module data_mem(input clk,memWrite,memRead,input [31:0]writeData,Address,output reg [31:0]readData);
reg[31:0] mem[0:127];

initial begin

end

always@(memRead,Address)begin
    if (memRead ==1)
        readData <= mem[((Address>>2)<<2)-32'd1024];
end

always@(posedge clk)begin
    if(memWrite==1)
        mem[((Address>>2)<<2)-32'd1024]<=writeData;
end
endmodule