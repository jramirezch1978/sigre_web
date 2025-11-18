$PBExportHeader$w_ope003_labor_ejecutor.srw
forward
global type w_ope003_labor_ejecutor from w_abc
end type
type dw_lista from u_dw_abc within w_ope003_labor_ejecutor
end type
type st_producibles from statictext within w_ope003_labor_ejecutor
end type
type dw_producibles from u_dw_abc within w_ope003_labor_ejecutor
end type
type uo_search from n_cst_search within w_ope003_labor_ejecutor
end type
type dw_master from u_dw_abc within w_ope003_labor_ejecutor
end type
type dw_labor_ejecutor from u_dw_abc within w_ope003_labor_ejecutor
end type
type dw_consumibles from u_dw_abc within w_ope003_labor_ejecutor
end type
type st_consumibles from statictext within w_ope003_labor_ejecutor
end type
type st_ejecutores from statictext within w_ope003_labor_ejecutor
end type
type st_datos_generales from statictext within w_ope003_labor_ejecutor
end type
end forward

global type w_ope003_labor_ejecutor from w_abc
integer width = 5385
integer height = 2348
string title = "[OPE003] Maestro de Labores"
string menuname = "m_master_sin_lista"
event ue_retrieve_labor ( string as_cod_labor )
dw_lista dw_lista
st_producibles st_producibles
dw_producibles dw_producibles
uo_search uo_search
dw_master dw_master
dw_labor_ejecutor dw_labor_ejecutor
dw_consumibles dw_consumibles
st_consumibles st_consumibles
st_ejecutores st_ejecutores
st_datos_generales st_datos_generales
end type
global w_ope003_labor_ejecutor w_ope003_labor_ejecutor

type variables
String  	is_flag_Cnta_prsp
str_parametros 	ist_datos


end variables

event ue_retrieve_labor(string as_cod_labor);dw_master.retrieve(as_cod_labor)

dw_labor_ejecutor.Retrieve(as_cod_labor)

dw_consumibles.Retrieve(as_cod_labor)

dw_producibles.Retrieve(as_cod_labor)


dw_master.ii_update = 0
dw_labor_ejecutor.ii_update = 0
dw_consumibles.ii_update = 0
dw_producibles.ii_update = 0

dw_master.resetUpdate()
dw_labor_ejecutor.resetUpdate()
dw_consumibles.resetUpdate()
dw_producibles.resetUpdate()
end event

event ue_open_pre;call super::ue_open_pre;dw_lista.SetTransObject(SQLCA)
dw_master.SetTransobject(sqlca)
dw_labor_ejecutor.SettransObject(sqlca)
dw_consumibles.SetTransObject(sqlca)
dw_producibles.SetTransObject(sqlca)

//Protección de objectos Datawindows
dw_master.of_protect()
dw_consumibles.of_protect()
dw_producibles.of_protect()
dw_labor_ejecutor.of_protect()

idw_1 = dw_master  // asignar dw corriente

//Help
ii_help = 2

select NVL(flag_mod_cnta_prsp, '0')
	into :is_flag_cnta_prsp
from presup_param
where llave = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en presup_param')
	return
end if

uo_search.of_set_dw(dw_lista)

event ue_refresh()
end event

event resize;call super::resize;dw_master.width  				= newwidth - dw_master.x - 10
st_datos_generales.width	= dw_master.width


dw_labor_ejecutor.width  	= newwidth - dw_labor_ejecutor.x - 10
st_ejecutores.width			= dw_labor_ejecutor.width

//Los paneles de consumibles y producibles
dw_consumibles.width  	= (newwidth - dw_consumibles.x) / 2 - 5
dw_consumibles.height 	= newheight - dw_consumibles.y - 10
st_consumibles.width		= dw_consumibles.width

dw_producibles.x  		= dw_consumibles.x + dw_consumibles.width + 5
dw_producibles.width  	= newwidth - dw_producibles.x - 10
dw_producibles.height 	= newheight - dw_producibles.y - 10
st_producibles.x			= dw_producibles.x
st_producibles.width		= dw_producibles.width

dw_lista.height  = newheight - dw_lista.y  - 10


uo_search.event ue_resize(sizetype, uo_search.width, newheight)
end event

event ue_modify;call super::ue_modify;Int li_protect

dw_master.of_protect()
dw_labor_ejecutor.of_protect()
dw_consumibles.of_protect()
dw_producibles.of_protect()

li_protect = integer(dw_master.Object.cod_labor.Protect)

IF li_protect = 0 THEN
   dw_master.Object.cod_labor.Protect = 1
END IF 
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_cod_labor
Long 		ll_find

dw_master.AcceptText()
dw_labor_ejecutor.AcceptText()
dw_consumibles.AcceptText()
dw_producibles.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

if ib_log then
	dw_master.of_create_log( )
	dw_labor_ejecutor.of_create_log( )
	dw_consumibles.of_create_log( )
	dw_producibles.of_create_log( )
end if

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF dw_labor_ejecutor.ii_update = 1 THEN
	IF dw_labor_ejecutor.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Eejcutor","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF dw_consumibles.ii_update = 1 THEN
	IF dw_consumibles.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Articulos consumibles","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF dw_producibles.ii_update = 1 THEN
	IF dw_producibles.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Articulos Producibles","Se ha procedido al rollback",exclamation!)
	END IF
END IF


if ib_log and lbo_ok then
	lbo_ok = dw_master.of_save_log()
	lbo_ok = dw_labor_ejecutor.of_save_log()
	lbo_ok = dw_consumibles.of_save_log()
	lbo_ok = dw_producibles.of_save_log()
end if

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	if dw_master.RowCount() > 0 then
		ls_cod_labor = dw_master.object.cod_labor [1]
	else
		ls_Cod_labor = ''
	end if
	
	dw_master.ii_update = 0
	dw_labor_ejecutor.ii_update = 0
	dw_consumibles.ii_update = 0
	dw_producibles.ii_update = 0
	
	dw_master.ResetUpdate()
	dw_labor_ejecutor.ResetUpdate()
	dw_consumibles.ResetUpdate()
	dw_producibles.ResetUpdate()
	
	//Limpio el filtro
	uo_search.of_clear_filtro()
	
	this.event ue_refresh()
	
	if trim(ls_cod_labor) <> '' and dw_lista.RowCount() > 0 then
		ll_find = dw_lista.find("cod_labor='" + ls_cod_labor + "'", 1, dw_lista.RowCount())
		
		if ll_find > 0 then
			dw_lista.SetRow(ll_find)
			dw_lista.ScrollToRow(ll_find)
			dw_lista.SelectRow(0, false)
			dw_lista.SelectRow(ll_find, true)
		end if
	end if
	
	f_mensaje("Cambios Guardados satisfactoriamente", "")
ELSE 
	ROLLBACK USING SQLCA;
END IF

	
	
end event

on w_ope003_labor_ejecutor.create
int iCurrent
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
this.dw_lista=create dw_lista
this.st_producibles=create st_producibles
this.dw_producibles=create dw_producibles
this.uo_search=create uo_search
this.dw_master=create dw_master
this.dw_labor_ejecutor=create dw_labor_ejecutor
this.dw_consumibles=create dw_consumibles
this.st_consumibles=create st_consumibles
this.st_ejecutores=create st_ejecutores
this.st_datos_generales=create st_datos_generales
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
this.Control[iCurrent+2]=this.st_producibles
this.Control[iCurrent+3]=this.dw_producibles
this.Control[iCurrent+4]=this.uo_search
this.Control[iCurrent+5]=this.dw_master
this.Control[iCurrent+6]=this.dw_labor_ejecutor
this.Control[iCurrent+7]=this.dw_consumibles
this.Control[iCurrent+8]=this.st_consumibles
this.Control[iCurrent+9]=this.st_ejecutores
this.Control[iCurrent+10]=this.st_datos_generales
end on

on w_ope003_labor_ejecutor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
destroy(this.st_producibles)
destroy(this.dw_producibles)
destroy(this.uo_search)
destroy(this.dw_master)
destroy(this.dw_labor_ejecutor)
destroy(this.dw_consumibles)
destroy(this.st_consumibles)
destroy(this.st_ejecutores)
destroy(this.st_datos_generales)
end on

event ue_insert;call super::ue_insert;Long  ll_row

if idw_1 = dw_master then
	this.event ue_update_request()
	
	dw_master.Reset()
	
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_master.ii_update = 1 or &
	dw_labor_ejecutor.ii_update = 1 or &
	dw_consumibles.ii_update = 1 or &
	dw_producibles.ii_update = 1 THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	END IF
END IF

end event

event ue_print;OpenSheet (w_OPE003_labor_ejecutor_rpt, This, 0, layered!)

end event

event ue_update_pre;call super::ue_update_pre;//--VERIFICACION Y ASIGNACION DE LABORES Y EJECUTORES

ib_update_check = False	

if not gnvo_app.of_row_Processing( dw_master ) then return
if not gnvo_app.of_row_Processing( dw_labor_ejecutor ) then return
if not gnvo_app.of_row_Processing( dw_consumibles ) then return
if not gnvo_app.of_row_Processing( dw_producibles ) then return


dw_master.of_set_flag_replicacion()
dw_labor_ejecutor.of_set_flag_replicacion()
dw_consumibles.of_set_flag_replicacion()
dw_producibles.of_set_flag_replicacion()

ib_update_check = True
end event

event ue_refresh;call super::ue_refresh;dw_lista.retrieve(gs_user)

dw_master.SetFocus()


end event

type dw_lista from u_dw_abc within w_ope003_labor_ejecutor
integer y = 100
integer width = 1554
integer height = 1932
integer taborder = 30
string dataobject = "d_labor_list_tbl"
end type

event ue_output;call super::ue_output;if al_row <= 0 then return



parent.event dynamic ue_retrieve_labor(this.object.cod_labor[al_row])
end event

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
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

type st_producibles from statictext within w_ope003_labor_ejecutor
integer x = 3557
integer y = 1324
integer width = 1984
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 67108864
long backcolor = 8388608
boolean enabled = false
string text = "Articulos producibles"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_producibles from u_dw_abc within w_ope003_labor_ejecutor
integer x = 3557
integer y = 1404
integer width = 1984
integer height = 600
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_producibles_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1		
ii_rk[1] = 1

idw_mst = dw_master

is_mastdet = 'd'
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

event itemchanged;call super::itemchanged;this.Accepttext()

String 	ls_desc_art, ls_und, ls_cnta_prsp, ls_cod_clase, ls_desc_clase
Long 		ll_count

CHOOSE CASE dwo.name
	CASE "cod_art"
		SELECT a1.desc_art, a1.und, a2.cnta_prsp_egreso, ac.cod_clase, ac.desc_clase
		INTO  :ls_desc_art, :ls_und, :ls_cnta_prsp, :ls_cod_clase, :ls_desc_clase
		FROM  articulo 				a1,
			   articulo_sub_Categ 	a2,
				articulo_clase			ac
		WHERE a1.sub_cat_Art = a2.cod_sub_cat
		  and a1.cod_clase	= ac.cod_clase
		  and a1.cod_art= :data 
		  and a1.flag_estado = '1' ;
		
		IF SQLCA.SQLCode = 100 then
			Messagebox('Aviso','Codigo de Articulo no existe o no esta activo',StopSign!)
			this.object.cod_Art 			[row] = gnvo_app.is_null
			this.object.desc_art 		[row] = gnvo_app.is_null
			this.object.und 				[row] = gnvo_app.is_null
			this.object.cnta_prsp		[row] = gnvo_app.is_null
			
			this.object.cod_clase		[row] = gnvo_app.is_null
			this.object.desc_clase		[row] = gnvo_app.is_null

			return 1
		end if
		
		this.object.desc_art	[row] =  ls_desc_art
		this.object.und		[row] =  ls_und
		
		// Actualiza la cuenta presupuestal, si fuera necesario
		this.object.cnta_prsp	[row] = ls_cnta_prsp

		this.object.cod_clase	[row] = ls_cod_clase
		this.object.desc_clase	[row] = ls_desc_clase
		
		this.Sort()
		this.GroupCalc()

	CASE 'cnta_prsp'
		
		SELECT count(*)
			INTO :ll_count
		FROM presupuesto_cuenta
		WHERE cnta_prsp=:data 
		  and flag_estado = '1';
	
		IF SQLCA.SQLCode = 100 then
			Messagebox('Aviso','Cuenta Presupuestal no existe o no esta activo',StopSign!)
			this.object.cnta_prsp[row] = gnvo_app.is_null
			return 1
		end if
		
END CHOOSE
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;Long   ll_row
String ls_cnta_prsp

ll_row = dw_master.getrow()

dw_master.accepttext()
ls_cnta_prsp = dw_master.object.cnta_prsp [ll_row]

this.object.cnta_prsp [al_row] = ls_cnta_prsp


end event

event ue_display;call super::ue_display;boolean 			lb_ret
string 			ls_codigo, ls_data, ls_sql, ls_und, ls_cnta_prsp
str_articulo	lstr_articulo
choose case lower(as_columna)
	case "cod_art"
		
		lstr_articulo = gnvo_almacen.of_get_producibles()
		
		if lstr_articulo.b_return then
			
			this.object.cod_art		[al_row] = lstr_articulo.cod_art
			this.object.desc_art		[al_row] = lstr_articulo.desc_art
			this.object.und			[al_row] = lstr_articulo.und

			this.object.cod_clase	[al_row] = lstr_articulo.cod_clase
			this.object.desc_clase	[al_row] = lstr_articulo.desc_clase

			// Actualiza la cuenta presupuestal, si fuera necesario
			this.object.cnta_prsp	[al_row] = lstr_articulo.cnta_prsp_egreso
			
			this.Sort()
			this.GroupCalc()
			
			this.ii_update = 1
		end if
		
		
		
	case "cnta_prsp"
		ls_sql = "SELECT PC.CNTA_PRSP AS CODIGO_CNTA_PRSP, "&   
				 + "PC.DESCRIPCION AS DESC_CNTA_PRSP "&   
				 + "FROM  PRESUPUESTO_CUENTA PC " &
				 + "WHERE PC.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose

//IF Getrow() = 0 THEN Return
//String ls_name,ls_prot
//str_seleccionar lstr_seleccionar
//
//ls_name = dwo.name
//ls_prot = this.Describe( ls_name + ".Protect")
//
//if ls_prot = '1' then return
//
//CHOOSE CASE dwo.name
//	CASE ''
//	
//		lstr_seleccionar.s_seleccion = 'S'
//		lstr_seleccionar.s_sql = " "    
//	
//		OpenWithParm(w_seleccionar,lstr_seleccionar)
//		
//		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//		IF lstr_seleccionar.s_action = "aceptar" THEN
//			
//			this.object. 	[row] = lstr_seleccionar.param1[1]
//			this.object.	[row] = lstr_seleccionar.param2[1]
//			this.object.		[row] = lstr_seleccionar.param3[1]
//			
//			// Actualiza la cuenta presupuestal, si fuera necesario
//			this.object.cnta_prsp	[row] = lstr_seleccionar.param4[1]
//			
//			this.ii_update = 1
//		END IF
//		
//	CASE ''
//	
//		lstr_seleccionar.s_seleccion = 'S'
//		lstr_seleccionar.s_sql =  ""
//	
//		OpenWithParm(w_seleccionar,lstr_seleccionar)
//		
//		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//		IF lstr_seleccionar.s_action = "aceptar" THEN
//			
//			this.object.	[row] = lstr_seleccionar.param1[1]
//			this.ii_update = 1
//		END IF
//END CHOOSE
//
//
end event

type uo_search from n_cst_search within w_ope003_labor_ejecutor
event destroy ( )
integer width = 1554
integer taborder = 30
end type

on uo_search.destroy
call n_cst_search::destroy
end on

event ue_post_editchanged;call super::ue_post_editchanged;if dw_lista.RowCount() = 0 then
	dw_master.Reset()
	dw_labor_ejecutor.Reset()
	dw_consumibles.Reset()
	dw_producibles.Reset()
//else
//	dw_lista.setRow(1)
//	dw_lista.ScrollTorow(1)
//	dw_lista.SelectRow(0, false)
//	dw_lista.SelectRow(1, true)
//	
//  	parent.event ue_retrieve_labor(dw_lista.object.cod_labor[1])
end if

//dw_master.ResetUpdate()
//dw_labor_ejecutor.ResetUpdate()
//dw_consumibles.ResetUpdate()
//dw_producibles.ResetUpdate()
//	
//dw_master.ii_update = 0
//dw_labor_ejecutor.ii_update = 0
//dw_consumibles.ii_update = 0
//dw_producibles.ii_update = 0



end event

type dw_master from u_dw_abc within w_ope003_labor_ejecutor
integer x = 1559
integer y = 88
integer width = 2583
integer height = 792
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_labor_ff"
boolean vscrollbar = false
end type

event constructor;call super::constructor;THIS.EVENT POST ue_val_param()

is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_det  = dw_labor_ejecutor	// dw_detail
end event

event ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event ue_insert_pre;
this.object.flag_estado 			[al_row] = '1'
this.object.flag_transporte 		[al_row] = 'N'
this.object.flag_marcador 			[al_row] = '0'
this.object.flag_incidencia 		[al_row] = '0'
this.object.flag_jornal_destajo 	[al_row] = '0'
this.object.flag_maq_mo 			[al_row] = 'O'


dw_labor_ejecutor.reset()
dw_consumibles.reset()
dw_producibles.reset()


dw_labor_ejecutor.ResetUpdate()
dw_consumibles.ResetUpdate()
dw_producibles.ResetUpdate()

dw_labor_ejecutor.ii_update 	= 0
dw_consumibles.ii_update 		= 0
dw_producibles.ii_update 		= 0

is_Action = 'new'

this.SetColumn('cod_fase')


end event

event itemchanged;call super::itemchanged;Integer li_count
String  ls_cnta,ls_descripcion,ls_null
SetNull(ls_null)

This.accepttext( )

CHOOSE CASE dwo.name
	 // Busca si cuenta contable existe
	 CASE 'cod_Etapa'
			select count(*) 
				into :li_count 
			from labor_etapa
			where cod_etapa = :data;
			
			if li_count = 0 then
				Messagebox ('Aviso','Código de actividad no existe, Verifique!')
				this.object.concepto_rrhh [row] = ls_null
				Return 1
			end if
	
	 CASE 'sub_cat_serv_3ro'
			select a.cnta_prsp_egreso, b.descripcion
				into :ls_cnta, :ls_descripcion
			from 	articulo_sub_Categ a,
					presupuesto_cuenta b	
			where a.cnta_prsp_egreso = b.cnta_prsp (+)
			  and cod_sub_cat = :data
			  and NVL(a.flag_servicio, '0') = '1';
			
			if SQLCA.SQlcode = 100 then
				Messagebox ('Aviso','Código de Servicio no existe no existe, Verifique!')
				this.object.sub_cat_serv_3ro 	[row] = ls_null
				this.object.cnta_prsp_3ro 		[row] = ls_null
				this.object.desc_cnta_prsp_3ro[row] = ls_null
				Return 1
			end if
			
			this.object.cnta_prsp_3ro 		[row] = ls_cnta
			this.object.descripcion_1 		[row] = ls_descripcion
			
	CASE 'concepto_rrhh'
			select count(*) into :li_count from concepto
			 where (concep      = :data )  and 
					 (flag_estado = '1'   ) ;
			
			if li_count = 0 then
				Messagebox ('Aviso','Concepto No existe Verifique!')
				SetNull(ls_null)
				this.object.concepto_rrhh [row] = ls_null
				Return 1
			end if
			
	CASE 'cnta_prsp'
	
		SELECT descripcion
			INTO :ls_descripcion
		FROM presupuesto_cuenta
		WHERE cnta_prsp = :data 
		  and flag_Estado = '1';
					
		IF SQLCA.sqlcode = 100 THEN
			Messagebox('Aviso','Cuenta Presupuestal Propia No existe o no existe, Verifique! ',StopSign!)
			This.object.cnta_prsp   [row] = ls_null
			This.object.descripcion [row] = ls_null
			Return 1
		END IF
		
		This.object.descripcion [row] = ls_descripcion				 
			
	CASE 'cnta_prsp_3ro'
		
		SELECT descripcion
			INTO :ls_descripcion
		FROM presupuesto_cuenta
		WHERE cnta_prsp = :data 
		  and flag_Estado = '1';
					
		IF SQLCA.sqlcode = 100 THEN
			Messagebox('Aviso','Cuenta Presupuestal de terceros No existe o no existe, Verifique! ',StopSign!)
			This.object.cnta_prsp   		[row] = ls_null
			This.object.desc_cnta_prsp_3ro[row] = ls_null
			Return 1
		END IF
		
		This.object.desc_cnta_prsp_3ro [row] = ls_descripcion				 

			
	CASE 'cnta_prsp_insm'
		
		SELECT descripcion
			INTO :ls_descripcion
		FROM presupuesto_cuenta
		WHERE cnta_prsp = :data 
		  and flag_Estado = '1';
					
		IF SQLCA.sqlcode = 100 THEN
			Messagebox('Aviso','Cuenta Presupuestal de terceros No existe o no existe, Verifique! ',StopSign!)
			This.object.cnta_prsp  [row] = ls_null
			This.object.descp_insm [row] = ls_null
			Return 1
		END IF
		
		This.object.descp_insm [row] = ls_descripcion
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event ue_display;call super::ue_display;string ls_codigo, ls_data, ls_sql, ls_cod_fase, ls_data2, ls_data3

choose case lower(as_columna)
	CASE "cod_fase"
		ls_sql = "SELECT cod_fase AS codigo_fase, " &
			  	 + "desc_fase AS descripcion_fase " &
			  	 + "FROM labor_fase " 
								  
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cod_fase		[al_row] = ls_codigo
			this.object.desc_fase	[al_row] = ls_data
			this.ii_update = 1
		end if

		
	CASE "cod_etapa"
		ls_cod_fase = this.object.cod_fase [al_row]
		
		if trim(ls_cod_fase) = '' or IsNull(ls_cod_fase) then
			MessageBox('Error', 'Debe especificar un codigo de Proceso', StopSign!)
			this.setColumn("cod_fase")
			this.setFocus()
			return
		end if
		
		ls_sql = "SELECT cod_etapa AS codigo_etapa, " &
			  	 + "DESC_etapa AS descripcion_etapa " &
			  	 + "FROM labor_etapa " &
			  	 + "WHERE COD_FASE = '" + ls_cod_fase + "'"
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cod_etapa	[al_row] = ls_codigo
			this.object.desc_etapa	[al_row] = ls_data
			this.ii_update = 1
		end if

	CASE "sub_cat_serv_3ro"
		ls_sql = "SELECT A1.COD_SUB_CAT AS CODIGO_SUB_CAT, " &
				 + " 	 	  A1.DESC_SUB_CAT AS DESCRIPCION_SUB_CAT, " &
				 + "		  A1.CNTA_PRSP_EGRESO AS CNTA_PRSP, " &
				 + "		  PC.DESCRIPCION AS DESCRIPCION_CNTA_PRSP " &
				 + "	FROM articulo_sub_categ A1, " &
				 + "		  PRESUPUESTO_CUENTA PC " &
				 + "WHERE PC.CNTA_PRSP (+) = A1.CNTA_PRSP_EGRESO " &
				 + "  AND PC.FLAG_ESTADO = '1' " &
				 + "  AND NVL(A1.FLAG_SERVICIO,'0') = '1' "
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '2') then
			this.object.sub_cat_serv_3ro			[al_row] = ls_codigo
			this.object.desc_sub_cat_serv_3ro	[al_row] = ls_data
			this.object.CNTA_PRSP_3ro				[al_row] = ls_data2
			this.object.desc_cnta_prsp_3ro		[al_row] = ls_data3
			this.ii_update = 1
		end if

	CASE "concepto_rrhh"
		ls_sql = 'SELECT CONCEPTO.CONCEP 	   AS CODIGO	  ,'&
				 + 'CONCEPTO.DESC_CONCEP AS DESCRIPCION  '&
				 + 'FROM CONCEPTO '&
				 + "WHERE CONCEPTO.FLAG_ESTADO = '1'"
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.concepto_rrhh	[al_row] = ls_codigo
			this.object.desc_concepto	[al_row] = ls_data
			this.ii_update = 1
		end if

	CASE "cnta_prsp","cnta_prsp_3ro","cnta_prsp_insm"
		
		ls_sql = "SELECT PC.CNTA_PRSP AS CUENTA_PPTTO, "&
				 + "		  PC.DESCRIPCION AS DESCRIPCION "&
				 + "FROM PRESUPUESTO_CUENTA PC " &
				 + "WHERE PC.FLAG_ESTADO = '1'"
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			IF lower(as_columna) = "cnta_prsp" THEN
				this.object.cnta_prsp	[al_row] = ls_codigo
				this.object.descripcion	[al_row] = ls_data
			ELSEIF lower(as_columna) = "cnta_prsp_3ro" THEN
				this.object.cnta_prsp_3ro		[al_row] = ls_codigo
				this.object.desc_cnta_prsp_3ro[al_row] = ls_data
			ELSEIF lower(as_columna) = "cnta_prsp_insm" THEN
				this.object.cnta_prsp_insm	[al_row] = ls_codigo
				this.object.descp_insm		[al_row] = ls_data
			END IF
			ii_update = 1
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

type dw_labor_ejecutor from u_dw_abc within w_ope003_labor_ejecutor
integer x = 1559
integer y = 972
integer width = 1984
integer height = 344
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_labor_ejecutor_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_dwform = 'tabular'
ii_ck[1] = 1			// columnas de lectura de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

ii_ss = 1
idw_mst = dw_master
is_mastdet = 'd'
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;// Asigna como activo al flag de estado

this.object.flag_estado [al_row] = '1'
this.object.cod_moneda 	[al_row] = gnvo_app.is_soles
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cod_moneda'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MONEDA.COD_MONEDA AS CODIGO,'&
						 								 +'MONEDA.DESCRIPCION AS DESCRIPCION  '&
				  										 +'FROM MONEDA '

				

										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_moneda',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
				
END CHOOSE




end event

event itemchanged;call super::itemchanged;Accepttext()
Integer li_count
String  ls_null

This.accepttext( )

CHOOSE CASE dwo.name

		 CASE 'cod_moneda'
				select count(*) into :li_count
              from moneda
				 where (cod_moneda = :data) ;
				 
				if li_count = 0 then 
					SetNull(ls_null)					
					This.object.cod_moneda [row] = ls_null
					Return 1
				end if
END CHOOSE



end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

type dw_consumibles from u_dw_abc within w_ope003_labor_ejecutor
integer x = 1559
integer y = 1408
integer width = 1984
integer height = 600
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_insumos_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1		
ii_rk[1] = 1

idw_mst = dw_master

is_mastdet = 'd'
end event

event itemchanged;call super::itemchanged;this.Accepttext()

String 	ls_desc_art, ls_und, ls_cnta_prsp, ls_null
Long 		ll_count

SetNull(ls_null)

CHOOSE CASE dwo.name
	CASE "cod_art"
		SELECT a1.desc_art, a1.und, a2.cnta_prsp_egreso
		INTO  :ls_desc_art, :ls_und, :ls_cnta_prsp
		FROM  articulo a1,
			   articulo_sub_Categ a2
		WHERE a1.sub_cat_Art = a2.cod_sub_cat
		  and a1.cod_art= :data 
		  and a1.flag_estado = '1' ;
		
		IF SQLCA.SQLCode = 100 then
			Messagebox('Aviso','Codigo de Articulo no existe o no esta activo',StopSign!)
			this.object.cod_Art 			[row] = ls_null
			this.object.desc_art 		[row] = ls_null
			this.object.und 				[row] = ls_null
			this.object.cnta_prsp		[row] = ls_null
			return 1
		end if
		
		this.object.desc_art	[row] =  ls_desc_art
		this.object.und		[row] =  ls_und
		
		// Actualiza la cuenta presupuestal, si fuera necesario
		//IF is_flag_cnta_prsp='1' THEN
		this.object.cnta_prsp	[row] = ls_cnta_prsp
		//END IF
		
	CASE 'cnta_prsp'
		
		SELECT count(*)
			INTO :ll_count
		FROM presupuesto_cuenta
		WHERE cnta_prsp=:data 
		  and flag_estado = '1';
	
		IF SQLCA.SQLCode = 100 then
			Messagebox('Aviso','Cuenta Presupuestal no existe o no esta activo',StopSign!)
			this.object.cnta_prsp[row] = ls_null
			return 1
		end if
		
END CHOOSE
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;Long   ll_row
String ls_cnta_prsp

dw_master.accepttext()

this.setColumn('cod_art')


end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event ue_display;call super::ue_display;boolean 			lb_ret
string 			ls_codigo, ls_data, ls_sql, ls_und, ls_cnta_prsp
str_articulo	lstr_articulo
choose case lower(as_columna)
	case "cod_art"
		lstr_articulo = gnvo_almacen.of_get_articulos_all()
		
		if lstr_articulo.b_return then
			
			this.object.cod_art		[al_row] = lstr_articulo.cod_art
			this.object.desc_art		[al_row] = lstr_articulo.desc_art
			this.object.und			[al_row] = lstr_articulo.und
			this.object.cod_clase	[al_row] = lstr_articulo.cod_clase
			this.object.desc_clase	[al_row] = lstr_articulo.desc_clase
			
			// Actualiza la cuenta presupuestal, si fuera necesario
			this.object.cnta_prsp	[al_row] = lstr_articulo.cnta_prsp_egreso
			
			//Ordeno
			this.Sort()
			this.GroupCalc()
			
			this.ii_update = 1
		end if
		
		
		
	case "cnta_prsp"
		ls_sql = "SELECT PC.CNTA_PRSP AS CODIGO_CNTA_PRSP, "&   
				 + "PC.DESCRIPCION AS DESC_CNTA_PRSP "&   
				 + "FROM  PRESUPUESTO_CUENTA PC " &
				 + "WHERE PC.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
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

type st_consumibles from statictext within w_ope003_labor_ejecutor
integer x = 1559
integer y = 1328
integer width = 1984
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 67108864
long backcolor = 8388608
boolean enabled = false
string text = "Articulos Consumibles"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_ejecutores from statictext within w_ope003_labor_ejecutor
integer x = 1559
integer y = 888
integer width = 1984
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 67108864
long backcolor = 8388608
boolean enabled = false
string text = "Ejecutores por labor"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_datos_generales from statictext within w_ope003_labor_ejecutor
integer x = 1559
integer y = 4
integer width = 1984
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 67108864
long backcolor = 8388608
boolean enabled = false
string text = "Datos generales"
alignment alignment = center!
boolean focusrectangle = false
end type

