$PBExportHeader$w_ope710_plantilla_operaciones.srw
forward
global type w_ope710_plantilla_operaciones from w_rpt
end type
type sle_descrip from singlelineedit within w_ope710_plantilla_operaciones
end type
type pb_1 from picturebutton within w_ope710_plantilla_operaciones
end type
type st_2 from statictext within w_ope710_plantilla_operaciones
end type
type sle_codigo from singlelineedit within w_ope710_plantilla_operaciones
end type
type rb_rel from radiobutton within w_ope710_plantilla_operaciones
end type
type rb_val from radiobutton within w_ope710_plantilla_operaciones
end type
type dw_report from u_dw_rpt within w_ope710_plantilla_operaciones
end type
type cb_2 from commandbutton within w_ope710_plantilla_operaciones
end type
type gb_1 from groupbox within w_ope710_plantilla_operaciones
end type
end forward

global type w_ope710_plantilla_operaciones from w_rpt
integer width = 3579
integer height = 1812
string title = "Plantilla de Operaciones (OPE710)"
string menuname = "m_rpt_smpl"
long backcolor = 67108864
sle_descrip sle_descrip
pb_1 pb_1
st_2 st_2
sle_codigo sle_codigo
rb_rel rb_rel
rb_val rb_val
dw_report dw_report
cb_2 cb_2
gb_1 gb_1
end type
global w_ope710_plantilla_operaciones w_ope710_plantilla_operaciones

on w_ope710_plantilla_operaciones.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.sle_descrip=create sle_descrip
this.pb_1=create pb_1
this.st_2=create st_2
this.sle_codigo=create sle_codigo
this.rb_rel=create rb_rel
this.rb_val=create rb_val
this.dw_report=create dw_report
this.cb_2=create cb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_descrip
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_codigo
this.Control[iCurrent+5]=this.rb_rel
this.Control[iCurrent+6]=this.rb_val
this.Control[iCurrent+7]=this.dw_report
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.gb_1
end on

on w_ope710_plantilla_operaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_descrip)
destroy(this.pb_1)
destroy(this.st_2)
destroy(this.sle_codigo)
destroy(this.rb_rel)
destroy(this.rb_val)
destroy(this.dw_report)
destroy(this.cb_2)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;//dw_1.visible = false

idw_1 = dw_report
idw_1.SetTransObject(sqlca)
idw_1.ii_zoom_actual = 95
THIS.Event ue_preview()
//This.Event ue_retrieve()

// ii_help = 101           // help topic

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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event open;call super::open;//long ll_row
//
//dw_1.Settransobject(sqlca)
//dw_1.retrieve()
//
//ll_row = dw_1.insertrow(0)
end event

type sle_descrip from singlelineedit within w_ope710_plantilla_operaciones
integer x = 1769
integer y = 92
integer width = 1189
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_ope710_plantilla_operaciones
integer x = 1618
integer y = 84
integer width = 128
integer height = 104
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
IF rb_rel.checked = true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT OT_ADMINISTRACION.OT_ADM AS CODIGO,'&
									 +'OT_ADMINISTRACION.DESCRIPCION AS DESCRIPCION '&     	
		   						 +'FROM OT_ADMINISTRACION ' 
										
	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_descrip.text = lstr_seleccionar.param2[1]
	END IF												 
END IF 

IF rb_val.checked = true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = "SELECT PLANT_PROD.cod_plantilla AS PLANTILLA, "&
								  + "PLANT_PROD.desc_plantilla as DESCRIPCION, "&
								  + "PLANT_PROD.ot_adm as OT_ADM "&
								  + "FROM plant_prod "&
								  + "where flag_estado = '1'"

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_descrip.text = lstr_seleccionar.param2[1]
	END IF												 
END IF 

end event

type st_2 from statictext within w_ope710_plantilla_operaciones
integer x = 1042
integer y = 100
integer width = 210
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Código:"
boolean focusrectangle = false
end type

type sle_codigo from singlelineedit within w_ope710_plantilla_operaciones
integer x = 1257
integer y = 92
integer width = 343
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type rb_rel from radiobutton within w_ope710_plantilla_operaciones
integer x = 37
integer y = 128
integer width = 896
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Relación de plantillas x ot_adm"
end type

type rb_val from radiobutton within w_ope710_plantilla_operaciones
integer x = 41
integer y = 48
integer width = 663
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Plantilla valorizada"
end type

type dw_report from u_dw_rpt within w_ope710_plantilla_operaciones
integer x = 9
integer y = 244
integer width = 3470
integer height = 1212
integer taborder = 40
string dataobject = "d_rpt_plant_prod"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_2 from commandbutton within w_ope710_plantilla_operaciones
integer x = 3035
integer y = 76
integer width = 443
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_codigo, ls_texto

IF rb_val.checked=false AND rb_rel.checked=false then
	messagebox('Aviso','Seleccione opción de reporte')
	return
end if

ls_codigo = TRIM(sle_codigo.text)

IF ls_codigo='' then
	messagebox('Aviso','Defina código')
END IF

IF rb_val.checked=true then
	idw_1.DataObject='d_rpt_plant_valorizada_tbl'
	ls_texto = 'Plantilla ' + TRIM(ls_codigo)
ELSEIF rb_rel.checked=true then
	idw_1.DataObject='d_rpt_plant_prod'
	ls_texto = 	'OT Adm. ' + TRIM(ls_codigo)
	//ls_codigo = dw_1.object.campo[1]
END IF

idw_1.SetTransObject(sqlca)
idw_1.retrieve( ls_codigo )
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = ls_texto 
idw_1.Object.p_logo.filename = gs_logo
SetPointer(Arrow!)

ib_preview = false
idw_1.visible=true
idw_1.ii_zoom_actual = 100
parent.event ue_preview()

end event

type gb_1 from groupbox within w_ope710_plantilla_operaciones
integer x = 997
integer y = 40
integer width = 1993
integer height = 164
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetro"
end type

