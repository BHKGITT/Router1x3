/////////////////////////// DESTINATION_SEQUENCER //////////////////////////////////
class dest_sequencer extends uvm_sequencer#(dest_txn);
	`uvm_component_utils(dest_sequencer)
//	virtual dest_if vif;
	extern function new(string name="dest_sequencer",uvm_component parent);
endclass

function dest_sequencer::new(string name="dest_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction
