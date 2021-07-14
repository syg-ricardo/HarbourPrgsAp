/*
    For Each
*/
procedure main
    local cCliente
    local cEl 

    ? "Processando com o laco For Each "
    ? "Ele pegara a String e processara letra por letra"
    accept "Informe o seu nome: " to cCliente
    for each cEl in cCliente
        ? cEl
    next
return

