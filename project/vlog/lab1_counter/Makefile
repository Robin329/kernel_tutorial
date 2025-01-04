
NAME=counter
VFLAG=-g2012

compile:
	iverilog $(VFLAG) -I ./ testbench.sv -o $(NAME)
	
all: compile

.PHONY: clean

clean:
	rm *.out *.vcd $(NAME)