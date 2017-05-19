// top

module top ( clk,
             rst,
			 // Instruction Memory
			 IM_Address,
             Instruction,
			 // Data Memory
			 DM_Address,
			 DM_enable,
			 DM_Write_Data,
			 DM_Read_Data);

	parameter data_size = 32;
	parameter mem_size = 16;

	input  clk, rst;

	// Instruction Memory
	output [mem_size-1:0] IM_Address;
	input  [data_size-1:0] Instruction;

	// Data Memory
	output [mem_size-1:0] DM_Address;
	output DM_enable;
	output [data_size-1:0] DM_Write_Data;
    input  [data_size-1:0] DM_Read_Data;

	// write your code here
	parameter pc_size = 18;

	/*wire declaration*/
	/*PC*/
	wire [pc_size-1:0] PCin;
	wire [pc_size-1:0] PCout;

	/*Controller*/
	wire [5:0] opcode;
	wire [5:0] funct;
    wire RegDst, ALUSrc, MemWrite, MemRead, MemToReg, Half, Branch, Jump, Jal, Jr;//RegWrite in Regfile
	wire [3:0] ALUOp;

	/*Regfile*/
	wire [data_size-1:0]Read_data_1;
	wire [data_size-1:0]Read_data_2;
	wire RegWrite;
	wire [4:0] Write_addr;
	wire [data_size-1:0] Write_data;
    wire [mem_size-1:0] Immediate;
	wire [4:0] Rs_Addr;
	wire [4:0] Rt_Addr;
	wire [4:0] Rd_Addr;

	/*ALU*/
	wire [data_size-1:0] src1;
	wire [data_size-1:0] src2;
	wire [4:0] shamt;
	wire [data_size-1:0] ALU_result;
	wire Zero;

	/*Mux*/
    wire [pc_size-1:0] PCout_Plus4;                            //PC + 4
    wire [pc_size-1:0] PCout_Plus8;                            //PC + 8 for jal
	wire [4:0] Mux_RegDst_out;
	wire [data_size-1:0] Mux_MemToReg_out;
    wire [data_size-1:0] Mux_lh_out;

    /*Sign_Extend*/
    wire [data_size-1:0] Immediate_After_Sign_Extend;           //for ALU
    wire [data_size-1:0] Read_data_2_half_After_Sign_Extend;    //for sh
    wire [data_size-1:0] DM_Read_Data_half_After_Sign_Extend;   //for lh

    /*Jump_Ctrl*/
	wire [1:0] JumpOP;
    wire [pc_size-1:0] Jump_Addr;
    wire [pc_size-1:0] Branch_Addr;

	/*wire connection*/
	/*PC*/
	assign IM_Address = PCout [pc_size-1:2];                  //output IM_Address

    /*Controller*/
	assign opcode = Instruction [31:26];
	assign funct = Instruction [5:0];
    assign DM_enable = MemWrite;

	/*Regfile*/
	assign Immediate = Instruction[15:0];                      //get imm from Instruction
	assign Rs_Addr = Instruction[25:21];                       //get Rs_Addr from Instruction
	assign Rt_Addr = Instruction[20:16];                       //get Rt_Addr from Instruction
	assign Rd_Addr = Instruction[15:11];                       //get Rd_Addr from Instruction

	/*ALU*/
	assign shamt = Instruction[10:6];                          //get shamt from Instruction
	assign src1 = Read_data_1;

    /*DM*/
    //assign DM_Write_Data = Read_data_2_After_Sign_Extend;
    //assign DM_Write_Data = Read_data_2;
    assign DM_Address = ALU_result[17:2];

    /*Jump_Ctrl*/
    assign Jump_Addr = ({Immediate, 2'b0});
endmodule
