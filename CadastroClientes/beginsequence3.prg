/*
Usando  Begin Sequence
esta estrutura deve possuir um comando Break
O uso excessivo do Begin Sequence pode causar confusao na
leitura dos codigos
*/
procedure main
    local x,y

    begin sequence
        for x:= 1 to 15
            for y := 1 to 15
                ? x , y
                if x == 3 .and. y == 10 //Condicao de saida
                    ? "Devo sair dos 2 lacos a partir daqui."
                    ? "Com o Begin Sequence e Break isso e possivel."
                    Break // Sai da sequencia e vai para a "Final do Programa"
                end if
            next
        next
    end sequence
    ? "Final do programa"
    ? " x vale " , x , " e y vale " , y
return

