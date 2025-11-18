$PBExportHeader$u_ingreso_fecha.sru
$PBExportComments$Custom object para ingreso de una fecha
forward
global type u_ingreso_fecha from userobject
end type
type cb_1 from commandbutton within u_ingreso_fecha
end type
type em_1 from editmask within u_ingreso_fecha
end type
end forward

global type u_ingreso_fecha from userobject
integer width = 608
integer height = 88
long backcolor = 79741120
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_output ( )
cb_1 cb_1
em_1 em_1
end type
global u_ingreso_fecha u_ingreso_fecha

type variables
Date id_inicio, id_fin
end variables

forward prototypes
public function date of_get_fecha ()
public subroutine of_set_label (string as_label)
public subroutine of_set_fecha (date ad_fecha)
public subroutine of_set_rango_inicio (date ad_fecha)
public subroutine of_set_rango_fin (date ad_fecha)
end prototypes

public function date of_get_fecha ();Date		ld_fecha
Integer	li_status

li_status = em_1.GetData(ld_fecha)

RETURN ld_fecha

end function

public subroutine of_set_label (string as_label);cb_1.Text = as_label
end subroutine

public subroutine of_set_fecha (date ad_fecha);em_1.text = String(ad_fecha)
end subroutine

public subroutine of_set_rango_inicio (date ad_fecha);id_inicio = ad_fecha
end subroutine

public subroutine of_set_rango_fin (date ad_fecha);id_fin = ad_fecha
end subroutine

on u_ingreso_fecha.create
this.cb_1=create cb_1
this.em_1=create em_1
this.Control[]={this.cb_1,&
this.em_1}
end on

on u_ingreso_fecha.destroy
destroy(this.cb_1)
destroy(this.em_1)
end on

event constructor;// of_set_label('Desde:') // para seatear el titulo del boton
// of_set_fecha(date('31/12/9999')) //para setear la fecha inicial
// of_set_rango_inicio(date('01/01/1900')) // rango inicial
// of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha()  para leer las fechas

end event

type cb_1 from commandbutton within u_ingreso_fecha
integer x = 5
integer width = 247
integer height = 76
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;em_1.Event ue_calendar()
end event

type em_1 from editmask within u_ingreso_fecha
event ue_calendar ( )
event ue_validacion ( date ad_enter,  integer ai_cal )
integer x = 261
integer width = 338
integer height = 76
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
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

event ue_validacion;Integer li_rc = 1

IF ad_enter < id_inicio THEN
	MessageBox("Error", "Fecha por debajo del limite")
	li_rc = -1
ELSE
	IF ad_enter > id_fin THEN
		MessageBox("Error", "Fecha sobre el limite")
		li_rc = -1
	END IF
END IF


IF li_rc = -1 THEN
	IF ai_cal = 1 THEN
		cb_1.SetFocus()
	ELSE
		em_1.SetFocus()
	END IF
ELSE
	PARENT.EVENT ue_output()
END IF


end event

event modified;
THIS.EVENT ue_validacion(Date(em_1.text), 0)


end event

