/*
    Estrutura de controle com IF
*/
procedure Main
    local nNota
    // Recebe o valor da nota
    nNota := 0
    input "Informe a nota do aluno: " to nNota

    //Decide se foi aprovado ou nao de acordo com a media
    if (nNota > 10) .or. (nNota <0)
        ? "Valor invalido"
    elseif ( nNota >= 7)
        ? "Aprovado"
    elseif ( nNota >= 5)
        ? "Recuperacao"
    elseif ( nNota >= 0 )
        ? "Reprovado"
    else
        ? "Valor invalido"
    end if
return

