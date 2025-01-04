#!/bin/bash
#
# Function call subprocess tracing (stack)
# Function calling process (stack)

OPT=$1
ARGS=$2
FUNCTION_GRAPH=0
FUNC_SEL="function_graph"
GRAPH_DEPTH=20
init_func()
{
	# cat /sys/kernel/debug/tracing/set_ftrace_filter
    echo "*" > /sys/kernel/debug/tracing/set_ftrace_filter
	echo $FUNC_SEL > /sys/kernel/debug/tracing/current_tracer
    if [ "$FUNC_SEL" == "function" ]; then
        echo $ARGS > /sys/kernel/debug/tracing/set_ftrace_filter
        echo -e "set ftrace filter:"
        cat /sys/kernel/debug/tracing/set_ftrace_filter
        echo -e
    else
        echo $GRAPH_DEPTH > /sys/kernel/debug/tracing/max_graph_depth
        echo $ARGS > /sys/kernel/debug/tracing/set_graph_function
        echo -e "set ftrace graph function:"
        cat /sys/kernel/debug/tracing/set_graph_function
        echo -e
    fi


    if [ "$FUNC_SEL" == "function" ]; then
        echo 1 > /sys/kernel/debug/tracing/options/func_stack_trace
    fi
	# echo 1 > /sys/kernel/debug/tracing/tracing_on
	echo "Staring tracing .... :)"
}

usage()
{
    echo -e
    echo -e "./$0 [OPT] [ARGS]"
    echo -e "  [OPT]  : init | on | off | clear | max | add | sub | show | print"
    echo -e "  [ARGS] : function name."
    echo -e
}

clear_func()
{
    if [ "$FUNC_SEL" == "function" ]; then
	    echo > /sys/kernel/debug/tracing/set_ftrace_filter
    else
	    echo > /sys/kernel/debug/tracing/set_graph_function
    fi
}

trace_on()
{
	echo 1 > /sys/kernel/debug/tracing/tracing_on
}

trace_off()
{
	echo 0 > /sys/kernel/debug/tracing/tracing_on
    if [ "$FUNC_SEL" == "function" ]; then
        echo 0 > /sys/kernel/debug/tracing/options/func_stack_trace
    fi
}

add_func()
{
    if [ "$FUNC_SEL" == "function" ]; then
        echo $ARGS >> /sys/kernel/debug/tracing/set_ftrace_filter
    else
	    echo $ARGS >> /sys/kernel/debug/tracing/set_graph_function
    fi
}

sub_func()
{
    if [ "$FUNC_SEL" == "function" ]; then
	    echo $ARGS > /sys/kernel/debug/tracing/set_ftrace_notrace
    fi
}

show_trace()
{
	cat /sys/kernel/debug/tracing/trace > /mnt/trace_$(date +%Y-%m-%d-%H:%M:%S).txt
}

print_trace() {
    cat /sys/kernel/debug/tracing/trace
}

case $OPT in
	"init")
        read -p "Please input 0(function)/1(function_graph):" choice
        case $choice in
            0)
                FUNC_SEL="function"
                ;;
            1)
                FUNC_SEL="function_graph"
                ;;
            *)
                echo "Invalid option!"
                ;;
        esac
        echo "You selected $FUNC_SEL!"
		init_func
	;;
	"on")
		trace_on
	;;
	"off")
		trace_off
	;;
	"clear")
		clear_func
	;;
	"max")
		GRAPH_DEPTH=$2
	;;
	"add")
		add_func
	;;
	"sub")
		sub_func
	;;
	"show")
		show_trace
	;;
	"print")
		print_trace
	;;
    *)
        usage
    ;;
esac
