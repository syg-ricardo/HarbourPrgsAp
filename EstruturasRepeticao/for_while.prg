/*
    Desafio: Comando loop
*/
procedure main
    local cResposta
    local nContador

    ? "Processando com o laco While "
    do while .t.
        accept "Confirma a operacao ? (S/N) " to cResposta
        if !( cResposta $ "SsNn" ) // Leia cResposta nao esta contido em "SsNn"
            ? "Digite 'S' para Sim ou 'N' para Nao"
            loop
        else
            exit
        end if
    end do

    ? "Processando com o laco for "
    for nContador  := 1 to 5 
        ? nContador 
        accept "Deseja prosseguir para a etapa seguinte (S/N) " to cResposta 
        if (cResposta $ 'nN') // Leia cResposta estacontido em "nN"
            ? "Pulando sem executar o restante da operacao " , nContador
            loop
        end if
        ? "Restante da operacao " , nContador
    next
    ? "O valor apos a saida e " , nContador
return
