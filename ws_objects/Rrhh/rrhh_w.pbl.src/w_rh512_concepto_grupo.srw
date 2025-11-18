$PBExportHeader$w_rh512_concepto_grupo.srw
forward
global type w_rh512_concepto_grupo from w_report_smpl
end type
type cb_1 from commandbutton within w_rh512_concepto_grupo
end type
type st_1 from statictext within w_rh512_concepto_grupo
end type
type sle_year from singlelineedit within w_rh512_concepto_grupo
end type
type sle_mes from singlelineedit within w_rh512_concepto_grupo
end type
type gb_1 from groupbox within w_rh512_concepto_grupo
end type
end forward

global type w_rh512_concepto_grupo from w_report_smpl
integer width = 5115
integer height = 2152
string title = "[RH512] Consulta conceptos vs grupos"
string menuname = "m_impresion"
cb_1 cb_1
st_1 st_1
sle_year sle_year
sle_mes sle_mes
gb_1 gb_1
end type
global w_rh512_concepto_grupo w_rh512_concepto_grupo

on w_rh512_concepto_grupo.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.st_1=create st_1
this.sle_year=create sle_year
this.sle_mes=create sle_mes
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_year
this.Control[iCurrent+4]=this.sle_mes
this.Control[iCurrent+5]=this.gb_1
end on

on w_rh512_concepto_grupo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.sle_year)
destroy(this.sle_mes)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String  	ls_origen, ls_tiptra, ls_desc_origen, ls_codigo,  ls_cencos, &
			ls_msg, ls_mensaje, ls_flag_ajuste
Integer 	li_msg, li_year, li_mes

try 
	dw_report.reset( )
	
	li_year			= Integer(sle_year.text)
	li_mes			= Integer(sle_mes.text)
	
	dw_report.setTransObject( SQLCA )
	
	ib_preview = true
	event ue_preview()
	
	dw_report.retrieve(li_year, li_mes)

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error en generar boletas")
end try

	
end event

event ue_open_pre;call super::ue_open_pre;Str_parametros		lstr_param
string				ls_desc_origen, ls_data, ls_desc_tipo_planilla
Date					ld_hoy

try 
	ld_hoy = Date(gnvo_app.of_fecha_actual())
	
	sle_year.text = string(ld_hoy, 'yyyy')
	sle_mes.text = string(ld_hoy, 'mm')
	
	


catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "")
end try


end event

type dw_report from w_report_smpl`dw_report within w_rh512_concepto_grupo
integer x = 0
integer y = 224
integer width = 3438
integer height = 1444
integer taborder = 60
string dataobject = "d_concepto_grupos_crt"
end type

event dw_report::rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type cb_1 from commandbutton within w_rh512_concepto_grupo
integer x = 718
integer y = 80
integer width = 315
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;setPointer(HourGlass!)
Parent.Event ue_retrieve()
setPointer(Arrow!)
end event

type st_1 from statictext within w_rh512_concepto_grupo
integer x = 37
integer y = 92
integer width = 251
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Periodo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_rh512_concepto_grupo
integer x = 297
integer y = 88
integer width = 229
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_rh512_concepto_grupo
integer x = 544
integer y = 88
integer width = 155
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_rh512_concepto_grupo
integer width = 4686
integer height = 216
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtro para el reporte"
end type

