FUNCTION MAIN()
    //Nome do arquivo: CRMENU.PRG
    //POR: EXTRAÍDO DO LIVRO CLIPPER 5.0 DO RAMALHO
    
    LOCAL empresa := "BLOGUEIRO SAMURAI"
    LOCAL sistema := "CONTAS A RECEBER"
    LOCAL OP := 0
    LOCAL MENU  := {{"FATURAS     ","MANUTENCAO DE FATURAS"      },;
                     {"CLIENTES   ","MANUTENCAO DO ARQUIVO DE CLIENTES"        },;
                     {"CONS/RELAT ","CONSULTA EM VIDEO E EMISSAO DE RELATORIOS"},;
                     {"UTILITARIOS","ROTINAS DE BACKUP E REINDEXACAO"          },;
                     {"FIM        ","RETORNA AO SISTEMA OPERACIONAL  "         }}
        SET SCOREBOARD OFF
        SET DATE BRITISH
        SET WRAP oN
        SET DELETED ON
        SET MESSAGE TO 23 CENTER
        SET KEY 28 TO AJUDA
        DO WHILE .T.
            TELAPADRAO(PROCNAME(), empresa, sistema)
            MONTAMENU(6, 5, aMENU)
            MENU TO OP
            DO CASE
                CASE OP == 1
                    //DO MODFAT
                    CASE OP == 2
                    //DO MODCLI
                    CASE OP == 3
                    //DO MODCON
                    CASE OP == 4
                    //DO MODUTI
                    CASE OP == 5
            IF CONFIRMA("ABANDONA O SISTEMA") == 1
                EXIT
            ENDIF
        ENDCASE
            ENDDO
        RETURN .T.
    FUNCTION MONTAMENU (LS, cs, aMENU)
        LOCAL I := 0
        LOCAL retangulo :=  CHR(213)+CHR(205)+CHR(184)+CHR(179)+;
        CHR(190)+CHR(205)+CHR(212)+CHR(179)+CHR(32)
        @ls,cs,ls+LEN(aMENU)+1,cs+LEN(aMENU [1,1])+1 box retangulo
        FOR I=1 TO LEN(aMENU)
        @ls+i,cs+1 PROMPT aMENU [I,1] message aMENU [1,2]
    NEXT
RETURN nil
FUNCTION CONFIRMA(TEXTO)
    LOCAL les, ces, largjan, telavelha
    LOCAL corantg, corova, coluna
    LOCAL CONFIRM
    largjan := LEN(TEXTO)+2
    IF largjan < 16
        largjan := 16
    ENDIF
    ces=(80-largjan)/2
    les=19
    telavelha=SAVESCREEN(les,0,les+4,79)
    corantg=SETCOLOR()
    corova="W/B,N/W"
    SET COLOR TO %CORNOVA
    @les,ces CLEAR TO les+3,ces+largjan
    @les,ces TO les+3,ces+largjan double
    @les+1,ces+2 SAY texto
    coluna=(largjan-9)/2
    @les+2,ces+coluna PROMPT "Sim"
    @les+2,ces+coluna+6 PROMPT "Nao"
    MENU TO CONFIRM 
    SET COLOR TO &CORANTIG
    RESTSCREEN(les,0,les+4,79,telavelha)
RETURN(CONFIRM)
FUNCTION TELAPADRAO(programa, empresa, sistema)
    CLS
    @0,0 TO 3,39 double
    @0,40 TO 3,79 double
    @4,0,21,79 BOX replicate(chr(176),9)
    @4,0 TO 24,79 double
    @1,1 SAY empresa
    @1,41 SAY sistema
    @1,73 say left(time(),5)
    @2,41 say programa
    @2,70 SAY  DATE()
    @23,1 SAY "MENSAGEM:"
RETURN nil