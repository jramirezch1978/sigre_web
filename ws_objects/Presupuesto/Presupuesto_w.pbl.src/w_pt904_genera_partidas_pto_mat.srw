$PBExportHeader$w_pt904_genera_partidas_pto_mat.srw
$PBExportComments$Genera partidas del presupuesto de materiales
forward
global type w_pt904_genera_partidas_pto_mat from w_abc
end type
type st_7 from statictext within w_pt904_genera_partidas_pto_mat
end type
type cbx_rev from checkbox within w_pt904_genera_partidas_pto_mat
end type
type em_ano from editmask within w_pt904_genera_partidas_pto_mat
end type
type st_6 from statictext within w_pt904_genera_partidas_pto_mat
end type
type st_4 from statictext within w_pt904_genera_partidas_pto_mat
end type
type st_3 from statictext within w_pt904_genera_partidas_pto_mat
end type
type st_2 from statictext within w_pt904_genera_partidas_pto_mat
end type
type st_1 from statictext within w_pt904_genera_partidas_pto_mat
end type
type pb_2 from picturebutton within w_pt904_genera_partidas_pto_mat
end type
type pb_1 from picturebutton within w_pt904_genera_partidas_pto_mat
end type
end forward

global type w_pt904_genera_partidas_pto_mat from w_abc
integer width = 1673
integer height = 1324
string title = "Generacion de partidas (PT904)"
string menuname = "m_master"
boolean toolbarvisible = false
st_7 st_7
cbx_rev cbx_rev
em_ano em_ano
st_6 st_6
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_pt904_genera_partidas_pto_mat w_pt904_genera_partidas_pto_mat

on w_pt904_genera_partidas_pto_mat.create
int iCurrent
call super::create
if this.MenuName = "m_master" then this.MenuID = create m_master
this.st_7=create st_7
this.cbx_rev=create cbx_rev
this.em_ano=create em_ano
this.st_6=create st_6
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_7
this.Control[iCurrent+2]=this.cbx_rev
this.Control[iCurrent+3]=this.em_ano
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.pb_1
end on

on w_pt904_genera_partidas_pto_mat.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_7)
destroy(this.cbx_rev)
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

type st_7 from statictext within w_pt904_genera_partidas_pto_mat
integer x = 46
integer y = 432
integer width = 1554
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Una vez generada esta informacion no podra ser alterada."
boolean focusrectangle = false
end type

type cbx_rev from checkbox within w_pt904_genera_partidas_pto_mat
integer x = 960
integer y = 664
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

type em_ano from editmask within w_pt904_genera_partidas_pto_mat
integer x = 256
integer y = 660
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

type st_6 from statictext within w_pt904_genera_partidas_pto_mat
integer x = 50
integer y = 680
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

type st_4 from statictext within w_pt904_genera_partidas_pto_mat
integer x = 46
integer y = 300
integer width = 1454
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "informacion el presupuesto de materiales."
boolean focusrectangle = false
end type

type st_3 from statictext within w_pt904_genera_partidas_pto_mat
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
string text = "para el presupuesto de materiales, tomando como "
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt904_genera_partidas_pto_mat
integer x = 46
integer y = 168
integer width = 1431
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proceso que tiene como finalidad generar las partidas"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pt904_genera_partidas_pto_mat
integer x = 297
integer y = 16
integer width = 850
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
string text = "Generacion de partidas"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_pt904_genera_partidas_pto_mat
integer x = 759
integer y = 892
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

type pb_1 from picturebutton within w_pt904_genera_partidas_pto_mat
integer x = 384
integer y = 892
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

SETPOINTER( hourglass!)

ll_ano = Long(em_ano.text)
if cbx_rev.checked = true then
	ls_modo = 'R'
else
	ls_modo = 'G'
end if

DECLARE proc1 PROCEDURE FOR USP_PTO_APRUEBA_DETALLE (:ll_ano, :gs_origen, :gs_user, :ls_modo);
EXECUTE proc1;
if sqlca.sqlcode = -1 then   // Fallo
	Messagebox( "Error", sqlca.sqlerrtext, stopsign!)
	MessageBox( 'Error', "Procedimiento <<USP_PTO_APRUEBA_DETALLE>> no concluyo correctamente", StopSign! )
	rollback ;
	return 0
else
	MessageBox( 'Mensaje', "Proceso terminado" )
	commit ;
End If
close(parent)
end event

