module MUX2 #(
    parameter INPUT_WIDTH = 32
)(
    input wire [INPUT_WIDTH - 1:0]      A_i,
    input wire [INPUT_WIDTH - 1:0]      B_i,
    input wire                          s_i,
    output logic [INPUT_WIDTH-1:0]      C_o
);

    assign C_o = s_i ? A_i:B_i; 

endmodule