$PBExportHeader$u_em_date.sru
forward
global type u_em_date from editmask
end type
end forward

global type u_em_date from editmask
int Width=343
int Height=84
int TabOrder=10
Alignment Alignment=Center!
BorderStyle BorderStyle=StyleLowered!
string Mask="dd/mm/yyyy"
MaskDataType MaskDataType=DateMask!
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event ue_calendar ( )
event ue_validacion ( date ad_enter,  integer ai_cal )
end type
global u_em_date u_em_date

type variables
Date id_inicio, id_fin
end variables

event ue_calendar;Long ls_rs
Date ld_enter

ls_rs = OpenWithParm(w_pb_calendar,THIS)

IF ls_rs <> 1 THEN
	MessageBox("Error","Error en la apertura del calendario")
ELSE
//	THIS.EVENT ue_validacion(Date(this.text), 1)
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


//IF li_rc = -1 THEN
//	IF ai_cal = 1 THEN
//		cb_1.SetFocus()
//	ELSE
//		THIS.SetFocus()
//	END IF
//ELSE
//	PARENT.EVENT DYNAMIC ue_output()
//END IF

end event

