$PBExportHeader$w_pr917_valorizar_produccion.srw
forward
global type w_pr917_valorizar_produccion from w_abc_master_smpl
end type
type cb_importar_xls from commandbutton within w_pr917_valorizar_produccion
end type
type st_2 from statictext within w_pr917_valorizar_produccion
end type
type sle_year from singlelineedit within w_pr917_valorizar_produccion
end type
type sle_mes from singlelineedit within w_pr917_valorizar_produccion
end type
type st_4 from statictext within w_pr917_valorizar_produccion
end type
type sle_grp_cntbl from singlelineedit within w_pr917_valorizar_produccion
end type
type st_1 from statictext within w_pr917_valorizar_produccion
end type
type hpb_progreso from hprogressbar within w_pr917_valorizar_produccion
end type
type gb_1 from groupbox within w_pr917_valorizar_produccion
end type
end forward

global type w_pr917_valorizar_produccion from w_abc_master_smpl
integer width = 3054
integer height = 2164
string title = "[PR917] Valorizacion de Ingreso por produccion por Grupo Contable"
string menuname = "m_smpl"
event type integer ue_listar_data ( )
cb_importar_xls cb_importar_xls
st_2 st_2
sle_year sle_year
sle_mes sle_mes
st_4 st_4
sle_grp_cntbl sle_grp_cntbl
st_1 st_1
hpb_progreso hpb_progreso
gb_1 gb_1
end type
global w_pr917_valorizar_produccion w_pr917_valorizar_produccion

type variables
string is_ruta

end variables

event type integer ue_listar_data();oleobject  	lole_workbook, lole_worksheet
oleobject 	excel
integer		li_i
long 			ll_hasil, ll_return, ll_count, ll_max_rows, ll_fila1, ll_nro_item
boolean 		lb_cek

Long			ll_year, ll_mes, ll_year_xls, ll_mes_xls
String 		ls_origen, ls_cod_art, ls_grp_cntbl, ls_mensaje, ls_nro_ot, ls_flag_estado, &
				ls_tipo_mov
Decimal		ldc_precio_unit



try 
	//Elimino la data de la tabla
	ll_year 			= Long(sle_year.text)
	ll_mes			= Long(sle_mes.text)
	ls_grp_cntbl	= sle_grp_cntbl.text
	
	IF isnull(ll_year) or ll_year <= 0  THEN
		gnvo_app.of_mensaje_error("El Año ingresado no es correcto, por favor corrijalo para continuar!")
		sle_year.setFocus()
		return -1
	end if
	
	if isnull(ll_mes) or ll_mes <= 0 then
		gnvo_app.of_mensaje_error('El Mes ingresado no es correcto, por favor corrijalo para continuar!.')
		sle_mes.setFocus()
		return -1
	end if
	
	if isnull(ls_grp_cntbl) or trim(ls_grp_cntbl) = '' then
		gnvo_app.of_mensaje_error('El Grupo Contable ingresado no es correcto, por favor corrijalo para continuar!.')
		sle_grp_cntbl.setFocus()
		return -1
	end if
		
	
	delete COSTOS_ARTICULO_PERIODO
	where ano 			= :ll_year
	  and mes			= :ll_mes
	  and grp_cntbl	= :ls_grp_cntbl;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Error al eliminar registros en tabla COSTOS_ARTICULO_PERIODO. Mensaje: ' + ls_mensaje, StopSign!)
		return -1
	end if
	
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
	lole_worksheet = lole_workbook.worksheets(1)
	ll_max_rows   	= lole_worksheet.UsedRange.Rows.Count
	
	if ll_max_rows <= 1 then
		gnvo_app.of_mensaje_error('La hoja de excel debe tener al menos un registro, aparte de la cabera del mismo', '')
		dw_master.ii_update = 0
		return -1
	end if

	hpb_progreso.position = 0
	
	FOR ll_fila1 = 2 TO ll_max_rows
		yield ()
		
		ls_origen 			= String(lole_worksheet.cells(ll_fila1,1).value) 
		ls_tipo_mov			= String(lole_worksheet.cells(ll_fila1,2).value) 
		ls_cod_Art 			= String(lole_worksheet.cells(ll_fila1,3).value) 
		ldc_precio_unit	= Dec(lole_worksheet.cells(ll_fila1,4).value) 
		ll_year_xls			= long(lole_worksheet.cells(ll_fila1,5).value)
		ll_mes_xls			= long(lole_worksheet.cells(ll_fila1,6).value)
		ls_grp_cntbl		= String(lole_worksheet.cells(ll_fila1,7).value)
		ls_nro_ot			= String(lole_worksheet.cells(ll_fila1,8).value)
		
		IF ll_mes_xls <= 0  THEN
			gnvo_app.of_mensaje_error('El Mes ingresado no es correcto, por favor corrijalo para continuar!. Nro de fila ' + string(ll_fila1))
			dw_master.Reset()
			dw_master.ii_update = 0
			return -1
		end if
		
		if isnull(ll_year_xls) or ll_year_xls <= 0 then
			MessageBox('Error', 'El AÑO ingresado en la hoja de excel esta en blanco o es negativo, ' &
									+ 'por favor corrija!. ' &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1), StopSign!)
			dw_master.Reset()
			dw_master.ii_update = 0
			return -1
		end if
		
		if ll_year <> ll_year_xls then
			MessageBox('Error', 'El AÑO de la hoja de excel no coindice con el año a procesar, ' &
									+ 'por favor corrija!. ' &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~Año excel: ' + String(ll_year_xls) &
									+ '~r~Año a procesar: ' + String(ll_year) )
			dw_master.Reset()
			dw_master.ii_update = 0
			return -1
		end if
		
		if ll_year <> ll_year_xls then
			MessageBox('Error', 'El MES de la hoja de excel no coindice con el MES a procesar, ' &
									+ 'por favor corrija!. ' &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~nMES excel: ' + String(ll_year_xls) &
									+ '~r~nMES a procesar: ' + String(ll_year) )
			dw_master.Reset()
			dw_master.ii_update = 0
			return -1
		end if
		
		//Valido Si el Tipo de Mov existe
		If IsNull(ls_tipo_mov) or trim(ls_tipo_mov) = '' then
			ls_tipo_mov = 'I09'
		end if
		
		select count(*)
			into :ll_count
		from articulo_mov_tipo amt
		where trim(amt.tipo_mov) = trim(:ls_tipo_mov)
		  and amt.flag_estado = '1';
		  
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al CONSULTAR en tabla ARTICULO_MOV_TIPO. Mensaje: ' + ls_mensaje &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~nOrigen: ' + ls_origen &
									+ '~r~nCod. ART.: ' + ls_cod_art &
									+ '~r~nPrecio Unit: ' + string(ldc_precio_unit, '###,##0.00000000')&
									+ '~r~nAño: ' + String(ll_year) &
									+ '~r~nMes: ' + String(ll_mes) &
									+ '~r~nGrupo Cntbl: ' + ls_grp_cntbl &
									+ '~r~nTipo Mov: ' + ls_tipo_mov , StopSign!)
			return -1
		end if
		
		if ll_count = 0 then
			MessageBox('Error', 'El Tipo de Movimiento ' + ls_tipo_mov +  ' no existe o no esta activo, ' &
									+ 'por favor corrija!. ' &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~nTipo Mov: ' + String(ls_tipo_mov))
			dw_master.Reset()
			dw_master.ii_update = 0
			return -1
		end if
		
		//Valido el nro de la OT
		if not IsNull(ls_nro_ot) and trim(ls_nro_ot) <> '' then
			
			select flag_estado
				into :ls_flag_estado
			from orden_trabajo
			where nro_orden = :ls_nro_ot;
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error', 'Error al CONSULTAR en tabla ORDEN_TRABAJO. Mensaje: ' + ls_mensaje &
										+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
										+ '~r~nOrigen: ' + ls_origen &
										+ '~r~Cod. ART.: ' + ls_cod_art &
										+ '~r~Precio Unit: ' + string(ldc_precio_unit, '###,##0.00000000')&
										+ '~r~Año: ' + String(ll_year) &
										+ '~r~Mes: ' + String(ll_mes) &
										+ '~r~nGrupo Cntbl: ' + ls_grp_cntbl, StopSign!)
				return -1
			end if
			
			if SQLCA.SQLCode = 100 then
				ROLLBACK;
				MessageBox('Error', 'No existe nro de OT ' + ls_nro_ot &
										+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
										+ '~r~nOrigen: ' + ls_origen &
										+ '~r~Cod. ART.: ' + ls_cod_art &
										+ '~r~Precio Unit: ' + string(ldc_precio_unit, '###,##0.00000000')&
										+ '~r~Año: ' + String(ll_year) &
										+ '~r~Mes: ' + String(ll_mes) &
										+ '~r~nGrupo Cntbl: ' + ls_grp_cntbl, StopSign!)
				return -1
			end if
			
			if ls_flag_estado = '0' then
				ROLLBACK;
				MessageBox('Error', 'La Orden de Trabajo ' + ls_nro_ot + ' se encuentra ANULADA, por favor confirme.' &
										+ '~r~nEstado OT: ' + ls_flag_estado &
										+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
										+ '~r~nOrigen: ' + ls_origen &
										+ '~r~Cod. ART.: ' + ls_cod_art &
										+ '~r~Precio Unit: ' + string(ldc_precio_unit, '###,##0.00000000')&
										+ '~r~Año: ' + String(ll_year) &
										+ '~r~Mes: ' + String(ll_mes) &
										+ '~r~nGrupo Cntbl: ' + ls_grp_cntbl, StopSign!)
				return -1
			end if
			
		end if
		
		//Obtengo el nro de item
		select nvl(max(nro_item), 0)
			into :ll_nro_item
		from COSTOS_ARTICULO_PERIODO
		where cod_origen 	= :ls_origen
		  and ano			= :ll_year
		  and mes			= :ll_mes
		  and grp_cntbl	= :ls_grp_cntbl
		  and tipo_mov		= :ls_tipo_mov;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al CONSULTAR para obtener el nro de item en tabla COSTOS_ARTICULO_PERIODO. Mensaje: ' + ls_mensaje &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~nOrigen: ' + ls_origen &
									+ '~r~Cod. ART.: ' + ls_cod_art &
									+ '~r~Precio Unit: ' + string(ldc_precio_unit, '###,##0.00000000')&
									+ '~r~Año: ' + String(ll_year) &
									+ '~r~Mes: ' + String(ll_mes) &
									+ '~r~nGrupo Cntbl: ' + ls_grp_cntbl &
									+ '~r~nTipo Mov: ' + ls_tipo_mov, StopSign!)
			return -1
		end if
		
		ll_nro_item ++
		
		insert into COSTOS_ARTICULO_PERIODO(
			COD_ART, PRECIO_UNIT, ANO, MES, GRP_CNTBL, COD_ORIGEN, 
			nro_item, nro_orden, tipo_mov) 
		values(
			:ls_cod_art, :ldc_precio_unit, :ll_year, :ll_mes, :ls_grp_cntbl, :ls_origen, 
			:ll_nro_item, :ls_nro_ot, :ls_tipo_mov);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al INSERTAR registros en tabla COSTOS_ARTICULO_PERIODO. Mensaje: ' + ls_mensaje &
									+ '~r~nNro Fila Excel: ' + string(ll_fila1) &
									+ '~r~nOrigen: ' + ls_origen &
									+ '~r~Cod. ART.: ' + ls_cod_art &
									+ '~r~Precio Unit: ' + string(ldc_precio_unit, '###,##0.00000000')&
									+ '~r~Año: ' + String(ll_year) &
									+ '~r~Mes: ' + String(ll_mes) &
									+ '~r~nGrupo Cntbl: ' + ls_grp_cntbl &
									+ '~r~nOrden Trabajo: ' + ls_nro_ot &
									+ '~r~nTipo Mov: ' + ls_tipo_mov, StopSign!)
			return -1
		end if
		
		hpb_progreso.position = ll_fila1 / ll_max_rows * 100
		yield ()
		
	next
	
	commit;
	
	hpb_progreso.position = 100
	
	//Ahora corro el procedimiento
	//create or replace procedure usp_prod_costos_periodo(
	//	 ani_year             in number,
	//	 ani_mes              in number,
	//	 asi_grp_cntbl        in costos_articulo_periodo.grp_cntbl%TYPE
	//) is

	DECLARE usp_prod_costos_periodo PROCEDURE FOR 
		usp_prod_costos_periodo( 	:ll_year, 
											:ll_mes, 
											:ls_grp_cntbl ) ;
	EXECUTE usp_prod_costos_periodo ;

	if SQLCA.SQLCode = -1 then
	  ls_mensaje = sqlca.sqlerrtext
	  rollback ;
	  MessageBox("Error", "Error al ejecutar procedimiento usp_prod_costos_periodo. Mensaje: " + ls_mensaje, StopSign!)
	  return -1
	end if
	
	CLOSE usp_prod_costos_periodo ;
	
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
	if not IsNull(excel) and IsValid(excel) then
		excel.application.quit
		excel.disconnectobject()
	end if
	destroy excel

end try


end event

on w_pr917_valorizar_produccion.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.cb_importar_xls=create cb_importar_xls
this.st_2=create st_2
this.sle_year=create sle_year
this.sle_mes=create sle_mes
this.st_4=create st_4
this.sle_grp_cntbl=create sle_grp_cntbl
this.st_1=create st_1
this.hpb_progreso=create hpb_progreso
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_importar_xls
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_year
this.Control[iCurrent+4]=this.sle_mes
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.sle_grp_cntbl
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.hpb_progreso
this.Control[iCurrent+9]=this.gb_1
end on

on w_pr917_valorizar_produccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_importar_xls)
destroy(this.st_2)
destroy(this.sle_year)
destroy(this.sle_mes)
destroy(this.st_4)
destroy(this.sle_grp_cntbl)
destroy(this.st_1)
destroy(this.hpb_progreso)
destroy(this.gb_1)
end on

event ue_update;call super::ue_update;dw_master.of_set_flag_replicacion( )
this.event ue_dw_share()
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;String ls_ano, ls_mes
ls_ano = string( Date(gnvo_app.of_fecha_actual()), 'yyyy' )
ls_mes = string( Date(gnvo_app.of_fecha_actual()), 'mm' )
					
sle_year.text 		= ls_ano
sle_mes.text 		= ls_mes


ii_lec_mst = 0
end event

event ue_refresh;call super::ue_refresh;oleobject  	lole_workbook, lole_worksheet
oleobject 	excel
integer		li_i
long 			ll_hasil, ll_return, ll_count, ll_max_rows, ll_fila1, ll_fila
boolean 		lb_cek

Long			ll_year, ll_mes
String 		ls_origen, ls_cod_art, ls_grp_cntbl, ls_mensaje
Decimal		ldc_precio_unit



try 
	//Elimino la data de la tabla
	ll_year 			= Long(sle_year.text)
	ll_mes			= Long(sle_mes.text)
	ls_grp_cntbl	= sle_grp_cntbl.text
	
	dw_master.Retrieve(ll_year, ll_mes, ls_grp_cntbl)
	
	RETURN
	
catch ( Exception ex )
	
	ROLLBACK;
	
	gnvo_app.of_mensaje_error("Ha ocurrido una exception: " + ex.getMessage())
	dw_master.ii_update = 0
	return 

finally
	if not IsNull(excel) and IsValid(excel) then
		excel.application.quit
		excel.disconnectobject()
	end if
	destroy excel

end try


end event

type dw_master from w_abc_master_smpl`dw_master within w_pr917_valorizar_produccion
event ue_display ( string as_columna,  long al_row )
integer y = 368
integer width = 2958
integer height = 1448
string dataobject = "d_abc_valorizar_produccion_tbl"
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

type cb_importar_xls from commandbutton within w_pr917_valorizar_produccion
integer x = 663
integer y = 52
integer width = 485
integer height = 184
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

type st_2 from statictext within w_pr917_valorizar_produccion
integer x = 55
integer y = 56
integer width = 366
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_pr917_valorizar_produccion
integer x = 439
integer y = 56
integer width = 187
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_pr917_valorizar_produccion
integer x = 439
integer y = 148
integer width = 187
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_pr917_valorizar_produccion
integer x = 55
integer y = 244
integer width = 366
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Grp Cntbl :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_grp_cntbl from singlelineedit within w_pr917_valorizar_produccion
event dobleclick pbm_lbuttondblclk
integer x = 439
integer y = 240
integer width = 187
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "Select grp_cntbl as grp_cntbl, " &
		 + "desc_grp_cntbl as desc_grupo_contable " &
		 + "from grupo_contable" 

if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data,'1')  then
	this.text   = ls_codigo
end if



end event

type st_1 from statictext within w_pr917_valorizar_produccion
integer x = 55
integer y = 152
integer width = 366
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type hpb_progreso from hprogressbar within w_pr917_valorizar_produccion
integer x = 667
integer y = 244
integer width = 1381
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 10
end type

type gb_1 from groupbox within w_pr917_valorizar_produccion
integer width = 2071
integer height = 356
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

