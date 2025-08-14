
module ALU
(
    input signed [31:0]     a_num_i,
    input signed [31:0]     b_num_i,
    input wire [3:0]        alu_control_op_i,
    output logic [31:0]     c_num_o,
    output logic            zero_o,
    output logic            negative_o
);

    localparam [3:0]
        ALU_AND  = 4'b0000,
        ALU_OR   = 4'b0001,
        ALU_ADD  = 4'b0010,
        ALU_SUB  = 4'b0110,
        ALU_XOR  = 4'b0011,
        ALU_SLL  = 4'b0100,
        ALU_SRL  = 4'b0101,
        ALU_SRA  = 4'b0111,
        ALU_SLT  = 4'b1000,
    ALU_SLTU = 4'b1010;


    always_comb begin
        case (alu_control_op_i)
            ALU_AND: c_num_o = a_num_i & b_num_i; // and
            ALU_OR: c_num_o = a_num_i | b_num_i; // or
            ALU_ADD: c_num_o = a_num_i + b_num_i; // add
            ALU_SUB: c_num_o = a_num_i - b_num_i; // sub
            ALU_XOR: c_num_o = a_num_i ^ b_num_i; // xor
            ALU_SLL: c_num_o = a_num_i <<  b_num_i[4:0]; // shift left
            ALU_SRL: c_num_o = a_num_i >> b_num_i[4:0]; // shift right
            ALU_SRA: c_num_o = a_num_i >>> b_num_i[4:0]; // shift right signed
            ALU_SLT: c_num_o = (a_num_i < b_num_i)?1:0; // slt
            ALU_SLTU: c_num_o = ($unsigned(a_num_i) < $unsigned(b_num_i))?1:0; // sltu
            default: c_num_o = 32'bx;
        endcase
        // set status signals
        zero_o = c_num_o == 0;
        negative_o = c_num_o[31];
    end
    
endmodule