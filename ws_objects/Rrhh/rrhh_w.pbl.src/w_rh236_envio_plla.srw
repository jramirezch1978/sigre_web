$PBExportHeader$w_rh236_envio_plla.srw
forward
global type w_rh236_envio_plla from w_abc_master
end type
type rb_3 from radiobutton within w_rh236_envio_plla
end type
type rb_1 from radiobutton within w_rh236_envio_plla
end type
type p_1 from picture within w_rh236_envio_plla
end type
type st_1 from statictext within w_rh236_envio_plla
end type
type gb_2 from groupbox within w_rh236_envio_plla
end type
end forward

global type w_rh236_envio_plla from w_abc_master
integer width = 3465
integer height = 2432
string title = "[RH236] Envio a Planilla de Calculo"
string menuname = "m_modifica_graba"
rb_3 rb_3
rb_1 rb_1
p_1 p_1
st_1 st_1
gb_2 gb_2
end type
global w_rh236_envio_plla w_rh236_envio_plla

on w_rh236_envio_plla.create
int iCurrent
call super::create
if this.MenuName = "m_modifica_graba" then this.MenuID = create m_modifica_graba
this.rb_3=create rb_3
this.rb_1=create rb_1
this.p_1=create p_1
this.st_1=create st_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_3
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.gb_2
end on

on w_rh236_envio_plla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_3)
destroy(this.rb_1)
destroy(this.p_1)
destroy(this.st_1)
destroy(this.gb_2)
end on

event ue_modify;call super::ue_modify;///Override
end event

type dw_master from w_abc_master`dw_master within w_rh236_envio_plla
integer y = 192
integer width = 3296
integer height = 1092
string dataobject = "d_list_envio_plla_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	// Columna de lectrua de este datawindows
is_dwform = 'tabular'	// tabular, form (default)
end event

event dw_master::doubleclicked;call super::doubleclicked;Integer 	li_opcion
String	ls_estado

Accepttext()

IF row = 0 THEN Return

ls_estado = this.object.flag_estado [row]

if ls_estado = '1' then
	li_opcion = MessageBox('Pregunta' ,'Desea Enviar a planilla la Solicitud de Vacaciones ?', Question!, YesNo!, 2)
else
	li_opcion = MessageBox('Pregunta' ,'Desea Revertir el envio a la planilla de la Solicitud de Vacaciones ?', Question!, YesNo!, 2)
end if


IF li_opcion = 1 THEN
	if ls_estado = '1' then
		This.Object.flag_estado 	[row] = '2'
		This.ii_update = 1
	else
		This.Object.flag_estado 	[row] = '1'
		This.ii_update = 1
	end if
END IF
end event

type rb_3 from radiobutton within w_rh236_envio_plla
integer x = 73
integer y = 80
integer width = 631
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pendientes por enviar"
boolean checked = true
end type

event clicked;  dw_master.settransobject(sqlca)
  dw_master.Retrieve('1')


end event

type rb_1 from radiobutton within w_rh236_envio_plla
integer x = 727
integer y = 88
integer width = 389
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enviados"
end type

event clicked;  dw_master.settransobject(sqlca)
  dw_master.Retrieve('2')
end event

type p_1 from picture within w_rh236_envio_plla
integer x = 1179
integer y = 64
integer width = 110
integer height = 76
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\BMP\CHKMARK.BMP"
boolean border = true
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh236_envio_plla
integer x = 1330
integer y = 84
integer width = 1646
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dar Doble Click Para enviar la boleta de permiso de vacaciones a la planilla"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_rh236_envio_plla
integer width = 1157
integer height = 180
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = " Seleccionar "
end type

