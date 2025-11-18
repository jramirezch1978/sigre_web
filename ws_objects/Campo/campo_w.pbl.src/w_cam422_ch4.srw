$PBExportHeader$w_cam422_ch4.srw
forward
global type w_cam422_ch4 from w_abc_mastdet_smpl
end type
end forward

global type w_cam422_ch4 from w_abc_mastdet_smpl
integer width = 2629
integer height = 2268
string title = "[CAM422] CH4-010511"
string menuname = "m_abc_anular_lista"
end type
global w_cam422_ch4 w_cam422_ch4

type variables
String	is_soles, is_salir
end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_set_base (long al_row, string as_productor)
public subroutine of_retrieve (string as_nro)
public function integer of_get_param ()
end prototypes

public function integer of_set_numera ();// Numera documento
Long 		ll_ult_nro, ll_j, ll_count
string	ls_mensaje, ls_nro

if is_action = 'new' then

	Select count(*) 
		into :ll_count
	from NUM_SIC_CH4_010511 
	where cod_origen = :gs_origen;
	
	IF ll_count = 0 then
		Insert into NUM_SIC_CH4_010511 (cod_origen, ult_nro)
			values( :gs_origen, 1);
	end if
	
	Select ult_nro 
		into :ll_ult_nro 
	from NUM_SIC_CH4_010511 
	where cod_origen = :gs_origen for update;
	
	// Asigna numero a cabecera
	ls_nro = TRIM( gs_origen) + trim(string(ll_ult_nro, '00000000'))
	
	dw_master.object.nro_registro[dw_master.getrow()] = ls_nro
	// Incrementa contador
	Update NUM_SIC_CH4_010511
		set ult_nro = :ll_ult_nro + 1 
	 where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_registro[dw_master.getrow()] 
end if

// Asigna numero a detalle
for ll_j = 1 to dw_detail.RowCount()	
	dw_detail.object.nro_registro[ll_j] = ls_nro	
next
return 1
end function

public subroutine of_set_base (long al_row, string as_productor);string	ls_base, ls_Desc_base

select distinct ab.cod_base, ab.desc_base
	into :ls_base, :ls_desc_base
from ap_bases ab,
     ap_proveedor_certif apc
where ab.cod_base = apc.cod_base  
  and apc.proveedor = :as_productor;

dw_master.object.cod_base [al_row] = ls_base
dw_master.object.desc_base [al_row] = ls_desc_base
end subroutine

public subroutine of_retrieve (string as_nro);Long ll_row, ll_ano, ll_mes

ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

if ll_row > 0 then
	// Fuerza a leer detalle
	dw_detail.retrieve(as_nro)
	
	if dw_detail.RowCount() > 0 then
		dw_detail.il_row = 1
		dw_detail.SelectRow(0, false)
		dw_detail.SelectRow(dw_detail.il_Row, true)
		dw_detail.SetRow(1)
	end if
	
	dw_master.ii_protect = 0
	dw_master.ii_update	= 0
	dw_master.of_protect()
	dw_master.ResetUpdate()
	
	dw_detail.ii_protect = 0
	dw_detail.ii_update	= 0
	dw_detail.of_protect()
	dw_detail.ResetUpdate()
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	is_action = 'open'
end if

return 
end subroutine

public function integer of_get_param ();String ls_mensaje

// busca tipos de movimiento definidos
SELECT 	cod_soles
	INTO 	:is_soles
FROM logparam 
where reckey = '1';

if sqlca.sqlcode = 100 then
	Messagebox( "Error", "no ha definido parametros en Logparam")
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error", ls_mensaje)
	return 0
end if

// busca doc. prog. compras
if ISNULL( is_soles ) or TRIM( is_soles ) = '' then
	Messagebox("Error", "Defina Moneda Soles en logparam")
	return 0
end if


return 1

end function

on w_cam422_ch4.create
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
end on

on w_cam422_ch4.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

ii_lec_mst = 0 
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, dw_detail.is_dwform) <> true then	return

if dw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta detalle")
	return
end if

//of_set_total_oc()
if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()


end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_sic_ch4_tbl'
sl_param.titulo = 'Registro CH4'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_update;//Override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

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
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	if dw_master.getRow() > 0 then
		of_retrieve(dw_master.object.nro_registro[dw_master.getRow()])
	end if
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
	
END IF

end event

event ue_anular;call super::ue_anular;String	ls_estado
Long		ll_i

if dw_master.getRow() = 0 then return

ls_estado = dw_master.object.flag_estado[dw_master.getRow()] 

if ls_estado <> '1' then
	MessageBox('Error', 'No se puede anular el documento porque no esta ACTIVO, por favor verifique')
	return
end if

IF dw_master.ii_update = 1 OR dw_detail.ii_update = 1 THEN 
	Messagebox('Aviso','Tiene Actualizaciones Pendientes Grabe Antes de Anular ,Verifique!')
	Return
END IF

if MessageBox('Aviso', 'Desea anular el documento?', Information!, YesNo!, 2) = 2 then return

dw_master.object.flag_estado [dw_master.getRow()] = '0'
dw_master.ii_update = 1

for ll_i = 1 to dw_detail.RowCount()
	dw_detail.object.flag_estado[ll_i] = '0'
	dw_detail.ii_update = 1
next
end event

event ue_print;call super::ue_print;/*// vista previa de mov. almacen
sg_parametros lstr_rep

if dw_master.rowcount() = 0 then return

lstr_rep.dw1 		= 'd_frm_credito'
lstr_rep.titulo 	= 'Previo de Crédito'
lstr_rep.string1 	= dw_master.object.nro_credito[dw_master.getrow()]
lstr_rep.tipo		= '1S'

OpenSheetWithParm(w_cam304_creditos_frm, lstr_rep, w_main, 0, Layered!)*/
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cam422_ch4
integer x = 0
integer y = 0
integer width = 2533
integer height = 896
string dataobject = "d_abc_sic_ch4_cab_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro 	[al_row] = f_fecha_Actual()
this.object.cod_usr 	[al_row] = gs_user
this.object.flag_estado		[al_row] = '1'

is_Action = 'new'

end event

event dw_master::constructor;call super::constructor; is_dwform = 'form' // tabular form
 
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cam422_ch4
integer x = 0
integer y = 916
integer width = 2542
integer height = 1084
string dataobject = "d_abc_sic_ch4_det_tbl"
end type

event dw_detail::constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = 	dw_master

end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
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

event dw_detail::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_data2, ls_data3, ls_sql, ls_ot_adm, &
			ls_nro_ot, ls_labor, ls_null
SetNull(ls_null)			

choose case lower(as_columna)
	case "proveedor"
		ls_sql = "SELECT p.proveedor as cod_productor, " &
				 + "a.has as area_has, " &
				 + "p.nro_doc_ident AS nro_doc_ident, " &
				 + "p.nom_proveedor AS nombre_productor, " &
				 + "p.ruc AS ruc_productor " &
				 + "FROM AP_PROVEEDOR_CERTIF a, " &
				 +"      ap_proveedor_mp mp, " &
				 + "     proveedor p " &
				 + "WHERE a.proveedor = p.proveedor " &
				 + "  and a.proveedor = mp.proveedor " &
				 + "  and p.FLAG_ESTADO = '1' " &
				 + "  and mp.flag_estado = '1'"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.proveedor	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data3
			this.ii_update = 1
		end if

end choose
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.nro_item  [al_row]	= of_nro_item(this)
end event

