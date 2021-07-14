/*
    Begin Sequence é uma estrutura usada
    para controle de erros em tempo de
    execução
*/

//Existe uma condicao no laco interno, que
//incrementa o valor de y que requer a saida dos dois
//lacos, mas o exit fara sair somente do laco interno

procedure main
    local x,y

    for x := 1 to 15
        for y := 1 to 15
            ? x,y
            if x == 3 .and. y == 10 // Condição de saída
                ? "Devo sair dos dois lacos a partir daqui."
                ? "Mas so e possivel sair do laco interno"
                exit
            end if
        next
    next
    ? "Final do programa"
    ? " x vale ",x," e y vale ",y
return 