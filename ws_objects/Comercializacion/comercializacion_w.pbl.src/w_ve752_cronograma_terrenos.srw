$PBExportHeader$w_ve752_cronograma_terrenos.srw
forward
global type w_ve752_cronograma_terrenos from w_rpt
end type
type cbx_1 from checkbox within w_ve752_cronograma_terrenos
end type
type sle_desc_art from singlelineedit within w_ve752_cronograma_terrenos
end type
type pb_lote from picturebutton within w_ve752_cronograma_terrenos
end type
type sle_cod_art from singlelineedit within w_ve752_cronograma_terrenos
end type
type st_2 from statictext within w_ve752_cronograma_terrenos
end type
type sle_nom_cliente from singlelineedit within w_ve752_cronograma_terrenos
end type
type pb_1 from picturebutton within w_ve752_cronograma_terrenos
end type
type sle_cliente from singlelineedit within w_ve752_cronograma_terrenos
end type
type st_1 from statictext within w_ve752_cronograma_terrenos
end type
type cb_1 from commandbutton within w_ve752_cronograma_terrenos
end type
type dw_report from u_dw_rpt within w_ve752_cronograma_terrenos
end type
type gb_1 from groupbox within w_ve752_cronograma_terrenos
end type
end forward

global type w_ve752_cronograma_terrenos from w_rpt
integer width = 3799
integer height = 2404
string title = "[VE752] Cronograma de pagos de terrenos"
string menuname = "m_reporte"
cbx_1 cbx_1
sle_desc_art sle_desc_art
pb_lote pb_lote
sle_cod_art sle_cod_art
st_2 st_2
sle_nom_cliente sle_nom_cliente
pb_1 pb_1
sle_cliente sle_cliente
st_1 st_1
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_ve752_cronograma_terrenos w_ve752_cronograma_terrenos

on w_ve752_cronograma_terrenos.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_1=create cbx_1
this.sle_desc_art=create sle_desc_art
this.pb_lote=create pb_lote
this.sle_cod_art=create sle_cod_art
this.st_2=create st_2
this.sle_nom_cliente=create sle_nom_cliente
this.pb_1=create pb_1
this.sle_cliente=create sle_cliente
this.st_1=create st_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.sle_desc_art
this.Control[iCurrent+3]=this.pb_lote
this.Control[iCurrent+4]=this.sle_cod_art
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_nom_cliente
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.sle_cliente
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.gb_1
end on

on w_ve752_cronograma_terrenos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.sle_desc_art)
destroy(this.pb_lote)
destroy(this.sle_cod_art)
destroy(this.st_2)
destroy(this.sle_nom_cliente)
destroy(this.pb_1)
destroy(this.sle_cliente)
destroy(this.st_1)
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

//dw_report.object.p_logo.filename = gs_logo
//dw_report.object.t_empresa.text = gs_empresa
//dw_report.object.t_user.text = gs_user


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

event ue_retrieve;call super::ue_retrieve;String 	ls_cliente, ls_cod_art

if trim(sle_cliente.text) = '' then
	MessageBox("Error", "Debes colocar el cliente para continuar", StopSign!)
	sle_cliente.setFocus()
	return
end if

if cbx_1.checked then
	ls_cod_art = '%%'
else
	if trim(sle_cod_art.text) = '' then
		MessageBox("Error", "Debes colocar el lote para continuar", StopSign!)
		sle_cod_art.setFocus()
		return
	end if
	ls_cod_art = trim(sle_cod_art.text) + '%'
end if

ls_cliente 	= sle_Cliente.text


dw_report.Settransobject( sqlca)

dw_report.Retrieve(ls_cliente, ls_cod_art )

//datos de reporte
ib_preview = false
Event ue_preview()

dw_report.object.p_logo.filename 	= gs_logo
dw_report.object.t_empresa.text   	= gnvo_app.empresa.is_nom_empresa
dw_report.object.t_ruc.text   		= 'RUC - ' + gnvo_app.empresa.is_ruc
dw_report.object.t_user.text     	= gs_user

end event

type cbx_1 from checkbox within w_ve752_cronograma_terrenos
integer x = 1856
integer y = 168
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if this.checked then
	sle_cod_art.enabled = false
	sle_desc_art.enabled = false
	pb_lote.enabled = false
else
	sle_cod_art.enabled = true
	sle_desc_art.enabled = true
	pb_lote.enabled = true
end if

sle_cod_art.text = ''
sle_desc_art.text = ''

end event

type sle_desc_art from singlelineedit within w_ve752_cronograma_terrenos
integer x = 745
integer y = 156
integer width = 1102
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type pb_lote from picturebutton within w_ve752_cronograma_terrenos
integer x = 622
integer y = 160
integer width = 114
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string picturename = "C:\SIGRE\resources\PNG\open.png"
string disabledname = "C:\SIGRE\resources\PNG\open.png"
alignment htextalign = left!
boolean map3dcolors = true
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_cliente

if trim(sle_Cliente.text) = '' then
	MessageBox('Error', 'Debe seleccionar un cliente, por favor verifique!', stopSign!)
	sle_cliente.setFocus()
	return
end if
ls_cliente 	= sle_Cliente.text


ls_sql = "select distinct " &
		 + "       a.cod_art as codigo_articulo, " &
		 + "       a.desc_art as descripcion_articulo " &
		 + "from cntas_cobrar     cc, " &
		 + "     cntas_cobrar_det ccd, " &
		 + "     articulo         a " &
		 + "where cc.tipo_doc = ccd.tipo_doc " &
		 + "  and cc.nro_doc  = ccd.nro_doc " &
		 + "  and cc.flag_estado <> '0' " &
		 + "  and cc.tipo_doc = 'LTC' " &
		 + "  and ccd.cod_art = a.cod_art " &
		 + "  and cc.cod_relacion = '" + ls_cliente + "' " &
		 + "order by a.cod_art"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

if ls_codigo <> '' then
	sle_cod_art.text		= ls_codigo
	sle_desc_art.text = ls_data
end if




end event

type sle_cod_art from singlelineedit within w_ve752_cronograma_terrenos
integer x = 233
integer y = 160
integer width = 384
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_ve752_cronograma_terrenos
integer x = 46
integer y = 168
integer width = 183
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Lote :"
boolean focusrectangle = false
end type

type sle_nom_cliente from singlelineedit within w_ve752_cronograma_terrenos
integer x = 745
integer y = 64
integer width = 1102
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_ve752_cronograma_terrenos
integer x = 622
integer y = 64
integer width = 114
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string picturename = "C:\SIGRE\resources\PNG\open.png"
string disabledname = "C:\SIGRE\resources\PNG\open.png"
alignment htextalign = left!
boolean map3dcolors = true
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data1, ls_sql, ls_data2, ls_data3

ls_sql = "select distinct p.proveedor as cliente, " &
		 + "p.nom_proveedor as nombre_cliente, " &
		 + "decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni, " &
		 + "a.cod_art as codigo_articulo, " &
		 + "a.desc_art as descripcion_articulo, " &
		 + "a.mnz as manzana, " &
		 + "a.lote as lote " &
		 + "from proveedor p, " &
		 + "cntas_cobrar	cc, " &
		 + "cntas_cobrar_det ccd, " &
		 + "articulo a " &
		 + "where p.proveedor = cc.cod_relacion " &
		 + "  and cc.tipo_doc = ccd.tipo_doc " &
		 + "  and cc.nro_doc  = ccd.nro_doc " &
		 + "  and ccd.cod_art = a.cod_art " &
		 + "  and cc.tipo_doc = 'LTC' " &
		 + "order by p.nom_proveedor"
		 
lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data1, ls_data2, ls_data3, '2')

if ls_codigo <> '' then
	sle_cliente.text		= ls_codigo
	sle_nom_cliente.text = ls_data1
	
	if not cbx_1.checked then
		sle_cod_art.text = ls_data2
		sle_desc_art.text = ls_data3
	end if
end if

end event

type sle_cliente from singlelineedit within w_ve752_cronograma_terrenos
integer x = 233
integer y = 64
integer width = 384
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_ve752_cronograma_terrenos
integer x = 46
integer y = 76
integer width = 183
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cliente: "
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ve752_cronograma_terrenos
integer x = 2875
integer y = 52
integer width = 425
integer height = 200
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;parent.event ue_retrieve()
end event

type dw_report from u_dw_rpt within w_ve752_cronograma_terrenos
integer y = 276
integer width = 3310
integer height = 1748
string dataobject = "d_rpt_cronograma_terrenos_tbl"
boolean livescroll = false
end type

type gb_1 from groupbox within w_ve752_cronograma_terrenos
integer width = 3369
integer height = 264
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtro"
end type

