$PBExportHeader$w_pop_guias.srw
forward
global type w_pop_guias from window
end type
type dw_master from u_dw_abc within w_pop_guias
end type
type cb_2 from commandbutton within w_pop_guias
end type
type cb_1 from commandbutton within w_pop_guias
end type
end forward

global type w_pop_guias from window
integer width = 1289
integer height = 1052
boolean titlebar = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
event ue_aceptar ( )
event ue_cancelar ( )
dw_master dw_master
cb_2 cb_2
cb_1 cb_1
end type
global w_pop_guias w_pop_guias

event ue_aceptar();string ls_maq, ls_rep
long ll_row
str_parametros lstr_param

ll_row = dw_master.il_row

if ll_row <= 0 then
	MessageBox('APROVISIONAMIENTO', 'NO SE HA SELECCIONADO NINGUNA FILA', StopSign!)
	return
end if

ls_maq = dw_master.object.cod_maquina[ll_row]
ls_rep = dw_master.object.nro_reporte[ll_row]
lstr_param.accion  = "aceptar"
lstr_param.string1 = ls_maq
lstr_param.string2 = ls_rep

CloseWithReturn(this, lstr_param)
end event

event ue_cancelar();str_parametros lstr_param

lstr_param.accion  = "cancelar"

CloseWithReturn(this, lstr_param)
end event

on w_pop_guias.create
this.dw_master=create dw_master
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.dw_master,&
this.cb_2,&
this.cb_1}
end on

on w_pop_guias.destroy
destroy(this.dw_master)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event resize;this.SetRedraw(false)
dw_master.width  = newwidth  - dw_master.x - 10
this.SetRedraw(true)
end event

event open;str_parametros lstr_param

if IsValid(Message.PowerObjectParm) then
	If Message.PowerObjectParm.ClassName() = 'str_parametros' then
		lstr_param = Message.PowerObjectParm
		
		this.Move(lstr_param.X, lstr_param.Y)
		
		This.Title = 'NUMERO DE GUIA: ' + lstr_param.string1
		
		dw_master.SetTransObject(SQLCA)
		dw_master.Retrieve(lstr_param.string1)
		
	end if
else
	Close(this)
end if
end event

type dw_master from u_dw_abc within w_pop_guias
integer width = 1266
integer height = 792
string dataobject = "d_rep_maq_grid"
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event doubleclicked;call super::doubleclicked;parent.event dynamic ue_aceptar()
end event

type cb_2 from commandbutton within w_pop_guias
integer x = 667
integer y = 816
integer width = 279
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event dynamic ue_cancelar()
end event

type cb_1 from commandbutton within w_pop_guias
integer x = 384
integer y = 816
integer width = 279
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;parent.event dynamic ue_aceptar()
end event

