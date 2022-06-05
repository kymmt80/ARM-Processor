module topLevel(
    input clk,rst,mode,//mode : 0 for hazard detection, 1 for forwarding
    inout [15:0]SRAM_DQ,
    output [17:0]SRAM_ADDR,
    output SRAM_LB_EN,
    output SRAM_UB_EN,
    output SRAM_WE_EN,
    output SRAM_CE_EN,
    output SRAM_OE_EN);

    wire freeze,hazard;
    wire [31:0] PC_if,Instruction_if;
    wire [31:0] PC_id,Instruction_id;

    wire WB_EN_id_out,MEM_R_EN_id_out,MEM_W_EN_id_out,S_id_out,B_id_out,imm_id_out,Two_src_id_out;
    wire[3:0]EXE_CMD_id_out,Dest_id_out,src1_id_out,src2_id_out;
    wire[11:0]Shift_operand_id_out;
    wire[23:0]Signed_imm_24_id_out;
    wire [31:0] Val_Rm_id_out,Val_Rn_id_out;

    wire WB_EN_exe_in,MEM_R_EN_exe_in,MEM_W_EN_exe_in,S_exe_in,B_exe_in,imm_exe_in;
    wire[3:0]EXE_CMD_exe_in,Dest_exe_in,src1_exe_in,src2_exe_in;
    wire[11:0]Shift_operand_exe_in;
    wire[23:0]Signed_imm_24_exe_in;
    wire [31:0] Val_Rm_exe_in,Val_Rm_exe_out,Val_Rn_exe_in,PC_exe_in;

    wire [31:0]ALU_result_exe_out,Br_addr_exe_out;

    wire WB_EN_mem_in,MEM_R_EN_mem_in,MEM_W_EN_mem_in;
    wire[3:0]Dest_mem_in;
    wire [31:0]ALU_result_mem_in,Val_Rm_mem_in;

    wire[31:0]Mem_read_value_mem_out;

    wire WB_EN_wb_in,MEM_R_EN_wb_in;
    wire[3:0]Dest_wb_in;
    wire[31:0]ALU_result_wb_in,Mem_read_value_wb_in;

    wire[31:0]WB_out;

    wire[3:0]SR_out,SR_in;

    wire[1:0]sel_src1,sel_src2,sel_src1_raw,sel_src2_raw;

    wire ready;

    //IF______________________________________

    assign flush=B_exe_in&ready;

    IF_stage if_stage(
        .clk(clk),
        .rst(rst),
        .freeze(freeze|(~ready)),
        .Branch_taken(B_exe_in),
        .branchAddr(Br_addr_exe_out),
        .PC(PC_if),
        .Instruction(Instruction_if)
    );

    IF_Stage_Reg ifreg(
        .clk(clk),
        .rst(rst),
        .freeze(freeze|(~ready)),
        .flush(flush),
        .PC_in(PC_if),
        .Instruction_in(Instruction_if),
        .PC(PC_id),
        .Instruction(Instruction_id)
    );

    //ID______________________________________

    ID_stage id_stage(
        .clk(clk),
        .rst(rst),
        .Instruction(Instruction_id),
        .Result_WB(WB_out),
        .writeBackEn(WB_EN_wb_in),
        .Dest_wb(Dest_wb_in),
        .hazard(freeze),
        .SR(SR_out),
        .WB_EN(WB_EN_id_out),
        .MEM_R_EN(MEM_R_EN_id_out),
        .MEM_W_EN(MEM_W_EN_id_out),
        .B(B_id_out),
        .S(S_id_out),
        .EXE_CMD(EXE_CMD_id_out),
        .val_Rn(Val_Rn_id_out),
        .Val_Rm(Val_Rm_id_out),
        .imm(imm_id_out),
        .Shift_operand(Shift_operand_id_out),
        .Signed_imm_24(Signed_imm_24_id_out),
        .Dest(Dest_id_out), 
        .src1(src1_id_out), 
        .src2(src2_id_out),
        .Two_src(Two_src_id_out)
    );

    ID_Stage_Reg idreg(
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .freeze(~ready),
        .WB_EN_IN(WB_EN_id_out),
        .MEM_R_EN_IN(MEM_R_EN_id_out),
        .MEM_W_EN_IN(MEM_W_EN_id_out),
        .B_IN(B_id_out),
        .S_IN(S_id_out), 
        .EXE_CMD_IN(EXE_CMD_id_out),
        .PC_IN(PC_id),
        .Val_Rn_IN(Val_Rn_id_out),
        .Val_Rm_IN(Val_Rm_id_out), 
        .imm_IN(imm_id_out), 
        .Shift_operand_IN(Shift_operand_id_out), 
        .Signed_imm_24_IN(Signed_imm_24_id_out), 
        .Dest_IN(Dest_id_out),
        .src1_IN(src1_id_out),
        .src2_IN(src2_id_out),

        .WB_EN(WB_EN_exe_in),
        .MEM_R_EN(MEM_R_EN_exe_in),
        .MEM_W_EN(MEM_W_EN_exe_in),
        .B(B_exe_in),
        .S(S_exe_in), 
        .EXE_CMD(EXE_CMD_exe_in), 
        .PC(PC_exe_in), 
        .Val_Rn(Val_Rn_exe_in),
        .Val_Rm(Val_Rm_exe_in), 
        .imm(imm_exe_in), 
        .Shift_operand(Shift_operand_exe_in), 
        .Signed_imm_24(Signed_imm_24_exe_in), 
        .Dest(Dest_exe_in),
        .src1(src1_exe_in),
        .src2(src2_exe_in)
    );

    //STATUS REGISTER_________________________

    register #4 SR(
        .clk(~clk),
        .rst(rst),
        .ld(S_exe_in),
        .Qin(SR_in),
        .Q(SR_out)
    );

    //EXE_____________________________________

    EXE_stage exe_stage(
        .clk(clk),
        .EXE_CMD(EXE_CMD_exe_in),
        .MEM_R_EN(MEM_R_EN_exe_in),
        .MEM_W_EN(MEM_W_EN_exe_in),
        .PC(PC_exe_in),
        .Val_Rn(Val_Rn_exe_in),
        .Val_Rm(Val_Rm_exe_in),
        .imm(imm_exe_in),
        .Shift_operand(Shift_operand_exe_in),
        .Signed_imm_24(Signed_imm_24_exe_in),
        .SR(SR_out),

        .sel_src1(sel_src1),
        .sel_src2(sel_src2),
        .MEM_ALU_result(ALU_result_mem_in),
        .WB_wbVal(WB_out),

        .ALU_result(ALU_result_exe_out),
        .Br_addr(Br_addr_exe_out),
        .Val_Rm_out(Val_Rm_exe_out),
        .status(SR_in)
    );

    EXE_Stage_Reg exereg(
        .clk(clk),
        .rst(rst),
        .freeze(~ready),
        .WB_en_in(WB_EN_exe_in),
        .MEM_R_EN_in(MEM_R_EN_exe_in),
        .MEM_W_EN_in(MEM_W_EN_exe_in),
        .ALU_result_in(ALU_result_exe_out),
        .ST_val_in(Val_Rm_exe_out),
        .Dest_in(Dest_exe_in),
        .WB_en(WB_EN_mem_in),
        .MEM_R_EN(MEM_R_EN_mem_in),
        .MEM_W_EN(MEM_W_EN_mem_in),
        .ALU_result(ALU_result_mem_in),
        .ST_val(Val_Rm_mem_in),
        .Dest(Dest_mem_in)
    );

    //MEM_____________________________________

    MEM_stage mem_stage(
        .clk(clk),
        .rst(rst),
        .MEMread(MEM_R_EN_mem_in),
        .MEMwrite(MEM_W_EN_mem_in),
        .address(ALU_result_mem_in),
        .data(Val_Rm_mem_in),
        .MEM_result(Mem_read_value_mem_out),
        .ready(ready),
        .SRAM_DQ(SRAM_DQ),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_UB_EN(SRAM_UB_EN),
        .SRAM_LB_EN(SRAM_LB_EN),
        .SRAM_WE_EN(SRAM_WE_EN),
        .SRAM_CE_EN(SRAM_CE_EN),
        .SRAM_OE_EN(SRAM_OE_EN)
    );

    MEM_Stage_Reg memreg(
        .clk(clk),
        .rst(rst),
        .freeze(~ready),
        .WB_en_in(WB_EN_mem_in&ready),
        .MEM_R_en_in(MEM_R_EN_mem_in),
        .ALU_result_in(ALU_result_mem_in),
        .Mem_read_value_in(Mem_read_value_mem_out),
        .Dest_in(Dest_mem_in),
        .WB_en(WB_EN_wb_in),
        .MEM_R_en(MEM_R_EN_wb_in),
        .ALU_result(ALU_result_wb_in),
        .Mem_read_value(Mem_read_value_wb_in),
        .Dest(Dest_wb_in)
    );

    //WB______________________________________

    WB_stage wb_stage(
    .ALU_result(ALU_result_wb_in),
    .MEM_result(Mem_read_value_wb_in),
    .MEM_R_en(MEM_R_EN_wb_in),
    .out(WB_out)
    );

    //Hazard_Detection________________________

    hazard_Detection_unit hdu(
        .src1(src1_id_out),
        .src2(src2_id_out),
        .Exe_Dest(Dest_exe_in),
        .Exe_WB_EN(WB_EN_exe_in),
        .Exe_MEM_R_EN(MEM_R_EN_exe_in),
        .Mem_Dest(Dest_mem_in),
        .Mem_WB_EN(WB_EN_mem_in),
        .Two_src(Two_src_id_out),
        .mode(mode),
        .hazard_Detected(hazard)
    );

    assign freeze= hazard;

    //Forwarding_Unit_________________________

    forwarding_unit fu(
        .src1(src1_exe_in),
        .src2(src2_exe_in),
        .MEM_dest(Dest_mem_in),
        .MEM_WB_en(WB_EN_mem_in),
        .WB_dest(Dest_wb_in),
        .WB_WB_en(WB_EN_wb_in),
        .sel_src1(sel_src1_raw),
        .sel_src2(sel_src2_raw)
    );
    assign sel_src1=sel_src1_raw&{mode,mode};
    assign sel_src2=sel_src2_raw&{mode,mode};
    // assign hazard=0;
endmodule