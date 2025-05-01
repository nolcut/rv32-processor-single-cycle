module MUX3 #(
    parameter INPUT_WIDTH = 32
)(
    input wire [INPUT_WIDTH - 1:0]      A_i,
    input wire [INPUT_WIDTH - 1:0]      B_i,
    input wire [INPUT_WIDTH - 1:0]      C_i,
    input wire [1:0]                    s_i,
    output logic [INPUT_WIDTH-1:0]      out_o
);

    assign out_o = s_i[1] ? C_i:(s_i[0] ? A_i:B_i); 

endmodule