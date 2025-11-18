$PBExportHeader$w_cn715_cntbl_rpt_mayor_cencos.srw
forward
global type w_cn715_cntbl_rpt_mayor_cencos from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn715_cntbl_rpt_mayor_cencos
end type
type sle_mes from singlelineedit within w_cn715_cntbl_rpt_mayor_cencos
end type
type cb_1 from commandbutton within w_cn715_cntbl_rpt_mayor_cencos
end type
type st_3 from statictext within w_cn715_cntbl_rpt_mayor_cencos
end type
type st_4 from statictext within w_cn715_cntbl_rpt_mayor_cencos
end type
type rb_1 from radiobutton within w_cn715_cntbl_rpt_mayor_cencos
end type
type rb_2 from radiobutton within w_cn715_cntbl_rpt_mayor_cencos
end type
type sle_cencos_desde from singlelineedit within w_cn715_cntbl_rpt_mayor_cencos
end type
type sle_cencos_hasta from singlelineedit within w_cn715_cntbl_rpt_mayor_cencos
end type
type st_1 from statictext within w_cn715_cntbl_rpt_mayor_cencos
end type
type st_2 from statictext within w_cn715_cntbl_rpt_mayor_cencos
end type
type cbx_1 from checkbox within w_cn715_cntbl_rpt_mayor_cencos
end type
type gb_1 from groupbox within w_cn715_cntbl_rpt_mayor_cencos
end type
type gb_2 from groupbox within w_cn715_cntbl_rpt_mayor_cencos
end type
type gb_3 from groupbox within w_cn715_cntbl_rpt_mayor_cencos
end type
end forward

global type w_cn715_cntbl_rpt_mayor_cencos from w_report_smpl
integer width = 3511
integer height = 1604
string title = "[CN715] Detalle del Mayor General por Centros de Costos"
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
rb_1 rb_1
rb_2 rb_2
sle_cencos_desde sle_cencos_desde
sle_cencos_hasta sle_cencos_hasta
st_1 st_1
st_2 st_2
cbx_1 cbx_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_cn715_cntbl_rpt_mayor_cencos w_cn715_cntbl_rpt_mayor_cencos

on w_cn715_cntbl_rpt_mayor_cencos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.sle_cencos_desde=create sle_cencos_desde
this.sle_cencos_hasta=create sle_cencos_hasta
this.st_1=create st_1
this.st_2=create st_2
this.cbx_1=create cbx_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.sle_cencos_desde
this.Control[iCurrent+9]=this.sle_cencos_hasta
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.cbx_1
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_3
end on

on w_cn715_cntbl_rpt_mayor_cencos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.sle_cencos_desde)
destroy(this.sle_cencos_hasta)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;String  ls_opcion, ls_cencos2, ls_cencos1
Integer li_count, li_year, li_mes

If rb_1.checked = true then
	ls_opcion = '1'
Elseif rb_2.checked = true then
	ls_opcion = '2'
End if

ls_cencos1 = String(sle_cencos_desde.text)
ls_cencos2 = String(sle_cencos_hasta.text)

If rb_1.checked = true then

	//  Verifica que centro de costo desde exista
	Select count(cencos)
	  Into :li_count
	  From centros_costo
	  Where cencos = :ls_cencos1;
  
	If li_count = 0 then
		MessageBox('Error','El centros de costo ' + ls_cencos1 + ' No Existe, verifique!', StopSign!)
	End if

	//  Verifica que centro de costo hasta exista
	Select count(cencos)
	  Into :li_count
	  From centros_costo
	  Where cencos = :ls_cencos2 ;
	  
	If li_count = 0 then
		MessageBox('Error','El centros de costo ' + ls_cencos2 + ' No Existe, verifique!', StopSign!)
	End if

End if

li_year 	= Integer(sle_ano.text)
li_mes 	= Integer(sle_mes.text)

dw_report.retrieve(li_year, li_mes, ls_opcion, ls_cencos1, ls_cencos2 )

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text 	= gs_empresa
dw_report.object.t_user.text 		= gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn715_cntbl_rpt_mayor_cencos
integer x = 0
integer y = 236
integer width = 3287
integer height = 1100
integer taborder = 80
string dataobject = "d_cntbl_mayor_cencos"
end type

type sle_ano from singlelineedit within w_cn715_cntbl_rpt_mayor_cencos
integer x = 2071
integer y = 92
integer width = 192
integer height = 72
integer taborder = 50
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

type sle_mes from singlelineedit within w_cn715_cntbl_rpt_mayor_cencos
integer x = 2446
integer y = 92
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
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cn715_cntbl_rpt_mayor_cencos
integer x = 3099
integer y = 76
integer width = 297
integer height = 92
integer taborder = 70
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

type st_3 from statictext within w_cn715_cntbl_rpt_mayor_cencos
integer x = 2281
integer y = 100
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
long backcolor = 67108864
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn715_cntbl_rpt_mayor_cencos
integer x = 1906
integer y = 100
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

type rb_1 from radiobutton within w_cn715_cntbl_rpt_mayor_cencos
integer x = 69
integer y = 64
integer width = 521
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
string text = "Centro de Costo"
borderstyle borderstyle = styleraised!
end type

event clicked;if rb_1.checked = true then
	sle_cencos_desde.enabled = true
	sle_cencos_hasta.enabled = true
end if

end event

type rb_2 from radiobutton within w_cn715_cntbl_rpt_mayor_cencos
integer x = 69
integer y = 132
integer width = 521
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
string text = "Todos"
borderstyle borderstyle = styleraised!
end type

event clicked;if rb_2.checked = true then
	sle_cencos_desde.enabled = false
	sle_cencos_hasta.enabled = false
	sle_cencos_desde.text = ' '
	sle_cencos_hasta.text = ' '
end if

end event

type sle_cencos_desde from singlelineedit within w_cn715_cntbl_rpt_mayor_cencos
integer x = 951
integer y = 92
integer width = 306
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

type sle_cencos_hasta from singlelineedit within w_cn715_cntbl_rpt_mayor_cencos
integer x = 1458
integer y = 92
integer width = 306
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

type st_1 from statictext within w_cn715_cntbl_rpt_mayor_cencos
integer x = 745
integer y = 100
integer width = 197
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Desde"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn715_cntbl_rpt_mayor_cencos
integer x = 1280
integer y = 100
integer width = 174
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Hasta"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_cn715_cntbl_rpt_mayor_cencos
integer x = 2633
integer y = 84
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

type gb_1 from groupbox within w_cn715_cntbl_rpt_mayor_cencos
integer x = 1870
integer y = 16
integer width = 745
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
borderstyle borderstyle = styleraised!
end type

type gb_2 from groupbox within w_cn715_cntbl_rpt_mayor_cencos
integer x = 695
integer y = 16
integer width = 1129
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Seleccione Centros de Costos "
borderstyle borderstyle = styleraised!
end type

type gb_3 from groupbox within w_cn715_cntbl_rpt_mayor_cencos
integer width = 654
integer height = 224
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = " Elija Opción "
borderstyle borderstyle = styleraised!
end type

