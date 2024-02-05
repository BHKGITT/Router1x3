///////////////////////////////////////////  DEST_MONITOR()  ////////////////////////////////////////////

class dest_monitor extends uvm_monitor;
	`uvm_component_utils(dest_monitor)
//Declare handle for dest_if
	virtual dest_if.DMON_MP vif;
//Declare handle for dest_config
	dest_agent_config d_cfg;
//Declaring handle analysis port
	uvm_analysis_port#(dest_txn) a_port;

	extern function new(string name="dest_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass

///////////////////////////////////////////  NEW()  ////////////////////////////////////////////

function dest_monitor::new(string name="dest_monitor",uvm_component parent);
	super.new(name,parent);
//Creating object for analysis port
	a_port=new("a_port",this);
endfunction

///////////////////////////////////////////  BUILD_PHASE()  ////////////////////////////////////////////

function void dest_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
//Getting d_cfg
	if(!uvm_config_db#(dest_agent_config)::get(this,"","dst_cfg",d_cfg))
		`uvm_fatal(get_type_name(),"d_cfg cant get,Have U set it")
endfunction

///////////////////////////////////////////  CONNECT_PHASE()  ////////////////////////////////////////////

function void dest_monitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
//Pointing virtual_interface
	vif=d_cfg.vif;
endfunction

///////////////////////////////////////////  RUN_PHASE()  ////////////////////////////////////////////

task dest_monitor::run_phase(uvm_phase phase);
//	super.run_phase(phase);
	forever
		collect_data();
endtask

///////////////////////////////////////////  COLLECT_DATA()  ////////////////////////////////////////////

task dest_monitor::collect_data();
	begin
		dest_txn dtxn;
		dtxn=dest_txn::type_id::create("dtxn");
		@(vif.dst_mon_cb);
		wait(vif.dst_mon_cb.read_enb) //whenever read_enb==1		
		@(vif.dst_mon_cb);
	//Monitoring Header
		dtxn.header = vif.dst_mon_cb.data_out;
	//Monitoring payload
		dtxn.payload=new[dtxn.header[7:2]];
		@(vif.dst_mon_cb)	
		foreach(dtxn.payload[i])
			begin
				dtxn.payload[i] = vif.dst_mon_cb.data_out;
				@(vif.dst_mon_cb);
			end
		//Monitoring parity
		dtxn.parity = vif.dst_mon_cb.data_out;
		@(vif.dst_mon_cb);
  		a_port.write(dtxn);
		`uvm_info(get_type_name(),$sformatf("Collecting PKT at DESTINATION MON \n %s",dtxn.sprint()),UVM_LOW)

	end
endtask

