//Uso do comando INPUT
PROCEDURE Main 
    LOCAL nVal1 := 0 //Declara a variavel parcela de pagamento
    LOCAL nVal2 := 0 //Declara a variavel parcela de pagamento

    INPUT "Informe o primeiro valor: " TO nVal1 //O INPUT é usado para receber numeros, aceita caracteres,
    INPUT "Informe o segundo valor: " TO nVal2 //mas não é recomendado (para usar caracteres com o INPUT é
                                               // preciso colocar a variavel entre aspas).
                                               //EXEMPLO cNome:= "" -   INPUT "DIGITE O NOME: " TO "cNome"
    ? "A soma dos dois valores e: ", nVal1 + nVal2
RETURN 