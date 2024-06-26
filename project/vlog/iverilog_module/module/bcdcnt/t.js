#!/usr/bin/env node
// bcd加法逻辑
var fs = require("fs")

a = [0,0,0,0]

for(i=0;i<1000;i++){
    console.log("%d%d%d%d",a[0],a[1],a[2],a[3])
    a[3]++
    k = [0,0,0,0]
    if(a[3] > 9){
        a[3] = 0
        k[3]=1
    } else {
        k[3] = 0
    } 
    a[2] += k[3]
    if(a[2] > 9){
        a[2] = 0
        k[2]=1
    } else {
        k[2] = 0
    } 

    a[1] += k[2]
    if(a[1] > 9){
        a[1] = 0
        k[1]=1
    } else {
        k[1] = 0
    } 

    a[0] += k[1]
    if(a[0] > 9){
        a[0] = 0
        k[0]=1
    } else {
        k[0] = 0
    }
}