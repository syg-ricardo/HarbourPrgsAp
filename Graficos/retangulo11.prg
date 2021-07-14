/*
@ ... SAY ... GET simples - Usando máscaras
*/
PROCEDURE Main
LOCAL cNome := SPACE (20)
LOCAL cTipo := SPACE (1)
LOCAL cCPF := SPACE (11)
LOCAL cCNPJ := SPACE (15)
LOCAL GetList := {}

SET DELIMITERS ON // Exibe os delimitadores
SET DELIMITERS TO "[]" // Cria delimitadores para os GETs
CLS
@ 5,5 SAY " Informe o nome : " GET cNome PICTURE "@!" //O sinal de exclamacao força a entrada das letras maiusculas

@ 7,5 SAY " Informe o tipo (F ou J): " GET cTipo PICTURE "!" VALID cTipo $ "FJ"
@ 9,5 SAY " Informe o CPF : " GET cCPF PICTURE "@R 999.999.999 -99 " WHEN ( cTipo ) == "F" //O numero 9 obriga a entrada de numeros
@ 11 ,5 SAY " Informe o CNPJ : " GET cCnpj PICTURE "@R 9999999999 -9999 " WHEN ( cTipo ) == "J"//O @R nao deixa que pontos e tracos sejam gravados na variavel
READ
? cNome
IF ( cTipo ) == "F"
? " CPF : " , cCPF
ELSE
? " CNPJ : " , cCNPJ
ENDIF
RETURN