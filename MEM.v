module MEM_stage (
    input clk,MEMread,MEMwrite,
    input[31:0] address,data,
    output [31:0] MEM_result
);
endmodule


module MEM_Stage_Reg (
    input clk,rst,WB_en_in,MEM_R_en_in,
    input[31:0] ALU_result_in, Mem_read_value_in,
    input[3:0] Dest_in,
    output reg WB_en, MEM_R_en,
    output reg [31:0] ALU_result, Mem_read_value,
    output reg[3:0] Dest
);

register #70 r (
    .clk(clk),
    .rst(rst),
    .ld(1'b1),
    .Qin({WB_en_in,MEM_R_en_in,ALU_result_in,Mem_read_value_in,Dest_in}),
    .Q({WB_en,MEM_R_en,ALU_result,Mem_read_value,Dest})
);

endmodule