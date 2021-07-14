//Manutencao de clientes (menu principal)
#define ultima_linha 23
#include "inkey.ch"
procedure MAIN
    local nOpc
    

    Config ()// Nova rotina
    Telainicial() // Nova rotina

    do while .t.
        @ 11,05 to 18,36 // Contorno do menu
        @ 06,39 to ultima_linha -3, maxcol() -3 //Contorno do box a direita do menu
        @ 11,07 say ".: Manutencao de clientes :."
        @ 12,10 prompt "        INCLUSAO    " message "Inclusao de usuarios"
        @ 13,10 prompt "        Alteracao   " message "Alteracao de usuarios"
        @ 14,10 prompt "        Exclusao    " message "Exclusao de usuarios"
        @ 15,10 prompt "        Listagem    " message "Listagem de usuarios"
        @ 17,10 prompt "        Sair        " message "Sair do sistema"
        menu to nOpc

        do case
            case nOpc == 1
                Inclui()
            case nOpc == 2
                Altera()
            case nOpc == 3
                Exclui()
            case nOpc == 4
                Lista()
            case nOpc == 5
                EXIT // Sai do laco e do programa endcase
              
        endcase
        @ 07,40 clear to ultima_linha -4, maxcol() -4 //Limpa o interior do box
    end do

return

//Inclusao de clientes
procedure inclui()

    @ 07,45 say "Inclusao de usuarios"
    @ 09,45 say "Tecle algo"
    Inkey(0) 
return

//Alteracao de clientes
procedure Altera()

    @ 07,45 say "Alteracao de usuarios"
    @ 09,45 say "Tecle algo"
    Inkey(0)
return

//Exclusao de clientes
procedure Exclui()

    @ 07,45 say "Exclusao de usuarios"
    @ 09,45 say "Tecle algo"
    inkey(0)
return

//Listagem de clientes
procedure Lista()

    @ 07,45 say "Listagem de usuarios"
    @ 09,45 say "Tecle algo"
    inkey(0)

return

/*
    Config() 
*/

procedure Config()
    
    set date british // Converte data para o formato dia/mes/ano
    set century on // Exibe o ano no formato de quatro digitos
    set delimiters on // Ativa delimitadores de GETs
    set delimiters to "[]" // Informa como serao os delimitadores
    set wrap on //Quando  usuario chegar no ultimo Prompt, passa para o primeiro
    set message to ultima_linha -1 center // Linha de mensagem do menu @ ... PROMPT
    set eventmask to INKEY_ALL // Mouse
return

/*
    Tela inicial
*/

procedure Telainicial()
    cls
    @ 0,0 to 3, maxcol()
    @ 1,3 say "Sistema para controle de usuarios"
    @ 1,maxcol() -15 say "Data: " + DToC( date() )
    @ 2,3 say "Cadastro de Clientes"

    @ 4,0 to ultima_linha, maxcol()
return 











