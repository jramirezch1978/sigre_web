$PBExportHeader$w_fl905_asig_plan_oper.srw
forward
global type w_fl905_asig_plan_oper from w_abc
end type
type st_opersec from statictext within w_fl905_asig_plan_oper
end type
type st_3 from statictext within w_fl905_asig_plan_oper
end type
type sle_opersec from singlelineedit within w_fl905_asig_plan_oper
end type
type st_ot from statictext within w_fl905_asig_plan_oper
end type
type sle_ot from singlelineedit within w_fl905_asig_plan_oper
end type
type st_2 from statictext within w_fl905_asig_plan_oper
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl905_asig_plan_oper
end type
type sle_nave from singlelineedit within w_fl905_asig_plan_oper
end type
type st_1 from statictext within w_fl905_asig_plan_oper
end type
type st_nomb_nave from statictext within w_fl905_asig_plan_oper
end type
type cb_2 from commandbutton within w_fl905_asig_plan_oper
end type
type cb_1 from commandbutton within w_fl905_asig_plan_oper
end type
end forward

global type w_fl905_asig_plan_oper from w_abc
integer width = 1883
integer height = 1044
string title = "Transferencia a Planillas Externas (FL904)"
string menuname = "m_smpl"
boolean maxbox = false
boolean resizable = false
boolean center = true
event ue_aceptar ( )
event ue_cancelar ( )
st_opersec st_opersec
st_3 st_3
sle_opersec sle_opersec
st_ot st_ot
sle_ot sle_ot
st_2 st_2
uo_fecha uo_fecha
sle_nave sle_nave
st_1 st_1
st_nomb_nave st_nomb_nave
cb_2 cb_2
cb_1 cb_1
end type
global w_fl905_asig_plan_oper w_fl905_asig_plan_oper

type variables
string is_cencos
end variables

event ue_aceptar();string	ls_nave, ls_opersec, ls_mensaje
date 		ld_finicio, ld_ffin
integer 	li_ok

ls_nave = sle_nave.text
ls_opersec = sle_opersec.text
ld_finicio = uo_fecha.of_get_fecha1()
ld_ffin = uo_fecha.of_get_fecha2()

//create or replace procedure usp_fl_asig_plla_oper(
//		adi_finicio 	in date, 
//    adi_ffin 			in date, 
//    asi_nave 			in tg_naves.nave%TYPE, 
//    asi_opersec 	in operaciones.oper_sec%TYPE,
//  	aso_mensaje 	out varchar2,
//    aio_ok      	out number) is
	 
DECLARE usp_fl_asig_plla_oper PROCEDURE FOR
	usp_fl_asig_plla_oper( :ld_finicio, :ld_ffin, 
		:ls_nave, :ls_opersec );

EXECUTE usp_fl_asig_plla_oper;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_fl_asig_plla_oper: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

FETCH usp_fl_asig_plla_oper INTO :ls_mensaje, :li_ok;
CLOSE usp_fl_asig_plla_oper;

if li_ok <> 1 then
	MessageBox('ERROR usp_fl_asig_plla_oper', ls_mensaje, StopSign!)	
else
	MessageBox('AVISO', 'Asignación de Planillas a Operaciones realizado Satisfactoriamente', Information!)
end if


end event

event ue_cancelar();close(this)
end event

on w_fl905_asig_plan_oper.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.st_opersec=create st_opersec
this.st_3=create st_3
this.sle_opersec=create sle_opersec
this.st_ot=create st_ot
this.sle_ot=create sle_ot
this.st_2=create st_2
this.uo_fecha=create uo_fecha
this.sle_nave=create sle_nave
this.st_1=create st_1
this.st_nomb_nave=create st_nomb_nave
this.cb_2=create cb_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_opersec
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.sle_opersec
this.Control[iCurrent+4]=this.st_ot
this.Control[iCurrent+5]=this.sle_ot
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.uo_fecha
this.Control[iCurrent+8]=this.sle_nave
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_nomb_nave
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.cb_1
end on

on w_fl905_asig_plan_oper.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_opersec)
destroy(this.st_3)
destroy(this.sle_opersec)
destroy(this.st_ot)
destroy(this.sle_ot)
destroy(this.st_2)
destroy(this.uo_fecha)
destroy(this.sle_nave)
destroy(this.st_1)
destroy(this.st_nomb_nave)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;date ld_fecha1, ld_fecha2

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( month( today() ) + 1 ,'00' ) &
	+ '/' + string( year( today() ), '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

uo_fecha.of_set_fecha( ld_fecha1, ld_fecha2 )
end event

type st_opersec from statictext within w_fl905_asig_plan_oper
integer x = 937
integer y = 456
integer width = 905
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_3 from statictext within w_fl905_asig_plan_oper
integer x = 37
integer y = 468
integer width = 517
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Operacion"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_opersec from singlelineedit within w_fl905_asig_plan_oper
event ue_dblclick pbm_lbuttondblclk
event ue_display ( )
event ue_keydwn pbm_keydown
integer x = 581
integer y = 456
integer width = 343
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event ue_display()
end event

event ue_display();// Este evento despliega la pantalla w_seleccionar

string ls_codigo, ls_data, ls_sql, ls_orden
integer li_i
str_seleccionar lstr_seleccionar

ls_orden = sle_ot.text

if IsNull(ls_orden) or trim(ls_orden) = '' then
	MessageBox('ERROR', 'ESTA VACIO LA ORDEN DE TRABAJO ', StopSign!)
	return
end if

ls_sql = "SELECT OPER_SEC AS CODIGO, " &
		 + "DESC_OPERACION AS DESCRIPCION " &
       + "FROM OPERACIONES " &
		 + "WHERE NRO_ORDEN = '" + ls_orden + "'"
				 
lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S'

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	

IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_codigo = lstr_seleccionar.param1[1]
	ls_data   = lstr_seleccionar.param2[1]
ELSE		
	Messagebox('Error', "DEBE SELECCIONAR UNA OPERACION", StopSign!)
	return
end if
		
st_opersec.text 	= ls_data		
this.text	 		= ls_codigo

end event

event ue_keydwn;if Key = KeyF2! then
	this.event ue_display()	
end if
end event

event modified;string ls_codigo, ls_data
integer li_count

ls_codigo = trim(this.text)

select count(*)
	into :li_count
from operaciones
where oper_sec = :ls_codigo;

if li_count = 0 then
	this.Text 			= ''
	st_nomb_nave.Text = ''
	MessageBox('ERROR', 'CODIGO DE OPERACION NO EXISTE', StopSign!)
	RETURN
end if

select desc_operacion
	into :ls_data
from operaciones
where oper_sec = :ls_codigo;

st_opersec.text = ls_data


end event

type st_ot from statictext within w_fl905_asig_plan_oper
integer x = 937
integer y = 332
integer width = 905
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type sle_ot from singlelineedit within w_fl905_asig_plan_oper
event ue_dblclick pbm_lbuttondblclk
event ue_display ( )
event ue_keydwn pbm_keydown
integer x = 581
integer y = 332
integer width = 343
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event ue_display()
end event

event ue_display();// Este evento despliega la pantalla w_seleccionar

string ls_codigo, ls_data, ls_sql, ls_cencos, ls_nave
integer li_i
str_seleccionar lstr_seleccionar

ls_cencos = parent.is_cencos

if IsNull(ls_cencos) or ls_cencos = '' then
	MessageBox('ERROR', 'CODIGO DE CENTRO DE COSTO ESTA EN BLANCO', StopSign!)
	return
end if

ls_nave = trim(sle_nave.text)

if IsNull(ls_cencos) or ls_cencos = '' then
	MessageBox('ERROR', 'CODIGO DE NAVE ESTA EN BLANCO', StopSign!)
	return
end if


ls_sql = "SELECT NRO_ORDEN AS CODIGO, " &
		 + "DESCRIPCION AS DESCR_ORDEN " &
       + "FROM VW_FL_OT_NAVE " &
		 + "WHERE NAVE = '" + ls_nave + "'"
				 
lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S'

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	

IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_codigo = lstr_seleccionar.param1[1]
	ls_data   = lstr_seleccionar.param2[1]
ELSE		
	Messagebox('Error', "DEBE SELECCIONAR UNA ORDEN DE TRABAJO", StopSign!)
	return
end if
		
st_ot.text 	= ls_data		
this.text	= ls_codigo

end event

event ue_keydwn;if Key = KeyF2! then
	this.event ue_display()	
end if
end event

event modified;string ls_codigo, ls_data, ls_estado, ls_cencos
integer li_count

ls_cencos = parent.is_cencos

If IsNull(ls_cencos) or ls_cencos = '' then
	MessageBox('ERROR', 'CODIGO DE CENTRO DE COSTO ESTA EN BLANCO' , StopSign!)
	return
end if

ls_codigo = trim(this.text)

select count(*)
	into :li_count
from orden_trabajo
where nro_orden = :ls_codigo;

if li_count = 0 then
	this.Text 			= ''
	st_ot.Text = ''
	MessageBox('ERROR', 'ORDEN DE TRABAJO NO EXISTE', StopSign!)
	RETURN
end if

select descripcion, flag_estado
	into :ls_data, :ls_estado
from orden_trabajo
where nro_orden = :ls_codigo;

st_ot.text = ls_data


end event

type st_2 from statictext within w_fl905_asig_plan_oper
integer x = 37
integer y = 344
integer width = 517
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Trabajo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_rango_fechas within w_fl905_asig_plan_oper
event destroy ( )
integer x = 73
integer y = 68
integer taborder = 30
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type sle_nave from singlelineedit within w_fl905_asig_plan_oper
event ue_dblclick pbm_lbuttondblclk
event ue_display ( )
event ue_keydwn pbm_keydown
integer x = 581
integer y = 192
integer width = 343
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event ue_display()
end event

event ue_display();// Este evento despliega la pantalla w_seleccionar

string ls_codigo, ls_data, ls_sql, ls_cencos
integer li_i
str_seleccionar lstr_seleccionar

ls_sql = "SELECT NAVE AS CODIGO, " &
		 + "NOMB_NAVE AS DESCRIPCION, " &
		 + "FLAG_TIPO_FLOTA AS TIPO_FLOTA, " &
		 + "CENCOS AS CENCOS " &
       + "FROM TG_NAVES " &
		 + "WHERE FLAG_TIPO_FLOTA = 'P'"
				 
lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S'

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	

IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_codigo = lstr_seleccionar.param1[1]
	ls_data   = lstr_seleccionar.param2[1]
	ls_cencos = lstr_seleccionar.param4[1]
ELSE		
	Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE NAVE", StopSign!)
	return
end if
		
st_nomb_nave.text = ls_data		
this.text	 		= ls_codigo
parent.is_cencos 	= ls_cencos

end event

event ue_keydwn;if Key = KeyF2! then
	this.event ue_display()	
end if
end event

event modified;string ls_codigo, ls_data, ls_tflota, ls_cencos
integer li_count

ls_codigo = trim(this.text)

select count(*)
	into :li_count
from tg_naves
where nave = :ls_codigo;

if li_count = 0 then
	this.Text 			= ''
	st_nomb_nave.Text = ''
	MessageBox('ERROR', 'CODIGO DE NAVE NO EXISTE', StopSign!)
	RETURN
end if

select nomb_nave, flag_tipo_flota, cencos
	into :ls_data, :ls_tflota, :ls_cencos
from tg_naves
where nave = :ls_codigo;

if ls_codigo <> 'P' then
	this.Text 			= ''
	st_nomb_nave.Text = ''
	MessageBox('ERROR', 'LA NAVE DEBE SER PROPIA', StopSign!)
	RETURN
end if

if IsNull(ls_cencos) or ls_cencos = '' then
	this.Text 			= ''
	st_nomb_nave.Text = ''
	MessageBox('ERROR', 'LA EMBARCACIÓN NO TIENE UN CENTRO DE COSTO ASIGNADO', StopSign!)
	RETURN
end if

st_nomb_nave.text = ls_data
parent.is_cencos 	= ls_cencos

end event

type st_1 from statictext within w_fl905_asig_plan_oper
integer x = 37
integer y = 204
integer width = 517
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Codigo de Nave:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_nomb_nave from statictext within w_fl905_asig_plan_oper
integer x = 937
integer y = 192
integer width = 905
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_fl905_asig_plan_oper
integer x = 1477
integer y = 692
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Salir"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()
end event

type cb_1 from commandbutton within w_fl905_asig_plan_oper
integer x = 1097
integer y = 692
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aplicar"
end type

event clicked;parent.event ue_aceptar()
end event

