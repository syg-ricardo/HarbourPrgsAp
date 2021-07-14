procedure main
    local cNota 
    local nNota 

    cNota := "1200" //Uma variavel caractere
    nNota := 300

    ? nNota + Val( cNota )
    ? "Deu certo, masa proxima vai gerar um erro de execucao..."
    ? nNota + cNota //Gera erro de execucao
return