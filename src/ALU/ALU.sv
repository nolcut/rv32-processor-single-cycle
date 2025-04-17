module ALU
(
    input wire [31:0]     a_num_i,
    input wire [31:0]     b_num_i,
    input wire [3:0]      alu_control_op_i,
    output logic [31:0]   c_num_o,
    output logic          zero_o
);

    always_comb begin
        case (alu_control_op_i)
            4'b0000: c_num_o = a_num_i & b_num_i;
            4'b0001: c_num_o = a_num_i | b_num_i;
            4'b0010: c_num_o = a_num_i + b_num_i;
            4'b0110: c_num_o = a_num_i - b_num_i;
            default: c_num_o = 32'bx;
        endcase
        zero_o = (c_num_o == 0);
    end
    
endmodule