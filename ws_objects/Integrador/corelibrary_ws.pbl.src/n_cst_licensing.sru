$PBExportHeader$n_cst_licensing.sru
forward
global type n_cst_licensing from nonvisualobject
end type
end forward

global type n_cst_licensing from nonvisualobject
end type
global n_cst_licensing n_cst_licensing

type prototypes
FUNCTION boolean GetVolumeInformation(string lpRootPathName, ref string lpVolumeNameBuffer, ulong nVolumeNameSize, ref ulong lpVolumeSerialNumber, ref ulong lpMaximumComponentLength, ref ulong lpFileSystemFlags, ref string lpFileSystemNameBuffer, ulong nFileSystemNameSize) Library "KERNEL32.DLL" Alias for "GetVolumeInformationW" 
FUNCTION boolean GetUserNameA(ref string uname, ref ulong slength) LIBRARY "ADVAPI32.DLL" alias for "GetUserNameA;Ansi" 
FUNCTION boolean IsNetworkAlive(ref int flags) LIBRARY "sensapi.dll"
end prototypes

type variables
n_adapter 			invo_adapt
n_cst_osversion 	invo_osver
boolean				ib_internet_verificado = false
end variables

forward prototypes
public function boolean of_validar (string ls_empresa)
public function string of_obtener_pc ()
public function boolean of_valida_internet ()
public function string of_get_usuario ()
public function ws_strrespuesta of_validar_usuario (string ls_cod_usuario)
public function ws_strrespuesta of_validar_modulos_housing (str_empresas str_param)
public function ws_strrespuesta of_validar_modulo_empresa (string ls_cod_usuario, string ls_cod_modulo)
public function ws_strrespuesta of_validar_modulos_por_empresa (string as_empresa)
end prototypes

public function boolean of_validar (string ls_empresa);String 	ls_path, ls_label, ls_sysname, ls_PCName, ls_drive = "C"
ULong 	lul_size, lul_serial, lul_complen, lul_flags 

String 	ls_macaddress_[], ls_description[]
String 	ls_adaptername[], ls_ipaddress[]
Integer 	li_cnt, li_max, li_row

string 	ls_hex = "0123456789ABCDEF", ls_SerieHDD = "" 
long 		ll_i 

string 	ls_UserOS, ls_var, ls_ipLocal, ls_MacAddress, ls_SerieRED 
String 	ls_VersionOS, ls_edition, ls_csd, ls_pbvmname
ulong 	lu_val 
boolean 	lb_rtn 

SoapConnection 		ws_conexion;
long       				ll_estado_conexion;
ws_implSigreService	ws_servicio;
ws_StrRespuesta		ws_rpta


//Valido si tengo conexión a Internet
IF not of_valida_internet( ) THEN
	MessageBox("Error","No hay conexion a internet", Exclamation!)
	return false
END IF

invo_adapt.of_GetAdaptersInfo(ls_macaddress_, ls_description, ls_adaptername, ls_ipaddress)

li_max = UpperBound(ls_description)

//SERIE DISCO DURO
ls_path = ls_drive + ":\" 
lul_size = 50 
ls_label = Space(lul_size) 
ls_sysname = Space(lul_size) 
if not GetVolumeInformation(ls_path, ls_label, lul_size, lul_serial, lul_complen, lul_flags, ls_sysname, lul_size) then 
	MessageBox("Error", "No se ha podido obtener la Serie del Disco Duro", Exclamation!)
	return false
end if 

// Convert ulong value to a hexadecimal string 
for ll_i = 1 to 8 
	ls_SerieHDD = mid(ls_hex, Mod(lul_serial, 16) + 1, 1) + ls_SerieHDD 
	lul_serial = lul_serial / 16 
next 

//NOMBRE PC
ls_PCName = of_obtener_pc( )

//NOMBRE USUARIO
lu_val = 255 
ls_UserOS = Space( 255 ) 
lb_rtn = GetUserNameA(ls_UserOS, lu_val)

//SISTEMA OPERATIVO nuevo
// get Windows version information

invo_osver.of_GetOSVersion(ls_VersionOS, ls_edition, ls_csd)
ls_pbvmname = invo_osver.of_PBVMName()

// ********************** Ejecuta el WEBSERVICE **********************

//crea un objeto soap para conectar al servicio web
ws_conexion = create SoapConnection;

//configura un archivo de logs para ver errores de la conexion
ws_conexion.setOptions( 'SoapLog="c:\\soaplog.log"');

//realiza la conexion al servicio web
ll_estado_conexion = ws_conexion.createinstance( ws_servicio,"ws_implsigreservice");

//Verifica que la conexion se alla realizado con exito
if (ll_estado_conexion <> 0) then
	MessageBox("Error", "Error al contactar el servicio web.", Exclamation!, OK!,1);
end if

//recibe la informacion del webservice llamando a la funcion informacion_deudor con el parametroidentificacion_deudor
//ls_Empresa 		= 'CANTABRIA'
ls_ipLocal 		= ls_ipaddress[1]
ls_MacAddress 	= ls_macaddress_[1]
ls_SerieRED		= ls_adaptername[1]

ws_rpta = ws_servicio.validaracceso( ls_Empresa, ls_PCName, ls_ipLocal, '', ls_UserOS, ls_VersionOS, ls_MacAddress, ls_SerieRED, ls_SerieHDD)

if not ws_rpta.isOk then
	MessageBox('Error', 'Equipo no valido, Mensaje de error:' + ws_rpta.mensaje, Exclamation!)
	return false
else
	return true
end if
end function

public function string of_obtener_pc ();String gsComputerName ,ls_temp[] 
ContextKeyword lcxk_base 
GetContextService("Keyword", lcxk_base) 
lcxk_base.getContextKeywords("COMPUTERNAME", ls_temp) 
gsComputerName = ls_temp[1] 
return gsComputerName
end function

public function boolean of_valida_internet ();OleObject lole_Send
OleObject lole_SrvHTTP

String ls_status

if ib_internet_verificado then return true

gnvo_wait.of_mensaje("Validando conexión a internet ... ")
yield()

try
	
	lole_Send = CREATE OleObject
	lole_SrvHTTP = CREATE OleObject
	lole_Send.connectToNewObject("Msxml2.DOMDocument.6.0")
	lole_SrvHTTP.connectToNewObject("MSXML2.ServerXMLHTTP.6.0")
	lole_SrvHTTP.Open("GET", "https://www.google.com.pe/", FALSE)
	lole_SrvHTTP.SetRequestHeader( "Content-Type", "application/json")

	lole_SrvHTTP.Send(lole_Send)
	ls_status = string(lole_SrvHTTP.Status) //Status = 200 is OK!
	
	if ls_status="200" then
		ib_internet_verificado = true
		gnvo_wait.of_mensaje("Conexión a internet OK ... ")
		yield()
		return true
	else
		return false
	end if
	
	
CATCH ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepcion en función of_valida_internet(). Mensaje: ' + ex.getMessage(), StopSign!)
	return false
	
FINALLY
	if not IsNull(lole_Send) and IsValid(lole_Send) then
		lole_Send.DisconnectObject()
	end if

	if not IsNull(lole_SrvHTTP) and IsValid(lole_SrvHTTP) then
		lole_SrvHTTP.DisconnectObject()
	end if
	
	destroy lole_Send
	destroy lole_SrvHTTP
	
	//gnvo_wait.of_close()

END TRY




end function

public function string of_get_usuario ();//NOMBRE USUARIO
string ls_UserOS 
ulong lu_val 
boolean rtn 

lu_val = 255 
ls_UserOS = Space( 255 ) 
rtn = GetUserNameA(ls_UserOS, lu_val)
return ls_UserOS
end function

public function ws_strrespuesta of_validar_usuario (string ls_cod_usuario);SoapConnection 		conexion_ws;
long       				conexion_estatus, ll_num_emp, ll_j;
ws_implSigreService	servicio;
ws_StrRespuesta		rpta

IF not of_valida_internet( ) THEN
	MessageBox("Error","No hay conexion a internet", Exclamation!)
ELSE
	// ********************** Ejecuta el WEBSERVICE **********************
	gnvo_wait.of_mensaje("Conectando con el servidor ... ")
	
	//crea un objeto soap para conectar al servicio web
	conexion_ws = create SoapConnection;
	
	//configura un archivo de logs para ver errores de la conexion
	conexion_ws.setOptions( 'SoapLog="c:\\soaplog.log"');
	
	//realiza la conexion al servicio web
	conexion_estatus = conexion_ws.createinstance( servicio,"ws_implsigreservice");
	
	//Verifica que la conexion se alla realizado con exito
	if (conexion_estatus <> 0) then
		MessageBox("Error", "Error al contactar el servicio web.", Exclamation!, OK!,1);
	end if
	
	gnvo_wait.of_mensaje("Validando usuario " + ls_cod_usuario + " ... ")
	yield()
	rpta = servicio.ValidarUsrHousing(ls_cod_usuario)

END IF

return rpta
end function

public function ws_strrespuesta of_validar_modulos_housing (str_empresas str_param);SoapConnection		conexion_ws;
long 						conexion_estatus, ll_num_emp, j;
ws_implSigreService 	servicio;
ws_StrRespuesta		rpta

IF NOT of_valida_internet( ) THEN
	MessageBox("Error", "No hay conexion a internet", Exclamation!)
ELSE
	//***************************EJECUTA WEBSERVICE**************

	//creo objeto soap
	conexion_ws = create SoapConnection;
	
	//configura un archivo de logs para errores de 
	conexion_ws.setOptions('SoapLog="c:\\soaplog.log"');
	
	//realiza la conexion al servicio web
	conexion_estatus = conexion_ws.createinstance( servicio, "ws_implsigreservice");
	
	//verifica que la conexion se alla realizado con exito
	IF (conexion_estatus <> 0) THEN
		MessageBox("Error","Error al contactar el servicio web", Exclamation!, OK!,1)	;
	END IF
	
	rpta = servicio.validarModulosHousing(str_param.empresas)
	
	return rpta
END IF
end function

public function ws_strrespuesta of_validar_modulo_empresa (string ls_cod_usuario, string ls_cod_modulo);SoapConnection 		conexion_ws;
long						conexion_estatus, ll_num_emp,j;
ws_implSigreService	servicio;
ws_StrRespuesta		rpta;

IF NOT of_valida_internet() THEN
	MessageBox("Error","No hay conexion a internet",Exclamation!)
ELSE
	//****************************EJECUTA WEBSERVICE***************************
	
	//CREA OBJETO SOAP
	conexion_ws = create SoapConnection;
	
	//configura archivo log
	conexion_ws.setOptions('SoapLog="c:\\soaplog.log"');
	
	//realiza la conexion
	conexion_estatus = conexion_ws.createinstance( servicio, "ws_implsigreservice");
	
	//verifica que la conexion se realice
	IF (conexion_estatus <> 0) THEN
		MessageBox("Error","Error al contactar el servicio web",Exclamation!,OK!,1);
	END IF
	
	gnvo_wait.of_mensaje("Validando Modulo / Empresa ... ")
	yield()
	rpta = servicio.validarmoduloempresa( ls_cod_usuario, ls_cod_modulo);
	return rpta
	
END IF
	
	
end function

public function ws_strrespuesta of_validar_modulos_por_empresa (string as_empresa);SoapConnection		conexion_ws;
long 						conexion_estatus, ll_num_emp, j;
ws_implSigreService 	servicio;
ws_StrRespuesta		rpta

IF NOT of_valida_internet( ) THEN
	MessageBox("Error", "No hay conexion a internet", Exclamation!)
ELSE
	//***************************EJECUTA WEBSERVICE**************

	//creo objeto soap
	conexion_ws = create SoapConnection;
	
	//configura un archivo de logs para errores de 
	conexion_ws.setOptions('SoapLog="c:\\soaplog.log"');
	
	//realiza la conexion al servicio webstr_param
	conexion_estatus = conexion_ws.createinstance( servicio, "ws_implsigreservice");
	
	//verifica que la conexion se alla realizado con exito
	IF (conexion_estatus <> 0) THEN
		MessageBox("Error","Error al contactar el servicio web", Exclamation!, OK!,1)	;
	END IF
	
	rpta = servicio.validarModulosPorEmpresa(as_empresa)
	
	return rpta
END IF
end function

on n_cst_licensing.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_licensing.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

