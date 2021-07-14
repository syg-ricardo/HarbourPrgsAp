//CORES
#define PREJUIZO "N/R" // PRETO / VERMELHO
#define LUCRO "N/G" // PRETO / VERDE
PROCEDURE MAIN
    local nAvista := 0
    local nAprazo := 0
    local nDespesas := 0
    local nResultado
    local GetList := {}

    /*Padrão barras luminosas*/
    set color to "W/N" // BRANCO E PRETO
    cls 

    @ 8,8 to 16,55 double

    @ 10,10 say "Informe as vendas a vista: " get nAvista;
                 picture "@E 999,999.99" range 0,999999.99
    @ 12,10 say "Informe as vendas a prazo: " get nAprazo;
                 picture "@E 999,999.99" range 0,999999.99
    @ 14,10 say "Informe as despesas: " get nDespesas;
                 picture "@E 999,999.99" range 0,999999.99
    read 

    nResultado := (nAvista + nAprazo) - nDespesas
    if nResultado > 0
        @ 18,10 say "Lucro de :   " color LUCRO
    elseif nResultado < 0
        @ 18,10 say "Prejuizo de : " color PREJUIZO
    else
        @ 18,10 say "Resultado neutro: "
    end if

    @ 18,Col() + 1 say nResultado picture "@E 999,999.99"
    ?
    ? "Fim"
    ?
return
