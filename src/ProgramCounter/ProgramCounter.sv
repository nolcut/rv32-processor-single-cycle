module ProgramCounter #(
    parameter DATA_WIDTH = 32
)(
    input wire rst,
    input wire clk,
    input wire [DATA_WIDTH-1:0] next_address_i,
    output logic [DATA_WIDTH-1:0] address_o
);

    always_ff @(negedge clk) begin
        if (rst)
            address_o <= 32'b0;
        else
            address_o <= next_address_i;
    end

endmodule