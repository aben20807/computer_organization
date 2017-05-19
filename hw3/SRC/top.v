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
	wire PCWrite;
	wire [pc_size-1:0] PCin;
	wire [pc_size-1:0] PCout;

	/*IF_ID*/
	wire IF_IDWrite, IF_Flush;
	wire [pc_size-1:0]   IF_PC;
	wire [data_size-1:0] IF_ir;

	wire [pc_size-1:0]   ID_PC;
	wire [data_size-1:0] ID_ir;

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

	/*ID_EX*/
	wire ID_Flush;
	// WB
	wire ID_MemtoReg;
	wire ID_RegWrite;
	// M
	wire ID_MemWrite;
	wire ID_Half;
	wire ID_Jal;
	// EX
	wire ID_Reg_imm;
	wire ID_Branch;
	wire ID_Jr;
	wire ID_Jump;
	// pipe
    //wire [pc_size-1:0] ID_PC;//in IF_ID
    wire [3:0] ID_ALUOp;
    wire [4:0] ID_shamt;
    wire [data_size-1:0] ID_Rs_data;
    wire [data_size-1:0] ID_Rt_data;
    wire [data_size-1:0] ID_se_imm;
    wire [4:0] ID_WR_out;
    wire [4:0] ID_Rs;
    wire [4:0] ID_Rt;

	// WB
	wire EX_MemtoReg;
	wire EX_RegWrite;
	// M
	wire EX_MemWrite;
	wire EX_Half;
	wire EX_Jal;
	// EX
	wire EX_Reg_imm;
	wire EX_Branch;
	wire EX_Jr;
	wire EX_Jump;
	// pipe
	wire [pc_size-1:0] EX_PC;
	wire [3:0] EX_ALUOp;
	wire [4:0] EX_shamt;
	wire [data_size-1:0] EX_Rs_data;
	wire [data_size-1:0] EX_Rt_data;
	wire [data_size-1:0] EX_se_imm;
	wire [4:0] EX_WR_out;
	wire [4:0] EX_Rs;
	wire [4:0] EX_Rt;

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

	/*IF_ID*/
	assign IF_PC = PCout_Plus4;
	assign IF_ir = Instruction;

    /*Controller*/
	assign opcode = ID_ir[31:26];
	assign funct = ID_ir[5:0];
    assign DM_enable = MemWrite;//TODO

	/*Regfile*/
	assign Immediate = ID_ir[15:0];                      //get imm from Instruction
	assign Rs_Addr = ID_ir[25:21];                       //get Rs_Addr from Instruction
	assign Rt_Addr = ID_ir[20:16];                       //get Rt_Addr from Instruction
	assign Rd_Addr = ID_ir[15:11];                       //get Rd_Addr from Instruction

	/*ID_EX*/
	assign ID_MemtoReg = MemToReg;
	assign ID_RegWrite = RegWrite;
	// M
	assign ID_MemWrite = MemWrite;
	assign ID_Half = Half;
	assign ID_Jal = Jal;
	// EX
	assign ID_Reg_imm = ALUSrc;
	assign ID_Branch = Branch;
	assign ID_Jr = Jr;
	assign ID_Jump = Jump;
	// pipe
	assign ID_ALUOp = ALUOp;
	assign ID_shamt = ID_ir[10:6];
	assign ID_Rs_data = Read_data_1;
	assign ID_Rt_data = Read_data_2;
	assign ID_se_imm = Immediate_After_Sign_Extend;
	assign ID_WR_out = Write_addr;
	assign ID_Rs = Rs_Addr;
	assign ID_Rt = Rt_Addr;

	/*ALU*/
	// assign shamt = Instruction[10:6];                          //get shamt from Instruction
	assign src1 = Read_data_1;

    /*DM*/
    //assign DM_Write_Data = Read_data_2_After_Sign_Extend;
    //assign DM_Write_Data = Read_data_2;
    assign DM_Address = ALU_result[17:2];

    /*Jump_Ctrl*/
    assign Jump_Addr = ({Immediate, 2'b0});

	PC PC1(
		.clk(clk),
		.rst(rst),
		.PCWrite(PCWrite),
		.PCin(PCin),
		.PCout(PCout)
	);

	ADD PC_ADD4(
        .src1(PCout),
        .src2(18'd4),
        .out(PCout_Plus4)
    );

	IF_ID IF_ID1(
		.clk(clk),
	    .rst(rst),
		// input
		.IF_IDWrite(IF_IDWrite),
		.IF_Flush(IF_Flush),
		.IF_PC(IF_PC),
	    .IF_ir(IF_ir),
		// output
	    .ID_PC(ID_PC),
		.ID_ir(ID_ir)
	);

	Controller Controller1(
		.opcode(opcode),
		.funct(funct),
		.RegDst(RegDst),
		.RegWrite(RegWrite),
		.ALUSrc(ALUSrc),
		.ALUOp(ALUOp),
		.MemWrite(MemWrite),
		.MemToReg(MemToReg),
        .Half(Half),
        .Branch(Branch),
        .Jump(Jump),
		.Jal(Jal),
        .Jr(Jr)
	);

	Regfile Regfile1(
		.clk(clk),
		.rst(rst),
		.Read_addr_1(Rs_Addr),
		.Read_addr_2(Rt_Addr),
		.Read_data_1(Read_data_1),
		.Read_data_2(Read_data_2),
		.RegWrite(RegWrite),                      //from Controller1
		.Write_addr(Write_addr),	//TODO                //(Mux_Jal1)Mux_RegDst_out or $ra
		.Write_data(Write_data)		//TODO
	);

    Sign_Extend Sign_Extend_Imm(                    //let Immediate become 32bits before goto ALU
		.sign_in(Immediate),
		.sign_out(Immediate_After_Sign_Extend)
	);

	Mux2to1_5bit Mux_RegDst(
		.I0(Rt_Addr),
		.I1(Rd_Addr),
		.S(RegDst),
		.out(Mux_RegDst_out)
	);

	Mux2to1_5bit Mux_Jal1(                         //if jal assign Write_addr = $ra
		.I0(Mux_RegDst_out),                      //(Mux_RegDst)Rt_Addr or Rd_Addr
		.I1(5'd31),                               //$ra
		.S(Jal),                                  //from Controller1
		.out(Write_addr)                          //Write_addr to Regfile
	);

	ID_EX ID_EX1(
		.clk(clk),
	    .rst(rst),
	    // input
		.ID_Flush(ID_Flush),
		// WB
		.ID_MemtoReg(ID_MemtoReg),
		.ID_RegWrite(ID_RegWrite),
		// M
	 	.ID_MemWrite(ID_MemWrite),
		.ID_Half(ID_Half),
		.ID_Jal(ID_Jal),
		// EX
		.ID_Reg_imm(ID_Reg_imm),
		.ID_Branch(ID_Branch),
		.ID_Jr(ID_Jr),
		.ID_Jump(ID_Jump),
		// pipe
		.ID_PC(ID_PC),
		.ID_ALUOp(ID_ALUOp),
		.ID_shamt(ID_shamt),
		.ID_Rs_data(ID_Rs_data),
		.ID_Rt_data(ID_Rt_data),
		.ID_se_imm(ID_se_imm),
		.ID_WR_out(ID_WR_out),
		.ID_Rs(ID_Rs),
		.ID_Rt(ID_Rt),
		// output
		// WB
		.EX_MemtoReg(EX_MemtoReg),
		.EX_RegWrite(EX_RegWrite),
		// M
		.EX_MemWrite(EX_MemWrite),
		.EX_Half(EX_Half),
		.EX_Jal(EX_Jal),
		// EX
		.EX_Reg_imm(EX_Reg_imm),
		.EX_Branch(EX_Branch),
		.EX_Jr(EX_Jr),
		.EX_Jump(EX_Jump),
		// pipe
		.EX_PC(EX_PC),
		.EX_ALUOp(EX_ALUOp),
		.EX_shamt(EX_shamt),
		.EX_Rs_data(EX_Rs_data),
		.EX_Rt_data(EX_Rt_data),
		.EX_se_imm(EX_se_imm),
		.EX_WR_out(EX_WR_out),
		.EX_Rs(EX_Rs),
		.EX_Rt(EX_Rt)
	);
endmodule
