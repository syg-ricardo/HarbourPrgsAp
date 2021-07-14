/*
@ ... SAY ... GET simples
*/
PROCEDURE Main
	LOCAL cCEP := SPACE (10)
	LOCAL cFone := SPACE (10)
	LOCAL GetList := {}

	SET DELIMITERS ON // Exibe os delimitadores
	SET DELIMITERS TO "[]" // Cria delimitadores para os GETs
	CLS
	@ 5,5 SAY " Informe o CEP " GET cCEP PICT "@R 99999-999" // Colocando o R para o traço não aparecer na mascara
	@ 7,5 SAY " Telefone : " GET cFone PICT "@R (999) 9999-9999" // Colocando o R para o traço não aparecer na mascara
	READ
	? cCEP , cFone

RETURN (True)