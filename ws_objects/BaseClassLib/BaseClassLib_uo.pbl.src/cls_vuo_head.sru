$PBExportHeader$cls_vuo_head.sru
forward
global type cls_vuo_head from userobject
end type
type st_titulo from statictext within cls_vuo_head
end type
type st_sistema from statictext within cls_vuo_head
end type
type rr_1 from roundrectangle within cls_vuo_head
end type
end forward

global type cls_vuo_head from userobject
integer width = 4549
integer height = 144
long backcolor = 134217741
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_titulo st_titulo
st_sistema st_sistema
rr_1 rr_1
end type
global cls_vuo_head cls_vuo_head

type variables
string is_titulo
integer width_left=480


end variables

forward prototypes
public subroutine of_set_sistema (string as_sistema)
public function integer of_set_title (string as_titulo)
public subroutine of_resize (integer ai_newwidth)
end prototypes

public subroutine of_set_sistema (string as_sistema);st_sistema.text = as_sistema
end subroutine

public function integer of_set_title (string as_titulo);st_titulo.text=as_titulo
return 0
end function

public subroutine of_resize (integer ai_newwidth);rr_1.width = ai_newwidth + 80
end subroutine

on cls_vuo_head.create
this.st_titulo=create st_titulo
this.st_sistema=create st_sistema
this.rr_1=create rr_1
this.Control[]={this.st_titulo,&
this.st_sistema,&
this.rr_1}
end on

on cls_vuo_head.destroy
destroy(this.st_titulo)
destroy(this.st_sistema)
destroy(this.rr_1)
end on

event constructor;st_titulo.text=is_titulo

rr_1.x=width_left
st_titulo.x=width_left + 150

end event

type st_titulo from statictext within cls_vuo_head
integer x = 590
integer y = 44
integer width = 3803
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 134217730
boolean enabled = false
string text = "Registro [...]"
boolean focusrectangle = false
end type

type st_sistema from statictext within cls_vuo_head
integer x = 14
integer y = 36
integer width = 453
integer height = 92
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217741
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within cls_vuo_head
long linecolor = 67108864
integer linethickness = 1
long fillcolor = 1073741824
integer x = 480
integer y = 20
integer width = 4677
integer height = 284
integer cornerheight = 400
integer cornerwidth = 400
end type

