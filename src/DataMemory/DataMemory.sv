module DataMemory #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32
) (
    input logic                     clk,            
    input logic [ADDR_WIDTH-1:0]    address_i,
    input logic [DATA_WIDTH-1:0]    write_data_i,
    input logic                     MemWrite_i,
    input logic                     MemRead_i,
    output logic [DATA_WIDTH-1:0]   data_read_o
);

    logic signed [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH)-1];

    assign data_read_o = mem[address_i / 4];

    initial begin 
        for (int i = 0; i < 2**ADDR_WIDTH; i++)
            mem[i] = DATA_WIDTH'(i) * 4;
        mem[0] = 410; // setting input 1 for multiply
        mem[1] = 236; // setting input 2 for multiply
    end

    always_ff @(posedge clk) begin
        if (MemWrite_i == 1)
            mem[address_i] <= write_data_i;
    end

endmodule