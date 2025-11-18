$PBExportHeader$w_pt902_valoriza_pto_detalle.srw
forward
global type w_pt902_valoriza_pto_detalle from w_abc
end type
type em_ano from editmask within w_pt902_valoriza_pto_detalle
end type
type st_6 from statictext within w_pt902_valoriza_pto_detalle
end type
type st_4 from statictext within w_pt902_valoriza_pto_detalle
end type
type st_3 from statictext within w_pt902_valoriza_pto_detalle
end type
type st_2 from statictext within w_pt902_valoriza_pto_detalle
end type
type st_1 from statictext within w_pt902_valoriza_pto_detalle
end type
type pb_2 from picturebutton within w_pt902_valoriza_pto_detalle
end type
type pb_1 from picturebutton within w_pt902_valoriza_pto_detalle
end type
end forward

global type w_pt902_valoriza_pto_detalle from w_abc
integer width = 1673
integer height = 952
string title = "Valorizacion (PT902)"
string menuname = "m_master"
boolean toolbarvisible = false
em_ano em_ano
st_6 st_6
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_pt902_valoriza_pto_detalle w_pt902_valoriza_pto_detalle

on w_pt902_valoriza_pto_detalle.create
int iCurrent
call super::create
if this.MenuName = "m_master" then this.MenuID = create m_master
this.em_ano=create em_ano
this.st_6=create st_6
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.st_6
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.pb_2
this.Control[iCurrent+8]=this.pb_1
end on

on w_pt902_valoriza_pto_detalle.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.st_6)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre();call super::ue_open_pre;of_center_window()


end event

type em_ano from editmask within w_pt902_valoriza_pto_detalle
integer x = 270
integer y = 552
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

type st_6 from statictext within w_pt902_valoriza_pto_detalle
integer x = 64
integer y = 572
integer width = 165
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

type st_4 from statictext within w_pt902_valoriza_pto_detalle
integer x = 46
integer y = 300
integer width = 1490
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ver posteriormente la consistencia si existieran errores."
boolean focusrectangle = false
end type

type st_3 from statictext within w_pt902_valoriza_pto_detalle
integer x = 46
integer y = 232
integer width = 1358
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "solicitados con el ultimo precio de compra."
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt902_valoriza_pto_detalle
integer x = 46
integer y = 168
integer width = 1513
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proceso que tiene como finalidad valorizar los materiales"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pt902_valoriza_pto_detalle
integer x = 69
integer y = 16
integer width = 1390
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
string text = "Valorizacion de presupuesto Materiales"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_pt902_valoriza_pto_detalle
integer x = 1243
integer y = 520
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

type pb_1 from picturebutton within w_pt902_valoriza_pto_detalle
integer x = 869
integer y = 520
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

event clicked;Long ll_ano, ln_count

if ISNULL( em_ano.text) OR TRIM(em_ano.text) = '' THEN
	Messagebox( "Error", "Ingrese año", exclamation!)
	em_ano.SetFocus()
	return
end if

ll_ano = Long(em_ano.text)
SetPointer(Hourglass!)

DECLARE proc1 PROCEDURE FOR USP_PTO_VALORIZA_MATERIALES (:ll_ano);
EXECUTE proc1;
if sqlca.sqlcode = -1 then   // Fallo
	Messagebox( "Error", sqlca.sqlerrtext, stopsign!)
	MessageBox( 'Error', "Procedimiento <<USP_PTO_VALORIZA_MATERIALES>> no concluyo correctamente", StopSign! )
	rollback ;
	return 0
else
	MessageBox( 'Mensaje', "Proceso terminado" )
	commit ;
End If 
close(parent)
end event

