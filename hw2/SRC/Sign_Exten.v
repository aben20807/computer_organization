// Sign_Extend

module Sign_Extend ( sign_in,
					 sign_out);

	input  [15:0] sign_in;
	output [31:0] sign_out;

	assign sign_out[15:0] = sign_in[15:0];
	assign sign_out[31:16] = (sign_in[15] == 1)? 16'b1111_1111_1111_1111: 16'b0000_0000_0000_0000;

endmodule
