build:
	# @gcc -m32 -no-pie -o main 152_Maracine_ConstantinRazvan_0.s
	# @gcc -m32 -no-pie -o main 152_Maracine_ConstantinRazvan_1.s
	# @gcc -m32 -no-pie -o main 152_Maracine_ConstantinRazvan_2.s

	@gcc  -o sol conway.c
	@g++  -o brute conway_0.cpp

t0:
	@gcc -m32 -no-pie -o main 152_Maracine_ConstantinRazvan_0.s
	@./main < input

t1:
	@gcc -m32 -no-pie -o main 152_Maracine_ConstantinRazvan_1.s
	@./main < input

t2:
	@gcc -m32 -no-pie -o main 152_Maracine_ConstantinRazvan_2.s
	@./main < input
