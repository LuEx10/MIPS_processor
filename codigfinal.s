# t0 = num 1
# t1 = num 2
# t2 = máximo de iteracoes
# t3 = contador
# t4 = num1 + num 2
# s0 = end de memoria

main:
	addi $t0, $t0,  0  		# 21080000	
	addi $t1, $t1, 1     	# 21290001
	addi $t2, $t2, 17     	# 214A0011
	addi $t3, $t3, 0     	# 216B0000
#---------fibonacci_loop-------
	sw $t0, 0($s0)			# AE080000		PC = 14
	add $t4, $t0, $t1		# 01096020
	add $t0, $t1, $zero		# 01204020
	add $t1, $t4, $zero     # 01804820
	addi $t3, $t3, 1		# 216B0001
	addi $s0, $s0, 4		# 22100004
	beq $t3, $t2, end		# 
	j fibonacci_loop		# 08000005
end: 
	final