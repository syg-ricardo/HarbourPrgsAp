/*
    Exemplo de funcoes com parametros
    Len , Upper,Lower    
*/
procedure main
    local cNome

    accept "Digite o seu nome: " to cNome
    ? "O seu nome possui " , Len(cNome) , "Letras"
    ? "O seu nome com letras maiusculas se escreve assim: " , Upper(cNome)
    ? "O seu nome com letras minusculas se escreve assim: " , Lower(cNome)
return