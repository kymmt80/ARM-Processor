module testbench();
reg clk=0,rst=0;
topLevel tl(.clk(clk),.rst(rst),.mode(1'd0));
always#5 clk=~clk;
initial begin
    #0 rst=1;
    #10 rst=0;
end
endmodule