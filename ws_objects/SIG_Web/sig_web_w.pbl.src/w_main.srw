$PBExportHeader$w_main.srw
forward
global type w_main from w_abc
end type
type pb_1 from picturebutton within w_main
end type
type st_1 from statictext within w_main
end type
type p_1 from picture within w_main
end type
type tab_1 from tab within w_main
end type
type tabpage_1 from userobject within tab_1
end type
type uo_1 from uo_rpt1 within tabpage_1
end type
type tabpage_1 from userobject within tab_1
uo_1 uo_1
end type
type tabpage_2 from userobject within tab_1
end type
type cb_1 from commandbutton within tabpage_2
end type
type uo_fecha from u_ingreso_rango_fechas within tabpage_2
end type
type dw_rpt2 from u_dw_rpt within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_1 cb_1
uo_fecha uo_fecha
dw_rpt2 dw_rpt2
end type
type tab_1 from tab within w_main
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
end forward

global type w_main from w_abc
integer width = 5157
integer height = 2720
string title = "Sistema de Información Gerencial - BLUEWAVE"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
long backcolor = 16777215
pb_1 pb_1
st_1 st_1
p_1 p_1
tab_1 tab_1
end type
global w_main w_main

type variables
u_dw_rpt idw_rpt2
end variables

forward prototypes
public subroutine of_set_dws ()
end prototypes

public subroutine of_set_dws ();idw_rpt2 = tab_1.tabpage_2.dw_rpt2
end subroutine

on w_main.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.st_1=create st_1
this.p_1=create p_1
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.tab_1
end on

on w_main.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.p_1)
destroy(this.tab_1)
end on

event ue_set_access;//Override
end event

event resize;call super::resize;of_Set_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

tab_1.tabpage_1.uo_1.width  = tab_1.tabpage_1.width  - tab_1.tabpage_1.uo_1.x - 10
tab_1.tabpage_1.uo_1.height = tab_1.tabpage_1.height - tab_1.tabpage_1.uo_1.y - 10

tab_1.tabpage_1.uo_1.event resize(tab_1.tabpage_1.width, tab_1.tabpage_1.height)

idw_rpt2.width  = tab_1.tabpage_2.width  - idw_rpt2.x - 10
idw_rpt2.height = tab_1.tabpage_2.height - idw_rpt2.y - 10




end event

type pb_1 from picturebutton within w_main
integer x = 3456
integer y = 128
integer width = 325
integer height = 188
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean originalsize = true
string picturename = "C:\SIGRE\resources\BMP\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(parent)
end event

type st_1 from statictext within w_main
integer x = 1061
integer y = 64
integer width = 2080
integer height = 348
integer textsize = -24
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "SISTEMA DE INFORMACIÓN GERENCIAL - VÍA WEB"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_1 from picture within w_main
integer y = 12
integer width = 960
integer height = 444
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type tab_1 from tab within w_main
integer y = 472
integer width = 5070
integer height = 2104
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 5033
integer height = 1976
long backcolor = 16777215
string text = "Avance de Ingreso"
long tabtextcolor = 33554432
long tabbackcolor = 16777215
string picturename = "ArrangeIcons!"
long picturemaskcolor = 536870912
uo_1 uo_1
end type

on tabpage_1.create
this.uo_1=create uo_1
this.Control[]={this.uo_1}
end on

on tabpage_1.destroy
destroy(this.uo_1)
end on

type uo_1 from uo_rpt1 within tabpage_1
event destroy ( )
integer width = 3401
integer height = 1900
integer taborder = 20
end type

on uo_1.destroy
call uo_rpt1::destroy
end on

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 5033
integer height = 1976
long backcolor = 16777215
string text = "Compras y Servicios"
long tabtextcolor = 33554432
long tabbackcolor = 16777215
string picturename = "Blob!"
long picturemaskcolor = 536870912
cb_1 cb_1
uo_fecha uo_fecha
dw_rpt2 dw_rpt2
end type

on tabpage_2.create
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.dw_rpt2=create dw_rpt2
this.Control[]={this.cb_1,&
this.uo_fecha,&
this.dw_rpt2}
end on

on tabpage_2.destroy
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.dw_rpt2)
end on

type cb_1 from commandbutton within tabpage_2
integer x = 1349
integer y = 12
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reporte"
end type

event clicked;date ld_Fecha1, ld_Fecha2

ld_Fecha1 = tab_1.tabpage_2.uo_Fecha.of_get_fecha1()
ld_Fecha2 = tab_1.tabpage_2.uo_Fecha.of_get_fecha2()

idw_rpt2.setTransObject(SQLCA)
idw_rpt2.retrieve(ld_Fecha1, ld_Fecha2)

end event

type uo_fecha from u_ingreso_rango_fechas within tabpage_2
integer x = 59
integer y = 32
integer taborder = 40
long backcolor = 16777215
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

of_set_fecha(date(f_fecha_actual()), date(f_fecha_actual())) //para setear la fecha inicial



end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_rpt2 from u_dw_rpt within tabpage_2
integer y = 140
integer width = 3360
integer height = 1440
integer taborder = 20
string dataobject = "d_reporte_compras_cst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

