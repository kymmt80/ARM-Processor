module ALU(
    input carry,
    input[3:0] EXE_CMD,
    input[31:0]Val1,Val2,
    output reg[31:0]ALU_res 
);
always@(*)begin
    case(EXE_CMD)begin
        4'd1: ALU_res=Val2;
        4'd9: ALU_res=~Val2;
        4'd2: ALU_res=Val1+Val2;
        4'd3: ALU_res=Val1+Val2+carry;
        4'd4: ALU_res=Val1-Val2;
        4'd5: ALU_res=Val1-Val2-(~carry);
        4'd6: ALU_res=Val1&Val2;
        4'd7: ALU_res=Val1|Val2;
        4'd8: ALU_res=Val1^Val2;
    end
end
