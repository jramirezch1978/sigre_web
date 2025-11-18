$PBExportHeader$w_ope301_solicit_ot.srw
forward
global type w_ope301_solicit_ot from w_abc
end type
type pb_3 from picturebutton within w_ope301_solicit_ot
end type
type pb_2 from picturebutton within w_ope301_solicit_ot
end type
type em_1 from editmask within w_ope301_solicit_ot
end type
type pb_1 from picturebutton within w_ope301_solicit_ot
end type
type cb_3 from commandbutton within w_ope301_solicit_ot
end type
type st_1 from statictext within w_ope301_solicit_ot
end type
type sle_solicitud from singlelineedit within w_ope301_solicit_ot
end type
type dw_master from u_dw_abc within w_ope301_solicit_ot
end type
type gb_1 from groupbox within w_ope301_solicit_ot
end type
end forward

global type w_ope301_solicit_ot from w_abc
integer width = 2821
integer height = 1324
string title = "Solicitud de Orden de Trabajo (OPE301)"
string menuname = "m_master_lista_anular"
event ue_anular ( )
pb_3 pb_3
pb_2 pb_2
em_1 em_1
pb_1 pb_1
cb_3 cb_3
st_1 st_1
sle_solicitud sle_solicitud
dw_master dw_master
gb_1 gb_1
end type
global w_ope301_solicit_ot w_ope301_solicit_ot

type variables
String is_accion


end variables

forward prototypes
public function long wf_asig_nro_solicitud_ot ()
public subroutine wf_retrieve_dw (string as_nro_solicitud_ot)
end prototypes

event ue_anular();Long   ll_row_master
String ls_flag_estado

ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN RETURN

IF (dw_master.ii_update = 1 ) THEN
	Messagebox('Aviso','Grabe Cambios ,Actualizacion pendiente')
	RETURN
END IF


ls_flag_estado = dw_master.object.flag_estado [ll_row_master] 

IF ls_flag_estado = '0'  THEN
	Messagebox('Aviso','No puede Anular Solicitud ,Se encuentra Anulada')
	RETURN
ELSEIF ls_flag_estado = '2'  THEN
	Messagebox('Aviso','No puede Anular Solicitud ,Ha sido generada Orden de Trabajo')
	RETURN
ELSEIF ls_flag_estado = '3'  THEN
	Messagebox('Aviso','No puede Anular Solicitud ,Se encuentra Rechazada')
	RETURN
END IF

IF (dw_master.ii_update = 1 ) THEN
	Messagebox('Aviso','Tiene Actualizaciones Pendientes ,Verifique!')
	RETURN
END IF

dw_master.object.flag_estado [ll_row_master] = '0'
dw_master.ii_update = 1
TriggerEvent('ue_modify')
end event

public function long wf_asig_nro_solicitud_ot ();Long   ll_nro_solitiud_ot
String ls_lock_table

ls_lock_table = 'LOCK TABLE NUM_SOLICITUD_OT IN EXCLUSIVE MODE'
EXECUTE IMMEDIATE :ls_lock_table ;

SELECT NVL(ULT_NRO,0) 
INTO   :ll_nro_solitiud_ot
FROM   NUM_SOLICITUD_OT
WHERE  RECKEY = '1' ;

	
UPDATE NUM_SOLICITUD_OT
SET ULT_NRO = :ll_nro_solitiud_ot + 1
WHERE RECKEY = '1' ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
	ll_nro_solitiud_ot = 0
	
END IF


Return ll_nro_solitiud_ot

end function

public subroutine wf_retrieve_dw (string as_nro_solicitud_ot);dw_master.Retrieve(as_nro_solicitud_ot)	

end subroutine

on w_ope301_solicit_ot.create
int iCurrent
call super::create
if this.MenuName = "m_master_lista_anular" then this.MenuID = create m_master_lista_anular
this.pb_3=create pb_3
this.pb_2=create pb_2
this.em_1=create em_1
this.pb_1=create pb_1
this.cb_3=create cb_3
this.st_1=create st_1
this.sle_solicitud=create sle_solicitud
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_3
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.em_1
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.sle_solicitud
this.Control[iCurrent+8]=this.dw_master
this.Control[iCurrent+9]=this.gb_1
end on

on w_ope301_solicit_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.em_1)
destroy(this.pb_1)
destroy(this.cb_3)
destroy(this.st_1)
destroy(this.sle_solicitud)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)
dw_master.SetTransObject(SQLCA)

idw_1 = dw_master              // asignar dw corriente


//Help
ii_help = 301

end event

event ue_modify;call super::ue_modify;String ls_flag_estado
Long   ll_row_master

ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN RETURN

ls_flag_estado = dw_master.object.flag_estado [ll_row_master]

IF ls_flag_estado = '0' OR ls_flag_estado = '2' THEN //ANULADO o ACEPTADO
	dw_master.ii_protect = 0
	dw_master.of_protect() 
ELSE
	dw_master.of_protect() 
END IF


end event

event ue_insert;call super::ue_insert;Long  ll_row

TriggerEvent('ue_update_request')

IF ib_update_check = FALSE THEN RETURN

dw_master.Reset()

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN 
	This.Event ue_insert_pos(ll_row)
END IF	

end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_solicitud_orden_trabajo_tbl'
sl_param.titulo = 'Solicitud de Orden de Trabajo'
sl_param.field_ret_i[1] = 1


OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	wf_retrieve_dw(sl_param.field_ret[1])
	dw_master.ii_update = 0
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
END IF

end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

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

event ue_update_pre;String ls_nro_sol
Long   ll_row_master


//invocar objeto de numeracion de parte
nvo_numeradores_varios lnvo_numeradores_varios
lnvo_numeradores_varios    = CREATE nvo_numeradores_varios
//

ll_row_master = dw_master.getrow()




IF ll_row_master = 0  THEN
	ib_update_check = False	
	RETURN
END IF	

//--VERIFICACION Y ASIGNACION DE DATOS DE ORDEN DE TRABAJO
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if


ls_nro_sol = dw_master.object.nro_solicitud [ll_row_master] 

IF is_accion = 'new' THEN
	IF lnvo_numeradores_varios.uf_num_solicitud_ot(gs_origen,ls_nro_sol) = FALSE THEN
		ib_update_check = False	
		destroy lnvo_numeradores_varios
		RETURN
	ELSE
		dw_master.Object.nro_solicitud [ll_row_master] = ls_nro_sol
	END IF
	MessageBox('', ls_nro_sol)
END IF

dw_master.of_set_flag_replicacion()

destroy lnvo_numeradores_varios


end event

event ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN
	Rollback ;
	RETURN
END IF	


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	is_accion = 'fileopen'
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_print;call super::ue_print;Long ll_row_master
Str_cns_pop lstr_cns_pop

ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN RETURN

IF (dw_master.ii_update = 1 ) THEN
	Messagebox('Aviso','Grabe Modificaciones Pendientes ')
	RETURN
END IF

//*Imprime Boleta*//
IF dw_master.ii_update = 1 THEN
	Messagebox('Aviso','Grabe Modificaciones , Para Proceder Imprimir Solicitud ')
	Return
END IF

lstr_cns_pop.arg[1] = dw_master.object.nro_solicitud [ll_row_master]

OpenSheetWithParm(w_ope301_solicit_ot_rpt, lstr_cns_pop, this, 2, Layered!)

end event

event ue_delete;//Messagebox('Aviso','No se puede eliminar Registro Verifique!')
end event

type pb_3 from picturebutton within w_ope301_solicit_ot
integer x = 2427
integer y = 212
integer width = 315
integer height = 180
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Long   ll_row_master
String ls_flag_estado,ls_nro_sol,ls_cencos,ls_tipo_doc,ls_mensaje,ls_nivel
window l_window
Str_seleccionar_ot lstr_seleccionar

//invocar objeto de numeracion de parte
nvo_nivel_aprobacion lnvo_nivel_aprobacion
lnvo_nivel_aprobacion = CREATE nvo_nivel_aprobacion
/**/

ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN RETURN

IF dw_master.ii_update = 1 THEN
	Messagebox('Aviso','Tiene Actualizaciones pendientes Verifique!')
	RETURN
END IF

select doc_solicitud_ot into :ls_tipo_doc from prod_param where reckey = '1' ;

IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc)= '' THEN
	Messagebox('Aviso','Tipo de Solicitud de Ot no existe en Tabla de Parametros PROD PARAM')
	RETURN
END IF	

ls_flag_estado = dw_master.object.flag_estado   [ll_row_master]
ls_nro_sol     = dw_master.object.nro_solicitud [ll_row_master]
ls_cencos	   = dw_master.object.cencos_rsp    [ll_row_master]

IF ls_flag_estado = '2' OR ls_flag_estado = '3' OR ls_flag_estado = '0' THEN
	Messagebox('Aviso','Solicitud de OT ya no puede ser Aceptada Verifique Estado de la Solicitud')
	RETURN
END IF	


IF lnvo_nivel_aprobacion.uf_aprobacion(ls_tipo_doc,ls_cencos,gs_user,ls_mensaje,ls_nivel) = FALSE THEN
	Messagebox('Aviso',ls_mensaje)
	Return
//ELSE

END IF

//Ventana de aceptación
OpenwithParm(w_ope301_solicit_ot_acept,ls_nro_sol)



lstr_seleccionar.param1  [1] = ls_nro_sol        				      // Nro. Solicitud
lstr_seleccionar.param1  [2] = '3'                				      // Flag Estado Pendiente
lstr_seleccionar.param1  [3] = dw_master.object.descripcion   [1] // Descripcion
lstr_seleccionar.param1  [4] = dw_master.object.cencos_rsp    [1] // Cencos Rsp
lstr_seleccionar.param1  [5] = dw_master.object.cencos_slc    [1] // Cencos Slc
lstr_seleccionar.param1  [6] = 'SOL' // INDICADOR DE SOLICITUD
lstr_seleccionar.paramdt1[7] = dw_master.object.fec_solicitud [1]  // FECHA DE SOLICITUD
lstr_seleccionar.param1  [8] = dw_master.object.cod_maquina   [1]  // Codigo de Maquina
lstr_seleccionar.param1  [9] = ls_nivel									 // nivel de autorizacion	


OpenSheetWithParm(l_window,  lstr_seleccionar,'w_OPE302_orden_trabajo', Parent, 2, Original!)
Destroy lnvo_nivel_aprobacion
Close(parent)

end event

type pb_2 from picturebutton within w_ope301_solicit_ot
integer x = 2432
integer y = 400
integer width = 315
integer height = 180
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "  Rechazar"
string picturename = "H:\Source\BMP\rechazar.bmp"
alignment htextalign = left!
end type

event clicked;String ls_respuesta,ls_flag_estado
Long   ll_row_master

ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN RETURN

ls_flag_estado = dw_master.object.flag_estado [ll_row_master]

IF ls_flag_estado = '2' OR ls_flag_estado = '3' OR ls_flag_estado = '0' THEN
	Messagebox('Aviso','Solicitud de OT ya no puede ser Aceptada Verifique Estado de la Solicitud')
	RETURN
END IF

IF dw_master.ii_update = 1 THEN
	Messagebox('Aviso','Tiene Actualizaciones Pendientes , Verifique!')
	RETURN
END IF


dw_master.object.flag_estado [ll_row_master] = '3'
dw_master.ii_update = 1

ls_respuesta = dw_master.GetItemString(ll_row_master, 'respuesta')

OpenwithParm( w_ope301_solicit_ot_recha, ls_respuesta )

end event

type em_1 from editmask within w_ope301_solicit_ot
integer x = 2409
integer y = 824
integer width = 357
integer height = 92
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_ope301_solicit_ot
integer x = 2409
integer y = 640
integer width = 357
integer height = 152
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
string text = "Presupuesto"
string picturename = "H:\Source\BMP\notes.bmp"
alignment htextalign = left!
end type

event clicked;Long        ll_row_master,ll_ano,ll_mes
Date        ldt_fecha
Decimal {2} ldc_presupuesto
String      ls_cencos,ls_cnta_prsp

ll_row_master = dw_master.getrow()


IF ll_row_master = 0 THEN 
	Messagebox('Aviso','No Existe Registro ,Verifique!')
	RETURN
END IF

ldt_fecha = Date(dw_master.object.fecha_esperada [ll_row_master])

IF Isnull(ldt_fecha) OR Trim(String(ldt_fecha,'yyyymmdd')) = '00000000' THEN
	Messagebox('Aviso','Fecha esperada debe Ingresar para calcular Presupuesto ,Verifique!')
	RETURN
END IF

ll_ano = Year(ldt_fecha)
ll_mes = Month(ldt_fecha)

ls_cencos    = dw_master.object.cencos_slc [ll_row_master]
ls_cnta_prsp = dw_master.object.cnta_prsp  [ll_row_master]

IF Isnull(ls_cencos) OR Trim(ls_cencos) = '' THEN
	Messagebox('Aviso','Debe Ingresar Centro de Costo ,Verifique!')
	RETURN
END IF

IF Isnull(ls_cnta_prsp) OR Trim(ls_cnta_prsp) = '' THEN
	Messagebox('Aviso','Debe Ingresar Cuenta Presupuestal ,Verifique!')
	RETURN
END IF


//retorna presupuesto actual
SELECT USF_PTO_SALDO_ACTUAL(:ll_mes, :ll_ano, :ls_cencos, :ls_cnta_prsp)
  INTO :ldc_presupuesto
  FROM dual ;
  
IF SQLCA.SQLCode = -1 THEN 
   MessageBox('SQL error', SQLCA.SQLErrText)
	Return
END IF  

em_1.text=String(ldc_presupuesto)


end event

type cb_3 from commandbutton within w_ope301_solicit_ot
integer x = 946
integer y = 64
integer width = 402
integer height = 84
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ubicar"
end type

event clicked;String ls_nro_sol

ls_nro_sol = Trim(sle_solicitud.text)

IF Isnull(ls_nro_sol) OR Trim(ls_nro_sol) = '' THEN
	Messagebox('Aviso','Digite solicitud de orden de trabajo a buscar')
	Return
END IF

dw_master.Retrieve(ls_nro_sol)

end event

event getfocus;String ls_solicitud
Long ll_count

ls_solicitud = TRIM(sle_solicitud.text)

IF isnull(ls_solicitud) THEN
	messagebox('Aviso','Digite solicitud de orden de trabajo a buscar')
ELSE
	
	SELECT count(*) INTO :ll_count FROM SOLICITUD_OT 
	WHERE NRO_SOLICITUD = :ls_solicitud ;
	
	IF ll_count > 0 THEN
		dw_master.Retrieve(ls_solicitud)
	ELSE
		MessageBox('Aviso', 'Solicitud de Orden de trabajo no existe')
	END IF
END IF

return 1
end event

type st_1 from statictext within w_ope301_solicit_ot
integer x = 87
integer y = 80
integer width = 439
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solicitud de OT : "
boolean focusrectangle = false
end type

type sle_solicitud from singlelineedit within w_ope301_solicit_ot
event ue_tecla pbm_keydown
integer x = 539
integer y = 64
integer width = 343
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;IF Key = KeyEnter! THEN
	cb_3.triggerevent(clicked!)
END IF
end event

type dw_master from u_dw_abc within w_ope301_solicit_ot
integer x = 27
integer y = 216
integer width = 2354
integer height = 892
string dataobject = "d_abc_solicitud_orden_trabajo_ff"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = dw_master				// dw_master



end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String ls_name,ls_prot
Datawindow ldw
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'fec_solicitud','fecha_esperada'
			   ldw = this
			   f_call_calendar(ldw,dwo.name,dwo.coltype,row)
		 CASE 'cencos_slc','cencos_rsp'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS 	  AS CENCOS,'&
														 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&     	
					 		   						 +'FROM CENTROS_COSTO '
		 CASE	'cod_maquina'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS CODIGO,'&
														 +'MAQUINA.DESC_MAQ AS DESCRIPCION '&     	
					 		   						 +'FROM MAQUINA '
		 CASE	'cnta_prsp'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP AS CODIGO,'&
														 +'PRESUPUESTO_CUENTA.DESCRIPCION AS DESCRIPCION '&     	
					 		   						 +'FROM PRESUPUESTO_CUENTA '

END CHOOSE			


IF lstr_seleccionar.s_seleccion = 'S' THEN
	OpenWithParm(w_seleccionar,lstr_seleccionar)	
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
	IF lstr_seleccionar.s_action = "aceptar" THEN
		CHOOSE CASE dwo.name		
				 CASE 'cencos_slc'
						Setitem(row,'cencos_slc',lstr_seleccionar.param1[1])
						Setitem(row,'centros_costo_desc_cencos',lstr_seleccionar.param2[1])
						ii_update = 1
				 CASE 'cencos_rsp'
						Setitem(row,'cencos_rsp',lstr_seleccionar.param1[1])
						Setitem(row,'centros_costo_desc_cencos_1',lstr_seleccionar.param2[1])
						ii_update = 1
				 CASE 'cod_maquina'
						Setitem(row,'cod_maquina',lstr_seleccionar.param1[1])
						Setitem(row,'desc_maq',lstr_seleccionar.param2[1])
						ii_update = 1
				 CASE 'cnta_prsp'
						Setitem(row,'cnta_prsp',lstr_seleccionar.param1[1])
						Setitem(row,'presupuesto_cuenta_descripcion',lstr_seleccionar.param2[1])
						ii_update = 1

		END CHOOSE			
	END IF
	
END IF


 





     





				


									  
									  
			


end event

event itemchanged;call super::itemchanged;Accepttext()
Long   ll_count 
String ls_codigo,ls_desc_maq,ls_descrip


CHOOSE CASE dwo.name
		 CASE 'cencos_slc'
			
				SELECT COUNT(*)
				  INTO   :ll_count
				  FROM   centros_costo
				WHERE  cencos = :data;
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					This.Object.cencos_slc                [row] = ls_codigo
					This.Object.centros_costo_desc_cencos [row] = ls_codigo
					Messagebox('Aviso','Debe Ingresar un Centro de Costo Valido')	
					Return 1
				ELSE
				   SELECT desc_cencos
				     INTO :ls_descrip
					  FROM centros_costo
					 WHERE cencos = :data ;
					
					This.Object.centros_costo_desc_cencos [row] = ls_descrip
				END IF
				
				ii_update = 1
				
       CASE 'cencos_rsp'
			
				SELECT COUNT(*)
				INTO   :ll_count
				FROM   centros_costo
				WHERE  cencos = :data;
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					This.Object.cencos_rsp					   [row] = ls_codigo
					This.Object.centros_costo_desc_cencos_1[row] = ls_codigo
					Messagebox('Aviso','Debe Ingresar un Centro de Costo Valido')	
					Return 1
				ELSE
				   SELECT desc_cencos
				     INTO :ls_descrip
					  FROM centros_costo
					 WHERE cencos = :data ;
					
					This.Object.centros_costo_desc_cencos_1 [row] = ls_descrip					
				END IF
				ii_update = 1
				
		 CASE	'cod_maquina'	
				SELECT Count(*)
				  INTO :ll_count
				  FROM maquina
				 WHERE (cod_maquina = :data ) ;
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					SetNull(ls_desc_maq)
					
					This.Object.cod_maquina [row] = ls_codigo
					This.Object.desc_maq    [row] = ls_desc_maq
					Messagebox('Aviso','Debe Ingresar un Codigo de Maquina Valido')	
					Return 1
				ELSE
					SELECT desc_maq
				     INTO :ls_desc_maq
				     FROM maquina
				    WHERE (cod_maquina = :data ) ;
					 
					ii_update = 1
					This.Object.desc_maq [row] = ls_desc_maq
				END IF
		 CASE	'cnta_prsp'	
				SELECT Count(*)
				  INTO :ll_count
				  FROM presupuesto_cuenta
				 WHERE (cnta_prsp = :data ) ;
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					SetNull(ls_desc_maq)
					
					This.Object.cnta_prsp [row] = ls_codigo
					This.Object.presupuesto_cuenta_descripcion [row] = ls_desc_maq
					Messagebox('Aviso','Debe Ingresar un Codigo de cuenta presupuestal Valida')	
					Return 1
				ELSE
					SELECT descripcion
				     INTO :ls_desc_maq
				     FROM presupuesto_cuenta
				    WHERE (cnta_prsp = :data ) ;
					 
					ii_update = 1
					This.Object.presupuesto_cuenta_descripcion [row] = ls_desc_maq
				END IF
			
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event ue_insert_pre;call super::ue_insert_pre;this.SetItem( al_row, 'flag_estado', '1' )
this.SetItem( al_row, 'fec_solicitud', today() )
this.SetItem( al_row, 'fecha_esperada', today() )
this.SetItem( al_row, 'cod_usuario_sol', gs_user )

is_accion = 'new'
end event

type gb_1 from groupbox within w_ope301_solicit_ot
integer x = 41
integer y = 8
integer width = 1358
integer height = 168
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ubicar"
end type

