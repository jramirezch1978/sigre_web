$PBExportHeader$w_select_printer.srw
$PBExportComments$Ventana para seleccionar impresora por defecto
forward
global type w_select_printer from window
end type
type st_titulo from statictext within w_select_printer
end type
type ddlb_impresoras from dropdownlistbox within w_select_printer
end type
type cb_aceptar from commandbutton within w_select_printer
end type
type cb_cancelar from commandbutton within w_select_printer
end type
type st_info from statictext within w_select_printer
end type
end forward

global type w_select_printer from window
integer width = 2057
integer height = 500
boolean titlebar = true
string title = "Seleccionar Impresora"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
st_titulo st_titulo
ddlb_impresoras ddlb_impresoras
cb_aceptar cb_aceptar
cb_cancelar cb_cancelar
st_info st_info
end type
global w_select_printer w_select_printer

type variables
str_parametros istr_param
end variables

on w_select_printer.create
this.st_titulo=create st_titulo
this.ddlb_impresoras=create ddlb_impresoras
this.cb_aceptar=create cb_aceptar
this.cb_cancelar=create cb_cancelar
this.st_info=create st_info
this.Control[]={this.st_titulo,&
this.ddlb_impresoras,&
this.cb_aceptar,&
this.cb_cancelar,&
this.st_info}
end on

on w_select_printer.destroy
destroy(this.st_titulo)
destroy(this.ddlb_impresoras)
destroy(this.cb_aceptar)
destroy(this.cb_cancelar)
destroy(this.st_info)
end on

event open;String 	ls_impresoras[], ls_default_printer
Integer li_rtn, li_i, li_nbImpresoras, li_item

istr_param = Message.PowerObjectParm

//Obtener las impresoras disponibles del registro de Windows
li_rtn = RegistryKeys("HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Print\Printers", ls_impresoras) 

li_nbImpresoras = UpperBound(ls_impresoras)

ddlb_impresoras.Reset()

//Agregar las impresoras al DropDownListBox
For li_i = 1 To li_nbImpresoras 
	ddlb_impresoras.AddItem(ls_impresoras[li_i]) 
Next

//Si hay alguna impresora por defecto, seleccionarla
if ddlb_impresoras.TotalItems() > 0 then
	ls_default_printer = istr_param.s_PrintName
	
	if len(trim(ls_default_printer)) > 0 then
		li_item = ddlb_impresoras.FindItem(ls_default_printer, 1)
		
		if li_item > 0 then
			ddlb_impresoras.SelectItem(li_item)
		else
			ddlb_impresoras.SelectItem(1)
		end if
	else
		ddlb_impresoras.SelectItem(1)
	end if
else
	MessageBox("Aviso", "No se encontraron impresoras instaladas en el sistema.", Information!)
	istr_param.b_return = false
	istr_param.s_PrintName = ""
	CloseWithReturn(this, istr_param)
end if

//Personalizar tÃ­tulo si viene en parÃ¡metros
if len(trim(istr_param.titulo)) > 0 then
	this.title = istr_param.titulo
end if

end event

type st_titulo from statictext within w_select_printer
integer x = 37
integer y = 24
integer width = 1984
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Seleccione la impresora por defecto:"
boolean focusrectangle = false
end type

type ddlb_impresoras from dropdownlistbox within w_select_printer
integer x = 37
integer y = 100
integer width = 1984
integer height = 700
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type cb_aceptar from commandbutton within w_select_printer
integer x = 1243
integer y = 316
integer width = 384
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;if len(trim(ddlb_impresoras.Text)) > 0 then
	istr_param.b_return = true
	istr_param.s_PrintName = trim(ddlb_impresoras.Text)
	CloseWithReturn(parent, istr_param)
else
	MessageBox("Aviso", "Por favor seleccione una impresora.", Information!)
end if
end event

type cb_cancelar from commandbutton within w_select_printer
integer x = 1637
integer y = 316
integer width = 384
integer height = 100
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;istr_param.b_return = false
istr_param.s_PrintName = ""
CloseWithReturn(parent, istr_param)
end event

type st_info from statictext within w_select_printer
integer x = 37
integer y = 248
integer width = 1984
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 16777215
string text = "Esta impresora se guardará como su impresora por defecto."
boolean focusrectangle = false
boolean righttoleft = true
end type

