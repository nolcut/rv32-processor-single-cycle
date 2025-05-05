
module TakeBranch (
        input  logic            negative_i,
        input  logic            zero_i,
        input  logic            branch_i,
        input  logic [2:0]      funct3_i,
        output logic            taken_o
);
    always_comb begin
        case (funct3_i)
            3'b000: taken_o = zero_i && branch_i; // beq
            3'b001: taken_o = ~(zero_i) && branch_i; // bne
            3'b100: taken_o = negative_i && branch_i; // blt
            3'b101: taken_o = ~(negative_i) && branch_i; // bge
            default: taken_o = '0;
        endcase
    end

endmodule