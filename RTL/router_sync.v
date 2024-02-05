////////////////////////// ROUTER_SYNCHRONIZER ////////////////////////////////
module router_sync(detect_add,data_in,write_enb_reg,clock,resetn,vld_out_0,vld_out_1,vld_out_2,read_enb_0,read_enb_1,read_enb_2,write_enb,fifo_full,empty_0,empty_1,empty_2,soft_reset_0,soft_reset_1,soft_reset_2,full_0,full_1,full_2);
input detect_add,write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
input [1:0]data_in;
output vld_out_0,vld_out_1,vld_out_2;
output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2;
output reg [2:0]write_enb;

parameter R0=2'b00,R1=2'b01,R2=2'b10;

reg c0;
reg [1:0]addr;
reg [4:0] count_0,count_1,count_2;

//Address Logic
always@(posedge clock)
begin
if(!resetn)
addr<=0;
else
	if(detect_add)
		addr <= data_in;
	else
		addr <= addr;
end

//Write enble logic
always@(*)
begin
if(!resetn)
	write_enb <= 3'b0;
else
	if(write_enb_reg) 
		case(addr)
			R0: write_enb <= 3'b001;
			R1: write_enb <= 3'b010;
			R2: write_enb <= 3'b100;
			default: write_enb <= 3'b000;
		endcase
	else
		write_enb <= 3'b0;
end

//Fifo full Logic
always@(*)
begin
if(!resetn)
	fifo_full <= 1'b0;
else
	case(addr)
		R0: fifo_full <= full_0;
		R1: fifo_full <= full_1;
		R2: fifo_full <= full_2;
		default: fifo_full <= 1'b0;
	endcase
end


//Counter 0
always@(posedge clock)
begin
if(!resetn)
	count_0 <= 5'b0;
else 
	if(vld_out_0) begin
		if(read_enb_0)
			count_0 <= 5'b0;
		else if (count_0 > 5'd28)
			count_0 <= 5'b0;
		else
			count_0 <= count_0 + 1'b1;
		end
	else
		count_0 <= 5'b0;
end

//Soft reset 0 logic
always@(posedge clock)
begin
if(!resetn)
	soft_reset_0 <= 1'b0;
else	begin
	if(count_0 > 5'd28)
		soft_reset_0 <= 1'b1;
	else 
		soft_reset_0 <= 1'b0;
	end
end

//Counter 1
always@(posedge clock)
begin
if(!resetn)
count_1 <= 1'b0;
else 
	if(vld_out_1) begin
		if(read_enb_1)
			count_1 <= 5'b0;
		else if (count_1 > 5'd28)
			count_1 <= 5'b0;
		else
			count_1 <= count_1 + 1'b1;
		end
	else
		count_1 <= 5'b0;
end

//Soft reset 1 logic
always@(posedge clock)
begin
if(!resetn)
	soft_reset_1 <= 1'b0;
else	begin
	if(count_1 > 5'd28)
		soft_reset_1 <= 1'b1;
	else 
		soft_reset_1 <= 1'b0;
	end
end

//Counter 2
always@(posedge clock)
begin
if(!resetn)
count_2 <= 1'b0;
else 
	if(vld_out_2) begin
		if(read_enb_2)
			count_2 <= 5'b0;
		else if (count_2 > 5'd28)
			count_2 <= 5'b0;
		else
			count_2 <= count_2 + 1'b1;
		end
	else
		count_2 <= 5'b0;
end

//Soft reset 2 logic
always@(posedge clock)
begin
if(!resetn)
	soft_reset_2 <= 1'b0;
else	begin
	if(count_2 > 5'd28)
		soft_reset_2 <= 1'b1;
	else 
		soft_reset_2 <= 1'b0;
	end
end
 
assign vld_out_0 = !empty_0;
assign vld_out_1 = !empty_1;
assign vld_out_2 = !empty_2;
endmodule

