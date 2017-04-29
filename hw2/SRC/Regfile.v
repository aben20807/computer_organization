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
	reg [bit_size-1:0] register [0:31];//32 registers

	integer i;
	always@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			for(i = 0; i < 32; i = i + 1)
				register[i] <= 32'b0;//clear address in every registers
		end
		else
		begin
			/****DEBUG****/
			//for(i = 0; i < 32; i = i + 1)
			//	$display("%d, %b", i, register[i]);
			//$display("Write_addr = %b, Write_data = %b\n", Write_addr, Write_data);
			$display("$ra = %h\n", register[31]);
			/****DEBUG****/
			if(RegWrite == 1 && Write_addr != 0)
			begin
				register[Write_addr] <= Write_data;
			end
		end
	end

	assign Read_data_1 = register[Read_addr_1];
	assign Read_data_2 = register[Read_addr_2];
	//assign Write_data = (RegWrite == 1'b1)? 0:1;//register[Write_addr]: 32'b0;
	//assign register[Write_addr] = (RegWrite == 1'b1)? Write_data: 0;

endmodule
