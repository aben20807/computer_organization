// Forwarding Unit

module FU ( // input
			EX_Rs,
            EX_Rt,
			M_RegWrite,
			M_WR_out,
			WB_RegWrite,
			WB_WR_out,
			// output
			// write your code in here
			src1_forword_M_WB,
			src1_isForword,
			src2_forword_M_WB,
			src2_isForword
			);

	input [4:0] EX_Rs;
    input [4:0] EX_Rt;
    input M_RegWrite;
    input [4:0] M_WR_out;
    input WB_RegWrite;
    input [4:0] WB_WR_out;

	// write your code in here
	output src1_forword_M_WB;
	output src1_isForword;
	output src2_forword_M_WB;
	output src2_isForword;

	reg src1_forword_M_WB;
	reg src1_isForword;
	reg src2_forword_M_WB;
	reg src2_isForword;

	always @(*)
	begin
		/*Rs*/
		if((M_RegWrite == 1) && (M_WR_out != 0) && (M_WR_out == EX_Rs))
		begin
			src1_forword_M_WB	= 0;
			src1_isForword 		= 1;
		end
		else if((WB_RegWrite == 1) && (WB_WR_out != 0) && (M_WR_out != EX_Rs) && (WB_WR_out == EX_Rs))
		begin
			src1_forword_M_WB	= 1;
			src1_isForword		= 1;
		end
		else
		begin
			src1_forword_M_WB	= 0;
			src1_isForword		= 0;
		end

		/*Rt*/
		if((M_RegWrite == 1) && (M_WR_out != 0) && (M_WR_out == EX_Rt))
		begin
			src2_forword_M_WB	= 0;
			src2_isForword 		= 1;
		end
		else if((WB_RegWrite == 1) && (WB_WR_out != 0) && (M_WR_out != EX_Rt) && (WB_WR_out == EX_Rt))
		begin
			src2_forword_M_WB	= 1;
			src2_isForword		= 1;
		end
		else
		begin
			src2_forword_M_WB	= 0;
			src2_isForword		= 0;
		end
	end
endmodule
