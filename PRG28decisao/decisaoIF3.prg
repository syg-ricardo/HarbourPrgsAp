/*
    Estrutura de controle de fluxo
*/
procedure main
    local nota 
    //Recebe o valor da nota
    nNota := 0
    input "Informe a nota do aluno: " to nNota

    //Decide se foi aprovado ou reprovado de acordo com a média
    if (nNota >= 7)
        ? "Aprovado"
    else
        ? "Reprovado"
    end if
return 



