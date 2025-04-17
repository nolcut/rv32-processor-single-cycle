module ProgramCounter #(
    parameter DATA_WIDTH = 32
)(
    input wire rst,
    input wire clk,
    input wire [DATA_WIDTH-1:0] next_instruction_i,
    output logic [DATA_WIDTH-1:0] address_o
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            address_o <= 32'b0;
        else
            address_o <= next_instruction_i;
    end

endmodule