$PBExportHeader$w_gxc_rpt_libro_gastos_campos.srw
forward
global type w_gxc_rpt_libro_gastos_campos from w_report_smpl
end type
type sle_ano from singlelineedit within w_gxc_rpt_libro_gastos_campos
end type
type sle_mes from singlelineedit within w_gxc_rpt_libro_gastos_campos
end type
type cb_1 from commandbutton within w_gxc_rpt_libro_gastos_campos
end type
type st_3 from statictext within w_gxc_rpt_libro_gastos_campos
end type
type st_4 from statictext within w_gxc_rpt_libro_gastos_campos
end type
type st_1 from statictext within w_gxc_rpt_libro_gastos_campos
end type
type sle_campo_desde from singlelineedit within w_gxc_rpt_libro_gastos_campos
end type
type sle_campo_hasta from singlelineedit within w_gxc_rpt_libro_gastos_campos
end type
type cb_2 from commandbutton within w_gxc_rpt_libro_gastos_campos
end type
type cb_3 from commandbutton within w_gxc_rpt_libro_gastos_campos
end type
type st_2 from statictext within w_gxc_rpt_libro_gastos_campos
end type
type st_5 from statictext within w_gxc_rpt_libro_gastos_campos
end type
type gb_1 from groupbox within w_gxc_rpt_libro_gastos_campos
end type
type gb_2 from groupbox within w_gxc_rpt_libro_gastos_campos
end type
end forward

global type w_gxc_rpt_libro_gastos_campos from w_report_smpl
integer width = 3369
integer height = 1604
string title = "Gastos por Campos"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
st_1 st_1
sle_campo_desde sle_campo_desde
sle_campo_hasta sle_campo_hasta
cb_2 cb_2
cb_3 cb_3
st_2 st_2
st_5 st_5
gb_1 gb_1
gb_2 gb_2
end type
global w_gxc_rpt_libro_gastos_campos w_gxc_rpt_libro_gastos_campos

on w_gxc_rpt_libro_gastos_campos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.st_1=create st_1
this.sle_campo_desde=create sle_campo_desde
this.sle_campo_hasta=create sle_campo_hasta
this.cb_2=create cb_2
this.cb_3=create cb_3
this.st_2=create st_2
this.st_5=create st_5
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.sle_campo_desde
this.Control[iCurrent+8]=this.sle_campo_hasta
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.cb_3
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_gxc_rpt_libro_gastos_campos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.sle_campo_desde)
destroy(this.sle_campo_hasta)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.st_2)
destroy(this.st_5)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String ls_ano, ls_mes, ls_desde, ls_hasta
ls_ano   = String(sle_ano.text)
ls_mes   = String(sle_mes.text)
ls_desde = String(sle_campo_desde.text)
ls_hasta = String(sle_campo_hasta.text)

DECLARE pb_usp_gxc_rpt_libro_mes PROCEDURE FOR USP_GXC_RPT_LIBRO_MES
        ( :ls_ano, :ls_mes, :ls_desde, :ls_hasta ) ;
Execute pb_usp_gxc_rpt_libro_mes ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_gxc_rpt_libro_gastos_campos
integer x = 23
integer y = 440
integer width = 3287
integer height = 964
integer taborder = 60
string dataobject = "d_gxc_rpt_libro_mes_tbl"
end type

type sle_ano from singlelineedit within w_gxc_rpt_libro_gastos_campos
integer x = 745
integer y = 268
integer width = 192
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
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_gxc_rpt_libro_gastos_campos
integer x = 1166
integer y = 268
integer width = 105
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
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_gxc_rpt_libro_gastos_campos
integer x = 2848
integer y = 252
integer width = 297
integer height = 92
integer taborder = 50
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

type st_3 from statictext within w_gxc_rpt_libro_gastos_campos
integer x = 969
integer y = 276
integer width = 178
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_gxc_rpt_libro_gastos_campos
integer x = 539
integer y = 276
integer width = 174
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_gxc_rpt_libro_gastos_campos
integer x = 704
integer y = 56
integer width = 2254
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 12632256
string text = "MOVIMIENTO MENSUAL DEL LIBRO DE GASTOS POR CAMPOS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type sle_campo_desde from singlelineedit within w_gxc_rpt_libro_gastos_campos
integer x = 1687
integer y = 268
integer width = 283
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_campo_hasta from singlelineedit within w_gxc_rpt_libro_gastos_campos
integer x = 2290
integer y = 268
integer width = 283
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_gxc_rpt_libro_gastos_campos
integer x = 1998
integer y = 268
integer width = 87
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_gxc_rpt_campo_zona_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_campo_desde.text = sl_param.field_ret[1]
END IF

end event

type cb_3 from commandbutton within w_gxc_rpt_libro_gastos_campos
integer x = 2601
integer y = 268
integer width = 87
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_gxc_rpt_campo_zona_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_campo_hasta.text = sl_param.field_ret[1]
END IF

end event

type st_2 from statictext within w_gxc_rpt_libro_gastos_campos
integer x = 1490
integer y = 276
integer width = 183
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Desde"
boolean focusrectangle = false
end type

type st_5 from statictext within w_gxc_rpt_libro_gastos_campos
integer x = 2121
integer y = 276
integer width = 160
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Hasta"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_gxc_rpt_libro_gastos_campos
integer x = 507
integer y = 192
integer width = 823
integer height = 192
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Periodo Contable "
end type

type gb_2 from groupbox within w_gxc_rpt_libro_gastos_campos
integer x = 1426
integer y = 192
integer width = 1339
integer height = 192
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Seleccione Administración y Zona "
end type

