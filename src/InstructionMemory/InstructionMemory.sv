module InstructionMemory #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter PROGRAM_LENGTH = 10
)(  
    input wire                      clk,
    input wire [ADDR_WIDTH-1:0]     read_address_i,
    output logic [DATA_WIDTH-1:0]   instruction_o
);

    logic [31:0] mem_rom[0:PROGRAM_LENGTH-1];
    
    // load program from memory
    initial begin
        $readmemb("src/InstructionMemory/program.mem",mem_rom);
    end

    // synchronously update current instruction
    always_ff @(posedge clk) begin
        instruction_o <= mem_rom[read_address_i];
    end

endmodule