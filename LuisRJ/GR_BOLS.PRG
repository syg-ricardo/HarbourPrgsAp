*  Sistema.....: ZIUL - Sistema de Cobranca
*  Programador.: Nando                                                  
*  Data........: 07/05/21                                                 
*  Programa....: GER_BOLS.PRG
*  Descricao...: Grava dados em ENV_BOLS.DBF a partir de ARQ_REC.DBF,
*                para serem enviados por e-mail pela rotina ENVIA_BOLS() 
*  Alteracao...: 
*  Data........:                                                  
*  Rotinas.....: Lista resumo, Todos recibos s/n, Bol. selec.,
*                Todas etiq., Etiq. selec., Lista cli, Manut. arqs.
*
*-------------------------------------------------------------------------
*
******************************************************************
* Grava arquivo com dados dos boletos aceitos pelo Itau,
* para serem gerados boletos para envio por e-mail ***************
*
*--------------------*
 Procedure DADOS_BOLS
*--------------------*
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
  sele CLIENTES
    set order to 2
  *
  sele NOTAS
    set order to 2
  *
  sele 15
    use ARQ_REC
    zap
    appe from &XARQ SDF
    go top
    WDT_DOC = left(DT_MOVIM,2) + "/" +;
                   substr(DT_MOVIM,3,2) + "/20" + right(DT_MOVIM,2)
    skip
  *
  sele 17
    use ENV_BOLS
    zap
    go top
  *
    sele 18
    use EMAILS
    index on EML_CODEMA to IEMAILS
    go top
  *
  sele ARQ_REC
  do while TIPO_REG <> '9' .and. !eof()      
     *
     * Grava registros em ENV_BOL
     *---------------------------
     if COD_OCORR = "02"
        sele ENV_BOLS
        appe blank
        repla ENV_EMPRE  with "ZIUL INFORMATICA LTDA ME"
        repla ENV_CNPJ_E with "CNPJ 03.211.838/0001-12"
        repla ENV_END_E  with "R PROF FRANCISCA PIRAGIBE 151 SL 404 405 " +;
              "TAQUARA RIO DE JANEIRO RJ 22710-195"
        repla ENV_VENCIM with left(ARQ_REC->DT_VENCIM,2) + "/"       +;
                              substr(ARQ_REC->DT_VENCIM,3,2) + "/20" +;
                              right(ARQ_REC->DT_VENCIM,2)
        *
        repla ENV_AG_BEN with "0314/22556-6"
        repla ENV_DT_DOC with WDT_DOC
        repla ENV_NUMDOC with ARQ_REC->NF
        if ARQ_REC->ESPEC_DOC = "01"
           repla ENV_ESPDOC with "DMI"
           else
             repla ENV_ESPDOC with "DSI"
           endif
        *
        repla ENV_ACEITE with "N"
        repla ENV_DTPROC with left(ARQ_REC->DT_OCORR,2) + "/"       +;
                              substr(ARQ_REC->DT_OCORR,3,2) + "/20" +;
                              right(ARQ_REC->DT_OCORR,2)
        *
        repla ENV_NOSSON with left(ARQ_REC->N_NUM_BOL,3) + "/"     +;
                              substr(ARQ_REC->N_NUM_BOL,4,8) + "-" +;
                              right(ARQ_REC->N_NUM_BOL,1)
        *
        repla ENV_CARTEI with left(ARQ_REC->N_NUM_BOL,3)
        repla ENV_ESPEC  with "R$"
        *
        *W0 = tran(str(val(ARQ_REC->VALOR)/100),'@E 999,999.99')
        *W1 = val(ARQ_REC->VALOR)/100
        *W2 = str(val(ARQ_REC->VALOR)/100)
        W0 = alltrim(tran(val(ARQ_REC->VALOR)/100,'@E 999,999.99'))
        repla ENV_VALOR  with alltrim(W0)
        *
        * Mora de R$ 5,90% ao mes 
        W0 = val(ARQ_REC->VALOR)/100
        WMORA = round(W0 * 5.9/30/100,2)
        W1 = alltrim(tran(WMORA,'@E 999,999.99'))
        repla ENV_MORA   with "APOS O VENCIMENTOCOBRAR MORA DE R$ " +;
                               repl(".",20-len(W1)) + W1 + " AO DIA"
        *
        repla ENV_REF    with "Ref. N. Fiscal " + alltrim(str(val(ARQ_REC->NF),10))
        repla ENV_PAGAD  with ARQ_REC->NOME_CLI
        sele NOTAS
        set order to 2
        W0 = left(ARQ_REC->SEU_NUM,5)  && Boleto
        W1 = val(W0)
        sele NOTAS
        seek W1
        if !found()
           alert ("BOLETO " + W0 + " nao encontrado em NOTAS;ABORTADO ...")
           exit
           endif
        *
        W0 = NOT_CLIEN
        sele CLIENTES
        seek W0
        if !found()
           alert ("COD. CLIENTE " + str(W0,5) + " nao encontrado em CLIENTES;ABORTADO ...")
           exit
           endif
        *
        sele ENV_BOLS   
        repla ENV_CNPJ_P with "CNPJ/CPF   " + left(CLIENTES->CLI_CGC,2) + "." +;
                              substr(CLIENTES->CLI_CGC,3,3) + "."             +;
                              substr(CLIENTES->CLI_CGC,6,3) + "/"             +; 
                              substr(CLIENTES->CLI_CGC,9,4) + "-"             +;
                              right(CLIENTES->CLI_CGC,2)
        *
        W0 = trim(CLIENTES->CLI_TIPOEN) + ' ' + trim(CLIENTES->CLI_ENDER) + ','
        if CLIENTES->CLI_NUMERO > 0
           W0 = W0 + ' ' + alltrim(str(CLIENTES->CLI_NUMERO,6))
           endif
        *
        if !empty(CLIENTES->CLI_COMPL)
           W0 = W0 + ' ' + trim(CLIENTES->CLI_COMPL)
           endif
        *
        W1 = trim(W0) + space(40-len(trim(W0)))
        repla ENV_END_P with W1         
        repla ENV_CEP_P with left(CLIENTES->CLI_CEP,5)  + "-" +;
                             right(CLIENTES->CLI_CEP,3) + " - " +;
                             trim(CLIENTES->CLI_BAIRRO) + " - " +;
                             trim(CLIENTES->CLI_CIDADE) + " - " +;
                             CLIENTES->CLI_UF
        * 
        * Grava Emails
        *-------------
        sele EMAILS
        W0 = CLIENTES->CLI_EMAIL1
        if W0 > 0
           seek W0
           if !found()
              alert ("CLI_EMAIL1 " + str(W0) + " nao encontrado em EMAILS;ABORTADO ...")
              exit
              endif
           *
           sele ENV_BOLS
           repla ENV_EMAIL1 with EMAILS->EML_EMAIL 
           else
             alert ("CLIENTE " + str(CLIENTES->CLI_CODIGO) + " sem email para envio;ABORTADO ...")
*             exit
           endif
        *       
        sele EMAILS
        W0 = CLIENTES->CLI_EMAIL2
        if W0 > 0
           seek W0
           if !found()
              alert ("CLI_EMAIL2 " + str(W0) + " nao encontrado em EMAILS;ABORTADO ...")
              exit
              endif
           *  
           sele ENV_BOLS
           repla ENV_EMAIL2 with EMAILS->EML_EMAIL
           endif
        * 
        sele EMAILS
        W0 = CLIENTES->CLI_EMAIL3
        if W0 > 0
           seek W0
           if !found()
              alert ("CLI_EMAIL3 " + str(W0) + " nao encontrado em EMAILS;ABORTADO ...")
              exit
              endif
           *  
           sele ENV_BOLS
           repla ENV_EMAIL3 with EMAILS->EML_EMAIL
           endif 
        endif
     *
     sele ARQ_REC
     skip
     enddo
  *
  sele CLIENTES
  set order to 1
  sele NOTAS
  set order to 1
*
**************************** fim *************************************