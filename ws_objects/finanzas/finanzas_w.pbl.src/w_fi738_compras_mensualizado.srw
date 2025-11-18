$PBExportHeader$w_fi738_compras_mensualizado.srw
forward
global type w_fi738_compras_mensualizado from w_rpt
end type
type cb_2 from commandbutton within w_fi738_compras_mensualizado
end type
type sle_moneda from singlelineedit within w_fi738_compras_mensualizado
end type
type st_1 from statictext within w_fi738_compras_mensualizado
end type
type cbx_origenes from checkbox within w_fi738_compras_mensualizado
end type
type cb_3 from commandbutton within w_fi738_compras_mensualizado
end type
type sle_origen from singlelineedit within w_fi738_compras_mensualizado
end type
type st_2 from statictext within w_fi738_compras_mensualizado
end type
type cb_1 from commandbutton within w_fi738_compras_mensualizado
end type
type st_3 from statictext within w_fi738_compras_mensualizado
end type
type em_year from editmask within w_fi738_compras_mensualizado
end type
type dw_report from u_dw_rpt within w_fi738_compras_mensualizado
end type
type gb_1 from groupbox within w_fi738_compras_mensualizado
end type
end forward

global type w_fi738_compras_mensualizado from w_rpt
integer width = 3799
integer height = 2404
string title = "[FI738] Compras por Proveedores Mensualizado"
string menuname = "m_reporte"
cb_2 cb_2
sle_moneda sle_moneda
st_1 st_1
cbx_origenes cbx_origenes
cb_3 cb_3
sle_origen sle_origen
st_2 st_2
cb_1 cb_1
st_3 st_3
em_year em_year
dw_report dw_report
gb_1 gb_1
end type
global w_fi738_compras_mensualizado w_fi738_compras_mensualizado

on w_fi738_compras_mensualizado.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_2=create cb_2
this.sle_moneda=create sle_moneda
this.st_1=create st_1
this.cbx_origenes=create cbx_origenes
this.cb_3=create cb_3
this.sle_origen=create sle_origen
this.st_2=create st_2
this.cb_1=create cb_1
this.st_3=create st_3
this.em_year=create em_year
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.sle_moneda
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cbx_origenes
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.sle_origen
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.em_year
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.gb_1
end on

on w_fi738_compras_mensualizado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.sle_moneda)
destroy(this.st_1)
destroy(this.cbx_origenes)
destroy(this.cb_3)
destroy(this.sle_origen)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.em_year)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)

em_year.text = string(Date(gnvo_app.of_fecha_actual( )), 'yyyy')

//datos de reporte
ib_preview = true
This.Event ue_preview()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user

sle_origen.text = gs_origen
sle_moneda.text = gnvo_app.is_soles
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

event ue_retrieve;call super::ue_retrieve;String	ls_origen, ls_nombre, ls_moneda
Integer	li_year

li_year = Integer(em_year.text)

//para leer las fechas
if cbx_origenes.checked then
	
	ls_nombre = 'Todos Los Origenes'
	ls_origen = '%%'
	
else
	ls_origen = trim(sle_origen.text)

	//buscar descripcion y exigir origen
	select nombre 
		into :ls_nombre 
	from origen 
	where cod_origen = :ls_origen ;
	
	IF SQLCA.SQLCode = 100 THEN
		Messagebox('Aviso','Origen ' + ls_origen + ' no Existe, por favor Verifique!', StopSign!)
		Return
	END IF
	
	ls_origen = ls_origen + '%'
end if

ls_moneda = sle_moneda.text

dw_report.Retrieve(li_year, ls_moneda, ls_origen )

dw_report.object.p_logo.filename = gs_logo
//dw_report.object.t_titulo1.text = 'MONEDA: ' + ls_moneda

//dw_report.object.t_nombre.text = gs_empresa
//dw_report.object.t_user.text = gs_user

//datos de reporte
ib_preview = False


end event

type cb_2 from commandbutton within w_fi738_compras_mensualizado
integer x = 741
integer y = 160
integer width = 114
integer height = 80
integer taborder = 40
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

ls_sql = "select m.cod_moneda as codigo_moneda, " &
		 + "m.descripcion as descripcion_moneda " &
		 + "from moneda m " &
		 + "where m.flag_estado = '1'"
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
	
if ls_codigo <> '' then
	sle_moneda.text		= ls_codigo
end if
end event

type sle_moneda from singlelineedit within w_fi738_compras_mensualizado
integer x = 361
integer y = 156
integer width = 343
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_fi738_compras_mensualizado
integer x = 32
integer y = 164
integer width = 288
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_origenes from checkbox within w_fi738_compras_mensualizado
integer x = 933
integer y = 44
integer width = 663
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Origenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_origen.Enabled = FALSE
	sle_origen.Text	  = '%'
	cb_3.enabled = false
else
	sle_origen.Enabled = TRUE
	sle_origen.Text	  = ''
	cb_3.enabled = true
end if
end event

type cb_3 from commandbutton within w_fi738_compras_mensualizado
integer x = 1595
integer y = 160
integer width = 114
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;string ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_sql = "SELECT COD_ORIGEN AS CODIGO_ORIGEN, " &
		  + "NOMBRE AS NOMBRE_ORIGEN " &
		  + "FROM ORIGEN " 
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	sle_origen.text		= ls_codigo
end if
end event

type sle_origen from singlelineedit within w_fi738_compras_mensualizado
integer x = 1216
integer y = 156
integer width = 343
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_fi738_compras_mensualizado
integer x = 933
integer y = 164
integer width = 242
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_fi738_compras_mensualizado
integer x = 1751
integer width = 434
integer height = 268
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Recuperar"
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type st_3 from statictext within w_fi738_compras_mensualizado
integer x = 32
integer y = 48
integer width = 288
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "AÑO:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_year from editmask within w_fi738_compras_mensualizado
integer x = 361
integer y = 40
integer width = 343
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type dw_report from u_dw_rpt within w_fi738_compras_mensualizado
integer y = 296
integer width = 3310
integer height = 1748
string dataobject = "d_rpt_resumen_compras_proveedor_tbl"
boolean livescroll = false
end type

type gb_1 from groupbox within w_fi738_compras_mensualizado
integer width = 1723
integer height = 268
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos"
end type

