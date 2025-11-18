$PBExportHeader$w_valida_origen.srw
forward
global type w_valida_origen from window
end type
type st_1 from statictext within w_valida_origen
end type
type pb_cancel from picturebutton within w_valida_origen
end type
type pb_ok from picturebutton within w_valida_origen
end type
type dw_1 from datawindow within w_valida_origen
end type
end forward

global type w_valida_origen from window
integer width = 1815
integer height = 852
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_1 st_1
pb_cancel pb_cancel
pb_ok pb_ok
dw_1 dw_1
end type
global w_valida_origen w_valida_origen

type variables

end variables

event open;string ls_sql
long ll_rows

//ls_sql = "select distinct oao.cod_origen, o.nombre from ot_adm_origen oao inner join origen o on oao.cod_origen = o.cod_origen where oao.ot_adm in (select oao.ot_adm from ot_adm_usuario oau where trim(oau.cod_usr) = '" + gs_user + "')"

//dw_1.SetSQLSelect(ls_sql)
dw_1.settransobject(sqlca);
dw_1.retrieve(gs_user)
ll_rows = dw_1.rowcount()
if ll_rows <= 0 then
	messagebox('Recursos Humanos', 'El usuario ' + trim(gs_user) + ' no tiene permisos para ver ningún orígen, comunicarse con sistemas')
	CloseWithReturn ( this , 0 )
else
	dw_1.setrow(1)
	dw_1.scrolltorow(1)
	dw_1.selectrow(1,true)
	if ll_rows = 1 then pb_ok.event clicked()
end if
end event

on w_valida_origen.create
this.st_1=create st_1
this.pb_cancel=create pb_cancel
this.pb_ok=create pb_ok
this.dw_1=create dw_1
this.Control[]={this.st_1,&
this.pb_cancel,&
this.pb_ok,&
this.dw_1}
end on

on w_valida_origen.destroy
destroy(this.st_1)
destroy(this.pb_cancel)
destroy(this.pb_ok)
destroy(this.dw_1)
end on

type st_1 from statictext within w_valida_origen
integer x = 329
integer y = 24
integer width = 1138
integer height = 100
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "Book Antiqua"
boolean italic = true
boolean underline = true
long backcolor = 12632256
string text = "  SELECCIONE ORIGEN  "
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_cancel from picturebutton within w_valida_origen
integer x = 965
integer y = 628
integer width = 325
integer height = 188
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
boolean originalsize = true
string picturename = "C:\SIGRE\resources\BMP\Salir.bmp"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Salir del Sistema"
end type

event clicked;CloseWithReturn ( parent , 0 )
end event

type pb_ok from picturebutton within w_valida_origen
integer x = 430
integer y = 628
integer width = 325
integer height = 188
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
boolean originalsize = true
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Cambiar Origen"
end type

event clicked;gs_origen = dw_1.object.cod_origen[dw_1.getrow()]
CloseWithReturn ( parent , 1 )
end event

type dw_1 from datawindow within w_valida_origen
integer x = 9
integer y = 148
integer width = 1774
integer height = 468
integer taborder = 10
string dataobject = "d_valida_origen"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;if currentrow <= 0 then return

this.scrolltorow(currentrow)
this.setrow(currentrow)
this.selectrow(currentrow,true)
end event

event rowfocuschanging;if currentrow <= 0 then return
this.selectrow(currentrow,false)

end event

