module inst_mem(input [31:0]Address,output reg [31:0]inst);
reg [31:0] mem[0:1023];

initial begin
    
    mem[0]=32'b000000_00001_00010_00000_00000000000;//addi R1 R0 40
    mem[1]=32'b000000_00011_00100_00000_00000000000;//addi R5 R0 0
    mem[2]=32'b000000_00101_00110_00000_00000000000;//beq R1 R0 END //LOOP
    mem[3]=32'b000000_00111_01000_00010_00000000000;//lw  R4 996(R1)
    mem[4]=32'b000000_01001_01010_00011_00000000000;//add R5 R4 R5
    mem[5]=32'b000000_01011_01100_00000_00000000000;//addi R1 R1 -4
    mem[6]=32'b000000_01101_01110_00000_00000000000;//J LOOP
end

always @(Address) begin
    inst<=mem[Address[31:2]];
end
endmodule