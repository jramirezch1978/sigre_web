$PBExportHeader$w_ve751_cronograma_cobranza.srw
forward
global type w_ve751_cronograma_cobranza from w_rpt
end type
type cbx_todos from checkbox within w_ve751_cronograma_cobranza
end type
type sle_nom_cliente from singlelineedit within w_ve751_cronograma_cobranza
end type
type cb_cliente from commandbutton within w_ve751_cronograma_cobranza
end type
type sle_cliente from singlelineedit within w_ve751_cronograma_cobranza
end type
type st_2 from statictext within w_ve751_cronograma_cobranza
end type
type cb_1 from commandbutton within w_ve751_cronograma_cobranza
end type
type dw_report from u_dw_rpt within w_ve751_cronograma_cobranza
end type
type gb_1 from groupbox within w_ve751_cronograma_cobranza
end type
end forward

global type w_ve751_cronograma_cobranza from w_rpt
integer width = 3799
integer height = 2404
string title = "[VE751] Cronograma de cobranza (Facturación simplificada)"
string menuname = "m_reporte"
cbx_todos cbx_todos
sle_nom_cliente sle_nom_cliente
cb_cliente cb_cliente
sle_cliente sle_cliente
st_2 st_2
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_ve751_cronograma_cobranza w_ve751_cronograma_cobranza

on w_ve751_cronograma_cobranza.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_todos=create cbx_todos
this.sle_nom_cliente=create sle_nom_cliente
this.cb_cliente=create cb_cliente
this.sle_cliente=create sle_cliente
this.st_2=create st_2
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_todos
this.Control[iCurrent+2]=this.sle_nom_cliente
this.Control[iCurrent+3]=this.cb_cliente
this.Control[iCurrent+4]=this.sle_cliente
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_report
this.Control[iCurrent+8]=this.gb_1
end on

on w_ve751_cronograma_cobranza.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_todos)
destroy(this.sle_nom_cliente)
destroy(this.cb_cliente)
destroy(this.sle_cliente)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)



//datos de reporte
ib_preview = true
This.Event ue_preview()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user

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

event ue_saveas;call super::ue_saveas;idw_1.EVENT ue_saveas()
end event

event ue_zoom;call super::ue_zoom;idw_1.EVENT ue_zoom(ai_zoom)
end event

type cbx_todos from checkbox within w_ve751_cronograma_cobranza
integer x = 114
integer y = 128
integer width = 1120
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los Clientes"
end type

event clicked;if this.checked then
	cb_cliente.enabled = false
else
	cb_cliente.enabled = true
end if
end event

type sle_nom_cliente from singlelineedit within w_ve751_cronograma_cobranza
integer x = 763
integer y = 52
integer width = 1545
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_cliente from commandbutton within w_ve751_cronograma_cobranza
integer x = 645
integer y = 52
integer width = 114
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_sql = "select distinct " &
		 + "       p.proveedor as proveedor,"&
		 + "       p.nom_proveedor as nom_cliente, " &
		 + "       decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni "&
		 + "from fs_factura_simpl f, " &
		 + "     proveedor        p, " &
		 + "     fs_factura_simpl_pagos fp " &
		 + "where f.cliente = p.proveedor  " &
		 + "  and f.nro_registro = fp.nro_registro " &
		 + "  and fp.flag_forma_pago = 'C'    " 
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	sle_Cliente.text		= ls_codigo
	sle_nom_cliente.text	= ls_data
end if
end event

type sle_cliente from singlelineedit within w_ve751_cronograma_cobranza
integer x = 293
integer y = 52
integer width = 343
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_ve751_cronograma_cobranza
integer x = 50
integer y = 52
integer width = 233
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cliente :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ve751_cronograma_cobranza
integer x = 2377
integer y = 36
integer width = 425
integer height = 148
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;String 	ls_cliente

if cbx_todos.checked then
	ls_cliente = '%%'
else
	if trim(sle_cliente.text) = '' then
		MessageBox('Aviso', 'Debe seleccionar un cliente previamente, por favor verifique', Information!)
		sle_cliente.setFocus()
		return
	end if
	ls_cliente = trim(sle_cliente.text) + '%'
end if

dw_report.Settransobject( sqlca)
dw_report.Retrieve(ls_cliente)

//datos de reporte
ib_preview = true
Parent.Event ue_preview()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_user.text     = gs_user


end event

type dw_report from u_dw_rpt within w_ve751_cronograma_cobranza
integer y = 236
integer width = 3310
integer height = 1748
string dataobject = "d_rpt_cronograma_cobranza_tbl"
boolean livescroll = false
end type

type gb_1 from groupbox within w_ve751_cronograma_cobranza
integer width = 2935
integer height = 220
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos para el reporte"
end type

