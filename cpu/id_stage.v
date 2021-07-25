
/* verilator lint_off UNDRIVEN */
/* verilator lint_off UNUSED */
//--xuezhen--

`include "defines.v"

module id_stage(
  input wire rst,
  input wire [31 : 0]inst,
  input wire [`REG_BUS]rs1_data,
  input wire [`REG_BUS]rs2_data,
  
  
  output wire rs1_r_ena,
  output wire [4 : 0]rs1_r_addr,
  output wire rs2_r_ena,
  output wire [4 : 0]rs2_r_addr,
  output wire rd_w_ena,
  output wire [4 : 0]rd_w_addr,
  
  output wire [4 : 0]inst_type,
  output wire [7 : 0]inst_opcode,
  output wire [`REG_BUS]op1,
  output wire [`REG_BUS]op2
);

wire [6  : 0]opcode;
wire [4  : 0]rd;
wire [2  : 0]func3;
wire [4  : 0]rs1;
wire [4  : 0]rs2;
assign opcode = inst[6  :  0];
assign rd     = inst[11 :  7];
assign func3  = inst[14 : 12];
assign rs1    = inst[19 : 15];
assign rs2    = inst[24 : 20];

//judge inst type from opcode,to avoid large-scale decoder
wire type_J;
wire type_R;
wire type_S;
wire type_B;
wire type_u_lui;
wire type_u_auipc;
wire type_i_arich;
wire type_i_load;
wire type_i_jalr;
wire type_i_env;
assign type_J = opcode[2] & opcode[3] & ~opcode[4] & opcode[5] & opcode[6];
assign type_R = ~opcode[2] & ~opcode[3] & opcode[4] & opcode[5] & ~opcode[6];
assign type_S = ~opcode[2] & ~opcode[3] & ~opcode[4] & opcode[5] & ~opcode[6];
assign type_B = ~opcode[2] & ~opcode[3] & ~opcode[4] & opcode[5] & opcode[6];
assign type_u_lui = opcode[2] & ~opcode[3] & opcode[4] & opcode[5] & ~opcode[6];
assign type_u_auipc = opcode[2] & ~opcode[3] & opcode[4] & ~opcode[5] & ~opcode[6];
assign type_i_arich = ~opcode[2] & ~opcode[3] & opcode[4] & ~opcode[5] & ~opcode[6];    //in fact, arich or logic
assign type_i_load = ~opcode[2] & ~opcode[3] & ~opcode[4] & ~opcode[5] & ~opcode[6];
assign type_i_jalr = opcode[2] & ~opcode[3] & ~opcode[4] & opcode[5] & opcode[6];
assign type_i_env = ~opcode[2] & ~opcode[3] & opcode[4] & opcode[5] & opcode[6];

// I-type
wire [11 : 0]imm;
assign imm    = inst[31 : 20];

wire inst_addi =   type_i_arich
                 & ~func3[0] & ~func3[1] & ~func3[2];

// arith inst: 10000; logic: 01000;
// load-store: 00100; j: 00010;  sys: 000001
assign inst_type[4] = ( rst == 1'b1 ) ? 0 : inst_addi;

assign inst_opcode[0] = (  rst == 1'b1 ) ? 0 : inst_addi;
assign inst_opcode[1] = (  rst == 1'b1 ) ? 0 : 0;
assign inst_opcode[2] = (  rst == 1'b1 ) ? 0 : 0;
assign inst_opcode[3] = (  rst == 1'b1 ) ? 0 : 0;
assign inst_opcode[4] = (  rst == 1'b1 ) ? 0 : inst_addi;
assign inst_opcode[5] = (  rst == 1'b1 ) ? 0 : 0;
assign inst_opcode[6] = (  rst == 1'b1 ) ? 0 : 0;
assign inst_opcode[7] = (  rst == 1'b1 ) ? 0 : 0;




assign rs1_r_ena  = ( rst == 1'b1 ) ? 0 : inst_type[4];
assign rs1_r_addr = ( rst == 1'b1 ) ? 0 : ( inst_type[4] == 1'b1 ? rs1 : 0 );
assign rs2_r_ena  = 0;
assign rs2_r_addr = 0;

assign rd_w_ena   = ( rst == 1'b1 ) ? 0 : inst_type[4];
assign rd_w_addr  = ( rst == 1'b1 ) ? 0 : ( inst_type[4] == 1'b1 ? rd  : 0 );

assign op1 = ( rst == 1'b1 ) ? 0 : ( inst_type[4] == 1'b1 ? rs1_data : 0 );
assign op2 = ( rst == 1'b1 ) ? 0 : ( inst_type[4] == 1'b1 ? { {52{imm[11]}}, imm } : 0 );


endmodule
