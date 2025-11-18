$PBExportHeader$u_ingreso_fec_hrs.sru
$PBExportComments$Custom Object para ingreso de un rango de fechas
forward
global type u_ingreso_fec_hrs from userobject
end type
type cb_1 from commandbutton within u_ingreso_fec_hrs
end type
type em_1 from editmask within u_ingreso_fec_hrs
end type
type em_2 from editmask within u_ingreso_fec_hrs
end type
type cb_2 from commandbutton within u_ingreso_fec_hrs
end type
end forward

global type u_ingreso_fec_hrs from userobject
integer width = 1088
integer height = 192
long backcolor = 79741120
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_output ( )
cb_1 cb_1
em_1 em_1
em_2 em_2
cb_2 cb_2
end type
global u_ingreso_fec_hrs u_ingreso_fec_hrs

type variables
DateTime idt_inicio, idt_fin, idt_f1
end variables

forward prototypes
public function datetime of_get_fecha1 ()
public function datetime of_get_fecha2 ()
public subroutine of_set_fecha (datetime adt_fecha)
public subroutine of_set_fecha (datetime adt_fecha1, datetime adt_fecha2)
public subroutine of_set_label (string as_label1, string as_label2)
public subroutine of_set_rango_fin (datetime adt_fecha)
public subroutine of_set_rango_inicio (datetime adt_fecha)
end prototypes

public function datetime of_get_fecha1 ();DateTime		ldt_fecha
Integer	li_status

li_status = em_1.GetData(ldt_fecha)

RETURN ldt_fecha

end function

public function datetime of_get_fecha2 ();DateTime		ldt_fecha
Integer	li_status

li_status = em_2.GetData(ldt_fecha)

RETURN ldt_fecha

end function

public subroutine of_set_fecha (datetime adt_fecha);em_1.text = String(adt_fecha)
end subroutine

public subroutine of_set_fecha (datetime adt_fecha1, datetime adt_fecha2);em_1.text = String(adt_fecha1)
em_2.text = String(adt_fecha2)
end subroutine

public subroutine of_set_label (string as_label1, string as_label2);cb_1.Text = as_label1

cb_2.Text = as_label2
end subroutine

public subroutine of_set_rango_fin (datetime adt_fecha);idt_fin = adt_fecha
end subroutine

public subroutine of_set_rango_inicio (datetime adt_fecha);idt_inicio = adt_fecha
end subroutine

on u_ingreso_fec_hrs.create
this.cb_1=create cb_1
this.em_1=create em_1
this.em_2=create em_2
this.cb_2=create cb_2
this.Control[]={this.cb_1,&
this.em_1,&
this.em_2,&
this.cb_2}
end on

on u_ingreso_fec_hrs.destroy
destroy(this.cb_1)
destroy(this.em_1)
destroy(this.em_2)
destroy(this.cb_2)
end on

event constructor;of_set_label('Desde:','Hasta:')// para seatear el titulo del boton 
of_set_fecha(DateTime('01/01/1900'), DateTime('31/12/9999')) //para setear la fecha inicial
of_set_rango_inicio(datetime('01/01/1900')) // rango inicial
of_set_rango_fin(datetime('31/12/9999')) // rango final
end event

type cb_1 from commandbutton within u_ingreso_fec_hrs
integer x = 5
integer y = 4
integer width = 539
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;em_1.Event ue_calendar()
end event

type em_1 from editmask within u_ingreso_fec_hrs
event ue_calendar ( )
event ue_validacion ( datetime adt_enter,  integer ai_cal )
integer x = 549
integer y = 4
integer width = 517
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "dd/mm/yyyy hh:mm:ss"
end type

event ue_calendar();Long ls_rs
Date ld_enter

ls_rs = OpenWithParm(w_pb_calendar,THIS)

IF ls_rs <> 1 THEN
	MessageBox("Error","Error en la apertura del calendario")
ELSE
	THIS.EVENT ue_validacion(DateTime(this.text), 1)
END IF
end event

event ue_validacion(datetime adt_enter, integer ai_cal);IF adt_enter < idt_inicio OR adt_enter > idt_fin THEN
	MessageBox("Error", "Fecha fuera del rango")
	IF ai_cal = 1 THEN
		cb_1.SetFocus()
	ELSE
		em_1.SetFocus()
	END IF
ELSE
	idt_f1 = adt_enter
END IF


end event

event modified;THIS.EVENT ue_validacion(DateTime(THIS.text), 0)
end event

type em_2 from editmask within u_ingreso_fec_hrs
event ue_calendar ( )
event ue_validacion ( datetime adt_enter,  integer ai_cal )
integer x = 549
integer y = 96
integer width = 517
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "dd/mm/yyyy hh:mm:ss"
end type

event ue_calendar();Long ls_rs
Date ld_enter

ls_rs = OpenWithParm(w_pb_calendar,THIS)

IF ls_rs <> 1 THEN
	MessageBox("Error","Error en la apertura del calendario")
ELSE
	THIS.EVENT ue_validacion(DateTime(this.text), 1)
END IF


end event

event ue_validacion(datetime adt_enter, integer ai_cal);IF adt_enter < idt_inicio OR adt_enter > idt_fin THEN
	MessageBox("Error", "Fecha fuera del rango")
	IF ai_cal = 1 THEN
		cb_2.SetFocus()
	ELSE
		em_2.SetFocus()
	END IF
ELSE
	IF adt_enter < idt_f1 THEN
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

event modified;THIS.EVENT ue_validacion(DateTime(THIS.text), 0)
end event

type cb_2 from commandbutton within u_ingreso_fec_hrs
integer x = 5
integer y = 96
integer width = 539
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;em_2.Event ue_calendar()
end event

