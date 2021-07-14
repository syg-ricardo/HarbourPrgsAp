/*
Begin Sequence 2
Agora sai dos dois lacos
Usa mais um if
*/
procedure main
    local x,y

    for x := 1 to 15
        for y := 1 to 15
            ? x , y
            if x == 3 .and. y == 10 // Condicao de saida
                ? "Devo sair dos dois lacos a partir daqui."
                ? "Mas so consigo sair do laco mais interno."
                exit
            end if
        next
        if x == 3 .and. y == 10 // Repare que repeti a condicao
            ? "Agora sim, esta condicao sai dos dois lacos"
            exit
        end if
    next
    ? "Final do programa"
    ? " x vale " , x , " e y vale " , y
return

