$PBExportHeader$w_help_response.srw
forward
global type w_help_response from window
end type
type cb_1 from commandbutton within w_help_response
end type
type dw_master from datawindow within w_help_response
end type
end forward

global type w_help_response from window
integer width = 1966
integer height = 1384
boolean titlebar = true
string title = "Seleccionar Administracion"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
dw_master dw_master
end type
global w_help_response w_help_response

on w_help_response.create
this.cb_1=create cb_1
this.dw_master=create dw_master
this.Control[]={this.cb_1,&
this.dw_master}
end on

on w_help_response.destroy
destroy(this.cb_1)
destroy(this.dw_master)
end on

event open;dw_master.Settransobject(sqlca)
dw_master.retrieve()

//elimino informacion tabla temporal
delete from tt_ope_ot_adm ;
end event

type cb_1 from commandbutton within w_help_response
integer x = 768
integer y = 1188
integer width = 370
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;Long	 ll_inicio
String ls_ot_adm,ls_flag

//insertar en tabla temporal administraciones 
//para generar distribucion contable y presupuestalmente

For ll_inicio = 1 to dw_master.Rowcount()
	 ls_ot_adm = dw_master.object.ot_adm 	  [ll_inicio]
	 ls_flag	  = dw_master.object.flag_marca [ll_inicio]
	 
	 if ls_flag = '1' then //seleccion de administracion
	 
	    Insert Into tt_ope_ot_adm
		 (ot_adm)
		 Values
		 (:ls_ot_adm) ;
		 
	 end if
	 
	 
Next	


close(parent)
end event

type dw_master from datawindow within w_help_response
integer x = 18
integer y = 8
integer width = 1920
integer height = 1152
integer taborder = 10
string title = "none"
string dataobject = "d_seleccionar_administracion_tbl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

