$PBExportHeader$w_lista_sesiones.srw
forward
global type w_lista_sesiones from w_abc
end type
type st_1 from statictext within w_lista_sesiones
end type
type dw_lista from u_dw_abc within w_lista_sesiones
end type
type pb_cancelar from picturebutton within w_lista_sesiones
end type
type pb_aceptar from picturebutton within w_lista_sesiones
end type
end forward

global type w_lista_sesiones from w_abc
integer width = 1929
integer height = 1484
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 16777215
st_1 st_1
dw_lista dw_lista
pb_cancelar pb_cancelar
pb_aceptar pb_aceptar
end type
global w_lista_sesiones w_lista_sesiones

type variables
n_cst_regkey		invo_regkey
n_cst_seguridad	invo_seguridad
n_cst_encriptor	invo_encriptor
String				is_flag_cambio_clv, is_flag_login
Integer				ii_dias_cambio, ii_flag_login
end variables

forward prototypes
public function long of_param ()
end prototypes

public function long of_param ();String	ls_mensaje


SELECT NVL(FLAG_LOGIN,'0'), NVL(FLAG_CAMBIO_FORZOSO,'0'), NVL(DIAS_CAMBIO,0)
  INTO :is_flag_login, :is_flag_cambio_clv, :ii_dias_cambio
  FROM LOGINPARAM  
 WHERE RECKEY = '1' ;	
	
IF SQLCA.SQLCODE = 100 THEN
	MessageBox("Error", 'No se ha especificado parametros en LOGINPARAM', StopSign!)
	return -1
end if

IF SQLCA.SQLCODE < 0 THEN
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox("Error", 'No se pudo leer LOGINPARAM, Mensaje: ' + ls_mensaje, StopSign!)
	return -1
end if

ii_flag_login = Integer(is_flag_login)


RETURN 0



end function

on w_lista_sesiones.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_lista=create dw_lista
this.pb_cancelar=create pb_cancelar
this.pb_aceptar=create pb_aceptar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_lista
this.Control[iCurrent+3]=this.pb_cancelar
this.Control[iCurrent+4]=this.pb_aceptar
end on

on w_lista_sesiones.destroy
call super::destroy
destroy(this.st_1)
destroy(this.dw_lista)
destroy(this.pb_cancelar)
destroy(this.pb_aceptar)
end on

event ue_open_pre;call super::ue_open_pre;if this.of_param() = -1 then
	post event close()
	return
end if

this.event ue_refresh()
end event

event ue_refresh;call super::ue_refresh;str_parametros		lstr_param
str_array			lstr_array
str_sesion			lstr_sesiones[]
Integer				li_i, ll_row

try 
	
	//Borro el listado de sesiones activas
	dw_lista.Reset()
	
	if not invo_regkey.of_existen_sesiones(gs_empresa) then
		MessageBox('Error', 'No existen sesiones abiertas, por favor verifique!', StopSign!)
		lstr_param.b_return = false
		post CloseWithReturn(this, lstr_param)
		return
	end if
	
	lstr_Array = invo_regkey.of_get_sesiones(gs_empresa)
	
	if not lstr_array.b_Return then
		return
	end if
	
	lstr_sesiones = lstr_array.session_array
	
	
	for li_i = 1 to UpperBound(lstr_sesiones) 
		ll_row = dw_lista.event ue_insert()
		if ll_row > 0 then
			dw_lista.object.fecha		[ll_row] = lstr_sesiones[li_i].fecha
			dw_lista.object.codigo		[ll_row] = lstr_sesiones[li_i].codigo
			dw_lista.object.nombre		[ll_row] = lstr_sesiones[li_i].nombre
			dw_lista.object.clave		[ll_row] = lstr_sesiones[li_i].clave
			dw_lista.object.id_sesion	[ll_row] = lstr_sesiones[li_i].id_sesion
		end if
	next
	

catch ( Exception ex )
	gnvo_App.of_catch_exception(ex, 'Error al abrir Listado de sesiones activas')
end try
end event

event ue_cancelar;call super::ue_cancelar;str_parametros lstr_param

lstr_param.b_Return = false

closeWithReturn(this, lstr_param)
end event

event ue_aceptar;call super::ue_aceptar;str_parametros	lstr_param
String 			ls_user, ls_clave
Long				ll_row, ll_return

ll_row = dw_lista.getRow()

if ll_row = 0 then
	MessageBox('Error', 'Debe Elegir una sesión activa, por favor verifique!', StopSign!)
	return
end if

ls_user 	= dw_lista.object.codigo	[ll_row]
ls_clave	= dw_lista.object.clave		[ll_row]

ls_clave = invo_encriptor.of_desencriptarJR(ls_clave)

//Asigno los datos
invo_Seguridad.invo_app 	= gnvo_app
invo_seguridad.iw_parent 	= this

ll_return = invo_seguridad.of_validar_credenciales(ls_user, ls_Clave)

IF ll_return < 0 THEN
	return
END IF

//Si es necesario el cambio de la contraseña
IF invo_seguridad.ii_desde_ult_cambio >= 0 THEN
	IF is_flag_cambio_clv = '1' AND ii_dias_cambio <= invo_seguridad.ii_desde_ult_cambio THEN 
		Open(w_password_chg, THIS)
	END IF
END IF

// Salida
lstr_param.b_Return = true
CloseWithReturn(this, lstr_param)
end event

type st_1 from statictext within w_lista_sesiones
integer width = 1911
integer height = 100
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "LISTA DE SESIONES ACTIVAS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_lista from u_dw_abc within w_lista_sesiones
integer y = 112
integer width = 1911
integer height = 1144
string dataobject = "d_lista_sesiones_tbl"
boolean hscrollbar = false
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event buttonclicked;call super::buttonclicked;String ls_id_sesion, ls_nombre, ls_codigo

try 
	this.Accepttext()
	
	if row = 0 then return
	
	CHOOSE CASE lower(dwo.name)
		CASE 'b_delete'
			
			ls_id_Sesion 	= this.object.id_Sesion [row]
			ls_codigo		= this.object.codigo		[row]
			ls_nombre		= this.object.nombre		[row]
			
			if MessageBox('Aviso', '¿Desea eliminar la sesión del usuario ' + ls_codigo + ' - ' + ls_nombre + '?', &
				Information!, YesNo!, 2) = 2 then return
			
			invo_regkey.of_delete_sesion(gs_empresa, ls_id_sesion)
			
			parent.event ue_refresh()
		
	
	END CHOOSE

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, 'Ha ocurrido una exception al eliminar la sesion')
	
end try


end event

event doubleclicked;call super::doubleclicked;if row > 0 then
	parent.event ue_aceptar()
end if
end event

type pb_cancelar from picturebutton within w_lista_sesiones
integer x = 997
integer y = 1268
integer width = 325
integer height = 188
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "c:\sigre\resources\Bmp\Salir.bmp"
alignment htextalign = right!
end type

event clicked;parent.event dynamic ue_cancelar()
end event

type pb_aceptar from picturebutton within w_lista_sesiones
integer x = 663
integer y = 1268
integer width = 325
integer height = 188
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = right!
end type

event clicked;parent.event ue_Aceptar()
end event

