$PBExportHeader$w_ope004_plant_operacion.srw
forward
global type w_ope004_plant_operacion from w_abc
end type
type cb_copiar from commandbutton within w_ope004_plant_operacion
end type
type tab_1 from tab within w_ope004_plant_operacion
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail dw_detail
end type
type tabpage_2 from userobject within tab_1
end type
type dw_salidas from u_dw_abc within tabpage_2
end type
type dw_ingresos from u_dw_abc within tabpage_2
end type
type st_salidas from statictext within tabpage_2
end type
type st_ingresos from statictext within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_salidas dw_salidas
dw_ingresos dw_ingresos
st_salidas st_salidas
st_ingresos st_ingresos
end type
type tab_1 from tab within w_ope004_plant_operacion
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_master from u_dw_abc within w_ope004_plant_operacion
end type
end forward

global type w_ope004_plant_operacion from w_abc
integer x = 5
integer y = 4
integer width = 4055
integer height = 4448
string title = "[OPE004] Maestro de Plantillas de Operaciones"
string menuname = "m_master_lista"
event ue_recuperar ( string as_cod_plant )
cb_copiar cb_copiar
tab_1 tab_1
dw_master dw_master
end type
global w_ope004_plant_operacion w_ope004_plant_operacion

type variables
Integer  ii_colnum_dd2, ii_colnum_d2

u_dw_abc		idw_detail, idw_salidas, idw_ingresos
staticText	ist_salidas, ist_ingresos

end variables

forward prototypes
public subroutine wf_genera_plantilla_x_ot (string as_nro_doc, string as_cod_plantilla, string as_desc_plantilla, string as_ot_adm)
public function boolean wf_genera_copia_plantilla (string as_new_plantilla, string as_desc_plantilla, string as_cod_plantilla, string as_ot_adm)
public subroutine wf_ins_plant_x_plant (string as_plant_origen, string as_plant_destino)
public subroutine of_asigna_dws ()
public subroutine of_retrieve (string as_nro_plantilla)
end prototypes

public subroutine wf_genera_plantilla_x_ot (string as_nro_doc, string as_cod_plantilla, string as_desc_plantilla, string as_ot_adm);String ls_msj_err



DECLARE PB_USP_OPE_COPIA_PLANTILLA_OT PROCEDURE FOR USP_OPE_COPIA_PLANTILLA_OT
(:as_nro_doc,:as_cod_plantilla,:as_desc_plantilla,:as_ot_adm);
EXECUTE PB_USP_OPE_COPIA_PLANTILLA_OT ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Aviso',ls_msj_err)
ELSE
	Messagebox('Aviso','Se Genero Plantilla '+as_cod_plantilla)
END IF


CLOSE PB_USP_OPE_COPIA_PLANTILLA_OT ;
end subroutine

public function boolean wf_genera_copia_plantilla (string as_new_plantilla, string as_desc_plantilla, string as_cod_plantilla, string as_ot_adm);Boolean lb_ret = TRUE
String  ls_msj_err

DECLARE PB_USP_COPIA_PLANTILLA_OT PROCEDURE FOR USP_OPE_COPIA_PLANT_A_PLANT_OT
(:as_cod_plantilla, :as_new_plantilla, :as_desc_plantilla, :as_ot_adm);
EXECUTE PB_USP_COPIA_PLANTILLA_OT ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Aviso',ls_msj_err)
	lb_ret = FALSE
ELSE
	Commit ;
	lb_ret = TRUE
	Messagebox('Aviso','Se Genero Plantilla ' + as_cod_plantilla)
END IF


CLOSE PB_USP_COPIA_PLANTILLA_OT ;

Return lb_ret
end function

public subroutine wf_ins_plant_x_plant (string as_plant_origen, string as_plant_destino);String ls_msj_err

DECLARE PB_USP_OPE_COPIAR_PLANT_A_PLANT PROCEDURE FOR USP_OPE_COPIAR_PLANT_A_PLANT
(:as_plant_origen,:as_plant_destino);
EXECUTE PB_USP_OPE_COPIAR_PLANT_A_PLANT ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Aviso',ls_msj_err)
ELSE
	Messagebox('Aviso','Se Genero Plantilla '+as_plant_origen)
END IF


CLOSE PB_USP_OPE_COPIAR_PLANT_A_PLANT ;
end subroutine

public subroutine of_asigna_dws ();idw_detail 		= tab_1.tabpage_1.dw_detail
idw_salidas		= tab_1.tabpage_2.dw_salidas
idw_ingresos	= tab_1.tabpage_2.dw_ingresos

ist_salidas = tab_1.tabpage_2.st_salidas
ist_ingresos = tab_1.tabpage_2.st_ingresos
end subroutine

public subroutine of_retrieve (string as_nro_plantilla);Long 		ll_nro_operacion
String	ls_filtro
dw_master.retrieve(as_nro_plantilla)
idw_detail.retrieve(as_nro_plantilla)
idw_salidas.Reset()
idw_ingresos.reset()

if idw_detail.RowCount() > 0 then
	idw_detail.SelectRow( 1, true)
	idw_Detail.SetRow(1)
	
	ll_nro_operacion = Long(idw_Detail.object.nro_operacion [1])
	
	idw_salidas.Retrieve(as_nro_plantilla)
	idw_ingresos.Retrieve(as_nro_plantilla)
	
	ls_filtro = "nro_operacion = " + string(ll_nro_operacion)
	idw_salidas.SetFilter(ls_filtro)
	idw_salidas.Filter()
	
	idw_ingresos.SetFilter(ls_filtro)
	idw_ingresos.Filter()
end if

dw_master.ii_update = 0
idw_detail.ii_update = 0
idw_salidas.ii_update = 0
idw_ingresos.ii_update = 0

dw_master.ResetUpdate()
idw_detail.ResetUpdate()
idw_salidas.ResetUpdate()
idw_ingresos.ResetUpdate()

dw_master.ii_protect = 0
dw_master.of_protect()

idw_detail.ii_protect = 0
idw_detail.of_protect()

idw_salidas.ii_protect = 0
idw_salidas.of_protect()

idw_ingresos.ii_protect = 0
idw_ingresos.of_protect()

is_Action = 'open'

end subroutine

on w_ope004_plant_operacion.create
int iCurrent
call super::create
if this.MenuName = "m_master_lista" then this.MenuID = create m_master_lista
this.cb_copiar=create cb_copiar
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_copiar
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.dw_master
end on

on w_ope004_plant_operacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_copiar)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

dw_master.SetTransObject(SQLCA)
idw_detail.SetTransObject(SQLCA)
idw_ingresos.SetTransObject(SQLCA)
idw_salidas.SetTransObject(SQLCA)


idw_1 = dw_master                   			// asignar dw corriente




end event

event ue_modify;call super::ue_modify;
dw_master.of_protect()
idw_detail.of_protect()
idw_salidas.of_protect()
idw_ingresos.of_protect()

dw_master.SetFocus()
dw_master.of_column_protect("cod_plantilla")




end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR idw_Detail.ii_update = 1 OR &
	 idw_salidas.ii_update = 1 OR idw_ingresos.ii_update = 1 ) THEN
	 
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	END IF
END IF

end event

event ue_update;call super::ue_update;Boolean 	lbo_ok = TRUE
String  	ls_msj, ls_filtro, ls_plantilla
Long		ll_row

try 
	dw_master.AcceptText()
	idw_detail.AcceptText()
	idw_ingresos.AcceptText()
	idw_salidas.AcceptText()
	
	idw_ingresos.setredraw( false )
	idw_salidas.setRedraw( false )
	
	THIS.EVENT ue_update_pre()
	IF ib_update_check = FALSE THEN RETURN
	
	if ib_log then
		dw_master.of_create_log()
		idw_detail.of_create_log()
		idw_salidas.of_create_log()
		idw_ingresos.of_create_log()
	end if
	
	idw_salidas.SetFilter("")
	idw_salidas.Filter()
	
	idw_ingresos.SetFilter("")
	idw_ingresos.Filter()
	
	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			ls_msj = 'Error en Garbación de Maestro de Plantilla - dw_master'
		END IF
	END IF
	
	IF idw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			ls_msj = 'Error en Grabacion de Detalle - de_detail'
		END IF
	END IF
	
	IF	idw_salidas.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_salidas.Update(true, false) = -1 then		// Grabacion del detdet
			lbo_ok = FALSE
			ls_msj = 'Error en Grabacion en Articulos de Salida - dw_salidas'
		END IF
	END IF
	
	IF	idw_ingresos.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_ingresos.Update(true, false) = -1 then		// Grabacion del detdet
			lbo_ok = FALSE
			ls_msj = 'Error en Grabacion en Articulos de Ingreso - dw_ingresos'
		END IF
	END IF
	
	if ib_log and lbo_ok then
		lbo_ok = dw_master.of_save_log()
		lbo_ok = idw_detail.of_save_log()
		lbo_ok = idw_salidas.of_save_log()
		lbo_ok = idw_ingresos.of_save_log()
	end if
	
	
	IF lbo_ok THEN
		COMMIT using SQLCA;
		
		if dw_master.GetRow() > 0 then
			ll_row = idw_detail.getRow()
			ls_plantilla = dw_master.object.cod_plantilla [dw_master.getRow()]
			
			of_retrieve(ls_plantilla)
			
			if ll_row > 0 then
				if idw_detail.RowCount() < ll_row then
					ll_row = 1
				end if
				
				idw_detail.setRow(ll_row)
				idw_detail.SelectRow(0, false)
				idw_detail.SelectRow(ll_row, true)
				idw_detail.ScrollToRow(ll_row)
				
				ls_filtro = "nro_operacion=" + String(idw_detail.object.nro_operacion[ll_row])
			
				idw_salidas.SetFilter(ls_filtro)
				idw_salidas.Filter()
				
				idw_ingresos.SetFilter(ls_filtro)
				idw_ingresos.Filter()
			end if
		end if
		
		dw_master.ii_update = 0
		idw_detail.ii_update = 0
		idw_salidas.ii_update = 0
		idw_ingresos.ii_update = 0
		
		dw_master.ResetUpdate()
		idw_detail.ResetUpdate()
		idw_salidas.ResetUpdate()
		idw_ingresos.ResetUpdate()
		
		
		f_mensaje("Cambios guardados satisfactoriamente", "")
	ELSE 
		ROLLBACK USING SQLCA;
	END IF	

catch ( Exception ex )
	f_mensaje("Ha ocurrido una excepcion, por favor verifique!." &
				+ "~r~nMensaje: " + ex.getMessage(), "")
	
finally
	idw_ingresos.setredraw( true )
	idw_salidas.setRedraw( true )

end try

end event

event ue_insert;call super::ue_insert;Long  ll_row

IF (idw_1 = idw_salidas or idw_1 = idw_ingresos) AND idw_detail.getRow() = 0 THEN
	MessageBox("Error", "No ha seleccionado Operacion")
	RETURN
END IF

IF idw_1 = idw_detail AND dw_master.getRow() = 0 THEN
	MessageBox("Error", "No ha seleccionado Plantilla")
	RETURN
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
END IF



end event

event resize;call super::resize;of_asigna_dws()

tab_1.width = newwidth - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detail.width  = tab_1.tabpage_1.width  - idw_detail.x - 10
idw_detail.height  = tab_1.tabpage_1.height  - idw_detail.y - 10

idw_salidas.width  = tab_1.tabpage_2.width / 2  - idw_salidas.x - 10
idw_salidas.height  = tab_1.tabpage_2.height  - idw_salidas.y - 10


idw_ingresos.x  		= idw_salidas.x + idw_salidas.width + 10
idw_ingresos.width  	= tab_1.tabpage_2.width  - idw_ingresos.x - 10
idw_ingresos.height  = tab_1.tabpage_2.height  - idw_ingresos.y - 10

ist_salidas.x = idw_salidas.x
ist_salidas.width = idw_salidas.width

ist_ingresos.x = idw_ingresos.x
ist_ingresos.width = idw_ingresos.width


end event

event ue_update_pre;call super::ue_update_pre;//--VERIFICACION Y ASIGNACION OPERACIONES
ib_update_check = False	

IF gnvo_app.of_row_Processing( dw_master ) <> true then	return
IF gnvo_app.of_row_Processing( idw_Detail ) <> true then	return
IF gnvo_app.of_row_Processing( idw_salidas) <> true then	return
IF gnvo_app.of_row_Processing( idw_ingresos ) <> true then	return

dw_master.of_set_flag_replicacion()
idw_Detail.of_set_flag_replicacion()
idw_salidas.of_set_flag_replicacion()
idw_ingresos.of_set_flag_replicacion()

ib_update_check = true

end event

event ue_delete_list;call super::ue_delete_list;//
end event

event ue_delete;// Override
Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		
IF ib_update_check = FALSE THEN RETURN

sl_param.dw1     = 'd_lista_plant_prod_tbl'
sl_param.titulo  = 'Plantillas de Ot (Recetas)'
sl_param.tipo    = ''
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
END IF


end event

event ue_print;String			ls_cod_plantilla
str_parametros lstr_param

if dw_master.getRow() = 0 then return

ls_cod_plantilla = dw_master.object.cod_plantilla [1]

lstr_param.dw1 		= 'd_rpt_plant_operaciones_campo_ff'
lstr_param.titulo 	= 'Previo de PLANTILLA DE OT [' + ls_cod_plantilla + "]"
lstr_param.string1 	= ls_cod_plantilla
lstr_param.tipo		= '1S'


OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)

end event

type cb_copiar from commandbutton within w_ope004_plant_operacion
integer x = 2802
integer y = 200
integer width = 704
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copiar Plantilla"
end type

event clicked;String 	ls_old_plantilla, ls_sql
Long 		ll_i, ll_row, ll_row1, ll_j

u_ds_base	ids_detail, ids_consumibles, ids_producibles

try 
	
	ls_sql = "select distinct pp.cod_plantilla as codigo_plantilla, " &
		 + "pp.desc_plantilla as descripcion_plantilla " &
		 + "from plant_prod  pp, " &
		 + "     plant_prod_mov ppm, " &
		 + "     ot_adm_usuario otu " &
		 + "where pp.cod_plantilla = ppm.cod_plantilla " &
		 + "  and pp.ot_adm        = otu.ot_adm " &
		 + "  and otu.cod_usr      = '" + gs_user + "'" &
		 + "  and pp.flag_estado = '1'"

	if not gnvo_app.of_prompt_value( "Seleccione Plantilla", ls_old_plantilla, ls_sql) then return
	
	//Creo los dataStore
	ids_detail = create u_ds_base
	ids_consumibles = create u_ds_base
	ids_producibles = create u_ds_base
	
	ids_detail.DataObject = 'd_plant_prod_oper_tbl'
	ids_consumibles.DataObject = 'd_plant_prod_mov_tbl'
	ids_producibles.DataObject = 'd_plant_prod_mov_ingreso_tbl'
	
	ids_detail.setTransObject(SQLCA)
	ids_consumibles.setTransObject(SQLCA)
	ids_producibles.setTransObject(SQLCA)	
	
	//Recupero la informacion
	ids_detail.Retrieve(ls_old_plantilla)
	ids_consumibles.Retrieve(ls_old_plantilla)
	ids_producibles.Retrieve(ls_old_plantilla)
	
	if ids_detail.RowCount() = 0 then 
		gnvo_app.of_mensaje_error("La plantilla " + ls_old_plantilla + " no tiene ningun detalle de labores ni materiales, por favor confirmar!")
		return
	end if
	
	for ll_i = 1 to ids_detail.RowCount() 
		ll_row = idw_detail.event ue_insert()
		
		if ll_row > 0 then
			idw_detail.object.nro_operacion 		[ll_row] = ids_detail.object.nro_operacion	[ll_i]
			idw_detail.object.nro_precedencia 	[ll_row] = ids_detail.object.nro_precedencia	[ll_i]
			idw_detail.object.cod_labor 			[ll_row] = ids_detail.object.cod_labor			[ll_i]
			idw_detail.object.cod_ejecutor 		[ll_row] = ids_detail.object.cod_ejecutor		[ll_i]
			idw_detail.object.servicio 			[ll_row] = ids_detail.object.servicio			[ll_i]
			idw_detail.object.nro_dias_inicio 	[ll_row] = ids_detail.object.nro_dias_inicio	[ll_i]
			idw_detail.object.dias_duracion 		[ll_row] = ids_detail.object.dias_duracion	[ll_i]
			idw_detail.object.desc_operacion 	[ll_row] = ids_detail.object.desc_operacion	[ll_i]
			idw_detail.object.dias_holgura 		[ll_row] = ids_detail.object.dias_holgura		[ll_i]
			idw_detail.object.cantidad 			[ll_row] = ids_detail.object.cantidad			[ll_i]
			idw_detail.object.labor_und 			[ll_row] = ids_detail.object.labor_und			[ll_i]
			idw_detail.object.flag_pre 			[ll_row] = ids_detail.object.flag_pre			[ll_i]
			idw_detail.object.flag_dias_inicio 	[ll_row] = ids_detail.object.flag_dias_inicio[ll_i]
			idw_detail.object.nro_personas 		[ll_row] = ids_detail.object.nro_personas		[ll_i]
			idw_detail.object.cencos 				[ll_row] = ids_detail.object.cencos				[ll_i]
			idw_detail.object.ot_seccion 			[ll_row] = ids_detail.object.ot_seccion		[ll_i]
			
		end if
	next
	
	for ll_j = 1 to ids_consumibles.RowCount()
		ll_row1 = idw_salidas.event ue_insert( ) 
		if ll_row1 > 0 then
			idw_salidas.object.cod_art			[ll_row1] = ids_consumibles.object.cod_art			[ll_j]
			idw_salidas.object.desc_art		[ll_row1] = ids_consumibles.object.desc_art			[ll_j]
			idw_salidas.object.cantidad		[ll_row1] = ids_consumibles.object.cantidad			[ll_j]
			idw_salidas.object.und				[ll_row1] = ids_consumibles.object.und					[ll_j]
			idw_salidas.object.desc_operacion[ll_row1] = ids_consumibles.object.desc_operacion	[ll_j]
			idw_salidas.object.cod_clase		[ll_row1] = ids_consumibles.object.cod_clase			[ll_j]
			idw_salidas.object.desc_clase		[ll_row1] = ids_consumibles.object.desc_clase		[ll_j]
		end if
	next
	
	for ll_j = 1 to ids_producibles.RowCount()
		ll_row1 = idw_ingresos.event ue_insert( ) 
		if ll_row1 > 0 then
			idw_ingresos.object.cod_art			[ll_row1] = ids_producibles.object.cod_art			[ll_j]
			idw_ingresos.object.desc_art			[ll_row1] = ids_producibles.object.desc_art			[ll_j]
			idw_ingresos.object.cantidad			[ll_row1] = ids_producibles.object.cantidad			[ll_j]
			idw_ingresos.object.und					[ll_row1] = ids_producibles.object.und					[ll_j]
			idw_ingresos.object.desc_operacion	[ll_row1] = ids_producibles.object.desc_operacion	[ll_j]
			idw_ingresos.object.cod_clase			[ll_row1] = ids_producibles.object.cod_clase			[ll_j]
			idw_ingresos.object.desc_clase		[ll_row1] = ids_producibles.object.desc_clase		[ll_j]
		end if
	next
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Ha ocurrido una excepcion para crear la plantilla")
	
finally
	destroy ids_detail
	destroy ids_consumibles
	destroy ids_producibles
	
end try




end event

type tab_1 from tab within w_ope004_plant_operacion
event create ( )
event destroy ( )
integer y = 672
integer width = 3360
integer height = 1888
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 3323
integer height = 1768
long backcolor = 79741120
string text = "Labores / Operaciones"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabpage_1.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabpage_1
integer width = 3008
integer height = 1376
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_plant_prod_oper_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;of_asigna_dws()

is_mastdet = 'd'      // 'm' = master sin detalle (default), 'd' =  detalle,
                       // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  // tabular, grid, form (default)
 
ii_ck[1] = 1		// columnas de lectrua de este dw
ii_rk[1] = 9 	   // columnas que recibimos del master
ii_dk[1] = 9 	   // columnas que se pasan al detalle
ii_dk[2] = 1

idw_mst  = dw_master
idw_det  = idw_salidas

ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear
end event

event doubleclicked;IF Getrow() = 0 THEN Return
String 	ls_name, ls_prot, ls_filter, ls_flag_estado, &
			ls_cod_labor, ls_ot_adm, ls_null
str_seleccionar lstr_seleccionar

SetNull(ls_null)
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

ls_flag_estado = '1'



CHOOSE CASE dwo.name
	CASE 'cod_labor'
		ls_ot_adm = dw_master.object.ot_adm[dw_master.getRow()]
		lstr_seleccionar.s_seleccion = 'S'
		
										
		lstr_seleccionar.s_sql = 'SELECT VW_OPE_LABOR_X_OT_ADM.COD_LABOR AS CODIGO, '&   
														+'VW_OPE_LABOR_X_OT_ADM.DESC_LABOR AS DESCRIPCION, '&
														+'VW_OPE_LABOR_X_OT_ADM.UND AS UNIDAD '&
														+'FROM VW_OPE_LABOR_X_OT_ADM '&
														+'WHERE VW_OPE_LABOR_X_OT_ADM.OT_ADM = '+"'"+ls_ot_adm+"'"													
											
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'cod_labor',lstr_seleccionar.param1[1])
			SetItem(row,'desc_operacion',lstr_seleccionar.param2[1])
			SetItem(row,"labor_und",lstr_seleccionar.param3[1])
			SetItem(row,"cod_ejecutor",ls_null)
			this.ii_update = 1
		END IF
	
	CASE 'cencos'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS, '&   
										+'CENTROS_COSTO.DESC_CENCOS AS DESC_CENCOS '&
										+'FROM CENTROS_COSTO '&
										+'WHERE FLAG_ESTADO = '+"'"+ls_flag_estado+"'"
										
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'cencos',lstr_seleccionar.param1[1])
			this.ii_update = 1
		END IF
		
	CASE 'servicio'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT SERVICIOS.SERVICIO AS CODIGO ,SERVICIOS.DESCRIPCION AS DESCRIPCION'&
									+' FROM SERVICIOS '&
									+'WHERE SERVICIOS.FLAG_ESTADO = '+"'"+'1'+"'"
										
										
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'servicio',lstr_seleccionar.param1[1])
			this.ii_update = 1
		END IF
	
	case "cod_ejecutor"
		ls_cod_labor = this.object.cod_labor [row]
		if ISNull(ls_cod_labor) or ls_cod_labor = '' then
			MessageBox('Error', 'No ha especificado código de labor')
			this.setColumn('cod_labor')
			return
		end if
		
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = "SELECT e.cod_ejecutor as codigo_ejecutor, " &
									  + "e.DESCRIPCION AS DESCRIPCION_ejecutor "&
									  + "FROM labor_ejecutor la, "&
									  + "ejecutor e " &
									  + "WHERE la.cod_ejecutor = e.cod_ejecutor " &
									  + "and la.cod_labor = '" + ls_cod_labor + "'"
										
										
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'cod_ejecutor',lstr_seleccionar.param1[1])
			this.ii_update = 1
		END IF

				
END CHOOSE


end event

event itemchanged;call super::itemchanged;String ls_resultado, ls_columna ,ls_cod_labor, ls_desc_labor, ls_precedencia, ls_und, ls_filter
Long   ll_count

ii_update = 1

CHOOSE CASE dwo.name
		 CASE 'servicios'
				select Count(*) into :ll_count
				  from servicios
				 where (servicio    = :data ) and
				 		 (flag_estado = '1'   )	;

				if ll_count = 0 then
					Messagebox('Aviso','Servicio No Existe ,Verifique!')
					Return 1
				end if
				
									
		 CASE 'cod_labor'
	  			ls_cod_labor = data
		      SELECT desc_labor, und INTO :ls_desc_labor,:ls_und  
		        FROM labor  
			    WHERE cod_labor = :ls_cod_labor  and
				 		 flag_estado = '1' ;
	
			   IF Isnull(ls_desc_labor) OR Trim(ls_desc_labor) = '' THEN
					Messagebox('Aviso','Codigo de Labor No Existe Verifique',StopSign!)
			      This.Object.cod_labor[row] = ''
					This.Object.desc_operacion[row] = ''
					This.Object.labor_und[row] = ''
					Return 1
				ELSE
		  			This.SetItem(row,"desc_operacion",ls_desc_labor)
					This.SetItem(row,"labor_und",ls_und)
					//ls_filter = "cod_labor = '" + ls_cod_labor + "'"
					//idw_child.Setfilter(ls_filter)
					//idw_child.filter()	
				END IF
				
		CASE 'cantidad'  // Pasar de horas a decimales
			  IF pos( data, ':' ) > 0 Then  // Esta en Formato horario
		        ls_columna = dwo.Name 
		        ls_resultado = f_conv_hr_dec(data) 
			     THIS.SetItem(row, ls_columna, Dec(ls_resultado)) 
				  THIS.SetText(ls_resultado)
				  RETURN 2
			  END IF

END CHOOSE		

end event

event itemerror;Return 1

end event

event ue_output;call super::ue_output;Long 		ll_nro_operacion
String	ls_filtro

ll_nro_operacion = Long(this.object.nro_operacion [al_row])

if not IsNull(ll_nro_operacion) and ll_nro_operacion <> 0 then
	ls_filtro = "nro_operacion=" + string(ll_nro_operacion)
else
	ls_filtro = "nro_operacion=-1"
end if

idw_salidas.SetFilter(ls_filtro)
idw_salidas.Filter()

idw_ingresos.SetFilter(ls_filtro)
idw_ingresos.Filter()




end event

event ue_insert_pre;call super::ue_insert_pre;Long ll_row
String ls_cod_plantilla

ll_row = dw_master.GetRow()

IF ll_row = 0 then 
	messagebox('Aviso','No existe plantilla')
	return
END IF

ls_cod_plantilla = dw_master.GetItemString(ll_row, 'cod_plantilla')

This.SetItem ( al_row, 'cod_plantilla', ls_cod_plantilla)
This.SetItem ( al_row, 'flag_pre', 'I')
This.SetItem ( al_row, 'flag_dias_inicio', 'F')
end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;//Parent.TriggerEvent('ue_update_request')

idw_salidas.retrieve(aa_id[1], aa_id[2])
idw_ingresos.retrieve(aa_id[1], aa_id[2])


end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 3323
integer height = 1768
long backcolor = 79741120
string text = "Artículos / Insumos / PP.TT."
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_salidas dw_salidas
dw_ingresos dw_ingresos
st_salidas st_salidas
st_ingresos st_ingresos
end type

on tabpage_2.create
this.dw_salidas=create dw_salidas
this.dw_ingresos=create dw_ingresos
this.st_salidas=create st_salidas
this.st_ingresos=create st_ingresos
this.Control[]={this.dw_salidas,&
this.dw_ingresos,&
this.st_salidas,&
this.st_ingresos}
end on

on tabpage_2.destroy
destroy(this.dw_salidas)
destroy(this.dw_ingresos)
destroy(this.st_salidas)
destroy(this.st_ingresos)
end on

type dw_salidas from u_dw_abc within tabpage_2
integer y = 96
integer width = 1719
integer height = 720
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_plant_prod_mov_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;of_asigna_dws()

is_mastdet = 'd'       // 'm' = master sin detalle (default), 'd' =  detalle,
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  // tabular, grid, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2


idw_mst  = idw_detail

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple

end event

event itemchanged;call super::itemchanged;String ls_desc_art, ls_und, ls_cod_art, ls_cod_labor, ls_cnta_prsp, ls_cod_clase, ls_desc_clase

This.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_art'
		ls_cod_labor = idw_detail.object.cod_labor [idw_detail.getrow()]
	
		SELECT a.desc_art , a.und, a2.cnta_prsp_egreso, ac.cod_clase, ac.desc_clase
		  INTO :ls_desc_art,:ls_und, :ls_cnta_prsp, :ls_cod_clase, :ls_desc_clase
		  FROM 	articulo 				a,
					labor_insumo 			l,
					articulo_clase			ac,
					articulo_sub_categ 	a2
		 WHERE a.cod_art     = l.cod_art     
		   and a.sub_cat_art = a2.cod_sub_cat
			and a.cod_clase	= ac.cod_clase
		   AND a.flag_estado = '1'           
			AND l.cod_labor   = :ls_cod_labor 
			AND a.cod_art	  	= :data;
		
	
		
		IF Isnull(ls_desc_art) OR Trim(ls_desc_art) = '' THEN
			Messagebox('Aviso','Codigo de Articulo ' + data + ' no existe, no se encuentra activo o no pertenece a la labor ' + ls_cod_labor + ', por favor verifique!!',StopSign!)
			This.Object.cod_art		[row] = gnvo_app.is_null
			This.Object.desc_art		[row] = gnvo_app.is_null
			This.Object.und			[row] = gnvo_app.is_null
			This.Object.cnta_prsp	[row] = gnvo_app.is_null
			This.Object.cod_clase	[row] = gnvo_app.is_null
			This.Object.desc_clase	[row] = gnvo_app.is_null
			
			Return 1
		end if
		
		This.Object.desc_art		[row] = ls_Desc_art
		This.Object.und			[row] = ls_und
		This.Object.cnta_prsp	[row] = ls_cnta_prsp
		This.Object.cod_clase	[row] = ls_cod_clase
		This.Object.desc_clase	[row] = ls_desc_clase
		
END CHOOSE
end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;THIS.Selectrow( 0,false)
THIS.Selectrow( currentrow,false)
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cantidad 		[al_Row] = 0.00
this.object.desc_operacion [al_Row] = idw_detail.object.desc_operacion[idw_detail.getRow()]
end event

event ue_display;call super::ue_display;string 	ls_codigo, ls_data, ls_sql, ls_cod_labor, ls_und, ls_cnta_prsp, ls_cod_clase, ls_desc_clase
choose case lower(as_columna)
	case "cod_art"
		ls_cod_labor = idw_detail.object.cod_labor [idw_detail.getrow()]

		ls_sql = "SELECT VW.COD_ART AS CODIGO, "&   
				 + "VW.DESC_ART AS DESCRIPCION, "&   
				 + "VW.UND AS UNIDAD, "&   
				 + "ac.cod_clase, " &
				 + "ac.desc_clase, " &
				 + "a2.CNTA_PRSP_EGRESO as cnta_prsp " &
				 + "FROM  VW_MTT_ART_X_LABOR VW, "&
				 + "articulo a, " &
				 + "articulo_clase ac, " &
				 + "articulo_sub_categ a2 " &
				 + "WHERE vw.cod_art 	= a.cod_Art " &
				 + "  and a.cod_clase 	= ac.cod_clase " &
				 + "  and a.sub_Cat_art = a2.cod_sub_cat "  &
				 + "  and VW.COD_LABOR 	= '" + ls_cod_labor + "'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_und, ls_cod_clase, ls_desc_clase, ls_cnta_prsp, '2') then
			this.object.cod_Art		[al_row] = ls_codigo
			this.object.desc_art		[al_row] = ls_data
			this.object.und			[al_row] = ls_und
			this.object.cnta_prsp	[al_row] = ls_cnta_prsp
			this.object.cod_clase	[al_row] = ls_cod_clase
			this.object.desc_clase	[al_row] = ls_desc_clase
			this.ii_update = 1
		end if
		
end choose



end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

type dw_ingresos from u_dw_abc within tabpage_2
integer x = 1760
integer y = 96
integer width = 1719
integer height = 720
integer taborder = 40
string dataobject = "d_plant_prod_mov_ingreso_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'       // 'm' = master sin detalle (default), 'd' =  detalle,
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  // tabular, grid, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3

ii_rk[1] = 1	      // columnas que recibimos del master
ii_rk[2] = 2

idw_mst  = idw_detail
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event itemchanged;call super::itemchanged;String ls_desc_art, ls_und, ls_cod_art, ls_cod_labor, ls_cnta_prsp, ls_cod_clase, ls_desc_clase

This.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_art'
		ls_cod_labor = idw_detail.object.cod_labor [idw_detail.getrow()]
	
		SELECT a.desc_art , a.und, decode(l.cnta_prsp, null, a2.cnta_prsp_ingreso, l.cnta_prsp), ac.cod_clase, ac.desc_clase
		  INTO :ls_desc_art,:ls_und, :ls_cnta_prsp, :ls_cod_clase, :ls_desc_clase
		  FROM 	articulo 				a,
					labor_produccion		l,
					articulo_clase			ac,
					articulo_sub_categ 	a2
		 WHERE a.cod_art     = l.cod_art     
		   and a.sub_cat_art = a2.cod_sub_cat
			and a.cod_clase	= ac.cod_clase
		   AND a.flag_estado = '1'           
			AND l.cod_labor   = :ls_cod_labor 
			AND a.cod_art	  	= :data;
		
	
		
		IF Isnull(ls_desc_art) OR Trim(ls_desc_art) = '' THEN
			Messagebox('Aviso','Codigo de Articulo ' + data + ' no existe, no se encuentra activo o no pertenece a la labor ' + ls_cod_labor + ', por favor verifique!!',StopSign!)
			This.Object.cod_art		[row] = gnvo_app.is_null
			This.Object.desc_art		[row] = gnvo_app.is_null
			This.Object.und			[row] = gnvo_app.is_null
			This.Object.cnta_prsp	[row] = gnvo_app.is_null
			This.Object.cod_clase	[row] = gnvo_app.is_null
			This.Object.desc_clase	[row] = gnvo_app.is_null
			
			Return 1
		end if
		
		This.Object.desc_art		[row] = ls_Desc_art
		This.Object.und			[row] = ls_und
		This.Object.cnta_prsp	[row] = ls_cnta_prsp
		This.Object.cod_clase	[row] = ls_cod_clase
		This.Object.desc_clase	[row] = ls_desc_clase
		
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;THIS.Selectrow( 0,false)
THIS.Selectrow( currentrow,false)
end event

event ue_display;call super::ue_display;string 	ls_codigo, ls_data, ls_sql, ls_cod_labor, ls_und, ls_cnta_prsp, ls_cod_clase, ls_desc_clase
choose case lower(as_columna)
	case "cod_art"
		ls_cod_labor = idw_detail.object.cod_labor [idw_detail.getrow()]

		ls_sql = "SELECT a.COD_ART AS CODIGO, "&   
				 + "a.DESC_ART AS DESCRIPCION, "&   
				 + "a.UND AS UNIDAD, "&   
				 + "ac.cod_clase, " &
				 + "ac.desc_clase, " &
				 + "decode(vw.cnta_prsp, null, a2.cnta_prsp_ingreso, vw.cnta_prsp) as cnta_prsp " &
				 + "FROM  labor_produccion VW, "&
				 + "articulo a, " &
				 + "articulo_clase ac, " &
				 + "articulo_sub_categ a2 " &
				 + "WHERE vw.cod_art 	= a.cod_Art " &
				 + "  and a.cod_clase 	= ac.cod_clase " &
				 + "  and a.sub_Cat_art = a2.cod_sub_cat "  &
				 + "  and VW.COD_LABOR 	= '" + ls_cod_labor + "'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_und, ls_cod_clase, ls_desc_clase, ls_cnta_prsp, '2') then
			this.object.cod_Art		[al_row] = ls_codigo
			this.object.desc_art		[al_row] = ls_data
			this.object.und			[al_row] = ls_und
			this.object.cnta_prsp	[al_row] = ls_cnta_prsp
			this.object.cod_clase	[al_row] = ls_cod_clase
			this.object.desc_clase	[al_row] = ls_desc_clase
			this.ii_update = 1
		end if
		
end choose



end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cantidad 		[al_Row] = 0.00
this.object.desc_operacion [al_Row] = idw_detail.object.desc_operacion[idw_detail.getRow()]
end event

type st_salidas from statictext within tabpage_2
integer x = 9
integer y = 16
integer width = 352
integer height = 72
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Salidas"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_ingresos from statictext within tabpage_2
integer x = 1760
integer y = 16
integer width = 352
integer height = 72
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingresos"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_ope004_plant_operacion
integer width = 3611
integer height = 664
integer taborder = 40
string dataobject = "d_plant_prod_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event constructor;call super::constructor;of_asigna_dws()

is_mastdet = 'md'       // 'm' = master sin detalle (default), 'd' =  detalle,
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'tabular'  // tabular, grid, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_det  = idw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'grupo'
		
		// Verifica que codigo ingresado exista			
		SELECT descripcion
			INTO :ls_data
		FROM plantilla_grupo
		WHERE grupo = :data ;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.grupo			[row] = gnvo_app.is_null
			this.object.desc_grupo	[row] = gnvo_app.is_null
			gnvo_app.of_mensaje_error('Grupo ' + data + ' no existe, por favor verifique')
			return 1
		end if

		this.object.desc_grupo			[row] = ls_data

	CASE 'ot_adm'
		
		// Verifica que codigo ingresado exista			
		select ota.descripcion
			into :ls_data
		from 	ot_administracion ota,
     			ot_adm_usuario    otu
		where ota.ot_adm 			= otu.ot_adm     
  		  and ota.flag_estado 	= '1'
		  and otu.cod_usr			= :gs_user
		  and ota.ot_adm			= :data;

			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.ot_adm		[row] = gnvo_app.is_null
			this.object.desc_ot_adm	[row] = gnvo_app.is_null
			gnvo_app.of_mensaje_error('OT_ADM ' + data + ' no existe, no esta activo o no tiene acceso al mismo, por favor verifique')
			return 1
		end if

	CASE 'especie'
		
		// Verifica que codigo ingresado exista			
		select e.descr_especie
			into :ls_data
		from tg_especies e
		where e.flag_estado 	= '1'
		  and e.especie		= :data;

			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.especie		[row] = gnvo_app.is_null
			this.object.desc_especie[row] = gnvo_app.is_null
			gnvo_app.of_mensaje_error('ESPECIE ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if
END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado		[al_row]='1'
this.object.copia_material	[al_row]='0'

is_Action = 'new'
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "grupo"
		ls_sql = "SELECT GRUPO AS GRUPO, " &   
				 + "DESCRIPCION AS DESCRIPCION "&
				 + "FROM PLANTILLA_GRUPO "

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.grupo			[al_row] = ls_codigo
			this.object.desc_grupo	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "ot_adm"
		ls_sql = "select ota.ot_adm as ot_adm, " &
				 + "ota.descripcion as desc_ot_adm " &
				 + "from ot_administracion ota, " &
				 + "     ot_adm_usuario    otu " &
				 + "where ota.ot_adm = otu.ot_adm " &
				 + "  and ota.flag_estado = '1' " &
				 + "  and otu.cod_usr = '" + gs_user + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.ot_adm		[al_row] = ls_codigo
			this.object.desc_ot_adm	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "especie"
		ls_sql = "select e.especie as especie, " &
				 + "e.descr_especie as descripcion_especie " &
				 + "from tg_especies e " &
				 + "where e.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.especie			[al_row] = ls_codigo
			this.object.desc_especie	[al_row] = ls_data
			this.ii_update = 1
		end if


end choose



//CHOOSE CASE dwo.name

//		 CASE ''
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT VW_CAM_USR_ADM.OT_ADM AS CODIGO, '&   
//												 +'VW_CAM_USR_ADM.DESCRIPCION  AS DESCRIPCION  '&   
//												 +'FROM  VW_CAM_USR_ADM '&
//												 +'WHERE VW_CAM_USR_ADM.COD_USR = '+"'"+gs_user+"'"    	
//
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'ot_adm',lstr_seleccionar.param1[1])
//					//ls_ot_adm = lstr_seleccionar.param1[1]
//					Setitem(row,'descripcion',lstr_seleccionar.param2[1])
//					this.ii_update = 1
//				END IF
//END CHOOSE
//
end event

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if


end event

event buttonclicked;call super::buttonclicked;
n_cst_wait		invo_wait
str_parametros	lstr_param

if row = 0 then return

try 
	
	if lower(dwo.name) = 'b_obs' then
		
		If this.is_protect("observacion", row) then RETURN
		
		// Para la descripcion de la Factura
		lstr_param.string1   = 'Descripcion de Factura '
		lstr_param.string2	 = this.object.observacion [row]
	
		OpenWithParm( w_descripcion_fac, lstr_param)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		IF lstr_param.titulo = 's' THEN
				This.object.observacion [row] = left(lstr_param.string3, 2000)
				this.ii_update = 1
		END IF	
	end if

catch ( exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al hacer click en boton en el DAtaWindow Maestro")

finally
	destroy invo_wait
end try

end event

