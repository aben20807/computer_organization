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
	reg [bit_size-1:0] tPCin;
	wire [bit_size-1:0] PCout;
	reg [bit_size-1:0] tPCout;
	assign IM_Address = PCout [bit_size-1:2];
	assign PCin = tPCin;
	assign PCout = tPCout;

	/*Controller*/
	wire [5:0] opcode;
	wire [5:0] funct;
	assign opcode = Instruction [31:26];
	assign funct = Instruction [5:0];

	/*Regfile*/
	wire [4:0] Read_addr_1;
	wire [4:0] Read_addr_2;
	wire [data_size-1:0]Read_data_1;
	wire [data_size-1:0]Read_data_2;
	wire RegWrite;
	wire [4:0] Write_addr;
	wire [data_size-1:0] Write_data;
	assign Read_addr_1 = Instruction[25:21];
	assign Read_addr_2 = Instruction[20:16];
	
	
	//initial begin
		//#1
	//end
	//reg [5:0] i = 5'b000000;
	//reg boo = 0;
	always@(posedge clk, negedge rst)
	begin
		if(rst)
		begin
			tPCin <= 18'b0000_0000_0001_0000_00;
			tPCout <= 18'b0000_0000_0001_0000_00;
			$display("rst PCin %b", PCin);
		end
		else
		begin
			/****DEBUG****/
			$display("%b", Instruction);//get instruction
			$display("$Rs : %b , $Rt : %b", Read_addr_1, Read_addr_2);//get register
			$display("$Rs > %b , $Rt > %b", Read_data_1, Read_data_2);//get data in register
			/****DEBUG****/
			//tPCout <= PCout + 4;
			//tPCin <= PCout + 18'b0000_0000_0000_0001_00;
			
			//$display("%d : PCin %b", i, PCin);
			//i = i + 1;
			//$display("clk call PCout %b", PCout);
		end
	end

PC PC1(
	.clk(clk), 
	.rst(rst),
	.PCin(PCin), 
	.PCout(PCout)
);

Controller Controller1(
	.opcode(opcode),
	.funct(funct)
);

Regfile Regfile1(
.clk(clk), 
.rst(rst),
.Read_addr_1(Read_addr_1),
.Read_addr_2(Read_addr_2),
.Read_data_1(Read_data_1),
.Read_data_2(Read_data_2),
.RegWrite(RegWrite),
.Write_addr(Write_addr),
.Write_data(Write_data)
);

endmodule


























