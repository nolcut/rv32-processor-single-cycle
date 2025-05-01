
module Controller 
(
       input wire [6:0]     opcode_i,
       output logic [1:0]   ALU_op_o,
       output logic         Branch_o,
       output logic         Jump_o,
       output logic         JALR_o,
       output logic         LUI_o,
       output logic         auipc_o,
       output logic         MemWrite_o,
       output logic         MemRead_o,
       output logic         RegWrite_o,
       output logic         MemtoReg_o,
       output logic         ALUSrc_o
);
    logic [11:0] controls;
    assign {ALUSrc_o, MemtoReg_o, RegWrite_o, MemRead_o, MemWrite_o, Branch_o, Jump_o, JALR_o, LUI_o, auipc_o, ALU_op_o[1], ALU_op_o[0]} = controls;
    // I did not simplify the truth table mapping opcode controls because I plan to implement more instructions later on
    always_comb begin
        case (opcode_i)
            7'b0110011: controls = 12'b001000000010; // R-format
            7'b0010011: controls = 12'b101000000011; // I-type 
            7'b0000011: controls = 12'b111100000000; // load-format 
            7'b0100011: controls = 12'b100010000000; // store-format
            7'b1100011: controls = 12'b000001000001; // branch-format
            7'b1101111: controls = 12'b101000100000; // uj-format 
            7'b1100111: controls = 12'b001000010000; // jalr-format
            7'b0110111: controls = 12'b101000001000; // lui (need to test)
            7'b0010111: controls = 12'b101000000100; // auipc (need to test)
            default: controls = 12'bx;
        endcase
    end

endmodule