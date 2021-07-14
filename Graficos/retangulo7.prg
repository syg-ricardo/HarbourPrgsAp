/*
    @ ... SAY ... GET simples
*/
procedure main 
    local nValor1 := 0
    local nValor2 := 0
    local getlist := {}

    set delimiters on // Exibe os delimitadores
    set delimiters to "[]" // Cria delimitadores para os gets

    cls 
    @ 5, 5 say "Informe o valor da parcela 1: " get  nValor1
    @ 7, 5 say "Informe o valor da parcela 2: " get  nValor2
    Read 
return