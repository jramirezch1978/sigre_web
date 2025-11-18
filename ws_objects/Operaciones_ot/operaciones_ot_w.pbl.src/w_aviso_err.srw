$PBExportHeader$w_aviso_err.srw
forward
global type w_aviso_err from window
end type
type st_3 from statictext within w_aviso_err
end type
type st_2 from statictext within w_aviso_err
end type
type st_1 from statictext within w_aviso_err
end type
end forward

global type w_aviso_err from window
integer width = 1815
integer height = 548
boolean titlebar = true
string title = "Aviso"
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_3 st_3
st_2 st_2
st_1 st_1
end type
global w_aviso_err w_aviso_err

type variables

end variables

on w_aviso_err.create
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.Control[]={this.st_3,&
this.st_2,&
this.st_1}
end on

on w_aviso_err.destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
end on

event timer;
//CLOSE(THIS)
end event

event open;
String ls_item

ls_item = message.STRINGparm

ST_2.TEXT = ST_2.TEXT +' '+TRIM(LS_ITEM)

end event

type st_3 from statictext within w_aviso_err
integer x = 398
integer y = 316
integer width = 663
integer height = 68
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217857
long backcolor = 67108864
string text = "Revisar Item !!!"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_aviso_err
integer x = 64
integer y = 220
integer width = 1682
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217857
long backcolor = 67108864
string text = "Aviso Cantidad Labor es Negativa o es Igual a 0  , Item Nº :"
boolean focusrectangle = false
end type

type st_1 from statictext within w_aviso_err
integer x = 64
integer y = 56
integer width = 1682
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parte Diario"
boolean focusrectangle = false
end type

