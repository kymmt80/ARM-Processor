module forwarding_unit(
    //From EXE Phase:
    input [3:0]src1,src2,
    //From MEM Phase:
    input [3:0]MEM_dest,
    input MEM_WB_en,
    //From WB Phase:
    input [3:0]WB_dest,
    input WB_WB_en,
    //To EXE Phase:
    output [1:0]sel_src1,sel_src2
);
assign sel_src1 = (src1==MEM_dest & MEM_WB_en)?2'b01:(src1==WB_dest & WB_WB_en)?2'b10:2'b00;
assign sel_src2 = (src2==MEM_dest & MEM_WB_en)?2'b01:(src2==WB_dest & WB_WB_en)?2'b10:2'b00;

endmodule