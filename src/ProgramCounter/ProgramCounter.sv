module ProgramCounter #(
    parameter MEM_SIZE = 32
)(
    input wire rst,
    input wire clk,
    input wire [MEM_SIZE-1:0] curr_instruction_i,
    output logic [MEM_SIZE-1:0] next_instruction_o
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            next_instruction_o <= 32'b0;
        else
            next_instruction_o <= curr_instruction_i;
    end

endmodule