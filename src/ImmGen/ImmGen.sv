module ImmGen 
(
    input wire [31:0]   instruction_i,
    output logic [31:0] immediate_o
);

    always_comb begin
        case (instruction_i[6:0])
            7'b0010011, 7'b0000011, 7'b1100111, 7'b1110011: immediate_o = {{21{instruction_i[31]}}, instruction_i[30:20]}; // i-instruction (not implemented)
            7'b0100011: immediate_o = {{21{instruction_i[31]}}, instruction_i[30:25], instruction_i[11:7]}; // s-instruction 
            7'b1100011: immediate_o = {{20{instruction_i[31]}}, instruction_i[7], instruction_i[30:25], instruction_i[11:8], 1'b0}; // sb-instruction
            7'b1101111: immediate_o = {{12{instruction_i[31]}}, instruction_i[19:12], instruction_i[20], instruction_i[30:25], instruction_i[11:8], 1'b0}; // uj-instruction (not implemented)
            7'b0110111, 7'b0010111: immediate_o = {instruction_i[31:20], instruction_i[19:12], {12{1'b0}}}; // u-instruction (not implemented yet)
            default: immediate_o = 32'bx;
        endcase
    end

endmodule