class dest_agent extends uvm_agent;
	`uvm_component_utils(dest_agent)
//dest agent Config class handle
	dest_agent_config d_cfg;
//Instantiating DRV,MON,SEQR
	dest_driver   dst_drvh;
	dest_monitor  dst_monh;
	dest_sequencer dst_seqrh;

	extern function new(string name="dest_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

////////////////////// new() ///////////////////////////////////
function dest_agent::new(string name="dest_agent",uvm_component parent);
	super.new(name,parent);
endfunction

/////////////////////  build_phase  //////////////////////////////
function void dest_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(dest_agent_config)::get(this,"","dst_cfg",d_cfg))
		`uvm_fatal(get_type_name(),"d_cfg cant get,Have U set it?")

	dst_drvh=dest_driver::type_id::create("dst_drvh",this);
	dst_monh=dest_monitor::type_id::create("dst_monh",this);
	dst_seqrh=dest_sequencer::type_id::create("dst_seqrh",this);
endfunction

////////////////////  connect_phase  //////////////////////////////
function void dest_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
//	if(d_cfg.is_active==UVM_ACTIVE)
		dst_drvh.seq_item_port.connect(dst_seqrh.seq_item_export);
endfunction
