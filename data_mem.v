module data_mem(input clk,memWrite,memRead,input [15:0]writeData,Address,output reg [15:0]readData);
reg[15:0] mem[0:127];

initial begin

end

always@(memRead,Address)begin
    if (memRead ==1)
        readData <= mem[Address];
    else
        readData <=16'd0;
end

always@(posedge clk)begin
    if(memWrite==1)
        mem[Address]<=writeData;
end
endmodule