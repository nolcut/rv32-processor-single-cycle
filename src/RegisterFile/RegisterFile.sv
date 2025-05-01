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

    logic signed [31:0] registers [0:31]; // x0-x31
    logic [31:0] mstatus, mcause, mepc, mtvec;

    // mcause[31]: interrupt -- mcause[30:0]: exception code
    // mepc: stores program counter after exception occured
    // mtvec[1:0]: mode -- mtvec[31:2] address to jump to when exception occurs
    // mstatus: SD = (XS == 11 or FS == 11 or VS == 11) -- XS, FS, VS always 0, so SD also 0
    // mstatus:
    // asynchronous reads
    assign register_data1_o = registers[register1_addr_i];
    assign register_data2_o = registers[register2_addr_i];
    
    // synchronous writes
    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 32; i++)
                registers[i] <= 0;       
        end else if(RegWrite_i == 1'b1 && write_addr_i != '0) begin
            // by convention x0 should be 0
            registers[write_addr_i] <= write_data_i;
        end
    end

endmodule