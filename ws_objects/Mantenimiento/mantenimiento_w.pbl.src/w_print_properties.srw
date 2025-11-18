$PBExportHeader$w_print_properties.srw
forward
global type w_print_properties from window
end type
type pb_2 from picturebutton within w_print_properties
end type
type pb_1 from picturebutton within w_print_properties
end type
type dw_master from u_dw_abc within w_print_properties
end type
end forward

global type w_print_properties from window
integer width = 1678
integer height = 1060
boolean titlebar = true
string title = "Propiedades de la impresion"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_aceptar ( )
event ue_cancelar ( )
pb_2 pb_2
pb_1 pb_1
dw_master dw_master
end type
global w_print_properties w_print_properties

type variables
sg_parametros 	istr_param
u_dw_rpt			idw_1
end variables

event ue_aceptar();idw_1.Object.DataWindow.Print.Paper.Size			= dw_master.object.paper_size		[1]
idw_1.Object.DataWindow.Print.Paper.Source 		= dw_master.object.paper_source	[1] 
idw_1.Object.DataWindow.Print.Preview.Rulers 	= dw_master.object.rules			[1] 
idw_1.Object.DataWindow.Print.Orientation			= dw_master.object.orientation	[1]
idw_1.Object.DataWindow.Print.Page.RangeInclude	= dw_master.object.range			[1]
idw_1.Object.DataWindow.Print.Quality				= dw_master.object.calidad			[1]

close(this)
end event

event ue_cancelar();close(this)
end event

on w_print_properties.create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_master=create dw_master
this.Control[]={this.pb_2,&
this.pb_1,&
this.dw_master}
end on

on w_print_properties.destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_master)
end on

event open;string ls_size

if Message.PowerObjectParm.ClassName() <> 'sg_parametros' then
	MessageBox('Aviso', 'Parámetros mal ingresados', StopSign!)
	close(this)
end if

istr_param = Message.PowerObjectParm

idw_1 = istr_param.dw_d

If IsNull(idw_1) or Not IsValid(idw_1) then
	MessageBox('Aviso', 'Datawindow Invalido', StopSign!)
	close(this)
end if

dw_master.object.paper_size	[1] = idw_1.Object.DataWindow.Print.Paper.Size
dw_master.object.paper_source	[1] = idw_1.Object.DataWindow.Print.Paper.Source
dw_master.object.rules			[1] = idw_1.Object.DataWindow.Print.Preview.Rulers
dw_master.object.orientation	[1] = idw_1.Object.DataWindow.Print.Orientation
dw_master.object.range			[1] = idw_1.Object.DataWindow.Print.Page.RangeInclude
dw_master.object.calidad		[1] = idw_1.Object.DataWindow.Print.Quality	

end event

type pb_2 from picturebutton within w_print_properties
integer x = 850
integer y = 756
integer width = 315
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_cancelar()
end event

type pb_1 from picturebutton within w_print_properties
integer x = 475
integer y = 756
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

type dw_master from u_dw_abc within w_print_properties
integer y = 24
integer width = 1641
integer height = 736
string dataobject = "d_paper_size_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

