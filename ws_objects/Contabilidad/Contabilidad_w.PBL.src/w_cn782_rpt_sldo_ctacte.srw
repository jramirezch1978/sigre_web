$PBExportHeader$w_cn782_rpt_sldo_ctacte.srw
forward
global type w_cn782_rpt_sldo_ctacte from w_report_smpl
end type
type sle_origen from singlelineedit within w_cn782_rpt_sldo_ctacte
end type
type st_1 from statictext within w_cn782_rpt_sldo_ctacte
end type
type st_2 from statictext within w_cn782_rpt_sldo_ctacte
end type
type sle_ano from singlelineedit within w_cn782_rpt_sldo_ctacte
end type
type st_3 from statictext within w_cn782_rpt_sldo_ctacte
end type
type sle_mes from singlelineedit within w_cn782_rpt_sldo_ctacte
end type
type cb_1 from commandbutton within w_cn782_rpt_sldo_ctacte
end type
type rb_1 from radiobutton within w_cn782_rpt_sldo_ctacte
end type
type rb_2 from radiobutton within w_cn782_rpt_sldo_ctacte
end type
type sle_grupo from singlelineedit within w_cn782_rpt_sldo_ctacte
end type
type st_4 from statictext within w_cn782_rpt_sldo_ctacte
end type
type gb_1 from groupbox within w_cn782_rpt_sldo_ctacte
end type
type gb_2 from groupbox within w_cn782_rpt_sldo_ctacte
end type
end forward

global type w_cn782_rpt_sldo_ctacte from w_report_smpl
integer width = 3410
integer height = 1760
string title = "(CN782) Saldos de Cta Cte por Grupo de Cuentas Contables"
string menuname = "m_abc_report_smpl"
long backcolor = 67108864
sle_origen sle_origen
st_1 st_1
st_2 st_2
sle_ano sle_ano
st_3 st_3
sle_mes sle_mes
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
sle_grupo sle_grupo
st_4 st_4
gb_1 gb_1
gb_2 gb_2
end type
global w_cn782_rpt_sldo_ctacte w_cn782_rpt_sldo_ctacte

type variables
String is_opcion
end variables

on w_cn782_rpt_sldo_ctacte.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_origen=create sle_origen
this.st_1=create st_1
this.st_2=create st_2
this.sle_ano=create sle_ano
this.st_3=create st_3
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.sle_grupo=create sle_grupo
this.st_4=create st_4
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_origen
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_ano
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_mes
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.sle_grupo
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
end on

on w_cn782_rpt_sldo_ctacte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_origen)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_ano)
destroy(this.st_3)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.sle_grupo)
destroy(this.st_4)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre();call super::ue_open_pre;String ls_origen, ls_ano, ls_mes
sle_origen.text = gs_origen
sle_ano.text = string( today(), 'yyyy')
sle_mes.text = string( today(), 'mm')
is_opcion='R'

end event

event resize;call super::resize;// prueba

end event

event ue_retrieve;call super::ue_retrieve;String ls_origen, ls_ano, ls_mes, ls_grupo
Integer li_ano, li_mes

ls_origen = sle_origen.text
ls_ano 	 = sle_ano.text
ls_mes 	 = sle_mes.text
ls_grupo  = sle_grupo.Text

IF isnull(ls_origen) OR isnull(ls_ano) OR isnull(ls_mes) or isnull(ls_grupo) then
	messagebox('Aviso', 'Corregir datos son nulos')
	return
END IF
li_ano = integer(ls_ano)
li_mes = integer(ls_mes)

SetPointer(HourGlass!)
if rb_1.Checked = true then
	dw_report.DataObject = 'd_rpt_sldo_ctacte'	
	DECLARE pb_rpt_sldo_ctacte PROCEDURE FOR usp_cntbl_rpt_sldo_ctacte
			  ( :li_ano, :li_mes, :ls_grupo ) ;
	Execute pb_rpt_sldo_ctacte ;
elseif rb_2.Checked = true then
	dw_report.DataObject = 'd_rpt_sldo_err_ctacte'	
	DECLARE pb_rpt_err_sldo_ctacte PROCEDURE FOR usp_cntbl_rpt_err_sldo_ctacte
			  ( :li_ano, :li_mes, :ls_grupo ) ;
	Execute pb_rpt_err_sldo_ctacte ;
end if

IF sqlca.sqlcode = -1 THEN
	MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
	SetPointer(Arrow!)
	Return
END IF

dw_report.SetTransObject(sqlca)
dw_report.retrieve()
//idw_1.Visible = True
//idw_1.object.p_logo.filename = gs_logo
//idw_1.object.t_texto.text = 'Año: ' + ls_ano + '  Mes: ' + ls_mes
//cb_generar.enabled = true
SetPointer(Arrow!)
end event

type dw_report from w_report_smpl`dw_report within w_cn782_rpt_sldo_ctacte
integer x = 18
integer y = 280
integer width = 3333
integer height = 1348
integer taborder = 50
end type

type sle_origen from singlelineedit within w_cn782_rpt_sldo_ctacte
integer x = 846
integer y = 160
integer width = 123
integer height = 72
integer taborder = 10
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

type st_1 from statictext within w_cn782_rpt_sldo_ctacte
integer x = 635
integer y = 164
integer width = 201
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn782_rpt_sldo_ctacte
integer x = 699
integer y = 68
integer width = 137
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_cn782_rpt_sldo_ctacte
integer x = 846
integer y = 68
integer width = 215
integer height = 72
integer taborder = 20
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

type st_3 from statictext within w_cn782_rpt_sldo_ctacte
integer x = 1111
integer y = 68
integer width = 123
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes:"
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_cn782_rpt_sldo_ctacte
integer x = 1230
integer y = 68
integer width = 123
integer height = 72
integer taborder = 30
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

type cb_1 from commandbutton within w_cn782_rpt_sldo_ctacte
integer x = 1733
integer y = 156
integer width = 302
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;//
//
//IF is_opcion='R' then
//	idw_1.DataObject='d_rpt_asiento_codrel_error_tbl'
//ELSEIF is_opcion='C' then
//	idw_1.DataObject='d_rpt_asiento_cencos_error_tbl'
//ELSEIF is_opcion='P' then
//	idw_1.DataObject='d_rpt_asiento_cnta_prsp_error_tbl'
//ELSEIF is_opcion='D' then
//	idw_1.DataObject='d_rpt_asiento_docum_error_tbl'
//ELSEIF is_opcion='X' then
//	idw_1.DataObject='d_rpt_error_cencos_tbl'
//ELSE
//	messagebox('Seleccione opcion','Detalle o Resumido')
//	return
//END IF
//
//idw_1.visible = true
////parent.event ue_preview()

parent.event ue_retrieve()

end event

type rb_1 from radiobutton within w_cn782_rpt_sldo_ctacte
integer x = 55
integer y = 88
integer width = 421
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
string text = "Saldo Cta Cte."
boolean checked = true
end type

event clicked;is_opcion='R'
end event

type rb_2 from radiobutton within w_cn782_rpt_sldo_ctacte
integer x = 55
integer y = 160
integer width = 421
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
string text = "Ctas Error"
end type

event clicked;is_opcion='C'
end event

type sle_grupo from singlelineedit within w_cn782_rpt_sldo_ctacte
integer x = 1275
integer y = 164
integer width = 411
integer height = 72
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

type st_4 from statictext within w_cn782_rpt_sldo_ctacte
integer x = 974
integer y = 168
integer width = 302
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Grupo Ctas.:"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn782_rpt_sldo_ctacte
integer x = 37
integer y = 28
integer width = 558
integer height = 224
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Reporte"
end type

type gb_2 from groupbox within w_cn782_rpt_sldo_ctacte
integer x = 626
integer y = 24
integer width = 1097
integer height = 232
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

