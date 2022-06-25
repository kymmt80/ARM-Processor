module testbench();
reg clk=0,rst=0;
wire [15:0]SRAM_DQ;
wire [17:0]SRAM_ADDR;
wire SRAM_UB_EN,SRAM_LB_EN,SRAM_WE_EN,SRAM_CE_EN,SRAM_OE_EN;
topLevel tl(
    .clk(clk),
    .rst(rst),
    .mode(1'd1),
    .SRAM_DQ(SRAM_DQ),
    .SRAM_ADDR(SRAM_ADDR),
    .SRAM_UB_EN(SRAM_UB_EN),
    .SRAM_LB_EN(SRAM_LB_EN),
    .SRAM_WE_EN(SRAM_WE_EN),
    .SRAM_CE_EN(SRAM_CE_EN),
    .SRAM_OE_EN(SRAM_OE_EN)
    );
wire [15:0]rdd;
    assign SRAM_DQ=(SRAM_WE_EN==0)?16'bzzzzzzzzzzzzzzzz:rdd;
    data_mem dm(
    .clk(clk),
    .memWrite(~SRAM_WE_EN),
    .memRead(SRAM_WE_EN),
    .Address(SRAM_ADDR),
    .writeData(SRAM_DQ),
    .readData(rdd)
);
always#5 clk=~clk;
initial begin
    #0 rst=1;
    #10 rst=0;
end
endmodule