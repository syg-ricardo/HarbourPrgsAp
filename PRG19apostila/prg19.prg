//descobre o numero antecessor e o sucessor
PROCEDURE Main 
    LOCAL nValor //Numero a ser inserido

    //Recebendo dados
    ? ""
    ? "*****Descobrindo o antecessor e o sucessor*****"
    ? ""
    INPUT "Digite o numero: " TO nValor 
    //Calculando e exibindo na tela
    ? "Antecessor: " , nValor - 1
    ? "Sucessor: " , nValor + 1
RETURN 