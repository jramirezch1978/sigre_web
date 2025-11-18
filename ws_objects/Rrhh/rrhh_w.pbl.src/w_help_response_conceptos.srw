$PBExportHeader$w_help_response_conceptos.srw
forward
global type w_help_response_conceptos from window
end type
type cb_1 from commandbutton within w_help_response_conceptos
end type
type dw_master from datawindow within w_help_response_conceptos
end type
end forward

global type w_help_response_conceptos from window
integer width = 1637
integer height = 1776
boolean titlebar = true
string title = "Seleccionar Administracion"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
dw_master dw_master
end type
global w_help_response_conceptos w_help_response_conceptos

on w_help_response_conceptos.create
this.cb_1=create cb_1
this.dw_master=create dw_master
this.Control[]={this.cb_1,&
this.dw_master}
end on

on w_help_response_conceptos.destroy
destroy(this.cb_1)
destroy(this.dw_master)
end on

event open;dw_master.Settransobject(sqlca)
dw_master.retrieve()

//elimino informacion tabla temporal
delete from tt_rh_concepto ;
end event

type cb_1 from commandbutton within w_help_response_conceptos
integer x = 622
integer y = 1592
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
String ls_concep,ls_flag

//insertar en tabla temporal administraciones 
//para generar distribucion contable y presupuestalmente

For ll_inicio = 1 to dw_master.Rowcount()
	 ls_concep = dw_master.object.concepto_concep [ll_inicio]
	 ls_flag	  = dw_master.object.flag 				 [ll_inicio]
	 
	 if ls_flag = '1' then //seleccion de administracion
	 
	    Insert Into tt_rh_concepto
		 (concep)
		 Values
		 (:ls_concep) ;
		 
	 end if
	 
	 
Next	


close(parent)
end event

type dw_master from datawindow within w_help_response_conceptos
integer width = 1609
integer height = 1564
integer taborder = 10
string title = "none"
string dataobject = "d_seleccionar_concepto_tbl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

