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

	/*PC*/
	wire [bit_size-1:0] PCin;
	wire [bit_size-1:0] PCout;
	wire [bit_size-1:0] PCout_Plus4;
    wire [bit_size-1:0] PCout_Plus8;

	/*Controller*/
	wire [5:0] opcode;
	wire [5:0] funct;
	wire RegDst, ALUSrc, MemWrite, MemRead, MemToReg, PCSrc, Jump, Jal, Jr;//RegWrite in Regfile
	wire [3:0] ALUOp;

	/*Regfile*/
	//wire [4:0] Read_addr_1;
	//wire [4:0] Read_addr_2;
	wire [data_size-1:0]Read_data_1;
	wire [data_size-1:0]Read_data_2;
	wire RegWrite;
	wire [4:0] Write_addr;
	wire [data_size-1:0] Write_data;

	/*ALU*/
	//wire [3:0] ALUOp;
	wire [data_size-1:0] src1;
	wire [data_size-1:0] src2;
	wire [4:0] shamt;
	wire [data_size-1:0] ALU_result;
	wire Zero;

	/*Mux*/
	wire [15:0] Immediate;
	wire [4:0] Rs;
	wire [4:0] Rt;
	wire [4:0] Rd;
	wire [4:0] Mux_RegDst_out;
	wire [data_size-1:0] Mux_MemToReg_out;

    /*Sign_Extend*/
    wire [31:0] Immediate_After_Sign_Extend;
    wire [31:0] Read_data_2_After_Sign_Extend;

	/*Mux control*/
	//assign Write_addr = (RegDst == 1)? Instruction[15:11]: Instruction[20:16];//Rd(R):Rt(I)
	//assign src2 = (ALUSrc == 1)? Immediate: Read_data_2;//imm(I):Rt(R)
	//assign DM_enable = MemWrite;

	/*wire connect*/
	/*PC*/
	assign IM_Address = PCout [bit_size-1:2];//output IM_Address
	//assign PCout_Plus4 = PCout + 18'b0000_0000_0000_0001_00;//PCout + 4
    //assign PCout_Plus8 = PCout + 18'b0000_0000_0000_0010_00;//PCout + 8

    /*Controller*/
	assign opcode = Instruction [31:26];
	assign funct = Instruction [5:0];
    assign DM_enable = MemWrite;

	/*Regfile*/
	//assign Read_addr_1 = Instruction[25:21];
	//assign Read_addr_2 = Instruction[20:16];
	assign Immediate = Instruction[15:0];
	assign Rs = Instruction[25:21];
	assign Rt = Instruction[20:16];
	assign Rd = Instruction[15:11];

	/*ALU*/
	assign shamt = Instruction[10:6];
	assign src1 = Read_data_1;

    /*DM*/
    //assign DM_Write_Data = Read_data_2_After_Sign_Extend;
    assign DM_Write_Data = Read_data_2;
    assign DM_Address = ALU_result[17:2];



	integer i = 0;
	always@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			//$display("rst PCin %b", PCin);
		end
		else
		begin
			/****DEBUG****/
			//$display("%d", i); i = i + 1;
			//$display(Write_addr);
		//	$display("%b", Instruction);//get instruction
			//$display("opcode %b , funct %b", opcode, funct);//get opcode, funct
			//$display("$Rs    %b  , $Rt   %b\n", Rs, Rt);//get register
		//	$display("$Rs_data = %b , $Rt_data = %b", Read_data_1, Read_data_2);//get data in register
        //    $display("Immediate = %b", Immediate);
            //$display("ALUOp = %b", ALUOp);
        //    $display("ALU_result = %b", ALU_result);
            $display("DM_Address = %b, DM_Write_Data = %b\n", DM_Address, DM_Write_Data);
            /****DEBUG****/
		end
	end

	PC PC1(
		.clk(clk),
		.rst(rst),
		.PCin(PCout_Plus4),//tamp
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
		.MemRead(MemRead),
		.MemToReg(MemToReg),
		.PCSrc(PCSrc),
        .Jump(Jump),
		.Jal(Jal),
        .Jr(Jr)
	);

	Regfile Regfile1(
		.clk(clk),
		.rst(rst),
		.Read_addr_1(Rs),
		.Read_addr_2(Rt),
		.Read_data_1(Read_data_1),
		.Read_data_2(Read_data_2),
		.RegWrite(RegWrite),
		.Write_addr(Write_addr),
		.Write_data(Write_data)
	);

	ALU ALU1(
		.ALUOp(ALUOp),
		.src1(src1),
		.src2(src2),
		.shamt(shamt),
		.ALU_result(ALU_result),
		.Zero(Zero)
	);

	Mux2to1_5bit Mux_RegDst(
		.I0(Rt),
		.I1(Rd),
		.S(RegDst),
		.out(Mux_RegDst_out)
	);

	Mux2to1_5bit Mux_Jr(
		.I0(Mux_RegDst_out),
		.I1(5'd31),//$ra
		.S(Jr),
		.out(Write_addr)//Write_addr to Regfile
	);

	Sign_Extend Sign_Extend_Immediate(
		.sign_in(Immediate),
		.sign_out(Immediate_After_Sign_Extend)
	);

	Mux2to1_32bit Mux_ALUSrc(
		.I0(Immediate_After_Sign_Extend),
		.I1(Read_data_2),
		.S(ALUSrc),
		.out(src2)
	);

    // Sign_Extend Sign_Extend_Read_data_2(
	// 	.sign_in(Read_data_2),
	// 	.sign_out(Read_data_2_After_Sign_Extend)
	// );

	Mux2to1_32bit Mux_MemToReg(
		.I0(ALU_result),
		.I1(DM_Read_Data),
		.S(MemToReg),
		.out(Mux_MemToReg_out)
	);

    ADD PC_ADD8(
        .src1(PCout),
        .src2(18'd8),
        .out(PCout_Plus8)
    );

    Mux2to1_32bit Mux_Jal(
		.I0(Mux_MemToReg_out),
		.I1({14'b0, PCout_Plus8}),
		.S(Jal),
		.out(Write_data)//Write_data to Regfile
	);

endmodule
