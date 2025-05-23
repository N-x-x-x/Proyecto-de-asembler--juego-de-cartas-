;CODIGO DE BAJO PRESUPUESTO 

.8086
.model small
.stack 100h
.data  
    ;varibles y demas cosas reseteables 
    estadoMenuInicio db 0
    nrm                      db "000",0dh,0ah,24h
    nrm_jugador              db "000",0dh,0ah,24h
    ayuda_visual_jugador     db "000",24h  
    vj                       db 3
    vm                       db 3    
    estadoMenu               db 2 ;Guarda el estado para saber en que posición esta ;0 estado1-pedir
                                                                                    ;1 estado2-pasar
                                                                                    ;2 estado normal
    flag_NO_CARTA   db 0
    cartaRondaJugador   db 0
    cartaDeLaRonda      db 0;maquina
        ;Flags para ir al final de la ronda
    flag_usuario_pasar db 0
    flag_maquina_pasar db 0  

        ;variables de la maquina a la hora de tomar deciciones
    tomardorDeciciones  db "000"
    mazoCartasMaquina   db 0;valor total de las cartas de la maquina
    acumulado_jugador   db 0;valor total de las cartas del jugador
    

    ;Mensajes
    espacio db "",0AH,0DH,24h
    creditos        DB "======================== PROGRAMADO POR ========================", 0dh, 0ah
                    DB "================                                ================", 0dh, 0ah 
                    DB "================        NEYLER NARVAEZ          ================", 0dh, 0ah 
                    DB "================                                ================", 0dh, 0ah 
                    DB "================        TADEO FERNANDEZ         ================", 0dh, 0ah 
                    DB "================                                ================" , 0dh, 0ah 
                    DB "================        MICAELA RODRIGUEZ       ================", 0dh, 0ah
                    DB "================                                ================", 0dh, 0ah
                    DB "================================================================", 0dh, 0ah,24h
    msj_cartas  db "El mazo de cartas durante la ronda fue:",24h

    msj_numero  db "El valor numerico acumulado del mazo fue:",24h

    ya_no_tengo_mas_nombres db "-----------------------------------------Explicación del juego-----------------------------------------",0dh,0ah;eliminar ortografia
                            db "El juego se llama ""treinta y uno"", es un juego de cartas donde se reparte una carta aleatoria a cada jugador",0dh,0ah
                            db "El principio del juego es que cada persona inicie con una carta y por turnos vayan sumando valores que se sacan ",0dh,0ah
                            db "de la baraja, el primero en llegar a 31 o a un valor muy cerca del dicho número gana, los jugadores pueden elegir cuantas",0dh,0ah
                            db "cartas agarran y cuando quieren dejar de agarrar, el juego termina cuando ambos deciden no agarrar más cartas, (pasan los 2)",0dh,0ah
                            db "y se muestra el valor numérico de ambas manos. ",0dh,0ah                          
                            db "Si los 2 jugadores se pasan del número queda en un EMPATE, si los 2 jugadores llegan a 31, o el resultado de sus manos es ",0dh,0ah
                            db "el mismo queda en EMPATE. El ganador final del juego es el que gane 3 veces al ""treinta y uno"". ",0dh,0ah
                            db "En caso de EMPATE ambos pierden y nadie suma victorias.",0dh,0ah
                            db "Repeticion del valor de las cartas en el mazo estandar",0dh,0ah
                            db "4 Ases   (A=1) | 4 Doses  (2)   | 4 Treses (3)   ",0dh,0ah
                            db "4 Cuatros(4)   | 4 Cincos (5)   | 4 Seises (6)   ",0dh,0ah
                            db "4 Sietes (7)   | 4 Ochos  (8)   | 4 Nueves (9)   ",0dh,0ah
                            db "4 Jotas  (J);10| 4 Reinas (Q);11| 4 Reyes  (K);12",0dh,0ah,24h

    menu                     db "           ----BIENVENIDO A TREINTA Y UNO 31----",0dh,0ah
                             db "   JUGAR VS MAQUINA",0dh,0ah
                             db "   REGLAS DEL JUEGO",0dh,0ah,24h

    jugadorVSmaquina_msj     db "           ----BIENVENIDO A TREINTA Y UNO 31----",0dh,0ah
                             db "   ->JUGAR VS MAQUINA",0dh,0ah
                             db "   REGLAS DEL JUEGO",0dh,0ah,24h

    jugadorVSjugador_msj     db "           ----BIENVENIDO A TREINTA Y UNO 31----",0dh,0ah
                             db "   JUGAR VS MAQUINA",0dh,0ah
                             db "   REGLAS DEL JUEGO",0dh,0ah,24h

    reglas_msj               db "           ----BIENVENIDO A TREINTA Y UNO 31----",0dh,0ah
                             db "   JUGAR VS MAQUINA",0dh,0ah
                             db "    ->REGLAS DEL JUEGO",0dh,0ah,24h                      

    msj_termino_todo_maquina db "/////////////////////EL GANADOR FUE EL JUGADOR////////////////////",0dh,0ah,24h

    msj_termino_todo_jugador db "/////////////////////EL GANADOR FUE LA MAQUINA////////////////////",0dh,0ah,24h

    msj_pausador             db "--------------Precione cualquier tecla para continuar--------------",0dh,0ah,24h

    msj_gano_jugador         db "El ganador de la ronda fue el Jugador",0dh,0ah,24h

    msj_gano_maquina         db "El ganador de la ronda fue la Maquina",0dh,0ah,24h

    msj_empate               db "Ocurrio un EMPATE, se pasara a otra ronda a desempatar",0dh,0ah,24h

    jugadortext              db "       <<<--Jugador-->>>",0dh,0ah,24h

    maquinatext              db "       <<<--Maquina-->>>",0dh,0ah,24h

    separador                db "          ----/////////////////////////////////////////////////----               ",0dh,0ah,24h

    vidas       db     "  ***                               ***",0dh,0ah,24h;vidas del jugador pos 3-5
                                                                            ;vidas del jugador pos 30-39

    opciones1       db "->Pedir                             Pasar",0dh,0ah,24h
    opciones2       db "  Pedir                             ->Pasar",0dh,0ah,24h
    opcion_normal   db "  Pedir                             Pasar",0dh,0ah,24h

    cartasJugador   db"xxxxxxxxxxxxxxxxxx",0dh,0ah,24h
    cartasMaquina   db"xxxxxxxxxxxxxxxxxx",0dh,0ah,24h

        ;variables del corrector de mazo
                                   ;"0 1 2 3 4 5 6 7 8 9 10 11"
                                   ;"a 2 3 4 5 6 7 8 9 j q  k "
    array_de_cartas             db "a23456789jkq";11 cartas
    array_cantidad_de_cartas    db "444444444444";existencias de las posibles cartas en mazo   

    ;variables que necesita el rand
    random_secuencia    dw 4
    ran_anterior        dw 3
    semilla             db 1
.code
    extrn caja_carga_palabras:proc
    extrn caja_carga_numeros:proc
    extrn printer:proc
    extrn assci2reg:proc
    extrn reg2assci:proc
    extrn imprimirXstack:proc 
    extrn reemplzador_de_caracteres:proc
    extrn buscador_mas_contador:proc
    extrn caja_carga_palabras_caracter_fijo:proc
    extrn buscador_posicion_cadena:proc

main proc
    mov ax, @data
    mov ds, ax

        mov ax,0
    fikifiki:
        call inicio_juego_menu;al--Devuelve en al un numero segun lo pedido 
        
        call HANDLE_INPUT
        cmp bp,1ch;la tecla enter seria el boton de aceptar 
        je es_casi_accion2
        jmp fua;(se me acaban los nombres)

        es_casi_accion2:
        ;comprueba el estado
        cmp estadoMenuInicio,1
        je es_jugadorVSmaquina

        cmp estadoMenuInicio,3
        je es_reglassss
        jmp fua
        es_reglassss:
            lea bx,ya_no_tengo_mas_nombres
            push bx
            call imprimirXstack
            call pausador_con_aviso
        fua:
        jmp fikifiki

    es_jugadorVSmaquina:;ciclo de juego normal
ciclo_de_juego:

    cmp vj,0
    je puente_perdio_jugador;perdio_jugador_fin_game
    cmp vm,0
    je puente_perdio_maquina;perdio_maquina_fin_game

                            ;SIRVE PARA CORREGIR UN SALTO INCONDICIONAL
                                         jmp afuera_puente2
                                        puente_perdio_jugador:
                                            jmp perdio_jugador_fin_game
                                        afuera_puente2:
                                        jmp afuera_puente3

                                        jmp afuera_puente3
                                        puente_perdio_maquina:
                                            jmp perdio_maquina_fin_game
                                        afuera_puente3:

    ;Acomoda el estado del flag de salida para que no se vaya a un resultado desconocido 
    cmp flag_usuario_pasar,0
    jb acomodo
    cmp flag_usuario_pasar,3
    jae acomodo23
    jmp nohagonadapng

    acomodo:
        mov flag_usuario_pasar,0
        jmp nohagonadapng
    acomodo23:
        mov flag_usuario_pasar,0;1
        jmp nohagonadapng
    nohagonadapng:

        ;muestro lo visual dentro del juego (vidas y interfaz)
        call limpiar_pantalla
        call interfaz   
    
        ;me fijo en que toca el usuario
        call HANDLE_INPUT
        ;si toca enter cuando la flecha esta en pedir o pasar, hace algo
        cmp bp,1ch;la tecla enter seria el boton de aceptar 
        je es_casi_accion
        jmp afuera_puente1 

    ;fraccion de codigo para arreglar un salto INCONDICIONAL
    puente1:
        jmp fin_ronda
    afuera_puente1:
        jmp no_accion

    ;El codigo se fija si lo que se quiere hacer es pedir o pasar 
    es_casi_accion:
        ;comprueba el estado
        cmp estadoMenu,0
        je es_pedir
        cmp estadoMenu,1
        je es_pasar
        jmp no_accion
        
        es_pedir:;usuario
            mov estadoMenu,2

            dec flag_usuario_pasar
            
            cartificador_jugador:
                mov flag_NO_CARTA, 0
                call rand
                call verificardor_mazo
                cmp flag_NO_CARTA, 1
                je cartificador_jugador
        
            tomar_carta_jugador:
                ;movemos el valor de la carta al acumulado y a la carta actual de la ronda (tambien en la funcion para limpiar 
                ;agregamos un mov 0)
                add acumulado_jugador, al
                mov cartaRondaJugador, al
                ;buscamos la posicion en la cual poner la carta
                lea bx, cartasJugador
                mov dl, "x"
                call buscador_posicion_cadena
                ;correjimos su valor para poder insertarla
                xor bx, bx
                mov bl, al
                mov ah, cartaRondaJugador
                call corrector_valor_mazo 
                ;la incertamos
                mov cartasJugador[bx], ah
    
                ;terminamos de pedirla
                jmp es_pasar
            
        es_pasar:;usuario
            mov estadoMenu,2
           
           inc flag_usuario_pasar
            ;esto se fija cuando termina el juego.
                ;la condicion del usuario de pasar es variable, pero la condicion de la maquina solo sera la de pasar cuando tenga
                ;chances de perder, de este modo cuando los 2 pasen (definitivamente) el juego terminara
            ;si los 2 son igual a 1, el jeugo acaba
            cmp flag_usuario_pasar,2; es uno solo cuando el jugador pasa
            je casi_fin_game
            jmp sigo_jugando

            ;si el usuario pasa varias veces y la maquina siente que puede perder termina 
            casi_fin_game:
                cmp flag_maquina_pasar,1; es uno solo cuando existe la posibilidad de perder
                je puente1; imprime resultados finales
                jmp sigo_jugando
            sigo_jugando:


            ;si el acumulado de las cartas llega a un valor especifico que haga un proceso random para 
            ;verificar si la maquina se arriesga a tomar otra carta o pasa el turno
            cmp mazoCartasMaquina,25;valor de riesgo
            jae se_prepara_pensar
            
            ;la maquina sabe que ya se paso o gano
            cmp mazoCartasMaquina,32;31;si se paso de 31 que pase
            jae pasa_maquina
            cmp mazoCartasMaquina,31;la maquina sabe que ya gano
            je pasa_maquina

            ;si no tengo un cierto acumulado cerca de 31 tomo carta 
            jmp toma_carta_maquina
            
            ;ciclo de lectura de la toma de decicion de la maquina
            se_prepara_pensar:
                mov flag_maquina_pasar,1

            ;toma numeros randoms para luego compararlos y decidir
                mov cx,3
                mov bx,0
                genero:
                    call rand;en al el resultado random
                    mov tomardorDeciciones[bx],al;lleno la variables de 3 valores aleatorios
                    inc bx
                loop genero

            ;inicia proceso de decicion aleatoria
                mov bx,0
                mov cx,0
                dec bx
            pensando_maquina_accion:
                inc bx
                cmp bx,2;lo hace 3 veces
                jae termino_pensando_maquina_accion

                cmp tomardorDeciciones[bx],6;si uno de los numeros generados son mayores a 6 da un visto bueno
                jae acumulo_decicion_uno

                jmp pensando_maquina_accion
            acumulo_decicion_uno:
                inc cl;flag de decicion final
                jmp pensando_maquina_accion
            termino_pensando_maquina_accion:

            ;Si cl tiene 3 vistos buenos saco del mazo una carta para la mano de la maquina
            cmp cl,3;con 3 vistos buenos en el caso de estar cerca de 31 la maquina se arriesga a tomar una carta
            je toma_carta_maquina
            jmp pasa_maquina;si no no toma ninguna carta

            ;Aca termina lo de pensar para arriesgar a tomar carta 
            toma_carta_maquina:
                mov flag_maquina_pasar,0
                ;esta instancia se fija que el rand no pase mas  de 4 cartas de un tipo de carta
                cartificador_finito:
                ; como se usa para no tomar cartas que no hay 
                    mov flag_NO_CARTA,0
                    call rand; en al el numero
                    ;Verifica que la carta que se genera exista en el mazo limitado
                    ;al
                    call verificardor_mazo
                    cmp flag_NO_CARTA,1;no existe la carta, en respuesta que vuelva a generar el random
                    je cartificador_finito 

                add mazoCartasMaquina,al;acumula el valor decimal de las cartas
                mov cartaDeLaRonda,al

                lea bx,cartasMaquina
                mov dl,"x"
                call buscador_posicion_cadena;en al la pocicion de la primera x
                mov bx,0
                mov bl,al
                ;aplico un corrector para los numeros,1,10,11,12
                mov ah,cartaDeLaRonda
                call corrector_valor_mazo; en ah el caracter en forma de carta
                mov cartasMaquina[bx],ah;luego de que agarra una carta y guarda todo la maquina pasa
                jmp pasa_maquina

            pasa_maquina:
                ;limpio siempre esta opcon
                mov cx,3
                mov bx,0

                limpio_tomardorDeciciones:
                    mov tomardorDeciciones[bx],"0"
                    inc bx
                loop limpio_tomardorDeciciones
                jmp no_accion
    no_accion:
        jmp ciclo_de_juego
    
    fin_ronda:
        ;printea los creditos del juego
        call resultados

        ;Aca deberia restar una vida al que perdio y empezar otra ronda
            ;acumulado_jugador--valor decimal de todas las cartas del jugador
            ;mazoCartasMaquina--valor decimal de todas las cartas de la maquina
        mov dl,acumulado_jugador    

        cmp mazoCartasMaquina,dl
        ja casiGanaMaquina ;si el mazo de la maquina es mayor al del jugador se fija si se paso (la maquina)
       
        cmp mazoCartasMaquina,dl ;si el mazo de la maquina es menor al del jugador se fija si se paso (el jugador)
        jb casiGanaJugador;
        
        cmp mazoCartasMaquina,dl; si ambos son iguales empate
        je empate

        casiGanaMaquina:
            ;si el mazo de la maquina es mayor y no se paso gano la maquina
            cmp mazoCartasMaquina, 31;
            jbe gano_maquina ;si no se paso gano la maquina
            cmp acumulado_jugador,31
            jbe gano_jugador ;de lo contrario pierde la maquina
            jmp empate
        
        casiGanaJugador:
            ;si el mazo de el jugador es mayor y no se paso gano el jugador
            cmp acumulado_jugador,31
            jbe gano_jugador ;si no se paso gano el jugador
            cmp mazoCartasMaquina, 31;
            jbe gano_maquina ;de lo contrario pierde el jugador
            jmp empate
        
        gano_maquina:
            ;resta vida al jugador
            lea bx, msj_gano_maquina
            push bx
            call imprimirXstack
            ;restar vida jugador
            lea bx, vidas
            mov dl,"*"
            call buscador_posicion_cadena;al posicion
            mov bx,0
            mov bl,al
            cmp vidas[bx],"*"
            je restar_vidas1
            jmp no_restar_vidas1
            restar_vidas1:
                mov vidas[bx]," "
                jmp no_restar_vidas1    
            no_restar_vidas1:
                dec vj;resto 1 a la vida del jugador

            call pausador_con_aviso
            jmp termino_decicion
        empate:
            ;busca el desenpate
            lea bx, msj_empate
            push bx
            call imprimirXstack
                ;sigo juga jugando
            call pausador_con_aviso
            jmp termino_decicion
        gano_jugador:
            ;resta vida a la maquina
            lea bx, msj_gano_jugador
            push bx
            call imprimirXstack
            ;restar vida maquina
            lea bx, vidas
            add bx,30
            mov dl,"*"
            call buscador_posicion_cadena;al deberia devolver 7

            mov bx,0
            add al,30 
            mov bl,al

            cmp vidas[bx],"*"
            je restar_vidas
            jmp no_restar_vidas

        restar_vidas:
            mov vidas[bx]," "
            jmp no_restar_vidas
        no_restar_vidas:
            dec vm
        call pausador_con_aviso
        jmp termino_decicion
        termino_decicion:
            mov acumulado_jugador,0
            mov mazoCartasMaquina,0

        ; antes deberia resetear todas las variables
        call borrar_para_sig_ronda
        jmp ciclo_de_juego
        ;termino el juego
        perdio_maquina_fin_game:
            lea bx, msj_termino_todo_maquina
            push bx
            call imprimirXstack 
        call pausador_con_aviso
        jmp finz
        perdio_jugador_fin_game:
            lea bx, msj_termino_todo_jugador
            push bx
            call imprimirXstack 
        call pausador_con_aviso
        jmp finz
        finz:
            mov flag_usuario_pasar,0
            mov flag_usuario_pasar,0
            lea bx, espacio
            push bx
            call imprimirXstack
            lea bx, creditos
            push bx
            call imprimirXstack
            lea bx, espacio
            push bx
            call imprimirXstack
            call pausador_con_aviso

    mov ax, 4c00h
    int 21h
main endp
    
    inicio_juego_menu proc
    push bx    
    push ax

        call limpiar_pantalla

        cmp estadoMenuInicio,0
        jb acomodo0
;la ley de colump-pios?
        cmp estadoMenuInicio,4
        jae acomodo2

        jmp paso_epicamente

            acomodo0:
            mov estadoMenuInicio,0
            jmp paso_epicamente

            acomodo2:
            dec estadoMenuInicio
            jmp paso_epicamente

        paso_epicamente:
        ;se prepara a ver que pasa en teclado
        call HANDLE_INPUT
        cmp bp, 48h 
        je arriba
        cmp bp, 50h
        je abajo    
        
        ; si no es ninguno de los cambios tira el menu normal
        cmp estadoMenuInicio, 1
        je jugadorVSmaquina

        cmp estadoMenuInicio, 3
        je REGLAS

        lea bx, menu
        push bx
        call imprimirXstack
        jmp esquivo

        jugadorVSmaquina:
            mov estadoMenuInicio, 1
            lea bx, jugadorVSmaquina_msj
            push bx
            call imprimirXstack
            call pausador

        jmp esquivo
        REGLAS:
            mov estadoMenuInicio, 3
            lea bx, reglas_msj
            push bx
            call imprimirXstack
            call pausador
        jmp esquivo

        arriba:
            cmp estadoMenuInicio,3;si bajo una vez queda en 2 si bajo otra vez queda en 3
            je subiendop
            jmp no_es_tres
                subiendop:
                    mov estadoMenuInicio,2
                    jmp esquivo
            no_es_tres:
            mov estadoMenuInicio,1
            jmp esquivo
        abajo:
            cmp estadoMenuInicio,3;si bajo 3 veces y quiero bajar mas, que no haga nada
            je esquivo
            
            cmp estadoMenuInicio,2;si bajop una vez queda en 2 si bajo otra vez queda en 3
            je baje_2_veces
            
            mov estadoMenuInicio,2
            jmp esquivo
            
            baje_2_veces:
            mov estadoMenuInicio,3
            jmp esquivo

        esquivo:
    ;en al esta el resultado de lo que pidio  el usuario
        pop ax
        pop bx
        ret
    inicio_juego_menu endp
    
    fun_ayuda_visual_jugador proc
        ;Lo que hace es mostrar en pantalla el valor acumulado en  
        push cx 
        push bx

        mov dl,acumulado_jugador
        lea bx,ayuda_visual_jugador
        call reg2assci

        lea bx, ayuda_visual_jugador
        push bx
        call imprimirXstack
    
        mov cx,3
        mov bx,0
        tukikiki:
            mov ayuda_visual_jugador[bx],"0"
            inc bx
        loop tukikiki
        pop bx
        pop cx
        ret
    fun_ayuda_visual_jugador endp

    interfaz proc ; Función para imprimir la interfaz y detectar el estado de las opciones del juego (jugables)
        push bx
        push bp
        lea bx, vidas
        push bx
        call imprimirXstack

        call HANDLE_INPUT ; en bp la tecla escaneada

        cmp bp, 4Bh ; Scancode para la tecla 'flechita derecha'
        je op1
        cmp bp, 4Dh ; Scancode para la tecla 'flechita izquierda'
        je op2

        cmp estadoMenu, 0
        je op1
        cmp estadoMenu, 1
        je op2

        lea bx, opcion_normal
        push bx
        call imprimirXstack

        lea bx, cartasJugador
        push bx
        call imprimirXstack

        jmp saltito_de_imprecio_normal

    op1:
        mov estadoMenu, 0
        lea bx, opciones1
        push bx
        call imprimirXstack
        lea bx, cartasJugador
        push bx
        call imprimirXstack
        call fun_ayuda_visual_jugador
        call pausador

        jmp saltito_de_imprecio_normal
    op2:
        mov estadoMenu, 1
        lea bx, opciones2
        push bx
        call imprimirXstack
        lea bx, cartasJugador
        push bx
        call imprimirXstack
        call fun_ayuda_visual_jugador
        call pausador

        jmp saltito_de_imprecio_normal

    saltito_de_imprecio_normal:
        pop bp
        pop bx
        ret
    interfaz endp

    borrar_para_sig_ronda proc
        push bx
        push cx

        mov cx,18
        mov bx,0 
        ;receteo mazo de cartas
        borraindador:
            mov cartasMaquina[bx],"x"
            mov cartasJugador[bx],"x"
        inc bx
        loop borraindador

        ;receteo valor acumulado del mazo de cartas 
        mov cx,3
        mov bx,0 
        borraindador1:
            mov nrm [bx],"0"
            mov nrm_jugador [bx],"0"
        inc bx
        loop borraindador1

        ;reinicia flags importantes y otros por si acaso
        mov flag_NO_CARTA, 0
        mov estadoMenu, 2
        mov mazoCartasMaquina, 0
        mov acumulado_jugador, 0
        mov cartaRondaJugador, 0
        mov flag_usuario_pasar, 0
        mov flag_maquina_pasar, 0
        mov cartaDeLaRonda, 0
            
        ;PRoCESO por si acaso VER SI QUITAR-- LO QUE HACE ES reniciar las cartas como si nunca se hubierar repartido
        ;si se quita daria resultados mas cerrados y complicados ya que ciertas  cartas no estarian en juego  
        mov cx,12
        mov bx,0
        borraindador3:
            mov array_cantidad_de_cartas [bx],"4"
            inc bx
        loop borraindador3
        pop cx
        pop bx
        ret
    borrar_para_sig_ronda endp

    resultados proc
        push bx
        push dx 

        call limpiar_pantalla

        ;Datos del jugador
        lea bx, jugadortext
        push bx
        call imprimirXstack
        ;cartas en partida
        lea bx,msj_cartas
        push bx
        call imprimirXstack
        lea bx, cartasJugador
        push bx
        call imprimirXstack

        lea bx,msj_numero
        push bx
        call imprimirXstack
        lea bx, nrm_jugador
        mov dl, acumulado_jugador
        call reg2assci

        lea bx,nrm_jugador
        push bx
        call imprimirXstack
        ;///////////////////////
        lea bx, separador
        push bx
        call imprimirXstack
        ;//////////////////////
        ;Datos de la maquina
        lea bx, maquinatext
        push bx
        call imprimirXstack
        ;cartas de la partida
        lea bx,msj_cartas
        push bx
        call imprimirXstack
        lea bx,cartasMaquina
        push bx
        call imprimirXstack

        ;imprimo resultado numerico del mazo
        lea bx,msj_numero
        push bx
        call imprimirXstack
        lea bx, nrm
        mov dl, mazoCartasMaquina
        call reg2assci
        lea bx,nrm
        push bx
        call imprimirXstack

        pop dx
        pop bx
        ret 
    resultados endp

 pausador proc
    ;paralizador del codigo sin mensaje
    push ax
     
    etiqueta_por_compromiso:
        
        mov ah,8;1
        int 21h
        cmp al,0dh
        je salgo_pausador
        ;si no preciona salgo igual
        jmp salgo_pausador
    salgo_pausador:
     
        pop ax
        ret 
 pausador endp

     pausador_con_aviso proc
        ;paralizador del codigo con mensaje de aviso
        push ax
        lea bx, msj_pausador
        push bx
        call imprimirXstack

        mov ah,8;1
        int 21h
        cmp al,0dh
        je salgo_pausador2
        ;si no preciona salgo igual
        jmp salgo_pausador2
        salgo_pausador2:
        pop ax
        ret
     pausador_con_aviso endp

HANDLE_INPUT PROC ; LEVANTA LA tecla presionada y deja el scancode en BP
                  ; Código sacado del campus, créditos al tipo que lo hizo 
                  ;ojo Comparaciones de bp con caracteres ASCII: El scancode de una tecla no es su valor ASCII
    ; CLEARS THE KEYBOARD TYPEHEAD BUFFER AND COLLECTS A SCANCODE 
    ; ALTERS BP
    LOCAL_HANDLE_INPUT:
    push ax
    push bx
    push es

    mov ax, 40h                
    mov es, ax                  ; Access keyboard data area via segment 40h
    mov WORD PTR es:[1ah], 1eh  ; Set the kbd buff head to start of buff
    mov WORD PTR es:[1ch], 1eh  ; Set the kbd buff tail to same as buff head
                                ; The keyboard typehead buffer is now cleared

    xor ah, ah
    in al, 60h                  ; al -> scancode
    test al, 80h                ; Is a break code in al?

    jz .ACCEPT_KEY              ; If not, accept it. 
                                ; If so, check to see if it's the break code
                                ; that corresponds with the make code in bp.
    mov bx, bp                  ; bx -> make code   
    or bl, 80h                  ; Change make code into its break code  
    cmp bl, al   

    je .ACCEPT_KEY              ; If so, accept the break code.
    jmp fin

.ACCEPT_KEY: 
    mov bp, ax                  ; bp -> scancode, accessible globally
fin:
    pop es
    pop bx
    pop ax
    ret
HANDLE_INPUT ENDP

corrector_valor_mazo proc
    ;Necesita
        ;en ah el numero decimal a corregir y pasar a caracter 
    ;Devuelve
        ;en ah el catacter corregido
        ; se fija en que caso esta
        cmp ah,1
        je es_a

        cmp ah,10
        je es_j
        cmp ah,11
        je es_q
        cmp ah,12
        je es_k

        cmp ah,10
        jb es_menor_a_diez 

        es_a:
            mov ah,"A"
        jmp termine_corregir
        es_j:
            mov ah,"J"
        jmp termine_corregir
        es_k:
            mov ah,"K"
        jmp termine_corregir
        es_q:
            mov ah,"Q"
        jmp termine_corregir

        es_menor_a_diez:
            add ah,30h
        jmp termine_corregir

        termine_corregir:
    ret
corrector_valor_mazo  endp

limpiar_pantalla proc
    push ax

    mov ah, 0fh
    int 10h
    mov ah, 0
    int 10h

    pop ax
    ret 
limpiar_pantalla endp

 rand proc
    ;Necesita
        ;nada, solo las variables de abajo, solo la llamas y te da un random en el rango (1-12)
    ;Devuelve
        ;En al un numero random
    push si
    push di
    push dx
    push bx
    push cx

    corrector:
        ; obtengo la hora del sistema como semilla
        ; Usa DX como la semilla
        mov ah, 2ch
        int 21h   
        mov dh,0  
        mov ah,0

        ;guardo una semilla inicial
        mov semilla,dl
        mov al,semilla

        ;paso los datos para la intr
        mov ax, dx;semilla completa
        mov si, random_secuencia ;(puede ser cualquier valor fijo) ;NO TOCAR!!!!
        mov di, ran_anterior
        int 81h;Llama al generador de números aleatorios

        ;guardo la info del primero generado
        mov ran_anterior,ax
        mov random_secuencia,si

        ;Verificacion de que se genere el numero random en un rango de datos
        cmp al,13;para que llegue hasta 12
        jae corrector
        cmp al,0
        je corrector
        jmp fin_corrector 
    fin_corrector:
        pop cx
        pop bx
        pop dx
        pop di
        pop si
    
        ret
    ;necesita estas variables 
        ; random_secuencia dw 4
        ; ran_anterior dw 3
        ; semilla db 1
rand endp

    verificardor_mazo proc
                                   ;" 0 1 2 3 4 5 6 7 8 9 10 11"
                                   ;" a 2 3 4 5 6 7 8 9 j q  k "
        push ax
        push bx
        push si
        push cx
        push dx

        ;Mira cual es la carta en al y la saca de la pila del mazo  
        mov dx,0
        mov bx,0
        mov si,0
        mov cx,9;?

        ;primero se fija si en "al" estan las cartas que no tienen valor numerico de simbolo
        ;si las encuentra les da su posicion correspondiente para luego fijarse sui hay mas de esas cartas
        cmp al,1
        je es_letra_a;bx en 0

        cmp al,10
        je es_letra_j;bx en 9

        cmp al,11
        je es_letra_q;bx en 10

        cmp al,12
        je es_letra_k;bx en 11

        ;si no es ninguno de las anteriores debe estar enre 0 y 9 y se fija en eso
        add al,30h;que este en el rango
        etiqueta:;si esta entre 0 y 9 lo encuentra
            cmp array_de_cartas[bx],al;2,3,4,5,6,7,8,9 ; solita se pasa la posicion de bx 
            je encontre_carta
            inc bx
        loop etiqueta

        es_letra_a:
            mov bx,0;en array 1
        jmp encontre_carta
        es_letra_j:
            mov bx,9;en array 10
        jmp encontre_carta
        es_letra_k:
            mov bx,11;en array 12
        jmp encontre_carta
        es_letra_q:
            mov bx,10;en array 11
        jmp encontre_carta

        encontre_carta:
        ;en bx debe pasarse la posicion que corresponda 
        cmp array_cantidad_de_cartas[bx],"0"
        je mandar_aviso_NO_CARTA
        sub array_cantidad_de_cartas[bx],1
        jmp termino_aqui

        mandar_aviso_NO_CARTA:
            mov flag_NO_CARTA,1
            jmp termino_aqui

        termino_aqui:
            pop dx
            pop cx
            pop si
            pop bx
            pop ax
            ret
    verificardor_mazo endp
end      