/*
    Calculo de juros compostos
*/
procedure main
    local nCapital
    local nMontante
    local n
    local nRendimento
    local nTaxa
    local nTrimestre
    local x

    input "Informe o capital : " to nCapital
    input "Informe a taxa : " to nTaxa
    input "Informe os anos: " to x

    nMontante := nCapital
    nTrimestre := 1
    n := 4 * x

    do while .t.
    /*Calculo de rendimento trimestral*/
    nRendimento := nTaxa * nMontante
    
    /*Calculo do montante trimestral*/
    nMontante := nCapital * ( 1 + nTaxa ) ^ nTrimestre 

    /*Rendimento e montante trimestrais*/
    ? "Rendimento = " , nRendimento , " Montante = " , nMontante

    if nTrimestre == n
        exit 
    end if

    // Modifique o valor do trimestre
    nTrimestre := nTrimestre + 1
    end do
return