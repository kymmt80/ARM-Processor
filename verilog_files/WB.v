module WB_stage (
    input[31:0] ALU_result,MEM_result,
    input MEM_R_en,
    output [31:0] out
);

mux2nton #32 mux(
    .a(ALU_result),
    .b(MEM_result),
    .s(MEM_R_en),
    .o(out)
);
endmodule