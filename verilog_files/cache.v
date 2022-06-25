module cache(
    input clk,rst,cache_read,mem_write,cache_write,
    input [18:0] address,
    input [63:0] write_data,
    output hit,
    output [31:0] read_data
);

    wire [9:0] tag;
    wire [5:0] index;
    wire [2:0] offset;

    wire [63:0] raw_read_data;

    assign {tag, index, offset} = address;
    assign read_data=(offset[2])?raw_read_data[63:32]:raw_read_data[31:0];

    reg [63:0] data_0 [0:63];
    reg [63:0] data_1 [0:63];

    reg [9:0] tag_0 [0:63];
    reg [9:0] tag_1 [0:63];

    reg valid_0 [0:63];
    reg valid_1 [0:63];

    reg lru [0:63];

    wire hit_0, hit_1;
    assign hit_0 = (tag_0[index] == tag) & valid_0[index];
    assign hit_1 = (tag_1[index] == tag) & valid_1[index];

    integer i;
    initial for (i=0; i<64 ; i=i+1) begin
        valid_0[i] = 1'b0;
        valid_1[i] = 1'b0;
        tag_0[i] = 10'b0;
        tag_1[i] = 10'b0;
        lru[i] = 1'b0;
    end

    mux2nton #64 mux1(
        .a(data_0[index]),
        .b(data_1[index]),
        .s(~hit_0),
        .o(raw_read_data)
    );

    assign hit = hit_0 | hit_1;

    always @(posedge clk)
        if (cache_read & hit)
            lru[index] <= hit_0 ? 1'b0: 1'b1;

    always @(posedge clk) begin
        if (mem_write & hit) begin
            if (hit_0) begin
                valid_0[index] <= 1'b0;
                lru[index] <= 1'b1;
            end
            
            else if (hit_1) begin
                valid_1[index] <= 1'b0;
                lru[index] <= 1'b0;
            end
        end
    end


    always @(posedge clk) begin
        if (cache_write) begin
            if (lru[index]==0) begin
                data_1[index] <= write_data;
                tag_1[index] <= tag;
                valid_1[index] <= 1'b1;
            end
      
            else if (lru[index]==1) begin
                data_0[index] <= write_data;
                tag_0[index] <= tag;
                valid_0[index] <= 1'b1;
            end
        end
    end

endmodule