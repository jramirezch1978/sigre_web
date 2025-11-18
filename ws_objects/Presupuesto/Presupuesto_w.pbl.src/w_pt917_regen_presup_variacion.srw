$PBExportHeader$w_pt917_regen_presup_variacion.srw
$PBExportComments$Adiciona articulos proyectados al presupuesto de materiales
forward
global type w_pt917_regen_presup_variacion from w_abc
end type
type em_ano from editmask within w_pt917_regen_presup_variacion
end type
type st_6 from statictext within w_pt917_regen_presup_variacion
end type
type st_1 from statictext within w_pt917_regen_presup_variacion
end type
type pb_2 from picturebutton within w_pt917_regen_presup_variacion
end type
type pb_1 from picturebutton within w_pt917_regen_presup_variacion
end type
end forward

global type w_pt917_regen_presup_variacion from w_abc
integer width = 1673
integer height = 788
string title = "Regenera Variacion Presupuesto Partida (PT917)"
string menuname = "m_only_exit"
boolean toolbarvisible = false
em_ano em_ano
st_6 st_6
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_pt917_regen_presup_variacion w_pt917_regen_presup_variacion

on w_pt917_regen_presup_variacion.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.em_ano=create em_ano
this.st_6=create st_6
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.st_6
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_1
end on

on w_pt917_regen_presup_variacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.st_6)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre();call super::ue_open_pre;of_center_window()


end event

type em_ano from editmask within w_pt917_regen_presup_variacion
integer x = 677
integer y = 176
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

type st_6 from statictext within w_pt917_regen_presup_variacion
integer x = 471
integer y = 196
integer width = 187
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

type st_1 from statictext within w_pt917_regen_presup_variacion
integer x = 146
integer y = 16
integer width = 1435
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
string text = "Regenera Variacion Presupuesto Partida"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_pt917_regen_presup_variacion
integer x = 809
integer y = 344
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

type pb_1 from picturebutton within w_pt917_regen_presup_variacion
integer x = 434
integer y = 344
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

event clicked;Long 		ll_ano
String 	ls_modo, ls_mensaje

if ISNULL( em_ano.text) OR TRIM(em_ano.text) = '' THEN
	Messagebox( "Error", "Ingrese año", exclamation!)
	em_ano.SetFocus()
	return
end if

ll_ano = Long(em_ano.text)

//create or replace procedure USP_PTO_ACT_PRESUP_VARIACION(
//       an_ano number
//) is

DECLARE USP_PTO_ACT_PRESUP_VARIACION PROCEDURE FOR 
	USP_PTO_ACT_PRESUP_VARIACION(:ll_ano);
	
EXECUTE USP_PTO_ACT_PRESUP_VARIACION;

if sqlca.sqlcode = -1 then   // Fallo
	ls_mensaje = SQLCA.SQLErrText
	rollback ;
	Messagebox( "Error USP_PTO_ACT_PRESUP_VARIACION", ls_mensaje, stopsign!)
	return 0
end if

CLOSE USP_PTO_ACT_PRESUP_VARIACION;

MessageBox( 'Mensaje', "Proceso terminado satisfactoriamente" )

end event

