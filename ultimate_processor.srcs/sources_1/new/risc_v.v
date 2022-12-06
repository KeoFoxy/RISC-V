module risc_v 
(
input CLK, 
input RST
);

reg [31:0] PC; // Cчетчик
wire [31:0] IM_Output; // Instruction memory data output
wire Flag; // ALU


wire [31:0] WD3; // RF
wire [31:0] ALU_Output;
wire [4:0] ALU_Op; // ALU
wire [31:0] RD1; // RF Output -> ALU Input
wire [31:0] RD2; // RF Output -> ALU Input

reg [31:0] ALU_Operand_A, ALU_Operand_B; // Вход ALU 1 
wire [1:0] ex_op_a_sel_o;
wire [2:0] ex_op_b_sel_o;

wire branch_o; // 32
wire jal_o;
wire jalr_o;
wire gpr_we_a_o;
wire wb_src_sel_o;

wire [31:0] imm_I, imm_S, imm_J, imm_B, imm_U;
wire [31:0] imm_select;
wire [31:0] PC_sum_select;
wire [31:0] mux_pc; 

assign imm_select = branch_o ? imm_B : imm_J;
assign PC_sum_select = jal_o | (Flag & branch_o) ? imm_select : 4;
assign mux_pc = jalr_o ? $signed(RD1) + $signed(imm_I) : PC + $signed(PC_sum_select);
 


assign imm_I = {{20{IM_Output[31]}}, IM_Output[31:25], IM_Output[24:20]};
assign imm_S = {{20{IM_Output[31]}}, IM_Output[31:25], IM_Output[11:7]};
assign imm_B = {{20{IM_Output[31]}}, IM_Output[7], IM_Output[30:25], IM_Output[11:8], 1'b0};
assign imm_U = {IM_Output[31:25], IM_Output[24:20], IM_Output[19:15], IM_Output[14:12], 12'b0};
assign imm_J = {{12{IM_Output[31]}}, IM_Output[19:15], IM_Output[14:12], IM_Output[20], IM_Output[30:25], IM_Output[24:21], 1'b0};


assign WD3 = wb_src_sel_o ? 32'hx : ALU_Output;
 
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


main_decoder decoder(.fetched_instr_i(IM_Output),
                     .ex_op_a_sel_o(ex_op_a_sel_o),
                     .ex_op_b_sel_o(ex_op_b_sel_o),
                     .alu_op_o(ALU_Op),
                     .mem_req_o(),
                     .mem_we_o(),
                     .mem_size_o(),
                     .gpr_we_a_o(gpr_we_a_o),
                     .wb_src_sel_o(wb_src_sel_o),
                     .illegal_instr_o(),
                     .branch_o(branch_o),
                     .jal_o(jal_o),
                     .jalr_o(jalr_o)); // Модуль декодера



psu_memory instr_mem(.A(PC), 
               .CLK(CLK),
               .RD(IM_Output));
//Register File
ram_memory reg_file(.CLK(CLK),
                    .A1(IM_Output[19:15]),
                    .A2(IM_Output[24:20]),
                    .A3(IM_Output[11:7]),
                    .WD3(WD3),
                    .WE3(gpr_we_a_o),
                    .RD1(RD1),
                    .RD2(RD2));
                    
                   

alu alu(.A(ALU_Operand_A),
        .B(ALU_Operand_B),
        .ALUOp(ALU_Op),
        .result(ALU_Output),
        .flag(Flag));
                      
                     

always @(posedge CLK) begin
    if (~RST) PC <= 0;
    else PC <= mux_pc;
    end



endmodule
