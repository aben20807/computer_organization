// IF_ID

module IF_ID ( clk,
               rst,
			   // input
			   IF_IDWrite,
			   IF_Flush,
			   IF_PC,
			   IF_ir,
			   // output
			   ID_PC,
			   ID_ir);

	parameter pc_size = 18;
	parameter data_size = 32;

	input clk, rst;
	input IF_IDWrite, IF_Flush;
	input [pc_size-1:0]   IF_PC;
	input [data_size-1:0] IF_ir;

	output [pc_size-1:0]   ID_PC;
	output [data_size-1:0] ID_ir;

	// write your code in here
	reg [pc_size-1:0]   ID_PC;
	reg [data_size-1:0] ID_ir;

	always@(negedge clk, posedge rst)
	begin
		if(rst || IF_Flush)
		begin
			ID_PC <= 18'b0;
			ID_ir <= 32'b0;
		end
		else
		begin
			if(IF_IDWrite)
			begin
				ID_PC <= IF_PC;
				ID_ir <= IF_ir;
			end
			else
			begin
				ID_PC <= ID_PC;
				ID_ir <= ID_ir;
			end
		end
	end
endmodule
