////////////////////////// ROUTER_FIFO ///////////////////////////////////
module router_fifo(clock,resetn,write_enb,read_enb,soft_reset,lfd_state,data_in,empty,data_out,full);

parameter depth=5'd16,width=5'd9,addr_size=4'd4;
input clock,resetn,write_enb,read_enb,lfd_state,soft_reset;
input [7:0] data_in;
output empty,full;
output reg [7:0]data_out;
reg lfd=0;
integer i;

reg [addr_size:0]wr_addr,rd_addr;
reg [5:0] count;
reg [width-1:0] fifo [depth-1:0];

always@(posedge clock)
begin
if(!resetn)
	lfd <= 0;
else
	lfd <= lfd_state;
end
 
always@(posedge clock)
begin:write_address
	if(!resetn)
		wr_addr<=0;
	else if (soft_reset)
		wr_addr<=0;
	else
	begin
		if(write_enb && !full)
			wr_addr<=wr_addr+1'b1;
		else
			wr_addr <= wr_addr;
	end
end
always@(posedge clock)
begin:read_address
	if(!resetn)
		rd_addr<=0;
	else if (soft_reset)
		rd_addr<=0;
	else
	begin
		if(read_enb && !empty)
			rd_addr<=rd_addr+1'b1;
		else
			rd_addr <= rd_addr;
	end
end
always@(posedge clock)
begin:Counter
	if(!resetn)
		count<=0;
	else if (soft_reset)
		count<=0;
	else if (fifo[rd_addr[3:0]][8])
		count<= fifo[rd_addr[3:0]][7:2]+1'b1;
	else if (read_enb && !empty)
		count<= count-1'b1;
	else count<=count;
end

always@(posedge clock)
begin:Write_Operation
	if(!resetn)
	begin 
		for(i=0;i<16;i=i+1)
			fifo[i]<=0;
	end	
	else if(soft_reset)	
		for(i=0;i<16;i=i+1)
			fifo[i]<=0;
	else
	begin
		if( write_enb && !full)
			fifo[wr_addr[3:0]]<={lfd,data_in};
       	end
end

always@(posedge clock)
begin:Read_operation
	if(!resetn)
		data_out<=0;
	else if(soft_reset)
		data_out<=8'bz;
	else 
		begin
		if(count > 0)
				if(read_enb && !empty)
					data_out<=fifo[rd_addr[3:0]];  
		else
			data_out <= 8'bz;
		end

end

assign full=((rd_addr==5'd0) && (wr_addr==5'd16));
assign empty = (rd_addr == wr_addr);
endmodule

