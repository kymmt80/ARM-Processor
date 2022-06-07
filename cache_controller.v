module cache_controller(
    input clk,
    input rst,

    input [31:0] address,
    input [31:0] wdata,
    input MEM_R_EN,
    input MEM_W_EN,
    output [31:0] rdata,
    output reg ready,

    output [31:0] sram_address,
    output [31:0] sram_wdata,
    output reg write,
    output reg read,
    input [63:0] sram_rdata,
    input sram_ready );

    wire hit;
    wire [31:0] cache_rdata;

    reg [2:0] ns,ps;

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

    assign sram_wdata=wdata;
    assign sram_address=address;
    assign rdata=(hit)?cache_rdata:(address[2])?sram_rdata[63:32]:sram_rdata[31:0];

    always@(posedge clk,posedge rst)begin
        if(rst)
            ps<=1'b0;
        else
            ps<=ns;
    end

    always@(ps,sram_ready,MEM_R_EN,MEM_W_EN,hit)begin
        {cache_write,cache_read,cache_mem_write,write,read,ready}=6'b000000;
        case(ps)
            3'b000: begin cache_read=1'b1; ready=(MEM_W_EN)?1'b0:(MEM_R_EN)?hit|sram_ready:1'b1; end
            3'b001: {read,cache_write}={1'b1,sram_ready};
            3'b010: {cache_mem_write,write}=2'b11;
            3'b100: ready=1'b1;
        endcase
    end

    always@(ps,MEM_R_EN,hit,MEM_W_EN,sram_ready)begin
        case(ps)
            3'b000: ns=(MEM_R_EN&~hit)?3'b001:(MEM_W_EN)?3'b010:3'b000;
            3'b001: ns=(sram_ready)?3'b100:3'b001;
            3'b010: ns=(sram_ready)?3'b100:3'b010;
            3'b100: ns=3'b000;
        endcase
    end


endmodule