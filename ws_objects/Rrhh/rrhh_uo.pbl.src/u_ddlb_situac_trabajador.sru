$PBExportHeader$u_ddlb_situac_trabajador.sru
forward
global type u_ddlb_situac_trabajador from userobject
end type
type cbx_1 from checkbox within u_ddlb_situac_trabajador
end type
type ddlb_1 from u_ddlb_lista within u_ddlb_situac_trabajador
end type
type gb_1 from groupbox within u_ddlb_situac_trabajador
end type
end forward

global type u_ddlb_situac_trabajador from userobject
integer width = 905
integer height = 212
long backcolor = 67108864
string text = "none"
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
cbx_1 cbx_1
ddlb_1 ddlb_1
gb_1 gb_1
end type
global u_ddlb_situac_trabajador u_ddlb_situac_trabajador

forward prototypes
public function string of_get_seleccion ()
end prototypes

public function string of_get_seleccion ();string ls_seleccion

if cbx_1.checked then
	ls_seleccion = '%%'
else
	ls_seleccion = string(ddlb_1.ia_key[ddlb_1.ii_index])
end if

return ls_seleccion
end function

on u_ddlb_situac_trabajador.create
this.cbx_1=create cbx_1
this.ddlb_1=create ddlb_1
this.gb_1=create gb_1
this.Control[]={this.cbx_1,&
this.ddlb_1,&
this.gb_1}
end on

on u_ddlb_situac_trabajador.destroy
destroy(this.cbx_1)
destroy(this.ddlb_1)
destroy(this.gb_1)
end on

type cbx_1 from checkbox within u_ddlb_situac_trabajador
integer x = 558
integer width = 238
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if this.checked = true then
	ddlb_1.enabled = false
else
	ddlb_1.enabled = true
end if
end event

type ddlb_1 from u_ddlb_lista within u_ddlb_situac_trabajador
integer x = 64
integer y = 80
integer height = 464
boolean enabled = false
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_dddw_situac_trabajador_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 50                     // Longitud del campo 1
ii_lc2 = 3							// Longitud del campo 2

this.event ue_populate()
end event

event ue_populate;call super::ue_populate;this.selectitem(1)
end event

type gb_1 from groupbox within u_ddlb_situac_trabajador
integer width = 896
integer height = 208
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Condición Trabajador               "
end type

