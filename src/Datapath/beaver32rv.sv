
module beaver32rv #(
     parameter MEM_WIDTH = 8
)(
    input wire clk,
    input wire rst
);
        logic MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Branch, Zero, Negative, Taken, Jump, JALR, LUI, auipc;
        logic [1:0] ALUOp, size;
        logic [2:0] funct3;
        logic [3:0] ALU_control_op;
        logic [4:0] rs1, rs2, rd;
        logic [6:0] opcode;
        logic [31:0] next_address, pc_addr, instruction;
        logic [31:0] register_data1, register_data2, immediate, read_data, read_data_shifted, ALU_IN1, ALU_IN2, ALU_OUT, branch_target_base, write_data;
        // get register/opcode info
        assign rs1 = instruction[19:15];
        assign rs2 = instruction[24:20];
        assign rd = instruction[11:7];
        assign funct3 = instruction[14:12];
        assign opcode = instruction[6:0];
        assign size = {funct3 == 3'b010, funct3 == 3'b001}; // word: 11 halfword: 01 byte: 00 -- used for byte/hw meme accesses

    ProgramCounter pc (
        .rst(rst),
        .clk(clk), 
        .next_address_i(next_address), 
        .address_o(pc_addr)
        );
    
    InstructionMemory program_mem (
        .clk(clk),
        .read_address_i(pc_addr),
        .instruction_o(instruction)
    );

    Controller control (
        .opcode_i(instruction[6:0]),
        .Branch_o(Branch),
        .Jump_o(Jump),
        .JALR_o(JALR),
        .LUI_o(LUI),
        .auipc_o(auipc),
        .MemRead_o(MemRead),
        .MemtoReg_o(MemtoReg),
        .ALU_op_o(ALUOp),
        .MemWrite_o(MemWrite),
        .ALUSrc_o(ALUSrc),
        .RegWrite_o(RegWrite)
    );

    // figure out if branch is taken
    TakeBranch branch_control (
        .negative_i(Negative),
        .zero_i(Zero),
        .funct3_i(funct3),
        .branch_i(Branch),
        .taken_o(Taken)
    );
    
    ALUcontrol alu_control (
        .alu_op_i(ALUOp),
        .funct7_op_i(instruction[30]),
        .funct3_op_i(funct3),
        .alu_control_op_o(ALU_control_op)
    );

    ImmGen imm_gen (
        .instruction_i(instruction),
        .immediate_o(immediate)
    );

    RegisterFile rf (
        .clk(clk),
        .rst(rst),
        .register1_addr_i(rs1),
        .register2_addr_i(rs2),
        .write_addr_i(rd),
        .write_data_i(write_data),
        .RegWrite_i(RegWrite),
        .register_data1_o(register_data1),
        .register_data2_o(register_data2)
    );

    MUX3 select_ALU_IN1 (
        .A_i(32'b0),
        .B_i(register_data1),
        .C_i(pc_addr),
        .s_i({auipc, LUI}),
        .out_o(ALU_IN1)
    );

    MUX2 select_ALU_IN2 (
        .A_i(immediate),
        .B_i(register_data2),
        .s_i(ALUSrc),
        .out_o(ALU_IN2)
    );

    ALU ALU1 (
        .a_num_i(ALU_IN1),
        .b_num_i(ALU_IN2),
        .alu_control_op_i(ALU_control_op),
        .c_num_o(ALU_OUT),
        .zero_o(Zero),
        .negative_o(Negative)
    );

    MUX2 branch_target (
        .A_i(register_data1),
        .B_i(pc_addr),
        .s_i(JALR),
        .out_o(branch_target_base)
    );

    MUX3 select_next_instruction (
        .A_i(branch_target_base + immediate),
        .B_i(pc_addr + 4),
        .s_i(Taken || Jump),
        .out_o(next_address)
    );

    DataMemory data_mem (
        .clk(clk),
        .address_i(ALU_OUT[MEM_WIDTH-1:0]),
        .write_data_i(register_data2),
        .MemWrite_i(MemWrite),
        .MemRead_i(MemRead),
        .size_i(size),
        .data_read_o(read_data)
    );

    MUX3 select_reg_write_data (
        .A_i(read_data),
        .B_i(ALU_OUT),
        .C_i(pc_addr + 4),
        .s_i({Jump || JALR, MemtoReg}),
        .out_o(write_data)
    );

endmodule