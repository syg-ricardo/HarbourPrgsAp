*  Sistema.....: ZIUL - Sistema de Cobranca
*  Programador.: Nando                                                  
*  Data........: 27/04/04                                                 
*  Programa....: NOTAS.PRG
*  Descricao...: Rotinas de emissao de notas fiscais
*  Alteracao...: Versao Harbour
*  Data........:                                                  
*  Feita por...:
*
*************************** Notas_Todas ********************************
*-----------------------*
 Procedure NOTAS_TODAS()
*-----------------------*
  *  
  * Cobranca é feita no inicio do mes, mas é a do mes anterior
  *
  DT_EMISS  = date()
  WMES_ANT := if(month(DT_EMISS)=1,'12',strzero(month(date())-1,2))
  WANO     := if(month(date())=1,  right(strzero(year(date())-1,4),2),;
                                   right(strzero(year(date()),4),2))
  MES_REF   = MESES[val(WMES_ANT)] + '/' + WANO
  W1 = ' RPS Todos (Cobran‡a)'
  @ 02, 01 get W1
  clear gets
  do while .t.
     @ 03, 05 say 'Data de Emissao ..:' get DT_EMISS
     @ 04, 05 say 'Mes de referencia :' get MES_REF   pict '@! XXX/99'
     read
     if lastkey() = TESC
        *
        *
        return
        endif
     *
     OK = 'S'
     P2OKSN('Confirma')
     if OK = 'S'
        exit
        endif
     *
     enddo
  *
  sele NOTAS
  set filter to NOT_TIPO = 'S'
  go bottom
  if eof()
     WNUM_NOTA = 0
     WNOTA_INI = 1
     else
       WNUM_NOTA = NOT_NUMERO
       WNOTA_INI = NOT_NUMERO+1
     endif
  *
  sele CLIENTES
  go top
  do while !eof()
     *
     * Verifica se tem Servicos adicionais
     sele SERV_ADI
     seek CLIENTES->CLI_CODIGO
     CLI_ADIC = 0.00
     do while SAD_CODIGO = CLIENTES->CLI_CODIGO .and. !eof()
        if SAD_VALID = MES_REF
           WVL = SAD_UNID * SAD_VALOR
           CLI_ADIC = CLI_ADIC + WVL
           endif
        skip
        enddo
     *
     sele CLIENTES
     if (CLI_VALOR = 0.00 .and. CLI_MANUT = 0.00 .and. CLI_ADIC = 0.00)
        skip
        loop
        endif
     *
     *WMES_SEG := if(month(date())=12,'01',strzero(month(date())+1,2))
     *WANO     := if(month(date())=12,right(strzero(year(date())+1,4),2),;
     *                                right(strzero(year(date()),4),2))
     *CH_VENCIM = WDIA_VENC + '/' + WMES_SEG + '/' + WANO
     *
     if CLI_VALOR > 0.00
        * Emite RPS de Licenca de uso
        * ***************************
        WVAL = CLI_VALOR + CLI_MOBILE + CLI_TEFMOB + CLI_CONCIL + CLI_TEFIP
        sele NOTAS
        appe blank
        WNUM_NOTA++
        repla NOT_NUMERO with WNUM_NOTA
        repla NOT_TIPO   with 'S'
        repla NOT_CLIEN  with CLIENTES->CLI_CODIGO
        repla NOT_DATA   with DT_EMISS
        repla NOT_VALOR  with WVAL
        repla NOT_FANTAS with CLIENTES->CLI_FANTAS
        repla NOT_CDSVMU with '14.01.32'  && Manutencao de equipamentos
        sele ITNOTA
        appe blank
        repla ITN_NUMERO with WNUM_NOTA
        repla ITN_TIPO   with 'S'
        repla ITN_PROD   with 'Manutencao de equipamentos' + ' - ' + MES_REF
        repla ITN_QUANT  with 1
        repla ITN_VALOR  with WVAL
        sele CLIENTES
        endif
     *
     if CLI_MANUT > 0.00
        * Emite RPS de Manutencao de computadores
        * ***************************************
        sele NOTAS
        appe blank
        WNUM_NOTA++
        repla NOT_NUMERO with WNUM_NOTA
        repla NOT_TIPO   with 'S'
        repla NOT_CLIEN  with CLIENTES->CLI_CODIGO
        repla NOT_DATA   with DT_EMISS
        repla NOT_VALOR  with CLIENTES->CLI_MANUT
        *repla NOT_MODO   with 'FATURADO     Vencimento: ' + CH_VENCIM
        repla NOT_FANTAS with CLIENTES->CLI_FANTAS
        repla NOT_CDSVMU with '14.01.51'  && manutencao de computadores
        *
        sele ITNOTA
        appe blank
        repla ITN_NUMERO with WNUM_NOTA
        repla ITN_TIPO   with 'S'
        repla ITN_PROD   with 'Manutencao de computadores' + ' - ' + MES_REF
        repla ITN_QUANT  with 1
        repla ITN_VALOR  with CLIENTES->CLI_MANUT
        endif
     *
     * Emite RPS de Servicos adicionais
     * ********************************
     sele SERV_ADI
     seek CLIENTES->CLI_CODIGO
     do while SAD_CODIGO = CLIENTES->CLI_CODIGO .and. !eof()
        if SAD_VALID = MES_REF
           sele NOTAS
           appe blank
           WNUM_NOTA++
           repla NOT_NUMERO with WNUM_NOTA
           repla NOT_TIPO   with 'S'
           repla NOT_CLIEN  with CLIENTES->CLI_CODIGO
           repla NOT_DATA   with DT_EMISS
           repla NOT_VALOR  with SERV_ADI->SAD_UNID * SERV_ADI->SAD_VALOR
           *repla NOT_MODO   with 'FATURADO     Vencimento: ' + CH_VENCIM
           repla NOT_FANTAS with CLIENTES->CLI_FANTAS
           repla NOT_CDSVMU with SERV_ADI->SAD_CODSER
           *
           sele ITNOTA
           appe blank
           repla ITN_NUMERO with WNUM_NOTA
           repla ITN_TIPO   with 'S'
           repla ITN_PROD   with SERV_ADI->SAD_REFER
           repla ITN_QUANT  with 1
           *repla ITN_VALOR  with SERV_ADI->SAD_VALOR
           repla ITN_VALOR  with SERV_ADI->SAD_UNID * SERV_ADI->SAD_VALOR
           sele SERV_ADI
           endif
        *
        skip
        enddo
     *
     sele CLIENTES
     skip
     enddo
  *
  @ 10,05 say "Gravados RPS's de " + str(WNOTA_INI,8) + " a " + str(WNUM_NOTA,8)
  inkey(0)
  set filter to
  sele NOTAS
  commit
  sele ITNOTA
  commit
  return
*
**************************** RPS's Avulsos *****************************
*--------------------*
 Procedure NOTAS_AVUL 
*--------------------*
  sele CLIENTES
  set filter to CLI_TIPO = ' '
  go top
  sele NOTAS
  set filter to NOT_TIPO = 'S'
  DT_EMISS = date()
  MES_REF  = MESES[month(DT_EMISS)] + '/' + right(strzero(year(DT_EMISS),4),2)
  W1 = " RPS's Avulsos "
  @ 02, 01 get W1
  clear gets
  @ 05, 05 clear to 06, 70
  sele CLIENTES
  do while .t.
     sele CLIENTES
     set device to screen
     @ 03, 01 clear to 22, 78
     @ 03, 10 to 21, 70
     dbedit(04,11,20,69,CAMPOS,,FORMATOS,TITULOS)
     @ 03, 10 clear to 21, 70
     if lastkey() = TESC
        @ 03, 10 clear to 21, 70
        WPESSOA = ' '
        @ 04, 10 say 'Pessoa (F)isica ou (J)uridica ?' get WPESSOA pict '!';
                 valid WPESSOA $ 'FJ'        
        read
        if lastkey() = TESC
           return
           endif
        *
        if WPESSOA = 'F'
           WMSG = 'CPF'
           WCGC = space(11)
           else
             WMSG = 'CNPJ'
             WCGC = space(14)
           endif
        *
        WCOD  = 99999
        SAI   = .f.
        do while .t.
           if WPESSOA = 'F'
              @ 05, 02 say 'CPF ...............:' get WCGC;
                       pict '@R 999.999.999-99'    
              else
                @ 05, 02 say 'CNPJ ..............:' get WCGC;
                         pict '@R 99.999.999/9999-99'  
              endif
           *
           read
           if lastkey() = TESC
              SAI = .t.
              exit
              endif
            *
            if !RDV11(WPESSOA, WCGC)
               MSG_ERRO(WMSG + ' Invalido! Tecle ENTER')
               loop
               endif
           *
           sele CLI_NCAD
           seek WCGC
           if found()
              WNOME    = CLN_NOME
              WTIPOEND = CLN_TIPOEN
              WENDER   = CLN_ENDER
              WNUMERO  = CLN_NUMERO
              WCOMPLE  = CLN_COMPL  
              WBAIRRO  = CLN_BAIRRO
              WCIDADE  = CLN_CIDADE 
              WUF      = CLN_UF
              WCEP     = CLN_CEP    
              WIE      = CLN_IE    
              WIM      = CLN_IM     
              WTELEF   = CLN_TELEFO 
              WEMAIL   = CLN_EMAIL  
              else
                WNOME    = space(40)
                WTIPOEND = '   '
                WENDER   = space(40)
                WNUMERO  = 0
                WCOMPLE  = space(20)
                WBAIRRO  = space(25)
                WCIDADE  = 'RIO DE JANEIRO           '
                WUF      = 'RJ'      
                WCEP     = space(8)
                WIE      = space(8)
                WIM      = space(8)
                WTELEF   = space(13)
                WEMAIL   = space(40)
              endif
           *
           WFANTAS = ' '
           exit
           enddo
        *
        if SAI
           loop
           endif
        *
        else
          WCOD     = CLI_CODIGO
          WFANTAS  = CLI_FANTAS
          WNOME    = CLI_NOME
          WTIPOEND = CLI_TIPOEN
          WENDER   = CLI_ENDER
          WNUMERO  = CLI_NUMERO
          WCOMPLE  = CLI_COMPL
          WBAIRRO  = CLI_BAIRRO
          WCIDADE  = CLI_CIDADE
          WUF      = CLI_UF    
          WCEP     = CLI_CEP
          WCGC     = CLI_CGC   
          WIE      = CLI_IE
          WIM      = CLI_IM
          WEMAIL   = left(CLI_EMAIL,40)
          WTELEF   = CLI_TELEFO
          if len(trim(WCGC)) = 11
             WPESSOA = 'F'
             WMSG = 'CPF'
             @ 05, 02 say 'CPF ...............:' get WCGC;
                      pict '@R 999.999.999-99'    
             else
               WPESSOA = 'J'
               WMSG = 'CNPJ'
               @ 05, 02 say 'CNPJ ..............:' get WCGC;
                        pict '@R 99.999.999/9999-99'  
             endif
          *
          clear gets
          if !RDV11(WPESSOA, WCGC)
             MSG_ERRO(WMSG + ' Invalido! Tecle ENTER')
             loop
             endif
          *
          if !empty(WIE) .and. !VALID_IE(WIE)
             MSG_ERRO('Inscricao Estadual Invalida! Tecle ENTER')
             loop
             endif
          *
          if WPESSOA = 'J' .and. empty(WIE) .and. empty(WIM)
             MSG_ERRO('Cliente sem Inscricao Estadual e Municipal! Tecle ENTER')
             loop
             endif
        *
        endif
     *
     WCDSVMU = '        '
     @ 06, 02 clear to 21, 70
     *
     *0    *    1    *    2    *    3    *    4    *    5    *    6    *    7    *
     *01234567890123456789012345678901234567890123456789012345678901234567890123456789
     *  Nome do Cliente ...: X--------- 40 -------------------------X
     *  CNPJ/CPF ..........: 99.999.999/9999-99   
     *  Endereco ..........: XXX X--------- 40 -------------------------X
     *  Numero ............: 999.999       Complemento : X------------------X
     *  Bairro ............: X--------- 25 ----------X   Telefone: (21)9999-9999
     *  Cidade ............: X--------- 25 ----------X   UF: XX    CEP: 99999-999
     *  Inscr. Estadual ...: 99.999.99            Inscr. Municipal: 9.999.999-9
     *  E-Mail ............: X--------- 40 -------------------------X
     *  Codigo do Servico .: 99.99.99 - X------------------------------------------X
     *
     *  Unid Quant Discriminacao dos Servicos                Preco Unit  Preco 
     *   UN   999  X--------------------------------------X  999.999,99   999.99
     *   UN   999  X--------------------------------------X  999.999,99   999.99
     *
     SAI = .f.
     do while .t.
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
        if WCOD = 99999
           read
           if lastkey() = TESC
              SAI = .t.
              exit
              endif
           *
           else
             clear gets
           endif
        *
        if !RDV11(WPESSOA, WCGC)
           MSG_ERRO(WMSG + ' Invalido! Tecle ENTER')
           loop
           endif
        *
        if !empty(WIE) .and. !VALID_IE(WIE)
           MSG_ERRO('Inscricao Estadual Invalida! Tecle ENTER')
           loop
           endif
        *
        if WPESSOA = 'J' .and. empty(WIE) .and. empty(WIM)
           MSG_ERRO('Preencha Inscricao Estadual ou Municipal! Tecle ENTER')
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
     if SAI
        loop
        endif
     *
     * Pega codigo do servico
     * **********************
     @ 13, 02 say 'Codigo do Servico .:' get WCDSVMU pict '99.99.99'
     clear gets
     WLIN_SV = 13
     WCOL_SV = 23
     WSERVI  = ' '  && PEGA_CODSER ai preencher
     if !PEGA_CODSER()
        loop
        endif
     *
     W0 = trim(left(WSERVI,46))
     @ 13, 23 get WCDSVMU pict '@ 99.99.99'
     @ 13, 31 say '-'
     @ 13, 32 get W0
     clear gets
     *
     TOT_LIN = 0
     WLIN    = 16
     WTOT    = 0.00
     XQUANT  = 1
     XDESCRI = space(40)
     XPRUNI  = 0.00
     @ 15, 02 say 'Unid Quant Discriminacao dos Servicos           '+;
                  '     Preco Unit  Preco Total'
     @ 22, 40 say 'Total: '
     *
     SAI = .f.
     do while .t.
        @ WLIN, 08 get XQUANT   pict '999'
        @ WLIN, 13 get XDESCRI
        @ WLIN, 55 get XPRUNI   pict '@E 999,999.99'
        read
        if lastkey() = TESC
           OK := 'N'
           P2OKSN('Cancela')
           if OK = 'S'
              SAI := .t.
              exit
              else
                loop
              endif
           *
           elseif lastkey() = PGDN
             OK = 'N'
             P2OKSN('Fim dos Itens')
             if OK = 'S'
                exit
                else
                  loop
                endif
           endif
        *
        if XQUANT <= 0
           MSG_ERRO('Quantidade deve ser maior que zero! Tecle ENTER')
           loop
           endif
        *
        if empty(XDESCRI)
           MSG_ERRO('Preencha a descri‡ao do servi‡o! Tecle ENTER')
           loop
           endif
        *
        if XPRUNI <= 0.00
           MSG_ERRO('Preco unitario deve ser maior que zero! Tecle ENTER')
           loop
           endif
        *
        OK = 'N'
        P2OKSN('Confirma')
        if OK = 'S'
           if TOT_LIN = 0
              TOT_LIN = 1
              decl WQUANT[1]
              decl WDESCRI[1]
              decl WPRUNI[1] 
              decl WVALOR[1] 
              else
                TOT_LIN++
                asize(WQUANT,  TOT_LIN)
                asize(WDESCRI, TOT_LIN) 
                asize(WPRUNI,  TOT_LIN) 
                asize(WVALOR,  TOT_LIN)  
              endif
           *
           WQUANT[TOT_LIN]  = XQUANT
           WDESCRI[TOT_LIN] = XDESCRI
           WPRUNI[TOT_LIN]  = XPRUNI
           XVALOR           = round(XQUANT*XPRUNI,2)
           WVALOR[TOT_LIN]  = XVALOR
           @ WLIN, 67 get XVALOR pict '@E 999,999.99'
           clear gets
           WTOT = WTOT + XVALOR
           @ 22, 67 get WTOT pict '@E 999,999.99'
           clear gets
           XQUANT  = 1
           XDESCRI = space(40) 
           XPRUNI  = 0.00
           WLIN++
           endif
        enddo
     *
     if SAI
        loop
        endif
     *
     * Grava Cliente nao cadastrado
     * ****************************
     if WCOD = 99999
        sele CLI_NCAD
        if CLN_CGC <> WCGC
           appe blank
           endif
        *
        repla CLN_NOME   with WNOME
        repla CLN_TIPOEN with WTIPOEND
        repla CLN_ENDER  with WENDER
        repla CLN_NUMERO with WNUMERO
        repla CLN_COMPL  with WCOMPLE
        repla CLN_BAIRRO with WBAIRRO
        repla CLN_CIDADE with WCIDADE
        repla CLN_UF     with WUF    
        repla CLN_CEP    with WCEP
        repla CLN_CGC    with WCGC
        repla CLN_IE     with WIE 
        repla CLN_IM     with WIM 
        repla CLN_TELEFO with WTELEF
        repla CLN_EMAIL  with WEMAIL
        endif
     *
     * Grava o RPS 
     * ***********
     sele NOTAS
     go bottom
     WNUM_NOTA = NOT_NUMERO + 1
     appe blank
     repla NOT_NUMERO with WNUM_NOTA
     repla NOT_TIPO   with 'S'
     repla NOT_CLIEN  with WCOD
     *repla NOT_DATA   with WRPS_DATA
     repla NOT_DATA   with DT_EMISS
     repla NOT_VALOR  with WTOT
     repla NOT_FANTAS with WFANTAS
     repla NOT_CDSVMU with WCDSVMU
     if WCOD = 99999
        repla NOT_CGC with WCGC
        endif
     *
     sele ITNOTA
     for I1 = 1 to TOT_LIN
         appe blank
         repla ITN_NUMERO with WNUM_NOTA
         repla ITN_TIPO   with 'S'
         repla ITN_PROD   with WDESCRI[I1]
         repla ITN_QUANT  with WQUANT[I1]
         repla ITN_VALOR  with WVALOR[I1]
         next I1
     *
     commit
     sele CLIENTES
     *
     * Imprime o RPS 
     OK = ' '
     P2OKSN('Imprime o RPS')
     if OK = 'S'
        @ 04, 02 clear to 21,78
        @ 05, 05 say 'Aguarde! Imprimindo o RPS ...'
        IMPR_RPS(WNUM_NOTA)
        @ 04, 02 clear to 21,78
        endif
     enddo
  *
  sele CLIENTES
  set filter to
  return
*
**************************** Pega Cod. Servico *************************
*--------------------*
 Function PEGA_CODSER
*--------------------*
  SAI   = .f.
  ACHOU = .f.
  do while .t.
     @ WLIN_SV, WCOL_SV get WCDSVMU pict '99.99.99'
     read
     if lastkey() = TESC
        exit
        endif
     *
     sele COD_SERV
     if WCDSVMU = '        '  .or. WCDSVMU = '  .  .  '
        * Pega GRUPO
        set filter to SER_TIPO = '1' .or. SER_TIPO = '2'
        go top
        SALVATELA = savescreen(04,01,22,78)
        ULTKEY = 0
        @ 04,01 to 22,78
        @ 03, 01 say 'Selecione o GRUPO do codigo do servi‡o'
        do while .t.
           ULTKEY = 0
           INICIO_DBEDIT = .t.
           dbedit(05,02,21,77,CAMPOS4,'DBEDIT_SAI',FORMATOS4,TITULOS4)
           if ULTKEY = TESC
              SAI = .t.
              exit
              endif
           *
           if ULTKEY = TENTER
              WGRUPO = left(SER_CODW,2)
              exit
              endif
           enddo
        *
        if SAI
           exit
           endif
        *
        * Pega SUB GRUPO
        set filter to left(SER_CODW,2) = WGRUPO;
            .and. (SER_TIPO = '3' .or. SER_TIPO = '4')
        go top
        @ 03, 01 say 'Selecione o SUB GRUPO do codigo do servi‡o'
        do while .t.
           ULTKEY = 0
           INICIO_DBEDIT = .t.
           dbedit(05,02,21,77,CAMPOS4,'DBEDIT_SAI',FORMATOS4,TITULOS4)
           if ULTKEY = TESC
              SAI = .t.
              exit
              endif
           *
           if ULTKEY = TENTER
              WSUB_GRUPO = left(SER_CODW,5)
              exit
              endif
           enddo
        *
        if SAI
           exit
           endif
        *
        * Pega CODIGO DO SERVICO
        set filter to left(SER_CODW,5) = WSUB_GRUPO;
            .and. (SER_TIPO = '5' .or. SER_TIPO = '6')
        go top
        @ 03, 01 clear to 03,75
        @ 03, 01 say 'Selecione o CODIGO DO SERVICO'
        @ 03, 01 clear to 03,75
        do while .t.
           ULTKEY = 0
           INICIO_DBEDIT = .t.
           dbedit(05,02,21,77,CAMPOS4,'DBEDIT_SAI',FORMATOS4,TITULOS4)
           if ULTKEY = TESC
              *SAI = .t.
              exit
              endif
           *
           if ULTKEY = TENTER
              * Posiciona no 1. registro do servico
              do while SER_CODIGO = '        '
                 skip -1
                 enddo
              *
              WSERVI  = SER_DESCRI
              W0      = trim(left(WSERVI,46))
              WCDSVMU = SER_CODW
              ACHOU   = .t.
              exit
              endif
           enddo
        *
        restscreen(04,01,22,78,SALVATELA)
        else
          locate for SER_CODIGO = WCDSVMU 
          if found() .and. SER_TIPO = '5'
             WSERVI = SER_DESCRI
             W0     = trim(left(WSERVI,46))
             ACHOU  = .t.
             *exit
             else
               MSG_ERRO('Codigo do servico invalido! Tecle ENTER')
               *exit
             endif
        endif
     *
     *restscreen(04,01,22,78,SALVATELA)
     exit
     enddo
  *
  return ACHOU
*
**************************** Imprime RPS *******************************
*------------------*
 Procedure IMPR_RPS
*------------------*
  PAR_RS    = 'Ziul Informatica Ltda                  '
  PAR_IE    = '77.820.582'
  PAR_IM    = '0.257.477-2'
  PAR_FANTA = 'Ziul Informatica'
  PAR_ENDER = 'Est. Rodrigues Caldas, 299 s/ 306      '
  PAR_BAIRR = 'Taquara-JPA                            '
  PAR_CIDA  = 'Rio de Janeiro'
  PAR_UF    = 'RJ'
  PAR_CEP   = '22730-001'
  PAR_TELEF = '(21)2426-3390'
  PAR_EMAIL = 'comercial@ziulinformatica.com.br'
  PAR_CNPJ  = '03.211.838/0001-12'
  *
  WDEDUCOES  = 0.00
  WDESC_INC  = 0.00
  WBASE_CALC = WTOT
  WALIQUOTA  = 5.00
  WVALOR_ISS = TRUNCA(WTOT, '*', WALIQUOTA/100, 2)
  WCRED_IPTU = 0.00
  WRPS       = WNUM_NOTA
  *
  if prow() > 32
     eject
     endif
  *
  @ prow(), 26 say 'RECIBO PROVISORIO DE SERVI€OS'
  ? 'Data: ' + dtoc(DT_EMISS) 
  W0 = trim(PAR_RS)                   
  W1 = 40 - TRUNCA(len(W0), '/', 2, 0)
  @ prow(), W1 say W0
  @ prow(), 65 say 'Numero: ' + tran(WNUM_NOTA, '@E 999,999')
  ? 'Endere‡o: ' + trim(PAR_ENDER) + ' - ' + trim(PAR_BAIRR)
  ? 'Municipio: ' + PAR_CIDA
  @ prow(), 37 say 'UF: ' + PAR_UF + '  CEP: ' + PAR_CEP
  @ prow(), 61 say 'Tel.: ' + PAR_TELEF
  ? 'CNPJ: ' + PAR_CNPJ + '   Email: ' + PAR_EMAIL
  ? 'Inscri‡ao Estadual: ' + PAR_IE
  @ prow(), 40 say 'Inscri‡ao Municipal: ' + PAR_IM
  ? repl('-', 80)
  *
  *-----------------------------------------------------------------
  ? 'Cliente:'
  ? '  Nome/Razao Social: ' + WNOME
  ? '  Endere‡o: ' + trim(WTIPOEND) + ' ' + trim(WENDER)
  if WNUMERO > 0
    @ prow(), pcol() say ', ' + alltrim(str(WNUMERO,6,0))
    endif
  *
  if !empty(WCOMPLE)
     @ prow(), pcol() say ' ' + trim(WCOMPLE)
     endif
  *
  @ prow(), pcol() say ' - ' + trim(WBAIRRO)
  ? '  Municipio: ' + WCIDADE
  @ prow(), 43 say 'UF: ' + WUF +;
                   '     CEP: ' + left(WCEP,5) + '-' + right(WCEP,3)
  ? '  Inscri‡ao Estadual: ' + WIE
  @ prow(), 38 say 'Inscri‡ao Municipal: ' + WIM
  ? '  CPF/CNPJ: '
  if WPESSOA = 'J'
     @ prow(), pcol() say tran(WCGC, '@R 99.999.999/9999-99')
     else
       @ prow(), pcol() say tran(WCGC, '@R 999.999.999-99')
     endif
  *
  @ prow(), 38 say 'Tel: ' + WTELEF
  ? repl('-', 80)
  *-----------------------------------------------------------------
  @ prow()+1, 26 say 'DISCRIMINA€AO DOS SERVI€OS'
  sele ITNOTA
  seek WNUM_NOTA
  do while ITN_NUMERO = WNUM_NOTA .and. !eof()
     ? '  ' + trim(ITN_PROD)
     @ prow(), 43 say tran(ITN_VALOR, '@E 99,999.99')
     skip
     enddo
  *
  ? repl('-', 80)
  *-----------------------------------------------------------------
  ? '  Total da nota:'
  @ prow(), 42 say tran(WTOT, '@E 999,999.99')
  ? repl('-', 80)
  *-----------------------------------------------------------------
  ? "  Observa‡ao: A nota fiscal referente a este recibo provisorio, podera' ser"
  ? "              impressa no site notacarioca.rio.gov.br, apos envio por"
  ? "              Ziul Informatica Ltda"
  ? repl('-', 80)
  if prow() < 30
     @ 30, 00 say repl('-', 80)
     ? ' '
     endif
  *
  return
*
****************** Notas fiscais de Venda ******************************
*---------------------*
 Procedure NOTAS_VENDA
*---------------------*
  *
  ******************************************************************
  * Emite Notas Fiscais de Venda ***********************************
  sele CLIENTES
  set filter to CLI_TIPO = ' '
  go top
  sele NOTAS
  set filter to NOT_TIPO = 'V'
  go top
  if eof()
     TEM_REG = .f.
     else
       TEM_REG = .t.
     endif
  *
  DT_EMISS := date()
  MES_REF  := MESES[month(DT_EMISS)] + '/' + right(strzero(year(DT_EMISS),4),2)
  W1 = ' Notas Venda '
  @02, 01 get W1
  clear gets
  do while .t.
     @ 05, 05 say 'Data de Emissao ..:' get DT_EMISS
     @ 06, 05 say 'Mes de referencia :' get MES_REF  pict '@! XXX/99'
     read
     if lastkey() = TESC
        set filter to
        return
        endif
     *
     OK = 'S'
     P2OKSN('Confirma')
     if OK = 'S'
        exit
        endif
     enddo
  *
  @ 05, 05 clear to 06, 70
  *
  * Pega numero da proxima nota
  *
  go bottom
  if eof()
     WNUM_NOTA = 1
     else
       WNUM_NOTA = NOT_NUMERO+1
     endif
  *
  do while .t.
     @ 08, 05 say 'Nota Fisc. inicial numero:' get WNUM_NOTA;
              pict '@E 999,999' valid WNUM_NOTA # 0
     read
     *
     if lastkey() = TESC
        set filter to
        return
        endif
     *
     OK = 'S'
     P2OKSN('Confirma')
     if OK = 'N'
        loop
        endif
     *
     sele NOTAS
     seek str(WNUM_NOTA,6)
     if found()
        MSG_ERRO("Nota fiscal ja' gravada! Tecle ENTER")
        loop
        endif
     *
     if WNUM_NOTA > 1 .and. TEM_REG
        WNOTA_ANT = WNUM_NOTA - 1
        seek str(WNOTA_ANT,6)
        if !found()
           MSG_ERRO("Falta lancar nota fiscal " +;
                    alltrim(tran(WNOTA_ANT, '999,999')) + ". Tecle ENTER")
           loop
           endif
        endif
     *
     * Sai posicionado na ultima nota lancada
     if NOT_DATA > DT_EMISS
        MSG_ERRO('Data da nota menor que da ultima lancada! Tecle ENTER')
        loop
        endif
     *
     exit
     enddo
  *
  sele CLIENTES
  do while !eof()
     set device to screen
     @ 03, 01 clear to 22, 78
     @ 03, 10 to 21, 70
     dbedit(04,11,20,69,CAMPOS,,FORMATOS,TITULOS)
     if lastkey() = TESC
        exit
        endif
     *
     @ 03, 10 clear to 21, 70
     WNOME    = CLI_NOME
     WENDER   = CLI_ENDER
     WBAIRRO  = CLI_BAIRRO
     WCIDADE  = CLI_CIDADE
     WUF      = CLI_UF    
     WCGC     = CLI_CGC   
     WIE      = CLI_IE
     WMODO    = 'A VISTA                              '
     WSIMPLES = ' '
     *
     *0    *    1    *    2    *    3    *    4    *    5    *    6    *    7  
     *01234567890123456789012345678901234567890123456789012345678901234567890123
     *     Data de emissao ..: 99/99/99
     *     Nome da Firma ....: X
     *     Endereco .........: 
     *     Bairro ...........: 
     *     Cidade ...........: 
     *     UF ...............:
     *     CNPJ/CPF .........: 99.999.999/9999-99
     *     Inscricao Estadual: 99.999.999
     *     Cond. Pagamento ..: X--------------------------------------X
     *
     *
     *  Unid Quant Discriminacao dos Servicos                Preco Unit  Preco 
     *   UN   999  X--------------------------------------X  999.999,99   999.99
     *   UN   999  X--------------------------------------X  999.999,99   999.99
     *
     SAI = .f.
     do while .t.
        @ 04, 05 say 'Data de emissao ..:' get DT_EMISS
        @ 05, 05 say 'Nome da Firma ....:' get WNOME
        @ 06, 05 say 'Endereco .........:' get WENDER
        @ 07, 05 say 'Bairro ...........:' get WBAIRRO
        @ 08, 05 say 'Cidade ...........:' get WCIDADE
        @ 09, 05 say 'UF ...............:' get WUF
        if len(trim(WCGC)) = 11
           @ 10, 05 say 'CPF ..............:' get WCGC;
                    pict '@R 999.999.999-99'
           else
             @ 10, 05 say 'CNPJ .............:' get WCGC;
                      pict '@R 99.999.999/9999-99'
           endif
        *
        @ 11, 05 say 'Inscricao Estadual:' get WIE;
                 pict '@R 99.999.999'
        @ 12, 05 say 'Cond. Pagamento ..:' get WMODO
        read
        if lastkey() = TESC
           OK := 'N'
           P2OKSN('Cancela')
           if OK = 'S'
              SAI := .t.
              exit
              endif
           endif
        *
        OK := 'N'
        P2OKSN('Confirma')
        if OK = 'S'
           exit
           endif
        enddo
     *
     if SAI
        loop
        endif
     *
     TOT_LIN = 0
     WLIN    = 16
     WTOT    = 0.00
     XQUANT  = 1
     XDESCRI = space(40)
     XPRUNI  = 0.00
     @ 15, 02 say 'Unid Quant Discriminacao dos Servicos           '+;
                  '     Preco Unit  Preco Total'
     *
     do while .t.
        @ WLIN, 08 get XQUANT   pict '999'
        @ WLIN, 13 get XDESCRI
        @ WLIN, 55 get XPRUNI   pict '@E 999,999.99'
        read
        if lastkey() = TESC
           OK := 'N'
           P2OKSN('Cancela')
           if OK = 'S'
              SAI := .t.
              exit
              else
                loop
              endif
           *
           elseif lastkey() = PGDN
             OK := 'N'
             P2OKSN('Fim dos Itens')
             if OK = 'S'
                exit
                else
                  loop
                endif
           endif
        *
        if XQUANT <= 0
           MSG_ERRO('Quantidade deve ser maior que zero! Tecle ENTER')
           loop
           endif
        *
        if XPRUNI <= 0.00
           MSG_ERRO('Preco unitario deve ser maior que zero! Tecle ENTER')
           loop
           endif
        *
        OK = 'N'
        P2OKSN('Confirma')
        if OK = 'S'
           if TOT_LIN = 0
              TOT_LIN = 1
              decl WQUANT[1]
              decl WDESCRI[1]
              decl WPRUNI[1] 
              decl WVALOR[1] 
              else
                TOT_LIN++
                asize(WQUANT,  TOT_LIN)
                asize(WDESCRI, TOT_LIN) 
                asize(WPRUNI,  TOT_LIN) 
                asize(WVALOR,  TOT_LIN)  
              endif
           *
           WQUANT[TOT_LIN]  = XQUANT
           WDESCRI[TOT_LIN] = XDESCRI
           WPRUNI[TOT_LIN]  = XPRUNI
           XVALOR           = round(XQUANT*XPRUNI,2)
           WVALOR[TOT_LIN]  = XVALOR
           @ WLIN, 67 get XVALOR pict '@E 999,999.99'
           clear gets
           WTOT = WTOT + XVALOR
           @ 22, 67 get WTOT pict '@E 999,999.99'
           clear gets
           XQUANT  = 1
           XDESCRI = space(40) 
           XPRUNI  = 0.00
           WLIN++
           endif
        enddo
     *
     if SAI
        loop
        endif
     *
     *TEM_RETIDO := if(WSIMPLES = 'S', .t., .f.)
     @ 05, 02 clear to 22, 78
     @ 05, 05 say 'Coloque a NOTA FISCAL numero ' + tran(WNUM_NOTA,'@E 999,999')
     @ 06, 05 say 'para imprimir a nota de'
     @ 07, 05 say WNOME
     @ 08, 05 say 'Tecle ENTER para imprimir ou ESC para cancelar'
     inkey(0)
     @ 05, 05 clear to 08, 60
     if lastkey() = TESC
        exit
        endif
     *
     * Grava nota fiscal
     sele NOTAS
     appe blank
     repla NOT_NUMERO with WNUM_NOTA
     repla NOT_TIPO   with 'V'
     repla NOT_CLIEN  with CLIENTES->CLI_CODIGO
     repla NOT_DATA   with DT_EMISS
     repla NOT_VALOR  with WTOT
     repla NOT_MODO   with WMODO
     repla NOT_FANTAS with CLIENTES->CLI_FANTAS
     *
     sele ITNOTA
     for I1 = 1 to TOT_LIN
         appe blank
         repla ITN_NUMERO with WNUM_NOTA
         repla ITN_TIPO   with 'V'
         repla ITN_PROD   with WDESCRI[I1]
         repla ITN_QUANT  with WQUANT[I1]
         repla ITN_VALOR  with WVALOR[I1]
         next I1
     *
     sele CLIENTES
     WNUM_NOTA++
     enddo
  *
  sele CLIENTES
  set filter to
  return
*
****************** Cancela uma NOTA FISCAL *****************************
*----------------------*
 Procedure NOTAS_CANCEL
*----------------------*
  *
  ******************************************************************
  * Cancela uma NOTA FISCAL ****************************************
  set color to n/bg
  W1 = ' Notas Cancelamento '
  WPAGO   = 'T'  && Para nao filtrar Pagos
  WCANCEL = ' '  && Nao filtra canceladas
  WVENC   = ' ' 
  WCLIEN  = 0
  @02, 01 get W1
  clear gets
  ERRO = .f.
  do while .t.
     if !ERRO
        MDATAI = ctod('  /  /  ')
        MDATAF = ctod('  /  /  ')
        TIPO   = ' '
        endif
     *
     if !LE_PERIODO(0)
        exit
        endif
     *
     @ 05, 05 say 'Nota de (S)ervico, (V)enda ou sem (N)ota:' get TIPO;
              pict '!' valid TIPO $ 'SVN' 
     read
     if lastkey() = TESC
        loop
        endif
     *
     sele ITNOTA
     set filter to ITN_TIPO = TIPO
     go top
     sele NOTAS
     FILTRA()
     *
     do while .t.
        @ 03, 01 clear to 22, 78
        @ 03, 01 to 21, 78
        dbedit(04,02,20,77,CAMPOS2,,FORMATOS2,TITULOS2)
        if lastkey() = TESC
           exit
           endif
        *
        @ 03, 01 clear to 22, 78
        WNOTA = NOT_NUMERO
        sele CLIENTES
        set order to 2
        seek NOTAS->NOT_CLIEN 
        WNOME    = CLI_NOME
        WENDER   = CLI_ENDER
        WBAIRRO  = CLI_BAIRRO
        WCIDADE  = CLI_CIDADE
        WCEP     = left(CLI_CEP,5) + '-' + right(CLI_CEP,3)
        WUF      = CLI_UF
        WCGC     = CLI_CGC   
        WIE      = CLI_IE
        WMODO    = NOTAS->NOT_MODO
        WSIMPLES = ' '
        set order to 1
        MOSTRA_NOTA(WNOTA)
        clear gets
        sele NOTAS
        OK = 'N'
        if NOT_CANCEL = '1'
           WMSG = "Nota ja' cancelada! Desfaz cancelamento"
           else
             WMSG = 'Confirma cancelar a nota fiscal'
           endif
        *
        P2OKSN(WMSG)
        if OK = 'N'
           loop
           endif
        *
        * Cancela/desfaz cancelamento
        if NOT_CANCEL = '1'
           repla NOT_CANCEL with ' '
           else
             repla NOT_CANCEL with 'C'
           endif
        enddo
     *
     sele NOTAS   
     set filter to
     enddo
  *
  return
*
****************** NOTAS FISCAIS Pagamento *****************************
*--------------------*
 Procedure NOTAS_PGTO
*--------------------*
  *
  ******************************************************************
  * NOTA FISCAL Pagamento ******************************************
  set color to n/bg
  ERRO = .f.
  W1 = ' Notas Pagamento '
  @02, 01 get W1
  clear gets
  WPAGO   = 'T'  && Para nao filtrar Pagos
  WCANCEL = '1'  && Somente nao canceladas
  WVENC   = ' ' 
  WCLIEN  = 0
  do while .t.
     if !ERRO
        MDATAI = ctod('  /  /  ')
        MDATAF = ctod('  /  /  ')
        TIPO   = ' '
        endif
     *
     if !LE_PERIODO(0)
        exit
        endif
     *
     @ 05, 05 say 'Nota de (S)ervico, (V)enda ou sem (N)ota:' get TIPO;
              pict '!' valid TIPO $ 'SVN' 
     read
     if lastkey() = TESC
        loop
        endif
     *
     sele ITNOTA
     set filter to ITN_TIPO = TIPO
     go top
     sele NOTAS
     FILTRA()
     do while .t.
        @ 03, 01 clear to 22, 78
        @ 03, 01 to 21, 78
        dbedit(04,02,20,77,CAMPOS2,,FORMATOS2,TITULOS2)
        if lastkey() = TESC
           exit
           endif
        *
        WNOTA = NOT_NUMERO
        @ 03, 01 clear to 22, 78
        sele CLIENTES
        set order to 2
        seek NOTAS->NOT_CLIEN 
        WNOME    = CLI_NOME
        WENDER   = CLI_ENDER
        WBAIRRO  = CLI_BAIRRO
        WCIDADE  = CLI_CIDADE
        WCEP     = left(CLI_CEP,5) + '-' + right(CLI_CEP,3)
        WUF      = CLI_UF    
        WCGC     = CLI_CGC   
        WIE      = CLI_IE
        WMODO    = NOTAS->NOT_MODO
        WSIMPLES = ' '
        set order to 1
        MOSTRA_NOTA(WNOTA)
        clear gets
        sele NOTAS
        OK = 'N'
        if NOT_PAGO = 'PG'
           WMSG = "Nota ja' paga! Desfaz pagamento"
           else
             WMSG = 'Confirma lancar pagamento da nota fiscal'
           endif
        *
        P2OKSN(WMSG)
        if OK = 'N'
           loop
           endif
        *
        * Lanca/Cancela Pagamento
        if NOT_PAGO = 'PG'
           repla NOT_PAGO with ' '
           else
             repla NOT_PAGO with 'PG'
           endif
        enddo
     *
     sele NOTAS   
     set filter to
     sele ITNOTA
     set filter to
     enddo
  *
  return
*
****************** NOTAS FISCAIS Exclusao ******************************
*--------------------*
 Procedure NOTAS_EXCL
*--------------------*
  *
  ******************************************************************
  * NOTA FISCAL Pagamento ******************************************
  set color to n/bg
  ERRO = .f.
  W1 = ' Notas Exclusao '
  @02, 01 get W1
  clear gets
  WPAGO   = 'T'  && Para nao filtrar Pagos
  WCANCEL = ' '  && Nao filtra canceladas
  WVENC   = ' ' 
  WCLIEN  = 0
  do while .t.
     if !ERRO
        MDATAI = ctod('  /  /  ')
        MDATAF = ctod('  /  /  ')
        TIPO   = ' '
        endif
     *
     if !LE_PERIODO(0)
        exit
        endif
     *
     @ 05, 05 say 'Nota de (S)ervico, (V)enda ou sem (N)ota:' get TIPO;
              pict '!' valid TIPO $ 'SVN' 
     read
     if lastkey() = TESC
        loop
        endif
     *
     sele ITNOTA
     set filter to ITN_TIPO = TIPO
     go top
     sele NOTAS
     FILTRA()
     *
     do while .t.
        @ 03, 01 clear to 22, 78
        @ 03, 01 to 21, 78
        dbedit(04,02,20,77,CAMPOS2,,FORMATOS2,TITULOS2)
        if lastkey() = TESC
           exit
           endif
        *
        WNOTA = NOT_NUMERO
        @ 03, 01 clear to 22, 78
        sele CLIENTES
        set order to 2
        seek NOTAS->NOT_CLIEN 
        WNOME    = CLI_NOME
        WENDER   = CLI_ENDER
        WBAIRRO  = CLI_BAIRRO
        WCIDADE  = CLI_CIDADE
        WCEP     = left(CLI_CEP,5) + '-' + right(CLI_CEP,3)
        WUF      = CLI_UF    
        WCGC     = CLI_CGC   
        WIE      = CLI_IE
        WMODO    = NOTAS->NOT_MODO
        WSIMPLES = ' '
        set order to 1
        MOSTRA_NOTA(WNOTA)
        clear gets
        sele NOTAS
        OK = 'N'
        if NOT_PAGO = 'PG'
           WMSG = "Nota ja' paga! Continua Exclusao"
           else
             WMSG = 'Confirma excluir nota fiscal'
           endif
        *
        P2OKSN(WMSG)
        if OK = 'N'
           loop
           endif
        *
        * Exclui Nota
        delete
        skip 
        if eof()
           go bottom
           endif
        enddo
     *
     sele NOTAS   
     set filter to
     enddo
  *
  return
*
****************** Lista NOTAS FISCAIS em ABERTO ***********************
*----------------------*
 Procedure NOTAS_ABERTO
*----------------------*
  *
  ******************************************************************
  * Lista NOTAS FISCAIS em ABERTO **********************************
  set color to n/bg
  W1 = ' Notas em Aberto '
  @02, 01 get W1
  clear gets
  ERRO    = .f.
  WPAGO   = 'N'   && Somente notas nao Pagas
  WCANCEL = '1' && Somente nao canceladas
  WCLIEN  = 0
  sele NOTAS
  set order to 3
  do while !eof()
     if NOT_VENCIM < date() .and. NOT_PAGO = ' '
        repla NOT_ATRAZ with '*'
        else
          repla NOT_ATRAZ with ' '
        endif
     skip
     enddo
  *
  do while .t.
     if !ERRO
        MDATAI = ctod('  /  /  ')
        MDATAF = ctod('  /  /  ')
        TIPO   = ' '
        WVENC  = ' ' 
        endif
     *
     if !LE_PERIODO(0)
        sele NOTAS
        set filter to
        set order to 1
        exit
        endif
     *
     @ 05, 05 say 'Nota de (S)ervico, (V)enda, sem (N)ota ou (T)odas:' get TIPO;
              pict '!' valid TIPO $ 'SVNT' 
     @ 07, 05 say '(V)encidas, (A)vencer ou (T)odas:' get WVENC;
              pict '!' valid WVENC $ 'VAT' 
     read
     if lastkey() = TESC
        loop
        endif
     *
     if WVENC = 'V'
        W1 = ' Notas em Aberto (Vencidas)'
        elseif WVENC = 'A'
          W1 = ' Notas em Aberto (A Vencer)'
        else      && WVENC = 'A'
          W1 = ' Notas em Aberto (Todas)'
        endif
     *
     @02, 01 get W1
     clear gets
     sele NOTAS
     FILTRA()
     go top
     @ 03, 10 clear to 21, 70
     RODAPE(5)
     ULTKEY = 0
     INICIO_DBEDIT = .t.
     dbedit(04,02,20,77,CAMPOS3,'SAI_DBEDIT',FORMATOS3,TITULOS3)
     if ULTKEY = F3
        OK = 'N'
        P2OKSN('Imprime a consulta')
        if OK = 'S'
           @ 04, 01 clear to 22,78
           IMPRIME()
           endif
        endif
     *
     @ 03, 01 clear to 22,78
     enddo
  *
  return
*
****************** Lista NOTAS TODAS de 1 CLIENTE **********************
*---------------------*
 Procedure TODAS_CLIEN
*---------------------*
  *
  ******************************************************************
  * Lista TODAS AS NOTAS FISCAIS do CLIENTE*************************
  set color to n/bg
  W1 = ' Todas do CLIENTE'
  @02, 01 get W1
  clear gets
  ERRO    = .f.
  WPAGO   = 'T'   && Somente notas nao Pagas
  WCANCEL = '1' && Somente nao canceladas
  sele NOTAS
  *set order to 3
  set order to 1
  do while !eof()
     if NOT_VENCIM < date() .and. NOT_PAGO = ' '
        repla NOT_ATRAZ with '*'
        else
          repla NOT_ATRAZ with ' '
        endif
     skip
     enddo
  *
  sele CLIENTES
  RODAPE(1)
  ULTKEY = 0
  INICIO_DBEDIT = .t.
  dbedit(04,02,20,77,CAMPOS,'SAI_DBEDIT',FORMATOS,TITULOS)
  if ULTKEY = TESC
     OK = 'N'
     P2OKSN('Cancela')
     if OK = 'S'
        @ 04, 01 clear to 22,78
        WCLIEN = 0
        return
        endif
     endif
  *
  @ 03, 01 clear to 22,78
  WCLIEN = CLI_CODIGO
  WFANTA = trim(CLI_FANTAS)
  *
  do while .t.
     if !ERRO
        MDATAI = ctod('  /  /  ')
        MDATAF = ctod('  /  /  ')
        TIPO   = ' '
        WVENC  = ' ' 
        endif
     *
     if !LE_PERIODO(0)
        sele NOTAS
        set filter to
        set order to 1
        exit
        endif
     *
     @ 05, 05 say 'Nota de (S)ervico, (V)enda, sem (N)ota ou (T)odas:' get TIPO;
              pict '!' valid TIPO $ 'SVNT' 
     @ 07, 05 say '(V)encidas, (A)vencer ou (T)odas:' get WVENC;
              pict '!' valid WVENC $ 'VAT' 
     read
     if lastkey() = TESC
        loop
        endif
     *
     if WVENC = 'V'
        W1 = ' Notas em Aberto (Vencidas)'
        elseif WVENC = 'A'
          W1 = ' Notas em Aberto (A Vencer)'
        else      && WVENC = 'T'
          W1 = ' Notas em Aberto (Todas)'
        endif
     *
     W2 = WFANTA + ' - ' + W1
     @02, 20 get W2
     clear gets
     sele NOTAS
     FILTRA()
     go top
     @ 03, 10 clear to 21, 70
     RODAPE(5)
     ULTKEY = 0
     INICIO_DBEDIT = .t.
     dbedit(04,02,20,77,CAMPOS5,'SAI_DBEDIT',FORMATOS5,TITULOS5)
     if ULTKEY = F3
        OK = 'N'
        P2OKSN('Imprime a consulta')
        if OK = 'S'
           @ 04, 01 clear to 22,78
           IMPRIME()
           endif
        endif
     *
     @ 03, 01 clear to 22,78
     enddo
  *
  WCLIEN = 0
  return
*
******************************** FILTRA ********************************
*-----------------------*
 Static Procedure FILTRA  
*-----------------------*
  do case
     case MDATAI <> ctod('  /  /  ') .and. MDATAF <> ctod('  /  /  ')
          WF1 = '(NOT_VENCIM >= MDATAI .and. NOT_VENCIM <= MDATAF)'
     case MDATAI <> ctod('  /  /  ') .and. MDATAF = ctod('  /  /  ')
          WF1 = 'NOT_VENCIM >= MDATAI' 
     case MDATAI = ctod('  /  /  ') .and. MDATAF <> ctod('  /  /  ')
          WF1 = 'NOT_VENCIM <= MDATAF' 
     otherwise
          WF1 = ' ' 
     endcase
  *
  if WPAGO = 'P'
     WF2 = "NOT_PAGO = 'PG'"
     elseif WPAGO = 'N'
       WF2 = "NOT_PAGO = '  '"
     else  && WPAGO = 'T'
       WF2 = ' '
     endif
  *
  if TIPO <> 'T'
     WF3 = 'NOT_TIPO = TIPO' 
     else
       WF3 = ' '
     endif
  *
  if WCANCEL = '1'
     WF4 = "NOT_CANCEL = ' '" 
     else
       WF4 = ' '
     endif
  *
  if WVENC = 'V'           && Vencidas
     WF5 = "NOT_VENCIM < date()"
     elseif WVENC = 'A'    && A Vencer
       WF5 = "NOT_VENCIM >= date()"
     else  && WVENC = 'T'  && Todas
       WF5 = ' '
     endif
  *              
  WFILTRO = ' '
  if WF1 <> ' '
     WFILTRO = WF1
     endif
  *
  if WF2 <> ' '
     if WFILTRO <> ' '
        WFILTRO = WFILTRO + ' .and. ' + WF2
        else
          WFILTRO = WF2
        endif
     endif
  *
  if WF3 <> ' '
     if WFILTRO <> ' '
        WFILTRO = WFILTRO + ' .and. ' + WF3
        else
          WFILTRO = WF3
        endif
     endif
  *
  if WF4 <> ' '
     if WFILTRO <> ' '
        WFILTRO = WFILTRO + ' .and. ' + WF4
        else
          WFILTRO = WF4
        endif
     endif
  *
  if WF5 <> ' '
     if WFILTRO <> ' '
        WFILTRO = WFILTRO + ' .and. ' + WF5
        else
          WFILTRO = WF5
        endif
     endif
  *
  if WCLIEN > 0
     if WFILTRO <> ' '
        WFILTRO = WFILTRO + ' .and. ' + 'NOT_CLIEN = WCLIEN'
        else
          WFILTRO = 'NOT_CLIEN = WCLIEN'
        endif
     endif
  *
  if WFILTRO <> ' '
     set filter to &WFILTRO
     go top
     endif
  *
  return
*
***************************** MOSTRA NOTA ******************************
*---------------------*
 Procedure MOSTRA_NOTA
*---------------------*
  *
  *0    *    1    *    2    *    3    *    4    *    5    *    6    *    7    *
  *01234567890123456789012345678901234567890123456789012345678901234567890
  *     Nota fiscal num.: 999.999
  *     Nome da Firma ..: X--------------------------------------X
  *     Endereco .......: X--------------------------------------X
  *     Bairro: X-----------------------X   Cep: 99.999-99
  *     Cidade: X-----------------------X - RJ
  *     CNPJ..: 99.999.999/9999-99     Inscr. Estadual: 99.999.999
  *     ----------------------------------------------------------
  *     Cond. Pagamento ...: X-----------------------------------X
  *     ----------------------------------------------------------
  *
  *   Descricao dos Servicos                   Unid   Quant       Total
  *   -----------------------------------------------------------------
  *   X--------------------------------------X  UN      999  999.999,99
  *   X--------------------------------------X  UN      999  999.999,99      
  *   -----------------------------------------------------------------
  *                                     Valor total da nota: 999.999,99
  *                                     -------------------------------
  *
  *
  @ 03, 05 say 'Nota fiscal num.:' get WNOTA    pict '@E 999,999'
  @ 04, 05 say 'Nome da Firma ..:' get WNOME
  @ 05, 05 say 'Endereco .......:' get WENDER
  @ 06, 05 say 'Bairro:' get WBAIRRO
  @ 06, 41 say 'Cep:' get WCEP
  WX1 = trim(WCIDADE) + ' - ' + WUF
  @ 07, 05 say 'Cidade:' get WX1
  if len(trim(WCGC)) = 11
     @ 08, 05 say 'CPF...:' get WCGC;
              pict '@R 999.999.999-99'
     else
       @ 08, 05 say 'CNPJ..:' get WCGC;
                pict '@R 99.999.999/9999-99'
     endif
  *
  @ 08, 36 say 'Inscr. Estadual:' get WIE pict '@R 99.999.999'
  @ 09,05 to 09,62
  @ 10, 05 say 'Cond. Pagamento ...:' get WMODO
  @ 11,05 to 11,62
  *
  * Imprime itens da nota
  @ 13, 03 say 'Descricao dos Servicos                   ' +;
               'Unid   Quant       Total'
  @ 14,03 to 14,67
  sele ITNOTA
  seek NOTAS->NOT_NUMERO
  WLIN = 14
  do while ITN_NUMERO = WNOTA .and. !eof()
     WLIN++
     @ WLIN, 03 say ITN_PROD
     @ WLIN, 45 say 'UN' 
     @ WLIN, 53 say ITN_QUANT pict '@E 999'
     @ WLIN, 58 say ITN_VALOR pict '@E 999,999.99'
     skip
     enddo
  *
  @ WLIN+1,03 to WLIN+1,67
  @ WLIN+2, 37 say 'Valor total da nota:'
  @ WLIN+2, 58 say NOTAS->NOT_VALOR pict '@E 999,999.99'
  return
*
************************* IMPRIME **************************************
*------------------------*
 Static Procedure IMPRIME
*------------------------*
  WNOMPRG  = 'BOLET'
  TITULO   = 'NOTA FISCAIS EM ABERTO'
  if WVENC = 'V'
     WCABEC1  = 'Boletos VENCIDOS'
     elseif WVENC = 'A'
       WCABEC1  = 'Boletos A VENCER'
     else          && WVENC = 'T'
       WCABEC1  = 'Boletos TODOS'
     endif
  *
  WCABEC1  = WCABEC1 + ' - De ' + dtoc(MDATAI) + ' a ' + dtoc(MDATAF)
  WCABEC2  = ''
  WCONDENS = '1'
  WTAM     = 80
  WDATA    = dtoc(date())
  MHORA    = time()
  PAGINA   = 0
  NLIN     = 99
  * 
  *       0    *    1    *    2    *    3    *    4    *    5    *    6    *    7    *    
  *       01234567890123456789012345678901234567890123456789012345678901234567890123456789
  CAB1 = 'ÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄ'
  CAB2 = '  DATA  ³  VENC  ³  NOTA ³ BOLETO³CODIGO³NOME DO CLIENTE³   VALOR ³PARC.³ OBSERV'      
  CAB3 = 'ÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄ'
  *       99/99/99 99/99/99 999.999 999.999 99.999 X-------------X 99.999,99 99/99 _______
  *       99/99/99 99/99/99*999.999 999.999 99.999 X-------------X 99.999,99 99/99 _______
  *       99/99/99 99/99/99 999.999 999.999 99.999 X-------------X 99.999,99 99/99 _______
  *       ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 
  *                                                        Total: 999.999,99
  *
  TOT_ABERTO = 0.00
  sele CLIENTES
  set order to 2
  sele NOTAS
  go top
  do while !eof()
     ULTKEY = inkey()
     if ULTKEY = TESC
        if CANC_IMPRE()
           exit
           endif
        endif
     *
     if NLIN > 59
        if PAGINA # 0
           eject
           endif
           CABEC(WCONDENS,WTAM,TITULO,WCABEC1,WCABEC2,WNOMPRG,WDATA,MHORA)
           @prow()+1, 00 say CAB1
           @prow()+1, 00 say CAB2
           @prow()+1, 00 say CAB3
           NLIN = 6
           endif
        *
        @prow()+1, 00 say NOT_DATA    
        @prow(),   09 say NOT_VENCIM
        if NOT_VENCIM < date()
           @prow(), 17 say '*'
           endif
        @prow(),   18 say NOT_NUMERO pict '@E 999,999'
        @prow(),   26 say NOT_BOLETO pict '@E 999,999'
        @prow(),   34 say NOT_CLIEN  pict '@E 99,999'
        sele CLIENTES
        seek NOTAS->NOT_CLIEN
        @prow(),   41 say CLI_FANTAS
        sele NOTAS
        @prow(),   57 say NOT_VALOR  pict '@E 99,999.99'
        @prow(),   67 say NOT_PARCEL
        @prow(),   73 say '_______'
        TOT_ABERTO = TOT_ABERTO + NOT_VALOR
        NLIN++
        skip
        enddo
     *
     @prow()+1, 00 say repl('Ä', 80)
     @prow()+1, 49 say 'Total: ' + tran(TOT_ABERTO, '@E 999,999.99')
     eject
     sele CLIENTES
     set order to 1
     return
*
************* Testa se operador quer mesmo cancelar a impressao ********
*--------------------*
 Procedure CANC_IMPRE
*--------------------*
  local WOK:= .f.
  set devi to screen
  @ 24,00 say 'Cancela a impressao (S/N)? N'
  inkey(0)
  @ 24,00
  if upper(chr(lastkey())) = 'S'
     @ PROW()+2,10 say 'Impressao cancelada pelo operador'
     @ PROW()+1,10 say 'Impressao cancelada pelo operador'
     @ PROW()+1,10 say 'Impressao cancelada pelo operador'
     eject
     WOK = .t.
     endif   
  return WOK
*
******************************** DBEDIT_SAI ****************************
*-------------------*
 Function DBEDIT_SAI
*-------------------*
  do case
     case INICIO_DBEDIT
          INICIO_DBEDIT = .f.
          return 1
     case lastkey() = TENTER
          ULTKEY = TENTER
          return 0
     case lastkey() = TESC
          ULTKEY = TESC
          return 0
     case isalpha(chr(lastkey()))
          ULTKEY = lastkey()
          return 0
     endcase
  return 1
*
************************* TRUNCA ***************************************
*-----------------*
 Function TRUNCA()
*-----------------*
  Local W0:= 0.00, W1, RESULT
  Param P_N1, P_SINAL, P_N2, P_DECIMAIS
  if P_SINAL = '*'
     W0 := strzero(P_N1*P_N2, 15, 6)
     elseif P_SINAL = '/'
       W0 := strzero(P_N1/P_N2, 15, 6)
     endif
  W1 := left(W0, 9+P_DECIMAIS)
  RESULT := val(W1)
  return RESULT
*
**************************  fim do programa  ***************************

