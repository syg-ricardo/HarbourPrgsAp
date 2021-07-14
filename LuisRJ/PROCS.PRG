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
******************************** IMPR_HARB *****************************
*------------------------------------*
 Function IMPR_HARB(cArq,cPrint,cTit)
*------------------------------------*
 Local oPrn, aPrn:=WIN_PRINTERLIST()
 hb_default(@cPrint,win_PrinterGetDefault())
 hb_default(@cTit,cTit)
 If Empty(cArq)
    alert('Informe algo p/ imprimir.') 
    Return .F.
    EndIf
 *
 If empty(aPrn)
    alert('Informe uma impressora')
    Return .F.
    EndIf
 *
 nRet := Win_PrintFileRaw(cPrint,cArq,cTit)
 if nRet < 1
    cMsg := 'Erro Imprimindo: '
    SWITCH nRet
    CASE -1
         cMsg += "Parâmetro inválido passado" ; EXIT
    CASE -2
         cMsg += "WinAPI OpenPrinter() Falha na chamada"      ; EXIT
    CASE -3
         cMsg += "WinAPI StartDocPrinter() Falha na chamada"  ; EXIT
    CASE -4
         cMsg += "WinAPI StartPagePrinter() Falha na chamada" ; EXIT
    CASE -5
         cMsg += "WinAPI malloc() of memory failed"      ; EXIT
    CASE -6
         cMsg += "Arquivo " + cArq + " não Localizado"   ; EXIT
    //DEFAULT
    //   cMsg += cFile + " PRINTED OK!!!"
    END
    *
    alert(cMsg)
    EndIf
 *
 Return .T.
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
  * Chama rotina para impressão
  cArq = "C:\RPS_HARB\ARQIMP"
  cTit = "IMPRIME LISTA RESUMO" 
  *
  return
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
