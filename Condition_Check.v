module Condition_Check(
    input[3:0] Cond,
    input[3:0] SR,
    output reg check_output);
//SR={N,Z,C,V}
parameter[1:0] 
    N_=2'd3,Z_=2'd2,C_=2'd1,V_=2'd0;    
always @(Cond,SR) begin
    case(Cond)begin
        4'd0: check_output=SR[Z_];
        4'd1: check_output=~SR[Z_];
        4'd2: check_output=SR[C_];
        4'd3: check_output=~SR[C_];
        4'd4: check_output=SR[N_];
        4'd5: check_output=~SR[N_];
        4'd6: check_output=SR[v_];
        4'd7: check_output=~SR[V_];
        4'd8: check_output=SR[C_]&~SR[Z_];
        4'd9: check_output=~SR[C_]|SR[Z_];
        4'd10: check_output=(SR[N_]==SR[V_])?1'b1:1'b0;
        4'd11: check_output=(SR[N_]==SR[V_])?1'b0:1'b1;
        4'd12: check_output=~SR[Z_]&((SR[N_]==SR[V_])?1'b1:1'b0);
        4'd13: check_output=SR[Z_]|((SR[N_]==SR[V_])?1'b1:1'b0);
        4'd14: check_output=1'b1;
        4'd15: check_output=1'b0;
    end
end
endmodule