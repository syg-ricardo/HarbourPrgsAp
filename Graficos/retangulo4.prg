/*
    Desenhando retangulo na tela com "Limpa tela - @...Promt - Menu To
*/    
procedure main
    local nOpcao
    cls //Limpa Tela
    @ 5, 5 to 9, 18 double //Criando um box com o @ ... to

    //Aqui inicia o menu
    @ 6,6 prompt " Cadastro "
    @ 7,6 prompt " Relatorios "
    @ 8,6 prompt " Utilitarios "

    //Aqui eu seleciono a opcao
    Menu To nOpcao

    //Aqui eu analiso o valor de nOpcao
    do case
    case nopcao == 1
        ? "Voce selecionou cadastro"
    case nopcao == 2
        ? "Voce selecionou relatorios"
    case nopcao == 3
        ? "Voce selecionou utilitarios"    
    otherwise
        ? "Nenhuma das alternativas"
    endcase
return


