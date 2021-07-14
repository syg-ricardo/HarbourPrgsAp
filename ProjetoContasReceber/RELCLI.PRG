//RELCLI.PRG
//A rotina RELCOD abre o arquivo indexado por codigo e aciona LISTACLI.
//Em ambos os casos o layout do relatório é o mesmo
//Procedure responsável pela impressão do relatório geral de clientes
//Procedure criada a parte para não deixar o MODCON.PRG maior ainda.
//Se preferir essa procedure pode ser incorporada ao MODCON.
Function Main()
    local op  
    telavelha = SaveScreen(04,01,21,79)
    MOLDURA(15,26,19,40,.T.,"LISTAR POR")
    @23,10 say space(60)
    do while .t.
        @16,27 prompt "NOME"message "LISTAGEM EM ORDEM ALFABETICA"
        @17,27 prompt "CODIDO"message "LISTAGEM POR ORDEM DE CODIGO"
        @18,27 PROMPT "RETORNA"message "VOLTA AO MENU ANTERIO"
        MENU TO op
        do case
            case op=1
                relnome()
            case op=2
                relcod()
            case op=3
                restscreen(04,01,21,79,telavelha)
            return
        end case
    end do

    procedure relnome
        if .not. abrearq("CLIENTES","INDNOMCL")
            MENSAGEM(23,10,"ARQUIVO DE CLIENTES NAO ENCONTRADO.ROTINA TERMINADA")
        end if
        titulo = "RELATORIO DE CLIENTES POR ORDEM ALFABETICA"
        nr="CR-002"
        listacli()

        procedure relcod
            if .not. abrearq("CLIENTES","INDCODCL")
                mensagem(23,10,"ARQUIVO DE CLIENTES NAO ENCONTRADO.ROTINA TERMINADA")
            end if
            titulo = "RELATORIO DE CLIENTES POR ORDEM DE CODIGO"
            nr="CR-002"
            listacli()

        procedure listacli(TITULO,nr)
            local p=0, lin=61
            @23,10 say "LISTANDO ARQUIVO DE CLIENTES"
            set device to printer 
            do while .not. eof()
                nr = "CR-002"
                if lin > 60
                    cabecger(titulo,nr)
                    cabeccli()
                end if
                detalhecli()
                skip 
            end do
            final()
            set device to screen 
            mensagem(23,10,"FINAL DO RELATORIO DE CLIENTES",2)

            procedure cabeccli
                @04,02 say "CODIGO          NOME"
                @05,10 say "ENDERECO"
                @06,05 say "CIDADE          ESTADO          CEP"
                @06,48 say "ULTIMA COMPRA       SITUACAO"
                @07,00 say Replicate("=",80)
                lin = 8
            return

            procedure detalhe
                @lin,03say condatcli
                @lin, 14 say nomecli
                @lin + 1,03 say endereco
                @lin + 2,03 say cidade 
                @lin + 2,30 say estado
                @lin + 2,39 say cep 
                @lin + 2,49 say ultcompra picture 'dd/dd/dd'
                @lin + 2,66 say if(situacao,"PONTUAL","COM ATRASOS")
                @lin + 3,0 say Replicate("- ",40)
                lin += 4
            return
        

Return
