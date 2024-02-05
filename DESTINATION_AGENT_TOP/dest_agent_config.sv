class dest_agent_config extends uvm_object;
	`uvm_object_utils(dest_agent_config)
	virtual dest_if vif;
	uvm_active_passive_enum is_active=UVM_ACTIVE;
	extern function new(string name="dest_agent_config");
	static int no_of_txn_drive=0;
	static int no_of_txn_monitored=0;
endclass

function dest_agent_config::new(string name="dest_agent_config");
	super.new(name);
endfunction

