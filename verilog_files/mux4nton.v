module mux4nton#(parameter N=32)(input[N-1:0]a,b,c,d,input[1:0] s,output [N-1:0]o);
	assign o=(s==2'd0)?a:
		(s==2'd1)?b:
        (s==2'd2)?c:
        (s==2'd3)?d:1'bx;
endmodule