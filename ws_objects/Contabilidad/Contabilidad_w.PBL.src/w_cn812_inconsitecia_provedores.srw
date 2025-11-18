$PBExportHeader$w_cn812_inconsitecia_provedores.srw
forward
global type w_cn812_inconsitecia_provedores from w_rpt
end type
type rb_2 from radiobutton within w_cn812_inconsitecia_provedores
end type
type rb_1 from radiobutton within w_cn812_inconsitecia_provedores
end type
type st_1 from statictext within w_cn812_inconsitecia_provedores
end type
type sle_1 from singlelineedit within w_cn812_inconsitecia_provedores
end type
type cb_1 from commandbutton within w_cn812_inconsitecia_provedores
end type
type dw_report from u_dw_rpt within w_cn812_inconsitecia_provedores
end type
end forward

global type w_cn812_inconsitecia_provedores from w_rpt
integer width = 2528
integer height = 1476
string title = "Inconsistencia Proveedores (CN812)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
rb_2 rb_2
rb_1 rb_1
st_1 st_1
sle_1 sle_1
cb_1 cb_1
dw_report dw_report
end type
global w_cn812_inconsitecia_provedores w_cn812_inconsitecia_provedores

on w_cn812_inconsitecia_provedores.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_1=create cb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.dw_report
end on

on w_cn812_inconsitecia_provedores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_1)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
ib_preview = false
THIS.Event ue_preview()






end event

event ue_retrieve;call super::ue_retrieve;Long ll_nro_libro,ll_ano


if rb_1.checked then
   select p.libro_compras into :ll_nro_libro from finparam p where p.reckey = '1' ;	
	dw_report.dataobject = 'd_abc_daot_consistencia_prov_tbl'
elseif rb_2.checked then
	select p.libro_ventas into :ll_nro_libro from finparam p where p.reckey = '1' ;
	dw_report.dataobject = 'd_abc_daot_consistencia_cliente_tbl'
end if	

dw_report.settransobject(sqlca)

ib_preview = false
THIS.Event ue_preview()

ll_ano = Long(sle_1.text)


idw_1.Retrieve(ll_ano,ll_nro_libro)
idw_1.Visible = True



idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user


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

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type rb_2 from radiobutton within w_cn812_inconsitecia_provedores
integer x = 599
integer y = 124
integer width = 379
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Clientes"
end type

type rb_1 from radiobutton within w_cn812_inconsitecia_provedores
integer x = 599
integer y = 36
integer width = 389
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proveedores"
boolean checked = true
end type

type st_1 from statictext within w_cn812_inconsitecia_provedores
integer x = 37
integer y = 40
integer width = 197
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_cn812_inconsitecia_provedores
integer x = 261
integer y = 36
integer width = 261
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

type cb_1 from commandbutton within w_cn812_inconsitecia_provedores
integer x = 2066
integer y = 24
integer width = 407
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type dw_report from u_dw_rpt within w_cn812_inconsitecia_provedores
integer x = 32
integer y = 232
integer width = 2441
integer height = 1048
string dataobject = "d_abc_daot_consistencia_prov_tbl"
end type

