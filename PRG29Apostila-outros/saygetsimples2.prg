/*
@ ... SAY ... GET simples
*/
PROCEDURE Main
LOCAL cCEP := SPACE (10)
LOCAL nIdade := 0
LOCAL GetList := {}

SET DELIMITERS ON // Exibe os delimitadores
SET DELIMITERS TO "[]" // Cria delimitadores para os GETs
CLS
@ 5,5 SAY " Informe o CEP " GET cCEP PICTURE " 99999-999 "
@ 7,5 SAY " Idade : " GET nIdade PICTURE "999"
READ

? "Cep: " , cCEP
? "Idade: " , nIdade

RETURN(.T.)