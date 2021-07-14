/*
Operador de maior e variavel logica
*/
procedure main
    local nNum1, nNum2 // Valores
    local lResultado // Resultado logico

    input "Informe o primeiro numero: " to nNum1
    input "Informe o segundo numero: " to nNum2

    lResultado := (nNum1 > nNum2)

    ? "A variavel nNum1 e maior  do que nNum2 ? " , lResultado 
return
