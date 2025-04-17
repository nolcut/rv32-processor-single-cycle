module beaver32rv (
    input wire clk,
    input wire rst
);
    logic Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Zero;
    logic [3:0] ALU_control_op;
    logic [1:0] ALUOp;
    logic [31:0] register_data1, register_data2, immediate, read_data;
    logic [31:0] write_data, next_instruction, pc_addr, ALU_IN2, ALU_OUT, instruction;
    
    ProgramCounter pc (
        .rst(rst),
        .clk(clk), 
        .next_instruction_i(next_instruction), 
        .address_o(pc_addr)
        );
    
    InstructionMemory program_mem (
        .clk(clk),
        .read_address_i(pc_addr),
        .instruction_o(instruction)
    );

    ALUcontrol alu_control (
        .alu_op_i(ALUOp),
        .funct7_op_i(instruction[30]),
        .funct3_op_i(instruction[14:12]),
        .alu_control_op_o(ALU_control_op)
    );

    RegisterFile rf (
        .clk(clk),
        .rst(rst),
        .register1_addr_i(instruction[19:15]),
        .register2_addr_i(instruction[24:20]),
        .write_addr_i(instruction[11:7]),
        .write_data_i(write_data),
        .RegWrite_i(RegWrite),
        .register_data1_o(register_data1),
        .register_data2_o(register_data2)
    );

    MUX2 select_ALU_IN2 (
        .A_i(immediate),
        .B_i(register_data2),
        .s_i(ALUSrc),
        .C_o(ALU_IN2)
    );

    ALU ALU1 (
        .a_num_i(register_data1),
        .b_num_i(ALU_IN2),
        .alu_control_op_i(ALU_control_op),
        .c_num_o(ALU_OUT),
        .zero_o(Zero)
    );

    MUX2 select_next_instruction (
        .A_i(instruction + immediate),
        .B_i(instruction + 4),
        .s_i(Branch && Zero),
        .C_o(next_instruction)
    );

    DataMemory data_mem (
        .clk(clk),
        .address_i(ALU_OUT),
        .write_data_i(register_data2),
        .MemWrite_i(MemWrite),
        .MemRead_i(MemRead),
        .data_read_o(read_data)
    );

    MUX2 select_reg_write_data (
        .A_i(read_data),
        .B_i(ALU_OUT),
        .s_i(MemtoReg),
        .C_o(write_data)
    );

endmodule