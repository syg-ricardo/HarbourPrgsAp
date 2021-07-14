/*
    Incremento decremento    
*/
PROCEDURE Main
    LOCAL nNum1, nNum2 //Valores numericos

    //Operador de pre incremento ++
    nNum1 := 0
    nNum2 := ++nNum1
    ? nNum1 // Vale 1
    ? nNUm2 // Vale 1

    //Operador de pos incremento ++
    //Inicio
    nNum1 := 0
    nNum2 := nNum1++
    ? nNum1 := 0 // Vale 1
    ? nNum2 := nNum1++ // Vale 0
    // fim

    //Operador de pre decremento --
    nNum1 := 1
    nNum2 := --nNum1
    ? nNum1 // Vale 0
    ? nNum2 // Vale 0

    //Operador de pos decremento --
    //Inicio
    nNum1 := 1
    nNum2 := nNum1--
    ? nNum1 //Vale 0
    ? nNum2 //Vale 1
    //fim

    //Os dis operadores em conjunto
    //inicio
    nNum1 := 1
    nNum2 := 5
    ? nNum1 -- * 2 + (++nNum2) //Mostra 8
    // O calculo efetuado foi:
    // 1 * 2 + 6
    // Mostra 8
     ? nNum1 // Vale 0
     ? nNum2 // Vale 6
     // fim
RETURN 







