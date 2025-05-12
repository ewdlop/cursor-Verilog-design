module control_unit(
    input wire [6:0] opcode,
    output reg reg_write,
    output reg alu_src,
    output reg [2:0] alu_op,
    output reg branch,
    output reg mem_read,
    output reg mem_write
);

    // 操作码定义
    localparam R_TYPE = 7'b0110011;  // 寄存器-寄存器操作
    localparam I_TYPE = 7'b0010011;  // 立即数操作
    localparam LOAD   = 7'b0000011;  // 加载指令
    localparam STORE  = 7'b0100011;  // 存储指令
    localparam BRANCH = 7'b1100011;  // 分支指令

    always @(*) begin
        // 默认值
        reg_write = 1'b0;
        alu_src = 1'b0;
        alu_op = 3'b000;
        branch = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;

        case (opcode)
            R_TYPE: begin
                reg_write = 1'b1;
                alu_src = 1'b0;
            end
            I_TYPE: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
            end
            LOAD: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                mem_read = 1'b1;
            end
            STORE: begin
                alu_src = 1'b1;
                mem_write = 1'b1;
            end
            BRANCH: begin
                branch = 1'b1;
                alu_op = 3'b001;  // 减法操作用于比较
            end
            default: begin
                reg_write = 1'b0;
                alu_src = 1'b0;
                alu_op = 3'b000;
                branch = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
            end
        endcase
    end

endmodule 