module RegisterFile #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32
)(
    input wire rst,
    input wire clk,
    input wire RegWrite_i,
    input wire [ADDR_WIDTH-1:0] register1_i,
    input wire [ADDR_WIDTH-1:0] register2_i,
    input wire [DATA_WIDTH-1:0] WriteData_i,
    output reg [DATA_WIDTH-1:0] data1_o,
    output reg [DATA_WIDTH-1:0] data2_o
); 

    logic [31:0] registers [0:31];

    // asynchronous reads
    assign data1_o = registers[register1_i];
    assign data2_o = registers[register2_i];
    
    // synchronous writes
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 32; i++)
                registers[i] = 32'b0;       
        end else if(RegWrite_i == 1'b1 && register1_i != '0) begin
            // by convention x0 should be 0
            registers[register1_i] <= WriteData_i;
        end
    end

endmodule