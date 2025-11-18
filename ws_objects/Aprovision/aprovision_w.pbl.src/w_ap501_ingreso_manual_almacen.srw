$PBExportHeader$w_ap501_ingreso_manual_almacen.srw
forward
global type w_ap501_ingreso_manual_almacen from w_rpt
end type
type st_total_reg from statictext within w_ap501_ingreso_manual_almacen
end type
type st_1 from statictext within w_ap501_ingreso_manual_almacen
end type
type dw_origen from u_dw_abc within w_ap501_ingreso_manual_almacen
end type
type pb_1 from picturebutton within w_ap501_ingreso_manual_almacen
end type
type dw_report from u_dw_rpt within w_ap501_ingreso_manual_almacen
end type
end forward

global type w_ap501_ingreso_manual_almacen from w_rpt
integer width = 2871
integer height = 2024
string title = "Ingresos Manuales a Almacen   (AP501)"
string menuname = "m_consulta"
long backcolor = 67108864
st_total_reg st_total_reg
st_1 st_1
dw_origen dw_origen
pb_1 pb_1
dw_report dw_report
end type
global w_ap501_ingreso_manual_almacen w_ap501_ingreso_manual_almacen

type variables
Integer	ii_ss, il_LastRow
Boolean	ib_action_on_buttonup
dwobject	idwo_clicked

String  is_cod_origen []
end variables

forward prototypes
public function boolean of_verificar ()
end prototypes

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

long 		ll_i, ll_array
String 	ls_separador, ls_array[]
boolean	lb_ok

is_cod_origen = ls_array
ls_separador  = ''
lb_ok			  = True

ll_array = 1
// leer el dw_origen con los origenes seleccionados
For ll_i = 1 To dw_origen.RowCount()
	If dw_origen.Object.Chec[ll_i] = '1' Then
		is_cod_origen [ll_array] = dw_origen.Object.cod_origen[ll_i]
		ll_array ++
	end if
Next

IF UpperBound(is_cod_origen) = 0 THEN
	messagebox('Aprovisionamiento', 'Debe seleccionar al menos un origen para el Reporte')
	return lb_ok = False
END IF
//
//long 		ll_i
//String 	ls_separador
//boolean	lb_ok
//
//is_cod_origen = ''
//ls_separador  = ''
//lb_ok			  = True
//
//// leer el dw_origen con los origenes seleccionados
//For ll_i = 1 To dw_origen.RowCount()
//	If dw_origen.Object.Chec[ll_i] = '1' Then
//		if is_cod_origen <>'' THEN ls_separador = ', '
//		is_cod_origen = is_cod_origen + ls_separador + dw_origen.Object.cod_origen[ll_i]
//	end if
//Next
//
//IF LEN(is_cod_origen) = 0 THEN
//	messagebox('Aprovisionamiento', 'Debe seleccionar al menos un origen para el Reporte')
//	return lb_ok = False
//END IF
//
//
RETURN lb_ok






end function

on w_ap501_ingreso_manual_almacen.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.st_total_reg=create st_total_reg
this.st_1=create st_1
this.dw_origen=create dw_origen
this.pb_1=create pb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_total_reg
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_origen
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.dw_report
end on

on w_ap501_ingreso_manual_almacen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_total_reg)
destroy(this.st_1)
destroy(this.dw_origen)
destroy(this.pb_1)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;Long ll_row

idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
//THIS.Event ue_preview()
//This.Event ue_retrieve()

// Para mostrar los origenes
dw_origen.SetTransObject(sqlca)
dw_origen.Retrieve()
  
ll_row = dw_origen.Find ("cod_origen = '" + gs_origen +"'", 1, dw_origen.RowCount())

dw_origen.object.chec[ll_row] = '1'

end event

event ue_retrieve;call super::ue_retrieve;// Recuperar los datos de la consulta

IF NOT of_verificar() THEN RETURN

idw_1.SetRedraw(false)

// Recupera los datos para el Reporte
idw_1.Retrieve(is_cod_origen)
st_total_reg.text = String(idw_1.Rowcount( ))

idw_1.object.usuario_t.text 		= gs_user
idw_1.object.p_logo.filename 		= gs_logo

idw_1.Visible = True
idw_1.SetRedraw(true)
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

type st_total_reg from statictext within w_ap501_ingreso_manual_almacen
integer x = 2427
integer y = 228
integer width = 288
integer height = 92
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_1 from statictext within w_ap501_ingreso_manual_almacen
integer x = 1947
integer y = 244
integer width = 453
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Total Registros ="
boolean focusrectangle = false
end type

type dw_origen from u_dw_abc within w_ap501_ingreso_manual_almacen
integer x = 41
integer y = 20
integer width = 1001
integer height = 288
string dataobject = "d_ap_origen_liq_pesca_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type pb_1 from picturebutton within w_ap501_ingreso_manual_almacen
integer x = 1102
integer y = 60
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

type dw_report from u_dw_rpt within w_ap501_ingreso_manual_almacen
integer x = 23
integer y = 336
integer width = 2720
integer height = 1232
string dataobject = "d_ap_cns_movimiento_ingreso_manual_tbl"
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

