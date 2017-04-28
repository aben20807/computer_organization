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
					PCSrc,
					Jal
					);

	input  [5:0] opcode;
    input  [5:0] funct;

	// write your code in here
	output RegDst, RegWrite, ALUSrc, MemWrite, MemRead, MemToReg, PCSrc, Jal;
	output [3:0] ALUOp;
	reg RegDst, RegWrite, ALUSrc, MemWrite, MemRead, MemToReg, PCSrc;
	reg [3:0] ALUOp;

	always@(*)
	begin
		case(opcode)
			6'b000000://R type RegDst, RegWrite
			begin
				//$display("Controller R type");
				RegDst <= 1'b1;
				RegWrite <= 1'b1;
				ALUSrc <= 1'b0;
				ALUOp <= 4'b0;//define by funct
				MemWrite <= 1'b0;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b0;
			end
			6'b100011://lw RegWrite, ALUSrc, MemRead, MemToReg
			begin
				$display("Controller lw");
				RegDst <= 1'b0;
				RegWrite <= 1'b1;
				ALUSrc <= 1'b1;
				ALUOp <= 4'b0010;
				MemWrite <= 1'b0;
				MemRead <= 1'b1;
				MemToReg <= 1'b1;
				PCSrc <= 1'b0;
			end
			6'b101011://sw ALUSrc, MemWrite
			begin
				$display("Controller sw");
				RegDst <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b1;
				ALUOp <= 4'b0010;
				MemWrite <= 1'b1;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b0;
			end
			6'b000100://beq PCSrc(Branch)
			begin
				$display("Controller beq");
				RegDst <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b0;
				ALUOp <= 4'b0110;
				MemWrite <= 1'b0;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b1;
			end
			6'b001000://addi
			begin
				$display("Controller addi");////TODO
				RegDst <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b0;
				ALUOp <= 4'b0010;
				MemWrite <= 1'b0;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b0;
			end
			6'b001100://andi
			begin
				$display("Controller andi");////TODO
				RegDst <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b0;
				ALUOp <= 4'b0000;
				MemWrite <= 1'b0;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b0;
			end
			6'b001010://slti
			begin
				$display("Controller slti");////TODO
				RegDst <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b0;
				ALUOp <= 4'b0;
				MemWrite <= 1'b0;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b0;
			end
			6'b000101://bne
			begin
				$display("Controller bne");////TODO
				RegDst <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b0;
				ALUOp <= 4'b0;
				MemWrite <= 1'b0;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b0;
			end
			6'b100001://lh
			begin
				$display("Controller lh");////TODO
				RegDst <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b0;
				ALUOp <= 4'b0;
				MemWrite <= 1'b0;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b0;
			end
			6'b101001://sh
			begin
				$display("Controller sh");////TODO
				RegDst <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b0;
				ALUOp <= 4'b0;
				MemWrite <= 1'b0;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b0;
			end
			6'b000010://j
			begin
				$display("Controller j");////TODO
				RegDst <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b0;
				ALUOp <= 4'b0;
				MemWrite <= 1'b0;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b0;
			end
			6'b000011://jal
			begin
				$display("Controller jal");////TODO
				RegDst <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b0;
				ALUOp <= 4'b0;
				MemWrite <= 1'b0;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b0;
			end
			default:
			begin
				RegDst <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b0;
				ALUOp <= 4'b0;
				MemWrite <= 1'b0;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b0;
			end
		endcase

		if(opcode == 6'b000000)//R type
		begin
			case(funct)
			6'b100000://add
			begin
				$display("Controller add");
				ALUOp <= 4'b0010;
			end
			6'b100010://sub
			begin
				$display("Controller sub");
				ALUOp <= 4'b0110;
			end
			6'b100100://and
			begin
				$display("Controller and");
				ALUOp <= 4'b0000;
			end
			6'b100101://or
			begin
				$display("Controller or");
				ALUOp <= 4'b0001;
			end
			6'b100110://xor
			begin
				$display("Controller xor");
				ALUOp <= 4'b1000;
			end
			6'b100111://nor
			begin
				$display("Controller nor");
				ALUOp <= 4'b1100;
			end
			6'b101010://slt
			begin
				$display("Controller slt");
				ALUOp <= 4'b0111;
			end
			6'b000000://sll, shamt != 0
			begin
				$display("Controller sll");
				ALUOp <= 4'b1010;
			end
			6'b000010://srl
			begin
				$display("Controller srl");
				ALUOp <= 4'b1011;
			end
			6'b001000://jr
			begin
				$display("Controller jr");
				ALUOp <= 4'b1101;
			end
			6'b001001://jalr
			begin
				$display("Controller jalr");
				ALUOp <= 4'b1110;
			end
			default:
			begin
				$display("NO defined R !!!!");
				ALUOp <= 4'b0;
			end
			endcase
		end
	end

endmodule
