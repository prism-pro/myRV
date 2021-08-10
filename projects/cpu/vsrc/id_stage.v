
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
  output wire [3 : 0] aluop,
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

//generate alu operation code





// I-type  */


/*
wire inst_addi =    type_i_arich & ~func3[0] & ~func3[1] & ~func3[2];
wire inst_xori =    type_i_arich & func3[0] & ~func3[1] & ~func3[2];
wire inst_ori =     type_i_arich & func3[0] & func3[1] & ~func3[2];
wire inst_andi =    type_i_arich & func3[0] & func3[1] & func3[2];
wire inst_slli =    type_i_arich & func3[0] & ~func3[1] & ~func3[2] & ~imm_i[10];//
wire inst_srli =    type_i_arich & func3[0] & ~func3[1] & func3[2] & ~imm_i[10];
wire inst_srai =    type_i_arich & func3[0] & ~func3[1] & func3[2] & imm_i[10];
wire inst_slti =    type_i_arich & ~func3[0] & func3[1] & ~func3[2];
wire inst_sltiu =   type_i_arich & func3[0] & func3[1] & ~func3[2]; */
// arith inst: 10000; logic: 01000;
// load-store: 00100; j: 00010;  sys: 000001





assign rs1_r_ena  = ( rst == 1'b1 ) ? 0 : inst_type[4];
assign rs1_r_addr = ( rst == 1'b1 ) ? 0 : ( inst_type[4] == 1'b1 ? rs1 : 0 );
assign rs2_r_ena  = 0;
assign rs2_r_addr = 0;

assign rd_w_ena   = ( rst == 1'b1 ) ? 0 : inst_type[4];
assign rd_w_addr  = ( rst == 1'b1 ) ? 0 : ( inst_type[4] == 1'b1 ? rd  : 0 );




endmodule
