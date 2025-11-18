$PBExportHeader$w_rh508_rpt_saldo_cuenta_corrte.srw
forward
global type w_rh508_rpt_saldo_cuenta_corrte from w_rpt
end type
type cbx_ttrab from checkbox within w_rh508_rpt_saldo_cuenta_corrte
end type
type cbx_origen from checkbox within w_rh508_rpt_saldo_cuenta_corrte
end type
type sle_origen from singlelineedit within w_rh508_rpt_saldo_cuenta_corrte
end type
type st_4 from statictext within w_rh508_rpt_saldo_cuenta_corrte
end type
type cb_3 from commandbutton within w_rh508_rpt_saldo_cuenta_corrte
end type
type st_3 from statictext within w_rh508_rpt_saldo_cuenta_corrte
end type
type st_2 from statictext within w_rh508_rpt_saldo_cuenta_corrte
end type
type cb_2 from commandbutton within w_rh508_rpt_saldo_cuenta_corrte
end type
type st_1 from statictext within w_rh508_rpt_saldo_cuenta_corrte
end type
type cb_1 from commandbutton within w_rh508_rpt_saldo_cuenta_corrte
end type
type sle_tipo_trab from singlelineedit within w_rh508_rpt_saldo_cuenta_corrte
end type
type dw_report from u_dw_rpt within w_rh508_rpt_saldo_cuenta_corrte
end type
end forward

global type w_rh508_rpt_saldo_cuenta_corrte from w_rpt
integer width = 3881
integer height = 1528
string title = "(RH508) Saldo de Cuenta Corriente por concepto"
string menuname = "m_impresion"
long backcolor = 12632256
cbx_ttrab cbx_ttrab
cbx_origen cbx_origen
sle_origen sle_origen
st_4 st_4
cb_3 cb_3
st_3 st_3
st_2 st_2
cb_2 cb_2
st_1 st_1
cb_1 cb_1
sle_tipo_trab sle_tipo_trab
dw_report dw_report
end type
global w_rh508_rpt_saldo_cuenta_corrte w_rh508_rpt_saldo_cuenta_corrte

event ue_open_pre;call super::ue_open_pre;//sle_tipo_trab.text = '%  '
//sle_origen.text = '% '
//

idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ib_preview = FALSE

THIS.Event ue_preview()



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

event ue_retrieve;call super::ue_retrieve;String ls_tip_trab, ls_origen, ls_mon_sol 

ls_tip_trab = sle_tipo_trab.text
ls_origen	= sle_origen.text

ls_origen   = ls_origen+'%'
ls_tip_trab = ls_tip_trab+'%'

if cbx_origen.checked then
	ls_origen = '%'	
end if


if cbx_ttrab.checked then
	ls_tip_trab = '%'	
end if

SELECT l.cod_soles INTO :ls_mon_sol FROM logparam l WHERE reckey='1' ;

idw_1.Retrieve( ls_origen, ls_tip_trab, ls_mon_sol)


idw_1.Object.p_logo.filename = gs_logo
//idw_1.object.t_texto.text = gs_empresa
idw_1.object.t_user.text = gs_user
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_rh508_rpt_saldo_cuenta_corrte.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cbx_ttrab=create cbx_ttrab
this.cbx_origen=create cbx_origen
this.sle_origen=create sle_origen
this.st_4=create st_4
this.cb_3=create cb_3
this.st_3=create st_3
this.st_2=create st_2
this.cb_2=create cb_2
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_tipo_trab=create sle_tipo_trab
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_ttrab
this.Control[iCurrent+2]=this.cbx_origen
this.Control[iCurrent+3]=this.sle_origen
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.sle_tipo_trab
this.Control[iCurrent+12]=this.dw_report
end on

on w_rh508_rpt_saldo_cuenta_corrte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_ttrab)
destroy(this.cbx_origen)
destroy(this.sle_origen)
destroy(this.st_4)
destroy(this.cb_3)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_tipo_trab)
destroy(this.dw_report)
end on

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type cbx_ttrab from checkbox within w_rh508_rpt_saldo_cuenta_corrte
integer x = 800
integer y = 332
integer width = 951
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Todos Los Tipo de Trabajadores"
end type

type cbx_origen from checkbox within w_rh508_rpt_saldo_cuenta_corrte
integer x = 27
integer y = 332
integer width = 681
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Todos los Origenes"
end type

type sle_origen from singlelineedit within w_rh508_rpt_saldo_cuenta_corrte
event ue_tecla pbm_dwnkey
integer x = 594
integer y = 196
integer width = 178
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_rh508_rpt_saldo_cuenta_corrte
integer x = 27
integer y = 212
integer width = 530
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_3 from commandbutton within w_rh508_rpt_saldo_cuenta_corrte
integer x = 1486
integer y = 196
integer width = 110
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS CODIGO      , '&
								       +'ORIGEN.NOMBRE     AS DESCRIPCION   '&
				   				 	 +'FROM ORIGEN '&

														 
														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_origen.text = lstr_seleccionar.param1[1]
	st_3.text  = lstr_seleccionar.param2[1]
END IF														 

end event

type st_3 from statictext within w_rh508_rpt_saldo_cuenta_corrte
integer x = 791
integer y = 196
integer width = 677
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh508_rpt_saldo_cuenta_corrte
integer x = 791
integer y = 80
integer width = 677
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_rh508_rpt_saldo_cuenta_corrte
integer x = 1486
integer y = 80
integer width = 110
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT TIPO_TRABAJADOR.TIPO_TRABAJADOR AS TTRABAJADOR , '&
								       +'TIPO_TRABAJADOR.DESC_TIPO_TRA   AS DESCRIPCION , '&
										 +'TIPO_TRABAJADOR.LIBRO_PLANILLA  AS NRO_LIBRO  '&
				   				 	 +'FROM TIPO_TRABAJADOR '&

														 
														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_tipo_trab.text = lstr_seleccionar.param1[1]
	st_2.text  = lstr_seleccionar.param2[1]	
END IF														 

end event

type st_1 from statictext within w_rh508_rpt_saldo_cuenta_corrte
integer x = 27
integer y = 96
integer width = 530
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Tipo de Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_rh508_rpt_saldo_cuenta_corrte
integer x = 1746
integer y = 76
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Parent.triggerevent( 'ue_retrieve')
end event

type sle_tipo_trab from singlelineedit within w_rh508_rpt_saldo_cuenta_corrte
event ue_tecla pbm_dwnkey
integer x = 594
integer y = 80
integer width = 178
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

type dw_report from u_dw_rpt within w_rh508_rpt_saldo_cuenta_corrte
integer x = 5
integer y = 440
integer width = 3776
integer height = 888
string dataobject = "d_rpt_cnta_crrte_saldo_cnc_tbl"
end type

