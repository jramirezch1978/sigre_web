$PBExportHeader$n_cst_fec_proceso.sru
forward
global type n_cst_fec_proceso from userobject
end type
type st_1 from statictext within n_cst_fec_proceso
end type
type dw_1 from datawindow within n_cst_fec_proceso
end type
type gb_2 from groupbox within n_cst_fec_proceso
end type
end forward

global type n_cst_fec_proceso from userobject
integer width = 1664
integer height = 188
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_1 st_1
dw_1 dw_1
gb_2 gb_2
end type
global n_cst_fec_proceso n_cst_fec_proceso

type variables
Date 		id_fec_proceso
String	is_origen, is_desc_tipo_trabaj, is_tipo_trabaj

end variables

on n_cst_fec_proceso.create
this.st_1=create st_1
this.dw_1=create dw_1
this.gb_2=create gb_2
this.Control[]={this.st_1,&
this.dw_1,&
this.gb_2}
end on

on n_cst_fec_proceso.destroy
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.gb_2)
end on

event constructor;dw_1.InsertRow(0)
end event

type st_1 from statictext within n_cst_fec_proceso
integer x = 901
integer y = 36
integer width = 722
integer height = 124
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean focusrectangle = false
end type

type dw_1 from datawindow within n_cst_fec_proceso
integer x = 14
integer y = 56
integer width = 896
integer height = 72
integer taborder = 20
string title = "none"
string dataobject = "d_ext_fec_proceso_ff"
boolean border = false
boolean livescroll = true
end type

event itemchanged;id_fec_proceso = Date(this.object.fec_proceso [1])

end event

type gb_2 from groupbox within n_cst_fec_proceso
integer width = 1646
integer height = 168
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Seleccione planilla"
end type

