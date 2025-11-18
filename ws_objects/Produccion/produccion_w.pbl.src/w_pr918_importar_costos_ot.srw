$PBExportHeader$w_pr918_importar_costos_ot.srw
forward
global type w_pr918_importar_costos_ot from w_abc_master_smpl
end type
type cb_importar_xls from commandbutton within w_pr918_importar_costos_ot
end type
type st_2 from statictext within w_pr918_importar_costos_ot
end type
type sle_periodo from singlelineedit within w_pr918_importar_costos_ot
end type
type cb_1 from commandbutton within w_pr918_importar_costos_ot
end type
type hpb_progreso from hprogressbar within w_pr918_importar_costos_ot
end type
type gb_1 from groupbox within w_pr918_importar_costos_ot
end type
end forward

global type w_pr918_importar_costos_ot from w_abc_master_smpl
integer width = 3054
integer height = 2164
string title = "[PR918] Valorizacion por Orden de Trabajo"
string menuname = "m_smpl"
event type integer ue_listar_data ( )
cb_importar_xls cb_importar_xls
st_2 st_2
sle_periodo sle_periodo
cb_1 cb_1
hpb_progreso hpb_progreso
gb_1 gb_1
end type
global w_pr918_importar_costos_ot w_pr918_importar_costos_ot

type variables
string is_ruta

end variables

event type integer ue_listar_data();oleobject  	lole_workbook, lole_worksheet
oleobject 	excel
integer		li_i
long 			ll_hasil, ll_return, ll_count, ll_max_rows, ll_fila1, ll_nro_am
boolean 		lb_cek

String 		ls_mensaje, ls_nro_ot, ls_periodo, ls_periodo_xls, ls_flag_estado, ls_org_am
Decimal		ldc_precio_unit, ldc_precio_unit_new
u_ds_base	lds_precios
n_cst_wait	lnvo_Wait



try 
	lnvo_wait = create n_cst_wait
	
	lnvo_wait.of_mensaje("Se empieza a procesar")
	
	lds_precios = create u_ds_base
	lds_precios.dataObject = 'd_list_precios_am_tbl'
	lds_precios.setTransObject(SQLCA)
	
	//Elimino la data de la tabla
	ls_periodo 		= sle_periodo.text
	
	IF isnull(ls_periodo) or trim(ls_periodo) = "" or len(trim(ls_periodo)) <> 6  THEN
		gnvo_app.of_mensaje_error("El Periodo ingresado esta en blanco o no es correcto, por favor corrijalo para continuar!")
		sle_periodo.setFocus()
		return -1
	end if
	
	delete prod_costo_ot
	where periodo 		= :ls_periodo;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Error al eliminar registros en tabla PROD_COSTO_OT. Mensaje: ' + ls_mensaje, StopSign!)
		return -1
	end if
	
	commit;
	
	excel = create oleobject
	
	dw_master.reset()
	 
	if not(FileExists( is_ruta )) then
		gnvo_app.of_mensaje_error('Ruta del archivo ' + is_ruta + ' no existe, por favor verifique!', '') 
		return -1
	end if 
	
	//connect to office application
	ll_return = excel.connecttonewobject("excel.application")
	if ll_return <> 0 then
		gnvo_app.of_mensaje_error('No se puede crear objeto de excel MS.Excel!', '')
		dw_master.ii_update = 0
		return -1
	end if
	
	//open file excel (you can make this string as variable)
	excel.workbooks.open( is_ruta )
	excel.application.visible = false
	excel.windowstate = 2
	
	//cek rows in excel sheet with return value copy
	lole_workbook 	= excel.workbooks(1)
	lb_cek 			= lole_workbook.activate
	lole_worksheet = lole_workbook.worksheets("Hoja1")
	ll_max_rows   	= lole_worksheet.UsedRange.Rows.Count
	
	if ll_max_rows <= 1 then
		gnvo_app.of_mensaje_error('La hoja de excel debe tener al menos un registro, aparte de la cabera del mismo', '')
		dw_master.ii_update = 0
		return -1
	end if

	hpb_progreso.position = 0
	
	FOR ll_fila1 = 4 TO ll_max_rows
		yield ()
		lnvo_wait.of_mensaje("Procesando fila " +  string(ll_fila1) + ", por favor espere")
		
		ls_periodo_xls		= String(lole_worksheet.cells(ll_fila1,2).value) 
		ls_nro_ot			= String(lole_worksheet.cells(ll_fila1,3).value)
		ldc_precio_unit	= Dec(lole_worksheet.cells(ll_fila1,4).value) 
		
		if isnull(ls_periodo_xls) or trim(ls_periodo_xls) = '' or len(trim(ls_periodo_xls)) <> 6 then
			rollback;
			MessageBox('Error', 'El PERIODO ingreso ingresado en la hoja de excel esta en blanco o no es correcto, ' &
									+ 'por favor corrija!. ' &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~nPERIODO a procesar: ' + ls_periodo,  StopSign! )
			dw_master.Reset()
			dw_master.ii_update = 0
			return -1
		end if
		
		if ls_periodo <> ls_periodo_xls then
			rollback;
			MessageBox('Error', 'El PERIODO de la hoja de excel no coindice con el PERIODO a procesar, ' &
									+ 'por favor corrija!. ' &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~nPERIODO excel: ' + ls_periodo_xls &
									+ '~r~nPERIODO a procesar: ' + ls_periodo,  StopSign! )
			dw_master.Reset()
			dw_master.ii_update = 0
			return -1
		end if
		
		//Valido el nro de la OT
		if IsNull(ls_nro_ot) or trim(ls_nro_ot) = '' then
			rollback;
			MessageBox('Error', 'La Orden de Trabajo de la hoja de excel esta vacio o en blanco, ' &
									+ 'por favor corrija!. ' &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) )
			dw_master.Reset()
			dw_master.ii_update = 0
			return -1
		end if
			
		select flag_estado
			into :ls_flag_estado
		from orden_trabajo
		where nro_orden = :ls_nro_ot;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al CONSULTAR en tabla ORDEN_TRABAJO. Mensaje: ' + ls_mensaje &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~nPeriodo: ' + ls_periodo_xls &
									+ '~r~nOrden Trabajo: ' + ls_nro_ot &
									+ '~r~Precio Unit: ' + string(ldc_precio_unit, '###,##0.00000000'), StopSign!)
			return -1
		end if
		
		if SQLCA.SQLCode = 100 then
			ROLLBACK;
			MessageBox('Error', 'No existe nro de OT ' + ls_nro_ot &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~nPeriodo: ' + ls_periodo_xls &
									+ '~r~nOrden Trabajo: ' + ls_nro_ot &
									+ '~r~Precio Unit: ' + string(ldc_precio_unit, '###,##0.00000000'), StopSign!)
			return -1
		end if
		
		if ls_flag_estado = '0' then
			ROLLBACK;
			MessageBox('Error', 'La Orden de Trabajo ' + ls_nro_ot + ' se encuentra ANULADA, por favor confirme.' &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~nPeriodo: ' + ls_periodo_xls &
									+ '~r~nOrden Trabajo: ' + ls_nro_ot &
									+ '~r~Precio Unit: ' + string(ldc_precio_unit, '###,##0.00000000'), StopSign!)
			return -1
		end if
			
	
		//Obtengo el nro de item
		select count(*)
			into :ll_count
		from prod_costo_ot
		where periodo		= :ls_periodo
		  and nro_orden	= :ls_nro_ot;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al CONSULTAR para obtener el nro de item en tabla PROD_COSTO_OT. Mensaje: ' + ls_mensaje &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~nPeriodo: ' + ls_periodo_xls &
									+ '~r~nOrden Trabajo: ' + ls_nro_ot &
									+ '~r~Precio Unit: ' + string(ldc_precio_unit, '###,##0.00000000'), StopSign!)
			return -1
		end if
		
		if ll_count > 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error, no se puede insertar dos veces la misma Orden de Trabajo. Mensaje: ' + ls_mensaje &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~nPeriodo: ' + ls_periodo_xls &
									+ '~r~nOrden Trabajo: ' + ls_nro_ot &
									+ '~r~Precio Unit: ' + string(ldc_precio_unit, '###,##0.00000000'), StopSign!)
			return -1
		end if
		
		
		insert into PROD_COSTO_OT(
			PERIODO, NRO_ORDEN, COSTO_ESTIMADO)
		values(
			:ls_periodo, :ls_nro_ot, :ldc_precio_unit);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al INSERTAR registros en tabla PROD_COSTO_OT. Mensaje: ' + ls_mensaje &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~nPeriodo: ' + ls_periodo_xls &
									+ '~r~nOrden Trabajo: ' + ls_nro_ot &
									+ '~r~Precio Unit: ' + string(ldc_precio_unit, '###,##0.00000000'), StopSign!)
			return -1
		end if
		
		commit;
		
		hpb_progreso.position = ll_fila1 / ll_max_rows * 100
		yield ()
		
	next
	
	commit;
	
	hpb_progreso.position = 0
	
	lds_precios.Retrieve(ls_periodo)
	
	lnvo_wait.of_mensaje("Actualizando precios del Ingreso por produccion")
	
	if lds_precios.RowCount() > 0 then
		FOR ll_fila1 = 1 TO lds_precios.RowCount()
			ls_org_am 				= lds_precios.object.org_am 					[ll_fila1]
			ll_nro_am 				= lds_precios.object.nro_am 					[ll_fila1]
			ldc_precio_unit 		= Dec(lds_precios.object.precio_unit 		[ll_fila1])
			ldc_precio_unit_new 	= Dec(lds_precios.object.precio_unit_new 	[ll_fila1])
			
			update articulo_mov am
			   set am.precio_unit = :ldc_precio_unit_new
			 where am.cod_origen		= :ls_org_am
			   and am.nro_mov			= :ll_nro_am;
				
				
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error', 'Error al ACTUALIZAR registros en tabla ARTICULO_MOV. Mensaje: ' + ls_mensaje &
										+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
										+ '~r~nPeriodo: ' + ls_periodo_xls &
										+ '~r~nOrden Trabajo: ' + ls_nro_ot &
										+ '~r~Precio Unit: ' + string(ldc_precio_unit, '###,##0.00000000'), StopSign!)
				return -1
			end if
			
			commit;
		
			hpb_progreso.position = ll_fila1 / ll_max_rows * 100
			yield ()
		next
	end if
	
	
	hpb_progreso.position = 100
	
	commit;
	
	//ACtualizo el DAtaWindows
	this.event ue_refresh( )
	
	f_mensaje("Proceso completado satisfactoriamente. Debe ejecutar el descuadre de valorizacion", "")
	
	RETURN 1
	
catch ( Exception ex )
	
	ROLLBACK;
	
	gnvo_app.of_mensaje_error("Ha ocurrido una exception: " + ex.getMessage())
	dw_master.ii_update = 0
	return -1

finally
	lnvo_Wait.of_close()
	destroy lnvo_Wait
	
	if not IsNull(excel) and IsValid(excel) then
		excel.application.quit
		excel.disconnectobject()
	end if
	destroy excel

end try



end event

on w_pr918_importar_costos_ot.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.cb_importar_xls=create cb_importar_xls
this.st_2=create st_2
this.sle_periodo=create sle_periodo
this.cb_1=create cb_1
this.hpb_progreso=create hpb_progreso
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_importar_xls
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_periodo
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.hpb_progreso
this.Control[iCurrent+6]=this.gb_1
end on

on w_pr918_importar_costos_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_importar_xls)
destroy(this.st_2)
destroy(this.sle_periodo)
destroy(this.cb_1)
destroy(this.hpb_progreso)
destroy(this.gb_1)
end on

event ue_update;call super::ue_update;dw_master.of_set_flag_replicacion( )
this.event ue_dw_share()
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;String ls_periodo
ls_periodo = string( Date(gnvo_app.of_fecha_actual()), 'yyyymm' )
					
sle_periodo.text 		= ls_periodo


ii_lec_mst = 0
end event

event ue_refresh;call super::ue_refresh;string ls_periodo



try 
	//Elimino la data de la tabla
	ls_periodo 		= sle_periodo.text
	
	dw_master.Retrieve(ls_periodo)
	
	RETURN
	
catch ( Exception ex )
	
	ROLLBACK;
	
	gnvo_app.of_mensaje_error("Ha ocurrido una exception: " + ex.getMessage())
	dw_master.ii_update = 0
	return 

finally


end try


end event

type dw_master from w_abc_master_smpl`dw_master within w_pr918_importar_costos_ot
event ue_display ( string as_columna,  long al_row )
integer y = 224
integer width = 2958
integer height = 1448
string dataobject = "d_abc_prod_costos_ot_tbl"
end type

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_col, ls_sql, ls_return1, ls_return2

If this.ii_protect = 1 or row <= 0 then return

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'und'
		select und, desc_unidad
			into :ls_return1, :ls_return2
			from unidad
			where und = :data;
			
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, "No se encuentra la unidad")
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.und[row] = ls_return1
		this.object.desc_unidad[row] = ls_return2
		
		return 2
		
	case 'grp_medicion'
		select grp_medicion, descripcion 
			into :ls_return1, :ls_return2
			from tg_med_act_atributo_grp
			where grp_medicion = :data;
		
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, "No se encuentra la unidad")
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.grp_medicion[row] = ls_return1
		this.object.grp_descripcion[row] = ls_return2
		
		return 2
		
end choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_ck[4] = 4				// columnas de lectrua de este dw
ii_ck[5] = 5				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

type cb_importar_xls from commandbutton within w_pr918_importar_costos_ot
integer x = 1349
integer y = 48
integer width = 485
integer height = 116
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

event clicked;Long		li_value
String	ls_docname, ls_named


li_value =  GetFileOpenName("Abrir ..",  ls_docname, ls_named, "XLS",  &
   				"Archivos Excel (*.XLS),*.XLS" )

IF li_value = 1 THEN  
   is_ruta = ls_docname
else
	return
END IF

IF parent.event ue_listar_data() = -1 THEN 
	RETURN 
END IF


end event

type st_2 from statictext within w_pr918_importar_costos_ot
integer x = 55
integer y = 56
integer width = 425
integer height = 88
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Periodo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_periodo from singlelineedit within w_pr918_importar_costos_ot
integer x = 485
integer y = 56
integer width = 334
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_pr918_importar_costos_ot
integer x = 841
integer y = 48
integer width = 485
integer height = 116
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;parent.event ue_refresh()


end event

type hpb_progreso from hprogressbar within w_pr918_importar_costos_ot
integer x = 1861
integer y = 72
integer width = 1038
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
end type

type gb_1 from groupbox within w_pr918_importar_costos_ot
integer width = 2962
integer height = 212
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
borderstyle borderstyle = styleraised!
end type

