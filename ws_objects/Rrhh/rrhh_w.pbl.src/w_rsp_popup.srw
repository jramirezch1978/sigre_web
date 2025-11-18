$PBExportHeader$w_rsp_popup.srw
forward
global type w_rsp_popup from window
end type
type mle_1 from multilineedit within w_rsp_popup
end type
end forward

global type w_rsp_popup from window
integer width = 2021
integer height = 1008
boolean titlebar = true
string title = "Descripcion Amplia de Concepto"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event keydown pbm_keydown
mle_1 mle_1
end type
global w_rsp_popup w_rsp_popup

event keydown;if key = (KeyEscape!) then
	
	close(this)
	
end if
end event

event open;mle_1.SetFocus()
Long ll_nfila
String ls_columna
DataWindow ldw_master
str_parametros lstr_rep

lstr_rep = message.powerobjectparm

ll_nfila  = lstr_rep.long1
ls_columna = lstr_rep.string1
ldw_master = lstr_rep.dw_m

mle_1.text = ldw_master.GetItemString(ll_nfila,ls_columna)
end event

on w_rsp_popup.create
this.mle_1=create mle_1
this.Control[]={this.mle_1}
end on

on w_rsp_popup.destroy
destroy(this.mle_1)
end on

type mle_1 from multilineedit within w_rsp_popup
integer x = 32
integer y = 28
integer width = 1943
integer height = 868
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

