`define RESET_ADDR 32'h00000000

`define ALU_OP_WIDTH  5

`define ADD   5'b00000
`define SUB   5'b01000

`define XOR   5'b00100
`define OR    5'b00110
`define AND   5'b00111

// shifts
`define SRA   5'b01101
`define SRL   5'b00101
`define SLL   5'b00001

// comparisons
`define BLT   5'b11100
`define BLTU  5'b11110
`define BGE   5'b11101
`define BGEU   5'b11111
`define BEQ   5'b11000
`define BNE    5'b11001

// set lower than operations
`define SLT  5'b00010
`define SLTU  5'b00011

// opcodes
`define LOAD_OPCODE      5'b00_000
`define MISC_MEM_OPCODE  5'b00_011
`define OP_IMM_OPCODE    5'b00_100
`define AUIPC_OPCODE     5'b00_101
`define STORE_OPCODE     5'b01_000
`define OP_OPCODE        5'b01_100
`define LUI_OPCODE       5'b01_101
`define BRANCH_OPCODE    5'b11_000
`define JALR_OPCODE      5'b11_001
`define JAL_OPCODE       5'b11_011
`define SYSTEM_OPCODE    5'b11_100

// dmem type load store
`define LDST_B           3'b000 // Знаковое 8-битное значение
`define LDST_H           3'b001 // Знаковое 16-битное значение
`define LDST_W           3'b010 // 32-битное значение
`define LDST_BU          3'b100 // Беззнаковое 8-битное значение
`define LDST_HU          3'b101 // Беззнаковое 16-битное значение

// operand a selection
`define OP_A_RS1         2'b00
`define OP_A_CURR_PC     2'b01
`define OP_A_ZERO        2'b10

// operand b selection
`define OP_B_RS2         3'b000
`define OP_B_IMM_I       3'b001
`define OP_B_IMM_U       3'b010
`define OP_B_IMM_S       3'b011
`define OP_B_INCR        3'b100

// writeback source selection
`define WB_EX_RESULT     1'b0
`define WB_LSU_DATA      1'b1
