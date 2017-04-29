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
	reg [bit_size-1:0] PCout = 18'b0000_0000_0000_0000_00;

	always@(posedge clk, posedge rst)
	begin
		if(rst)
		begin
			PCout <= 18'b0000_0000_0000_0000_00;
			//$display("rst %b", PCout);
		end
		else
		begin
			PCout <= PCin;
			//$display("call PC %b\n", PCout);
		end
	end
endmodule
