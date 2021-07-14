/*
    For Each Descendente
*/
procedure main
    local cNome
    local cEl 

    ? "Processando com o laco For Each"
    ? "Ele pegara a String e processara letra por letra"
    ? "mas ira exibir ao contrario"

    accept "Informe o seu nome: " to cNome 
    for each cEl in cNome Descend
        ? cEl
    next
return