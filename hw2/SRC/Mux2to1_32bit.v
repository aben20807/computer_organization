// Mux2to1_32bit

module Mux2to1_32bit ( I0,
				       I1,
				       S,
				       out);

	parameter bit_size = 32;

	input [bit_size-1:0] I0;
	input [bit_size-1:0] I1;
	input S;

	output [bit_size-1:0] out;

	assign out = (S == 1)? I1: I0;

endmodule
