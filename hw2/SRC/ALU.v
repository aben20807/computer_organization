// ALU

module ALU ( ALUOp,
			 src1,
			 src2,
			 shamt,
			 ALU_result,
			 Zero);

	parameter bit_size = 32;

	input [3:0] ALUOp;
	input [bit_size-1:0] src1;
	input [bit_size-1:0] src2;
	input [4:0] shamt;

	output [bit_size-1:0] ALU_result;
	output Zero;
	reg [bit_size-1:0] ALU_result;

	// write your code in here
	reg Zero;
	parameter OP_AND = 0,
			  OP_OR = 1,
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
		ALU_result = 0;
		Zero = 0;
		case(ALUOp)
			OP_AND	:ALU_result = src1 & src2;
			OP_OR	:ALU_result = src1 | src2;
			OP_ADD	:ALU_result = src1 + src2;
			//OP_MUL:
		  	//OP_DIV:
		  	OP_SUB	:ALU_result = src1 - src2;
			OP_SLT:
			begin
				if(src1 - src2 >= 32'b1000_0000_0000_0000_0000_0000_0000_0000)//s1 - s2 <= -1
					ALU_result = 32'b1;
				else
					ALU_result = 32'b0;
			end
			OP_XOR	:ALU_result = src1 ^ src2;
			//OP_NOT:
			OP_BEQ	:Zero = (src1 == src2)? 1: 0;
			OP_BNE	:Zero = (src1 != src2)? 1: 0;
			OP_NOR	:ALU_result = ~(src1 | src2);
			OP_SLL	:ALU_result = src2 << shamt;
			OP_SRL	:ALU_result = src2 >> shamt;
			default	:
			begin
				ALU_result = 0;
				Zero = 0;
			end
		endcase
		// 	OP_AND://and
		//
		// 	begin
		// 		Zero <= 0;
		// 		ALU_result <= src1 & src2;
		// 	end
		// 	OP_OR://or
		// 	begin
		// 		Zero <= 0;
		// 		ALU_result <= src1 | src2;
		// 	end
		// 	 OP_ADD://add
		// 	begin
		// 		Zero <= 0;
		// 		ALU_result <= src1 + src2;
		// 	end
		// 	OP_SUB://sub
		// 	begin
		// 		if(src1 == src2)Zero <= 1;
		// 		else
		// 		begin
		// 			Zero <= 0;
		// 			ALU_result <= src1 - src2;
		// 		end
		// 	end
		// 	4'b0111://slt
		// 	begin
		// 		Zero <= 0;
		// 		if(src1 - src2 >= 32'b1000_0000_0000_0000_0000_0000_0000_0000)//s1 - s2 <= -1
		// 			ALU_result <= 32'b1;
		// 		else
		// 			ALU_result <= 32'b0;
		// 	end
		// 	4'b1100://nor
		// 	begin////TODO
		// 		Zero <= 0;
		// 		ALU_result <= (~src1) & (~src2);
		// 	end
		// 	4'b0011://mul
		// 	begin////TODO
		// 		Zero <= 0;
		// 		ALU_result <= src1 * src2;
		// 	end
		// 	4'b0100://div
		// 	begin////TODO
		// 		if(src2 != 0)
		// 		begin
		// 			Zero <= 0;
		// 			ALU_result <= src1 / src2;
		// 		end
		// 		else
		// 		begin
		// 			Zero <= 0;
		// 			ALU_result <= src1;
		// 		end
		// 	end
		// 	4'b1001://not
		// 	begin////TODO
		// 		Zero <= 0;
		// 		ALU_result <= ~src1;
		// 	end
		// 	4'b1000://xor
		// 	begin////TODO
		// 		Zero <= 0;
		// 		ALU_result <= src1 ^ src2;
		// 	end
		// 	default:
		// 	begin
		// 		Zero <= 0;
		// 		ALU_result <= src1;
		// 	end
		// endcase
	end

endmodule
