/////////////////////////////// ROUTER_REGISTER ///////////////////////////
module router_reg(clock,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,err,dout);

input clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
input [7:0] data_in;
output reg parity_done,low_pkt_valid,err;
output reg [7:0]dout;
reg [7:0] header,fifo_full_state,int_parity,pkt_parity;

always@(posedge clock)   //Header reg logic
begin
if(!resetn)
	header <= 0;
else
	if(pkt_valid && detect_add && data_in[1:0] != 2'd3)
		header <= data_in;
end

always@(posedge clock)   //Data out logic & Fifo_full_state reg
begin
if(!resetn)
	begin dout <= 0; fifo_full_state <= 0; end
else if(lfd_state)
	dout <= header;
else if(ld_state && !fifo_full)
	dout <= data_in;
else if( ld_state && fifo_full)
	fifo_full_state <= data_in;
else if(laf_state)
	dout <= fifo_full_state;
end

always@(posedge clock)     //External Parity
begin 
if(!resetn)
	pkt_parity <= 0;
else if(detect_add)
	pkt_parity <= 0;
else if( !pkt_valid && ld_state)
	pkt_parity <= data_in;
end

always@(posedge clock)     //Internal Parity logic
begin
if(!resetn)
	int_parity <= 0;
else if(detect_add)
	int_parity <= 0;
else if (lfd_state)
	int_parity <= header ^ int_parity;
else if (ld_state && pkt_valid && !full_state)
	int_parity <= int_parity ^ data_in;
end

always@(posedge clock)     //Parity_done Output logic
begin
if(!resetn)
	parity_done <= 0;
else if( (ld_state && !fifo_full && !pkt_valid) | (laf_state && low_pkt_valid && !parity_done) )
	parity_done <= 1'b1;
else if(pkt_valid && detect_add && data_in[1:0] != 2'd3)
	parity_done <= 0;
end

always@(posedge clock)    //Error Output logic
begin
if(!resetn)
	err <= 0;
else if(parity_done)
	if( int_parity == pkt_parity)
		err <= 0;
	else
		err <= 1;
else
 err <= 0;
end

always@(posedge clock)    //Low_pkt_valid Output logic
begin
if(!resetn)
	low_pkt_valid <= 0;
else if(rst_int_reg)
	low_pkt_valid <= 0;
else if (ld_state && !pkt_valid)
	low_pkt_valid <= 1;
end
endmodule


