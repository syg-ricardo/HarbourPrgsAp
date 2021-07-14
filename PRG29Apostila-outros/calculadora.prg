//Calculadora
procedure MAIN
    local nEscolha // Escolha do menu

    //Inicialização do ambiente
    cls 

    //menu inicia
    @ 09,10 say "Calculos matematicos"

    @ 11,10 PROMPT "        SOMA            "
    @ 12,10 PROMPT "        SUBTRACAO       "
    @ 13,10 PROMPT "        MULTIPLICACAO   "
    @ 14,10 PROMPT "        DIVISAO         "

    MENU TO nEscolha

    do case
        case nEscolha == 1
            Soma()
        case nEscolha == 2
            Subtracao()
        case nEscolha == 3
            Multiplicacao()
        case nEscolha == 4
            Divisao()            
    endcase

return

procedure Soma
    local n1, n2 // Valores que serao digitados
    local nResp // A resposta
    local nCont // Contador do laco
    local nAcerto := 0 // Contador de acertos

    for nCont := 1 to 5
        n1 := hb_RandomInt(1, 10)
        n2 := hb_RandomInt(1, 10)
        ? "Quanto e ", n1, " + " , n2, " ? "
        input "Resposta: " to nResp

        if ( nResp == (n1 + n2))
            nAcerto++
            ? "Certo !"
        else
            ? "Errado !"
        end if
    next
    if nAcerto == 5
        ? "Parabens voce acertou !"
    end if

return

procedure Subtracao
    local n1, n2 // Valores que serao digitados
    local nResp // A resposta
    local nCont // Contador do laco
    local nAcerto := 0 // Contador de acertos

    for nCont := 1 to 5
        n1 := hb_RandomInt(1, 10)
        n2 := hb_RandomInt(1, 10)
        ? "Quanto e ", n1, " - " , n2, " ? "
        input "Resposta: " to nResp

        if ( nResp == (n1 - n2))
            nAcerto++
            ? "Certo !"
        else
            ? "Errado !"
        end if
    next
    if nAcerto == 5
        ? "Parabens voce acertou !"
    end if

return

procedure Multiplicacao
    local n1, n2 // Valores que serao digitados
    local nResp // A resposta
    local nCont // Contador do laco
    local nAcerto := 0 // Contador de acertos

    for nCont := 1 to 5
        n1 := hb_RandomInt(1, 10)
        n2 := hb_RandomInt(1, 10)
        ? "Quanto e ", n1, " * " , n2, " ? "
        input "Resposta: " to nResp

        if ( nResp == (n1 * n2))
            nAcerto++
            ? "Certo !"
        else
            ? "Errado !"
        end if
    next
    if nAcerto == 5
        ? "Parabens voce acertou !"
    end if

 return

procedure Divisao
    local n1, n2 // Valores que serao digitados
    local nResp // A resposta
    local nCont // Contador do laco
    local nAcerto := 0 // Contador de acertos

    for nCont := 1 to 5
        n1 := hb_RandomInt(1, 10)
        n2 := hb_RandomInt(1, 10)
        ? "Quanto e ", n1, " / " , n2, " ? "
        input "Resposta: " to nResp

        if ( nResp == (n1 / n2))
            nAcerto++
            ? "Certo !"
        else
            ? "Errado !"
        end if
    next
    if nAcerto == 5
        ? "Parabens voce acertou !"
    end if    
return

return