$PBExportHeader$w_fi756_cheque_vs_facturas.srw
forward
global type w_fi756_cheque_vs_facturas from w_rpt
end type
type st_nom_banco from statictext within w_fi756_cheque_vs_facturas
end type
type sle_banco from singlelineedit within w_fi756_cheque_vs_facturas
end type
type st_2 from statictext within w_fi756_cheque_vs_facturas
end type
type st_1 from statictext within w_fi756_cheque_vs_facturas
end type
type sle_cheque from singlelineedit within w_fi756_cheque_vs_facturas
end type
type dw_reporte from u_dw_rpt within w_fi756_cheque_vs_facturas
end type
type cb_1 from commandbutton within w_fi756_cheque_vs_facturas
end type
type gb_1 from groupbox within w_fi756_cheque_vs_facturas
end type
end forward

global type w_fi756_cheque_vs_facturas from w_rpt
integer width = 3657
integer height = 2208
string title = "[FI756] Detalle de Facturas por Cheque"
string menuname = "m_reporte"
st_nom_banco st_nom_banco
sle_banco sle_banco
st_2 st_2
st_1 st_1
sle_cheque sle_cheque
dw_reporte dw_reporte
cb_1 cb_1
gb_1 gb_1
end type
global w_fi756_cheque_vs_facturas w_fi756_cheque_vs_facturas

forward prototypes
public function boolean of_validacion_rpt ()
end prototypes

public function boolean of_validacion_rpt ();//========== VALIDACION DE LA LONGITUD DEL AÑO Y MES ========//
/*
IF (  len(sle_origen.text) <> 2 OR 
		len(sle_ano) <> 4 OR
		len(sle_mes) <> 2 OR
		len(sle_libro) <> 2 OR
		len(sle_desde) <> 0 OR
		len(sle_hasta) <> 0 ) THEN 
	Messagebox('AVISO','DATOS REQUERIDOS INCOMPLETOS')
	sle_origen.SetFocus()
	RETURN FALSE
END IF 
*/

RETURN TRUE
end function

on w_fi756_cheque_vs_facturas.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_nom_banco=create st_nom_banco
this.sle_banco=create sle_banco
this.st_2=create st_2
this.st_1=create st_1
this.sle_cheque=create sle_cheque
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nom_banco
this.Control[iCurrent+2]=this.sle_banco
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_cheque
this.Control[iCurrent+6]=this.dw_reporte
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_fi756_cheque_vs_facturas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_nom_banco)
destroy(this.sle_banco)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_cheque)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_nro_cheque, ls_banco

ls_banco = trim(sle_banco.text)
ls_nro_cheque = trim(sle_cheque.text)

idw_1.retrieve(ls_banco, ls_nro_cheque)

idw_1.Object.DataWindow.Print.Paper.Size = 256 
idw_1.Object.DataWindow.Print.CustomPage.Width = 70
idw_1.Object.DataWindow.Print.CustomPage.Length = 145

ib_preview = false
event ue_preview()
end event

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_reporte
idw_1.Visible = true
idw_1.SetTransObject(sqlca)

Event ue_preview()
//This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_reporte.width  = newwidth  - dw_reporte.x
dw_reporte.height = newheight - dw_reporte.y
end event

type st_nom_banco from statictext within w_fi756_cheque_vs_facturas
integer x = 782
integer y = 56
integer width = 1669
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_banco from singlelineedit within w_fi756_cheque_vs_facturas
event ue_dobleclick pbm_lbuttondblclk
integer x = 393
integer y = 56
integer width = 379
integer height = 72
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = "select cod_banco as codigo_banco, "  &
							  + "nom_banco as nombre_banco " &
							  + "from banco b"
										 
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	This.text			= lstr_seleccionar.param1[1]
	st_nom_banco.text = lstr_seleccionar.param2[1]
END IF	

end event

type st_2 from statictext within w_fi756_cheque_vs_facturas
integer x = 69
integer y = 64
integer width = 306
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Banco :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi756_cheque_vs_facturas
integer x = 69
integer y = 144
integer width = 306
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cheque :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_cheque from singlelineedit within w_fi756_cheque_vs_facturas
integer x = 393
integer y = 136
integer width = 375
integer height = 72
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type dw_reporte from u_dw_rpt within w_fi756_cheque_vs_facturas
integer y = 248
integer width = 3589
integer height = 1404
integer taborder = 0
string dataobject = "d_rpt_cheque_fact_tbl"
end type

type cb_1 from commandbutton within w_fi756_cheque_vs_facturas
integer x = 2491
integer y = 44
integer width = 343
integer height = 172
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Event ue_retrieve()
end event

type gb_1 from groupbox within w_fi756_cheque_vs_facturas
integer width = 2885
integer height = 236
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos de entrada"
end type

