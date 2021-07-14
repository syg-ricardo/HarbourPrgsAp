/*
    Switch
*/
procedure main
    local nOpc
    ? "Uso do Switch"
    Input "Informe a sua opcao (1, 2 ou 3): " to nOpc
    switch nOpc
        case 1
            ? "Escolheu 1"
        case 2
            ? "Escolheu 2"
            exit
        case 3
            ? "Escolheu 3"
        otherwise
            ? "Opcao invalida"
        end
        ? "TERMINOU !"
return


