/*
As quatro operacoes
Entrada: dois numeros
Saida: as quatro operacoes realizadas com estes numeros
*/
PROCEDURE Main
    LOCAL nValor1, nValor2 //Valores a sere calculados

    //Recebendo Dados
    ? "Introduza dois numeros para que eu realize as quatro operacoes: "
    INPUT "Introduza o primeiro valor: " TO nValor1
    INPUT "Introduza o segundo valor: " TO nValor2

    //Calculando e exibindo
    ? "Soma............", nValor1 + nValor2
    ? "Subtracao.......", nValor1 - nValor2
    ? "Multiplicacao...", nValor1 * nValor2
    ? "Divisao.........", nValor1 / nValor2
RETURN 