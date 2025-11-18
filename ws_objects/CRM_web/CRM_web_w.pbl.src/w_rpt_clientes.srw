$PBExportHeader$w_rpt_clientes.srw
forward
global type w_rpt_clientes from window
end type
type cb_print_rpt from commandbutton within w_rpt_clientes
end type
type dw_master from u_dw_rpt within w_rpt_clientes
end type
end forward

global type w_rpt_clientes from window
integer width = 5861
integer height = 2460
boolean titlebar = true
string title = "Modulo de Cotizacion - Reporte Clientes"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
cb_print_rpt cb_print_rpt
dw_master dw_master
end type
global w_rpt_clientes w_rpt_clientes

on w_rpt_clientes.create
this.cb_print_rpt=create cb_print_rpt
this.dw_master=create dw_master
this.Control[]={this.cb_print_rpt,&
this.dw_master}
end on

on w_rpt_clientes.destroy
destroy(this.cb_print_rpt)
destroy(this.dw_master)
end on

event open;dw_master.SetTransObject(sqlca)
dw_master.retrieve()
end event

type cb_print_rpt from commandbutton within w_rpt_clientes
integer x = 5042
integer y = 44
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "IMPRIMIR"
end type

event clicked;long random_number
String ls_Null, ls_pdf_filename, ls_filepathname, random_number_string,filepathname
randomize( cpu() )
random_number = rand(9999)
random_number_string = string(random_number)

dw_master.Object.DataWindow.Export.PDF.Method = Distill!
dw_master.Modify("DataWindow.Export.PDF.Method = XSLFOP! ")
dw_master.Object.DataWindow.Export.PDF.Distill.CustomPostScript  = 'No'

//filepathname = MapVirtualPath("D:\Reporte Clientes-"+ random_number_string + ".pdf")
ls_pdf_filename = "D:\ReporteClientes-"+ random_number_string + ".pdf"

if dw_master.SaveAs(ls_pdf_filename, PDF!, true) = 1 then
		messagebox("Correcto","Archivo exportado")
		#if defined PBWEBFORM then
			DownloadFile(ls_pdf_filename,true)
		#end if
end if
close(w_rpt_clientes)
end event

type dw_master from u_dw_rpt within w_rpt_clientes
integer y = 12
integer width = 5833
integer height = 2336
string dataobject = "dw_rpt_clientes_tb"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

