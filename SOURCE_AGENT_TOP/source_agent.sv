///////////////////////////////// SOURCE_AGENT ///////////////////////////////
class source_agent extends uvm_agent;
	`uvm_component_utils(source_agent)
	
	source_agent_config s_cfg;

	source_sequencer src_seqrh;
	source_driver	src_drvh;
	source_monitor	src_monh;
	
	extern function new(string name="source_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function source_agent::new(string name="source_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void source_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(source_agent_config)::get(this,"","src_cfg",s_cfg))
		`uvm_fatal(get_type_name(),"s_cfg cant get,Have U set it?")
		src_monh=source_monitor::type_id::create("src_monh",this);
        if(s_cfg.is_active==UVM_ACTIVE)
		begin
			src_seqrh=source_sequencer::type_id::create("src_seqrh",this);
			src_drvh=source_driver::type_id::create("src_drvh",this);
		end
endfunction

function void source_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
//	if(s_cfg.is_active==UVM_ACTIVE)
		src_drvh.seq_item_port.connect(src_seqrh.seq_item_export);
endfunction


