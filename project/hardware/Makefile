SHELL                   := $(shell which bash) -o pipefail
ABS_TOP                 := $(subst /cygdrive/c/,C:/,$(shell pwd))
SCRIPTS                 := $(ABS_TOP)/scripts
RTL                     += $(subst /cygdrive/c/,C:/,$(shell find $(ABS_TOP)/src -type f -name "*.v"))
SIM_RTL                 := $(subst /cygdrive/c/,C:/,$(shell find $(ABS_TOP)/sim -type f -name "*.v"))
IVERILOG                := iverilog
IVERILOG_OPTS           := -Ttyp -D IVERILOG=1 -g2012 -gassertions -Wall -Wno-timescale -D ABS_TOP=$(ABS_TOP) -I $(ABS_TOP)/src/riscv_core -I $(ABS_TOP)/sim
VVP                     := vvp
SYN                     += $(subst /cygdrive/c/,C:/,$(shell find $(ABS_TOP)/syn -type f -name "*.v"))

sim/%.fst: sim/%.v $(RTL)
	@cd sim && $(IVERILOG) $(IVERILOG_OPTS) -o $*.tbi $*.v $(RTL) && $(VVP) $*.tbi -fst |& tee $*.log

sim-syn/%.fst: sim/%.v $(SYN)
	@cd sim && $(IVERILOG) $(IVERILOG_OPTS) -DSYN -o $*_syn.tbi $*.v $(SYN) && $(VVP) $*_syn.tbi -fst |& tee $*.log

clean-all: clean-sim clean-syn clean-sta

clean-sim:
	@rm -rf sim/*.tbi sim/*.fst sim/*.log

syn:
	@yosys -s syn/syn.ys

clean-syn:
	@rm -rf syn/*.v syn/*.log

sta-tt: ./syn/rv151_soc_syn.v
	@sta sta/opensta_delay_calc_tt.tcl

sta-mc: ./syn/rv151_soc_syn.v
	@python3 sta/calc_multi_corner.py

clean-sta:
	@rm -rf sta/log tns.log whs.log wns.log

.PHONY: clean-all clean-sim syn clean-syn sta-tt sta-mc clean-sta
.PRECIOUS: sim/%.tbi sim/%.fst
