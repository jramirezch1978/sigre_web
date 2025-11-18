$PBExportHeader$w_fl901_presupuesto_new.srw
forward
global type w_fl901_presupuesto_new from w_abc
end type
type em_1 from editmask within w_fl901_presupuesto_new
end type
type cb_1 from commandbutton within w_fl901_presupuesto_new
end type
end forward

global type w_fl901_presupuesto_new from w_abc
integer width = 1303
integer height = 360
string title = "Generación de Presupuesto (FL901)"
string menuname = "m_mto_smpl"
em_1 em_1
cb_1 cb_1
end type
global w_fl901_presupuesto_new w_fl901_presupuesto_new

on w_fl901_presupuesto_new.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.em_1=create em_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_1
this.Control[iCurrent+2]=this.cb_1
end on

on w_fl901_presupuesto_new.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_1)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;em_1.text = string(Today(), 'yyyy')
end event

type em_1 from editmask within w_fl901_presupuesto_new
integer x = 37
integer y = 32
integer width = 389
integer height = 80
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
string mask = "####"
boolean spin = true
double increment = 1
end type

type cb_1 from commandbutton within w_fl901_presupuesto_new
integer x = 626
integer y = 24
integer width = 594
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar Presupuesto"
end type

event clicked;integer li_anho, li_estado

li_anho = integer(trim(em_1.text))
//li_estado = 1
li_estado = 99
declare usp_fl_genera_presupuesto procedure for
	usp_fl_genera_presupuesto(:li_anho,:gs_user);

execute usp_fl_genera_presupuesto;

fetch usp_fl_genera_presupuesto into :li_estado;

close usp_fl_genera_presupuesto;

choose case li_estado
	case 0
		messagebox('Flota','Se ha generado el presupuesto para el año '+trim(string(li_anho)),Exclamation!,Ok!)
   case 1
		messagebox('Flota', 'Ya existen registros con la misma cuenta presupuestal y centro de costos para presupuesto del año '+trim(string(li_anho)),StopSign!)
   case 2
		messagebox('Flota', 'No existen plantillas asignadas a las naves para el presupuesto del año '+trim(string(li_anho)),StopSign!)
	case else
		messagebox('Flota', 'Error al ejecutar el procedimiento de cálculo de presupuesto',StopSign!)
end choose

end event

