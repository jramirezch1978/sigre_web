$PBExportHeader$w_fi748_rpt_detalle_compras_prov.srw
forward
global type w_fi748_rpt_detalle_compras_prov from w_rpt
end type
type cbx_todos from checkbox within w_fi748_rpt_detalle_compras_prov
end type
type sle_proveedor from singlelineedit within w_fi748_rpt_detalle_compras_prov
end type
type cb_busqueda from commandbutton within w_fi748_rpt_detalle_compras_prov
end type
type st_proveedor from statictext within w_fi748_rpt_detalle_compras_prov
end type
type st_4 from statictext within w_fi748_rpt_detalle_compras_prov
end type
type ddlb_mes_2 from dropdownlistbox within w_fi748_rpt_detalle_compras_prov
end type
type st_3 from statictext within w_fi748_rpt_detalle_compras_prov
end type
type ddlb_mes_1 from dropdownlistbox within w_fi748_rpt_detalle_compras_prov
end type
type st_2 from statictext within w_fi748_rpt_detalle_compras_prov
end type
type st_1 from statictext within w_fi748_rpt_detalle_compras_prov
end type
type em_ano from editmask within w_fi748_rpt_detalle_compras_prov
end type
type cb_1 from commandbutton within w_fi748_rpt_detalle_compras_prov
end type
type dw_report from u_dw_rpt within w_fi748_rpt_detalle_compras_prov
end type
type gb_1 from groupbox within w_fi748_rpt_detalle_compras_prov
end type
end forward

global type w_fi748_rpt_detalle_compras_prov from w_rpt
integer width = 3438
integer height = 2060
string title = "[FI748] Detalle de Cntas x Pagar por Proveedor"
string menuname = "m_reporte_filter"
cbx_todos cbx_todos
sle_proveedor sle_proveedor
cb_busqueda cb_busqueda
st_proveedor st_proveedor
st_4 st_4
ddlb_mes_2 ddlb_mes_2
st_3 st_3
ddlb_mes_1 ddlb_mes_1
st_2 st_2
st_1 st_1
em_ano em_ano
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_fi748_rpt_detalle_compras_prov w_fi748_rpt_detalle_compras_prov

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ib_preview = FALSE
THIS.Event ue_preview()



idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text   = gs_empresa
idw_1.object.t_usuario.text     = gs_user

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

on w_fi748_rpt_detalle_compras_prov.create
int iCurrent
call super::create
if this.MenuName = "m_reporte_filter" then this.MenuID = create m_reporte_filter
this.cbx_todos=create cbx_todos
this.sle_proveedor=create sle_proveedor
this.cb_busqueda=create cb_busqueda
this.st_proveedor=create st_proveedor
this.st_4=create st_4
this.ddlb_mes_2=create ddlb_mes_2
this.st_3=create st_3
this.ddlb_mes_1=create ddlb_mes_1
this.st_2=create st_2
this.st_1=create st_1
this.em_ano=create em_ano
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_todos
this.Control[iCurrent+2]=this.sle_proveedor
this.Control[iCurrent+3]=this.cb_busqueda
this.Control[iCurrent+4]=this.st_proveedor
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.ddlb_mes_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.ddlb_mes_1
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.em_ano
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.dw_report
this.Control[iCurrent+14]=this.gb_1
end on

on w_fi748_rpt_detalle_compras_prov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_todos)
destroy(this.sle_proveedor)
destroy(this.cb_busqueda)
destroy(this.st_proveedor)
destroy(this.st_4)
destroy(this.ddlb_mes_2)
destroy(this.st_3)
destroy(this.ddlb_mes_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type cbx_todos from checkbox within w_fi748_rpt_detalle_compras_prov
integer x = 2039
integer y = 168
integer width = 297
integer height = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if cbx_todos.checked then
	sle_proveedor.enabled = false
else
	sle_proveedor.enabled = true
end if
end event

type sle_proveedor from singlelineedit within w_fi748_rpt_detalle_compras_prov
integer x = 325
integer y = 168
integer width = 347
integer height = 100
integer taborder = 50
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

type cb_busqueda from commandbutton within w_fi748_rpt_detalle_compras_prov
integer x = 677
integer y = 168
integer width = 82
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;String	ls
Str_seleccionar lstr_seleccionar

string ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_sql = "SELECT PROVEEDOR AS CODIGO, " &
   	 + "NOM_PROVEEDOR AS NOMBRE, " &
		 + "FLAG_ESTADO AS ESTADO " &
		 + "FROM PROVEEDOR " 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_proveedor.text	= ls_codigo
	st_proveedor.text 	= ls_data
end if
end event

type st_proveedor from statictext within w_fi748_rpt_detalle_compras_prov
integer x = 768
integer y = 168
integer width = 1253
integer height = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_4 from statictext within w_fi748_rpt_detalle_compras_prov
integer x = 1367
integer y = 64
integer width = 238
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Fin:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_mes_2 from dropdownlistbox within w_fi748_rpt_detalle_compras_prov
integer x = 1627
integer y = 64
integer width = 517
integer height = 856
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_fi748_rpt_detalle_compras_prov
integer x = 14
integer y = 180
integer width = 306
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proveedor :"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_mes_1 from dropdownlistbox within w_fi748_rpt_detalle_compras_prov
integer x = 827
integer y = 64
integer width = 517
integer height = 856
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_fi748_rpt_detalle_compras_prov
integer x = 526
integer y = 64
integer width = 279
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Inicio:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi748_rpt_detalle_compras_prov
integer x = 50
integer y = 64
integer width = 210
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_fi748_rpt_detalle_compras_prov
integer x = 283
integer y = 64
integer width = 219
integer height = 72
integer taborder = 20
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

type cb_1 from commandbutton within w_fi748_rpt_detalle_compras_prov
integer x = 2350
integer y = 68
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Long	   ll_ano,ll_mes_ini, ll_mes_fin
String	ls_proveedor, ls_nom_proveedor, ls_texto, ls_todos
Integer	li_count

ll_ano    		= Long(em_ano.text)
ll_mes_ini    	= Long(LEFT(ddlb_mes_1.text,2))
ll_mes_fin    	= Long(LEFT(ddlb_mes_2.text,2))

ls_proveedor  	= trim(sle_proveedor.text)

If cbx_todos.checked Then
	ls_todos = '1'
	ls_proveedor = '%'
	ls_texto		 = 'Todos los Proveedores '
Else
	ls_todos = '0'
	ls_nom_proveedor = st_proveedor.text
	ls_proveedor = ls_proveedor + '%'
	ls_texto = 'Del Proveedor ' + ls_nom_proveedor + ' '
End If	 

ls_texto = ls_texto + 'del Año: ' + String(ll_ano)
SetPointer(HourGlass!)		

dw_report.retrieve(ls_proveedor, ll_ano, ll_mes_ini, ll_mes_fin)
dw_report.object.t_texto.text = ls_texto




end event

type dw_report from u_dw_rpt within w_fi748_rpt_detalle_compras_prov
integer y = 304
integer width = 3355
integer height = 1400
string dataobject = "d_rpt_detalle_compras_tbl"
end type

type gb_1 from groupbox within w_fi748_rpt_detalle_compras_prov
integer width = 3387
integer height = 296
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Argumentos"
end type

