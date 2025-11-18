$PBExportHeader$w_cm904_update_flac_oc_ov.srw
forward
global type w_cm904_update_flac_oc_ov from w_abc
end type
type st_1 from statictext within w_cm904_update_flac_oc_ov
end type
type pb_2 from picturebutton within w_cm904_update_flac_oc_ov
end type
type pb_1 from picturebutton within w_cm904_update_flac_oc_ov
end type
end forward

global type w_cm904_update_flac_oc_ov from w_abc
integer width = 2007
integer height = 600
string title = "Actualiza "
string menuname = "m_salir"
boolean resizable = false
boolean center = true
event ue_aceptar ( )
event ue_salir ( )
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_cm904_update_flac_oc_ov w_cm904_update_flac_oc_ov

event ue_aceptar();string ls_mensaje, ls_null

SetNull(ls_null)

//create or replace procedure USP_CMP_UPDATE_FLAG_OC_OV(
//       ls_nada in varchar2
//) is

DECLARE USP_CMP_UPDATE_FLAG_OC_OV PROCEDURE FOR
	USP_CMP_UPDATE_FLAG_OC_OV( :ls_null );

EXECUTE USP_CMP_UPDATE_FLAG_OC_OV;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_CMP_UPDATE_FLAG_OC_OV:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return
END IF

CLOSE USP_CMP_UPDATE_FLAG_OC_OV;

MessageBox('Aviso', 'Proceso ejecutado satisfactoriamente')
end event

event ue_salir();close(this)
end event

on w_cm904_update_flac_oc_ov.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_1
end on

on w_cm904_update_flac_oc_ov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar(this)
end event

type st_1 from statictext within w_cm904_update_flac_oc_ov
integer width = 1984
integer height = 140
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Actualiza el Flag Estado en OC y OV"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_cm904_update_flac_oc_ov
integer x = 1001
integer y = 188
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type pb_1 from picturebutton within w_cm904_update_flac_oc_ov
integer x = 626
integer y = 188
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

