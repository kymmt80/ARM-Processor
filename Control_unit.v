module Control_unit(
    input [1:0] mode,
    input [3:0] op_code,
    input S,
    output reg [3:0] Execute_command,
    output reg mem_read,mem_write,WB_enable,B,Update_SR
);
parameter [3:0] 
    MOV=4'b1101,MVN=4'b1111, ADD=4'b0100,ADC=4'b0101,SUB=4'b0101, SBC =4'b0110, AND=4'b0000, ORR=4'b1100, EOR=4'b0001, CMP=4'b1010, TST=4'b1000, LDR_STR=4'b0100;
parameter [1:0]
    COMPUTE=2'b00, MEMORY=2'b01, BRANCH=2'b10;
always@(op_code,mode)begin
    {Execute_command,mem_read,mem_write,WB_enable,B,Update_SR}=9'b0000_00000;
    case(mode)begin
        Update_SR = S;
        COMPUTE:begin
            case(op_code)begin
                MOV:begin
                    Execute_command = 4'b0001;
                    WB_enable = 1'b1;
                end
                MVN:begin
                    Execute_command = 4'b1001;
                    WB_enable = 1'b1;
                end
                ADD:begin
                    Execute_command = 4'b0010;
                    WB_enable = 1'b1;
                end
                SUB:begin
                    Execute_command = 4'b0100;
                    WB_enable = 1'b1;
                end
                SBC:begin
                    Execute_command = 4'b0101;
                    WB_enable = 1'b1;
                end
                AND:begin
                    Execute_command = 4'b0110;
                    WB_enable = 1'b1;
                end
                ORR:begin
                    Execute_command = 4'b0111;
                    WB_enable = 1'b1;
                end
                EOR:begin
                    Execute_command = 4'b1000;
                    WB_enable = 1'b1;
                end
                CMP:begin
                    Execute_command = 4'b0100;
                end
                TST:begin
                    Execute_command = 4'b0110;
                end
                
        end

        MEMORY:begin
                LDR_STR:begin
                    Execute_command = 4'b0010;
                    mem_read = S;
                    mem_write = ~S;
                    WB_enable = S;
                end
        end

        BRANCH:begin
           B=1'b1;
        end
    end
end
endmodule