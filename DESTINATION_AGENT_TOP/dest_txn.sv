////////////////////////////// DESTINATION_TRANSACTION /////////////////////////////////////
class dest_txn extends uvm_sequence_item;
	`uvm_object_utils(dest_txn)
	bit [7:0]header;
	bit [7:0]payload[];
	bit [7:0]parity;
	rand bit[5:0] no_of_cycles;
	extern function new(string name="dest_txn");
	extern function void do_print(uvm_printer printer);
endclass

function dest_txn::new(string name="dest_txn");
	super.new(name);
endfunction

function void dest_txn::do_print(uvm_printer printer);
	printer.print_field("header",this.header,8,UVM_BIN);
	foreach(payload[i])
	printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);
	printer.print_field("parity",this.parity,8,UVM_DEC);
	printer.print_field("no_of_cycles", this.no_of_cycles,8,UVM_DEC);
endfunction
