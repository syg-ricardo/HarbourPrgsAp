/*
Estruturas de controle de fluxo
*/
procedure main 
    local nNota 
    //Recebe o valor da nota
    nNota := 0
    input "Informe a nota do aluno: " to nNota 

    //Decide se foi aprovado ou não de acordo com a média
    if (nNota >= 7)
            ? "Aprovado"
        else
        if (nNota >= 5)
            ? "Recuperação"
            else
            ? "Reprovado"
        end if
    end if
return