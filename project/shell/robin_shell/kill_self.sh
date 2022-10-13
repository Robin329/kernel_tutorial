#!/bin/sh

username=renbin

ps -aux |grep renbin|grep run_zRci| awk '{print $2}'|xargs kill -9