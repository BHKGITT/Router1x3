///////////////// SOURCE_INTERFACE /////////////////////
interface source_if(input bit clock);
	logic       resetn;
	logic [7:0] data_in;
	logic	    pkt_vld;
	logic 	    error;
	logic	    busy;

clocking source_driver_cb@(posedge clock);
	default input #1 output #1;
	output data_in;
	output pkt_vld;
	output resetn;
	input  error;
	input  busy;
endclocking

clocking source_monitor_cb@(posedge clock);
	default input #1 output #1;
	input data_in;
	input pkt_vld;
	input resetn;
	input error;
	input busy;
endclocking

modport SDRV_MP (clocking source_driver_cb);
modport SMON_MP	(clocking source_monitor_cb);

endinterface:source_if




