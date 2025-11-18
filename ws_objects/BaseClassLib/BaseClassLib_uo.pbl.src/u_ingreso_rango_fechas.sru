$PBExportHeader$u_ingreso_rango_fechas.sru
$PBExportComments$Custom Object para ingreso de un rango de fechas
forward
global type u_ingreso_rango_fechas from userobject
end type
type cb_1 from commandbutton within u_ingreso_rango_fechas
end type
type em_1 from editmask within u_ingreso_rango_fechas
end type
type em_2 from editmask within u_ingreso_rango_fechas
end type
type cb_2 from commandbutton within u_ingreso_rango_fechas
end type
end forward

global type u_ingreso_rango_fechas from userobject
integer width = 1285
integer height = 92
long backcolor = 79741120
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_output ( )
cb_1 cb_1
em_1 em_1
em_2 em_2
cb_2 cb_2
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
end prototypes

public subroutine of_set_fecha (date ad_fecha);em_1.text = String(ad_fecha)
end subroutine

public subroutine of_set_rango_inicio (date ad_fecha);id_inicio = ad_fecha
end subroutine

public subroutine of_set_rango_fin (date ad_fecha);id_fin = ad_fecha
end subroutine

public subroutine of_set_label (string as_label1, string as_label2);cb_1.Text = as_label1

cb_2.Text = as_label2
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

on u_ingreso_rango_fechas.create
this.cb_1=create cb_1
this.em_1=create em_1
this.em_2=create em_2
this.cb_2=create cb_2
this.Control[]={this.cb_1,&
this.em_1,&
this.em_2,&
this.cb_2}
end on

on u_ingreso_rango_fechas.destroy
destroy(this.cb_1)
destroy(this.em_1)
destroy(this.em_2)
destroy(this.cb_2)
end on

event constructor;// of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
// of_set_fecha(date('01/01/1900'), date('31/12/9999') //para setear la fecha inicial
// of_set_rango_inicio(date('01/01/1900')) // rango inicial
// of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cb_1 from commandbutton within u_ingreso_rango_fechas
integer x = 5
integer y = 4
integer width = 247
integer height = 76
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;em_1.Event ue_calendar()
end event

type em_1 from editmask within u_ingreso_rango_fechas
event ue_calendar ( )
event ue_validacion ( date ad_enter,  integer ai_cal )
integer x = 270
integer y = 4
integer width = 338
integer height = 76
integer taborder = 30
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

event ue_validacion;IF ad_enter < id_inicio OR ad_enter > id_fin THEN
	MessageBox("Error", "Fecha fuera del rango")
	IF ai_cal = 1 THEN
		cb_1.SetFocus()
	ELSE
		em_1.SetFocus()
	END IF
ELSE
	id_f1 = ad_enter
END IF


end event

event modified;THIS.EVENT ue_validacion(Date(THIS.text), 0)
end event

type em_2 from editmask within u_ingreso_rango_fechas
event ue_calendar ( )
event ue_validacion ( date ad_enter,  integer ai_cal )
integer x = 937
integer y = 4
integer width = 338
integer height = 76
integer taborder = 20
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

event ue_validacion;IF ad_enter < id_inicio OR ad_enter > id_fin THEN
	MessageBox("Error", "Fecha fuera del rango")
	IF ai_cal = 1 THEN
		cb_2.SetFocus()
	ELSE
		em_2.SetFocus()
	END IF
ELSE
	IF ad_enter < id_f1 THEN
		MessageBox("Error", "Rango Inconsistente")
		IF ai_cal = 1 THEN
			cb_2.SetFocus()
		ELSE
			em_2.SetFocus()
		END IF
	ELSE
		PARENT.EVENT ue_output()
	END IF
END IF


end event

event modified;THIS.EVENT ue_validacion(Date(THIS.text), 0)
end event

type cb_2 from commandbutton within u_ingreso_rango_fechas
integer x = 672
integer y = 4
integer width = 247
integer height = 76
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;em_2.Event ue_calendar()
end event

