$PBExportHeader$w_ma301_solicit_ot.srw
forward
global type w_ma301_solicit_ot from w_abc
end type
type sle_ppto from singlelineedit within w_ma301_solicit_ot
end type
type cb_ppto from commandbutton within w_ma301_solicit_ot
end type
type cb_3 from commandbutton within w_ma301_solicit_ot
end type
type st_1 from statictext within w_ma301_solicit_ot
end type
type sle_solicitud from singlelineedit within w_ma301_solicit_ot
end type
type dw_master from u_dw_abc within w_ma301_solicit_ot
end type
type cb_2 from commandbutton within w_ma301_solicit_ot
end type
type cb_1 from commandbutton within w_ma301_solicit_ot
end type
type gb_1 from groupbox within w_ma301_solicit_ot
end type
end forward

global type w_ma301_solicit_ot from w_abc
integer width = 2981
integer height = 1400
string title = "Solicitud de Orden de Trabajo (MA301)"
string menuname = "m_abc_orden_trabajo"
event ue_anular ( )
sle_ppto sle_ppto
cb_ppto cb_ppto
cb_3 cb_3
st_1 st_1
sle_solicitud sle_solicitud
dw_master dw_master
cb_2 cb_2
cb_1 cb_1
gb_1 gb_1
end type
global w_ma301_solicit_ot w_ma301_solicit_ot

type variables
String is_accion


end variables

forward prototypes
public subroutine wf_retrieve_dw (string as_nro_solicitud_ot)
public function long wf_asig_nro_solicitud_ot ()
end prototypes

event ue_anular();Long ll_row
ll_row = dw_master.GetRow()
dw_master.SetItem(ll_row, 'flag_estado','0')
dw_master.ii_update = 1
end event

public subroutine wf_retrieve_dw (string as_nro_solicitud_ot);IF as_nro_solicitud_ot = '' THEN
	SELECT NVL(MAX(NRO_SOLICITUD),'')
	INTO	 :as_nro_solicitud_ot
	FROM   SOLICITUD_OT;
END IF

IF Isnull(as_nro_solicitud_ot) OR Trim(as_nro_solicitud_ot) = '' THEN
	TriggerEvent('ue_insert')
ELSE
	dw_master.Retrieve(as_nro_solicitud_ot)	
END IF
end subroutine

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

on w_ma301_solicit_ot.create
int iCurrent
call super::create
if this.MenuName = "m_abc_orden_trabajo" then this.MenuID = create m_abc_orden_trabajo
this.sle_ppto=create sle_ppto
this.cb_ppto=create cb_ppto
this.cb_3=create cb_3
this.st_1=create st_1
this.sle_solicitud=create sle_solicitud
this.dw_master=create dw_master
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ppto
this.Control[iCurrent+2]=this.cb_ppto
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_solicitud
this.Control[iCurrent+6]=this.dw_master
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.gb_1
end on

on w_ma301_solicit_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ppto)
destroy(this.cb_ppto)
destroy(this.cb_3)
destroy(this.st_1)
destroy(this.sle_solicitud)
destroy(this.dw_master)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)
dw_master.SetTransObject(SQLCA)

idw_1 = dw_master              // asignar dw corriente
wf_retrieve_dw('')
dw_master.BorderStyle = StyleRaised! // indicar dw_detdet como no activado

//Help
ii_help = 301

end event

event ue_modify();call super::ue_modify;dw_master.of_protect() 
end event

event ue_insert();call super::ue_insert;Long  ll_row

TriggerEvent('ue_update_request')
dw_master.Reset()
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN 
	THIS.EVENT ue_insert_pos(ll_row)
	is_accion = 'new'
END IF	

end event

event ue_delete();call super::ue_delete;is_accion = 'delete'
end event

event ue_retrieve_list();call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
sg_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_solicitud_orden_trabajo_tbl'
sl_param.titulo = 'Solicitud de Orden de Trabajo'
sl_param.field_ret_i[1] = 1


OpenWithParm( w_search, sl_param)

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

event ue_update_pre();String ls_nro_solicitud_ot


//--VERIFICACION Y ASIGNACION DE DATOS DE ORDEN DE TRABAJO
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if



IF is_accion = 'new' THEN
	ls_nro_solicitud_ot =	Trim(String(wf_asig_nro_solicitud_ot ()))	
	IF Isnull(ls_nro_solicitud_ot) OR ls_nro_solicitud_ot = '0' THEN
		Messagebox('Aviso','Verifique Tabla NUM_SOLICITUD_OT ,Comuniquese con Sistemas')
		ib_update_check = False	
		Return
	END IF
	dw_master.object.nro_solicitud [1] = ls_nro_solicitud_ot
ELSEIF is_accion = 'fileopen' THEN
	ls_nro_solicitud_ot = dw_master.object.nro_solicitud [1] 
END IF

end event

event ue_update();Boolean lbo_ok = TRUE

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
	IF is_accion = 'delete' THEN
		wf_retrieve_dw ('')
	ELSE
		is_accion = 'fileopen'
	END IF
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_print();call super::ue_print;Str_cns_pop lstr_cns_pop
//*Imprime Boleta*//
IF dw_master.ii_update = 1 THEN
	Messagebox('Aviso','Grabe Modificaciones , Para Proceder Imprimir Solicitud ')
	Return
END IF

lstr_cns_pop.arg[1] = dw_master.object.nro_solicitud [1]

OpenSheetWithParm(w_ma301_solicit_ot_rpt, lstr_cns_pop, this, 2, Layered!)

end event

type sle_ppto from singlelineedit within w_ma301_solicit_ot
integer x = 2505
integer y = 1044
integer width = 393
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type cb_ppto from commandbutton within w_ma301_solicit_ot
integer x = 2551
integer y = 928
integer width = 311
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Presupuesto"
end type

event clicked;Date ld_fecha
Long ll_ano, ll_mes, ll_verifica
Decimal ld_presupuesto
String ls_cencos, ls_cnta_prsp

ll_verifica = 1

IF dw_master.GetRow() = 0 THEN
	MessageBox('Aviso','No existe partida presupuestal')
ELSE
	ld_fecha = DATE(dw_master.GetItemDateTime(1, 'fecha_esperada'))
	IF isnull(ld_fecha) THEN
		MessageBox('Aviso','Defina fecha esperada')
		ll_verifica=0
	ELSE
		ll_ano = YEAR(ld_fecha)
		ll_mes = MONTH(ld_fecha)
	END IF
	ls_cencos = dw_master.GetItemString(1, 'cencos_slc')
	ls_cnta_prsp = dw_master.GetItemString(1, 'cnta_prsp')
	IF ISNULL(ls_cencos) THEN
		MessageBox('Aviso','Defina centro de costo solicitante')
		ll_verifica=0
	END IF
	IF ISNULL(ls_cnta_prsp) THEN
		MessageBox('Aviso','Defina cuenta presupuestal')
		ll_verifica=0
	END IF
	IF ll_verifica=0 THEN
		return
	ELSE
		/*
		DECLARE PB_USF_PPTO_SALDO_ACTUAL PROCEDURE FOR USF_PTO_SALDO_ACTUAL(  
   	        :ll_mes, :ll_ano, :ls_cencos, :ls_cnta_prsp);
		
		EXECUTE PB_USF_PPTO_SALDO_ACTUAL ;
		FETCH PB_USF_PPTO_SALDO_ACTUAL INTO :ld_presupuesto ;
		*/
				
		SELECT USF_PTO_SALDO_ACTUAL(:ll_mes, :ll_ano, :ls_cencos, :ls_cnta_prsp)
		INTO :ld_presupuesto
		FROM dual ;
		
		sle_ppto.text=STRING(ld_presupuesto)
	END IF
END IF ;

end event

type cb_3 from commandbutton within w_ma301_solicit_ot
integer x = 965
integer y = 76
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ubicar"
end type

event clicked;String ls_solicitud
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
		is_accion = 'fileopen'
		dw_master.Retrieve(ls_solicitud)
	ELSE
		dw_master.reset()
		MessageBox('Aviso', 'Solicitud de Orden de trabajo no existe')
	END IF
END IF

return 1
end event

type st_1 from statictext within w_ma301_solicit_ot
integer x = 96
integer y = 88
integer width = 439
integer height = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solicitud de OT: "
boolean focusrectangle = false
end type

type sle_solicitud from singlelineedit within w_ma301_solicit_ot
integer x = 558
integer y = 88
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type dw_master from u_dw_abc within w_ma301_solicit_ot
integer x = 27
integer y = 280
integer width = 2414
integer height = 912
string dataobject = "d_abc_solicitud_orden_trabajo_ff"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = dw_master				// dw_master



end event

event doubleclicked;call super::doubleclicked;IF row < 1 then return 1
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
						ii_update = 1
				 CASE 'cencos_rsp'
						Setitem(row,'cencos_rsp',lstr_seleccionar.param1[1])
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

event itemchanged;Accepttext()
Long   ll_count 
String ls_codigo, ls_desc_maq, ls_desc_cencos

ii_update = 1

CHOOSE CASE dwo.name
		 CASE 'cencos_slc'
			
				SELECT COUNT(*)
				INTO   :ll_count
				FROM   centros_costo
				WHERE  cencos = :data;
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					This.Object.cencos_slc [row] = ls_codigo
					Messagebox('Aviso','Debe Ingresar un Centro de Costo Valido')	
					Return 1
				ELSE
					SELECT desc_cencos
					INTO   :ls_desc_cencos
					FROM   centros_costo
					WHERE  cencos = :data;
					
					This.Object.centros_costo_desc_cencos [row] = ls_desc_cencos
				END IF
				ii_update = 1
				
       CASE 'cencos_rsp'
			
				SELECT COUNT(*)
				INTO   :ll_count
				FROM   centros_costo
				WHERE  cencos = :data;
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					This.Object.cencos_rsp[row] = ls_codigo
					Messagebox('Aviso','Debe Ingresar un Centro de Costo Valido')	
					Return 1
				ELSE
					SELECT desc_cencos
					INTO   :ls_desc_cencos
					FROM   centros_costo
					WHERE  cencos = :data;
					
					This.Object.centros_costo_desc_cencos1 [row] = ls_desc_cencos
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

event ue_insert_pre(long al_row);call super::ue_insert_pre;this.SetItem( al_row, 'flag_estado', '1' )
this.SetItem( al_row, 'fec_solicitud', today() )
this.SetItem( al_row, 'cod_usuario_sol', gs_user )
end event

type cb_2 from commandbutton within w_ma301_solicit_ot
integer x = 2569
integer y = 400
integer width = 293
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Rechazar"
end type

event clicked;String ls_respuesta,ls_flag_estado


ls_flag_estado = dw_master.object.flag_estado [dw_master.getrow()]

IF ls_flag_estado = '2' OR ls_flag_estado = '3' &
   OR ls_flag_estado = '0' THEN RETURN

ls_respuesta = dw_master.GetItemString(1, 'respuesta')

OpenwithParm( w_ma301_solicit_ot_recha, ls_respuesta )
end event

type cb_1 from commandbutton within w_ma301_solicit_ot
integer x = 2569
integer y = 292
integer width = 293
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;window l_window
String          ls_nro_sol_aceptar, ls_flag_estado
Str_seleccionar lstr_seleccionar

IF is_accion = 'new' THEN
   MessageBox( 'Grabar', 'Debería grabar antes de utilizar esta opción' )
	RETURN 0
END IF

ls_flag_estado = dw_master.object.flag_estado [dw_master.getrow()]

IF ls_flag_estado = '2' OR ls_flag_estado = '3' &
   OR ls_flag_estado = '0' THEN RETURN


ls_nro_sol_aceptar = dw_master.GetItemString( dw_master.GetRow(), 'nro_solicitud' )

dw_master.ii_update = 1

lstr_seleccionar.param1  [1] = ls_nro_sol_aceptar 				      // Nro. Solicitud
lstr_seleccionar.param1  [2] = '3'                				      // Flag Estado Pendiente
lstr_seleccionar.param1  [3] = dw_master.object.descripcion   [1] // Descripcion
lstr_seleccionar.param1  [4] = dw_master.object.cencos_rsp    [1] // Cencos Rsp
lstr_seleccionar.param1  [5] = dw_master.object.cencos_slc    [1] // Cencos Slc
lstr_seleccionar.param1  [6] = 'SOL' // INDICADOR DE SOLICITUD
lstr_seleccionar.paramdt1[7] = dw_master.object.fec_solicitud [1]  // Fecha de solicitud
lstr_seleccionar.param1  [8] = dw_master.object.cod_maquina   [1]  // Codigo de Maquina
lstr_seleccionar.paramdt1[9] = dw_master.object.fecha_esperada [1]  // Fecha esperada

OpenSheetWithParm(l_window,  lstr_seleccionar,"w_ma302_orden_trabajo", Parent, 2, Original!)

//OpenwithParm      (w_ma301_solicit_ot_acept,ls_nro_sol_aceptar)

dw_master.SetItem(1, 'flag_estado', '2')
end event

type gb_1 from groupbox within w_ma301_solicit_ot
integer x = 41
integer y = 8
integer width = 1408
integer height = 220
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ubicar"
borderstyle borderstyle = stylelowered!
end type

