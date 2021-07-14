/*
    Exemplo de convercao de Num para Carac
*/
procedure main 
    local nTotal
    nTotal := 1300.456

    ? "O total da venda foi de " + Str(nTotal)
    ? "O total da venda foi de " + Str(nTotal , 10)
    ? "O total da venda foi de " + Str(nTotal , 5 , 2)
    ? "O total da venda foi de " + Str(nTotal , 3 , 2)
    ? "O total da venda foi de " + hb_ValToStr (nTotal) //Funcao que converte qualquer tipo de dado para caractere
    ? "Deu certo ate agora, ma a proxima vai gerar um erro de execucao..."
    ? "O total da venda foi de " + nTotal // Gera erro de execucao
return

