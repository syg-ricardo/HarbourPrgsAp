/*
    Desenhando um retangulo na tela usando o MESSAGE
*/
procedure main
    local nOpcao

    cls //Limpa a tela
    @ 5, 5 to 9, 18 double //Crio um box com @ ... to

    // Aqui inicia o menu
    @ 6, 6 prompt " Cadastro " message " Realiza o cadastro dos usuarios"
    @ 7, 6 prompt " Relatorios" message " Imprime os relatorios do sistema"
    @ 8, 6 prompt " Utilitarios" message " Inicia a rotina de utilitarios"

    //Aqui eu seleciono a opcao
    set message to 12 //As mensagens acima serao impressas na linha 12
    menu to nOpcao

    //Aqui eu analiso o valor de nOpcao
    do case
        case nOpcao == 1
            ? "Voce selecionou cadastro" 
        case nOpcao == 2
            ? "Voce selecionou relatorios"
        case nOpcao == 3
            ? "Voce selecionou utilitarios"
        otherwise
            ? "Nenhuma das alternativas"
                        
    endcase
    return
