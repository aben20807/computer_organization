// Cache Control

module Cache_Control (
					   clk,
					   rst,
					   // input
					   en_R,
					   en_W,
					   hit,
					   // output
					   Read_mem,
					   Write_mem,
					   Valid_enable,
					   Tag_enable,
					   Data_enable,
					   sel_mem_core,
					   stall
					   );

	input clk, rst;
	input en_R;
	input en_W;
    input hit;

	output Read_mem;
	output Write_mem;
	output Valid_enable;
	output Tag_enable;
	output Data_enable;
	output sel_mem_core;		// 0 data from mem, 1 data from core
	output stall;

	// write your code here
	reg Read_mem;
	reg Write_mem;
	reg Valid_enable;
	reg Tag_enable;
	reg Data_enable;
	reg sel_mem_core;
	reg stall;

	//{en_R,en_W} = 10(read), = 01(write)
	parameter mode_read	 = 2'b10,
			  mode_write = 2'b01;

	//FSM when cache read occurs
	parameter R_Idle		 = 0,
			  R_wait		 = 1,
			  R_Read_Memory	 = 2;

	reg [1:0] curr_R_state;
	reg [1:0] next_R_state;

	wire Read_Miss;
	assign Read_Miss = (hit == 0 && en_R == 1)? 1: 0;

	//write state
	parameter Write_Miss = 0,
			  Write_Hit	 = 1;

	//FSM circuit
	always @(*)
	begin
		case (curr_R_state)
			R_Idle			 :next_R_state = (Read_Miss == 1)? R_wait: R_Idle;
			R_wait			 :next_R_state = R_Read_Memory;
			R_Read_Memory	 :next_R_state = R_Idle;
		endcase
	end

	//main circuit
	always @(*)
	begin
		Read_mem	 = 0;
		Write_mem	 = 0;
		Valid_enable = 0;
		Tag_enable	 = 0;
		Data_enable	 = 0;
		sel_mem_core = 0;

		//when read miss, stall cpu
		stall = Read_Miss;

		//Read Write Control
		case ({en_R,en_W})
			/*read*/
			mode_read:
			begin
				case (cur_R_state)
					R_Idle:
					begin
						Read_mem = (Read_Miss == 1)? 1: 0;
					end
					R_wait://do nothing, just wait;
					begin
					end
		    		R_Read_Memory:
					begin
						Data_enable		= 1;
						Tag_enable 		= 1;
						Valid_enable	= 1;
					end
				endcase
			end
			/*write*/
			mode_write:
				begin
				Write_mem = 1;
				case (hit)
					Write_Miss:
					begin
					end
		    		Write_Hit:
					begin
						Data_enable = 1;
						sel_mem_core = 1;
					end
				endcase
			end
		endcase
	end

	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			cur_R_state <= R_Idle;
		end
		else
		begin
			curr_R_state <= next_R_state;
		end
	end
endmodule
