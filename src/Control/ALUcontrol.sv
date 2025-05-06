
module ALUcontrol
(
    input wire [1:0] alu_op_i,
    input wire funct7_op_i,
    input wire [2:0] funct3_op_i,
    output logic [3:0] alu_control_op_o
);
    // alu_op 00: always add
    // alu_op 01: always subtract
    // alu_op 10: use funct3 and funct7 to determine operation
    // alu_op 11: use funct3 to determine operation
    always_comb begin
        case (alu_op_i)
            2'b00: alu_control_op_o = 4'b0010; // add
            2'b01: alu_control_op_o = 4'b0110; // sub
            2'b10: begin
                if (funct7_op_i == 1'b1) begin
                    case (funct3_op_i)
                        3'b000: alu_control_op_o = 4'b0110; // sub
                        3'b101: alu_control_op_o = 4'b0111; // shift-right arithmetic (msb extends)
                        default: alu_control_op_o = 4'bx;
                    endcase
                end else begin
                    case (funct3_op_i)
                        3'b000: alu_control_op_o = 4'b0010; // add
                        3'b111: alu_control_op_o = 4'b0000; // and
                        3'b110: alu_control_op_o = 4'b0001; // or
                        3'b100: alu_control_op_o = 4'b0011; // xor
                        3'b001: alu_control_op_o = 4'b0100; // sll
                        3'b101: alu_control_op_o = 4'b0101; // srl
                        3'b010: alu_control_op_o = 4'b1000; // slt
                        3'b011: alu_control_op_o = 4'b1010; // sltu
                        default: alu_control_op_o = 4'bx;
                    endcase
                end
            end
            2'b11: 
                case (funct3_op_i) 
                    3'b000: alu_control_op_o = 4'b0010; // addi
                    3'b100: alu_control_op_o = 4'b0011; // xori
                    3'b110: alu_control_op_o = 4'b0001; // ori
                    3'b111: alu_control_op_o = 4'b0000; // andi
                    3'b001: alu_control_op_o = 4'b0100; // slli
                    3'b010: alu_control_op_o = 4'b1000; //slti
                    3'b101: begin
                        if (funct7_op_i == 1'b1) begin
                            alu_control_op_o = 4'b0111; // srli
                        end else begin
                            alu_control_op_o = 4'b0101; // srai
                        end
                    end
                    3'b011: alu_control_op_o = 4'b1010; // sltui
                endcase
        endcase
    end

endmodule