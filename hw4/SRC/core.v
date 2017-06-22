// top

module core (
			  clk,
              rst,
			  // Instruction Cache
			  IC_stall,
			  IC_Address,
              Instruction,
			  // Data Cache
			  DC_stall,
			  DC_Address,
			  DC_Read_enable,
			  DC_Write_enable,
			  DC_Write_Data,
			  DC_Read_Data
			  );

	parameter data_size = 32;
	parameter mem_size = 16;
	parameter pc_size = 18;

	input  clk, rst;

	// Instruction Cache
	input  IC_stall;
	output [mem_size-1:0] IC_Address;
	input  [data_size-1:0] Instruction;

	// Data Cache
	input  DC_stall;
	output [mem_size-1:0] DC_Address;
	output DC_Read_enable;
	output DC_Write_enable;
	output [data_size-1:0] DC_Write_Data;
    input  [data_size-1:0] DC_Read_Data;

	// Write your code here
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
    wire RegDst, ALUSrc, MemWrite, MemToReg, Half, Branch, Jump, Jal, Jr;//RegWrite in Regfile
	wire [3:0] ALUOp;

	/*Regfile*/
	wire [data_size-1:0]Read_data_1;
	wire [data_size-1:0]Read_data_2;
	wire RegWrite;
	// wire [4:0] Write_addr;
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

	/*Jump_Ctrl*/
	wire [1:0] JumpOP;
    wire [pc_size-1:0] Jump_Addr;
    wire [pc_size-1:0] Branch_Addr;

	/*ALU*/
	wire [data_size-1:0] ALU_src1;
	wire [data_size-1:0] ALU_src2;
	wire Zero;

	/*EX_M*/
	// WB
    // M
	// pipe
	wire [data_size-1:0] EX_ALU_result;
    // wire [data_size-1:0] EX_Rt_data;
    wire [pc_size-1:0] EX_PCplus8;
    // wire [4:0] EX_WR_out;
	// WB
	wire M_MemtoReg;
	wire M_RegWrite;
	// M
	wire M_MemWrite;
	// write your code in here
	wire M_Half;
	wire M_Jal;
	// pipe
	wire [data_size-1:0] M_ALU_result;
	wire [data_size-1:0] M_Rt_data;
	wire [pc_size-1:0] M_PCplus8;
	wire [4:0] M_WR_out;

	/*M_WB*/
	// WB
	// pipe
    wire [data_size-1:0] M_DM_Read_Data;
    wire [data_size-1:0] M_WD_out;
	// WB
	wire WB_MemtoReg;
	wire WB_RegWrite;
	// pipe
    wire [data_size-1:0] WB_DM_Read_Data;
    wire [data_size-1:0] WB_WD_out;
    wire [4:0] WB_WR_out;

	/*Mux*/
    wire [pc_size-1:0] PCout_Plus4;                            //PC + 4
    wire [pc_size-1:0] PCout_Plus8;                            //PC + 8 for jal
	wire [4:0] Mux_RegDst_out;
	wire [4:0] Jal1_out;
	wire [data_size-1:0] Mux_MemToReg_out;
    wire [data_size-1:0] Mux_lh_out;
	wire [data_size-1:0] src1_forword_M_WB_out;
	wire [data_size-1:0] src2_forword_M_WB_out;
	wire [data_size-1:0] src2_isForword_out;

    /*Sign_Extend*/
    wire [data_size-1:0] Immediate_After_Sign_Extend;           //for ALU
    wire [data_size-1:0] M_Rt_data_half_After_Sign_Extend;    	//for sh
    wire [data_size-1:0] DC_Read_Data_half_After_Sign_Extend;   //for lh

	/*FU*/
	wire src1_forword_M_WB;
	wire src1_isForword;
	wire src2_forword_M_WB;
	wire src2_isForword;


	/*wire connection*/
	/*Cache*/
	assign IC_Address = PCout [pc_size-1:2];
	assign DC_Address = M_ALU_result[17:2];
	assign DC_Read_enable = M_MemtoReg;
	assign DC_Write_enable = M_MemWrite;
	assign DC_Write_Data = M_Rt_data;

	/*PC*/
	//assign IM_Address = PCout [pc_size-1:2];                  //output IM_Address

	/*IF_ID*/
	assign IF_PC = PCout_Plus4;
	assign IF_ir = Instruction;

    /*Controller*/
	assign opcode = ID_ir[31:26];
	assign funct = ID_ir[5:0];
    assign DM_enable = M_MemWrite;

	/*Regfile*/
	assign Immediate = ID_ir[15:0];                      //get imm from ID_ir
	assign Rs_Addr = ID_ir[25:21];                       //get Rs_Addr from ID_ir
	assign Rt_Addr = ID_ir[20:16];                       //get Rt_Addr from ID_ir
	assign Rd_Addr = ID_ir[15:11];                       //get Rd_Addr from ID_ir
	assign Write_data = Mux_MemToReg_out;

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
	assign ID_WR_out = Jal1_out;
	assign ID_Rs = Rs_Addr;
	assign ID_Rt = Rt_Addr;

	/*ALU*/
	/*EX_M*/
    /*DM*/
    //assign DM_Address = M_ALU_result[17:2];

    /*Jump_Ctrl*/
    assign Jump_Addr = ({EX_se_imm, 2'b0});

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
		.RegWrite(WB_RegWrite),					//from M_WB
		.Write_addr(WB_WR_out),					//from M_WB
		.Write_data(Write_data)
	);

    Sign_Extend Sign_Extend_Imm(				//let Immediate become 32bits before goto ALU
		.sign_in(Immediate),
		.sign_out(Immediate_After_Sign_Extend)
	);

	Mux2to1_5bit Mux_RegDst(
		.I0(Rt_Addr),
		.I1(Rd_Addr),
		.S(RegDst),
		.out(Mux_RegDst_out)
	);

	Mux2to1_5bit Mux_Jal1(						//if jal assign Write_addr = $ra
		.I0(Mux_RegDst_out),					//(Mux_RegDst)Rt_Addr or Rd_Addr
		.I1(5'd31),								//$ra
		.S(Jal),								//from Controller1
		.out(Jal1_out)                          //Write_addr to Regfile
	);

	ID_EX ID_EX1(
		.clk(clk),
	    .rst(rst),
	    // input
		.ID_EXWrite(ID_EXWrite),
		.ID_Flush(ID_Flush),
		// WB
		.ID_MemtoReg(ID_MemtoReg),
		.ID_RegWrite(ID_RegWrite),
		// M
	 	.ID_MemWrite(ID_MemWrite),
		.ID_Half(ID_Half),
		.ID_Jal(ID_Jal),
		//.ID_se_DM(ID_se_DM),
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
		//.EX_se_DM(EX_se_DM),
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

	ADD ADD_Branch(							//beq, bne
		.src1(Jump_Addr),
		.src2(EX_PC),
		.out(Branch_Addr)
	);

	Jump_Ctrl Jump_Ctrl1(
		.Zero(Zero),						//from ALU
		.JumpOP(JumpOP),
		.Branch(EX_Branch),					//from ID_EX
		.Jr(EX_Jr),							//from ID_EX
		.Jump(EX_Jump)						//from ID_EX
	);

	Mux4to1_18bit Mux_PC(
        .I0(PCout_Plus4),					//JUMP_TO_PCOUT_PLUS4
    	.I1(Branch_Addr),					//JUMP_TO_BRANCH
        .I2(ALU_src1[17:0]),				//JUMP_TO_JR
        .I3(Jump_Addr),						//JUMP_TO_JUMP
    	.S(JumpOP),
    	.out(PCin)
    );

	Mux2to1_32bit Mux_src1_forword_M_WB(	//forwarding src1 from MEM or WB
		.I0(M_WD_out),
		.I1(Mux_MemToReg_out),
		.S(src1_forword_M_WB),				//from FU
		.out(src1_forword_M_WB_out)
	);

	Mux2to1_32bit Mux_src1_isForword(		//forwarding src1 or not forwarding
		.I0(EX_Rs_data),
		.I1(src1_forword_M_WB_out),
		.S(src1_isForword),					//from FU
		.out(ALU_src1)
	);

	Mux2to1_32bit Mux_src2_forword_M_WB(	//forwarding src2 from MEM or WB
		.I0(M_WD_out),
		.I1(Mux_MemToReg_out),
		.S(src2_forword_M_WB),				//from FU
		.out(src2_forword_M_WB_out)
	);

	Mux2to1_32bit Mux_src2_isForword(		//forwarding src2 or not forwarding
		.I0(EX_Rt_data),
		.I1(src2_forword_M_WB_out),
		.S(src2_isForword),					//from FU
		.out(src2_isForword_out)
	);

	Mux2to1_32bit Mux_ALUSrc(
		.I0(EX_se_imm),
		.I1(src2_isForword_out),
		.S(EX_Reg_imm),						//ALUSrc
		.out(ALU_src2)
	);

	ALU ALU1(
		.ALUOp(EX_ALUOp),				//from ID_EX
		.src1(ALU_src1),
		.src2(ALU_src2),
		.shamt(EX_shamt),
		.ALU_result(EX_ALU_result),
		.Zero(Zero)
	);

	ADD PC_ADD8(
        .src1(EX_PC),
        .src2(18'd4),
        .out(EX_PCplus8)				//PCout_Plus8
    );

	EX_M EX_M1(
		.clk(clk),
		.rst(rst),
		// input
		.EX_MWrite(EX_MWrite),
		// WB
		.EX_MemtoReg(EX_MemtoReg),
		.EX_RegWrite(EX_RegWrite),
		// M
		.EX_MemWrite(EX_MemWrite),
		.EX_Half(EX_Half),
		.EX_Jal(EX_Jal),
		// pipe
		.EX_ALU_result(EX_ALU_result),
		.EX_Rt_data(src2_isForword_out),
		.EX_PCplus8(EX_PCplus8),
		.EX_WR_out(EX_WR_out),
		// output
		// WB
		.M_MemtoReg(M_MemtoReg),
		.M_RegWrite(M_RegWrite),
		// M
		.M_MemWrite(M_MemWrite),
		.M_Half(M_Half),
		.M_Jal(M_Jal),
		 // pipe
		.M_ALU_result(M_ALU_result),
	 	.M_Rt_data(M_Rt_data),
		.M_PCplus8(M_PCplus8),
		.M_WR_out(M_WR_out)
	);

	Sign_Extend Sign_Extend_sh(		//let half of Read_data_2 become 32bits
		.sign_in(M_Rt_data[15:0]),
		.sign_out(M_Rt_data_half_After_Sign_Extend)
	);

    Mux2to1_32bit Mux_sh(
        .I0(M_Rt_data),
		.I1(M_Rt_data_half_After_Sign_Extend),
		.S(M_Half),
		.out(DC_Write_Data)
    );

	Sign_Extend Sign_Extend_lh(		//let half of DM_Read_Data become 32bits
		.sign_in(DC_Read_Data[15:0]),
		.sign_out(DC_Read_Data_half_After_Sign_Extend)
	);

	Mux2to1_32bit Mux_lh(
		.I0(DC_Read_Data),
		.I1(DC_Read_Data_half_After_Sign_Extend),
		.S(M_Half),
		.out(M_DM_Read_Data)
	);

	Mux2to1_32bit Mux_Jal2(		//if jal assign Write_data = PCout_Plus8
		.I0(M_ALU_result),
		.I1({14'b0, M_PCplus8}),//let PCout_Plus8 become 32bits
		.S(M_Jal),
		.out(M_WD_out)
	);

	M_WB M_WB1(
		.clk(clk),
		.rst(rst),
		// input
		.M_WBWrite(M_WBWrite),
		// WB
		.M_MemtoReg(M_MemtoReg),
		.M_RegWrite(M_RegWrite),
		// pipe
		.M_DM_Read_Data(M_DM_Read_Data),
		.M_WD_out(M_WD_out),
		.M_WR_out(M_WR_out),
		// output
		// WB
		.WB_MemtoReg(WB_MemtoReg),
		.WB_RegWrite(WB_RegWrite),
		// pipe
		.WB_DM_Read_Data(WB_DM_Read_Data),
		.WB_WD_out(WB_WD_out),
	    .WB_WR_out(WB_WR_out)
	);

	Mux2to1_32bit Mux_MemToReg(
		.I0(WB_WD_out),
		.I1(WB_DM_Read_Data),
		.S(WB_MemtoReg),
		.out(Mux_MemToReg_out)
	);

	FU FU1(
		// input
		.EX_Rs(EX_Rs),
	    .EX_Rt(EX_Rt),
		.M_RegWrite(M_RegWrite),
		.M_WR_out(M_WR_out),
		.WB_RegWrite(WB_RegWrite),
		.WB_WR_out(WB_WR_out),
		// output
		.src1_forword_M_WB(src1_forword_M_WB),
		.src1_isForword(src1_isForword),
		.src2_forword_M_WB(src2_forword_M_WB),
		.src2_isForword(src2_isForword)
	);

	HDU HDU1(
		// input
		.ID_Rs(ID_Rs),
	    .ID_Rt(ID_Rt),
		.EX_WR_out(EX_WR_out),
		.EX_MemtoReg(EX_MemtoReg),
		.EX_JumpOP(JumpOP),
		.IC_stall(IC_stall),
		.DC_stall(DC_stall),
		// output
		.PCWrite(PCWrite),
		.IF_IDWrite(IF_IDWrite),
		.ID_EXWrite(ID_EXWrite),
		.EX_MWrite(EX_MWrite),
		.M_WBWrite(M_WBWrite),
		.IF_Flush(IF_Flush),
		.ID_Flush(ID_Flush)
	);
endmodule
