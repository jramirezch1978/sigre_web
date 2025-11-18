$PBExportHeader$w_cn788_cxp_dif_tasa_cambio.srw
forward
global type w_cn788_cxp_dif_tasa_cambio from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn788_cxp_dif_tasa_cambio
end type
type sle_mes_ini from singlelineedit within w_cn788_cxp_dif_tasa_cambio
end type
type cb_1 from commandbutton within w_cn788_cxp_dif_tasa_cambio
end type
type st_2 from statictext within w_cn788_cxp_dif_tasa_cambio
end type
type st_3 from statictext within w_cn788_cxp_dif_tasa_cambio
end type
type st_1 from statictext within w_cn788_cxp_dif_tasa_cambio
end type
type sle_mes_fin from singlelineedit within w_cn788_cxp_dif_tasa_cambio
end type
type gb_1 from groupbox within w_cn788_cxp_dif_tasa_cambio
end type
end forward

global type w_cn788_cxp_dif_tasa_cambio from w_report_smpl
integer width = 3191
integer height = 2060
string title = "[CN788] Saldos de cuenta corriente x grupo de codigos"
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
sle_mes_ini sle_mes_ini
cb_1 cb_1
st_2 st_2
st_3 st_3
st_1 st_1
sle_mes_fin sle_mes_fin
gb_1 gb_1
end type
global w_cn788_cxp_dif_tasa_cambio w_cn788_cxp_dif_tasa_cambio

on w_cn788_cxp_dif_tasa_cambio.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes_ini=create sle_mes_ini
this.cb_1=create cb_1
this.st_2=create st_2
this.st_3=create st_3
this.st_1=create st_1
this.sle_mes_fin=create sle_mes_fin
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes_ini
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.sle_mes_fin
this.Control[iCurrent+8]=this.gb_1
end on

on w_cn788_cxp_dif_tasa_cambio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes_ini)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.sle_mes_fin)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Long ll_ano, ll_mes_ini, ll_mes_fin, ll_libro
String ls_dolares

ll_ano = Long(sle_ano.text)
ll_mes_ini = Long(sle_mes_ini.text)
ll_mes_fin = Long(sle_mes_fin.text)

SELECT cod_dolares INTO :ls_dolares FROM logparam WHERE reckey='1' ;
SELECT libro_compras INTO :ll_libro FROM finparam WHERE reckey='1' ;

dw_report.retrieve(ll_ano, ll_mes_ini, ll_mes_fin, ls_dolares, ll_libro)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_texto.text = 'Año:' + string(ll_ano)+' Mes Ini:' + string(ll_mes_ini) + ' Mes Fin:' + string(ll_mes_fin)
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn788_cxp_dif_tasa_cambio
integer x = 0
integer y = 232
integer width = 987
integer height = 1576
string dataobject = "d_rpt_dif_tasa_camb_cxp_tbl"
end type

type sle_ano from singlelineedit within w_cn788_cxp_dif_tasa_cambio
integer x = 229
integer y = 80
integer width = 183
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes_ini from singlelineedit within w_cn788_cxp_dif_tasa_cambio
integer x = 695
integer y = 80
integer width = 123
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cn788_cxp_dif_tasa_cambio
integer x = 1353
integer y = 68
integer width = 288
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;string  ls_grupo, ls_ano, ls_mes
Long ll_count

parent.event ue_preview()
dw_report.SetTransObject(sqlca)
dw_report.visible=true

parent.event ue_retrieve()

end event

type st_2 from statictext within w_cn788_cxp_dif_tasa_cambio
integer x = 87
integer y = 92
integer width = 133
integer height = 80
boolean bringtotop = true
integer textsize = -8
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

type st_3 from statictext within w_cn788_cxp_dif_tasa_cambio
integer x = 475
integer y = 92
integer width = 206
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
string text = "Mes Ini:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn788_cxp_dif_tasa_cambio
integer x = 878
integer y = 96
integer width = 219
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
string text = "Mes Fin:"
boolean focusrectangle = false
end type

type sle_mes_fin from singlelineedit within w_cn788_cxp_dif_tasa_cambio
integer x = 1129
integer y = 80
integer width = 123
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_cn788_cxp_dif_tasa_cambio
integer x = 32
integer y = 20
integer width = 1275
integer height = 192
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

