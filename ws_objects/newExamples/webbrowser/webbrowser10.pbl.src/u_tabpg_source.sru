$PBExportHeader$u_tabpg_source.sru
forward
global type u_tabpg_source from u_base_tabpg
end type
type mle_source from multilineedit within u_tabpg_source
end type
end forward

global type u_tabpg_source from u_base_tabpg
string text = "Source"
mle_source mle_source
end type
global u_tabpg_source u_tabpg_source

on u_tabpg_source.create
int iCurrent
call super::create
this.mle_source=create mle_source
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_source
end on

on u_tabpg_source.destroy
call super::destroy
destroy(this.mle_source)
end on

event resize;call super::resize;mle_source.Width  = this.Width
mle_source.Height = this.Height

end event

event selectionchanging;call super::selectionchanging;w_main lw_main
u_tabpg_design lu_design

lw_main = iw_parent
lu_design = lw_main.tab_main.of_GetDesign()

lu_design.ole_browser.of_SetSource(mle_source.text)

end event

type mle_source from multilineedit within u_tabpg_source
integer width = 1655
integer height = 1032
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

