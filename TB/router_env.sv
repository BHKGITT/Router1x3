///////////////////////////////////////////  ROUTER_ENV  ////////////////////////////////////////////

class router_env extends uvm_env;
	`uvm_component_utils(router_env)
//Declaring handle of env_config class
	router_env_config   env_cfg;

//Declaring handles of source_agent_top & destination_agent_top
	src_agent_top       src_agt_top;
	dest_agent_top	    dest_agt_top;
//Declaring handles of source_agent & destination_agent
	source_agent sagent[];
	dest_agent dagent[];
//Declaring handles of scoreboard & virtual_seqr
	router_scoreboard sb;
	router_virtual_sequencer  env_v_seqrh;

	extern function new(string name="router_env",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

///////////////////////////////////////////  NEW()  ////////////////////////////////////////////

function router_env::new(string name="router_env",uvm_component parent);
	super.new(name,parent);
endfunction

///////////////////////////////////////////  BUILD_PHASE()  ////////////////////////////////////////////

function void router_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
//Getting env_cfg
	if(!uvm_config_db#(router_env_config)::get(this,"","ENV_CFG",env_cfg))
		`uvm_fatal(get_type_name(),"env_cfg cant get Have U set it?")
//Creating object for virtual_seqr,src_agt_top,dest_agt_top
	env_v_seqrh=router_virtual_sequencer::type_id::create("env_v_seqrh",this);
	src_agt_top=src_agent_top::type_id::create("src_agt_top",this);
	dest_agt_top=dest_agent_top::type_id::create("dest_agt_top",this);

//Creating object for scoreboard
	if(env_cfg.has_scoreboard)
		begin
			sb=router_scoreboard::type_id::create("sb",this);
		end

endfunction

///////////////////////////////////////////  CONNECT_PHASE()  ////////////////////////////////////////////

function void router_env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(env_cfg.has_virtual_sequencer)
		begin
			if(env_cfg.has_sagent)	
				foreach(env_v_seqrh.src_seqrh[i])
				begin
					env_v_seqrh.src_seqrh[i]=src_agt_top.sagent[i].src_seqrh; // physical src_seqrh pointing	
				end
			if(env_cfg.has_dagent)
				foreach(env_v_seqrh.dst_seqrh[i])
				begin
					env_v_seqrh.dst_seqrh[i]=dest_agt_top.dagent[i].dst_seqrh; // physical dst_seqrh pointing 
				end
		end
		
	if(env_cfg.has_scoreboard)
		foreach(env_cfg.s_cfg[i])
//connecting src_monitor with scoreboard
			begin
				src_agt_top.sagent[i].src_monh.a_port.connect(sb.fifo_sdh.analysis_export);
			end
		foreach(env_cfg.d_cfg[i])
//connecting dst_monitor with scoreboard
			begin
				dest_agt_top.dagent[i].dst_monh.a_port.connect(sb.fifo_ddh[i].analysis_export);
			end		
endfunction 

