$PBExportHeader$w_logon.srw
forward
global type w_logon from w_logon_ancst
end type
type p_logo from picture within w_logon
end type
type st_leyenda from statictext within w_logon
end type
end forward

global type w_logon from w_logon_ancst
integer width = 3575
integer height = 1948
p_logo p_logo
st_leyenda st_leyenda
end type
global w_logon w_logon

on w_logon.create
int iCurrent
call super::create
this.p_logo=create p_logo
this.st_leyenda=create st_leyenda
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_logo
this.Control[iCurrent+2]=this.st_leyenda
end on

on w_logon.destroy
call super::destroy
destroy(this.p_logo)
destroy(this.st_leyenda)
end on

event resize;call super::resize;//CENTRO LOGO
p_logo.x = (this.width/2)-(p_logo.width/2)
p_logo.y = (this.height/2)-(p_logo.height)

//CENTRAR DEMAS CONTROLES
st_user.y = p_logo.y + 748
st_user.x = p_logo.x
st_psswd_sys.y = p_logo.y + 860
st_psswd_sys.x = p_logo.x

sle_user.y = p_logo.y + 748
sle_user.x = p_logo.x + 654
sle_psswd_sys.y = p_logo.y + 860
sle_psswd_sys.x = p_logo.x + 654

cb_ok.x = p_logo.x + 976
cb_ok.y = p_logo.y + 996

st_leyenda.x = (this.width/2)-(st_leyenda.width/2)
st_leyenda.y = cb_ok.y + 600
end event

type st_psswd_db from w_logon_ancst`st_psswd_db within w_logon
boolean visible = false
integer x = 389
integer y = 1336
end type

type sle_psswd_db from w_logon_ancst`sle_psswd_db within w_logon
boolean visible = false
end type

type cb_cancel from w_logon_ancst`cb_cancel within w_logon
integer x = 1637
integer y = 1504
end type

type cb_ok from w_logon_ancst`cb_ok within w_logon
integer x = 1166
integer y = 1504
end type

type sle_psswd_sys from w_logon_ancst`sle_psswd_sys within w_logon
integer x = 1330
integer y = 1216
end type

type st_psswd_sys from w_logon_ancst`st_psswd_sys within w_logon
integer x = 389
integer y = 1228
integer weight = 400
fontcharset fontcharset = defaultcharset!
string facename = "Arial Narrow"
end type

type st_user from w_logon_ancst`st_user within w_logon
integer x = 384
integer y = 1108
integer weight = 400
fontcharset fontcharset = defaultcharset!
string facename = "Arial Narrow"
end type

type sle_user from w_logon_ancst`sle_user within w_logon
integer x = 1335
integer y = 1096
end type

type p_logo from picture within w_logon
integer x = 709
integer y = 20
integer width = 1321
integer height = 700
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type st_leyenda from statictext within w_logon
integer x = 603
integer y = 1780
integer width = 1627
integer height = 64
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
boolean italic = true
long textcolor = 33554432
long backcolor = 16777215
string text = "Modulo de Cotizacion Web - Uso exclusivo SYTCO"
alignment alignment = center!
boolean focusrectangle = false
end type

