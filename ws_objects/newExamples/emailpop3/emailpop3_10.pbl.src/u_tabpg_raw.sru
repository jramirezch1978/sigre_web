$PBExportHeader$u_tabpg_raw.sru
forward
global type u_tabpg_raw from u_tabpg
end type
type mle_body from multilineedit within u_tabpg_raw
end type
end forward

global type u_tabpg_raw from u_tabpg
integer width = 3296
integer height = 1572
string text = "Raw Email"
mle_body mle_body
end type
global u_tabpg_raw u_tabpg_raw

forward prototypes
public subroutine of_load ()
end prototypes

public subroutine of_load ();// load message

u_tab_pop3 lu_parent

lu_parent = this.GetParent()

mle_body.text = gn_pop3.of_MsgContent(lu_parent.ii_msgnum)

end subroutine

on u_tabpg_raw.create
int iCurrent
call super::create
this.mle_body=create mle_body
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_body
end on

on u_tabpg_raw.destroy
call super::destroy
destroy(this.mle_body)
end on

type mle_body from multilineedit within u_tabpg_raw
integer x = 37
integer y = 32
integer width = 3223
integer height = 1508
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean hscrollbar = true
boolean vscrollbar = true
boolean displayonly = true
end type

