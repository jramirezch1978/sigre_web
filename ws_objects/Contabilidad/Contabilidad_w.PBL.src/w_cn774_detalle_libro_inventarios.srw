$PBExportHeader$w_cn774_detalle_libro_inventarios.srw
forward
global type w_cn774_detalle_libro_inventarios from w_prc
end type
type ddlb_libro from dropdownlistbox within w_cn774_detalle_libro_inventarios
end type
type st_4 from statictext within w_cn774_detalle_libro_inventarios
end type
type cb_procesar from commandbutton within w_cn774_detalle_libro_inventarios
end type
type st_3 from statictext within w_cn774_detalle_libro_inventarios
end type
type sle_reg from singlelineedit within w_cn774_detalle_libro_inventarios
end type
type dw_report from u_dw_cns within w_cn774_detalle_libro_inventarios
end type
type st_1 from statictext within w_cn774_detalle_libro_inventarios
end type
type st_2 from statictext within w_cn774_detalle_libro_inventarios
end type
type em_ano from editmask within w_cn774_detalle_libro_inventarios
end type
type ddlb_mes from dropdownlistbox within w_cn774_detalle_libro_inventarios
end type
type gb_1 from groupbox within w_cn774_detalle_libro_inventarios
end type
end forward

global type w_cn774_detalle_libro_inventarios from w_prc
integer width = 5019
integer height = 2136
string title = "[CN774] Libros Detalle Inventario y Balance"
string menuname = "m_impresion"
event ue_saveas ( )
event ue_saveas_excel ( )
event ue_saveas_pdf ( )
event ue_print ( )
event ue_filter_avanzado ( )
event ue_filter ( )
event ue_preview ( )
event ue_sort ( )
event ue_zoom ( integer ai_zoom )
ddlb_libro ddlb_libro
st_4 st_4
cb_procesar cb_procesar
st_3 st_3
sle_reg sle_reg
dw_report dw_report
st_1 st_1
st_2 st_2
em_ano em_ano
ddlb_mes ddlb_mes
gb_1 gb_1
end type
global w_cn774_detalle_libro_inventarios w_cn774_detalle_libro_inventarios

type variables
u_ds_base 	ids_datos
boolean 		ib_preview


end variables

event ue_saveas();dw_report.EVENT ue_saveas()
end event

event ue_saveas_excel();string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

event ue_saveas_pdf();string ls_path, ls_file
int li_rc
n_cst_email	lnv_email

ls_file = dw_report.Object.DataWindow.Print.DocumentName

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "PDF", &
   "Archivos PDF (*.pdf),*.pdf" , "C:\", 32770)

IF li_rc = 1 Then
	lnv_email = CREATE n_cst_email
	try
		if not lnv_email.of_create_pdf( dw_report, ls_path) then return
		
		MessageBox('Confirmacion', 'Se ha creado el archivo ' + ls_path + ' satisfactoriamente.', Exclamation!)
		
	catch (Exception ex)
		MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + ls_path + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
		
	finally
		Destroy lnv_email
		
	end try
	
End If
end event

event ue_print();dw_report.EVENT ue_print()
end event

event ue_filter_avanzado();dw_report.EVENT ue_filter_avanzado()
end event

event ue_filter();dw_report.EVENT ue_filter()
end event

event ue_preview();IF ib_preview THEN
	dw_report.Modify("DataWindow.Print.Preview=No")
	dw_report.Modify("datawindow.print.preview.zoom = " + String(dw_report.ii_zoom_actual))
	dw_report.title = "Reporte " + " (Zoom: " + String(dw_report.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	dw_report.Modify("DataWindow.Print.Preview=Yes")
	dw_report.Modify("datawindow.print.preview.zoom = " + String(dw_report.ii_zoom_actual))
	dw_report.title = "Reporte " + " (Zoom: " + String(dw_report.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_sort();dw_report.EVENT ue_sort()
end event

event ue_zoom(integer ai_zoom);//dw_report.EVENT ue_zoom(ai_zoom)
end event

event open;call super::open;
dw_report.settransobject(sqlca)
//dw_report.settransobject(sqlca)
em_ano.text = string(Date(gnvo_app.of_fecha_actual()), 'yyyy')

ids_datos = create u_ds_base



end event

on w_cn774_detalle_libro_inventarios.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.ddlb_libro=create ddlb_libro
this.st_4=create st_4
this.cb_procesar=create cb_procesar
this.st_3=create st_3
this.sle_reg=create sle_reg
this.dw_report=create dw_report
this.st_1=create st_1
this.st_2=create st_2
this.em_ano=create em_ano
this.ddlb_mes=create ddlb_mes
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_libro
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.cb_procesar
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.sle_reg
this.Control[iCurrent+6]=this.dw_report
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.em_ano
this.Control[iCurrent+10]=this.ddlb_mes
this.Control[iCurrent+11]=this.gb_1
end on

on w_cn774_detalle_libro_inventarios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_libro)
destroy(this.st_4)
destroy(this.cb_procesar)
destroy(this.st_3)
destroy(this.sle_reg)
destroy(this.dw_report)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_ano)
destroy(this.ddlb_mes)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event close;call super::close;destroy ids_datos
end event

type ddlb_libro from dropdownlistbox within w_cn774_detalle_libro_inventarios
integer x = 1696
integer y = 68
integer width = 1874
integer height = 856
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean vscrollbar = true
string item[] = {"03.03: Detalle del Saldo de la Cuenta 12 - Clientes","03.05: Detalle del Saldo de la Cuenta 16 - Cuentas por Cobrar Diversas","03.07: Detalle del Saldo de la Cuenta 20 y 21","03.11: Detalle del Saldo de la Cuenta 41 - Remuneraciones por Pagar","03.12: Detalle del Saldo de la Cuenta 42 - Proveedores"}
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_cn774_detalle_libro_inventarios
integer x = 1234
integer y = 68
integer width = 462
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Libro :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_procesar from commandbutton within w_cn774_detalle_libro_inventarios
integer x = 3630
integer y = 60
integer width = 571
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_msj_err, ls_cadena, ls_libro, ls_nombre_mes
Long   ll_ano ,ll_mes,	ll_count

//LIMPIAR DW
dw_report.reset()
sle_reg.text = '0'

ll_ano = long(trim(em_ano.text))
ll_mes = long(trim(LEFT(ddlb_mes.text,2)))
ls_libro = left(trim(ddlb_libro.text),5)

ls_cadena = trim(em_ano.text)+trim(LEFT(ddlb_mes.text,2))


if Isnull(ll_ano) or ll_ano = 0 then
	Messagebox('Aviso','Debe Ingresar algun Año Valido ,Verifique!')
	Return
end if

if Isnull(ll_mes) or ll_mes < 0 or ll_mes > 13 then
	Messagebox('Aviso','Debe Ingresar algun Mes Valido ,Verifique!')
	Return
end if

IF ls_libro = "03.03" then

	dw_report.dataObject = 'd_f33_detalle_cuenta_12_tbl'
	
elseIF ls_libro = "03.05" then

	dw_report.dataObject = 'd_f35_detalle_cuenta_16_tbl'

elseIF ls_libro = "03.07" then

	dw_report.dataObject = 'd_f37_detalle_cuenta_20_21_tbl'

elseIF ls_libro = "03.11" then

	dw_report.dataObject = 'd_f311_detalle_cuenta_41_tbl'

elseIF ls_libro = "03.12" then

	dw_report.dataObject = 'd_f312_detalle_cuenta_42_tbl'

ELSE
	
	Messagebox("Aviso", "Seleccione un Formato de Libro Válido, por favor verifique!",Exclamation!)
	return
	
END IF	

dw_report.settransobject(SQLCA)

//Genero el archivo de texto
cb_procesar.enabled = false

dw_report.retrieve(ll_ano, ll_mes)

cb_procesar.enabled = true

ll_count = dw_report.rowcount()
sle_reg.text = Trim(String(ll_count))

//--
CHOOSE CASE ll_mes
			
	  	CASE 0
			  ls_nombre_mes = 'MES CERO'
		CASE 1
			  ls_nombre_mes = 'ENERO'
		CASE 2
			  ls_nombre_mes = 'FEBRERO'
	   CASE 3
			  ls_nombre_mes = 'MARZO'
      CASE 4
			  ls_nombre_mes = 'ABRIL'
		CASE 5
			  ls_nombre_mes = 'MAYO'
	   CASE 6
			  ls_nombre_mes = 'JUNIO'
		CASE 7
			  ls_nombre_mes = 'JULIO'
		CASE 8
			  ls_nombre_mes = 'AGOSTO'
	   CASE 9
			  ls_nombre_mes = 'SEPTIEMBRE'
	   CASE 10
			  ls_nombre_mes = 'OCTUBRE'
		CASE 11
			  ls_nombre_mes = 'NOVIEMBRE'
	   CASE 12
			  ls_nombre_mes = 'DICIEMBRE'
	END CHOOSE
//--

dw_report.object.p_logo.filename 		= gs_logo
dw_report.object.t_user.text     		= gs_user

dw_report.object.t_periodo.text  		= string(ll_ano) + '-' + ls_nombre_mes
dw_report.object.t_ruc.text      		= gnvo_app.empresa.is_ruc
dw_report.object.t_razon_social.text 	= gnvo_app.empresa.is_nom_empresa



end event

type st_3 from statictext within w_cn774_detalle_libro_inventarios
integer x = 2487
integer y = 176
integer width = 526
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Total de Registros :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_reg from singlelineedit within w_cn774_detalle_libro_inventarios
integer x = 3040
integer y = 168
integer width = 530
integer height = 96
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 65535
borderstyle borderstyle = stylelowered!
end type

type dw_report from u_dw_cns within w_cn774_detalle_libro_inventarios
integer y = 288
integer width = 3877
integer height = 1532
integer taborder = 40
string dataobject = "d_f33_detalle_cuenta_12_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez


 ii_ck[1] = 1         // columnas de lectrua de este dw

	
end event

type st_1 from statictext within w_cn774_detalle_libro_inventarios
integer x = 37
integer y = 72
integer width = 215
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn774_detalle_libro_inventarios
integer x = 448
integer y = 72
integer width = 224
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_cn774_detalle_libro_inventarios
integer x = 270
integer y = 72
integer width = 174
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type ddlb_mes from dropdownlistbox within w_cn774_detalle_libro_inventarios
integer x = 709
integer y = 72
integer width = 517
integer height = 856
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean vscrollbar = true
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre","00.- Apertura","13.- Cierre Ejercicio"}
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_cn774_detalle_libro_inventarios
integer width = 4215
integer height = 284
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Libro"
end type

