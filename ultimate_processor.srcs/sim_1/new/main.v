`timescale 1ns / 10ps
// Модуль тестбенча всего устройства
// Источник синхронизации: clk
module main();
// Блок часов
reg clk;
wire [31:0] OUTPUT_CHECK;
// Блок IN / RESET
reg IN;
reg RST;
// ERROR DETECTION WIRES
// RISC_V:
wire [7:0] PC; // Контроль счетчика
wire [31:0] CURRENT_INSTRUCTION; // Текущая инструкция
wire [31:0] RD1; // RF Output -> ALU Input
wire [31:0] RD2; // RF Output -> ALU Input


initial
begin
clk = 0;
IN = 31'b0;
RST = 0;
end
  
always #10 clk = ~clk; // Формируем сигнал часов

// Обьект процессора
risc_v processor(.IN(IN), 
                 .CLK(clk),
                 .RST(RST), 
                 .OUT(OUTPUT_CHECK));

// Подсоединение проводов для проверки:
assign PC = processor.PC;
assign CURRENT_INSTRUCTION = processor.IM_Output;
assign RD1 = processor.RD1;
assign RD2 = processor.RD2;
// C = processor.C;
//assign B = processor.B;
//assign TEST = processor.TEST;



// Проверка работы инструкции
initial begin
    check_instruction();
    $stop; 
end


task check_instruction();
begin
    #1500;    
end
endtask

endmodule