
//--xuezhen--

`include "defines.v"

module id_stage(
  input wire rst,
  input wire [31 : 0]inst,
  
  
  output wire rs1_r_ena,
  output wire [4 : 0]rs1_r_addr,
  output wire rs2_r_ena,
  output wire [4 : 0]rs2_r_addr,
  output wire rd_w_ena,
  output wire [4 : 0]rd_w_addr,
  
  output wire `REG_BUS imm_data,

  output wire pc_op1,
  output wire pc_op2,
  output reg [3 : 0] aluop,
  output wire rd_s,
  output wire op1,
  output wire op2

);

//inst fields
wire [6  : 0]opcode;
wire [4  : 0]rd;
wire [2  : 0]func3;
wire [4  : 0]rs1;
wire [4  : 0]rs2;
wire [11 : 0]imm_i;
wire [6 : 0]func_7;
assign opcode = inst[6  :  0];
assign rd     = inst[11 :  7];
assign func3  = inst[14 : 12];
assign rs1    = inst[19 : 15];
assign rs2    = inst[24 : 20];
assign imm_i  = inst[31 : 20];
assign func_7 = inst[31 : 25];

//opcode & fun3 1st stage decode
wire opcode_6_5_00 = (opcode[6 : 5] == 2'b00) ? 1'b1 :1'b0;
wire opcode_6_5_01 = (opcode[6 : 5] == 2'b01) ? 1'b1 :1'b0;
wire opcode_6_5_10 = (opcode[6 : 5] == 2'b10) ? 1'b1 :1'b0;
wire opcode_6_5_11 = (opcode[6 : 5] == 2'b11) ? 1'b1 :1'b0;

wire opcode_4_2_000 = (opcode[4 : 2] == 3'b000) ? 1'b1 :1'b0;
wire opcode_4_2_001 = (opcode[4 : 2] == 3'b001) ? 1'b1 :1'b0;
wire opcode_4_2_010 = (opcode[4 : 2] == 3'b010) ? 1'b1 :1'b0;
wire opcode_4_2_011 = (opcode[4 : 2] == 3'b011) ? 1'b1 :1'b0;
wire opcode_4_2_100 = (opcode[4 : 2] == 3'b100) ? 1'b1 :1'b0;
wire opcode_4_2_101 = (opcode[4 : 2] == 3'b101) ? 1'b1 :1'b0;
wire opcode_4_2_110 = (opcode[4 : 2] == 3'b110) ? 1'b1 :1'b0;
wire opcode_4_2_111 = (opcode[4 : 2] == 3'b111) ? 1'b1 :1'b0;

wire func3_000 = (func3 == 3'b000) ? 1'b1 :1'b0;
wire func3_001 = (func3 == 3'b001) ? 1'b1 :1'b0;
wire func3_010 = (func3 == 3'b010) ? 1'b1 :1'b0;
wire func3_011 = (func3 == 3'b011) ? 1'b1 :1'b0;
wire func3_100 = (func3 == 3'b100) ? 1'b1 :1'b0;
wire func3_101 = (func3 == 3'b101) ? 1'b1 :1'b0;
wire func3_110 = (func3 == 3'b110) ? 1'b1 :1'b0;
wire func3_111 = (func3 == 3'b111) ? 1'b1 :1'b0;

// I-type  

wire inst_addi =    opcode_6_5_00 & opcode_4_2_100 & func3_000;
wire inst_xori =    opcode_6_5_00 & opcode_4_2_100 & func3_100;
wire inst_ori =     opcode_6_5_00 & opcode_4_2_100 & func3_110;
wire inst_andi =    opcode_6_5_00 & opcode_4_2_100 & func3_111;
wire inst_slli =    opcode_6_5_00 & opcode_4_2_100 & func3_001 & ~imm_i[10];//
wire inst_srli =    opcode_6_5_00 & opcode_4_2_100 & func3_101 & ~imm_i[10];
wire inst_srai =    opcode_6_5_00 & opcode_4_2_100 & func3_101 & imm_i[10];
wire inst_slti =    opcode_6_5_00 & opcode_4_2_100 & func3_010;
wire inst_sltiu =   opcode_6_5_00 & opcode_4_2_100 & func3_011; 

wire inst_addiw =    opcode_6_5_00 & opcode_4_2_110 & func3_000;
wire inst_slliw =    opcode_6_5_00 & opcode_4_2_110 & func3_001 & ~imm_i[10];
wire inst_srliw =    opcode_6_5_00 & opcode_4_2_110 & func3_101 & ~imm_i[10];
wire inst_sraiw =    opcode_6_5_00 & opcode_4_2_110 & func3_101 & imm_i[10];

// R-type  
wire inst_add =    opcode_6_5_01 & opcode_4_2_100 & func3_000 & ~func_7[6];
wire inst_sub =    opcode_6_5_01 & opcode_4_2_100 & func3_000 & func_7[6];
wire inst_xor =    opcode_6_5_01 & opcode_4_2_100 & func3_100;
wire inst_or =     opcode_6_5_01 & opcode_4_2_100 & func3_110;
wire inst_and =    opcode_6_5_01 & opcode_4_2_100 & func3_111;
wire inst_sll =    opcode_6_5_01 & opcode_4_2_100 & func3_001 & ~func_7[6];//
wire inst_srl =    opcode_6_5_01 & opcode_4_2_100 & func3_101 & ~func_7[6];
wire inst_sra =    opcode_6_5_01 & opcode_4_2_100 & func3_101 & func_7[6];
wire inst_slt =    opcode_6_5_01 & opcode_4_2_100 & func3_010;
wire inst_sltu =   opcode_6_5_01 & opcode_4_2_100 & func3_011; 

wire inst_addw =    opcode_6_5_01 & opcode_4_2_110 & func3_000 & ~func_7[6];
wire inst_subw =    opcode_6_5_01 & opcode_4_2_110 & func3_000 & func_7[6];
wire inst_sllw =    opcode_6_5_01 & opcode_4_2_110 & func3_001 & ~func_7[6];
wire inst_srlw =    opcode_6_5_01 & opcode_4_2_110 & func3_101 & ~func_7[6];
wire inst_sraw =    opcode_6_5_01 & opcode_4_2_110 & func3_101 & func_7[6];

//load 
wire inst_lb = opcode_6_5_00 & opcode_4_2_000 & func3_000;
wire inst_lh = opcode_6_5_00 & opcode_4_2_000 & func3_001;
wire inst_lw = opcode_6_5_00 & opcode_4_2_000 & func3_010;
wire inst_lbu = opcode_6_5_00 & opcode_4_2_000 & func3_100;
wire inst_lhu = opcode_6_5_00 & opcode_4_2_000 & func3_101;
wire inst_ld = opcode_6_5_00 & opcode_4_2_000 & func3_011;
wire inst_lwu = opcode_6_5_00 & opcode_4_2_000 & func3_110;

//store
wire inst_sb = opcode_6_5_01 & opcode_4_2_000 & func3_000;
wire inst_sh = opcode_6_5_01 & opcode_4_2_000 & func3_001;
wire inst_sw = opcode_6_5_01 & opcode_4_2_000 & func3_010;
wire inst_sd = opcode_6_5_01 & opcode_4_2_000 & func3_011;

//branch
wire inst_beq = opcode_6_5_11 & opcode_4_2_000 & func3_000;
wire isnt_bne = opcode_6_5_11 & opcode_4_2_000 & func3_001;
wire inst_blt = opcode_6_5_11 & opcode_4_2_000 & func3_100;
wire inst_bge = opcode_6_5_11 & opcode_4_2_000 & func3_101;
wire inst_bltu = opcode_6_5_11 & opcode_4_2_000 & func3_110;
wire inst_bgeu = opcode_6_5_11 & opcode_4_2_000 & func3_111;

//control transfer
wire inst_jal = opcode_6_5_11 & opcode_4_2_011 ;
wire inst_jalr = opcode_6_5_11 & opcode_4_2_001 & func3_000;
wire inst_lui = opcode_6_5_01 & opcode_4_2_101;
wire inst_auipc = opcode_6_5_00 & opcode_4_2_101;

//envirnment inst
wire inst_ecall = opcode_6_5_11 & opcode_4_2_100 & func3_000 & ~imm_i[0];
wire inst_ebreak = opcode_6_5_11 & opcode_4_2_100 & func3_000 & imm_i[0];

// arith inst: 10000; logic: 01000;
// load-store: 00100; j: 00010;  sys: 000001


wire loads = opcode_6_5_00 & opcode_4_2_000;
wire stores = opcode_6_5_01 & opcode_4_2_000;
wire branchs = opcode_6_5_11 & opcode_4_2_000;
wire R_type =opcode_6_5_01 & (opcode_4_2_100 | opcode_4_2_110 ) ;
wire I_type_arth = opcode_6_5_00 | (opcode_4_2_110 | opcode_4_2_100) ; 

//generate alu operation code
wire alu_arth;
wire alu_logic;
wire alu_shift;
wire alu_comp;
wire alu_00;
wire alu_01;
wire alu_11;
wire alu_10;

assign alu_arth = inst_add | inst_sub | inst_addw | inst_addi | inst_addiw | inst_subw | loads | stores | inst_jal | inst_jalr | inst_auipc;
assign alu_logic = inst_xor | inst_or | inst_and | inst_xori | inst_ori | inst_andi;
assign alu_shift = inst_sll | inst_srl | inst_sra | inst_slli | inst_srli | inst_srai | inst_sllw | inst_srlw | inst_sraw | inst_slliw | inst_srliw | inst_sraiw;
assign alu_comp = inst_slt | inst_slti | inst_sltu | inst_sltiu | branchs;
assign alu_00 = inst_add | inst_addi | inst_addw | inst_addiw | loads | stores | inst_auipc;
assign alu_01 = inst_sub | isnt_subw | inst_srl | inst_srli |inst_srliw inst_srlw ;
assign alu_10 = inst_or | inst_ori | inst_bltu | inst_bgeu | inst_sltiu;
assign alu_11 = inst_and | inst_andi | inst_sra | inst_srai | inst_sraw |inst_sraiw ;


always @(*) begin
  case({alu_arth,alu_logic,alu_shift,alu_comp})
  4'h8: aluop[3:2] = 2'b00;
  4'h4: aluop[3:2] = 2'b01;
  4'h2: aluop[3:2] = 2'b10;
  4'h1: aluop[3:2] = 2'b11;
  default: aluop[3:2] = 2'b00;
  endcase
end
always @(*) begin
  case({alu_00,alu_01,alu_10,alu_11})
  4'h8: aluop[1:0] = 2'b00;
  4'h4: aluop[1:0] = 2'b01;
  4'h2: aluop[1:0] = 2'b10;
  4'h1: aluop[1:0] = 2'b11;
  default: aluop[1:0] = 2'b00;
  endcase
end

assign rs1_r_ena  = ( rst == 1'b1 ) ? 0 : inst_type[4];
assign rs1_r_addr = ( rst == 1'b1 ) ? 0 : ( inst_type[4] == 1'b1 ? rs1 : 0 );
assign rs2_r_ena  = 0;
assign rs2_r_addr = 0;

assign rd_w_ena   = ( rst == 1'b1 ) ? 0 : inst_type[4];
assign rd_w_addr  = ( rst == 1'b1 ) ? 0 : ( inst_type[4] == 1'b1 ? rd  : 0 );




endmodule
