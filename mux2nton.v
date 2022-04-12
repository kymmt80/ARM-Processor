module mux2nton#(parameter N=32)(input[N-1:0]a,b,input s,output [N-1:0]o);
	assign o=(s==0)?a:
		(s==1)?b:1'bx;
endmodule