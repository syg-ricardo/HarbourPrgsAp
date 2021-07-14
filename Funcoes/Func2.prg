/*
    Uso de AllTrim - Apaga espaços em branco e, torno da String
*/

procedure main
    local cNome, cSobrenome
cNome := "     Jose"
cSobrenome := "     Quintas     "

? "Concatenando o nome e sobrenome sem AllTrim"
? cNome + "  " + cSobrenome

? "Agora concatenando com AllTrim"
cNome := AllTrim(cNome)
cSobrenome := AllTrim(cSobrenome)
? cNome + "  " + cSobrenome
return

