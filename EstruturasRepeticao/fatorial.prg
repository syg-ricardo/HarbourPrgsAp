/*
    Programa que calcula o fatorial de N!
*/
procedure main
    local nFat, i, n 

    input "Informe o numero: " to n
    nFat := 1
    i := 2
        do while i <= n
            nFat := nFat * 1
            i := i + 1
        end do
        //Verificar porque o programa não está fazendo o calculo certo
        ? "O seu fatorial e:" 
        ?? nFat
        
    return