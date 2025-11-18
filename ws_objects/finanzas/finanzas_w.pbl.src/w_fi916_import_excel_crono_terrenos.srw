$PBExportHeader$w_fi916_import_excel_crono_terrenos.srw
forward
global type w_fi916_import_excel_crono_terrenos from w_abc_master_smpl
end type
type cb_1 from commandbutton within w_fi916_import_excel_crono_terrenos
end type
type hpb_progreso from hprogressbar within w_fi916_import_excel_crono_terrenos
end type
type st_texto from statictext within w_fi916_import_excel_crono_terrenos
end type
type st_left_time from statictext within w_fi916_import_excel_crono_terrenos
end type
end forward

global type w_fi916_import_excel_crono_terrenos from w_abc_master_smpl
integer width = 3470
integer height = 2648
string title = "[FI916] Importación de cronogramas de terrenos en excel"
string menuname = "m_proceso"
event type integer ue_importar_data ( string as_file )
cb_1 cb_1
hpb_progreso hpb_progreso
st_texto st_texto
st_left_time st_left_time
end type
global w_fi916_import_excel_crono_terrenos w_fi916_import_excel_crono_terrenos

type variables
n_cst_database 	invo_database
n_cst_migracion	invo_migracion

end variables

event type integer ue_importar_data(string as_file);oleobject excel
integer	li_i
long 		ll_hasil, ll_return, ll_count, ll_max_rows, ll_max_columns , ll_fila1, ll_fila
boolean	lb_cek
DateTime	ldt_inicio, ldt_fin
Decimal	ldc_tiempo, ldc_acum_tiempo, ldc_prom_tiempo, ldc_time_left

//Datos para importar
String	ls_tipo_doc_ident, ls_ruc_dni, ls_nom_proveedor, ls_tipo_doc, ls_nro_doc, ls_observacion, &
			ls_desc_centro, ls_cod_moneda, ls_cod_art, ls_desc_art, ls_vol_und, ls_nro_letra, &
			ls_fec_vencimiento, ls_saldo_pagar, ls_interes, ls_amortizacion, ls_cuota_pagar, &
			ls_cod_lote, ls_area
Integer	li_nro_letra
Date		ld_fec_vencimiento
Decimal	ldc_saldo_pagar, ldc_interes, ldc_amortizacion, ldc_cuota_pagar


oleobject  lole_workbook, lole_worksheet

try 
	excel = create oleobject;
	
	dw_master.reset()
	 
	if not(FileExists( as_file )) then
		messagebox('Excel','Archivo ' + as_file + ' no existe, por favor verifique!', StopSign!) 
		destroy excel
		return -1
	end if 
	
	//connect to office application
	ll_return = excel.connecttonewobject("excel.application")
	if ll_return <> 0 then
		messagebox('Error','No tiene instalado o cnfigurado el MS.Excel, por favor verifique!',exclamation!)
		destroy excel
		return -1
	end if
	
	//open file excel (you can make this string as variable)
	excel.workbooks.open( as_file )
	excel.application.visible = false
	excel.windowstate = 2
	
	//cek rows in excel sheet with return value copy
	lole_workbook 	= excel.workbooks(1)
	lb_cek 			= lole_workbook.activate
	lole_worksheet = lole_workbook.worksheets(1)
	ll_max_rows   	= lole_worksheet.UsedRange.Rows.Count
	dw_master.reset( )
	
	hpb_progreso.position 	= 0
	ldc_acum_tiempo			= 0
	
	FOR ll_fila1 = 2 TO ll_max_rows
		
		yield()
		
		//Tomo la hora de inicio
		select sysdate
			into :ldt_inicio
		from dual;
		
		ls_tipo_doc_ident	= String(lole_worksheet.cells(ll_fila1,1).value)
		ls_ruc_dni			= String(lole_worksheet.cells(ll_fila1,2).value) 
		ls_nom_proveedor	= String(lole_worksheet.cells(ll_fila1,3).value) 
		ls_tipo_doc			= String(lole_worksheet.cells(ll_fila1,4).value)
		ls_nro_letra		= String(lole_worksheet.cells(ll_fila1,5).value)  
		ls_fec_vencimiento= String(lole_worksheet.cells(ll_fila1,6).value) 
		ls_observacion		= String(lole_worksheet.cells(ll_fila1,7).value) 
		ls_desc_centro		= String(lole_worksheet.cells(ll_fila1,8).value) 
		ls_cod_moneda		= String(lole_worksheet.cells(ll_fila1,9).value) 
		ls_saldo_pagar		= String(lole_worksheet.cells(ll_fila1,10).value) 
		ls_interes			= String(lole_worksheet.cells(ll_fila1,11).value) 
		ls_amortizacion	= String(lole_worksheet.cells(ll_fila1,12).value) 
		ls_cuota_pagar		= String(lole_worksheet.cells(ll_fila1,13).value) 
		ls_cod_lote			= String(lole_worksheet.cells(ll_fila1,14).value) 
		ls_area				= String(lole_worksheet.cells(ll_fila1,15).value) 

		
		ll_fila = dw_master.event ue_insert()
		
		if ll_fila > 0 then
			dw_master.object.tipo_doc_ident	[ll_fila] = ls_tipo_doc_ident
			dw_master.object.ruc_dni			[ll_fila] = ls_ruc_dni
			dw_master.object.nom_proveedor	[ll_fila] = ls_nom_proveedor
			dw_master.object.tipo_doc			[ll_fila] = ls_tipo_doc
			dw_master.object.nro_letra			[ll_fila] = ls_nro_letra
			dw_master.object.fec_vencimiento	[ll_fila] = Date(ls_fec_vencimiento)
			dw_master.object.observacion		[ll_fila] = ls_observacion
			dw_master.object.desc_centro		[ll_fila] = ls_desc_centro
			dw_master.object.cod_moneda		[ll_fila] = ls_cod_moneda
			dw_master.object.saldo_pagar		[ll_fila] = Dec(ls_saldo_pagar)
			dw_master.object.interes			[ll_fila] = Dec(ls_interes)
			dw_master.object.amortizacion		[ll_fila] = Dec(ls_amortizacion)
			dw_master.object.cuota_pagar		[ll_fila] = Dec(ls_cuota_pagar)
			dw_master.object.cod_lote			[ll_fila] = ls_cod_lote
			dw_master.object.area				[ll_fila] = Dec(ls_area)
			
			//Procesando
			if not invo_migracion.of_migra_terreno(dw_master, ll_fila) then
				return -1
			end if
		end if
		
		//Tomo la hora de fin
		select sysdate
			into :ldt_fin
		from dual;
		
		//Obtengo el promedio de tiempo
		select (:ldt_fin - :ldt_inicio) * 24 * 60 * 60
			into :ldc_tiempo
		from dual;
		
		ldc_acum_tiempo += ldc_tiempo
		ldc_prom_tiempo = ldc_acum_tiempo / (ll_fila1 - 1)
		
		//Obtengo el tiempo que queda
		ldc_time_left = (ll_max_rows - ll_fila1) * ldc_prom_tiempo
		
		hpb_progreso.position = ll_fila1 / ll_max_rows * 100
		st_texto.Text = string(ll_fila1) + "/" + string(ll_max_rows) + " filas procesadas."
		st_left_time.Text = "Proceso medio: " + string(ldc_prom_tiempo, "###0.0000") + " seg."
		
		if ldc_time_left > 0 then
			//Agrego el tiempo que queda, en dias, horas, minutos y segundos
			st_left_time.Text += " - " + gnvo_app.utilitario.of_left_time_to_string(ldc_time_left)
		end if
		
		yield()	
		

	next
	
	if dw_master.RowCount() > 0 then
		//cb_procesar.enabled = true
	else
		//cb_procesar.enabled = false
	end if
	
	f_mensaje("Archivo de Excel " + as_file + " importado correctamente. Por favor verifique y luego proceselo!", "")
	
	RETURN 1
	
catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	return -1
	
finally
	if not IsNull(excel) and IsValid(excel) then
		excel.application.quit
		excel.disconnectobject()
		destroy excel;
	end if
end try

end event

on w_fi916_import_excel_crono_terrenos.create
int iCurrent
call super::create
if this.MenuName = "m_proceso" then this.MenuID = create m_proceso
this.cb_1=create cb_1
this.hpb_progreso=create hpb_progreso
this.st_texto=create st_texto
this.st_left_time=create st_left_time
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.hpb_progreso
this.Control[iCurrent+3]=this.st_texto
this.Control[iCurrent+4]=this.st_left_time
end on

on w_fi916_import_excel_crono_terrenos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.hpb_progreso)
destroy(this.st_texto)
destroy(this.st_left_time)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

hpb_progreso.width  	= newwidth  - hpb_progreso.x - 10
st_texto.x 				= newwidth - st_texto.width - 10

end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

invo_database 	= create n_cst_database
invo_migracion	= create n_cst_migracion	


//Valido la base de datos
invo_database.of_valida_database()
end event

event closequery;//Override


end event

event close;call super::close;destroy invo_database
destroy invo_migracion
end event

type dw_master from w_abc_master_smpl`dw_master within w_fi916_import_excel_crono_terrenos
integer y = 204
integer width = 3182
integer height = 1800
string dataobject = "d_list_importar_cronograma_terrenos_tbl"
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.procesado [al_row] = '0'
end event

type cb_1 from commandbutton within w_fi916_import_excel_crono_terrenos
integer x = 37
integer y = 20
integer width = 475
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Importar de XLS"
end type

event clicked;Integer	li_value
string 	ls_docname, ls_named, ls_codigo, ls_filtro, ls_mensaje

li_value =  GetFileOpenName("Abrir ..",  ls_docname, ls_named, &
									 "XLS",  "Archivos Excel (*.XLS*),*.XLS*" )

IF parent.dynamic event ue_importar_data(ls_docname) = -1 THEN 
	RETURN -1
END IF





end event

type hpb_progreso from hprogressbar within w_fi916_import_excel_crono_terrenos
integer x = 549
integer y = 4
integer width = 2693
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type st_texto from statictext within w_fi916_import_excel_crono_terrenos
integer x = 2505
integer y = 80
integer width = 736
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type st_left_time from statictext within w_fi916_import_excel_crono_terrenos
integer x = 562
integer y = 80
integer width = 1737
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

