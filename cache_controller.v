module cache_controller(
    input clk,
    input rst,

    input [31:0] address,
    input [31:0] wdata,
    input MEM_R_EN,
    input MEM_W_EN,
    input [31:0] rdata,
    output ready,

    output [31:0] sram_address,
    output [31:0] sram_wdata,
    output reg write,
    input [63:0] sram_rdata,
    input sram_ready );

    wire hit,cache_rdata;

    reg ns,ps;

    reg cache_write,cache_read,cache_mem_write;

    cache c(
        .clk(clk),
        .rst(rst),
        .cache_read(cache_read),
        .mem_write(cache_mem_write),
        .cache_write(cache_write),
        .write_data(sram_rdata),
        .address(address[18:0]),
        .hit(hit),
        .read_data(cache_rdata)
    );

    assign ready=hit|sram_ready;
    assign wdata=sram_wdata;
    assign sram_address=address;

    always@(posedge clk,posedge rst)begin
        if(rst)
            ps<=1'b0;
        else
            ps<=ns;
    end

    always@(ps)begin
        {cache_write,cache_read,cache_mem_write,write}=4'b0000;
        case(ps)
            3'b000: cache_read=1'b1;
            3'b001: cache_write=sram_ready;
            3'b010: {cache_mem_write,write}=2'b11;
        endcase
    end

    always@(ps,MEM_R_EN,hit,MEM_W_EN,sram_ready)begin
        case(ps)
            3'b000: ns=(MEM_R_EN&~hit)?3'b001:(MEM_W_EN)?3'b010:3'b000;
            3'b001: ns=(sram_ready)?3'b000:3'b001;
            3'b010: ns=(sram_ready)?3'b000:3'b010;
    end


endmodule