$PBExportHeader$w_fl724_pago_mensual_cbssp.srw
forward
global type w_fl724_pago_mensual_cbssp from w_rpt
end type
type st_nomb_nave from statictext within w_fl724_pago_mensual_cbssp
end type
type st_1 from statictext within w_fl724_pago_mensual_cbssp
end type
type sle_nave from singlelineedit within w_fl724_pago_mensual_cbssp
end type
type cb_1 from commandbutton within w_fl724_pago_mensual_cbssp
end type
type em_ano from editmask within w_fl724_pago_mensual_cbssp
end type
type em_mes from editmask within w_fl724_pago_mensual_cbssp
end type
type st_3 from statictext within w_fl724_pago_mensual_cbssp
end type
type st_2 from statictext within w_fl724_pago_mensual_cbssp
end type
type dw_report from u_dw_rpt within w_fl724_pago_mensual_cbssp
end type
end forward

global type w_fl724_pago_mensual_cbssp from w_rpt
integer width = 2999
integer height = 3832
string title = "Beneficios Mensuales a la CBSSP (FL724)"
string menuname = "m_rpt"
long backcolor = 67108864
st_nomb_nave st_nomb_nave
st_1 st_1
sle_nave sle_nave
cb_1 cb_1
em_ano em_ano
em_mes em_mes
st_3 st_3
st_2 st_2
dw_report dw_report
end type
global w_fl724_pago_mensual_cbssp w_fl724_pago_mensual_cbssp

type variables
uo_parte_pesca iuo_parte
end variables

on w_fl724_pago_mensual_cbssp.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.st_nomb_nave=create st_nomb_nave
this.st_1=create st_1
this.sle_nave=create sle_nave
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_mes=create em_mes
this.st_3=create st_3
this.st_2=create st_2
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nomb_nave
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_nave
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.em_ano
this.Control[iCurrent+6]=this.em_mes
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.dw_report
end on

on w_fl724_pago_mensual_cbssp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_nomb_nave)
destroy(this.st_1)
destroy(this.sle_nave)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_report)
end on

event ue_retrieve;call super::ue_retrieve;integer 	li_mes, li_ano
string 	ls_mensaje, ls_nave

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)
ls_nave= sle_nave.text

SetPointer(HourGlass!)
//create or replace procedure USP_FL_PAGO_BENEF_CBSSP(
//       asi_nave   IN tg_naves.nave%TYPE,
//       ani_mes    IN semanas.mes%TYPE,
//       ani_year   IN semanas.ano%TYPE
//) IS

DECLARE USP_FL_PAGO_BENEF_CBSSP PROCEDURE FOR
	USP_FL_PAGO_BENEF_CBSSP( :ls_nave,
									 :li_mes, 
									 :li_ano );

EXECUTE USP_FL_PAGO_BENEF_CBSSP;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_PAGO_BENEF_CBSSP: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_FL_PAGO_BENEF_CBSSP;

idw_1.Retrieve(ls_nave, li_ano, li_mes)
idw_1.Visible = True

SetPointer(Arrow!)
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.object.Datawindow.Print.Orientation = 1

iuo_parte = create uo_parte_pesca

em_ano.text = string( year( Date(f_fecha_actual()) ) )
em_mes.text = string( month( Date(f_fecha_actual()) ) )

//idw_1.object.p_logo.filename 	= gs_logo
//idw_1.object.t_empresa.text 	= gs_empresa
//idw_1.object.t_usuario.text	= gs_user
//idw_1.object.t_objeto.text		= this.classname()
end event

event resize;call super::resize;this.SetRedraw(false)
dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
this.SetRedraw(true)
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type st_nomb_nave from statictext within w_fl724_pago_mensual_cbssp
integer x = 818
integer y = 164
integer width = 1125
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

type st_1 from statictext within w_fl724_pago_mensual_cbssp
integer x = 59
integer y = 176
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

type sle_nave from singlelineedit within w_fl724_pago_mensual_cbssp
event ue_dblclick pbm_lbuttondblclk
event ue_desp_naves ( )
event ue_keydwn pbm_keydown
integer x = 507
integer y = 164
integer width = 293
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event ue_desp_naves()
end event

event ue_desp_naves();// Este evento despliega la pantalla w_seleccionar

string ls_codigo, ls_data, ls_sql
integer li_i
str_seleccionar lstr_seleccionar

ls_sql = "SELECT NAVE AS CODIGO, " &
		 + "NOMB_NAVE AS DESCRIPCION, " &
		 + "FLAG_TIPO_FLOTA AS TIPO_FLOTA " &
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

If not IsValid(iuo_parte) then
	return
end if

ls_codigo = trim(this.text)

ls_data = iuo_parte.of_get_nomb_nave( ls_codigo )
		
if ls_data = "" then
	Messagebox('Error', "CODIGO DE NAVE NO EXISTE", StopSign!)
	this.text = ""
	st_nomb_nave.text = ""
	dw_report.reset()
	return
end if
		
if iuo_parte.of_get_tipo_flota( ls_codigo ) <> 'P' then
	Messagebox('Error', "SOLO SE IMPRIMIR ASISTENCIA EN EMBACARCIONES PROPIAS", StopSign!)
	this.text = ""
	st_nomb_nave.text = ""
	dw_report.reset()
	return
end if
st_nomb_nave.text = ls_data

parent.event dynamic ue_retrieve()
end event

type cb_1 from commandbutton within w_fl724_pago_mensual_cbssp
integer x = 1797
integer y = 28
integer width = 393
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve( )
end event

type em_ano from editmask within w_fl724_pago_mensual_cbssp
integer x = 338
integer y = 28
integer width = 375
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
end type

type em_mes from editmask within w_fl724_pago_mensual_cbssp
integer x = 1307
integer y = 28
integer width = 370
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
end type

event modified;dw_report.Reset()
end event

type st_3 from statictext within w_fl724_pago_mensual_cbssp
integer x = 137
integer y = 48
integer width = 165
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fl724_pago_mensual_cbssp
integer x = 928
integer y = 48
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_fl724_pago_mensual_cbssp
integer y = 268
integer width = 2482
integer height = 1412
integer taborder = 70
string dataobject = "d_rpt_pago_mensual_cbssp_cmp"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

