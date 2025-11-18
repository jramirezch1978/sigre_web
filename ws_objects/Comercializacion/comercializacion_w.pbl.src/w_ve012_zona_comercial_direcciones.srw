$PBExportHeader$w_ve012_zona_comercial_direcciones.srw
forward
global type w_ve012_zona_comercial_direcciones from w_abc_master
end type
type st_1 from statictext within w_ve012_zona_comercial_direcciones
end type
type st_2 from statictext within w_ve012_zona_comercial_direcciones
end type
end forward

global type w_ve012_zona_comercial_direcciones from w_abc_master
integer width = 2939
integer height = 1000
string title = "[VE012] Direcciones Disponibles"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_1 st_1
st_2 st_2
end type
global w_ve012_zona_comercial_direcciones w_ve012_zona_comercial_direcciones

on w_ve012_zona_comercial_direcciones.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_ve012_zona_comercial_direcciones.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event ue_open_pre;call super::ue_open_pre;of_center_window(this)
end event

event ue_set_access;//Override
end event

event open;//Override
THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()

string ls_proveedor

ls_proveedor = trim(message.stringparm)

if ls_proveedor = '' or isnull(ls_proveedor) then
	
	messagebox('Aviso','Problemas al pasar parametros')
	close(this)
	
end if

dw_master.retrieve( ls_proveedor )
end event

type dw_master from w_abc_master`dw_master within w_ve012_zona_comercial_direcciones
integer x = 37
integer y = 288
integer width = 2821
integer height = 548
string dataobject = "d_abc_zona_comercial_direcciones"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
idw_mst  = 	dw_master

end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

event dw_master::doubleclicked;call super::doubleclicked;if row = 0 then return

string ls_item

ls_item = string(this.object.item[row])

closewithreturn(parent,ls_item)
end event

type st_1 from statictext within w_ve012_zona_comercial_direcciones
integer x = 37
integer y = 32
integer width = 2821
integer height = 132
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Este cliente tiene mas de una direccion de facturacion, las cuales se usan para fines internos del sistema.  Por favor Seleccione la direccion de Facturacion que se debe considerar."
boolean focusrectangle = false
end type

type st_2 from statictext within w_ve012_zona_comercial_direcciones
integer x = 37
integer y = 192
integer width = 1243
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccione una direccion haciendo Doble Clic"
boolean focusrectangle = false
end type

