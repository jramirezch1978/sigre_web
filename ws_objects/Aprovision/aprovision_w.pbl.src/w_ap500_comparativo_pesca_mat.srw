$PBExportHeader$w_ap500_comparativo_pesca_mat.srw
forward
global type w_ap500_comparativo_pesca_mat from w_rpt
end type
type pb_1 from picturebutton within w_ap500_comparativo_pesca_mat
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap500_comparativo_pesca_mat
end type
type dw_report from u_dw_rpt within w_ap500_comparativo_pesca_mat
end type
end forward

global type w_ap500_comparativo_pesca_mat from w_rpt
integer width = 2318
integer height = 1844
string title = "Comparativo entre Ingreso por Pesca y Materiales  (AP500)"
string menuname = "m_consulta"
long backcolor = 67108864
pb_1 pb_1
uo_fecha uo_fecha
dw_report dw_report
end type
global w_ap500_comparativo_pesca_mat w_ap500_comparativo_pesca_mat

type variables
Integer	ii_ss, il_LastRow
Boolean	ib_action_on_buttonup
dwobject	idwo_clicked

end variables

on w_ap500_comparativo_pesca_mat.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.pb_1=create pb_1
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.dw_report
end on

on w_ap500_comparativo_pesca_mat.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.uo_fecha)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
//THIS.Event ue_preview()
//This.Event ue_retrieve()

end event

event ue_retrieve;call super::ue_retrieve;string ls_rango_fecha, ls_especie
date ld_fecha_ini, ld_fecha_fin
dec ld_tipo_cambio 
Integer	li_x

ld_fecha_ini = date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin = date(uo_fecha.of_get_fecha2( ))

idw_1.Retrieve(ld_fecha_ini, ld_fecha_fin)

ls_rango_fecha = 'Del ' + string(ld_fecha_ini) + ' Al ' + string (ld_fecha_fin)

idw_1.object.usuario_t.text 		= gs_user
idw_1.object.p_logo.filename 		= gs_logo
idw_1.object.rango_1.text			= ls_rango_fecha

idw_1.Visible = True


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

event close;call super::close;integer li_x

FOR li_x = 1 TO Upperbound(iw_sheet)
	IF IsValid(iw_sheet[li_x]) THEN Close(iw_sheet[li_x])
NEXT
end event

type pb_1 from picturebutton within w_ap500_comparativo_pesca_mat
integer x = 1783
integer y = 28
integer width = 306
integer height = 136
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\procesar_enb.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_retrieve()

end event

type uo_fecha from u_ingreso_rango_fechas within w_ap500_comparativo_pesca_mat
event destroy ( )
integer x = 69
integer y = 44
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

type dw_report from u_dw_rpt within w_ap500_comparativo_pesca_mat
integer x = 18
integer y = 200
integer width = 2162
integer height = 1232
string dataobject = "d_ap_comparativo_pesca_mat_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;IF row = 0 OR is_dwform = 'form' THEN RETURN

ii_ss = 1

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	idwo_clicked = dwo        // dwo corriente
	This.SelectRow(0, False)
	This.SelectRow(row, True)
	THIS.SetRow(row)
	RETURN
END IF


end event

event doubleclicked;call super::doubleclicked;String ls_fec_ini, ls_fec_fin

IF row = 0 THEN RETURN

STR_CNS_POP lstr_1


ls_fec_ini = String(date(uo_fecha.of_get_fecha1( )),'yyyymmdd')
ls_fec_fin = String(date(uo_fecha.of_get_fecha2( )),'yyyymmdd')

lstr_1.DataObject = 'd_ap_cons_comp_pesca_mat_cpst'
lstr_1.Width = 4000
lstr_1.Height= 1400
lstr_1.Arg[1] = ls_fec_ini
lstr_1.Arg[2] = ls_fec_fin
lstr_1.Arg[3] = GetItemString(row,'proveedor')
lstr_1.Title = 'Detalle de Pesca y Materiales'
lstr_1.Tipo_Cascada = 'C'
of_new_sheet(lstr_1)	


end event

