module DataMemory #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input logic                     clk,                 
    input logic [ADDR_WIDTH-1:0]    address_i,
    input logic [DATA_WIDTH-1:0]    write_data_i,
    input logic                     MemWrite_i,
    input logic                     MemRead_i,
    output logic [DATA_WIDTH-1:0]   data_read_o
);

// to-do: implement data memory
    logic [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH)-1];

    initial begin
        for (int i = 0; i < 2**DATA_WIDTH; i++)
            mem[i] = i;
        data_read_o = 'bx;
    end

    always_ff @(posedge clk) begin
        if (MemWrite_i == 1)
            mem[address_i] <= write_data_i;
        if (MemRead_i == 1)
            data_read_o <= mem[address_i];
    end

endmodule