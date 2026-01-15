$PBExportHeader$n_cst_api_sigre_dll.sru
forward
global type n_cst_api_sigre_dll from nonvisualobject
end type
end forward

global type n_cst_api_sigre_dll from nonvisualobject
end type
global n_cst_api_sigre_dll n_cst_api_sigre_dll

type prototypes
// ============================================================
// Windows API para liberar DLL
// ============================================================
FUNCTION ulong GetModuleHandleW(string lpModuleName) LIBRARY "kernel32.dll" ALIAS FOR "GetModuleHandleW"
FUNCTION boolean FreeLibrary(ulong hModule) LIBRARY "kernel32.dll" ALIAS FOR "FreeLibrary"

// ============================================================
// DLL C++ nativa - SigreWebServiceWrapper.dll
// ============================================================

// Obtener version del DLL
FUNCTION string ObtenerVersion() LIBRARY "SigreWebServiceWrapper.dll" ALIAS FOR "ObtenerVersion"

// Configurar credenciales para consulta RUC
FUNCTION string ConfigurarCredencialesRuc(string usuario, string clave, string empresa) &
    LIBRARY "SigreWebServiceWrapper.dll" ALIAS FOR "ConfigurarCredencialesRuc"

// Obtener token JWT
FUNCTION string ObtenerTokenRest(string usuario, string clave, string empresa) &
    LIBRARY "SigreWebServiceWrapper.dll" ALIAS FOR "ObtenerTokenRest"

// Consultar RUC (requiere token previo)
FUNCTION string ConsultarRuc(string ruc, string rucOrigen, string computerName) &
    LIBRARY "SigreWebServiceWrapper.dll" ALIAS FOR "ConsultarRuc"

// Envio de correo UNIFICADO
// Formatos:
//   remitente: "email, nombre" (ej: "sigre@npssac.com.pe, SIGRE ERP")
//   destinatarios: "email1, nombre1; email2, nombre2;" (separados por ;)
//   cc/cco: mismo formato que destinatarios (o vacio)
//   adjuntos: rutas separadas por | (ej: "C:\file1.pdf|C:\file2.xlsx")
FUNCTION string EnviarEmail(string remitente, string destinatarios, &
    string cc, string cco, string asunto, string mensaje, int esHtml, string adjuntos) &
    LIBRARY "SigreWebServiceWrapper.dll" ALIAS FOR "EnviarEmail"

// Obtener configuracion actual del DLL
FUNCTION string ObtenerConfiguracion() &
    LIBRARY "SigreWebServiceWrapper.dll" ALIAS FOR "ObtenerConfiguracion"

end prototypes

forward prototypes
public subroutine of_liberar_dll ()
end prototypes

// ============================================================
// of_liberar_dll: Libera el DLL de memoria para permitir actualizaciones
// Llamar antes de destroy si necesitas reemplazar el DLL
// ============================================================
public subroutine of_liberar_dll ();
ulong lul_handle

// Obtener handle del DLL
lul_handle = GetModuleHandleW("SigreWebServiceWrapper.dll")

// Si está cargado, liberarlo
if lul_handle > 0 then
    FreeLibrary(lul_handle)
end if
end subroutine

on n_cst_api_sigre_dll.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_api_sigre_dll.destroy
// NOTA: NO liberar el DLL automaticamente porque PowerBuilder
// mantiene una referencia interna. Si se libera, las siguientes
// instancias no podran usar el DLL.
// Use of_liberar_dll() manualmente solo cuando necesite
// actualizar el archivo DLL (antes de cerrar la aplicacion).
TriggerEvent( this, "destructor" )
call super::destroy
end on
