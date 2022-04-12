module IF_stage (input clk,rst,freeze,Branch_taken,input[31:0] branchAddr,output [31:0] PC,Instruction);

wire [31:0] adderOut;

register PC_reg(
    .clk(clk),
    .rst(rst),
    .ld(~freeze),
    .Qin(adderOut),
    .Q(PC)
);

adder a(
    .a(PC),
    .b(32'd4),
    .res(adderOut)
);

inst_mem im(
    .Address(PC),
    .inst(Instruction)
);

endmodule


module IF_Stage_Reg (
    input clk,rst,freeze,flush,
    input[31:0] PC_in,Instruction_in,
    output[31:0] PC,Instruction
);

register #64 r (
    .clk(clk),
    .rst(rst|flush),
    .ld(~freeze),
    .Qin({PC_in,Instruction_in}),
    .Q({PC,Instruction})
);

endmodule