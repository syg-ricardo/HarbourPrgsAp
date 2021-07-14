/*
Variavel data
*/
PROCEDURE Main
    SET CENTURY ON //Deixa o ano com 4 digitos
    ? "Data no padrao americano - mes, dia e ano"
    ? "A data e 05 de junho de 2021"
    dvencimento := CTOD (" 06/05/2021 ") //Mostra a data no padrão americano - mes, dia e ano
    ? dvencimento
    // iniciando a data com o set correto
    set date british
    dvencimento2 := CTOD (" 06/05/2011 ")
    ? "Data no padrao britanico (usando set date british) - dia, mes e ano"
    ? "A data e 06 de maio de 2011"
    ? dvencimento2
return (True)
