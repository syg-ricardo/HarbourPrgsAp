/*
    Chamando rotinas de outros arquivos
*/
procedure main()
    local nParcela1 := 0
    local nParcela2 := 0
    local GetList := {}

    cls
    @ 5,5 say "Informe a parcela 1: " get nParcela1 picture "@RE 999,999.99"
    @ 7,5 say "Informe a parcela 2: " get nParcela2 picture "@RE 999,999.99"

    read

    soma(nParcela1, nParcela2)

return

procedure Soma (nVal1, nVal2)
    @ 9,5 say nVal1 + nVal2 picture "@RE 999,999.99"

return