$PBExportHeader$w_rpt_cotizacion.srw
forward
global type w_rpt_cotizacion from window
end type
type cb_printa_reporte from commandbutton within w_rpt_cotizacion
end type
type dw_master_cotiz_rpt from u_dw_abc within w_rpt_cotizacion
end type
end forward

global type w_rpt_cotizacion from window
integer width = 3387
integer height = 3172
boolean titlebar = true
string title = "Cotizacion Generada"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
cb_printa_reporte cb_printa_reporte
dw_master_cotiz_rpt dw_master_cotiz_rpt
end type
global w_rpt_cotizacion w_rpt_cotizacion

on w_rpt_cotizacion.create
this.cb_printa_reporte=create cb_printa_reporte
this.dw_master_cotiz_rpt=create dw_master_cotiz_rpt
this.Control[]={this.cb_printa_reporte,&
this.dw_master_cotiz_rpt}
end on

on w_rpt_cotizacion.destroy
destroy(this.cb_printa_reporte)
destroy(this.dw_master_cotiz_rpt)
end on

event open;	dw_master_cotiz_rpt.Retrieve(gi_cotizacion_id)
end event

type cb_printa_reporte from commandbutton within w_rpt_cotizacion
integer x = 2176
integer y = 28
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "IMPRIMIR"
end type

event clicked;long random_number, ll_return
String    ls_filename, random_number_string, ls_filepathname,filepathname

//String ls_Null, ls_pdf_filename, ls_filepathname, random_number_string,filepathname
randomize( cpu() )
random_number = rand(9999)
random_number_string = string(random_number)
//
//dw_master_cotiz_rpt.Object.DataWindow.Export.PDF.Method = Distill!
//dw_master_cotiz_rpt.Modify("DataWindow.Export.PDF.Method = XSLFOP! ")
//dw_master_cotiz_rpt.Object.DataWindow.Export.PDF.Distill.CustomPostScript  = 'No'
//
////filepathname = MapVirtualPath("D:\Reporte Clientes-"+ random_number_string + ".pdf")
//ls_pdf_filename = "D:\ReporteCotizacion-"+ random_number_string + ".pdf"
//
//if dw_master_cotiz_rpt.SaveAs(ls_pdf_filename, PDF!, true) = 1 then
//		messagebox("Correcto","Archivo exportado")
//		#if defined PBWEBFORM then
//			DownloadFile(ls_pdf_filename,true)
//		#end if
//end if

//IF (dw_master_cotiz_rpt.RowCount > 0) THEN
//filepathname = MapVirtualPath("D:\Reporte Clientes-"+ random_number_string + ".pdf")
ls_filename = "D:\Reporte Clientes-"+ random_number_string + ".pdf"
//   TRY 
      ll_return = dw_master_cotiz_rpt.SaveAs(ls_filename, PDF!, TRUE)
      IF (ll_return <> 1) THEN
         MessageBox("Export to PDF", "Failed")
      ELSE
         #if defined PBWBFORM then
            DownloadFile(ls_filename, TRUE)
         #end if
      END IF
//      #if defined PBDOTNET then
//         CATCH (SystemException se)
//            messagebox("PB.NET Exception", se.message)
//      #elseif defined PBNATIVE then
//         CATCH (throwable thr)
//            messagebox("PB Native Exception", se.getMessage())
//      #end if
//END TRY
//END IF
close(w_rpt_cotizacion)
end event

type dw_master_cotiz_rpt from u_dw_abc within w_rpt_cotizacion
integer width = 3355
integer height = 3076
string dataobject = "dw_rpt_cotizacion_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

