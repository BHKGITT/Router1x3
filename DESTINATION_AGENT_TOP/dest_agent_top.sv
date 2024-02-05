class dest_agent_top extends uvm_agent;
	`uvm_component_utils(dest_agent_top)
	
	router_env_config env_cfg;
	dest_agent_config d_cfg[];
	dest_agent dagent[];
	
	extern function new(string name="dest_agent_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass

function dest_agent_top::new(string name="dest_agent_top",uvm_component parent);
	super.new(name,parent);
endfunction

function void dest_agent_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
//Getting ENV config
	if(!uvm_config_db#(router_env_config)::get(this,"","ENV_CFG",env_cfg))
		`uvm_fatal(get_type_name()," env_cfg can't get,Have U set it? ")
	
	dagent=new[env_cfg.no_of_dagent];
	foreach(dagent[i])
		begin
			dagent[i]=dest_agent::type_id::create($sformatf("dagent[%0d]",i),this);
//Setting dest agent config
			uvm_config_db#(dest_agent_config)::set(this,$sformatf("dagent[%0d]*",i),"dst_cfg",env_cfg.d_cfg[i]);
		end
endfunction
