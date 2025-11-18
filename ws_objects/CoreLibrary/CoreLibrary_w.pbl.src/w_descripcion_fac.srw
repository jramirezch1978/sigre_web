$PBExportHeader$w_descripcion_fac.srw
forward
global type w_descripcion_fac from w_abc
end type
type pb_2 from picturebutton within w_descripcion_fac
end type
type pb_1 from picturebutton within w_descripcion_fac
end type
type st_1 from statictext within w_descripcion_fac
end type
type mle_descripcion from multilineedit within w_descripcion_fac
end type
end forward

global type w_descripcion_fac from w_abc
integer width = 2277
integer height = 1872
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
integer ii_access = 1
pb_2 pb_2
pb_1 pb_1
st_1 st_1
mle_descripcion mle_descripcion
end type
global w_descripcion_fac w_descripcion_fac

type variables


str_parametros 			ist_datos

end variables

on w_descripcion_fac.create
int iCurrent
call super::create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.st_1=create st_1
this.mle_descripcion=create mle_descripcion
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.mle_descripcion
end on

on w_descripcion_fac.destroy
call super::destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.mle_descripcion)
end on

event ue_open_pre;call super::ue_open_pre;// Recoge parametro enviado
IF ISNULL( Message.PowerObjectParm ) or NOT IsValid(Message.PowerObjectParm) THEN
	MessageBox('Aviso', 'Parametros enviados estan en blanco', StopSign!)
	RETURN
END IF

IF Message.PowerObjectParm.ClassName() <> 'str_parametros' THEN
	MessageBox('Aviso', 'Parametros enviados no son del Tipo str_parametros', StopSign!)
	RETURN
END IF	

ist_datos = MESSAGE.POWEROBJECTPARM	


st_1.text 				= ist_datos.string1
mle_descripcion.text	= ist_datos.string2



end event

type pb_2 from picturebutton within w_descripcion_fac
integer x = 1189
integer y = 1580
integer width = 315
integer height = 180
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\CLOSE_UP.BMP"
end type

event clicked;ist_datos.titulo = ''

CloseWithReturn( parent, ist_datos)
end event

type pb_1 from picturebutton within w_descripcion_fac
integer x = 667
integer y = 1576
integer width = 325
integer height = 188
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
end type

event clicked;
ist_datos.string3 = mle_descripcion.text

ist_datos.titulo = 's'

CloseWithReturn( parent, ist_datos)
end event

type st_1 from statictext within w_descripcion_fac
integer x = 32
integer y = 32
integer width = 2194
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type mle_descripcion from multilineedit within w_descripcion_fac
integer x = 9
integer y = 128
integer width = 2235
integer height = 1436
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier New"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

