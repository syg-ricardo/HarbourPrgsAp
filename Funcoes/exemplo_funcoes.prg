/*
    Exemplo de funcoes
*/
REQUEST HB_LANG_PT // Disponibiliza suporte a lingua portuguesa

procedure main
    local dData as Date

        set date british //Data no padrao dia, mes e ano

    dData := cTod ( "26/08/2016" )
    ? "O numero do mês correspondente e: " , Month ( dData )
    ? "O nome do mês correspondente e: " , cMonth ( dData )
    ? "O numero correspondente ao dia da semana e: " , DoW ( dData )
    ? "O dia da semana e: " , CDoW( dData )
    ? "O ano é " , Year( dData )
return  
