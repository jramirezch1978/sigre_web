$PBExportHeader$n_cst_usuario.sru
forward
global type n_cst_usuario from nonvisualobject
end type
end forward

global type n_cst_usuario from nonvisualobject
end type
global n_cst_usuario n_cst_usuario

type variables
public:

String  	is_flag_vobo1, is_flag_vobo2, is_cod_usr, is_origen, is_area, is_seccion, is_email, &
			is_nombre, is_flag_estado, is_origen_alt
Decimal	idc_monto_max1, idc_monto_max2
boolean	ib_aprobador_oc, ib_isOK = true
end variables

forward prototypes
public function boolean of_aprobador (string as_codusr)
public function boolean of_aprobar_oc (datawindow adw_datos, long al_row)
public subroutine clear ()
public function boolean of_fill_from_usuario (string as_user) throws exception
public function boolean of_get_clave (string as_clave)
end prototypes

public function boolean of_aprobador (string as_codusr);select nvl(flag_vobo1, '0'), nvl(flag_vobo2, '0'), nvl(monto_max_vobo1, 0), nvl(monto_max_vobo2, 0)
	into :is_flag_vobo1, :is_flag_vobo2, :idc_monto_max1, :idc_monto_max2
from aprobadores_oc
where cod_usr = :as_codusr;

if SQLCA.SQLCode = 100 then
	//En caso que no existe entonces no es aprobador, lo ponto como false 
	this.ib_aprobador_oc = false
	this.is_flag_vobo1 = '0'
	this.is_flag_vobo2 = '0'
	this.idc_monto_max1 = 0
	this.idc_monto_max2 = 0
	return false
end if


return true



end function

public function boolean of_aprobar_oc (datawindow adw_datos, long al_row);string ls_aprob1, ls_aprob2, ls_nom_aprob1, ls_nom_aprob2, ls_nom_user, ls_nro_oc, ls_mensaje

if al_row = 0 then return false

//ls_aprob1 = adw_datos.object.usuario_aprobador1 [al_row]
//ls_aprob2 = adw_datos.object.usuario_aprobador2 [al_row]
ls_nro_oc = adw_datos.object.nro_oc 				[al_row]

select nombre
	into :ls_nom_user
from usuario
where cod_usr = :gs_user;

update orden_compra oc
	set oc.aprobador 		= :gs_user,
		 oc.fecha_aprob 	= sysdate,
		 oc.flag_estado	= '1'
where nro_oc = :ls_nro_oc;
		
if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Ocurrio un error al momento de aprobar la Orden de Compra ' &
							+ ls_nro_oc + '. Mensaje: ' + ls_mensaje, StopSign!)
	return false
end if

commit;

adw_datos.Retrieve()

//adw_datos.object.aprobado_por 		[al_row] = ls_nom_user
//adw_datos.object.flag_aprobacion  	[al_row] = '0'


return true
end function

public subroutine clear ();is_flag_vobo1 = ''
is_flag_vobo2 = ''
is_cod_usr = ''
is_origen = ''
is_area = ''
is_seccion = ''
is_email = ''
is_nombre = ''
end subroutine

public function boolean of_fill_from_usuario (string as_user) throws exception;exception lnvo_ex

select u.cod_usr, u.nombre, u.email, u.flag_estado, u.origen_alt
	into :this.is_cod_usr, :this.is_nombre, :this.is_email, :this.is_flag_estado, :this.is_origen_alt
from usuario u
where u.cod_usr = :as_user;

if SQLCA.SQLCODE = 100 then
	lnvo_ex = create exception
	lnvo_ex.setMessage('Error al obtener datos del usuario ' + as_user + ', no se encuentra registrado en la tabla, por favor verifique!')
	this.ib_isok = false
	return false
end if

this.ib_isok = true
return true
end function

public function boolean of_get_clave (string as_clave);str_parametros lstr_param

openWithParm(w_clave_request, lstr_param)

if ISNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return false

lstr_param = Message.PowerObjectParm

if not lstr_param.b_return then return false

as_clave = lstr_param.s_clave

return true
end function

on n_cst_usuario.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_usuario.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

