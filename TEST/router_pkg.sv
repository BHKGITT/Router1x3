/////////////////////////// ROUTER_PACKAGE /////////////////////////////
package router_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "source_txn.sv"
	`include "source_agent_config.sv"
	`include "dest_agent_config.sv"
	`include "router_env_config.sv"
	`include "source_driver.sv"
	`include "source_monitor.sv"
	`include "source_sequencer.sv"
	`include "source_agent.sv"
	`include "src_agent_top.sv"
	`include "source_seqs.sv"


	`include "dest_txn.sv"
	`include "dest_driver.sv"
	`include "dest_sequencer.sv"
	`include "dest_monitor.sv"
	`include "dest_agent.sv"
	`include "dest_agent_top.sv"
  `include "dest_seqs.sv"

	`include "router_virtual_sequencer.sv"
	`include "router_virtual_sequence.sv"
	`include "router_scoreboard.sv"

	`include "virtual_sequence.sv"
	`include "virtual_sequencer.sv"
	`include "router_env.sv"

	`include "router_test.sv"
		
endpackage

