$PBExportHeader$w_cn755_detalle_asientos_periodo.srw
forward
global type w_cn755_detalle_asientos_periodo from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn755_detalle_asientos_periodo
end type
type cb_1 from commandbutton within w_cn755_detalle_asientos_periodo
end type
type st_4 from statictext within w_cn755_detalle_asientos_periodo
end type
type st_1 from statictext within w_cn755_detalle_asientos_periodo
end type
type sle_mes1 from singlelineedit within w_cn755_detalle_asientos_periodo
end type
type st_2 from statictext within w_cn755_detalle_asientos_periodo
end type
type sle_mes2 from singlelineedit within w_cn755_detalle_asientos_periodo
end type
type gb_1 from groupbox within w_cn755_detalle_asientos_periodo
end type
end forward

global type w_cn755_detalle_asientos_periodo from w_report_smpl
integer width = 3195
integer height = 1984
string title = "[CN755] Detalle de asiento por periodos"
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
cb_1 cb_1
st_4 st_4
st_1 st_1
sle_mes1 sle_mes1
st_2 st_2
sle_mes2 sle_mes2
gb_1 gb_1
end type
global w_cn755_detalle_asientos_periodo w_cn755_detalle_asientos_periodo

type variables
//boolean ib_retrieve = 
end variables

on w_cn755_detalle_asientos_periodo.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.cb_1=create cb_1
this.st_4=create st_4
this.st_1=create st_1
this.sle_mes1=create sle_mes1
this.st_2=create st_2
this.sle_mes2=create sle_mes2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_mes1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_mes2
this.Control[iCurrent+8]=this.gb_1
end on

on w_cn755_detalle_asientos_periodo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.sle_mes1)
destroy(this.st_2)
destroy(this.sle_mes2)
destroy(this.gb_1)
end on

event ue_retrieve;//override
Integer 	li_year, li_mes1, li_mes2

if trim(sle_ano.text) = '' then
	MessageBox('Error', 'Debe indicar el año para el periodo, por favor verifique!')
	sle_ano.setFocus( )
	return
end if

if trim(sle_mes1.text) = '' then
	MessageBox('Error', 'Debe indicar el mes de inicio para el reporte, por favor verifique!')
	sle_mes1.setFocus( )
	return
end if

li_year   = integer(sle_ano.text)
li_mes1	= integer(sle_mes1.text)
li_mes2  = integer(sle_mes2.text)

If isnull(li_year) or li_year = 0 then
	MessageBox('Aviso','Debe indicar Año')
	sle_ano.setFocus()
	Return
End if

If isnull(li_mes1) or li_mes1 = 0 then
	MessageBox('Aviso','Debe indicar Mes Desde')
	sle_mes1.setFocus()
	Return
End if

If isnull(li_mes2) or li_mes2 = 0 then
	MessageBox('Aviso','Debe indicar Mes hasta')
	sle_mes2.setFocus()
	Return
End if

ib_preview = true  
THIS.Event ue_preview()
  
dw_report.retrieve(li_year, li_mes1, li_mes2)

idw_1.Visible = True

SetPointer(Arrow!)
end event

event ue_open_pre;call super::ue_open_pre;string ls_cnta1, ls_cnta2
integer li_year

li_year = Integer(string(gnvo_app.of_fecha_actual(),'yyyy'))

sle_ano.text = string(li_year)
sle_mes1.text = "01"
sle_mes2.text = string(gnvo_app.of_fecha_actual(),'mm')

end event

type dw_report from w_report_smpl`dw_report within w_cn755_detalle_asientos_periodo
integer x = 0
integer y = 212
integer width = 3109
integer height = 1436
integer taborder = 70
string dataobject = "d_rpt_detalle_asientos_periodo_tbl"
end type

event dw_report::ue_leftbuttonup;call super::ue_leftbuttonup;/*if ib_Retrieve then
	cbx_PowerFilter.event post ue_buttonclicked(dwo.type, dwo.name)
end if
*/
end event

event dw_report::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_report::resize;call super::resize;/*if ib_retrieve = true then
	cbx_PowerFilter.event ue_positionbuttons()
end if
*/
end event

type sle_ano from singlelineedit within w_cn755_detalle_asientos_periodo
integer x = 219
integer y = 76
integer width = 192
integer height = 76
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

type cb_1 from commandbutton within w_cn755_detalle_asientos_periodo
integer x = 1499
integer y = 20
integer width = 288
integer height = 172
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;SetPointer(hourglass!)
Parent.Event ue_retrieve()
SetPointer(Arrow!)

end event

type st_4 from statictext within w_cn755_detalle_asientos_periodo
integer x = 50
integer y = 84
integer width = 155
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn755_detalle_asientos_periodo
integer x = 485
integer y = 84
integer width = 270
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Desde:"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_mes1 from singlelineedit within w_cn755_detalle_asientos_periodo
integer x = 768
integer y = 76
integer width = 192
integer height = 76
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

type st_2 from statictext within w_cn755_detalle_asientos_periodo
integer x = 969
integer y = 84
integer width = 270
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Hasta:"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_mes2 from singlelineedit within w_cn755_detalle_asientos_periodo
integer x = 1243
integer y = 76
integer width = 192
integer height = 76
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

type gb_1 from groupbox within w_cn755_detalle_asientos_periodo
integer x = 18
integer y = 16
integer width = 1449
integer height = 184
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Periodo Contable "
end type

