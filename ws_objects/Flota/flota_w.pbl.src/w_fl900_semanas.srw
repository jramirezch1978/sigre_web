$PBExportHeader$w_fl900_semanas.srw
forward
global type w_fl900_semanas from w_abc
end type
type st_1 from statictext within w_fl900_semanas
end type
type st_6 from statictext within w_fl900_semanas
end type
type em_ano from editmask within w_fl900_semanas
end type
type st_3 from statictext within w_fl900_semanas
end type
type st_2 from statictext within w_fl900_semanas
end type
type pb_2 from picturebutton within w_fl900_semanas
end type
type pb_aceptar from picturebutton within w_fl900_semanas
end type
end forward

global type w_fl900_semanas from w_abc
integer width = 1696
integer height = 1168
string title = "Generación de las semanas de pesca (FL900)"
string menuname = "m_mto_smpl"
event ue_aceptar ( )
st_1 st_1
st_6 st_6
em_ano em_ano
st_3 st_3
st_2 st_2
pb_2 pb_2
pb_aceptar pb_aceptar
end type
global w_fl900_semanas w_fl900_semanas

event ue_aceptar();string 	ls_mensaje
integer 	li_ano, li_ok

li_ano = integer(em_ano.text)

if li_ano = 0 or IsNull(li_ano) then
	MessageBox('Aviso', 'Año invalido, Verifique', StopSign!)
	return
end if

//create or replace procedure usp_fl_crea_semanas (
//       aii_anho in Integer, 
//       aso_mensaje out varchar2, 
//       aio_ok 			out number) is

DECLARE usp_fl_crea_semanas PROCEDURE FOR
	usp_fl_crea_semanas( :li_ano );

EXECUTE usp_fl_crea_semanas;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_fl_crea_semanas: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH usp_fl_crea_semanas INTO :ls_mensaje, :li_ok;
CLOSE usp_fl_crea_semanas;

if li_ok <> 1 then
	MessageBox('Error PROCEDURE usp_fl_crea_semanas', ls_mensaje, StopSign!)	
	return
end if

MessageBox('FLOTA', 'PROCESO REALIZADO SATISFACTORIAMENTE', StopSign!)	

return
end event

on w_fl900_semanas.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.st_1=create st_1
this.st_6=create st_6
this.em_ano=create em_ano
this.st_3=create st_3
this.st_2=create st_2
this.pb_2=create pb_2
this.pb_aceptar=create pb_aceptar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_6
this.Control[iCurrent+3]=this.em_ano
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.pb_aceptar
end on

on w_fl900_semanas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_6)
destroy(this.em_ano)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.pb_2)
destroy(this.pb_aceptar)
end on

event ue_open_pre;call super::ue_open_pre;em_ano.text = string( year( today() ) )

end event

type st_1 from statictext within w_fl900_semanas
integer x = 146
integer y = 16
integer width = 1243
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Generacion de Semanas de Pesca"
boolean focusrectangle = false
end type

type st_6 from statictext within w_fl900_semanas
integer x = 82
integer y = 404
integer width = 192
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type em_ano from editmask within w_fl900_semanas
integer x = 288
integer y = 384
integer width = 315
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
end type

type st_3 from statictext within w_fl900_semanas
integer x = 46
integer y = 244
integer width = 1445
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "de pesca (llamadas tambien semanas de produccion)."
boolean focusrectangle = false
end type

type st_2 from statictext within w_fl900_semanas
integer x = 46
integer y = 180
integer width = 1486
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proceso que tiene como finalidad generar las semanas"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_fl900_semanas
integer x = 791
integer y = 616
integer width = 315
integer height = 180
integer taborder = 30
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

event clicked;Close(parent)
end event

type pb_aceptar from picturebutton within w_fl900_semanas
integer x = 443
integer y = 616
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
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

