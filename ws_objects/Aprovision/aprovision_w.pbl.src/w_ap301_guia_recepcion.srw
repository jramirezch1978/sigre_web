$PBExportHeader$w_ap301_guia_recepcion.srw
forward
global type w_ap301_guia_recepcion from w_abc
end type
type cb_buscar from commandbutton within w_ap301_guia_recepcion
end type
type sle_nro from u_sle_codigo within w_ap301_guia_recepcion
end type
type st_1 from statictext within w_ap301_guia_recepcion
end type
type sle_gs_origen from singlelineedit within w_ap301_guia_recepcion
end type
type st_ori from statictext within w_ap301_guia_recepcion
end type
type tab_detalles from tab within w_ap301_guia_recepcion
end type
type tp_1 from userobject within tab_detalles
end type
type dw_precios_rep from u_dw_abc within tp_1
end type
type dw_2 from u_dw_abc within tp_1
end type
type tp_1 from userobject within tab_detalles
dw_precios_rep dw_precios_rep
dw_2 dw_2
end type
type tp_firma from userobject within tab_detalles
end type
type dw_6 from u_dw_abc within tp_firma
end type
type tp_firma from userobject within tab_detalles
dw_6 dw_6
end type
type tab_detalles from tab within w_ap301_guia_recepcion
tp_1 tp_1
tp_firma tp_firma
end type
type dw_master from u_dw_abc within w_ap301_guia_recepcion
end type
type gb_1 from groupbox within w_ap301_guia_recepcion
end type
end forward

global type w_ap301_guia_recepcion from w_abc
integer width = 3854
integer height = 2640
string title = "Guia Recepción Materia Prima (AP301)"
string menuname = "m_mantto_cons_anula"
string is_action = "open"
event ue_anular ( )
event ue_cancelar ( )
event ue_procesar_oc ( )
cb_buscar cb_buscar
sle_nro sle_nro
st_1 st_1
sle_gs_origen sle_gs_origen
st_ori st_ori
tab_detalles tab_detalles
dw_master dw_master
gb_1 gb_1
end type
global w_ap301_guia_recepcion w_ap301_guia_recepcion

type variables
u_dw_abc  idw_2, idw_3, idw_6

Int 		ii_cerrado 



end variables

forward prototypes
public function decimal of_set_total ()
public function integer of_set_numera ()
public function integer of_set_status_menu (datawindow adw)
public function decimal of_set_tot_pre ()
protected subroutine of_retrieve (string as_nro_guia)
public function integer of_nro_item (datawindow adw_pd)
end prototypes

event ue_anular;Long ll_row

IF dw_master.GetRow() = 0 THEN RETURN

IF MessageBox('Aviso', 'Deseas anular la Guia de Recepcion', Information!, YesNo!, 2) = 2 THEN RETURN

IF dw_master.object.flag_estado[dw_master.GetRow()] = '0' THEN
	MessageBox('Aviso', 'Esta Guia ya esta anulada, no puedes anularla')
	RETURN
END IF

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

dw_master.object.flag_estado[dw_master.GetRow()] = '0'
dw_master.object.monto_tot  [dw_master.GetRow()] =  0
dw_master.ii_update = 1

do while idw_2.Rowcount( ) > 0
	idw_2.DeleteRow(1)
loop

// Elimina los Precios Representacion
idw_3.setfilter("")  //elima el filtro
idw_3.Filter( )

do while idw_3.Rowcount( ) > 0
	idw_3.DeleteRow(1)
loop

idw_2.ii_update = 1
idw_3.ii_update = 1
is_action = 'anular'
of_set_status_menu(idw_1)




end event

event ue_cancelar;EVENT ue_update_request()   // Verifica actualizaciones pendientes

dw_master.Reset()
idw_2.Reset()
idw_3.Reset()
idw_6.Reset()

dw_master.ii_update = 0
idw_2.ii_update = 0
idw_3.ii_update = 0
idw_6.ii_update = 0

is_Action = 'open'

idw_1 = dw_master
idw_1.SetFocus()

of_set_status_menu(idw_1)

end event

event ue_procesar_oc();// Evento para crear una orden de compra a partir de
// una Guia de Recepcion de Materia Prima GRMP.

String  	ls_cod_guia, ls_mensaje, ls_nro_oc, ls_cod_origen
Integer	li_dir_item

//Obtenemos datos de la cabecera de la Guia
ls_cod_guia		= dw_master.object.cod_guia_rec [dw_master.getrow()]
ls_cod_origen	= dw_master.object.origen		  [dw_master.getrow()]

DECLARE SP_GENERAR_OC PROCEDURE FOR USP_AP_GENERAR_OC 
 			(  :ls_cod_guia, :ls_cod_origen, :gs_user)  ;

EXECUTE SP_GENERAR_OC;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_AP_GENERAR_OC: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	RETURN
ELSE
	messagebox('Aviso', 'El proceso a concluido satisfactoriamente')
END IF

FETCH SP_GENERAR_OC INTO :ls_nro_oc, :ls_mensaje;

CLOSE SP_GENERAR_OC;

of_retrieve(ls_cod_guia)

end event

public function decimal of_set_total ();Long ll_i
Decimal  ldc_total, ldc_tot_pre

IF dw_master.GetRow() = 0 THEN RETURN 0
ldc_total = 0

FOR ll_i = 1 TO idw_2.RowCount()
	ldc_total = ldc_total + ((Dec(idw_2.object.precio_unitario[ll_i]) + &
					Dec(idw_2.object.precio_representacion[ll_i]) + &
					Dec(idw_2.object.precio_unitario_castigo[ll_i])) * &
					idw_2.object.peso_venta[ll_i])
NEXT

dw_master.object.monto_tot [dw_master.GetRow()] = ldc_total

return ldc_total


end function

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i
String  	ls_next_nro, ls_lock_table, ls_mensaje, ls_origen

if dw_master.getrow() = 0 then return 0

ls_origen = dw_master.object.origen [dw_master.getrow()]

if is_action = 'new' then
	select count(*)
		into :ll_count
	from num_ap_guias_recep
	where cod_origen = :ls_origen;
	
	if ll_count = 0 then
		ls_lock_table = 'LOCK TABLE num_ap_guias_recep IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		insert into num_ap_guias_recep(cod_origen, ult_nro)
		values( :ls_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM num_ap_guias_recep
	where cod_origen = :ls_origen for update;
	
	update num_ap_guias_recep
		set ult_nro = ult_nro + 1
	where cod_origen = :ls_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
	
	ls_next_nro = trim(ls_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.cod_guia_rec[dw_master.getrow()] = ls_next_nro
	
	dw_master.ii_update = 1
else
	ls_next_nro = dw_master.object.cod_guia_rec[dw_master.getrow()] 
end if

// Asigna numero a detalle idw_2
for ll_i = 1 to idw_2.RowCount()
	idw_2.object.cod_guia_rec[ll_i] = ls_next_nro
next

// Asigna numero a detalle de Precios Representacion
idw_3.setfilter("")  //elima el filtro
idw_3.Filter( )

FOR ll_i = 1 TO idw_3.RowCount()
	idw_3.object.cod_guia_rec[ll_i] = ls_next_nro
NEXT 


// Asigna numero a detalle idw_6 (Firmas)
for ll_i = 1 to idw_6.RowCount()
	idw_6.object.cod_guia_rec[ll_i] = ls_next_nro
next

return 1
end function

public function integer of_set_status_menu (datawindow adw);Int li_estado
long ll_ref

This.changemenu( m_mantto_cons_anula )

// Activa todas las opciones
if is_flag_insertar = '1' then
	m_master.m_file.m_basedatos.m_insertar.enabled = true
else
	m_master.m_file.m_basedatos.m_insertar.enabled = false
end if

if is_flag_eliminar = '1' then
	m_master.m_file.m_basedatos.m_eliminar.enabled = true
else
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
end if

if is_flag_modificar = '1' then
	m_master.m_file.m_basedatos.m_modificar.enabled = true
else
	m_master.m_file.m_basedatos.m_modificar.enabled = false
end if

if is_flag_anular = '1' then
	m_master.m_file.m_basedatos.m_anular.enabled = true
else
	m_master.m_file.m_basedatos.m_anular.enabled = false
end if

if is_flag_cerrar = '1' then
	m_master.m_file.m_basedatos.m_cerrar.enabled = true
else
	m_master.m_file.m_basedatos.m_cerrar.enabled = false
end if

if is_flag_consultar = '1' then
	m_master.m_file.m_basedatos.m_abrirlista.enabled = true
else
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
end if

m_master.m_file.m_basedatos.m_abrirlista.enabled = true

IF dw_master.getrow() = 0 THEN return 0

IF is_Action = 'new' THEN
	// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_eliminar.enabled 		= false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false
	m_master.m_file.m_basedatos.m_anular.enabled 		= false
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false
	if is_flag_insertar = '1' then
		m_master.m_file.m_basedatos.m_insertar.enabled = true
	else
		m_master.m_file.m_basedatos.m_insertar.enabled = false
	end if

	IF adw = idw_2 THEN
		if is_flag_eliminar = '1' then
			m_master.m_file.m_basedatos.m_eliminar.enabled = true
		else
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
		end if

		m_master.m_file.m_basedatos.m_insertar.enabled 	= false
	ELSEIF adw = idw_3 THEN
		if is_flag_insertar = '1' then
			m_master.m_file.m_basedatos.m_insertar.enabled = true
		else
			m_master.m_file.m_basedatos.m_insertar.enabled = false
		end if
		
		if is_flag_eliminar = '1' then
			m_master.m_file.m_basedatos.m_eliminar.enabled = true
		else
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
		end if

	ELSEIF adw = idw_6 THEN
		if is_flag_insertar = '1' then
			m_master.m_file.m_basedatos.m_insertar.enabled = true
		else
			m_master.m_file.m_basedatos.m_insertar.enabled = false
		end if
		
		if is_flag_eliminar = '1' then
			m_master.m_file.m_basedatos.m_eliminar.enabled = true
		else
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
		end if

	END IF

ELSEIF is_Action = 'open' THEN
	li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])	
	CHOOSE CASE li_estado
		CASE 0 	// Anulado 
			m_master.m_file.m_basedatos.m_eliminar.enabled  = false
			m_master.m_file.m_basedatos.m_modificar.enabled = false
			m_master.m_file.m_basedatos.m_anular.enabled 	= false	
			IF adw = dw_master THEN
				if is_flag_insertar = '1' then
					m_master.m_file.m_basedatos.m_insertar.enabled = true
				else
					m_master.m_file.m_basedatos.m_insertar.enabled = false
				end if

			ELSE			
				m_master.m_file.m_basedatos.m_insertar.enabled = false
			END IF
	//		RETURN 1
			
		CASE 1   // Generado
			IF adw = dw_master THEN
				if is_flag_insertar = '1' then
					m_master.m_file.m_basedatos.m_insertar.enabled = true
				else
					m_master.m_file.m_basedatos.m_insertar.enabled = false
				end if

			ELSEIf adw = idw_2 THEN
				m_master.m_file.m_basedatos.m_insertar.enabled 	= False
				m_master.m_file.m_basedatos.m_modificar.enabled = True
				
			ELSEIF adw = idw_6 THEN
				
				if is_flag_insertar = '1' then
					m_master.m_file.m_basedatos.m_insertar.enabled = true
				else
					m_master.m_file.m_basedatos.m_insertar.enabled = false
				end if

			END IF	
//			RETURN 1
			
		CASE 2   // Enviado a Almacen
			m_master.m_file.m_basedatos.m_eliminar.enabled 	= false
			m_master.m_file.m_basedatos.m_modificar.enabled = false
			m_master.m_file.m_basedatos.m_anular.enabled		= false
			
			IF adw = dw_master THEN
				if is_flag_insertar = '1' then
					m_master.m_file.m_basedatos.m_insertar.enabled = true
				else
					m_master.m_file.m_basedatos.m_insertar.enabled = false
				end if

				m_master.m_file.m_basedatos.m_anular.enabled 	 = true
			ELSEIF adw = idw_2 THEN
				m_master.m_file.m_basedatos.m_modificar.enabled = True
				m_master.m_file.m_basedatos.m_insertar.enabled = false
			ELSEIF adw = idw_3 THEN
				m_master.m_file.m_basedatos.m_modificar.enabled = True
				m_master.m_file.m_basedatos.m_insertar.enabled = True
			ELSE
				m_master.m_file.m_basedatos.m_insertar.enabled = false
			END IF	
	//		RETURN 1
	END CHOOSE

	IF ii_cerrado <>2 THEN
		m_master.m_file.m_basedatos.m_modificar.enabled  = False
		m_master.m_file.m_basedatos.m_insertar.enabled   = False
	END IF
	
ELSEIF is_Action = 'anular' THEN
	 
	m_master.m_file.m_basedatos.m_eliminar.enabled 	 = false
	m_master.m_file.m_basedatos.m_modificar.enabled  = false
	m_master.m_file.m_basedatos.m_anular.enabled  	 = false
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
	m_master.m_file.m_basedatos.m_insertar.enabled	 = false	

END IF

RETURN 1
end function

public function decimal of_set_tot_pre ();Long 		ll_i
Decimal  ldc_total

IF dw_master.GetRow() = 0 THEN RETURN 0
IF idw_2.Getrow()		 = 0 THEN RETURN 0

ldc_total = 0.00

FOR ll_i = 1 to idw_3.Rowcount( )
	ldc_total = ldc_total + Dec(idw_3.object.monto[ll_i])
NEXT


idw_2.object.precio_representacion [idw_2.GetRow()] = ldc_total
idw_2.ii_update = 1

of_set_total()

return ldc_total


end function

protected subroutine of_retrieve (string as_nro_guia);String  	ls_nro_oc
Long 		ll_row, ll_year, ll_mes

ll_row = dw_master.retrieve( as_nro_guia )
idw_2.retrieve( as_nro_guia )
idw_3.retrieve(as_nro_guia)
idw_6.retrieve( as_nro_guia )

dw_master.ii_protect = 0
idw_2.ii_protect = 0
idw_3.ii_protect = 0
idw_6.ii_protect = 0

dw_master.of_protect( )
idw_2.of_protect( )
idw_3.of_protect( )
idw_6.of_protect( )

dw_master.ii_update = 0
idw_2.ii_update = 0
idw_3.ii_update = 0
idw_6.ii_update = 0

is_Action = 'open'

if dw_master.GetRow() > 0 then
	of_Set_Total()
end if

IF dw_master.GetRow() > 0 THEN
	IF dw_master.object.flag_estado[dw_master.GetRow()] = '2' OR &
		dw_master.object.flag_estado[dw_master.GetRow()] = '0' THEN
		dw_master.object.Tipo_guia.Protect		= 1	
		dw_master.object.Proveedor.Protect		= 1	
		dw_master.object.Cod_trato.Protect		= 1	
		dw_master.object.Cod_moneda.Protect		= 1
		dw_master.object.b_referencia.Enabled 	= False
	ELSE
		dw_master.object.Tipo_guia.Protect		= 0	
		dw_master.object.Proveedor.Protect		= 0	
		dw_master.object.Cod_trato.Protect		= 0
		dw_master.object.Cod_moneda.Protect		= 0
		dw_master.object.b_referencia.Enabled 	= True
	END IF
	IF dw_master.object.flag_estado[dw_master.GetRow()] = '2' THEN
		dw_master.object.b_referencia.Enabled 	= TRUE
	END IF
END IF

IF ll_row > 0 THEN
	ll_year = YEAR( DATE(dw_master.object.fecha_registro[ll_row]))
	ll_mes  = MONTH( DATE(dw_master.object.fecha_registro[ll_row]))
	
	// Busca si esta cerrado contablemente	
	SELECT (DECODE(NVL( flag_almacen, '0' ),'0',0,1) + 
           DECODE(NVL( flag_cierre_mes, '0' ),'0',0,1) ) 
	  INTO :ii_cerrado  
	from cntbl_cierre 
	where ano = :ll_year 
	  and mes = :ll_mes ;
	  
	IF ii_cerrado = 0 or ii_cerrado = 1 THEN
		dw_master.object.t_cierre.text = 'CERRADO X CONTABILIDAD'
		m_master.m_file.m_basedatos.m_modificar.enabled = false
		dw_master.object.b_referencia.Enabled 	= False
	ELSE
		dw_master.object.t_cierre.text = ''
	END IF
END IF

of_set_status_menu(dw_master)

end subroutine

public function integer of_nro_item (datawindow adw_pd);integer li_item, li_x

li_item = 0

For li_x = 1 to adw_pd.RowCount()
	IF li_item < adw_pd.object.item[li_x] THEN
		li_item = adw_pd.object.item[li_x]
	END IF
Next

Return li_item + 1
end function

on w_ap301_guia_recepcion.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_cons_anula" then this.MenuID = create m_mantto_cons_anula
this.cb_buscar=create cb_buscar
this.sle_nro=create sle_nro
this.st_1=create st_1
this.sle_gs_origen=create sle_gs_origen
this.st_ori=create st_ori
this.tab_detalles=create tab_detalles
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_buscar
this.Control[iCurrent+2]=this.sle_nro
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_gs_origen
this.Control[iCurrent+5]=this.st_ori
this.Control[iCurrent+6]=this.tab_detalles
this.Control[iCurrent+7]=this.dw_master
this.Control[iCurrent+8]=this.gb_1
end on

on w_ap301_guia_recepcion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_buscar)
destroy(this.sle_nro)
destroy(this.st_1)
destroy(this.sle_gs_origen)
destroy(this.st_ori)
destroy(this.tab_detalles)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event resize;call super::resize;long ll_x

idw_2 = tab_detalles.tp_1.dw_2
idw_3	= tab_detalles.tp_1.dw_precios_rep
idw_6	= tab_detalles.tp_firma.dw_6

This.SetRedraw(false)

dw_master.width  = newwidth  - dw_master.x - 10

tab_detalles.height = newheight - tab_detalles.y - 10
tab_detalles.width  = newwidth  - tab_detalles.x - 10


//resize de los objetos dentro del tab

idw_2.width  = tab_detalles.width  - idw_2.x - 40
idw_3.width  = tab_detalles.width  - idw_3.x - 40
idw_3.height = tab_detalles.height - idw_3.y - 100

idw_6.width  = tab_detalles.width  - idw_6.x - 40
idw_6.height = tab_detalles.height - idw_6.y - 40

This.SetRedraw(true)
end event

event ue_open_pre;call super::ue_open_pre;
dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_master.ii_protect = 0
dw_master.of_protect()         		// bloquear modificaciones 

//Datawindow por defecto
idw_1 = dw_master

idw_2.SetTransObject(SQLCA)
idw_3.SetTransObject(SQLCA)
idw_6.SetTransObject(SQLCA)

idw_1.object.p_logo.filename = gs_logo
sle_gs_origen.text = gs_origen

is_action = 'open'



end event

event ue_insert;call super::ue_insert;Long  ll_row

if idw_1 = dw_master then
	if idw_1.ii_update = 1 then
		MessageBox('Error', 'Tiene cambios pendientes, no puede insertar otro registro')
		return
	end if
end if

if idw_1 = dw_master THEN
  dw_master.object.b_referencia.Enabled 		 = True
  dw_master.Object.origen.Background.Color 	 = RGB(255,255,255)
  dw_master.Object.proveedor.Background.Color = RGB(255,255,255)
  dw_master.Reset()
end if

if idw_1 = idw_2 then
	if dw_master.GetRow() = 0 then
		MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
		return
	end if
end if

if idw_1 = idw_3 then
	if dw_master.GetRow() = 0 OR idw_2.GetRow() = 0 then
		MessageBox('Error', 'No puede insertar un precio si no tiene cabecera o detalle')
		return
	end if
end if

if idw_1 = idw_6 then
	if dw_master.GetRow() = 0 then
		MessageBox('Error', 'No puede insertar una firma si no tiene cabecera')
		return
	end if
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN 
	THIS.EVENT ue_insert_pos(ll_row)
END IF


end event

event ue_modify;call super::ue_modify;Integer 	li_estado
String	ls_nro_oc


li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])
ls_nro_oc = dw_master.object.nro_oc[dw_master.getrow()]

IF Len(ls_nro_oc) > 0 THEN
	messagebox('Aviso','No se puede Modificar la Guia porque tiene asociada' + '~n~r'+&
					'La Orden de Compra Nº: '+ls_nro_oc )
	RETURN
END IF

IF li_estado = 0 THEN
	messagebox('Aviso','No se puede Modificar la Guia porque esta Anulada')
	RETURN
END IF

//Verifica si la guia tiene una cuenta por pagar pendiente 


idw_1.of_protect()

IF idw_1 = idw_2 AND li_estado = 2 THEN
	idw_2.object.Peso_venta.Protect 					= 1
	idw_2.object.almacen_dst.Protect 				= 1
	idw_2.object.precio_unitario.Protect 			= 1
	idw_2.object.precio_unitario_Castigo.Protect = 1
	idw_2.object.precio_representacion.Protect 	= 1
END IF

IF idw_1 = idw_2 THEN
	//Precio unitario
	idw_2.Modify("precio_unitario.Protect ='1~tIf(IsNull(flag_modi),1,0)'")
	idw_2.Modify("precio_unitario.Background.color ='1~tIf(IsNull(flag_modi), RGB(192,192,192),RGB(255,255,255))'")
END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si 
// se quiere actualizar

IF dw_master.ii_update = 1 &
	or idw_2.ii_update = 1 &
	or idw_3.ii_update = 1 &
	or idw_6.ii_update = 1 THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", &
	                           "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		idw_2.ii_update = 0
		idw_3.ii_update = 0
		idw_6.ii_update = 0
	END IF
END IF

end event

event ue_update;call super::ue_update;// Override
long 		ll_item
Boolean lbo_ok = TRUE
string	ls_nro_guia

dw_master.AcceptText()
idw_2.Accepttext( )
idw_3.Accepttext( )
idw_6.Accepttext( )

if dw_master.GetRow() = 0 then return

ib_update_check = TRUE
THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

// Para el log diario
IF ib_log THEN
	dw_master.of_create_log()
	idw_2.of_create_log()
	idw_3.of_create_log()
END IF
//

IF is_action <> 'anular' THEN

	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update() = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			Rollback ;
			messagebox("Error en Grabacion Master", &
						  "Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF	idw_2.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_2.Update() = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			Rollback ;
			messagebox("Error en Grabacion dw_detalle",&
						  "Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF	idw_3.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_3.Update() = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			Rollback ;
			messagebox("Error en Grabacion dw_Precios_Rep",&
						  "Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF	idw_6.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_6.Update() = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			Rollback ;
			messagebox("Error en Grabacion dw_6", &
						  "Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
ELSE
	IF	idw_3.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_3.Update() = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			Rollback ;
			messagebox("Error en Grabacion dw_Precios_Rep",&
						  "Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF	idw_2.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_2.Update() = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			Rollback ;
			messagebox("Error en Grabacion dw_detalle",&
						  "Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF	idw_6.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_6.Update() = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			Rollback ;
			messagebox("Error en Grabacion dw_6", &
						  "Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update() = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			Rollback ;
			messagebox("Error en Grabacion Master", &
						  "Se ha procedido al rollback",exclamation!)
		END IF
	END IF

END IF

//Para el log diario
IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = idw_2.of_save_log()
		lbo_ok = idw_3.of_save_log()
	end if
END IF
//

IF lbo_ok THEN
	COMMIT using SQLCA;
	ls_nro_guia = dw_master.object.cod_guia_rec[dw_master.GetRow()]
	of_retrieve(ls_nro_guia)
	
	if idw_2.RowCount() > 0 then
		ll_item = idw_2.object.item[idw_2.GetRow()]
		idw_3.setfilter( "item = " + string(ll_item))  //Repone el filtro
		idw_3.Filter( )
	end if
	
	dw_master.ii_update  = 0
	idw_2.ii_update 		= 0
	idw_3.ii_update	 	= 0
	idw_6.ii_update 		= 0
	
	dw_master.ii_protect = 0
	idw_2.ii_protect 		= 0
	idw_3.ii_protect 		= 0
	idw_6.ii_protect 		= 0
	
	dw_master.of_protect	( )
	idw_2.of_protect		( )
	idw_3.of_protect		( )
	idw_6.of_protect		( )
	
	is_action = 'open'
	of_set_status_menu(idw_1)
	
	dw_master.il_totdel 	= 0
	idw_2.il_totdel 		= 0
	idw_3.il_totdel 		= 0
	
END IF


end event

event ue_update_pre;call super::ue_update_pre;long ll_row

// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_2, "tabular") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_3, "tabular") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_6, "tabular") <> true then return

// verifica que tenga datos de detalle
if idw_2.rowcount() = 0 AND is_action <> 'anular' then
	Messagebox( "Atencion", "Ingrese informacion de detalle")
	return
end if

// para calcular el total de la guia
of_set_total()

//Para la replicacion de datos
dw_master.of_set_flag_replicacion()
idw_2.of_set_flag_replicacion()
idw_3.of_set_flag_replicacion()
idw_6.of_set_flag_replicacion()

// Genera el numero de la Guia de REcepcion de Materia Prima
if of_set_numera() = 0 then return

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien
ib_update_check = true

end event

event open;//Ancestor Script Override

idw_2 = tab_detalles.tp_1.dw_2
idw_3 = tab_detalles.tp_1.dw_precios_rep
idw_6	= tab_detalles.tp_firma.dw_6


IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
ELSE
	CLOSE(THIS)
END IF
end event

event ue_list_open;call super::ue_list_open;//override
// Asigna valores a structura 

str_parametros sl_param

sl_param.dw1    = 'ds_guia_recepcion'
sl_param.titulo = 'GUIAS DE RECEPCION'
sl_param.field_ret_i[1] = 1	//Nro Guia
sl_param.field_ret_i[2] = 2	//Fecha Registro
sl_param.field_ret_i[3] = 3	//Parte Pesca
sl_param.field_ret_i[4] = 4	//proveedor

OpenWithParm( w_lista, sl_param )


sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_print;call super::ue_print;IF dw_master.rowcount() = 0 then return

if dw_master.object.flag_estado [1] <> '1' then
	MessageBox('Error', 'El Documento no se encuentra activo, no se puede imprimir', StopSign!)
end if

str_parametros lstr_rep

lstr_rep.string1 = dw_master.object.cod_guia_rec[1]

OpenSheetWithParm(w_ap301_guia_recepcion_frm, lstr_rep, w_main, 0, Layered!)
end event

type cb_buscar from commandbutton within w_ap301_guia_recepcion
integer x = 1239
integer y = 48
integer width = 297
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;EVENT ue_update_request()   // Verifica actualizaciones pendientes
of_retrieve(sle_nro.text)
end event

type sle_nro from u_sle_codigo within w_ap301_guia_recepcion
integer x = 667
integer y = 68
integer width = 393
integer height = 68
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer limit = 10
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;cb_buscar.event clicked()
end event

type st_1 from statictext within w_ap301_guia_recepcion
integer x = 453
integer y = 68
integer width = 210
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_gs_origen from singlelineedit within w_ap301_guia_recepcion
integer x = 265
integer y = 68
integer width = 133
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_ori from statictext within w_ap301_guia_recepcion
integer x = 64
integer y = 68
integer width = 192
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type tab_detalles from tab within w_ap301_guia_recepcion
integer y = 996
integer width = 2779
integer height = 1196
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean focusonbuttondown = true
boolean powertips = true
boolean boldselectedtext = true
integer selectedtab = 1
tp_1 tp_1
tp_firma tp_firma
end type

on tab_detalles.create
this.tp_1=create tp_1
this.tp_firma=create tp_firma
this.Control[]={this.tp_1,&
this.tp_firma}
end on

on tab_detalles.destroy
destroy(this.tp_1)
destroy(this.tp_firma)
end on

type tp_1 from userobject within tab_detalles
integer x = 18
integer y = 112
integer width = 2743
integer height = 1068
long backcolor = 79741120
string text = "  Ingreso Materia Prima"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "CreateRuntime!"
long picturemaskcolor = 536870912
string powertiptext = "Detalles de la Guia de Recepción Materia Prima"
dw_precios_rep dw_precios_rep
dw_2 dw_2
end type

on tp_1.create
this.dw_precios_rep=create dw_precios_rep
this.dw_2=create dw_2
this.Control[]={this.dw_precios_rep,&
this.dw_2}
end on

on tp_1.destroy
destroy(this.dw_precios_rep)
destroy(this.dw_2)
end on

type dw_precios_rep from u_dw_abc within tp_1
event ue_display ( string as_columna,  long al_row )
integer x = 9
integer y = 716
integer width = 2688
integer height = 336
integer taborder = 20
string dataobject = "d_abc_guia_rec_det_precios_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

CHOOSE CASE lower(as_columna)
		
	CASE "cod_precio"
	
	ls_sql = "SELECT COD_PRECIO AS CODIGO_PRECIO, " &
				  + "DESC_PRECIO AS DESCRIPCION_PRECIO " &
				  + "FROM AP_PRECIOS_REP " &
				  + "WHERE FLAG_ESTADO = '1' " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.cod_precio	[al_row] = ls_codigo
			This.object.desc_precio	[al_row] = ls_data
			This.ii_update = 1
		END IF

END CHOOSE
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 					// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2


end event

event getfocus;call super::getfocus;
idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_menu(this)

end event

event itemerror;call super::itemerror;RETURN 1
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
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

event ue_insert_pre;call super::ue_insert_pre;
this.object.cod_usr	[al_row] = gs_user
this.object.item	   [al_row] = dw_2.object.item [dw_2.GetRow()]

//of_set_tot_pre()


end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event itemchanged;call super::itemchanged;String	ls_data, ls_null

SetNull(ls_null)
This.AcceptText()

IF row = 0 THEN RETURN

CHOOSE CASE lower(dwo.name)
	
	CASE "cod_precio"
		SELECT desc_precio
		  INTO :ls_data
		FROM ap_precios_rep
		WHERE cod_precio = :data
		 AND  flag_Estado = '1';

		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Precio_Rep no existe", StopSign!)
			This.object.cod_precio	[row] = ls_null
			This.object.desc_precio	[row] = ls_null
			Return 1
		END IF

		This.object.desc_precio[row] = ls_data

END CHOOSE


of_set_tot_pre()
end event

event ue_delete;//Ancester Override

long ll_row = 1

ib_insert_mode = False

IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN ll_row = THIS.Event ue_delete_pre()  // solo si se tiene detalle

IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1								// indicador de actualizacion pendiente
		THIS.Event Post ue_delete_pos()
	END IF
END IF

of_set_tot_pre()

RETURN ll_row
end event

type dw_2 from u_dw_abc within tp_1
event ue_display ( string as_columna,  long al_row )
integer x = 5
integer width = 2697
integer height = 700
integer taborder = 30
string dataobject = "d_guia_recepcion_det_tbl"
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

CHOOSE CASE lower(as_columna)
		
	CASE "almacen_dst"
		ls_sql = "SELECT ALMACEN AS CODIGO_ALMACEN, " &
				  + "DESC_ALMACEN AS DESCRIPCION_ALMACEN " &
				  + "FROM ALMACEN " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "AND FLAG_TIPO_ALMACEN = 'P' " &
				  + "AND COD_ORIGEN = '" + gs_origen + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.almacen_dst		[al_row] = ls_codigo
			this.ii_update = 1
		end if
	
	CASE 'centro_benef'
		ls_sql = "SELECT CB.CENTRO_BENEF AS COD_CENTRO, " &
			    + "CB.DESC_CENTRO AS DESCRIPCION_CENTRO " &
				 + "FROM CENTRO_BENEFICIO CB, " &
				 + "CENTRO_BENEF_USUARIO CBU " &
				 + "WHERE CB.CENTRO_BENEF = CBU.CENTRO_BENEF " &
				 + "AND CB.FLAG_ESTADO = '1' "  &
				 + "AND CBU.COD_USR = '" + gs_user + "'"		
			
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			this.object.centro_benef [al_row] = ls_codigo
			this.ii_update = 1
		END IF
	
END CHOOSE

end event

event constructor;call super::constructor;						
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2



end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_menu(this)

end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;string ls_nro_guia

if dw_master.GetRow() = 0 then return

ls_nro_guia = dw_master.object.cod_guia_rec[dw_master.GetRow()]

this.object.precio_unitario 			[al_row] = 0
this.object.precio_unitario_castigo [al_row] = 0
this.object.precio_representacion 	[al_row] = 0
this.object.peso_venta 					[al_row] = 0
this.object.cod_guia_rec 				[al_row] = ls_nro_guia

of_set_total()


end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
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

event itemchanged;call super::itemchanged;String	ls_null
Long		ll_count

SetNull(ls_null)
this.AcceptText()

if row = 0 then return

CHOOSE CASE lower(dwo.name)
	case "almacen_dst"
		
		select count(*)
			into :ll_count
		from almacen
		where almacen = :data
		  and flag_estado = '1'
		  and cod_origen = :gs_origen
		  and flag_tipo_almacen = 'P';
		
		if ll_count = 0 then
			Messagebox('Aviso', "Codigo de almacen no existe o no esta activo, por favor verificar", StopSign!)
			this.object.almacen_dst	[row] = ls_null
			return 1
		end if
	
	CASE "centro_benef"
		SELECT count(*)
		  INTO :ll_count
		FROM  CENTRO_BENEFICIO CB,
				CENTRO_BENEF_USUARIO CBU
		WHERE CB.CENTRO_BENEF = CBU.CENTRO_BENEF
		 AND  CBU.COD_USR = :gs_user
		 AND  CB.centro_benef = :data
		 AND	CB.flag_Estado = '1';
		 
		 IF ll_count = 0 THEN
			Messagebox('Aviso', "Codigo de Beneficio no existe o no esta activo, por favor verificar", StopSign!)
			This.object.centro_benef	[row] = ls_null
			RETURN 1
		 END IF
	
			
END CHOOSE


of_set_total()
end event

event rowfocuschanged;call super::rowfocuschanged;int    li_item
string ls_filtro


IF NOT isNull(currentrow) AND currentrow > 0 THEN
	li_item		 = this.object.item		[currentrow]
   ls_filtro = "item = " + string(li_item)
	IF isNull(ls_filtro) THEN ls_filtro = ''
	idw_3.setfilter( ls_filtro )
	idw_3.Filter( )
	
END IF
end event

event ue_delete;//Override Ancester

long ll_row = 1 

ib_insert_mode = False

IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN ll_row = THIS.Event ue_delete_pre()  // solo si se tiene detalle

IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		do while idw_3.Rowcount( ) > 0 //Elina los registros de precios_rep
			idw_3.DeleteRow(1)
		loop
		idw_3.ii_update = 1
		il_totdel ++
		ii_update = 1								// indicador de actualizacion pendiente
		THIS.Event Post ue_delete_pos()
	END IF
END IF


RETURN ll_row

end event

type tp_firma from userobject within tab_detalles
integer x = 18
integer y = 112
integer width = 2743
integer height = 1068
long backcolor = 79741120
string text = "  Aprobación"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom082!"
long picturemaskcolor = 536870912
string powertiptext = "Aprobación de la Guia de Recepción"
dw_6 dw_6
end type

on tp_firma.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tp_firma.destroy
destroy(this.dw_6)
end on

type dw_6 from u_dw_abc within tp_firma
event ue_display ( string as_columna,  long al_row )
integer width = 2569
integer height = 932
integer taborder = 20
string dataobject = "d_guia_rec_firma_grid"
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "cod_cargo"
		
		ls_sql = "SELECT cod_cargo AS CODIGO_cargo, " &
				  + "Desc_cargo AS descripcion_cargo " &
				  + "FROM cargo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_cargo[al_row] = ls_codigo
			this.object.desc_cargo[al_row] = ls_data
		end if
		
		this.ii_update = 1
		
end choose
end event

event ue_insert_pre;call super::ue_insert_pre;string ls_nom_user
string ls_nro_guia

if dw_master.GetRow() = 0 then return

ls_nro_guia = dw_master.object.cod_guia_rec[dw_master.GetRow()]

select nombre
	into :ls_nom_user
from usuario
where cod_usr = :gs_user;

this.object.cod_usr 		[al_row] = gs_user
this.object.nom_usuario [al_row] = ls_nom_user
this.object.cod_guia_rec[al_row] = ls_nro_guia
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_menu(this)

end event

event rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
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

event itemchanged;call super::itemchanged;string ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	case "cod_cargo"
		
		select desc_cargo
			into :ls_data
		from cargo
		where cod_cargo = :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Codigo de cargo no existe", StopSign!)
			this.object.cad_cargo	[row] = ls_null
			this.object.desc_cargo	[row] = ls_null
			return 1
		end if

		this.object.desc_cargo[row] = ls_data
		
end choose

end event

type dw_master from u_dw_abc within w_ap301_guia_recepcion
event ue_display ( string as_columna,  long al_row )
integer x = 18
integer y = 176
integer width = 3552
integer height = 800
string dataobject = "d_guia_recep_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_tflota, ls_prov,	&
			ls_origen
long 		ll_count

CHOOSE CASE upper(as_columna)
		
	CASE "PROVEEDOR"
		ls_origen = This.Object.origen  [al_row]
		ls_sql 	 = "SELECT PROVEEDOR AS CODIGO, " &
				  		+ "NOM_PROVEEDOR AS NOMBRE " &
				 		+ "FROM vw_proveedor_guia_recep " &
				 		+ "WHERE COD_ORIGEN = '" + ls_origen + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
					
		IF ls_codigo <> '' THEN				
			This.object.proveedor		[al_row] = ls_codigo
			This.object.nom_proveedor	[al_row] = ls_data
		END IF
		
		This.ii_update = 1

	CASE "COD_TRATO"
		ls_sql = "SELECT TRATO_PROVEE_ID AS CODIGO, " &
				  + "TRATO_PROVEE_DESC AS DESCRIPCION " &
				  + "FROM AP_TRATO_PROVEE " &
				  + "WHERE TRATO_PROVEE_FLAG = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
					
		IF ls_codigo <> '' THEN
			This.object.cod_trato	[al_row] = ls_codigo
			This.object.desc_trato	[al_row] = ls_data
		END IF
		
		This.ii_update = 1
	
	CASE "COD_MONEDA"
		ls_sql = "SELECT COD_MONEDA AS CODIGO, " &
				  + "DESCRIPCION AS DESC_MONEDA " &
				  + "FROM MONEDA " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
					
		IF ls_codigo <> '' THEN
			This.object.cod_moneda[al_row] = ls_codigo
			This.object.descripcion[al_row] = ls_data
		END IF
		
		This.ii_update = 1
		
END CHOOSE
end event

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event ue_insert_pre;call super::ue_insert_pre;is_action = 'new'

this.object.origen			[al_row] = gs_origen
this.object.fecha_registro	[al_row] = f_fecha_actual()
this.object.flag_estado		[al_row] = '1'
this.object.cod_usr			[al_row] = gs_user
this.object.tipo_guia		[al_row] = 'H'		
this.object.p_logo.FileName 			= gs_logo
idw_2.reset()
idw_3.reset()
idw_6.reset()

idw_2.ii_protect = 1
idw_6.ii_protect = 1

idw_2.of_protect()
idw_6.of_protect()

idw_2.ii_update = 0
idw_6.ii_update = 0

Tab_detalles.Selectedtab = 1

of_set_status_menu(this)

end event

event itemerror;call super::itemerror;return 1
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event itemchanged;call super::itemchanged;String 	ls_data, ls_null

SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	CASE "proveedor"
		select nom_proveedor
			into :ls_data
		from proveedor
		where flag_estado = '1'
		  and proveedor = :data;
		  
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'EL PROVEEDOR NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.proveedor		[row] = ls_null
			this.object.nom_proveedor	[row] = ls_null
			return 1
		end if
		
		this.object.nom_proveedor[row] = ls_data
		
	CASE "cod_trato"
		
		select trato_provee_desc 
			into :ls_data
		from ap_trato_provee
		where trato_provee_flag = '1'
		  and trato_provee_id = :data;
		  
		if SQLCA.SQlCode = 100 then
			MessageBox('Aviso', 'EL CODIGO DE TRATO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.cod_trato[row]  = ls_null
			this.object.desc_trato[row] = ls_null
			return 1
		end if
		
		this.object.desc_trato[row] = ls_data
	
	CASE "cod_moneda"
		
		select descripcion
			into :ls_data
		from moneda
		where cod_moneda = :data
		  and flag_estado = '1';

		if SQLCA.SQlCode = 100 then
			MessageBox('Aviso', 'EL CODIGO DE MONEDA NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.cod_moneda	[row]  = ls_null
			this.object.descripcion	[row] = ls_null
			return 1
		end if

		this.object.descripcion[row] = ls_data
		
end choose

//



end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_menu(this)


end event

event buttonclicked;call super::buttonclicked;string ls_proveedor, ls_origen
str_parametros sl_param

CHOOSE CASE lower(dwo.name)
		
	CASE "b_referencia"
		ls_proveedor = this.object.proveedor[row]
		ls_origen	 = This.object.origen   [row]
		
		IF IsNull(ls_proveedor) OR ls_proveedor = '' THEN
			MessageBox('Aviso', 'Debe ingresar un codigo de proveedor')
			RETURN
		END IF
		
		// Si es una salida x consumo interno
		sl_param.w1 		 = parent
		sl_param.dw1       = 'd_list_pd_descarga_det_tbl'
		sl_param.titulo    = 'Partes Diarios de Descarga'
		sl_param.tipo		 = '2S'     // con un parametro del tipo string
		sl_param.string1   = ls_proveedor
		sl_param.string2   = ls_origen
		sl_param.dw_m		 = dw_master
		sl_param.dw_d		 = idw_2
		sl_param.opcion 	 = 1
	
		OpenWithParm( w_abc_seleccion, sl_param)
		
		IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
		IF sl_param.titulo = 's' THEN
			This.object.origen.protect    = 1
			This.object.proveedor.protect = 1
			This.Object.origen.Background.Color    = RGB(192,192,192)
			This.Object.proveedor.Background.Color = RGB(192,192,192)

		END IF
		
END CHOOSE

end event

type gb_1 from groupbox within w_ap301_guia_recepcion
integer x = 27
integer y = 4
integer width = 1102
integer height = 164
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda"
end type

