#define ultima_linha 23
#include "inkey.ch"
/*
  Config (Esta rotina estará disponível para projetos futuros)
*/
procedure Config()
    set date british // Converte data para o formato dia/mes/ano
    set century on // Exibe o ano no formato de quatro digitos
    set delimiters on // Ativa delimitadores de GETs
    set delimiters to "[]" // Informa como serao os delimitadores
    set wrap on //Quando  usuario chegar no ultimo Prompt, passa para o primeiro
    set message to ultima_linha -1 center // Linha de mensagem do menu @ ... PROMPT
    set eventmask to INKEY_ALL // Mouse
return