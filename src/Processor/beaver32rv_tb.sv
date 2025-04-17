`timescale 1 ns / 1ps
module beaver32rv_tb;
    logic clk, rst;

    beaver32rv processor (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        repeat(18) begin
            clk = 1;
            #1
            clk = 0;
        end
    end

    initial begin 
        $timeformat(-9, 1, " ns", 8);
        $monitor("time=%t clk=%d", $time, clk);
    end
endmodule