 /*
 Comandos ? e ??
 */
REQUEST HB_LANG_PT 
REQUEST HB_CODEPAGE_PT850
 PROCEDURE Main
  HB_LangSelect('PT')
  HB_cdpSelect("PT850")
  
   ? "O aniversario de Claudia sera hoje as", "dez horas"
   ?"Claudia ganhou um avia o de presente"
   ? "O valor da compra foi de R$", "4 reais"
      
 RETURN