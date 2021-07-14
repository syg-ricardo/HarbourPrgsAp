/*
    Comparacao entre caracteres2*
*/
#define estados_2porcento "CE:MA:PI" //Usar separador (:) para identificar as siglas
                                    //Se não usar o separador o sistema aceita EM, AP, CEM, etc
procedure Main
    local cSigla // Sigla

    accept "Informe a sigla do Estado: " to cSigla

    cSigla := UPPER(cSigla) // Se o usuario digitou em minuscula
                            // entao converte para maiusculas
    if ":" $ cSigla
        ? "Formato incorreto"
    else
        if cSigla $ estados_2porcento        
            ? "Aliquota de 2 por cento"
        else
        ? "Aliquota normal"
        end if
    end if
return