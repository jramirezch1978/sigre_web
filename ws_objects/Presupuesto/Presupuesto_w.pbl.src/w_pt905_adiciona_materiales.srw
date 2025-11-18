$PBExportHeader$w_pt905_adiciona_materiales.srw
$PBExportComments$Adiciona materiales a articulo mov proy.
forward
global type w_pt905_adiciona_materiales from w_abc
end type
type cbx_rev from checkbox within w_pt905_adiciona_materiales
end type
type em_ano from editmask within w_pt905_adiciona_materiales
end type
type st_6 from statictext within w_pt905_adiciona_materiales
end type
type st_3 from statictext within w_pt905_adiciona_materiales
end type
type st_2 from statictext within w_pt905_adiciona_materiales
end type
type st_1 from statictext within w_pt905_adiciona_materiales
end type
type pb_2 from picturebutton within w_pt905_adiciona_materiales
end type
type pb_1 from picturebutton within w_pt905_adiciona_materiales
end type
end forward

global type w_pt905_adiciona_materiales from w_abc
integer width = 1673
integer height = 1016
string title = "Adiciona mov. proyectados (PT905)"
string menuname = "m_master"
boolean toolbarvisible = false
cbx_rev cbx_rev
em_ano em_ano
st_6 st_6
st_3 st_3
st_2 st_2
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_pt905_adiciona_materiales w_pt905_adiciona_materiales

on w_pt905_adiciona_materiales.create
int iCurrent
call super::create
if this.MenuName = "m_master" then this.MenuID = create m_master
this.cbx_rev=create cbx_rev
this.em_ano=create em_ano
this.st_6=create st_6
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_rev
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.st_6
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.pb_2
this.Control[iCurrent+8]=this.pb_1
end on

on w_pt905_adiciona_materiales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_rev)
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

type cbx_rev from checkbox within w_pt905_adiciona_materiales
boolean visible = false
integer x = 992
integer y = 388
integer width = 329
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Revertir "
boolean lefttext = true
end type

type em_ano from editmask within w_pt905_adiciona_materiales
integer x = 288
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

type st_6 from statictext within w_pt905_adiciona_materiales
integer x = 82
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

type st_3 from statictext within w_pt905_adiciona_materiales
integer x = 46
integer y = 232
integer width = 1518
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "del presupuesto de materiales al plan anual de compras."
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt905_adiciona_materiales
integer x = 46
integer y = 168
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
string text = "Proceso que tiene como finalidad adicionar los articulos"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pt905_adiciona_materiales
integer x = 146
integer y = 16
integer width = 1271
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
string text = "Adiciona Presupuesto de materiales"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_pt905_adiciona_materiales
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

type pb_1 from picturebutton within w_pt905_adiciona_materiales
integer x = 416
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

event clicked;Long ll_ano, ln_count
String ls_modo

if ISNULL( em_ano.text) OR TRIM(em_ano.text) = '' THEN
	Messagebox( "Error", "Ingrese año", exclamation!)
	em_ano.SetFocus()
	return
end if

ll_ano = Long(em_ano.text)
if cbx_rev.checked = true then
	ls_modo = 'R'
end if
SetPointer( Hourglass!)

DECLARE proc1 PROCEDURE FOR USP_PTO_ADICIONA_MAT(:ll_ano, :gs_user, :ls_modo, :gs_origen);
EXECUTE proc1;
if sqlca.sqlcode = -1 then   // Fallo
	Messagebox( "Error", sqlca.sqlerrtext, stopsign!)
	MessageBox( 'Error', "Procedimiento <<USP_PTO_ADICIONA_MOV_PROY>> no concluyo correctamente", StopSign! )
	rollback ;
	return 0
else
	MessageBox( 'Mensaje', "Proceso terminado" )
	commit ;
End If
close(parent)
end event

