$PBExportHeader$w_ope317_reservacion_material.srw
forward
global type w_ope317_reservacion_material from w_abc_mastdet
end type
type sle_nro from u_sle_codigo within w_ope317_reservacion_material
end type
type cb_1 from commandbutton within w_ope317_reservacion_material
end type
type st_nro from statictext within w_ope317_reservacion_material
end type
end forward

global type w_ope317_reservacion_material from w_abc_mastdet
integer width = 2331
integer height = 2212
string title = "OPE317 Reservacion de Materiales"
string menuname = "m_master_lista_anular"
event ue_anular ( )
sle_nro sle_nro
cb_1 cb_1
st_nro st_nro
end type
global w_ope317_reservacion_material w_ope317_reservacion_material

type variables
string	is_accion
integer	ii_DIAS_VENC_RESERVAC
			
DatawindowChild idw_child

Decimal idc_cantidad

end variables

forward prototypes
public subroutine of_asignar_dws ()
public function boolean of_set_articulo (string as_cod_art, string as_almacen)
public function boolean of_set_saldo_total (string as_cod_art, string as_almacen)
public subroutine wf_accepttext ()
public subroutine wf_bloquea_dw ()
public subroutine of_bloquear_dws ()
public subroutine of_retrieve (string as_nro)
public function integer of_nro_item (datawindow adw_1)
public subroutine of_set_modify ()
end prototypes

event ue_anular;Long     ll_row, ll_i
String   ls_flag_estado, ls_nro_doc, ls_msj_err, ls_flag_automatico
Integer  li_opcion
Boolean  lb_ok = TRUE

ll_row = dw_master.Getrow()

IF ll_row = 0 OR is_accion = 'new' THEN RETURN 

TriggerEvent('ue_update_request')
IF ib_update_check = FALSE THEN RETURN

// Verifica si esta anulada
ls_flag_estado = dw_master.Object.flag_estado [ll_row]
ls_flag_automatico = dw_master.object.flag_automatico[ll_row]

IF ls_flag_estado <> '1'  THEN  
	Messagebox('Aviso','Documento no esta activo')	
	RETURN
END IF 

IF ls_flag_automatico = '1'  THEN  
	Messagebox('Aviso','No puede anular una reservacion automática')	
	RETURN
END IF 

li_opcion = MessageBox('Aviso','Esta Seguro de anular revervación de materiales',Question!, yesno!, 2) //pgta

IF li_opcion = 2 THEN RETURN //no desea anular orden de trabajo

ls_nro_doc = dw_master.Object.nro_reservacion [ll_row]

of_retrieve( ls_nro_doc)

//cambiar estado de la orden de trabajo
dw_master.object.flag_estado [ll_row] = '0'
dw_master.ii_update = 1

for ll_i = 1 to dw_detail.RowCount( )
	if dw_detail.object.flag_estado[ll_i] = '1' then
		dw_detail.object.flag_estado[ll_i] = '0' //Anulo solamente los que estan activos nada mas
		dw_detail.ii_update = 1
	end if
next
end event

public subroutine of_asignar_dws ();// Asigno los Datawindows con sus respectivas variables globales

dw_master.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)

end subroutine

public function boolean of_set_articulo (string as_cod_art, string as_almacen);string 	ls_almacen, ls_cod_clase, ls_flag_reposicion
Long ll_row
Decimal {4}	ld_saldo_total, ld_costo_ult_compra
// Setea las variables x defecto de acuerdo al codigo de articulo
// x ejemplo el almacen tácito y el precio en articulo_precio_pactado

if dw_detail.GetRow() = 0 then return false

ll_row = dw_detail.GetRow()

ld_saldo_total = dw_detail.object.articulo_almacen_sldo_total[ll_row]
ld_costo_ult_compra = dw_detail.object.articulo_mov_proy_precio_unit[ll_row]

IF ld_saldo_total=0 and ld_costo_ult_compra = 0 THEN

	select NVL(sldo_total,0), NVL(costo_ult_compra,0)
	  into :ld_saldo_total, :ld_costo_ult_compra
	  from articulo_almacen aa
	 where aa.cod_art=:as_cod_art and
			 aa.almacen=:as_almacen ;
	
	dw_detail.object.articulo_almacen_sldo_total[ll_row] = ld_saldo_total
	dw_detail.object.articulo_mov_proy_precio_unit[ll_row] = ld_costo_ult_compra

END IF

return true
end function

public function boolean of_set_saldo_total (string as_cod_art, string as_almacen);Decimal	ldc_saldo_total, ldc_costo_unit

if dw_detail.GetRow() = 0 then return false

select sldo_total
	into :ldc_saldo_total
from articulo_almacen
where cod_art = :as_cod_art
  and almacen = :as_almacen;

if SQLCA.SQLCode = 100 then ldc_saldo_total = 0

dw_detail.object.articulo_almacen_sldo_total[dw_detail.GetRow()] = ldc_saldo_Total

SELECT usf_cmp_prec_ult_compra(:as_cod_art, :as_almacen ) 
  INTO :ldc_costo_unit 
  FROM dual ;

dw_detail.object.articulo_mov_proy_precio_unit[dw_detail.GetRow()] = ldc_costo_unit


return true
end function

public subroutine wf_accepttext ();/* funcion de ventana que realiza los accepttext sobre todos los dw */
dw_master.Accepttext()
dw_detail.Accepttext()

end subroutine

public subroutine wf_bloquea_dw ();dw_master.ii_protect = 0
dw_detail.ii_protect       	 = 0
								
dw_master.of_protect()
dw_detail.of_protect() //SALIDAS

end subroutine

public subroutine of_bloquear_dws ();// Asigno los Datawindows con sus respectivas variables globales
dw_master.ii_protect = 1
dw_master.of_protect()

dw_detail.ii_protect = 1
dw_detail.of_protect()

end subroutine

public subroutine of_retrieve (string as_nro);this.event ue_update_request( )

dw_master.Retrieve(as_nro)
dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect( )

dw_detail.Retrieve(as_nro)
dw_detail.ii_update = 0
dw_detail.ii_protect = 0
dw_detail.of_protect( )

is_Accion = 'open'
return
end subroutine

public function integer of_nro_item (datawindow adw_1);// Genera numero de item para un dw
Integer ll_i, ll_mayor

ll_mayor = adw_1.object.nro_item[1]
if isnull(ll_mayor) then
	ll_mayor = 0
end if
For ll_i = 1 to adw_1.RowCount()
	if adw_1.object.nro_item[ll_i] > ll_mayor then
		ll_mayor = adw_1.object.nro_item[ll_i]
	end if
Next
ll_mayor ++

Return ll_mayor
end function

public subroutine of_set_modify ();//Cantidad
dw_detail.Modify("cantidad.Protect ='1~tIf(flag_estado <> ~~'1~~',1,0)'")
dw_detail.Modify("cantidad.Background.color ='1~tIf(flag_estado <> ~~'1~~', RGB(192,192,192),RGB(255,255,255))'")

//Codigo de Articulo
dw_detail.Modify("cod_art.Protect ='1~tIf(flag_estado <> ~~'1~~',1,0)'")
dw_detail.Modify("cod_art.Background.color ='1~tIf(flag_estado <> ~~'1~~', RGB(192,192,192),RGB(255,255,255))'")


end subroutine

on w_ope317_reservacion_material.create
int iCurrent
call super::create
if this.MenuName = "m_master_lista_anular" then this.MenuID = create m_master_lista_anular
this.sle_nro=create sle_nro
this.cb_1=create cb_1
this.st_nro=create st_nro
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nro
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_nro
end on

on w_ope317_reservacion_material.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_nro)
destroy(this.cb_1)
destroy(this.st_nro)
end on

event ue_retrieve_list;call super::ue_retrieve_list;////// Asigna valores a structura 
String ls_estado
str_parametros sl_param

TriggerEvent ('ue_update_request')		
IF ib_update_check = FALSE THEN RETURN

ls_estado = '1'

sl_param.dw1     = 'd_lista_reservacion_tbl'
sl_param.titulo  = 'Reservaciones'
sl_param.tipo    = '1SQL'
//sl_param.string1 =  ' WHERE ("reservacion "."flag_estado" = '+"'"+ls_estado+"'"+') '

sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
END IF

end event

event open;call super::open;// Ancestor Script has been Override
idw_1 = dw_master
is_accion = 'new' 

of_asignar_dws()

end event

event ue_delete;//Override
Long   ll_row
String ls_flag_estado, ls_flag_automatico

ll_row = dw_master.getrow()

IF ll_row = 0 THEN RETURN

ls_flag_estado = dw_master.Object.flag_estado [ll_row] // estado de la ot
ls_flag_automatico = dw_master.object.flag_automatico[ll_row]

IF ls_flag_estado <> '1' THEN //no esta activo
	Messagebox('Aviso','Estado de documento de Reservaciones no permite eliminaciones , Verifique!')
	RETURN
END IF

IF ls_flag_automatico = '1' THEN 	
	Messagebox('Aviso','No puede eliminar/modificar una reservacion que es automática')
	RETURN	
END IF

//Verifico si el flag_estado del detalle esta activo
if idw_1 = dw_detail then
	if idw_1.GetRow() > 0 then
		IF idw_1.object.flag_estado[idw_1.GetRow()] <> '1' THEN 	
			Messagebox('Aviso','No puede eliminar/modificar este detalle de la reservacion ya que no esta activa')
			RETURN	
		END IF
	end if
end if

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

event ue_insert;// Ancestor Override

Long  	ll_row
String   ls_flag_estado, ls_flag_automatico

wf_accepttext() //accepttext del dw

CHOOSE CASE idw_1
		 CASE dw_master
				
		     // Adicionando en dw_master
			  TriggerEvent ('ue_update_request') //verificar ii_update de los dw

			  IF ib_update_check = FALSE THEN RETURN
			  
			  // Limpieza de los demas dw en insercion
			  dw_master.Reset()
			  dw_detail.Reset()
			  
			  is_accion = 'new' 
			  			  
		CASE dw_detail
			ll_row = dw_master.Getrow()
			
			IF ll_row = 0 then return
			
			ls_flag_estado = dw_master.object.flag_estado [ll_row]	//estado de la orden de trabajo
			ls_flag_automatico = dw_master.object.flag_automatico[ll_row]
			  
			IF ls_flag_estado <> '1' THEN 	
			  	Messagebox('Aviso','No puede añadir a una reservacion que no esta activa')
			  	RETURN	
			END IF
			
			IF ls_flag_automatico = '1' THEN 	
			  	Messagebox('Aviso','No puede añadir a una reservacion que es automática')
			  	RETURN	
			END IF

	CASE ELSE
			  RETURN
END CHOOSE

//insertar
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
END IF

end event

event ue_modify;//Ancestor Overrding
Long   ll_row
String ls_flag_estado, ls_flag_automatico

ll_row = dw_master.Getrow()

IF ll_row = 0 THEN RETURN //NO EXISTE REGISTRO DE OT

ls_flag_estado = dw_master.Object.flag_estado 			[ll_row]
ls_flag_automatico = dw_master.object.flag_automatico	[ll_row]

IF ls_flag_estado <> '1' THEN //ACTIVO O PROYECTADO
	MessageBox('aviso', 'No puede modificar porque no esta activo')
	return
end if

IF ls_flag_automatico = '1' THEN //Reservación automática
	MessageBox('aviso', 'No puede modificar porque es una reservación automática')
	return
end if

dw_master.of_protect()
dw_detail.of_protect() //SALIDAS

if dw_detail.ii_protect = 0 then
	of_set_modify()
end if




end event

event ue_open_pre;call super::ue_open_pre;String ls_nro_sol_orden, ls_tipo_doc
Long   ll_row

of_position_window(0,0)        				// Posicionar la ventana en forma fija
im_1 = CREATE m_rButton
idw_1 = dw_master
//Help
ii_help = 317

select NVL(DIAS_VENC_RESERVAC, 7)
  into :ii_DIAS_VENC_RESERVAC
  from logparam
 where reckey = '1';

//ACtualizo todas las reservaciones vencidas
update reservacion_det
   set flag_estado = '5'
where trunc(fec_vencimiento) < trunc(sysdate)
  and flag_Estado = '1';

commit;  
end event

event ue_print;call super::ue_print;String  ls_nro_reservacion
Str_cns_pop lstr_cns_pop

//Verificacion de Nro de Reservacion
IF dw_master.GetRow()=0 THEN RETURN

ls_nro_reservacion = dw_master.GetItemString(1, 'nro_reservacion'   )


IF is_accion = 'new' THEN RETURN

lstr_cns_pop.arg[1] = ls_nro_reservacion

OpenSheetWithParm(w_ope317_reservacion_material_rpt, lstr_cns_pop, this, 2, Layered!)
	


end event

event ue_update;//Ancestor Overriding
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf, ls_nro_reserv

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	if dw_master.GetRow() = 0 then return
	ls_nro_reserv = dw_master.object.nro_reservacion[dw_master.GetRow()]
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.REsetUpdate()
	dw_detail.ResetUpdate()
	
	of_retrieve( ls_nro_reserv )
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
END IF

end event

event ue_update_pre;call super::ue_update_pre;Long      ll_row_det,ll_inicio
String    ls_cod_origen, ls_nro_doc, ls_oper_sec, ls_nro_reserv
Long      ll_row_master
Decimal   ldc_cant_proy, ld_precio_unit
dwItemStatus ldis_status

//is_doc_ot
ib_update_check = True


//invocar objeto de numeracion de parte
nvo_numeradores_varios lnvo_numeradores_varios
lnvo_numeradores_varios    = CREATE nvo_numeradores_varios
//

ll_row_master = dw_master.Getrow()

IF dw_master.Rowcount() = 0 THEN
	Messagebox('Aviso','No existe documento de Reservaciones, Verifique!')
	ib_update_check = False
	RETURN
END IF

//--VERIFICACION Y ASIGNACION DE DATOS DE ORDEN DE TRABAJO
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
end if

//--VERIFICACION Y ASIGNACION DE DATOS EN DETALLE DE ARTICULOS
if f_row_Processing( dw_detail, "tabular") <> true then	
	ib_update_check = False	
	return
end if

ls_cod_origen = dw_master.object.cod_origen [dw_master.GetRow()]
ls_nro_reserv  = dw_master.object.nro_reservacion [dw_master.GetRow()] 

IF is_accion = 'new' THEN
	IF lnvo_numeradores_varios.uf_num_reservados(ls_cod_origen, ls_nro_reserv) = FALSE THEN
		ib_update_check = False	
		RETURN
	ELSE
		dw_master.Object.nro_reservacion [ll_row_master] = ls_nro_reserv
	END IF
END IF

FOR ll_inicio = 1 TO dw_detail.Rowcount()  //SALIDA DE articulo x operaciones
	 //verifica si es un nuevo registro
	 dw_detail.object.nro_reservacion[ll_inicio] = ls_nro_reserv
NEXT

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

end event

event ue_update_request;//override
Integer li_msg_result

wf_accepttext()

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1) THEN
	 li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	 IF li_msg_result = 1 THEN
 		 This.TriggerEvent("ue_update")
	 ELSE
		 dw_master.ii_update = 0
		 dw_detail.ii_update = 0	 	
	 END IF
END IF

end event

type dw_master from w_abc_mastdet`dw_master within w_ope317_reservacion_material
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 136
integer width = 2176
integer height = 504
string dataobject = "d_abc_reservacion_material_ff"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "tipo_doc_ref"
		ls_sql = "SELECT tipo_doc AS tipo_documento, " &
				  + "DESC_TIPO_DOC AS DESCRIPCION_tipo_doc " &
				  + "FROM doc_tipo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.tipo_doc_ref[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose

end event

event dw_master::constructor;call super::constructor;//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
idw_det  =  dw_detail
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;String 	ls_dato
DateTime ldt_fecha

ldt_fecha = f_fecha_actual()

this.object.flag_estado  	 [al_row] = '1'      //estado de la reservacion material
this.object.cod_origen   	 [al_row] = gs_origen
this.object.cod_usr      	 [al_row] = gs_user
this.object.fecha	 			 [al_row] = ldt_fecha
this.object.ano				 [al_row] = Year(Date(ldt_fecha))
this.object.mes				 [al_row] = Month(Date(ldt_fecha))

this.object.flag_automatico [al_row] = '0'

select nombre 
  into :ls_dato 
  from origen u 
 where u.cod_origen=:gs_origen ;

dw_master.object.nom_origen 	 [al_row] = ls_dato

select nombre 
  into :ls_dato 
  from usuario u 
 where u.cod_usr=:gs_user ;

dw_master.object.nom_usuario 	 [al_row] = ls_dato

is_accion = 'new'



end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
Send(Handle(this),256,9,Long(0,0))   // fuerza a dar enter
end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0
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

event dw_master::itemchanged;call super::itemchanged;string ls_data, ls_null
SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "tipo_doc_ref"
		select desc_tipo_doc
			into :ls_data
		from doc_tipo
		where tipo_doc = :data
		  and flag_estado = '1';

		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "TIPO DE DOCUMENTO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.tipo_doc_ref	[row] = ls_null
			return 1
		end if

end choose
end event

type dw_detail from w_abc_mastdet`dw_detail within w_ope317_reservacion_material
integer x = 0
integer y = 656
integer width = 2190
integer height = 1220
string dataobject = "d_insumo_reservacion_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_ss = 0
end event

event dw_detail::doubleclicked;call super::doubleclicked;IF row = 0 THEN Return

String 	ls_name, ls_codigo, ls_almacen, &
 		 	ls_org_amp, ls_flag_reposicion, ls_oper_sec, ls_nro_ot
str_seleccionar lstr_seleccionar
Date		ld_fec_proyect	
Decimal 	ld_saldo_libre, ld_cantidad, ld_costo_unit, ld_saldo_total
Long 		ll_nro_amp

ls_name = dwo.name

if this.Describe( lower(dwo.name) + ".Protect") = '1' then return

CHOOSE CASE dwo.name
	CASE 'cod_art'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = "SELECT COD_ART AS CODIGO, "&   
									  + "NOM_ARTICULO AS DESCRIPCION, "&   
									  + "UND AS UNIDAD, "&
									  + "COD_ORIGEN AS ORIGEN, "&
									  + "ALMACEN AS ALMAC, "&									  
									  + "NRO_MOV AS NUMERO, "&								  
									  + "SALDO_LIBRE AS SALDO, "& 
									  + "ORD_TRABAJ AS NRO_OT, "& 
									  + "OPER_SEC AS OPERSEC "& 
									  + "FROM VW_OPE_SALDO_LIBRE_ARTICULO " &
									  + "where flag_reposicion = '0'"
									  
		OpenWithParm(w_seleccionar, lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		
		IF lstr_seleccionar.s_action = "aceptar" THEN
			
			this.object.cod_art 		[row] = lstr_seleccionar.param1[1]
			this.object.desc_art		[row] = lstr_seleccionar.param2[1]
			this.object.und			[row] = lstr_seleccionar.param3[1]
			this.object.org_amp_ref	[row] = lstr_seleccionar.param4[1]
			this.object.almacen		[row] = lstr_seleccionar.param5[1]			
			this.object.nro_amp_ref	[row] = LONG(lstr_seleccionar.paramdc6[1])
			this.object.cantidad		[row] = lstr_seleccionar.paramdc7[1]
			
			// Asigna datos a variables
			ls_org_amp  = lstr_seleccionar.param4[1]
			ls_almacen 	= lstr_seleccionar.param5[1]
			ll_nro_amp	  = LONG(lstr_seleccionar.paramdc6[1])
//			id_cantidad		= lstr_seleccionar.paramdc7[1]
			
		
			// Captura datos segun AMP
			SELECT aa.costo_ult_compra, 
					 aa.sldo_total,
					 aa.flag_reposicion, 
					 amp.oper_sec, 
					 amp.nro_doc,
					 trunc(amp.fec_proyect)
			  INTO :ld_costo_unit, 
					 :ld_saldo_total,
					 :ls_flag_reposicion, 
					 :ls_oper_sec, 
					 :ls_nro_ot, 
					 :ld_fec_proyect
			FROM 	articulo_mov_proy amp, 
					articulo_almacen 	aa, 
					articulo 			a 
			WHERE amp.cod_art = aa.cod_art 
			  and amp.almacen = aa.almacen 
			  and amp.cod_art = a.cod_art 
			  and amp.tipo_doc=(select doc_ot from logparam where reckey='1') 
			  and amp.cod_origen = :ls_org_amp
			  and amp.nro_mov 	= :ll_nro_amp;
			
			this.object.flag_reposicion[row] = ls_flag_reposicion
			this.object.oper_sec			[row] = ls_oper_sec
			this.object.nro_doc			[row] = ls_nro_ot
			this.object.sldo_total		[row] = ld_saldo_total
			this.object.precio_unit 	[row] = ld_costo_unit
			this.object.fec_proyect		[row] = ld_fec_proyect
			
			this.ii_update = 1
//			//of_set_articulo(lstr_seleccionar.param1[1], lstr_seleccionar.param5[1])
			END IF
END CHOOSE
end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_cod_art, ls_desc_art, ls_und, ls_almacen, ls_org_amp, &
		 	ls_null, ls_flag_reposicion, ls_oper_sec, ls_nro_ot
LONG 	 	ll_count, ll_nro_amp
Date		ld_fec_proyect
Decimal 	ldc_cantidad, ldc_costo_unit, ldc_saldo_total, ldc_cant_libre

str_seleccionar lstr_seleccionar

this.acceptText()

SetNull(ls_null)

IF dwo.name = 'cod_art' then
	
	SELECT count(*) 
	  INTO :ll_count
     FROM articulo_mov_proy 	amp, 
       	 articulo_almacen 	aa,
       	 articulo 				a 
	 WHERE amp.cod_art 	= aa.cod_art 
	   and amp.cod_art 	= a.cod_art
		and aa.cod_art 	= a.cod_art  
		and NVL(aa.flag_reposicion,0)='0'
		and amp.flag_estado = '1' 
		and amp.tipo_doc = (select doc_ot from logparam where reckey='1') 
		and nvl(aa.sldo_total,0 ) - nvl(aa.sldo_reservado,0) > 0 
		and nvl(amp.cant_proyect,0) - nvl(amp.cant_procesada,0) - nvl(amp.cant_reservado,0) > 0
		and a.cod_art = :data
		and a.flag_inventariable = '1' 
		and a.flag_estado <> '0';
			  
   IF ll_count =0 THEN
		Messagebox('Aviso','Articulo no puede reservarse')
		this.object.cod_art [row] = ls_null
		RETURN 1
	END IF
	
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = "SELECT COD_ART AS CODIGO, "&   
								  + "NOM_ARTICULO AS DESCRIPCION, "&   
								  + "UND AS UNIDAD, "&
								  + "COD_ORIGEN AS ORIGEN, "&
								  + "ALMACEN AS ALMAC, "&									  
								  + "NRO_MOV AS NUMERO, "&								  
								  + "SALDO_LIBRE AS SALDO, "& 
								  + "ORD_TRABAJ AS NRO_OT, "& 
								  + "OPER_SEC AS OPERSEC "& 
								  + "FROM VW_OPE_SALDO_LIBRE_ARTICULO " &
								  + "WHERE COD_ART = '" + ls_cod_art + "' " &
								  + "and flag_reposicion = '1'"
								  
	OpenWithParm(w_seleccionar, lstr_seleccionar)
		
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		
	IF lstr_seleccionar.s_action = "aceptar" THEN
			
		this.object.cod_art 				[row] = lstr_seleccionar.param1[1]
		this.object.articulo_desc_art	[row] = lstr_seleccionar.param2[1]
		this.object.und					[row] = lstr_seleccionar.param3[1]
		this.object.org_amp_ref			[row] = lstr_seleccionar.param4[1]
		this.object.almacen				[row] = lstr_seleccionar.param5[1]			
		this.object.nro_amp_ref			[row] = Long(lstr_seleccionar.paramdc6[1])
		this.object.cantidad				[row] = lstr_seleccionar.paramdc7[1]
			
		// Asigna datos a variables
		ls_org_amp   = lstr_seleccionar.param4[1]
		ls_almacen 	 = lstr_seleccionar.param5[1]
		ll_nro_amp	 = LONG(lstr_seleccionar.paramdc6[1])
		ldc_cantidad = lstr_seleccionar.paramdc7[1]
		
		// Captura datos segun AMP
		SELECT aa.costo_ult_compra, 
				 aa.sldo_total,
				 a.flag_reposicion, 
				 amp.oper_sec, 
				 amp.nro_doc,
				 amp.fec_proyect
		  INTO :ldc_costo_unit, 
				 :ldc_saldo_total,
				 :ls_flag_reposicion, 
				 :ls_oper_sec, 
				 :ls_nro_ot,
				 :ld_fec_proyect
	     FROM articulo_mov_proy 	amp, 
		  		 articulo_almacen 	aa, 
				 articulo 				a 
		 WHERE amp.cod_art = aa.cod_art 
		   and amp.almacen = aa.almacen 
			and amp.cod_art = a.cod_art 
			and amp.tipo_doc=(select doc_ot from logparam where reckey='1') 
			and amp.cod_origen = :ls_org_amp 
			and amp.nro_mov 	 = :ll_nro_amp;
			
		this.object.flag_reposicion[row] = ls_flag_reposicion
		this.object.oper_sec			[row] = ls_oper_sec
		this.object.nro_doc			[row] = ls_nro_ot
		this.object.sldo_total	 	[row] = ldc_saldo_total
		this.object.precio_unit 	[row] = ldc_costo_unit
		this.object.fec_proyect		[row] = ld_fec_proyect
			
		this.ii_update = 1
	END IF

END IF

IF dwo.name = 'cantidad' then
	ls_cod_art = THIS.object.cod_art[row] 
	IF ISNULL(ls_cod_art) OR ls_cod_art='' THEN
		MessageBox('Aviso', 'Articulo indefinido')
		THIS.object.cantidad	[row] = 0
		RETURN 1
	END IF 

	ldc_cantidad = Dec(THIS.object.cantidad[row])
	ls_org_amp = THIS.object.org_amp_ref[row]
	ll_nro_amp = THIS.object.nro_amp_ref[row]
	ls_almacen = THIS.object.almacen[row]
	
	SELECT CASE WHEN 
       	 ( USF_ALM_CANT_LIBRE_OT(:ls_org_amp, :ll_nro_amp) < 
        	 (NVL(aa.sldo_total,0) - NVL(aa.sldo_reservado,0))) THEN
       	 USF_ALM_CANT_LIBRE_OT(:ls_org_amp, :ll_nro_amp) ELSE
       	 (NVL(aa.sldo_total,0) - NVL(aa.sldo_reservado,0)) 
       	 END  
     INTO :ldc_cant_libre 
	  FROM articulo_almacen aa 
	  WHERE aa.cod_art = :ls_cod_art 
	    AND aa.almacen = :ls_almacen ;
	
	IF ldc_cantidad > ldc_cant_libre THEN
		MessageBox('Aviso', 'La cantidad ha reservar no puede ser mayor a la cantidad libre')
		THIS.object.cantidad	[row] = ldc_cant_libre
		RETURN 1
	END IF 
END IF 

end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
//TriggerEvent ue_modify()
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;Datetime ldt_fecha

ldt_fecha = f_fecha_Actual()

This.object.flag_estado 	[al_row] = '1'
this.object.fec_registro	[al_row] = ldt_fecha
this.object.cod_usr			[al_row] = gs_user
this.object.nro_item			[al_row] = of_nro_item( this )
this.object.fec_vencimiento[al_row] = RelativeDate(Date(ldt_fecha), ii_dias_venc_reservac)
this.object.cant_procesada	[al_row] = 0

of_set_modify()

end event

event dw_detail::ue_output;call super::ue_output;//THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

event dw_detail::clicked;call super::clicked;IF dw_master.GetRow() > 0 THEN 
	idw_mst.il_row = 1
END IF 

end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

type sle_nro from u_sle_codigo within w_ope317_reservacion_material
integer x = 261
integer y = 12
integer width = 471
integer height = 92
integer taborder = 10
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;cb_1.Triggerevent( clicked!)
end event

type cb_1 from commandbutton within w_ope317_reservacion_material
integer x = 782
integer y = 8
integer width = 402
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;of_retrieve(sle_nro.text)
end event

type st_nro from statictext within w_ope317_reservacion_material
integer x = 9
integer y = 24
integer width = 251
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero:"
boolean focusrectangle = false
end type

