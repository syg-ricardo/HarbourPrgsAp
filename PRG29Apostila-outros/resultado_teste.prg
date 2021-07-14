/*
    Estrutura de controle de fluxo
    Analise de teste de resultados
    Adaptada de (DEITEL 2001 PG. 122)
*/
procedure MAIN
    local nPasses,; // Sucesso
          nFailures,; // Falhas
          nStudentConter,; // Estudantes
          nResult // Desempenho

    // Inicializacao
    nPasses := 0
    nFailures := 0
    nStudentConter := 1
    nResult := 0

    // Processamento
    Do While ( nStudentConter <= 10 ) //Repete enquanto nao for <= 10
    Input "Forneca o resultado (1 = aprovado, 2 = reprovado): " to nResult

        if (nResult == 1)
            nPasses++
        else
            nFailures++
        end if

        nStudentConter++
    enddo

    //Fase de termino
    ? "Aprovados: ", nPasses
    ? "Reprovados: ", nFailures

        if ( nPasses > 8)
            ?
            ? "Aumente o preco da mensalidade"
        end if
return



