/*
Variavel data exibida corretamente
*/
procedure main
    local dVenc // Data vencimento
    dVenc := ctod ( "12/31/2021" ) //31 de dezembro de 2021 (mes, dia, ano)

    ? "Exibindo a data 31/12/2021"
    ? "O formato padrao e o americano (mes/dia/ano)"
    ? dVenc
    ?
    set date british //Exibe as data no formato dia/mes/ano
    ? "Exibe as datas no formato dia/mes/ano"
    ? "O vencimento da ultima parcela e em " , dVenc
    ?
    set century on //Ativa a exibica do ano com 4 digitos
    ? "Ativa a exibicao do ano com 4 digitos"
    ? "A mesma data acima com o ano com 4 digitos: " , dVenc 
    ?
    ? "Outros exempos com outras datas:"
    ? ctod ("26/08/1970")
    dVenc := ctod ( "26/09/1996" )
    ? dVenc
    dVenc := ctod ( "15/05/1999" )
    ? dVenc 

    set century off //data volta a ter o ano com 2 digitos
    ?
    ? "Data volta a ter o ano com 2 digitos"
    ? dVenc
	Read
return (True)