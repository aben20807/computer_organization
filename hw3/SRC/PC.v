// Program Counter

module PC ( clk,
			rst,
			PCWrite,
			PCin,
			PCout);

	parameter pc_size = 18;

	input  clk, rst;
	input  PCWrite;
	input  [pc_size-1:0] PCin;
	output [pc_size-1:0] PCout;

	// write your code in here
	reg [pc_size-1:0] PCout;

	always@(negedge clk, posedge rst)
	begin
		if(rst)
		begin
			PCout <= 18'b0;
			//$display("rst %b", PCout);
		end
		else
		begin
			if(PCWrite)
			begin
				PCout <= PCin;
			end
			else
			begin
				PCout <= PCout;
			end
			//$display("call PC %b\n", PCout);
		end
	end
endmodule
