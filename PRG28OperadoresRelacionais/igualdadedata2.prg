/*
    Operador de igualdade aplicado ao tipo de dado data
    Entrada: A data de hoje gerada por Date()
    Saida: Se hoje for o dia ou for menor emite um aviso
*/
#define data_limite 0d20210520
#define dias_aviso 10 //Emite um aviso com 10 dias ou menos
procedure Main

    set date british
    ? "Hoje e dia " , date()
    ? "A data limite e " , data_limite
    //Note que esta rotina nao tem dados de entrada
    //gerados pelo usuario
    //pois o dia de hoje e informado por Date()

    if date() > data_limite
        ? "Atencao !!! Passou da data do envio de dados."
        elseif date() < data_limite
            if (data_limite - date()) < 10
        ? "Esta chegando perto do dia limite"
        ?? " faltam" ,data_limite - date() , "dias"
            end if
        elseif date() == data_limite
        ? "lembrete especial: Hoje e o ultimo dia para enviar"
        ?? "os dados do balanco patrimonial."
    end if
return

