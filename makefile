go: main
	qemu-riscv64 -cpu rv64,v=true,zba=true,vlen=128,rvv_ta_all_1s=on,rvv_ma_all_1s=on ./main

main: main.c vec.S makefile
	riscv64-unknown-elf-gcc -O main.c vec.S -o main -march=rv64gcv_zba -lm
