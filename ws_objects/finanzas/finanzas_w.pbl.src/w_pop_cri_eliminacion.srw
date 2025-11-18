$PBExportHeader$w_pop_cri_eliminacion.srw
forward
global type w_pop_cri_eliminacion from window
end type
type cb_1 from commandbutton within w_pop_cri_eliminacion
end type
type dw_1 from datawindow within w_pop_cri_eliminacion
end type
end forward

global type w_pop_cri_eliminacion from window
integer width = 1664
integer height = 428
boolean titlebar = true
string title = "Ingrese Parametros de Busqueda"
windowtype windowtype = response!
long backcolor = 67108864
boolean center = true
cb_1 cb_1
dw_1 dw_1
end type
global w_pop_cri_eliminacion w_pop_cri_eliminacion

on w_pop_cri_eliminacion.create
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.cb_1,&
this.dw_1}
end on

on w_pop_cri_eliminacion.destroy
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;
end event

type cb_1 from commandbutton within w_pop_cri_eliminacion
integer x = 1230
integer y = 48
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;String ls_fecha_inicio,ls_fecha_final,ls_cri
str_parametros lstr_param

dw_1.Accepttext()


ls_fecha_inicio = String(dw_1.object.ad_fecha_inicio [1],'yyyymmdd')
ls_fecha_final  = String(dw_1.object.ad_fecha_final  [1],'yyyymmdd')
ls_cri			 = dw_1.object.cri [1]

IF ls_fecha_inicio = '00000000' OR Isnull(ls_fecha_inicio) OR trim(ls_fecha_inicio) = '' THEN
	Messagebox('Aviso','Debe Ingresar Una Fecha de inicio')
	RETURN
END IF

IF ls_fecha_final = '00000000' OR Isnull(ls_fecha_final) OR trim(ls_fecha_final) = '' THEN
	Messagebox('Aviso','Debe Ingresar Una Fecha Final')
	RETURN
END IF	

IF Isnull(ls_cri) OR Trim(ls_cri) = '' THEN
	ls_cri = '%'	
END IF


lstr_param.field_ret_s[1] = ls_fecha_inicio
lstr_param.field_ret_s[2] = ls_fecha_final
lstr_param.field_ret_s[3] = ls_cri
//
CloseWithReturn(Parent,lstr_param)
end event

type dw_1 from datawindow within w_pop_cri_eliminacion
integer x = 27
integer y = 40
integer width = 1111
integer height = 256
integer taborder = 20
string title = "none"
string dataobject = "d_ext_parametros_cri_tbl"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Accepttext()

end event

event itemerror;Return 1
end event

event constructor;Settransobject(sqlca)
Insertrow(0)
end event

