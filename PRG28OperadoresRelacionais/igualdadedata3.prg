/*
    Operador de diferença aplicadoa um tipo de dado data
*/
#define data_da_operacao 0d20210520
procedure Main

    set date british
    ? "Hoje e " , date()
    ? "A data da operacao e " , data_da_operacao
    //Note que esta rotina nao tem dados de entrada
    //gerados pelo usuario, pois o dia
    //de hoje e informado por date()

    if date() <> data_da_operacao
        ? "Aviso importante !! Essa operacao nao pode ser realizada hoje"
    else
        ? "Rotina especial sendo executada agora"
        // Segue o hipotetico codigo a ser executado
        ? "Operacao realizada"
    end if
return 