//////////////////////////////////////  ROTER_VIRTUAL_SEQUENCE  ////////////////////////////////////////

class router_virtual_sequence extends uvm_sequence#(uvm_sequence_item);
	`uvm_object_utils(router_virtual_sequence)
//Declaring virtual_seqr handle
	router_virtual_sequencer v_seqrh;

	source_sequencer   src_seqrh[]; //local src_seqr handle
	dest_sequencer     dst_seqrh[]; //local dst_seqr handle
	router_env_config  env_cfg;

	extern function new(string name="router_virtual_sequence");
	extern task body();
endclass

function router_virtual_sequence::new(string name="router_virtual_sequence");
	super.new(name);
endfunction

task router_virtual_sequence::body();
//Getting env_cfg	
	if(!uvm_config_db#(router_env_config)::get(null,get_full_name(),"ENV_CFG",env_cfg))
		`uvm_fatal(get_type_name(),"env_cfg cant get Have U set it?")

//Checking compatibility  ( P=C or not )
	if($cast(v_seqrh,m_sequencer))
	src_seqrh=new[env_cfg.no_of_sagent]; //Declaring size to src_seqrh
	dst_seqrh=new[env_cfg.no_of_dagent]; //Declaring size to src_seqrh
	
	foreach(src_seqrh[i])
		src_seqrh[i]=v_seqrh.src_seqrh[i];  //Pointing physical seqr via v_seqr
	foreach(dst_seqrh[i])
		dst_seqrh[i]=v_seqrh.dst_seqrh[i];  //Pointing physical seqr via v_seqr
endtask

/*function void router_virtual_sequence::build_phase(uvm_phase phase);
	super.build_phase(phase);
		if(!uvm_config_db#(bit[1:0])::get(null,"","bit",addr))
		`uvm_fatal(get_type_name(),"addr cant get Have U set it in Test")
endfunction*/

//////////////////////////// ROUTER_VIRTUAL_SEQUENCE1  //////////////////////////////

class router_virtual_sequence1 extends router_virtual_sequence;
	`uvm_object_utils(router_virtual_sequence1)
//Declare addr of bit type
	bit[1:0] addr;
	small_pkt s_small_pkt;  //source seqs handle
	small_pktt d_small_pkt; //dest seqs handle
	extern function new(string name="router_virtual_sequence1");
	extern task body();
endclass

function router_virtual_sequence1::new(string name="router_virtual_sequence1");
	super.new(name);
endfunction		

task router_virtual_sequence1::body();
	super.body();
//Getting addr
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit",addr))
		`uvm_fatal(get_type_name(),"addr cant get Have U set it in Test")

//object create for seqs which is going to start on virtual seqr
	s_small_pkt=small_pkt::type_id::create("s_small_pkt");
	//Dest side small pkt seqs handle
//	d_small_pkt=new[env_cfg.no_of_dagent];
	d_small_pkt=small_pktt::type_id::create("d_small_pkt");

//	foreach(d_small_pkt[i])
        //creating dst side seqs for each dest Agent
//	d_small_pkt[i]=small_pktt::type_id::create($sformatf("d_small_pkt[%0d]",i));
	fork
		begin
			foreach(src_seqrh[i])
			s_small_pkt.start(src_seqrh[i]);  //Staring SRC seqs on seqrh
		end
		begin
		//	foreach(dst_seqrh[i])
			if(addr==2'b00)
			d_small_pkt.start(dst_seqrh[0]);
			if(addr==2'b01)
			d_small_pkt.start(dst_seqrh[1]);
			if(addr==2'b10)
			d_small_pkt.start(dst_seqrh[2]);
		//	foreach(dst_seqrh[i])
		//	d_small_pkt[i].start(dst_seqrh[i]); //Staring SRC seqs on seqrh
		end
	join
endtask

//////////////////////////// ROUTER_VIRTUAL_SEQUENCE2  //////////////////////////////

class router_virtual_sequence2 extends router_virtual_sequence;
	`uvm_object_utils(router_virtual_sequence2)
//Declare addr of bit type
	bit[1:0] addr;
	
//Declare handle for seqs 
	medium_pkt    s_medium_pkt;
	medium_pktt   d_medium_pkt;
 	
	extern function new(string name="router_virtual_sequence2");
	extern task body();
endclass

function router_virtual_sequence2::new(string name="router_virtual_sequence2");
	super.new(name);
endfunction

task router_virtual_sequence2::body();
	super.body();
//Getting addr
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit",addr))
		`uvm_fatal(get_type_name(),"addr cant get Have U set in Test")

//Creating instances for seqs handles
	s_medium_pkt=medium_pkt::type_id::create("s_medium_pkt");
	d_medium_pkt=medium_pktt::type_id::create("d_medium_pkt");

	fork
		begin
			foreach(src_seqrh[i])
			s_medium_pkt.start(src_seqrh[i]); //starting s_medium_pkt seq
		end

		begin
			if(addr == 2'b00)	
			d_medium_pkt.start(dst_seqrh[0]);

			if(addr == 2'b01)
			d_medium_pkt.start(dst_seqrh[1]);

			if(addr == 2'b10)
			d_medium_pkt.start(dst_seqrh[2]);
		end
		
	join
endtask

//////////////////////////// ROUTER_VIRTUAL_SEQUENCE3  //////////////////////////////

class router_virtual_sequence3 extends router_virtual_sequence;
	`uvm_object_utils(router_virtual_sequence3)
//Declare addr of bit type
	bit[1:0] addr;
//Declare handles for seqs
	big_pkt   s_big_pkt;
	big_pktt  d_big_pkt;

	extern function new(string name="router_virtual_sequence3");
	extern task body();
endclass

function router_virtual_sequence3::new(string name="router_virtual_sequence3");
	super.new(name);
endfunction

task router_virtual_sequence3::body();
	super.body();
//Getting addr
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit",addr))
		`uvm_fatal(get_type_name(),"addr cant get Have U set it in Test")

//Creating instances for seqs handles
	s_big_pkt=big_pkt::type_id::create("s_big_pkt");
	d_big_pkt=big_pktt::type_id::create("d_big_pkt");
	
	fork
		begin
			foreach(src_seqrh[i])
			s_big_pkt.start(src_seqrh[i]); //starting s_big_pkt seq
		end

		begin
			if(addr == 2'b00)
			d_big_pkt.start(dst_seqrh[0]);
	
			if(addr == 2'b01)
			d_big_pkt.start(dst_seqrh[1]);

			if(addr == 2'b10)
			d_big_pkt.start(dst_seqrh[2]);
		end
	join
endtask
