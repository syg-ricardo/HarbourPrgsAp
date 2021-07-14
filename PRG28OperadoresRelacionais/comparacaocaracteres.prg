/*
    Comparacao entre caracteres
*/
procedure Main
    local cNome1, cNome2 // Nomes

    ? "O programa seguinte coloca dois nomes em ordem alfabetica."

    accept "Digite um nome: " to cNome1
    accept "Digite outro nome: " to cNome2

    if ( upper(cNome1) > upper (cNome2)) //Usando upper para converter letras para maiusculo
        ? cNome2
        ? cNome1
    else
        ? cNome1
        ? cNome2
    end if

return