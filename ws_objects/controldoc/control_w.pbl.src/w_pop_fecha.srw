$PBExportHeader$w_pop_fecha.srw
forward
global type w_pop_fecha from window
end type
type cb_1 from commandbutton within w_pop_fecha
end type
type dw_1 from datawindow within w_pop_fecha
end type
end forward

global type w_pop_fecha from window
integer width = 1275
integer height = 404
boolean titlebar = true
string title = "Parametros de Busqueda"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
dw_1 dw_1
end type
global w_pop_fecha w_pop_fecha

event open;f_centrar(this)
end event

on w_pop_fecha.create
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.cb_1,&
this.dw_1}
end on

on w_pop_fecha.destroy
destroy(this.cb_1)
destroy(this.dw_1)
end on

type cb_1 from commandbutton within w_pop_fecha
integer x = 896
integer y = 72
integer width = 302
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;String ls_fecha_inicio,ls_fecha_final
str_parametros lstr_param

dw_1.Accepttext()


ls_fecha_inicio = String(dw_1.object.ad_fecha_inicio [1],'yyyymmdd')
ls_fecha_final  = String(dw_1.object.ad_fecha_final  [1],'yyyymmdd')


IF ls_fecha_inicio = '00000000' OR Isnull(ls_fecha_inicio) OR trim(ls_fecha_inicio) = '' THEN
	Messagebox('Aviso','Debe Ingresar Una Fecha de inicio')
	RETURN
END IF

IF ls_fecha_final = '00000000' OR Isnull(ls_fecha_final) OR trim(ls_fecha_final) = '' THEN
	Messagebox('Aviso','Debe Ingresar Una Fecha Final')
	RETURN
END IF	

lstr_param.field_ret_s[1] = ls_fecha_inicio
lstr_param.field_ret_s[2] = ls_fecha_final
//
CloseWithReturn(Parent,lstr_param)
end event

type dw_1 from datawindow within w_pop_fecha
integer x = 23
integer y = 20
integer width = 855
integer height = 240
integer taborder = 10
string title = "none"
string dataobject = "d_ext_parametros_docreg_form"
boolean livescroll = true
borderstyle borderstyle = StyleBox!
end type

event constructor;Settransobject(sqlca)
Insertrow(0)
end event

event itemchanged;Accepttext()
end event

event itemerror;Return 1
end event

