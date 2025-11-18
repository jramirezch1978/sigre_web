$PBExportHeader$w_type_export_pdf.srw
forward
global type w_type_export_pdf from window
end type
type cb_cancelar from commandbutton within w_type_export_pdf
end type
type cb_aceptar from commandbutton within w_type_export_pdf
end type
type cbx_xslfop_print from checkbox within w_type_export_pdf
end type
type ddlb_impresoras from dropdownlistbox within w_type_export_pdf
end type
type cbx_postscript from checkbox within w_type_export_pdf
end type
type st_1 from statictext within w_type_export_pdf
end type
type rb_xslfop from radiobutton within w_type_export_pdf
end type
type rb_distill from radiobutton within w_type_export_pdf
end type
type gb_1 from groupbox within w_type_export_pdf
end type
end forward

global type w_type_export_pdf from window
integer width = 2057
integer height = 552
boolean titlebar = true
string title = "Tipo export PDF"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_close ( )
event ue_aceptar ( )
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
cbx_xslfop_print cbx_xslfop_print
ddlb_impresoras ddlb_impresoras
cbx_postscript cbx_postscript
st_1 st_1
rb_xslfop rb_xslfop
rb_distill rb_distill
gb_1 gb_1
end type
global w_type_export_pdf w_type_export_pdf

type variables
Str_parametros istr_parametros
end variables

event ue_close();istr_parametros.b_return = false

closewithreturn(this, istr_parametros)
end event

event ue_aceptar();istr_parametros.b_return = true

if rb_Distill.checked then
	istr_parametros.i_TypeExportPDF = 1
else
	istr_parametros.i_TypeExportPDF = 2
end if

istr_parametros.s_PrintName 			= ddlb_impresoras.text

if gs_user = 'jarch' then
	MessageBox('Aviso', 'Impresora seleccionada es: ' + istr_parametros.s_PrintName)
end if

if cbx_postscript.checked then
	istr_parametros.s_CustomPostScript = '1'
else
	istr_parametros.s_CustomPostScript = '0'
end if

if cbx_xslfop_print.checked then
	istr_parametros.s_printxlsfop = '1'
else
	istr_parametros.s_printxlsfop = '0'
end if


closewithreturn(this, istr_parametros)
end event

on w_type_export_pdf.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.cbx_xslfop_print=create cbx_xslfop_print
this.ddlb_impresoras=create ddlb_impresoras
this.cbx_postscript=create cbx_postscript
this.st_1=create st_1
this.rb_xslfop=create rb_xslfop
this.rb_distill=create rb_distill
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.cbx_xslfop_print,&
this.ddlb_impresoras,&
this.cbx_postscript,&
this.st_1,&
this.rb_xslfop,&
this.rb_distill,&
this.gb_1}
end on

on w_type_export_pdf.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.cbx_xslfop_print)
destroy(this.ddlb_impresoras)
destroy(this.cbx_postscript)
destroy(this.st_1)
destroy(this.rb_xslfop)
destroy(this.rb_distill)
destroy(this.gb_1)
end on

event open;String 	ls_impresoras[], ls_default_printer
Integer 	li_rtn, li_i, li_nbImpresoras, li_item 
Str_parametros lstr_param

lstr_param = Message.PowerObjectParm

ls_default_printer = lstr_param.s_PrintName

//Recupera las subentradas disponibles para una determinada clave 
li_rtn = RegistryKeys("HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Print\Printers", ls_impresoras) 

li_nbImpresoras = UpperBound(ls_impresoras) 

ddlb_impresoras.Reset()

For li_i=1 To li_nbImpresoras 
	ddlb_impresoras.AddItem(ls_impresoras[li_i]) 
next 


//PArametros por defecto
if ddlb_impresoras.TotalItems() > 0 then
	if len(trim(ls_default_printer)) > 0 then
		li_item = ddlb_impresoras.FindItem(ls_Default_printer, 1)
		
		if li_item > 0 then
			ddlb_impresoras.selectitem( li_item )
		end if
	else
		ddlb_impresoras.selectitem( 1 )
	end if
end if

if lstr_param.s_CustomPostScript = '1' then
	cbx_postscript.Checked = true
else
	cbx_postscript.Checked = true
end if

if lstr_param.s_printXLSFOP = '1' then
	cbx_xslfop_print.checked = true
else
	cbx_xslfop_print.checked = false
end if

if lstr_param.i_typeexportpdf = 1 then
	rb_distill.checked = true
else
	rb_xslfop.checked = true
end if


end event

type cb_cancelar from commandbutton within w_type_export_pdf
integer x = 1499
integer y = 344
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event dynamic ue_close()
end event

type cb_aceptar from commandbutton within w_type_export_pdf
integer x = 1143
integer y = 344
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;parent.event ue_aceptar()
end event

type cbx_xslfop_print from checkbox within w_type_export_pdf
integer x = 1289
integer y = 164
integer width = 590
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Printer after XSLFOP"
end type

type ddlb_impresoras from dropdownlistbox within w_type_export_pdf
integer x = 315
integer y = 160
integer width = 946
integer height = 852
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type cbx_postscript from checkbox within w_type_export_pdf
integer x = 59
integer y = 272
integer width = 485
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Custom Post Script"
boolean checked = true
end type

type st_1 from statictext within w_type_export_pdf
integer x = 50
integer y = 172
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Impresora : "
boolean focusrectangle = false
end type

type rb_xslfop from radiobutton within w_type_export_pdf
integer x = 1285
integer y = 36
integer width = 677
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Usando Metodo XSLFOP"
end type

type rb_distill from radiobutton within w_type_export_pdf
integer x = 50
integer y = 64
integer width = 814
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Usando Metodo Distill (Printer)"
boolean checked = true
end type

type gb_1 from groupbox within w_type_export_pdf
integer width = 2025
integer height = 460
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Distill"
end type

