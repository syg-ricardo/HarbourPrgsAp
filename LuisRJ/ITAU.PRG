*  Sistema.....: ZIUL - Cobranca da manutencao
*  Programador.: Nando                                                  
*  Data........: 27/04/04                                                 
*  Programa....: ITAU.PRG
*  Descricao...: Grava arquivos para cobranca ITAU
*  Alteracao...: 
*  Data........:                                                  
*  Feita por...:
*
******************** ARQUIVOS/BOLETOS ITAU ********************
*-----------------*
 Procedure GR_ITAU
*-----------------*
  *
  ******************************************************************
  * Grava arquivo para cobranca ITAU **************************
  sele NOTAS
  set order to 4
  go top
  *
  * Cria arquivo TXT
  * ----------------
  WARQ_TXT = 'ARQUIVO.TXT'
  !del ARQUIVO.TXT
  NUM_ARQ := fcreate(WARQ_TXT,0)
  if NUM_ARQ = -1  && Deu erro
     MSG_ERRO('Problemas ao criar arquivo ARQUIVO.TXT! Tecle ENTER.')
     return
     endif
  *
  fclose(NUM_ARQ)
  NUM_ARQ := fopen(WARQ_TXT,2)
  if NUM_ARQ = -1  && Deu erro
     MSG_ERRO('Problemas ao abrir arquivo ARQUIVO.TXT! Tecle ENTER.')
     return
     endif
  *
  WTAM     = 402
  *WQUEM = 'I'
  SEQ_ITAU = 0
  clear gets
  do while .t.
     @ 05, 05 say 'Sequencial ITAU (ITAUnnn) ..:' get SEQ_ITAU pict '999';
              valid SEQ_ITAU > 0
     *
     read
     if lastkey() = TESC
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
*zzz     if WQUEM = 'I' 
        WCOD_GRAV = '11'
        set filter to NOT_CODCAR = '01' .and. NOT_BANCO = '3';
                      .and. NOT_CANCEL = ' '
*        else
*          WCOD_GRAV = '15'
*          set filter to NOT_CODCAR = '05' .and. NOT_BANCO = '3';
*                        .and. NOT_CANCEL = ' '
*        endif
     *
     go top
     if eof()
        MSG_ERRO('Nenhum Boleto para gravar! Tecle ENTER')
        exit
        endif
     *
     * Grava Registro 0-HEADER
     * -----------------------
     CRLF            = chr(13) + chr(10)
     CEDENTE         = 'ZIUL INFORMATICA LTDA         '
     CNPJ_CEDENTE    = '03211838000112'
     COD_AGENCIA     = '0314'
     COD_CONTA       = '22556'
     DV_CONTA        = '6'
     COD_BANCO       = '341'
     NOME_BANCO      = 'BANCO ITAU SA  '
     NUM_CARTEIRA    = '109'
     COD_CARTEIRA    = 'I'
     ID_OCORR        = '01'   && Remessa
     *
     REG = '0' + '1' + 'REMESSA' + '01' + 'COBRANCA       '
     REG = REG + COD_AGENCIA + '00' + COD_CONTA + DV_CONTA + '        '
     REG = REG + CEDENTE + COD_BANCO +  NOME_BANCO
     W0  = strzero(day(date()),2) + strzero(month(date()),2) +;
           right(str(year(date()),4),2)
     REG = REG + W0 + space(294) + '000001' + CRLF
     *
     POS = 0
     fseek(NUM_ARQ,POS)
     RET := fwrite(NUM_ARQ, REG, WTAM) 
     if RET # WTAM
        MSG_ERRO('ERRO ao gravar registro HEADER! Tecle ENTER.')
        fclose(NUM_ARQ)
        loop
        endif
     *
     POS = WTAM
     SEQ_REG = 1
     REGS_01 = 0
     *VL_TOT_TITULOS = 0.00
     *
     sele NOTAS
     do while !eof()
        WNOS_NUM = NOT_BOLETO
        sele RASGADOS
        seek WNOS_NUM
        if !found()
           *
           * Grava Registro 1-MOVIMENTO
           * --------------------------
           sele CLIENTES
           set order to 2
           seek NOTAS->NOT_CLIEN
           NOME_SACADO = left(CLI_NOME,30)
           CNPJ_SACADO = CLI_CGC
           *
           if CLI_ENDCOR = 0
              W0 = trim(CLI_TIPOEN) + ' ' + trim(CLI_ENDER) + ','
              if CLI_NUMERO > 0
                 W0 = W0 + ' ' + alltrim(str(CLI_NUMERO,6))
                 endif
              *
              if !empty(CLI_COMPL)
                 W0 = W0 + ' ' + trim(CLI_COMPL)
                 endif
              *
              if len(W0) > 40
                 W0 = left(W0,40)
                 MSG_ERRO('Ver endereco de: ' + trim(CLI_NOME))
                 endif
              *
              ENDER_SACADO  = trim(W0) + space(40-len(trim(W0)))
              UF_SACADO     = CLI_UF
              BAIRRO_SACADO = left(CLI_BAIRRO,12) 
              CEP_SACADO    = CLI_CEP
              CIDADE_SACADO = left(CLI_CIDADE,15)
              else
                sele ENDCOR
                seek CLIENTES->CLI_CODIGO
                if !found()
                   alert(" ERRO - Endereco de correspondencia nao encontrado! ")
                   quit
                   endif
                *
                ENDER_SACADO  = ENC_ENDER
                UF_SACADO     = ENC_UF
                BAIRRO_SACADO = left(ENC_BAIRRO,12) 
                CEP_SACADO    = ENC_CEP
                CIDADE_SACADO = left(ENC_CIDADE,15)
              endif
           *
           sele NOTAS
           SEQ_REG++
           REGS_01++
           REG = '1' + '02' + CNPJ_CEDENTE + COD_AGENCIA + '00' + COD_CONTA +;
                 DV_CONTA + '    ' + '0000' 
           *
           REG = REG + str(WNOS_NUM,5) + space(20)    && Num boleto
           *
           * Nosso numero
           W0 = strzero(WNOS_NUM,7)
           W1 = DV11_P(W0)
           NOSSO_NUM = W0 + W1
           REG = REG + NOSSO_NUM
           *
           *            Qt. moeda var
           REG = REG + '0000000000000' + NUM_CARTEIRA + space(21) +;
                       COD_CARTEIRA + ID_OCORR
           *
           REG = REG + strzero(NOT_NUMERO,10)     && Num. documento
           *
           W0 = strzero(day(NOT_VENCIM),2)    +;  && Data vencim.
                strzero(month(NOT_VENCIM),2)  +;
                right(str(year(NOT_VENCIM),4),2)
           REG = REG + W0
           *
           W0        = strzero(NOT_VALOR,14,2)
           VL_TITULO = left(W0,11) + right(W0,2)
           REG = REG + VL_TITULO + COD_BANCO + '00000' 
           *
           if NOT_TIPO = 'V'
              W0 = '01'
              else  && NOT_TIPO = 'S'
                W0 = '08'
              endif
           *   
           REG = REG + W0 + 'N'
           *
           W0  = strzero(day(NOT_DATA),2)   +;    && Data de emiss.
                 strzero(month(NOT_DATA),2) +;    && Mesma data da NF
                 right(str(year(NOT_DATA),4),2)
           REG = REG + W0 + '94' + '  ' + '0000000000000' + '000000'    +;
                       '0000000000000' + '0000000000000' + '0000000000000'
           REG = REG + '02' + CNPJ_SACADO + NOME_SACADO + space(10)
           REG = REG + ENDER_SACADO + BAIRRO_SACADO        +;
                       CEP_SACADO + CIDADE_SACADO + UF_SACADO
           *
           MSG01 = 'Ref.: N. Fiscal ' + alltrim(str(NOT_NUMERO,6))
           if !empty(NOT_PARCEL)
              MSG01 = MSG01 + ' - Parc.' + NOT_PARCEL
              endif
           *
           REG = REG + MSG01 + space(40-len(MSG01)) +;
                 '00 ' + strzero(SEQ_REG,6) + CRLF
           *
           * Grava Registro
           * --------------
           fseek(NUM_ARQ,POS)
           RET := fwrite(NUM_ARQ, REG, WTAM) 
           if RET # WTAM
              MSG_ERRO('ERRO ao gravar registro MOVIMENTO! Tecle ENTER.')
              exit
              endif
           *  
           POS = POS + WTAM
           endif
        *
        * Proximo boleto
        sele NOTAS
        repla NOT_CODCAR with WCOD_GRAV
        skip
        WNOS_NUM = NOT_BOLETO
        enddo
     *
     * Grava Registro 9-TRAILLER
     * -------------------------
     SEQ_REG++
     REG = '9' + space(393) + strzero(SEQ_REG,6) + CRLF
     *
     * Grava Registro
     * --------------
     fseek(NUM_ARQ,POS)
     RET := fwrite(NUM_ARQ, REG, WTAM) 
     if RET # WTAM
        MSG_ERRO('ERRO ao gravar registro TRAILLER! Tecle ENTER.')
        exit
        endif
     *
     exit
     enddo
  *
  fclose(NUM_ARQ)
  PATH_ARQGR = 'ITAU' + strzero(SEQ_ITAU,3) + '.TXT'
  *
  if file(PATH_ARQGR)              && Se existe o arquivo
     W1 := ferase(PATH_ARQGR)      && Apaga o arquivo
     endif
  *
  W2 := frename(WARQ_TXT,PATH_ARQGR)  && Renomeia o arquivo
  *
  sele NOTAS
  set filter to
  *
  * Imprime Relatorio de boletos gravados
  BOL_GRAV()
  *
  sele NOTAS 
  set order to 1
  *
  sele CLIENTES
  set order to 1
  return
*
******************************************************************
* Le arquivo da cobranca ITAU ************************************
*-----------------*
 Procedure LE_ITAU
*-----------------*
  *
  * Cobranca ITAU
  * Trata arquivos recebidos
  *
  do while .t.
     MOPCAO = 0
     clear screen
     @ 05, 05 say '1-Incluir Movimento'
     @ 06, 05 say '2-Dar baixa na Cobranca'
     @ 08, 05 say 'Opcao?' get MOPCAO pict '9'
     read
     if lastkey() = 27
        clear screen
        return
        endif
     *
     OK = ' '
     @ 10, 05 say 'Confirma?' get OK pict '!' valid OK $ 'SN' 
     read
     if OK = 'N'
        loop
        endif
     *
     if MOPCAO = 1
        INCL_MOV()
        elseif MOPCAO = 2
          BAIXA()
        endif
     * 
     enddo
  *
  return .t.
*
* ********************* PROCESSA ARQ MOV ITAU *********************
*-----------------*
 Function INCL_MOV
*-----------------*
  sele NOTAS
    set order to 2
  *
  clear screen
  WARQ = 0
  @ 05, 05 say 'Arquivo:' get WARQ pict '999'
  read
  XARQ = strzero(WARQ,3) + '_CN~1.RET'
  if !file(XARQ)
     alert("Arquivo " + XARQ + " Nao encontrado!!!")
     return
     endif
  *
  sele 15
    use ARQ_REC
    zap
    appe from &XARQ SDF
    go top
  *
  * Registro HEADER
  * ---------------
  WDIA = left(DT_MOVIM,2)
  WMES = substr(DT_MOVIM,3,2)
  WANO = right(DT_MOVIM,2)
  WDT_MOVIM = WDIA + '/' + WMES + '/' + WANO
  *
  * ---------------------------------------------------------
  * Verifica se ja' processou este arquivo
    sele 14
    use MOV_REC
    index on MOV_DATA to IDTMOVIM
    go top
    seek WDT_MOVIM
    if found()
       alert("Arquivo com Data de Movimento: " + WDT_MOVIM +;
             " ja' processado!!!")
       sele ARQ_REC
       use
       sele MOV_REC
       use
       return
       endif
    *
    use
    use MOV_REC  && Sem Indice
  * ---------------------------------------------------------
  *
  * Grava registros em MOV_REC.DBF
  *
  sele ARQ_REC
  index on TIPO_REG to IARQ_REG
  go top
  skip
  *
  XARQ = 'REL_' + strzero(WARQ,3) + '.TXT'
  set console off
  set printer to &XARQ
  set print on
  *
  sele ARQ_REC
  do while TIPO_REG <> '9' .and. !eof()
     COD_OCORR = left(SEQ_ARQ,2)
     WBOLETO   = val(SEU_NUM)
     sele NOTAS
     seek WBOLETO
     WNOTA   = NOT_NUMERO
     WFANTAS = NOT_FANTAS
     WPARCEL = NOT_PARCEL
     WCODCLI = NOT_CLIEN
     *
     sele CLIENTES
     set order to 2
     seek WCODCLI
     WRASOC = CLI_NOME
     *
     sele ARQ_REC
     WCOD_OCORR = COD_OCORR
     WDIA       = left(DT_VENCIM,2)
     WMES       = substr(DT_VENCIM,3,2)
     WANO       = right(DT_VENCIM,2)
     WDT_VENC   = WDIA + '/' + WMES + '/' + WANO
     WVALOR     = val(left(VALOR,11) + '.' + right(VALOR,2))
     WDESP_COBR = val(left(DESP_COBR,11) + '.' + right(DESP_COBR,2))
     WVALOR_LIQ = val(left(VALOR_LIQ,11) + '.' + right(VALOR_LIQ,2))
     *
     if WCOD_OCORR = '06'  && Liquidacoes
        WDIA       = left(DT_CREDITO,2)
        WMES       = substr(DT_CREDITO,3,2)
        WANO       = right(DT_CREDITO,2)
        WDT_CRED   = WDIA + '/' + WMES + '/' + WANO
        WVALOR_REC = WVALOR_LIQ + WDESP_COBR 
        endif
        *
     if ESPEC_DOC = '01'
        WESP_DOC = 'VE'
        elseif ESPEC_DOC = '08'
          WESP_DOC = 'SV'
        else
          WESP_DOC = '  '
        endif
     *
     sele MOV_REC
     appe blank
     repla MOV_DATA   with WDT_MOVIM
     repla MOV_CODOCO with WCOD_OCORR
     repla MOV_FANTAS with WFANTAS
     repla MOV_RASOC  with WRASOC 
     repla MOV_BOLETO with WBOLETO
     repla MOV_NOTA   with WNOTA
     repla MOV_ESPDOC with WESP_DOC
     repla MOV_PARCEL with WPARCEL
     repla MOV_DTVENC with WDT_VENC
     repla MOV_VALOR  with WVALOR
     repla MOV_DESP   with WDESP_COBR
     *
     if WCOD_OCORR = '06'  && Liquidacoes
        repla MOV_DTCRED with WDT_CRED
        repla MOV_VALREC with WVALOR_REC
        endif
     *
     sele ARQ_REC
     skip
     enddo
  *
  * ******************************************************************
  * Imprime ERROS
  * ******************************************************************
  sele 16
    use COD_OCOR
    index on OCO_CODIGO to ICODOC
    go top
  *
  sele MOV_REC
  set filter to MOV_DATA = WDT_MOVIM;
      .and. MOV_CODOCO <> '02' .and. MOV_CODOCO <> '06'
  index on MOV_BOLETO to ITEMP
  go top
  *
  CONT_BOL   = 0
  CONT_LIN   = 5
  WTOT_VALOR = 0.00
  WTOT_DESP  = 0.00
  XTOT_DESP  = 0.00
  if !eof()
     ? '          Cobranca ITAU - ' + WDT_MOVIM + ' - OUTROS CODS'
     ? '          ======================================'
     ? '--------------- ------- ------- --- ----- -------- --------- ---- ---------- ------'
     ? 'Cliente          Boleto N. Fisc S/V Parc  Dt Venc      Valor Cod. Ocorrenc.   Desp.'
     ? '--------------- ------- ------- --- ----- -------- --------- ---- ---------- ------' 
     *
     do while !eof()
        *--------------- ------- ------- --- ----- -------- --------- ---- ---------- ------
        *Cliente          Boleto N. Fisc S/V Parc  Dt Venc      Valor Cod. Ocorrenc.   Desp.
        *--------------- ------- ------- --- ----- -------- --------- ---- ---------- ------ 
        *X-------------X 999.999 999.999 XX  99/99 99/99/99 99.999,99  99  X--------X 999.99
        *X-------------X 999.999 999.999 XX  99/99 99/99/99 99.999,99  99  X--------X 999.99
        *
        sele COD_OCOR
        seek MOV_REC->MOV_CODOCO
        WOCOR = OCO_DESCRI
        sele MOV_REC
        
        ? MOV_FANTAS + ' ' + tran(MOV_BOLETO, '@E 999,999') + ' '             +;
          tran(MOV_NOTA, '@E 999,999') + ' ' + MOV_ESPDOC + '  ' + MOV_PARCEL +;
          ' ' + MOV_DTVENC + ' ' + tran(MOV_VALOR, '@E 99,999.99') + '  '     +;
          MOV_CODOCO + '  ' + WOCOR + ' ' + tran(MOV_DESP, '@E 999.99')
        *
        WTOT_VALOR = WTOT_VALOR + MOV_VALOR
        WTOT_DESP  = WTOT_DESP  + MOV_DESP
        CONT_LIN++
        CONT_BOL++                         
        skip
        enddo
     * 
     ? repl('-', 83)
     ? '        Totais: ' + tran(CONT_BOL, '@E 999,999') + space(27) +;
       tran(WTOT_VALOR, '@E 999,999.99') + space(17) + tran(WTOT_DESP, '@E 999.99')
     *
     XTOT_DESP = XTOT_DESP + WTOT_DESP
     endif
  *  
  sele COD_OCOR
  use
  *
  * ******************************************************************
  * Imprime ENTRADAS
  * ******************************************************************
  *
  if CONT_LIN > 50
     eject
     else
       ?;?;?;?
     endif
  *
  sele MOV_REC
  set filter to MOV_DATA = WDT_MOVIM .and. MOV_CODOCO = '02'
  index on MOV_BOLETO to ITEMP
  go top
  *
  ? '          Cobranca ITAU - ' + WDT_MOVIM + ' - Entradas'
  ? '          ==================================='
  ? '--------------- ------- ------- --- ----- -------- ---------'
  ? 'Cliente          Boleto N. Fisc S/V Parc  Dt Venc      Valor'
  ? '--------------- ------- ------- --- ----- -------- ---------' 
  *
  CONT_BOL   = 0
  CONT_LIN   = 5
  WTOT_VALOR = 0.00
  do while !eof()
     *--------------- ------- ------- --- ----- -------- ---------
     *Cliente          Boleto N. Fisc S/V Parc  Dt Venc      Valor
     *--------------- ------- ------- --- ----- -------- --------- 
     *X-------------X 999.999 999.999 XX  99/99 99/99/99 99.999,99
     *X-------------X 999.999 999.999 XX  99/99 99/99/99 99.999,99
     *
     ? MOV_FANTAS + ' ' + tran(MOV_BOLETO, '@E 999,999') + ' '          +;
       tran(MOV_NOTA, '@E 999,999') + ' ' + MOV_ESPDOC + '  ' + MOV_PARCEL +;
       ' ' + MOV_DTVENC + ' ' + tran(MOV_VALOR, '@E 99,999.99')
     *
     WTOT_VALOR = WTOT_VALOR + MOV_VALOR
     CONT_LIN++
     CONT_BOL++                         
     skip
     enddo
  * 
  ? repl('-', 60)
  ? '        Totais: ' + tran(CONT_BOL, '@E 999,999') + space(27) +;
    tran(WTOT_VALOR, '@E 999,999.99')
  *
  * ******************************************************************
  * Imprime LIQUIDACOES
  * ******************************************************************
  sele MOV_REC
  set filter to MOV_DATA = WDT_MOVIM .and. MOV_CODOCO = '06'
  index on MOV_BOLETO to ITEMP
  go top
  *
  if CONT_LIN > 50
     eject
     else
       ?;?;?;?
     endif
  *
  ? '                Cobranca ITAU - ' + WDT_MOVIM + ' - Liquidacoes - ' + XARQ
  ? '                ===================================================='
  ? '--------------- ------- ------- --- ----- -------- --------- -------- --------- ------'
  ? 'Cliente          Boleto N. Fisc S/V Parc  Dt Venc      Valor Dt Liq.  Valor Rec  Desp.'
  ? '--------------- ------- ------- --- ----- -------- --------- -------- --------- ------'
  *  X-------------X  99.999  99.999  X  99/99 99/99/99 99.999,99 99/99/99 99.999,99 999,99


  CONT_BOL    = 0
  CONT_LIN    = 5
  WTOT_VALOR  = 0.00
  WTOT_VALREC = 0.00
  WTOT_DESP   = 0.00
  do while !eof()
     if CONT_LIN = 60
        eject
        ? '                     Cobranca ITAU - ' + WDT_MOVIM + ' Liquidacoes - MOV' + strzero(WARQ,4)
        ? '                ====================================================='
        ? '--------------- ------- ------- --- ----- -------- --------- -------- --------- ------'
        ? 'Cliente          Boleto N. Fisc S/V Parc  Dt Venc      Valor Dt Liq.  Valor Rec  Desp.'
        ? '--------------- ------- ------- --- ----- -------- --------- -------- --------- ------'
        CONT_LIN = 3
        endif
     *  
     ? MOV_FANTAS + ' ' + tran(MOV_BOLETO, '@E 999,999') + ' '                +;
       tran(MOV_NOTA, '@E 999,999') + ' ' + MOV_ESPDOC + '  '    + MOV_PARCEL +;
       ' ' + MOV_DTVENC + ' ' + tran(MOV_VALOR, '@E 99,999.99') + ' '         +;
       MOV_DTCRED + ' ' + tran(MOV_VALREC, '@E 99,999.99') + ' ' + tran(MOV_DESP, '@E 999.99')
     *
     WTOT_VALOR  = WTOT_VALOR  + MOV_VALOR
     WTOT_VALREC = WTOT_VALREC + MOV_VALREC
     WTOT_DESP   = WTOT_DESP   + MOV_DESP
     CONT_LIN++
     CONT_BOL++                         
     skip
     enddo
  *
  ? repl('-', 79)
  ? '        Totais: ' + tran(CONT_BOL, '@E 999,999') + space(27) +;
    tran(WTOT_VALOR, '@E 999,999.99') + space(9)                  +;
    tran(WTOT_VALREC, '@E 999,999.99')
  *
  ? '  Desp. Liquid: ' + space(57) + tran(WTOT_DESP, '@E 999.99')
  *
  XTOT_DESP = XTOT_DESP + WTOT_DESP
  *
  ? 
  ? 'Total de Desp.: ' + space(57) + tran(XTOT_DESP, '@E 999.99')
  *
  set console on
  set print off
  set printer to
  sele NOTAS
  set order to 1
  sele ARQ_REC
  use
  sele MOV_REC
  use
  MSG_ERRO("Arquivo com Data de Movimento " + WDT_MOVIM +;
             " processado com sucesso. Tecle ENTER")
  return .t.
*
* ************************* LANCA PGTO EM NOTAS ************************
*--------------*
 Function BAIXA
*--------------*
  sele NOTAS
    set order to 2
    go top
  *
  sele 14
    use MOV_REC
    set filter to MOV_CODOCO = '06' .and. MOV_BAIXA = ' '
    go top
  *
  do while !eof()
     WBOLETO = MOV_BOLETO
     sele NOTAS
     seek WBOLETO
     if found()
        repla NOT_PAGO  with 'PG'
        sele MOV_REC
        repla MOV_BAIXA with '1'
        else
          alert('Boleto ' + alltrim(str(WBOLETO,6)) + 'Nao encontrado!')
        endif
     *
     sele MOV_REC
     skip
     enddo
  *
  sele NOTAS
  set order to 1
  sele MOV_REC
  use
  MSG_ERRO("Lancado PG nos boletos pagos. Tecle ENTER")
  return .t.
*
******************************************************************
* Emite TODAS as Boletas do ITAU ****************************
*--------------------*
 Procedure ITAU_TODAS
*--------------------*
  WMES = strzero(month(date()),2)
  WANO = right(strzero(year(date()),4),2)
  DT_VENCIM  = ctod('10/' + WMES + '/' + WANO)
  DT_EMISS   = date()
  DT_LIMITE  = ULTIMO_DIA(val(WMES), val(WANO))
  WMES_ANT := if(month(DT_EMISS)=1,'12',strzero(month(date())-1,2))
  WANO_ANT := if(month(date())=1,  right(strzero(year(date())-1,4),2),;
                                   right(strzero(year(date()),4),2))  
  VALID      = MESES[val(WMES_ANT)] + '/' + WANO_ANT
  SAI = .f.
  do while .t.
     @ 03, 05 say 'Data de Vencimento:' get DT_VENCIM
     @ 04, 05 say 'Data de Emissao ..:' get DT_EMISS
     @ 05, 05 say 'Data limite ......:' get DT_LIMITE
     @ 06, 05 say 'Referencia .......:' get VALID pict '@! XXX/99'
     read
     if lastkey() = TESC
        SAI := .t.
        exit
        endif
     *
     OK := 'S'
     P2OKSN('Confirma')
     if OK = 'S'
        exit
        endif
     enddo
  *
  if SAI
     set filter to
     return
     endif
  *
  sele CLIENTES
  set order to 2
  MNOTAI = 0
  MNOTAF = 0
  sele NOTAS
  set order to 2
  go bottom
  WNUM_BOLETO = NOT_BOLETO + 1
  set filter to NOT_TIPO = 'S'
  go top
  *
  do while .t.
     @ 08, 10 say 'Nota fiscal INICIAL numero:' get MNOTAI
     @ 09, 10 say 'Nota fiscal FINAL numero..:' get MNOTAF
     @ 11, 05 say 'Boleto inicial numero:' get WNUM_BOLETO;
              pict '@E 999,999' valid WNUM_BOLETO # 0
     read
     if lastkey() = TESC
        sele NOTAS
        set order to 1
        set filter to
        sele CLIENTES
        set order to 1
        return
        endif
     *
     seek WNUM_BOLETO
     if found()
        MSG_ERRO('Boleto ja lancado! Tecle ENTER')
        loop
        endif
     *
     set order to 1
     seek str(MNOTAI,6)
     if !found()
        MSG_ERRO('Nota fiscal nao encontrada! Tecle ENTER')
        loop
        endif
     *
     OK = 'N'
     P2OKSN('Confirma')
     if OK = 'N'
        loop
        endif
     *
     exit
     enddo
  *
  WCOD_GRAV = '01'
  MNOTA = MNOTAI
  do while MNOTA <= MNOTAF .and. !eof()
     X := inkey()
     if X = TESC
        exit
        endif
     * 
     if NOT_CANCEL = 'C'   && Pula canceladas
        skip
        loop
        endif
     *
     WVALOR = NOT_VALOR
     *
     if NOT_BOLETO > 0
        WOK := alert("Ja' emitido boleto para a NF "    +;
                      alltrim(tran(MNOTA,'@E 999,999')) +;
                      ' Continua ?',                     ;
                      {"SIM", "NAO"})
        if WOK = 1
           skip
           loop
           else
             set device to screen
             set print off
             return
           endif
        endif
     *
     * Grava dados do boleto em NOTAS
     * ---------------------------------------------------
     * Alteracao para data de vencimento para cada cliente
     * ---------------------------------------------------
     *
     sele CLIENTES
     seek NOTAS->NOT_CLIEN
     if !empty(CLI_DIAVEN)
        WDT_VENCLI = ctod(CLI_DIAVEN + '/' + WMES + '/' + WANO)
        else
          WDT_VENCLI = DT_VENCIM
        endif
     * ---------------------------------------------------
     *
     sele NOTAS
     repla NOT_CODCAR with WCOD_GRAV
     repla NOT_BANCO  with '3'
     repla NOT_BOLETO with WNUM_BOLETO
     repla NOT_VENCIM with WDT_VENCLI 
     WNUM_BOLETO++ 
     *
     skip
     MNOTA++
     enddo
  *
  set filter to
  return
*
******************************************************************
* Emite Boletas Selecionadas do ITAU ************************
*--------------------*
 Procedure ITAU_SELEC
*--------------------*
  do while .t.
     WNUM_BOLETO = 0
     WDIA_VENCIM = 0
*zzz     WQUEM       = ' '
     WTIPO_NOTA  = ' '
     WFILTRO     = ''
     sele NOTAS
     set order to 2
     do while .t.
        @ 02, 05 say 'Boleto inicial numero:' get WNUM_BOLETO;
              pict '@E 999,999' valid WNUM_BOLETO # 0
        @ 03, 05 say 'Dia do vencimento ...:' get WDIA_VENCIM;
              pict '99' valid WDIA_VENCIM > 0 .and. WDIA_VENCIM < 32
*        @ 04, 05 say 'Itau Imprime(I) ou Ziul Imprime(Z):';
*zzz              get WQUEM pict '@!' valid(WQUEM $ 'IZ')
        read
        *
        if lastkey() = TESC
           set order to 1
           if !empty(WFILTRO)
              set filter to
              endif
           return
           endif
        *
        seek WNUM_BOLETO
        if found()
           MSG_ERRO("Boleto ja' emitido! Tecle ENTER")
           loop
           endif
        *
        @ 06, 05 say 'Nota de (S)ervico ou (V)enda:' get WTIPO_NOTA;
                 pict '!' valid WTIPO_NOTA $ 'SV' 
        read
        if lastkey() = TESC
           loop
           endif
        *
        DIA_VENCIM = strzero(WDIA_VENCIM,2)
        set order to 1
        WFILTRO = "NOT_TIPO='" + WTIPO_NOTA + "'"
        set filter to &WFILTRO
        go bottom
        skip -10
        exit
        enddo
     *
*zzz     if WQUEM = 'I'
        WCOD_GRAV = '01'
*        else
*          WCOD_GRAV = '05'
*        endif
     *
     CANCELOU = .f.
     do while .t.
        sele NOTAS
        SALVATELA := savescreen(07,10,22,70)
        @ 07,02 clear to 22,70
        @ 07,10 to 22,70
        do while .t.
           dbedit(08,11,21,69,)
           if lastkey() = TESC
              CANCELOU = .t.
              exit
              endif
           *
           if NOT_BOLETO > 0
              OK = 'N'
              P2OKSN("Boleto ja' emitido para esta Nota fiscal! Emite outro")
              if OK = 'N'
                 loop
                 endif
              PARC_NOT = NOT_PARCEL
              else
                PARC_NOT = ' '  
              endif
           *
           exit
           enddo
        *
        if CANCELOU
           exit
           endif
        *
        restscreen(07,10,22,70,SALVATELA)
        MCLI       = NOT_CLIEN
        MNOTA      = NOT_NUMERO
        MVALOR     = NOT_VALOR
        MDATA_NOTA = NOT_DATA
        sele CLIENTES
        set order to 2
        seek MCLI
        set order to 1
        @ 07, 05 say 'Nota fiscal:' get MNOTA pict '@E 999,999'
        @ 07, 27 say 'Cliente:' get CLI_NOME
        clear gets
        if month(date()) = 12
           WMES_SEG = '01'
           WANO     = right(strzero(year(date())+1,4),2)
           else
             WMES_SEG = strzero(month(date())+1,2)
             WANO     = right(strzero(year(date()),4),2)
           endif
        *
        PARCELAS   = 1
        MDT_VENC   = ctod(DIA_VENCIM + '/' + WMES_SEG + '/' + WANO)
        DT_EMISS   = date()
        DT_LIMITE  = ULTIMO_DIA(val(WMES_SEG), val(WANO))
        VALID      = MESES[month(date())] + '/' +;
                     right(strzero(year(date()),4),2)
        *
        do while .t.
           @ 09, 34 say 'Boleto:' get WNUM_BOLETO pict '@E 999,999'
           clear gets
           @ 09, 05 say 'Parcelas .........:' get PARCELAS  pict '99'
           @ 10, 05 say 'Data de Vencimento:' get MDT_VENC  when PARCELAS = 1
           @ 11, 05 say 'Data de Emissao ..:' get DT_EMISS
           @ 12, 05 say 'Data limite ......:' get DT_LIMITE
           @ 13, 05 say 'Referencia .......:' get VALID  pict '@! XXX/99'
           @ 14, 05 say 'Valor ............:' get MVALOR pict '@E 999,999.99'
           read
           if lastkey() = TESC
              CANCELOU = .t.
              exit
              endif
           *
           MULTA = MVALOR * 0.02
           MSG1  = 'Apos vencimento, multa de 2% (R$' +;
                    alltrim(tran(MULTA, '@E 999.99')) + ')'
           MORA  = 0.00033  && 0,033%
           WMORA = MVALOR * MORA
           MSG2  = 'Data limite para pagamento em banco: ' + dtoc(DT_LIMITE)
           MSG3  = 'Referencia: Nota fiscal Num.'               +;
                    alltrim(tran(MNOTA, '@E 999,999')) + ' de ' +;
                    dtoc(MDATA_NOTA)
           *   
           @ 16, 05 say 'MSG1 .............:' get MSG1
           @ 17, 05 say 'MSG2 .............:' get MSG2
           @ 18, 05 say 'MSG3 .............:' get MSG3
           read
           if lastkey() = TESC
              CANCELOU = .t.
              exit
              endif
           *
           OK = 'S'
           P2OKSN('Confirma')
           if OK = 'S'
              exit
              endif
           enddo
        *
        if CANCELOU
           loop
           endif
        *  
        if PARCELAS > 1
           for I1 = 1 to PARCELAS
               WI = strzero(I1,2)
               DT_PARC&WI = ctod('')
               next I1
           *
           do while .t.
              for I1 = 1 to PARCELAS
                  WI = strzero(I1,2)
                  @ 19+I1, 05 say 'Vencimento da parcela ' + tran(I1, '@E 99');
                              get DT_PARC&WI
                  next I1
              *
              read
              if lastkey() = TESC
                 CANCELOU = .t.
                 exit
                 endif
              *
              ERRO = .f.
              for I1 = 1 to PARCELAS
                  WI1 = strzero(I1,2)
                  WI2 = strzero(I1+1,2)
                  if I1 # PARCELAS
                     if DT_PARC&WI2 <= DT_PARC&WI1
                        MSG_ERRO('Data da parcela ' + WI2 + ' deve ser' +;
                                 ' maior que da ' + WI1 + '! Tecle ENTER')
                        ERRO = .t.
                        exit
                        endif
                     endif
                  next I1
              *
              if ERRO
                 loop
                 endif
              *
              OK = 'S'
              P2OKSN('Confirma')
              if OK = 'S'
                 exit
                 endif
              enddo
           *  
           if CANCELOU
              exit
              endif
           *
           WTOT = 0.00
           for I1 = 1 to PARCELAS
               WI = strzero(I1,2)
               VL_PARC&WI = round(MVALOR/PARCELAS,2)
               WTOT = WTOT + VL_PARC&WI
               next I1
           *
           if WTOT > MVALOR
              for I1 = 1 to PARCELAS
                  WI = strzero(I1,2)
                  VL_PARC&WI = VL_PARC&WI - 0.01
                  next I1
              endif
           *
           J1 = 0
           do while .t.
              WVAL = 0.00
              for I1 = 1 to PARCELAS
                  WI = strzero(I1,2)
                  WVAL = WVAL + VL_PARC&WI
                  next I1
              *
              if strzero(WVAL,12,2) = strzero(MVALOR,12,2)
                 exit
                 else
                   J1++
                   WJ = strzero(J1,2)
                   VL_PARC&WJ = VL_PARC&WJ + 0.01
                 endif
              enddo
           *
           else
             VL_PARC01 = MVALOR
             DT_PARC01 = MDT_VENC
           endif
        *  
*zzz     if WQUEM = 'Z'
*           set device to print
*           set print on
*           NROW := prow()
*           NCOL := pcol()
*           ?? chr(27) + '0' + chr(15) + chr(27) + 'C' + chr(32)
*           *  | 8 lin/pol   | condens.|   32 linhas  pagina   |
*           setprc(NROW, NCOL)
*           endif
        *
        WTOT_PARC = strzero(PARCELAS,2)
        for I1 = 1 to PARCELAS
            WI = strzero(I1,2)
            if PARCELAS > 1
               WPARC = WI + '/' + WTOT_PARC
               *@ 02, 94 say WPARC
               MSG3 = 'Referencia: Nota fiscal '       +;
                    alltrim(tran(MNOTA, '@E 999,999')) +;
                    ' - Parcela: ' + WPARC
               endif
            *
*zzz         if WQUEM = 'Z'
*               @ 01, 01 say 'PAGAR PREFERENCIALMENTE EM AGENCIA ITAU'
*               @ 01, 98 say dtoc(DT_PARC&WI)
*               @ 05, 01 say dtoc(DT_EMISS)
*               @ 05, 16 say strzero(WNUM_BOLETO,5)
*               @ 05, 48 say 'R$'
*               @ 07, 28 say '101'
*               @ 07, 98 say VL_PARC&WI pict '@E 999,999.99'
*               endif
            *
            * Monta Data limite p/ PG da parcela
            WANO      = right(strzero(year(DT_PARC&WI),4),2)
            DT_LIMITE = ULTIMO_DIA(month(DT_PARC&WI), val(WANO))
            MSG2  = 'Data limite para pagamento em banco: ' + dtoc(DT_LIMITE)
            *
            * Monta multa da parcela
            MULTA = VL_PARC&WI * 0.02
            MSG1  = 'Apos vencimento, multa de 2% (' +;
                     alltrim(tran(MULTA, '@E 999.99')) + ')'
            MORA  = 0.00033   && 0,033%
            WMORA = VL_PARC&WI * MORA
            MSG4  = 'e juros de R$ ' + alltrim(tran(WMORA, '@E 999.99')) +;
                    ' por dia de atraso.'
            *
/*zzz       if WQUEM = 'Z'
               @ 10,  15 say MSG1
               @ 12,  15 say MSG4
               @ 14,  15 say MSG2
               @ 16,  15 say MSG3
               *
               sele CLIENTES
               if len(trim(CLI_CGC)) = 11
                  @ 19, 15 say CLI_NOME + space(28)            +;
                               tran(CLI_CGC, '@R 999.999.999-99')
                  else
                    @ 19, 15 say CLI_NOME + space(28)                +;
                                 tran(CLI_CGC, '@R 99.999.999/9999-99')
                  endif
               *
               *@ 20,  15 say trim(CLI_ENDER) + ' - ' + CLI_BAIRRO
               @ 20, 15 say trim(CLI_TIPOEN) + ' ' + trim(CLI_ENDER)
               if CLI_NUMERO > 0
                  @ 20, pcol() say ', ' + alltrim(str(CLI_NUMERO,6,0))
                  endif
               *
               if !empty(CLI_COMPL)
                  @ 20, pcol() say ' ' + trim(CLI_COMPL)
                  endif
               *
               @ 20, pcol() say ' - ' + trim(CLI_BAIRRO)
               @ 21,  15 say trim(CLI_CIDADE) + ' - ' + CLI_UF
               eject
               else
*/
                  MSG_ERRO('Boleto Gravado! Tecle ENTER')
*              endif
            *
            * Grava numero do boleto
            sele NOTAS
            if PARCELAS = 1
               repla NOT_BANCO  with '3'
               repla NOT_BOLETO with WNUM_BOLETO
               repla NOT_VENCIM with DT_PARC01
               repla NOT_VALOR  with MVALOR         && Regrava valor, caso
               repla NOT_CODCAR with WCOD_GRAV      &&   tenha sido alterado.
               else
                 if I1 = 1
                    repla NOT_VALOR  with VL_PARC01 
                    repla NOT_BANCO  with '3'
                    repla NOT_BOLETO with WNUM_BOLETO
                    repla NOT_VENCIM with DT_PARC01
                    repla NOT_PARCEL with '01/' + WTOT_PARC
                    repla NOT_CODCAR with WCOD_GRAV
                    else
                      appe blank
                      repla NOT_NUMERO with MNOTA
                      repla NOT_TIPO   with WTIPO_NOTA
                      repla NOT_CLIEN  with MCLI
                      repla NOT_FANTAS with CLIENTES->CLI_FANTAS
                      repla NOT_DATA   with MDATA_NOTA
                      repla NOT_VALOR  with VL_PARC&WI 
                      repla NOT_BANCO  with '3'
                      repla NOT_BOLETO with WNUM_BOLETO
                      repla NOT_VENCIM with DT_PARC&WI
                      repla NOT_PARCEL with WI + '/' + WTOT_PARC
                      repla NOT_CODCAR with WCOD_GRAV
                    endif
               endif
            *
            WNUM_BOLETO++
            next I1
        *
        set device to screen
        set print off
        enddo
     *
*zzz  if WQUEM = 'Z'
 *       @prow(), 00 say chr(27) + '2' + chr(18) + chr(27) + 'C' + chr(87)
 *       set device to screen
 *       set print off
 *       endif
     *
     set filter to
     enddo
  *
  return
*
******************************************************************
* Reemite boleto  ************************************************
*--------------------*
 Procedure ITAU_REEMI
*--------------------*
  do while .t.
     WNUM_BOLETO = 0
     WDIA_VENCIM = 0
*zzz     WQUEM       = ' '
     WTIPO_NOTA  = ' '
     WFILTRO     = ''
     sele NOTAS
     set order to 2
     do while .t.
        @ 02, 05 say 'Boleto inicial numero:' get WNUM_BOLETO;
              pict '@E 999,999' valid WNUM_BOLETO # 0
        @ 03, 05 say 'Dia do vencimento ...:' get WDIA_VENCIM;
              pict '99' valid WDIA_VENCIM > 0 .and. WDIA_VENCIM < 32
*        @ 04, 05 say 'Itau Imprime(I) ou Ziul Imprime(Z):';
*zzz              get WQUEM pict '@!' valid(WQUEM $ 'IZ')
        read
        if lastkey() = TESC
           set order to 1
           if !empty(WFILTRO)
              set filter to
              endif
           return
           endif
        *
        seek WNUM_BOLETO
        if found()
           MSG_ERRO("Boleto ja' emitido! Tecle ENTER")
           loop
           endif
        *
        @ 05, 05 say 'Nota de (S)ervico ou (V)enda:' get WTIPO_NOTA;
                 pict '!' valid WTIPO_NOTA $ 'SV' 
        read
        if lastkey() = TESC
           loop
           endif
        *
        DIA_VENCIM = strzero(WDIA_VENCIM,2)
        set order to 1
        WFILTRO = "NOT_TIPO='" + WTIPO_NOTA + "'"
        set filter to &WFILTRO
        go bottom
        skip -10
        exit
        enddo
     *
*zzz     if WQUEM = 'I'
        WCOD_GRAV = '01'
*        else
*          WCOD_GRAV = '05'
*        endif
     *
     CANCELOU = .f.
     do while .t.
        sele NOTAS
        SALVATELA := savescreen(07,10,22,70)
        @ 07,02 clear to 22,70
        @ 07,10 to 22,70
        do while .t.
           dbedit(08,11,21,69,)
           if lastkey() = TESC
              CANCELOU = .t.
              exit
              endif
           *
           if NOT_BOLETO = 0
              OK = 'N'
              MSG_ERRO("Boleto nao emitido para esta Nota fiscal! Tecle ENTER")
              loop
              endif
           *
           exit
           enddo
        *
        if CANCELOU
           exit
           endif
        *
        restscreen(07,10,22,70,SALVATELA)
        MCLI       = NOT_CLIEN
        MNOTA      = NOT_NUMERO
        MVALOR     = NOT_VALOR
        MDATA_NOTA = NOT_DATA
        PARCELA    = NOT_PARCEL
        sele CLIENTES
        set order to 2
        seek MCLI
        set order to 1
        @ 07, 05 say 'Nota fiscal:' get MNOTA pict '@E 999,999'
        @ 07, 27 say 'Cliente:' get CLI_NOME
        clear gets
        if month(date()) = 12
           WMES_SEG = '01'
           WANO     = right(strzero(year(date())+1,4),2)
           else
             WMES_SEG = strzero(month(date())+1,2)
             WANO     = right(strzero(year(date()),4),2)
           endif
        *
        MDT_VENC   = ctod(DIA_VENCIM + '/' + WMES_SEG + '/' + WANO)
        DT_EMISS   = date()
        DT_LIMITE  = ULTIMO_DIA(val(WMES_SEG), val(WANO))
        VALID      = MESES[month(date())] + '/' +;
                     right(strzero(year(date()),4),2)
        *
        do while .t.
           @ 09, 34 say 'Boleto:' get WNUM_BOLETO pict '@E 999,999'
           clear gets
           @ 09, 05 say 'Parcela ..........:' get PARCELA 
           @ 10, 05 say 'Data de Vencimento:' get MDT_VENC  
           @ 11, 05 say 'Data de Emissao ..:' get DT_EMISS
           @ 12, 05 say 'Data limite ......:' get DT_LIMITE
           @ 13, 05 say 'Referencia .......:' get VALID  pict '@! XXX/99'
           @ 14, 05 say 'Valor ............:' get MVALOR pict '@E 999,999.99'
           read
           if lastkey() = TESC
              CANCELOU = .t.
              exit
              endif
           *
           MULTA = MVALOR * 0.02
           MSG1  = 'Apos vencimento, multa de 2% (R$ ' +;
                    alltrim(tran(MULTA, '@E 999.99')) + ')'
           MSG2  = 'Data limite para pagamento em banco: ' + dtoc(DT_LIMITE)
           MSG3  = 'Referencia: Nota fiscal '                   +;
                    alltrim(tran(MNOTA, '@E 999,999')) + ' de ' +;
                    dtoc(MDATA_NOTA)
           *   
           @ 16, 05 say 'MSG1 .............:' get MSG1
           @ 17, 05 say 'MSG2 .............:' get MSG2
           @ 18, 05 say 'MSG3 .............:' get MSG3
           read
           if lastkey() = TESC
              CANCELOU = .t.
              exit
              endif
           *
           OK = 'S'
           P2OKSN('Confirma')
           if OK = 'S'
              exit
              endif
           enddo
        *
        if CANCELOU
           loop
           endif
        *
/*zzz   if WQUEM = 'Z'
           set device to print
           set print on
           NROW := prow()
           NCOL := pcol()
           ?? chr(27) + '0' + chr(15) + chr(27) + 'C' + chr(32)
           *  | 8 lin/pol   | condens.|   32 linhas  pagina   |
           setprc(NROW, NCOL)
           *
           MULTA = MVALOR * 0.02
           *if !empty(PARCELA)
           *   @ 02, 94 say PARCELA
           *   endif
           *
           *sele NOTAS
           @ 01, 01 say 'PAGAR PREFERENCIALMENTE EM AGENCIA ITAU'
           @ 01, 98 say dtoc(MDT_VENC)
           @ 05, 01 say dtoc(DT_EMISS)
           @ 05, 16 say strzero(WNUM_BOLETO,5)
           @ 05, 48 say 'R$'
           @ 07, 28 say '101'
           @ 07, 98 say MVALOR pict '@E 999,999.99'
           @ 10, 15 say 'Apos vencimento, multa de 2% (R$ ' +;
                        tran(MULTA, '@E 999.99') + ')'
           MORA  = 0.00033   && 0,033%
           WMORA = MVALOR * MORA
           @ 12, 15 say 'e juros de R$ ' + tran(WMORA, '@E 999.99')
           @ 14, 15 say 'Data limite para pagamento em banco: ' +dtoc(DT_LIMITE)
           WREF = 'Referencia: Nota Fiscal ' + alltrim(tran(MNOTA,'@E 999,999'))
           if !empty(PARCELA)
              WREF = WREF + ' - Parcela: ' + PARCELA
              endif
           *
           @ 16, 15 say WREF
           *
           *sele CLIENTES
           *seek NOTAS->NOT_CLIEN
           @ 19, 15 say CLI_NOME + space(28)                +;
                        tran(CLI_CGC, '@R 99.999.999/9999-99')
           *@ 20, 15 say trim(CLI_ENDER) + ' - ' + CLI_BAIRRO
           @ 20, 15 say trim(CLI_TIPOEN) + ' ' + trim(CLI_ENDER)
           if CLI_NUMERO > 0
              @ 20, pcol() say ', ' + alltrim(str(CLI_NUMERO,6,0))
              endif
           *
           if !empty(CLI_COMPL)
              @ 20, pcol() say ' ' + trim(CLI_COMPL)
              endif
           *
           @ 20, pcol() say ' - ' + trim(CLI_BAIRRO)
           @ 21,  15 say trim(CLI_CIDADE) + ' - ' + CLI_UF
           eject
*/
*           else
             MSG_ERRO('Boleto Gravado! Tecle ENTER')
*           endif
        *
        * Grava numero do boleto
        sele NOTAS
        repla NOT_BANCO  with '3'
        repla NOT_BOLETO with WNUM_BOLETO
        repla NOT_VENCIM with MDT_VENC 
        repla NOT_VALOR  with MVALOR 
        repla NOT_CODCAR with WCOD_GRAV
        *
        set device to screen
        set print off
        WNUM_BOLETO++
        enddo
     *
*zzz  if WQUEM = 'Z'
*        @prow(), 00 say chr(27) + '2' + chr(18) + chr(27) + 'C' + chr(87)
*        set device to screen
*        set print off
*        endif
     *
     set filter to
     enddo
  *
  return
*
******************************************************************
* imprime boletos avulsos emitidos *******************************
*
*--------------------*
 Procedure ITAU_EMITI
*--------------------*
  sele AVULSAS
  VALID = space(6)
  SAI = .f.
  do while .t.
     @ 03, 05 say 'Referencia .......:' get VALID  pict '@! XXX/99'
     read
     if lastkey() = TESC
        SAI := .t.
        exit
        endif
     OK := 'S'
     P2OKSN('Confirma')
     if OK = 'S'
        exit
        endif
     enddo
  *
  if SAI
     return
     endif
  locate for AVU_REFER = VALID
  *
  set print on
  set console off
  @prow(), 00 say chr(27) + '2' + chr(18) + chr(27) + 'C' + chr(87)
  ? '                       BOLETOS AVULSOS EMITIDOS - ' + VALID
  ? '                    ======================================='
  *  0    *    1    *    2    *    3    *    4    *    5    *    6    *    7    *
  *  01234567890123456789012345678901234567890123456789012345678901234567890123456789
  ? 'COD FANTASIA        DESCRICAO                        PARC. VENCIM      VALOR Pag'
  ? '--- --------------- -------------------------------- ----- -------- -------- ---'
  *  999 X-------------X X- ( 32 ) ---------------------X 99/99 99/99/99 9.999,99 ___
  *  999 X-------------X X------------------------------X 99/99 99/99/99 9.999,99 ___
  *  999 X-------------X X------------------------------X 99/99 99/99/99 9.999,99 ___
  *  --------------------------------------------------------------------------------
  *  Total:          999                                                99.999,99
  *
  WTOT_BOL = 0
  WTOT_VAL = 0.00
  WLIN     = 6
  do while !eof()
     if WLIN > 59
        WLIN = 2
        eject
        ? 'COD FANTASIA        DESCRICAO                        PARC. VENCIM      VALOR Pag'
        ? '--- --------------- -------------------------------- ----- -------- -------- ---'
        endif
     *
     ?  tran(AVU_CODIGO, '@E 999') + ' '
     ?? AVU_FANTAS + ' '
     ?? left(AVU_DESCRI,32) + ' '
     ?? AVU_PARCEL + ' '
     ?? AVU_VENCIM; ?? ' '
     ?? tran(AVU_VALOR, '@E 9,999.99') 
     ?? ' ___'
     *
     WTOT_VAL = WTOT_VAL + AVU_VALOR
     WTOT_BOL++ 
     WLIN++
     skip
     enddo
  *
  ? repl('-', 80)
  ? 'Total:' + space(10) + tran(WTOT_BOL, '999') + space(48) +;
              tran(WTOT_VAL, '@E 99,999.99')
  eject
  set filter to
  set print off
  set console on
  return
*
/*
******************************************************************
* BROWSE boletos avulsos emitidos ********************************
*--------------------*
 Procedure ITAU_BROWS
*--------------------*
  sele AVULSAS
  VALID = space(6)
  SAI = .f.
  do while .t.
     @ 03, 05 say 'Referencia .......:' get VALID  pict '@! XXX/99'
     read
     if lastkey() = TESC
        SAI := .t.
        exit
        endif
     OK := 'S'
     P2OKSN('Confirma')
     if OK = 'S'
        exit
        endif
     enddo
  *
  if SAI
     return
     endif
  locate for AVU_REFER = VALID
  *
  *   *    1    *    2    *    3    *    4    *    5    *    6    *    7    *
  *2345678901234567890123456789012345678901234567890123456789012345678901234567
  @ 03, 02 say;
  'Fantasia ------  Descricao -----------------------  Parce  Vencimen Valor---'
  *X-------------X  X-------------------------------X  X---X  X------X 9.999,99
  *
  do while .t.
     SALVATELA := savescreen(05,10,22,70)
     @ 05,05 clear to 22,70
     @ 05,10 to 22,70
     dbedit(06,11,21,69)
     if lastkey() = TESC
        exit
        endif
     restscreen(05,10,22,70,SALVATELA)
     @ 04, 02 get AVU_FANTAS
     @ 04, 19 get AVU_DESCRI
     @ 04, 54 get AVU_PARCEL
     @ 04, 61 get AVU_VENCIM
     @ 04, 70 get AVU_VALOR pict '@E 9,999.99'
     clear gets
     OK := 'S'
     P2OKSN('Exclui')
     if OK = 'S'
        delete
        skip 
        if eof()
           go bottom
           endif
        endif
     enddo
  return
*
*/
******************************************************************
* Grava arq. com Boletos gravados ********************************
*-------------------*
 Procedure BOL_GRAV
*-------------------*
*
set date briti
*
sele 15
     use ARQ_ENV
     zap
     appe from &PATH_ARQGR SDF
     go top
*
? '                         Boletos Emitidos Ziul'
? '                         ====================='
? '-------- --------------- ------- ------- ---- ------ -------- ---------'
? 'Data     Cliente          Boleto N. Fisc Tipo Parcel  Dt Venc     Valor'
? '-------- --------------- ------- ------- ---- ------ -------- ---------'
*  99/99/99 X-------------X 999.999 999.999  XX   99/99 99/99/99 99.999,99
*  99/99/99 X-------------X 999.999 999.999  XX   99/99 99/99/99 99.999,99
*  -----------------------------------------------------------------------
*                   Totais: 999.999                           9.999.999,99
*
CONT_BOL   = 0
CONT_LIN   = 5
WTOT_VALOR = 0.00
WTOT_VALOR = 0.00
do while !eof()
   if TIPO <> '1'
      skip
      loop
      endif
   *
   WBOLETO = str(val(right(BOLETO,6)),6)
   sele NOTAS
   seek WBOLETO
   WTIPO = if(NOT_TIPO = 'S','SV','VE')
   WTOT_VALOR = WTOT_VALOR + NOT_VALOR
   *
   if CONT_LIN = 60
      eject
      ?'-------- --------------- ------- ------- ---- ------ -------- ---------'
      ?'Data     Cliente          Boleto N. Fisc Tipo Parcel  Dt Venc     Valor'
      ?'-------- --------------- ------- ------- ---- ------ -------- ---------'
      * 99/99/99 X-------------X 999.999 999.999  XX   99/99 99/99/99 99.999,99
      * 99/99/99 X-------------X 999.999 999.999  XX   99/99 99/99/99 99.999,99
      *------------------------------------------------------------------------
      *                  Totais: 999.999                           9.999.999,99
      *
      CONT_LIN = 3
      endif
   *
   W0 = val(WBOLETO)
   W1 = dtoc(NOT_DATA) + ' ' + NOT_FANTAS + ' ' + tran(W0, '@E 999,999') +;
     ' ' + tran(NOT_NUMERO, '@E 999,999') + '  ' + WTIPO + '   '           +;
     NOT_PARCEL + ' ' + dtoc(NOT_VENCIM) + ' ' +;
     tran(NOT_VALOR, '@E 99,999.99')
   ? W1
   *
   sele ARQ_ENV
   skip
   CONT_LIN++
   CONT_BOL++                         
   enddo
*
? repl('-', 71)
? '                  Totais: '  + tran(CONT_BOL, '@E 999,999')     +;
  '                           ' + tran(WTOT_VALOR, '@E 9,999,999.99')
*
* Cria arq com boletos gravados
  WARQ_TXT = 'AIMPRE'
  PATH_ARQGR = 'BOLS_' + strzero(SEQ_ITAU,3) + '.TXT'
  *
  if file(PATH_ARQGR)
     W1 := ferase(PATH_ARQGR)
     endif
  *
  W2 := frename(WARQ_TXT,PATH_ARQGR)
*--------------------------------
*
return
*
**************************** fim *************************************