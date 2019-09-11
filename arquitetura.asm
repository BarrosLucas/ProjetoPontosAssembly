;UFPB 	- UNIVERSIDADE FEDERAL DA PARAÍBA
;CI 	- CENTRO DE INFORMÁTICA
;P4		- ARQUITETURA DE COMPUTADORES
;ALUNOS:
;		- LUCAS FREITAS DE BARROS	(MAT.: 20170014418)
;		- JULIO LEITE TAVARES NETO	(MAT.: 20170064975)


.486
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc
includelib  \masm32\lib\msvcrt.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
    ;Counter write and read
	count_console		dw 0
	
	;Variable to inputs
	inputs 				dd 100 dup(0)
	
	
    ;Variaveis para mostrar texto na tela
    output 				db "Deseja recalcular os pontos?", 0ah, "--------(s)Sim\(n)Nao--------", 0ah, "Digite: ", 0h ; String seguida de nova linha e fim_de_string
    outputMss1 			db "Qnt. total de furos: ",0h
    mssX1 				db "Digite a coordenada do primeiro ponto: ", 0ah, "x: ", 0h
    mssY1 				db "y: ", 0h
    mssX2 				db "Digite a coordenada do ultimo ponto: ", 0ah, "x: ", 0h
    mssY2 				db "y: ", 0h
	mssShowCoordinatos	db "Coordenadas: ", 0ah," ( x, y)",0ah,0h
	openParentheses		db "(",0h
	closerParentheses	db ")",0ah,0h
	comma				db ",",0h
    
	
	;Byte
	ErrorCreateMsgFormat	byte ?
	
    ;Variaveis para reiniciar o sistema
    entrada 			db 100 dup(0)
    contadorEntrada 	dw 0

    ;Variavel da quantidade
    qnt 				dword 0
	qntAux				dword 0
	ErrorCode			dword 0

    ;Variaveis de ponto flutuante
    inicialX 			REAL8 0.0
    finalX 				REAL8 0.0
    inicialY 			REAL8 0.0
    finalY 				REAL8 0.0
	mediaX				REAL8 0.0
	mediaY				REAL8 0.0
	qntDeFuros			REAL8 0.0
	unidade				REAL8 1.0

    ;Variaveis auxiliares
    x1 					db 100 dup(0)
    x2 					db 100 dup(0)
    y1 					db 100 dup(0)
    y2 					db 100 dup(0)

    ;Variavel de total de pontos a serem mostrados
    totalPontos 		db 100 dup(0)
	entradaX			db 100 dup(0)
	entradaY			db 100 dup(0)
    contPontosPalavra 	dw 0
	contEscrever		dw 0
    totalPontosInt 		dw 0 
	tam 				dw 1

.code
	start:
		inicioForTotal:

			finit
		
			;printf("Qnt. total de furos: ");
			push STD_OUTPUT_HANDLE
			call GetStdHandle
			invoke WriteConsole, eax, addr outputMss1, sizeof outputMss1, addr count_console, NULL

			;scanf("%s",&totalPontos);
			push STD_INPUT_HANDLE
			call GetStdHandle
			invoke ReadConsole, eax, addr totalPontos, sizeof totalPontos, addr count_console, NULL
			invoke StrToFloat, addr totalPontos, addr qntDeFuros
			
			;printf("  Digite a coordenada do primeiro ponto: \nx: ");
			push STD_OUTPUT_HANDLE
			call GetStdHandle
			invoke WriteConsole, eax, addr mssX1, sizeof mssX1, addr count_console, NULL
			
			;scanf("%s",&inicialX);
			push STD_INPUT_HANDLE
			call GetStdHandle
			invoke ReadConsole, eax, addr entradaX, sizeof entradaX, addr count_console, NULL
			invoke StrToFloat, addr entradaX, addr inicialX
			
			;printf("y: ");
			push STD_OUTPUT_HANDLE
			call GetStdHandle
			invoke WriteConsole, eax, addr mssY1, sizeof mssY1, addr count_console, NULL
			
			;scanf("%s",&inicialY);
			push STD_INPUT_HANDLE
			call GetStdHandle
			invoke ReadConsole, eax, addr entradaY, sizeof entradaY, addr count_console, NULL
			invoke StrToFloat, addr entradaY, addr inicialY
			
			;printf("Digite a coordenada do ultimo ponto:\nx: ");
			push STD_OUTPUT_HANDLE
			call GetStdHandle
			invoke WriteConsole, eax, addr mssX2, sizeof mssX2, addr count_console, NULL
			
			;scanf("%s",&finalX);
			push STD_INPUT_HANDLE
			call GetStdHandle
			invoke ReadConsole, eax, addr entradaX, sizeof entradaX, addr count_console, NULL
			invoke StrToFloat, addr entradaX, addr finalX
			
			;printf("Y: ");
			push STD_OUTPUT_HANDLE
			call GetStdHandle
			invoke WriteConsole, eax, addr mssY2, sizeof mssY2, addr count_console, NULL
			
			;scanf("%s",&finalY);
			push STD_INPUT_HANDLE
			call GetStdHandle
			invoke ReadConsole, eax, addr entradaY, sizeof entradaY, addr count_console, NULL
			invoke StrToFloat, addr entradaY, addr finalY
			
			;qntDeFuros = qntDeFuros - 1;
			fld unidade
			fld qntDeFuros
			fsub st, st(1)
			fst qntDeFuros
			
			;mediaX = (finalX - inicialX)/qntDeFuros
			finit
			fld inicialX
			fld finalX
			fsub st, st(1)
			fdiv qntDeFuros
			fst mediaX

			;mediaY = (finalY - inicialY)/qntDeFuros
			finit
			fld inicialY
			fld finalY
			fsub st, st(1)
			fdiv qntDeFuros
			fst mediaY
			
			;float to str
			invoke FloatToStr, qntDeFuros, addr inputs
			mov esi, offset inputs    
			next:
				mov al, [esi]
				inc esi
				cmp al, 48
				jl finish
				cmp al, 58
				jl next
			finish:
				dec esi
				xor al, al
				mov [esi], al
			invoke atodw, addr inputs
			mov qntAux, eax
			
			;printf("Coordenadas: \n");
			push STD_OUTPUT_HANDLE
			call GetStdHandle
			invoke WriteConsole, eax, addr mssShowCoordinatos, sizeof mssShowCoordinatos, addr count_console, NULL
			
			;printf("(");
			push STD_OUTPUT_HANDLE
			call GetStdHandle
			invoke WriteConsole, eax, addr openParentheses, sizeof openParentheses, addr count_console, NULL
			
			;float to str
			invoke FloatToStr, inicialX, addr inputs
			invoke StrLen, addr inputs
			mov qnt, eax
			
			;printf("%s",inicialX);
			push STD_OUTPUT_HANDLE
			call GetStdHandle
			invoke WriteConsole, eax, addr inputs, qnt, addr count_console, NULL
			
			;printf(",");
			push STD_OUTPUT_HANDLE
			call GetStdHandle
			invoke WriteConsole, eax, addr comma, sizeof comma, addr count_console, NULL
			
			;float to str
			invoke FloatToStr, inicialY, addr inputs
			invoke StrLen, addr inputs
			mov qnt, EAX
			
			;printf("%s",inicialY);
			push STD_OUTPUT_HANDLE
			call GetStdHandle
			invoke WriteConsole, eax, addr inputs, qnt, addr count_console, NULL
			
			;printf(")");
			push STD_OUTPUT_HANDLE
			call GetStdHandle
			invoke WriteConsole, eax, addr closerParentheses, sizeof closerParentheses, addr count_console, NULL	

			
			;se qntAux
			cmp qntAux, 1
			JE UltimoFuro
			mov ebx, qntAux
			
			;do{
			Enquanto:
				;printf("(");
				push STD_OUTPUT_HANDLE
				call GetStdHandle
				invoke WriteConsole, eax, addr openParentheses, sizeof openParentheses, addr count_console, NULL
			
				;inicialX += mediaX;
				finit
				fld inicialX
				fld mediaX
				faddp st(1),st
				fst inicialX
				
				;float to string
				invoke FloatToStr, inicialX, addr inputs
				invoke StrLen, addr inputs
				mov qnt, eax
				
				;printf("%d",inicialX);
				push STD_OUTPUT_HANDLE
				call GetStdHandle
				invoke WriteConsole, eax, addr inputs, qnt, addr count_console, NULL
				
				;printf(",");
				push STD_OUTPUT_HANDLE
				call GetStdHandle
				invoke WriteConsole, eax, addr comma, sizeof comma, addr count_console, NULL

				;inicalY += mediaY;
				finit 
				fld inicialY
				fld mediaY
				faddp st(1), st
				fst inicialY
				
				;float to string
				invoke FloatToStr, inicialY, addr inputs
				invoke StrLen, addr inputs
				mov qnt, eax
				
				;printf("%d",inicalY);
				push STD_OUTPUT_HANDLE
				call GetStdHandle
				invoke WriteConsole, eax, addr inputs, qnt, addr count_console, NULL
				
				;printf(")");
				push STD_OUTPUT_HANDLE
				call GetStdHandle
				invoke WriteConsole, eax, addr closerParentheses, sizeof closerParentheses, addr count_console, NULL	
				
				;} while(ebx > 1);
				dec ebx
				cmp ebx, 1
				JG Enquanto
			
			;printf("(%d, %d)",finalX, finalY);
			UltimoFuro:
				;printf("(");
				push STD_OUTPUT_HANDLE
				call GetStdHandle
				invoke WriteConsole, eax, addr openParentheses, sizeof openParentheses, addr count_console, NULL
				
				;float to str
				invoke FloatToStr, finalX, addr inputs
				invoke StrLen, addr inputs
				mov qnt, eax
				
				;printf("%s",finalX);
				push STD_OUTPUT_HANDLE
				call GetStdHandle
				invoke WriteConsole, eax, addr inputs, qnt, addr count_console, NULL
				
				;printf(",");
				push STD_OUTPUT_HANDLE
				call GetStdHandle
				invoke WriteConsole, eax, addr comma, sizeof comma, addr count_console, NULL
				
				;float to str
				invoke FloatToStr, finalY, addr inputs
				invoke StrLen, addr inputs
				mov qnt, EAX
				
				;printf("%s",finalY);
				push STD_OUTPUT_HANDLE
				call GetStdHandle
				invoke WriteConsole, eax, addr inputs, qnt, addr count_console, NULL
				
				;printf(")");
				push STD_OUTPUT_HANDLE
				call GetStdHandle
				invoke WriteConsole, eax, addr closerParentheses, sizeof closerParentheses, addr count_console, NULL	
				
				;printf("Deseja recalcular os pontos?\n--------(s)Sim\(n)Nao--------\nDigite: ");
				push STD_OUTPUT_HANDLE
				call GetStdHandle
				invoke WriteConsole, eax, addr output, sizeof output, addr count_console, NULL
				
				;scanf("%c",entrada);
				push STD_INPUT_HANDLE
				call GetStdHandle
				invoke ReadConsole, eax, addr entrada, sizeof entrada, addr contadorEntrada, NULL

				;(entrada == 's')? inicioForTotal : 0;
				cmp entrada, 's'
				je inicioForTotal
		
		invoke ExitProcess, 0

	end start