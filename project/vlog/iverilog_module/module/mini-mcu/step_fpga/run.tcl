#!/usr/bin/env pnmainc
#配置
puts hello
prj_project open "./step_tp.ldf"
prj_run Synthesis -impl impl1
prj_run Map -impl impl1
prj_run PAR -impl impl1
prj_run Export -impl impl1

#拷贝生成的配置文件到step fpga中
file copy impl1/step_tp_impl1.jed "G:/step_tp_impl1.jed"
