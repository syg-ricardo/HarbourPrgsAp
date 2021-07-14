/*
    @ ... SAY ... GET simples "Formas de sair do formulario"
    Testar com Teclando <ENTER> ate chegar no ultimo GET, pressionando ESC, usando
    a tecla PAGE DOWN
*/
procedure main
    local nValor1 := 0
    local nValor2 := 0
    local GetList := {}

    set delimiters on //Exibe os delimitadores
    set delimiters to "[]" // Cria delimitadores para os GETs
    cls 
    @ 5, 5 say "Informe o valor da parcela 1: " get nValor1
    @ 7, 5 say "Informe o valor da parcela 2: " get nValor2
    Read 
    ? "O valor nValor1 e " , nValor1
    ? "O valor nValor2 e " , nValor2
return
