/*
    Begin Sequence sem recover
*/
procedure main
    local cResp
    begin sequence
        ? "Fluxo Normal"
        accept "Deseja sair com o break ? (S/N)" to cResp
        if cResp $ "Ss"
            Break
        end if
        ? "Continua o fluxo"
        end sequence
    ? "O break foi executado !"
    ? "Final do programa"
return



