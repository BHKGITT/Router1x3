/////////////////////////// DESTINATION_INTERFACE //////////////////////////////
interface dest_if(input bit clock);
	logic [7:0] data_out;
	logic	    vld_out;
	logic	    read_enb;
clocking dst_drv_cb@(posedge clock);
	default input #1 output #1;
	output	read_enb;
	input	vld_out;
endclocking

clocking dst_mon_cb@(posedge clock);
	default input #1 output #1;
	input read_enb;
	input data_out;
endclocking

modport DDRV_MP	(clocking dst_drv_cb);
modport DMON_MP	(clocking dst_mon_cb);

endinterface:dest_if



