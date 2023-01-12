`timescale 1ns/1ns

`include "opcode.vh"
`include "mem_path.vh"

`ifdef SYN
localparam SIM_MODE = "SYN ";
`else
localparam SIM_MODE = "RTL ";
`endif

`ifdef SYN
module tb_rf();
  reg [31:0] mem [0:31];
endmodule
`endif

module asm_tb();
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

`ifdef SYN
  tb_rf RF();

  //FLATTEN
  always@(*) begin
      RF.mem[1]  = soc.\rf.mem[1] ;
      RF.mem[2]  = soc.\rf.mem[2] ;
      RF.mem[3]  = soc.\rf.mem[3] ;
      RF.mem[4]  = soc.\rf.mem[4] ;
      RF.mem[5]  = soc.\rf.mem[5] ;
      RF.mem[6]  = soc.\rf.mem[6] ;
      RF.mem[7]  = soc.\rf.mem[7] ;
      RF.mem[8]  = soc.\rf.mem[8] ;
      RF.mem[9]  = soc.\rf.mem[9] ;
      RF.mem[10] = soc.\rf.mem[10] ;
      RF.mem[11] = soc.\rf.mem[11] ;
      RF.mem[12] = soc.\rf.mem[12] ;
      RF.mem[13] = soc.\rf.mem[13] ;
      RF.mem[14] = soc.\rf.mem[14] ;
      RF.mem[15] = soc.\rf.mem[15] ;
      RF.mem[16] = soc.\rf.mem[16] ;
      RF.mem[17] = soc.\rf.mem[17] ;
      RF.mem[18] = soc.\rf.mem[18] ;
      RF.mem[19] = soc.\rf.mem[19] ;
      RF.mem[20] = soc.\rf.mem[20] ;
      RF.mem[21] = soc.\rf.mem[21] ;
      RF.mem[22] = soc.\rf.mem[22] ;
      RF.mem[23] = soc.\rf.mem[23] ;
      RF.mem[24] = soc.\rf.mem[24] ;
      RF.mem[25] = soc.\rf.mem[25] ;
      RF.mem[26] = soc.\rf.mem[26] ;
      RF.mem[27] = soc.\rf.mem[27] ;
      RF.mem[28] = soc.\rf.mem[28] ;
      RF.mem[29] = soc.\rf.mem[29] ;
      RF.mem[30] = soc.\rf.mem[30] ;
      RF.mem[31] = soc.\rf.mem[31] ;
  end

//  always@(*) begin
//      RF.mem[1]  = soc.rf.\mem[1] ;
//      RF.mem[2]  = soc.rf.\mem[2] ;
//      RF.mem[3]  = soc.rf.\mem[3] ;
//      RF.mem[4]  = soc.rf.\mem[4] ;
//      RF.mem[5]  = soc.rf.\mem[5] ;
//      RF.mem[6]  = soc.rf.\mem[6] ;
//      RF.mem[7]  = soc.rf.\mem[7] ;
//      RF.mem[8]  = soc.rf.\mem[8] ;
//      RF.mem[9]  = soc.rf.\mem[9] ;
//      RF.mem[10] = soc.rf.\mem[10] ;
//      RF.mem[11] = soc.rf.\mem[11] ;
//      RF.mem[12] = soc.rf.\mem[12] ;
//      RF.mem[13] = soc.rf.\mem[13] ;
//      RF.mem[14] = soc.rf.\mem[14] ;
//      RF.mem[15] = soc.rf.\mem[15] ;
//      RF.mem[16] = soc.rf.\mem[16] ;
//      RF.mem[17] = soc.rf.\mem[17] ;
//      RF.mem[18] = soc.rf.\mem[18] ;
//      RF.mem[19] = soc.rf.\mem[19] ;
//      RF.mem[20] = soc.rf.\mem[20] ;
//      RF.mem[21] = soc.rf.\mem[21] ;
//      RF.mem[22] = soc.rf.\mem[22] ;
//      RF.mem[23] = soc.rf.\mem[23] ;
//      RF.mem[24] = soc.rf.\mem[24] ;
//      RF.mem[25] = soc.rf.\mem[25] ;
//      RF.mem[26] = soc.rf.\mem[26] ;
//      RF.mem[27] = soc.rf.\mem[27] ;
//      RF.mem[28] = soc.rf.\mem[28] ;
//      RF.mem[29] = soc.rf.\mem[29] ;
//      RF.mem[30] = soc.rf.\mem[30] ;
//      RF.mem[31] = soc.rf.\mem[31] ;
//  end

`endif

  rv151_soc #(
`ifndef SYN
    .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ),
    .RESET_PC(32'h4000_0000)
`endif
  ) soc (
    .clk(clk),
    .rst(rst),
    .io_bcf(bcfg),
    .io_scs(bscs),
    .io_sdi(bsdi),
    .io_sdo(bsdo),
    .io_sck(bsck),
    .io_hlt(),
    .io_irc(),
    .serial_in(1'b1),
    .serial_out()
  );

  // A task to check if the value contained in a register equals an expected value
  task check_reg;
    input [4:0] reg_number;
    input [31:0] expected_value;
    input [10:0] test_num;
    if (expected_value !== `RF_PATH.mem[reg_number]) begin
      $display("FAIL - test %d, got: %d, expected: %d for reg %d",
               test_num, `RF_PATH.mem[reg_number], expected_value, reg_number);
      $finish();
    end
    else begin
      $display("PASS - test %d, got: %d for reg %d", test_num, expected_value, reg_number);
    end
  endtask

  // A task that runs the simulation until a register contains some value
  task wait_for_reg_to_equal;
    input [4:0] reg_number;
    input [31:0] expected_value;
    while (`RF_PATH.mem[reg_number] !== expected_value)
      @(posedge clk);
  endtask

  reg [31:0] IMM;

  initial begin

    $display("[INFO] %s (%s) test-bench, clk-freq: %d", "asm_tb_dmem", SIM_MODE, CPU_CLOCK_FREQ);

    `ifndef IVERILOG
        $vcdpluson;
    `endif
    `ifdef IVERILOG
    `ifdef SYN
        $dumpfile("bspi_tb_bmem_syn.fst");
    `else
        $dumpfile("bspi_tb_bmem.fst");
    `endif
        $dumpvars(0, asm_tb);
    `endif
    rst = 0;

//===================================
    $display("[INFO] TEST I/DMEM0");

    // Reset the CPU
    rst = 1;
    repeat (5) @(posedge clk);

    //DMEM
    IMM = 32'd300;
    `DME0_PATH.mem[0] = {IMM[11:0], 5'd0, `FNC_ADD_SUB, 5'd1, `OPC_ARI_ITYPE};
    IMM = 32'd1;
    `DME0_PATH.mem[1] = {IMM[11:0], 5'd0, `FNC_ADD_SUB, 5'd20, `OPC_ARI_ITYPE};

    repeat (5) @(posedge clk);

    @(negedge clk);
    rst = 0; 
    
    repeat(10) @(negedge clk);
    bcfg = 1'b1;
    IMM = 32'd10;
    bspi_wr(11'h000+0, {IMM[11:0], 5'd0, `FNC_ADD_SUB, 5'd20, `OPC_ARI_ITYPE});
    IMM = 32'h30000000; //R-DMEM0
    bspi_wr(11'h000+1, {IMM[31:12], 5'd29, `OPC_LUI});
    IMM = 32'h20000000; //W-IMEM0
    bspi_wr(11'h000+2, {IMM[31:12], 5'd30, `OPC_LUI});
    IMM = 32'h30000000; //R-DMEM0
    bspi_wr(11'h000+3, {IMM[11:0], 5'd29, `FNC_LW, 5'd10, `OPC_LOAD});
    IMM = 32'h20000000; //W-IMEM0
    bspi_wr(11'h000+4, {IMM[11:5] , 5'd10, 5'd30, `FNC_SW, IMM[4:0], `OPC_STORE});
    IMM = 32'h30000004; //R-DMEM0
    bspi_wr(11'h000+5, {IMM[11:0], 5'd29, `FNC_LW, 5'd10, `OPC_LOAD});
    IMM = 32'h20000004; //W-IMEM0
    bspi_wr(11'h000+6, {IMM[11:5] , 5'd10, 5'd30, `FNC_SW, IMM[4:0], `OPC_STORE});
    IMM = 32'h10000000; //E-IMEM0
    bspi_wr(11'h000+7, {IMM[31:12], 5'd30, `OPC_LUI});
    bspi_wr(11'h000+8, {IMM[11:0], 5'd30, 3'b000, 5'd31, `OPC_JALR});

    @(negedge clk);
    bcfg = 1'b0;

    // Your processor should begin executing the code in /software/asm/start.s

    // Tests
    wait_for_reg_to_equal(20, 32'd10);       // Run the simulation until the flag is set to 10
    wait_for_reg_to_equal(20, 32'd1);       // Run the simulation until the flag is set to 1
    check_reg(1, 32'd300, 1);               // Verify that x1 contains 300
    $fflush();

//===================================
    $display("[INFO] TEST I/DMEM1");

    // Reset the CPU
    rst = 1;
    repeat (5) @(posedge clk);

    //DMEM
    IMM = 32'd310;
    `DME1_PATH.mem[0] = {IMM[11:0], 5'd0, `FNC_ADD_SUB, 5'd1, `OPC_ARI_ITYPE};
    IMM = 32'd1;
    `DME1_PATH.mem[1] = {IMM[11:0], 5'd0, `FNC_ADD_SUB, 5'd20, `OPC_ARI_ITYPE};

    repeat (5) @(posedge clk);

    @(negedge clk);
    rst = 0; 
    
    repeat(10) @(negedge clk);
    bcfg = 1'b1;
    IMM = 32'd20;
    bspi_wr(11'h000+0, {IMM[11:0], 5'd0, `FNC_ADD_SUB, 5'd20, `OPC_ARI_ITYPE});
    IMM = 32'h30002000; //R-DMEM1
    bspi_wr(11'h000+1, {IMM[31:12], 5'd29, `OPC_LUI});
    IMM = 32'h20002000; //W-IMEM1
    bspi_wr(11'h000+2, {IMM[31:12], 5'd30, `OPC_LUI});
    IMM = 32'h30002000; //R-DMEM1
    bspi_wr(11'h000+3, {IMM[11:0], 5'd29, `FNC_LW, 5'd10, `OPC_LOAD});
    IMM = 32'h20002000; //W-IMEM1
    bspi_wr(11'h000+4, {IMM[11:5] , 5'd10, 5'd30, `FNC_SW, IMM[4:0], `OPC_STORE});
    IMM = 32'h30002004; //R-DMEM1
    bspi_wr(11'h000+5, {IMM[11:0], 5'd29, `FNC_LW, 5'd10, `OPC_LOAD});
    IMM = 32'h20002004; //W-IMEM1
    bspi_wr(11'h000+6, {IMM[11:5] , 5'd10, 5'd30, `FNC_SW, IMM[4:0], `OPC_STORE});
    IMM = 32'h10002000; //E-IMEM1
    bspi_wr(11'h000+7, {IMM[31:12], 5'd30, `OPC_LUI});
    bspi_wr(11'h000+8, {IMM[11:0], 5'd30, 3'b000, 5'd31, `OPC_JALR});

    @(negedge clk);
    bcfg = 1'b0;

    // Your processor should begin executing the code in /software/asm/start.s

    // Tests
    wait_for_reg_to_equal(20, 32'd20);       // Run the simulation until the flag is set to 20
    wait_for_reg_to_equal(20, 32'd1);       // Run the simulation until the flag is set to 1
    check_reg(1, 32'd310, 1);               // Verify that x1 contains 300
    $fflush();

//===================================
    $display("bspi_tb_bmem TESTS PASSED! [%s]", SIM_MODE);
    $finish();
  end

  initial begin
    repeat (2000) @(posedge clk);
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
