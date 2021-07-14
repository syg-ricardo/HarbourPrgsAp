procedure main
    local cNome
    accept "Digite um nome (minimo de 9 letras): " to cNome
    ? "Os tres primeiros caracteres do seu nome: " , left(cNome, 3)
    ? "Os tres ultimos caracteres do seu nome: " , right(cNome,3)
    ? "Um trecho iniciando a terceira letra e "
    ?? "Finalizando na quinta letra: " , SubStr( cNome , 3 , 2)
return
