////////////////////////// ROUTER_TOP /////////////////////////////////
module top();
	import router_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
//     Generating clock
	bit clock;
	always #10 clock=~clock;

//     source_if & dest_if instantiation	
	source_if sin0(clock);
	dest_if	  dif0(clock);
	dest_if	  dif1(clock);
	dest_if	  dif2(clock);

//	router_top DUV  instantiation
	router_top DUV(.clock(clock),.resetn(sin0.resetn),.read_enb_0(dif0.read_enb),.read_enb_1(dif1.read_enb),.read_enb_2(dif2.read_enb),
			.data_in(sin0.data_in),.pkt_valid(sin0.pkt_vld),.data_out_0(dif0.data_out),.data_out_1(dif1.data_out),.data_out_2(dif2.data_out),
			.valid_out_0(dif0.vld_out),.valid_out_1(dif1.vld_out),.valid_out_2(dif2.vld_out),.error(sin0.error),.busy(sin0.busy));
initial
	begin
			
		`ifdef VCS
       		$fsdbDumpvars(0, top);
       		`endif

		uvm_config_db #(virtual source_if)::set(null,"*","src",sin0);
		uvm_config_db#(virtual dest_if)::set(null,"*","dest[0]",dif0);
		uvm_config_db#(virtual dest_if)::set(null,"*","dest[1]",dif1);
		uvm_config_db#(virtual dest_if)::set(null,"*","dest[2]",dif2);
		run_test();
	end
endmodule

