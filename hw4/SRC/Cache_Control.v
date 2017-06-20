// Cache Control

module Cache_Control ( 
					   clk,
					   rst,
					   // input
					   en_R,
					   en_W,
					   hit,
					   // output
					   Read_mem,
					   Write_mem,
					   Valid_enable,
					   Tag_enable,
					   Data_enable,
					   sel_mem_core,
					   stall
					   );
	
	input clk, rst;
	input en_R;
	input en_W;
    input hit;
	
	output Read_mem;
	output Write_mem;
	output Valid_enable;
	output Tag_enable;
	output Data_enable;
	output sel_mem_core;		// 0 data from mem, 1 data from core
	output stall;
	
	// write your code here
	
endmodule



















