module MUX2 #(
    parameter INPUT_WIDTH = 32
)(
    input wire [INPUT_WIDTH - 1:0]      a_i,
    input wire [INPUT_WIDTH - 1:0]      b_i,
    input wire                          s_i,
    output logic [INPUT_WIDTH-1:0]      c_o
);

    assign c_o = s_i ? a_i:b_i; 

endmodule