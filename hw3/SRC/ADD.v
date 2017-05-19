// ADD

module ADD ( src1,
			 src2,
			 out);

	parameter n = 18;

	input  [n-1:0] src1;
	input  [n-1:0] src2;

	output [n-1:0] out;

	assign out = src1 + src2;

endmodule
