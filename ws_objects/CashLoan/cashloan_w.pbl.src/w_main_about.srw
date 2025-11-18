$PBExportHeader$w_main_about.srw
forward
global type w_main_about from w_main_about_ancst
end type
type p_2 from picture within w_main_about
end type
end forward

global type w_main_about from w_main_about_ancst
p_2 p_2
end type
global w_main_about w_main_about

on w_main_about.create
int iCurrent
call super::create
this.p_2=create p_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_2
end on

on w_main_about.destroy
call super::destroy
destroy(this.p_2)
end on

type pb_1 from w_main_about_ancst`pb_1 within w_main_about
end type

type st_2 from w_main_about_ancst`st_2 within w_main_about
integer x = 439
integer y = 1324
integer width = 686
string text = "Powered by SIGRE"
end type

type st_1 from w_main_about_ancst`st_1 within w_main_about
integer x = 174
integer y = 8
integer width = 1673
integer height = 220
integer textsize = -18
string facename = "Arial"
long textcolor = 8388608
long backcolor = 16777215
string text = "CREDITOS FINANCIEROS CASH LOAN"
end type

type p_1 from w_main_about_ancst`p_1 within w_main_about
integer x = 23
integer y = 1120
integer width = 393
integer height = 268
end type

type p_2 from picture within w_main_about
integer x = 23
integer y = 252
integer width = 1979
integer height = 828
boolean bringtotop = true
string picturename = "C:\SIGRE\resources\Imagenes\CashLoan 02.jpg"
boolean focusrectangle = false
end type

