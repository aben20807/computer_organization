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
		   
endmodule

