$PBExportHeader$w_al903_act_ult_prec_comp.srw
forward
global type w_al903_act_ult_prec_comp from w_abc
end type
type st_1 from statictext within w_al903_act_ult_prec_comp
end type
type pb_2 from picturebutton within w_al903_act_ult_prec_comp
end type
type pb_1 from picturebutton within w_al903_act_ult_prec_comp
end type
end forward

global type w_al903_act_ult_prec_comp from w_abc
integer width = 2007
integer height = 716
string title = "Regenera Ultimo Precio de Compra (AL903)"
string menuname = "m_salir"
boolean resizable = false
event ue_aceptar ( )
event ue_salir ( )
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_al903_act_ult_prec_comp w_al903_act_ult_prec_comp

event ue_aceptar();SetPointer (HourGlass!)

string 	ls_mensaje, ls_null
integer	li_ok

SetNull(ls_null)

//create or replace procedure usp_alm_act_ult_comp_x_alm(
//       asi_nada             in  string,
//       aso_mensaje          out string,
//       aio_ok               out integer
//) is
DECLARE usp_alm_act_ult_comp_x_alm PROCEDURE FOR
	usp_alm_act_ult_comp_x_alm( :ls_null );

EXECUTE usp_alm_act_ult_comp_x_alm;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_act_ult_comp_x_alm: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetPointer (Arrow!)
	return 
END IF

fetch usp_alm_act_ult_comp_x_alm into :ls_mensaje, :li_ok;

CLOSE usp_alm_act_ult_comp_x_alm;

if li_ok <> 1 then
	ROLLBACK;
	MessageBox('Error usp_alm_act_ult_comp_x_alm', ls_mensaje, StopSign!)
	SetPointer (Arrow!)
	RETURN
end if


//create or replace procedure usp_alm_act_ult_comp(
//       asi_nada             in  string,
//       aso_mensaje          out string,
//       aio_ok               out integer
//) is

DECLARE usp_alm_act_ult_comp PROCEDURE FOR
	usp_alm_act_ult_comp( :ls_null );

EXECUTE usp_alm_act_ult_comp;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_alm_act_ult_comp: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetPointer (Arrow!)
	return 
END IF

fetch usp_alm_act_ult_comp into :ls_mensaje, :li_ok;

CLOSE usp_alm_act_ult_comp;

if li_ok <> 1 then
	ROLLBACK;
	MessageBox('Error usp_alm_act_ult_comp', ls_mensaje, StopSign!)
	SetPointer (Arrow!)
	RETURN
end if

MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')

SetPointer (Arrow!)
end event

event ue_salir();close(this)
end event

on w_al903_act_ult_prec_comp.create
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

on w_al903_act_ult_prec_comp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar(this)
end event

type st_1 from statictext within w_al903_act_ult_prec_comp
integer x = 114
integer y = 24
integer width = 1728
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
string text = "Regenera el Ultimo Precio de Compra del Articulo (en Dólares)"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_al903_act_ult_prec_comp
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
string picturename = "c:\sigre\resources\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type pb_1 from picturebutton within w_al903_act_ult_prec_comp
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
string picturename = "c:\sigre\resources\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

