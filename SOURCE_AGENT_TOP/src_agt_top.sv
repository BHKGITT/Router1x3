////////////////////////// SOURCE_AGENT_TOP /////////////////////////////
class src_agent_top extends uvm_agent;
	`uvm_component_utils(src_agent_top)

	router_env_config   env_cfg;
	source_agent_config s_cfg[];
	source_agent sagent[];

	extern function new(string name="src_agent_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
//	extern function run_phase(uvm_phase phase);
endclass

function src_agent_top::new(string name="src_agent_top",uvm_component parent);
	super.new(name,parent);
endfunction

function void src_agent_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
//Getting ENV config
	if(!uvm_config_db#(router_env_config)::get(this,"","ENV_CFG",env_cfg))
		`uvm_fatal(get_type_name(),"env_cfg cant get Have U set it?")
//	sagent=source_agent::type_id::create("sagent",this);
	sagent=new[env_cfg.no_of_sagent];
	foreach(sagent[i])
		begin
		sagent[i]=source_agent::type_id::create($sformatf("sagent[%0d]",i),this); 
//Setting source agent config
		uvm_config_db#(source_agent_config)::set(this,$sformatf("sagent[%0d]*",i),"src_cfg",env_cfg.s_cfg[i]);
		end
endfunction
