// ID_EX

module ID_EX ( clk,  
               rst,
               // input 
			   ID_Flush,
			   // WB
			   ID_MemtoReg,
			   ID_RegWrite,
			   // M
			   ID_MemWrite,
			   // write your code in here
			   // EX
			   ID_Reg_imm,
			   // write your code in here	   
			   // pipe
			   ID_PC,
			   ID_ALUOp,
			   ID_shamt,
			   ID_Rs_data,
			   ID_Rt_data,
			   ID_se_imm,
			   ID_WR_out,
			   ID_Rs,
			   ID_Rt,
			   // output
			   // WB
			   EX_MemtoReg,
			   EX_RegWrite,
			   // M
			   EX_MemWrite,
			   // write your code in here
			   // EX
			   EX_Reg_imm,
			   // write your code in here
			   // pipe
			   EX_PC,
			   EX_ALUOp,
			   EX_shamt,
			   EX_Rs_data,
			   EX_Rt_data,
			   EX_se_imm,
			   EX_WR_out,
			   EX_Rs,
			   EX_Rt		   			   
			   );
	
	parameter pc_size = 18;			   
	parameter data_size = 32;
	
	input clk, rst;
	input ID_Flush;
	
	// WB
	input ID_MemtoReg;
	input ID_RegWrite;
	// M
	input ID_MemWrite;
	// write your code in here
	// EX
	input ID_Reg_imm;
	// write your code in here
	// pipe
    input [pc_size-1:0] ID_PC;
    input [3:0] ID_ALUOp;
    input [4:0] ID_shamt;
    input [data_size-1:0] ID_Rs_data;
    input [data_size-1:0] ID_Rt_data;
    input [data_size-1:0] ID_se_imm;
    input [4:0] ID_WR_out;
    input [4:0] ID_Rs;
    input [4:0] ID_Rt;
	
	// WB
	output EX_MemtoReg;
	output EX_RegWrite;
	// M
	output EX_MemWrite;
	// write your code in here
	// EX
	output EX_Reg_imm;
	// write your code in here
	// pipe
	output [pc_size-1:0] EX_PC;
	output [3:0] EX_ALUOp;
	output [4:0] EX_shamt;
	output [data_size-1:0] EX_Rs_data;
	output [data_size-1:0] EX_Rt_data;
	output [data_size-1:0] EX_se_imm;
	output [4:0] EX_WR_out;
	output [4:0] EX_Rs;
	output [4:0] EX_Rt;
	
	// write your code in here
	
endmodule










