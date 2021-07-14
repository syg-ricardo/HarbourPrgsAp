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
*
*function main()
setmode(25,80) 
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
PROX_ATIV  := 'V H.03'
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
*  Sistema.....: ZIUL - Sistema de Cobranca
*  Programador.: Nando                                                  
*  Data........: 27/04/04                                                 
*  Programa....: PROCS.PRG
*  Descricao...: Rotinas auxiliares do sistema de cobranca
*  Alteracao...: ACERTADO RDV11
*  Data........:                                                  
*  Rotinas.....: 
*
*-------------------------------------------------------------------------

*
*************************** ROTINAS AUXILIARES *************************
*
******************************** REAJ_IPCA *****************************
*-------------------*
 Procedure REAJ_IPCA
*-------------------*
 sele 16
 use IPCA
 *
 WIPCA = 0.00
 @ 02,01 clear to 22,78
 @ 04,05 say 'IPCA:' get WIPCA pict '@ 999.99'
 read
 IPCA_NUM = 1 + (WIPCA / 100)
 *
 sele CLIENTES
 go top
 do while !eof()
    WVALOR_P = CLI_VALOR
    WVALOR_C = CLI_MANUT
    *
    * Calcula novo valor de manutencao de Programa
    if WVALOR_P > 0.00
       sele IPCA
       locate for IPC_TIPO = "P" .and. IPC_VALATU = WVALOR_P
       if eof()
          WVAL_NOVP = round(WVALOR_P*IPCA_NUM + 0.5,0)
          else
            WVAL_NOVP = IPC_VALNOV
          endif
       *
       sele CLIENTES
       repla CLI_VALOR with WVAL_NOVP
       sele IPCA
       endif
    *
    if WVALOR_C > 0.00
       locate for IPC_TIPO = "C" .and. IPC_VALATU = WVALOR_C
       if eof()
          WVAL_NOVC = round(WVALOR_C*IPCA_NUM + 0.5,0)
          else
            WVAL_NOVC = IPC_VALNOV
          endif
       *
       sele CLIENTES
       repla CLI_MANUT with WVAL_NOVC
       sele IPCA
       endif
    *
    sele CLIENTES
    skip
    enddo
 *
 return
*
*
****************************** IMPR_RESUMO *****************************
*---------------------*
 Procedure IMPR_RESUMO
*---------------------*
  *0    *    1    *    2 ...  3    *    4    *    5    *    6    *    7    *    
  *01234567890123456789012378901234567890123456789012345678901234567890123456789
  *Arquivo: AAAAMMnn.TXT
  *---------------------
  *NFiscal  Clien Razao Social                 Cod. Sv.  Vl da nota  St  NF Subs
  *-------  ---------------------------------  --------  ----------  --  -------
  *999.999  9.999 X--------- (30) ----------X  99.99.99  999.999,99   
  *999.999  9.999 X--------- (30) ----------X  99.99.99  999.999,99  S   999.999
  *999.999  9.999 X--------- (30) ----------X  99.99.99  999.999,99  C
  *999.999  9.999 X--------- (30) ----------X  99.99.99  999.999,99   
  *-----------------------------------------------------------------------------
  *         RPS gravados: 9.999
  *         Valor total.: 999.999,99
  *         Valor do ISS: 999.999,99
  *
  sele NOTAS
  seek MNOTA_INI
  ? 'Arquivo: ' + WARQ_TXT
  ? '---------------------'
  ? 'NFiscal  Clien  Razao Social                    Cod. Sv.  Vl da nota  St' +;
    '  NF Subs'
  ? '-------  -------------------------------------  --------  ----------  --' +;
    '  -------'
  sele CLIENTES
  set order to 2
  sele NOTAS
  seek str(MNOTA_INI,6)
  CONT_LIN = 4
  do while NOT_NUMERO <= MNOTA_FIN .and. !eof()
     sele CLIENTES
     seek NOTAS->NOT_CLIEN
     sele NOTAS
     if CONT_LIN = 60
        eject
        ? 'NFiscal  Clien  Razao Social                Cod. Sv.  Vl da nota' +;
          '  St  NF Subs'
        ? '-------  ---------------------------------  --------  ----------' +;
          '  --  -------'
        CONT_LIN = 2
        endif
     *
     if NOT_CLIEN = 99999  && Cliente nao cadastrado
        sele CLI_NCAD
        seek NOTAS->NOT_CGC
        if eof()
           alert('ERRO 01 - CPF/CNPJ nao encontrado em CLI_NCAD!')
           loop
           endif
        *
        sele NOTAS
        ? tran(NOT_NUMERO, '@E 999,999') + '  '   +;
          '99999  '                               +;
          left(CLI_NCAD->CLN_NOME,30)    + '  '   +;
          NOT_CDSVMU + '  '                       +; 
          tran(NOT_VALOR, '@E 999,999.99')
          * + status + NF subst
       else
         ? tran(NOT_NUMERO, '@E 999,999') + '  '   +;
           tran(NOT_CLIEN, '@E 9,999')    + '  '   +;
           left(CLIENTES->CLI_NOME,30)    + '  '   +;
           NOT_CDSVMU + '  '                       +; 
           tran(NOT_VALOR, '@E 999,999.99')
           * + status + NF subst
       endif
     *
     CONT_LIN++
     skip
     enddo
  *
  * Imprime totais
  ? repl('-', 80)
  ? '         RPS gravados: ' + tran(REG_TIPO20, '@E 999,999')
  ? '         Valor total.: ' + tran(TOT_SERV,   '@E 999,999.99')
  ? '         Valor do ISS: ' + tran(TOT_ISS,    '@E 999,999.99')
  sele CLIENTES
  set order to 1
  return
*
******************************LISTA_RESUMO *****************************
*----------------------*
 Procedure LISTA_RESUMO
*----------------------*
  WMES_ANT := if(month(date())=1,'12',strzero(month(date())-1,2))
  WANO_ANT := if(month(date())=1,right(strzero(year(date())-1,4),2),;
                                 right(strzero(year(date()),4),2))  
  VALID      = MESES[val(WMES_ANT)] + '/' + WANO_ANT
  do while .t.
     @ 05, 05 say 'Referencia .......:' get VALID pict '@! XXX/99'
     read
     if lastkey() = TESC
        return
        endif
     *
     OK := 'S'
     P2OKSN('Confirma')
     if OK = 'N'
        return
        endif
     *
     @ 07, 05 say 'Aguarde! Imprimindo o Relatorio em AIMPRE ...'
     *
     * Impressao em ARQ
     *--------------------
     set printer to AIMPRE
     set device  to print
     set print   on
     set console off     
     *--------------------
     *
     *
     * Imprime manutencoes de programas
     * ********************************
     ? '                                   ' + VALID
     ? '                        LICENCA DE USO DE PROGRAMAS ZIUL'      
     ? '                      ===================================='
     *  0    *    1    *    2    *    3    *    4    *    5    *    6    *    7    *
     *  01234567890123456789012345678901234567890123456789012345678901234567890123456789
     *  COD  FANTASIA        RAZAO SOCIAL                            LIC. USO   MANUT.
     *  ---- --------------- --------------------------------------- --------   --------
     *  9999 X-------------X X-------------------------------------X 9.999.99   9.999,99
     *  9999 X-------------X X-------------------------------------X 9.999.99   9.999,99
     *  --------------------------------------------------------------------------------
     *  Total:               999                                   999.999.99 999.999,99
     *
     WNUM_CLI := 0
     WTOT_CLI := 0
     WVAL_LIC := 0.00
     WTOT_LIC := 0.00
     WVAL_MAN := 0.00
     WTOT_MAN := 0.00
     *
     WTOT_CLI_G := 0
     WTOT_LIC_G := 0.00
     WTOT_MAN_G := 0.00
     WLIN       := 3
     *
     ? 'ZIUL'
     ? 'COD  FANTASIA        RAZAO SOCIAL                            ' +;
       'LIC. USO   MANUT.'
     ? '---- --------------- --------------------------------------- ' +;
       '--------   --------'
     *
     WLIN := WLIN + 2
     sele CLIENTES
     go top
     *
     do while !eof()
        if CLI_VALOR > 0.00
           if WLIN > 59
              WLIN := 3
              eject
              *
              ? 'COD  FANTASIA        RAZAO SOCIAL                            ' +;
                'LIC. USO   MANUT.'
              ? '---- --------------- --------------------------------------- ' +;
                '--------   --------'
              endif
           *                 
           ?  tran(CLI_CODIGO, '@E 9999') + ' '
           ?? CLI_FANTAS + ' '
           WVAL = CLI_VALOR + CLI_MOBILE + CLI_TEFMOB + CLI_CONCIL + CLI_TEFIP
           ?? left(CLI_NOME,39) + ' '
              W1 = tran(WVAL, '@E 9,999.99')
           * 
           ?? W1 + '   '
           WVAL_LIC := WVAL_LIC + WVAL
           WNUM_CLI++
           WLIN++
           endif
        *
        skip
        enddo
     *
     ? repl('-', 80)
     ? 'Totais:' + space(14) + tran(WNUM_CLI, '999') + SPACE(35) +;
                   tran(WVAL_LIC, '@E 999,999.99') + ' ' +;
                   tran(WVAL_MAN, '@E 999,999.99')
     ?;?
     WLIN = WLIN + 4
     *
     WTOT_CLI := WTOT_CLI + WNUM_CLI 
     WTOT_LIC := WTOT_LIC + WVAL_LIC 
     WTOT_MAN := WTOT_MAN + WVAL_MAN 
     *
     WTOT_CLI_G := WTOT_CLI_G + WNUM_CLI
     WTOT_LIC_G := WTOT_LIC_G + WVAL_LIC
     WTOT_MAN_G := WTOT_MAN_G + WVAL_MAN
     *
     WNUM_CLI := 0
     WVAL_LIC := 0.00
     WVAL_MAN := 0.00
     *
     * Imprime Manutencoes de computadores
     * ***********************************
     *
     ? 'Manutencoes de computadores'
     ? 'COD  FANTASIA        RAZAO SOCIAL                            ' +;
       'LIC. USO   MANUT.'
     ? '---- --------------- --------------------------------------- ' +;
       '--------   --------'
     *
     WLIN := WLIN + 2
     sele CLIENTES
     go top
     *
     do while !eof()
        if CLI_MANUT > 0.00
           if WLIN > 59
              WLIN := 3
              eject

              *
              ? 'COD  FANTASIA        RAZAO SOCIAL                            ' +;
                'LIC. USO   MANUT.'
              ? '---- --------------- --------------------------------------- ' +;
                '--------   --------'
              endif
           *                 
           ?  tran(CLI_CODIGO, '@E 9999') + ' '
           ?? CLI_FANTAS + ' '
           ?? left(CLI_NOME,39) + ' '
           W1 = tran(CLI_MANUT, '@E 9,999.99')
           ?? space(12) + W1
           *
           WVAL_MAN := WVAL_MAN + CLI_MANUT
           WNUM_CLI++
           WLIN++
           endif
        *
        skip
        enddo
     *
     ? repl('-', 80)
     WVAL_LIC = 0
     ? 'Totais:' + space(14) + tran(WNUM_CLI, '999') + SPACE(35) +;
                   tran(WVAL_LIC, '@E 999,999.99') + ' ' +;
                   tran(WVAL_MAN, '@E 999,999.99')
     ?;?
     WLIN = WLIN + 4
     *
     WTOT_CLI := WTOT_CLI + WNUM_CLI 
     WTOT_LIC := WTOT_LIC + WVAL_LIC 
     WTOT_MAN := WTOT_MAN + WVAL_MAN 
     *
     WTOT_CLI_G := WTOT_CLI_G + WNUM_CLI
     WTOT_LIC_G := WTOT_LIC_G + WVAL_LIC
     WTOT_MAN_G := WTOT_MAN_G + WVAL_MAN
     *
     WNUM_CLI := 0
     WVAL_LIC := 0.00
     WVAL_MAN := 0.00
     *
     *? '                            SERVICOS ADICIONAIS '           
     *? '               ==============================================='
     *? 'COD  FANTASIA        RAZAO SOCIAL                            LIC. USO   MANUT.'
     *? '---- --------------- --------------------------------------- --------   --------'
     *   9999 X-------------X X-------------------------------------X 
     *                        X-----------------------X                          9.999,99
     *   9999 X-------------X X-------------------------------------X 
     *                        X-----------------------X                          9.999,99
     *  ---------------------------------------------------------------------------------
     *  Total:                999                                              999.999,99
     *
     * Verifica se tem Servicos adicionais
     WNUM_CLI := 0
     WVAL_MAN := 0.00
     WLIN     := 99
     sele CLIENTES
     set filter to
     go top
     do while !eof()
        WVALOR := 0.00
        sele SERV_ADI
        seek CLIENTES->CLI_CODIGO
        WINI := .t.
        do while SAD_CODIGO = CLIENTES->CLI_CODIGO .and. !eof()
           if WLIN > 50
              WLIN := 4
              eject
              ? 'Servicos Adicionais'
              ? 'COD  FANTASIA        RAZAO SOCIAL                            ' +;
                'LIC. USO   MANUT.'
              ? '---- --------------- --------------------------------------- ' +;
                '--------   --------'
              endif
           *
           if SAD_VALID = VALID
              if WINI
                 ?  tran(SAD_CODIGO, '@E 9999') + ' '
                 ?? SAD_FANTAS + ' '
                 ?? left(SAD_NOME,39) + ' '
                 WINI := .f.
                 WLIN ++
                 endif
              *
              ?  space(21)
              ?? SAD_REFER + space(20)
              ?? tran(SAD_UNID * SAD_VALOR, '@E 9,999.99')
              WLIN ++
              WVAL_MAN := WVAL_MAN + SAD_UNID * SAD_VALOR
              WNUM_CLI++ 
              endif
           skip
           enddo
        *
        sele CLIENTES
        skip
        enddo
     *
     ? repl('-', 80)

     WTOT_CLI := WTOT_CLI + WNUM_CLI 
     WTOT_MAN := WTOT_MAN + WVAL_MAN 
     *
     WTOT_CLI_G := WTOT_CLI_G + WNUM_CLI
     WTOT_MAN_G := WTOT_MAN_G + WVAL_MAN
     *
     ? 'Total:' + space(13) + tran(WNUM_CLI, '999') + SPACE(48) +;
        tran(WVAL_MAN, '@E 999,999.99')
     *
     WNUM_CLI := 0
     WVAL_LIC := 0.00
     WVAL_MAN := 0.00
     *
     ? repl('-',80)
     ? 'Totais:' + space(14) + tran(WTOT_CLI, '999') + SPACE(35) +;
                   tran(WTOT_LIC, '@E 999,999.99') + ' ' +;
                   tran(WTOT_MAN, '@E 999,999.99')
     ?;?;?
     ? repl('=', 80)
     ? repl('-', 80)
     ? 'Totais:' + space(14) + tran(WNUM_CLI, '999') + SPACE(35) +;
                   tran(WVAL_LIC, '@E 999,999.99') + ' '
     *              tran(WREPASSE, '@E 999,999.99')
     *
     WTOT_CLI_G := WTOT_CLI_G + WNUM_CLI
     WTOT_FINAL := WTOT_LIC_G + WTOT_MAN_G
     *
     ? repl('-', 80)
     ? 'Totais:' + space(14) + tran(WTOT_CLI_G, '999') + SPACE(46) +;
                   tran(WTOT_FINAL, '@E 999,999.99')
     exit
     enddo
  *
  eject
  sele CLIENTES
  set filter to
  @ 04, 02 clear to 21,78
  *
  * Impressao em ARQ
  *--------------------
  set printer to 
  set device  to screen
  set print   off
  set console on
  *--------------------  
  *
  return
*
****************************** Valida IE *******************************
*-----------------*
 Function VALID_IE
*-----------------*
  Param P_IE
  declare Numero[8]
  Multipl = 2
  Result  = .f.
  for I1 = 1 to 8
      Numero[I1] = val(substr(P_IE,I1,1))
      next I1
  *
  SOMA = 0
  for I1 = 1 to 7
      Valor = Numero[I1] * Multipl
      Soma  = Soma + Valor
      Multipl = Multipl - 1
      if Multipl == 1
         Multipl = 7
         endif
      *
      next I1
  *
  Resto = mod(Soma,11)
  if Resto <= 1
     Digito = 0
     else
       Digito = 11 - Resto
     endif
  *
  if Numero[8] = Digito
     Result = .t.
     endif
  *
  return Result
*
******************************** SAI_DBEDIT ****************************
*-------------------*
 Function SAI_DBEDIT
*-------------------*
  do case
     case INICIO_DBEDIT
          INICIO_DBEDIT := .f.
          return 1
     case lastkey() = TENTER
          ULTKEY := TENTER
          return 0
     case lastkey() = F3
          ULTKEY := F3
          return 0
     case lastkey() = F4
          ULTKEY := F4
          return 0
     case lastkey() = TESC
          ULTKEY := lastkey()
          return 0
     endcase
  return 1
*
******************************** P1TELA3 *******************************
*-----------------*
 Procedure P1TELA3
*-----------------*
   SETCOLOR(cfgedger)
   @ 00,00 CLEAR TO 24,79
   @ 01,00 to 23,79 DOUBLE
   SETCOLOR(cfgedtit)
   @ 00,00 SAY SPACE(24)
   @ 00,01 SAY uscodigo
   
   * Ao inves da tata de abertura, mostra data de hoje
   dt_hojeb = DTOC(DATE())
   @ 00,15 SAY dt_hojeb
   mx = (30 - LEN(arqemp)) / 2
   @ 00,25 SAY SPACE(30)
   @ 00,25 SAY SPACE(mx) + arqemp
   @ 00,56 SAY SPACE(24)
   @ 00,57 SAY prox_ativ
   @ 00,70 SAY [Opcao:]
   tl_col = (80 - LEN(tl_cabec)) / 2 - 2
   SET COLOR TO +W/N
   @ 01,tl_col SAY [  ]+tl_cabec+[  ]
   RETURN
*
******************************** RODAPE ********************************
*----------------*
 Procedure RODAPE
*----------------*
  parameters P_NUM
  *  0         1         2         3         4         5         6         7
  *  01234567890123456789012345678901234567890123456789012345678901234567890123456789
  *1                                ESC - Retorna  
  *2                   ENTER - Seleciona         ESC - Retorna  
  *3         ENTER - Seleciona      F4 - Todos/Ativos      ESC - Retorna  
  *4                   PGDN - Grava              ESC - Retorna 
  *5                   F3 - Imprime              ESC - Retorna  
  *6         ENTER - Seleciona      F4 - Ordena: Codigo/Fantas       ESC - Retorna  
  *7                   F4 - Muda ordem           ESC - Retorna 
  *
  SALVACORI = setcolor(CFGMNNOR)
  set color to
  SALVACOR  = setcolor()
  @ 24, 00 clear to 24, 79
  setcolor(CFGMNTIT)
  do case
     case P_NUM = 1
          @24, 31 say 'ESC'
          setcolor(SALVACOR)
          @24, 35 say chr(26) + ' Retorna'    
     *
     case P_NUM = 2
          @24, 18 say 'ENTER'
          @24, 44 say 'ESC'
          setcolor(SALVACOR)
          @24, 24 say chr(26) + ' Seleciona'    
          @24, 48 say chr(26) + ' Retorna'    
     *
     case P_NUM = 3 
          @24, 08 say 'ENTER'
          @24, 31 say 'F4'
          @24, 54 say 'ESC'
          setcolor(SALVACOR)
          @24, 14 say chr(26) + ' Seleciona'    
          @24, 34 say chr(26) + ' Todos/Ativos'    
          @24, 58 say chr(26) + ' Retorna'    
     *
     case P_NUM = 4 
          @24, 18 say 'PGDN'
          @24, 44 say 'ESC'
          setcolor(SALVACOR)
          @24, 23 say chr(26) + ' Grava'    
          @24, 48 say chr(26) + ' Retorna'    
     *
     case P_NUM = 5
          @24, 18 say 'F3'
          @24, 44 say 'ESC'
          setcolor(SALVACOR)
          @24, 23 say chr(26) + ' Imprime'    
          @24, 48 say chr(26) + ' Retorna'    
     *     
     case P_NUM = 6 
          @24, 08 say 'ENTER'
          @24, 31 say 'F4'
          @24, 64 say 'ESC'
          setcolor(SALVACOR)
          @24, 14 say chr(26) + ' Seleciona'    
          @24, 34 say chr(26) + ' Ordena: Codigo/Fantas'    
          @24, 68 say chr(26) + ' Retorna'    
     *  
      case P_NUM = 7
          @24, 18 say 'F4'
          @24, 44 say 'ESC'
          setcolor(SALVACOR)
          @24, 21 say chr(26) + ' Muda ordem'    
          @24, 48 say chr(26) + ' Retorna'  
     *
     otherwise
          @24, 10 say 'RODAPE NAO DEFINIDO !!!!!!!!!!!!!!'
          setcolor(SALVACOR)
     endcase
  *
  setcolor(SALVACORI)
  return
*
******************************** P2OKSN ********************************
*----------------*
 Procedure P2OKSN
*----------------*
   parameters P_TEXTO
   local TXT, SALVALIN, GUARDACOR, WCOL
   SALVALIN = savescreen(24,00,24,79)
   if pcount() = 0
      TXT = space(43) + 'Confirma'
      else
        TXT = P_TEXTO
      endif
   *
   guardacor = SETCOLOR("/W")
   @ 24,00
   @ 24,1 say TXT + ' (S/N)? '
   WCOL = col()    
   do while .t. 
      @ 24, WCOL get OK pict '!'
      tone(500,5)
      read
      if lastkey() = TENTER .and. (OK = 'S' .or. OK = 'N');
         .or. chr(lastkey()) = 'N' .or. chr(lastkey()) = 'S';
         .or. chr(lastkey()) = 'n' .or. chr(lastkey()) = 's'
         exit
         else
           ? chr(7)
         endif
      enddo
   *
   restscreen(24,00,24,79,SALVALIN)
   setcolor(GUARDACOR)
   *@ 24,00
   return
*************************** MSG_ERRO ***********************************
*------------------*
 Procedure MSG_ERRO
*------------------*
  Parameters MSG
  PRIVATE x, salvacor, mini, mfim, mtela_w
  tone(500,5)
  tone(400,10)
  SET CURSOR OFF
  salvacor = SETCOLOR(cfg_cmsg)
  if len(MSG) > 77
     MSG := left(MSG,77)
     endif
  mini = (72 - LEN(msg)) / 2 + 1
  mfim = mini + LEN(msg) + 7
  desenha(INT((LEN(msg) + 23) / 2))
  mtela_w = SAVESCREEN(22,mini,24,mfim)
  @ 22,mini TO 24,mfim DOUBLE
  @ 23,mini+1 SAY '   ' + msg + '   '
  x = 0
  DO WHILE x = 0
     x = INKEY(.5)
     ENDDO
  RESTSCREEN(22,mini,24,mfim,mtela_w)
  SETCOLOR(salvacor)
  SET CURSOR ON
  RETURN
*
******************* Mostra na tela a msg de MSG_ERRO *******************
*----------------*
FUNCTION desenha
*----------------*
  PARAMETERS x
  PRIVATE mxant, mm, mll, mxatual, msalva
  DECLARE ca[21], la[21], cc[21], lc[21]
* calculo das coordenadas de a e c
  mxant = 1
  mm = 0
  FOR mll = 1 TO 21
    mxatual = INT((x * mll) / 22)
    IF mxatual > mxant
        mm = mm + 1
        ca[mm] = 40 - mxatual
        la[mm] = mll
        cc[mm] = 39 + mxatual
        lc[mm] = mll + 2
        mxant = mxatual
    ENDIF
  NEXT
  msalva = SAVESCREEN(0,39,3,40)
  @ 0,39 TO 3,40 DOUBLE
  RESTSCREEN(0,39,3,40,msalva)
  FOR mll = 1 TO mm
    msalva = SAVESCREEN(la[mll],ca[mll],lc[mll],cc[mll])
    @ la[mll],ca[mll] TO lc[mll],cc[mll] DOUBLE
    FOR mxant = 1 TO cfg_tmsg
    NEXT
    RESTSCREEN(la[mll],ca[mll],lc[mll],cc[mll],msalva)
  NEXT
  RETURN
*
*************************** MSG ****************************************
*------------*
 Function MSG
*------------*
  * Aceita ENTER ou ESC
  parameters MENS, P_TECLA1
  private GUARDACOR, SALVALINHA
  GUARDACOR = setcolor('/w')
  SALVALINHA = savescreen(24,00,24,79)
  @ 24,00
  if pcount() = 1
     @ 24,00 say MENS + '. Tecle ENTER'
     else
       @ 24,00 say MENS + '. Tecle ENTER ou ESC p/ cancelar'
     endif
  tone(2000,3)
  inkey(0)
  if pcount() = 1
     do while lastkey() # TENTER
        inkey(0)
        tone(246.90,3)
        enddo
     else
       do while lastkey() # TENTER .and. lastkey() # TESC
          inkey(0)
          tone(246.90,3)
          enddo
     endif
  setcolor(GUARDACOR)
  restscreen(24,00,24,79,SALVALINHA)
  return .f.
*
********************** Calcula DV Digito 11 ****************************
*---------------*
 Function DV11_P
*---------------*
 Local W0
 Param f_var
 * Calcula DV do Nosso Numero (Santander)
   f_p=10
   f_acm=0
   for f_xxxxx=len(f_var) to 1 step -1
       if f_p>9
          f_p=2
          endif
       f_acm=f_acm+(val(subs(f_var,f_xxxxx,1))*f_p)
       f_p=f_p+1
       next
   *
   W0 = mod(f_acm,11)
   if W0 = 10
      W_DV = '1'
      elseif W0 = 1 .or. W0 = 0
        W_DV = '0'
      else
        W_DV = str(11-W0,1)
      endif
   *
   return W_DV
*
********************** Devolve True se DV CPF/CNPJ correto  ************
*-------------------------------*
 Procedure RDV11(P_PESSOA,P_CPF)
*-------------------------------*
* Verifica DV de CPF ou CNPJ
*
if P_PESSOA = "F"  && Se for Pessoa Fisica
   w_pesoent = 99
   ELSE            && Se for Pessoa Juridica
     w_pesoent = 9
   ENDIF
w_qtdedv  = 2      && E' o Numero de Digitos do Digito Verificador
w_opcao   = "T"    && C = p/Criar   T = p/Testar
w_tamanho = LEN(P_CPF) && Tamanho do Campo
w_index   = 0
w_peso    = 2
w_soma    = 0 
w_dv      = 0       && Retorna o Digito Verificador
w_dvok    = .T.     && Retorna Falso ou Verdadeiro o Teste do DV
DO WHILE w_qtdedv > 0
   w_index = w_tamanho - w_qtdedv
   w_peso = 2
   w_soma = 0
   DO WHILE w_index > 0
      *w_soma = w_soma + VAL(SUBSTR(cgc1,w_index,1)) * w_peso
      w_soma = w_soma + VAL(SUBSTR(P_CPF,w_index,1)) * w_peso
      w_peso = w_peso + 1
      IF w_peso > w_pesoent
	 w_peso = 2
	 ENDIF
      w_index = w_index - 1
      ENDDO
   w_dv = 11 - (w_soma - INT(w_soma / 11) * 11)
   IF w_dv > 9
      w_dv = 0
      ENDIF
   IF w_opcao = "C"
      *cgc1 = SUBSTR(cgc1,1,w_tamanho - w_qtdedv) + STR(w_dv,1)
      P_CPF = SUBSTR(P_CPF,1,w_tamanho - w_qtdedv) + STR(w_dv,1)
      ELSE
	*IF SUBSTR(cgc1,w_tamanho - w_qtdedv + 1,1) # STR(w_dv,1)
        IF SUBSTR(P_CPF,w_tamanho - w_qtdedv + 1,1) # STR(w_dv,1)
	   w_dvok = .F.
	   ENDIF
      ENDIF
   w_qtdedv = w_qtdedv - 1
   ENDDO
RETURN w_dvok
*
******** Le uma data inicial e uma data final, podendo sugerir  ********
*---------------------------*
 Procedure LE_PERIODO(P_INI)
*---------------------------*
  local CDIAI, NMES, NMESI, CMESI, CMESF, NANO, NANOI, CANOI, CANOF,;
        CDATAF, I1, WOK:= .t.
  * Le data de inicio (MDATAI) e data final (MDATAF).
  * Se P_INI for igual a 0: Comeca com datas vazias
  * Se P_INI = 1: Sugere data inicio = dia 1 do mes anterior,
  *               e data final = ultimo dia do mes corrente.
  * Se P_INI = 2: Comeca com datas vazias
  *               mas exige preenchimento das duas datas. 
  * Se P_INI = 3: Sugere data inicio = dia 1 do mes anterior,
  *               e data final = ultimo dia do mes corrente,
  *               mas nao pede confirmacao
  *
  @ 03, 01 clear to 22, 78
  @ 03, 10 say 'Periodo -> de.:'
  @ 04, 10 say '           ate:'
  if P_INI = 0 .or. P_INI = 2
     MDATAI = ctod('')
     MDATAF = ctod('')
     else
       * Monta data Inicial
       CDIAI = '01'
       NMES  = month(date())
       NANO  = year(date())
       if NMES = 1
          CMESI = '12'
          if NANO = 2000
             CANOI = '99'
             else
               NANOI = NANO - 1
               CANOI = right(str(NANOI,4),2)
             endif
          else
            NMESI = NMES - 1
            CMESI = strzero(NMESI,2)
            CANOI = right(str(NANO,4),2)
          endif
       MDATAI = ctod(CDIAI + '/' + CMESI + '/' + CANOI)
       *
       * Monta data final
       CMESF = strzero(NMES,2)
       CANOF = right(str(NANO,4),2)
       for I1 = 31 to 28 step -1
           CDATAF = str(I1,2) + '/' + CMESF + '/' + CANOF
           if !DATAINV(CDATAF)
              exit
              endif
           next I1
       MDATAF = ctod(CDATAF)
     endif
  *
  ERRO = .f.
  do while .t.
     @ 03, 26 get MDATAI
     @ 04, 26 get MDATAF
     read
     if lastkey() = TESC
        WOK = .f.
        exit
        endif
     if P_INI = 2 .and. (empty(MDATAI) .or. empty(MDATAF))
        MSG_ERRO('Preencha as duas datas! Tecle ENTER.')
        loop
        endif
     if MDATAF < MDATAI .and. !empty(MDATAF)
        MSG_ERRO('Data final menor que data inicial! Tecle ENTER.')
        loop
        endif
     *
     if P_INI = 3
        exit
        endif
     *
     OK = 'S'
     P2OKSN('Confirma')
     if OK = 'N'
        ERRO = .t.
        loop
        else
          exit
        endif
     enddo
  return WOK
*
************ Rotina para testar se data 'DD/MM/AA' e invalida **********
*----------------*
 function DATAINV
*----------------*
  parameters PCAMPO
  RESULT = .f.
  if PCAMPO = '  /  /  '
     return RESULT
     endif
  private RESULT, DIA, MES, ANO
  DIA = val(left(PCAMPO,2))
  MES = val(substr(PCAMPO,4,2))
  ANO = val(right(PCAMPO,2))
  if MES < 1 .or. MES > 12 .or. DIA < 1 .or. DIA > 31; 
     .or. ((MES = 4 .or. MES = 6 .or. MES = 9 .OR. MES = 11) .and. DIA > 30);
     .or. (MES = 2 .and. (ANO % 4) = 0 .and. DIA > 29);
     .or. (MES = 2 .and. (ANO % 4) <> 0 .and. DIA > 28)
     RESULT = .t.
     endif
  return RESULT
*
************ Rotina para imprimir cabecalhos de relatorios *************
*---------------*
 Procedure CABEC
*---------------*
parameters CONDENS, TAM, TITULO, WCABEC1, WCABEC2, WNOMPRG, MDATA, MHORA
*********
* 0 -> Impressao NORMAL
* 1 -> Impressao CONDENSADA
***************
* EPSON LX-300:
* Condensado ....: chr(15)
* Normal ........: chr(18)
* Largura dupla (1 linha): chr(14)
* Cancela ...............: chr(20)
***************** ROMAM
*?  chr(27) + chr(120) + '1' 
*?? chr(27) + chr(107) + '0'
***************** SANS SERIF
*?  chr(27) + chr(120) + '1'
*?? chr(27) + chr(107) + '1'
***************** DRAFT
*? chr(27) + chr(120) + '0'
***************** DRAFT CONDENSED
*? chr(27) + chr(120) + '0'
*? CHR(15)
***************** DRAFT DOUBLE
*? chr(27) + chr(120) + '0'
*? CHR(14) + 'DRAFT DOUBLE'
***************** ROMAN DOUBLE
*?  chr(27) + chr(120) + '1' 
*?? chr(27) + chr(107) + '0'
*? CHR(14) + 'ROMAN DOUBLE'
***************** SANS SERIF DOUBLE
*?  chr(27) + chr(120) + '1' 
*?? chr(27) + chr(107) + '1'
*? CHR(14) + 'SANS SERIF DOUBLE'
********************************************
*
if CONDENS <> '0' .and. CONDENS <> '1' 
   alert('CONDENSADO INVALIDO;SO VALE 0 ou 1')
   quit
   endif
if CONDENS = '0'
   MULTIPL = 2
   else
     MULTIPL = 3.3
   endif
PAGINA = PAGINA + 1
if left(CFG_IMPRE,2) = 'HP'
   WCOL = int((TAM - (len(ARQEMP))) / 2)
   @ prow(), pcol() say space(WCOL) + ARQEMP 
   else
     WCOL = int((TAM - (len(ARQEMP)*MULTIPL)) / 2)
     @prow(), pcol() say space(WCOL)
     WLIN = prow()
     WCOL = pcol()
     @ prow(),pcol() say chr(14) 
     setprc(WLIN,WCOL)
     @ 00,WCOL say ARQEMP
   endif
*
@ prow()+1, 00 say 'Programa: ' + WNOMPRG
WCOL = int((TAM - (len(trim(TITULO)))) / 2) 
@ prow(), WCOL say trim(TITULO)
@ prow(), TAM-13 say 'Pagina: ' + strzero(PAGINA,5)
@ prow()+1, 000 say 'Hora....: ' + MHORA
if !empty(WCABEC1)
   WCOL = int((TAM - (len(trim(WCABEC1)))) / 2)
   @ prow(),WCOL say trim(WCABEC1)
   endif
@ prow(),TAM-17 say 'Emissao: '
@ prow(),pcol() say  MDATA
if !empty(WCABEC2)
   @ prow()+2,000 say WCABEC2
   endif
*
return
*
********************* Devolve data com ultimo dia do mes ***************
*-------------------*
 Function ULTIMO_DIA
*-------------------*
 local I1, WDIA, WDATA
 Parameters P_MES, P_ANO
 *
 *---------------------------------*
 * Recebe mes(99), ano(99)         *
 * Devolve dd/mm/aa (formato data) *
 *---------------------------------*
 *
 * Acha ultimo dia do mes
   for I1 = 31 To 28 step -1
       WDIA = I1
       WDATA = ctod(strzero(WDIA,2) + '/' + ;
               strzero(P_MES,2)     + '/' + ;
               strzero(P_ANO,2))
       if !empty(WDATA) .and. !DATAINV(dtoc(WDATA))
          exit
          endif
       next I1
 return WDATA
*
******************** FIM ************************************************
