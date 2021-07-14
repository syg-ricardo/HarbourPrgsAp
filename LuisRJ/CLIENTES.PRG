*  Sistema.....: ZIUL - Cobranca da manutencao
*  Programador.: Nando                                                  
*  Data........: 27/04/04                                                 
*  Programa....: CLIEN.PRG
*  Descricao...: CADASTRO DE CLIENTES
*  Alteracao...: 
*  Data........:                                                  
*  Rotinas.....: 
*
*************************** Cadastro de Clientes ***********************
*---------------*
 Procedure CLIEN
*---------------*
*
TL_CABEC := 'CADASTRO DE CLIENTES'
P1TELA3()
/*
  0    *    1    *    2    *    3    *    4    *    5    *    6    *    7    *
  012345678901234567890123456789012345678901234567890123456789012345678901234567
02  Cod.: 99.999 - X-------------X   Telef: (99)9999-9999 e X------------------X
03
04  Resp.: X----------------------------X  Ref.: X-----------------------------X
05
06  Razao Social: X--------------------------------------X  Band.: IPIRANGA
07
08  Endereco: X--------------------------------------X      Numero: 999.999
09
10  Complemento: X------------------X     CEP: 99999-999    Rede: X------------X
11
12  Bairro: X-----------------------X  Cidade: X-----------------------X  UF: XX 
13
14  CNPJ: 99.999.999/9999-99  IE: 99999999           IM: 9.999.999-9
15                                                      
16  Email: X-------------------------------------------------------------------X
17  ----------------------------------------------------------------------------
18  Licenca de uso: 999.999,99     Manutencao: 999.999,99     Mobile: 999.999,99
19  
20  TEF Mobile: 999.999,99         Conciliador: 999.999,99    TEF IP: 999.999,99
21  ----------------------------------------------------------------------------
22           
*/
set color to n/bg
@ 02, 01 clear to 22, 78
*          0    *    1    *    2    *    3    *    4    *    5    *    6    *    7    *
*          012345678901234567890123456789012345678901234567890123456789012345678901234567
@ 02,02 say 'Cod.:        -                   Telef:               e'
@ 04,02 say 'Resp.:                                 Ref.:'
@ 06,02 say 'Razao Social:                                           Band..: '
@ 08,02 say 'Endereco:                                               Numero: '
 @ 10,02 say 'Complemento:                          CEP:              Rede:'
@ 12,02 say 'Bairro:                            Cidade:                            UF:   '
@ 14,02 say 'CNPJ:                      IE:                   IM:'
@ 16,02 say 'Email:'
@ 17,02 say repl('�', 76) 
@ 18,02 say 'Licenca de uso:                Manutencao:                Mobile: '
@ 20,02 say 'TEF Mobile:                    Conciliador:               TEF IP: '
@ 21,02 say repl('�', 76)
TELA1 = savescreen(02,01,22,78)                          
*
sele CLIENTES
decl CAMPOS2[4]
     CAMPOS2[1] = 'CLI_CODIGO'
     CAMPOS2[2] = 'CLI_FANTAS'
     CAMPOS2[3] = 'CLI_RESPON'
     CAMPOS2[4] = 'CLI_TELEFO'
decl FORMATOS2[4]
     FORMATOS2[1] = '@E 99,999'
     FORMATOS2[2] = ''
     FORMATOS2[3] = ''
     FORMATOS2[4] = ''
decl TITULOS2[4]
     TITULOS2[1] = 'CODIGO'
     TITULOS2[2] = 'FANTASIA'
     TITULOS2[3] = 'RESPONS'
     TITULOS2[4] = 'TELEFONE'
*
do while .t.
   RODAPE(1)
   set color to n/bg
   @ 02,01 clear to 22,78
   set wrap on
   MENUT := 1
   @ 03,02 to 09,13 double
   @ 04,03 prompt "Incluir  "
   @ 05,03 prompt "Alterar  "
   @ 06,03 prompt "Consultar"
   @ 07,03 prompt "Excluir  "
   @ 08,03 prompt "Retornar "
   menu to menuT
   if lastkey() = TESC .or. MENUT = 5
      exit
      endif
   @ 02,01 clear to 22,78
   do case
      *
      **************************** INCLUSAO ****************************
      case MENUT = 1      
           sele CLIENTES
           set order to 2
           do while .t.
              RODAPE(1)
              sele CLIENTES
              go top
              I1 := 1
              do while .t.
                 if CLI_CODIGO # I1
                    CODIGO := I1
                    exit
                    endif
                 skip
                 I1++
                 enddo
              *
              restscreen(02,01,22,78,TELA1)
              @ 00, 78 say 'IN' 
              @ 02, 08 get CODIGO pict '@E 99,999' valid CODIGO > 0
              read
              if lastkey() = TESC 
                 set order to 1
                 exit
                 endif
              *
              sele CLIENTES
              seek CODIGO
              if found()
                 MSG_ERRO('Codigo de Cliente ja Cadastrado! Tecle ENTER')
                 loop
                 endif
              *
              ************************ LE DADOS ************************
              ERRO1 := .f.
              do while .t.
                 if !ERRO1
                    FANTASIA = space(15)
                    RAZAO    = space(40)
                    BANDEIRA = space(10)
                    RESPONS  = space(30)
                    TELEFONE = space(13)
                    TELEF2   = space(20)
                    TIPOEN   = '   '
                    ENDERECO = space(40)
                    NUMERO   = 0.00
                    COMPLEME = space(20)
                    BAIRRO   = space(25)
                    CEP      = space(08)
                    REDE     = space(14)
                    CIDADE   = 'RIO DE JANEIRO           '
                    UF       = 'RJ'
                    CGC      = space(14)
                    IE       = space(08)
                    IM       = space(08)
                    EMAIL    = space(69)
                    VALOR    = 0.00
                    REFER    = 'Licenca de uso SGA Petro       '
                    MANUT    = 0.00
                    MOBILE     = 0.00
                    TEF_MOBILE = 0.00
                    CONCILIAD  = 0.00
                    TEF_IP     = 0.00
                    endif
                 *
                 ERRO1 = .f.
                 @ 02,17 get FANTASIA
                 @ 02,42 get TELEFONE  pict '(99)9999-9999'
                 @ 02,58 get TELEF2
                 @ 04,09 get RESPONS  
                 @ 04,47 get REFER   
                 @ 06,16 get RAZAO
                 @ 06,66 get BANDEIRA  pict '@!'
                 @ 08,12 get TIPOEN  
                 @ 08,16 get ENDERECO
                 @ 08,66 get NUMERO    pict '@E 999,999'
                 @ 10,15 get COMPLEME  
                 @ 10,45 get CEP       pict '@R 99999-999'
                 @ 10,64 get REDE      pict '@!'
                 @ 12,10 get BAIRRO    pict '@!'
                 @ 12,45 get CIDADE    pict '@!'
                 @ 12,76 get UF        pict '!!'
                 @ 14,08 get CGC       pict '@R 99.999.999/9999-99'
                 @ 14,33 get IE        pict '@R 99.999.999'
                 @ 14,55 get IM        pict '@R 9.999.999-9'
                 @ 16,09 get EMAIL      
                 @ 18,18 get VALOR     pict '@E 999,999.99'
                 @ 18,45 get MANUT     pict '@E 999,999.99'
                 @ 18,68 get MOBILE     pict '@E 999,999.99'
                 @ 20,14 get TEF_MOBILE pict '@E 999,999.99'
                 @ 20,46 get CONCILIAD  pict '@E 999,999.99'
                 @ 20,68 get TEF_IP     pict '@E 999,999.99'
                 read
                 *
                 if lastkey() = TESC
                    exit
                    endif
                 * 
                 * Criticas
                 if empty(FANTASIA)
                    MSG_ERRO('Preencha o NOME FANTASIA. Tecle ENTER')
                    ERRO1 := .t.
                    elseif !empty(CGC) .and. !RDV11('J',CGC)
                      MSG_ERRO('CNPJ Invalido! Tecle ENTER')
                      ERRO1 := .t.
                  endif
                 *
                 if ERRO1
                    loop
                    endif
                 *
                 OK = 'S'
                 P2OKSN('Confirma INCLUSAO')
                 if OK = 'N'
                    ERRO1 := .t.
                    loop
                    endif
                 *
                 * Grava novo cliente
                 sele CLIENTES
                 append blank
                 repl CLI_CODIGO with CODIGO 
                 repl CLI_FANTAS with FANTASIA
                 repl CLI_NOME   with RAZAO   
                 repl CLI_BANDEI with BANDEIRA  
                 repl CLI_RESPON with RESPONS 
                 repl CLI_TELEFO with TELEFONE
                 repl CLI_TELEF2 with TELEF2
                 repl CLI_TIPOEN with TIPOEN     
                 repl CLI_ENDER  with ENDERECO   
                 repl CLI_NUMERO with NUMERO 
                 repl CLI_COMPL  with COMPLEME
                 repl CLI_BAIRRO with BAIRRO  
                 repl CLI_CEP    with CEP     
                 repl CLI_REDE   with REDE     
                 repl CLI_CIDADE with CIDADE  
                 repl CLI_UF     with UF      
                 repl CLI_CGC    with CGC     
                 repl CLI_IE     with IE      
                 repl CLI_IM     with IM      
                 repl CLI_EMAIL  with EMAIL   
                 repl CLI_VALOR  with VALOR   
                 repl CLI_REFER  with REFER   
                 repl CLI_MANUT  with MANUT   
                 *
                 * Grava outros servicos
                 replace CLI_MOBILE with MOBILE
                 replace CLI_TEFMOB with TEF_MOBILE
                 replace CLI_CONCIL with CONCILIAD
                 replace CLI_TEFIP  with TEF_IP
                 *
                 *if TIPO = 'H'
                 *   repl CLI_TIPO with 'H'
                 *   else
                 *     repl CLI_TIPO with 's'
                 *   endif
                 *repl CLI_TIPO with TIPO
                 commit
                 exit
                 enddo
              enddo
   *
   **************************** ALTERACAO ******************************
   case MENUT = 2   
        @ 00, 78 say 'AL' 
        sele CLIENTES
        WFILT = 1
        do while .t.
           do while .t.
              sele CLIENTES
              set order to 1
              CANCELOU      = .f.
              ULTKEY        = 0
              INICIO_DBEDIT = .t.
              RODAPE(3)
              set color to n/bg
              @ 02, 01 clear to 22, 78
              @ 02, 01 to 22, 78
              dbedit(07,02,19,77,CAMPOS2,'SAI_DBEDIT',FORMATOS2,TITULOS2)
              do case
                 case ULTKEY = TESC
                      CANCELOU = .t.
                      exit
                 *
                 case ULTKEY = F4
                      if WFILT = 1
                         WFILT = 2
                         set filter to CLI_VALOR > 0.00
                         go top
                         else
                           WFILT = 1
                           set filter to
                           go top
                         endif
                      loop
                 *
                 case ULTKEY = TENTER
                      restscreen(02,01,22,78,TELA1)
                      exit
                 *
                 endcase
              enddo
           *
           if CANCELOU
              set filter to
              go top
              exit
              endif
           *
           ERRO := .f.
           sele CLIENTES
           set order to 2
           do while .t.
              set color to n/bg
              @ 00, 78 say 'AL'
              @ 02, 08 get CLI_CODIGO pict '@E 99,999'
              clear gets
              RODAPE(1)
              *
              ************************ LE DADOS *****************************
              ERRO1 = .f.
              *
              do while .t.
                 CANCELOU := .f.
                 sele CLIENTES
                 RODAPE(1)
                 if !ERRO1
                    CODIGO   = CLI_CODIGO 
                    FANTASIA = CLI_FANTAS
                    RAZAO    = CLI_NOME   
                    BANDEIRA = CLI_BANDEI  
                    RESPONS  = CLI_RESPON
                    TELEFONE = CLI_TELEFO
                    TELEF2   = CLI_TELEF2
                    TIPOEN   = CLI_TIPOEN
                    ENDERECO = CLI_ENDER
                    NUMERO   = CLI_NUMERO
                    COMPLEME = CLI_COMPL
                    BAIRRO   = CLI_BAIRRO   
                    CEP      = CLI_CEP 
                    REDE     = CLI_REDE       
                    CIDADE   = CLI_CIDADE   
                    UF       = CLI_UF           
                    CGC      = CLI_CGC         
                    IE       = CLI_IE           
                    IM       = CLI_IM
                    EMAIL    = left(CLI_EMAIL,69)
                    VALOR    = CLI_VALOR
                    REFER    = CLI_REFER
                    MANUT    = CLI_MANUT
                    *
                    MOBILE     = CLI_MOBILE
                    TEF_MOBILE = CLI_TEFMOB
                    CONCILIAD  = CLI_CONCIL
                    TEF_IP     = CLI_TEFIP
                    endif
                 *
                 ERRO1 = .f.
                 set color to n/bg
                 @ 02,17 get FANTASIA
                 @ 02,42 get TELEFONE  pict '(99)9999-9999'
                 @ 02,58 get TELEF2
                 @ 04,09 get RESPONS
                 @ 04,47 get REFER   
                 @ 06,16 get RAZAO
                 @ 06,66 get BANDEIRA  pict '@!'
                 @ 08,12 get TIPOEN  
                 @ 08,16 get ENDERECO
                 @ 08,66 get NUMERO    pict '@E 999,999'
                 @ 10,15 get COMPLEME  
                 @ 10,45 get CEP       pict '@R 99999-999'
                 @ 10,64 get REDE      pict '@!'
                 @ 12,10 get BAIRRO    pict '@!'
                 @ 12,45 get CIDADE    pict '@!'
                 @ 12,76 get UF        pict '!!'
                 @ 14,08 get CGC       pict '@R 99.999.999/9999-99'
                 @ 14,33 get IE        pict '@R 99.999.999'
                 @ 14,55 get IM        pict '@R 9.999.999-9'
                 @ 16,09 get EMAIL     
                 @ 18,18 get VALOR     pict '@E 999,999.99'
                 @ 18,45 get MANUT     pict '@E 999,999.99'
                 *
                 @ 18,68 get MOBILE     pict '@E 999,999.99'
                 @ 20,14 get TEF_MOBILE pict '@E 999,999.99'
                 @ 20,46 get CONCILIAD  pict '@E 999,999.99'
                 @ 20,68 get TEF_IP     pict '@E 999,999.99'
                 read
                 *
                 if lastkey() = TESC
                    CANCELOU := .t.
                    exit
                    endif
                 *
                 * Criticas
                 if empty(FANTASIA)
                    MSG_ERRO('Preencha o NOME FANTASIA. Tecle ENTER')
                    ERRO1 := .t.
                    elseif !empty(CGC) .and. !RDV11('J',CGC)
                      MSG_ERRO('CNPJ Invalido! Tecle ENTER')
                      ERRO1 := .t.
                    *elseif empty(IE)
                    *  MSG_ERRO('Preencha a INSCRICAO ESTADUAL. Tecle ENTER')
                    *  ERRO1 := .t.
                    *elseif empty(REFER)
                    *  MSG_ERRO('Preencha a REFERENCIA. Tecle ENTER')
                    *  ERRO1 := .t.
                    endif
                 *
                 if ERRO1
                    loop
                    endif
                 *
                 if lastkey() = TESC
                    CANCELOU := .t.
                    exit
                    endif
                 *
                 OK = 'S'
                 P2OKSN('Confirma ALTERACAO')
                 if OK = 'N'
                    ERRO1 = .t.
                    loop
                    endif
                 *
                 * Grava alteracao
                 sele CLIENTES
                 repl CLI_FANTAS with FANTASIA
                 repl CLI_NOME   with RAZAO   
                 repl CLI_BANDEI with BANDEIRA  
                 repl CLI_RESPON with RESPONS    
                 repl CLI_TELEFO with TELEFONE   
                 repl CLI_TELEF2 with TELEF2
                 repl CLI_TIPOEN with TIPOEN     
                 repl CLI_ENDER  with ENDERECO   
                 repl CLI_NUMERO with NUMERO     
                 repl CLI_COMPL  with COMPLEME   
                 repl CLI_BAIRRO with BAIRRO  
                 repl CLI_CEP    with CEP     
                 repl CLI_CIDADE with CIDADE  
                 repl CLI_UF     with UF      
                 repl CLI_CGC    with CGC     
                 repl CLI_IE     with IE      
                 repl CLI_IM     with IM      
                 repl CLI_EMAIL  with EMAIL 
                 repl CLI_VALOR  with VALOR   
                 repl CLI_REFER  with REFER   
                 repl CLI_MANUT  with MANUT   
                 *
                 * Grava outros servicos
                 replace CLI_MOBILE with MOBILE
                 replace CLI_TEFMOB with TEF_MOBILE
                 replace CLI_CONCIL with CONCILIAD
                 replace CLI_TEFIP  with TEF_IP
                 *
                 sele CLIENTES
                 commit
                 CANCELOU := .t.  && Para sair
                 exit
                 enddo
              *
              if CANCELOU
                 exit
                 endif
              enddo
           *
           enddo
   *   
   **************************** CONSULTAR ******************************
   case MENUT = 3   
        @ 00, 78 say 'CO' 
        NORDEM := 1
        do while .t.
           sele CLIENTES
           ULTKEY := 0
           INICIO_DBEDIT := .t.
           RODAPE(6)
           set color to n/bg
           @ 02, 01 clear to 22, 78
           @ 02, 01 to 22, 78
           dbedit(07,02,19,77,CAMPOS2,'SAI_DBEDIT',FORMATOS2,TITULOS2)
           *
           do case
              case ULTKEY = TESC
                   sele CLIENTES
                   set order to 1
                   exit
              *
              case ULTKEY = F4
                   NORDEM := if(NORDEM=1, 2, 1)
                   sele CLIENTES
                   set order to NORDEM
                   go top
              *
              case ULTKEY = TENTER
                   CODIGO   = CLI_CODIGO 
                   FANTASIA = CLI_FANTAS
                   RAZAO    = CLI_NOME   
                   BANDEIRA = CLI_BANDEI  
                   RESPONS  = CLI_RESPON
                   TELEFONE = CLI_TELEFO
                   TELEF2   = CLI_TELEF2
                   TIPOEN   = CLI_TIPOEN
                   ENDERECO = CLI_ENDER
                   NUMERO   = CLI_NUMERO 
                   COMPLEME = CLI_COMPL
                   BAIRRO   = CLI_BAIRRO   
                   CEP      = CLI_CEP
                   REDE     = CLI_REDE   
                   CIDADE   = CLI_CIDADE   
                   UF       = CLI_UF           
                   CGC      = CLI_CGC         
                   IE       = CLI_IE           
                   IM       = CLI_IM           
                   EMAIL    = left(CLI_EMAIL,69)      
                   VALOR    = CLI_VALOR     
                   REFER    = CLI_REFER     
                   MANUT    = CLI_MANUT
                   *
                   MOBILE     = CLI_MOBILE
                   TEF_MOBILE = CLI_TEFMOB
                   CONCILIAD  = CLI_CONCIL
                   TEF_IP     = CLI_TEFIP
                   *
                   restscreen(02,01,22,78,TELA1)
                   set color to n/bg
                   @ 02,08 get CODIGO     pict '@E 99,999'
                   @ 02,17 get FANTASIA
                   @ 02,42 get TELEFONE
                   @ 02,58 get TELEF2
                   @ 04,09 get RESPONS
                   @ 04,47 get REFER   
                   @ 06,16 get RAZAO
                   @ 06,66 get BANDEIRA   pict '@!'
                   @ 08,12 get TIPOEN  
                   @ 08,16 get ENDERECO
                   @ 08,66 get NUMERO     pict '@E 999,999'
                   @ 10,15 get COMPLEME  
                   @ 10,45 get CEP        pict '@R 99999-999'
                   @ 10,64 get REDE       pict '@!'
                   @ 12,10 get BAIRRO     pict '@!'
                   @ 12,45 get CIDADE     pict '@!'
                   @ 12,76 get UF         pict '!!'
                   @ 14,08 get CGC        pict '@R 99.999.999/9999-99'
                   @ 14,33 get IE         pict '@R 99.999.999'
                   @ 14,55 get IM         pict '@R 9.999.999-9'
                   @ 16,09 get EMAIL      
                   @ 18,18 get VALOR      pict '@E 999,999.99'
                   @ 18,45 get MANUT      pict '@E 999,999.99'
                   @ 18,68 get MOBILE     pict '@E 999,999.99'
                   @ 20,14 get TEF_MOBILE pict '@E 999,999.99'
                   @ 20,46 get CONCILIAD  pict '@E 999,999.99'
                   @ 20,68 get TEF_IP     pict '@E 999,999.99'
                   clear gets
                   inkey(0)
              *
              endcase
           enddo
   *
   **************************** EXCLUSAO *******************************
   case MENUT = 4   
        ERRO := .f.
        sele CLIENTES
        set order to 2
        do while .t.
           RODAPE(1)
           if !ERRO
              CODIGO    := 0
              SALVA_COD := CODIGO
              @ 06, 07 clear to 06,57
              endif
           ERRO := .f.
           restscreen(02,01,22,78,TELA1)
           @ 00, 78 say 'EX' 
           @ 02, 08 get CODIGO pict '@E 99,999' valid CODIGO > 0
           read
           if lastkey() = TESC 
              set order to 1
              exit
              endif
           sele CLIENTES
           seek CODIGO
           if !found()
              MSG_ERRO('Codigo de Cliente nao Cadastrado! Tecle ENTER')
              ERRO   := .t.
              CODIGO := SALVA_COD
              @ 03, 10 get CODIGO pict '@E 99,999'
              clear gets
              loop
              endif
           SALVA_COD := CODIGO
           *
           ************************ LE DADOS *****************************
           ERRO1 := .f.
           do while .t.
              sele CLIENTES
              RODAPE(1)
              if !ERRO1
                 CODIGO   = CLI_CODIGO 
                 FANTASIA = CLI_FANTAS
                 RAZAO    = CLI_NOME   
                 BANDEIRA = CLI_BANDEI  
                 RESPONS  = CLI_RESPON    
                 TELEFONE = CLI_TELEFO    
                 TELEF2   = CLI_TELEF2
                 TIPOEN   = CLI_TIPOEN    
                 ENDERECO = CLI_ENDER     
                 NUMERO   = CLI_NUMERO    
                 COMPLEME = CLI_COMPL    
                 BAIRRO   = CLI_BAIRRO   
                 CEP      = CLI_CEP
                 REDE     = CLI_REDE
                 CIDADE   = CLI_CIDADE   
                 UF       = CLI_UF           
                 CGC      = CLI_CGC         
                 IE       = CLI_IE           
                 IM       = CLI_IM           
                 EMAIL    = left(CLI_EMAIL,69)      
                 VALOR    = CLI_VALOR     
                 REFER    = CLI_REFER     
                 MANUT    = CLI_MANUT     
                 MOBILE     = CLI_MOBILE
                 TEF_MOBILE = CLI_TEFMOB
                 CONCILIAD  = CLI_CONCIL
                 TEF_IP     = CLI_TEFIP
                 endif
              *
              ERRO1 = .f.
              @ 02,17 get FANTASIA
              @ 02,42 get TELEFONE
              @ 02,58 get TELEF2
              @ 04,09 get RESPONS 
              @ 04,47 get REFER   
              @ 06,16 get RAZAO
              @ 06,66 get BANDEIRA
              @ 08,12 get TIPOEN  
              @ 08,16 get ENDERECO
              @ 08,66 get NUMERO    pict '@E 999,999'
              @ 10,15 get COMPLEME  
              @ 10,45 get CEP       pict '@R 99999-999'
              @ 12,10 get BAIRRO  
              @ 12,45 get CIDADE  
              @ 12,76 get UF      
              @ 14,08 get CGC       pict '@R 99.999.999/9999-99'
              @ 14,33 get IE        pict '@R 99.999.999'
              @ 14,55 get IM        pict '@R 9.999.999-9'
              @ 16,09 get EMAIL                           
              @ 18,18 get VALOR     pict '@E 999,999.99'
              @ 18,45 get MANUT     pict '@E 999,999.99'
              @ 18,68 get MOBILE     pict '@E 999,999.99'
              @ 20,14 get TEF_MOBILE pict '@E 999,999.99'
              @ 20,46 get CONCILIAD  pict '@E 999,999.99'
              @ 20,68 get TEF_IP     pict '@E 999,999.99'
              clear gets
              OK = 'N'
              P2OKSN('Confirma EXCLUSAO')
              if OK = 'N'
                 ERRO1 = .t.
                 exit
                 endif
              *
              * Grava o cliente em DESATIV.DBF
              sele DESATIV
              appe from CLIENTES for CLI_CODIGO = CODIGO
              *
              * Exclui cliente
              sele CLIENTES
              delete
              commit
              exit
              enddo
           enddo
   endcase
 enddo
return
*
*************************** Servicos Adicionais ************************
*-------------------*
 Procedure SERV_ADIC
*-------------------*
*
TL_CABEC := 'SERVICOS ADICIONAIS'
P1TELA3()
/*
*          0    *    1    *    2    *    3    *    4    *    5    *    6    *    7    *
*          012345678901234567890123456789012345678901234567890123456789012345678901234567
@ 05,02 say 'Codigo:         Nome Fantasia:'
@ 07,02 say 'Razao Social:'
@ 09,02 say 'Endereco:                                           CEP:'        
@ 11,02 say 'Bairro:                            Cidade:                            UF:'
@ 13,02 say 'CNPJ:                     IE:'  
@ 15,02 say 'Valor:               Referencia:'
@ 17,02 say 'Ender Corr(M/O):    Banco(H/S):'
@ 18,02 say repl('�', 76) 
TELA1 := savescreen(02,01,22,78)
*/
*
decl CAMPOS2[4]
     CAMPOS2[1] = 'CLI_CODIGO'
     CAMPOS2[2] = 'CLI_FANTAS'
     CAMPOS2[3] = 'CLI_NOME'
decl FORMATOS2[3]
     FORMATOS2[1] = '@E 99,999'
     FORMATOS2[2] = ''
     FORMATOS2[3] = ''
decl TITULOS2[3]
     TITULOS2[1] = 'CODIGO'
     TITULOS2[2] = 'FANTASIA'
     TITULOS2[3] = 'NOME'
*
decl CAMPOS3[7]
     CAMPOS3[1] = 'SAD_CODIGO'
     CAMPOS3[2] = 'SAD_FANTAS'
     CAMPOS3[3] = 'SAD_NOME'
     CAMPOS3[4] = 'SAD_VALID'
     CAMPOS3[5] = 'SAD_UNID'
     CAMPOS3[6] = 'SAD_REFER'
     CAMPOS3[7] = 'SAD_VALOR'
decl FORMATOS3[7]
     FORMATOS3[1] = '@E 99,999'
     FORMATOS3[2] = ''
     FORMATOS3[3] = ''
     FORMATOS3[4] = ''
     FORMATOS3[5] = '999'
     FORMATOS3[6] = ''
     FORMATOS3[7] = '@E 9,999,999.99'
decl TITULOS3[7]
     TITULOS3[1] = 'CODIGO'
     TITULOS3[2] = 'FANTASIA'
     TITULOS3[3] = 'NOME'
     TITULOS3[4] = 'VALID'
     TITULOS3[5] = 'UNID'
     TITULOS3[6] = 'REFER'
     TITULOS3[7] = 'VALOR'
*
do while .t.
   RODAPE(1)
   set color to n/bg
   @ 02,01 clear to 22,78
   set wrap on
   MENUT := 1
   @ 03,02 to 09,13 double
   @ 04,03 prompt "Incluir  "
   @ 05,03 prompt "Alterar  "
   @ 06,03 prompt "Consultar"
   @ 07,03 prompt "Excluir  "
   @ 08,03 prompt "Retornar "
   menu to menuT
   if lastkey() = TESC .or. MENUT = 5
      exit
      endif
   @ 02,01 clear to 22,78
   do case
      *
      **************************** INCLUSAO ****************************
      case MENUT = 1      
           @ 00, 78 say 'IN' 
           INICIO_DBEDIT := .t.
           do while .t.
              sele SERV_ADI
              go bottom
              ULT_LANCAM := SAD_VALORD
              *
              sele CLIENTES
              ULTKEY := 0
              INICIO_DBEDIT := .t.
              RODAPE(2)
              set color to n/bg
              @ 02, 01 clear to 22, 78
              @ 02, 01 to 22, 78
              dbedit(05,02,19,77,CAMPOS2,'SAI_DBEDIT',FORMATOS2,TITULOS2)
              @ 02,01 clear to 22,78
              *
              do case
                 case ULTKEY = TESC
                      exit
                 *
                 case ULTKEY = TENTER
                      *0    *    1    *    2    *    3    *    4    *    5    *    6
                      *012345678901234567890123456789012345678901234567890123456789012
                      *  Codigo:         Nome Fantasia: X-------------X
                      *  Razao Social: X--------------------------------------X
                      *  -------------------------------------------------------------
                      *  Validade .: XXX/99
                      *  Unidades .: 999
                      *  Referencia: X-----------------------------X  
                      *  Valor ....: 9.999.999,99
                      *  Codigo SV.: 99.99.99
                      *
                      VALID  = space(6)
                      UNID   = 0
                      REFER  = space(31)
                      *COD_SERV = space(8)
                      VALOR := 0.00
                      @ 05,02 say 'Codigo:         Nome Fantasia:'
                      @ 07,02 say 'Razao Social:'
                      @ 08,02 say repl('�', 61) 
                      @ 09,02 say 'Validade .:'
                      @ 11,02 say 'Unidades .:'
                      @ 13,02 say 'Referencia:'
                      @ 15,02 say 'Valor ....:'
                      @ 05,10 get CLI_CODIGO pict '@E 99,999'
                      @ 05,33 get CLI_FANTAS
                      @ 07,16 get CLI_NOME
                      clear gets
                      CANCELOU := .f.
                      do while .t.
                         @ 09,14 get VALID pict '@! XXX/99' 
                         @ 11,14 get UNID  pict '999' valid UNID > 0
                         @ 13,14 get REFER  
                         @ 15,14 get VALOR    pict '@E 9,999,999.99';
                                              valid VALOR > 0.00
                         read
                         if lastkey() = TESC
                            CANCELOU := .t.
                            exit
                            endif
                         *
                         * Pega codigo do servico
                         * **********************
                         WCDSVMU = '        '
                         @ 17,02 say 'Codigo SV.:' get WCDSVMU pict '99.99.99'
                         clear gets
                         WLIN_SV = 17
                         WCOL_SV = 14
                         WSERVI  = ' '  && PEGA_CODSER ai preencher
                         if !PEGA_CODSER()
                            CANCELOU = .t.
                            exit
                            endif
                         *
                         W0 = trim(left(WSERVI,46))
                         @ 17, 14 get WCDSVMU pict '@ 99.99.99'
                         @ 17, 22 say '-'
                         @ 17, 23 get W0
                         clear gets
                         *
                         W0 = ascan(MESES, left(VALID,3))
                         W1 = right(VALID,2) + strzero(W0,2)
                         if W1 < ULT_LANCAM
                            MSG_ERRO('VALIDADE menor que ultima lancada! tecle ENTER')
                            loop
                            endif
                         *
                         OK := 'S'
                         P2OKSN('Confirma Servicos')
                         if OK = 'S'
                            exit
                            endif
                         enddo
                      *
                      if CANCELOU
                         loop
                         endif
                      *
                      * Grava servico adicional
                      sele SERV_ADI
                      appe blank
                      repla SAD_CODIGO with CLIENTES->CLI_CODIGO
                      repla SAD_FANTAS with CLIENTES->CLI_FANTAS
                      repla SAD_NOME   with CLIENTES->CLI_NOME  
                      repla SAD_VALID  with VALID
                      W1 := ascan(MESES, left(VALID,3))
                      repla SAD_VALORD with right(VALID,2) + strzero(W1,2)
                      repla SAD_UNID   with UNID
                      repla SAD_REFER  with REFER
                      repla SAD_VALOR  with VALOR
                      repla SAD_CODSER with WCDSVMU
                      commit
                 *
                 endcase
              enddo
      *
      **************************** ALTERACAO ***************************
      case MENUT = 2      
           @ 00, 78 say 'AL' 
           sele SERV_ADI
           do while .t.
              ULTKEY := 0
              INICIO_DBEDIT := .t.
              RODAPE(2)
              set color to n/bg
              @ 02, 01 to 22, 78
              dbedit(05,02,19,77,CAMPOS3,,FORMATOS3,TITULOS3)
              @ 02,01 clear to 22,78
              *
              do case
                 case lastkey() = TESC
                      exit
                 *
                 case lastkey() = TENTER
                      *0    *    1    *    2    *    3    *    4    *    5    *
                      *01234567890123456789012345678901234567890123456789012345
                      *  Codigo:         Nome Fantasia: X-------------X
                      *  Razao Social: X--------------------------------------X
                      *  ------------------------------------------------------
                      *  Validade..: XXX/99
                      *  Unidades..: 999
                      *  Referencia: X-----------------------------X
                      *  Valor.....: 9.999.999,99
                      *
                      VALID := SAD_VALID
                      UNID  := SAD_UNID
                      REFER := SAD_REFER
                      VALOR := SAD_VALOR
                      @ 05,02 say 'Codigo:         Nome Fantasia:'
                      @ 07,02 say 'Razao Social:'
                      @ 08,02 say repl('�', 54) 
                      @ 09,02 say 'Validade..:'
                      @ 11,02 say 'Unidades..:'
                      @ 13,02 say 'Referencia:'
                      @ 15,02 say 'Valor.....:'
                      @ 05,10 get SAD_CODIGO pict '@E 99,999'
                      @ 05,33 get SAD_FANTAS
                      @ 07,16 get SAD_NOME
                      clear gets
                      CANCELOU := .f.
                      do while .t.
                         @ 09,14 get VALID pict '@! XXX/99' 
                         @ 11,14 get UNID  pict '999' 
                         @ 13,14 get REFER  
                         @ 15,14 get VALOR pict '@E 9,999,999.99' 
                         read
                         if lastkey() = TESC
                            CANCELOU := .f.
                            exit
                            endif
                         OK := 'S'
                         P2OKSN('Confirma Alteracao')
                         if OK = 'S'
                            exit
                            endif
                         enddo
                      if CANCELOU
                         loop
                         endif
                      *
                      * Grava servico adicional
                      repla SAD_VALID  with VALID
                      W1 := ascan(MESES, left(VALID,3))
                      repla SAD_VALORD with right(VALID,2) + strzero(W1,2)
                      repla SAD_UNID   with UNID 
                      repla SAD_REFER  with REFER
                      repla SAD_VALOR  with VALOR
                      commit
                 *
                 endcase
              enddo
      *
      **************************** CONSULTA ****************************
      case MENUT = 3      
           @ 00, 78 say 'CO' 
           sele SERV_ADI
           NORDEM := 1
           do while .t.
              ULTKEY := 0
              INICIO_DBEDIT := .t.
              RODAPE(7)
              set color to n/bg
              do case
                 case NORDEM = 1
                      @ 04, 10 say 'Ordem: CODIGO             '
                 case NORDEM = 2
                      @ 04, 10 say 'Ordem: FANTASIA           '
                 case NORDEM = 3
                      @ 04, 10 say 'Ordem: VALIDADE + FANTASIA'
                 endcase
              *
              @ 02, 01 to 22, 78
              dbedit(07,02,19,77,CAMPOS3,'SAI_DBEDIT',FORMATOS3,TITULOS3)
              do case
                 case ULTKEY = TESC
                      sele SERV_ADI
                      set order to 1
                      exit
                 *
                 case ULTKEY = F4
                      do case
                         case NORDEM = 1
                              NORDEM := 2
                         case NORDEM = 2
                              NORDEM := 3
                         case NORDEM = 3
                              NORDEM := 1
                         endcase
                      sele SERV_ADI
                      set order to NORDEM
                      *go top
                      go bottom
                      skip -10
                 *
                 endcase
              enddo
      *
      **************************** EXCLUSAO ****************************
      case MENUT = 4      
           @ 00, 78 say 'EX' 
           sele SERV_ADI
           do while .t.
              ULTKEY := 0
              INICIO_DBEDIT := .t.
              RODAPE(2)
              set color to n/bg
              @ 02, 01 to 22, 78
              dbedit(05,02,19,77,CAMPOS3,,FORMATOS3,TITULOS3)
              @ 02,01 clear to 22,78
              *
              do case
                 case lastkey() = TESC
                      exit
                 *
                 case lastkey() = TENTER
                      *0    *    1    *    2    *    3    *    4    *    5    *
                      *01234567890123456789012345678901234567890123456789012345
                      *  Codigo:         Nome Fantasia: X-------------X
                      *  Razao Social: X--------------------------------------X
                      *  ------------------------------------------------------
                      *  Validade..: XXX/99
                      *  Unidades..: 999
                      *  Referencia: X-----------------------------X
                      *  Valor.....: 9.999.999,99
                      *
                      VALID := SAD_VALID
                      UNID  := SAD_UNID
                      REFER := SAD_REFER
                      VALOR := SAD_VALOR
                      @ 05,02 say 'Codigo:         Nome Fantasia:'
                      @ 07,02 say 'Razao Social:'
                      @ 08,02 say repl('�', 54) 
                      @ 09,02 say 'Validade..:'
                      @ 11,02 say 'Unidades..:'
                      @ 13,02 say 'Referencia:'
                      @ 15,02 say 'Valor.....:'
                      @ 05,10 get SAD_CODIGO pict '@E 99,999'
                      @ 05,33 get SAD_FANTAS
                      @ 07,16 get SAD_NOME
                      *
                      @ 09,14 get VALID pict 'XXX/99'
                      @ 11,14 get UNID  pict '999' 
                      @ 13,14 get REFER  
                      @ 15,14 get VALOR pict '@E 9,999,999.99' 
                      clear gets
                      OK := 'S'
                      P2OKSN('Confirma Exclusao')
                      if OK = 'N'
                         loop
                         endif
                      *
                      * Exclui servico adicional
                      delete
                      commit
                 *
                 endcase
              enddo
      *
      endcase
   enddo
return
*
**************************  fim do programa  ***************************
