module EXE_stage (
    input clk,
    input[3:0] EXE_CMD,
    input MEM_R_EN,MEM_W_EN,
    input[31:0]PC,
    input[31:0]Val_Rn,Val_Rm,
    input imm,
    input[11:0]Shift_operand,
    input[23:0]Signed_imm_24,
    input[3:0] SR,

    output[31:0]ALU_result,Br_addr,
    output[3:0]status
);

wire [31:0] Val_2;

Val2Generator v2g(
    .MEM_CMD(MEM_R_EN|MEM_W_EN),
    .imm(imm),
    .Shift_operand(Shift_operand),
    .Val_Rm(Val_Rm),
    .Val_2(Val_2)
);

ALU alu(
    .EXE_CMD(EXE_CMD),
    .Val1(Val_Rn),
    .Val2(Val_2),
    .carry(SR[1]),
    .ALU_res(ALU_result),
    .status(status)
);

adder a(
    .a(PC),
    .b({{8{Signed_imm_24[23]}},Signed_imm_24}),
    .res(Br_addr)
);

endmodule


module EXE_Stage_Reg (
    input clk,rst, WB_en_in, MEM_R_EN_in, MEM_W_EN_in,
    input[31:0] ALU_result_in, ST_val_in,
    input [3:0] Dest_in,
    output WB_en, MEM_R_EN,MEM_W_EN,
    output[31:0] ALU_result, ST_val,
    output[3:0]Dest
);

register #71 r (
    .clk(clk),
    .rst(rst),
    .ld(1'b1),
    .Qin({WB_en_in,MEM_R_EN_in,MEM_W_EN_in,ALU_result_in,ST_val_in,Dest_in}),
    .Q({WB_en,MEM_R_EN,MEM_W_EN,ALU_result,ST_val,Dest})
);

endmodule