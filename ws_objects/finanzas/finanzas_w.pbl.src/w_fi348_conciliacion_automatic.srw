$PBExportHeader$w_fi348_conciliacion_automatic.srw
forward
global type w_fi348_conciliacion_automatic from window
end type
type st_1 from statictext within w_fi348_conciliacion_automatic
end type
type cb_2 from commandbutton within w_fi348_conciliacion_automatic
end type
type cb_1 from commandbutton within w_fi348_conciliacion_automatic
end type
type dw_2 from datawindow within w_fi348_conciliacion_automatic
end type
type dw_1 from datawindow within w_fi348_conciliacion_automatic
end type
end forward

global type w_fi348_conciliacion_automatic from window
integer width = 4256
integer height = 1096
boolean titlebar = true
string title = "Conciliacion Automatica (FI348)"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_1 st_1
cb_2 cb_2
cb_1 cb_1
dw_2 dw_2
dw_1 dw_1
end type
global w_fi348_conciliacion_automatic w_fi348_conciliacion_automatic

type variables
str_parametros is_param
end variables

on w_fi348_conciliacion_automatic.create
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_2=create dw_2
this.dw_1=create dw_1
this.Control[]={this.st_1,&
this.cb_2,&
this.cb_1,&
this.dw_2,&
this.dw_1}
end on

on w_fi348_conciliacion_automatic.destroy
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_2)
destroy(this.dw_1)
end on

event open;Long   ll_inicio
String ls_cod_banco


dw_1.SettransObject(sqlca)


is_param = message.powerobjectparm

//datos de banco
ls_cod_banco = is_param.dw_m.object.banco_cnta_cod_banco [1]


//base de datos
is_param.dw_m.RowsMove(1,is_param.dw_m.Rowcount(), Primary!, dw_1, 1, Primary!)

//texto
f_create_dw(ls_cod_banco,dw_2)
is_param.dw_d.RowsMove(1,is_param.dw_d.Rowcount(), Primary!, dw_2, 1, Primary!)


//coloca indicadores

for ll_inicio = 1 to dw_1.Rowcount( )
	 dw_1.object.ind_concil [ll_inicio] = '1'
next

for ll_inicio = 1 to dw_2.Rowcount( )
	 dw_2.object.conciliacion [ll_inicio] = '1'
next	 

//contador
st_1.text = 'Son '+Trim(String(dw_1.Rowcount())+' Registros Coincidentes ')
end event

type st_1 from statictext within w_fi348_conciliacion_automatic
integer x = 14
integer y = 936
integer width = 1792
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_fi348_conciliacion_automatic
integer x = 3813
integer y = 160
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
end type

event clicked;Long ll_inicio
//coloca indicadores

for ll_inicio = 1 to dw_1.Rowcount( )
	 dw_1.object.ind_concil [ll_inicio] = '0'
next

for ll_inicio = 1 to dw_2.Rowcount( )
	 dw_2.object.conciliacion [ll_inicio] = '0'
next	 

dw_1.Accepttext( )
dw_2.Accepttext( )

//base de datos
dw_1.RowsMove(1,dw_1.Rowcount(), Primary!, is_param.dw_m, 1, Primary!)



//texto
dw_2.RowsMove(1,dw_2.Rowcount(), Primary!, is_param.dw_d, 1, Primary!)





Close(parent)
end event

type cb_1 from commandbutton within w_fi348_conciliacion_automatic
integer x = 3813
integer y = 20
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;
dw_1.Accepttext( )
dw_2.Accepttext( )

//base de datos
dw_1.RowsMove(1,dw_1.Rowcount(), Primary!, is_param.dw_m, 1, Primary!)



//texto
dw_2.RowsMove(1,dw_2.Rowcount(), Primary!, is_param.dw_d, 1, Primary!)


Close(parent)
end event

type dw_2 from datawindow within w_fi348_conciliacion_automatic
integer x = 1911
integer y = 72
integer width = 1865
integer height = 856
integer taborder = 20
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_fi348_conciliacion_automatic
integer x = 5
integer y = 72
integer width = 1865
integer height = 856
integer taborder = 10
string title = "none"
string dataobject = "d_abc_tt_conciliar_envio_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

