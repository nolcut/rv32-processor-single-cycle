
module ALU
(
    input signed [31:0]     a_num_i,
    input signed [31:0]     b_num_i,
    input wire [3:0]        alu_control_op_i,
    output logic [31:0]     c_num_o,
    output logic            zero_o,
    output logic            negative_o
);

    always_comb begin
        case (alu_control_op_i)
            4'b0000: c_num_o = a_num_i & b_num_i; // and
            4'b0001: c_num_o = a_num_i | b_num_i; // or
            4'b0010: c_num_o = a_num_i + b_num_i; // add
            4'b0110: c_num_o = a_num_i - b_num_i; // sub
            4'b0011: c_num_o = a_num_i ^ b_num_i; // xor
            4'b0100: c_num_o = a_num_i <<  b_num_i; // shift left
            4'b0101: c_num_o = a_num_i >> b_num_i; // shift right
            4'b0111: c_num_o = a_num_i >>> b_num_i; // shift right signed
            4'b1000: c_num_o = (a_num_i < b_num_i)?1:0;
            default: c_num_o = 32'bx;
        endcase
        // set status signals
        zero_o = c_num_o == 0;
        negative_o = c_num_o[31];
    end
    
endmodule