DESIGN	= sail
TESTS := $(shell basename -a $(filter-out ./source/old_tests/ ./source/rf_performance/ ./source/low_freq_blink/, $(sort $(dir $(wildcard ./source/*/)))))

sail-nextpnr:
	cp programs/data.hex verilog/
	cp programs/program.hex verilog/
	yosys -q ../../../yscripts/$(DESIGN).ys
	nextpnr-ice40 --up5k --package uwg30 --json $(DESIGN).json --pcf pcf/$(DESIGN).pcf --asc $(DESIGN).asc
	icetime -p pcf/sail.pcf -P uwg30 -d up5k -t sail.asc
	icepack $(DESIGN).asc $(DESIGN).bin
	sudo iceprog -S $(DESIGN).bin

test: clean
	cp programs/data.hex verilog/
	cp programs/program.hex verilog/
	yosys -q ../../../yscripts/$(DESIGN)_test.ys
	nextpnr-ice40 --up5k --package uwg30 --json $(DESIGN).json --pcf pcf/$(DESIGN).pcf --asc $(DESIGN).asc --pack-only -l pnr.txt -q >/dev/null 2>&1 

all: $(TESTS)

$(TESTS):
	rm -f $@.log
	@printf "\033[0;32mEvaluating $@\n\033[0m"
	make -C ./source/$@ 
	make install -C ./source/$@ > /dev/null 2>&1	
	make test
	printf '$@ \n --------------- \n' >> $@.log
	cut -c 7- pnr.txt >> $@.log
	awk -v RS="" '{a[NR]=$$0} END {print "         Adder memory \n" a[7] "\n\n" "         Total \n" a[NR]}' stat.txt | cut -c 4- >> $@.log
	rm stat.txt pnr.txt
	printf '\n' >> $@.log
	@printf "\n"

resource: 
	cat *.log > resources.log
	find . -maxdepth 1 -name '*.log' ! -name 'resources.log' -type f -delete

clean:
	rm -f *.json *.blif *.asc *.bin resource.log

.PHONY: $(TESTS)
