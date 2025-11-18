$PBExportHeader$w_pt771_partidas_presp_errores.srw
$PBExportComments$Detalle de ejecucion mensual
forward
global type w_pt771_partidas_presp_errores from w_report_smpl
end type
type em_ano from editmask within w_pt771_partidas_presp_errores
end type
type st_3 from statictext within w_pt771_partidas_presp_errores
end type
type cb_1 from commandbutton within w_pt771_partidas_presp_errores
end type
type gb_1 from groupbox within w_pt771_partidas_presp_errores
end type
end forward

global type w_pt771_partidas_presp_errores from w_report_smpl
integer width = 2720
integer height = 1652
string title = "Errores en Partida Presupuestal (PT771)"
string menuname = "m_impresion"
long backcolor = 67108864
em_ano em_ano
st_3 st_3
cb_1 cb_1
gb_1 gb_1
end type
global w_pt771_partidas_presp_errores w_pt771_partidas_presp_errores

type variables
Integer   ii_zoom_actual = 80, ii_zi = 10, ii_sort = 0
String is_tipo = '', is_nivelcc, is_nivelcp

end variables

on w_pt771_partidas_presp_errores.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.em_ano=create em_ano
this.st_3=create st_3
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_pt771_partidas_presp_errores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.gb_1)
end on

type dw_report from w_report_smpl`dw_report within w_pt771_partidas_presp_errores
integer y = 228
integer width = 1655
integer height = 1164
string dataobject = "d_rpt_fallas_prep_partida"
end type

type em_ano from editmask within w_pt771_partidas_presp_errores
integer x = 265
integer y = 72
integer width = 247
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_3 from statictext within w_pt771_partidas_presp_errores
integer x = 55
integer y = 88
integer width = 160
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pt771_partidas_presp_errores
integer x = 567
integer y = 68
integer width = 306
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;Int li_ano
string ls_mensaje
str_parametros sl_param

li_ano = INTEGER( em_ano.text)
			
dw_report.SetTransObject(sqlca)
dw_report.retrieve(li_ano)
//dw_report.object.datawindow.print.orientation = 1
dw_report.visible = true

dw_report.object.t_titulo2.text = 'Año: ' + em_ano.text 
dw_report.object.t_user.text = gs_user
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_objeto.text = parent.classname( )
dw_report.Object.p_logo.filename = gs_logo
end event

type gb_1 from groupbox within w_pt771_partidas_presp_errores
integer width = 544
integer height = 192
integer taborder = 90
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo"
end type

