module hazard_Detection_unit(
    input [3:0]src1,
    input [3:0]src2,
    input [3:0]Exe_Dest,
    input Exe_WB_EN,
    input [3:0]Mem_Dest,
    input Mem_WB_EN,
    input Two_src,
    output hazard_Detected);

    assign hazard_Detected=((src1==Exe_Dest)&Exe_WB_EN)?1'b1:
                            ((src1==Mem_Dest)&Mem_WB_EN)?1'b1:
                            ((src2==Exe_Dest)&Exe_WB_EN&Two_src)?1'b1:
                            ((src2==Mem_Dest)&Mem_WB_EN&Two_src)?1'b1:1'b0;

endmodule