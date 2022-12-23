`timescale 1ns / 1ps

// parameter BITWIDTH=32;
// parameter OPERATORWIDTH=5;

module ALU_tb();
    reg [31:0] A, B;
    reg [4:0] ALUOp;
    wire flag;
    wire [31:0] result;
    
    alu dut (A, B, ALUOp, flag, result);
    
    initial begin
        add_op(7,  6);
        sub_op(10, 6);
        sll_op(10, 6);
        slt_op(-2, 3);
        sltu_op(10, 9);
        xor_op(7, 5);
        srl_op(6, 3); 
        $stop;
    end
    
    // Сложение
    task add_op;
    input [31:0] a_op, b_op;
    begin
        A = a_op;
        B = b_op;
        ALUOp = 5'b00000;
        #100;
        if (result == (a_op + b_op))
            $display("PASS %d + %d = %d", A, B, result);
        else
            $display("FAIL %d + %d = %d", A, B, result);
        end
    endtask
    
    //Вычитание
    task sub_op;
    input [31:0] a_op, b_op;
    begin
        A = a_op;
        B = b_op;
        ALUOp = 5'b01000;
        #100;
        if (result == (a_op - b_op))
            $display("PASS %d - %d = %d", A, B, result);
        else
            $display("FAIL %d - %d = %d", A, B, result);
        end
    endtask
    
    //Сдвиг влево
    task sll_op;
    input [31:0] a_op, b_op;
    begin
        A = a_op;
        B = b_op;
        ALUOp = 5'b00001;
        #100;
        if (result == (a_op << b_op))
            $display("PASS %d << %d = %d", A, B, result);
        else
            $display("FAIL %d << %d = %d", A, B, result);
        end
    endtask
    
    //Знаковое сравнение
    task slt_op;
    input  [31:0] a_op, b_op;
    begin
        A = a_op;
        B = b_op;
        ALUOp = 5'b00010;
        #100;
        if (result == ($signed(a_op) < $signed(b_op)))
            $display("PASS $signed(%d) < $signed(%d) = %d", $signed(A), $signed(B), result);
        else
            $display("FAIL $signed(%d) < $signed(%d) = %d", A, B, result);
        end
    endtask
    
    //Беззнаковое сравнение
    task sltu_op;
    input [31:0] a_op, b_op;
    begin
        A = a_op;
        B = b_op;
        ALUOp = 5'b00011;
        #100;
        if (result == (a_op< b_op))
            $display("PASS %d < %d = %d", A, B, result);
        else
            $display("FAIL %d < %d = %d", A, B, result);
        end
    endtask
    
    //Побитовое исключающее ИЛИ
    task xor_op;
    input [31:0] a_op, b_op;
    begin
        A = a_op;
        B = b_op;
        ALUOp = 5'b00100;
        #100;
        if (result == a_op ^ b_op)
            $display("PASS %d ^ %d = %d", A, B, result);
        else
            $display("FAIL %d ^ %d = %d", A, B, result);
        end
    endtask
    
    //Сдвиг вправо
    task srl_op;
    input [31:0] a_op, b_op;
    begin
        A = a_op;
        B = b_op;
        ALUOp = 5'b00101;
        #100;
        if (result == a_op >> b_op)
            $display("PASS %d >> %d = %d", A, B, result);
        else
            $display("FAIL %d >> %d = %d", A, B, result);
        end
    endtask
endmodule