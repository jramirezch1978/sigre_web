$PBExportHeader$w_rh492_perfiles_structura.srw
forward
global type w_rh492_perfiles_structura from window
end type
type dw_master from u_dw_abc within w_rh492_perfiles_structura
end type
type pb_1 from picturebutton within w_rh492_perfiles_structura
end type
type pb_2 from picturebutton within w_rh492_perfiles_structura
end type
end forward

global type w_rh492_perfiles_structura from window
integer width = 1431
integer height = 336
boolean titlebar = true
string title = "Opciones Perfil"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_salir ( )
event ue_aceptar ( )
dw_master dw_master
pb_1 pb_1
pb_2 pb_2
end type
global w_rh492_perfiles_structura w_rh492_perfiles_structura

event ue_salir();str_parametros  lstr_param

lstr_param.titulo			= 'n'

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar();
Long 				ll_cantidad
str_parametros 	lstr_param

if dw_master.GetRow() = 0 then return

if dw_master.Update() = -1 then
	ROLLBACK;
	return
end if

commit;

ll_Cantidad = Long(dw_master.object.cantidad	[dw_master.GetRow()])

lstr_param.titulo			= 's'
lstr_param.ll_cantidad 	= ll_cantidad

CloseWithReturn(this, lstr_param)

end event

on w_rh492_perfiles_structura.create
this.dw_master=create dw_master
this.pb_1=create pb_1
this.pb_2=create pb_2
this.Control[]={this.dw_master,&
this.pb_1,&
this.pb_2}
end on

on w_rh492_perfiles_structura.destroy
destroy(this.dw_master)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;string 	ls_padre, ls_hijo
str_parametros lstr_param

if IsNull(Message.PowerObjectParm) or &
	Not IsValid(Message.PowerObjectParm) then 
	
	MessageBox('Aviso', 'Parametros Incorrectos')
	close(this)
	
end if	

if Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	MessageBox('Aviso', 'Parametros Incorrectos no son del tipo str_parametros')
	close(this)
end if

lstr_param = Message.PowerObjectParm

ls_padre = lstr_param.string1
ls_hijo = lstr_param.string2

dw_master.SetTransObject(SQLCA)
dw_master.Retrieve(ls_padre, ls_hijo)
end event

type dw_master from u_dw_abc within w_rh492_perfiles_structura
integer x = 14
integer y = 28
integer width = 1093
integer height = 220
string dataobject = "d_cargo_estructura_ff"
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type pb_1 from picturebutton within w_rh492_perfiles_structura
integer x = 1134
integer y = 20
integer width = 242
integer height = 112
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

type pb_2 from picturebutton within w_rh492_perfiles_structura
integer x = 1134
integer y = 132
integer width = 242
integer height = 112
integer taborder = 10
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

