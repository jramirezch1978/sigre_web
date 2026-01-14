$PBExportHeader$n_cst_api_sigre_dll.sru
$PBExportComments$Funciones API para SigreWebServiceWrapper DLL
forward
global type n_cst_api_sigre_dll from nonvisualobject
end type
end forward

global type n_cst_api_sigre_dll from nonvisualobject
end type
global n_cst_api_sigre_dll n_cst_api_sigre_dll

type prototypes

// === CONSULTA RUC ===
FUNCTION string ConfigurarCredencialesRuc(string usuario, string clave, &
    string empresa) LIBRARY "SigreWebServiceWrapper.dll"

FUNCTION string ConsultarRuc(string ruc, string rucOrigen, &
    string computerName) LIBRARY "SigreWebServiceWrapper.dll"


// === ENVIO DE CORREO ===
FUNCTION string EnviarCorreo(string destinatarios, string nombres, &
    string asunto, string mensaje, boolean esHtml, string adjuntos) &
    LIBRARY "SigreWebServiceWrapper.dll"

FUNCTION string EnviarCorreoAvanzado(string destinatarios, string nombres, &
    string cc, string cco, string asunto, string mensaje, boolean esHtml, &
    string adjuntos) LIBRARY "SigreWebServiceWrapper.dll"


// === UTILIDADES (opcional) ===
FUNCTION string ObtenerVersion() LIBRARY "SigreWebServiceWrapper.dll"

end prototypes

on n_cst_api_sigre_dll.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_api_sigre_dll.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

