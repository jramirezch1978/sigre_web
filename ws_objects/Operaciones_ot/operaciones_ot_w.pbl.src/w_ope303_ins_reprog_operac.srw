$PBExportHeader$w_ope303_ins_reprog_operac.srw
forward
global type w_ope303_ins_reprog_operac from w_abc_mastdet
end type
end forward

global type w_ope303_ins_reprog_operac from w_abc_mastdet
integer width = 3017
integer height = 1936
string title = "Ingreso de operaciones (OPE303-ins)"
string menuname = "m_abc_master"
end type
global w_ope303_ins_reprog_operac w_ope303_ins_reprog_operac

type variables
String  is_graba, is_opcion,is_nro_orden

end variables

on w_ope303_ins_reprog_operac.create
call super::create
if this.MenuName = "m_abc_master" then this.MenuID = create m_abc_master
end on

on w_ope303_ins_reprog_operac.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;str_parametros sl_recep
String  ls_oper_sec
Integer li_nro_operacion

sl_recep         = Message.PowerObjectParm
is_nro_orden     = sl_recep.field_ret_s[1]
is_opcion        = sl_recep.field_ret_s[2]
li_nro_operacion = sl_recep.field_ret_i[1]

// Cuando se trata de un ingreso
IF is_opcion = 'I' THEN
	
	is_graba = 'N'
	THIS.EVENT ue_insert()
// Cuando se trata de una modificacion de materiales
ELSEIF is_opcion = 'M' THEN
	dw_master.Retrieve( is_nro_orden, li_nro_operacion )
	//recupero aRticulos de operación
	IF dw_master.Rowcount() > 0 THEN
		ls_oper_sec = dw_master.GetItemString( 1, 'oper_sec')	
		dw_detail.Retrieve( ls_oper_sec )
	END IF

END IF

end event

event ue_update;//override script 
Boolean lbo_ok = TRUE

dw_master.AcceptText()
dw_detail.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF
is_graba = 'S'

end event

event resize;// Overrride
end event

event ue_update_pre;call super::ue_update_pre;//actualiza oper_sec de operaciones
Long   ll_inicio,ln_nro_operacion
String ls_nro_oper_sec,ls_mensaje
dwItemStatus ldis_status

For ll_inicio = 1 TO dw_master.Rowcount() 
	 ldis_status = dw_master.GetItemStatus(ll_inicio,0,Primary!)

	 IF ldis_status = NewModified! THEN
		 //incrementar nro de opersec
		 IF f_num_operaciones(ls_nro_oper_sec,ls_mensaje) = FALSE THEN
			 ib_update_check = FALSE 
			 SetNull(ls_nro_oper_sec)
 			 dw_master.object.oper_sec [ll_inicio] = ls_nro_oper_sec	
			 ROLLBACK ;
			 Messagebox('Aviso',ls_mensaje)
		    Return
		 ELSE
		    //actualizo dw	
			 dw_master.object.oper_sec [ll_inicio] = ls_nro_oper_sec	
		 END IF
			
	 END IF

Next
end event

type dw_master from w_abc_mastdet`dw_master within w_ope303_ins_reprog_operac
integer x = 0
integer y = 12
integer width = 2944
integer height = 948
string dataobject = "d_abc_operaciones_gantt_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_dk[1] = 1 	      	// columnas que se pasan al detalle

end event

event dw_master::ue_insert_pre;String  ls_cod_campo ,ls_desc_campo ,ls_cencos ,ls_corr_corte,ls_doc_ot
Date    ld_fec_nac_plnt
Decimal ld_has_netas, ld_has_totales
Long    ll_count, ln_nro_operacion

SELECT cc.cod_campo   , cc.fec_nac_plnt ,cc.has_netas, 
		 cc.has_totales , c.desc_campo    ,c.cencos    ,
		 cc.corr_corte
  INTO :ls_cod_campo  ,:ld_fec_nac_plnt, :ld_has_netas, 
	    :ld_has_totales,:ls_desc_campo  , :ls_cencos   ,
		 :ls_corr_corte
  FROM campo_ciclo cc, campo c
 WHERE cc.cod_campo = c.cod_campo   AND
	  	 cc.nro_orden = :is_nro_orden ;


// Buscando maxima numero de operacion, del correlativo de corte en mencion
SELECT count(*)
  INTO :ll_count
  FROM operaciones
 WHERE nro_orden = :is_nro_orden ;
 
select doc_ot into :ls_doc_ot from prod_param where reckey = '1' ;

IF ll_count > 0 THEN
	SELECT Max( nro_operacion ) + 10
	  INTO :ln_nro_operacion
	  FROM operaciones
	 WHERE nro_orden = :is_nro_orden ;
ELSE
	ln_nro_operacion = 10
END IF 

this.SetItem( al_row, 'nro_operacion', ln_nro_operacion ) // Numero de operacion
this.SetItem( al_row, 'flag_estado', '3')   	 				 // Estado pendiente
this.SetItem( al_row, 'flag_pre', 'I')    				    // Flag de precedencia
this.SetItem( al_row, 'fec_inicio_est', today() )    	    // Fecha de inicio estimada
this.SetItem( al_row, 'fec_inicio', today() )    	       // Fecha de inicio 
this.SetItem( al_row, 'dias_para_inicio', 0)              // dias para inicio
this.SetItem( al_row, 'dias_duracion_proy', 0) 	          // dias duracion proyectada
this.SetItem( al_row, 'nro_personas', 1) 		             // dias duracion proyectada
this.SetItem( al_row, 'dias_holgura', 0) 		             // dias de holgura
this.SetItem( al_row, 'nro_orden', is_nro_orden )
this.SetItem( al_row, 'tipo_orden', ls_doc_ot )
this.SetItem( al_row, 'corr_corte', ls_corr_corte )
this.SetItem( al_row, 'campo_ciclo_cod_campo', ls_cod_campo )
this.SetItem( al_row, 'campo_ciclo_has_totales', ld_has_totales )
this.SetItem( al_row, 'campo_ciclo_has_netas', ld_has_netas )
this.SetItem( al_row, 'campo_ciclo_fec_nac_plnt', ld_fec_nac_plnt )
this.SetItem( al_row, 'campo_desc_campo', ls_desc_campo )
end event

event dw_master::doubleclicked;call super::doubleclicked;String ls_name,ls_prot,ls_cod_labor
str_seleccionar lstr_seleccionar
Datawindow ldw
ldw = this

IF Getrow() = 0 THEN Return

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cod_labor'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT LABOR.COD_LABOR AS COD_LABOR, '&   
												 +'LABOR.DESC_LABOR AS DESCRIPCION, '&   
												 +'LABOR.UND AS UND '&   
												 +'FROM LABOR '&
												 +'WHERE LABOR.FLAG_ESTADO = 1'

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_labor',lstr_seleccionar.param1[1])
					Setitem(row,'desc_operacion',lstr_seleccionar.param2[1])
				END IF
		 CASE 'cod_ejecutor'
				ls_cod_labor = dw_master.object.cod_labor [dw_master.getrow()]
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT LABOR_EJECUTOR.COD_LABOR AS COD_LABOR, '&   
												 +'LABOR_EJECUTOR.COD_EJECUTOR AS COD_EJECUTOR '&   
												 +'FROM  LABOR_EJECUTOR '&
												 +'WHERE LABOR_EJECUTOR.COD_LABOR = '+"'"+ls_cod_labor+"'"
			

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_ejecutor',lstr_seleccionar.param2[1])
				END IF
				
END CHOOSE
end event

event dw_master::itemchanged;call super::itemchanged;String  ls_cod_labor, ls_cod_ejecutor, ls_desc_operacion, ls_codigo
DateTime ldt_fec_inicio
Long ll_count, ll_ult_oper
Integer li_colnum

this.ii_update = 1

CHOOSE CASE dwo.name
	    CASE 'nro_operacion'
				SELECT max(op.nro_operacion)
				INTO :ll_ult_oper
				FROM operaciones op
				WHERE op.corr_corte = is_corr_corte ;
				
				//this.SetItem( row, 'ult_operac', ll_ult_oper )
		 CASE 'cod_labor'
      		ls_codigo = data
				
				SELECT count(*)
				INTO :ll_count
				FROM labor
				WHERE cod_labor = :ls_codigo AND
						flag_estado ='1' ;
				
				IF ll_count > 0 THEN
					
					SELECT desc_labor
					INTO :ls_desc_operacion
					FROM labor
					WHERE cod_labor = :ls_codigo ;
					
					this.SetItem( row, 'desc_operacion', ls_desc_operacion )
					
				ELSE
					SetNull(ls_codigo)
					this.SetItem( row, 'cod_labor', ls_codigo )
				END IF 
				
		 CASE 'cod_ejecutor'
      		ls_cod_ejecutor = data
				ls_cod_labor = dw_master.object.cod_labor [dw_master.getrow()]
				
				SELECT count(*)
				INTO :ll_count
				FROM labor_ejecutor
				WHERE cod_labor = :ls_cod_labor AND
					    cod_ejecutor = :ls_cod_ejecutor  ;
				IF ll_count = 0 then
					SetNull(ls_cod_ejecutor)
					this.SetItem( row, 'cod_ejecutor', ls_cod_ejecutor )
				END IF ;
		 CASE 'fec_inicio'
			ldt_fec_inicio = this.object.fec_inicio[row]
			this.SetItem( row, 'fec_inicio_est', ldt_fec_inicio )
END CHOOSE

end event

event dw_master::ue_output(long al_row);call super::ue_output;//THIS.EVENT ue_retrieve_det(al_row)

end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;//idw_det.retrieve(aa_id[1])
end event

event dw_master::clicked;call super::clicked;String ls_oper_sec

IF row = 0 THEN RETURN


end event

event dw_master::itemerror;call super::itemerror;return 1
end event

type dw_detail from w_abc_mastdet`dw_detail within w_ope303_ins_reprog_operac
integer x = 14
integer y = 972
integer width = 2935
integer height = 740
string dataobject = "d_abc_art_mov_proy_gantt_tbl"
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_rk[1] = 1 	      	// columnas que recibimos del master

// 10 oper_sec


end event

event dw_detail::ue_insert_pre;Long ll_count, ll_row
DateTime ldt_fec_proyect
String ls_oper_cons_interno, ls_cencos, ls_oper_sec, ls_doc_ot, ls_nro_orden


// Captura el tipo de consumo interno
SELECT oper_cons_interno
INTO :ls_oper_cons_interno
FROM logparam
WHERE reckey = '1' ;
	
// Calcula el oper_sec
ls_oper_sec = dw_master.GetItemString(1, 'oper_sec')
ls_cencos 	= dw_master.GetItemString(1, 'cencos')

IF ISNULL( ls_oper_sec ) or trim(ls_oper_sec) = '' THEN
	messagebox('Aviso', 'Grabe primero master')
	return
END IF

select doc_ot into :ls_doc_ot from prod_param where reckey = '1' ;

// Captura de centro de costo
IF isnull(ls_cencos) OR ls_cencos='' THEN
	// captura centro de costo desde la orden de trabajo
	SELECT count(*) INTO :ll_count 
     FROM operaciones op, campo_ciclo cc, campo c
	 WHERE op.nro_orden = cc.nro_orden AND
		  	 cc.cod_campo = c.cod_campo  AND
			 op.oper_sec = :ls_oper_sec ;
			 
	IF ll_count>0 THEN
		SELECT c.cencos
		INTO :ls_cencos
		FROM operaciones op, campo_ciclo cc, campo c
		WHERE op.nro_orden = cc.nro_orden AND
				cc.cod_campo = c.cod_campo  AND
				op.oper_sec = :ls_oper_sec ;
	ELSE
		SELECT ot.cencos_slc
		INTO :ls_cencos
		FROM orden_trabajo ot
		WHERE ot.nro_orden = :is_nro_orden ; 
	END IF
		
END IF
	
	
ldt_fec_proyect = dw_master.GetItemDateTime( dw_master.GetRow(), 'fec_inicio')

this.SetItem(al_row, 'tipo_doc', ls_doc_ot )
this.SetItem(al_row, 'nro_doc', is_nro_orden)
this.SetItem(al_row, 'cod_origen', gs_origen )
this.SetItem(al_row, 'oper_sec', ls_oper_sec)
this.SetItem(al_row, 'flag_estado', '1')  // Pendiente
this.SetItem(al_row, 'tipo_mov', ls_oper_cons_interno)   // Consumo interno
this.SetItem(al_row, 'fec_registro', today() )   // Fecha del dia
this.SetItem(al_row, 'fec_proyect', ldt_fec_proyect )   // Fecha proyectada
this.SetItem(al_row, 'cencos', ls_cencos )   // Cencos
	
idw_mst.il_row = 1

end event

event dw_detail::doubleclicked;call super::doubleclicked;String ls_name, ls_prot, ls_cod_labor, ls_cod_art, ls_cnta_prsp_insm
str_seleccionar lstr_seleccionar
Datawindow ldw
ldw = this

IF Getrow() = 0 THEN Return

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cod_art'
				//ls_cod_labor = dw_master.object.cod_labor [dw_detail.getrow()]
				ls_cod_labor = dw_master.GetItemString(dw_master.GetRow(), 'cod_labor')
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_MTT_ART_X_LABOR.COD_ART AS CODIGO, '&   
												 +'VW_MTT_ART_X_LABOR.DESC_ART AS DESCRIPCION, '&   
												 +'VW_MTT_ART_X_LABOR.UND AS UNIDAD, '&   
												 +'VW_MTT_ART_X_LABOR.CNTA_PRSP_INSM AS CUENTA_PRESUP '&
												 +'FROM  VW_MTT_ART_X_LABOR '&
												 +'WHERE VW_MTT_ART_X_LABOR.COD_LABOR = '+"'"+ls_cod_labor+"'"    	
			

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_art',lstr_seleccionar.param1[1])
					Setitem(row,'nom_articulo',lstr_seleccionar.param2[1])
					Setitem(row,'articulo_und',lstr_seleccionar.param3[1])

					// Asignando cuenta presupuestal, en funcion al articulo y labor
					ls_cod_art = lstr_seleccionar.param1[1]
					ls_cod_labor = dw_master.GetItemString( dw_master.GetRow(), 'cod_labor' )

					SELECT cnta_prsp_insm
					INTO :ls_cnta_prsp_insm
					FROM labor_insumo
					WHERE cod_labor = :ls_cod_labor AND
							cod_art = :ls_cod_art ;
							
					this.Setitem(row, 'cnta_prsp', ls_cnta_prsp_insm )
				END IF

				
END CHOOSE
end event

event dw_detail::clicked;call super::clicked;Long ln_nro_operacion

IF is_opcion = 'I' THEN
	IF is_graba = 'N' THEN
		messagebox('Aviso', 'Grabe registros de cabecera previamente')
		dw_master.SetFocus()
	END IF
END IF
end event

event dw_detail::itemchanged;call super::itemchanged;accepttext()
end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

