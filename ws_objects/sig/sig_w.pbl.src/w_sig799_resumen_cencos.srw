$PBExportHeader$w_sig799_resumen_cencos.srw
forward
global type w_sig799_resumen_cencos from w_report_smpl
end type
type sle_year from singlelineedit within w_sig799_resumen_cencos
end type
type st_1 from statictext within w_sig799_resumen_cencos
end type
type cb_retrieve from commandbutton within w_sig799_resumen_cencos
end type
type sle_mes1 from singlelineedit within w_sig799_resumen_cencos
end type
type st_label from statictext within w_sig799_resumen_cencos
end type
type st_2 from statictext within w_sig799_resumen_cencos
end type
type sle_mes2 from singlelineedit within w_sig799_resumen_cencos
end type
type rb_1 from radiobutton within w_sig799_resumen_cencos
end type
type rb_2 from radiobutton within w_sig799_resumen_cencos
end type
type gb_1 from groupbox within w_sig799_resumen_cencos
end type
end forward

global type w_sig799_resumen_cencos from w_report_smpl
integer width = 3337
integer height = 1760
string title = "[SIG799] Resumido por Centro de Costos y Niveles"
string menuname = "m_rpt_simple"
sle_year sle_year
st_1 st_1
cb_retrieve cb_retrieve
sle_mes1 sle_mes1
st_label st_label
st_2 st_2
sle_mes2 sle_mes2
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_sig799_resumen_cencos w_sig799_resumen_cencos

type variables
String	is_dw_obj, is_tipo_cuenta
end variables

on w_sig799_resumen_cencos.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.sle_year=create sle_year
this.st_1=create st_1
this.cb_retrieve=create cb_retrieve
this.sle_mes1=create sle_mes1
this.st_label=create st_label
this.st_2=create st_2
this.sle_mes2=create sle_mes2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_year
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_retrieve
this.Control[iCurrent+4]=this.sle_mes1
this.Control[iCurrent+5]=this.st_label
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_mes2
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.gb_1
end on

on w_sig799_resumen_cencos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_year)
destroy(this.st_1)
destroy(this.cb_retrieve)
destroy(this.sle_mes1)
destroy(this.st_label)
destroy(this.st_2)
destroy(this.sle_mes2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;sle_year.text = String(gnvo_app.of_fecha_Actual(), 'yyyy')
sle_mes1.text = '01'
sle_mes2.text = String(gnvo_app.of_fecha_Actual(), 'mm')

dw_report.Object.Datawindow.Print.Orientation = 1
dw_report.Object.Datawindow.Print.Paper.Size = 9

is_tipo_cuenta = 'E'
end event

type dw_report from w_report_smpl`dw_report within w_sig799_resumen_cencos
integer x = 0
integer y = 248
integer width = 3090
integer height = 1076
integer taborder = 30
string dataobject = "d_rpt_resumen_cencos_ejec_tbl"
boolean livescroll = false
end type

event dw_report::doubleclicked;call super::doubleclicked;//IF row = 0 THEN RETURN
//
//STR_CNS_POP lstr_1
//String		ls_mes, ls_cencos
//
//CHOOSE CASE dwo.Name
//	CASE "ejec_ene" 
//		ls_mes = '01'
//	CASE "ejec_feb" 
//		ls_mes = '02'
//	CASE "ejec_mar" 
//		ls_mes = '03'
//	CASE "ejec_abr" 
//		ls_mes = '04'
//	CASE "ejec_may" 
//		ls_mes = '05'
//	CASE "ejec_jun" 
//		ls_mes = '06'
//	CASE "ejec_jul" 
//		ls_mes = '07'
//	CASE "ejec_ago" 
//		ls_mes = '08'
//	CASE "ejec_set" 
//		ls_mes = '09'
//	CASE "ejec_oct" 
//		ls_mes = '10'
//	CASE "ejec_nov" 
//		ls_mes = '11'
//	CASE "ejec_dic" 
//		ls_mes = '12'
//END CHOOSE
//
//IF rb_total.checked THEN
//	ls_cencos = '%%'
//ELSE
//	ls_cencos = THIS.GetItemString( row, 'cencos') + '%'
//END IF
//
//lstr_1.DataObject = 'd_presupuesto_ejec_mes_tbl'
//lstr_1.Width = 4000
//lstr_1.Height= 1300
//lstr_1.Title = 'Presupuesto Ejecutado'
//lstr_1.Arg[1] = Trim(sle_ano.text)
//lstr_1.Arg[2] = ls_cencos
//lstr_1.Arg[3] = THIS.GetItemString( row, 'cnta_prsp')
//lstr_1.Arg[4] = ls_mes
//lstr_1.Tipo_Cascada = 'C'
//of_new_sheet(lstr_1)	
end event

type sle_year from singlelineedit within w_sig799_resumen_cencos
integer x = 197
integer y = 52
integer width = 178
integer height = 76
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

type st_1 from statictext within w_sig799_resumen_cencos
integer x = 37
integer y = 52
integer width = 142
integer height = 76
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
boolean focusrectangle = false
end type

type cb_retrieve from commandbutton within w_sig799_resumen_cencos
integer x = 2199
integer y = 56
integer width = 315
integer height = 148
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Integer 	li_year, li_mes1, li_mes2


// Preparar Datawindow
idw_1.Visible = true

// Adecuar dato
li_year = Integer(sle_year.text)

li_mes1 = Integer(sle_mes1.text)
li_mes2 = Integer(sle_mes2.text)

if rb_1.checked then
	idw_1.DataObject = 'd_rpt_resumen_cencos_ejec_tbl'
else
	idw_1.DataObject = 'd_rpt_resumen_cencos_ejec_tv'
end if

idw_1.SetTransObject(SQLCA)

idw_1.Retrieve(li_year, li_mes1, li_mes2)
idw_1.object.t_subtitulo.text = 'Año: ' + trim(sle_year.text) + 'DEL MES: ' + sle_mes1.text + ' AL MES: ' + sle_mes2.text
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = parent.ClassName()
idw_1.Object.p_logo.filename = gs_logo
end event

type sle_mes1 from singlelineedit within w_sig799_resumen_cencos
integer x = 407
integer y = 136
integer width = 142
integer height = 76
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

type st_label from statictext within w_sig799_resumen_cencos
integer x = 50
integer y = 136
integer width = 352
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Desde :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_sig799_resumen_cencos
integer x = 562
integer y = 136
integer width = 325
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Hasta :"
boolean focusrectangle = false
end type

type sle_mes2 from singlelineedit within w_sig799_resumen_cencos
integer x = 887
integer y = 136
integer width = 142
integer height = 76
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

type rb_1 from radiobutton within w_sig799_resumen_cencos
integer x = 1134
integer y = 48
integer width = 567
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
string text = "Formato Tabular"
boolean checked = true
end type

type rb_2 from radiobutton within w_sig799_resumen_cencos
integer x = 1134
integer y = 124
integer width = 567
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
string text = "Formato Treeview"
end type

type gb_1 from groupbox within w_sig799_resumen_cencos
integer width = 2565
integer height = 228
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Criterios para el reporte"
end type

