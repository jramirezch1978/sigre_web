$PBExportHeader$w_pr916_imp_asistencia.srw
forward
global type w_pr916_imp_asistencia from w_abc_master_smpl
end type
type cb_1 from commandbutton within w_pr916_imp_asistencia
end type
type cb_procesar from commandbutton within w_pr916_imp_asistencia
end type
type hpb_progreso from hprogressbar within w_pr916_imp_asistencia
end type
type st_texto from statictext within w_pr916_imp_asistencia
end type
end forward

global type w_pr916_imp_asistencia from w_abc_master_smpl
integer width = 3054
integer height = 1880
string title = "[PR916] Importar asistencia Jornal de Campo"
string menuname = "m_smpl"
event type integer ue_listar_data ( string as_file )
cb_1 cb_1
cb_procesar cb_procesar
hpb_progreso hpb_progreso
st_texto st_texto
end type
global w_pr916_imp_asistencia w_pr916_imp_asistencia

type variables
u_ds_base ids_valorizar
integer ii_year
end variables

event type integer ue_listar_data(string as_file);oleobject excel
integer	li_i
long 		ll_hasil, ll_return, ll_count, ll_max_rows, ll_max_columns , ll_fila1, ll_fila2, &
			ll_fila, ll_year, ll_mes
double 	dbl_precio
boolean 	lb_cek
String 	ls_cellValue , ls_nomcol, ls_codigo

String	ls_cod_trabajador, ls_dni, ls_nom_trabajador, ls_fecha, ls_hora_ent, ls_hora_sal, ls_dpto, ls_labor, ls_ot_adm

oleobject  lole_workbook, lole_worksheet

try 
	excel = create oleobject;
	
	dw_master.reset()
	 
	if not(FileExists( as_file )) then
		messagebox('Excel','Ruta del archivo no existe') 
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
	lole_workbook = excel.workbooks(1)
	lb_cek = lole_workbook.activate
	lole_worksheet = lole_workbook.worksheets(1)
	ll_max_rows   = lole_worksheet.UsedRange.Rows.Count
	dw_master.reset( )
	
	hpb_progreso.position = 0
	
	FOR ll_fila1 = 2 TO ll_max_rows
		
		yield()
		
		ls_cod_trabajador	= String(lole_worksheet.cells(ll_fila1,1).value)
		ls_dni				= String(lole_worksheet.cells(ll_fila1,2).value) 
		ls_nom_trabajador	= String(lole_worksheet.cells(ll_fila1,3).value) 
		ls_fecha				= String(lole_worksheet.cells(ll_fila1,4).value)
		ls_hora_ent			= String(lole_worksheet.cells(ll_fila1,5).value)  
		ls_hora_sal			= String(lole_worksheet.cells(ll_fila1,6).value) 
		ls_dpto				= String(lole_worksheet.cells(ll_fila1,7).value) 
		ls_labor				= String(lole_worksheet.cells(ll_fila1,8).value) 
		ls_ot_adm			= String(lole_worksheet.cells(ll_fila1,9).value) 
		
		ll_fila = dw_master.event ue_insert()
		
		if ll_fila > 0 then
			dw_master.object.fecha				[ll_fila] = Date(ls_fecha)
			dw_master.object.cod_trabajador	[ll_fila] = ls_cod_trabajador
			dw_master.object.dni					[ll_fila] = ls_dni
			dw_master.object.nom_trabajador	[ll_fila] = ls_nom_trabajador
			dw_master.object.hora_ing			[ll_fila] = ls_hora_ent
			dw_master.object.hora_sal			[ll_fila] = ls_hora_sal
			dw_master.object.area				[ll_fila] = ls_dpto
			dw_master.object.ot_adm				[ll_fila] = ls_ot_adm
			dw_master.object.cod_labor			[ll_fila] = ls_labor
		end if
		
		hpb_progreso.position = ll_fila1 / ll_max_rows * 100
		st_texto.Text = string(ll_fila1) + "/" + string(ll_max_rows) + " filas procesadas."
		yield()		
	next
	
	if dw_master.RowCount() > 0 then
		cb_procesar.enabled = true
	else
		cb_procesar.enabled = false
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

on w_pr916_imp_asistencia.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.cb_1=create cb_1
this.cb_procesar=create cb_procesar
this.hpb_progreso=create hpb_progreso
this.st_texto=create st_texto
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_procesar
this.Control[iCurrent+3]=this.hpb_progreso
this.Control[iCurrent+4]=this.st_texto
end on

on w_pr916_imp_asistencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_procesar)
destroy(this.hpb_progreso)
destroy(this.st_texto)
end on

event ue_update;//Override
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;ids_valorizar = create u_ds_base
ids_valorizar.dataobject = "d_abc_valor_mensual_pptt_tbl"
ids_valorizar.settransobject(SQLCA)

ii_lec_mst = 0
end event

event close;call super::close;destroy ids_valorizar
end event

event ue_update_request;//Override
end event

event closequery;//Override
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr916_imp_asistencia
event ue_display ( string as_columna,  long al_row )
integer y = 164
integer width = 2958
integer height = 1448
string dataobject = "d_abc_asistencia_att2008_tbl"
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

event dw_master::doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2

If this.ii_protect = 1 or row <= 0 then return

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'und'
		ls_sql = "select und as codigo, desc_unidad as descripcion from unidad"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim (ls_return1) = '' then return
		this.object.und[row] = ls_return1
		this.object.desc_unidad[row] = ls_return2
		this.ii_update = 1
		
	case 'grp_medicion'
		ls_sql = "select grp_medicion as codigo, descripcion as nombre from tg_med_act_atributo_grp"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim (ls_return1) = '' then return
		this.object.grp_medicion[row] = ls_return1
		this.object.grp_descripcion[row] = ls_return2
		this.ii_update = 1
end choose
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

type cb_1 from commandbutton within w_pr916_imp_asistencia
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

cb_procesar.enabled = false
li_value =  GetFileOpenName("Abrir ..",  ls_docname, ls_named, "XLS",  "Archivos Excel (*.XLS),*.XLS" )

if li_value = 1 then
	IF parent.event ue_listar_data(ls_docname) = -1 THEN 
		RETURN -1
	END IF
end if




end event

type cb_procesar from commandbutton within w_pr916_imp_asistencia
integer x = 530
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
boolean enabled = false
string text = "Procesar"
end type

event clicked;Long 		ll_i
Integer	li_count, li_nro_item
Date		ld_fecha, ld_fecha1, ld_fecha2
String	ls_cod_trabajador, ls_dni, ls_nom_trabajador, ls_hora_ing, &
			ls_hora_sal, ls_area, ls_ot_adm, ls_cod_labor, ls_mensaje, &
			ls_cuadrilla, ls_reemplazar, ls_eliminar_fila


if dw_master.RowCount( ) = 0 then return

hpb_progreso.position = 0
st_texto.Text = ''
SetNull(ld_fecha1)
SetNull(ld_fecha2)

if MessageBox('Aviso', '¿Desea que la información de la hoja de excel reemplace a alguna ya existente?', Information!, Yesno!, 1) = 1 then
	ls_eliminar_fila = '1'
else
	ls_eliminar_fila = '0'
end if

//REcorro las filas para ver si hay algun duplicado sino para eliminarlo
for ll_i = 1 to dw_master.RowCount()
	dw_master.SelectRow( 0, false)
	dw_master.SelectRow(ll_i, true)
	dw_master.SetRow(ll_i)
	dw_master.ScrollTorow( ll_i )
	
	ld_fecha 			= date(dw_master.object.fecha			[ll_i])
	ls_cod_trabajador = dw_master.object.cod_trabajador 	[ll_i]
	ls_ot_adm 			= dw_master.object.ot_adm 				[ll_i]
	ls_cod_labor 		= dw_master.object.cod_labor 			[ll_i]
	ls_dni				= dw_master.object.dni 					[ll_i]

	//Validando codigo de trabajador
	if (IsNull(ls_cod_trabajador) or trim(ls_cod_trabajador) = '') and (IsNull(ls_dni) or trim(ls_dni) = '' ) then
		gnvo_app.of_message_error( "Error en linea " + String(ll_i) &
			+ " no se ha especificado ni el CODIGO ni el DNI. Por favor verifique!")
		
		return
	end if
	
	//Busco por codigo de trabajador
	if not IsNull(ls_cod_trabajador) and trim(ls_cod_trabajador) <> '' then
		select count(*)
		  into :li_count
		 from maestro
		 where cod_trabajador = :ls_cod_trabajador;
		
		if li_count = 0 then
			gnvo_app.of_message_error( "No existe el codigo de trabajador " + ls_cod_trabajador + " en el maestro de personal. Por favor verifique!")
			return
		end if
		
		//Obtengo el dni y nombre del trabajador
		select nro_doc_ident_rtps, nom_trabajador
			into :ls_dni, :ls_nom_trabajador
		from vw_pr_trabajador m
		where m.cod_trabajador = :ls_cod_trabajador;
		
		dw_master.object.dni 			  [ll_i] = ls_dni
		dw_master.object.nom_trabajador [ll_i] = ls_nom_trabajador
		
	elseif not IsNull(ls_dni) and trim(ls_dni) <> '' then
		
		select count(*)
		  into :li_count
		 from maestro
		 where nro_doc_ident_rtps = :ls_dni;
		
		if li_count = 0 then
			gnvo_app.of_message_error( "No existe el DNI " + ls_dni + " en el maestro de personal. Por favor verifique!")
			return
		end if
		
		//Obtengo el codigo y nombre del trabajador
		select cod_trabajador, nom_trabajador
			into :ls_cod_trabajador, :ls_nom_trabajador
		from vw_pr_trabajador m
		where m.nro_doc_ident_rtps = :ls_dni;
		
		dw_master.object.cod_trabajador [ll_i] = ls_cod_trabajador
		dw_master.object.nom_trabajador [ll_i] = ls_nom_trabajador
	end if
	
	//Validando codigo de labor
	if ISNull(ls_cod_labor) or trim(ls_cod_labor) = '' then
		gnvo_app.of_message_error( "No se ha especificado código de labor en la fila " + string(ll_i) + ". Por favor verifique!")
		return
	end if
	
	select count(*)
	  into :li_count
	 from labor
	 where trim(cod_labor) = trim(:ls_cod_labor);
	
	if li_count = 0 then
		gnvo_app.of_message_error( "No existe el codigo de labor " + ls_cod_labor + " en el maestro de Labores. Por favor verifique!")
		return
	end if
	
	//Validando OT_ADM
	if ISNull(ls_ot_adm) or trim(ls_ot_adm) = '' then
		gnvo_app.of_message_error( "No se ha especificado OT_ADM en la fila " + string(ll_i) + ". Por favor verifique!")
		return
	end if

	select count(*)
	  into :li_count
	 from ot_administracion
	 where ot_adm = :ls_ot_adm;
	
	if li_count = 0 then
		gnvo_app.of_message_error( "No existe el OT_ADM " + ls_ot_adm + " en el maestro de OT_ADM. Por favor verifique!")
		return
	end if
	
	//Eliminando de la tabla RH_ASISTENCIA_ATT2008
	select count(*)
		into :li_count
	from RH_ASISTENCIA_ATT2008
	where trunc(FECHA) = trunc(:ld_fecha)
	  and cod_trabajador = :ls_cod_trabajador;
	
	if li_count > 0 then
		if ls_eliminar_fila = '1' then
			delete RH_ASISTENCIA_ATT2008
			where trunc(FECHA) 	= trunc(:ld_fecha)
			  and cod_trabajador = :ls_cod_trabajador;
			
			IF SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				rollback;
				gnvo_app.of_message_error( "Error al momento de eliminar en RH_ASISTENCIA_ATT2008: " + ls_mensaje)
				return
			end if
		else
			gnvo_app.of_message_Error('El trabajador ' + ls_nom_trabajador + ' con codigo ' + ls_cod_trabajador + ' ya esta registrado en la tabla RH_ASISTENCIA_ATT2008 con fecha ' + string(ld_Fecha, 'dd/mm/yyyy') + '. Por favor verifique!')
			return
		end if
	end if
	
	//Inserto en el jornal del campo
	select count(*)
		into :li_count
		from pd_jornal_campo
	where trunc(FECHA) 	= trunc(:ld_fecha)
	  and cod_trabajador = :ls_cod_trabajador;
	  
	if li_count > 0 then
		if ls_eliminar_fila = '1' then
			delete pd_jornal_campo
			where trunc(FECHA) 	= trunc(:ld_fecha)
			  and cod_trabajador = :ls_cod_trabajador;
			
			IF SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				rollback;
				gnvo_app.of_message_error( "Error al momento de eliminar en pd_jornal_campo: " + ls_mensaje)
				return
			end if
		else
			gnvo_app.of_message_Error('El trabajador ' + ls_nom_trabajador + ' con codigo ' + ls_cod_trabajador + ' ya esta registrado en la tabla pd_jornal_campo con fecha ' + string(ld_Fecha, 'dd/mm/yyyy') + '. Por favor verifique!')
			return
		end if
	end if
	
	//Actualizo el progreso del mismo
	hpb_progreso.position = ll_i / dw_master.RowCount( ) * 100
	st_texto.Text = 'Validando: ' + String(ll_i) + ' / ' + string(dw_master.RowCount()) + ' filas procesadas.'
	
next


//Recorro las filas para la importación
for ll_i = 1 to dw_master.RowCount()
	dw_master.SelectRow( 0, false)
	dw_master.SelectRow(ll_i, true)
	dw_master.SetRow(ll_i)
	dw_master.ScrollTorow( ll_i )
	
	ld_fecha 			= date(dw_master.object.fecha			[ll_i])
	
	//ld_fecha1 es la menor Fecha y ld_fecha2 es la mayor fecha
	if IsNull(ld_fecha1) then
		ld_fecha1 = ld_fecha
	elseif ld_fecha1 > ld_fecha then
		ld_fecha1 = ld_fecha
	end if
	
	if IsNull(ld_fecha2) then
		ld_fecha2 = ld_fecha
	elseif ld_fecha2 < ld_fecha then
		ld_fecha2 = ld_fecha
	end if
	
	ls_cod_trabajador = dw_master.object.cod_trabajador 	[ll_i]
	ls_dni 				= dw_master.object.dni 					[ll_i]
	ls_nom_trabajador = dw_master.object.nom_trabajador 	[ll_i]
	ls_hora_ing 		= dw_master.object.hora_ing 			[ll_i]
	ls_hora_sal 		= dw_master.object.hora_sal 			[ll_i]
	ls_area 				= dw_master.object.area 				[ll_i]
	ls_ot_adm 			= dw_master.object.ot_adm 				[ll_i]
	ls_cod_labor 		= dw_master.object.cod_labor 			[ll_i]
	
	//Validando codigo de trabajador
	select count(*)
	  into :li_count
	 from maestro
	 where cod_trabajador = :ls_cod_trabajador;
	
	if li_count = 0 then
		gnvo_app.of_message_error( "No existe el codigo del trabajador " + ls_cod_trabajador + " en el maestro de personal. Por favor verifique!")
		return
	end if
	
	//Validando codigo de labor
	select count(*)
	  into :li_count
	 from labor
	 where trim(cod_labor) = trim(:ls_cod_labor);
	
	if li_count = 0 then
		gnvo_app.of_message_error( "No existe el codigo de labor " + ls_cod_labor + " en el maestro de Labores. Por favor verifique!")
		return
	end if
	
	//Validando OT_ADM
	select count(*)
	  into :li_count
	 from ot_administracion
	 where ot_adm = :ls_ot_adm;
	
	if li_count = 0 then
		gnvo_app.of_message_error( "No existe el OT_ADM " + ls_ot_adm + " en el maestro de OT_ADM. Por favor verifique!")
		return
	end if
	
	//Busco el siguiente nro de item
	select nvl(max(nro_item), 0)
		into :li_nro_item
	from RH_ASISTENCIA_ATT2008
	where trunc(FECHA) = trunc(:ld_fecha)
	  and cod_trabajador = :ls_cod_trabajador;
	 
	li_nro_item ++
	
	//Inserto datos 
	insert into rh_asistencia_att2008(
		fecha, cod_trabajador, nro_item, dni, nom_trabajador, hora_ing, hora_sal, area, ot_adm, cod_labor)
	values(	
		:ld_fecha, :ls_cod_trabajador, :li_nro_item, :ls_dni, :ls_nom_trabajador, :ls_hora_ing, :ls_hora_sal, 
		:ls_area, :ls_ot_adm, :ls_cod_labor);
	
	if SQLCA.SQLCOde < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_message_error( "Error al momento de insertar en rh_asistencia_att2008: " + ls_mensaje)
		return
	end if
	
	//Obtengo la cuadrilla
	select min(td.cod_cuadrilla)
		into :ls_cuadrilla
   from tg_cuadrillas_det td
	where td.cod_trabajador = :ls_cod_trabajador;
	
	//Obtengo el item del parte de jornal del campo
	select nvl(max(nro_item), 0)
		into :li_nro_item
	from pd_jornal_campo
	where trunc(FECHA) = trunc(:ld_fecha)
	  and cod_trabajador = :ls_cod_trabajador;
	
	li_nro_item ++
			
	//Inserto en el jornal del campo
	insert into pd_jornal_campo(
       fecha, cod_trabajador, nro_item,
		 cod_labor, 
		 flag_trab_general, 
		 hrs_normales, 
		 hrs_extras_25, hrs_extras_35, hrs_noc_extras_35, hrs_extras_100, 
       ot_adm, 
		 fec_registro, 
		 oper_sec, 
		 cod_usr, 
		 cod_origen, 
		 hora_inicio, 
		 hora_fin, 
		 cod_cuadrilla)
	values(
		:ld_fecha, :ls_cod_trabajador, :li_nro_item,
		:ls_cod_labor,
       '0',
       8,
       0, 0, 0, 0,
       :ls_ot_adm,
       sysdate,
       null,
       :gs_user,
       :gs_origen,
       to_date(to_char(:ld_fecha, 'dd/mm/yyyy') || :ls_hora_ing, 'dd/mm/yyyy hh24:mi'),
       to_date(to_char(:ld_fecha, 'dd/mm/yyyy') || :ls_hora_sal, 'dd/mm/yyyy hh24:mi'),
       :ls_cuadrilla);
	
	if SQLCA.SQLCOde < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_message_error( "Error al momento de insertar en pd_jornal_campo: " + ls_mensaje)
		return
	end if
	
	//Actualizo el progreso del mismo
	hpb_progreso.position = ll_i / dw_master.RowCount( ) * 100
	st_texto.Text = 'Insertando: ' + String(ll_i) + ' / ' + string(dw_master.RowCount()) + ' filas procesadas.'
	
next

//Confirmo los cambios
commit;

//Ahora proceso las horas que han sido levantadas anteriormente
if MessageBox('Information', '¿Desea que se procesen las horas que han sido subidas con exito?', Information!, Yesno!, 1) = 1 then

	//create or replace procedure USP_RH_HORAS_JORNAL_CAMPO(
	//		 adi_fecha1 IN DATE,
	//		 adi_fecha2 IN DATE
	//
	//) IS

	DECLARE 	USP_RH_HORAS_JORNAL_CAMPO PROCEDURE FOR
				USP_RH_HORAS_JORNAL_CAMPO( :ld_fecha1,
													:ld_fecha2);
	EXECUTE 	USP_RH_HORAS_JORNAL_CAMPO ;
	
	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "PROCEDURE USP_RH_HORAS_JORNAL_CAMPO: " + SQLCA.SQLErrText
		Rollback ;
		MessageBox('SQL error', ls_mensaje, StopSign!)	
		return
	END IF
	
	CLOSE USP_RH_HORAS_JORNAL_CAMPO;
	
	commit;
end if;

f_mensaje("Proceso terminado satisfactoriamente", "")

	


end event

type hpb_progreso from hprogressbar within w_pr916_imp_asistencia
integer x = 1029
integer y = 8
integer width = 1591
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type st_texto from statictext within w_pr916_imp_asistencia
integer x = 1879
integer y = 84
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

