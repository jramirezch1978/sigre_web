$PBExportHeader$w_fondo.srw
forward
global type w_fondo from window
end type
type st_esquema from statictext within w_fondo
end type
type st_fec_inicio from statictext within w_fondo
end type
type st_origen from statictext within w_fondo
end type
type st_empresa from statictext within w_fondo
end type
type st_5 from statictext within w_fondo
end type
type st_4 from statictext within w_fondo
end type
type st_3 from statictext within w_fondo
end type
type st_2 from statictext within w_fondo
end type
type st_usuario from statictext within w_fondo
end type
type st_1 from statictext within w_fondo
end type
type gb_1 from groupbox within w_fondo
end type
type p_1 from picture within w_fondo
end type
type shl_datos from statichyperlink within w_fondo
end type
type mc_calendar from monthcalendar within w_fondo
end type
type gb_sesion from groupbox within w_fondo
end type
type p_logo from picture within w_fondo
end type
end forward

global type w_fondo from window
accessiblerole accessiblerole = animationrole!
integer width = 4585
integer height = 2276
boolean enabled = false
boolean border = false
windowtype windowtype = child!
long backcolor = 16777215
string icon = "AppIcon!"
string pointer = "h:\Source\CUR\P-ARGYLE.ANI"
boolean toolbarvisible = false
boolean center = true
event ue_selected_date ( )
st_esquema st_esquema
st_fec_inicio st_fec_inicio
st_origen st_origen
st_empresa st_empresa
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_usuario st_usuario
st_1 st_1
gb_1 gb_1
p_1 p_1
shl_datos shl_datos
mc_calendar mc_calendar
gb_sesion gb_sesion
p_logo p_logo
end type
global w_fondo w_fondo

event ue_selected_date();integer 	li_citas
date 		ld_fecha

mc_calendar.getselecteddate( ld_fecha )

select count(*)
	into :li_citas
from his_agenda
where usr_destino = :gnvo_app.is_user
and trunc(fecha_hora_inicio) = :ld_fecha
and flag_estado = '1';

if li_citas > 0 then
	shl_datos.text = "Usted tiene " + string(li_citas) + " anotaciones en la Agenda"
else
	shl_datos.text = "No hay mensajes para el día seleccionado"
end if

end event

on w_fondo.create
this.st_esquema=create st_esquema
this.st_fec_inicio=create st_fec_inicio
this.st_origen=create st_origen
this.st_empresa=create st_empresa
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_usuario=create st_usuario
this.st_1=create st_1
this.gb_1=create gb_1
this.p_1=create p_1
this.shl_datos=create shl_datos
this.mc_calendar=create mc_calendar
this.gb_sesion=create gb_sesion
this.p_logo=create p_logo
this.Control[]={this.st_esquema,&
this.st_fec_inicio,&
this.st_origen,&
this.st_empresa,&
this.st_5,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_usuario,&
this.st_1,&
this.gb_1,&
this.p_1,&
this.shl_datos,&
this.mc_calendar,&
this.gb_sesion,&
this.p_logo}
end on

on w_fondo.destroy
destroy(this.st_esquema)
destroy(this.st_fec_inicio)
destroy(this.st_origen)
destroy(this.st_empresa)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_usuario)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.p_1)
destroy(this.shl_datos)
destroy(this.mc_calendar)
destroy(this.gb_sesion)
destroy(this.p_logo)
end on

event resize;this.SetRedraw(false)

p_1.width 	= this.width
p_1.height 	= this.height
gb_sesion.height  = this.height - 50

st_usuario.text = gnvo_app.is_user + " - " + gnvo_app.of_nom_usuario()
st_origen.text  = gnvo_app.is_origen + " - " + gnvo_app.of_desc_origen()
st_empresa.text = gnvo_app.invo_empresa.is_empresa + " - " + gnvo_app.invo_empresa.is_desc_empresa
st_esquema.text = gnvo_app.is_esquema
st_fec_inicio.text = string(gnvo_app.idt_ingreso, "mm/dd/yyyy hh:mm am/pm;'none'")

p_logo.y =gb_sesion.height - p_logo.height - 50
p_logo.x = gb_sesion.x + (gb_sesion.width - p_logo.width) / 2
p_logo.picturename = gnvo_app.is_logo

this.SetRedraw(true)
end event

event open;this.post event ue_selected_date( )
end event

type st_esquema from statictext within w_fondo
integer x = 352
integer y = 1552
integer width = 837
integer height = 88
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 134217752
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_fec_inicio from statictext within w_fondo
integer x = 352
integer y = 1452
integer width = 837
integer height = 88
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 134217752
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_origen from statictext within w_fondo
integer x = 352
integer y = 1352
integer width = 837
integer height = 88
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 134217752
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_empresa from statictext within w_fondo
integer x = 352
integer y = 1252
integer width = 837
integer height = 88
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 134217752
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_5 from statictext within w_fondo
integer x = 9
integer y = 1564
integer width = 329
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217752
string text = "Esquema:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_fondo
integer x = 9
integer y = 1464
integer width = 329
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217752
string text = "Fec. Sesión:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_fondo
integer x = 9
integer y = 1364
integer width = 329
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217752
string text = "Origen:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fondo
integer x = 9
integer y = 1264
integer width = 329
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217752
string text = "Empresa:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_usuario from statictext within w_fondo
integer x = 352
integer y = 1152
integer width = 837
integer height = 88
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 134217752
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_1 from statictext within w_fondo
integer x = 9
integer y = 1164
integer width = 329
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217752
string text = "Usuario:"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_fondo
integer width = 1221
integer height = 1060
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217752
string text = "Mensajes de Agenda"
end type

type p_1 from picture within w_fondo
integer x = 1234
integer width = 3013
integer height = 1920
string pointer = "h:\Source\CUR\P-ARGYLE.ANI"
string picturename = "C:\SIGRE\resources\JPG\erp1.jpg"
boolean focusrectangle = false
end type

type shl_datos from statichyperlink within w_fondo
integer x = 46
integer y = 72
integer width = 1125
integer height = 132
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 134217752
string text = "No hay mensajes para el día de Hoy"
alignment alignment = center!
boolean focusrectangle = false
end type

type mc_calendar from monthcalendar within w_fondo
integer x = 46
integer y = 204
integer width = 1125
integer height = 840
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long titletextcolor = 16711680
long trailingtextcolor = 134217745
long backcolor = 67108864
long monthbackcolor = 134217729
long titlebackcolor = 134217735
integer maxselectcount = 1
integer scrollrate = 1
boolean todaysection = true
boolean todaycircle = true
boolean border = true
end type

event datechanged;parent.post event ue_selected_date( )
end event

type gb_sesion from groupbox within w_fondo
integer x = 5
integer y = 1060
integer width = 1211
integer height = 1200
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217752
string text = "Datos de la Sesión"
end type

type p_logo from picture within w_fondo
integer x = 37
integer y = 1804
integer width = 974
integer height = 444
boolean bringtotop = true
boolean focusrectangle = false
end type

