module InstructionMemory #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter ROM_SIZE = 30 // for simulation
)(  
    input wire                      clk,
    input wire [ADDR_WIDTH-1:0]     read_address_i,
    output logic [DATA_WIDTH-1:0]   instruction_o
);

    logic [31:0] mem_rom[0:ROM_SIZE];

    // asynchronous reads
    assign instruction_o = mem_rom[read_address_i / 4];
    
    // load program from memory
    initial begin
        $readmemb("InstructionMemory/multiply_x1_x2.mem",mem_rom);   
    end


endmodule