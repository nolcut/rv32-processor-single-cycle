module DataMemory #(
    parameter ADDR_WIDTH = 8,
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
    always_comb begin
        case (size_i)
            2'b10: data_read_o = mem[address_i >> 2];
            2'b01: begin
                if (segment[1]) 
                    data_read_o = {{16{'0}}, mem[address_i >> 2][15:0]};
                else
                    data_read_o = {{16{'0}}, mem[address_i >> 2][31:16]};
            end
            2'b00: begin
                case (segment)
                    2'b00: data_read_o = {{24{'0}}, mem[address_i >> 2][7:0]};
                    2'b01: data_read_o = {{24{'0}}, mem[address_i >> 2][15:8]};
                    2'b10: data_read_o = {{24{'0}}, mem[address_i >> 2][23:16]};
                    2'b11: data_read_o = {{24{'0}}, mem[address_i >> 2][31:24]};
                endcase
            end
        endcase
    end

    initial begin 
        for (int i = 0; i < 2**ADDR_WIDTH; i++)
            mem[i] = '0;
        mem[0] = 25; // setting input 1 for multiply
        mem[1] = 15; // setting input 2 for multiply
    end

    always_ff @(posedge clk) begin
        if (MemWrite_i == 1)
            case (size_i)
                2'b10: mem[address_i >> 2] <= write_data_i;
                2'b01: begin
                    if (segment[1]) 
                        mem[address_i >> 2][15:0] <= write_data_i[15:0];
                    else
                        mem[address_i >> 2][31:16] <= write_data_i[15:0];
                end
                2'b00: begin
                    case (segment)
                        2'b00: mem[address_i >> 2][7:0] <= write_data_i[7:0];
                        2'b01: mem[address_i >> 2][15:8] <= write_data_i[7:0];
                        2'b10: mem[address_i >> 2][23:16] <= write_data_i[7:0];
                        2'b11: mem[address_i >> 2][31:24] <= write_data_i[7:0];
                    endcase
                end
            endcase
    end

endmodule