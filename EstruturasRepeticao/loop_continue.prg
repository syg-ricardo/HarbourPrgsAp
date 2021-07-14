/*
    Diferencas entre loop e continue
*/
procedure main
    local nCont
    local cResp

    ? "LOOP"
    for nCont := 1 to 10
        ? "O valor de nCont e " , nCont
        if nCont == 5
            ? "Vou para o topo do laco, mas nCont sera incrementada."
            loop
        end if
    next
    ? "O valor fora do laco e " , nCont //nCont vale 11
    ? "EXIT"
    for nCont := 1 to 10
        ? "O valor de nCont e " , nCont
        if nCont == 5
            ? "Vou sair imediatamente sem incrementar nCont"
            exit
        end if
    next
    ? "O valor fora do laco e " , nCont // nCont vale 5
return