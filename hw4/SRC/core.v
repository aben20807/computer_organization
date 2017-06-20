// top

module core (
			  clk,
              rst,
			  // Instruction Cache
			  IC_stall,
			  IC_Address,
              Instruction,
			  // Data Cache
			  DC_stall,
			  DC_Address,
			  DC_Read_enable,
			  DC_Write_enable,
			  DC_Write_Data,
			  DC_Read_Data
			  );

	parameter data_size = 32;
	parameter mem_size = 16;
	parameter pc_size = 18;
	
	input  clk, rst;
	
	// Instruction Cache
	input  IC_stall;
	output [mem_size-1:0] IC_Address;
	input  [data_size-1:0] Instruction;
	
	// Data Cache
	input  DC_stall;
	output [mem_size-1:0] DC_Address;
	output DC_Read_enable;
	output DC_Write_enable;
	output [data_size-1:0] DC_Write_Data;
    input  [data_size-1:0] DC_Read_Data;
	
	// Write your code here
	
endmodule


























