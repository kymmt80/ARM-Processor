module Val2Generator(
    input MEM_CMD,imm,
    input [11:0]Shift_operand,
    input [31:0]Val_Rm,
    output reg[31:0]Val_2);

always@(Shift_operand, imm, Val_Rm)begin
    if(MEM_CMD==1'b1)
        Val_2 = Shift_operand;
    else begin
        case(imm)
            1'b1:begin
                Val_2 = {Shift_operand[7:0],24'd0}>>(Shift_operand[11:8]);
                Val_2 = Val_2>>(Shift_operand[11:8]);
                Val_2 = {Val_2[23:0],Val_2[31:24]};
            end
            1'b0:begin
                case(Shift_operand[6:5])
                    2'b00: Val_2 = Val_Rm<<Shift_operand[11:7];
                    2'b01: Val_2 = Val_Rm>>Shift_operand[11:7];
                    2'b10: Val_2 = Val_Rm>>>Shift_operand[11:7];
                    2'b11: Val_2 = {Val_Rm,Val_Rm}>>Shift_operand[11:7];
                endcase
            end

        endcase
    end
end

endmodule
