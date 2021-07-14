/*
    Begin seqwuence com dois break
    Identificando qual break foi executado
*/
procedure main
    local cResp, nValBreak

    begin sequence
        ? "Fluxo normal"
        accept "Deseja sair com o Break ? (S/N)" to cResp
        if cResp $ "Ss"
            break 1
        end if
            ? "Continua o fluxo"
            ? "O primeiro break nao foi executado"

        accept "Deseja sair com o Break ? (S/N)" to cResp
        if cResp $ "Ss"
            break 2
        end if
            ? "Continua o fluxo"
            ? "O segundo break nao foi executado !"
    recover using nValBreak
            ? "Fluxo alternativo"
            ? "O break numero ", nValBreak , " foi executado !"
    endsequence
    ? "Final do programa"
return