$PBExportHeader$u_ingreso_rango_fechas.sru
$PBExportComments$Custom Object para ingreso de un rango de fechas
forward
global type u_ingreso_rango_fechas from userobject
end type
type shl_2 from statichyperlink within u_ingreso_rango_fechas
end type
type shl_1 from statichyperlink within u_ingreso_rango_fechas
end type
type em_1 from editmask within u_ingreso_rango_fechas
end type
type em_2 from editmask within u_ingreso_rango_fechas
end type
end forward

global type u_ingreso_rango_fechas from userobject
integer width = 1285
integer height = 92
long backcolor = 79741120
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_output ( )
shl_2 shl_2
shl_1 shl_1
em_1 em_1
em_2 em_2
end type
global u_ingreso_rango_fechas u_ingreso_rango_fechas

type variables
Date id_inicio, id_fin, id_f1
end variables

forward prototypes
public subroutine of_set_fecha (date ad_fecha)
public subroutine of_set_rango_inicio (date ad_fecha)
public subroutine of_set_rango_fin (date ad_fecha)
public subroutine of_set_label (string as_label1, string as_label2)
public subroutine of_set_fecha (date ad_fecha1, date ad_fecha2)
public function date of_get_fecha1 ()
public function date of_get_fecha2 ()
public subroutine of_enabled (boolean as_estado)
public subroutine of_set_enabled (boolean ab_estado)
end prototypes

public subroutine of_set_fecha (date ad_fecha);em_1.text = String(ad_fecha)
end subroutine

public subroutine of_set_rango_inicio (date ad_fecha);id_inicio = ad_fecha
end subroutine

public subroutine of_set_rango_fin (date ad_fecha);id_fin = ad_fecha
end subroutine

public subroutine of_set_label (string as_label1, string as_label2);shl_1.Text = as_label1

shl_2.Text = as_label2
end subroutine

public subroutine of_set_fecha (date ad_fecha1, date ad_fecha2);em_1.text = String(ad_fecha1)
em_2.text = String(ad_fecha2)
end subroutine

public function date of_get_fecha1 ();Date		ld_fecha
Integer	li_status

li_status = em_1.GetData(ld_fecha)

RETURN ld_fecha

end function

public function date of_get_fecha2 ();Date		ld_fecha
Integer	li_status

li_status = em_2.GetData(ld_fecha)

RETURN ld_fecha

end function

public subroutine of_enabled (boolean as_estado);this.em_1.enabled = as_estado
this.em_2.enabled = as_estado

this.shl_1.enabled = as_estado
this.shl_2.enabled = as_estado
end subroutine

public subroutine of_set_enabled (boolean ab_estado);
end subroutine

on u_ingreso_rango_fechas.create
this.shl_2=create shl_2
this.shl_1=create shl_1
this.em_1=create em_1
this.em_2=create em_2
this.Control[]={this.shl_2,&
this.shl_1,&
this.em_1,&
this.em_2}
end on

on u_ingreso_rango_fechas.destroy
destroy(this.shl_2)
destroy(this.shl_1)
destroy(this.em_1)
destroy(this.em_2)
end on

event constructor;//Date	ld_fecha_actual
//
//ld_fecha_actual = Date(gnvo_app.of_fecha_actual(true))
//
//of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
//of_set_fecha(ld_fecha_actual, gnvo_app.of_last_date(ld_fecha)) //para setear la fecha inicial
//of_set_rango_inicio(date('01/01/1900')) // rango inicial
//of_set_rango_fin(date('31/12/9999')) // rango final
end event

type shl_2 from statichyperlink within u_ingreso_rango_fechas
integer x = 645
integer y = 4
integer width = 247
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

event clicked;em_2.Event ue_calendar()
end event

type shl_1 from statichyperlink within u_ingreso_rango_fechas
integer x = 9
integer y = 4
integer width = 247
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

event clicked;em_1.Event ue_calendar()
end event

type em_1 from editmask within u_ingreso_rango_fechas
event ue_calendar ( )
event ue_validacion ( date ad_enter,  integer ai_cal )
integer x = 274
integer y = 4
integer width = 361
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

event ue_calendar;Long ls_rs
Date ld_enter

ls_rs = OpenWithParm(w_pb_calendar,THIS)

IF ls_rs <> 1 THEN
	MessageBox("Error","Error en la apertura del calendario")
ELSE
	THIS.EVENT ue_validacion(Date(this.text), 1)
END IF
end event

event ue_validacion(date ad_enter, integer ai_cal);IF ad_enter < id_inicio OR ad_enter > id_fin THEN
	//MessageBox("Error", "Fecha fuera del rango")
	em_1.SetFocus()
ELSE
	id_f1 = ad_enter
END IF


end event

event modified;THIS.EVENT ue_validacion(Date(THIS.text), 0)
end event

type em_2 from editmask within u_ingreso_rango_fechas
event ue_calendar ( )
event ue_validacion ( date ad_enter,  integer ai_cal )
integer x = 919
integer y = 4
integer width = 361
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

event ue_calendar();//Long ls_rs
//Date ld_enter
//
//ls_rs = OpenWithParm(w_pb_calendar,THIS)
//
//IF ls_rs <> 1 THEN
//	MessageBox("Error","Error en la apertura del calendario")
//ELSE
//	THIS.EVENT ue_validacion(Date(this.text), 1)
//END IF
//

end event

event ue_validacion(date ad_enter, integer ai_cal);IF ad_enter < id_inicio OR ad_enter > id_fin THEN
	//MessageBox("Error", "Fecha fuera del rango")
	em_2.SetFocus()
ELSE
	IF ad_enter < id_f1 THEN
		//MessageBox("Error", "Rango Inconsistente")
		em_2.SetFocus()
	ELSE
		PARENT.EVENT ue_output()
	END IF
END IF


end event

event modified;THIS.EVENT ue_validacion(Date(THIS.text), 0)
end event

