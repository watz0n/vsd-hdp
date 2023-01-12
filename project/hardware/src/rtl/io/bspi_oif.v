module bspi_oif(

    input  io_bcf,

    input  io_scs,
    input  io_sdi,
    output io_sdo,
    input  io_sck,

    output       wen,
    output [7:0] wdt,
    input        wfl,

    output       ren,
    input  [7:0] rdt,
    input        rey,

    input  rstn
);

wire scs;
wire sdi;
wire sdo;
wire sck;

reg [2:0] bct;

reg [7:0] wsfr;
reg [7:0] rsfr;

reg       rsot;

wire xsfr;

assign xsfr = (bct==3'h7);
assign wen = xsfr;
assign ren = xsfr;
assign wdt = {wsfr[6:0], sdi};

always@(posedge sck or negedge rstn) begin
    if(!rstn) begin
        bct <= 3'h0;
    end
    else begin
        bct <= (!scs) ? bct+1 : bct;
    end
end

always@(posedge sck or negedge rstn) begin
    if(!rstn) begin
        wsfr <= 8'h0;
    end
    else begin
        wsfr <= (!scs) ? {wsfr[6:0], sdi} : wsfr;
    end
end

always@(posedge sck or negedge rstn) begin
    if(!rstn) begin
        rsfr <= 8'h0;
    end
    else begin
        rsfr <= (!scs & !rey & ren) ? rdt : {rsfr[6:0], 1'b0};
    end
end

always@(negedge sck or negedge rstn) begin
    if(!rstn) begin
        rsot <= 1'b0;
    end
    else begin
        rsot <= rsfr[7];
    end
end

assign sdo = rsot;

assign scs = io_scs|(!io_bcf);
assign sdi = io_sdi;
assign io_sdo = sdo;
assign sck = io_sck;

endmodule