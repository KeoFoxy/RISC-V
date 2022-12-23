`include "defines_riscv.v"
//                               _      ____   _   _ 
//                              | |    / ___| | | | |
//                              | |    \___ \ | | | |
//                              | |___  ___) || |_| |
//                              |_____||____/  \___/ 
//                     
//                             API for RISC V and RAM 
//

module miriscv_lsu
(
 input clk_i, // синхронизаци€,
 input arstn_i, // сброс внутренних регистров,
 
 // core protocol
 input logic [31:0] lsu_addr_i, // адрес, по которому хотим обратитьс€ (->lsu A)
 input lsu_we_i, // 1 - если нужно записать в пам€ть (Decoder -> lsu WE) DEC
 input logic [2:0] lsu_size_i, // размер обрабатываемых данных (Decoder -> lsu I) DEC
 input logic [31:0] lsu_data_i, // данные дл€ записи в пам€ть (RD2 -> lsu WD)
 input lsu_req_i, // 1 - обратитьс€ к пам€ти (Decoder -> ?) DEC
 output logic lsu_stall_req_o, // используетс€ как !enable pc (S)
 output logic [31:0] lsu_data_o, // данные, считанные из пам€ти (RD -> Register file)

 // memory protocol
 input logic [31:0] data_rdata_i, // запрошенные данные (RAM -> lsu)
 output data_req_o, // 1 - обратитьс€ к пам€ти 
 output data_we_o, // 1 - это запрос на запись 
 output logic [3:0] data_be_o, // к каким байтам слова идет обращение (lsu -> Ram)
 output logic [31:0] data_addr_o, // адрес, по которому идет обращение (AD -> Ram)
 output logic [31:0] data_wdata_o // данные, которые требуетс€ записать (WD -> Ram)
);

// ќбьединенные порты
assign data_addr_o = lsu_addr_i; // ѕр€мое перенаправление
// assign data_req_o = lsu_req_i;
assign data_we_o = lsu_we_i && lsu_req_i; // –азрешает запись при двух услови€х


always_comb begin
data_be_o = 0;
// ‘ормируем data_be_o
case(lsu_size_i) 
   3'b000,3'b100:      
    begin
           data_wdata_o <= { 4{lsu_data_i[7:0]} };
           case(lsu_addr_i[1:0])
           2'b00: data_be_o = 4'b0001;
           2'b01: data_be_o = 4'b0010;
           2'b10: data_be_o = 4'b0100;
           2'b11: data_be_o = 4'b1000;
           endcase
    end
   3'b001,3'b101:
   begin
            $display("In lw block with lsu_data_i: %d", lsu_data_i);
            data_wdata_o <= { 2{lsu_data_i[15:0]} };     
            case(lsu_addr_i[1:0])
            2'b00: data_be_o = 4'b0011;
            2'b10: data_be_o = 4'b1100;
            endcase  
    end
   3'b010: 
   begin
           data_wdata_o <= lsu_data_i;
           data_be_o = 4'b1111;
    end
endcase
end

// ѕолучаем байт по нужному смещению (будет использоватьс€, если запрашивалс€ байт)
	logic [7:0] lb_data;
	always_comb begin
		case (lsu_addr_i[1:0])
			2'b00: lb_data <= data_rdata_i[7:0];
			2'b01: lb_data <= data_rdata_i[15:8];
			2'b10: lb_data <= data_rdata_i[23:16];
			2'b11: lb_data <= data_rdata_i[31:24];
		endcase
	end
	
	// ѕолучаем полуслово по нужному смещению (будет использоватьс€, если запрашивалось слово)
	logic [15:0] lh_data;
	assign lh_data = (lsu_addr_i[1:0] == 2'b10) ? data_rdata_i[31:16] : data_rdata_i[15:0];
	
	
	// „тение из пам€ти
	always_comb begin
		case (lsu_size_i)
            3'b000: lsu_data_o <= {{24{lb_data[7]}}, lb_data};
            3'b001: lsu_data_o <= {{16{lh_data[15]}}, lh_data};
            3'b100: lsu_data_o <= {24'b0, lb_data};
            3'b101: lsu_data_o <= {16'b0, lh_data};
            default: lsu_data_o <= data_rdata_i; 
		endcase
	end
	
	// –еализуем синхронное чтение / запись данных
	logic data_need_req;
	assign data_need_req = lsu_req_i;
	logic mem_op_idle;
	always_ff @(posedge clk_i) begin
	    if (!arstn_i || !data_need_req) begin
	       mem_op_idle <= 1'b0;
	    end else begin
	       mem_op_idle <= !mem_op_idle;
	    end
	end
	assign data_req_o = data_need_req ^ mem_op_idle;
	
	// ѕриостанавлиаем процессор, пока идЄт обращение к ќ«”
	assign lsu_stall_req_o = data_req_o;
	
endmodule