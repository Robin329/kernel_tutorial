#!/bin/bash

# Running 9p Function
#
# (C) 2020.03.03 BuddyZhang1 <buddy.zhang@aliyun.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.


OPT=$1
ARGS=$2

init_filter()
{
	echo "*" > /sys/kernel/debug/tracing/set_ftrace_filter
	# cat /sys/kernel/debug/tracing/set_ftrace_filter
	echo function_graph > /sys/kernel/debug/tracing/current_tracer
	echo 1 > /sys/kernel/debug/tracing/tracing_on
	echo "Staring tracing .... :)"
}

usage()
{
    echo -e
    echo -e "./ftrace_on.sh [OPT] [ARGS]"
    echo -e "  [OPT]  : init | on | off | clear | add | sub | show"
    echo -e "  [ATGS] : function name."
    echo -e
}

clear_filter()
{
	echo > /sys/kernel/debug/tracing/set_ftrace_filter
}

trace_on()
{
	echo 1 > /sys/kernel/debug/tracing/tracing_on
}

trace_off()
{
	echo 0 > /sys/kernel/debug/tracing/tracing_on
}

add_filter()
{
	echo $ARGS > /sys/kernel/debug/tracing/set_ftrace_filter
}

sub_filter()
{
	echo $ARGS > /sys/kernel/debug/tracing/set_ftrace_notrace
}

show_trace()
{
	cat /sys/kernel/debug/tracing/trace > /mnt/trace_$(date +%Y-%m-%d-%H:%M:%S).txt
}


case $OPT in
	"init")
		init_filter
	;;
	"on")
		trace_on
	;;
	"off")
		trace_off
	;;
	"clear")
		trace_off
		trace_on
	;;
	"add")
		add_filter
	;;
	"sub")
		sub_filter
	;;
	"show")
		show_trace
	;;
    *)
        usage
    ;;
esac
