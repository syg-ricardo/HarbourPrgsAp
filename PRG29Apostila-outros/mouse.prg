//Mouse
#include "inkey.ch"
procedure MAIN
    local dDataini := date()
    local dDatafim := date()
    local cPedNot := "PEDIDO"
    local GetList := {}

    //Configuração do mouse
    set eventmask to inkey_all // Mouse


    set date british //Exibe as datas no formato dia / mes / ano
    set century on //Ativa a exibição do ano com 4 dígitos
    set delimiters on // Exibe os delimitadores
    set delimiters to "[]" // Cria delimitadores para os gets
    cls 
    @ 5,5 say "Informe a data inicial: " get dDataini picture "OK"
    @ 7,5 say "Informe a data final: " get dDatafim 
    @ 9,5 say "Digite PEDIDO para pedido ou NOTA para notas fiscais: " get cPedNot picture "OK"
    read 

     ? dDataini, dDatafim, cPedNot
return