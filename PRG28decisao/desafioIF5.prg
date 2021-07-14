/*
    Estrutura de controle de fluxo
*/
procedure main
    local nNota 

        //Recebe o valor da nota
        nNota := 0
        input "Informe  valor da nota: " to nNota
        //Decide se foi aprovado ou não de acordo com  a nota
        if (nNota >= 7)
            ? "Aprovado"
        elseif (nNota >=5)
            ? "Recuperacao"
        else
            ? "Reprovado"
        endif 
return



        
