$PBExportHeader$w_al746_saldos_libres.srw
forward
global type w_al746_saldos_libres from w_rpt
end type
type st_1 from statictext within w_al746_saldos_libres
end type
type cbx_almacen from checkbox within w_al746_saldos_libres
end type
type sle_descrip from singlelineedit within w_al746_saldos_libres
end type
type sle_almacen from singlelineedit within w_al746_saldos_libres
end type
type cbx_1 from checkbox within w_al746_saldos_libres
end type
type cb_1 from commandbutton within w_al746_saldos_libres
end type
type dw_report from u_dw_rpt within w_al746_saldos_libres
end type
type gb_1 from groupbox within w_al746_saldos_libres
end type
end forward

global type w_al746_saldos_libres from w_rpt
integer width = 3698
integer height = 1640
string title = "[AL746] Saldos Libres x Almacenes"
string menuname = "m_impresion"
long backcolor = 12632256
st_1 st_1
cbx_almacen cbx_almacen
sle_descrip sle_descrip
sle_almacen sle_almacen
cbx_1 cbx_1
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_al746_saldos_libres w_al746_saldos_libres

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al746_saldos_libres.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_1=create st_1
this.cbx_almacen=create cbx_almacen
this.sle_descrip=create sle_descrip
this.sle_almacen=create sle_almacen
this.cbx_1=create cbx_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cbx_almacen
this.Control[iCurrent+3]=this.sle_descrip
this.Control[iCurrent+4]=this.sle_almacen
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_report
this.Control[iCurrent+8]=this.gb_1
end on

on w_al746_saldos_libres.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cbx_almacen)
destroy(this.sle_descrip)
destroy(this.sle_almacen)
destroy(this.cbx_1)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)

ib_preview = false
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

type st_1 from statictext within w_al746_saldos_libres
integer x = 763
integer y = 92
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Almacenes :"
boolean focusrectangle = false
end type

type cbx_almacen from checkbox within w_al746_saldos_libres
integer x = 96
integer y = 80
integer width = 640
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Todos los almacenes"
boolean checked = true
boolean lefttext = true
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type sle_descrip from singlelineedit within w_al746_saldos_libres
integer x = 1545
integer y = 76
integer width = 1426
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_almacen from singlelineedit within w_al746_saldos_libres
event dobleclick pbm_lbuttondblclk
integer x = 1093
integer y = 76
integer width = 439
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc

end event

type cbx_1 from checkbox within w_al746_saldos_libres
integer x = 82
integer y = 212
integer width = 613
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Solo Saldo Libre"
end type

type cb_1 from commandbutton within w_al746_saldos_libres
integer x = 3246
integer y = 36
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

event clicked;String ls_almacen,ls_sql_old,ls_new_sql,ls_sql

ls_almacen = sle_almacen.text

if cbx_almacen.checked then
	ls_almacen = '%'
else
	if Isnull(ls_almacen) OR Trim(ls_almacen) = '' then
		Messagebox('Aviso','Debe Seleccionar Un Almacen , Verifique!')
		Return
	end if
end if


ls_new_sql = ' AND (("ARTICULO_ALMACEN"."SLDO_TOTAL" - "ARTICULO_ALMACEN"."SLDO_RESERVADO") > 0 )'


ls_sql_old = dw_report.GetSQLSelect()

IF cbx_1.Checked THEN
	ls_sql	  = ls_sql_old + ls_new_sql 

	IF dw_report.SetSQLselect(ls_sql)  = 1 THEN
		Messagebox('Aviso','Fallo Filtro de Select ,Verifique!')
		Return 	
	END IF	
END IF	



dw_report.retrieve(ls_almacen)


//old sql
dw_report.SetSQLselect(ls_sql_old)

end event

type dw_report from u_dw_rpt within w_al746_saldos_libres
integer x = 18
integer y = 360
integer width = 3593
integer height = 1096
string dataobject = "d_rpt_saldos_libres_x_almacen_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_al746_saldos_libres
integer x = 37
integer y = 4
integer width = 3063
integer height = 316
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Datos"
end type

