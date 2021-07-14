/*
@ ... SAY ... GET simples
*/
PROCEDURE Main
LOCAL nNota := 0
LOCAL dData := DATE ()
LOCAL GetList := {}

SET DATE BRITISH // Exibe dadas no formado dd/mm/aa
SET CENTURY ON // Ativa a exibição do ano com quatro dígitos .
SET DELIMITERS ON // Exibe os delimitadores
SET DELIMITERS TO "[]" // Cria delimitadores para os GETs
CLS
@ 5,5 SAY " Informe a nota : " GET nNota RANGE 0 , 10
@ 7,5 SAY " Informa a data da prova : " GET dData RANGE
DATE () -10, DATE () +10
READ

? nNota , dData

RETURN