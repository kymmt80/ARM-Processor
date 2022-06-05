module SRAM_controller(
    input clk,
    input rst,
    //From Memory Stage
    input wr_en,
    input rd_en,
    input[31:0]address,
    input [31:0]write_Data,
    //to next stage
    output[31:0] ReadData,
    //to freeze other stages
    output reg ready,

    inout [15:0]SRAM_DQ,
    output [17:0]SRAM_ADDR,
    output reg SRAM_UB_EN,
    output reg SRAM_LB_EN,
    output reg SRAM_WE_EN,
    output reg SRAM_CE_EN,
    output reg SRAM_OE_EN);

    reg [2:0] ps, ns;
    reg [17:0]addr;
    reg [15:0]writeDataOut;
    reg [31:0]rawReadData;

    assign SRAM_DQ=(SRAM_WE_EN==0)?writeDataOut:16'bzzzzzzzzzzzzzzzz;
    assign SRAM_ADDR=addr;
    assign ReadData=rawReadData;

    always@(posedge clk,posedge rst)begin
        if(rst) ps<=2'b00;
        else ps<=ns;
    end

    always@(ps,wr_en,rd_en)begin
        if(ps==3'b101)
            ns=3'b000;
        else if(wr_en|rd_en)
            ns=ps+1;
        else
            ns=3'b000;
    end

    always@(ps,wr_en,rd_en)begin
        {SRAM_WE_EN,SRAM_UB_EN,SRAM_LB_EN,SRAM_CE_EN,SRAM_OE_EN,ready}=6'b100000;
        if(wr_en)
            case(ps)
            3'b000: begin
                ready=~(wr_en|rd_en);
            end
            3'b001: begin
                writeDataOut=write_Data[15:0];
                addr=((address>>2)<<2)-32'd1024;
                SRAM_WE_EN=1'b0;
            end
            3'b010: begin
                writeDataOut=write_Data[31:16];
                addr=(((address>>2)<<2)-32'd1024)+2;
                SRAM_WE_EN=1'b0;
            end
            3'b101: begin
                ready=1'b1;
            end
            endcase
        else if(rd_en)
            case(ps)
            3'b000: begin
                ready=~(wr_en|rd_en);
            end
            3'b001: begin
                addr=((address>>2)<<2)-32'd1024;
            end
            3'b010: begin
                rawReadData[15:0]=SRAM_DQ;
                addr=(((address>>2)<<2)-32'd1024)+2;
            end
            3'b011: begin
                rawReadData[31:16]=SRAM_DQ;
            end
            3'b101: begin
                ready=1'b1;
            end
            endcase
        else
            case(ps)
            3'b000: begin
                ready=~(wr_en|rd_en);
            end
            endcase
    end

endmodule