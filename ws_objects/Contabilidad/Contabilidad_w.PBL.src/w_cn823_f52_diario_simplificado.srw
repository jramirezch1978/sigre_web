$PBExportHeader$w_cn823_f52_diario_simplificado.srw
forward
global type w_cn823_f52_diario_simplificado from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn823_f52_diario_simplificado
end type
type sle_mes from singlelineedit within w_cn823_f52_diario_simplificado
end type
type cb_1 from commandbutton within w_cn823_f52_diario_simplificado
end type
type st_3 from statictext within w_cn823_f52_diario_simplificado
end type
type st_4 from statictext within w_cn823_f52_diario_simplificado
end type
type cbx_fecha from checkbox within w_cn823_f52_diario_simplificado
end type
type st_1 from statictext within w_cn823_f52_diario_simplificado
end type
type sle_nivel from singlelineedit within w_cn823_f52_diario_simplificado
end type
type gb_1 from groupbox within w_cn823_f52_diario_simplificado
end type
end forward

global type w_cn823_f52_diario_simplificado from w_report_smpl
integer width = 3936
integer height = 2264
string title = "[CN823] Formato 5.2 Libro Diario Simplificado"
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
cbx_fecha cbx_fecha
st_1 st_1
sle_nivel sle_nivel
gb_1 gb_1
end type
global w_cn823_f52_diario_simplificado w_cn823_f52_diario_simplificado

on w_cn823_f52_diario_simplificado.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.cbx_fecha=create cbx_fecha
this.st_1=create st_1
this.sle_nivel=create sle_nivel
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.cbx_fecha
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.sle_nivel
this.Control[iCurrent+9]=this.gb_1
end on

on w_cn823_f52_diario_simplificado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cbx_fecha)
destroy(this.st_1)
destroy(this.sle_nivel)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_mensaje, ls_nombre_mes
Long 		ll_ano, ll_mes, ll_nivel

ll_ano 	= long(sle_ano.text)
ll_mes 	= long(sle_mes.text)
ll_nivel = long(sle_nivel.text)

//--
CHOOSE CASE ll_nivel
			
	  	CASE 1
			  ll_nivel = 2
		CASE 2
			  ll_nivel = 3
		CASE 3
			  ll_nivel = 5
	   CASE 4
			  ll_nivel = 6
      CASE 5
			  ll_nivel = 8
END CHOOSE
//--


dw_report.object.DataWindow.print.Orientation = 1
dw_report.object.DataWindow.print.Paper.Size = 9

dw_report.retrieve(ll_ano, ll_mes, ll_nivel)
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

type dw_report from w_report_smpl`dw_report within w_cn823_f52_diario_simplificado
integer x = 0
integer y = 184
integer width = 3790
integer height = 1780
integer taborder = 40
string dataobject = "d_f52_diario_simplificado_cmp"
end type

type sle_ano from singlelineedit within w_cn823_f52_diario_simplificado
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

type sle_mes from singlelineedit within w_cn823_f52_diario_simplificado
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

type cb_1 from commandbutton within w_cn823_f52_diario_simplificado
integer x = 2706
integer y = 60
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

type st_3 from statictext within w_cn823_f52_diario_simplificado
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

type st_4 from statictext within w_cn823_f52_diario_simplificado
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

type cbx_fecha from checkbox within w_cn823_f52_diario_simplificado
integer x = 1769
integer y = 60
integer width = 891
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
	dw_report.object.fecha_t.visible = '0'
else
	dw_report.object.fecha_t.visible = 'yes'
end if

end event

type st_1 from statictext within w_cn823_f52_diario_simplificado
integer x = 709
integer y = 84
integer width = 334
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
string text = "Nivel Cuenta:"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_nivel from singlelineedit within w_cn823_f52_diario_simplificado
integer x = 1051
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
string text = "1"
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_cn823_f52_diario_simplificado
integer width = 1221
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

