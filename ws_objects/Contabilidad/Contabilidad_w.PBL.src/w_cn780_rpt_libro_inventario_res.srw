$PBExportHeader$w_cn780_rpt_libro_inventario_res.srw
forward
global type w_cn780_rpt_libro_inventario_res from w_report_smpl
end type
type cb_1 from commandbutton within w_cn780_rpt_libro_inventario_res
end type
type sle_ano from singlelineedit within w_cn780_rpt_libro_inventario_res
end type
type sle_mes from singlelineedit within w_cn780_rpt_libro_inventario_res
end type
type st_10 from statictext within w_cn780_rpt_libro_inventario_res
end type
type st_11 from statictext within w_cn780_rpt_libro_inventario_res
end type
type dw_almacen from datawindow within w_cn780_rpt_libro_inventario_res
end type
type st_1 from statictext within w_cn780_rpt_libro_inventario_res
end type
type cbx_1 from checkbox within w_cn780_rpt_libro_inventario_res
end type
type cbx_2 from checkbox within w_cn780_rpt_libro_inventario_res
end type
type gb_12 from groupbox within w_cn780_rpt_libro_inventario_res
end type
end forward

global type w_cn780_rpt_libro_inventario_res from w_report_smpl
integer width = 3479
integer height = 1604
string title = "Libro de inventario resumen (CN780)"
string menuname = "m_abc_report_smpl"
boolean righttoleft = true
cb_1 cb_1
sle_ano sle_ano
sle_mes sle_mes
st_10 st_10
st_11 st_11
dw_almacen dw_almacen
st_1 st_1
cbx_1 cbx_1
cbx_2 cbx_2
gb_12 gb_12
end type
global w_cn780_rpt_libro_inventario_res w_cn780_rpt_libro_inventario_res

on w_cn780_rpt_libro_inventario_res.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.st_10=create st_10
this.st_11=create st_11
this.dw_almacen=create dw_almacen
this.st_1=create st_1
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.gb_12=create gb_12
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_ano
this.Control[iCurrent+3]=this.sle_mes
this.Control[iCurrent+4]=this.st_10
this.Control[iCurrent+5]=this.st_11
this.Control[iCurrent+6]=this.dw_almacen
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.cbx_1
this.Control[iCurrent+9]=this.cbx_2
this.Control[iCurrent+10]=this.gb_12
end on

on w_cn780_rpt_libro_inventario_res.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.dw_almacen)
destroy(this.st_1)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.gb_12)
end on

event ue_retrieve;call super::ue_retrieve;String ls_ano, ls_mes, ls_texto, ls_almacen
Long ll_ano, ll_mes

ls_ano = String(sle_ano.text)
ls_mes = String(sle_mes.text)
ll_ano = LONG( ls_ano )
ll_mes = LONG( ls_mes )
ls_texto = 'Año ' + ls_ano + ' - Mes ' + ls_mes

SetPointer(HourGlass!)

DECLARE PB_USP_CNT_RPT_LIBRO_INVENT_RES1 PROCEDURE FOR USP_CNT_RPT_LIBRO_INVENT_RES1
		  ( :ll_ano, :ll_mes ) ;
Execute PB_USP_CNT_RPT_LIBRO_INVENT_RES1 ;


if cbx_1.checked = true  then
	ls_almacen= '%'
else
	ls_almacen = dw_almacen.object.almacen [dw_almacen.getrow()]
end if

dw_report.retrieve(ls_almacen)

SetPointer(Arrow!)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_texto.text    = ls_texto
dw_report.object.t_user.text     = gs_user

end event

event ue_open_pre;call super::ue_open_pre;dw_almacen.SetTransObject(sqlca)
dw_almacen.retrieve()
end event

type dw_report from w_report_smpl`dw_report within w_cn780_rpt_libro_inventario_res
integer x = 0
integer y = 208
integer width = 3406
integer height = 1096
integer taborder = 90
string dataobject = "d_rpt_libro_inventario_resumen_tbl"
end type

type cb_1 from commandbutton within w_cn780_rpt_libro_inventario_res
integer x = 2793
integer y = 68
integer width = 315
integer height = 92
integer taborder = 80
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

type sle_ano from singlelineedit within w_cn780_rpt_libro_inventario_res
integer x = 201
integer y = 76
integer width = 192
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn780_rpt_libro_inventario_res
integer x = 686
integer y = 76
integer width = 105
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_10 from statictext within w_cn780_rpt_libro_inventario_res
integer x = 489
integer y = 84
integer width = 169
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
string text = "Mes:"
boolean focusrectangle = false
end type

type st_11 from statictext within w_cn780_rpt_libro_inventario_res
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
string text = "Año :"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_almacen from datawindow within w_cn780_rpt_libro_inventario_res
integer x = 1129
integer y = 68
integer width = 846
integer height = 88
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_almacen"
boolean border = false
boolean livescroll = true
end type

type st_1 from statictext within w_cn780_rpt_libro_inventario_res
integer x = 855
integer y = 84
integer width = 265
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen :"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_cn780_rpt_libro_inventario_res
integer x = 2030
integer y = 80
integer width = 293
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if cbx_1.checked = true then 

dw_almacen.enabled=false
else

dw_almacen.enabled=true

end if
end event

type cbx_2 from checkbox within w_cn780_rpt_libro_inventario_res
integer x = 2309
integer y = 80
integer width = 462
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
string text = "Mostrar Fecha"
boolean checked = true
end type

event clicked;if cbx_1.checked then
	dw_report.object.t_fecha.visible = '1'
else
	dw_report.object.t_fecha.visible = '0'
end if
end event

type gb_12 from groupbox within w_cn780_rpt_libro_inventario_res
integer width = 3168
integer height = 200
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
end type

