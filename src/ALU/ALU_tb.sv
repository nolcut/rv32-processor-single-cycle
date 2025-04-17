`timescale 1ns / 1ps

module ALU_tb;

    logic [3:0] alu_control_op_i;
    logic [31:0] a_num_i;
    logic [31:0] b_num_i;
    logic valid;
    wire [31:0] c_num_o;
    wire zero_o;

    ALU uut (
        .alu_control_op_i(alu_control_op_i),
        .a_num_i(a_num_i),
        .b_num_i(b_num_i),
        .c_num_o(c_num_o),
        .zero_o(zero_o)
    );

    // test 1000 combinations of a and b with each control op type
    initial begin
        repeat(1000) begin
            a_num_i = $urandom;
            b_num_i = $urandom;
            alu_control_op_i = 4'b0000;
            #1;
            valid = (c_num_o == (a_num_i & b_num_i));
            #1;
            alu_control_op_i = 4'b0001;
            #1;
            valid = (c_num_o == (a_num_i | b_num_i));
            #1;
            alu_control_op_i = 4'b0010;
            #1;
            valid = (c_num_o == (a_num_i + b_num_i));
            #1;
            alu_control_op_i = 4'b0110;
            #1;
            valid = (c_num_o == (a_num_i - b_num_i));
        end
    end

    // log
    initial begin
        $timeformat(-9, 1, " ns", 8);
        $monitor("time=%t alu_control_op=%b a_num=%b b_num=%b c_num=%2b zero=%b valid=%b", $time, alu_control_op_i, a_num_i, b_num_i, c_num_o, zero_o, valid);
        $dumpfile("ALU_tb.vcd");
        $dumpvars(0, ALU_tb);
    end

endmodule

