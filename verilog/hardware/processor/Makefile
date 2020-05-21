DESIGN	= sail
TESTS := $(filter-out ./source/rf_performance/ ./source/low_freq_blink/, $(sort $(dir $(wildcard ./source/*/))))

sail-nextpnr:
	cp programs/data.hex verilog/
	cp programs/program.hex verilog/
	yosys -q ../../../yscripts/$(DESIGN).ys
	nextpnr-ice40 --up5k --package uwg30 --json $(DESIGN).json --pcf pcf/$(DESIGN).pcf --asc $(DESIGN).asc
	icetime -p pcf/sail.pcf -P uwg30 -d up5k -t sail.asc
	icepack $(DESIGN).asc $(DESIGN).bin
	sudo iceprog -S $(DESIGN).bin

test:
	cp programs/data.hex verilog/
	cp programs/program.hex verilog/
	yosys -q ../../../yscripts/$(DESIGN)_test.ys
	nextpnr-ice40 --up5k --package uwg30 --json $(DESIGN).json --pcf pcf/$(DESIGN).pcf --asc $(DESIGN).asc --pack-only -l pnr.txt -q >/dev/null 2>&1 

resource.log: $(TESTS)

$(TESTS):
	@printf "\033[0;32mEvaluating $(shell basename $@)\n\033[0m"
	make -C $@ 
	make install -C $@ > /dev/null 2>&1	
	make test
	printf '$(shell basename $@)\n-----------------------------------\n' >> resource.log  
	cut -c 7- pnr.txt >> resource.log
	awk -v RS="" '{a[NR]=$$0} END {print a[NR]}' stat.txt | cut -c 4- >> resource.log
	rm stat.txt pnr.txt
	printf '\n' >> resource.log
	@printf "\n"

clean:
	rm -f *.json *.blif *.asc *.bin *.log

.PHONY: $(TESTS)
