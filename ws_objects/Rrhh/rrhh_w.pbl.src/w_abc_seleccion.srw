$PBExportHeader$w_abc_seleccion.srw
forward
global type w_abc_seleccion from w_abc_list
end type
type cb_transferir from commandbutton within w_abc_seleccion
end type
type uo_search from n_cst_search within w_abc_seleccion
end type
end forward

global type w_abc_seleccion from w_abc_list
integer width = 3589
integer height = 1836
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_transferir cb_transferir
uo_search uo_search
end type
global w_abc_seleccion w_abc_seleccion

type variables
String  			is_col = '', is_tipo, is_type, is_soles, is_tipo_alm, &
					is_oper_cons_int, is_almacen, is_opcion
Date 				id_fecha
Double 			in_tipo_cambio
Long				il_opcion
str_parametros	ist_datos
n_cst_maestro	invo_maestro		

end variables

forward prototypes
public function boolean of_opcion1 ()
public function boolean of_opcion2 ()
public function boolean of_opcion3 ()
public function boolean of_opcion4 ()
end prototypes

public function boolean of_opcion1 ();// Solo para consumos internos 
Long   	ll_j, ll_row, ll_found
String 	ls_filtro, ls_cod_trabajador
date		ld_fec_fin, ld_fec_inicio
u_dw_abc ldw_detail, ldw_master

ldw_detail = ist_datos.dw_d	// detail
ldw_master = ist_datos.dw_m	// master

ll_row = ldw_master.GetRow()
if ll_row = 0 then return false

ls_cod_trabajador = ldw_master.Object.cod_trabajador 	[ll_row]
	 
FOR ll_j = 1 TO dw_2.RowCount()								
	
	//Verifico si ya ha sido ingresado
	ls_filtro = "item = " + string(dw_2.object.item[ll_j])
	
	ll_found = ldw_detail.find( ls_filtro, 1, ldw_detail.RowCount())
	
	if ll_found > 0 then
		MessageBox('Error', 'Periodo ya ha sido ingresado' )
		return false
	end if
	
	//Valido que el periodo sea continuo para liquidarlo
	if ldw_detail.RowCount() > 0 then
		ld_fec_fin = Date(ldw_detail.object.fec_final_periodo[ldw_detail.RowCount()])
		
		ld_fec_fin = relativeDate(ld_fec_fin, 1)
		ld_fec_inicio = Date(dw_2.object.fec_inicio_periodo[ll_j])
		
		if ld_fec_inicio <> ld_fec_fin then
			MessageBox('Error', 'Los periodos no son continuos' &
									+ "~r~nFecha Fin Periodo Anterior: " + string(ld_fec_fin, 'dd/mm/yyyy') &
									+ "~r~nFecha Inicio Siguiente Periodo: " + string(ld_fec_inicio, 'dd/mm/yyyy') )
			return false
		end if
		
	end if
	
	ll_row = ldw_detail.event ue_insert()
	IF ll_row > 0 THEN
		ldw_detail.ii_update = 1
		ls_cod_trabajador = dw_2.Object.cod_trabajador			[ll_j]
	
		ld_fec_inicio = Date(dw_2.object.fec_inicio_periodo[ll_j])
		ld_fec_fin = Date(dw_2.object.fec_final_periodo[ldw_detail.RowCount()])
				
		ldw_detail.Object.cod_trabajador 		[ll_row] = dw_2.Object.cod_trabajador			[ll_j]
		ldw_detail.Object.item 	 					[ll_row] = dw_2.Object.item 						[ll_j]
		ldw_detail.Object.fec_inicio_periodo  	[ll_row] = dw_2.Object.fec_inicio_periodo		[ll_j]
		ldw_detail.Object.fec_final_periodo    [ll_row] = dw_2.Object.fec_final_periodo		[ll_j]
		ldw_detail.Object.fec_liquidacion  		[ll_row] = dw_2.object.fec_liquidacion			[ll_j]
		ldw_detail.Object.vacaciones_gozadas  	[ll_row] = dw_2.object.vacaciones_gozadas		[ll_j]
		ldw_detail.Object.nro_dias_vacac  		[ll_row] = dw_2.object.nro_dias_vacac			[ll_j]
		ldw_detail.Object.dias_periodo  			[ll_row] = DaysAfter(ld_fec_inicio, ld_fec_fin) + 1
		ldw_detail.Object.dias_laborados  		[ll_row] = invo_maestro.of_dias_trabajados(ls_cod_trabajador, ld_fec_inicio, ld_fec_fin)
	END IF					
NEXT				
return true

end function

public function boolean of_opcion2 ();Long 		ll_inicio
String	ls_codigo

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete TT_RRHH_GRUPO_TRABAJADOR;
if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_RRHH_GRUPO_TRABAJADOR' ) then
	rollback;
	return false;
end if	
commit;

FOR ll_inicio = 1 TO dw_2.Rowcount ()
	ls_codigo	= dw_2.object.grupo_trabaj  	  [ll_inicio]				 				
	
	
	Insert into TT_RRHH_GRUPO_TRABAJADOR(grupo_trabaj)
	Values (:ls_codigo) ;
	
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_RRHH_GRUPO_TRABAJADOR' ) then
		rollback;
		return false;
	end if	
	
NEXT

commit;

return true
end function

public function boolean of_opcion3 ();Long 		ll_inicio
String	ls_codigo

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete TT_SITUACION_TRABAJADOR;
if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_SITUACION_TRABAJADOR' ) then
	rollback;
	return false;
end if	
commit;

FOR ll_inicio = 1 TO dw_2.Rowcount ()
	ls_codigo	= dw_2.object.situa_trabaj  	  [ll_inicio]				 				
	
	
	Insert into TT_SITUACION_TRABAJADOR(situa_trabaj)
	Values (:ls_codigo) ;
	
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_SITUACION_TRABAJADOR' ) then
		rollback;
		return false;
	end if	
	
NEXT

commit;

return true
end function

public function boolean of_opcion4 ();Long 		ll_inicio
String	ls_codigo

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete TT_SINDICATO;
if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_SINDICATO' ) then
	rollback;
	return false;
end if	
commit;

FOR ll_inicio = 1 TO dw_2.Rowcount ()
	ls_codigo	= dw_2.object.flag_sindicato  	  [ll_inicio]				 				
	
	
	Insert into TT_SINDICATO(flag_sindicato)
	Values (:ls_codigo) ;
	
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_SINDICATO' ) then
		rollback;
		return false;
	end if	
	
NEXT

commit;

return true
end function

on w_abc_seleccion.create
int iCurrent
call super::create
this.cb_transferir=create cb_transferir
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_transferir
this.Control[iCurrent+2]=this.uo_search
end on

on w_abc_seleccion.destroy
call super::destroy
destroy(this.cb_transferir)
destroy(this.uo_search)
end on

event ue_open_pre;call super::ue_open_pre;Long 		ll_row
string 	ls_articulo, ls_datawindow
date		ld_fecha
u_dw_abc	ldw_master

invo_maestro = create n_cst_maestro

ii_access = 1   // sin menu

// Recoge parametro enviado
if ISNULL( Message.PowerObjectParm ) or NOT IsValid(Message.PowerObjectParm) THEN
	MessageBox('Aviso', 'Parametros enviados estan en blanco', StopSign!)
	return
end if

If Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	MessageBox('Aviso', 'Parametros enviados no son del Tipo str_parametros', StopSign!)
	return
end if

is_tipo = ist_datos.tipo
il_opcion = ist_datos.opcion


dw_1.DataObject = ist_datos.dw1
dw_2.DataObject = ist_datos.dw1
dw_1.SetTransObject( SQLCA)
dw_2.SetTransObject( SQLCA)	

IF TRIM(is_tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
		ll_row = dw_1.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			ll_row = dw_1.Retrieve(ist_datos.string1)
		CASE '2S'				
			ll_row = dw_1.Retrieve(ist_datos.string1, ist_datos.string2)
		CASE '2S_V2'	// Salida x Consumo Interno
			ldw_master = ist_datos.dw_or_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( ist_datos.string1, ist_datos.fecha1, is_almacen, &
					 ist_datos.tipo_doc, ist_datos.nro_doc)
		CASE '2S_V3'	// Ingreso por produccion			
			ldw_master = ist_datos.dw_or_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen, ist_datos.tipo_doc, ist_datos.nro_doc)

		CASE 'CONSIG'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ld_fecha    = ist_datos.fecha1
			ll_row = dw_1.Retrieve( ist_datos.string1, ld_fecha, is_almacen)
			
		CASE 'CONSIG_2'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			ls_articulo = ldw_master.object.cod_art[ll_row]
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen, ls_articulo )
			
		CASE 'CONSIG_3'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen )
			
		CASE 'DEVOL'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen )
			
		CASE 'PRESTAMOS'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen )

		CASE 'DEVOL_ALMACEN'				
			ldw_master = ist_datos.dw_or_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( ist_datos.oper_cons_interno, ist_datos.fecha1, &
						is_almacen, ist_datos.tipo_doc, ist_datos.nro_doc)
			
	END CHOOSE
END IF

This.Title = ist_datos.titulo
is_col = dw_1.Describe("#1" + ".name")

uo_search.of_set_dw(dw_1)



end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()

end event

event resize;call super::resize;dw_1.height 		= newheight - dw_1.y - 10
dw_1.width			= newwidth/2 - dw_1.x - pb_1.width/2 - 20

dw_2.x				= newwidth/2 + pb_1.width/2 + 20
dw_2.height 		= newheight - dw_2.y - 10
dw_2.width   		= newwidth  - dw_2.x - 10

pb_1.x				= newwidth/2 - pb_1.width/2
pb_2.x				= newwidth/2 - pb_2.width/2

cb_transferir.x = newWidth - cb_transferir.width - 10

uo_search.width 	= cb_transferir.x - uo_Search.x - 10
uo_search.event ue_resize(sizetype, newwidth, newheight)
end event

event close;call super::close;destroy invo_maestro
end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion
event type integer ue_selected_row_now ( long al_row )
integer x = 37
integer y = 144
integer width = 1362
end type

event type integer dw_1::ue_selected_row_now(long al_row);long 		ll_row, ll_count, ll_rc
integer	li_x
any		la_id

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)

return 1
end event

event dw_1::constructor;call super::constructor;if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if

is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

ii_ss = 0

end event

event dw_1::getfocus;call super::getfocus;uo_search.setFocus()
end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_1::ue_selected_row();//
Long	ll_row, ll_y

dw_2.ii_update = 1

THIS.EVENT ue_selected_row_pre()

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	// si retorna 0 (fallo en el row_now), deselecciona
	if THIS.EVENT ue_selected_row_now(ll_row) = 0 then
		this.selectRow(ll_row, false);
	end if
	ll_row = THIS.GetSelectedRow(ll_row)
Loop

THIS.EVENT ue_selected_row_pos()


end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion
integer x = 1600
integer y = 144
integer width = 1362
integer taborder = 50
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1         // columnas de lectrua de este dw

end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc, ll_count
Any	la_id
Integer	li_x

if ist_datos.opcion >= 7 and ist_datos.opcion <= 10 then
	
	ll_row = idw_det.EVENT ue_insert()
	ll_count = Long(this.object.Datawindow.Column.Count)
	FOR li_x = 1 to ll_count
		la_id = THIS.object.data.primary.current[al_row, li_x]	
		ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
	NEXT
	
else
	ll_row = idw_det.EVENT ue_insert()
	
	FOR li_x = 1 to UpperBound(ii_dk)
		la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
		ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
	NEXT
	
end if

idw_det.ScrollToRow(ll_row)


end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion
integer x = 1426
integer y = 440
integer taborder = 30
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion
integer x = 1431
integer y = 588
integer taborder = 40
end type

type cb_transferir from commandbutton within w_abc_seleccion
integer x = 3017
integer width = 338
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;// Transfiere campos 
CHOOSE CASE ist_datos.opcion
		
	CASE 1 // consumos internos
		if of_opcion1() then 
			ist_datos.titulo = 's'
		else
			return
		end if
	
	CASE 2 // Grupos de Trabajadores
		if of_opcion2() then 
			ist_datos.titulo = 's'
		else
			return
		end if
	
	CASE 3 // Tipos de Contrato
		if of_opcion3() then 
			ist_datos.titulo = 's'
		else
			return
		end if
		
	CASE 4 // Estados de sindicato
		if of_opcion4() then 
			ist_datos.titulo = 's'
		else
			return
		end if

END CHOOSE
CloseWithReturn( parent, ist_datos)
end event

type uo_search from n_cst_search within w_abc_seleccion
event destroy ( )
integer taborder = 40
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

