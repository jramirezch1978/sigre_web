$PBExportHeader$w_fi334_lista_detraccion.srw
forward
global type w_fi334_lista_detraccion from w_abc
end type
type hpb_progreso from hprogressbar within w_fi334_lista_detraccion
end type
type cb_xls from commandbutton within w_fi334_lista_detraccion
end type
type uo_1 from u_ingreso_rango_fechas within w_fi334_lista_detraccion
end type
type cb_2 from commandbutton within w_fi334_lista_detraccion
end type
type cb_1 from commandbutton within w_fi334_lista_detraccion
end type
type rb_2 from radiobutton within w_fi334_lista_detraccion
end type
type rb_1 from radiobutton within w_fi334_lista_detraccion
end type
type dw_master from u_dw_abc within w_fi334_lista_detraccion
end type
type gb_1 from groupbox within w_fi334_lista_detraccion
end type
end forward

global type w_fi334_lista_detraccion from w_abc
integer width = 3488
integer height = 1708
string title = "Detraccion (FI334)"
string menuname = "m_consulta_print"
event ue_saves ( )
event ue_saveas ( )
event type integer ue_importar_xls ( string as_ruta )
hpb_progreso hpb_progreso
cb_xls cb_xls
uo_1 uo_1
cb_2 cb_2
cb_1 cb_1
rb_2 rb_2
rb_1 rb_1
dw_master dw_master
gb_1 gb_1
end type
global w_fi334_lista_detraccion w_fi334_lista_detraccion

type variables

end variables

event ue_saves();
dw_master.saveas()
end event

event ue_saveas();
dw_master.saveas()
end event

event type integer ue_importar_xls(string as_ruta);oleobject  	lole_workbook, lole_worksheet
oleobject 	excel
integer		li_i
long 			ll_hasil, ll_return, ll_count, ll_max_rows, ll_fila1, ll_nro_item
boolean 		lb_cek

String		ls_ruc, ls_serie, ls_numero, ls_fecha_pago, ls_nro_constancia, ls_mensaje
Date			ld_fecha_pago


try 
	excel = create oleobject
	
	if not(FileExists( as_ruta )) then
		gnvo_app.of_mensaje_error('Ruta del archivo ' + as_ruta + ' no existe, por favor verifique!', '') 
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
	excel.workbooks.open( as_ruta )
	excel.application.visible = false
	excel.windowstate = 2
	
	//cek rows in excel sheet with return value copy
	lole_workbook 	= excel.workbooks(1)
	lb_cek 			= lole_workbook.activate
	lole_worksheet = lole_workbook.worksheets(1)
	ll_max_rows   	= lole_worksheet.UsedRange.Rows.Count
	
	if ll_max_rows <= 1 then
		gnvo_app.of_mensaje_error('La hoja de excel debe tener al menos un registro, aparte de la cabera del mismo', '')
		dw_master.ii_update = 0
		return -1
	end if

	hpb_progreso.position = 0
	hpb_progreso.visible = true
	
	FOR ll_fila1 = 2 TO ll_max_rows
		yield ()
		
		ls_ruc 				= String(lole_worksheet.cells(ll_fila1,1).value) 
		ls_serie 			= String(lole_worksheet.cells(ll_fila1,2).value) 
		ls_numero 			= String(lole_worksheet.cells(ll_fila1,3).value) 
		ls_fecha_pago		= String(lole_worksheet.cells(ll_fila1,4).value) 
		ls_nro_constancia = String(lole_worksheet.cells(ll_fila1,5).value) 
		
		IF IsNull(ls_ruc) or trim(ls_ruc) = ''  THEN
			MessageBox('Error', 'No ha ingresado el RUC, por favor corrijalo para continuar!. Nro de fila ' + string(ll_fila1))
			return -1
		end if
		
		IF IsNull(ls_serie) or trim(ls_serie) = ''  THEN
			MessageBox('Error', 'No ha ingresado la SERIE, por favor corrijalo para continuar!. Nro de fila ' + string(ll_fila1))
			return -1
		end if
		
		IF len(trim(ls_serie)) <> 4  THEN
			MessageBox('Error', 'La SERIE debe ser de 4 caracteres, por favor corrijalo para continuar!. Nro de fila ' + string(ll_fila1))
			return -1
		end if
		
		IF IsNull(ls_numero) or trim(ls_numero) = ''  THEN
			MessageBox('Error', 'No ha ingresado el NUMERO, por favor corrijalo para continuar!. Nro de fila ' + string(ll_fila1))
			return -1
		end if
		
		IF IsNull(ls_fecha_pago) or trim(ls_fecha_pago) = ''  THEN
			MessageBox('Error', 'No ha ingresado la FECHA DE PAGO, por favor corrijalo para continuar!. Nro de fila ' + string(ll_fila1))
			return -1
		end if
		
		IF IsNull(ls_nro_constancia) or trim(ls_nro_constancia) = ''  THEN
			MessageBox('Error', 'No ha ingresado el NUMERO DE CONSTANCIA, por favor corrijalo para continuar!. Nro de fila ' + string(ll_fila1))
			return -1
		end if
		
		//Obtengo la fecha de pago
		ld_fecha_pago = Date(ls_fecha_pago)
		
		//Obtengo el nro de item
		update detraccion d
   	   set d.fecha_deposito = :ld_fecha_pago,
       	 	 d.nro_deposito 	= :ls_nro_constancia
  	 	 where d.nro_detraccion = (select cp.nro_detraccion
											  from cntas_pagar cp,
													 proveedor   p
											 where cp.cod_relacion = p.proveedor
												and cp.serie_cp     = :ls_serie
												and pkg_utility.of_trim(cp.numero_cp, '0') = :ls_numero
												and decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) = :ls_ruc);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al ACTUALIZAR los datos de detraccion en tabla DETRACCION. Mensaje: ' + ls_mensaje &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~nRUC: ' + ls_ruc &
									+ '~r~nSERIE: ' + ls_serie &
									+ '~r~nNUMERO: ' + ls_numero &
									+ '~r~nFecha Pago: ' + ls_fecha_pago &
									+ '~r~nNro Constancia: ' + ls_nro_constancia, StopSign!)
			return -1
		end if
		
		ll_nro_item ++
		
		
		hpb_progreso.position = ll_fila1 / ll_max_rows * 100
		yield ()
		
	next
	
	commit;
	
	hpb_progreso.position = 100
	
	//ACtualizo el DAtaWindows
	this.event ue_refresh( )
	
	f_mensaje("Proceso completado satisfactoriamente. Debe ejecutar el descuadre de valorizacion", "")
	
	RETURN 1
	
catch ( Exception ex )
	
	ROLLBACK;
	
	gnvo_app.of_mensaje_error("Ha ocurrido una exception: " + ex.getMessage())
	
	return -1

finally
	if not IsNull(excel) and IsValid(excel) then
		excel.application.quit
		excel.disconnectobject()
	end if
	destroy excel
	
	hpb_progreso.visible = false

end try


end event

on w_fi334_lista_detraccion.create
int iCurrent
call super::create
if this.MenuName = "m_consulta_print" then this.MenuID = create m_consulta_print
this.hpb_progreso=create hpb_progreso
this.cb_xls=create cb_xls
this.uo_1=create uo_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_progreso
this.Control[iCurrent+2]=this.cb_xls
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.rb_1
this.Control[iCurrent+8]=this.dw_master
this.Control[iCurrent+9]=this.gb_1
end on

on w_fi334_lista_detraccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.hpb_progreso)
destroy(this.cb_xls)
destroy(this.uo_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
      Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
END IF

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente

of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0

	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

event ue_print;call super::ue_print;


OpenWithParm(w_print_opt, dw_master)
If Message.DoubleParm = -1 Then Return
dw_master.Print(True)
end event

event ue_refresh;call super::ue_refresh;date ld_fecha_inicio,ld_fecha_final


//verificación de fechas
ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()



if rb_1.checked THEN
	//cuentas x cobrar
	dw_master.dataobject = 'd_abc_lista_detraccion_cobrar_tbl'
	dw_master.SetTransobject(sqlca)
elseif rb_2.checked THEN
	//cuentas x pagar
	dw_master.dataobject = 'd_abc_lista_detraccion_pagar_tbl'
	dw_master.SetTransobject(sqlca)
end if

dw_master.Retrieve(ld_fecha_inicio, ld_fecha_final)
end event

type hpb_progreso from hprogressbar within w_fi334_lista_detraccion
boolean visible = false
integer x = 2080
integer y = 108
integer width = 1070
integer height = 56
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 10
end type

type cb_xls from commandbutton within w_fi334_lista_detraccion
integer x = 2432
integer y = 4
integer width = 361
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Importar XLS"
end type

event clicked;Long		li_value
String	ls_docname, ls_named


li_value =  GetFileOpenName("Abrir ..",  ls_docname, ls_named, "XLS",  &
   				"Archivos Excel (*.XLS),*.XLS" )

IF li_value <> 1 THEN  
	return
END IF

IF parent.event ue_importar_xls(ls_docname) = -1 THEN 
	RETURN 
END IF


end event

type uo_1 from u_ingreso_rango_fechas within w_fi334_lista_detraccion
integer x = 731
integer y = 68
integer taborder = 20
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date	ld_fecha_actual

ld_fecha_actual = Date(gnvo_app.of_fecha_actual(true))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha_actual, gnvo_app.of_last_date(ld_fecha_actual)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

type cb_2 from commandbutton within w_fi334_lista_detraccion
integer x = 2802
integer y = 4
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Grabar"
end type

event clicked;Parent.triggerevent( 'ue_update')
end event

type cb_1 from commandbutton within w_fi334_lista_detraccion
integer x = 2080
integer y = 4
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Refrescar"
end type

event clicked;//ACtualizo el DAtaWindows
setPointer(HourGlass!)
event ue_refresh( )
setPointer(Arrow!)
end event

type rb_2 from radiobutton within w_fi334_lista_detraccion
integer x = 46
integer y = 16
integer width = 549
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cuentas por Pagar"
boolean checked = true
end type

type rb_1 from radiobutton within w_fi334_lista_detraccion
integer x = 46
integer y = 92
integer width = 549
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cuentas por Cobrar"
end type

type dw_master from u_dw_abc within w_fi334_lista_detraccion
event ue_saveas ( )
integer y = 184
integer width = 3360
integer height = 1120
string dataobject = "d_abc_lista_detraccion_pagar_tbl"
end type

event ue_saveas();THIS.saveas()
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst = dw_master

end event

event itemchanged;call super::itemchanged;Long		ll_data, ll_row

try 
	this.Accepttext()
	
	CHOOSE CASE dwo.name
		CASE 'nro_deposito'
			
			if IsNumber(data) and row < this.RowCount() then
				if gnvo_app.of_get_parametro("FIN_REEMPLAZO_MASIVO_NRO_DEPOSITO_DETR", "1") = "1" THEN
					if MessageBox('Pregunta', 'Desea aplicar el numero secuencial para los registros restantes?', &
									Information!, YesNo!, 2) = 2 then
						return 1
					end if
					
					ll_data = Long(data) + 1 
				
					for ll_row = row + 1 to this.RowCount()
						this.object.nro_deposito	[ll_row] = String(ll_data)
						ll_data ++
					next
	
				end if
				
			end if
			
	
		CASE 'fecha_deposito'
			
			if row < this.RowCount() then
				if gnvo_app.of_get_parametro("FIN_REEMPLAZO_MASIVO_NRO_DEPOSITO_DETR", "1") = "1" THEN
					if MessageBox('Pregunta', 'Desea aplicar la fecha de deposito para los registros restantes?', &
									Information!, YesNo!, 2) = 2 then
						return 1
					end if
					
					for ll_row = row + 1 to this.RowCount()
						this.object.fecha_deposito	[ll_row] = Date(data)
		
					next					
				END IF
				
			end if
	
	END CHOOSE

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'ha ocurrido una exception')
	
end try


end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

type gb_1 from groupbox within w_fi334_lista_detraccion
integer x = 695
integer y = 12
integer width = 1353
integer height = 160
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Fechas"
end type

