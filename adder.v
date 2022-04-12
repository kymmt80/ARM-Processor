module adder #(parameter N=32)(input [N-1:0]a,input [N-1:0]b,output[N-1:0]res);
	assign res=a+b;
endmodule