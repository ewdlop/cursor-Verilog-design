module cpu(
    input wire clk,
    input wire rst,
    input wire [31:0] instruction,
    output wire [31:0] pc,
    output wire [31:0] alu_result,
    output wire mem_write,
    output wire [31:0] mem_data
);

    // 寄存器文件
    reg [31:0] registers [0:31];
    
    // 控制信号
    wire reg_write;
    wire alu_src;
    wire [2:0] alu_op;
    wire branch;
    wire mem_read;
    
    // 数据通路信号
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] immediate;
    wire [31:0] alu_in2;
    
    // 指令解码
    wire [6:0] opcode = instruction[6:0];
    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];
    wire [4:0] rd = instruction[11:7];
    
    // 控制单元实例化
    control_unit ctrl(
        .opcode(opcode),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .branch(branch),
        .mem_read(mem_read),
        .mem_write(mem_write)
    );
    
    // ALU实例化
    alu alu_unit(
        .a(rs1_data),
        .b(alu_in2),
        .op(alu_op),
        .result(alu_result)
    );
    
    // 寄存器文件读取
    assign rs1_data = registers[rs1];
    assign rs2_data = registers[rs2];
    
    // ALU输入选择
    assign alu_in2 = alu_src ? immediate : rs2_data;
    
    // 立即数生成
    immediate_generator imm_gen(
        .instruction(instruction),
        .immediate(immediate)
    );
    
    // 寄存器写回
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (integer i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end else if (reg_write) begin
            registers[rd] <= alu_result;
        end
    end

endmodule 