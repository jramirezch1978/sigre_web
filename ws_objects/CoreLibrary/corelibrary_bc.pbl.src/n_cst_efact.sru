$PBExportHeader$n_cst_efact.sru
forward
global type n_cst_efact from nonvisualobject
end type
end forward

global type n_cst_efact from nonvisualobject
end type
global n_cst_efact n_cst_efact

type variables
Integer	ii_default_max_anulados, ii_nro_dias_anulacion, ii_seed_clave
String	is_request_clave_anular, is_clave_anular_ce, is_anular_only_dia, is_clave_dinamica, &
			is_letra_inicial_clave


end variables

forward prototypes
public function boolean of_load ()
public function boolean of_validar_anulados (string as_usuario, date ad_fecha)
public function boolean of_validar_clave ()
public function string of_generar_clave ()
public function string of_get_nro_doc (string as_serie, string as_nro)
end prototypes

public function boolean of_load ();String 	ls_mensaje

try 
	
	//MAXIMO NUMERO DE ANULADOS
	ii_default_max_anulados = gnvo_app.of_get_parametro("EFACT_DEFAULT_MAX_ANULADOS", 5)
	
	//MAXIMO NRO DE DIAS PARA ANULAR
	ii_nro_dias_anulacion = gnvo_app.of_get_parametro("EFACT_MAX_NRO_DIAS_ANULACION", 7)
	
	//REQUEST
	is_request_clave_anular = gnvo_app.of_get_parametro("EFACT_REQUEST_CLAVE_ANULAR", "0")
	
	//CLAVE PARA ANULAR COMPROBANTES
	is_clave_anular_ce = gnvo_app.of_get_parametro("EFACT_CLAVE_ANULAR_CE", "123456")
	
	//Solo permite anular un solo día
	is_anular_only_dia = gnvo_app.of_get_parametro("EFACT_SOLO_ANULAR_DIARIO", "0")
	
	//Si es con clave fija o dinamica
	is_clave_dinamica = gnvo_app.of_get_parametro("EFACT_CLAVE_DINAMICA", "1")
	
	//Letra Inicial de la clave
	is_letra_inicial_clave = gnvo_app.of_get_parametro("EFACT_LETRA_INICIAL_CLAVE", "A")
	
	//NUMERO SEED PARA LA GENERACIÓN DE LA CLAVE DINAMICA
	ii_seed_clave = gnvo_app.of_get_parametro("EFACT_SEED_CLAVE", 40)
	
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepción en la función OF_LOAD del objeto ' + this.classname() &
							+ '.~r~nMensaje de error: ' + ex.getMessage() + '.' &
							+ '~r~nPor favor verifique!', StopSign!)
finally
	/*statementBlock*/
end try

return true
end function

public function boolean of_validar_anulados (string as_usuario, date ad_fecha);Integer 	li_count

//Obtengo el nro de anulados que tiene hasta ahora
select count(*)
  into :li_count
from fs_factura_smpl fs
where trunc(fs_fec_registro) = trunc(:ad_fecha)
  and cod_usr					  = :as_usuario;

if li_count >= ii_default_max_anulados then
	MessageBox('Error', 'El usuario ' + as_usuario + ' ha alcanzado el numero maximo de anulaciones diarias de ' &
			+ string(ii_default_max_anulados) + '.', StopSign!)
	return false
end if
  

return true
end function

public function boolean of_validar_clave ();str_parametros lstr_param
string			ls_clave, ls_clave_org

openWithParm(w_clave_request, lstr_param)

if ISNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return false

lstr_param = Message.PowerObjectParm

if not lstr_param.b_return then return false

ls_clave = lstr_param.s_clave

if this.is_clave_dinamica = '1' then
	ls_clave_org = this.dynamic of_generar_clave()
else
	ls_clave_org = this.is_clave_anular_ce
end if

if ls_clave <> ls_clave_org then
	MessageBox('Error', 'La clave ingresada no es correcta. Por favor consulte con su administrador', StopSign!)
	return false
end if

return true
end function

public function string of_generar_clave ();String 	ls_clave, ls_hora, ls_dia
DateTime	ldt_hoy
Integer	li_seed

ldt_hoy = gnvo_app.of_fecha_Actual()

ls_dia = string(Date(ldt_hoy), 'dd')
ls_hora = string(Time(ldt_hoy), 'hh')

li_seed = Integer(ls_hora) + Integer(ls_dia) + ii_seed_clave

ls_clave = is_letra_inicial_clave + left(string(li_seed),1) + '0' + '0' + right(string(li_seed),1)

return ls_clave
end function

public function string of_get_nro_doc (string as_serie, string as_nro);string  ls_mensaje, ls_return
integer li_ok

//pkg_fact_electronica.of_get_nro_doc(as_serie => :as_serie,
//                                    as_nro_doc => :as_nro_doc);
//
DECLARE usp_get_nro_doc PROCEDURE FOR
	pkg_fact_electronica.of_get_nro_doc(:as_serie,
                                       :as_nro);

EXECUTE usp_get_nro_doc;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_get_nro_doc:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return gnvo_app.is_null
END IF

FETCH usp_get_nro_doc INTO :ls_return;

CLOSE usp_get_nro_doc;

return ls_return
end function

on n_cst_efact.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_efact.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

