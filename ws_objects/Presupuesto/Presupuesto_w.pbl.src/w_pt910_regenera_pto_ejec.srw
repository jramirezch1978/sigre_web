$PBExportHeader$w_pt910_regenera_pto_ejec.srw
$PBExportComments$Adiciona articulos proyectados al presupuesto de materiales
forward
global type w_pt910_regenera_pto_ejec from w_abc
end type
type em_ano from editmask within w_pt910_regenera_pto_ejec
end type
type st_6 from statictext within w_pt910_regenera_pto_ejec
end type
type st_3 from statictext within w_pt910_regenera_pto_ejec
end type
type st_2 from statictext within w_pt910_regenera_pto_ejec
end type
type st_1 from statictext within w_pt910_regenera_pto_ejec
end type
type pb_2 from picturebutton within w_pt910_regenera_pto_ejec
end type
type pb_1 from picturebutton within w_pt910_regenera_pto_ejec
end type
end forward

global type w_pt910_regenera_pto_ejec from w_abc
integer width = 1673
integer height = 1016
string title = "Regenera presupuesto ejecutado (PT910)"
string menuname = "m_only_exit"
boolean toolbarvisible = false
em_ano em_ano
st_6 st_6
st_3 st_3
st_2 st_2
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_pt910_regenera_pto_ejec w_pt910_regenera_pto_ejec

on w_pt910_regenera_pto_ejec.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.em_ano=create em_ano
this.st_6=create st_6
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.st_6
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.pb_1
end on

on w_pt910_regenera_pto_ejec.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.st_6)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre();call super::ue_open_pre;of_center_window()


end event

type em_ano from editmask within w_pt910_regenera_pto_ejec
integer x = 750
integer y = 384
integer width = 315
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_6 from statictext within w_pt910_regenera_pto_ejec
integer x = 544
integer y = 404
integer width = 402
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

type st_3 from statictext within w_pt910_regenera_pto_ejec
integer x = 46
integer y = 232
integer width = 1509
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "ejecutado, en función a los gastos generados."
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt910_regenera_pto_ejec
integer x = 46
integer y = 168
integer width = 1573
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proceso que tiene como finalidad regenerar el presupuesto"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pt910_regenera_pto_ejec
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
string text = "Regenera presupuesto ejecutado"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_pt910_regenera_pto_ejec
integer x = 869
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

type pb_1 from picturebutton within w_pt910_regenera_pto_ejec
integer x = 494
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

event clicked;Long ll_ano
String ls_modo, ls_mensaje

if ISNULL( em_ano.text) OR TRIM(em_ano.text) = '' THEN
	Messagebox( "Error", "Ingrese año", exclamation!)
	em_ano.SetFocus()
	return
end if

ll_ano = Long(em_ano.text)

//create or replace procedure USP_PTO_ACT_PRESUP_PARTIDA(
//       an_ano cntbl_asiento.ano%type
//) is

DECLARE USP_PTO_ACT_PRESUP_PARTIDA PROCEDURE FOR 
	USP_PTO_ACT_PRESUP_PARTIDA(:ll_ano);
	
EXECUTE USP_PTO_ACT_PRESUP_PARTIDA;

if sqlca.sqlcode = -1 then   // Fallo
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error USP_PTO_ACT_PRESUP_PARTIDA", ls_mensaje, stopsign!)
	return 0
end if

CLOSE USP_PTO_ACT_PRESUP_PARTIDA;

MessageBox( 'Mensaje', "Proceso terminado" )

end event

