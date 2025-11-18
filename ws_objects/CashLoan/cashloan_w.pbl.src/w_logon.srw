$PBExportHeader$w_logon.srw
forward
global type w_logon from w_logon_ancst
end type
type p_1 from picture within w_logon
end type
type st_1 from statictext within w_logon
end type
type p_sigre from picture within w_logon
end type
type gb_1 from groupbox within w_logon
end type
end forward

global type w_logon from w_logon_ancst
integer width = 2313
integer height = 1188
p_1 p_1
st_1 st_1
p_sigre p_sigre
gb_1 gb_1
end type
global w_logon w_logon

on w_logon.create
int iCurrent
call super::create
this.p_1=create p_1
this.st_1=create st_1
this.p_sigre=create p_sigre
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.p_sigre
this.Control[iCurrent+4]=this.gb_1
end on

on w_logon.destroy
call super::destroy
destroy(this.p_1)
destroy(this.st_1)
destroy(this.p_sigre)
destroy(this.gb_1)
end on

type cbx_sesion from w_logon_ancst`cbx_sesion within w_logon
integer x = 1390
integer y = 640
end type

type cb_cancel from w_logon_ancst`cb_cancel within w_logon
integer x = 1723
integer y = 780
integer width = 343
integer height = 212
end type

type cb_ok from w_logon_ancst`cb_ok within w_logon
integer x = 1344
integer y = 780
integer width = 343
integer height = 212
end type

type sle_psswd_sys from w_logon_ancst`sle_psswd_sys within w_logon
integer x = 1499
integer y = 520
end type

type st_psswd_sys from w_logon_ancst`st_psswd_sys within w_logon
integer x = 1093
integer y = 528
integer width = 398
string text = "Clave:"
alignment alignment = right!
end type

type st_user from w_logon_ancst`st_user within w_logon
integer x = 1088
integer y = 408
alignment alignment = right!
end type

type sle_user from w_logon_ancst`sle_user within w_logon
integer x = 1504
integer y = 400
end type

type p_1 from picture within w_logon
integer x = 27
integer y = 60
integer width = 882
integer height = 900
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\Imagenes\cashLoan.jpg"
boolean focusrectangle = false
end type

type st_1 from statictext within w_logon
integer x = 933
integer y = 56
integer width = 1312
integer height = 276
boolean bringtotop = true
integer textsize = -19
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Unicode MS"
long textcolor = 8388608
long backcolor = 16777215
string text = "Credito y Finanzas Cash Loan"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_sigre from picture within w_logon
integer x = 827
integer y = 800
integer width = 421
integer height = 232
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_logon
integer x = 9
integer width = 2277
integer height = 1088
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
end type

