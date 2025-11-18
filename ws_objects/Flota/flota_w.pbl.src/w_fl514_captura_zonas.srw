$PBExportHeader$w_fl514_captura_zonas.srw
forward
global type w_fl514_captura_zonas from w_rpt
end type
type rb_2 from radiobutton within w_fl514_captura_zonas
end type
type rb_1 from radiobutton within w_fl514_captura_zonas
end type
type dw_report from u_dw_rpt within w_fl514_captura_zonas
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl514_captura_zonas
end type
type pb_recuperar from u_pb_std within w_fl514_captura_zonas
end type
end forward

global type w_fl514_captura_zonas from w_rpt
integer width = 2226
integer height = 1844
string title = "Captura por Zonas de Pesca (FL514)"
string menuname = "m_rep_grf"
long backcolor = 67108864
event ue_copiar ( )
rb_2 rb_2
rb_1 rb_1
dw_report dw_report
uo_fecha uo_fecha
pb_recuperar pb_recuperar
end type
global w_fl514_captura_zonas w_fl514_captura_zonas

event ue_copiar();dw_report.ClipBoard("gr_1")
end event

event ue_open_pre;call super::ue_open_pre;date ld_fecha1, ld_fecha2

idw_1 = dw_report
//idw_1.Visible = False
idw_1.SetTransObject(sqlca)

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( month( today() ) + 1 ,'00' ) &
	+ '/' + string( year( today() ), '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

uo_fecha.of_set_fecha( ld_fecha1, ld_fecha2 )

end event

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_retrieve;call super::ue_retrieve;date ld_fecha1, ld_fecha2
integer li_ok
string ls_mensaje

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

dw_report.Retrieve(ld_fecha1, ld_fecha2)

dw_report.object.gr_1.Title = "Captura por Zonas de Pesca - Flota Propia: " &
	+ "~r~n~r~n" + string(ld_fecha1, 'dd/mm/yyyy') &
	+ " - " + string(ld_fecha2, 'dd/mm/yyyy') 
end event

on w_fl514_captura_zonas.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_report=create dw_report
this.uo_fecha=create uo_fecha
this.pb_recuperar=create pb_recuperar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.dw_report
this.Control[iCurrent+4]=this.uo_fecha
this.Control[iCurrent+5]=this.pb_recuperar
end on

on w_fl514_captura_zonas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_report)
destroy(this.uo_fecha)
destroy(this.pb_recuperar)
end on

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
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

type rb_2 from radiobutton within w_fl514_captura_zonas
integer x = 1413
integer y = 96
integer width = 302
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Columnas"
end type

event clicked;// Col3DObj
dw_report.SetRedraw(false)
dw_report.object.gr_1.GraphType = 9
dw_report.object.gr_1.Values.Label = 'Toneladas'
dw_report.object.gr_1.Category.Label = 'Zonas de Pesca'
dw_report.object.gr_1.Category.DispAttr.AutoSize = 0
dw_report.object.gr_1.Category.DispAttr.Font.Height = 63
dw_report.SetRedraw(true)

end event

type rb_1 from radiobutton within w_fl514_captura_zonas
integer x = 1417
integer y = 28
integer width = 238
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Torta"
boolean checked = true
end type

event clicked;//Pie3D
dw_report.SetRedraw(false)
dw_report.object.gr_1.GraphType = 17
dw_report.SetRedraw(true)
end event

type dw_report from u_dw_rpt within w_fl514_captura_zonas
integer y = 172
integer width = 2167
integer height = 1464
integer taborder = 60
string dataobject = "d_captura_zonas_graph"
end type

type uo_fecha from u_ingreso_rango_fechas within w_fl514_captura_zonas
event destroy ( )
integer x = 73
integer y = 44
integer taborder = 50
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type pb_recuperar from u_pb_std within w_fl514_captura_zonas
integer x = 1856
integer y = 24
integer width = 155
integer height = 132
integer textsize = -2
string text = "&r"
string picturename = "Retrieve!"
boolean map3dcolors = true
end type

event clicked;call super::clicked;parent.event dynamic ue_retrieve()
end event

