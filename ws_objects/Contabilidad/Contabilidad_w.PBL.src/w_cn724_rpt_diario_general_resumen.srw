$PBExportHeader$w_cn724_rpt_diario_general_resumen.srw
forward
global type w_cn724_rpt_diario_general_resumen from w_report_smpl
end type
type cb_1 from commandbutton within w_cn724_rpt_diario_general_resumen
end type
type sle_ano from singlelineedit within w_cn724_rpt_diario_general_resumen
end type
type sle_mes from singlelineedit within w_cn724_rpt_diario_general_resumen
end type
type st_10 from statictext within w_cn724_rpt_diario_general_resumen
end type
type st_11 from statictext within w_cn724_rpt_diario_general_resumen
end type
type gb_12 from groupbox within w_cn724_rpt_diario_general_resumen
end type
end forward

global type w_cn724_rpt_diario_general_resumen from w_report_smpl
integer width = 3529
integer height = 2044
string title = "Diario mensual resumen (CN724)"
string menuname = "m_abc_report_smpl"
cb_1 cb_1
sle_ano sle_ano
sle_mes sle_mes
st_10 st_10
st_11 st_11
gb_12 gb_12
end type
global w_cn724_rpt_diario_general_resumen w_cn724_rpt_diario_general_resumen

on w_cn724_rpt_diario_general_resumen.create
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

on w_cn724_rpt_diario_general_resumen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.gb_12)
end on

event ue_retrieve;call super::ue_retrieve;String ls_ano, ls_mes, ls_nombre_mes
Integer li_ano, li_mes

ls_ano = String(sle_ano.text)
ls_mes = String(sle_mes.text)

li_ano = Integer(ls_ano)
li_mes = Integer(ls_mes)

//--
CHOOSE CASE li_mes
			
	  	CASE 0
			  ls_nombre_mes = 'MES CERO'
		CASE 1
			  ls_nombre_mes = '01 ENERO'
		CASE 2
			  ls_nombre_mes = '02 FEBRERO'
	   CASE 3
			  ls_nombre_mes = '03 MARZO'
      CASE 4
			  ls_nombre_mes = '04 ABRIL'
		CASE 5
			  ls_nombre_mes = '05 MAYO'
	   CASE 6
			  ls_nombre_mes = '06 JUNIO'
		CASE 7
			  ls_nombre_mes = '07 JULIO'
		CASE 8
			  ls_nombre_mes = '08 AGOSTO'
	   CASE 9
			  ls_nombre_mes = '09 SEPTIEMBRE'
	   CASE 10
			  ls_nombre_mes = '10 OCTUBRE'
		CASE 11
			  ls_nombre_mes = '11 NOVIEMBRE'
	   CASE 12
			  ls_nombre_mes = '12 DICIEMBRE'
	END CHOOSE
//--

dw_report.retrieve(li_ano, li_mes)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_texto.text = 'Año: ' + ls_ano + '  Mes: ' + ls_nombre_mes
dw_report.object.t_ruc.text = gs_ruc

end event

event ue_open_pre;call super::ue_open_pre;sle_ano.text = String(today(), 'yyyy')
sle_mes.text = String(today(), 'mm')
end event

type dw_report from w_report_smpl`dw_report within w_cn724_rpt_diario_general_resumen
integer x = 0
integer y = 212
integer width = 3406
integer height = 1484
integer taborder = 90
string dataobject = "d_rpt_diario_general_resumen_tbl"
end type

type cb_1 from commandbutton within w_cn724_rpt_diario_general_resumen
integer x = 1001
integer y = 60
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

type sle_ano from singlelineedit within w_cn724_rpt_diario_general_resumen
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
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn724_rpt_diario_general_resumen
integer x = 736
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
borderstyle borderstyle = stylelowered!
end type

type st_10 from statictext within w_cn724_rpt_diario_general_resumen
integer x = 416
integer y = 84
integer width = 293
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
string text = "Mes Desde"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_11 from statictext within w_cn724_rpt_diario_general_resumen
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
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_12 from groupbox within w_cn724_rpt_diario_general_resumen
integer width = 901
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
end type

