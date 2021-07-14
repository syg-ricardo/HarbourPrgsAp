*  Sistema.....: ZIUL - Sistema de Cobranca
*  Programador.: Nando                                                  
*  Data........: 27/04/04                                                 
*  Programa....: BOLET.PRG
*  Descricao...: Emissao de notas e boletas de cobranca bancaria
*  Alteracao...: V. harbour
*  Data........:                                                  
*  Rotinas.....: Lista resumo, Todos recibos s/n, Bol. selec.,
*                Todas etiq., Etiq. selec., Lista cli, Manut. arqs.
*
*-------------------------------------------------------------------------
* Documentacao.:
*    Todas as Etiquetas: CLI_ENDCOR  = 1 -> Imprime endereco de ENDCOR.DBF
*                        CLI_SEMETIQ = 1 -> Nao imprime etiqueta
*    Todas as notas fiscais: CLI_ENDCOR = 2 -> Nao imprime NF
*                            CLI_TIPO = ' ' -> Filtro. So imprime estas NF
*                            Grava num. NF em CLI_NFISC
*    ITAU Todas: Pega num. NF de CLI_NFISC  
*    Todos os recibos dos sem nota: CLI_TIPO = 's' -> Imprime
*-------------------------------------------------------------------------
*
******************** CONTROLE DE EMISSAO DE BOLETAS ********************
*---------------*
 Function main()
*---------------*
setmode(25,80)
cImpPadrao := GetDefaultPrinter() 
*
sele 1
     use CLIENTES
     set dele on
     index on CLI_FANTAS to ICLIEN
     index on CLI_CODIGO to ICOD
     set index to ICLIEN, ICOD
*
sele 2
     use ENDCOR
     set dele on
     index on ENC_CODIGO to IENDCOR
*
sele 3
     use SERV_ADI
     set dele on
     index on SAD_CODIGO to IADIC
     index on SAD_FANTAS to IFANTAS
     index on SAD_VALORD + SAD_FANTAS to IVALFAN
     set index to IADIC, IFANTAS, IVALFAN
*
sele 4
     use DESATIV
*
sele 6
     use LEIAME
*
sele 7
     use WMOST
*
sele 8
     use AVULSAS
     set dele on
*
sele 9
     use NOTAS
     index on str(NOT_NUMERO,6) + NOT_PARCEL to INOTAS  
     index on NOT_BOLETO to INOTAS1  
     index on NOT_FANTAS to INOTAS2  
     index on str(NOT_BOLETO,6) + NOT_PARCEL to INOTAS3 
     use NOTAS index INOTAS, INOTAS1, INOTAS2, INOTAS3
     set dele on
*
sele 10
     use ITNOTA
     index on ITN_NUMERO to ITNOTA  
     set dele on
*
sele 11
     use COD_SERV
*
sele 12
     use CLI_NCAD
     index on CLN_CGC to CGCNCAD
*
sele 13
     use RASGADOS
     index on RAS_NUMERO to IRASG
*
* Area 14
*  Usada para abrir MOV_REC
*
* Area 15
*  Usada para abrir ARQ_REC
*
* Area 16
*  Usada para abrir IPCA / COD_OCOR
*
sele CLIENTES
TTAB      :=  9
TESC      := 27
TENTER    := 13
PGDN      :=  3
SETA_CIMA := 5
F2        := -1
F3        := -2
F4        := -3
PGUP      := 18
CFG_CMSG  := 'w/b+'
CFG_TMSG  := 160
CFGEDGER  := 'W+/N+'
CFGEDTIT  := 'N+/W+'
CFGMNNOR  := 'W+/N+'
CFGMNTIT  := 'I/R+'
CFG_IMPRE := 'HP'
set color to n/gb
set date british
set epoch to 1990
set scoreboard off
*
PROX_ATIV  := 'V H.04'
REGISTRO   := 0
USCODIGO   := space(10)
NOMEMODULO := 'infoPDV'
ARQEMP     := 'ZIUL Informatica Ltda'
MDATA      := date()
MTURNO     := ' '
*
decl CAMPOS[2]
     CAMPOS[1] := 'CLI_FANTAS'
     CAMPOS[2] := 'CLI_NOME'
decl FORMATOS[2]
     FORMATOS[1] := ''
     FORMATOS[2] := ''
decl TITULOS[2]
     TITULOS[1] := 'CLIENTE'
     TITULOS[2] := 'NOME'
*
decl CAMPOS2[11]
     CAMPOS2[ 1] = 'NOT_BOLETO'
     CAMPOS2[ 2] = 'NOT_NUMERO'
     CAMPOS2[ 3] = 'NOT_PAGO'
     CAMPOS2[ 4] = 'NOT_VALOR'
     CAMPOS2[ 5] = 'NOT_VENCIM'
     CAMPOS2[ 6] = 'NOT_PARCEL'
     CAMPOS2[ 7] = 'NOT_CANCEL'
     CAMPOS2[ 8] = 'NOT_CLIEN'
     CAMPOS2[ 9] = 'NOT_FANTAS'
     CAMPOS2[10] = 'NOT_DATA'
     CAMPOS2[11] = 'NOT_TIPO'
decl FORMATOS2[11]
     FORMATOS2[ 1] = '@E 999,999'
     FORMATOS2[ 2] = '@E 999,999'
     FORMATOS2[ 3] = ''
     FORMATOS2[ 4] = '@E 999,999.99'
     FORMATOS2[ 5] = ''
     FORMATOS2[ 6] = ''
     FORMATOS2[ 7] = ''
     FORMATOS2[ 8] = '@E 99,999'
     FORMATOS2[ 9] = ''
     FORMATOS2[10] = ''
     FORMATOS2[11] = ''
decl TITULOS2[11]
     TITULOS2[ 1] = 'BOLETO'
     TITULOS2[ 2] = 'N FISC.'
     TITULOS2[ 3] = 'PG'
     TITULOS2[ 4] = 'VALOR'
     TITULOS2[ 5] = 'VENCIM'
     TITULOS2[ 6] = 'PARC'
     TITULOS2[ 7] = 'CANC'
     TITULOS2[ 8] = 'CLIEN'
     TITULOS2[ 9] = 'FANTASIA'
     TITULOS2[10] = 'DATA'
     TITULOS2[11] = 'TIPO'
*
decl CAMPOS3[10]
     CAMPOS3[ 1] = 'NOT_ATRAZ'
     CAMPOS3[ 2] = 'NOT_FANTAS'
     CAMPOS3[ 3] = 'NOT_BOLETO'
     CAMPOS3[ 4] = 'NOT_NUMERO'
     CAMPOS3[ 5] = 'NOT_VALOR'
     CAMPOS3[ 6] = 'NOT_VENCIM'
     CAMPOS3[ 7] = 'NOT_PARCEL'
     CAMPOS3[ 8] = 'NOT_CLIEN'
     CAMPOS3[ 9] = 'NOT_DATA'
     CAMPOS3[10] = 'NOT_TIPO'
decl FORMATOS3[10]
     FORMATOS3[ 1] = ''
     FORMATOS3[ 2] = ''
     FORMATOS3[ 3] = '@E 999,999'
     FORMATOS3[ 4] = '@E 999,999'
     FORMATOS3[ 5] = '@E 999,999.99'
     FORMATOS3[ 6] = ''
     FORMATOS3[ 7] = ''
     FORMATOS3[ 8] = '@E 99,999'
     FORMATOS3[ 9] = ''
     FORMATOS3[10] = ''
decl TITULOS3[10]
     TITULOS3[ 1] = 'V'
     TITULOS3[ 2] = 'CLIENTE'
     TITULOS3[ 3] = 'BOLETO'
     TITULOS3[ 4] = 'N FISC.'
     TITULOS3[ 5] = 'VALOR'
     TITULOS3[ 6] = 'VENCIM'
     TITULOS3[ 7] = 'PARC'
     TITULOS3[ 8] = 'CODCLI'
     TITULOS3[ 9] = 'DATA'
     TITULOS3[10] = 'TIPO'
*
decl CAMPOS4[2]
     CAMPOS4[1] = 'SER_CODIGO'
     CAMPOS4[2] = 'SER_DESCRI'
decl FORMATOS4[2]
     FORMATOS4[1] = ''
     FORMATOS4[2] = ''
decl TITULOS4[2]
     TITULOS4[1] = 'CODIGO'
     TITULOS4[2] = 'SERVICO'
*
decl CAMPOS5[10]
     CAMPOS5[ 1] = 'NOT_ATRAZ'
     CAMPOS5[ 2] = 'NOT_FANTAS'
     CAMPOS5[ 3] = 'NOT_BOLETO'
     CAMPOS5[ 4] = 'NOT_NUMERO'
     CAMPOS5[ 5] = 'NOT_VALOR'
     CAMPOS5[ 6] = 'NOT_VENCIM'
     CAMPOS5[ 7] = 'NOT_PARCEL'
     CAMPOS5[ 8] = 'NOT_PAGO'
     CAMPOS5[ 9] = 'NOT_DATA'
     CAMPOS5[10] = 'NOT_TIPO'
decl FORMATOS5[10]
     FORMATOS5[ 1] = ''
     FORMATOS5[ 2] = ''
     FORMATOS5[ 3] = '@E 999,999'
     FORMATOS5[ 4] = '@E 999,999'
     FORMATOS5[ 5] = '@E 999,999.99'
     FORMATOS5[ 6] = ''
     FORMATOS5[ 7] = ''
     FORMATOS5[ 8] = ''
     FORMATOS5[ 9] = ''
     FORMATOS5[10] = ''
decl TITULOS5[10]
     TITULOS5[ 1] = 'V'
     TITULOS5[ 2] = 'CLIENTE'
     TITULOS5[ 3] = 'BOLETO'
     TITULOS5[ 4] = 'N FISC.'
     TITULOS5[ 5] = 'VALOR'
     TITULOS5[ 6] = 'VENCIM'
     TITULOS5[ 7] = 'PARC'
     TITULOS5[ 8] = 'PAGO'
     TITULOS5[ 9] = 'DATA'
     TITULOS5[10] = 'TIPO'
*
decl MESES[12]
     MESES[01] := 'JAN'
     MESES[02] := 'FEV'
     MESES[03] := 'MAR'
     MESES[04] := 'ABR'
     MESES[05] := 'MAI'
     MESES[06] := 'JUN'
     MESES[07] := 'JUL'
     MESES[08] := 'AGO'
     MESES[09] := 'SET'
     MESES[10] := 'OUT'
     MESES[11] := 'NOV'
     MESES[12] := 'DEZ'
*
WNUM_NOTA = 0
CH_VENCIM = ' '
do while .t.
   TL_CABEC = 'Cobranca Ziul'
   P1TELA3()
   RODAPE(01)
   set color to n/bg
   @ 02,01 clear to 22,78
   set wrap on
   MENUT = 1
   @ 02,02 to 22,41 double
   @ 02,42 to 12,77 double
   @ 03,03 prompt "Imprime LISTA RESUMO                  "
   @ 04,03 prompt "Grava arquivo TXT com RPS's emitidos  "
   @ 05,03 prompt "RPS Todos (Cobran‡a)                  " 
   @ 06,03 prompt "RPS Avulsos                           " 
   @ 07,03 prompt "RPS Impressao                         " 
   @ 08,03 prompt "NOTAS FISCAIS de Venda de Mercadorias "
   @ 09,03 prompt "NOTAS FISCAIS/RPS Cancelamento        " 
   @ 10,03 prompt "NOTAS FISCAIS/RPS Pagamento           " 
   @ 11,03 prompt "NOTAS FISCAIS/RPS Exclusao            " 
   @ 12,03 prompt "NOTAS FISCAIS/RPS em Aberto           " 
   @ 13,03 prompt "Imprime LISTA de CLIENTES             "
   @ 14,03 prompt "MANUTENCAO dos arquivos               "
   @ 15,03 prompt "Browse CLIENTES                       "
   @ 16,03 prompt "Consulta TODAS DO CLIENTE             "
   @ 03,43 prompt "Grava arquivo Cobranca ITAU       "
   @ 04,43 prompt "Le arquivo Cobranca ITAU          "
   @ 05,43 prompt "BOLETOS Todos ITAU                "
   @ 06,43 prompt "BOLETOS Selecionados ITAU         "
   @ 07,43 prompt "BOLETOS Reemissao ITAU            "
   @ 08,43 prompt "GRAVA DADOS p/ BOLETOS POR E-MAIL "
   @ 09,43 prompt "Envia BOLETOS POR E-MAIL          "
   @ 10,43 prompt "Reajuste pelo IPCA                "
   @ 11,43 prompt "Instrucoes                        "
   *
   menu to menuT
   if lastkey() = TESC
      OK = 'N'
      P2OKSN('Encerra')
      if OK = 'N'
         loop
         endif
      *
      set color to
      clear screen
      return
      endif
   *
   @ 02,01 clear to 22,78
   do case
      *
      ******************************************************************
      * Imprime LISTA RESUMO *******************************************
      case menuT = 1
           OK = 'S'
           P2OKSN('Imprime relatorio')
           if OK = 'N'
              loop
              endif
           *
           LISTA_RESUMO()
      *
      ******************************************************************
      * Grava arquivo TXT com RPS's emitidos ***************************
      case menuT = 2
           sele NOTAS
           set filter to NOT_TIPO = 'S'
           go bottom
           MNOTA_FIN = NOT_NUMERO
           if NOT_GRAVOU = '1'
              MSG_ERRO('Nenhum RPS pendente para gravacao! tecle ENTER')
              loop
              endif
           *
           do while NOT_GRAVOU = ' ' .and. !bof()
              skip -1
              enddo
           *
           if bof()
              go top
              else
                skip
              endif
           *
           MNOTA_INI = NOT_NUMERO
           SAI = .f.
           @ 05, 05 say 'Nota inicial:' get MNOTA_INI pict '@E 999,999'
           clear gets
           do while .t.
              @ 06, 05 say 'Nota final..:' get MNOTA_FIN pict '@E 999,999'
              read
              if lastkey() = TESC
                 SAI = .t.
                 exit
                 endif
              *
              OK = 'S'
              P2OKSN('Confirma')
              if OK = 'N'
                 loop
                 endif
              *
              sele NOTAS
              seek str(MNOTA_INI,6)
              if !found()
                 MSG_ERRO('Nota inicial nao encontrada! Tecle ENTER')
                 loop
                 endif
              *
              WDATA_INI = dtos(NOT_DATA)
              seek str(MNOTA_FIN,6)
              if !found()
                 MSG_ERRO('Nota final nao encontrada! Tecle ENTER')
                 loop
                 endif
              *
              WDATA_FIN = dtos(NOT_DATA)
              exit
              enddo
           *
           if SAI
              loop
              endif
           *
           * Grava TXT
           * *********
           W0 = left(dtos(date()),6)
           for I1 = 1 to 99
               W1 = strzero(I1,2) + '.TXT'
               WARQ_TXT = W0 + W1 
               if !file(WARQ_TXT)
                  exit
                  endif
               next I1
           *
           NUM_ARQ := fcreate(WARQ_TXT,0)
           if NUM_ARQ = -1  && Deu erro
              MSG_ERRO('Problemas ao criar arquivo ' + WARQ_TXT +;
                       '! Tecle ENTER.')
              loop
              endif
           *
           fclose(NUM_ARQ)
           NUM_ARQ := fopen(WARQ_TXT,2)
           if NUM_ARQ = -1  && Deu erro
              MSG_ERRO('Problemas ao abrir arquivo ' + WARQ_TXT +;
                       '! Tecle ENTER.')
              loop
              endif
           *
           CRLF = chr(13) + chr(10)
           * Registro Tipo 10
           * ****************
           WPESSOA = '2'
           WCNPJ   = '03211838000112'
           WIM     = '000000002574772'
           WVERSAO = '003'
           REG = '10' + WVERSAO   + WPESSOA + WCNPJ + WIM + WDATA_INI +;
                        WDATA_FIN + CRLF
           POS = 0
           fseek(NUM_ARQ,POS)
           RET := fwrite(NUM_ARQ, REG, 53) 
           if RET # 53
              MSG_ERRO('ERRO ao gravar arquivo ARQTXT! Tecle ENTER.')
              fclose(NUM_ARQ)
              loop
              endif
           *
           POS = 53
           REG_TIPO20 = 0
           *
           * Registro Tipo 20
           * ****************
           sele NOTAS
           seek str(MNOTA_INI,6)
           TUDO_OK   = .t.
           TOT_SERV  = 0.00
           TOT_ISS   = 0.00
           do while NOT_NUMERO <= MNOTA_FIN .and. !eof()
              STAT_NOTA = '1'
              REG = '20' + '0' + '     '
              REG = REG + strzero(NOT_NUMERO,15) + dtos(NOT_DATA) +;
                          STAT_NOTA
              if NOT_CLIEN = 99999
                 * Cliente nao cadastrado
                 * **********************
                 sele CLI_NCAD
                 seek NOTAS->NOT_CGC
                 if eof()
                    MSG_ERRO('Nota para cliente nao encontrado! Tecle ENTER')
                    TUDO_OK = .f.
                    exit
                    endif
                 *
                 W0 = trim(CLN_CGC)
                 if len(W0) = 11
                    WPESSOA = '1'
                    else
                      WPESSOA = '2'
                    endif
                 *
                 REG = REG + WPESSOA + repl('0', 14-len(W0)) + W0
                 if CLN_CIDADE = 'RIO DE JANEIRO'
                    REG = REG + CLN_IM + space(7)
                    *WTRIB = '01'
                    else
                      REG = REG + space(15)
                      *WTRIB = '02'
                    endif
                 *
                 WTRIB = '01'
                 W0 = trim(CLN_IE)
                 REG = REG + repl('0', 15-len(W0))  + W0 + CLN_NOME + space(75) +;
                             CLN_TIPOEN + CLN_ENDER  + space(85)
                 if CLN_NUMERO > 0
                    W0 = alltrim(str(CLN_NUMERO,6))
                    W1 = W0 + space(10-len(W0))
                    else
                      W1 = space(10)
                    endif
                 *
                 REG = REG + W1 + CLN_COMPL + space(40) + CLN_BAIRRO      +;
                       space(47) + CLN_CIDADE + space(25) + CLN_UF + CLN_CEP
                 *(99)9999-9999
                 W0 = substr(CLN_TELEFO,2,2) + '-' +;
                      substr(CLN_TELEFO,5,4) + substr(CLN_TELEFO,10,4)
                 REG = REG + W0 + CLN_EMAIL + WTRIB +;
                             CLN_CIDADE + space(25) + CLN_UF
                 else
                   * Cliente cadastrado
                   * ******************
                   sele CLIENTES
                   set order to 2
                   seek NOTAS->NOT_CLIEN
                   set order to 1
                   if eof()
                      MSG_ERRO('Nota para cliente nao encontrado! Tecle ENTER')
                      TUDO_OK = .f.
                      exit
                      endif
                   *
                   W0 = trim(CLI_CGC)
                   if len(W0) = 11
                      WPESSOA = '1'
                      else
                        WPESSOA = '2'
                      endif
                   *
                   REG = REG + WPESSOA + repl('0', 14-len(W0)) + W0
                   if CLI_CIDADE = 'RIO DE JANEIRO'
                      REG = REG + CLI_IM + space(7)
                      *WTRIB = '01'
                      else
                        REG = REG + space(15)
                        *WTRIB = '02'
                      endif
                   *
                   WTRIB = '01'
                   W0 = trim(CLI_IE)
                   REG = REG + repl('0', 15-len(W0))  + W0 + CLI_NOME + space(75) +;
                               CLI_TIPOEN + CLI_ENDER  + space(85)
                   if CLI_NUMERO > 0
                      W0 = alltrim(str(CLI_NUMERO,6))
                      W1 = W0 + space(10-len(W0))
                      else
                        W1 = space(10)
                      endif
                   *
                   REG = REG + W1 + CLI_COMPL + space(40) + CLI_BAIRRO     +;
                               space(47) + CLI_CIDADE + space(25) + CLI_UF +;
                          CLI_CEP
                   *
                   W0 = substr(CLI_TELEFO,2,2) + '-' +;
                        substr(CLI_TELEFO,5,4) + substr(CLI_TELEFO,10,4)
                   REG = REG + W0 + CLI_EMAIL + WTRIB +;
                               CLI_CIDADE + space(25) + CLI_UF
                 endif
              *
              sele NOTAS
              WREG_ESP   = '00'
              OPC_SIMPL  = '1'
              INC_CULTUR = '0'
              COD_SV_FED = left(NOT_CDSVMU,2) + substr(NOT_CDSVMU,4,2)
              COD_SV_MUN = COD_SV_FED + right(NOT_CDSVMU,2) + space(14)
              ALIQUOTA   = '00500'
              W0         = strzero(NOT_VALOR,16,2)
              VL_NOTA    = left(W0,13) + right(W0,2)
              TOT_SERV   = TOT_SERV + NOT_VALOR
              VL_DEDUCAO = '000000000000000'
              VL_DESC_CO = '000000000000000'
              VL_DESC_IN = '000000000000000'
              VL_COFINS  = '000000000000000'
              VL_CSLL    = '000000000000000'
              VL_INSS    = '000000000000000'
              VL_IRPJ    = '000000000000000'
              VL_PIS_PSP = '000000000000000'
              VL_OU_RFED = '000000000000000'
              W0         = round(NOT_VALOR*0.05,2)
              TOT_ISS    = TOT_ISS + W0  
              W1         = strzero(NOT_VALOR*0.05,16,2)
              VL_ISS     = left(W1,13) + right(W1,2)
              ISS_RETIDO = '0'
              REG = REG + WREG_ESP   + OPC_SIMPL  + INC_CULTUR + COD_SV_FED +;
                          COD_SV_MUN + ALIQUOTA   + VL_NOTA    + VL_DEDUCAO +;
                          VL_DESC_CO + VL_DESC_IN + VL_COFINS  + VL_CSLL    +;
                          VL_INSS    + VL_IRPJ    + VL_PIS_PSP + VL_OU_RFED +;
                          VL_ISS     + ISS_RETIDO 
              *
              DATA_COMP = dtos(NOT_DATA)
              COD_OBRA  = space(15)
              ANOT_RESP = space(15)
              SER_RPS_SB = '     '
              NUM_RPS_SB = '000000000000000'
              RESERVADO  = space(30)
              REG = REG + DATA_COMP  + COD_OBRA   + ANOT_RESP + SER_RPS_SB +;
                          NUM_RPS_SB + RESERVADO
              *
              MNOTA = NOT_NUMERO
              sele ITNOTA
              seek MNOTA
              if eof()
                 MSG_ERRO('Nota sem itens lancados! Tecle ENTER')
                 TUDO_OK = .f.
                 exit
                 endif
              *
              DESCR = trim(ITN_PROD)
              skip
              do while ITN_NUMERO = MNOTA
                 DESCR = DESCR + '|' + trim(ITN_PROD)
                 skip
                 enddo
              *
              REG  = REG + DESCR + CRLF
              WTAM = len(REG)
              fseek(NUM_ARQ,POS)
              RET := fwrite(NUM_ARQ, REG, WTAM) 
              if RET # WTAM
                 MSG_ERRO('ERRO ao gravar arquivo ARQTXT! Tecle ENTER.')
                 TUDO_OK = .f.
                 exit
                 endif
              *
              POS = POS + WTAM
              REG_TIPO20++
              sele NOTAS
              skip
              enddo
           *
           if TUDO_OK
              * Registro Tipo 90
              * ****************
              WNUM_LIN   = strzero(REG_TIPO20,8)
              W0         = strzero(TOT_SERV,16,2)
              WTOT_SERV  = left(W0,13) + right(W0,2)
              WTOT_DEDU  = '000000000000000'
              WTOT_DESCO = '000000000000000'
              WTOT_DESIN = '000000000000000'
              W0         = strzero(TOT_ISS,16,2)
              WTOT_ISS   = left(W0,13) + right(W0,2)
              REG = '90' + WNUM_LIN   + WTOT_SERV + WTOT_DEDU + WTOT_DESCO +;
                           WTOT_DESIN + WTOT_ISS  + CRLF
              fseek(NUM_ARQ,POS)
              RET := fwrite(NUM_ARQ, REG, 87) 
              if RET # 87
                 MSG_ERRO('ERRO ao gravar arquivo ARQTXT! Tecle ENTER.')
                 fclose(NUM_ARQ)
                 TUDO_OK = .f.
                 endif
              endif
           *
           fclose(NUM_ARQ)
           if TUDO_OK
              MSG('Arquivo com notas gravado!')
              sele NOTAS
              seek str(MNOTA_INI,6)
              do while NOT_NUMERO <= MNOTA_FIN .and. !eof()
                 repla NOT_GRAVOU with '1'
                 skip
                 enddo
              *
              IMPR_RESUMO()
              else
                alert('Arquivo gravado com ERROS!')
              endif
           *
           sele NOTAS
           set filter to
      *
      ******************************************************************
      * RPS Todos (Cobranca) *******************************************
      case menuT = 3
           NOTAS_TODAS()
      *
      ******************************************************************
      * RPS Avulsos ****************************************************
      case menuT = 4
           NOTAS_AVUL()
      *
      ******************************************************************
      * RPS Impressao **************************************************
      case menuT = 5
        set color to n/bg
        do while .t.
           @ 02,01 clear to 22,78
           set wrap on
           MENUI = 1
           @ 02,02 to 05,23 double
           @ 03,03 prompt "Imprime 1 RPS       "
           @ 04,03 prompt "Imprime varios RPS's"
           menu to MENUI
           if lastkey() = TESC
              OK = 'N'
              P2OKSN('Encerra')
              if OK = 'N'
                 loop
                 else
                   exit
                 endif
              endif
           *
           @ 02,01 clear to 22,78
           if MENUI = 1
              * ********************************************************
              * Imprime 1 RPS
              * *************
              sele NOTAS
              WNUM_NOTA = 0
              SAIU = .f.
              do while .t.
                 @ 05, 02 say 'Numero do RPS .....:' get WNUM_NOTA;
                          pict '@E 999,999' valid WNUM_NOTA > 0
                 read
                 if lastkey() = TESC
                    SAIU = .t.
                    exit
                    endif
                 *
                 seek str(WNUM_NOTA,6)
                 if eof() .or. NOT_TIPO <> 'S'
                    MSG_ERRO('RPS nao lan‡ado! Tecle ENTER')
                    loop
                    endif
                 *
                 WCDSVMU  = NOT_CDSVMU
                 WTOT     = NOT_VALOR
                 DT_EMISS = NOT_DATA
                 if NOT_CLIEN = 99999
                    WCGC = NOT_CGC
                    if len(trim(WCGC)) = 11
                       WPESSOA = 'F'
                       else
                         WPESSOA = 'J'
                       endif
                    *
                    sele CLI_NCAD
                    seek WCGC
                    if eof()
                       alert('ERRO 01 - CPF/CNPJ nao encontrado em CLI_NCAD!')
                       loop
                       endif
                    *
                    * Pega dados para impressao do RPS
                    WCOD     = 99999
                    WNOME    = CLN_NOME
                    WTIPOEND = CLN_TIPOEND
                    WENDER   = CLN_ENDER
                    WNUMERO  = CLN_NUMERO
                    WCOMPLE  = CLN_COMPL
                    WBAIRRO  = CLN_BAIRRO
                    WCIDADE  = CLN_CIDADE
                    WUF      = CLN_UF    
                    WCEP     = left(CLN_CEP,5) + '-' + right(CLN_CEP,3)
                    WCGC     = CLN_CGC   
                    WIE      = CLN_IE
                    WIM      = CLN_IM
                    WTELEF   = left(CLN_TELEFO,13)
                    WEMAIL   = left(CLN_EMAIL,32)
                    else
                      sele CLIENTES
                      set order to 2
                      seek NOTAS->NOT_CLIEN
                      if !found()
                         alert('ERRO - Cliente do RPS nao cadastrado! Tecle ENTER')
                         set order to 1
                         loop
                         endif
                      *
                      set order to 1
                      WCOD     = CLI_CODIGO
                      WNOME    = CLI_NOME
                      WTIPOEND = CLI_TIPOEND
                      WENDER   = CLI_ENDER
                      WNUMERO  = CLI_NUMERO
                      WCOMPLE  = CLI_COMPL
                      WBAIRRO  = CLI_BAIRRO
                      WCIDADE  = CLI_CIDADE
                      WUF      = CLI_UF    
                      WCEP     = left(CLI_CEP,5) + '-' + right(CLI_CEP,3)
                      WCGC     = CLI_CGC   
                      WIE      = CLI_IE
                      WIM      = CLI_IM
                      WTELEF   = left(CLI_TELEFO,13)
                      WEMAIL   = left(CLI_EMAIL,32)
                      if len(trim(WCGC)) = 11
                         WPESSOA = 'F'
                         else
                           WPESSOA = 'J'
                         endif
                    *
                    endif
                 *
                 @ 06, 02 say 'Nome do Cliente ...:' get WNOME     valid !empty(WNOME)
                 @ 07, 02 say 'Endereco ..........:' get WTIPOEND  valid !empty(WTIPOEND)
                 @ 07, 27                            get WENDER    valid !empty(WENDER)
                 @ 08, 02 say 'Numero ............:' get WNUMERO   
                 @ 08, 37 say 'Complemento :'        get WCOMPLE
                 @ 09, 02 say 'Bairro ............:' get WBAIRRO;
                                                     pict '@!'     valid !empty(WBAIRRO)
                 @ 09, 51 say 'Telefone:'            get WTELEF    pict '(99)9999-9999'
                 @ 10, 02 say 'Cidade ............:' get WCIDADE;
                                                     pict '@!'     valid !empty(WCIDADE)
                 @ 10, 51 say 'UF:'                  get WUF       pict '!!';
                                                     valid !empty(WUF)
                 @ 10, 61 say 'CEP:'                 get WCEP      pict '@R 99999-999';
                                                     valid !empty(WCEP)
                 *
                 @ 11, 02 say 'Inscr. Estadual ...:' get WIE       when WPESSOA = 'J'
                 @ 11, 44 say 'Inscr. Municipal:'    get WIM       when WPESSOA = 'J'
                 @ 12, 02 say 'E-Mail ............:' get WEMAIL
                 @ 13, 02 say 'Codigo do Servico .:' get WCDSVMU
                 @ 15,02 say 'Unid Quant Discriminacao dos Servicos                Preco Unit  Preco' 
                 WLIN = 16
                 sele ITNOTA
                 seek WNUM_NOTA
                 do while ITN_NUMERO = WNUM_NOTA .and. !eof()
                    @ WLIN, 08 get ITN_QUANT   pict '999'
                    @ WLIN, 13 get ITN_PROD
                    @ WLIN, 55 get ITN_VALOR   pict '@E 999,999.99'
                    WLIN++
                    skip
                    enddo
                 *
                 clear gets
                 OK = 'N'
                 P2OKSN('Confirma impressao do RPS '     +;
                         alltrim(tran(WNUM_NOTA, '@E 99,999,999')))
                 if OK = 'N'
                    loop
                    endif
                 *
                 exit
                 enddo
              *
              if SAIU
                 loop
                 endif
              *
              @ 04, 02 clear to 21,78
              @ 05, 05 say 'Aguarde! Imprimindo o RPS ...'
*
              IMPR_RPS(WNUM_NOTA)
              @ 04, 02 clear to 21,78
*
              else
                * ******************************************************
                * Imprime varios RPS's
                * ********************
                sele NOTAS
                set filter to NOT_TIPO = 'S'
                SAIU = .f.
                do while .t.
                   RPS_INI  = 0
                   RPS_FIN  = 0
                   DT_EMISS = NOT_DATA
                   @ 05, 02 say 'RPS Inicial:' get RPS_INI pict '@E 999,999';
                            valid RPS_INI > 0
                   @ 06, 02 say 'RPS Final..:' get RPS_FIN pict '@E 999,999';
                            valid RPS_INI > 0
                   read
                   if lastkey() = TESC
                      SAIU = .t.
                      exit
                      endif
                   *
                   OK = 'S'
                   P2OKSN('Confirma')
                   if OK = 'N'
                      loop
                      endif
                   *
                   sele NOTAS
                   seek str(RPS_INI,6)
                   if !found()
                      MSG_ERRO('RPS inicial nao encontrado! Tecle ENTER')
                      loop
                      endif
                   *
                   seek str(RPS_FIN,6)
                   if !found()
                      MSG_ERRO('RPS final nao encontrado! Tecle ENTER')
                      loop
                      endif
                   *
                   exit
                   enddo
                *
                if SAIU
                   exit
                   endif
                *
                sele NOTAS
                seek str(RPS_INI,6)
                *
                * Imprime todos os RPS's
                * **********************
                @ 04, 02 clear to 21,78
                @ 05, 05 say "Aguarde! Imprimindo os RPS's ..."
*
                do while NOT_NUMERO <= RPS_FIN .and. !eof()
                   WNUM_NOTA = NOT_NUMERO
                   WCDSVMU   = NOT_CDSVMU
                   WTOT      = NOT_VALOR
                   DT_EMISS  = NOT_DATA
                   if NOT_CLIEN = 99999 .or. NOT_TIPO <> 'S'
                      skip
                      loop
                      endif
                   *
                   sele CLIENTES
                   set order to 2
                   seek NOTAS->NOT_CLIEN
                   if !found()
                      alert('ERRO - Cliente do RPS nao cadastrado! Tecle ENTER')
                      set order to 1
                      loop
                      endif
                   *
                   set order to 1
                   WCOD     = CLI_CODIGO
                   WNOME    = CLI_NOME
                   WTIPOEND = CLI_TIPOEND
                   WENDER   = CLI_ENDER
                   WNUMERO  = CLI_NUMERO
                   WCOMPLE  = CLI_COMPL
                   WBAIRRO  = CLI_BAIRRO
                   WCIDADE  = CLI_CIDADE
                   WUF      = CLI_UF    
                   WCEP     = left(CLI_CEP,5) + '-' + right(CLI_CEP,3)
                   WCGC     = CLI_CGC   
                   WIE      = CLI_IE
                   WIM      = CLI_IM
                   WTELEF   = left(CLI_TELEFO,13)
                   WEMAIL   = left(CLI_EMAIL,32)
                   if len(trim(WCGC)) = 11
                      WPESSOA = 'F'
                      else
                        WPESSOA = 'J'
                      endif
                   *
                   IMPR_RPS(WNUM_NOTA)
                   sele NOTAS
                   skip
                   enddo
                *
                @ 04, 02 clear to 21,78
*
              endif
           enddo
      *
      ******************************************************************
      * Emite Notas Fiscais de Venda de Mercadorias ********************
      case menuT = 6
           NOTAS_VENDA()
      *
      ******************************************************************
      * Cancela uma NOTA FISCAL/RPS ************************************
      case menuT = 7
           NOTAS_CANCEL()
      *
      ******************************************************************
      * NOTA FISCAL/RPS Pagamento **************************************
      case menuT = 8
           NOTAS_PGTO()
      *
      ******************************************************************
      * NOTA FISCAL Exclusao *******************************************
      case menuT = 9
           NOTAS_EXCL()
      *
      ******************************************************************
      * Lista NOTAS FISCAIS/RPS em ABERTO ******************************
      case menuT = 10
           NOTAS_ABERTO()
      *
      ******************************************************************
      * Imprime lista de CLIENTES **************************************
      case menuT = 11
           *
           *0    *    1    *    2    *    3    *    4    *    5    *    6    *
           *01234567890123456789012345678901234567890123456789012345678901234567
           *X-- Fantasia -X - X---------- Razao Social --------------X  Cod: 99.
           *                  X------------ Endereco ----------------X - X-bairr
           *                  Resp: X----------------------------X Tel: X-------
           *                  X------- Cidade --------X - XX - 99999-999    Pgms
           *                  CNPJ: 99.999.999/9999-99    IE: 99.999.999    Manu
           *                  IF1: 9999.999.999.999 - 9.99      IF2: 9999.999.99
           *                  --------------------------------------------------
           *
           OK := 'S'
           P2OKSN('Imprime relatorio')
           if OK = 'N'
              loop
              endif
           sele CLIENTES
           go top
*
           CONT := 0
           do while !eof()
              if CONT = 9
                 CONT := 0
                 eject
                 endif
              *
              if CONT = 0
                 @ prow(),     00 say CLI_FANTAS + ' - ' + CLI_NOME
                 else
                   @ prow()+1, 00 say CLI_FANTAS + ' - ' + CLI_NOME
                 endif
              *
              @ prow(), 60   say 'Cod: ' + tran(CLI_CODIGO, '@E 99,999') 
              @ prow()+1, 18 say trim(CLI_ENDER) + ' - ' + trim(CLI_BAIRRO) 
              @ prow()+1, 18 say 'Resp: ' + CLI_RESPON
              @ prow(),   55 say 'Tel: ' + CLI_TELEFO
              @ prow()+1, 18 say trim(CLI_CIDADE) + ' - ' + CLI_UF + ' - ' +;
                                 tran(CLI_CEP, '@R 99.999-999')
              @ prow(),   64 say 'Pgms : ' + tran(CLI_VALOR, '@E 99,999.99')
              @ prow()+1, 18 say 'CNPJ: ' +;
                                  tran(CLI_CGC, '@R 99.999.999/9999-99') +;
                                 '   IE: ' + tran(CLI_IE, '@R 99.999.999')
              @ prow(),   64 say 'Manut: ' + tran(CLI_MANUT, '@E 99,999.99')
              @ prow()+1, 18 say 'IF1: ' + tran(CLI_IF01, '@R XXXX.XXX.XXX.XXX')
              @ prow(),   pcol() say ' - '
              @ prow(),   pcol() say tran(CLI_VER01, '@R 9.99')
              @ prow(),   52 say 'IF2: ' + CLI_IF02 pict('@R XXXX.XXX.XXX.XXX')
              @ prow(),   pcol() say ' - '
              @ prow(),   pcol() say CLI_VER02 pict '@R 9.99'
              @ prow()+1, 18 say '-------------------------------------'+;
                                 '-------------------------'
              CONT++
              skip
              enddo
           *
           eject
      *
      ******************************************************************
      * Manutencao dos arquivos ****************************************
      case menuT = 12
           do while .t.
              RODAPE(01)
              set color to n/bg
              @ 02,01 clear to 22,78
              set wrap on
              MENUT := 1
              @ 03,02 to 07,23 double
              @ 04,03 prompt "Cadastro de CLIENTES"
              @ 05,03 prompt "Servicos adicionais "
              @ 06,03 prompt "Retorna             "
              menu to menuT
              if lastkey() = TESC .or. MENUT = 3
                 exit
                 endif
              do case
                 case MENUT = 1
                      CLIEN()
                 case MENUT = 2
                      SERV_ADIC()
                 endcase
              enddo
      *
      ******************************************************************
      * Browse *********************************************************
      case menuT = 13
           sele CLIENTES
           browse()
      *
      ******************************************************************
      * Consulta TODAS DO CLIENTE **************************************
      case menuT = 14
           TODAS_CLIEN()
      *
      * Grava arq. cobranca ITAU ***************************************
      case menuT = 15
           GR_ITAU()
      *
      ******************************************************************
      * Le arq. cobranca ITAU ******************************************
      case menuT = 16
           LE_ITAU()
      *
      ******************************************************************
      * Emite todos os boletos ITAU da cobranca ************************
      case menuT = 17
           ITAU_TODAS()
      *
      ******************************************************************
      * Emite boletos ITAU selecionados ********************************
      case menuT = 18
           ITAU_SELEC()
      *
      ******************************************************************
      * Reemite 1 boleto ITAU ******************************************
      case menuT = 19
           ITAU_REEMI()
      *
      ******************************************************************
      * GRAVA DADOS para BOLETOS POR E-MAIL ****************************
      case menuT = 20
           DADOS_BOLS()
      *
      ******************************************************************
      * Envia BOLETOS POR E-MAIL ***************************************
      case menuT = 21
           ENVIA_BOLS()
      *
      ******************************************************************
      * Reajuste pelo IPCA *********************************************
      case menuT = 22
           MSG_ERRO('Reajuste pelo IPCA')
           REAJ_IPCA()
      *
      ******************************************************************
      * Instrucoes *****************************************************
      case menuT = 23
           sele LEIAME
           zap
           appe from LEIAME sdf
           go top
           @ 00, 78 say 'IC'
           RODAPE(01)
           set color to n/bg
           @ 02, 01 to 22, 78
           dbedit(03,02,21,77)
      *
      endcase
   enddo
*
return NIL
*
**************************  fim do programa  ***************************
