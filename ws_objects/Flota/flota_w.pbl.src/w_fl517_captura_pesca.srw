$PBExportHeader$w_fl517_captura_pesca.srw
forward
global type w_fl517_captura_pesca from w_rpt
end type
type dw_report from u_dw_rpt within w_fl517_captura_pesca
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl517_captura_pesca
end type
type pb_recuperar from u_pb_std within w_fl517_captura_pesca
end type
end forward

global type w_fl517_captura_pesca from w_rpt
integer width = 2226
integer height = 1844
string title = "Consulta Captura Pesca (FL517)"
string menuname = "m_smpl"
long backcolor = 67108864
event ue_copiar ( )
dw_report dw_report
uo_fecha uo_fecha
pb_recuperar pb_recuperar
end type
global w_fl517_captura_pesca w_fl517_captura_pesca

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
end event

on w_fl517_captura_pesca.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.dw_report=create dw_report
this.uo_fecha=create uo_fecha
this.pb_recuperar=create pb_recuperar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.pb_recuperar
end on

on w_fl517_captura_pesca.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

type dw_report from u_dw_rpt within w_fl517_captura_pesca
integer y = 168
integer width = 2167
integer height = 1464
integer taborder = 60
string dataobject = "d_cns_captura_pesca_grid"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'
end event

event clicked;call super::clicked;IF Row = 0 OR is_dwform = 'form' THEN RETURN

il_row = row              // fila corriente
This.SelectRow(0, False)
This.SelectRow(Row, True)
THIS.SetRow(Row)
RETURN

end event

event doubleclicked;call super::doubleclicked;string ls_fecha1, ls_fecha2, ls_nave
STR_CNS_POP lstr_1
w_cns_pop	lw_sheet

if row = 0 then return
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN

choose case upper(dwo.name)
		
	case "PESCA"
		ls_fecha1 	= string(uo_fecha.of_get_fecha1(), 'yyyymmdd')
		ls_fecha2 	= string(uo_fecha.of_get_fecha2(), 'yyyymmdd')
		ls_nave 		= trim(this.object.nave[row])
		lstr_1.DataObject = 'ds_cns_cap_pesca_det_grid'
		lstr_1.Width = 2500
		lstr_1.Height= 1300
		lstr_1.Title = 'Captura de Pesca Detallada'
		lstr_1.Arg[1] = ls_nave
		lstr_1.Arg[2] = ls_fecha1
		lstr_1.Arg[3] = ls_fecha2
		lstr_1.Arg[4] = ''
		lstr_1.Arg[5] = ''
		lstr_1.Arg[6] = ''
		OpenSheetWithParm(lw_sheet, lstr_1, Parent, 0, Original!)
end choose

end event

type uo_fecha from u_ingreso_rango_fechas within w_fl517_captura_pesca
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

type pb_recuperar from u_pb_std within w_fl517_captura_pesca
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

