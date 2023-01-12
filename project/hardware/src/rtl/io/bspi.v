module bspi(

    input  io_bcf,

    input  io_scs,
    input  io_sdi,
    output io_sdo,
    input  io_sck,

    output        bcsb,
    output [3:0]  bweb,
    output [10:0] badr,
    output [31:0] bdti,
    input  [31:0] bdto,

    input rstn,
    input clk
);

wire       o_wen;
wire [7:0] o_wdt;
wire       o_wfl;
wire       o_ren;
wire [7:0] o_rdt;
wire       o_rey;

wire       b_ren;
wire [7:0] b_rdt;
wire       b_rey;
wire       b_wen;
wire [7:0] b_wdt;
wire       b_wfl;

bspi_oif oif(

    .io_bcf(io_bcf),
    .io_scs(io_scs),
    .io_sdi(io_sdi),
    .io_sdo(io_sdo),
    .io_sck(io_sck),

    .wen(o_wen),
    .wdt(o_wdt),
    .wfl(o_wfl),
    .ren(o_ren),
    .rdt(o_rdt),
    .rey(o_rey),

    .rstn(rstn)
);


bspi_aff o2b(

    .wen(o_wen),
    .wdt(o_wdt),
    .wfl(o_wfl),
    .ren(b_ren),
    .rdt(b_rdt),
    .rey(b_rey),

    .wck(io_sck), 
    .rck(clk),

    .rstn(rstn)
);

bspi_aff b2o(

    .wen(b_wen),
    .wdt(b_wdt),
    .wfl(b_wfl),
    .ren(o_ren),
    .rdt(o_rdt),
    .rey(o_rey),

    .wck(clk), 
    .rck(io_sck),

    .rstn(rstn)
);


bspi_bif bif(

    .io_bcf(io_bcf),
    .io_scs(io_scs),

    .bcsb(bcsb),
    .bweb(bweb),
    .badr(badr),
    .bdti(bdti),
    .bdto(bdto),

    .ren(b_ren),
    .rdt(b_rdt),
    .rey(b_rey),
    .wen(b_wen),
    .wdt(b_wdt),
    .wfl(b_wfl),

    .rstn(rstn),
    .clk(clk)
);

endmodule