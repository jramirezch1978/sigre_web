$PBExportHeader$w_print_opt.srw
$PBExportComments$opciones de impresion
forward
global type w_print_opt from window
end type
type cbx_imprimirarchivo from checkbox within w_print_opt
end type
type st_1 from statictext within w_print_opt
end type
type ddlb_rangoincluye from dropdownlistbox within w_print_opt
end type
type st_5 from statictext within w_print_opt
end type
type cb_printer_setup from commandbutton within w_print_opt
end type
type cb_cancelar from commandbutton within w_print_opt
end type
type st_3 from statictext within w_print_opt
end type
type sle_rango from singlelineedit within w_print_opt
end type
type rb_rango from radiobutton within w_print_opt
end type
type rb_pagina_actual from radiobutton within w_print_opt
end type
type rb_todas from radiobutton within w_print_opt
end type
type em_copias from editmask within w_print_opt
end type
type st_copias from statictext within w_print_opt
end type
type sle_printer from singlelineedit within w_print_opt
end type
type st_printer from statictext within w_print_opt
end type
type cb_ok from commandbutton within w_print_opt
end type
type gb_1 from groupbox within w_print_opt
end type
end forward

global type w_print_opt from window
integer x = 672
integer y = 268
integer width = 2213
integer height = 840
boolean titlebar = true
string title = "Print Options"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
toolbaralignment toolbaralignment = alignatleft!
event ue_help_topic ( )
event ue_help_index ( )
cbx_imprimirarchivo cbx_imprimirarchivo
st_1 st_1
ddlb_rangoincluye ddlb_rangoincluye
st_5 st_5
cb_printer_setup cb_printer_setup
cb_cancelar cb_cancelar
st_3 st_3
sle_rango sle_rango
rb_rango rb_rango
rb_pagina_actual rb_pagina_actual
rb_todas rb_todas
em_copias em_copias
st_copias st_copias
sle_printer sle_printer
st_printer st_printer
cb_ok cb_ok
gb_1 gb_1
end type
global w_print_opt w_print_opt

type variables
string is_opt_pag
datawindow idw_1
Integer ii_help
end variables

event ue_help_topic;ShowHelp(gs_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gs_help, Index!)
end event

event open;// por el powerobjectparm se pasa el nombre del datawindow control a imprimir

idw_1 = message.powerobjectparm
sle_printer.text = idw_1.describe('datawindow.printer')
is_opt_pag = 'T'
ddlb_rangoincluye.selectitem( 1 )

// ii_help = 101           // help topic

end event

on w_print_opt.create
this.cbx_imprimirarchivo=create cbx_imprimirarchivo
this.st_1=create st_1
this.ddlb_rangoincluye=create ddlb_rangoincluye
this.st_5=create st_5
this.cb_printer_setup=create cb_printer_setup
this.cb_cancelar=create cb_cancelar
this.st_3=create st_3
this.sle_rango=create sle_rango
this.rb_rango=create rb_rango
this.rb_pagina_actual=create rb_pagina_actual
this.rb_todas=create rb_todas
this.em_copias=create em_copias
this.st_copias=create st_copias
this.sle_printer=create sle_printer
this.st_printer=create st_printer
this.cb_ok=create cb_ok
this.gb_1=create gb_1
this.Control[]={this.cbx_imprimirarchivo,&
this.st_1,&
this.ddlb_rangoincluye,&
this.st_5,&
this.cb_printer_setup,&
this.cb_cancelar,&
this.st_3,&
this.sle_rango,&
this.rb_rango,&
this.rb_pagina_actual,&
this.rb_todas,&
this.em_copias,&
this.st_copias,&
this.sle_printer,&
this.st_printer,&
this.cb_ok,&
this.gb_1}
end on

on w_print_opt.destroy
destroy(this.cbx_imprimirarchivo)
destroy(this.st_1)
destroy(this.ddlb_rangoincluye)
destroy(this.st_5)
destroy(this.cb_printer_setup)
destroy(this.cb_cancelar)
destroy(this.st_3)
destroy(this.sle_rango)
destroy(this.rb_rango)
destroy(this.rb_pagina_actual)
destroy(this.rb_todas)
destroy(this.em_copias)
destroy(this.st_copias)
destroy(this.sle_printer)
destroy(this.st_printer)
destroy(this.cb_ok)
destroy(this.gb_1)
end on

type cbx_imprimirarchivo from checkbox within w_print_opt
integer x = 1495
integer y = 548
integer width = 608
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Imprimir en un Archivo"
end type

type st_1 from statictext within w_print_opt
integer x = 119
integer y = 596
integer width = 210
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Incluir:"
boolean focusrectangle = false
end type

type ddlb_rangoincluye from dropdownlistbox within w_print_opt
integer x = 343
integer y = 596
integer width = 965
integer height = 400
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
boolean sorted = false
string item[] = {"Todas las páginas","Solo páginas pares","Solo páginas impares"}
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_print_opt
integer x = 69
integer y = 528
integer width = 1330
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
boolean enabled = false
string text = "Ejemplo:  2,3,5,  8-20"
boolean focusrectangle = false
end type

type cb_printer_setup from commandbutton within w_print_opt
integer x = 1810
integer y = 284
integer width = 338
integer height = 88
integer taborder = 90
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Printer Setup"
end type

event clicked;printsetup()
sle_printer.text = idw_1.describe('datawindow.printer')
end event

type cb_cancelar from commandbutton within w_print_opt
integer x = 1810
integer y = 164
integer width = 338
integer height = 88
integer taborder = 80
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;closewithreturn(parent, '0')
end event

type st_3 from statictext within w_print_opt
integer x = 69
integer y = 472
integer width = 1330
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
boolean enabled = false
string text = "El rango debe expresarse con commas y guiones."
boolean focusrectangle = false
end type

type sle_rango from singlelineedit within w_print_opt
integer x = 453
integer y = 364
integer width = 882
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type rb_rango from radiobutton within w_print_opt
integer x = 119
integer y = 368
integer width = 297
integer height = 68
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 78748035
string text = "Rango:"
end type

event clicked;	
sle_rango.enabled = true
is_opt_pag = 'R'


end event

type rb_pagina_actual from radiobutton within w_print_opt
integer x = 119
integer y = 292
integer width = 462
integer height = 68
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 78748035
string text = "Pagina Actual"
end type

event clicked;
sle_rango.text = ''
sle_rango.enabled = false
is_opt_pag = 'P'
	




end event

type rb_todas from radiobutton within w_print_opt
integer x = 114
integer y = 220
integer width = 242
integer height = 68
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 78748035
string text = "Todas"
boolean checked = true
end type

event clicked;
sle_rango.text = ''
sle_rango.enabled = false
is_opt_pag = 'T'



end event

type em_copias from editmask within w_print_opt
integer x = 1755
integer y = 448
integer width = 343
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "1"
borderstyle borderstyle = stylelowered!
string mask = "#####"
boolean spin = true
string minmax = "1~~"
end type

type st_copias from statictext within w_print_opt
integer x = 1495
integer y = 452
integer width = 187
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 78748035
boolean enabled = false
string text = "Copias:"
boolean focusrectangle = false
end type

type sle_printer from singlelineedit within w_print_opt
integer x = 329
integer y = 48
integer width = 1358
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_printer from statictext within w_print_opt
integer x = 64
integer y = 52
integer width = 233
integer height = 68
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
boolean enabled = false
string text = "Printer:"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_print_opt
integer x = 1810
integer y = 48
integer width = 338
integer height = 88
integer taborder = 70
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "OK"
boolean default = true
end type

event clicked;string 	ls_work, ls_prtparam,  ls_error, ls_PathDocName, ls_DocName, ls_Return
long 		ll_row
Integer	li_value

ls_prtparam = ''

// Rango de Paginas
CHOOSE CASE is_opt_pag // Se escogio un rango?
	CASE 'T'  // Todos
		ls_work = ''
	CASE 'P' // Pagina Actual?
		ll_row = idw_1.getrow()
		ls_work = idw_1.describe("evaluate('page()',"+string(ll_row)+")")
	CASE 'R' // Rango?
		ls_work = sle_rango.text
END CHOOSE		
IF len(ls_work) > 0 THEN
	ls_prtparam = ls_prtparam +  " datawindow.print.page.range = '"+ls_work+"'"
END IF

//Rango de Impresion
ls_work = String( ddlb_RangoIncluye.FindItem( ddlb_RangoIncluye.Text, 0 ) - 1 )
ls_prtparam = ls_prtparam + " DataWindow.Print.Page.RangeInclude = " + ls_work

// numero de copias ?
IF Integer(em_copias.text) > 0 THEN
	ls_prtparam = ls_prtparam +  " datawindow.print.copies = "+em_copias.text
END IF

// Imprimir en un archivo
if cbx_ImprimirArchivo.checked then // Archivo a Imprimir ?
	li_value = GetFileSaveName("Archivo a Imprimir", ls_PathDocName, &
		ls_DocName, "PRN", "Print (*.PRN),*.PRN")
	if li_value = 1 then 
		ls_prtparam = ls_prtparam + " DataWindow.Print.FileName = '" + ls_PathDocName + "'"
	else // Si cancela el diálogo termina la ejecución
		return
	end if
Else
	ls_prtparam = ls_prtparam + " DataWindow.Print.FileName = ''"
end if


// modifica datawindow
ls_error = idw_1.modify(ls_prtparam)
IF len(ls_error) > 0 THEN // si hay error 
	ls_return = '0'
	messagebox('Error en Parametros de Impresion','Mensaje de Error = ' + ls_error + '~r~nParametro = ' + ls_prtparam)
	return
ELSE
	ls_Return = '1'
END IF
CloseWithReturn(parent, ls_Return)
//CLOSE(Parent)
end event

type gb_1 from groupbox within w_print_opt
integer x = 37
integer y = 160
integer width = 1399
integer height = 576
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
string text = "Rango de Paginas"
end type

