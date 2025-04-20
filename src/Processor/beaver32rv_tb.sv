`timescale 1 ns / 1ps
module beaver32rv_tb;
    logic clk, rst;

    beaver32rv dut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        rst = 1;
        #1
        clk = 1;
        #1
        clk = 0;
        #1
        rst = 0;
        #1
        repeat(18) begin
            clk = 1;
            #1;
            clk = 0;
            #1;
        end
    end

    logic BranchTaken;
    assign BranchTaken = dut.Zero && dut.Branch;

    initial begin 
        $timeformat(-9, 1, " ns", 8);
        $monitor(
            "time=%t clk=%d ALUOp=%b rst=%b pc_rst=%b\npc_addr=%d zero=%b branch=%b BranchTaken=%b ALU_out=%b reg_write_data=%b\n reg_write_addr=%b RegWrite=%b instruction=%b\nimmediate=%b MemtoReg=%b DataRead=%b\n x0=%d x1=%d x2=%d x3=%d x4=%d\n", 
            $time, clk, dut.ALUOp, dut.rst, dut.pc.rst, dut.pc_addr, dut.Zero, dut.Branch, BranchTaken, dut.ALU_OUT[6:0], dut.write_data, dut.instruction[11:7], dut.RegWrite, dut.instruction, dut.immediate, dut.MemtoReg, dut.read_data, dut.rf.registers[0], dut.rf.registers[1], dut.rf.registers[2], dut.rf.registers[3], dut.rf.registers[4]
        );
        $dumpfile("beaver32rv_tb.vcd");
        $dumpvars(0, beaver32rv_tb);
    end
endmodule