/*
	@ ... SAY ... GET simples
*/
PROCEDURE Main
LOCAL cNome := SPACE (20)
LOCAL nIdade := 0
LOCAL GetList := {}

SET DELIMITERS ON // Exibe os delimitadores
 SET DELIMITERS TO "[]" // Cria delimitadores para os GETs
CLS
@ 5,5 SAY " Informe o nome : " GET cNome PICTURE "@!" //Usando o @ com ! para que o campo fique completo
@ 7,5 SAY " Idade : " GET nIdade
READ

? cNome , nIdade
return(True)