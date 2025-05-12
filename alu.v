module alu(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [2:0] op,
    output reg [31:0] result
);

    // ALU操作码定义
    localparam ADD  = 3'b000;
    localparam SUB  = 3'b001;
    localparam AND  = 3'b010;
    localparam OR   = 3'b011;
    localparam XOR  = 3'b100;
    localparam SLT  = 3'b101;
    localparam SLTU = 3'b110;

    always @(*) begin
        case (op)
            ADD:  result = a + b;
            SUB:  result = a - b;
            AND:  result = a & b;
            OR:   result = a | b;
            XOR:  result = a ^ b;
            SLT:  result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
            SLTU: result = (a < b) ? 32'b1 : 32'b0;
            default: result = 32'b0;
        endcase
    end

endmodule 