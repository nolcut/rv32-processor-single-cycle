`timescale 1 ns / 1ps
module beaver32rv_tb;
    logic clk, rst;
    int cycle;

    beaver32rv dut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        cycle = 0;
        rst = 1; 
        #1;
        clk = 1; 
        #1;
        clk = 0; 
        #1;
        rst = 0; 
        #1;
        repeat(1500) begin
            cycle += 1;
            clk = ~clk; #1;
            clk = ~clk; #1;
        end
    end

    initial begin 
        $timeformat(-9, 1, " ns", 8);
        $monitor(
            "===============================================================================================================================================\n\n",
            " pc_addr=%d next_address=%d  cycle=%d\n",
            dut.pc_addr, dut.next_address, cycle,
            " --------------------------------------------------------------------------------------------------------------------------------------------\n",
            "| instruction=  %b | reg_data_w=  %b | JALR=%b     LUI=%b  auipc=%b  rst=%b   clk=%b  |\n",
            dut.instruction, dut.write_data, dut.JALR, dut.LUI, dut.auipc, dut.rst, clk,
            "| immediate=    %b | mem_read=    %b | MemtoReg=%b Jump=%b Branch=%b BranchTaken=%b  |\n", 
            dut.immediate, dut.read_data, dut.MemtoReg, dut.Jump, dut.Branch, dut.Taken,
            "| rs1=          %b | rs2=         %b | Zero=%b     ALUOp=%b  ALU_control_op= %b |\n",
            dut.register_data1, dut.register_data2, dut.Zero, dut.ALUOp, dut.ALU_control_op,
            "| ALU_in1=      %b | ALU_in2=     %b | ALU_out= %b |\n",
            dut.ALU_IN1, dut.ALU_IN2, dut.ALU_OUT,
            "write_mem=%d segment=%b\n",
            dut.MemWrite, dut.data_mem.segment,
            " --------------------------------------------------------------------------------------------------------------------------------------------\n",
            " ---------------------------------------------------------------------------- \n",
            "| reg_write_addr=%d RegWrite=%b                                               |\n",
            dut.instruction[11:7], dut.RegWrite,
            "| x0= %d  x1=%d  x2=%d  x3=%d  x4=%d |\n",
            dut.rf.registers[0], dut.rf.registers[1], dut.rf.registers[2], dut.rf.registers[3], dut.rf.registers[4],
            "| x5= %d  x6=%d  x7=%d  x8=%d  x9=%d |\n",
            dut.rf.registers[5], dut.rf.registers[6], dut.rf.registers[7], dut.rf.registers[8], dut.rf.registers[9],
            "| x10=%d x11=%d x12=%d x13=%d x14=%d |\n",
            dut.rf.registers[10], dut.rf.registers[11], dut.rf.registers[12], dut.rf.registers[13], dut.rf.registers[14],
            "| x15=%d x16=%d x17=%d x18=%d x19=%d |\n",
            dut.rf.registers[15], dut.rf.registers[16], dut.rf.registers[17], dut.rf.registers[18], dut.rf.registers[19],
            "| x20=%d x21=%d x22=%d x23=%d x24=%d |\n",
            dut.rf.registers[20], dut.rf.registers[21], dut.rf.registers[22], dut.rf.registers[23], dut.rf.registers[24],
            "| x25=%d x26=%d x27=%d x28=%d x29=%d |\n",
            dut.rf.registers[25], dut.rf.registers[26], dut.rf.registers[27], dut.rf.registers[28], dut.rf.registers[29],
            "| x30=%d x31=%d                                              |\n",
            dut.rf.registers[30], dut.rf.registers[31],
            " ---------------------------------------------------------------------------- \n",
            " -------------------------------------------------------------------------------------------------------------------- \n",
            "| data_mem[0]=%d data_mem[1]=%d data_mem[2]=%d data_mem[3]=%d data_mem[4]=%d |\n",
            dut.data_mem.mem[0], dut.data_mem.mem[1], dut.data_mem.mem[2], dut.data_mem.mem[3], dut.data_mem.mem[4],
            "| data_mem[5]=%d data_mem[6]=%d data_mem[7]=%d data_mem[8]=%d data_mem[9]=%d |\n",
            dut.data_mem.mem[5], dut.data_mem.mem[6], dut.data_mem.mem[7], dut.data_mem.mem[8], dut.data_mem.mem[9],
            " -------------------------------------------------------------------------------------------------------------------- \n\n"
        );
        $dumpfile("beaver32rv_tb.vcd");
        $dumpvars(0, beaver32rv_tb);
    end
endmodule
