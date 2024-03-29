`timescale 1ns/1ns
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

module echo_tb();
  reg clk, rst;
  parameter CPU_CLOCK_PERIOD = 100;
  parameter CPU_CLOCK_FREQ   = 1_000_000_000 / CPU_CLOCK_PERIOD;
  //localparam BAUD_RATE       = 1_000_000;
  localparam BAUD_RATE       = 115_200;
  localparam BAUD_PERIOD     = 1_000_000_000 / BAUD_RATE; // 8680.55 ns

  localparam CHAR0     = 8'h61; // ~ 'a'
  localparam NUM_CHARS = 10;

  localparam TIMEOUT_CYCLE = 10_000 * NUM_CHARS;

  initial clk = 0;
  always #(CPU_CLOCK_PERIOD/2) clk = ~clk;

  reg  serial_in;
  wire serial_out;
  reg bp_enable = 1'b0;

  hdp_rv151 rv151 (
    .io_bcf(1'b0),
    .io_scs(1'b0),
    .io_sdi(1'b0),
    .io_sdo(),
    .io_sck(1'b0),
    .io_hlt(),
    .io_irc(),
    .serial_in(serial_in),   // input
    .serial_out(serial_out),  // output
    .gpio_in(8'h0),
    .gpio_out(),
    .gpio_oeb(),
    .io_cslt(1'b1),
    .io_clk(clk),
    .io_rst(rst),
    .clk(1'b0),
    .rst(1'b0)
  );

`ifdef RTL
initial begin: rpt_baud_bits
  #1; $display("[INFO] BAUD_BITS: %d, uart_baud_edge: 0x%08x", rv151.soc.BAUD_BITS, rv151.soc.uart_baud_edge);
end
`endif

`ifdef RGL
  `ifdef SDF
    initial begin : load_sdf
      `ifdef MAX
        $display("INFO: Load MAX-SDF");
        $sdf_annotate("../rgl/sdf/hdp_rv151.ss.sdf", rv151) ;
      `elsif MIN
        $display("INFO: Load MIN-SDF");
        $sdf_annotate("../rgl/sdf/hdp_rv151.ff.sdf", rv151) ;
      `elsif NOM
        $display("INFO: Load NOM-SDF");
        $sdf_annotate("../rgl/sdf/hdp_rv151.tt.sdf", rv151) ;
      `else
        $display("INFO: no-SDF");
      `endif
    end
  `endif
`endif

  integer i, j, c, c1, c2;
  reg [31:0] cycle;
  always @(posedge clk) begin
    if (rst === 1)
      cycle <= 0;
    else
      cycle <= cycle + 1;
  end

  integer num_mismatches = 0;

  // this holds characters sent by the host via serial line
  reg [7:0] chars_from_host [NUM_CHARS-1:0];
  // this holds characters received by the host via serial line
  reg [9:0] chars_to_host   [NUM_CHARS-1:0];

  // initialize test vectors
  initial begin
    #0;
    for (c = 0; c < NUM_CHARS; c = c + 1) begin
      chars_from_host[c] = CHAR0 + c;
    end
  end

  // Host off-chip UART --> FPGA on-chip UART (receiver)
  // The host (testbench) sends a character to the CPU via the serial line
  task host_to_fpga;
    begin
      for (c1 = 0; c1 < NUM_CHARS; c1 = c1 + 1) begin
        serial_in = 0;
        #(BAUD_PERIOD);
        // Data bits (payload)
        for (i = 0; i < 8; i = i + 1) begin
          serial_in = chars_from_host[c1][i];
          #(BAUD_PERIOD);
        end
        // Stop bit
        serial_in = 1;
        #(BAUD_PERIOD);

        $display("[time %t, sim. cycle %d] [Host (tb) --> TB_SERIAL_RX] Sent char 8'h%h",
                 $time, cycle, chars_from_host[c1]);
        $fflush();
        repeat (100) @(posedge clk); // Give time for the echo program to process each character
      end
    end
  endtask

  // Host off-chip UART <-- TB on-chip UART (transmitter)
  // The host (testbench) expects to receive a character from the CPU via the serial line (echoed)
  task fpga_to_host;
    begin

      for (c2 = 0; c2 < NUM_CHARS; c2 = c2 + 1) begin
        // Wait until serial_out is LOW (start of transaction)
        wait (serial_out === 1'b0);

        for (j = 0; j < 10; j = j + 1) begin
          // sample output half-way through the baud period to avoid tricky edge cases
          #(BAUD_PERIOD / 2);
          chars_to_host[c2][j] = serial_out;
          #(BAUD_PERIOD / 2);
        end

        $display("[time %t, sim. cycle %d] [Host (tb) <-- TB_SERIAL_TX] Got char: start_bit=%b, payload=8'h%h, stop_bit=%b",
                 $time, cycle, chars_to_host[c2][0], chars_to_host[c2][8:1], chars_to_host[c2][9]);
        $fflush();
      end
    end
  endtask

  initial begin

    $display("[INFO] %s (%s) test-bench, clk-freq: %d", "echo_tb_bmem", SIM_MODE, CPU_CLOCK_FREQ);

    $readmemh("../../software/echo/echo.hex", `BIOS_PATH .mem);

    `ifndef IVERILOG
        $vcdpluson;
    `endif
    `ifdef IVERILOG
      `ifdef SYN
        $dumpfile("echo_tb_bmem_syn.fst");
      `elsif RGL
        `ifdef SDF
          $dumpfile("echo_tb_bmem_rgl+sdf.fst");
        `else
          $dumpfile("echo_tb_bmem_rgl.fst");
        `endif
      `else
        $dumpfile("echo_tb_bmem.fst");
      `endif
        $dumpvars(0, echo_tb);
    `endif
    rst = 1;
    serial_in = 1;

    // Hold reset for a while
    repeat (10) @(posedge clk);

    @(negedge clk);
    rst = 0;

    // Delay for some time
    repeat (10) @(posedge clk);

    fork
      begin
        host_to_fpga();
      end
      begin
        fpga_to_host();
      end
    join

    // Check results
    for (c = 0; c < NUM_CHARS; c = c + 1) begin
      if (chars_from_host[c] !== chars_to_host[c][8:1]) begin
        $display("Mismatches at char %d: char_from_host=%h, char_to_host=%h",
                 c, chars_from_host[c], chars_to_host[c][8:1]);
                 num_mismatches = num_mismatches + 1;
      end
    end

    if (num_mismatches > 0)
      $display("echo_tb_bmem Test failed [%s]", SIM_MODE);
    else
      $display("echo_tb_bmem Test passed! [%s]", SIM_MODE);

    $finish();
  end

  initial begin
    repeat (TIMEOUT_CYCLE) @(posedge clk);
    $display("Timeout!");
    $fatal();
  end

endmodule
