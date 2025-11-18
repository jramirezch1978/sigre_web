$PBExportHeader$w_cm793_basc_listado_proveedores.srw
forward
global type w_cm793_basc_listado_proveedores from w_rpt
end type
type rb_4 from radiobutton within w_cm793_basc_listado_proveedores
end type
type rb_3 from radiobutton within w_cm793_basc_listado_proveedores
end type
type dw_report from u_dw_rpt within w_cm793_basc_listado_proveedores
end type
type gb_2 from groupbox within w_cm793_basc_listado_proveedores
end type
type gb_1 from groupbox within w_cm793_basc_listado_proveedores
end type
type rb_2 from radiobutton within w_cm793_basc_listado_proveedores
end type
type rb_1 from radiobutton within w_cm793_basc_listado_proveedores
end type
end forward

global type w_cm793_basc_listado_proveedores from w_rpt
integer x = 282
integer y = 250
integer width = 3098
integer height = 1347
string title = "[CM793] Listado BASC de Proveedores / Clientes"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
rb_4 rb_4
rb_3 rb_3
dw_report dw_report
gb_2 gb_2
gb_1 gb_1
rb_2 rb_2
rb_1 rb_1
end type
global w_cm793_basc_listado_proveedores w_cm793_basc_listado_proveedores

on w_cm793_basc_listado_proveedores.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_4=create rb_4
this.rb_3=create rb_3
this.dw_report=create dw_report
this.gb_2=create gb_2
this.gb_1=create gb_1
this.rb_2=create rb_2
this.rb_1=create rb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_4
this.Control[iCurrent+2]=this.rb_3
this.Control[iCurrent+3]=this.dw_report
this.Control[iCurrent+4]=this.gb_2
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.rb_1
end on

on w_cm793_basc_listado_proveedores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.dw_report)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.rb_2)
destroy(this.rb_1)
end on

event ue_open_pre;call super::ue_open_pre;//idw_1.Visible = False
idw_1 = dw_report
ii_help = 101           // help topic

idw_1.SetTransObject( SQLCA )

This.Event ue_retrieve()
end event

event ue_retrieve;call super::ue_retrieve;string ls_clipro, ls_nacext,ls_leyenda, ls_fecha
string ls_titulo, ls_codigo, ls_version	

if rb_1.checked then
	ls_clipro = '0' //cliente
	ls_leyenda = 'CLIENTES'
	ls_titulo ='LISTADO DE CLIENTE'
	ls_codigo = 'CANT.FO.08.2'
	ls_version = 'VERSION: 00'
	ls_fecha = 'FECHA: 24/03/2014'
else
	ls_clipro = '1' //proveedor
	ls_leyenda = 'PROVEEDORES'
	ls_titulo ='LISTADO DE PROVEEDORES'
	ls_codigo = 'CANT.FO.07.2'
	ls_version = 'VERSION: 00'
	ls_fecha = 'FECHA: 06/03/2014'
end if

if rb_3.checked then
	ls_nacext = 'N' //nacional
	ls_leyenda += ' LOCALES'
else
	ls_nacext = 'E' //extranjero
	ls_leyenda += ' EN EL EXTERIOR'
end if
dw_report.Retrieve(ls_clipro, ls_nacext)
dw_report.Visible = True
dw_report.object.t_3.text = LS_LEYENDA
dw_report.object.t_titulobasc1.text = ls_titulo
dw_report.object.t_codigobasc.text = ls_codigo
dw_report.object.t_versionbasc.text = ls_version
dw_report.object.t_fecha.text = ls_fecha
dw_report.object.t_usuario.text = upper(gs_user)
dw_report.Object.p_logo.filename = gs_logo
ib_preview = false
event ue_preview()	
end event

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y


end event

event ue_print;call super::ue_print;dw_report.EVENT ue_print()

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

type rb_4 from radiobutton within w_cm793_basc_listado_proveedores
integer x = 1412
integer y = 106
integer width = 351
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Extranjero"
end type

event clicked;parent.post Event ue_retrieve()
end event

type rb_3 from radiobutton within w_cm793_basc_listado_proveedores
integer x = 987
integer y = 106
integer width = 351
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nacional"
boolean checked = true
end type

event clicked;parent.post Event ue_retrieve()
end event

type dw_report from u_dw_rpt within w_cm793_basc_listado_proveedores
integer x = 29
integer y = 256
integer width = 2988
integer height = 899
boolean bringtotop = true
string dataobject = "d_rpt_proveedor_basc_listado_clie_prov"
end type

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type gb_2 from groupbox within w_cm793_basc_listado_proveedores
integer x = 936
integer y = 26
integer width = 881
integer height = 208
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

type gb_1 from groupbox within w_cm793_basc_listado_proveedores
integer x = 29
integer y = 26
integer width = 881
integer height = 208
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo"
end type

type rb_2 from radiobutton within w_cm793_basc_listado_proveedores
integer x = 508
integer y = 106
integer width = 351
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proveedor"
end type

event clicked;parent.post Event ue_retrieve()
end event

type rb_1 from radiobutton within w_cm793_basc_listado_proveedores
integer x = 95
integer y = 106
integer width = 351
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cliente"
boolean checked = true
end type

event clicked;parent.post Event ue_retrieve()
end event

