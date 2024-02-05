//////////////////////////////ROUTER_FSM ///////////////////////////////////
module router_fsm(clock,resetn,pkt_valid,busy,parity_done,data_in,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);
input clock,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2;
output busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state;
input [1:0]data_in;

parameter DECODE_ADDRESS = 8'b0000_0001,
	  LOAD_FIRST_DATA = 8'b0000_0010,
	  WAIT_TILL_EMPTY = 8'b0000_0100,
	  LOAD_DATA = 8'b0000_1000,
     	  FIFO_FULL_STATE = 8'b0001_0000,
	  LOAD_AFTER_FULL = 8'b0010_0000,
	  LOAD_PARITY = 8'b0100_0000,
	  CHECK_PARITY_ERROR = 8'b1000_0000;

reg [7:0]state,next_state;
reg [1:0]addr;

always@(posedge clock)
begin
if(!resetn)
	addr <= 0;
else if(detect_add && pkt_valid && data_in[1:0] != 2'd3)
	addr <= data_in[1:0];
else
	addr <= addr;
end

always@(posedge clock)
begin
	if(~resetn)
		state <= DECODE_ADDRESS;
	else if((soft_reset_0 & addr) | (soft_reset_1 & addr) | (soft_reset_2 & addr))
		state <= DECODE_ADDRESS;
	else
		state <= next_state;
end

always@(*)
begin
next_state = state;
case(state)
DECODE_ADDRESS:begin  if( (pkt_valid & (data_in[1:0] == 0) & fifo_empty_0) |  (pkt_valid & (data_in[1:0] == 1) & fifo_empty_1) | (pkt_valid & (data_in[1:0] == 2) & fifo_empty_2) )
			next_state = LOAD_FIRST_DATA;
		else if ( (pkt_valid & (data_in[1:0] == 0) & !fifo_empty_0) |  (pkt_valid & (data_in[1:0] == 1) & !fifo_empty_1) | (pkt_valid & (data_in[1:0] == 2) & !fifo_empty_2) )
			next_state = WAIT_TILL_EMPTY; end
LOAD_FIRST_DATA: next_state = LOAD_DATA;
WAIT_TILL_EMPTY: if( (fifo_empty_0 && (addr == 0)) || (fifo_empty_1 && (addr == 1)) || (fifo_empty_2 && (addr == 2)) )
			next_state = LOAD_FIRST_DATA;
LOAD_DATA: if(fifo_full)
		next_state = FIFO_FULL_STATE;
	   else if (!fifo_full && !pkt_valid)
		next_state = LOAD_PARITY;
FIFO_FULL_STATE: if(!fifo_full)
			next_state = LOAD_AFTER_FULL;
LOAD_AFTER_FULL: if(parity_done)
			next_state = DECODE_ADDRESS;
		 else if (!parity_done && !low_pkt_valid)
			next_state = LOAD_DATA;
		 else if (!parity_done && low_pkt_valid)
			next_state = LOAD_PARITY;
LOAD_PARITY: next_state = CHECK_PARITY_ERROR;
CHECK_PARITY_ERROR: if(!fifo_full) 
			next_state = DECODE_ADDRESS;
		    else if(fifo_full)
			    next_state = FIFO_FULL_STATE;
endcase
end

assign detect_add = (state == DECODE_ADDRESS);
assign lfd_state = (state == LOAD_FIRST_DATA);
assign busy = (state == LOAD_FIRST_DATA) || (state == LOAD_PARITY) || (state == FIFO_FULL_STATE) || (state == LOAD_AFTER_FULL) || (state == WAIT_TILL_EMPTY) || (state == CHECK_PARITY_ERROR);
assign ld_state = (state == LOAD_DATA);
assign write_enb_reg =(state == LOAD_DATA) || (state == LOAD_PARITY) ||  (state == LOAD_AFTER_FULL) ;
assign full_state = (state == FIFO_FULL_STATE);
assign laf_state = (state == LOAD_AFTER_FULL);
assign rst_int_reg = (state == CHECK_PARITY_ERROR);

endmodule


