$PBExportHeader$w_cd304_remesa.srw
forward
global type w_cd304_remesa from w_abc
end type
type cb_1 from commandbutton within w_cd304_remesa
end type
type dw_detail from u_dw_abc within w_cd304_remesa
end type
type dw_master from u_dw_abc within w_cd304_remesa
end type
end forward

global type w_cd304_remesa from w_abc
integer width = 3150
integer height = 1816
string title = "[CD304] Emite Remesa "
string menuname = "m_mantenimiento_sl"
cb_1 cb_1
dw_detail dw_detail
dw_master dw_master
end type
global w_cd304_remesa w_cd304_remesa

type variables
// Tipos de movimiento
String 		is_doc_otr, is_salir, is_tabla, is_colname[], &
				is_coltype[], is_oper_ing_otr, is_oper_sal_otr,is_accion
			
Int 			ii_ref, ii_cerrado
DATETIME 	id_fecha_proc
Boolean 		ib_log = FALSE, ib_mod=false, ib_control_lin = false 


end variables

forward prototypes
public function boolean of_set_num ()
public subroutine of_retrieve (string as_remesa)
end prototypes

public function boolean of_set_num ();Boolean lb_retorno = TRUE
Long	  ll_nro_reg, j
String  ls_lock_table, ls_num_liquidacion

//messagebox('Aviso','of_set_numera')

//messagebox('Origen', gs_origen)

ls_lock_table = 'LOCK TABLE NUM_REMESAS IN EXCLUSIVE MODE'
EXECUTE IMMEDIATE :ls_lock_table ;



SELECT count(*) 
  INTO :ll_nro_reg 
  FROM num_remesas 
 WHERE origen = :gs_origen ;

IF ll_nro_reg = 0 THEN
	INSERT INTO num_remesas(origen, ult_nro) 
	VALUES(:gs_origen, 2) ;

	ll_nro_reg = 1 
ELSE
	SELECT ult_nro 
	  INTO :ll_nro_reg 
	 FROM num_remesas 
	WHERE origen = :gs_origen ;
	
	//Actualiza Tabla num_remesa
	UPDATE num_remesas
		SET ult_nro = :ll_nro_reg + 1
	 WHERE (origen = :gs_origen ) ;
	
END IF

//messagebox('Numero', string(ll_nro_reg))

	
IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
	lb_retorno = FALSE
	GOTO SALIDA
END IF	

//ARMAR NRO DE REMESA
ls_num_liquidacion = gs_origen + f_llena_caracteres('0',Trim(String(ll_nro_reg)),8)

//messagebox('Remesa', ls_num_liquidacion)

dw_master.object.nro_remesa[dw_master.GetRow()]=ls_num_liquidacion
dw_master.accepttext()

FOR j = 1 TO dw_detail.RowCount()
	dw_detail.object.nro_remesa[j] = ls_num_liquidacion
NEXT
dw_detail.accepttext()


SALIDA:

RETURN lb_retorno	

end function

public subroutine of_retrieve (string as_remesa);Long ll_row
dw_master.retrieve(as_remesa)


is_Action = 'open'

if dw_master.GetRow() > 0 then		
	dw_detail.retrieve(as_remesa)
end if

dw_master.il_row = ll_row
dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()

dw_detail.ii_update = 0
dw_detail.ii_protect = 0
dw_detail.of_protect()
end subroutine

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if

end event

event resize;call super::resize;Long ll_y
dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 35

	
	

end event

event ue_insert;call super::ue_insert;Long  	ll_row, ll_ano, ll_mes, ll_mov_atrazados
string	ls_msg

is_accion = 'new'

IF idw_1 = dw_detail THEN	
	if is_Action <> 'new' then
		MessageBox("Error", "No se puede insertar otro item a este Registro")
		RETURN
	end if
	IF dw_master.GetRow() = 0 THEN
		MessageBox("Error", "No existe cabecera de la Remesa")
		RETURN
	END IF	

	/*if dw_master.GetRow() <> 0 then
		if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' &
			and idw_1 = dw_detail then
			MessageBox('Aviso', 'No puede ingresar mas detalles a la Remesa')
			return
		end if
	end if*/
END IF

if idw_1 = dw_master then

	// Limpia dw
	dw_master.Reset()
	dw_detail.Reset()
else
	if is_action <> 'new' then
		is_action = 'edit'
	end if
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN 
	THIS.EVENT ue_insert_pos(ll_row)
	dw_master.object.p_logo.filename = gs_logo
end if

end event

on w_cd304_remesa.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.cb_1=create cb_1
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.dw_master
end on

on w_cd304_remesa.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

event ue_insert_pos;call super::ue_insert_pos;idw_1.setcolumn(1)
end event

event ue_open_pre;call super::ue_open_pre;of_position_window(10,10)  
dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)
idw_1 = dw_master              		// asignar dw corriente
idw_1.TriggerEvent(clicked!)
dw_master.of_protect()         		// bloquear modificaciones 
dw_detail.of_protect()
ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
ib_log = TRUE
is_tabla = 'cd_remesa'
is_accion = 'open'
dw_master.object.p_logo.filename = gs_logo
cb_1.enabled=false

////

//// Abriendo el ultimo registro
//Long ll_count 
//String ls_nro_remesa
//
//of_position_window(100,100) 
//
//SELECT count(*) 
//  INTO :ll_count 
//  FROM cd_remesa ;
//
//IF ll_count>0 THEN   
//	SELECT nro_remesa
//	  INTO :ls_nro_remesa
//	  FROM cd_remesa
//	 WHERE (rowid IN (SELECT MAX(rowid) FROM cd_remesa)) ;
//	 
// 	dw_master.retrieve( ls_nro_remesa )
//END IF
//
//is_action = 'open'
end event

event ue_update;call super::ue_update;Long 		ll_row_master
Datetime ldt_fecha_emision
Boolean 	lbo_ok = TRUE
String 	ls_msg1, ls_msg2

if dw_master.rowcount() = 0 then return
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()

IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
end if

//messagebox('dw_master',string(dw_master.ii_update))

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN	
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Master"
		ls_msg2 = "Se ha procedido al rollback"		
	END IF
END IF

//messagebox('dw_detalle',string(dw_detail.ii_update))
IF dw_detail.ii_update = 1 THEN	
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Detalle"
		ls_msg2 = "Se ha procedido al rollback"		
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	is_action = 'open'
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
//	dw_master.Retrieve(dw_master.object.nro_remesa[dw_master.GetRow()])
//	dw_detail.retrieve(dw_master.object.nro_remesa[dw_master.GetRow()])
ELSE 
	ROLLBACK USING SQLCA;
	//messagebox(ls_msg1,ls_msg2,exclamation!)	
END IF

is_accion = 'open'
end event

event ue_update_pre;call super::ue_update_pre;String ls_origen, ls_flag_tabla, ls_cierre, ls_flag_estado, ls_nro_liquidacion
String ls_nro_registro, ls_cod_user_transfer
Integer i
Long ll_nro_libro, ll_ano, ll_mes, j, ll_row, ll_row_master
Decimal ld_sdebe, ld_shaber, ld_ddebe, ld_dhaber

if dw_detail.rowcount() = 0 then 
	rollback ;
	messagebox( "Atencion", "No se grabara el documento, falta detalle")
	return
end if

IF is_accion = 'new' then
	//genera numeracion
	IF of_set_num()	= FALSE THEN
		ib_update_check = False	
		Return
	END IF
	ls_cod_user_transfer = dw_master.object.usr_destino[dw_master.GetRow()] 
	FOR i=1 TO dw_detail.RowCount()
		ls_nro_registro = dw_detail.object.nro_registro[i] 
		// El update a cd_cod_recibido, se maneja por trigger
//		UPDATE cd_doc_recibido 
//         SET flag_transfer = '2', 
//				 cod_user_transfer = :ls_cod_user_transfer
//       WHERE nro_registro = :ls_nro_registro ;
	NEXT
ELSE
	FOR i=1 TO dw_detail.RowCount()
		dw_detail.object.nro_remesa[i] = dw_master.object.nro_remesa[dw_master.GetRow()]
	NEXT
	dw_detail.ii_update = 1
END IF

ib_update_check = true

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF

end event

event ue_list_open;call super::ue_list_open;// Asigna valores a structura 

str_parametros sl_param

sl_param.dw1    = 'd_remesas_grd' 
sl_param.titulo = 'REMESAS'
sl_param.field_ret_i[1] = 1	//Remesas

OpenWithParm( w_lista, sl_param )


sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	//messagebox('Aviso',sl_param.field_ret[1])
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_modify;call super::ue_modify;String ls_user

IF dw_master.GetRow()=0 THEN RETURN

ls_user = dw_master.object.usr_remite[dw_master.GetRow()]

messagebox('User', ls_user)

IF trim(ls_user) <> trim(gs_user) THEN
	Messagebox('Aviso', 'Usuario no autorizado a modificar datos de registro')
	cb_1.enabled = false
	Return 
END IF 
dw_master.of_protect() 
dw_detail.of_protect() 
cb_1.enabled = true



end event

type cb_1 from commandbutton within w_cd304_remesa
integer x = 2601
integer y = 696
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Referencias"
end type

event clicked;Long    ll_row_master,ll_ano,ll_mes, j
String  ls_usr_destino , ls_cod_relacion , ls_area_destino, ls_seccion_destino, &
		  ls_origen_destino, ls_grupo, ls_tipo_doc ,ls_matriz, ls_remesa
Decimal {3} ldc_tasa_cambio
str_parametros sl_param

ll_row_master = dw_master.Getrow()

dw_master.Accepttext()

IF ll_row_master = 0 THEN Return

ls_cod_relacion 	 = dw_master.object.usr_remite[ll_row_master]
ls_usr_destino  	 = dw_master.object.usr_destino[ll_row_master]
ls_area_destino 	 = dw_master.object.area_destino[ll_row_master]
ls_seccion_destino =	dw_master.object.seccion_destino[ll_row_master]
ls_origen_destino	 =	dw_master.object.org_destino[ll_row_master]

sl_param.dw1		= 'd_lista_doc_recibidos_tbl'
sl_param.titulo	= 'Documentos para Remesa'
sl_param.tipo		= '1CP'
sl_param.opcion   = 16 
sl_param.string1   = gs_user
sl_param.db1 		= 1600
sl_param.dw_m		= dw_detail
sl_param.string1  = gs_user

OpenWithParm( w_abc_seleccion_lista, sl_param)

FOR j = 1 TO dw_detail.RowCount()
		dw_detail.object.org_destino 	  	[j] = dw_master.object.org_destino[dw_master.GetRow()]
		dw_detail.object.usr_destino    	[j] = dw_master.object.usr_destino[dw_master.GetRow()]
		dw_detail.object.area_destino   	[j] = dw_master.object.area_destino[dw_master.GetRow()]
		dw_detail.object.seccion_destino	[j] = dw_master.object.seccion_destino[dw_master.GetRow()]
		dw_detail.object.flag_estado		[j] = '1'
		dw_detail.ii_update=1
NEXT

end event

type dw_detail from u_dw_abc within w_cd304_remesa
integer x = 37
integer y = 876
integer width = 3031
integer height = 652
integer taborder = 20
string dataobject = "d_remesa_detalle"
boolean hscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                      	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst = dw_master
idw_det = dw_detail
end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_remesa		[al_row] = dw_master.object.nro_remesa      [dw_master.GetRow()]
this.object.origen_destino [al_row] = dw_master.object.origen_remite   [dw_master.GetRow()]
this.object.usr_destino    [al_row] = dw_master.object.origen_remite   [dw_master.GetRow()]
this.object.area_destino   [al_row] = dw_master.object.area_destino    [dw_master.GetRow()]
this.object.seccion_destino[al_row] = dw_master.object.seccion_destino [dw_master.GetRow()]



end event

type dw_master from u_dw_abc within w_cd304_remesa
event ue_display ( string as_columna,  long al_row )
integer x = 32
integer y = 36
integer width = 3022
integer height = 800
string dataobject = "d_remesa_cabecera"
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
String ls_origen, ls_usuario, ls_area, ls_seccion, ls_nombre
str_seleccionar lstr_seleccionar


CHOOSE CASE UPPER(as_columna)

CASE "USR_DESTINO"
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT CD_USUARIO_SECCION.COD_ORIGEN AS ORIGEN, '	&
					 		+'CD_USUARIO_SECCION.COD_USR AS USUARIO, '	&
					 		+'USUARIO.NOMBRE AS NOMBRE, '						&
					 		+'CD_USUARIO_SECCION.COD_AREA AS AREA, '		&
					 		+'CD_USUARIO_SECCION.COD_SECCION AS SECCION '&										 
					 +'FROM CD_USUARIO_SECCION, USUARIO ' &
					 +'WHERE CD_USUARIO_SECCION.COD_USR=USUARIO.COD_USR '&
					 +  'AND CD_USUARIO_SECCION.FLAG_RECEPCION=1 AND CD_USUARIO_SECCION.FLAG_ESTADO=1' 
		
//nuevo
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_origen 	= lstr_seleccionar.param1[1]
	ls_usuario 	= lstr_seleccionar.param2[1]
	ls_nombre 	= lstr_seleccionar.param3[1]
	ls_area 		= lstr_seleccionar.param4[1]
	ls_seccion 	= lstr_seleccionar.param5[1]

	This.object.org_destino [al_row] = ls_origen
	This.object.area_destino   [al_row] = ls_area
	This.object.usr_destino    [al_row] = ls_usuario
	This.object.seccion_destino[al_row] = ls_seccion
	This.object.usuario_nombre [al_row] = ls_nombre

end IF
end choose
cb_1.enabled=true

//

/*		ls_sql = "SELECT cd.cod_usr AS codigo,"  &
					+ "usu.nombre As Nombre "        &
			 		+ "FROM cd_usuario_seccion cd,"  &
					+ "usuario usu " 					  &
			  	   + "WHERE cd.cod_usr=usu.cod_usr " &
			      + "and cd.flag_recepcion = '1' "*/

/*		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
	
		IF ls_codigo <> '' THEN
			This.object.usr_destino	   [al_row] = ls_codigo
			This.object.usuario_nombre [al_row] = ls_data						
		END IF
		This.ii_update = 1
end choose

cb_1.enabled=true*/


/*probando que dispare ventana---
Long    ll_row_master,ll_ano,ll_mes
String  ls_cod_moneda ,ls_cod_relacion ,ls_result,ls_mensaje,ls_confin,ls_grupo,&
		  ls_tipo_doc

str_parametros sl_param

ll_row_master = dw_master.Getrow()

dw_master.Accepttext()
IF ll_row_master = 0 THEN Return

ls_cod_relacion = dw_master.object.usr_destino[ll_row_master]

sl_param.dw1		= 'd_lista_doc_recibidos_tbl'
sl_param.titulo	= 'Documentos para Remesa'
sl_param.opcion   = 16  //liquidacion de caja
sl_param.db1 		= 1600


OpenWithParm( w_abc_seleccion_lista, sl_param)

*/
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
//of_set_status_doc(THIS)
IF dw_master.GetRow()=0 THEN 
	Return
END IF
IF dw_master.object.flag_estado[dw_master.GetRow()]='2' THEN
	MessageBox('Aviso','Estado cerrado, no acepta modificaciones')
	Return
END IF
end event

event constructor;call super::constructor;is_mastdet = 'md'	
is_dwform = 'form' // tabular form

ii_ck[1] = 1				// columnas de lectura de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
idw_mst  = dw_master
idw_det	= dw_detail
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 
u_dw_abc	ldw

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
if row = 0 then return

ls_columna = upper(dwo.name)
this.event dynamic ue_display(ls_columna, row)

end event

event itemchanged;call super::itemchanged;Int 		li_val, li_saldo_consig, li_saldo_pres, li_saldo_dev
string 	ls_nombre, ls_area, ls_seccion, ls_origen, ls_null, ls_mensaje, ls_desc, ls_user
DATE 		ld_null
Long ll_count

This.AcceptText()
if row = 0 then return

Setnull( ls_null)

CHOOSE CASE lower(dwo.name)
		
	CASE 'usr_destino'
		ls_user = data 
		
		SELECT count(*)
		  INTO :ll_count 
		  FROM cd_usuario_seccion c 
		 WHERE c.cod_usr=:ls_user AND flag_recepcion='1' ;
		
		IF ll_count=0 THEN
			MessageBox('Aviso','Usuario destino no configurado para remesas')
			this.object.usr_destino[row] = ls_null
		 	this.setfocus()
			Return 1
		ELSE
			SELECT c.cod_area, c.cod_seccion, c.cod_origen, u.nombre
			  INTO :ls_area, :ls_seccion, :ls_origen, :ls_nombre 
			  FROM cd_usuario_seccion c, usuario u 
			 WHERE c.cod_usr = u.cod_usr AND c.cod_usr=:ls_user and c.flag_recepcion='1' ;
		END IF 
		
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCOde = 100 then
				Messagebox('Aviso','Codigo de usuario no existe o no esta activo')
			else
				MessageBox('Aviso', SQLCA.SQLErrText)
			end if
			this.Object.usr_destino 			[row] = ls_null
			this.Object.org_destino				[row] = ls_null
			this.Object.area_destino 			[row] = ls_null
			this.Object.seccion_destino 		[row] = ls_null
			this.object.usuario_nombre			[row] = ls_null
		 	this.setfocus()
			RETURN 1
		END IF
		this.object.usuario_nombre			[row] = ls_nombre
		this.Object.org_destino				[row] = ls_origen
		this.Object.area_destino 			[row] = ls_area
		this.Object.seccion_destino 		[row] = ls_seccion

		
		cb_1.enabled = TRUE

END CHOOSE

end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;String	ls_nom_usr, ls_nombre, ls_cod_area, ls_cod_seccion, ls_cod_origen
Long 		ll_ano, ll_mes, ll_count 

SELECT count(*)
  INTO :ll_count 
  FROM cd_usuario_seccion c
 WHERE c.cod_usr=:gs_user AND c.cod_origen=:gs_origen ;

IF ll_count=0 THEN
	MessageBox('Aviso','Usuario no definido en origen')
	Return
ELSEIF ll_count>1 THEN
	MessageBox('Aviso','Usuario tiene varios registros en mismo origen')
	Return
ELSE
	SELECT c.cod_area, c.cod_seccion, c.cod_origen 
	  INTO :ls_cod_area, :ls_cod_seccion, :ls_cod_origen 
	  FROM cd_usuario_seccion c
	 WHERE c.cod_usr=:gs_user AND c.cod_origen=:gs_origen ;
END IF 

ls_nombre=''

select nombre
	into :ls_nom_usr
from usuario
where cod_usr = :gs_user;

this.object.usr_remite	 [al_row] = gs_user
this.object.origen_remite [al_row] = ls_cod_origen 
this.object.area_remite [al_row] = ls_cod_area
this.object.seccion_remite [al_row] = ls_cod_seccion 
this.object.fecha_emision[al_row] = today()
this.object.flag_remesa [al_row]  = '1'
this.object.flag_estado [al_row]  = '1'

is_action = 'new'

end event

