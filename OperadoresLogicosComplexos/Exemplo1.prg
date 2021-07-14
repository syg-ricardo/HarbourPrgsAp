/*
    Operadores logicos complexos
*/
procedure Main
    local cResp1, cResp2
     accept "Esta chovendo ? (S/N) " to cResp1
     cResp1 := upper(cResp1) //Converte a letra para maiuscula caso.

     accept "Esta relampejando ? (S/N) " to cResp2
     cResp2 := upper (cResp2) //Converte a letra para maiuscula caso.

     if (( cResp1 == "S") .and. ( cResp2 == "S"))
        ? "Fique em casa."
     else
        ? "Pode sair."
     end if
return
