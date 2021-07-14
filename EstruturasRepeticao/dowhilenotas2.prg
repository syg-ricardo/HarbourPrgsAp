/*
    Estruturas de controle de fluxo
    Programa para calculo da media da turma com repeticao
    controlada por sentinela
    Programa para receber a nota de n alunos e exibir a media da turma
    Entrada: N notas
    Saida: A media
*/
procedure main
    local nTotNotas // soma das notas
    local nNotaDig // Numero de notas digitadas
    local nNota // O valor de uma nota
    local nMedia // Media de notas

    // Inicializacao
    nTotNotas := 0
    nNotaDig := 0
    nNota := 0
    ? "Forneca a nota ou digite -1 para finalizar"
    input "Forneca a nota: " to nNota

    // Processamento
    do while ( nNota <> -1 ) // Repete enquanto nao for -1
        nTotNotas += nNota
        nNotaDig++
        input "Forneca a nota: " to nNota
    enddo

    // Fase de termino
    if ( nNota <> 0 )
        nMedia := nTotNotas / nNotaDig
        ? "A media geral e: " , nMedia
        ?
        ? "Quantidade de notas digitadas: " , nNotaDig
    else
        ? "Nenhuma nota foi digitada"
    end if
return


