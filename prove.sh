#!/bin/sh
gcc -c -O2 -fomit-frame-pointer -lgmp -freg-struct-return prove-c.c

stalin -On -copt -lgmp -copt prove-c.o -k -copt -Ofast -copt -fomit-frame-pointer -copt -mcpu=native -copt -mtune=native -cc /opt/intel/oneapi/compiler/2024.0/bin/icx prove.sc
set -m # Enable Job Control

export d=$(cat calced)
for i in $(seq $(cat calced) $(($(cat calced) + 10000))); do
	 for i in `seq 8`; do # start 8 jobs in parallel
	     export d=$((d+1))
	     ./prove $d &
	 done
	 echo $d > calced
	 # Wait for all parallel jobs to finish
	 while [ 1 ]; do fg 2> /dev/null; [ $? == 1 ] && break; done
done
