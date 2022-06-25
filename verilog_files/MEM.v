module MEM_stage (
    input clk,rst,MEMread,MEMwrite,
    input[31:0] address,data,
    output [31:0] MEM_result,
    output ready,
    inout [15:0]SRAM_DQ,
    output [17:0]SRAM_ADDR,
    output SRAM_LB_EN,
    output SRAM_UB_EN,
    output SRAM_WE_EN,
    output SRAM_CE_EN,
    output SRAM_OE_EN);

// data_mem dm(
//     .clk(clk),
//     .memWrite(MEMwrite),
//     .memRead(MEMread),
//     .Address(address),
//     .writeData(data),
//     .readData(MEM_result)
// );

// SRAM_controller sc(
//     .clk(clk),
//     .rst(rst),
//     .wr_en(MEMwrite),
//     .rd_en(MEMread),
//     .address(address),
//     .write_Data(data),
//     .ReadData(MEM_result),
//     .ready(ready),

//     .SRAM_DQ(SRAM_DQ),
//     .SRAM_ADDR(SRAM_ADDR),
//     .SRAM_UB_EN(SRAM_UB_EN),
//     .SRAM_LB_EN(SRAM_LB_EN),
//     .SRAM_WE_EN(SRAM_WE_EN),
//     .SRAM_CE_EN(SRAM_CE_EN),
//     .SRAM_OE_EN(SRAM_OE_EN)
//     );

wire [31:0]SRAM_addr,SRAM_wdata;
wire [63:0] SRAM_rdata;
wire SRAM_ready,SRAM_W_EN,SRAM_R_EN;

cache_controller cc(
    .clk(clk),
    .rst(rst),

    .address(address),
    .wdata(data),
    .MEM_R_EN(MEMread),
    .MEM_W_EN(MEMwrite),
    .rdata(MEM_result),
    .ready(ready),

    .sram_address(SRAM_addr),
    .sram_wdata(SRAM_wdata),
    .write(SRAM_W_EN),
    .read(SRAM_R_EN),
    .sram_rdata(SRAM_rdata),
    .sram_ready(SRAM_ready)
);

SRAM_controller sc(
    .clk(clk),
    .rst(rst),
    .wr_en(SRAM_W_EN),
    .rd_en(SRAM_R_EN),
    .address(SRAM_addr),
    .write_Data(SRAM_wdata),
    .ReadData(SRAM_rdata),
    .ready(SRAM_ready),

    .SRAM_DQ(SRAM_DQ),
    .SRAM_ADDR(SRAM_ADDR),
    .SRAM_UB_EN(SRAM_UB_EN),
    .SRAM_LB_EN(SRAM_LB_EN),
    .SRAM_WE_EN(SRAM_WE_EN),
    .SRAM_CE_EN(SRAM_CE_EN),
    .SRAM_OE_EN(SRAM_OE_EN)
    );

endmodule


module MEM_Stage_Reg (
    input clk,rst,freeze,WB_en_in,MEM_R_en_in,
    input[31:0] ALU_result_in, Mem_read_value_in,
    input[3:0] Dest_in,
    output WB_en, MEM_R_en,
    output [31:0] ALU_result, Mem_read_value,
    output[3:0] Dest
);

register #70 r (
    .clk(clk),
    .rst(rst),
    .ld(~freeze),
    .Qin({WB_en_in,MEM_R_en_in,ALU_result_in,Mem_read_value_in,Dest_in}),
    .Q({WB_en,MEM_R_en,ALU_result,Mem_read_value,Dest})
);

endmodule