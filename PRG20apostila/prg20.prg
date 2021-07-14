//Calcula quantos numeros existem entre dois intervalo
//Somar tambem os numeros extremos
#define UNIDADE_COMPLEMENTER 1 //Deve ser adicionada ao resultado final
PROCEDURE Main 
    LOCAL nIni, nFim //Lmite inferior e superior
    LOCAL nQtd // Quantidade

    ? "Informa quantos numeros existem entre dois intervalos"
    ? "(Incluidos os numeros extremos)"
    INPUT "Informe o numero inicial: " TO nIni
    INPUT "informe o numero final: " TO nfim 
    nQtd := nFim - nIni + UNIDADE_COMPLEMENTER 
    ? "Entre os numeros ", nIni , " e " , nFim , " existem " , nQtd, " numeros"
RETURN 