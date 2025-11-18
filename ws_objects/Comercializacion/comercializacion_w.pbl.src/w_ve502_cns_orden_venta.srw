$PBExportHeader$w_ve502_cns_orden_venta.srw
forward
global type w_ve502_cns_orden_venta from w_abc_master_tab
end type
type tabpage_5 from userobject within tab_1
end type
type dw_5 from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_5 dw_5
end type
type sle_codigo from u_sle_codigo within w_ve502_cns_orden_venta
end type
type st_1 from statictext within w_ve502_cns_orden_venta
end type
type cb_1 from commandbutton within w_ve502_cns_orden_venta
end type
end forward

global type w_ve502_cns_orden_venta from w_abc_master_tab
integer width = 4192
integer height = 2492
string title = "[VE502] Consulta de orden de venta"
string menuname = "m_consulta"
sle_codigo sle_codigo
st_1 st_1
cb_1 cb_1
end type
global w_ve502_cns_orden_venta w_ve502_cns_orden_venta

type variables
String is_articulo

u_dw_abc  idw_detail5
end variables

forward prototypes
public subroutine of_get_orden (string as_orden)
public subroutine of_asigna_dws ()
end prototypes

public subroutine of_get_orden (string as_orden);Long ll_count
String ls_origen, ls_doc_ov

tab_1.SelectTab(1)

idw_detail1.Reset()
idw_detail2.Reset()
idw_detail3.Reset()
idw_detail4.Reset()
idw_detail5.Reset()

dw_master.setFocus()

dw_master.Retrieve(as_orden)

if dw_master.RowCount() = 0 then
	Messagebox( "Error", "Orden de Venta " +  as_orden + " no existe, por favor verifique!", StopSign!)		
	Return
end if

tab_1.SelectTab(1)

idw_detail1.Retrieve(as_orden)
idw_detail2.Retrieve(as_orden)
idw_detail3.Retrieve(as_orden)
idw_detail4.Retrieve(as_orden)
idw_detail5.Retrieve(as_orden)

dw_master.setFocus()

dw_master.ii_protect = 1
dw_master.of_protect()

end subroutine

public subroutine of_asigna_dws ();//Override
idw_detail1	= tab_1.tabpage_1.dw_1
idw_detail2	= tab_1.tabpage_2.dw_2
idw_detail3	= tab_1.tabpage_3.dw_3
idw_detail4	= tab_1.tabpage_4.dw_4
idw_detail5	= tab_1.tabpage_5.dw_5
end subroutine

on w_ve502_cns_orden_venta.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.sle_codigo=create sle_codigo
this.st_1=create st_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_codigo
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
end on

on w_ve502_cns_orden_venta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_codigo)
destroy(this.st_1)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;//dw_orden.SetTransObject(sqlca)
//dw_oper.SetTransObject(sqlca)

of_asigna_dws()

idw_detail1.SetTransObject(sqlca)
idw_detail2.SetTransObject(sqlca)
idw_detail3.SetTransObject(sqlca)
idw_detail4.SetTransObject(sqlca)
idw_detail5.SetTransObject(sqlca)

end event

event ue_dw_share;// Override

end event

event resize;// override
of_asigna_dws()

dw_master.width = newwidth - dw_master.x

tab_1.width  = newwidth  - tab_1.x
tab_1.height = newheight - tab_1.y

idw_detail1.width  = tab_1.tabpage_1.width  - idw_detail1.x - 10
idw_detail1.height = tab_1.tabpage_1.height - idw_detail1.y - 10

idw_detail2.width  = tab_1.tabpage_2.width  - idw_detail2.x - 10
idw_detail2.height = tab_1.tabpage_2.height - idw_detail2.y - 10

idw_detail3.width  = tab_1.tabpage_3.width  - idw_detail3.x - 10
idw_detail3.height = tab_1.tabpage_3.height - idw_detail3.y - 10

idw_detail4.width  = tab_1.tabpage_4.width  - idw_detail4.x - 10
idw_detail4.height = tab_1.tabpage_4.height - idw_detail4.y - 10

idw_detail5.width  = tab_1.tabpage_5.width  - idw_detail5.x - 10
idw_detail5.height = tab_1.tabpage_5.height - idw_detail5.y - 10
end event

event ue_saveas_excel;call super::ue_saveas_excel;string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( idw_1, ls_file )
End If
end event

event ue_saveas_pdf;call super::ue_saveas_pdf;string ls_path, ls_file
int li_rc
n_cst_email	lnv_email

ls_file = idw_1.Object.DataWindow.Print.DocumentName

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "PDF", &
   "Archivos PDF (*.pdf),*.pdf" , "C:\", 32770)

IF li_rc = 1 Then
	lnv_email = CREATE n_cst_email
	try
		if not lnv_email.of_create_pdf( idw_1, ls_path) then return
		
		MessageBox('Confirmacion', 'Se ha creado el archivo ' + ls_path + ' satisfactoriamente.', Exclamation!)
		
	catch (Exception ex)
		MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + ls_path + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
		
	finally
		Destroy lnv_email
		
	end try
	
End If
end event

event ue_saveas;call super::ue_saveas;idw_1.EVENT ue_saveas()
end event

type dw_master from w_abc_master_tab`dw_master within w_ve502_cns_orden_venta
integer y = 120
integer width = 3397
integer height = 1076
string dataobject = "d_cns_orden_venta_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tab_1 from w_abc_master_tab`tab_1 within w_ve502_cns_orden_venta
integer x = 0
integer y = 1220
integer width = 4023
integer height = 1112
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_5=create tabpage_5
call super::create
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_1.destroy
call super::destroy
destroy(this.tabpage_5)
end on

type tabpage_1 from w_abc_master_tab`tabpage_1 within tab_1
integer width = 3986
integer height = 984
string text = "Detalle"
end type

type dw_1 from w_abc_master_tab`dw_1 within tabpage_1
integer width = 3808
integer height = 912
string dataobject = "d_cns_orden_venta_det_tbl"
end type

event dw_1::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectura de este dw

end event

event dw_1::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_2 from w_abc_master_tab`tabpage_2 within tab_1
integer width = 3986
integer height = 984
string text = "Vales de salida"
end type

type dw_2 from w_abc_master_tab`dw_2 within tabpage_2
integer width = 3369
integer height = 924
string dataobject = "d_cns_vales_salida_x_ov_grd"
end type

event dw_2::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectura de este dw

end event

event dw_2::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_3 from w_abc_master_tab`tabpage_3 within tab_1
integer width = 3986
integer height = 984
string text = "Guías de remisión"
end type

type dw_3 from w_abc_master_tab`dw_3 within tabpage_3
integer width = 2382
integer height = 700
string dataobject = "d_cns_guias_remision_x_ov_grd"
end type

event dw_3::constructor;call super::constructor;is_mastdet = 'm'		
is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_3::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_4 from w_abc_master_tab`tabpage_4 within tab_1
integer width = 3986
integer height = 984
string text = "Embarques"
end type

type dw_4 from w_abc_master_tab`dw_4 within tabpage_4
integer width = 3973
integer height = 920
string dataobject = "d_cns_embarque_x_ov_grd"
end type

event dw_4::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle, 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_4::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3986
integer height = 984
long backcolor = 79741120
string text = "Facturas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_5.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_5.destroy
destroy(this.dw_5)
end on

type dw_5 from u_dw_abc within tabpage_5
integer width = 3301
integer height = 928
integer taborder = 20
string dataobject = "d_cns_factura_x_ov_grd"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type sle_codigo from u_sle_codigo within w_ve502_cns_orden_venta
integer x = 498
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 9
ibl_mayuscula = true
end event

event modified;call super::modified;cb_1.event clicked()
end event

type st_1 from statictext within w_ve502_cns_orden_venta
integer y = 16
integer width = 475
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de venta:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ve502_cns_orden_venta
integer x = 1079
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consultar"
end type

event clicked;String ls_cod
ls_cod = TRIM(sle_codigo.text)
of_get_orden( ls_cod )


end event

