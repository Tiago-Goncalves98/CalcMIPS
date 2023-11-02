##########################################################
# Projeto de Arquitetura de Computadores 2020/2021 - UAL #
# TEMA: Calculadora Científica   FASE:4                  #
# GRUPO:                                                 #
# 30007039 - Andre Goncalves                             #
# 30007075 - Tiago Goncalves                             #
##########################################################
.data
	frameBuffer: 	.space 	0x80000	# space for bitmap display
	#files
	menudirectory: .asciiz "menu.data"
	menuspace: .space 1024
	helpdirectory: .asciiz "help.data"
	helpspace: .space 1024
	basicfile: .asciiz "basichelp.data"
	basicspace: .space 1024
	basefile: .asciiz "basechelp.data"
	basespace: .space 1024
	logfile: .asciiz "loghelp.data"
	logspace: .space 1024
	powerfile: .asciiz "powerhelp.data"
	powerspace: .space 1024
	rootfile: .asciiz "roothelp.data"
	rootspace: .space 1024
	trigfile: .asciiz "trighelp.data"
	trigspace: .space 1024
	#inputs
	intinput: .word
	floatinput: .float
	result: .float
	#constants
	precision2: .float 0.001 #pouca precisao senao iria demorar demasiado tempo 
	precision: .double 0.000001
	sevenfact: .float 5040
	fivefact: .float 120
	fourfact: .float 24
	threefact: .float 6
	twofact: .float 2
	one: .float 1
	#prompts
	closeprogram: .asciiz "Programa encerrado."
	badinput: .asciiz "Input incorreto, tente de novo.\n"
	space: .asciiz " "
	newline: .asciiz "\n"
	entervalue: .asciiz "Introduza valor: \n"
	enterint: .asciiz "Introduza o seu inteiro: \n"
	enterpower: .asciiz "Introduza a potencia: \n"
	addprompt: .asciiz "O valor da adicao e: "
	subprompt: .asciiz "O valor da subtracao e: "
	mulprompt: .asciiz "O valor da multiplicao e: "
	divprompt: .asciiz "O valor da divisao e: "
	powerprompt: .asciiz "O valor da potencia e: "
	convprompt: .asciiz "Valor Convertido: "
	logexception: .asciiz "O logaritmo de 1 e sempre 0.\n"
	logexception2: .asciiz "O valor do logaritmo e: 1"
	logprompt1: .asciiz "1 - Logaritmo de base 2\n"
	logprompt2: .asciiz "2 - Logaritmo de base 10\n"
	logdoneprompt: .asciiz "O valor do logaritmo e: "
	logfailureprompt: .asciiz "Nao consigo calcular o resultado pois e negativou e/ou decimal ou e indefinido.\n"
	rootprompt: .asciiz "A raiz quadrada e: "
	trigprompt1: .asciiz "1 - Seno\n"
	trigprompt2: .asciiz "2 - Cosseno\n"
	resultprompt: .asciiz "Resultado e: "
	rootprompt1: .asciiz "1 - Raiz quadrada\n"
	rootprompt2: .asciiz "2 - Raiz Cubica\n"
	zeroresultprompt: .asciiz "\nResultado e 0.\n"
	zeroexcepprompt: .asciiz "\nA solucao e zero ou um numero imaginario.\n"
.text
	calldraw:
		jal draw
	main:
		#Command line interface
		#open menu text file
		li $v0,13
		la $a0,menudirectory
		li $a1,0
		syscall
		#read from menu text file
		move $s0,$v0
		li $v0,14
		move $a0,$s0
		la $a1,menuspace
		la $a2,1024
		syscall
		#print menu text file
		li $v0,4
		la $a0,menuspace
		syscall
		li $v0,4
		la $a0,newline
		syscall
		#selecting from menu
		li $v0,5
		syscall
		move $t1,$v0
		beqz $t1,endprogram
		beq $t1,1,Addition
		beq $t1,2,Subtraction
		beq $t1,3,Multiplication
		beq $t1,4,Division
		beq $t1,5,Deciamal2Binary
		beq $t1,6,Deciamal2Hexa
		beq $t1,7,Logarithm
		beq $t1,8,Power
		beq $t1,9,Roots
		beq $t1,10,Trigonometry
		beq $t1,11,Help
		bgt $t1,11,wronginput
		blt $t1,0,wronginput
		j main
		#Preping inputs and such lul
		wronginput:
			li $v0,4
			la $a0,badinput
			syscall
			j main
		wronginput2:
			li $v0,4
			la $a0,badinput
			syscall
			j Help
		#preping inputs
		Addition:
			li $v0,4
			la $a0,entervalue
			syscall
			li $v0,6
			syscall
			add.s $f4,$f0,$f8
			li $v0,4
			la $a0,entervalue
			syscall
			li $v0,6
			syscall
			add.s $f6,$f0,$f8
			jal addnumbs
		Subtraction:
			li $v0,4
			la $a0,entervalue
			syscall
			li $v0,6
			syscall
			add.s $f4,$f0,$f8
			li $v0,4
			la $a0,entervalue
			syscall
			li $v0,6
			syscall
			add.s $f6,$f0,$f8
			jal subnumbs
		Multiplication:
			li $v0,4
			la $a0,entervalue
			syscall
			li $v0,6
			syscall
			add.s $f4,$f0,$f8
			li $v0,4
			la $a0,entervalue
			syscall
			li $v0,6
			syscall
			add.s $f6,$f0,$f8
			jal mulnumbs
		Division:
			li $v0,4
			la $a0,entervalue
			syscall
			li $v0,6
			syscall
			add.s $f4,$f0,$f8
			li $v0,4
			la $a0,entervalue
			syscall
			li $v0,6
			syscall
			add.s $f6,$f0,$f8
			jal divnumbs
		Deciamal2Binary:
			li $v0,4
			la $a0,entervalue
			syscall
			li $v0,5
			syscall
			move $s1,$v0
			li $v0,4
			la $a0,convprompt
			syscall
			li $v0,35 #built-in available service for printing intergers as binary
			move $a0,$s1
			syscall
			li $v0,4
			la $a0,newline
			syscall
			j main
		Deciamal2Hexa:
			li $v0,4
			la $a0,entervalue
			syscall
			li $v0,5
			syscall
			move $s1,$v0
			li $v0,4
			la $a0,convprompt
			syscall
			li $v0,34 #built-in available service for printing intergers as hexadecimal
			move $a0,$s1
			syscall
			li $v0,4
			la $a0,newline
			syscall
			j main
		Logarithm:
			li $v0,4
			la $a0,logprompt1
			syscall
			li $v0,4
			la $a0,logprompt2
			syscall
			li $v0,5
			syscall
			move $t1,$v0
			beq $t1,1,logtwo
			beq $t1,2,logten
			bgt $t1,2,wronginput
			blt $t1,1,wronginput
		Power:
			li $v0,4
			la $a0,entervalue
			syscall
			li $v0,6
			syscall
			add.s $f2,$f0,$f28
			li $v0,4
			la $a0,enterpower
			syscall
			li $v0,5
			syscall
			move $t3,$v0
			j calcpower
		Trigonometry:
			li $v0,4
			la $a0,trigprompt1
			syscall
			li $v0,4
			la $a0,trigprompt2
			syscall
			li $v0,5
			syscall
			move $t1,$v0
			beq $t1,1,sine
			beq $t1,2,cosine
			bgt $t1,2,wronginput
			blt $t1,1,wronginput
		Roots:
			li $v0,4
			la $a0,rootprompt1
			syscall
			li $v0,4
			la $a0,rootprompt2
			syscall
			li $v0,5
			syscall
			move $t2,$v0
			beq $t2,1,SQroot
			beq $t2,2,CUBEroot
			blt $t2,1,wronginput
			bgt $t2,2,wronginput
			
		Help:
 			#open help text file
 			li   $v0,13     
 			la   $a0,helpdirectory     
 			li   $a1,0
 			li   $a2,0     
 			syscall            
 			move $s0,$v0   
 			#read help text file
 			li   $v0,14    
 			move $a0,$s0       
 			la   $a1,helpspace 
 			li   $a2, 1024  
 			syscall
 			#print help text file
 			li  $v0,4          
 			la  $a0,helpspace    
 			syscall
 			li $v0,4
			la $a0,newline
			syscall
 			
 			li $v0,5
 			syscall
 			move $t1,$v0
 			blt $t1,1,wronginput2
 			beq $t1,1,Basichelp
			beq $t1,2,Basehelp
			beq $t1,3,Loghelp
			beq $t1,4,Powerhelp
			beq $t1,5,Roothelp
			beq $t1,6,Trighelp
			beq $t1,7,main
			bgt $t1,7,wronginput2
			
		Basichelp:
 			li   $v0,13     
 			la   $a0,basicfile    
 			li   $a1,0
 			li   $a2,0     
 			syscall            
 			move $s0,$v0   
 			li   $v0,14    
 			move $a0,$s0       
 			la   $a1,basicspace 
 			li   $a2, 1024  
 			syscall
 			li  $v0,4          
 			la  $a0,basicspace    
 			syscall
 			li $v0,4
			la $a0,newline
			syscall
			j Help
			
		Basehelp:
			li   $v0,13     
 			la   $a0,basefile    
 			li   $a1,0
 			li   $a2,0     
 			syscall            
 			move $s0,$v0   
 			li   $v0,14    
 			move $a0,$s0       
 			la   $a1,basespace 
 			li   $a2, 1024  
 			syscall
 			li  $v0,4          
 			la  $a0,basespace    
 			syscall
 			li $v0,4
			la $a0,newline
			syscall
			j Help
			
		Loghelp:
			li   $v0,13     
 			la   $a0,logfile    
 			li   $a1,0
 			li   $a2,0     
 			syscall            
 			move $s0,$v0   
 			li   $v0,14    
 			move $a0,$s0       
 			la   $a1,logspace 
 			li   $a2, 1024  
 			syscall
 			li  $v0,4          
 			la  $a0,logspace    
 			syscall
 			li $v0,4
			la $a0,newline
			syscall
			j Help
			
		Powerhelp:
			li   $v0,13     
 			la   $a0,powerfile    
 			li   $a1,0
 			li   $a2,0     
 			syscall            
 			move $s0,$v0   
 			li   $v0,14    
 			move $a0,$s0       
 			la   $a1,powerspace 
 			li   $a2, 1024  
 			syscall
 			li  $v0,4          
 			la  $a0,powerspace    
 			syscall
 			li $v0,4
			la $a0,newline
			syscall
			j Help
			
		Roothelp:
			li   $v0,13     
 			la   $a0,rootfile    
 			li   $a1,0
 			li   $a2,0     
 			syscall            
 			move $s0,$v0   
 			li   $v0,14    
 			move $a0,$s0       
 			la   $a1,rootspace 
 			li   $a2, 1024  
 			syscall
 			li  $v0,4          
 			la  $a0,rootspace    
 			syscall
 			li $v0,4
			la $a0,newline
			syscall
			j Help
			
		Trighelp:
			li   $v0,13     
 			la   $a0,trigfile    
 			li   $a1,0
 			li   $a2,0     
 			syscall            
 			move $s0,$v0   
 			li   $v0,14    
 			move $a0,$s0       
 			la   $a1,trigspace 
 			li   $a2, 1024  
 			syscall
 			li  $v0,4          
 			la  $a0,trigspace    
 			syscall
 			li $v0,4
			la $a0,newline
			syscall
			j Help
			
#functions
#-------------------------------------------------------------------------
#root functions
	CUBEroot:
		li $v0,4
		la $a0,entervalue
		syscall
		li $v0,6
		syscall
		li $t4,0
		mtc1 $t4,$f28
		cvt.s.w $f28,$f28 #making sure f28 is zero
		add.s $f2,$f0,$f28
		add.s $f30,$f2,$f28 #storing input in f30 for later use
		add.s $f6,$f28,$f28 #for adding precision later
		add.s $f24,$f2,$f28 #for later use if input is negative
		c.eq.s $f30,$f28
		bc1t zeroresult
		c.lt.s $f30,$f28
		bc1t negnumb
		c.lt.s $f28,$f30
		bc1t maincalc
		maincalc:
			l.s $f26,precision2
			add.s $f6,$f6,$f26 #f6 will be the final result
			mul.s $f8,$f6,$f6
			mul.s $f8,$f8,$f6
			c.lt.s $f8,$f24
			bc1t maincalc
			c.eq.s $f8,$f24
			bc1t calcdone
			c.lt.s $f24,$f8
			bc1t calcdone
		negnumb:#converting input to positive number
			li $t4,-1
			mtc1 $t4,$f22
			cvt.s.w $f22,$f22
			mul.s $f24,$f24,$f22
			j maincalc
		calcdone:
			c.lt.s $f30,$f28
			bc1t negdone
			li $v0,4
			la $a0,resultprompt
			syscall
			li $v0,2
			add.s $f12,$f6,$f28
			syscall
			li $v0,4
			la $a0,newline
			syscall
			li $v0,4
			la $a0,newline
			syscall
			j main
		negdone:
			li $v0,4
			la $a0,resultprompt
			syscall
			li $v0,2
			mul.s $f12,$f6,$f22
			syscall
			li $v0,4
			la $a0,newline
			syscall
			li $v0,4
			la $a0,newline
			syscall
			j main
		zeroresult:
			li $v0,4
			la $a0,zeroresultprompt
			syscall
			li $v0,10
			syscall
			j main
	
	
	SQroot:
		li $v0,4
		la $a0,entervalue
		syscall
		li $v0,7
		syscall
		add.d $f2,$f0,$f28 #x
		c.le.d $f2,$f28
		bc1t zeroorless
		add.d $f4,$f2,$f30 #r
		l.d $f6,precision
		rootwhile:
			mul.d $f8,$f4,$f4 #r^2
			sub.d $f10,$f2,$f8
			abs.d $f10,$f10
			c.le.d $f10,$f6 
			bc1t rootdone
			div.d $f16,$f2,$f4
			add.d $f18,$f4,$f16
			li $t4,2
			mtc1 $t4,$f20
			cvt.d.w $f20,$f20
			div.d $f4,$f18,$f20
			j rootwhile
		rootdone:
			li $v0,4
			la $a0,resultprompt
			syscall
			li $v0,3
			add.d $f12,$f28,$f4
			syscall
			li $v0,4
			la $a0,newline
			syscall
			li $v0,4
			la $a0,newline
			syscall
			j main
		
		zeroorless:
			li $v0,4
			la $a0,zeroexcepprompt
			syscall
			li $v0,4
			la $a0,newline
			syscall
			j main
#--------------------------------------------------------------------------
#trigonometry

	sine:#serie de taylor para calcular o seno
		li $v0,4
		la $a0,entervalue
		syscall
		li $v0,6
		syscall
		mov.s $f2,$f0

		#calc x-((x^3)/3!)
		powerthree:
			add.s $f4,$f28,$f2 #result
			addi $t4,$zero,1 #power
			threepowerwhile:
				beq $t4,3,powerthreedone
				mul.s $f4,$f4,$f2
				addi $t4,$t4,1
				j threepowerwhile
		powerthreedone:
			l.s $f6,threefact
			mov.s $f2,$f0
			div.s $f4,$f4,$f6
			sub.s $f2,$f2,$f4
			s.s $f2,result
			
		#calc  +((x^5)/5!)
		powerfive:
			mov.s $f2,$f0
			add.s $f4,$f28,$f2 #result
			addi $t4,$zero,1 #power
			fivepowerwhile:
				beq $t4,5,powerfivedone
				mul.s $f4,$f4,$f2
				addi $t4,$t4,1
				j fivepowerwhile
		powerfivedone:
			l.s $f2,result
			l.s $f6,fivefact
			div.s $f4,$f4,$f6
			add.s $f2,$f2,$f4
			s.s $f2,result
		
		#calc -((x^7)/7!)
		
		powerseven:
			mov.s $f2,$f0
			add.s $f4,$f28,$f2 #result
			addi $t4,$zero,1 #power
			sevenpowerwhile:
				beq $t4,7,powersevendone
				mul.s $f4,$f4,$f2
				addi $t4,$t4,1
				j sevenpowerwhile
		powersevendone:
			addi $t6,$zero,5040
			mtc1 $t6,$f8
			cvt.s.w $f8,$f8
			l.s $f2,result
			div.s $f4,$f4,$f8
			sub.s $f2,$f2,$f4
			li $v0,4
			la $a0,resultprompt
			syscall
			li $v0,2
			mov.s $f12,$f2
			syscall
			li $v0,4
			la $a0,newline
			syscall
			li $v0,4
			la $a0,newline
			syscall
		
			j main
			
	cosine:#serie de taylor para calcular o coseno
		li $v0,4
		la $a0,entervalue
		syscall
		li $v0,6
		syscall
		mov.s $f2,$f0

		#calc x-((x^2)/2!)
		powertwo:
			add.s $f4,$f28,$f2 #result
			addi $t4,$zero,1 #power
			twopowerwhile:
				beq $t4,2,powertwodone
				mul.s $f4,$f4,$f2
				addi $t4,$t4,1
				j twopowerwhile
		powertwodone:
			l.s $f6,twofact
			l.s $f2,one
			div.s $f4,$f4,$f6
			sub.s $f2,$f2,$f4
			s.s $f2,result
			
		#calc  +((x^4)/4!)
		powerfour:
			mov.s $f2,$f0
			add.s $f4,$f28,$f2 #result
			addi $t4,$zero,1 #power
			fourpowerwhile:
				beq $t4,4,powerfourdone
				mul.s $f4,$f4,$f2
				addi $t4,$t4,1
				j fourpowerwhile
		powerfourdone:
			l.s $f2,result
			l.s $f6,fourfact
			div.s $f4,$f4,$f6
			add.s $f2,$f2,$f4
			s.s $f2,result
		
		#calc -((x^6)/6!)
		
		powersix:
			mov.s $f2,$f0
			add.s $f4,$f28,$f2 #result
			addi $t4,$zero,1 #power
			sixpowerwhile:
				beq $t4,6,powersixdone
				mul.s $f4,$f4,$f2
				addi $t4,$t4,1
				j sixpowerwhile
		powersixdone:
			addi $t6,$zero,720
			mtc1 $t6,$f8
			cvt.s.w $f8,$f8
			l.s $f2,result
			div.s $f4,$f4,$f8
			sub.s $f2,$f2,$f4
			li $v0,4
			la $a0,resultprompt
			syscall
			li $v0,2
			mov.s $f12,$f2
			syscall
			li $v0,4
			la $a0,newline
			syscall
			li $v0,4
			la $a0,newline
			syscall
		
			j main
#-------------------------------------------------------------------------------
#calculate powers

	calcpower:
		add.s $f4,$f28,$f2 #result
		addi $t5,$zero,1
		powerwhile:
			beq $t5,$t3,powerdone
			mul.s $f4,$f4,$f2
			addi $t5,$t5,1
			j powerwhile
	powerdone:
		li $v0,4
		la $a0,powerprompt
		syscall
		li $v0,2
		add.s $f12,$f4,$f28
		syscall
		li $v0,4
		la $a0,newline
		syscall
		li $v0,4
		la $a0,newline
		syscall
		j main
#-------------------------------------------------------------------------
#logarithms

	logtwo:
		li $v0,4
		la $a0,enterint
		syscall
		li $v0,5
		syscall
		sw $v0,intinput
		addi $t3,$zero,2 #base
		addi $t4,$zero,2 #expoente
		lw $t5,intinput #input
		beq $t3,$t5,exception2
		beq $t5,1,exception
		addi $t7,$zero,2
		logtwowhile:
			mul $t7,$t7,$t3
			beq $t7,$t5,logdone
			bgt $t7,$t5,logfailure
			addi $t4,$t4,1
			blt $t7,$t5,logtwowhile
			
	logten:
		li $v0,4
		la $a0,enterint
		syscall
		li $v0,5
		syscall
		sw $v0,intinput
		addi $t3,$zero,10 #base
		addi $t4,$zero,2 #expoente
		lw $t5,intinput #input
		beq $t3,$t5,exception2
		beq $t5,1,exception
		addi $t7,$zero,10
		logtenwhile:
			mul $t7,$t7,$t3
			beq $t7,$t5,logdone
			bgt $t7,$t5,logfailure
			addi $t4,$t4,1
			blt $t7,$t5,logtenwhile
	
	logdone:
		li $v0,4
		la $a0,logdoneprompt
		syscall
		li $v0,1
		move $a0,$t4
		syscall
		li $v0,4
		la $a0,newline
		syscall
		li $v0,4
		la $a0,newline
		syscall
		j main
		
	logfailure:
		li $v0,4
		la $a0,logfailureprompt
		syscall
		j main
#-----------------------------------------------------------------------------
#basic operations
			
	addnumbs:
		li $v0,4
		la $a0,addprompt
		syscall
		li $v0,2
		add.s $f12,$f4,$f6
		syscall
		li $v0,4
		la $a0,newline
		syscall
		li $v0,4
		la $a0,newline
		syscall
		j main
		
	subnumbs:	
		li $v0,4
		la $a0,subprompt
		syscall
		li $v0,2
		sub.s $f12,$f4,$f6
		syscall
		li $v0,4
		la $a0,newline
		syscall
		li $v0,4
		la $a0,newline
		syscall
		j main
		
	mulnumbs:
		li $v0,4
		la $a0,mulprompt
		syscall
		li $v0,2
		mul.s $f12,$f4,$f6
		syscall
		li $v0,4
		la $a0,newline
		syscall
		li $v0,4
		la $a0,newline
		syscall
		j main
		
	divnumbs:
		li $v0,4
		la $a0,divprompt
		syscall
		li $v0,2
		div.s $f12,$f4,$f6
		syscall
		li $v0,4
		la $a0,newline
		syscall
		li $v0,4
		la $a0,newline
		syscall
		j main
#------------------------------------------------------------------------------
#miscellaneous		
	exception:
		li $v0,4
		la $a0,logexception
		syscall
		li $v0,4
		la $a0,newline
		syscall
		li $v0,4
		la $a0,newline
		syscall
		j main
		
	exception2:
		li $v0,4
		la $a0,logexception2
		syscall
		li $v0,4
		la $a0,newline
		syscall
		li $v0,4
		la $a0,newline
		syscall
		j main
#----------------------------------------------------------------------------------------------
#bitmap display
	draw:
	
			#draw background color
			la $t0, frameBuffer	# load frame buffer addres
			li $t1, 0x20000  	# save 512*256 pixels
			li $t2, 0x00003333	# load background color
		background:
			sw   $t2, 0($t0)
			addi $t0, $t0, 4 	# advance to next pixel position in display
			addi $t1, $t1, -1	# decrement number of pixels
			bnez $t1, background    # repeat while number of pixels is not zero
			
			
			la $t0,frameBuffer+1528
			li $t1,0x100		#total lines
			li $t3,0xffffffff   	#white
		whiterectangle:
			li $t2,0x00000082		#total pixel in line
			whiteline:
				sw $t3,0($t0)
				addi $t0,$t0,4
				addi $t2,$t2,-1
				bnez $t2,whiteline
				addi $t0,$t0,1528
				addi $t1,$t1,-1
				bnez $t1,whiterectangle
				
				
				# for first square
				la $t0,frameBuffer+8208
				li $t2,0x0000003B #y for loop
				li $t3,0x00e6ffff #key color
		#draw squares to form a grid
		whitesquare1:
			li $t1,0x0000003B #x for loop
				paintsquare1:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare1
					addi $t0,$t0,1796
					addi $t0,$t0,16
					addi $t2,$t2,-1
					bnez $t2,whitesquare1
					
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+137232
		whitesquare2:
			li $t1,0x0000003B #x
				paintsquare2:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare2
					addi $t0,$t0,1796
					addi $t0,$t0,16
					addi $t2,$t2,-1
					bnez $t2,whitesquare2
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+266256
		whitesquare3:
			li $t1,0x0000003B #x
				paintsquare3:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare3
					addi $t0,$t0,1796
					addi $t0,$t0,16
					addi $t2,$t2,-1
					bnez $t2,whitesquare3
					
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+395280
		whitesquare4:
			li $t1,0x0000003B #x
				paintsquare4:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare4
					addi $t0,$t0,1796
					addi $t0,$t0,16
					addi $t2,$t2,-1
					bnez $t2,whitesquare4
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+8460
		whitesquare5:
			li $t1,0x0000003B #x
				paintsquare5:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare5
					addi $t0,$t0,1544
					addi $t0,$t0,268
					addi $t2,$t2,-1
					bnez $t2,whitesquare5
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+137484
		whitesquare6:
			li $t1,0x0000003B #x
				paintsquare6:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare6
					addi $t0,$t0,1544
					addi $t0,$t0,268
					addi $t2,$t2,-1
					bnez $t2,whitesquare6
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+266508
		whitesquare7:
			li $t1,0x0000003B #x
				paintsquare7:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare7
					addi $t0,$t0,1544
					addi $t0,$t0,268
					addi $t2,$t2,-1
					bnez $t2,whitesquare7
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+395532
		whitesquare8:
			li $t1,0x0000003B #x
				paintsquare8:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare8
					addi $t0,$t0,1544
					addi $t0,$t0,268
					addi $t2,$t2,-1
					bnez $t2,whitesquare8
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+8712
		whitesquare9:
			li $t1,0x0000003B #x
				paintsquare9:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare9
					addi $t0,$t0,1292
					addi $t0,$t0,520
					addi $t2,$t2,-1
					bnez $t2,whitesquare9
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+137736
		whitesquare10:
			li $t1,0x0000003B #x
				paintsquare10:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare10
					addi $t0,$t0,1292
					addi $t0,$t0,520
					addi $t2,$t2,-1
					bnez $t2,whitesquare10
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+266760
		whitesquare11:
			li $t1,0x0000003B #x
				paintsquare11:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare11
					addi $t0,$t0,1292
					addi $t0,$t0,520
					addi $t2,$t2,-1
					bnez $t2,whitesquare11
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+395784
		whitesquare12:
			li $t1,0x0000003B #x
				paintsquare12:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare12
					addi $t0,$t0,1292
					addi $t0,$t0,520
					addi $t2,$t2,-1
					bnez $t2,whitesquare12
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+8964
		whitesquare13:
			li $t1,0x0000003B #x
				paintsquare13:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare13
					addi $t0,$t0,1040
					addi $t0,$t0,772
					addi $t2,$t2,-1
					bnez $t2,whitesquare13
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+137988
		whitesquare14:
			li $t1,0x0000003B #x
				paintsquare14:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare14
					addi $t0,$t0,1040
					addi $t0,$t0,772
					addi $t2,$t2,-1
					bnez $t2,whitesquare14
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+267012
		whitesquare15:
			li $t1,0x0000003B #x
				paintsquare15:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare15
					addi $t0,$t0,1040
					addi $t0,$t0,772
					addi $t2,$t2,-1
					bnez $t2,whitesquare15
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+396036
		whitesquare16:
			li $t1,0x0000003B #x
				paintsquare16:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare16
					addi $t0,$t0,1040
					addi $t0,$t0,772
					addi $t2,$t2,-1
					bnez $t2,whitesquare16
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+9216
		whitesquare17:
			li $t1,0x0000003B #x
				paintsquare17:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare17
					addi $t0,$t0,788
					addi $t0,$t0,1024
					addi $t2,$t2,-1
					bnez $t2,whitesquare17
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+138240
		whitesquare18:
			li $t1,0x0000003B #x
				paintsquare18:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare18
					addi $t0,$t0,788
					addi $t0,$t0,1024
					addi $t2,$t2,-1
					bnez $t2,whitesquare18
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+267264
		whitesquare19:
			li $t1,0x0000003B #x
				paintsquare19:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare19
					addi $t0,$t0,788
					addi $t0,$t0,1024
					addi $t2,$t2,-1
					bnez $t2,whitesquare19
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+396288
		whitesquare20:
			li $t1,0x0000003B #x
				paintsquare20:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare20
					addi $t0,$t0,788
					addi $t0,$t0,1024
					addi $t2,$t2,-1
					bnez $t2,whitesquare20
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+9468
		whitesquare21:
			li $t1,0x0000003B #x
				paintsquare21:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare21
					addi $t0,$t0,520
					addi $t0,$t0,1292
					addi $t2,$t2,-1
					bnez $t2,whitesquare21
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+138492
		whitesquare22:
			li $t1,0x0000003B #x
				paintsquare22:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare22
					addi $t0,$t0,520
					addi $t0,$t0,1292
					addi $t2,$t2,-1
					bnez $t2,whitesquare22
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+267516
		whitesquare23:
			li $t1,0x0000003B #x
				paintsquare23:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare23
					addi $t0,$t0,520
					addi $t0,$t0,1292
					addi $t2,$t2,-1
					bnez $t2,whitesquare23
					
					li $t2,0x0000003B #y
					la $t0,frameBuffer+396540
		whitesquare24:
			li $t1,0x0000003B #x
				paintsquare24:
					sw $t3,0($t0)
					addi $t0,$t0,4
					addi $t1,$t1,-1
					bnez $t1,paintsquare24
					addi $t0,$t0,520
					addi $t0,$t0,1292
					addi $t2,$t2,-1
					bnez $t2,whitesquare24
		#draw numbers and such on the grid itself
		# drawing number 0
		drawzero:
			li $t1, 0x00003333 # load the color
			la $t0,frameBuffer+403508
			li $t2,5
			zerotopline:
				li $t3,41
				zerolinetoploop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,zerolinetoploop
					addi $t0,$t0,1828
					addi $t0,$t0,56
					addi $t2,$t2,-1
					bnez $t2,zerotopline
					
					la $t0,frameBuffer+403508
					li $t2,51
			zeroleftline:
				li $t3,5
				zeroleftlineloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,zeroleftlineloop
					addi $t0,$t0,1976
					addi $t0,$t0,52
					addi $t2,$t2,-1
					bnez $t2,zeroleftline
					
					la $t0,frameBuffer+403660
					li $t2,51
			zerorightline:
				li $t3,5
				zerorightlineloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,zerorightlineloop
					addi $t0,$t0,1828
					addi $t0,$t0,200
					addi $t2,$t2,-1
					bnez $t2,zerorightline
					
					la $t0,frameBuffer+499764
					li $t2,5
			zerobotline:
				li $t3,42
				zerobotlineloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,zerobotlineloop
					addi $t0,$t0,1824
					addi $t0,$t0,56
					addi $t2,$t2,-1
					bnez $t2,zerobotline
		#drawing dot
		drawdot:
			la $t0,frameBuffer+487788
			li $t2,11
			dot:
				li $t3,11
				dotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,dotloop
					addi $t0,$t0,1640
					addi $t0,$t0,364
					addi $t2,$t2,-1
					bnez $t2,dot
		#draw equals sign
		drawequals:
			li $t2,11
			la $t0,frameBuffer+416304
				topequals:
					li $t3,41
					topequalsloop:
						sw $t1,0($t0)
						add $t0,$t0,4
						addi $t3,$t3,-1
						bnez $t3,topequalsloop
						addi $t0,$t0,1328
						addi $t0,$t0,556
						addi $t2,$t2,-1
						bnez $t2,topequals
						
						la $t0,frameBuffer+473648
						li $t2,11
				botequals:
					li $t3,41
					botequalsloop:
						sw $t1,0($t0)
						add $t0,$t0,4
						addi $t3,$t3,-1
						bnez $t3,botequalsloop
						addi $t0,$t0,1328
						addi $t0,$t0,556
						addi $t2,$t2,-1
						bnez $t2,botequals
		#draw div sign
		drawdiv:
			li $t2,7
			la $t0,frameBuffer+414576
			topdot:
				li $t3,7
				topdotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,topdotloop
					addi $t0,$t0,1144
					addi $t0,$t0,876
					addi $t2,$t2,-1
					bnez $t2,topdot
					
					li $t2,7
					la $t0,frameBuffer+484208
			botdot:
				li $t3,7
				botdotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,botdotloop
					addi $t0,$t0,1144
					addi $t0,$t0,876
					addi $t2,$t2,-1
					bnez $t2,botdot
					
					la $t0,frameBuffer+451368
					li $t2,7
			middleline:
				li $t3,43
				middlelineloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,middlelineloop
					addi $t0,$t0,1072
					addi $t0,$t0,804
					addi $t2,$t2,-1
					bnez $t2,middleline
					
		drawE:
			la $t0,frameBuffer+414756
			li $t2,6
			topEline:
				li $t3,42
				topElineloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,topElineloop
					addi $t0,$t0,1072
					addi $t0,$t0,808
					addi $t2,$t2,-1
					bnez $t2,topEline
					
					la $t0,frameBuffer+414756
					li $t2,41
			Eleftline:
				li $t3,7
				Eleftloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Eleftloop
					addi $t0,$t0,1212
					addi $t0,$t0,808
					addi $t2,$t2,-1
					bnez $t2,Eleftline
					
					la $t0,frameBuffer+490532
					li $t2,6
			Ebotline:
				li $t3,42
				Ebotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Ebotloop
					addi $t0,$t0,1072
					addi $t0,$t0,808
					addi $t2,$t2,-1
					bnez $t2,Ebotline
					
					la $t0,frameBuffer+455716
					li $t2,5
			Emiddleline:
				li $t3,33
				Emiddleloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Emiddleloop
					addi $t0,$t0,1072
					addi $t0,$t0,844
					addi $t2,$t2,-1
					bnez $t2,Emiddleline
					
		drawC: #for Close
			la $t0,frameBuffer+415008
			li $t2,6
			Ctopline:
				li $t3,33
				Ctoploop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Ctoploop
					addi $t0,$t0,1072
					addi $t0,$t0,844
					addi $t2,$t2,-1
					bnez $t2,Ctopline
					
					la $t0,frameBuffer+415008
					li $t2,41
			Cleftline:
				li $t3,7
				Cleftloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Cleftloop
					addi $t0,$t0,716
					addi $t0,$t0,1304
					addi $t2,$t2,-1
					bnez $t2,Cleftline
					
					la $t0,frameBuffer+488736
					li $t2,6
			Cbotline:
				li $t3,33
				Cbotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Cbotloop
					addi $t0,$t0,1072
					addi $t0,$t0,844
					addi $t2,$t2,-1
					bnez $t2,Cbotline
					
		drawone:
			li $t2,45
			la $t0,frameBuffer+280752
			onevertline:
				li $t3,9
				onevertloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,onevertloop
					addi $t0,$t0,1840
					addi $t0,$t0,172
					addi $t2,$t2,-1
					bnez $t2,onevertline
					
					li $t2,23
					la $t0,frameBuffer+280752
			onetiltline:
				li $t3,9
				onetiltloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,onetiltloop
					addi $t0,$t0,1836
					addi $t0,$t0,172
					addi $t2,$t2,-1
					bnez $t2,onetiltline
		drawtwo:
			la $t0,frameBuffer+282924
			li $t2,7
			twotopline:
				li $t3,45
				twotoploop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,twotoploop
					addi $t0,$t0,1748
					addi $t0,$t0,120
					addi $t2,$t2,-1
					bnez $t2,twotopline
					
					la $t0,frameBuffer+321836
					li $t2,7
			twomiddleline:
				li $t3,45
				twomiddleloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,twomiddleloop
					addi $t0,$t0,1748
					addi $t0,$t0,120
					addi $t2,$t2,-1
					bnez $t2,twomiddleline
					
					la $t0,frameBuffer+360748
					li $t2,7
			twobotline:
				li $t3,45
				twobotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,twobotloop
					addi $t0,$t0,1748
					addi $t0,$t0,120
					addi $t2,$t2,-1
					bnez $t2,twobotline
					
					la $t0,frameBuffer+283076
					li $t2,26
			tworightline:
				li $t3,7
					tworightloop:
						sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,tworightloop
					addi $t0,$t0,1572
					addi $t0,$t0,448
					addi $t2,$t2,-1
					bnez $t2,tworightline
					
					la $t0,frameBuffer+321836
					li $t2,26
			twoleftline:
				li $t3,7
				twoleftloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,twoleftloop
					addi $t0,$t0,1740
					addi $t0,$t0,280
					addi $t2,$t2,-1
					bnez $t2,twoleftline
		drawthree:
			la $t0,frameBuffer+283176
			li $t2,7
			threetopline:
				li $t3,45
				threetoploop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,threetoploop
					addi $t0,$t0,1748
					addi $t0,$t0,120
					addi $t2,$t2,-1
					bnez $t2,threetopline
					
					la $t0,frameBuffer+361000
					li $t2,7
			threebotline:
				li $t3,45
				threebotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,threebotloop
					addi $t0,$t0,1748
					addi $t0,$t0,120
					addi $t2,$t2,-1
					bnez $t2,threebotline
					
					la $t0,frameBuffer+283328
					li $t2,40
			threerightline:
				li $t3,7
				threerightloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,threerightloop
					addi $t0,$t0,1336
					addi $t0,$t0,684
					addi $t2,$t2,-1
					bnez $t2,threerightline
					
					la $t0,frameBuffer+322124
					li $t2,7
			threemiddleline:
				li $t3,35
				threemiddleloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,threemiddleloop
					addi $t0,$t0,1288
					addi $t0,$t0,620
					addi $t2,$t2,-1
					bnez $t2,threemiddleline
		drawX:
			la $t0,frameBuffer+283428
			li $t2,40
			Xfirst:
				li $t3,7
				Xfirstloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Xfirstloop
					addi $t0,$t0,1264
					addi $t0,$t0,760
					addi $t2,$t2,-1
					bnez $t2,Xfirst
					
					li $t2,40
					la $t0,frameBuffer+283580
			Xsecond:
				li $t3,7
				Xsecondloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Xsecondloop
					addi $t0,$t0,1260
					addi $t0,$t0,756
					addi $t2,$t2,-1
					bnez $t2,Xsecond
					
		drawroot:
			li $t2,5
			la $t0,frameBuffer+283680
			Rtopline:
				li $t3,42
				Rtoploop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Rtoploop
					addi $t0,$t0,1108
					addi $t0,$t0,772
					addi $t2,$t2,-1
					bnez $t2,Rtopline
					
					li $t2,44
					la $t0,frameBuffer+283680
			Rleftline:
				li $t3,5
				Rleftloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Rleftloop
					addi $t0,$t0,1140
					addi $t0,$t0,888
					addi $t2,$t2,-1
					bnez $t2,Rleftline
					
					li $t2,25
					la $t0,frameBuffer+283828
			Rrightline:
				li $t3,5
				Rrightloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Rrightloop
					addi $t0,$t0,1128
					addi $t0,$t0,900
					addi $t2,$t2,-1
					bnez $t2,Rrightline
					
					li $t2,5
					la $t0,frameBuffer+326688
			Rmiddleline:
				li $t3,42
				Rmiddleloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Rmiddleloop
					addi $t0,$t0,1108
					addi $t0,$t0,772
					addi $t2,$t2,-1
					bnez $t2,Rmiddleline
					
					li $t2,23
					la $t0,frameBuffer+326688
			Rtiltline:
				li $t3,6
				Rtiltloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Rtiltloop
					addi $t0,$t0,1140
					addi $t0,$t0,888
					addi $t2,$t2,-1
					bnez $t2,Rtiltline
					
		helpdraw:
			li $t2,45
			la $t0,frameBuffer+283932
			helpleftline:
				li $t3,5
				helpleftloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,helpleftloop
					addi $t0,$t0,1108
					addi $t0,$t0,920
					addi $t2,$t2,-1
					bnez $t2,helpleftline
					
					li $t2,45
					la $t0,frameBuffer+284092
			helprightline:
				li $t3,5
				helprightloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,helprightloop
					addi $t0,$t0,1108
					addi $t0,$t0,920
					addi $t2,$t2,-1
					bnez $t2,helprightline
					
					li $t2,5
					la $t0,frameBuffer+324892
			helpmiddleline:
				li $t3,44
				helpmiddleloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,helpmiddleloop
					addi $t0,$t0,952
					addi $t0,$t0,920
					addi $t2,$t2,-1
					bnez $t2,helpmiddleline
					
		drawfour:
			li $t2,25
			la $t0,frameBuffer+153648
			fourleftline:
				li $t3,5
				fourleftloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,fourleftloop
					addi $t0,$t0,1848
					addi $t0,$t0,180
					addi $t2,$t2,-1
					bnez $t2,fourleftline
					
					li $t2,45
					la $t0,frameBuffer+153808
			fourrightline:
				li $t3,5
				fourrightloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,fourrightloop
					addi $t0,$t0,1848
					addi $t0,$t0,180
					addi $t2,$t2,-1
					bnez $t2,fourrightline
					
					li $t2,5
					la $t0,frameBuffer+200752
			fourmiddleline:
				li $t3,45
				fourmiddleloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,fourmiddleloop
					addi $t0,$t0,1736
					addi $t0,$t0,132
					addi $t2,$t2,-1
					bnez $t2,fourmiddleline
		drawfive:
			li $t2,5
			la $t0,frameBuffer+153900
			fivetopline:
				li $t3,45
				fivetoploop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,fivetoploop
					addi $t0,$t0,1736
					addi $t0,$t0,132
					addi $t2,$t2,-1
					bnez $t2,fivetopline
					
					li $t2,5
					la $t0,frameBuffer+194860
			fivemiddleline:
				li $t3,45
				fivemiddleloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,fivemiddleloop
					addi $t0,$t0,1736
					addi $t0,$t0,132
					addi $t2,$t2,-1
					bnez $t2,fivemiddleline
					
					li $t2,5
					la $t0,frameBuffer+235820
			fivebotline:
				li $t3,45
				fivebotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,fivebotloop
					addi $t0,$t0,1736
					addi $t0,$t0,132
					addi $t2,$t2,-1
					bnez $t2,fivebotline
					
					li $t2,23
					la $t0,frameBuffer+153900
			fiveleftline:
				li $t3,5
				fiveleftloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,fiveleftloop
					addi $t0,$t0,1732
					addi $t0,$t0,296
					addi $t2,$t2,-1
					bnez $t2,fiveleftline
					
					li $t2,23
					la $t0,frameBuffer+195020
			fiverightline:
				li $t3,5
				fiverightloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,fiverightloop
					addi $t0,$t0,1732
					addi $t0,$t0,296
					addi $t2,$t2,-1
					bnez $t2,fiverightline
		drawsix:
			li $t2,45
			la $t0,frameBuffer+154152
			sixleftline:
				li $t3,5
				sixleftloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,sixleftloop
					addi $t0,$t0,1732
					addi $t0,$t0,296
					addi $t2,$t2,-1
					bnez $t2,sixleftline
					
					li $t2,5
					la $t0,frameBuffer+154152
			sixtopline:
				li $t3,44
				sixtoploop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,sixtoploop
					addi $t0,$t0,1736
					addi $t0,$t0,136
					addi $t2,$t2,-1
					bnez $t2,sixtopline
					
					li $t2,5
					la $t0,frameBuffer+195112
			sixmiddleline:
				li $t3,44
				sixmiddleloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,sixmiddleloop
					addi $t0,$t0,1736
					addi $t0,$t0,136
					addi $t2,$t2,-1
					bnez $t2,sixmiddleline
					
					li $t2,5
					la $t0,frameBuffer+236072
			sixbotline:
				li $t3,44
				sixbotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,sixbotloop
					addi $t0,$t0,1736
					addi $t0,$t0,136
					addi $t2,$t2,-1
					bnez $t2,sixbotline
					
					li $t2,25
					la $t0,frameBuffer+195268
			sixrightline:
				li $t3,5
				sixrightloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,sixrightloop
					addi $t0,$t0,1320
					addi $t0,$t0,708
					addi $t2,$t2,-1
					bnez $t2,sixrightline
					
					li $t2,5
					la $t0,frameBuffer+195364
		drawminus:
			li $t3,45
			minusloop:
				sw $t1,0($t0)
				add $t0,$t0,4
				addi $t3,$t3,-1
				bnez $t3,minusloop
				addi $t0,$t0,1068
				addi $t0,$t0,800
				addi $t2,$t2,-1
				bnez $t2,drawminus
		drawL:
			li $t2,45
			la $t0,frameBuffer+154656
			lrightline:
				li $t3,5
				lrightloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,lrightloop
					addi $t0,$t0,976
					addi $t0,$t0,1052
					addi $t2,$t2,-1
					bnez $t2,lrightline
					
					li $t2,5
					la $t0,frameBuffer+236576
			lbotline:
				li $t3,45
				lbotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,lbotloop
					addi $t0,$t0,792
					addi $t0,$t0,1076
					addi $t2,$t2,-1
					bnez $t2,lbotline
		drawD2H:
			li $t2,59
			la $t0,frameBuffer+138608
			splitline:
				li $t3,1
				splitloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,splitloop
					addi $t0,$t0,648
					addi $t0,$t0,1396
					addi $t2,$t2,-1
					bnez $t2,splitline
					
					li $t2,44
					la $t0,frameBuffer+154968
			drightline:
				li $t3,5
				drightloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,drightloop
					addi $t0,$t0,640
					addi $t0,$t0,1388
					addi $t2,$t2,-1
					bnez $t2,drightline
					
					li $t2,21
					la $t0,frameBuffer+201996
					
			dleftline:
				li $t3,5
				dleftloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,dleftloop
					addi $t0,$t0,640
					addi $t0,$t0,1388
					addi $t2,$t2,-1
					bnez $t2,dleftline
					
					li $t2,5
					la $t0,frameBuffer+201996
			dtopline:
				li $t3,24
				dtoploop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,dtoploop
					addi $t0,$t0,640
					addi $t0,$t0,1312
					addi $t2,$t2,-1
					bnez $t2,dtopline
					
					li $t2,5
					la $t0,frameBuffer+236812
			dbotline:
				li $t3,24
				dbotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,dbotloop
					addi $t0,$t0,640
					addi $t0,$t0,1312
					addi $t2,$t2,-1
					bnez $t2,dbotline
					
					li $t2,45
					la $t0,frameBuffer+155000
			hleftline:
				li $t3,5
				hleftloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,hleftloop
					addi $t0,$t0,700
					addi $t0,$t0,1328
					addi $t2,$t2,-1
					bnez $t2,hleftline
					
					li $t2,21
					la $t0,frameBuffer+202188
			hrightline:
				li $t3,5
				hrightloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,hrightloop
					addi $t0,$t0,764
					addi $t0,$t0,1264
					addi $t2,$t2,-1
					bnez $t2,hrightline
					
					li $t2,5
					la $t0,frameBuffer+202112
			hmiddleline:
				li $t3,24
				hmiddleloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,hmiddleloop
					addi $t0,$t0,640
					addi $t0,$t0,1312
					addi $t2,$t2,-1
					bnez $t2,hmiddleline
		drawD2B:
			li $t2,59
			la $t0,frameBuffer+9584
			splitline1:
				li $t3,1
				splitloop1:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,splitloop1
					addi $t0,$t0,648
					addi $t0,$t0,1396
					addi $t2,$t2,-1
					bnez $t2,splitline1
					
					li $t2,44
					la $t0,frameBuffer+25944
			drightline1:
				li $t3,5
				drightloop1:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,drightloop1
					addi $t0,$t0,640
					addi $t0,$t0,1388
					addi $t2,$t2,-1
					bnez $t2,drightline1
					
					li $t2,21
					la $t0,frameBuffer+72972
					
			dleftline1:
				li $t3,5
				dleftloop1:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,dleftloop1
					addi $t0,$t0,640
					addi $t0,$t0,1388
					addi $t2,$t2,-1
					bnez $t2,dleftline1
					
					li $t2,5
					la $t0,frameBuffer+72972
			dtopline1:
				li $t3,24
				dtoploop1:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,dtoploop1
					addi $t0,$t0,640
					addi $t0,$t0,1312
					addi $t2,$t2,-1
					bnez $t2,dtopline1
					
					li $t2,5
					la $t0,frameBuffer+107788
			dbotline1:
				li $t3,24
				dbotloop1:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,dbotloop1
					addi $t0,$t0,640
					addi $t0,$t0,1312
					addi $t2,$t2,-1
					bnez $t2,dbotline1
					
							li $t2,45
					la $t0,frameBuffer+25976
			bleftline:
				li $t3,5
				bleftloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,bleftloop
					addi $t0,$t0,700
					addi $t0,$t0,1328
					addi $t2,$t2,-1
					bnez $t2,bleftline
					
					li $t2,21
					la $t0,frameBuffer+73164
			brightline:
				li $t3,5
				brightloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,brightloop
					addi $t0,$t0,764
					addi $t0,$t0,1264
					addi $t2,$t2,-1
					bnez $t2,brightline
					
					li $t2,5
					la $t0,frameBuffer+73088
			bmiddleline:
				li $t3,24
				bmiddleloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,bmiddleloop
					addi $t0,$t0,640
					addi $t0,$t0,1312
					addi $t2,$t2,-1
					bnez $t2,bmiddleline
					
					li $t2,5
					la $t0,frameBuffer+107904
			bbotline:
				li $t3,24
				bbotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,bbotloop
					addi $t0,$t0,640
					addi $t0,$t0,1312
					addi $t2,$t2,-1
					bnez $t2,bbotline
			
		drawseven:
			li $t2,5
			la $t0,frameBuffer+24624
			seventopline:
				li $t3,37
				seventoploop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,seventoploop
					addi $t0,$t0,640
					addi $t0,$t0,1260
					addi $t2,$t2,-1
					bnez $t2,seventopline
					
					li $t2,5
					la $t0,frameBuffer+67708
			sevenbotline:
				li $t3,26
				sevenbotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,sevenbotloop
					addi $t0,$t0,640
					addi $t0,$t0,1304
					addi $t2,$t2,-1
					bnez $t2,sevenbotline
					
					li $t2,45
					la $t0,frameBuffer+24752
			sevenvertline:
				li $t3,5
				sevenvertloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,sevenvertloop
					addi $t0,$t0,1856
					addi $t0,$t0,172
					addi $t2,$t2,-1
					bnez $t2,sevenvertline
		draweight:
			li $t2,5
			la $t0,frameBuffer+24876
			eighttopline:
				li $t3,45
				eighttoploop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,eighttoploop
					addi $t0,$t0,1736
					addi $t0,$t0,132
					addi $t2,$t2,-1
					bnez $t2,eighttopline
					
					li $t2,5
					la $t0,frameBuffer+67884
			eightmiddleline:
				li $t3,45
				eightmiddleloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,eightmiddleloop
					addi $t0,$t0,1736
					addi $t0,$t0,132
					addi $t2,$t2,-1
					bnez $t2,eightmiddleline
					
					li $t2,5
					la $t0,frameBuffer+106796
			eightbotline:
				li $t3,45
				eightbotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,eightbotloop
					addi $t0,$t0,1736
					addi $t0,$t0,132
					addi $t2,$t2,-1
					bnez $t2,eightbotline
					
					li $t2,45
					la $t0,frameBuffer+24876
			eightleftline:
				li $t3,5
				eightleftloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,eightleftloop
					addi $t0,$t0,1732
					addi $t0,$t0,296
					addi $t2,$t2,-1
					bnez $t2,eightleftline
					
					li $t2,45
					la $t0,frameBuffer+25036
			eightrightline:
				li $t3,5
				eightrightloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,eightrightloop
					addi $t0,$t0,1732
					addi $t0,$t0,296
					addi $t2,$t2,-1
					bnez $t2,eightrightline
		drawnine:
			li $t2,5
			la $t0,frameBuffer+25128
			ninetopline:
				li $t3,45
				ninetoploop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,ninetoploop
					addi $t0,$t0,1736
					addi $t0,$t0,132
					addi $t2,$t2,-1
					bnez $t2,ninetopline
					
					li $t2,5
					la $t0,frameBuffer+68136
			ninebotline:
				li $t3,45
				ninebotloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,ninebotloop
					addi $t0,$t0,1736
					addi $t0,$t0,132
					addi $t2,$t2,-1
					bnez $t2,ninebotline
					
					li $t2,25
					la $t0,frameBuffer+25128
			nineleftline:
				li $t3,5
				nineleftloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,nineleftloop
					addi $t0,$t0,1732
					addi $t0,$t0,296
					addi $t2,$t2,-1
					bnez $t2,nineleftline
					
					li $t2,45
					la $t0,frameBuffer+25288
			ninerightline:
				li $t3,5
				ninerightloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,ninerightloop
					addi $t0,$t0,1732
					addi $t0,$t0,296
					addi $t2,$t2,-1
					bnez $t2,ninerightline
		drawplus:
			li $t2,51
			la $t0,frameBuffer+19316
			plusvertline:
				li $t3,5
				plusvertloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,plusvertloop
					addi $t0,$t0,1732
					addi $t0,$t0,296
					addi $t2,$t2,-1
					bnez $t2,plusvertline
					
					li $t2,5
					la $t0,frameBuffer+66328
			plushorline:
				li $t3,51
				plushorloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,plushorloop
					addi $t0,$t0,1724
					addi $t0,$t0,120
					addi $t2,$t2,-1
					bnez $t2,plushorline
		drawT:
			li $t2,5
			la $t0,frameBuffer+25632
			Tvertline:
				li $t3,45
				Tvertloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Tvertloop
					addi $t0,$t0,1740
					addi $t0,$t0,128
					addi $t2,$t2,-1
					bnez $t2,Tvertline
					
					li $t2,45
					la $t0,frameBuffer+25712
			Thorline:
				li $t3,5
				Thorloop:
					sw $t1,0($t0)
					add $t0,$t0,4
					addi $t3,$t3,-1
					bnez $t3,Thorloop
					addi $t0,$t0,1732
					addi $t0,$t0,296
					addi $t2,$t2,-1
					bnez $t2,Thorline
		jr $ra
	
	
	
	
	#close program
	endprogram:
	li $v0,4
	la $a0,closeprogram
	syscall
	li $v0,10
	syscall
