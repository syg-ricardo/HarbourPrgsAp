/*
    Bein Sequence com recover
    O recover serve para criar um fluxo extra
    quando o break for executado
*/
procedure main
    local cResp
    begin sequence
        ? "Fluxo normal"
        accept "Deseja sair com o break ? (S/N)" to cResp
        if cResp $ "Ss"
            Break
        end if
        ? "Continua o fluxo"
        ? "O primeiro break nao foi executado !"

        accept "Deseja sair com o break ? (S/N)" to cResp
        if cResp $ "Ss"
            Break
        end if
        ? "Continua o fluxo"
        ? "O segundo break nao foi executado !"
    Recover
        ? "Fluxo alternativo"
        ? "O break foi executado, mas qual dos dois ?"
    endsequence
    ? "Final do programa"
return