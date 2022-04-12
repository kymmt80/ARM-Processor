module topLevel(input clk,rst);
    wire freeze, Branch_taken;
    wire [31:0] PC_if,branchAddr,Instruction_if;
    wire [31:0] PC_id,Instruction_id;

    IF_stage if(
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .Branch_taken(Branch_taken),
        .branchAddr(branchAddr),
        .PC(PC_if),
        .Instruction(Instruction_if)
    )

    IF_Stage_Reg ifreg(
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .flush(flush),
        .PC_in(PC_if),
        .Instruction_in(instruction_if),
        .PC(PC_id),
        .Instruction(Instruction_id)
    )

    
endmodule