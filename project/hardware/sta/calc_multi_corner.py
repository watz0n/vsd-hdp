# Copyright 2023 Hwa-Shan (Watson) Huang
# Author: watson.edx@gmail.com

import os

lst_libcnr = [
    "ff_100C_1v65",
    "ff_100C_1v95",
    "ff_n40C_1v56",
    "ff_n40C_1v65",
    "ff_n40C_1v76",
    "ff_n40C_1v95",
    "ss_100C_1v40",
    "ss_100C_1v60",
    "ss_n40C_1v28",
    "ss_n40C_1v35",
    "ss_n40C_1v40",
    "ss_n40C_1v44",
    "ss_n40C_1v60",
    "ss_n40C_1v76",
    "tt_025C_1v80",
    "tt_100C_1v80"
];

lst_wns = [];
lst_whs = [];
lst_tns = [];

for libcnr in lst_libcnr:
    print("OpenSTA:",libcnr);
    libhd = libcnr[0:2];
    memcnr="";
    if(libhd == "tt"):
            memcnr="TT_1p8V_25C";
    elif(libhd == "ff"):
            memcnr="FF_1p8V_25C";
    elif(libhd == "ss"):
            memcnr="SS_1p8V_25C";
    else:
            print("unknown corner"); exit(-1);

    #print(memcnr);
    fd = open("py_cal_dly.tcl", "w");
    fd.write("read_liberty ./lib/openram/hdp_sky130_sram_8kbytes_1rw1r_32x2048_8_{}.lib\n".format(memcnr))
    fd.write("read_liberty ./lib/openram/hdp_sky130_sram_8kbytes_1rw_32x2048_8_{}.lib\n".format(memcnr))
    fd.write("read_liberty ./lib/sky130/sky130_fd_sc_hd__{}.lib\n".format(libcnr));
    fd.write("source ./sta/opensta_report_timing.tcl\n");
    fd.write("exit\n");
    fd.close();

    os.system("sta py_cal_dly.tcl");

    fd = open("wns.log");
    frdl = fd.readline();
    if frdl[-1] == '\n':
        frdl = frdl[:-1];
    cmpst = "worst slack ";
    if(cmpst in frdl):
        #print(frdl[len(cmpst):]);
        lst_wns += [frdl[len(cmpst):]];
    else:
        print("no expect result {}".format(fd.name)); exit(-1);
    fd.close();

    fd = open("whs.log");
    frdl = fd.readline();
    if frdl[-1] == '\n':
        frdl = frdl[:-1];
    cmpst = "worst slack ";
    if(cmpst in frdl):
        #print(frdl[len(cmpst):]);
        lst_whs += [frdl[len(cmpst):]];
    else:
        print("no expect result {}".format(fd.name)); exit(-1);
    fd.close();

    fd = open("tns.log");
    frdl = fd.readline();
    if frdl[-1] == '\n':
        frdl = frdl[:-1];
    cmpst = "tns ";
    if(cmpst in frdl):
        #print(frdl[len(cmpst):]);
        lst_tns += [frdl[len(cmpst):]];
    else:
        print("no expect result {}".format(fd.name)); exit(-1);
    fd.close();

os.system("rm -f tns.log whs.log wns.log py_cal_dly.tcl");

#print(lst_wns); #debug-only
#print(lst_whs); #debug-only
#print(lst_tns); #debug-only

lb_cnr="PVT-CORNER";
lb_wns="WNS";
lb_whs="WHS";
lb_tns="TNS";

ml_cnr=len(lb_cnr);
for l in lst_libcnr:
    if(len(l)>ml_cnr):
        ml_cnr = len(l);

ml_wns=len(lb_wns);
for l in lst_wns:
    if(len(l)>ml_wns):
        ml_wns = len(l);

ml_whs=len(lb_whs);
for l in lst_whs:
    if(len(l)>ml_whs):
        ml_whs = len(l);

ml_tns=len(lb_tns);
for l in lst_tns:
    if(len(l)>ml_tns):
        ml_tns = len(l);

print("|{}|{}|{}|{}|".format(lb_cnr.ljust(ml_cnr), lb_wns.ljust(ml_wns), lb_whs.ljust(ml_whs), lb_tns.ljust(ml_tns)));
for i in range(len(lst_libcnr)):
    print("|{}|{}|{}|{}|".format(lst_libcnr[i].ljust(ml_cnr), lst_wns[i].ljust(ml_wns), lst_whs[i].ljust(ml_whs), lst_tns[i].ljust(ml_tns)));

os.system("mkdir -p ./sta/log");
fd = open("./sta/log/calc_multi_corner_pvt.md", "w");
fd.write("|{}|{}|{}|{}|\n".format(lb_cnr.ljust(ml_cnr), lb_wns.ljust(ml_wns), lb_whs.ljust(ml_whs), lb_tns.ljust(ml_tns)));
fd.write("|{}|{}|{}|{}|\n".format("-"*ml_cnr, "-"*(ml_wns), "-"*(ml_whs), "-"*(ml_tns)));
for i in range(len(lst_libcnr)):
    fd.write("|{}|{}|{}|{}|\n".format(lst_libcnr[i].ljust(ml_cnr), lst_wns[i].ljust(ml_wns), lst_whs[i].ljust(ml_whs), lst_tns[i].ljust(ml_tns)));
fd.close();