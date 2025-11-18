$PBExportHeader$w_ve767_ventas_vs_despachos.srw
forward
global type w_ve767_ventas_vs_despachos from w_report_smpl
end type
type cbx_origenes from checkbox within w_ve767_ventas_vs_despachos
end type
type cb_1 from commandbutton within w_ve767_ventas_vs_despachos
end type
type st_4 from statictext within w_ve767_ventas_vs_despachos
end type
type sle_year from singlelineedit within w_ve767_ventas_vs_despachos
end type
type st_3 from statictext within w_ve767_ventas_vs_despachos
end type
type sle_mes from singlelineedit within w_ve767_ventas_vs_despachos
end type
type tab_1 from tab within w_ve767_ventas_vs_despachos
end type
type tabpage_1 from userobject within tab_1
end type
type dw_categorias from u_dw_rpt within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_categorias dw_categorias
end type
type tabpage_2 from userobject within tab_1
end type
type dw_resumen2 from u_dw_rpt within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_resumen2 dw_resumen2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_detalle from u_dw_rpt within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_detalle dw_detalle
end type
type tab_1 from tab within w_ve767_ventas_vs_despachos
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type gb_1 from groupbox within w_ve767_ventas_vs_despachos
end type
end forward

global type w_ve767_ventas_vs_despachos from w_report_smpl
integer width = 3973
integer height = 2036
string title = "[VE767] Reporte de ventas vs despachos"
string menuname = "m_reporte"
cbx_origenes cbx_origenes
cb_1 cb_1
st_4 st_4
sle_year sle_year
st_3 st_3
sle_mes sle_mes
tab_1 tab_1
gb_1 gb_1
end type
global w_ve767_ventas_vs_despachos w_ve767_ventas_vs_despachos

type variables
u_dw_rpt	idw_categorias, idw_resumen2, idw_detalle

end variables

forward prototypes
public subroutine of_asigna_dws ()
end prototypes

public subroutine of_asigna_dws ();idw_categorias = tab_1.tabpage_1.dw_categorias
idw_resumen2 	= tab_1.tabpage_2.dw_resumen2
idw_detalle 	= tab_1.tabpage_3.dw_detalle
end subroutine

on w_ve767_ventas_vs_despachos.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_origenes=create cbx_origenes
this.cb_1=create cb_1
this.st_4=create st_4
this.sle_year=create sle_year
this.st_3=create st_3
this.sle_mes=create sle_mes
this.tab_1=create tab_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_origenes
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.sle_year
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_mes
this.Control[iCurrent+7]=this.tab_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_ve767_ventas_vs_despachos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_origenes)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.sle_year)
destroy(this.st_3)
destroy(this.sle_mes)
destroy(this.tab_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_flag_incluye_mp
Integer	li_mes, li_year


if cbx_origenes.checked then
	ls_flag_incluye_mp = '1'
else
	ls_flag_incluye_mp = '0'
end if

li_mes = Integer(sle_mes.text)
li_year = Integer(sle_year.text)

ib_preview = true
event ue_preview()

idw_categorias.retrieve(li_year, li_mes, ls_flag_incluye_mp)

idw_resumen2.retrieve(li_year, li_mes, ls_flag_incluye_mp)

idw_detalle.retrieve(li_year, li_mes, ls_flag_incluye_mp)

//dw_report.object.p_logo.filename = gs_logo
//dw_report.object.t_nombre.text = gs_empresa
//dw_report.object.t_user.text = gs_user


end event

event ue_open_pre;call super::ue_open_pre;date 	ld_hoy

of_asigna_dws()

ld_hoy = Date(gnvo_app.of_fecha_Actual())

sle_year.text = string(ld_hoy, 'yyyy')
sle_mes.text = string(ld_hoy, 'mm')

idw_1 = idw_categorias
idw_categorias.Visible = true
idw_categorias.SetTransObject(sqlca)

idw_resumen2.Visible = true
idw_resumen2.SetTransObject(sqlca)

idw_detalle.Visible = true
idw_detalle.SetTransObject(sqlca)


end event

event resize;call super::resize;//Override
of_asigna_dws()

tab_1.width 	= newwidth - tab_1.x - 10
tab_1.height 	= newheight - tab_1.y - 10

idw_categorias.width 	= tab_1.tabpage_1.width - idw_categorias.x - 10
idw_categorias.height 	= tab_1.tabpage_1.height - idw_categorias.y - 10

idw_resumen2.width 	= tab_1.tabpage_2.width - idw_resumen2.x - 10
idw_resumen2.height 	= tab_1.tabpage_2.height - idw_resumen2.y - 10

idw_detalle.width 	= tab_1.tabpage_2.width - idw_resumen2.x - 10
idw_detalle.height 	= tab_1.tabpage_2.height - idw_resumen2.y - 10
end event

type dw_report from w_report_smpl`dw_report within w_ve767_ventas_vs_despachos
boolean visible = false
integer x = 3131
integer y = 40
integer width = 229
integer height = 168
integer taborder = 40
boolean enabled = false
end type

type cbx_origenes from checkbox within w_ve767_ventas_vs_despachos
integer x = 55
integer y = 176
integer width = 777
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Incluir la Materia Prima"
end type

type cb_1 from commandbutton within w_ve767_ventas_vs_despachos
integer x = 782
integer y = 68
integer width = 448
integer height = 168
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type st_4 from statictext within w_ve767_ventas_vs_despachos
integer x = 32
integer y = 84
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_ve767_ventas_vs_despachos
integer x = 201
integer y = 76
integer width = 192
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_ve767_ventas_vs_despachos
integer x = 416
integer y = 84
integer width = 210
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_ve767_ventas_vs_despachos
integer x = 649
integer y = 76
integer width = 105
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type tab_1 from tab within w_ve767_ventas_vs_despachos
integer y = 308
integer width = 3607
integer height = 1452
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 152
integer width = 3570
integer height = 1284
long backcolor = 67108864
string text = "Resumen por~r~nCategorias (Cantidad)"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_categorias dw_categorias
end type

on tabpage_1.create
this.dw_categorias=create dw_categorias
this.Control[]={this.dw_categorias}
end on

on tabpage_1.destroy
destroy(this.dw_categorias)
end on

type dw_categorias from u_dw_rpt within tabpage_1
integer width = 3442
integer taborder = 20
string dataobject = "d_rpt_despacho_vs_ventas_crt"
boolean hsplitscroll = true
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 152
integer width = 3570
integer height = 1284
long backcolor = 67108864
string text = "Resumen por~r~nCategorias (Importe S/.)"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_resumen2 dw_resumen2
end type

on tabpage_2.create
this.dw_resumen2=create dw_resumen2
this.Control[]={this.dw_resumen2}
end on

on tabpage_2.destroy
destroy(this.dw_resumen2)
end on

type dw_resumen2 from u_dw_rpt within tabpage_2
integer width = 3442
string dataobject = "d_rpt_despacho_vs_ventas2_crt"
boolean hsplitscroll = true
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 152
integer width = 3570
integer height = 1284
long backcolor = 67108864
string text = "Detalle de~r~nInformacion"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_detalle dw_detalle
end type

on tabpage_3.create
this.dw_detalle=create dw_detalle
this.Control[]={this.dw_detalle}
end on

on tabpage_3.destroy
destroy(this.dw_detalle)
end on

type dw_detalle from u_dw_rpt within tabpage_3
integer width = 3442
string dataobject = "d_rpt_detalle_despacho_vs_ventas_tbl"
boolean hsplitscroll = true
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type gb_1 from groupbox within w_ve767_ventas_vs_despachos
integer width = 3442
integer height = 296
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de Busqueda"
end type

