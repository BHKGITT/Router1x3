////////////////////////// ROUTER_ENV_CONFIG //////////////////////////////////
class router_env_config extends uvm_object;
	`uvm_object_utils(router_env_config)
	
	source_agent_config  s_cfg[];
	dest_agent_config   d_cfg[];

	bit has_sagent=1;
	bit has_dagent=1;
	bit has_scoreboard=1;
	bit has_virtual_sequencer=1;
	int no_of_sagent=1;
	int no_of_dagent=3;
	int no_of_scoreboard=1;
	

function new(string name="router_env_config");
	super.new(name);
endfunction
endclass
