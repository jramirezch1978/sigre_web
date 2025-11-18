$PBExportHeader$w_sig701_resumen_area_seccion.srw
forward
global type w_sig701_resumen_area_seccion from w_report_smpl
end type
type cb_retrieve from commandbutton within w_sig701_resumen_area_seccion
end type
type rb_1 from radiobutton within w_sig701_resumen_area_seccion
end type
type rb_2 from radiobutton within w_sig701_resumen_area_seccion
end type
type gb_1 from groupbox within w_sig701_resumen_area_seccion
end type
end forward

global type w_sig701_resumen_area_seccion from w_report_smpl
integer width = 3337
integer height = 1760
string title = "[SIG701] Personal Resumido por area y seccion"
string menuname = "m_rpt_simple"
cb_retrieve cb_retrieve
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_sig701_resumen_area_seccion w_sig701_resumen_area_seccion

type variables
String	is_dw_obj, is_tipo_cuenta
end variables

on w_sig701_resumen_area_seccion.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_retrieve=create cb_retrieve
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.gb_1
end on

on w_sig701_resumen_area_seccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_retrieve)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;
dw_report.Object.Datawindow.Print.Orientation = 1
dw_report.Object.Datawindow.Print.Paper.Size = 9

is_tipo_cuenta = 'E'
end event

type dw_report from w_report_smpl`dw_report within w_sig701_resumen_area_seccion
integer x = 0
integer y = 248
integer width = 3090
integer height = 1076
integer taborder = 30
string dataobject = "d_rpt_resumen_area_seccion_tbl"
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

type cb_retrieve from commandbutton within w_sig701_resumen_area_seccion
integer x = 663
integer y = 52
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

event clicked;
// Preparar Datawindow
idw_1.Visible = true

// Adecuar dato

if rb_1.checked then
	idw_1.DataObject = 'd_rpt_resumen_area_seccion_tbl'
else
	idw_1.DataObject = 'd_rpt_resumen_area_seccion_TV'
end if

idw_1.SetTransObject(SQLCA)

idw_1.Retrieve()
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = parent.ClassName()
idw_1.Object.p_logo.filename = gs_logo
end event

type rb_1 from radiobutton within w_sig701_resumen_area_seccion
integer x = 18
integer y = 52
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
end type

type rb_2 from radiobutton within w_sig701_resumen_area_seccion
integer x = 18
integer y = 128
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
boolean checked = true
end type

type gb_1 from groupbox within w_sig701_resumen_area_seccion
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

