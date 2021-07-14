# define DATA_LIMITE 0d20160915
PROCEDURE Main

SET DATE BRITISH
? " Hoje e " , DATE ()
? "A data limite e ", DATA_LIMITE
// Note que essa rotina não tem dados de entrada
// gerados pelo usuário
// pois o dia de hoje é informado por DATE ()
IF DATE () > DATA_LIMITE
? " Urgente !!! Passou do prazo de envio dos dados "
ELSEIF DATE () < DATA_LIMITE
? " Esta chegando perto do dia limite "
ELSEIF DATE () == DATA_LIMITE
? " Lembrete especial : hoje e o ultimo dia para enviar "
?? " os dados do balanço patrimonial ."
ENDIF
RETURN