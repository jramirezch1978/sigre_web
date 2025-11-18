$PBExportHeader$w_aud712_guias_sin_facturar.srw
forward
global type w_aud712_guias_sin_facturar from w_report_smpl
end type
type st_1 from statictext within w_aud712_guias_sin_facturar
end type
type uo_1 from u_ingreso_rango_fechas within w_aud712_guias_sin_facturar
end type
type cb_3 from commandbutton within w_aud712_guias_sin_facturar
end type
type rb_pptt from radiobutton within w_aud712_guias_sin_facturar
end type
type rb_mate from radiobutton within w_aud712_guias_sin_facturar
end type
type rb_todos from radiobutton within w_aud712_guias_sin_facturar
end type
type gb_1 from groupbox within w_aud712_guias_sin_facturar
end type
type gb_2 from groupbox within w_aud712_guias_sin_facturar
end type
end forward

global type w_aud712_guias_sin_facturar from w_report_smpl
integer width = 3387
integer height = 1592
string title = "Guías de remisión sin facturar[AUD712] "
string menuname = "m_reporte"
long backcolor = 12632256
st_1 st_1
uo_1 uo_1
cb_3 cb_3
rb_pptt rb_pptt
rb_mate rb_mate
rb_todos rb_todos
gb_1 gb_1
gb_2 gb_2
end type
global w_aud712_guias_sin_facturar w_aud712_guias_sin_facturar

on w_aud712_guias_sin_facturar.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.uo_1=create uo_1
this.cb_3=create cb_3
this.rb_pptt=create rb_pptt
this.rb_mate=create rb_mate
this.rb_todos=create rb_todos
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.rb_pptt
this.Control[iCurrent+5]=this.rb_mate
this.Control[iCurrent+6]=this.rb_todos
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_aud712_guias_sin_facturar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.rb_pptt)
destroy(this.rb_mate)
destroy(this.rb_todos)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;date ld_fec_desde
date ld_fec_hasta
String ls_tipo

ld_fec_desde=uo_1.of_get_fecha1()
ld_fec_hasta=uo_1.of_get_fecha2()

IF rb_todos.checked = TRUE THEN
	ls_tipo = 'T'
ELSEIF rb_pptt.checked = TRUE THEN
	ls_tipo = 'P'
ELSEIF rb_mate.checked = TRUE THEN
	ls_tipo = 'M'
END IF


DECLARE pb_usp_aud_guias_x_facturar PROCEDURE FOR usp_aud_guias_x_facturar
		  ( :ls_tipo, :ld_fec_desde, :ld_fec_hasta ) ;
Execute pb_usp_aud_guias_x_facturar ;

idw_1.Retrieve()

dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_texto.text = 'Del ' + STRING(ld_fec_desde,'dd/mm/yyyy') + ' al ' + STRING(ld_fec_hasta,'dd/mm/yyyy')
dw_report.object.p_logo.filename = gs_logo

end event

type dw_report from w_report_smpl`dw_report within w_aud712_guias_sin_facturar
integer x = 14
integer y = 484
integer width = 3314
integer height = 912
integer taborder = 30
string dataobject = "d_rpt_guias_sin_facturar_tbl"
end type

type st_1 from statictext within w_aud712_guias_sin_facturar
integer x = 1216
integer y = 72
integer width = 1321
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "GUIAS DE REMISION SIN FACTURAR"
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_aud712_guias_sin_facturar
integer x = 1243
integer y = 272
integer taborder = 10
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;string ls_inicio
uo_1.of_set_label('Desde','Hasta')

// obtenemos el primer dia del mes
ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

uo_1.of_set_fecha(date(ls_inicio),today())
uo_1.of_set_rango_inicio(date('01/01/1900'))   // rango inicial
uo_1.of_set_rango_fin(date('31/12/9999'))      // rango final

end event

type cb_3 from commandbutton within w_aud712_guias_sin_facturar
integer x = 2715
integer y = 260
integer width = 274
integer height = 84
integer taborder = 20
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

type rb_pptt from radiobutton within w_aud712_guias_sin_facturar
integer x = 96
integer y = 208
integer width = 782
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217750
string text = "Produtos terminados "
end type

type rb_mate from radiobutton within w_aud712_guias_sin_facturar
integer x = 96
integer y = 296
integer width = 782
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217750
string text = "Materiales"
end type

type rb_todos from radiobutton within w_aud712_guias_sin_facturar
integer x = 96
integer y = 124
integer width = 782
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217750
string text = "Todas las guías de remisión"
boolean checked = true
end type

type gb_1 from groupbox within w_aud712_guias_sin_facturar
integer x = 1198
integer y = 204
integer width = 1381
integer height = 192
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 134217750
string text = " Ingrese Rango de Fechas "
end type

type gb_2 from groupbox within w_aud712_guias_sin_facturar
integer x = 55
integer y = 60
integer width = 901
integer height = 352
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 134217750
string text = "Selección"
end type

