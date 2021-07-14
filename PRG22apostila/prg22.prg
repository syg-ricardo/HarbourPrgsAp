/*
    O codigo abaixo usando o operador (-) difere da tabuada de soma, pois e necessario evitar
    numeros negativos.
*/
PROCEDURE Main 
LOCAL nNumero
    ? "Tabuada (Subtracao)"
    INPUT "Informe um numero entre 1 e 9: " TO nNumero 

    ? "Subtracao"
    ? "---------"
    ? nNumero, " - " , nNumero, " = ", nNumero - nNumero
    ? nNumero + 1, " - ", nNumero, " = ", (nNumero + 1) - nNumero 
    ? nNumero + 2, " - ", nNumero, " = ", (nNumero + 2) - nNumero
    ? nNumero + 3, " - ", nNumero, " = ", (nNUmero + 3) - nNumero
    ? nNumero + 4, " - ", nNumero, " = ", (nNumero + 4) - nNumero
    ? nNumero + 5, " - ", nNumero, " = ", (nNumero + 5) - nNumero
    ? nNumero + 6, " - ", nNumero, " = ", (nNumero + 6) - nNumero
    ? nNumero + 7, " = ", nNumero, " = ", (nNumero + 7) - nNumero
    ? nNumero + 8, " = ", nNumero, " = ", (nNumero + 8) - nNumero
    ? nNumero + 9, " = ", nNumero, " = ", (nNumero + 9) - nNumero
RETURN 


