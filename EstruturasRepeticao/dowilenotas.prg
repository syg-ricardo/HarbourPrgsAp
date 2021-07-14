/*
    Estrutura de controle de fluxo
    Adaptada de (Deitel, 2001, pag.111)

    Programa para receber a nota de 10 alunos e 
    mostrar a media da turma

    Entrada: 10 notas
    Saidfa: A media
*/
#define qtd_alunos 10 // Qtde de iteracoes
procedure main
    local nTotNotas , ; // Soma das notas
          nNotaDig , ;  // Numero de notas digitadas
          nNota , ;     // O valor de uma nota
          nMedia     // Media de notas
   // Inicializacao
   nTotNotas := 0
   nNotaDig := 1 // Condicao de permanencia no laco

   // Processamento
   do while ( nNotaDig <= qtd_alunos) // Repete o numero de vezes de qtd_alunos
    input "Fonece a nota do aluno: " to nNota 
    nNotaDig ++
    nTotNotas += nNota
   end do

   // Fase de termino
   nMedia := nTotNotas / qtd_alunos
   ? rtrim("A media geral e ") , nMedia // Exibe a media
return
    


