module Control_unit(
    input [1:0] mode,
    input [3:0] op_code,
    input S,
    output Execute_command,
    output mem_read,mem_write,WB_enable,B,Update_reg
);