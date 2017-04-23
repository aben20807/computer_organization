// Regfile

module Regfile ( clk, 
				 rst,
				 Read_addr_1,
				 Read_addr_2,
				 Read_data_1,
                 Read_data_2,
				 RegWrite,
				 Write_addr,
				 Write_data);
	
	parameter bit_size = 32;
	
	input  clk, rst;
	input  [4:0] Read_addr_1;
	input  [4:0] Read_addr_2;
	
	output [bit_size-1:0] Read_data_1;
	output [bit_size-1:0] Read_data_2;
	
	input  RegWrite;
	input  [4:0] Write_addr;
	input  [bit_size-1:0] Write_data;
	
    // write your code in here
	reg [5-1:0] register [32-1:0];//32 registers

	integer i;
	always@(posedge clk, negedge rst)
	begin
		if(rst)
		begin
			for(i=0;i<32;i=i+1)
				register[i] <= 5'd0;//clear address in every registers
		end
	end

	assign Read_data_1 = register[Read_addr_1];
	assign Read_data_2 = register[Read_addr_2];
	assign Write_data = (RegWrite == 1'b1)? register[Write_addr]: 32'b0;

endmodule






