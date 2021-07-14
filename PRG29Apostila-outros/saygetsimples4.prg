/*
	@ ... SAY ... GET simples
*/
PROCEDURE Main
	LOCAL dDataIni := DATE ()
	LOCAL dDataFim := DATE ()
	LOCAL cPedNot := " PEDIDO "
	LOCAL GetList := {}

	SET DATE BRITISH // Exibe dadas no formado dd/mm/aa
	SET CENTURY ON // Ativa a exibição do ano com quatro dígitos .
	SET DELIMITERS ON // Exibe os delimitadores
	SET DELIMITERS TO "[]" // Cria delimitadores para os GETs
	CLS
	@ 5,5 SAY " Informe a data inicial : " GET dDataIni PICTURE "@K"
	@ 7,5 SAY " Informe a data final : " GET dDataFim
	@ 9,5 SAY " Digite 'PEDIDO ' para pedido ou 'NOTA ' para notas	fiscais : " GET cPedNot PICTURE "@K"
	READ
	? DataIni , dDataFim , cPedNot
return(True)