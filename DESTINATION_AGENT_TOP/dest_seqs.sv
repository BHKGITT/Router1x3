
////////////////////////////   BASE SEQS   ///////////////////////////////////
class dest_seqs extends uvm_sequence #(dest_txn);
	`uvm_object_utils(dest_seqs)
	extern function new(string name="dest_seqs");
endclass

function dest_seqs::new(string name="dest_seqs");
	super.new(name);
endfunction

///////////////////////////    SMALL PKT  ///////////////////////////////////
class small_pktt extends dest_seqs;
	`uvm_object_utils(small_pktt)

	extern function new(string name="small_pktt");
	extern task body();
endclass

function small_pktt::new(string name="small_pktt");
	super.new(name);
endfunction

task small_pktt::body();
	req=dest_txn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {no_of_cycles inside {[1:28]};});
	`uvm_info(get_type_name(),$sformatf("Generated Small_PKT at Destination \n %s",req.sprint()),UVM_LOW)
	finish_item(req);
endtask

//////////////////////////////  MEDIUM PKT   /////////////////////////////////
class medium_pktt extends dest_seqs;
	`uvm_object_utils(medium_pktt)

	extern function new(string name="medium_pktt");
	extern task body();
endclass

function medium_pktt::new(string name="medium_pktt");
	super.new(name);
endfunction

task medium_pktt::body();
	req=dest_txn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {no_of_cycles inside {[1:28]};});
	`uvm_info(get_type_name(),$sformatf("Generated Medium_PKT\n %s",req.sprint()),UVM_LOW)
	finish_item(req);
endtask

////////////////////////////    BIG PKT     ////////////////////////////////////
class big_pktt extends dest_seqs;
	`uvm_object_utils(big_pktt)

	extern function new(string name="big_pktt");
	extern task body(); 
endclass

function big_pktt::new(string name="big_pktt");
	super.new(name);
endfunction

task big_pktt::body();
	req=dest_txn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {no_of_cycles inside {[1:28]};});
	`uvm_info(get_type_name(),$sformatf("Generated BIG_PKT\n %s",req.sprint()),UVM_LOW)
	finish_item(req);
endtask




