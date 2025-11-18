$PBExportHeader$w_cn744_rpt_res_activo_fijo.srw
forward
global type w_cn744_rpt_res_activo_fijo from w_report_smpl
end type
type cb_1 from commandbutton within w_cn744_rpt_res_activo_fijo
end type
type sle_ano from singlelineedit within w_cn744_rpt_res_activo_fijo
end type
type sle_mes from singlelineedit within w_cn744_rpt_res_activo_fijo
end type
type st_10 from statictext within w_cn744_rpt_res_activo_fijo
end type
type st_11 from statictext within w_cn744_rpt_res_activo_fijo
end type
type gb_12 from groupbox within w_cn744_rpt_res_activo_fijo
end type
end forward

global type w_cn744_rpt_res_activo_fijo from w_report_smpl
integer width = 3735
integer height = 1564
string title = "Resumen Cta. Contable de Articulo Mensual (CN744)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
sle_ano sle_ano
sle_mes sle_mes
st_10 st_10
st_11 st_11
gb_12 gb_12
end type
global w_cn744_rpt_res_activo_fijo w_cn744_rpt_res_activo_fijo

on w_cn744_rpt_res_activo_fijo.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.st_10=create st_10
this.st_11=create st_11
this.gb_12=create gb_12
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_ano
this.Control[iCurrent+3]=this.sle_mes
this.Control[iCurrent+4]=this.st_10
this.Control[iCurrent+5]=this.st_11
this.Control[iCurrent+6]=this.gb_12
end on

on w_cn744_rpt_res_activo_fijo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.st_10)
destroy(this.st_11)
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

DECLARE PB_usp_cnt_saldo_mensual_cntbl PROCEDURE FOR usp_cnt_saldo_mensual_cntbl
		  ( :ll_ano, :ll_mes ) ;
Execute PB_usp_cnt_saldo_mensual_cntbl ;


//USP_cnt_res_activo_fijo
//if cbx_1.checked = true  then
//	ls_almacen= '%'
//else
//	ls_almacen = dw_almacen.object.almacen [dw_almacen.getrow()]
//end if
//ls_almacen
dw_report.retrieve()

SetPointer(Arrow!)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_texto.text    = ls_texto
dw_report.object.t_user.text     = gs_user

end event

event ue_open_pre;call super::ue_open_pre;//dw_almacen.SetTransObject(sqlca)
//dw_almacen.retrieve()
end event

type dw_report from w_report_smpl`dw_report within w_cn744_rpt_res_activo_fijo
integer x = 9
integer y = 256
integer width = 3657
integer height = 1096
integer taborder = 90
string dataobject = "d_rpt_libro_res_activo_fijo_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;if row = 0 then return

string ls_cnta

ls_cnta = string(this.object.cta_contb[row])

str_parametros lstr_parametros

lstr_parametros.string1 = sle_ano.text
lstr_parametros.string2 = sle_mes.text
lstr_parametros.string3 = ls_cnta

setpointer(HourGlass!)

opensheetwithparm(w_cn744_rpt_res_activo_fijo_det,lstr_parametros,parent,1,Layered!)
end event

type cb_1 from commandbutton within w_cn744_rpt_res_activo_fijo
integer x = 992
integer y = 100
integer width = 297
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

type sle_ano from singlelineedit within w_cn744_rpt_res_activo_fijo
integer x = 270
integer y = 104
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

type sle_mes from singlelineedit within w_cn744_rpt_res_activo_fijo
integer x = 805
integer y = 104
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

type st_10 from statictext within w_cn744_rpt_res_activo_fijo
integer x = 558
integer y = 112
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
long backcolor = 12632256
string text = "Mes:"
boolean focusrectangle = false
end type

type st_11 from statictext within w_cn744_rpt_res_activo_fijo
integer x = 101
integer y = 112
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
long backcolor = 12632256
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_12 from groupbox within w_cn744_rpt_res_activo_fijo
integer x = 69
integer y = 28
integer width = 1266
integer height = 196
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

