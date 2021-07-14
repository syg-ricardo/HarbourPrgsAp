/*
    Desenhando um retangulo na tela (segundo exemplo)
*/
#include "box.ch"
procedure main
    local nLinTop, nColEsq, nLinBase, nColDir // Coordenadas

        nColEsq := 1
        nColDir := 20
        nLinTop := 1
        nLinBase := nLinTop + 5

        @ nLinTop, nColEsq, nLinBase, nColDir box B_SINGLE

        nLintop := nLinTop + 7
        nLinBase := nlintop + 5
        @ nLinTop, nColEsq, nLinBase, nColDir box B_DOUBLE

        nLinTop := nLinTop + 7
        nLinBase := nLinTop + 5
        @ nLinTop, nColEsq, nLinBase, nColDir box B_DOUBLE_SINGLE

        nLinTop := nLinTop + 7
        nLinBase := nLinTop + 5
        @ nLinTop, nColEsq, nLinBase, nColDir box B_DOUBLE_SINGLE
return