//////////////////////////// SOURCE_AGENT_CONFIG ////////////////////////////////////
class source_agent_config extends uvm_object;
	`uvm_object_utils(source_agent_config)
	virtual source_if vif;
	uvm_active_passive_enum is_active=UVM_ACTIVE;
	extern function new(string name="source_agent_config");
	static int no_of_txn_drive=0;
	static int no_of_txn_monitored=0;
endclass

function source_agent_config::new(string name="source_agent_config");
	super.new(name);
endfunction

