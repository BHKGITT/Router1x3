///////////////////////// SOURCE_SEQUENCER ///////////////////////////////
class source_sequencer extends uvm_sequencer #(source_txn);
	`uvm_component_utils(source_sequencer)
	
	extern function new(string name="source_sequencer",uvm_component parent);

endclass

function source_sequencer::new(string name="source_sequencer",uvm_component parent);
		super.new(name,parent);
endfunction

