/*
    Erros de arredondamento
*/
procedure main
    local nPreOri := 300000000000000 // Preco original
    local nPreDes := nPreOri - 0.05 // Preco com desconto
    local nDesconto := Round (nPreOri - nPreDes , 2 ) // Valor do desconto calculado

    ? "O Valor esperado do desconto e de 0.05 "
    ? "O valor calculado do desconto e de " , nDesconto
return
