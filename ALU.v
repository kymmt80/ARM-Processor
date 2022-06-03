module ALU(
    input carry,
    input[3:0] EXE_CMD,
    input[31:0]Val1,Val2,
    output reg[31:0]ALU_res,
    output reg[3:0]status
);

reg carry1,ncarry;

always@(*)begin
    ALU_res=32'd0;
    carry1=1'b0;
    ncarry=~carry;
    case(EXE_CMD)
        4'd1: ALU_res=Val2;
        4'd9: ALU_res=~Val2;
        4'd2: {carry1,ALU_res}=Val1+Val2;
        4'd3: {carry1,ALU_res}=Val1+Val2+carry;
        4'd4: ALU_res=Val1-Val2;
        4'd5: ALU_res=Val1-Val2-(ncarry);
        4'd6: ALU_res=Val1&Val2;
        4'd7: ALU_res=Val1|Val2;
        4'd8: ALU_res=Val1^Val2;
    endcase
end

always@(ALU_res)begin
    status=4'd0;
    status[0] = ((EXE_CMD==4'd2|EXE_CMD==4'd3)&((ALU_res[31]&~Val1[31]&~Val2[31])|(~ALU_res[31]&Val1[31]&Val2[31])))|((EXE_CMD==4'd4|EXE_CMD==4'd5)&((ALU_res[31]&~Val1[31]&Val2[31])|(~ALU_res[31]&Val1[31]&~Val2[31])));
    status[1] = carry1;
    status[2] = ~(|ALU_res);
    status[3] = ALU_res[31];
end

endmodule