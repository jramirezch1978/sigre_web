$PBExportHeader$w_ap301_guia_recepcion_frm.srw
forward
global type w_ap301_guia_recepcion_frm from w_rpt
end type
type rb_2 from radiobutton within w_ap301_guia_recepcion_frm
end type
type rb_1 from radiobutton within w_ap301_guia_recepcion_frm
end type
type dw_report from u_dw_rpt within w_ap301_guia_recepcion_frm
end type
end forward

global type w_ap301_guia_recepcion_frm from w_rpt
integer width = 3433
integer height = 2448
string title = "Reporte de Guia de Recepcion de Materia Prima"
string menuname = "m_rpt"
rb_2 rb_2
rb_1 rb_1
dw_report dw_report
end type
global w_ap301_guia_recepcion_frm w_ap301_guia_recepcion_frm

on w_ap301_guia_recepcion_frm.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.dw_report
end on

on w_ap301_guia_recepcion_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()
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

event ue_print;call super::ue_print;idw_1.EVENT ue_print()

end event

event ue_retrieve;call super::ue_retrieve;String ls_nro_guia, ls_firma_digital, ls_aprobador

str_parametros lstr_rep

try 
	lstr_rep = message.powerobjectparm
	
	ls_nro_guia = lstr_rep.string1
	dw_report.Retrieve( ls_nro_guia)
	
	//A mitad de pagina
	dw_report.Object.DataWindow.Print.Paper.Size = 256 
	dw_report.Object.DataWindow.Print.CustomPage.Width = 225
	dw_report.Object.DataWindow.Print.CustomPage.Length = 140
				
	idw_1.Visible = True
	idw_1.Object.p_logo.filename  = gs_logo
	idw_1.object.usuario_t.text	= gs_user
	
	//Ahora coloco la firma del jefe de almacen
	if dw_report.of_ExistsPictureName("p_aprobador") then
		if gnvo_app.of_get_parametro("FIRMAS_GRMP", "1") = "1"  then
			
			ls_aprobador		= dw_report.object.aprobador [1]
			ls_firma_digital 	= gnvo_app.almacen.of_get_firma_autorizado(gs_inifile, ls_aprobador)
			
			// Coloco la firma escaneada del representante 
			if ls_firma_digital <> "" then
				
				if Not FileExists(ls_firma_digital) then
					MessageBox('Error', 'No existe el archivo ' + ls_firma_digital + ", por favor verifique!!", StopSign!)
					//return
				else
					dw_report.object.p_aprobador.filename = ls_firma_digital	
				end if
				
			end if
			
		end if
		
		
	end if

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, 'Error al recuperar GRMP')
finally
	/*statementBlock*/
end try


end event

type rb_2 from radiobutton within w_ap301_guia_recepcion_frm
integer x = 407
integer y = 12
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato 2"
end type

event clicked;dw_report.DataObject = 'd_rpt_guia_recepcion2_tbl'
dw_report.SetTransObject(SQLCA)

ib_preview=false
event ue_preview()
Event ue_retrieve()
end event

type rb_1 from radiobutton within w_ap301_guia_recepcion_frm
integer y = 8
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato 1"
boolean checked = true
end type

event clicked;dw_report.DataObject = 'd_rpt_guia_recepcion_tbl'
dw_report.SetTransObject(SQLCA)

ib_preview=false
event ue_preview()
Event ue_retrieve()
end event

type dw_report from u_dw_rpt within w_ap301_guia_recepcion_frm
integer y = 100
integer width = 3301
integer height = 1904
string dataobject = "d_rpt_guia_recepcion_tbl"
end type

