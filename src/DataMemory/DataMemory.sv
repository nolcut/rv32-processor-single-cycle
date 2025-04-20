module DataMemory #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32
) (
    input logic                     clk,
    input logic                     rst,                 
    input logic [ADDR_WIDTH-1:0]    address_i,
    input logic [DATA_WIDTH-1:0]    write_data_i,
    input logic                     MemWrite_i,
    input logic                     MemRead_i,
    output logic [DATA_WIDTH-1:0]   data_read_o
);

// to-do: implement data memory
    logic [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH)-1];

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
        for (int i = 0; i < 2**ADDR_WIDTH - 1; i++)
            mem[i] <= i;
        data_read_o <= '0;
        end else begin
            if (MemWrite_i == 1)
                mem[address_i] <= write_data_i;
            if (MemRead_i == 1)
                data_read_o <= mem[address_i];
        end
    end

endmodule