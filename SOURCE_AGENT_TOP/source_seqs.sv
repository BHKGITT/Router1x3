//////////////////////////////////////  BASE_SEQS  ////////////////////////////////////////

class base_seqs extends uvm_sequence #(source_txn);
	`uvm_object_utils(base_seqs)
	extern function new(string name="base_seqs");
endclass


function base_seqs::new(string name="base_seqs");
	super.new(name);
endfunction

//////////////////////////////////////  Small PKT  ////////////////////////////////////////
class small_pkt extends base_seqs;
	`uvm_object_utils(small_pkt)
//Declare addr of bit type
	bit[1:0] addr;
	extern function new(string name="small_pkt");
	extern task body();
endclass

function small_pkt::new(string name="small_pkt");
	super.new(name);
endfunction

task small_pkt::body();
//Getting addr
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit",addr))
		`uvm_fatal(get_type_name(),"addr cant get set it")

	req=source_txn::type_id::create("req");
	start_item(req);
//	assert(req.randomize() with {header[7:2] inside {[1:15]};}); 
	assert(req.randomize() with {header[7:2]==15 && header[1:0] == addr;});   //randomize payload & addr
//	assert(req.randomize() with {header[1:0]==addr;}); 
	`uvm_info(get_type_name(),$sformatf("addr=[%b]",addr),UVM_LOW)	
	`uvm_info(get_type_name(),$sformatf("Generated SMALL_PKT seqs at SOURCE \n %s",req.sprint()),UVM_LOW)
	finish_item(req);
endtask

////////////////////////////////////  Medium PKT  ////////////////////////////////////////////

class medium_pkt extends base_seqs;
	`uvm_object_utils(medium_pkt)
//Declare addr of bit type
	bit[1:0] addr;

	extern function new(string name="medium_pkt");
	extern task body();
endclass
//////////////////////////////////////  NEW()  ////////////////////////////////////////

function medium_pkt::new(string name="medium_pkt");
	super.new(name);
endfunction
//////////////////////////////////////  BODY()  ////////////////////////////////////////

task medium_pkt::body();
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit",addr))
		`uvm_fatal(get_type_name(),"addr cant get set it")

	req=source_txn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[7:2] == 30 && header[1:0] == addr;}); //randomize payload & addr	
	`uvm_info(get_type_name(),$sformatf("addr=[%b]",addr),UVM_LOW)	
	`uvm_info(get_type_name(),$sformatf("Generated MEDIUM_PKT seqs at SOURCE\n %s",req.sprint()),UVM_LOW)
	finish_item(req);
endtask  

////////////////////////////////////  Big PKT   ////////////////////////////////////////////

class big_pkt extends base_seqs;
	`uvm_object_utils(big_pkt)
//Declare addr of bit type
	bit[1:0] addr;

	extern function new(string name="big_pkt");
	extern task body();
endclass

function big_pkt::new(string name="big_pkt");
	super.new(name);
endfunction


task big_pkt::body();

	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit",addr))
		`uvm_fatal(get_type_name(),"addr cant get set it")

	req=source_txn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[7:2] ==63 && header[1:0] == addr;}); //randomize payload && addr
	`uvm_info(get_type_name(),$sformatf("addr=[%b]",addr),UVM_LOW)	
	`uvm_info(get_type_name(),$sformatf("Generated BIG_PKT seqs at SOURCE\n %s",req.sprint()),UVM_LOW)
	finish_item(req);
endtask
              
