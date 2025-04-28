module ALUcontrol
(
    input wire [1:0] alu_op_i,
    input wire funct7_op_i,
    input wire [2:0] funct3_op_i,
    output logic [3:0] alu_control_op_o
);
    
    always_comb begin
        case (alu_op_i)
            2'b00: alu_control_op_o = 4'b0010;
            2'b01: alu_control_op_o = 4'b0110; 
            2'b10: begin // an ALUOp of 2'b10 indicates an R-type instruction, so funct7 and funct3 are needed to determine ALU action
                if(funct7_op_i == 1'b1) begin
                    alu_control_op_o = 4'b0110;
                end else begin
                    case (funct3_op_i)
                        3'b000: alu_control_op_o = 4'b0010; 
                        3'b111: alu_control_op_o = 4'b0000;
                        3'b110: alu_control_op_o = 4'b0001;
                        default: alu_control_op_o = 4'bx;
                    endcase
                end
            end
            2'b11: alu_control_op_o = 4'b0010;
        endcase
    end

endmodule