/*
    Operadores relacionais: um resumo
*/
procedure main
    local x,y //Valores numericos
    local dData1, dData2 //Datas
    local cString1, cString2  // Caracteres

    set date brit // Data dd/mm/aa
    set century on // Ano comm 4 digitos

    ? "Comparando variaveis numericas"
    ?
    x := 2
    y := 3
    ? 'x := 2'
    ? 'y := 3'
    ? "x > y: " , x > y // Retorna falso (.f.)
    ? "y = 3: " , y = 3 // Retorna verdadeiro (.t.)
    ? "y <> x: " , y <> x // retorna verdadeiro (.t)
    ?
    ? "Comparando datas"
    ?
    dData1 := ctod("01/09/2015")
    dData2 := ctod("02/09/2015")
    ? 'dData1 := ctod("01/09/2015")'
    ? 'dData2 := ctod("02/09/2015")'
    ? "dData1 >= dData2 : " , dData1 >= dData2 // Retorna falso (.f.)
    ? "( dData1 + 1 ) = dData2: " , ( dData1 + 1) = dData2 //Retorna verdadeiro (.t.)
    ?
    ? "Comparando Strings"
    ?
    cString1 := "Vlademiro"
    cString2 := "Vlad"

    ? 'cString1 := "Vlademiro"'
    ? 'cString2 := "Vlad"'

    ? "cString1 == cString2: " , cString1 == cString2 // .f.

    /* Cuidado !! */
    /* Leia com atenção o tópico sobre comparacao de strings */
    ? "Cuidado com a comparacao abaixo. Ela e confusa por causa do = . "
    ? "cString1 == cString2: " , cString1 = cString2 // .t.
    ? "Use sempre o operador == no lugar de = ."
return
    