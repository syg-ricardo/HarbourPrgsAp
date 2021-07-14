/*
 * Harbour 3.2.0dev (r1405061532)
 * MinGW GNU C 4.6.1 (32-bit)
 * Generated C source from "ENV_BOLS.PRG"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( ENVIA_BOLS );
HB_FUNC_EXTERN( SCROLL );
HB_FUNC_EXTERN( SETPOS );
HB_FUNC_EXTERN( ALERT );


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_ENV_BOLS )
{ "ENVIA_BOLS", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( ENVIA_BOLS )}, NULL },
{ "SCROLL", {HB_FS_PUBLIC}, {HB_FUNCNAME( SCROLL )}, NULL },
{ "SETPOS", {HB_FS_PUBLIC}, {HB_FUNCNAME( SETPOS )}, NULL },
{ "ALERT", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALERT )}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_ENV_BOLS, "ENV_BOLS.PRG", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_ENV_BOLS
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_ENV_BOLS )
   #include "hbiniseg.h"
#endif

HB_FUNC( ENVIA_BOLS )
{
	static const HB_BYTE pcode[] =
	{
		36,14,0,176,1,0,20,0,176,2,0,121,121,20,
		2,36,18,0,176,3,0,106,47,82,111,116,105,110,
		97,32,112,97,114,97,32,101,110,118,105,97,114,32,
		98,111,108,101,116,111,115,46,32,69,109,32,100,101,
		115,101,110,118,111,108,118,105,109,101,110,116,111,0,
		20,1,36,20,0,7
	};

	hb_vmExecute( pcode, symbols );
}

