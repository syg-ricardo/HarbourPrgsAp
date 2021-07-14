/*
    @ ... SAY ... GET simples
    Usando tambem o valid
*/
procedure main
    local cEndereco := space(50)
    local cBairro := space(30)
    local nNumero := 0
    local cCEP := space(8)
    local cComplemento := space(10)
    local GetList:={}

    set delimiters on // Exibe os delimitadores
    set delimiter to "[]" // Cria delimitadores para os gets
    cls 
    @ 5,5 say "Informe o endereco: " get cEndereco
    @ 7,5 say "Informe o numero: " get nNumero valid nNumero > 0
    @ 9,5 say "Informe o cep: " get cCEP
    @ 11,5 say "Informe o complemento: " get cComplemento
    @ 13,5 say "Informe o bairro: " get cBairro
    Read 
    ? cEndereco, nNumero
    ? cComplemento
    ? cBairro, cCEP
    
return  

