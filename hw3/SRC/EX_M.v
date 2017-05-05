// EX_M

module EX_M ( clk,
			  rst,
			  // input 
			  // WB
			  EX_MemtoReg,
			  EX_RegWrite,
			  // M
			  EX_MemWrite,
			  // write your code in here
			  // pipe
			  EX_ALU_result,
			  EX_Rt_data,
			  EX_PCplus8,
			  EX_WR_out,
			  // output
			  // WB
			  M_MemtoReg,
			  M_RegWrite,
			  // M
			  M_MemWrite,
			  // write your code in here
			  // pipe
			  M_ALU_result,
			  M_Rt_data,
			  M_PCplus8,
			  M_WR_out			  		  			  
			  );
	
	parameter pc_size = 18;	
	parameter data_size = 32;
	
	input clk, rst;		  
			  
	// WB		  
	input EX_MemtoReg;
    input EX_RegWrite;
    // M
    input EX_MemWrite;
	// write your code in here
	// pipe		  
	input [data_size-1:0] EX_ALU_result;
    input [data_size-1:0] EX_Rt_data;
    input [pc_size-1:0] EX_PCplus8;
    input [4:0] EX_WR_out;
	
	// WB
	output M_MemtoReg;	
	output M_RegWrite;	
	// M	
	output M_MemWrite;	
	// write your code in here
	// pipe		  
	output [data_size-1:0] M_ALU_result;
	output [data_size-1:0] M_Rt_data;
	output [pc_size-1:0] M_PCplus8;
	output [4:0] M_WR_out;
	
	// write your code in here
	
endmodule


























