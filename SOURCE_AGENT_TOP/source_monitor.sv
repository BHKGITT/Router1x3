///////////////////////////////////////////  SOURCE_MONITOR  ////////////////////////////////////////////

class source_monitor extends uvm_monitor;
	`uvm_component_utils(source_monitor)
//Declare Virtual interface handle
	virtual source_if.MMON_MP vif;
	source_agent_config s_cfg;
//Declaring handle for analysis port
	uvm_analysis_port#(source_txn) a_port;

	extern function new(string name="source_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass

///////////////////////////////////////////  NEW()  ////////////////////////////////////////////

function source_monitor::new(string name="source_monitor",uvm_component parent);
	super.new(name,parent);
//Creating object for analysis port
	a_port=new("a_port",this);
endfunction

///////////////////////////////////////////  BUILD_PHASE()  ////////////////////////////////////////////

function void source_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
//Getting s_cfg
	if(!uvm_config_db#(source_agent_config)::get(this,"","src_cfg",s_cfg))
		`uvm_fatal(get_type_name(),"s_cfg cant get Have U set it ? in TOP")
endfunction

///////////////////////////////////////////  CONNECT_PHASE()  ////////////////////////////////////////////

function void source_monitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
//Pointing virtual_interface
	vif=s_cfg.vif;
endfunction

///////////////////////////////////////////  RUN_PHASE()  ////////////////////////////////////////////

task source_monitor::run_phase(uvm_phase phase);
//	super.run_phase(phase);
	forever
		collect_data();
endtask

///////////////////////////////////////////  COLLECT_DATA()  ////////////////////////////////////////////

task source_monitor::collect_data();
  source_txn stxn;
	begin
		stxn=source_txn::type_id::create("stxn");
//		repeat(2)
		@(vif.source_monitor_cb);
		wait(vif.source_monitor_cb.pkt_vld && !vif.source_monitor_cb.busy)
//		@(vif.source_monitor_cb);		
		stxn.header  = vif.source_monitor_cb.data_in;
		stxn.payload = new[stxn.header[7:2]];	
		@(vif.source_monitor_cb);
		foreach(stxn.payload[i])
				begin
					wait(!vif.source_monitor_cb.busy)
//					@(vif.source_monitor_cb)
					stxn.payload[i] = vif.source_monitor_cb.data_in;
					@(vif.source_monitor_cb);
				end
		wait(!vif.source_monitor_cb.busy && !vif.source_monitor_cb.pkt_vld ) //When busy==0 & pkt_vld==0
		stxn.parity = vif.source_monitor_cb.data_in;
		@(vif.source_monitor_cb);
		@(vif.source_monitor_cb);
		
		`uvm_info(get_type_name(),$sformatf("Collected  SMALL_PKT seqs at SOURCE MON \n %s",stxn.sprint()),UVM_LOW)
		a_port.write(stxn); 
	end
endtask
