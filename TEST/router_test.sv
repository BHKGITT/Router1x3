//////////////////////////////////////  ROUTER_TEST  ////////////////////////////////////////

class my_test extends uvm_test;
	`uvm_component_utils(my_test)

	router_env envh;
	router_env_config 	env_cfg;
	source_agent_config 	s_cfg[];
	dest_agent_config       d_cfg[];
	
	int no_of_scoreboard=1;
	int no_of_sagent=1;
	int no_of_dagent=3;
	bit has_sagent=1;
	bit has_dagent=1;
	extern function new(string name="my_test",uvm_component parent);
	extern function void config_router();
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
endclass

function my_test::new(string name="my_test",uvm_component parent);
	super.new(name,parent);
endfunction


function void my_test::config_router();
if(has_sagent)
	begin	
		s_cfg=new[no_of_sagent];
		env_cfg.s_cfg=new[no_of_sagent];
		foreach(s_cfg[i])
			begin
				s_cfg[i]=source_agent_config::type_id::create($sformatf("s_cfg[%0d]",i));
	//Getting source_agent_config
				if(!uvm_config_db#(virtual source_if)::get(this,"","src",s_cfg[i].vif))
					`uvm_fatal(get_type_name(),"cant get ,Have U set?")
				s_cfg[i].is_active=UVM_ACTIVE;
				env_cfg.s_cfg[i]=s_cfg[i];
			end			
	end
if(has_dagent)
	begin
		d_cfg=new[no_of_dagent];
		env_cfg.d_cfg=new[no_of_dagent];
		foreach(d_cfg[i])
			begin
				d_cfg[i]=dest_agent_config::type_id::create($sformatf("d_cfg[%0d]",i));
	//Getting dest_agent_config
				if(!uvm_config_db#(virtual dest_if)::get(this,"",$sformatf("dest[%0d]",i),d_cfg[i].vif))
				`uvm_fatal(get_type_name(),"cant get config,Have U set it?")
				d_cfg[i].is_active=UVM_ACTIVE;
				env_cfg.d_cfg[i]=d_cfg[i];
			end
	end
	
	env_cfg.has_sagent=has_sagent;
	env_cfg.has_dagent=has_dagent;
	env_cfg.no_of_sagent=no_of_sagent;
	env_cfg.no_of_dagent=no_of_dagent;
	env_cfg.no_of_scoreboard=no_of_scoreboard;

//Setting ENV config 
	uvm_config_db#(router_env_config)::set(this,"*","ENV_CFG",env_cfg);
endfunction 

function void my_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	env_cfg=router_env_config::type_id::create("env_cfg");
	config_router();//calling method config_router()
	envh=router_env::type_id::create("envh",this);
endfunction

function void my_test::end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction

//////////////////////////////////////////   MY_TEST 1   ////////////////////////////////////

class my_test1 extends my_test;
	`uvm_component_utils(my_test1)
//Declaring router_virtual_sequence class handle
	router_virtual_sequence1  test_v_seqh;
	bit[1:0] addr;
	extern function new(string name="my_test1",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function my_test1::new(string name="my_test1",uvm_component parent);
	super.new(name,parent);
endfunction

function void my_test1::build_phase(uvm_phase phase);
	super.build_phase(phase);	
endfunction

task my_test1::run_phase(uvm_phase phase);
	super.run_phase(phase);
	repeat(3)
	begin
		addr={$random}%3;
		uvm_config_db #(bit[1:0])::set(this,"*","bit",addr);

		//test_v_seqh=router_virtual_sequence1::type_id::create("test_v_seqh");
		phase.raise_objection(this);
		test_v_seqh=router_virtual_sequence1::type_id::create("test_v_seqh");
		test_v_seqh.start(envh.env_v_seqrh); //starting virtual sequence on virtual sequencer
		phase.drop_objection(this);
	end
endtask

//////////////////////////////////////  MY_TEST 2  ////////////////////////////////////////

class my_test2 extends my_test;
	`uvm_component_utils(my_test2)
//Declare virtual_sequence handle
	router_virtual_sequence2 test_v_seqh;
//Declare addr of bit type
	bit[1:0] addr;
	
	extern function new(string name="my_test2",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass 

function my_test2::new(string name="my_test2",uvm_component parent);
	super.new(name,parent);
endfunction

function void my_test2::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task my_test2::run_phase(uvm_phase phase);
	super.run_phase(phase);
	repeat(3)
	begin
		addr={$random}%3;
		uvm_config_db #(bit[1:0])::set(this,"*","bit",addr);

		phase.raise_objection(this);
		test_v_seqh=router_virtual_sequence2::type_id::create("test_v_seqh");
		test_v_seqh.start(envh.env_v_seqrh);
		phase.drop_objection(this);		
	end
endtask

//////////////////////////////////////  MY_TEST 3  ////////////////////////////////////////

class my_test3 extends my_test;
	`uvm_component_utils(my_test3)
//Declare virtual sequence handle
	router_virtual_sequence3 test_v_seqh;
//Declare addr of bit type
	bit[1:0] addr;

	extern function new(string name="router_virtual_sequence3",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function my_test3::new(string name="router_virtual_sequence3",uvm_component parent);
	super.new(name,parent);
endfunction

function void my_test3::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task my_test3::run_phase(uvm_phase phase);
	super.run_phase(phase);
	repeat(3)
	begin
		addr={$random}%3;
		uvm_config_db #(bit[1:0])::set(this,"*","bit",addr);
	
		phase.raise_objection(this);
		test_v_seqh=router_virtual_sequence3::type_id::create("test_v_seqh");
		test_v_seqh.start(envh.env_v_seqrh);
		phase.drop_objection(this);
	end
endtask




