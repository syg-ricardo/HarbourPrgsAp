/*
    Chamando rotinas de outros arquivos
*/
procedure main
    local cNome := space(20)
    local cTipo := space(1)
    local dNascimento := ctod("//") // Inicializa com uma data vazia
    local getlist := {}
    cls
    Config()// Chamar "rotinas.prg" na compilação
    @ 5,5 say "Informe o nome: " get cNome
    @ 7,5 say "Informe o tipo (F ou J): " GET cTipo valid upper( cTipo ) $ "FJ"
    read
return


