/*
    Operador ==
*/
procedure main 
    local nTabuada1, nTabuada2, nResp
    input "Informe um numero: " to nTabuada1
    input "informe outro numero: " to nTabuada2
    ?
    ? "Quanto e ", nTabuada1 , " vezes " , nTabuada2, " ? "
    ?
    input "Resposta: " to nResp
    if ((nTabuada1 * nTabuada2) == nResp) //Aqui foi utilizado o operador "==" , mas o operador "="
                                          //Causa o mesmo efeito
        ? "Certa a resposta."
    elseif ((nTabuada1 * nTabuada2) <> nResp)
        ? "resposta errada."
    end if
    ? "Final da rotina"
return