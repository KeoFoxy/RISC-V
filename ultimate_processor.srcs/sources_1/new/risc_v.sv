//               ____   ___  ____    ____   __     __
//              |  _ \ |_ _|/ ___|  / ___|  \ \   / /
//              | |_) | | | \___ \ | |       \ \ / / 
//              |  _ <  | |  ___) || |___     \ V /  
//              |_| \_\|___||____/  \____|     \_/   
//
//
//                      RISC V Basic processor


module risc_v 
(
    input logic clk_i, 
    input logic arstn_i,

    input        [31:0] instr_rdata_i, // ram -> risc_v; 
    output logic [31:0] instr_addr_o,  //  risc_v -> ram AI;

    input        [31:0] data_rdata_i, // ram -> risc_v -> lsu
    output logic        data_req_o, // risc_v -> lsu -> ram (memory request for ram) 
    output logic        data_we_o,
    output logic [3:0]  data_be_o, // risc_v -> lsu -> ram
    output logic [31:0] data_addr_o, // risc_v -> lsu -> ram
    output logic [31:0] data_wdata_o //

);

logic [31:0] PC; // Cчетчик
logic [31:0] IM_Output; // Instruction memory data output
logic Flag; // ALU


logic [31:0] WD3; // RF
logic [31:0] ALU_Output;
logic [4:0]  ALU_Op; // ALU
logic [31:0] RD1; // RF Output -> ALU Input
logic [31:0] RD2; // RF Output -> ALU Input

logic [31:0] ALU_Operand_A, ALU_Operand_B; // ¬ход ALU 1 
logic [1:0] ex_op_a_sel_o;
logic [2:0] ex_op_b_sel_o;


// —игналы с/дл€ декодера
logic branch_o; 
logic jal_o;
logic jalr_o;
logic gpr_we_a_o;
logic wb_src_sel_o;
logic lsu_stall_req;

// LR5
logic mem_we_o;
logic [31:0] A_mem;
logic [31:0] RD_mem;
logic [2:0] mem_size;
logic lsu_req_o;
logic enable_pc;


assign A_mem = ALU_Output;


assign IM_Output = instr_rdata_i;
assign instr_addr_o = PC;

logic [31:0] imm_I, imm_S, imm_J, imm_B, imm_U; // »нструкции
logic [31:0] imm_select; //
logic [31:0] PC_sum_select; // 
logic [31:0] mux_pc; // 



main_decoder decoder(.fetched_instr_i(IM_Output),
                     .ex_op_a_sel_o(ex_op_a_sel_o),
                     .ex_op_b_sel_o(ex_op_b_sel_o),
                     .alu_op_o(ALU_Op),
                     .mem_req_o(lsu_req_o),
                     .mem_we_o(mem_we_o),
                     .mem_size_o(mem_size),
                     .gpr_we_a_o(gpr_we_a_o),
                     .wb_src_sel_o(wb_src_sel_o),
                     .illegal_instr_o(), //   подсистеме прерываний
                     .branch_o(branch_o),
                     .jal_o(jal_o),
                     .jalr_o(jalr_o), // ћодуль декодера
                     .mem_stall_req_i(lsu_stall_req),
                     .enable_pc(enable_pc));


register_file reg_file(.CLK(clk_i),
                    .WE3(gpr_we_a_o),
                    .A1(IM_Output[19:15]),
                    .A2(IM_Output[24:20]),
                    .A3(IM_Output[11:7]),
                    .WD3(WD3),
                    .RD1(RD1),
                    .RD2(RD2));
                    
                   
alu alu(.A(ALU_Operand_A),
        .B(ALU_Operand_B),
        .ALUOp(ALU_Op),
        .result(ALU_Output),
        .flag(Flag));
                      
                     
miriscv_lsu lsu(.clk_i(clk_i), // синхронизаци€
         .arstn_i(arstn_i), // сброс внутренних регистров
         // core protocol
         .lsu_addr_i(ALU_Output), // адрес, по которому хотим обратитьс€
         .lsu_we_i(mem_we_o), // 1 - если нужно записать в пам€ть
         .lsu_size_i(mem_size), // размер обрабатываемых данных
         .lsu_data_i(RD2), // данные дл€ записи в пам€ть
         .lsu_req_i(lsu_req_o), // 1 - обратитьс€ к пам€ти
         .lsu_stall_req_o(lsu_stall_req), // используетс€ как !enable pc
         .lsu_data_o(RD_mem), // данные считанные из пам€ти

          // memory protocol
         .data_rdata_i(data_rdata_i), // запрошенные данные
         .data_req_o(data_req_o), // 1 - обратитьс€ к пам€ти
         .data_we_o(data_we_o), // 1 - это запрос на запись
         .data_be_o(data_be_o), // к каким байтам слова идет обращение
         .data_addr_o(data_addr_o), // адрес, по которому идет обращение    
         .data_wdata_o(data_wdata_o) // данные, которые требуетс€ записать
);


assign imm_select = branch_o ? imm_B : imm_J;
assign PC_sum_select = jal_o | (Flag & branch_o) ? imm_select : 4;
assign mux_pc = jalr_o ? $signed(RD1) + $signed(imm_I) : PC + $signed(PC_sum_select);
 


assign imm_I = {{20{IM_Output[31]}}, IM_Output[31:25], IM_Output[24:20]};
assign imm_S = {{20{IM_Output[31]}}, IM_Output[31:25], IM_Output[11:7]};
assign imm_B = {{20{IM_Output[31]}}, IM_Output[7], IM_Output[30:25], IM_Output[11:8], 1'b0};
assign imm_U = {IM_Output[31:25], IM_Output[24:20], IM_Output[19:15], IM_Output[14:12], 12'b0};
assign imm_J = {{12{IM_Output[31]}}, IM_Output[19:15], IM_Output[14:12], IM_Output[20], IM_Output[30:25], IM_Output[24:21], 1'b0};

 
//IM_Output memory

always @(*) begin
case(ex_op_a_sel_o)
    2'b00: ALU_Operand_A = RD1;
    2'b01: ALU_Operand_A = PC;
    2'b10: ALU_Operand_A = 0;
    default: ALU_Operand_A = RD1;
endcase
end

always @(*) begin
case(ex_op_b_sel_o)
    3'd0: ALU_Operand_B = RD2;
    3'd1: ALU_Operand_B = imm_I;
    3'd2: ALU_Operand_B = imm_U;
    3'd3: ALU_Operand_B = imm_S; 
    3'd4: ALU_Operand_B = 4; 
    default: ALU_Operand_A = RD2;
endcase
end


always_ff@(posedge clk_i) begin
   if(!arstn_i) 
       PC <= 0;
   else if(enable_pc) begin
       if (jalr_o)
           PC <= RD1 + imm_I;
       else begin 
            case(jal_o|(Flag & branch_o)) 
                1'b0: PC <= PC + 4;
                1'b1:
                case(branch_o) 
                    1'b0: PC <= $signed(PC) + imm_J;
                    1'b1: PC <= PC + imm_B;
                endcase
            endcase
        end
    end
 end

// ћультиплексор на запись (правый)
always_comb begin
case(wb_src_sel_o) 
    2'b0: begin
             WD3 = ALU_Output;
          end        
    2'b1: begin 
            WD3 = RD_mem;
          end
     default: WD3 = 0;
        
     endcase
end


endmodule
