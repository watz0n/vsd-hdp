// MIT License
// -----------
// 
// Copyright (c) 2023 Watson Huang (watson.edx@gmail.com)
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// -----------
// SPDX-License-Identifier: MIT

module rv151_soc #(
    //parameter CPU_CLOCK_FREQ = 50_000_000,
    parameter CPU_CLOCK_FREQ = 10_000_000,
    parameter RESET_PC = 32'h4000_0000,
    parameter BAUD_RATE = 115200,
    parameter MIN_BDRT = 9600
) (
    input  io_bcf,
    input  io_scs,
    input  io_sdi,
    output io_sdo,
    input  io_sck,

    output io_hlt,
    output io_irc,

    input  serial_in,
    output serial_out,

    input  [7:0] gpio_in,
    output [7:0] gpio_out,
    output [7:0] gpio_oeb,
    
    input  clk,
    input  rst
);

    //Register-File
    wire        rf_wen;
    wire [4:0]  rf_wad;
    wire [31:0] rf_wdt;
    wire [4:0]  rf_ra1;
    wire [4:0]  rf_ra2;
    wire [31:0] rf_rd1;
    wire [31:0] rf_rd2;

    //Instruction Memory
    wire        mi_en;
    wire [31:0] mi_ad;
    wire [3:0]  mi_we;
    wire [31:0] mi_wd;
    wire [31:0] mi_rd;

    //Data Memory
    wire        md_en;
    wire [31:0] md_ad;
    wire [3:0]  md_we;
    wire [31:0] md_wd;
    wire [31:0] md_rd;

    //CSR
    wire        cs_en;
    wire [11:0] cs_ad;
    wire        cs_we;
    wire [31:0] cs_wd;
    wire [31:0] cs_rd;

    //Debug-Status
    wire        ds_irc;
    wire        ds_hlt;
    wire [31:0] ds_hpc;

//===========

    localparam SRAM_AWDH = 9;

//===========

    wire        bcsb;
    wire [3:0]  bweb;
    wire [10:0] badr;
    wire [31:0] bdti;
    wire [31:0] bdto;

    wire      bcf;
    reg [1:0] bcf_sr;

    assign bcf = bcf_sr[1];

    always@(posedge clk or posedge rst) begin
      if(rst) begin
        bcf_sr <= 2'h0;
      end
      else begin
        bcf_sr <= {bcf_sr[0], io_bcf};
      end
    end

    bspi bspi(

      .io_bcf(io_bcf),
      .io_scs(io_scs),
      .io_sdi(io_sdi),
      .io_sdo(io_sdo),
      .io_sck(io_sck),

      .bcsb(bcsb),
      .bweb(bweb),
      .badr(badr),
      .bdti(bdti),
      .bdto(bdto),

      .rstn(~rst),
      .clk(clk)
    );

    localparam BMEM_AWDH = 10; //4KB
    localparam BMEM_SWMX = BMEM_AWDH-SRAM_AWDH;
    localparam BMEM_SWDH = 'h1<<(BMEM_SWMX);

    wire [BMEM_SWDH-1:0] bios_mxa;
    wire [BMEM_SWDH-1:0] bios_mxb;

    wire [BMEM_AWDH-1:0] bios_addra, bios_addrb;
    wire [BMEM_SWDH-1:0] bios_ena;
    wire [BMEM_SWDH-1:0] bios_enb;

    wire [31:0] bios_dout0 [BMEM_SWDH-1:0];
    wire [31:0] bios_dout1 [BMEM_SWDH-1:0];
    reg  [31:0] bios_douta, bios_doutb;

    wire        bios_web0  ;
    wire [3:0]  bios_wmask0;
    wire [31:0] bios_din0  ;

    sky130_sram_2kbyte_1rw1r_32x512_8 bios_mem0(
      // Port 0: RW
      .clk0(clk),
      .csb0(~bios_ena[0]),
      .web0(bios_web0),
      .wmask0(bios_wmask0),
      .addr0(bios_addra[0+:SRAM_AWDH]),
      .din0(bios_din0),
      .dout0(bios_dout0[0]),
      // Port 1: R
      .clk1(clk),
      .csb1(~bios_enb[0]),
      .addr1(bios_addrb[0+:SRAM_AWDH]),
      .dout1(bios_dout1[0])
    );

    sky130_sram_2kbyte_1rw1r_32x512_8 bios_mem1(
      // Port 0: RW
      .clk0(clk),
      .csb0(~bios_ena[1]),
      .web0(bios_web0),
      .wmask0(bios_wmask0),
      .addr0(bios_addra[0+:SRAM_AWDH]),
      .din0(bios_din0),
      .dout0(bios_dout0[1]),
      // Port 1: R
      .clk1(clk),
      .csb1(~bios_enb[1]),
      .addr1(bios_addrb[0+:SRAM_AWDH]),
      .dout1(bios_dout1[1])
    );
    
    assign bios_mxa = ({{(BMEM_SWDH-1){1'b0}},1'b1}) << (bios_addra[SRAM_AWDH+:BMEM_SWMX]);
    assign bios_mxb = ({{(BMEM_SWDH-1){1'b0}},1'b1}) << (bios_addrb[SRAM_AWDH+:BMEM_SWMX]);

    //assign bios_ena = mi_en&mi_ad[30];
    assign bios_ena = bcf ? {BMEM_SWDH{(~bcsb)}}&bios_mxa : {BMEM_SWDH{(mi_en&mi_ad[30])}}&bios_mxa;
    
    assign bios_enb = {BMEM_SWDH{(md_en&md_ad[30])}}&bios_mxb;
    
    //assign bios_addra = mi_ad[2+:BMEM_AWDH];
    assign bios_addra = bcf ? badr : (mi_ad[2+:BMEM_AWDH]);
    
    assign bios_addrb = md_ad[2+:BMEM_AWDH];

    assign bios_web0   = bcf ? &bweb : 1'b1  ;
    assign bios_wmask0 = bcf ? ~bweb : 4'h0  ;
    assign bios_din0   = bcf ? bdti  : 32'h0 ;

    always@(posedge clk) begin
        {bios_doutb, bios_douta} <= {bios_dout1[bios_addrb[SRAM_AWDH+:BMEM_SWMX]], bios_dout0[bios_addra[SRAM_AWDH+:BMEM_SWMX]]};
    end

    assign bdto = bios_douta;

//===========

    //localparam DMEM_AWDH = 11; //8KB //Route-Congestion
    localparam DMEM_AWDH = 10; //4KB
    localparam DMEM_SWMX = DMEM_AWDH-SRAM_AWDH;
    localparam DMEM_SWDH = 'h1<<(DMEM_SWMX);

    wire [DMEM_SWDH-1:0] dmem_mxa;

    wire [DMEM_AWDH-1:0] dmem_addr;
    wire [31:0] dmem_din; 
    wire [3:0] dmem_we;
    
    wire [3:0] dmem_web;

    wire [DMEM_SWDH-1:0] dmem_en;
    wire [31:0] dmem_dout0 [DMEM_SWDH-1:0];

    reg  [31:0] dmem_dout;

    sky130_sram_2kbyte_1rw1r_32x512_8 dmem0(
      // Port 0: RW
      .clk0(clk),
      .csb0(~dmem_en[0]),
      .web0(&dmem_web),
      .wmask0(dmem_we),
      .addr0(dmem_addr[0+:SRAM_AWDH]),
      .din0(dmem_din),
      .dout0(dmem_dout0[0]),
      // Port 1: R
      .clk1(1'b0),
      .csb1(1'b1),
      .addr1({SRAM_AWDH{1'b1}}),
      .dout1()
    );

    sky130_sram_2kbyte_1rw1r_32x512_8 dmem1(
      // Port 0: RW
      .clk0(clk),
      .csb0(~dmem_en[1]),
      .web0(&dmem_web),
      .wmask0(dmem_we),
      .addr0(dmem_addr[0+:SRAM_AWDH]),
      .din0(dmem_din),
      .dout0(dmem_dout0[1]),
      // Port 1: R
      .clk1(1'b0),
      .csb1(1'b1),
      .addr1({SRAM_AWDH{1'b1}}),
      .dout1()
    );
/* //8KB //Route-Congestion
    sky130_sram_2kbyte_1rw1r_32x512_8 dmem2(
      // Port 0: RW
      .clk0(clk),
      .csb0(~dmem_en[2]),
      .web0(&dmem_web),
      .wmask0(dmem_we),
      .addr0(dmem_addr[0+:SRAM_AWDH]),
      .din0(dmem_din),
      .dout0(dmem_dout0[2]),
      // Port 1: R
      .clk1(1'b0),
      .csb1(1'b1),
      .addr1({SRAM_AWDH{1'b1}}),
      .dout1()
    );

    sky130_sram_2kbyte_1rw1r_32x512_8 dmem3(
      // Port 0: RW
      .clk0(clk),
      .csb0(~dmem_en[3]),
      .web0(&dmem_web),
      .wmask0(dmem_we),
      .addr0(dmem_addr[0+:SRAM_AWDH]),
      .din0(dmem_din),
      .dout0(dmem_dout0[3]),
      // Port 1: R
      .clk1(1'b0),
      .csb1(1'b1),
      .addr1({SRAM_AWDH{1'b1}}),
      .dout1()
    );
*/
    assign dmem_mxa = ({{(DMEM_SWDH-1){1'b0}},1'b1}) << (dmem_addr[SRAM_AWDH+:DMEM_SWMX]);

    assign dmem_addr = md_ad[2+:DMEM_AWDH];
    assign dmem_din  = md_wd;
    assign dmem_we   = md_we;

    assign dmem_web  = ~dmem_we;

    assign dmem_en = {DMEM_SWDH{md_en&md_ad[28]}}&dmem_mxa;

    always@(posedge clk) begin
      dmem_dout <= dmem_dout0[dmem_addr[SRAM_AWDH+:DMEM_SWMX]];
    end

//===========

    //localparam IMEM_AWDH = 11; //8KB //Route-Congestion
    localparam IMEM_AWDH = 10; //4KB
    localparam IMEM_SWMX = IMEM_AWDH-SRAM_AWDH;
    localparam IMEM_SWDH = 'h1<<(IMEM_SWMX);

    wire [IMEM_SWDH-1:0] imem_mxa;
    wire [IMEM_SWDH-1:0] imem_mxb;

    wire [IMEM_AWDH-1:0] imem_addra, imem_addrb;
    wire [31:0] imem_dina; 
    wire [3:0] imem_wea;
    wire [3:0] imem_weba;

    wire [IMEM_SWDH-1:0] imem_ena;
    wire [IMEM_SWDH-1:0] imem_enb;
    wire [31:0] imem_dout1 [IMEM_SWDH-1:0];

    reg  [31:0] imem_doutb;

    sky130_sram_2kbyte_1rw1r_32x512_8 imem0(
      // Port 0: RW
      .clk0(clk),
      .csb0(~imem_ena[0]),
      .web0(&imem_weba),
      .wmask0(imem_wea),
      .addr0(imem_addra[0+:SRAM_AWDH]),
      .din0(imem_dina),
      .dout0(),
      // Port 1: R
      .clk1(clk),
      .csb1(~imem_enb[0]),
      .addr1(imem_addrb[0+:SRAM_AWDH]),
      .dout1(imem_dout1[0])
    );

    sky130_sram_2kbyte_1rw1r_32x512_8 imem1(
      // Port 0: RW
      .clk0(clk),
      .csb0(~imem_ena[1]),
      .web0(&imem_weba),
      .wmask0(imem_wea),
      .addr0(imem_addra[0+:SRAM_AWDH]),
      .din0(imem_dina),
      .dout0(),
      // Port 1: R
      .clk1(clk),
      .csb1(~imem_enb[1]),
      .addr1(imem_addrb[0+:SRAM_AWDH]),
      .dout1(imem_dout1[1])
    );

/* //8KB //Route-Congestion
    sky130_sram_2kbyte_1rw1r_32x512_8 imem2(
      // Port 0: RW
      .clk0(clk),
      .csb0(~imem_ena[2]),
      .web0(&imem_weba),
      .wmask0(imem_wea),
      .addr0(imem_addra[0+:SRAM_AWDH]),
      .din0(imem_dina),
      .dout0(),
      // Port 1: R
      .clk1(clk),
      .csb1(~imem_enb[2]),
      .addr1(imem_addrb[0+:SRAM_AWDH]),
      .dout1(imem_dout1[2])
    );

    sky130_sram_2kbyte_1rw1r_32x512_8 imem3(
      // Port 0: RW
      .clk0(clk),
      .csb0(~imem_ena[3]),
      .web0(&imem_weba),
      .wmask0(imem_wea),
      .addr0(imem_addra[0+:SRAM_AWDH]),
      .din0(imem_dina),
      .dout0(),
      // Port 1: R
      .clk1(clk),
      .csb1(~imem_enb[3]),
      .addr1(imem_addrb[0+:SRAM_AWDH]),
      .dout1(imem_dout1[3])
    );
*/
    assign imem_mxa = ({{(IMEM_SWDH-1){1'b0}},1'b1}) << (imem_addra[SRAM_AWDH+:IMEM_SWMX]);
    assign imem_mxb = ({{(IMEM_SWDH-1){1'b0}},1'b1}) << (imem_addrb[SRAM_AWDH+:IMEM_SWMX]);
    
    assign imem_addra = md_ad[2+:IMEM_AWDH];
    assign imem_dina  = md_wd;
    assign imem_addrb = mi_ad[2+:IMEM_AWDH];

    assign imem_wea   = md_we;
    assign imem_weba  = ~imem_wea;

    assign imem_ena  = {IMEM_SWDH{(md_en&mi_ad[30]&md_ad[29])}}&imem_mxa;
    assign imem_enb  = {IMEM_SWDH{(mi_en&(~mi_ad[30]))}}&imem_mxb;

    always@(posedge clk) begin
      imem_doutb <= imem_dout1[imem_addrb[SRAM_AWDH+:IMEM_SWMX]];
    end

//===========
    
    // Register file
    // Asynchronous read: read data is available in the same cycle
    // Synchronous write: write takes one cycle
    wire we;
    wire [4:0] ra1, ra2, wa;
    wire [31:0] wd;
    wire [31:0] rd1, rd2;
    rv151_rgf rf (
        .clk(clk),
        .we(we),
        .ra1(ra1), .ra2(ra2), .wa(wa),
        .wd(wd),
        .rd1(rd1), .rd2(rd2)
    );

    assign we = rf_wen;
    assign wa = rf_wad;
    assign wd = rf_wdt;
    assign ra1 = rf_ra1;
    assign ra2 = rf_ra2;
    assign rf_rd1 = rd1;
    assign rf_rd2 = rd2;

//===|UART=CSR|===

    localparam SYMBOL_EDGE_TIME = CPU_CLOCK_FREQ / BAUD_RATE;
    localparam CPU_CLOCK_MAX = 200_000_000;
    localparam BAUD_BITS = $clog2((CPU_CLOCK_MAX+(MIN_BDRT/2)-1) / (MIN_BDRT/2));

    reg [BAUD_BITS-1:0] uart_baud_edge;

    reg [7:0] uart_din;
    reg       uart_div;
    reg       uart_dor;

    // On-chip UART
    //// UART Receiver
    wire [7:0] uart_rx_data_out;
    wire uart_rx_data_out_valid;
    wire uart_rx_data_out_ready;
    //// UART Transmitter
    wire [7:0] uart_tx_data_in;
    wire uart_tx_data_in_valid;
    wire uart_tx_data_in_ready;
    uart #(
        .CLOCK_FREQ(CPU_CLOCK_MAX),
        .MIN_BDRT(MIN_BDRT)
    ) uart (
        .clk(clk),
        .reset(rst),

        .baud_edge(uart_baud_edge),

        .serial_in(serial_in),
        .data_out(uart_rx_data_out),
        .data_out_valid(uart_rx_data_out_valid),
        .data_out_ready(uart_rx_data_out_ready),

        .serial_out(serial_out),
        .data_in(uart_tx_data_in),
        .data_in_valid(uart_tx_data_in_valid),
        .data_in_ready(uart_tx_data_in_ready)
    );
    
    always@(posedge clk or posedge rst) begin
      if(rst) begin
          uart_baud_edge <= SYMBOL_EDGE_TIME;
      end
      else begin
          uart_baud_edge <= (mi_ad[31]&md_en&md_we[0]&(md_ad[7:0]==8'h0C)) ? md_wd[BAUD_BITS-1:0] : 
                                                                             uart_baud_edge       ;
      end
    end

    assign uart_tx_data_in = uart_din;
    assign uart_tx_data_in_valid = uart_div;

    always@(posedge clk or posedge rst) begin
      if(rst) begin
        uart_din <= 8'h0;
        uart_div <= 1'b0;
      end
      else begin
          uart_din <= (md_ad[31]&md_en&md_we[0]&(md_ad[7:0]==8'h08)) ? md_wd[7:0] : 
                                                                       uart_din   ;
          uart_div <= (uart_tx_data_in_valid&uart_tx_data_in_ready)  ? 1'b0     : 
                      (md_ad[31]&md_en&md_we[0]&(md_ad[7:0]==8'h08)) ? 1'b1     : 
                                                                       uart_div ;
      end
    end

    assign uart_rx_data_out_ready = uart_dor;

    always@(posedge clk or posedge rst) begin
      if(rst) begin
        uart_dor <= 1'b0;
      end
      else begin
          uart_dor <= (uart_rx_data_out_valid&uart_rx_data_out_ready) ? 1'b0 : 
                      (md_ad[31]&md_en&(md_ad[7:0]==8'h04))           ? 1'b1 : 
                                                                    uart_dor ;
      end
    end

//===|GPIO=CSR|===

    reg [7:0] gpio_ot;
    reg [7:0] gpio_ob;

    assign gpio_out = gpio_ot;
    assign gpio_oeb = gpio_ob;

    always@(posedge clk or posedge rst) begin
      if(rst) begin
        gpio_ot <= 8'h0;
        gpio_ob <= 8'h0;
      end
      else begin
        gpio_ot <= (md_ad[31]&md_en&md_we[0]&(md_ad[7:0]==8'h1C)) ? md_wd[8*0+:8] : 
                                                                    gpio_ot       ;
        gpio_ob <= (md_ad[31]&md_en&md_we[2]&(md_ad[7:0]==8'h1C)) ? md_wd[8*2+:8] : 
                                                                    gpio_ob       ;
      end
    end


//===|RISCV-CSR|===

    reg [31:0] tohost_csr = 0;

    always@(posedge clk or posedge rst) begin
      if(rst) begin
        tohost_csr <= 32'h0;
      end
      else begin
        if(cs_we&(cs_ad==12'h51E))
          tohost_csr <= cs_wd;
      end
    end

    assign cs_rd = (cs_we&(cs_ad==12'h51E)) ? tohost_csr : 32'h0 ;

//===|Status Counter|===

    reg [31:0] cc_cntr; //Cycle-Counter
    reg [31:0] ir_cntr; //Instruction-Counter

    always@(posedge clk or posedge rst) begin
      if(rst) begin
        cc_cntr <= 32'h0;
      end
      else begin
        cc_cntr <= (mi_ad[31]&md_en&md_we[0]&(md_ad[7:0]==8'h18)) ? 32'h0 : cc_cntr+1;
      end
    end

    always@(posedge clk or posedge rst) begin
      if(rst) begin
        ir_cntr <= 32'h0;
      end
      else begin
        ir_cntr <= (mi_ad[31]&md_en&md_we[0]&(md_ad[7:0]==8'h18)) ? 32'h0 : (ds_irc) ? ir_cntr+1 : ir_cntr;
      end
    end

//===|Read-Memory MUX|===

    reg [31:0] mi_rm;
    reg [31:0] md_rm;
    reg [31:0] io_rm;

    reg [31:0] io_dout;
    reg        mi_sl;
    reg [1:0]  md_sl;

    assign mi_rd = mi_rm;
    assign md_rd = md_rm;

    always@(*) begin
      case(mi_sl)
        1'b1    : mi_rm = bios_douta;
        1'b0    : mi_rm = imem_doutb;
        default : mi_rm = imem_doutb;
      endcase
    end

    always@(*) begin
      case(md_sl[1:0])
        2'h0    : md_rm = dmem_dout;
        2'h1    : md_rm = bios_doutb;
        2'h2    : md_rm = io_dout;
        default : md_rm = 32'h0;
      endcase
    end

    always@(*) begin
      case({md_ad[31:28], md_ad[7:0]})
        {4'h8, 8'h00} : io_rm = {30'h0, uart_rx_data_out_valid, uart_tx_data_in_ready};
        {4'h8, 8'h04} : io_rm = {24'h0, uart_rx_data_out};
        {4'h8, 8'h0C} : io_rm = {{(32-BAUD_BITS){1'b0}}, uart_baud_edge};
        {4'h8, 8'h10} : io_rm = cc_cntr;
        {4'h8, 8'h18} : io_rm = ir_cntr;
        {4'h8, 8'h1C} : io_rm = {8'h0, gpio_ob, 8'h0, gpio_in};
        default :       io_rm = 32'h0;
      endcase
    end

    always@(posedge clk or posedge rst) begin
      if(rst) begin
        io_dout <= 32'h0;
      end
      else begin
        io_dout <= ((md_ad[31:28]==4'h8)&md_en) ? io_rm : io_dout ;
      end
    end

    always@(posedge clk or posedge rst) begin
      if(rst) begin
        mi_sl <= RESET_PC[30];
        md_sl <= 2'h0;
      end
      else begin
        mi_sl <= mi_ad[30];
        case({md_en, md_ad[31:28]})
          {1'b1, 4'b0001} : md_sl <= 2'h0;
          {1'b1, 4'b0011} : md_sl <= 2'h0;
          {1'b1, 4'b0100} : md_sl <= 2'h1;
          {1'b1, 4'b1000} : md_sl <= 2'h2;
          default         : md_sl <= 2'h0;
        endcase
      end
    end

//======================

    rv151_core#(
      .PC_RST_VAL(RESET_PC)
    ) core (
      //Register-File
      .rf_wen(rf_wen),
      .rf_wad(rf_wad),
      .rf_wdt(rf_wdt),
      .rf_ra1(rf_ra1),
      .rf_ra2(rf_ra2),
      .rf_rd1(rf_rd1),
      .rf_rd2(rf_rd2),

      //Instruction Memory
      .mi_en(mi_en),
      .mi_ad(mi_ad),
      .mi_we(mi_we),
      .mi_wd(mi_wd),
      .mi_rd(mi_rd),

      //Data Memory
      .md_en(md_en),
      .md_ad(md_ad),
      .md_we(md_we),
      .md_wd(md_wd),
      .md_rd(md_rd),

      //CSR
      .cs_en(cs_en),
      .cs_ad(cs_ad),
      .cs_we(cs_we),
      .cs_wd(cs_wd),
      .cs_rd(cs_rd),

      //Debug-Status
      .ds_irc(ds_irc),
      .ds_hlt(ds_hlt),
      .ds_hpc(ds_hpc),

      //System-Control
      .sc_rsr(bcf), 

      //system
      .rstn(!rst),
      .clk(clk)
    );

//======================

assign io_hlt = ds_hlt;
assign io_irc = ds_irc;

endmodule
