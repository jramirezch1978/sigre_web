$PBExportHeader$w_pt907_proc_operaciones.srw
forward
global type w_pt907_proc_operaciones from w_abc
end type
type st_8 from statictext within w_pt907_proc_operaciones
end type
type st_7 from statictext within w_pt907_proc_operaciones
end type
type cbx_1 from checkbox within w_pt907_proc_operaciones
end type
type em_ano from editmask within w_pt907_proc_operaciones
end type
type st_6 from statictext within w_pt907_proc_operaciones
end type
type st_5 from statictext within w_pt907_proc_operaciones
end type
type st_4 from statictext within w_pt907_proc_operaciones
end type
type st_3 from statictext within w_pt907_proc_operaciones
end type
type st_2 from statictext within w_pt907_proc_operaciones
end type
type st_1 from statictext within w_pt907_proc_operaciones
end type
type pb_2 from picturebutton within w_pt907_proc_operaciones
end type
type pb_1 from picturebutton within w_pt907_proc_operaciones
end type
end forward

global type w_pt907_proc_operaciones from w_abc
integer width = 1673
integer height = 1324
string title = "Precupuesto operaciones (PT907)"
string menuname = "m_master"
boolean toolbarvisible = false
st_8 st_8
st_7 st_7
cbx_1 cbx_1
em_ano em_ano
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_pt907_proc_operaciones w_pt907_proc_operaciones

type variables
String is_opcion

end variables

on w_pt907_proc_operaciones.create
int iCurrent
call super::create
if this.MenuName = "m_master" then this.MenuID = create m_master
this.st_8=create st_8
this.st_7=create st_7
this.cbx_1=create cbx_1
this.em_ano=create em_ano
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_8
this.Control[iCurrent+2]=this.st_7
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.pb_2
this.Control[iCurrent+12]=this.pb_1
end on

on w_pt907_proc_operaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.cbx_1)
destroy(this.em_ano)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre();call super::ue_open_pre;f_centrar( this)

ii_pregunta_delete = 1

is_opcion='G'
end event

type st_8 from statictext within w_pt907_proc_operaciones
integer x = 41
integer y = 500
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
string text = "y de campos propios."
boolean focusrectangle = false
end type

type st_7 from statictext within w_pt907_proc_operaciones
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
string text = "Solo considerará las operaciones de terceros (servicios)"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_pt907_proc_operaciones
integer x = 1079
integer y = 668
integer width = 402
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
end type

event clicked;Boolean lb_ok
lb_ok = cbx_1.Checked
IF lb_ok = TRUE then
	is_opcion='R'
else
	is_opcion='G'
end if

end event

type em_ano from editmask within w_pt907_proc_operaciones
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

type st_6 from statictext within w_pt907_proc_operaciones
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

type st_5 from statictext within w_pt907_proc_operaciones
integer x = 46
integer y = 364
integer width = 763
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "esten pendientes"
boolean focusrectangle = false
end type

type st_4 from statictext within w_pt907_proc_operaciones
integer x = 46
integer y = 300
integer width = 2647
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "informacion de las ordenes de trabajo cuyas operaciones"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pt907_proc_operaciones
integer x = 46
integer y = 232
integer width = 1426
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "para el presupuesto operativo, tomando como base la"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt907_proc_operaciones
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

type st_1 from statictext within w_pt907_proc_operaciones
integer x = 69
integer y = 16
integer width = 1897
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
string text = "Generacion de presupuesto de operaciones"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_pt907_proc_operaciones
integer x = 759
integer y = 852
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
string picturename = "\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(parent)
end event

type pb_1 from picturebutton within w_pt907_proc_operaciones
integer x = 384
integer y = 852
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
String ls_error

if ISNULL( em_ano.text) OR TRIM(em_ano.text) = '' THEN
	Messagebox( "Error", "Ingrese año", exclamation!)
	em_ano.SetFocus()
	return
end if

SetPointer(Hourglass!)

ll_ano = Long(em_ano.text)
DECLARE pb_usp_pto_labores PROCEDURE FOR USP_PTO_LABORES (:ll_ano, :is_opcion, :gs_user);
EXECUTE pb_usp_pto_labores;

ls_error = sqlca.sqlerrtext

if sqlca.sqlcode = -1 then   // Fallo
	rollback ;
	Messagebox( "Error", ls_error, stopsign!)
	MessageBox( 'Error', "Procedimiento <<USP_PTO_LABORES>> no concluyo correctamente", StopSign! )

	return 0
else
	commit ;
	MessageBox( 'Mensaje', "Proceso terminado" )
End If

close(parent)
end event

