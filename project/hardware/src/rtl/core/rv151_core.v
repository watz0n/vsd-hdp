module rv151_core#(
    parameter PC_RST_VAL = 32'h40000000
)(

    //Register-File
    output        rf_wen,
    output [4:0]  rf_wad,
    output [31:0] rf_wdt,
    output [4:0]  rf_ra1,
    output [4:0]  rf_ra2,
    input  [31:0] rf_rd1,
    input  [31:0] rf_rd2,

    //Instruction Memory
    output        mi_en,
    output [31:0] mi_ad,
    output [3:0]  mi_we,
    output [31:0] mi_wd,
    input  [31:0] mi_rd,

    //Data Memory
    output        md_en,
    output [31:0] md_ad,
    output [3:0]  md_we,
    output [31:0] md_wd,
    input  [31:0] md_rd,

    //CSR
    output        cs_en,
    output [11:0] cs_ad,
    output        cs_we,
    output [31:0] cs_wd,
    input  [31:0] cs_rd,
    
    //Debug-Status
    output        ds_irc,
    output        ds_hlt,
    output [31:0] ds_hpc,

    //System-Control
    input         sc_rsr, 

    //System
    input rstn,
    input clk
);

//=====================================================================
//===|Declare|===
//===|Pc-iF|===
reg  [31:0] pc_cr;

wire [31:0] pc_a4;
wire [31:0] pc_an; 
wire        pc_jp;

wire        pc_ifn;

reg         pf_ifv;
reg  [31:0] pf_pcr;
reg  [31:0] pf_pc4;

//===|iF-eX|===

wire [31:0] pf_ins; //from instruction memory

wire [3:0]  exc_afn;
wire [2:0]  exc_bfn;
wire [2:0]  exc_itp;
wire [2:0]  exc_mfn;
wire [2:0]  exc_csf;

wire        exc_cso;
wire        exc_rfw;
wire        exc_mre;
wire        exc_mwe;
wire        exc_djp;
wire        exc_dbr;
wire        exc_ds1;
wire        exc_ds2;
wire [1:0]  exc_drs;
wire        exc_ivd;

wire        exr_wen;
wire [4:0]  exr_wad;
wire [31:0] exr_wdt;
wire [4:0]  exr_ra1;
wire [4:0]  exr_ra2;
wire [31:0] exr_rd1;
wire [31:0] exr_rd2;

wire [31:0] exi_imm;

wire [31:0] exa_in1;
wire [31:0] exa_in2;
wire [31:0] exa_odt;

wire        exb_tkn;

reg         xw_rfw;
reg  [31:0] xw_aot;
reg  [1:0]  xw_drs;
reg  [4:0]  xw_dra;
reg  [31:0] xw_pc4;
reg  [31:0] xw_csr;
reg  [1:0]  xw_mof;
reg  [2:0]  xw_mfn;
//reg         xw_irc; //instruction complete

reg  [3:0]  exo_mwe;
wire [31:0] exo_mws;
reg  [31:0] exo_mwd;

wire [31:0] exo_zim;
reg  [31:0] exo_csd;

//===|eX-Wb|===

//wire [31:0] xw_rdt; //from data memory

reg [31:0]  xw_rdt; //from data memory

wire        wb_rfw;
wire [4:0]  wb_rfa;
reg  [31:0] wb_rfd;

//Forward Result for Data Dependency
wire [31:0] fw_rd1;
wire [31:0] fw_rd2;

//===|debug-status reg|===
reg         dr_irc; //instruction complete
reg         dr_hlt;
reg [31:0]  dr_hpc;

wire        dc_hlt;

//=====================================================================
//===|Behavior|===
//===|Pc-iF|===

assign pc_a4 = pc_cr + 4;
assign pc_an = dc_hlt ? pc_cr : pc_jp ? {exa_odt[31:1],1'b0} : pc_a4;
assign pc_jp = exb_tkn|exc_djp;

always@(posedge clk or negedge rstn) begin
    if(!rstn) begin
        pc_cr <= PC_RST_VAL;
    end
    else begin
        pc_cr <= (sc_rsr) ? PC_RST_VAL : pc_an;
    end
end

assign mi_en = !(sc_rsr|dr_hlt); //1'b1;
assign mi_ad = pc_cr;
assign mi_we = 4'h0;
assign mi_wd = 32'h0;

assign pc_ifn = (!pc_jp)&mi_en;
    
always@(posedge clk or negedge rstn) begin
    if(!rstn) begin
        pf_ifv <= 1'b0;
        pf_pcr <= 32'h0;
        pf_pc4 <= 32'h0;
    end
    else begin
        pf_ifv <= pc_ifn;
        pf_pcr <= pc_cr;
        pf_pc4 <= pc_a4;
    end
end

//===|iF-eX|===

assign pf_ins = mi_rd;

rv151_ctl ctl (
    .ctl_ifv(pf_ifv),
    .ctl_ins(pf_ins),

    .ctl_afn(exc_afn),
    .ctl_bfn(exc_bfn),
    .ctl_itp(exc_itp),
    .ctl_mfn(exc_mfn),
    .ctl_csf(exc_csf),

    .ctl_cso(exc_cso),
    .ctl_rfw(exc_rfw),
    .ctl_mre(exc_mre),
    .ctl_mwe(exc_mwe),
    .ctl_djp(exc_djp),
    .ctl_dbr(exc_dbr),
    .ctl_ds1(exc_ds1),
    .ctl_ds2(exc_ds2),
    .ctl_drs(exc_drs),
    .ctl_ivd(exc_ivd) 
);

assign exr_wen = wb_rfw;
assign exr_wad = wb_rfa;
assign exr_wdt = wb_rfd;
assign exr_ra1 = pf_ins[19:15];
assign exr_ra2 = pf_ins[24:20];

//===|Register-File|===
assign rf_wen = exr_wen;
assign rf_wad = exr_wad;
assign rf_wdt = exr_wdt;
assign rf_ra1 = exr_ra1;
assign rf_ra2 = exr_ra2;
assign exr_rd1 = rf_rd1;
assign exr_rd2 = rf_rd2;

rv151_bch bch(
    .bch_c1(fw_rd1), //Forward, origin: .bch_c1(exr_rd1),
    .bch_c2(fw_rd2), //Forward, origin: .bch_c2(exr_rd2),
    .bch_op(exc_dbr), //branch operation
    .bch_fn(exc_bfn), //branch function
    .bch_tk(exb_tkn)  //taken
);

rv151_imm imm(
    .imm_it(pf_ins),
    .imm_tp(exc_itp),
    .imm_ot(exi_imm)
);

//assign exa_in1 = exc_ds1 ? pf_pcr  : exr_rd1;
//assign exa_in2 = exc_ds2 ? exi_imm : exr_rd2;

//Forward Result to solve Data Dependency
assign exa_in1 = exc_ds1 ? pf_pcr  : fw_rd1;
assign exa_in2 = exc_ds2 ? exi_imm : fw_rd2;

rv151_alu alu(
    .alu_i1(exa_in1),
    .alu_i2(exa_in2),
    .alu_fn(exc_afn),
    .alu_ot(exa_odt)
);

assign md_en = exc_mre|exc_mwe;
assign md_ad = exa_odt;
//assign md_we = exc_mwe&pf_ifv; //1-bit
assign md_we = exo_mwe&{4{pf_ifv&exc_mwe}};
//assign md_wd = exr_rd2;
assign md_wd = exo_mwd;

assign cs_en = exc_cso;
assign cs_ad = pf_ins[31:20];
assign cs_we = exc_cso;
//assign cs_wd = exr_rd1;
assign cs_wd = exo_csd;

always@(posedge clk or negedge rstn) begin
    if(!rstn) begin
        xw_rfw <= 1'b0;
        xw_aot <= 32'h0;
        xw_drs <= 2'h0;
        xw_dra <= 5'h0;
        xw_pc4 <= 32'h0;
        xw_csr <= 32'h0;
        xw_mof <= 2'h0;
        xw_mfn <= 3'h0;
//        xw_irc <= 1'b0;
    end
    else begin
        xw_rfw <= exc_rfw&pf_ifv;
        xw_aot <= exa_odt;
        xw_drs <= exc_drs;
        xw_dra <= pf_ins[11:7];
        xw_pc4 <= pf_pc4;
        xw_csr <= cs_rd;
        xw_mof <= md_ad[1:0];
        xw_mfn <= exc_mfn;
//        xw_irc <= pf_ifv&exc_ivd;
    end
end

always@(posedge clk or negedge rstn) begin
    if(!rstn) begin
        dr_irc <= 1'b0;
    end
    else begin
        dr_irc <= pf_ifv&exc_ivd;
    end
end

always@(*) begin
    case(exc_mfn)
        3'b000  : begin
                case(md_ad[1:0])
                    2'h0    : exo_mwe = 4'h1;
                    2'h1    : exo_mwe = 4'h2;
                    2'h2    : exo_mwe = 4'h4;
                    2'h3    : exo_mwe = 4'h8;
                    default : exo_mwe = 4'h1;
                endcase
            end
        3'b001  : begin
                case(md_ad[1])
                    1'b0    : exo_mwe = 4'h3;
                    1'b1    : exo_mwe = 4'hC;
                    default : exo_mwe = 4'h3;
                endcase
            end
        3'b010  : exo_mwe = 4'hF;
        default : exo_mwe = 4'hF;
    endcase
end

always@(*) begin
    case(exc_mfn)
        3'b000  : exo_mwd = {4{fw_rd2[7:0]}};
        3'b001  : exo_mwd = {2{fw_rd2[15:0]}};
        3'b010  : exo_mwd = fw_rd2;
        default : exo_mwd = fw_rd2; //exo_mwd = exr_rd2;
    endcase
end

assign exo_zim = {27'h0, pf_ins[19:15]};
always@(*) begin
    case(exc_csf)
        3'b001  : exo_csd = exr_rd1;
        3'b010  : exo_csd = cs_rd|exr_rd1;
        3'b011  : exo_csd = cs_rd&(~exr_rd1);
        3'b101  : exo_csd = exo_zim;
        3'b110  : exo_csd = cs_rd|exo_zim;
        3'b111  : exo_csd = cs_rd&(~exo_zim);
        default : exo_csd = exr_rd1;
    endcase
end

//===|eX-Wb|===

//assign xw_rdt = md_rd;

always@(*) begin
    case(xw_mfn)
        3'b000  : begin
                case(xw_mof[1:0])
                    2'h0    : xw_rdt = {{24{md_rd[(8*1)-1]}},md_rd[8*0+:8]};
                    2'h1    : xw_rdt = {{24{md_rd[(8*2)-1]}},md_rd[8*1+:8]};
                    2'h2    : xw_rdt = {{24{md_rd[(8*3)-1]}},md_rd[8*2+:8]};
                    2'h3    : xw_rdt = {{24{md_rd[(8*4)-1]}},md_rd[8*3+:8]};
                    default : xw_rdt = {{24{md_rd[(8*1)-1]}},md_rd[8*0+:8]};
                endcase
            end
        3'b001  : begin
                case(xw_mof[1])
                    1'b0    : xw_rdt = {{24{md_rd[(16*1)-1]}},md_rd[16*0+:16]};
                    1'b1    : xw_rdt = {{24{md_rd[(16*2)-1]}},md_rd[16*1+:16]};
                    default : xw_rdt = {{24{md_rd[(16*1)-1]}},md_rd[16*0+:16]};
                endcase
            end
        3'b010  : xw_rdt = md_rd;
        3'b100  : begin
                case(xw_mof[1:0])
                    2'h0    : xw_rdt = {{24{1'b0}},md_rd[8*0+:8]};
                    2'h1    : xw_rdt = {{24{1'b0}},md_rd[8*1+:8]};
                    2'h2    : xw_rdt = {{24{1'b0}},md_rd[8*2+:8]};
                    2'h3    : xw_rdt = {{24{1'b0}},md_rd[8*3+:8]};
                    default : xw_rdt = {{24{1'b0}},md_rd[8*0+:8]};
                endcase
            end
        3'b101  : begin
                case(xw_mof[1])
                    1'b0    : xw_rdt = {{24{1'b0}},md_rd[16*0+:16]};
                    1'b1    : xw_rdt = {{24{1'b0}},md_rd[16*1+:16]};
                    default : xw_rdt = {{24{1'b0}},md_rd[16*0+:16]};
                endcase
            end
        default : xw_rdt = md_rd;
    endcase
end

assign wb_rfw = xw_rfw;
assign wb_rfa = xw_dra;

always@(*) begin
    case(xw_drs[1:0])
        2'h0:    wb_rfd = xw_aot;
        2'h1:    wb_rfd = xw_rdt;
        2'h2:    wb_rfd = xw_pc4;
        default: wb_rfd = xw_aot;
    endcase
end

assign fw_rd1 = (wb_rfw&(wb_rfa==rf_ra1)) ? wb_rfd : exr_rd1;
assign fw_rd2 = (wb_rfw&(wb_rfa==rf_ra2)) ? wb_rfd : exr_rd2;

//=====================================================================

assign ds_irc = dr_irc;
assign ds_hlt = dr_hlt;
assign ds_hpc = dr_hpc;

assign dc_hlt = (pf_ifv&(!exc_ivd));

always@(posedge clk or negedge rstn) begin
    if(!rstn) begin
        dr_hlt <= 1'b0;
        dr_hpc <= PC_RST_VAL;
    end
    else begin
        dr_hlt <= (sc_rsr) ? 1'b0       : dc_hlt ? 1'b1   : dr_hlt;
        dr_hpc <= (sc_rsr) ? PC_RST_VAL : dc_hlt ? pf_pcr : dr_hpc;
    end
end

endmodule