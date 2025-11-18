$PBExportHeader$w_fl311_aprobar_parte.srw
forward
global type w_fl311_aprobar_parte from w_abc
end type
type dw_master from u_dw_abc within w_fl311_aprobar_parte
end type
type sle_nave from singlelineedit within w_fl311_aprobar_parte
end type
type st_1 from statictext within w_fl311_aprobar_parte
end type
type st_nomb_nave from statictext within w_fl311_aprobar_parte
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl311_aprobar_parte
end type
type pb_recuperar from u_pb_std within w_fl311_aprobar_parte
end type
type cbx_todo from checkbox within w_fl311_aprobar_parte
end type
end forward

global type w_fl311_aprobar_parte from w_abc
integer width = 2414
integer height = 1400
string title = "Aprobar Partes de Pesca (FL311)"
string menuname = "m_mto_smpl"
event ue_retrieve ( )
dw_master dw_master
sle_nave sle_nave
st_1 st_1
st_nomb_nave st_nomb_nave
uo_fecha uo_fecha
pb_recuperar pb_recuperar
cbx_todo cbx_todo
end type
global w_fl311_aprobar_parte w_fl311_aprobar_parte

type variables
uo_parte_pesca iuo_parte

end variables

event ue_retrieve();date ld_fecha1, ld_fecha2
string ls_cadena

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

if cbx_todo.checked then
	ls_cadena = '%%'
else
	ls_cadena = trim(sle_nave.text)
end if

dw_master.SetTransObject(SQLCA)
dw_master.Retrieve( ld_fecha1, ld_fecha2, ls_cadena )


end event

on w_fl311_aprobar_parte.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.dw_master=create dw_master
this.sle_nave=create sle_nave
this.st_1=create st_1
this.st_nomb_nave=create st_nomb_nave
this.uo_fecha=create uo_fecha
this.pb_recuperar=create pb_recuperar
this.cbx_todo=create cbx_todo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.sle_nave
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_nomb_nave
this.Control[iCurrent+5]=this.uo_fecha
this.Control[iCurrent+6]=this.pb_recuperar
this.Control[iCurrent+7]=this.cbx_todo
end on

on w_fl311_aprobar_parte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
destroy(this.sle_nave)
destroy(this.st_1)
destroy(this.st_nomb_nave)
destroy(this.uo_fecha)
destroy(this.pb_recuperar)
destroy(this.cbx_todo)
end on

event ue_open_pre;call super::ue_open_pre;date ld_fecha1, ld_fecha2
iuo_parte = CREATE uo_parte_pesca

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( month( today() ) + 1 ,'00' ) &
	+ '/' + string( year( today() ), '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

uo_fecha.of_set_fecha( ld_fecha1, ld_fecha2 )

this.MenuId.item[1].item[1].item[2].visible = false
this.MenuId.item[1].item[1].item[3].visible = false
this.MenuId.item[1].item[1].item[4].visible = false
this.MenuId.item[1].item[1].item[5].visible = false

this.MenuId.item[1].item[1].item[2].ToolbarItemvisible = false
this.MenuId.item[1].item[1].item[3].ToolbarItemvisible = false
this.MenuId.item[1].item[1].item[4].ToolbarItemvisible = false

end event

event close;call super::close;destroy iuo_parte
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
integer li_ok, li_ano1, li_ano2, li_i
string ls_mensaje


dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
END IF

li_ano1 = year(uo_fecha.of_get_fecha1())
li_ano2 = year(uo_fecha.of_get_fecha2())


//create or replace procedure USP_FL_ACUM_PESCA_REAL(
//		ani_ano			in number,
//    aso_mensaje out varchar2, 
//    aio_ok 			out number) is
	

DECLARE USP_FL_ACUM_PESCA_REAL PROCEDURE FOR
	USP_FL_ACUM_PESCA_REAL( :li_i );

for li_i = li_ano1 to li_ano2
	EXECUTE USP_FL_ACUM_PESCA_REAL;

	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "PROCEDURE USP_FL_ACUM_PESCA_REAL: " + SQLCA.SQLErrText
		Rollback ;
		MessageBox('SQL error', ls_mensaje, StopSign!)	
		return
	END IF
	
	FETCH USP_FL_ACUM_PESCA_REAL INTO :ls_mensaje, :li_ok;
	CLOSE USP_FL_ACUM_PESCA_REAL;
	
	if li_ok <> 1 then
		MessageBox('ERROR AL PROCESAR LA PESCA REAL', ls_mensaje, StopSign!)	
		return
	end if
next

MessageBox('INFORMACION', 'PARTES DE PESCA APROBADOS Y PROCESADOS CORRECTAMENTE', StopSign!)	

return
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from u_dw_abc within w_fl311_aprobar_parte
integer y = 340
integer width = 2350
integer height = 836
integer taborder = 50
string dataobject = "d_aprob_parte_grid"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, false)
this.SelectRow(currentrow, true)
this.SetRow(currentrow)
end event

event clicked;call super::clicked;string ls_flota, ls_aprobado, ls_data
string ls_reg_arribo, ls_reg_zarpe

if row <= 0 then
	return
end if

if lower(dwo.name) = "arribo_aprobado" then
	ls_flota 		= trim(this.object.tipo_flota[row])
	ls_reg_arribo	= trim(this.object.registro_arribo[row])
	
	if IsNull(ls_reg_arribo) then
		ls_reg_arribo = ''
	end if
	
	if ls_flota = 'P' and  ls_reg_arribo =''  then
		this.object.arribo_aprobado[row] = '0'
		MessageBox('ERROR', 'NO PUEDE APROBAR ESTE ARRIBO', StopSign!)
		return 1
	end if
	
	ls_aprobado = this.object.arribo_aprobado[row]
	if ls_aprobado = '1' then
		this.object.usr_aprob_datos[row] = gs_user	
	end if
	
elseif upper(dwo.name) = "ZARPE_APROBADO" then
	
	ls_flota 				= this.object.tipo_flota[row]
	
	if ls_flota = 'T' then
		this.object.zarpe_aprobado[row] = '0'
		MessageBox('ERROR', 'NO PUEDE APROBAR ESTE ZARPE', StopSign!)
		return 1
	end if
	
	ls_aprobado = this.object.arribo_aprobado[row]
	if ls_aprobado = '1' then
		this.object.usr_aprob_datos[row] = gs_user	
	end if
	
end if


end event

event itemchanged;call super::itemchanged;string ls_flota, ls_aprobado
string ls_reg_arribo, ls_reg_zarpe

if row <= 0 then
	return
end if

if lower(dwo.name) = "arribo_aprobado" then
	ls_flota 		= trim(this.object.tipo_flota[row])
	ls_reg_arribo	= trim(this.object.registro_arribo[row])
	
	if IsNull(ls_reg_arribo) then
		ls_reg_arribo = ''
	end if
	
	if ls_flota = 'P' and  ls_reg_arribo =''  then
		this.object.arribo_aprobado[row] = '0'
		MessageBox('ERROR', 'NO PUEDE APROBAR ESTE ARRIBO', StopSign!)
		return 2
	end if
	
	ls_aprobado = this.object.arribo_aprobado[row]
	if ls_aprobado = '1' then
		this.object.usr_aprob_datos[row] = gs_user	
	end if
	
elseif upper(dwo.name) = "ZARPE_APROBADO" then
	
	ls_flota 				= this.object.tipo_flota[row]
	
	if ls_flota = 'T' then
		this.object.zarpe_aprobado[row] = '0'
		MessageBox('ERROR', 'NO PUEDE APROBAR ESTE ZARPE', StopSign!)
		return 2
	end if
	
	ls_aprobado = this.object.arribo_aprobado[row]
	if ls_aprobado = '1' then
		this.object.usr_aprob_datos[row] = gs_user	
	end if
	
end if
end event

type sle_nave from singlelineedit within w_fl311_aprobar_parte
event ue_dblclick pbm_lbuttondblclk
event ue_desp_naves ( )
event ue_keydwn pbm_keydown
integer x = 507
integer y = 208
integer width = 293
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event ue_desp_naves()
end event

event ue_desp_naves();// Este evento despliega la pantalla w_seleccionar

string ls_codigo, ls_data, ls_sql
integer li_i
str_seleccionar lstr_seleccionar

ls_sql = "SELECT NAVE AS CODIGO_EMB, " &
		 + "NOMB_NAVE AS DESCRIPCION, " &
		 + "FLAG_TIPO_FLOTA AS TIPO_FLOTA " &
       + "FROM TG_NAVES " 
				 
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
	Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE NAVE", StopSign!)
	return
end if
		
st_nomb_nave.text = ls_data		
this.text	 		= ls_codigo
parent.event ue_retrieve()
end event

event ue_keydwn;if Key = KeyF2! then
	this.event ue_desp_naves()	
end if
end event

event modified;string ls_codigo, ls_data

ls_codigo = trim(this.text)

iuo_parte.of_get_nomb_nave( ls_codigo )
		
if ls_data = "" then
	Messagebox('Error', "CODIGO DE NAVE NO EXISTE", StopSign!)
	return
end if
		
st_nomb_nave.text = ls_data

parent.event ue_retrieve()
end event

type st_1 from statictext within w_fl311_aprobar_parte
integer x = 59
integer y = 220
integer width = 421
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

type st_nomb_nave from statictext within w_fl311_aprobar_parte
integer x = 818
integer y = 208
integer width = 951
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type uo_fecha from u_ingreso_rango_fechas within w_fl311_aprobar_parte
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

type pb_recuperar from u_pb_std within w_fl311_aprobar_parte
integer x = 1783
integer y = 36
integer width = 155
integer height = 132
integer textsize = -2
string text = "&r"
string picturename = "Retrieve!"
boolean map3dcolors = true
end type

event clicked;call super::clicked;parent.event ue_retrieve()
end event

type cbx_todo from checkbox within w_fl311_aprobar_parte
integer x = 1783
integer y = 216
integer width = 475
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Todas las naves"
boolean checked = true
end type

event clicked;if this.checked then
	sle_nave.enabled = false
else
	sle_nave.enabled = true
end if
end event

