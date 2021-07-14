/*
    Exemplo Funcao Round
*/
procedure main
    local nNum

    do while .t.
        input "Digite um numero decimal qualquer: " to nNUm 
        if int( nNUm ) != nNum
            exit
        end if
    end do
    ? "Round ( nNUm, 3 ) ==> ", Round ( nNUm, 3 )
    ? "Round ( nNUm, 2 ) ==> ", Round ( nNUm, 2 )
    ? "Round ( nNUm, 1 ) ==> ", Round ( nNUm, 1 )
    ? "Round ( nNUm, -1 ) ==> ", Round ( nNUm, -1 )
return

