module register#(parameter N=32)(input clk,ld,rst,input [N-1:0]Qin,output [N-1:0]Q);
	reg [N-1:0]q1;
	always@(posedge clk,posedge rst)begin
		if(rst)q1<=0;
		else 
			if(ld)q1<=Qin;

	end
	assign Q=q1;
endmodule