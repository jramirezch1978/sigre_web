$PBExportHeader$w_al908_act_fec_ult_sal.srw
forward
global type w_al908_act_fec_ult_sal from w_abc
end type
type st_1 from statictext within w_al908_act_fec_ult_sal
end type
type pb_2 from picturebutton within w_al908_act_fec_ult_sal
end type
type pb_1 from picturebutton within w_al908_act_fec_ult_sal
end type
end forward

global type w_al908_act_fec_ult_sal from w_abc
integer width = 2007
integer height = 716
string title = "Actualiza la fecha de ultima salida (AL908)"
string menuname = "m_salir"
boolean resizable = false
boolean center = true
event ue_aceptar ( )
event ue_salir ( )
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_al908_act_fec_ult_sal w_al908_act_fec_ult_sal

event ue_aceptar();SetPointer (HourGlass!)

string ls_mensaje, ls_null

SetNull(ls_null)

//create or replace procedure usp_alm_act_ult_sal_x_alm(
//       asi_nada             in  string,
//       aso_mensaje          out string,
//       aio_ok               out integer
//) is

DECLARE usp_alm_act_ult_sal_x_alm PROCEDURE FOR
	usp_alm_act_ult_sal_x_alm( :ls_null );

EXECUTE usp_alm_act_ult_sal_x_alm;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_act_ult_sal_x_alm: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetPointer (Arrow!)
	return 
END IF

CLOSE usp_alm_act_ult_sal_x_alm;

MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')

SetPointer (Arrow!)
end event

event ue_salir();close(this)
end event

on w_al908_act_fec_ult_sal.create
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

on w_al908_act_fec_ult_sal.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar(this)
end event

type st_1 from statictext within w_al908_act_fec_ult_sal
integer x = 46
integer y = 28
integer width = 1874
integer height = 220
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Actualiza la fecha de ultima salida"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_al908_act_fec_ult_sal
integer x = 1001
integer y = 324
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

type pb_1 from picturebutton within w_al908_act_fec_ult_sal
integer x = 626
integer y = 324
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

