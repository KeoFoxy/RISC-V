`include "defines_riscv.v"
`timescale 1ns / 1ps
`define ADD 5'b00000
`define SUB 5'b01000
`define SLL 5'b00001
`define SLT 5'b00010
`define SLTU 5'b00011
`define XOR 5'b00100
`define SRL 5'b00101
`define SRA 5'b01101
`define OR 5'b00110
`define AND 5'b00111
`define BEQ 5'b11000
`define BNE 5'b11001
`define BLT 5'b11100
`define BGE 5'b11101
`define BLTU 5'b11110
`define BGEU 5'b11111

module alu(A, B, ALUOp, flag, result);

    parameter BITWIDTH=32;
    parameter OPERATORWIDTH=5;
      
    input [OPERATORWIDTH-1:0] ALUOp;
    input [BITWIDTH-1:0] A;
    input [BITWIDTH-1:0] B;
    output reg [BITWIDTH-1:0] result;
    output reg flag ;

initial
begin
flag = 0;
result = 32'b0;
end
    

always @(*) begin
case(ALUOp)
    `ADD: begin
        result = A + B;
        flag = 0;
    end    
    `ADD: begin
        result = A + B;
        flag = 0;
    end
    `SUB: begin
        result = A - B;
        flag = 0;
    end
    `SLL: begin
        result = A << B;
        flag = 0;
    end
    `SLT: begin
        result = ($signed(A) < $signed(B)) ? 1 : 0;
        flag = 0;
    end
    `SLTU: begin
        result = A < B;
        flag = 0;
    end
    `XOR: begin
        result = A ^ B;
        flag = 0;
    end
    `SRL: begin
        result = A >> B;
        flag = 0;
    end
    `SRA: begin
        result = $signed(A) >>> B;
        flag = 0;
    end
    `OR: begin
        result = A | B;
        flag = 0;
    end
    `AND: begin
        result = A & B;
        flag = 0;
    end 
    `BEQ: begin
        result = 0;
        flag = (A == B);
    end
    `BNE: begin
        result = 0;
        flag = (A != B);
    end
    `BLT: begin
        result = 0;
        flag = ($signed(A) < $signed(B)) ? 1 : 0;
    end
    `BGE: begin
        result = 0;
        flag = ($signed(A) >= $signed(B)) ? 1 : 0;
    end
    `BLTU: begin
        result = 0;
        flag = (A < B);
    end
    `BGEU: begin
        result = 0;
        flag = (A >= B);
    end
endcase 
end
endmodule
