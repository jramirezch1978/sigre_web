$PBExportHeader$w_ve755_letras_vencidas.srw
forward
global type w_ve755_letras_vencidas from w_rpt
end type
type cbx_2 from checkbox within w_ve755_letras_vencidas
end type
type sle_desc_art from singlelineedit within w_ve755_letras_vencidas
end type
type pb_lote from picturebutton within w_ve755_letras_vencidas
end type
type sle_cod_art from singlelineedit within w_ve755_letras_vencidas
end type
type st_2 from statictext within w_ve755_letras_vencidas
end type
type cbx_1 from checkbox within w_ve755_letras_vencidas
end type
type st_3 from statictext within w_ve755_letras_vencidas
end type
type em_fecha from n_ingreso_fecha within w_ve755_letras_vencidas
end type
type sle_nom_cliente from singlelineedit within w_ve755_letras_vencidas
end type
type pb_cliente from picturebutton within w_ve755_letras_vencidas
end type
type sle_cliente from singlelineedit within w_ve755_letras_vencidas
end type
type st_1 from statictext within w_ve755_letras_vencidas
end type
type cb_1 from commandbutton within w_ve755_letras_vencidas
end type
type dw_report from u_dw_rpt within w_ve755_letras_vencidas
end type
type gb_1 from groupbox within w_ve755_letras_vencidas
end type
end forward

global type w_ve755_letras_vencidas from w_rpt
integer width = 3799
integer height = 2404
string title = "[VE755] Cuotas Vencias - Cartera Pesada"
string menuname = "m_reporte"
cbx_2 cbx_2
sle_desc_art sle_desc_art
pb_lote pb_lote
sle_cod_art sle_cod_art
st_2 st_2
cbx_1 cbx_1
st_3 st_3
em_fecha em_fecha
sle_nom_cliente sle_nom_cliente
pb_cliente pb_cliente
sle_cliente sle_cliente
st_1 st_1
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_ve755_letras_vencidas w_ve755_letras_vencidas

on w_ve755_letras_vencidas.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_2=create cbx_2
this.sle_desc_art=create sle_desc_art
this.pb_lote=create pb_lote
this.sle_cod_art=create sle_cod_art
this.st_2=create st_2
this.cbx_1=create cbx_1
this.st_3=create st_3
this.em_fecha=create em_fecha
this.sle_nom_cliente=create sle_nom_cliente
this.pb_cliente=create pb_cliente
this.sle_cliente=create sle_cliente
this.st_1=create st_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_2
this.Control[iCurrent+2]=this.sle_desc_art
this.Control[iCurrent+3]=this.pb_lote
this.Control[iCurrent+4]=this.sle_cod_art
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.em_fecha
this.Control[iCurrent+9]=this.sle_nom_cliente
this.Control[iCurrent+10]=this.pb_cliente
this.Control[iCurrent+11]=this.sle_cliente
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.cb_1
this.Control[iCurrent+14]=this.dw_report
this.Control[iCurrent+15]=this.gb_1
end on

on w_ve755_letras_vencidas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_2)
destroy(this.sle_desc_art)
destroy(this.pb_lote)
destroy(this.sle_cod_art)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.st_3)
destroy(this.em_fecha)
destroy(this.sle_nom_cliente)
destroy(this.pb_cliente)
destroy(this.sle_cliente)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)

em_fecha.text = string(gnvo_app.of_fecha_actual(), 'dd/mm/yyyy')


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
Date		ld_fecha

if cbx_1.checked then
	ls_cliente = '%%' 
else
	if trim(sle_Cliente.text) = '' then
		MessageBox('Error', 'Debe seleccionar un cliente, por favor verifique!', stopSign!)
		sle_cliente.setFocus()
		return
	end if
	ls_cliente 	= trim(sle_Cliente.text) + '%'
end if

if cbx_2.checked then
	ls_cod_Art = '%%' 
else
	if trim(sle_cod_Art.text) = '' then
		MessageBox('Error', 'Debe seleccionar un Lote, por favor verifique!', stopSign!)
		sle_cod_Art.setFocus()
		return
	end if
	ls_cod_Art 	= trim(sle_Cod_art.text) + '%'
end if

ld_fecha 	= Date(em_fecha.text)

dw_report.Settransobject( sqlca)

dw_report.Retrieve(ls_cliente, ld_fecha, ls_cod_art )

//datos de reporte
ib_preview = true
Event ue_preview()

dw_report.object.p_logo.filename 	= gs_logo
dw_report.object.t_empresa.text   	= gs_empresa
//dw_report.object.t_titulo1.text   	= gnvo_app.empresa.is_nom_empresa + ' - ' + gnvo_app.empresa.is_ruc
dw_report.object.t_user.text     	= gs_user

end event

type cbx_2 from checkbox within w_ve755_letras_vencidas
integer x = 1989
integer y = 168
integer width = 823
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mostrar todos los Lotes"
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

type sle_desc_art from singlelineedit within w_ve755_letras_vencidas
integer x = 2555
integer y = 68
integer width = 640
integer height = 84
integer taborder = 50
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

type pb_lote from picturebutton within w_ve755_letras_vencidas
integer x = 2427
integer y = 72
integer width = 114
integer height = 84
integer taborder = 40
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

if cbx_1.checked then
	ls_cliente = '%%' 
else
	if trim(sle_Cliente.text) = '' then
		MessageBox('Error', 'Debe seleccionar un cliente, por favor verifique!', stopSign!)
		sle_cliente.setFocus()
		return
	end if
	ls_cliente 	= trim(sle_Cliente.text) + '%'
end if

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
		 + "  and cc.cod_relacion like '" + ls_cliente + "' " &
		 + "order by a.cod_art"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

if ls_codigo <> '' then
	sle_cod_art.text		= ls_codigo
	sle_desc_art.text = ls_data
end if




end event

type sle_cod_art from singlelineedit within w_ve755_letras_vencidas
integer x = 2071
integer y = 72
integer width = 347
integer height = 84
integer taborder = 30
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

type st_2 from statictext within w_ve755_letras_vencidas
integer x = 1906
integer y = 80
integer width = 174
integer height = 52
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

type cbx_1 from checkbox within w_ve755_letras_vencidas
integer x = 59
integer y = 168
integer width = 823
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mostrar todos los clientes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_cliente.enabled = false
	sle_nom_cliente.enabled = false
	pb_cliente.enabled = false
else
	sle_cliente.enabled = true
	sle_nom_cliente.enabled = true
	pb_cliente.enabled = true
end if

sle_cliente.text = ''
sle_nom_cliente.text = ''

end event

type st_3 from statictext within w_ve755_letras_vencidas
integer x = 987
integer y = 180
integer width = 544
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Vencimiento :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_fecha from n_ingreso_fecha within w_ve755_letras_vencidas
integer x = 1550
integer y = 164
integer width = 379
integer height = 80
integer taborder = 20
integer textsize = -8
string text = ""
alignment alignment = center!
maskdatatype maskdatatype = datetimemask!
string mask = "dd/mm/yyyy"
double increment = 1
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text = string(today(),'dd/mm/yyyy hh:mm:ss')
end event

type sle_nom_cliente from singlelineedit within w_ve755_letras_vencidas
integer x = 709
integer y = 64
integer width = 1179
integer height = 84
integer taborder = 30
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

type pb_cliente from picturebutton within w_ve755_letras_vencidas
integer x = 590
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
boolean enabled = false
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
	
	if not cbx_2.checked then
		sle_cod_art.text = ls_data2
		sle_desc_art.text = ls_data3
	end if
end if




end event

type sle_cliente from singlelineedit within w_ve755_letras_vencidas
integer x = 233
integer y = 64
integer width = 347
integer height = 84
integer taborder = 30
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

type st_1 from statictext within w_ve755_letras_vencidas
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

type cb_1 from commandbutton within w_ve755_letras_vencidas
integer x = 3227
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

type dw_report from u_dw_rpt within w_ve755_letras_vencidas
integer y = 308
integer width = 3310
integer height = 1660
string dataobject = "d_rpt_cuotas_vencidas_tbl"
boolean livescroll = false
end type

event buttonclicked;call super::buttonclicked;String			ls_tipo_doc, ls_nro_doc, ls_nom_cliente
str_parametros	lstr_param
w_ve310_cntas_cobrar lw_1

if row = 0 then return

ls_nom_cliente = this.object.nom_cliente 	[row]
ls_tipo_doc		= this.object.tipo_doc 		[row]
ls_nro_doc		= this.object.nro_doc 		[row]

if lower(dwo.name) = 'b_envio' then
	if MessageBox('Confirmacion', 'Desea factura la letra ' + ls_tipo_doc + '/' + ls_nro_doc &
		+ ' del cliente ' + ls_nom_cliente, Information!, YEsNo!, 2) = 2 then return
	
	lstr_param.dw_report = this
	lstr_param.long1		= row
	
	OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered!)
	
end if
end event

type gb_1 from groupbox within w_ve755_letras_vencidas
integer width = 3671
integer height = 268
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

