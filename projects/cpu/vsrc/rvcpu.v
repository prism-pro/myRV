
//--xuezhen--

`timescale 1ns / 1ps

`include "defines.v"


module rvcpu(
  input wire            clk,
  input wire            rst,
  input wire  [31 : 0]  inst,
  
  output wire [`REG_BUS]  inst_addr, 
  output wire           inst_ena
);

//if_stage-> exe stage
//inst_addr 

// id_stage
//id_stage -> if_stage
wire pc_jump;
wire pc_b_eq;
wire pc_b_less;
wire pc_b_n;
wire link;

// id_stage -> regfile
wire rs1_r_ena;
wire [4 : 0]rs1_r_addr;
wire rs2_r_ena;
wire [4 : 0]rs2_r_addr;
wire rd_w_ena;
wire [4 : 0]rd_w_addr;
wire rd_s;


// id_stage -> exe_stage
wire op1,op2;
wire [3 : 0]aluop;
wire [7 : 0]inst_opcode;
wire [`REG_BUS]imm_data;

// regfile -> id_stage

//reg_file -> exe stage
wire [`REG_BUS] rs_data1;
wire [`REG_BUS] rs_data2;

// exe_stage
// exe_stage -> if stage
wire eq_flag;
wire less_flag;
wire [4 : 0]inst_type_o;
// exe_stage -> regfile
wire [`REG_BUS] rd_data;

if_stage If_stage(
  .clk(clk),
  .rst(rst),
  .eq_flag(eq_flag),
  .less_flag(less_flag),
  .pc_jump(pc_jump),
  .pc_b_eq(pc_b_eq),
  .pc_b_less(pc_b_less),
  .pc_b_n(pc_b_n),
  .link(link),
  .rs1_data(rs1_data),
  .imm_data(imm_data),
  .inst_addr(inst_addr),
  .inst_ena(inst_ena)
);

id_stage Id_stage(
  .rst(rst),
  .inst(inst),
  
  .rs1_r_ena(rs1_r_ena),
  .rs1_r_addr(rs1_r_addr),
  .rs2_r_ena(rs2_r_ena),
  .rs2_r_addr(rs2_r_addr),
  .rd_w_ena(rd_w_ena),
  .rd_w_addr(rd_w_addr),

  .pc_jump(pc_jump),
  .pc_b_eq(pc_b_eq),
  .pc_b_less(pc_b_less),
  .pc_b_n(pc_b_n),
  .link(link),
  
  .op1(op1),
  .op2(op2),
  .imm_data(imm_data),
  .aluop(aluop),
  .z_exp(),
  .mem_acs(),
);

exe_stage Exe_stage(
  .rst(rst),
  .op1(op1),
  .op2(op2),
  .rs1_data(rs1_data),
  .rs2_data(rs2_data),
  .imm_data(imm_data),
  .pc_value(inst_addr),
  .eq_flag(eq_flag),
  .less_flag(less_flag),
  .rd_data(rd_data)
);

regfile Regfile(
  .clk(clk),
  .rst(rst),
  .w_addr(rd_w_addr),
  .w_data(rd_data),
  .w_ena(rd_w_ena),
  .w_data_s(rd_s),
  .r_addr1(rs1_r_addr),
  .rs1_data(rs1_data),
  .r_ena1(rs1_r_ena),
  .r_addr2(rs2_r_addr),
  .rs2_data(rs2_data),
  .r_ena2(rs2_r_ena)
);

endmodule
