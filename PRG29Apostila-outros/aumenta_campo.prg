/*
	@ ... SAY ... GET simples
*/
PROCEDURE Main
	LOCAL cNome := SPACE (100)
	LOCAL GetList := {}
	SET DATE BRITISH // Exibe datas no formado dd/mm/aa
	SET CENTURY ON // Ativa a exibição do ano com quatro dígitos .
	SET DELIMITERS ON // Exibe os delimitadores
	SET DELIMITERS TO "[]" // Cria delimitadores para os GETs
	CLS
	@ 5,5 SAY 	" Informe o nome : " GET cNome PICTURE "@S30"
READ

? cNome

RETURN