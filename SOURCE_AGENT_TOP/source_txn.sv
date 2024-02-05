///////////////////////////// SOURCE_TRANSACTION ////////////////////////////
class source_txn extends uvm_sequence_item;
	`uvm_object_utils(source_txn)
	rand bit[7:0]header;
	rand bit[7:0]payload[];
	     bit[7:0]parity;
	   //  bit[1:0]addr;
	
	constraint c1{header[1:0]!=2'b11;}
	constraint c2{payload.size==header[7:2];}
	constraint c3{header[7:2]!=0;}
//	constraint c4{header[1:0]==addr;}

	extern function new(string name="source_txn");
	extern function void do_print(uvm_printer printer);
	extern function void post_randomize();
	
endclass

function source_txn::new(string name="source_txn");
	super.new(name);
endfunction

function void source_txn::post_randomize();
	parity=0 ^ header;
	foreach(payload[i])
		parity=payload[i] ^ header;
endfunction

function void source_txn::do_print(uvm_printer printer);
	printer.print_field("header",this.header, 8 ,UVM_BIN);
	foreach(payload[i])
	printer.print_field($sformatf("payload[%0d]",i),this.payload[i], 8 ,UVM_DEC);
	printer.print_field("parity",this.parity,8,UVM_DEC);
endfunction


