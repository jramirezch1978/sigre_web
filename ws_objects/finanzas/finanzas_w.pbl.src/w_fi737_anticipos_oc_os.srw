$PBExportHeader$w_fi737_anticipos_oc_os.srw
forward
global type w_fi737_anticipos_oc_os from w_rpt
end type
type cb_2 from commandbutton within w_fi737_anticipos_oc_os
end type
type rb_gen from radiobutton within w_fi737_anticipos_oc_os
end type
type rb_tod from radiobutton within w_fi737_anticipos_oc_os
end type
type rb_canc from radiobutton within w_fi737_anticipos_oc_os
end type
type rb_pend from radiobutton within w_fi737_anticipos_oc_os
end type
type dw_report from u_dw_rpt within w_fi737_anticipos_oc_os
end type
type gb_1 from groupbox within w_fi737_anticipos_oc_os
end type
end forward

global type w_fi737_anticipos_oc_os from w_rpt
integer width = 3109
integer height = 2748
string title = "Anticipos OC,OS (FI737)"
string menuname = "m_reporte"
long backcolor = 12632256
cb_2 cb_2
rb_gen rb_gen
rb_tod rb_tod
rb_canc rb_canc
rb_pend rb_pend
dw_report dw_report
gb_1 gb_1
end type
global w_fi737_anticipos_oc_os w_fi737_anticipos_oc_os

on w_fi737_anticipos_oc_os.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_2=create cb_2
this.rb_gen=create rb_gen
this.rb_tod=create rb_tod
this.rb_canc=create rb_canc
this.rb_pend=create rb_pend
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.rb_gen
this.Control[iCurrent+3]=this.rb_tod
this.Control[iCurrent+4]=this.rb_canc
this.Control[iCurrent+5]=this.rb_pend
this.Control[iCurrent+6]=this.dw_report
this.Control[iCurrent+7]=this.gb_1
end on

on w_fi737_anticipos_oc_os.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.rb_gen)
destroy(this.rb_tod)
destroy(this.rb_canc)
destroy(this.rb_pend)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)



//datos de reporte
ib_preview = False
This.Event ue_preview()
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user


end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_saveas;call super::ue_saveas;idw_1.EVENT ue_saveas()
end event

event ue_zoom;call super::ue_zoom;idw_1.EVENT ue_zoom(ai_zoom)
end event

type cb_2 from commandbutton within w_fi737_anticipos_oc_os
integer x = 2487
integer y = 28
integer width = 347
integer height = 120
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Recuperar"
end type

event clicked;String old_select, new_select, where_clause 
String ls_flag_estado,ls_flag_cbancos ,ls_titulo


// Get old SELECT statement
old_select = dw_report.GetSQLSelect()

// Specify new WHERE clause
if     rb_gen.checked  then //solo generados
	ls_flag_estado  = "('1')"
	ls_flag_cbancos = "('0')"
	
	ls_titulo = 'Anticipos Solo Generados'
	
elseif rb_pend.checked then //solo pendientes por aplicar	
	ls_flag_estado = "('1','2')"
	ls_flag_cbancos = "('1')"
	
	ls_titulo = 'Anticipos Pendientes de Aplicacion'
	
elseif rb_canc.checked then //solo cancelados	
	ls_flag_estado = "('3')"
	ls_flag_cbancos = "('1')"
	
	ls_titulo = 'Anticipos Cancelados'
elseif rb_tod.checked  then	
	ls_flag_estado = "('1','2','3')"
	ls_flag_cbancos = "('0','1')"
	
		ls_titulo = 'Todos Los Anticipos'
end if

where_clause = " and (cp.flag_estado      in " +ls_flag_estado  +")" &
				  +" and (cp.flag_caja_bancos in " +ls_flag_cbancos +")"


// Add the new where clause to old_select 

new_select = old_select + where_clause


// Set the SELECT statement for the DW

dw_report.SetSQLSelect(new_select)

dw_report.retrieve()

//asigno titulos
dw_report.object.t_titulo.text = ls_titulo



//volver a estado natural
dw_report.SetSQLSelect(old_select)
end event

type rb_gen from radiobutton within w_fi737_anticipos_oc_os
integer x = 78
integer y = 80
integer width = 699
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Generados"
end type

type rb_tod from radiobutton within w_fi737_anticipos_oc_os
integer x = 78
integer y = 308
integer width = 699
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Todos"
end type

type rb_canc from radiobutton within w_fi737_anticipos_oc_os
integer x = 78
integer y = 232
integer width = 699
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Cancelados"
end type

type rb_pend from radiobutton within w_fi737_anticipos_oc_os
integer x = 78
integer y = 156
integer width = 699
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Pendientes por Aplicar"
end type

type dw_report from u_dw_rpt within w_fi737_anticipos_oc_os
integer x = 18
integer y = 436
integer width = 2853
integer height = 1248
string dataobject = "d_abc_anticipos_rpt_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_fi737_anticipos_oc_os
integer x = 27
integer y = 16
integer width = 763
integer height = 408
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Esatdos del Documento"
end type

