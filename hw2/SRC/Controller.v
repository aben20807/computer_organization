// Controller

module Controller ( opcode,
					funct,
					// write your code in here
					//Zore// from ALU
					RegDst,
					RegWrite,
					ALUSrc,
					ALUOp,
					MemWrite,
					MemRead,
					MemToReg,
					Half,
					Branch,
					Jump,
					Jal,
					Jr
					);

	input  [5:0] opcode;
    input  [5:0] funct;

	// write your code in here
	output RegDst, RegWrite, ALUSrc, MemWrite, MemRead, MemToReg, Half, Branch, Jump, Jal, Jr;
	output [3:0] ALUOp;
	reg RegDst, RegWrite, ALUSrc, MemWrite, MemRead, MemToReg, Half, Branch, Jump, Jal, Jr;
	reg [3:0] ALUOp;

	/*ALUSrc*/
	parameter   DATA_FROM_IMM = 0,
				DATA_FROM_REG = 1;
	/*ALUOp*/
	parameter OP_AND = 0,
			  OP_OR  = 1,
			  OP_ADD = 3,
			  //OP_MUL = 4;
			  //OP_DIV = 5;
			  OP_SUB = 6,
			  OP_SLT = 7,
			  OP_XOR = 8,
			  //OP_NOT = 9,
			  OP_BEQ = 10,
			  OP_BNE = 11,
			  OP_NOR = 12,
			  OP_SLL = 13,
			  OP_SRL = 14,
			  OP_NOP = 15;

	always@(*)
	begin
		RegDst 		= 1'b0;
		RegWrite 	= 1'b0;
		ALUSrc 		= DATA_FROM_REG;
		ALUOp 		= OP_NOP;
		MemWrite 	= 1'b0;
		MemRead 	= 1'b0;
		MemToReg 	= 1'b0;
		Half		= 1'b0;
		Jump		= 1'b0;
		Jal 		= 1'b0;
		Jr 			= 1'b0;
		case(opcode)
			6'b100011://lw RegWrite, ALUSrc, MemRead, MemToReg
			begin
				//$display("Controller lw");
				RegWrite 	= 1'b1;
				ALUSrc 		= DATA_FROM_IMM;
				ALUOp 		= OP_ADD;
				MemRead 	= 1'b1;
				MemToReg 	= 1'b1;
			end
			6'b101011://sw ALUSrc, MemWrite
			begin
				//$display("Controller sw");
				ALUSrc 		= DATA_FROM_IMM;
				ALUOp 		= OP_ADD;
				MemWrite 	= 1'b1;
			end
			6'b000100://beq PCSrc(Branch)
			begin
				//$display("Controller beq");
				ALUOp 		= OP_BEQ;
				Branch 		= 1'b1;
			end
			6'b001000://addi
			begin
				//$display("Controller addi");
				RegWrite 	= 1'b1;
				ALUSrc 		= DATA_FROM_IMM;
				ALUOp 		= OP_ADD;
			end
			6'b001100://andi
			begin
				//$display("Controller andi");
				RegWrite 	= 1'b1;
				ALUSrc 		= DATA_FROM_IMM;
				ALUOp 		= OP_AND;
			end
			6'b001010://slti
			begin
				//$display("Controller slti");
				RegWrite 	= 1'b1;
				ALUSrc 		= DATA_FROM_IMM;
				ALUOp 		= OP_SLT;
			end
			6'b000101://bne
			begin
				//$display("Controller bne");
				ALUOp 		= OP_BNE;
				Branch 		= 1'b1;
			end
			6'b100001://lh
			begin
				//$display("Controller lh");
				RegWrite 	= 1'b1;
				ALUSrc 		= DATA_FROM_IMM;
				ALUOp 		= OP_ADD;
				MemRead 	= 1'b1;
				MemToReg 	= 1'b1;
				Half		= 1'b1;
			end
			6'b101001://sh
			begin
				//$display("Controller sh");
				ALUSrc 		= DATA_FROM_IMM;
				ALUOp 		= OP_ADD;
				MemWrite 	= 1'b1;
				Half		= 1'b1;
			end
			6'b000010://j
			begin
				//$display("Controller j");
				Jump 		= 1'b1;
			end
			6'b000011://jal
			begin
				//$display("Controller jal");
				RegWrite 	= 1'b1;
				Jump 		= 1'b1;
				Jal 		= 1'b1;
			end
			default:
			begin
				RegDst 		= 1'b0;
				RegWrite 	= 1'b0;
				ALUSrc 		= DATA_FROM_REG;
				ALUOp 		= OP_NOP;
				MemWrite 	= 1'b0;
				MemRead 	= 1'b0;
				MemToReg 	= 1'b0;
				Half		= 1'b0;
				Jump		= 1'b0;
				Jal 		= 1'b0;
				Jr 			= 1'b0;
			end
		endcase

		if(opcode == 6'b000000)//R type
		begin
			RegDst 			= 1'b1;
			ALUSrc 			= DATA_FROM_REG;
			case(funct)
			6'b100000://add
			begin
				//$display("Controller add");
				ALUOp 		= OP_ADD;
				RegWrite 	= 1'b1;
			end
			6'b100010://sub
			begin
				//$display("Controller sub");
				ALUOp 		= OP_SUB;
				RegWrite 	= 1'b1;
			end
			6'b100100://and
			begin
				//$display("Controller and");
				ALUOp 		= OP_AND;
				RegWrite 	= 1'b1;
			end
			6'b100101://or
			begin
				//$display("Controller or");
				ALUOp 		= OP_OR;
				RegWrite 	= 1'b1;
			end
			6'b100110://xor
			begin
				//$display("Controller xor");
				ALUOp 		= OP_XOR;
				RegWrite 	= 1'b1;
			end
			6'b100111://nor
			begin
				//$display("Controller nor");
				ALUOp 		= OP_NOR;
				RegWrite 	= 1'b1;
			end
			6'b101010://slt
			begin
				//$display("Controller slt");
				ALUOp 		= OP_SLT;
				RegWrite 	= 1'b1;
			end
			6'b000000://sll, shamt != 0
			begin
				//$display("Controller sll");
				ALUOp 		= OP_SLL;
				RegWrite 	= 1'b1;

			end
			6'b000010://srl
			begin
				//$display("Controller srl");
				ALUOp 		= OP_SRL;
				RegWrite 	= 1'b1;
			end
			6'b001000://jr
			begin
				//$display("Controller jr");
				Jr 			= 1'b1;
			end
			6'b001001://jalr = jal + jr
			begin
				//$display("Controller jalr");
				RegWrite 	= 1'b1;
				Jr	 		= 1'b1;
				Jal 		= 1'b1;
			end
			default:
			begin
				//$display("NO defined R !!!!");
				ALUOp 		= OP_NOP;
			end
			endcase
		end
	end

endmodule
