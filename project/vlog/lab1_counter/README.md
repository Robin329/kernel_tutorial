## SystemVerilog/Verilog/UVM

#### 1. Environment ready
- Ubuntu
```bash
$  sudo apt-get install gtkwave iverilog -y
```
- VScode
  - Verilog-HDL/SystemVerilog/Bluespec
  - verilog
  - Verilog HDL
  - Verilog Format
  - Verilog_Testbench
  - verilog-formater

#### 2. Run
```bash
$ iverilog -g2012 -y ./ testbench.sv
# OR include header file path
$ iverilog -g2012 -I ./ testbench.sv
```