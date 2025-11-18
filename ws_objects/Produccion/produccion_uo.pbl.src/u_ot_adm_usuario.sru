$PBExportHeader$u_ot_adm_usuario.sru
forward
global type u_ot_adm_usuario from userobject
end type
type cbx_ot_adm from checkbox within u_ot_adm_usuario
end type
type ddlb_ot_adm from u_ddlb_ot_adm_user within u_ot_adm_usuario
end type
end forward

global type u_ot_adm_usuario from userobject
integer width = 1710
integer height = 116
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cbx_ot_adm cbx_ot_adm
ddlb_ot_adm ddlb_ot_adm
end type
global u_ot_adm_usuario u_ot_adm_usuario

forward prototypes
public function string of_get_ot_adm ()
end prototypes

public function string of_get_ot_adm ();string ls_ot_adm

if cbx_ot_adm.checked then
	ls_ot_adm = trim(right(ddlb_ot_adm.text, 10))
else
	setnull(ls_ot_adm)
end if

return ls_ot_adm
end function

on u_ot_adm_usuario.create
this.cbx_ot_adm=create cbx_ot_adm
this.ddlb_ot_adm=create ddlb_ot_adm
this.Control[]={this.cbx_ot_adm,&
this.ddlb_ot_adm}
end on

on u_ot_adm_usuario.destroy
destroy(this.cbx_ot_adm)
destroy(this.ddlb_ot_adm)
end on

type cbx_ot_adm from checkbox within u_ot_adm_usuario
integer x = 5
integer y = 16
integer width = 544
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "O.T. Adminsitración"
end type

event clicked;if this.checked then
	ddlb_ot_adm.enabled = true
else
	ddlb_ot_adm.enabled = false
end if
end event

type ddlb_ot_adm from u_ddlb_ot_adm_user within u_ot_adm_usuario
integer x = 562
integer y = 4
integer height = 500
boolean enabled = false
end type

