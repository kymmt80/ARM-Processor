module ID_stage (
    input clk,rst,
    //from IF stage
    input [31:0] Instruction,
    //from WB stage
    input[31:0] Result_WB,
    input writeBackEn,
    input [3:0] Dest_wb,
    //from hazard detection module
    input hazard,
    //from status register
    input [3:0]SR,
    //to next stage
    output WB_EN,MEM_R_EN,MEM_W_EN,B,S,
    output[3:0] EXE CMD,
    output[31:0] val_Rn, Val_Rm,
    output imm,
    output[11:0] Shift_operand,
    output[23:0] Signed_imm_24,
    output[3:0] Dest, 
    //to hazard detect module 
    output[3:0] srcl, src2,
    output Two_src);
endmodule


module ID_Stage_Reg (
input clk, Ist, flush,
input WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN,
input B_IN,S_IN, 
input[3:0] EXE_CMD_IN,
input[31:0] PC_IN,
input[31:0] Val_Rn_IN, Val_Rm_IN, 
input imm_IN, 
input[11:0] Shift_operand_IN, 
input[23:0] Signed_imm_24_IN, 
input[3:0] Dest_IN,

output reg WB_EN, MEM_R_EN, MEM_W_EN, B, S, 
output reg[3:0] EXE_CMD, 
output reg[31:0] PC, 
output reg[31:0] Val_Rn, Val_Rm, 
output reg imm, 
output reg[11:0] Shift_operand, 
output reg[23:0] Signed_imm_24, 
output reg [3:0] Dest
);
endmodule