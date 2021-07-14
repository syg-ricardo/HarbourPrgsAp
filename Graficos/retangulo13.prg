/*
    @ ... SAY ... GET simples    
    Usando o @ junto com a ! aparece o tamanho completo
    do campo, caso contrario eu preciso repetir a !
    o numero de vezes dotamanho do campo
*/
PROCEDURE Main
    LOCAL cNome := SPACE (20)
    LOCAL nIdade := 0
    LOCAL GetList := {}
    SET DELIMITERS ON // Exibe os delimitadores
    SET DELIMITERS TO "[]" // Cria delimitadores para os GETs
    CLS
    @ 5,5 SAY " Informe o nome : " GET cNome PICTURE "@!"
    @ 7,5 SAY " Idade : " GET nIdade
    READ
    ? cNome , nIdade
RETURN