$PBExportHeader$w_ma712_horas_talleres.srw
forward
global type w_ma712_horas_talleres from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_ma712_horas_talleres
end type
type cb_3 from commandbutton within w_ma712_horas_talleres
end type
type rb_1 from radiobutton within w_ma712_horas_talleres
end type
type rb_2 from radiobutton within w_ma712_horas_talleres
end type
type rb_3 from radiobutton within w_ma712_horas_talleres
end type
type gb_1 from groupbox within w_ma712_horas_talleres
end type
type gb_2 from groupbox within w_ma712_horas_talleres
end type
end forward

global type w_ma712_horas_talleres from w_report_smpl
integer width = 3323
integer height = 1636
string title = "Detalle de Horas Trabajadas de Talleres (MA712)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
uo_1 uo_1
cb_3 cb_3
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
gb_1 gb_1
gb_2 gb_2
end type
global w_ma712_horas_talleres w_ma712_horas_talleres

on w_ma712_horas_talleres.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_1=create uo_1
this.cb_3=create cb_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_ma712_horas_talleres.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve();call super::ue_retrieve;string ls_titulo, ls_taller
date   ld_fec_desde, ld_fec_hasta

if rb_1.checked = true then
	ls_titulo = 'DETALLE DE HORAS TALLERES DE FABRICA'
	ls_taller = 'TALL_FAB'
elseif rb_2.checked = true then
	ls_titulo = 'DETALLE DE HORAS TALLERES DE DMA'
	ls_taller = 'TALL_DMA'
elseif rb_3.checked = true then
	ls_titulo = 'DETALLE DE HORAS TALLERES DE SERVICIOS INTERNOS'
	ls_taller = 'TALL_ADM'

end if

ld_fec_desde = uo_1.of_get_fecha1()
ld_fec_hasta = uo_1.of_get_fecha2()

DECLARE pb_usp_mtt_rpt_horas_talleres PROCEDURE FOR USP_MTT_RPT_HORAS_TALLERES
        ( :ld_fec_desde, :ld_fec_hasta, :ls_taller ) ;
EXECUTE pb_usp_mtt_rpt_horas_talleres ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user
dw_report.object.t_titulo.text   = ls_titulo

end event

type dw_report from w_report_smpl`dw_report within w_ma712_horas_talleres
integer y = 416
integer width = 3273
integer height = 1036
integer taborder = 50
string dataobject = "d_rpt_horas_talleres_tbl"
end type

type uo_1 from u_ingreso_rango_fechas within w_ma712_horas_talleres
integer x = 946
integer y = 164
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;string ls_inicio
uo_1.of_set_label('Desde','Hasta')

ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

uo_1.of_set_fecha(date(ls_inicio),today())
uo_1.of_set_rango_inicio(date('01/01/1900'))
uo_1.of_set_rango_fin(date('31/12/9999'))

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_3 from commandbutton within w_ma712_horas_talleres
integer x = 2441
integer y = 160
integer width = 297
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type rb_1 from radiobutton within w_ma712_horas_talleres
integer x = 96
integer y = 116
integer width = 626
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Taller Fábrica"
borderstyle borderstyle = styleraised!
end type

type rb_2 from radiobutton within w_ma712_horas_talleres
integer x = 96
integer y = 188
integer width = 626
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Taller DMA"
borderstyle borderstyle = styleraised!
end type

type rb_3 from radiobutton within w_ma712_horas_talleres
integer x = 96
integer y = 260
integer width = 699
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Taller servicios internos"
end type

type gb_1 from groupbox within w_ma712_horas_talleres
integer x = 37
integer y = 52
integer width = 782
integer height = 312
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Seleccionar"
end type

type gb_2 from groupbox within w_ma712_horas_talleres
integer x = 873
integer y = 92
integer width = 1417
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Ingrese Rango de Fechas "
end type

