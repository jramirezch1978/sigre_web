$PBExportHeader$w_af710_fecha_adquisicion.srw
forward
global type w_af710_fecha_adquisicion from w_rpt
end type
type dw_origen from u_dw_abc within w_af710_fecha_adquisicion
end type
type pb_1 from picturebutton within w_af710_fecha_adquisicion
end type
type uo_fecha from u_ingreso_rango_fechas within w_af710_fecha_adquisicion
end type
type dw_report from u_dw_rpt within w_af710_fecha_adquisicion
end type
type gb_1 from groupbox within w_af710_fecha_adquisicion
end type
end forward

global type w_af710_fecha_adquisicion from w_rpt
integer width = 3598
integer height = 1936
string title = "(AF710) Activos Según Fecha de Adquisición"
string menuname = "m_reporte"
long backcolor = 134217750
event ue_query_retrieve ( )
dw_origen dw_origen
pb_1 pb_1
uo_fecha uo_fecha
dw_report dw_report
gb_1 gb_1
end type
global w_af710_fecha_adquisicion w_af710_fecha_adquisicion

type variables

end variables

forward prototypes
public function boolean of_verificar (ref string as_cod_origen[])
end prototypes

event ue_query_retrieve();this.event dynamic ue_retrieve()
end event

public function boolean of_verificar (ref string as_cod_origen[]);// Verifica que no falten parametros para el reporte
long 		ll_i, ll_j
Boolean	lb_ok

lb_ok			  = True

// leer el dw_origen con los origenes seleccionados
ll_j = 1

FOR ll_i = 1 To dw_origen.RowCount()
	IF dw_origen.Object.Chec[ll_i] = '1' THEN
		as_cod_origen [ll_j] = dw_origen.Object.cod_origen[ll_i]
		ll_j ++
	END IF
NEXT

IF UpperBound(as_cod_origen) = 0 THEN
	messagebox('Activo Fijo', 'Debe seleccionar al menos un origen para el Reporte')
	RETURN lb_ok = False
END IF

RETURN lb_ok

end function

on w_af710_fecha_adquisicion.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_origen=create dw_origen
this.pb_1=create pb_1
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_origen
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.dw_report
this.Control[iCurrent+5]=this.gb_1
end on

on w_af710_fecha_adquisicion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_origen)
destroy(this.pb_1)
destroy(this.uo_fecha)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_cod_origen[]
date 		ld_fecha_ini, ld_fecha_fin


//ls_rango_fecha, ls_especie

// Llama a la función para verificar
IF NOT of_verificar(ls_cod_origen) THEN RETURN

ld_fecha_ini = date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin = date(uo_fecha.of_get_fecha2( ))

idw_1.SetRedraw(false)

//Recupera los datos del reporte

idw_1.Retrieve(ld_fecha_ini, ld_fecha_fin, ls_cod_origen)

//ls_rango_fecha = 'Del ' + string(ld_fecha_ini) + ' Al ' + string (ld_fecha_fin)
//
idw_1.object.usuario_t.text 		= gs_user
idw_1.object.p_logo.filename 		= gs_logo
//idw_1.object.rango_1.text			= ls_rango_fecha
//
idw_1.Visible = True
idw_1.SetRedraw(true)
end event

event ue_open_pre;call super::ue_open_pre;long ll_row

idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)

// Para mostrar los origenes
dw_origen.SetTransObject(sqlca)
dw_origen.Retrieve()
  
ll_row = dw_origen.Find ("cod_origen = '" + gs_origen +"'", 1, dw_origen.RowCount())

dw_origen.object.chec[ll_row] = '1'



THIS.Event ue_preview()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
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

type dw_origen from u_dw_abc within w_af710_fecha_adquisicion
integer x = 1541
integer y = 40
integer width = 1001
integer height = 260
integer taborder = 30
string dataobject = "d_origenes_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type pb_1 from picturebutton within w_af710_fecha_adquisicion
integer x = 2853
integer y = 108
integer width = 306
integer height = 148
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

type uo_fecha from u_ingreso_rango_fechas within w_af710_fecha_adquisicion
integer x = 128
integer y = 172
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

type dw_report from u_dw_rpt within w_af710_fecha_adquisicion
integer x = 41
integer y = 380
integer width = 3470
integer height = 1032
string dataobject = "dw_rpt_fecha_adquisicion_tbl"
end type

type gb_1 from groupbox within w_af710_fecha_adquisicion
integer x = 82
integer y = 84
integer width = 1385
integer height = 216
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha de Adquisición"
end type

