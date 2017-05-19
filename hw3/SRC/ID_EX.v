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
			   ID_Half,
			   ID_Jal,
			   // EX
			   ID_Reg_imm,
			   // write your code in here
			   ID_Branch,
			   ID_Jr,
			   ID_Jump,
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
			   EX_Half,
			   EX_Jal,
			   // EX
			   EX_Reg_imm,
			   // write your code in here
			   EX_Branch,
			   EX_Jr,
			   EX_Jump,
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
	input ID_Half;
	input ID_Jal;
	// EX
	input ID_Reg_imm;
	// write your code in here
	input ID_Branch;
	input ID_Jr;
	input ID_Jump;
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
	output EX_Half;
	output EX_Jal;
	// EX
	output EX_Reg_imm;
	// write your code in here
	output EX_Branch;
	output EX_Jr;
	output EX_Jump;
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
	// WB
	reg EX_MemtoReg;
	reg EX_RegWrite;
	// M
	reg EX_MemWrite;
	reg EX_Half;
	reg EX_Jal;
	// EX
	reg EX_Reg_imm;
	reg EX_Branch;
	reg EX_Jr;
	reg EX_Jump;
	// pipe
	reg [pc_size-1:0] EX_PC;
	reg [3:0] EX_ALUOp;
	reg [4:0] EX_shamt;
	reg [data_size-1:0] EX_Rs_data;
	reg [data_size-1:0] EX_Rt_data;
	reg [data_size-1:0] EX_se_imm;
	reg [4:0] EX_WR_out;
	reg [4:0] EX_Rs;
	reg [4:0] EX_Rt;

	always@(negedge clk, posedge rst)
	begin
		if(rst || ID_Flush)
		begin
			// WB
			EX_MemtoReg	<= 0;
			EX_RegWrite	<= 0;
			// M
			EX_MemWrite	<= 0;
			EX_Half		<= 0;
			EX_Jal		<= 0;
			// EX
			EX_Reg_imm	<= 0;
			EX_Branch	<= 0;
			EX_Jr		<= 0;
			EX_Jump		<= 0;
			// pipe
			EX_PC		<= 18'b0;
			EX_ALUOp	<= 4'b0;
			EX_shamt	<= 5'b0;
			EX_Rs_data	<= 32'b0;
			EX_Rt_data	<= 32'b0;
			EX_se_imm	<= 32'b0;
			EX_WR_out	<= 5'b0;
			EX_Rs		<= 5'b0;
			EX_Rt		<= 5'b0;
		end
		else
		begin
			// WB
			EX_MemtoReg	<= ID_MemtoReg;
			EX_RegWrite	<= ID_RegWrite;
			// M
			EX_MemWrite	<= ID_MemWrite;
			EX_Half		<= ID_Half;
			EX_Jal		<= ID_Jal;
			// EX
			EX_Reg_imm	<= ID_Reg_imm;
			EX_Branch	<= ID_Branch;
			EX_Jr		<= ID_Jr;
			EX_Jump		<= ID_Jump;
			// pipe
			EX_PC		<= ID_PC;
			EX_ALUOp	<= ID_ALUOp;
			EX_shamt	<= ID_shamt;
			EX_Rs_data	<= ID_Rs_data;
			EX_Rt_data	<= ID_Rt_data;
			EX_se_imm	<= ID_se_imm;
			EX_WR_out	<= ID_WR_out;
			EX_Rs		<= ID_Rs;
			EX_Rt		<= ID_Rt;
		end
	end
endmodule
