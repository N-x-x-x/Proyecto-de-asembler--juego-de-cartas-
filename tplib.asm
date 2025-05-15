.8086
.model small
.stack 100h
.data 
	
 	dataMul db 100,10,1
 	caracterFIN db "0"
   ;texto db 255 dup (24h),0dh,0ah
   ;texto2 db "aabaa",0dh,0ah,24h
   ;caracter db "a"
   ;numero db "000",0dh,0ah,24h
   ;espacio db "",0dh,0ah,24h

.code
;***Publicaciones***
 	public caja_carga_palabras
 	public caja_carga_numeros
 	public printer
 	public assci2reg
 	public reg2assci
 	public imprimirXstack
 	public reemplzador_de_caracteres
 	public buscador_mas_contador
 	public caja_carga_palabras_caracter_fijo
 	public buscador_posicion_cadena
    ; main proc
    ; mov ax,@data
    ; mov ds,ax
	    
		; mov bx, offset texto
		; call caja_carga_palabras
		; lea dx, texto
		; call printer
		; lea dx, espacio
		; call printer

		; lea bx, numero
		; call caja_carga_numeros
		; lea dx, numero
		; call printer
		; lea dx, espacio
		; call printer
		; lea bx, numero
		; mov cx,0
		; call assci2reg

		; lea bx, numero
		; mov dx,0
		; mov cx,0
		; mov cl,32
		; mov dx,cx
		; call reg2assci

		; lea dx, numero
		; call printer
		; lea dx, espacio
		; call printer

		; lea bx, texto2
		; mov dx,0
		; mov cx,0
		; mov dl,"z"
		; mov al,"a"
		; call reemplzador_de_caracteres
		
		; lea bx, texto2
		; push bx
		; call imprimirXstack
		; lea dx, espacio
		; call printer

		; lea bx,texto2
		; mov dl,caracter
		; call buscador_mas_contador
    ; mov ax,4c00h
    ; int 21h
    ; main endp
;funciones
 ;Que funciones tengo de momento? 
 ; (a)	una funcion que solo puede guardar texto en una variable (no guarda algo que no sea letras y vocales), 
 ;		sin usar el stack y cuidadando la profilaxis (osea usando los reg en limpio) ARREGLAR 
 ; (b)	una funcion que solo puede guardar numeros en una variable (no guarda algo que no sea numeros)
 ; (c)	una funcion que solo printea
 ; (d)	un asci2reg (caracteres a numero)
 ; (e)	un reg2asci (numero a caracteres)
 ; (f)	una funcion que solo printea pero por stack
 ; (g)	un remplazador de caracteres, solo remplaza de a un caracter
 ; (h)	un buscador mas sumador de caracteres especificos hay en una cadena 
 ; (i)	una funcion que guarda texto pidiendo un caracter para finalizar 
 		buscador_posicion_cadena proc ; 
 			;necesita
	 			;la dir del texto debe estar en bx
	 			;en dl el caracter que se le va a buscar la posicion
	 		;devuelve
	 		;la posisicion se devuelve en al
 		push bx
 		;push ax
 		push dx
	 		mov ax,0
	 		mov dh,0
	 		ciclo_debusqueda:
	 		; cmp bx,255
	 		; je finall

	 		cmp [bx],24h
	 		je finall

	 		cmp [bx],dl
	 		je finall

	 		inc bx
	 		inc al
	 		jmp ciclo_debusqueda
	 		finall:
	 		;mov al,bl
	 	pop dx
	 	;pop ax
	 	pop bx
 		ret 
	    buscador_posicion_cadena endp

	    caja_carga_palabras proc ;(a)
	    	push bx
	    	push ax
	    	;Pasa la dir de la variable  en bx del tipo "xxx db 255 dup (24h),0dh,0ah"
	    	;Lee hasta 255 caracteres y solo letras no numeros 
	    	dec bx 
		    caja_carga:
		    	inc bx
		    no_metio_letra:
		    	mov ah,1;8;valor modificable para sin eco 
		    	int 21h
		    	cmp bx,255
		    	je termino_carga
		    	cmp al,0dh
		    	je termino_carga
		    	;////////////////Modulo de deteccion de errores;////////////////////////
		    	cmp al, 'a'
		        jb no_metio_letra
		        cmp al, 'z'
		        ja es_letra
		        cmp al, 'A'
		        jb no_metio_letra
		        cmp al, 'Z'
		        ja es_letra
		        jmp no_metio_letra
		    	;//////////////////////////////////////////////////////////////////////
		    es_letra:
		    	mov [bx],al
		    	jmp caja_carga
		    termino_carga:
		    pop ax
		    pop bx
		    ret 
	    caja_carga_palabras endp

	    	
	    caja_carga_numeros proc ;(b)
	    ;Pasa la dir de la variable en bx del tipo "xxx db "000",0dh,0ah,24h"
	    ;puede trabjar hasta el valor 255 
	    ; ** no tiene acomodador (aun)
	   		push bx
	    	push ax
	    	dec bx
	    	caja_carga_numerica:
		    	inc bx
		    	mov ah,1;8;valor modificable para sin eco 
		    	int 21h
		    	cmp al,0dh
		    	je termino_carga_numerica
		    	mov [bx],al
		    	jmp caja_carga_numerica
		    termino_carga_numerica:
	    	pop ax
		    pop bx
	    	ret 
	    caja_carga_numeros endp

	    printer proc ;(c)
	    ;Pasa la dir de la variable en dx a printear
	    push ax
		push dx
			mov ah,09h
			;se supone que en dx ya esta el offset
			int 21h
		pop dx
		pop ax
	    ret 
	    printer endp

	    assci2reg proc ;(d)
	    push ax
	    push bx
	    push si 
	    push dx
	    ;necesita
	    	;La dir de la variable en bx del tipo "xxx db "000",0dh,0ah,24h"
	    	;mov cx,0 con anterioridad
	    ;usa
	    	;la dataMul db 100,10,1
	    ;DEVUELVE 
	    	;En cl el resultado
	   	;trabaja con numeros de hasta 255 
	   		mov si,0 
	   	proceso:
	   		mov ah,0
	   		mov al,[bx]
	   		sub al,30h
	   		mov dl, dataMul[si]
	   		mul dl
	   		add cl,al
	   		inc bx
	   		inc si
	   		cmp si,3
	   		je fin_proceso
	   		jmp proceso
	   	fin_proceso:
	   	pop dx
	   	pop si
	   	pop bx
	   	pop ax
	    ret 
	    assci2reg endp

	    reg2assci proc ;(e)
	    ;necesita
	    	;la dir donde se guarda tipo "xxx db "000",0dh,0ah,24h" en bx 
	    	;un valor numerico a convertir "zzz db 32" que DEBE SER PASADO por dl con anterioridad
  		;devuelve 
  			;en el registro xxx el numero imprimible 
  		;trabaja con numeros de hasta 255
	        push bx
	        push ax
	        push dx
	        push cx
	        mov ax,0;limpio
	        mov al,dl
	        add bx,2
	        mov cx,3
	        mov dl,10
	    convierto:
	        mov ah,0;limpio
	        div dl
	        add [bx],ah 
	        dec bx 
	    loop convierto
	        pop cx
	        pop dx
	        pop ax
	        pop bx
	        ret 
        reg2assci endp

        imprimirXstack proc ;(f)
        		; solo imprime por stack
            	;ej ;mov bx, offset varx
                ;push bx
                ;call imprimir
            push bp
            mov bp, sp
            push dx
            push ax
            mov dx, ss:[bp+4]

            mov ah,9
            int 21h

            pop ax
            pop dx
            pop bp
            ret 2; por el push bx 
        imprimirXstack endp
		
		reemplzador_de_caracteres proc ;(g)
		;necesita
            ;bx -->La dir de una variable tipo xxx db "texto",0dh,0ah,24h
            ;dl -->Caracter nuevo que quiero poner 
            ;al -->Caracter que quiero remplazar 
        ;devuelve
            ;cl -->cantidad de veces que se hizo un cambio hasta terminar
            ;en bx el texto estara cambiado
            push bx
            push dx
            push ax

            mov cx, 0 
            mov dh, 0
            mov ah, 0
        comienza:
            cmp [bx], 24h 
            je final_busqueda_coso
            cmp [bx], al  
            je remplazo
            inc bx;inc indice
            jmp comienza
        remplazo:
            mov [bx], dl; hago el cambio  
            inc bx;inc indice
            inc cl; aumento contador 
            jmp comienza
        final_busqueda_coso:
            pop ax
            pop dx
            pop bx
         ret
        reemplzador_de_caracteres endp

        buscador_mas_contador proc; (h)
        ;necesita
            ;bx -->la dir de una variable texto
            ;dl -->el caracter que busco en el texto tipo " caracter db "a" "
        ;devuelve
            ;cl -->Cantidad de veces que se encontro un caracter especifico hasta encontrar $
            ;si -->Cantidad de caracteres de la cadena hasta encontrar $
        ;ADVERTENCIA si la cadena es tipo texto2 db " "aabaa",0dh,0ah,24h " (tengo que restar 2) y si es tipo
        			;"texto db 255 dup (24h),0dh,0ah" creo que no
            push bx
            ;push si
            push dx
            mov cx, 0 
            ;mov ah, 0
            mov dh,0
        sigo:
            ;cmp byte ptr[bx], 24h 
            cmp bx,255
            je final_busqueda 
            cmp byte ptr[bx],dl
            je cuento
            inc bx
            inc si 
            jmp sigo
        cuento:
            inc bx
            inc si 
            inc cl
            jmp sigo
        final_busqueda:
        	pop dx
            ;pop si
            pop bx
        ret
        buscador_mas_contador endp
        ; con si hay un PROLBEMA
        caja_carga_palabras_caracter_fijo proc ;(i)
	    	push bx
	    	push ax
	    	push dx
	    	;Pasa la dir de la variable  en bx del tipo "xxx db 255 dup (24h),0dh,0ah"
	    	;Pasa la dir del caracter de finalizacion en dl del tipo " "xxx db "carecter" "
	    	;Lee hasta 255 caracteres y solo letras no numeros 
	    	; busco_tomar_caracter:
		    ; 	mov ah,1
		    ; 	int 21h
		    ; 	cmp al,0dh
		    ; 	je ya_toma_caracter
		    ; 	mov caracterFIN,al
		    ; 	jmp busco_tomar_caracter
	    	; ya_toma_caracter:
	    	mov caracterFIN,dl
	    	dec bx 
		    caja_carga2:
		    	inc bx
		    	mov ah,1;8;valor modificable para sin eco 
		    	int 21h
		    	cmp bx,255
		    	je termino_carga2
		    	cmp al,caracterFIN;0dh
		    	je termino_carga2
		    	mov [bx],al
		    	jmp caja_carga2
		    termino_carga2:
		    pop dx
		    pop ax
		    pop bx
		    ret 
	    caja_carga_palabras_caracter_fijo endp

 end

