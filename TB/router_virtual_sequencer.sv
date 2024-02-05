///////////////////////// ROUTER_VIRTUAL_SEQUENCER ///////////////////////////////
class router_virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
	`uvm_component_utils(router_virtual_sequencer)
	source_sequencer  src_seqrh[]; //physical source_sequencer handles
	dest_sequencer    dst_seqrh[]; //physical dest_sequencer handles
	router_env_config env_cfg;
	extern function new(string name="router_virtual_sequencer",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass

function router_virtual_sequencer::new(string name="router_virtual_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_virtual_sequencer::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(router_env_config)::get(this,"","ENV_CFG",env_cfg))
		`uvm_fatal(get_type_name(),"env_cfg cant get Have U set it?")
	src_seqrh=new[env_cfg.no_of_sagent];
	dst_seqrh=new[env_cfg.no_of_dagent];
endfunction

