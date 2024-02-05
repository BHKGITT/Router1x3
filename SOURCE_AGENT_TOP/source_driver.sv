///////////////////////// OURCE_DRIVER //////////////////////////////////
class source_driver extends uvm_driver #(source_txn);
	`uvm_component_utils(source_driver)
	//Virtual interface
	virtual source_if.SDRV_MP vif;
	source_agent_config s_cfg;
	extern function new(string name="source_driver",uvm_component parent);		
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task src_to_dut(source_txn stxn);	
	extern task run_phase(uvm_phase phase);
		
endclass

function source_driver::new(string name="source_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void source_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(source_agent_config)::get(this,"","src_cfg",s_cfg))
		`uvm_fatal(get_type_name(),"s_cfg cant get,Have U set it? in TOP ")
endfunction

function void source_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=s_cfg.vif; 
endfunction

task source_driver::run_phase(uvm_phase phase);
	@(vif.source_driver_cb);
	vif.source_driver_cb.resetn <= 0;
	@(vif.source_driver_cb);
	vif.source_driver_cb.resetn <= 1;
	forever
		begin
			seq_item_port.get_next_item(req);
			src_to_dut(req);
			seq_item_port.item_done();
		end
endtask

task source_driver::src_to_dut(source_txn stxn);
	@(vif.source_driver_cb);
	wait(!vif.source_driver_cb.busy) //When busy==0
	vif.source_driver_cb.pkt_vld <=1;
	vif.source_driver_cb.data_in <= stxn.header;
	@(vif.source_driver_cb);
	foreach(stxn.payload[i])
		begin
			wait(!vif.source_driver_cb.busy) //when busy==0
			vif.source_driver_cb.data_in <= stxn.payload[i];
			@(vif.source_driver_cb);
		end
	wait(!vif.source_driver_cb.busy ) //when busy==0
	vif.source_driver_cb.pkt_vld <=0;
	vif.source_driver_cb.data_in <= stxn.parity;
	@(vif.source_driver_cb);
	@(vif.source_driver_cb);
	`uvm_info(get_type_name(),$sformatf("Getting SMALL_PKT seqs at DRIVER \n %s",stxn.sprint()),UVM_LOW)
endtask
