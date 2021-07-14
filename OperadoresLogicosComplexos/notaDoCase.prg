/*
    Estrutura Do Case
*/
procedure Main
    local nNota 

    //Recebe o valor da nota
    nNota := 0
    input "Informe a nota do aluno: " to nNota

    //Decide se foi aprovado ou nao de acordo com a nota
    do case
        case ( nNota > 10) .or. ( nNota < 0)
            ? "Valor invalido"
            case ( nNota >= 7 )
                ? "Aprovado"
                case ( nNota >= 5 )
                    ? "Recuperacao"
                    case ( nNota >= 0 )
                        ? "reprovado"
                        otherwise
                            ? "Valor invalido"
                        endcase
return      

