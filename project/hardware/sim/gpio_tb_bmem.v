`timescale 1ns/1ns

`include "opcode.vh"
`include "mem_path.vh"

`ifdef SYN
localparam SIM_MODE = "SYN ";
`elsif RGL
  `ifdef SDF
    localparam SIM_MODE = "RGL+SDF";
  `else
    localparam SIM_MODE = "RGL ";
  `endif
`else
localparam SIM_MODE = "RTL ";
`endif

`ifdef SYN
module tb_rf();
  reg [31:0] mem [0:31];
endmodule
`elsif RGL
module tb_rf();
  reg [31:0] mem [0:31];
endmodule
`endif

module gpio_tb();
  reg clk, rst;
  parameter CPU_CLOCK_PERIOD = 100;
  parameter CPU_CLOCK_FREQ   = 1_000_000_000 / CPU_CLOCK_PERIOD;
  parameter SPI_CLOCK_PERIOD = 100;

  initial clk = 0;
  always #(CPU_CLOCK_PERIOD/2) clk = ~clk;
  
  reg  bcfg = 1'b0;
  reg  bscs = 1'b1;
  reg  bsdi = 1'b1;
  reg  bsck = 1'b1;
  wire bsdo;
  
  wire [7:0] gpio_out;
  wire [7:0] gpio_oeb;

`ifdef SYN
  tb_rf RF();

  //FLATTEN
  always@(*) begin
      RF.mem[1]  = rv151.\soc.rf.mem[1] ;
      RF.mem[2]  = rv151.\soc.rf.mem[2] ;
      RF.mem[3]  = rv151.\soc.rf.mem[3] ;
      RF.mem[4]  = rv151.\soc.rf.mem[4] ;
      RF.mem[5]  = rv151.\soc.rf.mem[5] ;
      RF.mem[6]  = rv151.\soc.rf.mem[6] ;
      RF.mem[7]  = rv151.\soc.rf.mem[7] ;
      RF.mem[8]  = rv151.\soc.rf.mem[8] ;
      RF.mem[9]  = rv151.\soc.rf.mem[9] ;
      RF.mem[10] = rv151.\soc.rf.mem[10] ;
      RF.mem[11] = rv151.\soc.rf.mem[11] ;
      RF.mem[12] = rv151.\soc.rf.mem[12] ;
      RF.mem[13] = rv151.\soc.rf.mem[13] ;
      RF.mem[14] = rv151.\soc.rf.mem[14] ;
      RF.mem[15] = rv151.\soc.rf.mem[15] ;
      RF.mem[16] = rv151.\soc.rf.mem[16] ;
      RF.mem[17] = rv151.\soc.rf.mem[17] ;
      RF.mem[18] = rv151.\soc.rf.mem[18] ;
      RF.mem[19] = rv151.\soc.rf.mem[19] ;
      RF.mem[20] = rv151.\soc.rf.mem[20] ;
      RF.mem[21] = rv151.\soc.rf.mem[21] ;
      RF.mem[22] = rv151.\soc.rf.mem[22] ;
      RF.mem[23] = rv151.\soc.rf.mem[23] ;
      RF.mem[24] = rv151.\soc.rf.mem[24] ;
      RF.mem[25] = rv151.\soc.rf.mem[25] ;
      RF.mem[26] = rv151.\soc.rf.mem[26] ;
      RF.mem[27] = rv151.\soc.rf.mem[27] ;
      RF.mem[28] = rv151.\soc.rf.mem[28] ;
      RF.mem[29] = rv151.\soc.rf.mem[29] ;
      RF.mem[30] = rv151.\soc.rf.mem[30] ;
      RF.mem[31] = rv151.\soc.rf.mem[31] ;
  end

`elsif RGL

  `ifdef SDF
    initial begin : load_sdf
      `ifdef MAX
        $display("[INFO]: Load MAX-SDF");
        $sdf_annotate("../rgl/sdf/hdp_rv151.ss.sdf", rv151) ;
      `elsif MIN
        $display("[INFO]: Load MIN-SDF");
        $sdf_annotate("../rgl/sdf/hdp_rv151.ff.sdf", rv151) ;
      `elsif NOM
        $display("[INFO]: Load NOM-SDF");
        $sdf_annotate("../rgl/sdf/hdp_rv151.tt.sdf", rv151) ;
      `else
        $display("[INFO]: no-SDF");
      `endif
    end
  `endif

  tb_rf RF();

	always@(*) begin
		RF.mem[1]  = {rv151.\soc.rf.mem[1][31] ,rv151.\soc.rf.mem[1][30] ,rv151.\soc.rf.mem[1][29] ,rv151.\soc.rf.mem[1][28] , 
					  rv151.\soc.rf.mem[1][27] ,rv151.\soc.rf.mem[1][26] ,rv151.\soc.rf.mem[1][25] ,rv151.\soc.rf.mem[1][24] , 
					  rv151.\soc.rf.mem[1][23] ,rv151.\soc.rf.mem[1][22] ,rv151.\soc.rf.mem[1][21] ,rv151.\soc.rf.mem[1][20] , 
					  rv151.\soc.rf.mem[1][19] ,rv151.\soc.rf.mem[1][18] ,rv151.\soc.rf.mem[1][17] ,rv151.\soc.rf.mem[1][16] , 
					  rv151.\soc.rf.mem[1][15] ,rv151.\soc.rf.mem[1][14] ,rv151.\soc.rf.mem[1][13] ,rv151.\soc.rf.mem[1][12] , 
					  rv151.\soc.rf.mem[1][11] ,rv151.\soc.rf.mem[1][10] ,rv151.\soc.rf.mem[1][9]  ,rv151.\soc.rf.mem[1][8] , 
					  rv151.\soc.rf.mem[1][7]  ,rv151.\soc.rf.mem[1][6]  ,rv151.\soc.rf.mem[1][5]  ,rv151.\soc.rf.mem[1][4] , 
					  rv151.\soc.rf.mem[1][3]  ,rv151.\soc.rf.mem[1][2]  ,rv151.\soc.rf.mem[1][1]  ,rv151.\soc.rf.mem[1][0] } ;
		RF.mem[2]  = {rv151.\soc.rf.mem[2][31] ,rv151.\soc.rf.mem[2][30] ,rv151.\soc.rf.mem[2][29] ,rv151.\soc.rf.mem[2][28] , 
					  rv151.\soc.rf.mem[2][27] ,rv151.\soc.rf.mem[2][26] ,rv151.\soc.rf.mem[2][25] ,rv151.\soc.rf.mem[2][24] , 
					  rv151.\soc.rf.mem[2][23] ,rv151.\soc.rf.mem[2][22] ,rv151.\soc.rf.mem[2][21] ,rv151.\soc.rf.mem[2][20] , 
					  rv151.\soc.rf.mem[2][19] ,rv151.\soc.rf.mem[2][18] ,rv151.\soc.rf.mem[2][17] ,rv151.\soc.rf.mem[2][16] , 
					  rv151.\soc.rf.mem[2][15] ,rv151.\soc.rf.mem[2][14] ,rv151.\soc.rf.mem[2][13] ,rv151.\soc.rf.mem[2][12] , 
					  rv151.\soc.rf.mem[2][11] ,rv151.\soc.rf.mem[2][10] ,rv151.\soc.rf.mem[2][9]  ,rv151.\soc.rf.mem[2][8] , 
					  rv151.\soc.rf.mem[2][7]  ,rv151.\soc.rf.mem[2][6]  ,rv151.\soc.rf.mem[2][5]  ,rv151.\soc.rf.mem[2][4] , 
					  rv151.\soc.rf.mem[2][3]  ,rv151.\soc.rf.mem[2][2]  ,rv151.\soc.rf.mem[2][1]  ,rv151.\soc.rf.mem[2][0] } ;
		RF.mem[3]  = {rv151.\soc.rf.mem[3][31] ,rv151.\soc.rf.mem[3][30] ,rv151.\soc.rf.mem[3][29] ,rv151.\soc.rf.mem[3][28] , 
					  rv151.\soc.rf.mem[3][27] ,rv151.\soc.rf.mem[3][26] ,rv151.\soc.rf.mem[3][25] ,rv151.\soc.rf.mem[3][24] , 
					  rv151.\soc.rf.mem[3][23] ,rv151.\soc.rf.mem[3][22] ,rv151.\soc.rf.mem[3][21] ,rv151.\soc.rf.mem[3][20] , 
					  rv151.\soc.rf.mem[3][19] ,rv151.\soc.rf.mem[3][18] ,rv151.\soc.rf.mem[3][17] ,rv151.\soc.rf.mem[3][16] , 
					  rv151.\soc.rf.mem[3][15] ,rv151.\soc.rf.mem[3][14] ,rv151.\soc.rf.mem[3][13] ,rv151.\soc.rf.mem[3][12] , 
					  rv151.\soc.rf.mem[3][11] ,rv151.\soc.rf.mem[3][10] ,rv151.\soc.rf.mem[3][9]  ,rv151.\soc.rf.mem[3][8] , 
					  rv151.\soc.rf.mem[3][7]  ,rv151.\soc.rf.mem[3][6]  ,rv151.\soc.rf.mem[3][5]  ,rv151.\soc.rf.mem[3][4] , 
					  rv151.\soc.rf.mem[3][3]  ,rv151.\soc.rf.mem[3][2]  ,rv151.\soc.rf.mem[3][1]  ,rv151.\soc.rf.mem[3][0] } ;
		RF.mem[4]  = {rv151.\soc.rf.mem[4][31] ,rv151.\soc.rf.mem[4][30] ,rv151.\soc.rf.mem[4][29] ,rv151.\soc.rf.mem[4][28] , 
					  rv151.\soc.rf.mem[4][27] ,rv151.\soc.rf.mem[4][26] ,rv151.\soc.rf.mem[4][25] ,rv151.\soc.rf.mem[4][24] , 
					  rv151.\soc.rf.mem[4][23] ,rv151.\soc.rf.mem[4][22] ,rv151.\soc.rf.mem[4][21] ,rv151.\soc.rf.mem[4][20] , 
					  rv151.\soc.rf.mem[4][19] ,rv151.\soc.rf.mem[4][18] ,rv151.\soc.rf.mem[4][17] ,rv151.\soc.rf.mem[4][16] , 
					  rv151.\soc.rf.mem[4][15] ,rv151.\soc.rf.mem[4][14] ,rv151.\soc.rf.mem[4][13] ,rv151.\soc.rf.mem[4][12] , 
					  rv151.\soc.rf.mem[4][11] ,rv151.\soc.rf.mem[4][10] ,rv151.\soc.rf.mem[4][9]  ,rv151.\soc.rf.mem[4][8] , 
					  rv151.\soc.rf.mem[4][7]  ,rv151.\soc.rf.mem[4][6]  ,rv151.\soc.rf.mem[4][5]  ,rv151.\soc.rf.mem[4][4] , 
					  rv151.\soc.rf.mem[4][3]  ,rv151.\soc.rf.mem[4][2]  ,rv151.\soc.rf.mem[4][1]  ,rv151.\soc.rf.mem[4][0] } ;
		RF.mem[5]  = {rv151.\soc.rf.mem[5][31] ,rv151.\soc.rf.mem[5][30] ,rv151.\soc.rf.mem[5][29] ,rv151.\soc.rf.mem[5][28] , 
					  rv151.\soc.rf.mem[5][27] ,rv151.\soc.rf.mem[5][26] ,rv151.\soc.rf.mem[5][25] ,rv151.\soc.rf.mem[5][24] , 
					  rv151.\soc.rf.mem[5][23] ,rv151.\soc.rf.mem[5][22] ,rv151.\soc.rf.mem[5][21] ,rv151.\soc.rf.mem[5][20] , 
					  rv151.\soc.rf.mem[5][19] ,rv151.\soc.rf.mem[5][18] ,rv151.\soc.rf.mem[5][17] ,rv151.\soc.rf.mem[5][16] , 
					  rv151.\soc.rf.mem[5][15] ,rv151.\soc.rf.mem[5][14] ,rv151.\soc.rf.mem[5][13] ,rv151.\soc.rf.mem[5][12] , 
					  rv151.\soc.rf.mem[5][11] ,rv151.\soc.rf.mem[5][10] ,rv151.\soc.rf.mem[5][9]  ,rv151.\soc.rf.mem[5][8] , 
					  rv151.\soc.rf.mem[5][7]  ,rv151.\soc.rf.mem[5][6]  ,rv151.\soc.rf.mem[5][5]  ,rv151.\soc.rf.mem[5][4] , 
					  rv151.\soc.rf.mem[5][3]  ,rv151.\soc.rf.mem[5][2]  ,rv151.\soc.rf.mem[5][1]  ,rv151.\soc.rf.mem[5][0] } ;
		RF.mem[6]  = {rv151.\soc.rf.mem[6][31] ,rv151.\soc.rf.mem[6][30] ,rv151.\soc.rf.mem[6][29] ,rv151.\soc.rf.mem[6][28] , 
					  rv151.\soc.rf.mem[6][27] ,rv151.\soc.rf.mem[6][26] ,rv151.\soc.rf.mem[6][25] ,rv151.\soc.rf.mem[6][24] , 
					  rv151.\soc.rf.mem[6][23] ,rv151.\soc.rf.mem[6][22] ,rv151.\soc.rf.mem[6][21] ,rv151.\soc.rf.mem[6][20] , 
					  rv151.\soc.rf.mem[6][19] ,rv151.\soc.rf.mem[6][18] ,rv151.\soc.rf.mem[6][17] ,rv151.\soc.rf.mem[6][16] , 
					  rv151.\soc.rf.mem[6][15] ,rv151.\soc.rf.mem[6][14] ,rv151.\soc.rf.mem[6][13] ,rv151.\soc.rf.mem[6][12] , 
					  rv151.\soc.rf.mem[6][11] ,rv151.\soc.rf.mem[6][10] ,rv151.\soc.rf.mem[6][9]  ,rv151.\soc.rf.mem[6][8] , 
					  rv151.\soc.rf.mem[6][7]  ,rv151.\soc.rf.mem[6][6]  ,rv151.\soc.rf.mem[6][5]  ,rv151.\soc.rf.mem[6][4] , 
					  rv151.\soc.rf.mem[6][3]  ,rv151.\soc.rf.mem[6][2]  ,rv151.\soc.rf.mem[6][1]  ,rv151.\soc.rf.mem[6][0] } ;
		RF.mem[7]  = {rv151.\soc.rf.mem[7][31] ,rv151.\soc.rf.mem[7][30] ,rv151.\soc.rf.mem[7][29] ,rv151.\soc.rf.mem[7][28] , 
					  rv151.\soc.rf.mem[7][27] ,rv151.\soc.rf.mem[7][26] ,rv151.\soc.rf.mem[7][25] ,rv151.\soc.rf.mem[7][24] , 
					  rv151.\soc.rf.mem[7][23] ,rv151.\soc.rf.mem[7][22] ,rv151.\soc.rf.mem[7][21] ,rv151.\soc.rf.mem[7][20] , 
					  rv151.\soc.rf.mem[7][19] ,rv151.\soc.rf.mem[7][18] ,rv151.\soc.rf.mem[7][17] ,rv151.\soc.rf.mem[7][16] , 
					  rv151.\soc.rf.mem[7][15] ,rv151.\soc.rf.mem[7][14] ,rv151.\soc.rf.mem[7][13] ,rv151.\soc.rf.mem[7][12] , 
					  rv151.\soc.rf.mem[7][11] ,rv151.\soc.rf.mem[7][10] ,rv151.\soc.rf.mem[7][9]  ,rv151.\soc.rf.mem[7][8] , 
					  rv151.\soc.rf.mem[7][7]  ,rv151.\soc.rf.mem[7][6]  ,rv151.\soc.rf.mem[7][5]  ,rv151.\soc.rf.mem[7][4] , 
					  rv151.\soc.rf.mem[7][3]  ,rv151.\soc.rf.mem[7][2]  ,rv151.\soc.rf.mem[7][1]  ,rv151.\soc.rf.mem[7][0] } ;
		RF.mem[8]  = {rv151.\soc.rf.mem[8][31] ,rv151.\soc.rf.mem[8][30] ,rv151.\soc.rf.mem[8][29] ,rv151.\soc.rf.mem[8][28] , 
					  rv151.\soc.rf.mem[8][27] ,rv151.\soc.rf.mem[8][26] ,rv151.\soc.rf.mem[8][25] ,rv151.\soc.rf.mem[8][24] , 
					  rv151.\soc.rf.mem[8][23] ,rv151.\soc.rf.mem[8][22] ,rv151.\soc.rf.mem[8][21] ,rv151.\soc.rf.mem[8][20] , 
					  rv151.\soc.rf.mem[8][19] ,rv151.\soc.rf.mem[8][18] ,rv151.\soc.rf.mem[8][17] ,rv151.\soc.rf.mem[8][16] , 
					  rv151.\soc.rf.mem[8][15] ,rv151.\soc.rf.mem[8][14] ,rv151.\soc.rf.mem[8][13] ,rv151.\soc.rf.mem[8][12] , 
					  rv151.\soc.rf.mem[8][11] ,rv151.\soc.rf.mem[8][10] ,rv151.\soc.rf.mem[8][9]  ,rv151.\soc.rf.mem[8][8] , 
					  rv151.\soc.rf.mem[8][7]  ,rv151.\soc.rf.mem[8][6]  ,rv151.\soc.rf.mem[8][5]  ,rv151.\soc.rf.mem[8][4] , 
					  rv151.\soc.rf.mem[8][3]  ,rv151.\soc.rf.mem[8][2]  ,rv151.\soc.rf.mem[8][1]  ,rv151.\soc.rf.mem[8][0] } ;
		RF.mem[9]  = {rv151.\soc.rf.mem[9][31] ,rv151.\soc.rf.mem[9][30] ,rv151.\soc.rf.mem[9][29] ,rv151.\soc.rf.mem[9][28] , 
					  rv151.\soc.rf.mem[9][27] ,rv151.\soc.rf.mem[9][26] ,rv151.\soc.rf.mem[9][25] ,rv151.\soc.rf.mem[9][24] , 
					  rv151.\soc.rf.mem[9][23] ,rv151.\soc.rf.mem[9][22] ,rv151.\soc.rf.mem[9][21] ,rv151.\soc.rf.mem[9][20] , 
					  rv151.\soc.rf.mem[9][19] ,rv151.\soc.rf.mem[9][18] ,rv151.\soc.rf.mem[9][17] ,rv151.\soc.rf.mem[9][16] , 
					  rv151.\soc.rf.mem[9][15] ,rv151.\soc.rf.mem[9][14] ,rv151.\soc.rf.mem[9][13] ,rv151.\soc.rf.mem[9][12] , 
					  rv151.\soc.rf.mem[9][11] ,rv151.\soc.rf.mem[9][10] ,rv151.\soc.rf.mem[9][9]  ,rv151.\soc.rf.mem[9][8] , 
					  rv151.\soc.rf.mem[9][7]  ,rv151.\soc.rf.mem[9][6]  ,rv151.\soc.rf.mem[9][5]  ,rv151.\soc.rf.mem[9][4] , 
					  rv151.\soc.rf.mem[9][3]  ,rv151.\soc.rf.mem[9][2]  ,rv151.\soc.rf.mem[9][1]  ,rv151.\soc.rf.mem[9][0] } ;
		RF.mem[10]  = {rv151.\soc.rf.mem[10][31] ,rv151.\soc.rf.mem[10][30] ,rv151.\soc.rf.mem[10][29] ,rv151.\soc.rf.mem[10][28] , 
					  rv151.\soc.rf.mem[10][27] ,rv151.\soc.rf.mem[10][26] ,rv151.\soc.rf.mem[10][25] ,rv151.\soc.rf.mem[10][24] , 
					  rv151.\soc.rf.mem[10][23] ,rv151.\soc.rf.mem[10][22] ,rv151.\soc.rf.mem[10][21] ,rv151.\soc.rf.mem[10][20] , 
					  rv151.\soc.rf.mem[10][19] ,rv151.\soc.rf.mem[10][18] ,rv151.\soc.rf.mem[10][17] ,rv151.\soc.rf.mem[10][16] , 
					  rv151.\soc.rf.mem[10][15] ,rv151.\soc.rf.mem[10][14] ,rv151.\soc.rf.mem[10][13] ,rv151.\soc.rf.mem[10][12] , 
					  rv151.\soc.rf.mem[10][11] ,rv151.\soc.rf.mem[10][10] ,rv151.\soc.rf.mem[10][9]  ,rv151.\soc.rf.mem[10][8] , 
					  rv151.\soc.rf.mem[10][7]  ,rv151.\soc.rf.mem[10][6]  ,rv151.\soc.rf.mem[10][5]  ,rv151.\soc.rf.mem[10][4] , 
					  rv151.\soc.rf.mem[10][3]  ,rv151.\soc.rf.mem[10][2]  ,rv151.\soc.rf.mem[10][1]  ,rv151.\soc.rf.mem[10][0] } ;
		RF.mem[11]  = {rv151.\soc.rf.mem[11][31] ,rv151.\soc.rf.mem[11][30] ,rv151.\soc.rf.mem[11][29] ,rv151.\soc.rf.mem[11][28] , 
					  rv151.\soc.rf.mem[11][27] ,rv151.\soc.rf.mem[11][26] ,rv151.\soc.rf.mem[11][25] ,rv151.\soc.rf.mem[11][24] , 
					  rv151.\soc.rf.mem[11][23] ,rv151.\soc.rf.mem[11][22] ,rv151.\soc.rf.mem[11][21] ,rv151.\soc.rf.mem[11][20] , 
					  rv151.\soc.rf.mem[11][19] ,rv151.\soc.rf.mem[11][18] ,rv151.\soc.rf.mem[11][17] ,rv151.\soc.rf.mem[11][16] , 
					  rv151.\soc.rf.mem[11][15] ,rv151.\soc.rf.mem[11][14] ,rv151.\soc.rf.mem[11][13] ,rv151.\soc.rf.mem[11][12] , 
					  rv151.\soc.rf.mem[11][11] ,rv151.\soc.rf.mem[11][10] ,rv151.\soc.rf.mem[11][9]  ,rv151.\soc.rf.mem[11][8] , 
					  rv151.\soc.rf.mem[11][7]  ,rv151.\soc.rf.mem[11][6]  ,rv151.\soc.rf.mem[11][5]  ,rv151.\soc.rf.mem[11][4] , 
					  rv151.\soc.rf.mem[11][3]  ,rv151.\soc.rf.mem[11][2]  ,rv151.\soc.rf.mem[11][1]  ,rv151.\soc.rf.mem[11][0] } ;
		RF.mem[12]  = {rv151.\soc.rf.mem[12][31] ,rv151.\soc.rf.mem[12][30] ,rv151.\soc.rf.mem[12][29] ,rv151.\soc.rf.mem[12][28] , 
					  rv151.\soc.rf.mem[12][27] ,rv151.\soc.rf.mem[12][26] ,rv151.\soc.rf.mem[12][25] ,rv151.\soc.rf.mem[12][24] , 
					  rv151.\soc.rf.mem[12][23] ,rv151.\soc.rf.mem[12][22] ,rv151.\soc.rf.mem[12][21] ,rv151.\soc.rf.mem[12][20] , 
					  rv151.\soc.rf.mem[12][19] ,rv151.\soc.rf.mem[12][18] ,rv151.\soc.rf.mem[12][17] ,rv151.\soc.rf.mem[12][16] , 
					  rv151.\soc.rf.mem[12][15] ,rv151.\soc.rf.mem[12][14] ,rv151.\soc.rf.mem[12][13] ,rv151.\soc.rf.mem[12][12] , 
					  rv151.\soc.rf.mem[12][11] ,rv151.\soc.rf.mem[12][10] ,rv151.\soc.rf.mem[12][9]  ,rv151.\soc.rf.mem[12][8] , 
					  rv151.\soc.rf.mem[12][7]  ,rv151.\soc.rf.mem[12][6]  ,rv151.\soc.rf.mem[12][5]  ,rv151.\soc.rf.mem[12][4] , 
					  rv151.\soc.rf.mem[12][3]  ,rv151.\soc.rf.mem[12][2]  ,rv151.\soc.rf.mem[12][1]  ,rv151.\soc.rf.mem[12][0] } ;
		RF.mem[13]  = {rv151.\soc.rf.mem[13][31] ,rv151.\soc.rf.mem[13][30] ,rv151.\soc.rf.mem[13][29] ,rv151.\soc.rf.mem[13][28] , 
					  rv151.\soc.rf.mem[13][27] ,rv151.\soc.rf.mem[13][26] ,rv151.\soc.rf.mem[13][25] ,rv151.\soc.rf.mem[13][24] , 
					  rv151.\soc.rf.mem[13][23] ,rv151.\soc.rf.mem[13][22] ,rv151.\soc.rf.mem[13][21] ,rv151.\soc.rf.mem[13][20] , 
					  rv151.\soc.rf.mem[13][19] ,rv151.\soc.rf.mem[13][18] ,rv151.\soc.rf.mem[13][17] ,rv151.\soc.rf.mem[13][16] , 
					  rv151.\soc.rf.mem[13][15] ,rv151.\soc.rf.mem[13][14] ,rv151.\soc.rf.mem[13][13] ,rv151.\soc.rf.mem[13][12] , 
					  rv151.\soc.rf.mem[13][11] ,rv151.\soc.rf.mem[13][10] ,rv151.\soc.rf.mem[13][9]  ,rv151.\soc.rf.mem[13][8] , 
					  rv151.\soc.rf.mem[13][7]  ,rv151.\soc.rf.mem[13][6]  ,rv151.\soc.rf.mem[13][5]  ,rv151.\soc.rf.mem[13][4] , 
					  rv151.\soc.rf.mem[13][3]  ,rv151.\soc.rf.mem[13][2]  ,rv151.\soc.rf.mem[13][1]  ,rv151.\soc.rf.mem[13][0] } ;
		RF.mem[14]  = {rv151.\soc.rf.mem[14][31] ,rv151.\soc.rf.mem[14][30] ,rv151.\soc.rf.mem[14][29] ,rv151.\soc.rf.mem[14][28] , 
					  rv151.\soc.rf.mem[14][27] ,rv151.\soc.rf.mem[14][26] ,rv151.\soc.rf.mem[14][25] ,rv151.\soc.rf.mem[14][24] , 
					  rv151.\soc.rf.mem[14][23] ,rv151.\soc.rf.mem[14][22] ,rv151.\soc.rf.mem[14][21] ,rv151.\soc.rf.mem[14][20] , 
					  rv151.\soc.rf.mem[14][19] ,rv151.\soc.rf.mem[14][18] ,rv151.\soc.rf.mem[14][17] ,rv151.\soc.rf.mem[14][16] , 
					  rv151.\soc.rf.mem[14][15] ,rv151.\soc.rf.mem[14][14] ,rv151.\soc.rf.mem[14][13] ,rv151.\soc.rf.mem[14][12] , 
					  rv151.\soc.rf.mem[14][11] ,rv151.\soc.rf.mem[14][10] ,rv151.\soc.rf.mem[14][9]  ,rv151.\soc.rf.mem[14][8] , 
					  rv151.\soc.rf.mem[14][7]  ,rv151.\soc.rf.mem[14][6]  ,rv151.\soc.rf.mem[14][5]  ,rv151.\soc.rf.mem[14][4] , 
					  rv151.\soc.rf.mem[14][3]  ,rv151.\soc.rf.mem[14][2]  ,rv151.\soc.rf.mem[14][1]  ,rv151.\soc.rf.mem[14][0] } ;
		RF.mem[15]  = {rv151.\soc.rf.mem[15][31] ,rv151.\soc.rf.mem[15][30] ,rv151.\soc.rf.mem[15][29] ,rv151.\soc.rf.mem[15][28] , 
					  rv151.\soc.rf.mem[15][27] ,rv151.\soc.rf.mem[15][26] ,rv151.\soc.rf.mem[15][25] ,rv151.\soc.rf.mem[15][24] , 
					  rv151.\soc.rf.mem[15][23] ,rv151.\soc.rf.mem[15][22] ,rv151.\soc.rf.mem[15][21] ,rv151.\soc.rf.mem[15][20] , 
					  rv151.\soc.rf.mem[15][19] ,rv151.\soc.rf.mem[15][18] ,rv151.\soc.rf.mem[15][17] ,rv151.\soc.rf.mem[15][16] , 
					  rv151.\soc.rf.mem[15][15] ,rv151.\soc.rf.mem[15][14] ,rv151.\soc.rf.mem[15][13] ,rv151.\soc.rf.mem[15][12] , 
					  rv151.\soc.rf.mem[15][11] ,rv151.\soc.rf.mem[15][10] ,rv151.\soc.rf.mem[15][9]  ,rv151.\soc.rf.mem[15][8] , 
					  rv151.\soc.rf.mem[15][7]  ,rv151.\soc.rf.mem[15][6]  ,rv151.\soc.rf.mem[15][5]  ,rv151.\soc.rf.mem[15][4] , 
					  rv151.\soc.rf.mem[15][3]  ,rv151.\soc.rf.mem[15][2]  ,rv151.\soc.rf.mem[15][1]  ,rv151.\soc.rf.mem[15][0] } ;
		RF.mem[16]  = {rv151.\soc.rf.mem[16][31] ,rv151.\soc.rf.mem[16][30] ,rv151.\soc.rf.mem[16][29] ,rv151.\soc.rf.mem[16][28] , 
					  rv151.\soc.rf.mem[16][27] ,rv151.\soc.rf.mem[16][26] ,rv151.\soc.rf.mem[16][25] ,rv151.\soc.rf.mem[16][24] , 
					  rv151.\soc.rf.mem[16][23] ,rv151.\soc.rf.mem[16][22] ,rv151.\soc.rf.mem[16][21] ,rv151.\soc.rf.mem[16][20] , 
					  rv151.\soc.rf.mem[16][19] ,rv151.\soc.rf.mem[16][18] ,rv151.\soc.rf.mem[16][17] ,rv151.\soc.rf.mem[16][16] , 
					  rv151.\soc.rf.mem[16][15] ,rv151.\soc.rf.mem[16][14] ,rv151.\soc.rf.mem[16][13] ,rv151.\soc.rf.mem[16][12] , 
					  rv151.\soc.rf.mem[16][11] ,rv151.\soc.rf.mem[16][10] ,rv151.\soc.rf.mem[16][9]  ,rv151.\soc.rf.mem[16][8] , 
					  rv151.\soc.rf.mem[16][7]  ,rv151.\soc.rf.mem[16][6]  ,rv151.\soc.rf.mem[16][5]  ,rv151.\soc.rf.mem[16][4] , 
					  rv151.\soc.rf.mem[16][3]  ,rv151.\soc.rf.mem[16][2]  ,rv151.\soc.rf.mem[16][1]  ,rv151.\soc.rf.mem[16][0] } ;
		RF.mem[17]  = {rv151.\soc.rf.mem[17][31] ,rv151.\soc.rf.mem[17][30] ,rv151.\soc.rf.mem[17][29] ,rv151.\soc.rf.mem[17][28] , 
					  rv151.\soc.rf.mem[17][27] ,rv151.\soc.rf.mem[17][26] ,rv151.\soc.rf.mem[17][25] ,rv151.\soc.rf.mem[17][24] , 
					  rv151.\soc.rf.mem[17][23] ,rv151.\soc.rf.mem[17][22] ,rv151.\soc.rf.mem[17][21] ,rv151.\soc.rf.mem[17][20] , 
					  rv151.\soc.rf.mem[17][19] ,rv151.\soc.rf.mem[17][18] ,rv151.\soc.rf.mem[17][17] ,rv151.\soc.rf.mem[17][16] , 
					  rv151.\soc.rf.mem[17][15] ,rv151.\soc.rf.mem[17][14] ,rv151.\soc.rf.mem[17][13] ,rv151.\soc.rf.mem[17][12] , 
					  rv151.\soc.rf.mem[17][11] ,rv151.\soc.rf.mem[17][10] ,rv151.\soc.rf.mem[17][9]  ,rv151.\soc.rf.mem[17][8] , 
					  rv151.\soc.rf.mem[17][7]  ,rv151.\soc.rf.mem[17][6]  ,rv151.\soc.rf.mem[17][5]  ,rv151.\soc.rf.mem[17][4] , 
					  rv151.\soc.rf.mem[17][3]  ,rv151.\soc.rf.mem[17][2]  ,rv151.\soc.rf.mem[17][1]  ,rv151.\soc.rf.mem[17][0] } ;
		RF.mem[18]  = {rv151.\soc.rf.mem[18][31] ,rv151.\soc.rf.mem[18][30] ,rv151.\soc.rf.mem[18][29] ,rv151.\soc.rf.mem[18][28] , 
					  rv151.\soc.rf.mem[18][27] ,rv151.\soc.rf.mem[18][26] ,rv151.\soc.rf.mem[18][25] ,rv151.\soc.rf.mem[18][24] , 
					  rv151.\soc.rf.mem[18][23] ,rv151.\soc.rf.mem[18][22] ,rv151.\soc.rf.mem[18][21] ,rv151.\soc.rf.mem[18][20] , 
					  rv151.\soc.rf.mem[18][19] ,rv151.\soc.rf.mem[18][18] ,rv151.\soc.rf.mem[18][17] ,rv151.\soc.rf.mem[18][16] , 
					  rv151.\soc.rf.mem[18][15] ,rv151.\soc.rf.mem[18][14] ,rv151.\soc.rf.mem[18][13] ,rv151.\soc.rf.mem[18][12] , 
					  rv151.\soc.rf.mem[18][11] ,rv151.\soc.rf.mem[18][10] ,rv151.\soc.rf.mem[18][9]  ,rv151.\soc.rf.mem[18][8] , 
					  rv151.\soc.rf.mem[18][7]  ,rv151.\soc.rf.mem[18][6]  ,rv151.\soc.rf.mem[18][5]  ,rv151.\soc.rf.mem[18][4] , 
					  rv151.\soc.rf.mem[18][3]  ,rv151.\soc.rf.mem[18][2]  ,rv151.\soc.rf.mem[18][1]  ,rv151.\soc.rf.mem[18][0] } ;
		RF.mem[19]  = {rv151.\soc.rf.mem[19][31] ,rv151.\soc.rf.mem[19][30] ,rv151.\soc.rf.mem[19][29] ,rv151.\soc.rf.mem[19][28] , 
					  rv151.\soc.rf.mem[19][27] ,rv151.\soc.rf.mem[19][26] ,rv151.\soc.rf.mem[19][25] ,rv151.\soc.rf.mem[19][24] , 
					  rv151.\soc.rf.mem[19][23] ,rv151.\soc.rf.mem[19][22] ,rv151.\soc.rf.mem[19][21] ,rv151.\soc.rf.mem[19][20] , 
					  rv151.\soc.rf.mem[19][19] ,rv151.\soc.rf.mem[19][18] ,rv151.\soc.rf.mem[19][17] ,rv151.\soc.rf.mem[19][16] , 
					  rv151.\soc.rf.mem[19][15] ,rv151.\soc.rf.mem[19][14] ,rv151.\soc.rf.mem[19][13] ,rv151.\soc.rf.mem[19][12] , 
					  rv151.\soc.rf.mem[19][11] ,rv151.\soc.rf.mem[19][10] ,rv151.\soc.rf.mem[19][9]  ,rv151.\soc.rf.mem[19][8] , 
					  rv151.\soc.rf.mem[19][7]  ,rv151.\soc.rf.mem[19][6]  ,rv151.\soc.rf.mem[19][5]  ,rv151.\soc.rf.mem[19][4] , 
					  rv151.\soc.rf.mem[19][3]  ,rv151.\soc.rf.mem[19][2]  ,rv151.\soc.rf.mem[19][1]  ,rv151.\soc.rf.mem[19][0] } ;
		RF.mem[20]  = {rv151.\soc.rf.mem[20][31] ,rv151.\soc.rf.mem[20][30] ,rv151.\soc.rf.mem[20][29] ,rv151.\soc.rf.mem[20][28] , 
					  rv151.\soc.rf.mem[20][27] ,rv151.\soc.rf.mem[20][26] ,rv151.\soc.rf.mem[20][25] ,rv151.\soc.rf.mem[20][24] , 
					  rv151.\soc.rf.mem[20][23] ,rv151.\soc.rf.mem[20][22] ,rv151.\soc.rf.mem[20][21] ,rv151.\soc.rf.mem[20][20] , 
					  rv151.\soc.rf.mem[20][19] ,rv151.\soc.rf.mem[20][18] ,rv151.\soc.rf.mem[20][17] ,rv151.\soc.rf.mem[20][16] , 
					  rv151.\soc.rf.mem[20][15] ,rv151.\soc.rf.mem[20][14] ,rv151.\soc.rf.mem[20][13] ,rv151.\soc.rf.mem[20][12] , 
					  rv151.\soc.rf.mem[20][11] ,rv151.\soc.rf.mem[20][10] ,rv151.\soc.rf.mem[20][9]  ,rv151.\soc.rf.mem[20][8] , 
					  rv151.\soc.rf.mem[20][7]  ,rv151.\soc.rf.mem[20][6]  ,rv151.\soc.rf.mem[20][5]  ,rv151.\soc.rf.mem[20][4] , 
					  rv151.\soc.rf.mem[20][3]  ,rv151.\soc.rf.mem[20][2]  ,rv151.\soc.rf.mem[20][1]  ,rv151.\soc.rf.mem[20][0] } ;
		RF.mem[21]  = {rv151.\soc.rf.mem[21][31] ,rv151.\soc.rf.mem[21][30] ,rv151.\soc.rf.mem[21][29] ,rv151.\soc.rf.mem[21][28] , 
					  rv151.\soc.rf.mem[21][27] ,rv151.\soc.rf.mem[21][26] ,rv151.\soc.rf.mem[21][25] ,rv151.\soc.rf.mem[21][24] , 
					  rv151.\soc.rf.mem[21][23] ,rv151.\soc.rf.mem[21][22] ,rv151.\soc.rf.mem[21][21] ,rv151.\soc.rf.mem[21][20] , 
					  rv151.\soc.rf.mem[21][19] ,rv151.\soc.rf.mem[21][18] ,rv151.\soc.rf.mem[21][17] ,rv151.\soc.rf.mem[21][16] , 
					  rv151.\soc.rf.mem[21][15] ,rv151.\soc.rf.mem[21][14] ,rv151.\soc.rf.mem[21][13] ,rv151.\soc.rf.mem[21][12] , 
					  rv151.\soc.rf.mem[21][11] ,rv151.\soc.rf.mem[21][10] ,rv151.\soc.rf.mem[21][9]  ,rv151.\soc.rf.mem[21][8] , 
					  rv151.\soc.rf.mem[21][7]  ,rv151.\soc.rf.mem[21][6]  ,rv151.\soc.rf.mem[21][5]  ,rv151.\soc.rf.mem[21][4] , 
					  rv151.\soc.rf.mem[21][3]  ,rv151.\soc.rf.mem[21][2]  ,rv151.\soc.rf.mem[21][1]  ,rv151.\soc.rf.mem[21][0] } ;
		RF.mem[22]  = {rv151.\soc.rf.mem[22][31] ,rv151.\soc.rf.mem[22][30] ,rv151.\soc.rf.mem[22][29] ,rv151.\soc.rf.mem[22][28] , 
					  rv151.\soc.rf.mem[22][27] ,rv151.\soc.rf.mem[22][26] ,rv151.\soc.rf.mem[22][25] ,rv151.\soc.rf.mem[22][24] , 
					  rv151.\soc.rf.mem[22][23] ,rv151.\soc.rf.mem[22][22] ,rv151.\soc.rf.mem[22][21] ,rv151.\soc.rf.mem[22][20] , 
					  rv151.\soc.rf.mem[22][19] ,rv151.\soc.rf.mem[22][18] ,rv151.\soc.rf.mem[22][17] ,rv151.\soc.rf.mem[22][16] , 
					  rv151.\soc.rf.mem[22][15] ,rv151.\soc.rf.mem[22][14] ,rv151.\soc.rf.mem[22][13] ,rv151.\soc.rf.mem[22][12] , 
					  rv151.\soc.rf.mem[22][11] ,rv151.\soc.rf.mem[22][10] ,rv151.\soc.rf.mem[22][9]  ,rv151.\soc.rf.mem[22][8] , 
					  rv151.\soc.rf.mem[22][7]  ,rv151.\soc.rf.mem[22][6]  ,rv151.\soc.rf.mem[22][5]  ,rv151.\soc.rf.mem[22][4] , 
					  rv151.\soc.rf.mem[22][3]  ,rv151.\soc.rf.mem[22][2]  ,rv151.\soc.rf.mem[22][1]  ,rv151.\soc.rf.mem[22][0] } ;
		RF.mem[23]  = {rv151.\soc.rf.mem[23][31] ,rv151.\soc.rf.mem[23][30] ,rv151.\soc.rf.mem[23][29] ,rv151.\soc.rf.mem[23][28] , 
					  rv151.\soc.rf.mem[23][27] ,rv151.\soc.rf.mem[23][26] ,rv151.\soc.rf.mem[23][25] ,rv151.\soc.rf.mem[23][24] , 
					  rv151.\soc.rf.mem[23][23] ,rv151.\soc.rf.mem[23][22] ,rv151.\soc.rf.mem[23][21] ,rv151.\soc.rf.mem[23][20] , 
					  rv151.\soc.rf.mem[23][19] ,rv151.\soc.rf.mem[23][18] ,rv151.\soc.rf.mem[23][17] ,rv151.\soc.rf.mem[23][16] , 
					  rv151.\soc.rf.mem[23][15] ,rv151.\soc.rf.mem[23][14] ,rv151.\soc.rf.mem[23][13] ,rv151.\soc.rf.mem[23][12] , 
					  rv151.\soc.rf.mem[23][11] ,rv151.\soc.rf.mem[23][10] ,rv151.\soc.rf.mem[23][9]  ,rv151.\soc.rf.mem[23][8] , 
					  rv151.\soc.rf.mem[23][7]  ,rv151.\soc.rf.mem[23][6]  ,rv151.\soc.rf.mem[23][5]  ,rv151.\soc.rf.mem[23][4] , 
					  rv151.\soc.rf.mem[23][3]  ,rv151.\soc.rf.mem[23][2]  ,rv151.\soc.rf.mem[23][1]  ,rv151.\soc.rf.mem[23][0] } ;
		RF.mem[24]  = {rv151.\soc.rf.mem[24][31] ,rv151.\soc.rf.mem[24][30] ,rv151.\soc.rf.mem[24][29] ,rv151.\soc.rf.mem[24][28] , 
					  rv151.\soc.rf.mem[24][27] ,rv151.\soc.rf.mem[24][26] ,rv151.\soc.rf.mem[24][25] ,rv151.\soc.rf.mem[24][24] , 
					  rv151.\soc.rf.mem[24][23] ,rv151.\soc.rf.mem[24][22] ,rv151.\soc.rf.mem[24][21] ,rv151.\soc.rf.mem[24][20] , 
					  rv151.\soc.rf.mem[24][19] ,rv151.\soc.rf.mem[24][18] ,rv151.\soc.rf.mem[24][17] ,rv151.\soc.rf.mem[24][16] , 
					  rv151.\soc.rf.mem[24][15] ,rv151.\soc.rf.mem[24][14] ,rv151.\soc.rf.mem[24][13] ,rv151.\soc.rf.mem[24][12] , 
					  rv151.\soc.rf.mem[24][11] ,rv151.\soc.rf.mem[24][10] ,rv151.\soc.rf.mem[24][9]  ,rv151.\soc.rf.mem[24][8] , 
					  rv151.\soc.rf.mem[24][7]  ,rv151.\soc.rf.mem[24][6]  ,rv151.\soc.rf.mem[24][5]  ,rv151.\soc.rf.mem[24][4] , 
					  rv151.\soc.rf.mem[24][3]  ,rv151.\soc.rf.mem[24][2]  ,rv151.\soc.rf.mem[24][1]  ,rv151.\soc.rf.mem[24][0] } ;
		RF.mem[25]  = {rv151.\soc.rf.mem[25][31] ,rv151.\soc.rf.mem[25][30] ,rv151.\soc.rf.mem[25][29] ,rv151.\soc.rf.mem[25][28] , 
					  rv151.\soc.rf.mem[25][27] ,rv151.\soc.rf.mem[25][26] ,rv151.\soc.rf.mem[25][25] ,rv151.\soc.rf.mem[25][24] , 
					  rv151.\soc.rf.mem[25][23] ,rv151.\soc.rf.mem[25][22] ,rv151.\soc.rf.mem[25][21] ,rv151.\soc.rf.mem[25][20] , 
					  rv151.\soc.rf.mem[25][19] ,rv151.\soc.rf.mem[25][18] ,rv151.\soc.rf.mem[25][17] ,rv151.\soc.rf.mem[25][16] , 
					  rv151.\soc.rf.mem[25][15] ,rv151.\soc.rf.mem[25][14] ,rv151.\soc.rf.mem[25][13] ,rv151.\soc.rf.mem[25][12] , 
					  rv151.\soc.rf.mem[25][11] ,rv151.\soc.rf.mem[25][10] ,rv151.\soc.rf.mem[25][9]  ,rv151.\soc.rf.mem[25][8] , 
					  rv151.\soc.rf.mem[25][7]  ,rv151.\soc.rf.mem[25][6]  ,rv151.\soc.rf.mem[25][5]  ,rv151.\soc.rf.mem[25][4] , 
					  rv151.\soc.rf.mem[25][3]  ,rv151.\soc.rf.mem[25][2]  ,rv151.\soc.rf.mem[25][1]  ,rv151.\soc.rf.mem[25][0] } ;
		RF.mem[26]  = {rv151.\soc.rf.mem[26][31] ,rv151.\soc.rf.mem[26][30] ,rv151.\soc.rf.mem[26][29] ,rv151.\soc.rf.mem[26][28] , 
					  rv151.\soc.rf.mem[26][27] ,rv151.\soc.rf.mem[26][26] ,rv151.\soc.rf.mem[26][25] ,rv151.\soc.rf.mem[26][24] , 
					  rv151.\soc.rf.mem[26][23] ,rv151.\soc.rf.mem[26][22] ,rv151.\soc.rf.mem[26][21] ,rv151.\soc.rf.mem[26][20] , 
					  rv151.\soc.rf.mem[26][19] ,rv151.\soc.rf.mem[26][18] ,rv151.\soc.rf.mem[26][17] ,rv151.\soc.rf.mem[26][16] , 
					  rv151.\soc.rf.mem[26][15] ,rv151.\soc.rf.mem[26][14] ,rv151.\soc.rf.mem[26][13] ,rv151.\soc.rf.mem[26][12] , 
					  rv151.\soc.rf.mem[26][11] ,rv151.\soc.rf.mem[26][10] ,rv151.\soc.rf.mem[26][9]  ,rv151.\soc.rf.mem[26][8] , 
					  rv151.\soc.rf.mem[26][7]  ,rv151.\soc.rf.mem[26][6]  ,rv151.\soc.rf.mem[26][5]  ,rv151.\soc.rf.mem[26][4] , 
					  rv151.\soc.rf.mem[26][3]  ,rv151.\soc.rf.mem[26][2]  ,rv151.\soc.rf.mem[26][1]  ,rv151.\soc.rf.mem[26][0] } ;
		RF.mem[27]  = {rv151.\soc.rf.mem[27][31] ,rv151.\soc.rf.mem[27][30] ,rv151.\soc.rf.mem[27][29] ,rv151.\soc.rf.mem[27][28] , 
					  rv151.\soc.rf.mem[27][27] ,rv151.\soc.rf.mem[27][26] ,rv151.\soc.rf.mem[27][25] ,rv151.\soc.rf.mem[27][24] , 
					  rv151.\soc.rf.mem[27][23] ,rv151.\soc.rf.mem[27][22] ,rv151.\soc.rf.mem[27][21] ,rv151.\soc.rf.mem[27][20] , 
					  rv151.\soc.rf.mem[27][19] ,rv151.\soc.rf.mem[27][18] ,rv151.\soc.rf.mem[27][17] ,rv151.\soc.rf.mem[27][16] , 
					  rv151.\soc.rf.mem[27][15] ,rv151.\soc.rf.mem[27][14] ,rv151.\soc.rf.mem[27][13] ,rv151.\soc.rf.mem[27][12] , 
					  rv151.\soc.rf.mem[27][11] ,rv151.\soc.rf.mem[27][10] ,rv151.\soc.rf.mem[27][9]  ,rv151.\soc.rf.mem[27][8] , 
					  rv151.\soc.rf.mem[27][7]  ,rv151.\soc.rf.mem[27][6]  ,rv151.\soc.rf.mem[27][5]  ,rv151.\soc.rf.mem[27][4] , 
					  rv151.\soc.rf.mem[27][3]  ,rv151.\soc.rf.mem[27][2]  ,rv151.\soc.rf.mem[27][1]  ,rv151.\soc.rf.mem[27][0] } ;
		RF.mem[28]  = {rv151.\soc.rf.mem[28][31] ,rv151.\soc.rf.mem[28][30] ,rv151.\soc.rf.mem[28][29] ,rv151.\soc.rf.mem[28][28] , 
					  rv151.\soc.rf.mem[28][27] ,rv151.\soc.rf.mem[28][26] ,rv151.\soc.rf.mem[28][25] ,rv151.\soc.rf.mem[28][24] , 
					  rv151.\soc.rf.mem[28][23] ,rv151.\soc.rf.mem[28][22] ,rv151.\soc.rf.mem[28][21] ,rv151.\soc.rf.mem[28][20] , 
					  rv151.\soc.rf.mem[28][19] ,rv151.\soc.rf.mem[28][18] ,rv151.\soc.rf.mem[28][17] ,rv151.\soc.rf.mem[28][16] , 
					  rv151.\soc.rf.mem[28][15] ,rv151.\soc.rf.mem[28][14] ,rv151.\soc.rf.mem[28][13] ,rv151.\soc.rf.mem[28][12] , 
					  rv151.\soc.rf.mem[28][11] ,rv151.\soc.rf.mem[28][10] ,rv151.\soc.rf.mem[28][9]  ,rv151.\soc.rf.mem[28][8] , 
					  rv151.\soc.rf.mem[28][7]  ,rv151.\soc.rf.mem[28][6]  ,rv151.\soc.rf.mem[28][5]  ,rv151.\soc.rf.mem[28][4] , 
					  rv151.\soc.rf.mem[28][3]  ,rv151.\soc.rf.mem[28][2]  ,rv151.\soc.rf.mem[28][1]  ,rv151.\soc.rf.mem[28][0] } ;
		RF.mem[29]  = {rv151.\soc.rf.mem[29][31] ,rv151.\soc.rf.mem[29][30] ,rv151.\soc.rf.mem[29][29] ,rv151.\soc.rf.mem[29][28] , 
					  rv151.\soc.rf.mem[29][27] ,rv151.\soc.rf.mem[29][26] ,rv151.\soc.rf.mem[29][25] ,rv151.\soc.rf.mem[29][24] , 
					  rv151.\soc.rf.mem[29][23] ,rv151.\soc.rf.mem[29][22] ,rv151.\soc.rf.mem[29][21] ,rv151.\soc.rf.mem[29][20] , 
					  rv151.\soc.rf.mem[29][19] ,rv151.\soc.rf.mem[29][18] ,rv151.\soc.rf.mem[29][17] ,rv151.\soc.rf.mem[29][16] , 
					  rv151.\soc.rf.mem[29][15] ,rv151.\soc.rf.mem[29][14] ,rv151.\soc.rf.mem[29][13] ,rv151.\soc.rf.mem[29][12] , 
					  rv151.\soc.rf.mem[29][11] ,rv151.\soc.rf.mem[29][10] ,rv151.\soc.rf.mem[29][9]  ,rv151.\soc.rf.mem[29][8] , 
					  rv151.\soc.rf.mem[29][7]  ,rv151.\soc.rf.mem[29][6]  ,rv151.\soc.rf.mem[29][5]  ,rv151.\soc.rf.mem[29][4] , 
					  rv151.\soc.rf.mem[29][3]  ,rv151.\soc.rf.mem[29][2]  ,rv151.\soc.rf.mem[29][1]  ,rv151.\soc.rf.mem[29][0] } ;
		RF.mem[30]  = {rv151.\soc.rf.mem[30][31] ,rv151.\soc.rf.mem[30][30] ,rv151.\soc.rf.mem[30][29] ,rv151.\soc.rf.mem[30][28] , 
					  rv151.\soc.rf.mem[30][27] ,rv151.\soc.rf.mem[30][26] ,rv151.\soc.rf.mem[30][25] ,rv151.\soc.rf.mem[30][24] , 
					  rv151.\soc.rf.mem[30][23] ,rv151.\soc.rf.mem[30][22] ,rv151.\soc.rf.mem[30][21] ,rv151.\soc.rf.mem[30][20] , 
					  rv151.\soc.rf.mem[30][19] ,rv151.\soc.rf.mem[30][18] ,rv151.\soc.rf.mem[30][17] ,rv151.\soc.rf.mem[30][16] , 
					  rv151.\soc.rf.mem[30][15] ,rv151.\soc.rf.mem[30][14] ,rv151.\soc.rf.mem[30][13] ,rv151.\soc.rf.mem[30][12] , 
					  rv151.\soc.rf.mem[30][11] ,rv151.\soc.rf.mem[30][10] ,rv151.\soc.rf.mem[30][9]  ,rv151.\soc.rf.mem[30][8] , 
					  rv151.\soc.rf.mem[30][7]  ,rv151.\soc.rf.mem[30][6]  ,rv151.\soc.rf.mem[30][5]  ,rv151.\soc.rf.mem[30][4] , 
					  rv151.\soc.rf.mem[30][3]  ,rv151.\soc.rf.mem[30][2]  ,rv151.\soc.rf.mem[30][1]  ,rv151.\soc.rf.mem[30][0] } ;
		RF.mem[31]  = {rv151.\soc.rf.mem[31][31] ,rv151.\soc.rf.mem[31][30] ,rv151.\soc.rf.mem[31][29] ,rv151.\soc.rf.mem[31][28] , 
					  rv151.\soc.rf.mem[31][27] ,rv151.\soc.rf.mem[31][26] ,rv151.\soc.rf.mem[31][25] ,rv151.\soc.rf.mem[31][24] , 
					  rv151.\soc.rf.mem[31][23] ,rv151.\soc.rf.mem[31][22] ,rv151.\soc.rf.mem[31][21] ,rv151.\soc.rf.mem[31][20] , 
					  rv151.\soc.rf.mem[31][19] ,rv151.\soc.rf.mem[31][18] ,rv151.\soc.rf.mem[31][17] ,rv151.\soc.rf.mem[31][16] , 
					  rv151.\soc.rf.mem[31][15] ,rv151.\soc.rf.mem[31][14] ,rv151.\soc.rf.mem[31][13] ,rv151.\soc.rf.mem[31][12] , 
					  rv151.\soc.rf.mem[31][11] ,rv151.\soc.rf.mem[31][10] ,rv151.\soc.rf.mem[31][9]  ,rv151.\soc.rf.mem[31][8] , 
					  rv151.\soc.rf.mem[31][7]  ,rv151.\soc.rf.mem[31][6]  ,rv151.\soc.rf.mem[31][5]  ,rv151.\soc.rf.mem[31][4] , 
					  rv151.\soc.rf.mem[31][3]  ,rv151.\soc.rf.mem[31][2]  ,rv151.\soc.rf.mem[31][1]  ,rv151.\soc.rf.mem[31][0] } ;
	end

`endif

  hdp_rv151 rv151 (
    .io_bcf(bcfg),
    .io_scs(bscs),
    .io_sdi(bsdi),
    .io_sdo(bsdo),
    .io_sck(bsck),
    .io_hlt(),
    .io_irc(),
    .serial_in(1'b1),
    .serial_out(),
    .gpio_in(~gpio_out),
    .gpio_out(gpio_out),
    .gpio_oeb(gpio_oeb),
    .io_cslt(1'b1),
    .io_clk(clk),
    .io_rst(rst),
    .clk(1'b0),
    .rst(1'b0)
  );

  // A task to check if the value contained in a register equals an expected value
  task check_reg;
    input [4:0] reg_number;
    input [31:0] expected_value;
    input [10:0] test_num;
    if (expected_value !== `RF_PATH .mem[reg_number]) begin
      $display("FAIL - test %d, got: %d(%08x), expected: %d(%08x) for reg %d",
               test_num, `RF_PATH .mem[reg_number], `RF_PATH .mem[reg_number], expected_value, expected_value, reg_number);
      $finish();
    end
    else begin
      $display("PASS - test %d, got: 0x%08x for reg %d", test_num, expected_value, reg_number);
    end
  endtask

  // A task that runs the simulation until a register contains some value
  task wait_for_reg_to_equal;
    input [4:0] reg_number;
    input [31:0] expected_value;
    while (`RF_PATH .mem[reg_number] !== expected_value)
      @(posedge clk);
  endtask

  reg [31:0] IMM;
  reg [31:0] CLU;

  initial begin

    $display("[INFO] %s (%s) test-bench, clk-freq: %d", "gpio_tb_dmem", SIM_MODE, CPU_CLOCK_FREQ);

    `ifndef IVERILOG
        $vcdpluson;
    `endif
    `ifdef IVERILOG
    `ifdef SYN
        $dumpfile("gpio_tb_bmem_syn.fst");
    `elsif RGL
      `ifdef SDF
        $dumpfile("gpio_tb_bmem_rgl+sdf.fst");
      `else
        $dumpfile("gpio_tb_bmem_rgl.fst");
      `endif
    `else
        $dumpfile("gpio_tb_bmem.fst");
    `endif
        $dumpvars(0, gpio_tb);
    `endif
    rst = 0;

//===================================
    $display("[INFO] TEST GPIO");

    // Reset the CPU
    rst = 1;
    repeat (5) @(posedge clk);

    //DMEM

    IMM = 32'd10;
    `BIOS_PATH .mem[0] = {IMM[11:0], 5'd0, `FNC_ADD_SUB, 5'd20, `OPC_ARI_ITYPE};

    IMM = 32'h8000001C;
    `BIOS_PATH .mem[1] = {IMM[31:12], 5'd30, `OPC_LUI};

    IMM = 32'h00A500A5;
    `BIOS_PATH .mem[2] = {IMM[31:12], 5'd21, `OPC_LUI};
    `BIOS_PATH .mem[3] = {IMM[11:0], 5'd21, `FNC_ADD_SUB, 5'd21, `OPC_ARI_ITYPE};
    IMM = 32'h8000001C;
    `BIOS_PATH .mem[4] = {IMM[11:5], 5'd21, 5'd30,  `FNC_SW, IMM[4:0], `OPC_STORE};
    `BIOS_PATH .mem[5] = {IMM[11:0], 5'd30, `FNC_LW,  5'd1,  `OPC_LOAD};

    IMM = 32'h005A005A;
    `BIOS_PATH .mem[6] = {IMM[31:12], 5'd21, `OPC_LUI};
    `BIOS_PATH .mem[7] = {IMM[11:0], 5'd21, `FNC_ADD_SUB, 5'd21, `OPC_ARI_ITYPE};
    IMM = 32'h8000001C;
    `BIOS_PATH .mem[8] = {IMM[11:5], 5'd21, 5'd30,  `FNC_SW, IMM[4:0], `OPC_STORE};
    `BIOS_PATH .mem[9] = {IMM[11:0], 5'd30, `FNC_LW,  5'd2,  `OPC_LOAD};

    IMM = 32'd11;
    `BIOS_PATH .mem[10] = {IMM[11:0], 5'd0, `FNC_ADD_SUB, 5'd20, `OPC_ARI_ITYPE};

    repeat (5) @(posedge clk);

    @(negedge clk);
    rst = 0; 

    // Your processor should begin executing the code in /software/asm/start.s

    // Tests
    wait_for_reg_to_equal(20, 32'd10);       // Run the simulation until the flag is set to 10
    wait_for_reg_to_equal(20, 32'd11);       // Run the simulation until the flag is set to 11
    check_reg(1, 32'h00A5005A, 1);           // Verify x1
    check_reg(2, 32'h005A00A5, 2);           // Verify x1
    $fflush();

//===================================
    $display("gpio_tb_bmem TESTS PASSED! [%s]", SIM_MODE);
    $finish();
  end

  initial begin
    repeat (5000) @(posedge clk);
    $display("Failed: timing out");
    $fatal();
  end

  task bspi_wr;
    input [10:0] ad;
    input [31:0] dt;
    reg [15:0] hd;
    begin
      hd = {2'h2, {3{1'b0}}, ad};

      bscs = 1'b0;

      for(integer i=0; i<16; i=i+1) begin
        {bsck, bsdi} = {1'b0, hd[15-i]};
        #(SPI_CLOCK_PERIOD/2);
        {bsck, bsdi} = {1'b1, hd[15-i]};
        #(SPI_CLOCK_PERIOD/2);
      end

      for(integer i=0; i<32; i=i+1) begin
        {bsck, bsdi} = {1'b0, dt[31-i]};
        #(SPI_CLOCK_PERIOD/2);
        {bsck, bsdi} = {1'b1, dt[31-i]};
        #(SPI_CLOCK_PERIOD/2);
      end

      bscs = 1'b1;
      {bsck, bsdi} = {1'b0, 1'b0};
      #(SPI_CLOCK_PERIOD);

      repeat(4) @(posedge clk);
      //$display("hd[%04X]", hd); //debug 

      $display("bspi_wr[%04X]:%08X", ad, dt);

      $fflush();

    end
  endtask

endmodule
