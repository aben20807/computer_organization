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
	parameter bit_size = 18;

    /*wire declaration*/
	/*PC*/
	wire [bit_size-1:0] PCin;
	wire [bit_size-1:0] PCout;

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
    wire [bit_size-1:0] PCout_Plus4;                            //PC + 4
    wire [bit_size-1:0] PCout_Plus8;                            //PC + 8 for jal
	wire [4:0] Mux_RegDst_out;
	wire [data_size-1:0] Mux_MemToReg_out;
    wire [data_size-1:0] Mux_lh_out;

    /*Sign_Extend*/
    wire [data_size-1:0] Immediate_After_Sign_Extend;           //for ALU
    wire [data_size-1:0] Read_data_2_half_After_Sign_Extend;    //for sh
    wire [data_size-1:0] DM_Read_Data_half_After_Sign_Extend;   //for lh

    /*Jump_Ctrl*/
	wire [1:0] JumpOP;
    wire [bit_size-1:0] Jump_Addr;
    wire [bit_size-1:0] Branch_Addr;

	/*wire connection*/
	/*PC*/
	assign IM_Address = PCout [bit_size-1:2];                  //output IM_Address

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
    assign Jump_Addr = ({Immediate, 2'b0});                     //Jump_Addr = Immediate << 2

    /*//Used for debugging display
	integer i = 0;
	always@(posedge clk, posedge rst)
	begin
		if(rst)
		begin
			//$display("rst PCin %b", PCin);
		end
		else
		begin
			//****DEBUG****
			//$display("%d", i); i = i + 1;
			//$display(Write_addr);
			//$display("%h", Instruction);//get instruction
            //$display("PC %h", PCout);
            //$display("opcode %b , funct %b", opcode, funct);//get opcode, funct
			//$display("$Rs    %b  , $Rt   %b\n", Rs, Rt);//get register
		    //$display("$Rs_data = %b , $Rt_data = %b", Read_data_1, Read_data_2);//get data in register
            //$display("Immediate = %b", Immediate);
            //$display("ALUOp = %b", ALUOp);
            //$display("ALU_result = %b", ALU_result);
            //$display("DM_Address = %b, DM_Write_Data = %b\n", DM_Address, DM_Write_Data);
            //****DEBUG****
		end
	end
    */

	PC PC1(
		.clk(clk),
		.rst(rst),
		.PCin(PCin),                      //(Mux_PC)JUMP_TO_PCOUT_PLUS4 or JUMP_TO_BRANCH or JUMP_TO_JR or JUMP_TO_JUMP
		.PCout(PCout)
	);

    ADD PC_ADD4(
        .src1(PCout),
        .src2(18'd4),
        .out(PCout_Plus4)
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

	Regfile Regfile1(
		.clk(clk),
		.rst(rst),
		.Read_addr_1(Rs_Addr),
		.Read_addr_2(Rt_Addr),
		.Read_data_1(Read_data_1),
		.Read_data_2(Read_data_2),
		.RegWrite(RegWrite),                      //from Controller1
		.Write_addr(Write_addr),                  //(Mux_Jal1)Mux_RegDst_out or $ra
		.Write_data(Write_data)
	);

    Sign_Extend Sign_Extend_Imm(                    //let Immediate become 32bits before goto ALU
		.sign_in(Immediate),
		.sign_out(Immediate_After_Sign_Extend)
	);

	Mux2to1_32bit Mux_ALUSrc(
		.I0(Immediate_After_Sign_Extend),
		.I1(Read_data_2),
		.S(ALUSrc),                               //from Controller1
		.out(src2)
	);

	ALU ALU1(
		.ALUOp(ALUOp),                            //from Controller1
		.src1(src1),                              //Read_data_1
		.src2(src2),                              //(Mux_ALUSrc)Immediate_After_Sign_Extend or Read_data_2
		.shamt(shamt),
		.ALU_result(ALU_result),
		.Zero(Zero)
	);

	Sign_Extend Sign_Extend_sh(                    //let half of Read_data_2 become 32bits
		.sign_in(Read_data_2[15:0]),
		.sign_out(Read_data_2_half_After_Sign_Extend)
	);

    Mux2to1_32bit Mux_sh(
        .I0(Read_data_2),
		.I1(Read_data_2_half_After_Sign_Extend),
		.S(Half),
		.out(DM_Write_Data)
    );

    Sign_Extend Sign_Extend_lh(                     //let half of DM_Read_Data become 32bits
		.sign_in(DM_Read_Data[15:0]),
		.sign_out(DM_Read_Data_half_After_Sign_Extend)
	);

	Mux2to1_32bit Mux_lh(
		.I0(DM_Read_Data),
		.I1(DM_Read_Data_half_After_Sign_Extend),
		.S(Half),
		.out(Mux_lh_out)
	);

	Mux2to1_32bit Mux_MemToReg(
		.I0(ALU_result),
		.I1(Mux_lh_out),                          //(Mux_lh)DM_Read_Data or DM_Read_Data_half_After_Sign_Extend
		.S(MemToReg),
		.out(Mux_MemToReg_out)
	);

    ADD PC_ADD8(
        .src1(PCout),
        .src2(18'd8),
        .out(PCout_Plus8)
    );

    Mux2to1_32bit Mux_Jal2(                         //if jal assign Write_data = PCout_Plus8
		.I0(Mux_MemToReg_out),                    //(Mux_MemToReg)ALU_result or Mux_lh_out
		.I1({14'b0, PCout_Plus8}),                //let PCout_Plus8 become 32bits
		.S(Jal),
		.out(Write_data)                          //Write_data to Regfile
	);

    ADD ADD_Branch(                                 //beq, bne
        .src1(Jump_Addr),
        .src2(PCout_Plus4),
        .out(Branch_Addr)
    );

    Jump_Ctrl Jump_Ctrl1(
        .Zero(Zero),                                //from ALU
        .JumpOP(JumpOP),
        .Branch(Branch),                            //from Controller1
        .Jr(Jr),                                    //from Controller1
        .Jump(Jump)                                 //from Controller1
    );

    Mux4to1_18bit Mux_PC(
        .I0(PCout_Plus4),                           //JUMP_TO_PCOUT_PLUS4
    	.I1(Branch_Addr),                           //JUMP_TO_BRANCH
        .I2(Read_data_1[17:0]),                     //JUMP_TO_JR
        .I3(Jump_Addr),                             //JUMP_TO_JUMP
    	.S(JumpOP),
    	.out(PCin)
    );
endmodule
