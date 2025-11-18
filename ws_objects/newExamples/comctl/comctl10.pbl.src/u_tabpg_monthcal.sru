$PBExportHeader$u_tabpg_monthcal.sru
$PBExportComments$Month Calendar Control demo tabpage
forward
global type u_tabpg_monthcal from u_base_tabpg
end type
type uo_monthcal from u_comctl_monthcal within u_tabpg_monthcal
end type
type cb_set_date from u_base_button within u_tabpg_monthcal
end type
type cb_get_date from u_base_button within u_tabpg_monthcal
end type
type cb_set_today from u_base_button within u_tabpg_monthcal
end type
type cb_get_today from u_base_button within u_tabpg_monthcal
end type
type cb_set_color from u_base_button within u_tabpg_monthcal
end type
end forward

global type u_tabpg_monthcal from u_base_tabpg
long PictureMaskColor=553648127
long TabBackColor=79416533
string Text="Month Calendar"
uo_monthcal uo_monthcal
cb_set_date cb_set_date
cb_get_date cb_get_date
cb_set_today cb_set_today
cb_get_today cb_get_today
cb_set_color cb_set_color
end type
global u_tabpg_monthcal u_tabpg_monthcal

on u_tabpg_monthcal.create
int iCurrent
call super::create
this.uo_monthcal=create uo_monthcal
this.cb_set_date=create cb_set_date
this.cb_get_date=create cb_get_date
this.cb_set_today=create cb_set_today
this.cb_get_today=create cb_get_today
this.cb_set_color=create cb_set_color
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_monthcal
this.Control[iCurrent+2]=this.cb_set_date
this.Control[iCurrent+3]=this.cb_get_date
this.Control[iCurrent+4]=this.cb_set_today
this.Control[iCurrent+5]=this.cb_get_today
this.Control[iCurrent+6]=this.cb_set_color
end on

on u_tabpg_monthcal.destroy
call super::destroy
destroy(this.uo_monthcal)
destroy(this.cb_set_date)
destroy(this.cb_get_date)
destroy(this.cb_set_today)
destroy(this.cb_get_today)
destroy(this.cb_set_color)
end on

type uo_monthcal from u_comctl_monthcal within u_tabpg_monthcal
int X=37
int Y=32
boolean BringToTop=true
end type

type cb_set_date from u_base_button within u_tabpg_monthcal
int X=951
int Y=32
int TabOrder=10
boolean BringToTop=true
string Text="Set Date"
end type

event clicked;call super::clicked;Date ld_date

ld_date = Date(1960,9,16)

uo_monthcal.of_set_date(ld_date)

end event

type cb_get_date from u_base_button within u_tabpg_monthcal
int X=951
int Y=160
int TabOrder=20
boolean BringToTop=true
string Text="Get Date"
end type

event clicked;call super::clicked;Date ld_date

ld_date = uo_monthcal.of_get_date()

MessageBox("Date", String(ld_date))

end event

type cb_set_today from u_base_button within u_tabpg_monthcal
int X=951
int Y=288
int TabOrder=30
boolean BringToTop=true
string Text="Set Today"
end type

event clicked;call super::clicked;Date ld_date

ld_date = Date(1960,9,16)

uo_monthcal.of_set_today(ld_date)

end event

type cb_get_today from u_base_button within u_tabpg_monthcal
int X=951
int Y=416
int TabOrder=40
boolean BringToTop=true
string Text="Get Today"
end type

event clicked;call super::clicked;Date ld_date

ld_date = uo_monthcal.of_get_today()

MessageBox("Today", String(ld_date))

end event

type cb_set_color from u_base_button within u_tabpg_monthcal
int X=951
int Y=544
int TabOrder=50
boolean BringToTop=true
string Text="Set Color"
end type

event clicked;call super::clicked;ULong lul_color

lul_color = RGB(0, 255, 0)

uo_monthcal.of_set_color(uo_monthcal.MCSC_MONTHBK, lul_color)

end event

