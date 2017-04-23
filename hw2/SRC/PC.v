// Program Counter

module PC ( clk, 
			rst,
			PCin, 
			PCout);
	
	parameter bit_size = 18;
	
	input  clk, rst;
	input  [bit_size-1:0] PCin;
	output [bit_size-1:0] PCout;
	
	// write your code in here
	reg [bit_size-1:0] tPCout;
	assign PCout = tPCout;
	reg [bit_size-1:0] tPCin;
	assign PCin = tPCin;
	
	always@(posedge clk, negedge rst)
	begin
		if(rst)
		begin
			tPCin <= 18'b0000_0000_0001_0000_00;
			tPCout <= 18'b0000_0000_0001_0000_00;
		end
		else
		begin
			tPCout <= PCin;
			//$display("%b qwer\n", PCout);
		end
	end
endmodule

