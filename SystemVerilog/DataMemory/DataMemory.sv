module DataMemory #(
    parameter ADDR_WIDTH = 12,
    parameter DATA_WIDTH = 32
) (
    input logic                     clk,            
    input logic [ADDR_WIDTH-1:0]    address_i,
    input logic [DATA_WIDTH-1:0]    write_data_i,
    input logic                     MemWrite_i,
    input logic                     MemRead_i,
    input logic [1:0]               size_i,
    output logic [DATA_WIDTH-1:0]   data_read_o
);

    logic signed [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH)-1];
    logic [1:0] segment;
    assign segment = address_i[1:0];

    // asynchronous reads
    always_comb begin
        data_read_o = '0;

        if (MemRead_i) begin
            logic [DATA_WIDTH-1:0] mem_word;
            logic [15:0] halfword;
            logic [7:0] byte_val;

            mem_word = mem[address_i >> 2];

            case (size_i)
                // word access
                2'b10: data_read_o = mem_word;

                // halfword access
                2'b01: begin
                    if (segment[1])
                        halfword = mem_word[31:16];
                    else
                        halfword = mem_word[15:0];

                    data_read_o = {{16{halfword[15]}}, halfword};
                end

                // byte access
                2'b00: begin
                    case (segment)
                        2'b00: byte_val = mem_word[7:0];
                        2'b01: byte_val = mem_word[15:8];
                        2'b10: byte_val = mem_word[23:16];
                        2'b11: byte_val = mem_word[31:24];
                    endcase

                    data_read_o = {{24{byte_val[7]}}, byte_val};
                end
            endcase
        end
    end

    always_ff @(posedge clk) begin
        if (MemWrite_i == 1)
            case (size_i)
                2'b10: mem[address_i >> 2] <= write_data_i;
                2'b01: begin // pick halfword to write
                    if (segment[1]) 
                        mem[address_i >> 2][31:16] <= write_data_i[15:0];
                    else
                        mem[address_i >> 2][15:0] <= write_data_i[15:0];
                end
                2'b00: begin
                    case (segment) // pick byte to write
                        2'b00: mem[address_i >> 2][7:0] <= write_data_i[7:0];
                        2'b01: mem[address_i >> 2][15:8] <= write_data_i[7:0];
                        2'b10: mem[address_i >> 2][23:16] <= write_data_i[7:0];
                        2'b11: mem[address_i >> 2][31:24] <= write_data_i[7:0];
                    endcase
                end
            endcase
    end
endmodule