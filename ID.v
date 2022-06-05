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
    output[3:0] EXE_CMD,
    output[31:0] val_Rn, Val_Rm,
    output imm,
    output[11:0] Shift_operand,
    output[23:0] Signed_imm_24,
    output[3:0] Dest, 
    //to hazard detect module 
    output[3:0] src1, src2,
    output Two_src);

    wire condition_check_out;
    wire WB_EN_cn_out,MEM_R_EN_cn_out,MEM_W_EN_cn_out,B_cn_out,S_cn_out;
    wire[3:0]EXE_CMD_cn_out,src2in;

    wire mux1select;

    Control_unit cn(
        .mode(Instruction[27:26]),
        .op_code(Instruction[24:21]),
        .S(Instruction[20]),
        .Execute_command(EXE_CMD_cn_out),
        .mem_read(MEM_R_EN_cn_out),
        .mem_write(MEM_W_EN_cn_out),
        .WB_enable(WB_EN_cn_out),
        .B(B_cn_out),
        .Update_SR(S_cn_out)
    );

    or r1(mux1select,hazard,~condition_check_out);

    mux2nton #9 mux1(
        .a({WB_EN_cn_out,MEM_R_EN_cn_out,MEM_W_EN_cn_out,B_cn_out,S_cn_out,EXE_CMD_cn_out}),
        .b(9'd0),
        .o({WB_EN,MEM_R_EN,MEM_W_EN,B,S,EXE_CMD}),
        .s(mux1select)
    );

    Condition_Check cc(
        .Cond(Instruction[31:28]),
        .SR(SR),
        .check_output(condition_check_out)
    );

    Register_file rf(
        .clk(clk),
        .rst(rst),
        .src1(Instruction[19:16]),
        .src2(src2in),
        .Dest_wb(Dest_wb),
        .Result_WB(Result_WB),
        .writeBackEn(writeBackEn),
        .reg1(val_Rn),
        .reg2(Val_Rm)
    );

    assign Dest=Instruction[15:12];
    assign imm=Instruction[25];
    assign Signed_imm_24=Instruction[23:0];
    assign Shift_operand=Instruction[11:0];
    assign Two_src=(~imm)|MEM_W_EN;
    assign src1=Instruction[19:16];
    assign src2=src2in;

    mux2nton #4 mux2(
        .a(Instruction[3:0]),
        .b(Instruction[15:12]),
        .s(MEM_W_EN),
        .o(src2in)
    );


endmodule


module ID_Stage_Reg (
input clk, rst, flush,freeze,
input WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN,
input B_IN,S_IN, 
input[3:0] EXE_CMD_IN,
input[31:0] PC_IN,
input[31:0] Val_Rn_IN, Val_Rm_IN, 
input imm_IN, 
input[11:0] Shift_operand_IN, 
input[23:0] Signed_imm_24_IN, 
input[3:0] Dest_IN,
input[3:0] src1_IN,src2_IN,

output reg  WB_EN, MEM_R_EN, MEM_W_EN, B, S, 
output reg [3:0] EXE_CMD, 
output reg [31:0] PC, 
output reg [31:0] Val_Rn, Val_Rm, 
output reg  imm, 
output reg [11:0] Shift_operand, 
output reg [23:0] Signed_imm_24, 
output reg  [3:0] Dest,
output reg [3:0]src1,src2
);

always @(posedge clk, posedge rst) begin
    if(rst)
        {WB_EN,MEM_R_EN,MEM_W_EN,B,S,EXE_CMD,PC,Val_Rn,Val_Rm,imm,Shift_operand,Dest,Signed_imm_24,src1,src2}<=154'd0;
    else
        if(flush)
            {WB_EN,MEM_R_EN,MEM_W_EN,B,S,EXE_CMD,PC,Val_Rn,Val_Rm,imm,Shift_operand,Dest,Signed_imm_24,src1,src2}<=154'd0;
        else if(!freeze) 
            {WB_EN,MEM_R_EN,MEM_W_EN,B,S,EXE_CMD,PC,Val_Rn,Val_Rm,imm,Shift_operand,Dest,Signed_imm_24,src1,src2}<={WB_EN_IN,MEM_R_EN_IN,MEM_W_EN_IN,B_IN,S_IN,EXE_CMD_IN,PC_IN,Val_Rn_IN,Val_Rm_IN,imm_IN,Shift_operand_IN,Dest_IN,Signed_imm_24_IN,src1_IN,src2_IN};
end

// register #154 r (
//     .clk(clk),
//     .rst(rst|flush),
//     .ld(1'b1),
//     .Qin({WB_EN_IN,MEM_R_EN_IN,MEM_W_EN_IN,B_IN,S_IN,EXE_CMD_IN,PC_IN,Val_Rn_IN,Val_Rm_IN,imm_IN,Shift_operand_IN,Dest_IN,Signed_imm_24_IN,src1_IN,src2_IN}),
//     .Q({WB_EN,MEM_R_EN,MEM_W_EN,B,S,EXE_CMD,PC,Val_Rn,Val_Rm,imm,Shift_operand,Dest,Signed_imm_24,src1,src2})
// );

endmodule