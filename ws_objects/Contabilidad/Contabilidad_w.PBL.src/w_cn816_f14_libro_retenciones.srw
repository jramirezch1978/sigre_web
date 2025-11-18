$PBExportHeader$w_cn816_f14_libro_retenciones.srw
forward
global type w_cn816_f14_libro_retenciones from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn816_f14_libro_retenciones
end type
type sle_mes from singlelineedit within w_cn816_f14_libro_retenciones
end type
type cb_1 from commandbutton within w_cn816_f14_libro_retenciones
end type
type st_3 from statictext within w_cn816_f14_libro_retenciones
end type
type st_4 from statictext within w_cn816_f14_libro_retenciones
end type
type cbx_fecha from checkbox within w_cn816_f14_libro_retenciones
end type
type gb_1 from groupbox within w_cn816_f14_libro_retenciones
end type
end forward

global type w_cn816_f14_libro_retenciones from w_report_smpl
integer width = 3369
integer height = 1604
string title = "[CN816] Formato 14. Libro de Retenciones"
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
cbx_fecha cbx_fecha
gb_1 gb_1
end type
global w_cn816_f14_libro_retenciones w_cn816_f14_libro_retenciones

on w_cn816_f14_libro_retenciones.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.cbx_fecha=create cbx_fecha
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.cbx_fecha
this.Control[iCurrent+7]=this.gb_1
end on

on w_cn816_f14_libro_retenciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cbx_fecha)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_mensaje, ls_nombre_mes
Long 		ll_ano, ll_mes

ll_ano = long(sle_ano.text)
ll_mes = long(sle_mes.text)

dw_report.retrieve(ll_ano, ll_mes)
//--
CHOOSE CASE ll_mes
			
	  	CASE 0
			  ls_nombre_mes = 'MES CERO'
		CASE 1
			  ls_nombre_mes = 'ENERO'
		CASE 2
			  ls_nombre_mes = 'FEBRERO'
	   CASE 3
			  ls_nombre_mes = 'MARZO'
      CASE 4
			  ls_nombre_mes = 'ABRIL'
		CASE 5
			  ls_nombre_mes = 'MAYO'
	   CASE 6
			  ls_nombre_mes = 'JUNIO'
		CASE 7
			  ls_nombre_mes = 'JULIO'
		CASE 8
			  ls_nombre_mes = 'AGOSTO'
	   CASE 9
			  ls_nombre_mes = 'SEPTIEMBRE'
	   CASE 10
			  ls_nombre_mes = 'OCTUBRE'
		CASE 11
			  ls_nombre_mes = 'NOVIEMBRE'
	   CASE 12
			  ls_nombre_mes = 'DICIEMBRE'
	END CHOOSE
//--
dw_report.object.p_logo.filename 		= gs_logo
dw_report.object.t_user.text     		= gs_user
dw_report.object.t_periodo.text  		= string(ll_ano) + '-' + ls_nombre_mes
dw_report.object.t_ruc.text      		= gnvo_app.empresa.is_ruc
dw_report.object.t_razon_social.text 	= gnvo_app.empresa.is_nom_empresa


end event

event ue_open_pre;call super::ue_open_pre;sle_ano.text = string(f_fecha_Actual(), 'yyyy')
sle_mes.text = string(f_fecha_Actual(), 'mm')
end event

type dw_report from w_report_smpl`dw_report within w_cn816_f14_libro_retenciones
integer x = 0
integer y = 184
integer width = 3291
integer height = 1116
integer taborder = 40
string dataobject = "d_f14_libro_retenciones_tbl"
end type

type sle_ano from singlelineedit within w_cn816_f14_libro_retenciones
integer x = 201
integer y = 76
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
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn816_f14_libro_retenciones
integer x = 576
integer y = 76
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
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cn816_f14_libro_retenciones
integer x = 1527
integer y = 68
integer width = 297
integer height = 92
integer taborder = 30
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

type st_3 from statictext within w_cn816_f14_libro_retenciones
integer x = 411
integer y = 84
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

type st_4 from statictext within w_cn816_f14_libro_retenciones
integer x = 37
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

type cbx_fecha from checkbox within w_cn816_f14_libro_retenciones
integer x = 763
integer y = 72
integer width = 750
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ocultar Fecha de Impresión"
end type

event clicked;if this.checked then
	dw_report.object.t_fecha.visible = '0'
else
	dw_report.object.t_fecha.visible = 'yes'
end if

end event

type gb_1 from groupbox within w_cn816_f14_libro_retenciones
integer width = 745
integer height = 176
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

