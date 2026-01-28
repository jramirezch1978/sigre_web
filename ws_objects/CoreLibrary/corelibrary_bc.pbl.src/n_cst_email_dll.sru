$PBExportHeader$n_cst_email_dll.sru
forward
global type n_cst_email_dll from nonvisualobject
end type
end forward

global type n_cst_email_dll from nonvisualobject
end type
global n_cst_email_dll n_cst_email_dll

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
public function string of_format_address (str_email_address astr_addr)
public function string of_format_address_list (str_email_address astr_addrs[])
public function string of_get_version ()
public function string of_get_config ()
public function string of_send_email (str_email_address astr_from, str_email_address astr_to[], str_email_address astr_cc[], str_email_address astr_cco[], string as_subject, string as_body, boolean ab_html, string as_attachments)
public function string of_send_email (str_email_address astr_from, str_email_address astr_to[], str_email_address astr_cc[], string as_subject, string as_body, boolean ab_html, string as_attachments)
public function string of_send_email (str_email_address astr_from, str_email_address astr_to[], string as_subject, string as_body, boolean ab_html, string as_attachments)
public function string of_send_email (str_email_address astr_from, str_email_address astr_to[], string as_subject, string as_body, boolean ab_html)
public function string of_send_email (str_email_address astr_from, str_email_address astr_to[], string as_subject, string as_body)
end prototypes

public subroutine of_liberar_dll ();// ============================================================
// of_liberar_dll: Libera el DLL de memoria para permitir actualizaciones
// ============================================================
ulong lul_handle

lul_handle = GetModuleHandleW("SigreWebServiceWrapper.dll")

if lul_handle > 0 then
    FreeLibrary(lul_handle)
end if
end subroutine

public function string of_format_address (str_email_address astr_addr);// ============================================================
// of_format_address: Formatea una direccion como "email, nombre"
// ============================================================
string ls_result

if IsNull(astr_addr.email) or Trim(astr_addr.email) = "" then
    return ""
end if

ls_result = Trim(astr_addr.email)

if Not IsNull(astr_addr.nombre) and Trim(astr_addr.nombre) <> "" then
    ls_result += ", " + Trim(astr_addr.nombre)
end if

return ls_result
end function

public function string of_format_address_list (str_email_address astr_addrs[]);// ============================================================
// of_format_address_list: Formatea lista de direcciones
// Formato: "email1, nombre1; email2, nombre2;"
// ============================================================
string ls_result
integer li_idx, li_max
string ls_addr

ls_result = ""
li_max = UpperBound(astr_addrs)

for li_idx = 1 to li_max
    ls_addr = of_format_address(astr_addrs[li_idx])
    if ls_addr <> "" then
        ls_result += ls_addr + "; "
    end if
next

return ls_result
end function

public function string of_get_version ();return ObtenerVersion()
end function

public function string of_get_config ();// ============================================================
// of_get_config: Obtiene la configuracion actual del DLL
// ============================================================
return ObtenerConfiguracion()
end function

public function string of_send_email (str_email_address astr_from, str_email_address astr_to[], str_email_address astr_cc[], str_email_address astr_cco[], string as_subject, string as_body, boolean ab_html, string as_attachments);// ============================================================
// of_send_email: Envia correo electronico (version completa)
// 
// Argumentos:
//   astr_from       - Remitente (estructura con email y nombre)
//   astr_to[]       - Destinatarios (array de estructuras)
//   astr_cc[]       - CC (array de estructuras, puede estar vacio)
//   astr_cco[]      - CCO (array de estructuras, puede estar vacio)
//   as_subject      - Asunto del correo
//   as_body         - Cuerpo del mensaje
//   ab_html         - True si el cuerpo es HTML
//   as_attachments  - Rutas de adjuntos separadas por | (puede ser vacio)
//
// Retorna:
//   JSON con resultado: {"exitoso":true/false,"mensaje":"..."}
// ============================================================

string ls_from, ls_to, ls_cc, ls_cco
string ls_resultado
integer li_esHtml

// Formatear remitente
ls_from = of_format_address(astr_from)

// Formatear destinatarios
ls_to = of_format_address_list(astr_to)

// Formatear CC
ls_cc = of_format_address_list(astr_cc)

// Formatear CCO
ls_cco = of_format_address_list(astr_cco)

// Convertir boolean a int
if ab_html then
    li_esHtml = 1
else
    li_esHtml = 0
end if

// Validar que existan destinatarios
if Trim(ls_to) = "" then
    return '{"exitoso":false,"mensaje":"No se especificaron destinatarios"}'
end if

// Validar que exista remitente
if Trim(ls_from) = "" then
    return '{"exitoso":false,"mensaje":"No se especifico remitente"}'
end if

// Llamar al DLL
ls_resultado = EnviarEmail(ls_from, ls_to, ls_cc, ls_cco, as_subject, as_body, li_esHtml, as_attachments)

return ls_resultado
end function

public function string of_send_email (str_email_address astr_from, str_email_address astr_to[], str_email_address astr_cc[], string as_subject, string as_body, boolean ab_html, string as_attachments);// ============================================================
// of_send_email: Version con CC, sin CCO
// ============================================================

str_email_address lstr_empty[]

return of_send_email(astr_from, astr_to, astr_cc, lstr_empty, as_subject, as_body, ab_html, as_attachments)
end function

public function string of_send_email (str_email_address astr_from, str_email_address astr_to[], string as_subject, string as_body, boolean ab_html, string as_attachments);
// ============================================================
// of_send_email: Version sin CC ni CCO, con adjuntos
// ============================================================

str_email_address lstr_empty[]

return of_send_email(astr_from, astr_to, lstr_empty, lstr_empty, as_subject, as_body, ab_html, as_attachments)
end function

public function string of_send_email (str_email_address astr_from, str_email_address astr_to[], string as_subject, string as_body, boolean ab_html);
// ============================================================
// of_send_email: Version simple sin CC, CCO ni adjuntos
// ============================================================

str_email_address lstr_empty[]

return of_send_email(astr_from, astr_to, lstr_empty, lstr_empty, as_subject, as_body, ab_html, "")
end function

public function string of_send_email (str_email_address astr_from, str_email_address astr_to[], string as_subject, string as_body);// ============================================================
// of_send_email: Version minima (sin HTML)
// ============================================================

str_email_address lstr_empty[]

return of_send_email(astr_from, astr_to, lstr_empty, lstr_empty, as_subject, as_body, false, "")
end function

on n_cst_email_dll.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_email_dll.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

