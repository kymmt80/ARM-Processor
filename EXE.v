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
endmodule


module EXE_Stage_Reg (
    input clk,rst, WB_en_in, MEM_R_EN_in, MEM_W_EN_in,
    input[31:0] ALU_result_in, ST_val_in,
    input [3:0] Dest_in,
    output reg WB_en, MEM_R_EN,MEM_W_EN,
    output reg[31:0] ALU_result, ST_val,
    output reg[3:0]Dest
);

register #39 r (
    .clk(clk),
    .rst(rst),
    .ld(1'b1),
    .Qin({WB_en_in,MEM_R_EN_in,MEM_W_EN_in,ALU_result_in,ST_val_in,Dest_in}),
    .Q({WB_en,MEM_R_EN,MEM_W_EN,ALU_result,ST_val,Dest})
);

endmodule