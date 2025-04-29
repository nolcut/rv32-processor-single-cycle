module Controller 
(
       input wire [6:0]     opcode_i,
       output logic [1:0]   ALU_op_o,
       output logic         Branch_o,
       output logic         MemWrite_o,
       output logic         MemRead_o,
       output logic         RegWrite_o,
       output logic         MemtoReg_o,
       output logic         ALUSrc_o
);
    logic [7:0] controls;
    assign {ALUSrc_o, MemtoReg_o, RegWrite_o, MemRead_o, MemWrite_o, Branch_o, ALU_op_o[1], ALU_op_o[0]} = controls;
    // I did not simplify the truth table mapping opcode controls because I plan to implement more instructions later on
    always_comb begin
        case (opcode_i)
            7'b0110011: controls = 8'b00100010; // R-format (alu op: 10)
            7'b0010011: controls = 8'b10100011; // I-type (alu op: 11)
            7'b0000011: controls = 8'b11110000; // lw-format (alu op: 00)
            7'b0100011: controls = 8'b1x001000; // sw-format (alu op: 00)
            7'b1100011: controls = 8'b0x000101; // branch-format (alu op: 01)
            default: controls = 8'bx;
        endcase
    end

endmodule