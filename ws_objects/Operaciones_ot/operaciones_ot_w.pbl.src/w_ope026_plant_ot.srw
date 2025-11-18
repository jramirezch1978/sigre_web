$PBExportHeader$w_ope026_plant_ot.srw
forward
global type w_ope026_plant_ot from w_abc
end type
type dw_ext_plant from datawindow within w_ope026_plant_ot
end type
type dw_lista_corr_corte from u_dw_list_tbl within w_ope026_plant_ot
end type
type dw_master from u_dw_abc within w_ope026_plant_ot
end type
type dw_ext from datawindow within w_ope026_plant_ot
end type
end forward

global type w_ope026_plant_ot from w_abc
integer x = 5
integer y = 4
integer width = 2752
integer height = 1332
string title = "Mantenimiento de plantillas de OT (OPE026)"
string menuname = "m_master_lista_anular"
boolean resizable = false
event ue_recuperar ( string as_cod_plant )
dw_ext_plant dw_ext_plant
dw_lista_corr_corte dw_lista_corr_corte
dw_master dw_master
dw_ext dw_ext
end type
global w_ope026_plant_ot w_ope026_plant_ot

type variables
Integer  ii_colnum_dd2, ii_colnum_d2
DatawindowChild idw_child
long il_row
string is_corr_corte
end variables

forward prototypes
public subroutine wf_genera_plantilla_x_ot (string as_nro_doc, string as_cod_plantilla, string as_desc_plantilla, string as_ot_adm)
public function boolean wf_genera_copia_plantilla (string as_new_plantilla, string as_desc_plantilla, string as_cod_plantilla, string as_ot_adm)
public subroutine wf_ins_plant_x_plant (string as_plant_origen, string as_plant_destino)
end prototypes

event ue_recuperar(string as_cod_plant);dw_master.retrieve(as_cod_plant,gs_user)
//dw_detail.retrieve(as_cod_plant)
//dw_detdet.reset()
//dw_detdet_ingreso.reset()
//dw_detdet_desembolso.reset()

end event

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

//GENERAR CABECERA DE PLANTILLA //
insert into plant_prod
(cod_plantilla, desc_plantilla, flag_estado, ot_adm, tipo_riego)
VALUES(:as_new_plantilla, :as_desc_plantilla, '1', :as_ot_adm, '0') ;

//select :as_new_plantilla,:as_desc_plantilla,flag_estado,:as_ot_adm FROM plant_prod where cod_plantilla = :as_cod_plantilla ;
	
IF SQLCA.SQLCode = -1 THEN 
   ls_msj_err = SQLCA.SQLErrText
	lb_ret = FALSE
	GOTO SALIDA
END IF
	
//GENERA DETALLE DE PLANTILLA//
insert into plant_prod_oper
(nro_operacion   ,flag_pre      ,nro_precedencia,nro_dias_inicio,
 dias_duracion   ,desc_operacion,cantidad       ,cod_plantilla  ,
 flag_dias_inicio,cod_labor     ,cod_ejecutor   ,dias_holgura   ,
 nro_personas	  ,flag_marcador ,cencos			,flag_replicacion)
select nro_operacion   ,flag_pre      ,nro_precedencia,nro_dias_inicio  ,
		 dias_duracion   ,desc_operacion,cantidad       ,:as_new_plantilla,
 		 flag_dias_inicio,cod_labor     ,cod_ejecutor   ,dias_holgura     ,
		 nro_personas	  ,flag_marcador ,cencos			,'1'
  from plant_prod_oper where cod_plantilla = :as_cod_plantilla ;
	
	
IF SQLCA.SQLCode = -1 THEN 
   ls_msj_err = SQLCA.SQLErrText
	lb_ret = FALSE
	GOTO SALIDA
END IF
	
//GENERA INSUMOS 
insert into plant_prod_mov
(cod_plantilla, nro_operacion, cod_art, cantidad, flag_replicacion)
select :as_new_plantilla, nro_operacion, cod_art, cantidad, '0'
  from plant_prod_mov 
 where cod_plantilla = :as_cod_plantilla ;

IF SQLCA.SQLCode = -1 THEN 
   ls_msj_err = SQLCA.SQLErrText
	lb_ret = FALSE
	GOTO SALIDA
END IF

//GENERA ARTICULOS
insert into plant_prod_mov_ingreso
(cod_plantilla, nro_operacion, cod_art, cantidad, flag_replicacion)
select :as_new_plantilla, nro_operacion, cod_art, cantidad, '0' 
  from plant_prod_mov_ingreso 
 where cod_plantilla = :as_cod_plantilla ;

IF SQLCA.SQLCode = -1 THEN 
   ls_msj_err = SQLCA.SQLErrText
	lb_ret = FALSE
	GOTO SALIDA
END IF

//GENERA DESEMBOLSOS
insert into plant_prod_desembolso
(cod_plantilla, nro_desembolso, cod_moneda, concepto, importe, nro_operacion, flag_replicacion)
select :as_new_plantilla, nro_desembolso, cod_moneda, concepto, importe, nro_operacion, '0' 
  from plant_prod_desembolso 
 where cod_plantilla = :as_cod_plantilla ;

IF SQLCA.SQLCode = -1 THEN 
   ls_msj_err = SQLCA.SQLErrText
	lb_ret = FALSE
	GOTO SALIDA
END IF	

SALIDA:
if lb_ret then //graba
	//GRABA
	COMMIT ;
	Messagebox('Aviso','Se Culmino Generación de Plantilla '+as_new_plantilla)
else
	Rollback ;
	Messagebox('Aviso',ls_msj_err)
end if


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

on w_ope026_plant_ot.create
int iCurrent
call super::create
if this.MenuName = "m_master_lista_anular" then this.MenuID = create m_master_lista_anular
this.dw_ext_plant=create dw_ext_plant
this.dw_lista_corr_corte=create dw_lista_corr_corte
this.dw_master=create dw_master
this.dw_ext=create dw_ext
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ext_plant
this.Control[iCurrent+2]=this.dw_lista_corr_corte
this.Control[iCurrent+3]=this.dw_master
this.Control[iCurrent+4]=this.dw_ext
end on

on w_ope026_plant_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ext_plant)
destroy(this.dw_lista_corr_corte)
destroy(this.dw_master)
destroy(this.dw_ext)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(SQLCA)
////dw_detail.SetTransObject(SQLCA)
//dw_detdet.SetTransObject(SQLCA)
//dw_detdet_ingreso.SetTransObject(SQLCA)
//dw_detdet_desembolso.SetTransObject(SQLCA)



idw_1 = dw_master                   			// asignar dw corriente
//dw_detail.BorderStyle			= StyleRaised! 
//dw_detdet.BorderStyle 			= StyleRaised! // indicar dw_detdet como no activado
//dw_detdet_ingreso.BorderStyle = StyleRaised!

// bloquear modificaciones
dw_master.of_protect()         
//dw_detail.of_protect()
//dw_detdet.of_protect()
//dw_detdet_ingreso.of_protect()
////
//
//dw_detail.Getchild( "cod_ejecutor", idw_child )
//idw_child.settransobject(sqlca)

of_position_window(0,0)

//Help
//ii_help = 11



end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
//dw_detail.of_protect()
//dw_detdet.of_protect()
//dw_detdet_ingreso.of_protect()
//dw_detdet_desembolso.of_protect()

dw_master.of_column_protect("cod_plantilla")
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
//IF (dw_master.ii_update = 1         OR dw_detdet.ii_update = 1 OR dw_detail.ii_update = 1 OR &
//    dw_detdet_ingreso.ii_update = 1 OR dw_detdet_desembolso.ii_update = 1 ) THEN
IF (dw_master.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
//		dw_detdet.ii_update = 0
//		dw_detail.ii_update = 0
//		dw_detdet_ingreso.ii_update = 0
//		dw_detdet_desembolso.ii_update = 0
	END IF
END IF

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String  ls_msj

dw_master.AcceptText()
//dw_detail.AcceptText()
//dw_detdet.AcceptText()
//dw_detdet_ingreso.AcceptText()
//dw_detdet_desembolso.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msj = 'Error en Grabacion de Plantilla'
		GOTO SALIDA
	END IF
END IF

//IF dw_detail.ii_update = 1 THEN
//	IF dw_detail.Update() = -1 then		// Grabacion del detalle
//		lbo_ok = FALSE
//		ls_msj = 'Error en Grabacion de Movimientos'
//		GOTO SALIDA
//	END IF
//END IF
//
//IF	dw_detdet.ii_update = 1 AND lbo_ok = TRUE THEN
//	IF dw_detdet.Update() = -1 then		// Grabacion del detdet
//		lbo_ok = FALSE
//		ls_msj = 'Error en Grabacion en Articulos de Salida'
//		GOTO SALIDA
//	END IF
//END IF
//
//IF	dw_detdet_ingreso.ii_update = 1 AND lbo_ok = TRUE THEN
//	IF dw_detdet_ingreso.Update() = -1 then		// Grabacion del detdet
//		lbo_ok = FALSE
//		ls_msj = 'Error en Grabacion en Articulos de Ingreso'
//		GOTO SALIDA
//	END IF
//END IF
//
//IF	dw_detdet_desembolso.ii_update = 1 AND lbo_ok = TRUE THEN
//	IF dw_detdet_desembolso.Update() = -1 then		// Grabacion del detdet
//		lbo_ok = FALSE
//		ls_msj = 'Error en Grabacion en Desembolsos'
//		GOTO SALIDA
//	END IF
//END IF



IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
//	dw_detail.ii_update = 0
//	dw_detdet.ii_update = 0
//	dw_detdet_ingreso.ii_update = 0
//	dw_detdet_desembolso.ii_update = 0
ELSE 
	SALIDA:
	ROLLBACK USING SQLCA;
	Messagebox(ls_msj,'Se ha procedido al rollback',Exclamation!)
END IF	

end event

event ue_insert;call super::ue_insert;Long  ll_row

//IF idw_1 = dw_detdet AND dw_detail.il_row = 0 THEN
//	MessageBox("Error", "No ha seleccionado Operacion")
//	RETURN
//END IF
//
//IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
//	MessageBox("Error", "No ha seleccionado Plantilla")
//	RETURN
//END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
END IF



end event

event ue_print;//String      ls_cadena
//Str_cns_pop lstr_cns_pop
//
//IF idw_1.getrow() = 0 THEN RETURN
//
//ls_cadena = idw_1.Object.cod_plantilla[idw_1.getrow()]
//
//IF Isnull(ls_cadena) OR Trim(ls_cadena) = '' THEN RETURN
//
//lstr_cns_pop.arg[1] = ls_cadena
//lstr_cns_pop.arg[2] = gs_user
//lstr_cns_pop.arg[3] = gs_empresa
//lstr_cns_pop.arg[4] = ''
//lstr_cns_pop.arg[5] = ''
//lstr_cns_pop.arg[6] = ''
//
//lstr_cns_pop.dataobject = 'd_rpt_plant_operaciones_campo_ff'
//lstr_cns_pop.title = 'Plantilla de Operaciones por campo'
//lstr_cns_pop.width  = 3650
//lstr_cns_pop.height = 1950
//
//OpenSheetWithParm(w_rpt_pop, lstr_cns_pop, This, 2, Layered!)
//
//
//
//
//
end event

event resize;call super::resize;
//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detdet_desembolso.height = newheight - dw_detdet_desembolso.y - 10


end event

event ue_update_pre;call super::ue_update_pre;//--VERIFICACION Y ASIGNACION OPERACIONES
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

//--VERIFICACION Y ASIGNACION OPERACIONES
//IF f_row_Processing( dw_detail, "tabular") <> true then	
//	ib_update_check = False	
//	return
//ELSE
//	ib_update_check = True
//END IF

//--VERIFICACION Y ASIGNACION ARTICULOS
//IF f_row_Processing( dw_detdet, "tabular") <> true then	
//	ib_update_check = False	
//	return
//ELSE
//	ib_update_check = True
//END IF


//--VERIFICACION Y ASIGNACION ARTICULOS DE INGRESOS
//IF f_row_Processing( dw_detdet_ingreso, "tabular") <> true then	
//	ib_update_check = False	
//	return
//ELSE
//	ib_update_check = True
//END IF

//--VERIFICACION Y ASIGNACION DESEMBOLSO
//IF f_row_Processing( dw_detdet_desembolso, "tabular") <> true then	
//	ib_update_check = False	
//	return
//ELSE
//	ib_update_check = True
//END IF

dw_master.of_set_flag_replicacion()
//dw_detail.of_set_flag_replicacion()
//dw_detdet.of_set_flag_replicacion()
//dw_detdet_ingreso.of_set_flag_replicacion()
//dw_detdet_desembolso.of_set_flag_replicacion()
end event

event open;//Override
IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		
IF ib_update_check = FALSE THEN RETURN

sl_param.dw1     = 'd_abc_lista_plant_ot_x_usr'
sl_param.titulo  = 'Plantilla OT'
sl_param.tipo    = '1SQL'
sl_param.string1 =  ' WHERE ("VW_OPE_PLANT_OT_X_USR"."COD_USR" = '+"'"+gs_user+"'"+')    '&
						 +'ORDER BY "VW_OPE_PLANT_OT_X_USR"."COD_PLANTILLA" DESC  '

sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	dw_master.Retrieve(sl_param.field_ret[1])
	TriggerEvent ('ue_modify')
END IF

end event

type dw_ext_plant from datawindow within w_ope026_plant_ot
event ue_tecla pbm_dwnkey
boolean visible = false
integer x = 1719
integer y = 32
integer width = 1097
integer height = 224
integer taborder = 70
boolean titlebar = true
string title = "Plantilla Origen"
string dataobject = "d_abc_ext_plantilla_origen_tbl"
boolean border = false
boolean livescroll = true
end type

event ue_tecla;
IF key = KeyEscape! THEN
	Long   ll_count 
	String ls_data
	
	This.Accepttext()
	
	ls_data = this.object.cod_plantilla [1]
	
	select count(*) into :ll_count from plant_prod where cod_plantilla = :ls_data ;
	
	IF ll_count > 0 THEN
		This.Visible = FALSE
	ELSE
		Messagebox('Aviso','Plantilla No Existe Verifique!')
	END IF
	
END IF
end event

event constructor;Settransobject(sqlca)
end event

event itemchanged;Accepttext()
end event

event itemerror;RETURN 1
end event

type dw_lista_corr_corte from u_dw_list_tbl within w_ope026_plant_ot
boolean visible = false
integer x = 3008
integer y = 1556
integer width = 1280
integer height = 472
integer taborder = 50
string dragicon = "H:\Source\ICO\row2.ico"
boolean bringtotop = true
string dataobject = "d_campo_ciclo_tbl"
end type

event clicked;call super::clicked;IF row = 0 THEN RETURN
is_corr_corte = dw_lista_corr_corte.GetItemString(row,"campo_ciclo_corr_corte")
this.drag(begin!)

end event

event constructor;call super::constructor;ii_ck[1] = 1          // columnas de lectrua de este dw
end event

event itemerror;call super::itemerror;Return 1
end event

type dw_master from u_dw_abc within w_ope026_plant_ot
integer x = 32
integer y = 24
integer width = 2674
integer height = 1120
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_plant_ot_ff"
end type

event constructor;call super::constructor; is_mastdet = 'm'       // 'm' = master sin detalle (default), 'd' =  detalle,
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'tabular'  // tabular, grid, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_det  = dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
//this.drag(begin!)

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return

String ls_name, ls_prot, ls_filter, ls_ot_adm
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
	CASE 'plant_prod'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT VW_MT_PLANT_PROD_USR.COD_PLANTILLA AS CODIGO, '&   
										 +'VW_MT_PLANT_PROD_USR.DESC_PLANTILLA  AS DESCRIPCION,  '&   
										 +'VW_MT_PLANT_PROD_USR.OT_ADM '&
										 +'FROM  VW_MT_PLANT_PROD_USR '&
										 +'WHERE VW_MT_PLANT_PROD_USR.COD_USR = '+"'"+gs_user+"'"    	
	
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'plant_prod',lstr_seleccionar.param1[1])
			Setitem(row,'desc_plant_prod',lstr_seleccionar.param2[1])
			this.ii_update = 1
		END IF
		
	CASE 'ot_adm'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT VW_CAM_USR_ADM.OT_ADM AS CODIGO, '&   
										 +'VW_CAM_USR_ADM.DESCRIPCION  AS DESCRIPCION  '&   
										 +'FROM  VW_CAM_USR_ADM '&
										 +'WHERE VW_CAM_USR_ADM.COD_USR = '+"'"+gs_user+"'"    	
	
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'ot_adm',lstr_seleccionar.param1[1])
			Setitem(row,'desc_ot_adm',lstr_seleccionar.param2[1])
			this.ii_update = 1
		END IF
	CASE 'ot_tipo'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT OT_TIPO.OT_TIPO AS CODIGO, '&   
										 +'OT_TIPO.DESCRIPCION  AS DESCRIPCION  '&   
										 +'FROM  OT_TIPO ' 	
	
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'ot_tipo',lstr_seleccionar.param1[1])
			Setitem(row,'desc_ot_tipo',lstr_seleccionar.param2[1])
			this.ii_update = 1
		END IF
		
	CASE 'cencos_slc'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = "SELECT CENCOS 	  AS CENCOS, " &
				 + "DESC_CENCOS AS DESCRIPCION "		&     	
				 + "FROM CENTROS_COSTO " &
				 + "WHERE CENTROS_COSTO.FLAG_ESTADO = '1' "
	
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'cencos_slc',lstr_seleccionar.param1[1])
			Setitem(row,'desc_cencos_slc',lstr_seleccionar.param2[1])
			this.ii_update = 1
		END IF
		
	CASE 'cencos_rsp'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = "SELECT CENCOS 	  AS CENCOS, " &
				 + "DESC_CENCOS AS DESCRIPCION "		&     	
				 + "FROM CENTROS_COSTO " &
				 + "WHERE CENTROS_COSTO.FLAG_ESTADO = '1' "
	
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'cencos_rsp',lstr_seleccionar.param1[1])
			Setitem(row,'desc_cencos_rsp',lstr_seleccionar.param2[1])
			this.ii_update = 1
		END IF
	CASE 'cod_maquina'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = "SELECT COD_MAQUINA AS CODIGO, "&
				 + "DESC_MAQ AS DESCRIPCION,"&
				 + "MAQUINA.FLAG_ESTADO AS ST "&
				 + "FROM MAQUINA "&
				 + "WHERE MAQUINA.FLAG_ESTADO = '1'"
	
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'cod_maquina',lstr_seleccionar.param1[1])
			Setitem(row,'desc_maq',lstr_seleccionar.param2[1])
			this.ii_update = 1
		END IF

				
END CHOOSE

end event

event itemchanged;call super::itemchanged;String ls_name, ls_prot, ls_grupo, ls_descripcion
Long ll_count
Integer li_size

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
	CASE 'plant_prod'
		SELECT count(*) INTO :ll_count
		FROM plant_prod
		WHERE cod_plantilla = :data ;
		
		IF ll_count > 0 THEN
			
			SELECT desc_plantilla
			INTO :ls_descripcion
			FROM plant_prod
			WHERE cod_plantilla = :data ;
	
			this.SetItem( row, 'desc_plant_prod', ls_descripcion)
			this.ii_update = 1
		ELSE
			MessageBox('Aviso','Plantilla Prod no existe')
			SetColumn("plant_prod")
			SetItem(1,"plant_prod","")
			SetItem(1,"desc_plant_prod","")
			return 1
		END IF

	CASE 'cencos_rsp'
		SELECT count(*) INTO :ll_count
		FROM centros_costo
		WHERE cencos = :data ;
		
		IF ll_count > 0 THEN
			
			SELECT desc_cencos
			INTO :ls_descripcion
			FROM centros_costo
			WHERE cencos = :data ;
	
			this.SetItem( row, 'desc_cencos_rsp', ls_descripcion)
			this.ii_update = 1
		ELSE
			MessageBox('Aviso','Centro de Costo Responsable no existe')
			SetColumn("cencos_rsp")
			SetItem(1,"cencos_rsp","")
			SetItem(1,"desc_cencos_rsp","")
			return 1
		END IF
	CASE 'cencos_slc'
		SELECT count(*) INTO :ll_count
		FROM centros_costo
		WHERE cencos = :data ;
		
		IF ll_count > 0 THEN
			
			SELECT desc_cencos
			INTO :ls_descripcion
			FROM centros_costo
			WHERE cencos = :data ;
	
			this.SetItem( row, 'desc_cencos_slc', ls_descripcion)
			this.ii_update = 1
		ELSE
			MessageBox('Aviso','Centro de Costo Solicitante no existe')
			SetColumn("cencos_slc")
			SetItem(1,"cencos_slc","")
			SetItem(1,"desc_cencos_slc","")
			return 1
		END IF
	CASE 'ot_adm'
		SELECT count(*) INTO :ll_count
		FROM ot_administracion
		WHERE ot_adm = :data ;
		
		IF ll_count > 0 THEN
			
			SELECT descripcion
			INTO :ls_descripcion
			FROM ot_administracion
			WHERE ot_adm = :data ;
	
			this.SetItem( row, 'desc_ot_adm', ls_descripcion)
			this.ii_update = 1
		ELSE
			MessageBox('Aviso','OT Adm no existe')
			SetColumn("ot_adm")
			SetItem(1,"ot_adm","")
			SetItem(1,"desc_ot_adm","")
			return 1
		END IF
	CASE 'ot_tipo'
		SELECT count(*) INTO :ll_count
		FROM ot_tipo
		WHERE ot_tipo = :data ;
		
		IF ll_count > 0 THEN
			
			SELECT descripcion
			INTO :ls_descripcion
			FROM ot_tipo
			WHERE ot_tipo = :data ;
	
			this.SetItem( row, 'desc_ot_tipo', ls_descripcion)
			this.ii_update = 1
		ELSE
			MessageBox('Aviso','Tipo OT no existe')
			SetColumn("ot_tipo")
			SetItem(1,"ot_tipo","")
			SetItem(1,"desc_ot_tipo","")
			return 1
		END IF
	CASE 'cod_maquina'
		SELECT count(*) INTO :ll_count
		FROM maquina
		WHERE cod_maquina = :data ;
		
		IF ll_count > 0 THEN
			
			SELECT desc_maq
			INTO :ls_descripcion
			FROM maquina
			WHERE cod_maquina = :data ;
	
			this.SetItem( row, 'desc_maq', ls_descripcion)
			this.ii_update = 1
		ELSE
			MessageBox('Aviso','Máquina no existe')
			SetColumn("cod_maquina")
			SetItem(1,"cod_maquina","")
			SetItem(1,"desc_maq","")
			return 1
		END IF
		
END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado[al_row]='1'
//this.object.tipo_riego[al_row]='1'
end event

type dw_ext from datawindow within w_ope026_plant_ot
event ue_tecla pbm_dwnkey
boolean visible = false
integer x = 1719
integer y = 288
integer width = 1426
integer height = 384
integer taborder = 70
boolean titlebar = true
string title = "Datos Plantilla"
string dataobject = "d_abc_plantilla_ext_ff"
boolean border = false
boolean livescroll = true
end type

event ue_tecla;IF key = KeyEscape! THEN
	This.Accepttext()
	This.Visible = FALSE
END IF
end event

event itemchanged;Accepttext()
end event

event itemerror;Return 1
end event

event constructor;Settransobject(sqlca)

end event

