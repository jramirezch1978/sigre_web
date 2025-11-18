$PBExportHeader$u_tabpg_datetimepick.sru
$PBExportComments$Date and Time Picker Control demo tabpage
forward
global type u_tabpg_datetimepick from u_base_tabpg
end type
type cb_set_date from u_base_button within u_tabpg_datetimepick
end type
type cb_get_date from u_base_button within u_tabpg_datetimepick
end type
type uo_datetimepick from u_comctl_datetimepick within u_tabpg_datetimepick
end type
type cb_set_style from u_base_button within u_tabpg_datetimepick
end type
type cb_set_format from u_base_button within u_tabpg_datetimepick
end type
end forward

global type u_tabpg_datetimepick from u_base_tabpg
long PictureMaskColor=553648127
long TabBackColor=79416533
string Text="Date Time Picker"
cb_set_date cb_set_date
cb_get_date cb_get_date
uo_datetimepick uo_datetimepick
cb_set_style cb_set_style
cb_set_format cb_set_format
end type
global u_tabpg_datetimepick u_tabpg_datetimepick

on u_tabpg_datetimepick.create
int iCurrent
call super::create
this.cb_set_date=create cb_set_date
this.cb_get_date=create cb_get_date
this.uo_datetimepick=create uo_datetimepick
this.cb_set_style=create cb_set_style
this.cb_set_format=create cb_set_format
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_set_date
this.Control[iCurrent+2]=this.cb_get_date
this.Control[iCurrent+3]=this.uo_datetimepick
this.Control[iCurrent+4]=this.cb_set_style
this.Control[iCurrent+5]=this.cb_set_format
end on

on u_tabpg_datetimepick.destroy
call super::destroy
destroy(this.cb_set_date)
destroy(this.cb_get_date)
destroy(this.uo_datetimepick)
destroy(this.cb_set_style)
destroy(this.cb_set_format)
end on

type cb_set_date from u_base_button within u_tabpg_datetimepick
int X=951
int Y=32
boolean BringToTop=true
string Text="Set Date"
end type

event clicked;call super::clicked;Date ld_date

ld_date = Date(1960,9,16)

uo_datetimepick.of_set_date(ld_date)

end event

type cb_get_date from u_base_button within u_tabpg_datetimepick
int X=951
int Y=160
int TabOrder=20
boolean BringToTop=true
string Text="Get Date"
end type

event clicked;call super::clicked;Date ld_date

ld_date = uo_datetimepick.of_get_date()

MessageBox("Date", String(ld_date))

end event

type uo_datetimepick from u_comctl_datetimepick within u_tabpg_datetimepick
int X=37
int Y=32
boolean BringToTop=true
end type

type cb_set_style from u_base_button within u_tabpg_datetimepick
int X=951
int Y=288
int TabOrder=30
boolean BringToTop=true
string Text="Set Style"
end type

event clicked;call super::clicked;uo_datetimepick.of_set_style(4, True)

end event

type cb_set_format from u_base_button within u_tabpg_datetimepick
int X=951
int Y=416
int TabOrder=20
boolean BringToTop=true
string Text="Set Format"
end type

event clicked;call super::clicked;String ls_format

ls_format = "MM/dd/yyyy"

uo_datetimepick.of_set_format(ls_format)

end event

