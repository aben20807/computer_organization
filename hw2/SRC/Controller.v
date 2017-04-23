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
					PCSrc
					);

	input  [5:0] opcode;
    input  [5:0] funct;

	// write your code in here
	output RegDst, RegWrite, ALUSrc, MemWrite, MemRead, MemToReg, PCSrc;
	output [2:0] ALUOp;
	reg RegDst, RegWrite, ALUSrc, MemWrite, MemRead, MemToReg, PCSrc;
	reg [2:0] ALUOp;

	always@(*)
	begin
		case(opcode)
			6'b000000://R type RegDst, RegWrite
			begin
				$display("R");
				RegDst <= 1'b1;
				RegWrite <= 1'b1;
				ALUSrc <= 1'b0;
				ALUOp <= 3'b0;
				MemWrite <= 1'b0;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b0;
			end
			6'b100011://lw RegWrite, ALUSrc, MemRead, MemToReg
			begin
				$display("lw");
				RegDst <= 1'b0;
				RegWrite <= 1'b1;
				ALUSrc <= 1'b1;
				ALUOp <= 3'b0;
				MemWrite <= 1'b0;
				MemRead <= 1'b1;
				MemToReg <= 1'b1;
				PCSrc <= 1'b0;
			end
			6'b101011://sw ALUSrc, MemWrite, PCSrc(Branch)
			begin
				$display("sw");
				RegDst <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b1;
				ALUOp <= 3'b0;
				MemWrite <= 1'b1;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b1;
			end
			6'b000100://beq
			begin
				$display("beq");
				RegDst <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b0;
				ALUOp <= 3'b0;
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
				ALUOp <= 3'b0;
				MemWrite <= 1'b0;
				MemRead <= 1'b0;
				MemToReg <= 1'b0;
				PCSrc <= 1'b0;
			end
		endcase
	end

endmodule




