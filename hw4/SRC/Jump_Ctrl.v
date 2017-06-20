// Jump_Ctrl

module Jump_Ctrl( Zero,
                  JumpOP
				  // write your code in here
				  Branch,
                  Jr,
                  Jump
				  );

    input Zero;
	output [1:0] JumpOP;
	// write your code in here
	input Branch, Jr, Jump;
    reg [1:0] JumpOP;
    parameter   JUMP_TO_PCOUT_PLUS4 = 0,
                JUMP_TO_BRANCH      = 1,
                JUMP_TO_JR          = 2,
                JUMP_TO_JUMP        = 3;
    always@(*)
    begin
        if(Branch == 1 && Zero == 1)
        begin
            //$display("JUMP_TO_BRANCH");
            JumpOP = JUMP_TO_BRANCH;
        end
        else if(Jr == 1)
        begin
            //$display("JUMP_TO_JR");
            JumpOP = JUMP_TO_JR;
        end
        else if(Jump == 1)
        begin
            //$display("JUMP_TO_JUMP");
            JumpOP = JUMP_TO_JUMP;
        end
        else
        begin
            //$display("JUMP_TO_PCOUT_PLUS4");
            JumpOP = JUMP_TO_PCOUT_PLUS4;
        end
    end
endmodule
