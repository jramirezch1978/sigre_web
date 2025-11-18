$PBExportHeader$w_cn709_cntbl_rpt_nro_asiento.srw
forward
global type w_cn709_cntbl_rpt_nro_asiento from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn709_cntbl_rpt_nro_asiento
end type
type sle_mes from singlelineedit within w_cn709_cntbl_rpt_nro_asiento
end type
type cb_1 from commandbutton within w_cn709_cntbl_rpt_nro_asiento
end type
type st_3 from statictext within w_cn709_cntbl_rpt_nro_asiento
end type
type st_4 from statictext within w_cn709_cntbl_rpt_nro_asiento
end type
type sle_origen from singlelineedit within w_cn709_cntbl_rpt_nro_asiento
end type
type sle_libro from singlelineedit within w_cn709_cntbl_rpt_nro_asiento
end type
type sle_asiento from singlelineedit within w_cn709_cntbl_rpt_nro_asiento
end type
type st_1 from statictext within w_cn709_cntbl_rpt_nro_asiento
end type
type st_2 from statictext within w_cn709_cntbl_rpt_nro_asiento
end type
type st_5 from statictext within w_cn709_cntbl_rpt_nro_asiento
end type
type gb_1 from groupbox within w_cn709_cntbl_rpt_nro_asiento
end type
end forward

global type w_cn709_cntbl_rpt_nro_asiento from w_report_smpl
integer width = 3369
integer height = 1604
string title = "Emite Reporte de Asiento Contable (CN709)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
sle_origen sle_origen
sle_libro sle_libro
sle_asiento sle_asiento
st_1 st_1
st_2 st_2
st_5 st_5
gb_1 gb_1
end type
global w_cn709_cntbl_rpt_nro_asiento w_cn709_cntbl_rpt_nro_asiento

type variables
integer  in_origen 
end variables

on w_cn709_cntbl_rpt_nro_asiento.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.sle_origen=create sle_origen
this.sle_libro=create sle_libro
this.sle_asiento=create sle_asiento
this.st_1=create st_1
this.st_2=create st_2
this.st_5=create st_5
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.sle_origen
this.Control[iCurrent+7]=this.sle_libro
this.Control[iCurrent+8]=this.sle_asiento
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.gb_1
end on

on w_cn709_cntbl_rpt_nro_asiento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_origen)
destroy(this.sle_libro)
destroy(this.sle_asiento)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_5)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String  ls_origen, ls_ano, ls_mes, ls_libro, ls_asiento
Integer ln_ano, ln_mes, ln_libro, ln_asiento

ls_origen  = String(sle_origen.text)
ln_ano 	  = Integer(sle_ano.text)
ln_mes     = Integer(sle_mes.text)
ln_libro   = Integer(sle_libro.text)
ln_asiento = Integer(sle_asiento.text)

dw_report.retrieve(ls_origen, ln_ano, ln_mes, ln_libro, ln_asiento)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user


end event

event ue_open_pre;call super::ue_open_pre;str_parametros lstr_rep
lstr_rep = message.powerobjectparm
	
if lstr_rep.bol_origen = true then

	sle_origen.text =  lstr_rep.string1
	sle_ano.text    =  lstr_rep.string2
	sle_mes.text    =  lstr_rep.string3
	sle_libro.text  =  lstr_rep.string4
	sle_asiento.text=  lstr_rep.string5
	this.Event ue_retrieve()

end if

end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event activate;call super::activate;//String  ls_origen, ls_ano, ls_mes, ls_libro, ls_asiento
//Integer ln_ano, ln_mes, ln_libro, ln_asiento
//
//
//str_parametros lstr_rep
//lstr_rep = message.powerobjectparm
//
//sle_origen.text =  lstr_rep.string1
//sle_ano.text    =  lstr_rep.string2
//sle_mes.text    =  lstr_rep.string3
//sle_libro.text  =  lstr_rep.string4
//sle_asiento.text=  lstr_rep.string5
//
//ls_origen  = String(sle_origen.text)
//ls_ano 	  = String(sle_ano.text)
//ls_mes     = String(sle_mes.text)
//ls_libro   = String(sle_libro.text)
//ls_asiento = String(sle_asiento.text)
//
//ln_ano 	  = Integer(ls_ano)
//ln_mes     = Integer(ls_mes)
//ln_libro   = Integer(ls_libro)
//ln_asiento = Integer(ls_asiento)
//
//DECLARE pb_usp_cntbl_rpt_nro_asiento PROCEDURE FOR USP_CNTBL_RPT_NRO_ASIENTO
//        ( :ls_origen, :ln_ano, :ln_mes, :ln_libro, :ln_asiento ) ;
//Execute pb_usp_cntbl_rpt_nro_asiento ;
//
//dw_report.retrieve()
//
//dw_report.object.p_logo.filename = gs_logo
//dw_report.object.t_nombre.text = gs_empresa
//dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn709_cntbl_rpt_nro_asiento
integer x = 23
integer y = 312
integer width = 3291
integer height = 1092
integer taborder = 70
string dataobject = "d_rpt_nro_asiento_tbl"
end type

type sle_ano from singlelineedit within w_cn709_cntbl_rpt_nro_asiento
integer x = 965
integer y = 140
integer width = 192
integer height = 72
integer taborder = 20
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

type sle_mes from singlelineedit within w_cn709_cntbl_rpt_nro_asiento
integer x = 1362
integer y = 140
integer width = 105
integer height = 72
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

type cb_1 from commandbutton within w_cn709_cntbl_rpt_nro_asiento
integer x = 2898
integer y = 128
integer width = 297
integer height = 92
integer taborder = 60
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

type st_3 from statictext within w_cn709_cntbl_rpt_nro_asiento
integer x = 1189
integer y = 148
integer width = 160
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

type st_4 from statictext within w_cn709_cntbl_rpt_nro_asiento
integer x = 795
integer y = 148
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

type sle_origen from singlelineedit within w_cn709_cntbl_rpt_nro_asiento
integer x = 631
integer y = 140
integer width = 137
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type sle_libro from singlelineedit within w_cn709_cntbl_rpt_nro_asiento
integer x = 1815
integer y = 140
integer width = 192
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

type sle_asiento from singlelineedit within w_cn709_cntbl_rpt_nro_asiento
integer x = 2414
integer y = 140
integer width = 343
integer height = 72
integer taborder = 50
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

type st_1 from statictext within w_cn709_cntbl_rpt_nro_asiento
integer x = 411
integer y = 148
integer width = 201
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
string text = "Origen"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn709_cntbl_rpt_nro_asiento
integer x = 1518
integer y = 148
integer width = 279
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
string text = "Nro. Libro"
boolean focusrectangle = false
end type

type st_5 from statictext within w_cn709_cntbl_rpt_nro_asiento
integer x = 2057
integer y = 148
integer width = 343
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
string text = "Nro. Asiento"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn709_cntbl_rpt_nro_asiento
integer x = 352
integer y = 64
integer width = 2478
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Ingrese Datos Para Imprimir Asiento  "
end type

