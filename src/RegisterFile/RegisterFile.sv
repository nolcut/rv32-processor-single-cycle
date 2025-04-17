module RegisterFile #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32
)(
    input wire rst,
    input wire clk,
    input wire RegWrite_i,
    input wire [ADDR_WIDTH-1:0] register1_addr_i,
    input wire [ADDR_WIDTH-1:0] register2_addr_i,
    input wire [ADDR_WIDTH-1:0] write_addr_i,
    input wire [DATA_WIDTH-1:0] write_data_i,
    output reg [DATA_WIDTH-1:0] register_data1_o,
    output reg [DATA_WIDTH-1:0] register_data2_o
); 

    logic [31:0] registers [0:31];

    // asynchronous reads
    assign register_data1_o = registers[register1_addr_i];
    assign register_data2_o = registers[register2_addr_i];
    
    // synchronous writes
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 32; i++)
                registers[i] = 32'b0;       
        end else if(RegWrite_i == 1'b1 && register1_addr_i != '0) begin
            // by convention x0 should be 0
            registers[write_addr_i] <= write_data_i;
        end
    end

endmodule