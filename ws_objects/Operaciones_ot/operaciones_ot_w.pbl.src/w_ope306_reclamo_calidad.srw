$PBExportHeader$w_ope306_reclamo_calidad.srw
forward
global type w_ope306_reclamo_calidad from w_abc
end type
type pb_3 from picturebutton within w_ope306_reclamo_calidad
end type
type pb_2 from picturebutton within w_ope306_reclamo_calidad
end type
type cb_3 from commandbutton within w_ope306_reclamo_calidad
end type
type st_1 from statictext within w_ope306_reclamo_calidad
end type
type sle_solicitud from singlelineedit within w_ope306_reclamo_calidad
end type
type dw_master from u_dw_abc within w_ope306_reclamo_calidad
end type
type gb_1 from groupbox within w_ope306_reclamo_calidad
end type
end forward

global type w_ope306_reclamo_calidad from w_abc
integer width = 2830
integer height = 1952
string title = "Reclamos de calidad de PPTT (OPE306)"
string menuname = "m_master_lista_anular"
event ue_anular ( )
pb_3 pb_3
pb_2 pb_2
cb_3 cb_3
st_1 st_1
sle_solicitud sle_solicitud
dw_master dw_master
gb_1 gb_1
end type
global w_ope306_reclamo_calidad w_ope306_reclamo_calidad

type variables
String is_accion


end variables

forward prototypes
public function long wf_asig_nro_solicitud_ot ()
public subroutine wf_retrieve_dw (string as_nro_solicitud_ot)
public function integer of_bloquea_campos (string as_opcion)
public function string of_set_numera (string as_origen)
end prototypes

event ue_anular();/*
Long   ll_row_master
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
*/

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

public function integer of_bloquea_campos (string as_opcion);Integer li_retorno
Long ll_row_master

// li_retorno =>, 0=error, 1=ok

ll_row_master = dw_master.GetRow()

IF ll_row_master = 0 then 
	li_retorno = 0
END IF 

// Ingreso
IF as_opcion = 'I' THEN		
	//dw_master.object.tipo_mov.background.color = RGB(192,192,192)   
	dw_master.object.cal_rec_tipo.protect 	   = 1
	dw_master.object.cod_art.protect 			= 1
	dw_master.object.nro_certificado.protect  = 1
	dw_master.object.cencos_rsp.protect 		= 1
	dw_master.object.cliente.protect 			= 1
	dw_master.object.costo_dol.protect 			= 1
	dw_master.object.cantidad.protect 			= 1
	dw_master.object.cod_templa.protect 		= 1	

// Aceptada	
ELSEIF as_opcion = 'A' THEN		
	dw_master.SetItem( ll_row_master, 'fecha_reclamo', gd_fecha )
	dw_master.SetItem( ll_row_master, 'flag_estado', '2' )	
	dw_master.object.cal_rec_tipo.protect 	   = 0
	dw_master.object.cod_art.protect 			= 0
	dw_master.object.nro_certificado.protect  = 0
	dw_master.object.cencos_rsp.protect 		= 0
	dw_master.object.cliente.protect 			= 0
	dw_master.object.costo_dol.protect 			= 0
	dw_master.object.cantidad.protect 			= 0
	dw_master.object.cod_templa.protect 		= 0	

// Rechazada	
ELSEIF as_opcion = 'R' THEN   
	dw_master.SetItem( ll_row_master, 'fecha_reclamo', gd_fecha )
	dw_master.SetItem( ll_row_master, 'flag_estado', '3' )	
	dw_master.object.cal_rec_tipo.protect 	   = 0
	dw_master.object.cod_art.protect 			= 0
	dw_master.object.nro_certificado.protect  = 0
	dw_master.object.cencos_rsp.protect 		= 0
	dw_master.object.cliente.protect 			= 0
	dw_master.object.costo_dol.protect 			= 0
	dw_master.object.cantidad.protect 			= 0
	dw_master.object.cod_templa.protect 		= 0	
END IF

li_retorno = 1

RETURN li_retorno
end function

public function string of_set_numera (string as_origen);// Numera documento
Long ll_ult_nro, ll_count, ll_long
String ls_nro, ls_nro_reclamo

Select count(*) into :ll_count from num_cal_reclamo 
where origen=:gs_origen ;

IF ll_count = 0 THEN
	INSERT INTO num_cal_reclamo values(:gs_origen, 1) ;
END IF

Select ult_nro into :ll_ult_nro from num_cal_reclamo 
where origen=:gs_origen for update nowait;

// Asigna numero a cabecera
ls_nro = String( ll_ult_nro)	
ll_long = 9 - len( TRIM( gs_origen))
ls_nro_reclamo = TRIM( gs_origen) + f_llena_caracteres('0',Trim(ls_nro),ll_long)
	
dw_master.object.nro_reclamo[dw_master.getrow()] = ls_nro_reclamo

// Incrementa contador	
Update num_cal_reclamo set ult_nro = :ll_ult_nro + 1 
where origen=:gs_origen ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
	ls_nro_reclamo = '0'
END IF

return ls_nro_reclamo
end function

on w_ope306_reclamo_calidad.create
int iCurrent
call super::create
if this.MenuName = "m_master_lista_anular" then this.MenuID = create m_master_lista_anular
this.pb_3=create pb_3
this.pb_2=create pb_2
this.cb_3=create cb_3
this.st_1=create st_1
this.sle_solicitud=create sle_solicitud
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_3
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_solicitud
this.Control[iCurrent+6]=this.dw_master
this.Control[iCurrent+7]=this.gb_1
end on

on w_ope306_reclamo_calidad.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_3)
destroy(this.pb_2)
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
//ii_help = 301

end event

event ue_modify();call super::ue_modify;String  ls_flag_estado
Long    ll_row_master
Integer li_protect

dw_master.accepttext()
ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN RETURN

ls_flag_estado = dw_master.object.flag_estado [ll_row_master]

/*
Estado 0 - Anulado
Estado 1 - Activo
Estado 2 - Atendido
Estado 3 - Rechazado
*/

dw_master.of_protect()

IF ls_flag_estado = '0' THEN //ANULADO  proteger todo
	dw_master.ii_protect = 0
	dw_master.of_protect() 
ELSEIF ls_flag_estado = '1'  THEN
	li_protect = integer(dw_master.Object.cal_rec_tipo.Protect)
	IF li_protect = 0	THEN
		dw_master.object.respuesta_rsp.Protect = 1
	END IF
ELSE
	dw_master.ii_protect = 0
	dw_master.of_protect() 
	
	//HABILITAR RESPUESTA

	dw_master.object.respuesta_rsp.Protect = 0
//	dw_master.object.respuesta_rsp.setfocous()
END IF

end event

event ue_insert;call super::ue_insert;Long  ll_row

TriggerEvent('ue_update_request')

IF ib_update_check = FALSE THEN RETURN

dw_master.Reset()

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN 
	This.Event ue_insert_pos(ll_row)
	is_accion = 'new'
END IF	

end event

event ue_retrieve_list();call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_lista_cal_reclamos_tbl'
sl_param.titulo = 'Lista de reclamos'
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

event ue_update_pre;String ls_nro_reclamo, ls_user, ls_flag_estado
Long   ll_row_master

// Evaluando si existe registros para grabar
ll_row_master = dw_master.getrow()

IF ll_row_master = 0  THEN
	ib_update_check = False	
	RETURN
END IF	

IF is_accion='new' then
	// Calculando el correlativo del documento
	ls_nro_reclamo = of_set_numera(gs_origen)
	dw_master.Object.nro_reclamo [ll_row_master] = ls_nro_reclamo
	IF ls_nro_reclamo='0' THEN
		Messagebox('Aviso','Numero de reclamo incorrecto')
		ib_update_check = False	
		RETURN
	END IF
ELSE
	ls_user        = dw_master.Object.cod_usr     [ll_row_master] 
	ls_flag_estado = dw_master.Object.flag_estado [ll_row_master] 
	
	
	// No permite modificar registro en estado activo por usuario
	// diferente al que lo ingreso
	IF (ls_flag_estado = '1' and trim(ls_user) <> trim(gs_user)) THEN
		Messagebox('Aviso','Usuario no autorizado a modificar')
		ib_update_check = False	
		RETURN
	END IF
END IF

dw_master.of_set_flag_replicacion()
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

event ue_print;call super::ue_print;/*
Long ll_row_master
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
*/

end event

event ue_delete;Messagebox('Aviso','No se puede eliminar Registro Verifique!')
end event

type pb_3 from picturebutton within w_ope306_reclamo_calidad
integer x = 2071
integer y = 16
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
String ls_usuario, ls_flag_estado

ll_row_master = dw_master.GetRow()

IF ll_row_master = 0 THEN RETURN

IF dw_master.ii_update = 1 THEN
	Messagebox('Aviso','Tiene Actualizaciones pendientes Verifique!')
	RETURN
END IF

ls_usuario = dw_master.GetItemString(ll_row_master, 'cod_usr')

IF ls_usuario = gs_user THEN
	MessageBox('Aviso','Usuario no autorizado a aceptar reclamos')
	return
END IF

ls_flag_estado = dw_master.GetItemString(ll_row_master, 'flag_estado')

IF ls_flag_estado = '0' THEN
	MessageBox('Aviso','Documento anulado')
	return
END IF 

dw_master.SetItem( ll_row_master, 'flag_estado', '2' )
dw_master.SetItem( ll_row_master, 'fecha_respuesta', gd_fecha )

parent.triggerevent('ue_modify')
end event

type pb_2 from picturebutton within w_ope306_reclamo_calidad
integer x = 2432
integer y = 16
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

event clicked;Long   ll_row_master
String ls_usuario, ls_flag_estado

ll_row_master = dw_master.GetRow()

IF ll_row_master = 0 THEN RETURN

IF dw_master.ii_update = 1 THEN
	Messagebox('Aviso','Tiene Actualizaciones pendientes Verifique!')
	RETURN
END IF

ls_usuario = dw_master.GetItemString(ll_row_master, 'cod_usr')

IF ls_usuario = gs_user THEN
	MessageBox('Aviso','Usuario no autorizado a rechazar reclamos')
	return
END IF

ls_flag_estado = dw_master.GetItemString(ll_row_master, 'flag_estado')

IF ls_flag_estado = '0' THEN
	MessageBox('Aviso','Documento anulado')
	return
END IF 

dw_master.SetItem( ll_row_master, 'flag_estado', '3' )
dw_master.SetItem( ll_row_master, 'fecha_respuesta', gd_fecha )

parent.triggerevent('ue_modify')
end event

type cb_3 from commandbutton within w_ope306_reclamo_calidad
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

event clicked;
String ls_nro_reclamo
Long ll_count

ls_nro_reclamo = Trim(sle_solicitud.text)

IF Isnull(ls_nro_reclamo) OR Trim(ls_nro_reclamo) = '' THEN
	Messagebox('Aviso','Digite Nro. de reclamo')
	Return
END IF

select count(*) INTO :ll_count
from cal_reclamo
where nro_reclamo=:ls_nro_reclamo ;

IF ll_count > 0 THEN
	dw_master.Retrieve(ls_nro_reclamo)
ELSE
	messagebox('Aviso','Nro de reclamo no existe ....')
END IF ;

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

type st_1 from statictext within w_ope306_reclamo_calidad
integer x = 87
integer y = 80
integer width = 411
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No de reclamo : "
boolean focusrectangle = false
end type

type sle_solicitud from singlelineedit within w_ope306_reclamo_calidad
event ue_tecla pbm_keydown
integer x = 539
integer y = 64
integer width = 343
integer height = 84
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

type dw_master from u_dw_abc within w_ope306_reclamo_calidad
integer x = 27
integer y = 216
integer width = 2738
integer height = 1500
string dataobject = "d_abc_cal_reclamo_ff"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = dw_master				// dw_master



end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String ls_name, ls_prot, ls_inactivo, ls_templa
Datawindow ldw
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

ls_inactivo = '0' 

CHOOSE CASE dwo.name
		 CASE 'fec_reclamo'
			   ldw = this
			   f_call_calendar(ldw,dwo.name,dwo.coltype,row)
 		 CASE 'cal_rec_tipo'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CAL_RECLAMO_TIPO.CAL_REC_TIPO  AS CODIGO,'&
														 +'CAL_RECLAMO_TIPO.DESCRIPCION AS DESCRIPCION '& 
					 		   						 +'FROM CAL_RECLAMO_TIPO '
 		 CASE 'cod_art'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_OPE_ARTICULO_VENTA.COD_ART AS CODIGO, '&
														 +'VW_OPE_ARTICULO_VENTA.NOM_ARTICULO AS DESCRIPCION ,'& 
														 +'VW_OPE_ARTICULO_VENTA.UND AS UND '& 
					 		   						 +'FROM VW_OPE_ARTICULO_VENTA '
														  
		 CASE 'cencos_rsp'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS 	  AS CENCOS,'&
														 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&     	
					 		   						 +'FROM CENTROS_COSTO ' &
														 +'WHERE FLAG_ESTADO <> ' + "'"+ls_inactivo+"'"
		 CASE	'cliente'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO,'&
														 +'PROVEEDOR.NOM_PROVEEDOR AS RAZON_SOCIAL '& 
					 		   						 +'FROM PROVEEDOR '&
														 +'WHERE FLAG_ESTADO <> ' + "'"+ls_inactivo+"'"
		 CASE	'cod_templa'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT TEMPLAS.COD_TEMPLA AS COD_TEMPLA,'&
														 +'TEMPLAS.FEC_REGISTRO AS FEC_REGISTRO '& 
					 		   						 +'FROM TEMPLAS '
		 CASE	'nro_certificado'
				ls_templa = this.object.cod_templa[row]
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT TEMPLA_CLIENTE_DET.NRO_CERTIFICADO AS NRO_CERTIFICADO,'&
														 +'TEMPLA_CLIENTE_DET.COD_TEMPLA AS COD_TEMPLA '& 
					 		   						 +'FROM TEMPLA_CLIENTE_DET '&
														 +'WHERE COD_TEMPLA = ' + "'"+ls_templa+"'"
														 
END CHOOSE			


IF lstr_seleccionar.s_seleccion = 'S' THEN
	OpenWithParm(w_seleccionar,lstr_seleccionar)	
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
	IF lstr_seleccionar.s_action = "aceptar" THEN
		CHOOSE CASE dwo.name		
				 CASE 'cal_rec_tipo'
						Setitem(row,'cal_rec_tipo',lstr_seleccionar.param1[1])
						Setitem(row,'cal_reclamo_tipo_descripcion',lstr_seleccionar.param2[1])
						ii_update = 1
				 CASE 'cencos_rsp'
						Setitem(row,'cencos_rsp',lstr_seleccionar.param1[1])
						Setitem(row,'centros_costo_desc_cencos',lstr_seleccionar.param2[1])
						ii_update = 1
				 CASE 'cod_art'
						Setitem(row,'cod_art',lstr_seleccionar.param1[1])
						Setitem(row,'articulo_nom_articulo',lstr_seleccionar.param2[1])
						ii_update = 1
				 CASE 'cliente'
						Setitem(row,'cliente',lstr_seleccionar.param1[1])
						Setitem(row,'proveedor_nom_proveedor',lstr_seleccionar.param2[1])
						ii_update = 1
				 CASE 'cod_templa'
						Setitem(row,'cod_templa',lstr_seleccionar.param1[1])
						ii_update = 1
				 CASE 'nro_certificado'
						Setitem(row,'nro_certificado',lstr_seleccionar.param1[1])
						ii_update = 1

		END CHOOSE			
	END IF
	
END IF

end event

event itemchanged;call super::itemchanged;Accepttext()
Long   ll_count 
String ls_codigo, ls_desc_maq, ls_descrip, ls_user, ls_flag_estado

ls_flag_estado = This.Object.flag_estado [row] 
ls_user        = This.Object.cod_usr [row] 


IF ls_flag_estado='1' and Trim(ls_user) <> trim(gs_user) THEN
	messagebox('Aviso', 'Usuario no autorizado a modificar')
	
	return
END IF

CHOOSE CASE dwo.name
		 CASE	'cal_rec_tipo'	
				SELECT Count(*)
				  INTO :ll_count
				  FROM cal_reclamo_tipo
				 WHERE (cal_rec_tipo = :data ) ;
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					
					This.Object.cal_rec_tipo [row] = ls_codigo
					This.Object.cal_reclamo_tipo_descripcion  [row] = ls_codigo
					Messagebox('Aviso','Debe ingresar un codigo de tipo de raclamo')	
					Return 1
				ELSE
					SELECT descripcion
				     INTO :ls_descrip
				     FROM cal_reclamo_tipo
				    WHERE (cal_rec_tipo = :data ) ;
					 
					ii_update = 1
					This.Object.cal_reclamo_tipo_descripcion [row] = ls_descrip
				END IF

		 CASE	'cod_art'	
				SELECT Count(*)
				  INTO :ll_count
				  FROM articulo
				 WHERE (cod_art = :data ) ;
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					
					This.Object.cod_art [row] = ls_codigo
					This.Object.articulo_nom_articulo [row] = ls_codigo
					Messagebox('Aviso','Debe ingresar un Codigo de cuenta presupuestal Valida')	
					Return 1
				ELSE
					SELECT nom_articulo
				     INTO :ls_descrip
				     FROM articulo
				    WHERE (cod_art = :data ) ;
					 
					ii_update = 1
					This.Object.articulo_nom_articulo [row] = ls_descrip
				END IF
		
		 CASE 'cencos_rsp'
			
				SELECT COUNT(*)
				  INTO   :ll_count
				  FROM   centros_costo
				WHERE  cencos = :data;
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					This.Object.cencos_rsp                [row] = ls_codigo
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
				
		 CASE 'cliente'
			
				SELECT COUNT(*)
				  INTO :ll_count
				  FROM proveedor
				WHERE  proveedor = :data;
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					This.Object.cliente                 [row] = ls_codigo
					This.Object.proveedor_nom_proveedor [row] = ls_codigo
					Messagebox('Aviso','Debe ingresar un cliente valido')	
					Return 1
				ELSE
				   SELECT nom_proveedor
				     INTO :ls_descrip
					  FROM proveedor
					 WHERE proveedor = :data ;
					
					This.Object.proveedor_nom_proveedor [row] = ls_descrip
				END IF
				
				ii_update = 1
			
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;this.SetItem( al_row, 'flag_estado', '1' )
this.SetItem( al_row, 'cod_origen', gs_origen )
this.SetItem( al_row, 'fecha_registro', today() )
this.SetItem( al_row, 'cod_usr', gs_user )
is_accion = 'new'
//proteger respuesta
dw_master.object.respuesta_rsp.Protect = 1
end event

type gb_1 from groupbox within w_ope306_reclamo_calidad
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

