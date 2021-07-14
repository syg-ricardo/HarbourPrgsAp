/*
    @ ... SAY ... GET Simples
    Valida CPF / CNPJ usando o When
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
    @ 5,5 SAY " Informe o nome : " GET cNome
    @ 7,5 SAY " Informe o tipo (F ou J): " GET cTipo VALID UPPER (cTipo ) $ "FJ"
    @ 9,5 SAY " Informe o CPF : " GET cCPF WHEN UPPER ( cTipo ) == "F"
    @ 11 ,5 SAY " Informe o CNPJ : " GET cCnpj WHEN UPPER ( cTipo ) == "J"
    READ
    ? cNome
    IF UPPER ( cTipo ) == "F"
    ? " CPF : " , cCPF
    ELSE
    ? " CNPJ : " , cCNPJ
    ENDIF