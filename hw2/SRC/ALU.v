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
	
	always@(src1 or src1 or ALUOp)
	begin
		case(ALUOp)
			4'b0000://and
			begin
				Zero <= 0;
				ALU_result <= src1 & src2;
			end
			4'b0001://or
			begin
				Zero <= 0;
				ALU_result <= src1 | src2;
			end
			4'b0010://add
			begin
				Zero <= 0;
				ALU_result <= src1 + src2;
			end			4'b0110://sub
			begin
				if(src1 == src2)Zero <= 1;
				else
				begin
					Zero <= 0;
					ALU_result <= src1 - src2;
				end
			end
			4'b0111://slt
			begin
				Zero <= 0;
				if(src1 - src2 >= 32'b1000_0000_0000_0000_0000_0000_0000_0000)//s1 - s2 <= -1
					ALU_result <= 32'b1;
				else
					ALU_result <= 32'b0;
			end
			4'b1100://nor
			begin////TODO
				Zero <= 0;
				ALU_result <= (~src1) & (~src2);
			end
			4'b0011://mul
			begin////TODO
				Zero <= 0;
				ALU_result <= src1 * src2;
			end
			4'b0100://div
			begin////TODO
				if(src2 != 0)
				begin
					Zero <= 0;
					ALU_result <= src1 / src2;
				end
				else
				begin
					Zero <= 0;
					ALU_result <= src1;
				end
			end
			4'b1001://not
			begin////TODO
				Zero <= 0;
				ALU_result <= ~src1;
			end
			4'b1000://xor
			begin////TODO
				Zero <= 0;
				ALU_result <= src1 ^ src2;
			end
			default:
			begin
				Zero <= 0;
				ALU_result <= src1;
			end
		endcase
	end

endmodule





