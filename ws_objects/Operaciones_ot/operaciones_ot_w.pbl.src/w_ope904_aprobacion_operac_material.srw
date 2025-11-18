$PBExportHeader$w_ope904_aprobacion_operac_material.srw
forward
global type w_ope904_aprobacion_operac_material from w_abc
end type
type cb_grabar from picturebutton within w_ope904_aprobacion_operac_material
end type
type cb_procesar from picturebutton within w_ope904_aprobacion_operac_material
end type
type uo_search2 from n_cst_search within w_ope904_aprobacion_operac_material
end type
type uo_search1 from n_cst_search within w_ope904_aprobacion_operac_material
end type
type dw_ot from u_dw_abc within w_ope904_aprobacion_operac_material
end type
type st_1 from statictext within w_ope904_aprobacion_operac_material
end type
type tab_1 from tab within w_ope904_aprobacion_operac_material
end type
type tabpage_1 from userobject within tab_1
end type
type dw_art from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_art dw_art
end type
type tabpage_2 from userobject within tab_1
end type
type dw_artr from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_artr dw_artr
end type
type tabpage_3 from userobject within tab_1
end type
type st_pptop from statictext within tabpage_3
end type
type dw_pptop from u_dw_abc within tabpage_3
end type
type dw_ppto from u_dw_abc within tabpage_3
end type
type st_ppto from statictext within tabpage_3
end type
type tabpage_3 from userobject within tab_1
st_pptop st_pptop
dw_pptop dw_pptop
dw_ppto dw_ppto
st_ppto st_ppto
end type
type tabpage_4 from userobject within tab_1
end type
type dw_errores from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_errores dw_errores
end type
type tab_1 from tab within w_ope904_aprobacion_operac_material
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type cb_4 from commandbutton within w_ope904_aprobacion_operac_material
end type
type st_5 from statictext within w_ope904_aprobacion_operac_material
end type
type st_3 from statictext within w_ope904_aprobacion_operac_material
end type
type st_2 from statictext within w_ope904_aprobacion_operac_material
end type
type em_items from editmask within w_ope904_aprobacion_operac_material
end type
type sle_aprobacion from singlelineedit within w_ope904_aprobacion_operac_material
end type
type cb_noproc from commandbutton within w_ope904_aprobacion_operac_material
end type
type dw_master from u_dw_abc within w_ope904_aprobacion_operac_material
end type
type gb_1 from groupbox within w_ope904_aprobacion_operac_material
end type
end forward

global type w_ope904_aprobacion_operac_material from w_abc
integer width = 5550
integer height = 2752
string title = "[OPE904] Aprobación de operaciones y materiales"
string menuname = "m_salir"
event ue_anular ( )
event ue_aprobar ( )
event ue_desaprobar ( )
cb_grabar cb_grabar
cb_procesar cb_procesar
uo_search2 uo_search2
uo_search1 uo_search1
dw_ot dw_ot
st_1 st_1
tab_1 tab_1
cb_4 cb_4
st_5 st_5
st_3 st_3
st_2 st_2
em_items em_items
sle_aprobacion sle_aprobacion
cb_noproc cb_noproc
dw_master dw_master
gb_1 gb_1
end type
global w_ope904_aprobacion_operac_material w_ope904_aprobacion_operac_material

type variables
String 		is_dw
u_dw_abc  	idw_art, idw_artr, idw_ppto, idw_pptop, idw_errores

StaticText	ist_ppto, ist_pptop

end variables

forward prototypes
public function long wf_asig_nro_solicitud_ot ()
public function string of_set_numera (string as_origen)
public subroutine wf_ppto_materiales_aprob ()
public subroutine of_asigna_dws ()
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

event ue_aprobar();Long ll_row, ll_i,ll_count,ll_ano, ll_j
String ls_oper_sec,ls_cencos,ls_cnta_prsp,ls_cod_art, ls_flag_externo, ls_nro_orden

if is_dw = '0' then
	
	ll_row = dw_ot.GetSelectedRow(0)
	Do While ll_row <> 0
		
		ls_nro_orden = dw_ot.object.nro_orden [ll_row]
		
		for ll_i = 1 to dw_master.RowCount()
			yield()
			if dw_master.object.nro_orden [ll_i] = ls_nro_orden then
				//primero verifico si es flag externo o no
				ls_flag_externo = dw_master.object.flag_externo[ll_i]
				if IsNull(ls_flag_externo) then ls_flag_externo = '1'
				
				// verfico si es externo (OS) entonces debe tener una partida 
				// presupuestal activa
				if ls_flag_externo = '1' then
					ls_cencos 		= dw_master.object.cencos		[ll_i]
					ls_cnta_prsp 	= dw_master.object.cnta_prsp	[ll_i]
					
					if IsNull(ls_cencos) or ls_Cencos = '' then
						MessageBox("Error", "Ha indicado un ejecutor tercero, necesita especificar un centro " &
											  + "de costos en la operación")
						dw_master.setRow(ll_i)
						dw_master.SelectRow(0, false)
						dw_master.SelectRow(ll_i, true)
						dw_master.SetFocus()
						return
					end if
					
					if IsNull(ls_cnta_prsp) or ls_cnta_prsp = '' then
						MessageBox("Error", "Ha indicado un ejecutor tercero, necesita especificar una Cuenta " &
												+ "Presupuestal en la operación")
						dw_master.setRow(ll_i)
						dw_master.SelectRow(0, false)
						dw_master.SelectRow(ll_i, true)
						dw_master.SetFocus()
						return
					end if
		
				end if
				
				wf_ppto_materiales_aprob()
				
				dw_master.object.flag_estado[ll_i]='1'
				dw_master.ii_update = 1
				
				yield()
				
			end if
		next
		
		//Apruebo los materiales
		for ll_j = 1 to idw_art.RowCount()
			yield()
			if idw_art.object.nro_orden   [ll_j] = ls_nro_orden then
				ls_cencos    = idw_art.object.cencos 	 [ll_j]
				ls_cnta_prsp = idw_art.object.cnta_prsp [ll_j]
				ls_cod_art	 = idw_art.object.cod_art	 [ll_j]
				ll_ano       = Long(String(idw_art.object.fec_proyect [ll_j],'yyyy'))
				
				
				select count(*) 
					into :ll_count 
				from presupuesto_partida 
				 where (cencos 	= :ls_cencos	) and
						 (cnta_prsp = :ls_cnta_prsp) and
						 (ano			= :ll_ano		) ;
				
				
				if ll_count > 0 then
					idw_art.object.flag_estado[ll_j] = '1'
					idw_art.ii_update = 1
				else
					Messagebox('Aviso','Partida Presupuestal ~r~n' + &
						"Año: " + string(ll_ano) + "~r~n" + &
						"Centro Costo: " + ls_cencos + "~r~n" + &
						"Cuenta Prsp: " + ls_cnta_prsp + "~r~n" + &
						"No Existe. Por favor verifique el item: ~r~n" + & 
						'Articulo '+ls_cod_art+', Oper Sec '+ls_oper_sec )
				end if	
			end if
		next
		
		ll_row = dw_master.GetSelectedRow(ll_row)
		wf_ppto_materiales_aprob()
		yield()
		
	Loop
	
elseIF is_dw = '1' THEN

	ll_row = dw_master.GetSelectedRow(0)
	Do While ll_row <> 0
		//primero verifico si es flag externo o no
		ls_flag_externo = dw_master.object.flag_externo[ll_row]
		if IsNull(ls_flag_externo) then ls_flag_externo = '1'
		
		// verfico si es externo (OS) entonces debe tener una partida 
		// presupuestal activa
		if ls_flag_externo = '1' then
			ls_cencos 		= dw_master.object.cencos		[ll_row]
			ls_cnta_prsp 	= dw_master.object.cnta_prsp	[ll_row]
			
			if IsNull(ls_cencos) or ls_Cencos = '' then
				MessageBox("Error", "Ha indicado un ejecutor tercero, necesita especificar un centro " &
									  + "de costos en la operación")
				dw_master.setRow(ll_row)
				dw_master.SelectRow(0, false)
				dw_master.SelectRow(ll_row, true)
				dw_master.SetFocus()
				return
			end if
			
			if IsNull(ls_cnta_prsp) or ls_cnta_prsp = '' then
				MessageBox("Error", "Ha indicado un ejecutor tercero, necesita especificar una Cuenta " &
										+ "Presupuestal en la operación")
				dw_master.setRow(ll_row)
				dw_master.SelectRow(0, false)
				dw_master.SelectRow(ll_row, true)
				dw_master.SetFocus()
				return
			end if

		end if
		
		wf_ppto_materiales_aprob()
		
		dw_master.object.flag_estado[ll_row]='1'
		dw_master.ii_update = 1
		
		ls_oper_sec = dw_master.object.oper_sec[ll_row]
		for ll_i = 1 to idw_art.RowCount()
			yield()
			if idw_art.object.oper_sec   [ll_i] = ls_oper_sec then
				ls_cencos    = idw_art.object.cencos 	 [ll_i]
				ls_cnta_prsp = idw_art.object.cnta_prsp [ll_i]
				ls_cod_art	 = idw_art.object.cod_art	 [ll_i]
				ll_ano       = Long(String(idw_art.object.fec_proyect [ll_i],'yyyy'))
				
				
				select count(*) 
					into :ll_count 
				from presupuesto_partida 
				 where (cencos 	= :ls_cencos	) and
				 		 (cnta_prsp = :ls_cnta_prsp) and
						 (ano			= :ll_ano		) ;
				
				
				if ll_count > 0 then
					idw_art.object.flag_estado[ll_i] = '1'
					idw_art.ii_update = 1
				else
					Messagebox('Aviso','Partida Presupuestal ~r~n' + &
						"Año: " + string(ll_ano) + "~r~n" + &
						"Centro Costo: " + ls_cencos + "~r~n" + &
						"Cuenta Prsp: " + ls_cnta_prsp + "~r~n" + &
						"No Existe. Por favor verifique el item: ~r~n" + & 
						'Articulo '+ls_cod_art+', Oper Sec '+ls_oper_sec )
				end if	
				
			end if
			yield()
		next
		ll_row = dw_master.GetSelectedRow(ll_row)
		wf_ppto_materiales_aprob()
	Loop
	
ELSE

	ll_row = idw_art.GetSelectedRow(0)
	Do While ll_row <> 0
		yield()
		ls_cencos    = idw_art.object.cencos 	[ll_row]
		ls_cnta_prsp = idw_art.object.cnta_prsp [ll_row]
		ls_cod_art	 = idw_art.object.cod_art	[ll_row]
		ll_ano       = Long(String(idw_art.object.fec_proyect [ll_row],'yyyy'))
				
				
		select count(*) into :ll_count from presupuesto_partida 
		 where (cencos 	= :ls_cencos	) and
		 		 (cnta_prsp = :ls_cnta_prsp) and
				 (ano			= :ll_ano		) ;
				
		
		if ll_count > 0 then
			idw_art.object.flag_estado[ll_row]='1'
			tab_1.tabpage_1.dw_art.ii_update = 1
		else
			Messagebox('Aviso','Partida Presupuestal ~r~n' + &
				"Año: " + string(ll_ano) + "~r~n" + &
				"Centro Costo: " + ls_cencos + "~r~n" + &
				"Cuenta Prsp: " + ls_cnta_prsp + "~r~n" + &
				"No Existe. Por favor verifique el item: ~r~n" + & 
				'Articulo '+ls_cod_art+', Oper Sec '+ls_oper_sec )
		end if	
				
		wf_ppto_materiales_aprob()
		ll_row = idw_art.GetSelectedRow(ll_row)
		
		yield()
	Loop
	
END IF
end event

event ue_desaprobar();Long ll_row, ll_i
string ls_oper_sec

IF is_dw='1' THEN

	ll_row = dw_master.GetSelectedRow(0)
	Do While ll_row <> 0
		dw_master.object.flag_estado[ll_row]='0'
		dw_master.ii_update = 1
		
		ls_oper_sec = dw_master.object.oper_sec[ll_row]
		
		for ll_i = 1 to idw_art.RowCount()
			if idw_art.object.oper_sec[ll_i] = ls_oper_sec then
				idw_art.object.flag_estado[ll_i] = dw_master.object.flag_estado[ll_row]
				tab_1.tabpage_1.dw_art.ii_update = 1
			end if
		next		

		ll_row = dw_master.GetSelectedRow(ll_row )
	Loop
	wf_ppto_materiales_aprob()
ELSE

	ll_row = idw_art.GetSelectedRow(0)
	Do While ll_row <> 0
		idw_art.object.flag_estado[ll_row]='0'
		tab_1.tabpage_1.dw_art.ii_update = 1
		ll_row = idw_art.GetSelectedRow(ll_row )
	Loop
	wf_ppto_materiales_aprob()
END IF
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

public subroutine wf_ppto_materiales_aprob ();String ls_nada = ' ',ls_msj_err,ls_cod_origen,ls_estado
Long   ll_inicio,ll_nro_mov

//SetPointer(hourglass!)

//ACTUALIZA INFORMACION tabla temporal
tab_1.tabpage_1.dw_art.Accepttext()

delete from tt_ope_aprob_mat_ot_prev ;


Insert Into tt_ope_aprob_mat_ot_prev
Select * from tt_ope_aprobacion_material_ot ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error', ls_msj_err)
	return
END IF

//Actualizo los datos de las operaciones
dw_master.Accepttext( )
dw_master.Update()
commit;

for ll_inicio = 1 to idw_art.Rowcount()
	 ls_cod_origen = idw_art.object.cod_origen  [ll_inicio]
	 ll_nro_mov    = idw_art.object.nro_mov		 [ll_inicio]
	 ls_estado     = idw_art.object.flag_estado [ll_inicio]
	 
	 update tt_ope_aprob_mat_ot_prev
	    set flag_estado = :ls_estado
	  where (cod_origen = :ls_cod_origen ) and
	  		  (nro_mov	  = :ll_nro_mov    ) ;
	
next

//



DECLARE usp_ope_evaluacion_pto_aprob PROCEDURE FOR 
	usp_ope_evaluacion_pto_aprob (:ls_nada);
	
EXECUTE usp_ope_evaluacion_pto_aprob ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error', ls_msj_err)
END IF

CLOSE usp_ope_evaluacion_pto_aprob;
idw_pptop.Retrieve()
end subroutine

public subroutine of_asigna_dws ();idw_art 		= tab_1.tabpage_1.dw_art
idw_artr 	= tab_1.tabpage_2.dw_artr
idw_ppto 	= tab_1.tabpage_3.dw_ppto
idw_pptop 	= tab_1.tabpage_3.dw_pptop
idw_errores	= tab_1.tabpage_4.dw_errores


ist_ppto 	= tab_1.tabpage_3.st_ppto
ist_pptop 	= tab_1.tabpage_3.st_pptop
end subroutine

on w_ope904_aprobacion_operac_material.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cb_grabar=create cb_grabar
this.cb_procesar=create cb_procesar
this.uo_search2=create uo_search2
this.uo_search1=create uo_search1
this.dw_ot=create dw_ot
this.st_1=create st_1
this.tab_1=create tab_1
this.cb_4=create cb_4
this.st_5=create st_5
this.st_3=create st_3
this.st_2=create st_2
this.em_items=create em_items
this.sle_aprobacion=create sle_aprobacion
this.cb_noproc=create cb_noproc
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_grabar
this.Control[iCurrent+2]=this.cb_procesar
this.Control[iCurrent+3]=this.uo_search2
this.Control[iCurrent+4]=this.uo_search1
this.Control[iCurrent+5]=this.dw_ot
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.tab_1
this.Control[iCurrent+8]=this.cb_4
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.em_items
this.Control[iCurrent+13]=this.sle_aprobacion
this.Control[iCurrent+14]=this.cb_noproc
this.Control[iCurrent+15]=this.dw_master
this.Control[iCurrent+16]=this.gb_1
end on

on w_ope904_aprobacion_operac_material.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_grabar)
destroy(this.cb_procesar)
destroy(this.uo_search2)
destroy(this.uo_search1)
destroy(this.dw_ot)
destroy(this.st_1)
destroy(this.tab_1)
destroy(this.cb_4)
destroy(this.st_5)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.em_items)
destroy(this.sle_aprobacion)
destroy(this.cb_noproc)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;Long ll_count

of_Asigna_dws()

idw_art.SetTransObject(SQLCA)
idw_artr.SetTransObject(SQLCA)
idw_ppto.SetTransObject(SQLCA)
idw_pptop.SetTransObject(SQLCA)
dw_master.SetTransObject(SQLCA)
dw_ot.SetTransObject(SQLCA)

idw_1 = dw_ot              // asignar dw corriente

cb_procesar.enabled=true
cb_grabar.enabled=false
cb_noproc.enabled=false
sle_aprobacion.visible=false
st_3.visible=false

em_items.text = '0'

uo_search1.of_set_dw(dw_ot)
uo_search2.of_set_dw(dw_master)


end event

event ue_modify;call super::ue_modify;String  ls_flag_estado
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
		dw_master.object.flag_estado.Protect = 1
	END IF
ELSE
	dw_master.ii_protect = 0
	dw_master.of_protect() 
	
	//HABILITAR RESPUESTA

	dw_master.object.flag_estado.Protect = 0
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

event resize;call super::resize;of_Asigna_dws()

dw_master.width  = newwidth  - dw_master.x - 10
st_5.width = dw_master.width
st_5.x = dw_master.x

uo_search1.event ue_resize(sizetype, uo_search1.width, newheight)

uo_search2.width  = newwidth - uo_search2.x   - 10
uo_search2.event ue_resize(sizetype, uo_search2.width, newheight)

tab_1.height  		= newheight - tab_1.y   - 10
tab_1.width  		= newwidth - tab_1.x   - 10


idw_art.height  	= tab_1.tabpage_1.height - idw_art.y   - 10
idw_art.width   	= tab_1.tabpage_1.width  - idw_art.x    - 10

idw_artr.height	= tab_1.tabpage_2.height - idw_artr.y   - 10
idw_artr.width   	= tab_1.tabpage_2.width  - idw_artr.x    - 10

//tabpage_3
ist_pptop.width   		= tab_1.tabpage_3.width / 2 - ist_pptop.x - 5

idw_pptop.width   		= ist_pptop.width
idw_pptop.height  		= tab_1.tabpage_3.height - idw_pptop.y   - 10

ist_ppto.x					= ist_pptop.x + ist_pptop.width + 5
ist_ppto.width				= tab_1.tabpage_3.width - ist_pptop.x -10

idw_ppto.x  				= ist_ppto.x
idw_ppto.width  			= ist_ppto.width
idw_ppto.height  			= tab_1.tabpage_3.height - idw_ppto.y   - 10

//tabpage_4
idw_errores.width  			= tab_1.tabpage_3.width - idw_errores.x - 5
idw_errores.height  			= tab_1.tabpage_4.height - idw_errores.y   - 10


end event

event ue_refresh;call super::ue_refresh;String 	ls_tipo, ls_codigo, ls_opcion, ls_msj_err, ls_ot_adm 
DATE 		ld_fecha
DateTime ldt_fecha_sistema
Long 		ll_count

st_3.visible = false
sle_aprobacion.visible = false
idw_ppto.reset()
idw_pptop.reset()

// Resetea datawindows
dw_master.reset()
idw_art.reset()
idw_artr.reset()
dw_ot.Reset()
idw_errores.Reset()


//create or replace procedure usp_ope_selecc_operac_aprob(
//       asi_user      in usuario.cod_usr%type
//) IS
DECLARE usp_ope_selecc_operac_aprob PROCEDURE FOR 
		  usp_ope_selecc_operac_aprob(:gs_user);
EXECUTE usp_ope_selecc_operac_aprob ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error', 'Error en procedure usp_ope_selecc_operac_aprob, Mensaje: ' + ls_msj_err, StopSign!)
	Return
end if

CLOSE usp_ope_selecc_operac_aprob ;

cb_grabar.enabled=true
cb_noproc.enabled=true

dw_ot.Retrieve()
dw_master.Retrieve()
idw_art.Retrieve()
idw_artr.Retrieve()
idw_errores.Retrieve( )

dw_ot.ResetUpdate()
dw_master.ResetUpdate()
idw_art.ResetUpdate()
idw_artr.ResetUpdate()
idw_errores.ResetUpdate( )

dw_ot.ii_update = 0
dw_master.ii_update = 0
idw_art.ii_update = 0
idw_artr.ii_update = 0
idw_errores.ii_update = 0


if dw_ot.RowCount() > 0 then
 	dw_ot.setRow(1)
	dw_ot.SelectRow(0, false)
	dw_ot.SelectRow(1, true)
	
	dw_ot.event ue_filtrar( 1)
	dw_ot.setFocus()
end if


end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
idw_Art.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	idw_Art.of_create_log()
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

IF idw_Art.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_Art.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = idw_Art.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_Art.ii_update = 0
	dw_master.il_totdel = 0
	idw_Art.il_totdel = 0
	
	dw_master.ResetUpdate()
	idw_Art.ResetUpdate()
	
	//f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

event ue_update_pre;call super::ue_update_pre;

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( idw_art) <> true then	return


ib_update_check = true


end event

type cb_grabar from picturebutton within w_ope904_aprobacion_operac_material
integer x = 777
integer y = 60
integer width = 402
integer height = 224
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Grabar la Aprobación"
alignment htextalign = Center!
vtextalign vtextalign = multiline!
boolean map3dcolors = true
string powertiptext = "Listar Ordenes de Trabajo"
end type

event clicked;String 	ls_codigo, ls_msj_err, ls_aprobacion, ls_control
Long 		ll_count, ll_i
Decimal	lde_saldo
str_parametros lstr_rep

parent.event ue_update()

//Validacion de Presupuesto
for ll_i = 1 to idw_pptop.RowCount()
	lde_saldo  = idw_pptop.Object.saldo_total	[ll_i]
	ls_control = idw_pptop.Object.flag_control[ll_i]
	
	if IsNull(ls_control) then
		MessageBox("Aviso","PARTIDA PRESUPUESTAL NO TIENE FLAG DE CONTROL, POR FAVOR VERIFIQUE EN LA PESTAÑA DE PRESUPUESTO!!!")
		Return
	end if
	
	If lde_saldo < 0 and ls_control <> '0' then
		MessageBox("Aviso","NO SE PUEDE LLEVAR A CABO LA APROBACION PUES NO HAY PRESUPUESTO SUFICIENTE. REVISE PESTAÑA PRESUPUESTO")
		Return
	end if
next

//create or replace procedure usp_ope_aprueba_operac(
//       asi_origen    in  origen.cod_origen%type,
//       asi_user      in  usuario.cod_usr%type,
//       aso_nro_aprob OUT ot_aprobaciones.nro_aprob%type 
//) IS

// aprobacion de materiales	
DECLARE usp_ope_aprueba_operac PROCEDURE FOR 
		usp_ope_aprueba_operac(:gs_origen, 
								  	  :gs_user);
										 
EXECUTE usp_ope_aprueba_operac ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error', "Error en usp_ope_aprueba_operac. Mensaje: " + ls_msj_err, StopSign!)
	Return
end if

FETCH usp_ope_aprueba_operac INTO :ls_aprobacion ;

CLOSE usp_ope_aprueba_operac ;


st_3.visible = true
sle_aprobacion.visible = true
sle_aprobacion.text = ls_aprobacion
cb_grabar.enabled  = false
cb_procesar.enabled= true

f_mensaje('Proceso ha concluído satisfactoriamente', '')

event ue_refresh()




end event

type cb_procesar from picturebutton within w_ope904_aprobacion_operac_material
integer x = 27
integer y = 60
integer width = 402
integer height = 224
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lista des Ordenes de Trabajo"
alignment htextalign = Center!
vtextalign vtextalign = multiline!
boolean map3dcolors = true
string powertiptext = "Listar Ordenes de Trabajo"
end type

event clicked;event ue_refresh()
end event

type uo_search2 from n_cst_search within w_ope904_aprobacion_operac_material
event destroy ( )
integer x = 2112
integer y = 340
integer width = 3278
integer taborder = 120
end type

on uo_search2.destroy
call n_cst_search::destroy
end on

type uo_search1 from n_cst_search within w_ope904_aprobacion_operac_material
event destroy ( )
integer y = 340
integer width = 2112
integer taborder = 110
end type

on uo_search1.destroy
call n_cst_search::destroy
end on

event ue_post_editchanged;call super::ue_post_editchanged;if dw_ot.RowCount() = 0 then 
	
	dw_master.Reset()
	idw_art.Reset()
	
else
	dw_ot.setRow(1)
	dw_ot.selectRow( 0, false)
	dw_ot.SelectRow(1, true)

	dw_ot.event ue_filtrar( 1 )
end if


end event

type dw_ot from u_dw_abc within w_ope904_aprobacion_operac_material
event ue_aprobar ( )
event ue_filtrar ( long al_row )
integer y = 496
integer width = 2633
integer height = 788
integer taborder = 20
string dataobject = "d_proc_ordenes_trabajo_tbl"
end type

event ue_filtrar(long al_row);String ls_nro_orden

ls_nro_orden = this.object.nro_orden[al_row]

dw_master.setFilter("nro_orden='"+ls_nro_orden + "'" )
dw_master.filter( )

IF dw_master.RowCount() > 0 then		// la busqueda resulto exitosa
	dw_master.SelectRow(0, false)
	dw_master.SelectRow(1,true)
	dw_master.ScrollToRow(1)
END IF

idw_art.setFilter("nro_orden='"+ls_nro_orden + "'"  )
idw_art.filter( )

IF idw_art.RowCount() > 0 then		// la busqueda resulto exitosa
	idw_art.SelectRow(0, false)
	idw_art.SelectRow(1,true)
	idw_art.ScrollToRow(1)
END IF
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'tabular'
ii_ss = 0



end event

event doubleclicked;call super::doubleclicked;string 			ls_nro_orden
str_parametros 	lstr_param

choose case lower(dwo.name)
case 'nro_orden'
		if row = 0 then return

		ls_nro_orden = this.object.nro_orden[row]
		lstr_param.dw1		 = 'd_abc_datos_ot_frm'
		lstr_param.string1 = '1'
		lstr_param.string2 = ls_nro_orden
		OpenWithParm(w_cns_datos_ot, lstr_param)

end choose


end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;
//Ancestor Script
if row = 0 then return
m_rbutton_aprobar 	lm_1

lm_1 = CREATE m_rbutton_aprobar 
lm_1.PopMenu(w_main.PointerX(), w_main.PointerY())

destroy lm_1


end event

event getfocus;call super::getfocus;
idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


is_dw = '0'

end event

event rowfocuschanged;call super::rowfocuschanged;String ls_nro_orden


IF currentRow = 0 or this.RowCount() = 0 THEN 
	dw_master.Reset()

	idw_art.Reset()

	RETURN
else
	this.event ue_filtrar(currentrow)
end if


end event

event clicked;call super::clicked;if row =0 then return

this.event ue_filtrar( row )
end event

type st_1 from statictext within w_ope904_aprobacion_operac_material
integer y = 424
integer width = 2633
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Ordenes de Trabajo"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type tab_1 from tab within w_ope904_aprobacion_operac_material
integer y = 1304
integer width = 3730
integer height = 1140
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3694
integer height = 1012
long backcolor = 79741120
string text = "Materiales Requeridos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Properties!"
long picturemaskcolor = 536870912
dw_art dw_art
end type

on tabpage_1.create
this.dw_art=create dw_art
this.Control[]={this.dw_art}
end on

on tabpage_1.destroy
destroy(this.dw_art)
end on

type dw_art from u_dw_abc within tabpage_1
integer width = 3209
integer height = 548
integer taborder = 100
string dataobject = "d_proc_materiales_aprobadas_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 3				// columnas de lectrua de este dw
ii_ck[2] = 4
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle


end event

event clicked;call super::clicked;is_dw = '2'
ii_update = 1
end event

event doubleclicked;call super::doubleclicked;string 			ls_nro_orden
Long 				ll_em_items
str_parametros 	lstr_param

choose case lower(dwo.name)
case 'nro_orden'
		if row = 0 then return
		
		ls_nro_orden = this.object.nro_orden[row]
		lstr_param.dw1		 = 'd_abc_datos_ot_frm'
		lstr_param.string1 = '1'
		lstr_param.string2 = ls_nro_orden
		OpenWithParm(w_cns_datos_ot, lstr_param)

case 'oper_sec' // Con articulos
		if row = 0 then return
		ls_nro_orden = this.object.oper_sec[row]
		lstr_param.dw1		 = 'd_cns_det_opersec_x_autorizar_mat_tbl'
		lstr_param.string1 = '3'
		lstr_param.string2 = ls_nro_orden
		OpenWithParm(w_cns_datos_ot, lstr_param)

case 'cod_art'
		if row = 0 then return
		ls_nro_orden = this.object.cod_art[row]
		ll_em_items  = LONG(em_items.text)
		lstr_param.dw1		 = 'd_cns_articulos_x_aprobar_cmp'
		lstr_param.string1 = '4'
		lstr_param.string2 = ls_nro_orden
		lstr_param.long1 	 = ll_em_items
		OpenWithParm(w_cns_datos_ot, lstr_param)

end choose


end event

event rbuttondown;//Ancestor Script
if row = 0 then return
m_rbutton_aprobar 	lm_1

lm_1 = CREATE m_rbutton_aprobar 
lm_1.PopMenu(w_main.PointerX(), w_main.PointerY())

destroy lm_1

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


em_items.TExt = string(this.RowCount())
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3694
integer height = 1012
long backcolor = 79741120
string text = "Materiales Reposición"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Move!"
long picturemaskcolor = 536870912
dw_artr dw_artr
end type

on tabpage_2.create
this.dw_artr=create dw_artr
this.Control[]={this.dw_artr}
end on

on tabpage_2.destroy
destroy(this.dw_artr)
end on

type dw_artr from u_dw_abc within tabpage_2
integer width = 3214
integer height = 548
integer taborder = 20
string dataobject = "d_proc_materiales_aprobadas_reps"
end type

event constructor;call super::constructor;ii_ck[1] = 1
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3694
integer height = 1012
long backcolor = 79741120
string text = "Presupuesto"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "ComputeSum!"
long picturemaskcolor = 536870912
st_pptop st_pptop
dw_pptop dw_pptop
dw_ppto dw_ppto
st_ppto st_ppto
end type

on tabpage_3.create
this.st_pptop=create st_pptop
this.dw_pptop=create dw_pptop
this.dw_ppto=create dw_ppto
this.st_ppto=create st_ppto
this.Control[]={this.st_pptop,&
this.dw_pptop,&
this.dw_ppto,&
this.st_ppto}
end on

on tabpage_3.destroy
destroy(this.st_pptop)
destroy(this.dw_pptop)
destroy(this.dw_ppto)
destroy(this.st_ppto)
end on

type st_pptop from statictext within tabpage_3
integer width = 1614
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Partidas Presupuestales"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_pptop from u_dw_abc within tabpage_3
integer y = 80
integer width = 1614
integer height = 552
integer taborder = 20
string dataobject = "d_proc_ppto_partida_mat_aprob_tbl"
end type

event constructor;call super::constructor;ii_ck[1] = 1
end event

event doubleclicked;call super::doubleclicked;string 	ls_cencos, ls_cntap, ls_flag_ctrl
integer 	li_ano, li_mes
Date 		ld_fec_ini, ld_fec_fin


if row = 0 then return
w_ope907_aprob_material_prsp_det lw_1


if dwo.name = 'monto_aprob' then//Saldo Comprometido

	str_parametros lstr_rep
	
	ls_flag_ctrl = this.object.flag_control[row]
	ls_cencos   = this.object.cencos[row]
	ls_cntap    = this.object.cnta_prsp[row]
	li_ano   = this.object.ano[row]
	li_mes = this.object.mes[row]
	
	DECLARE usp_ope_periodo_control_pprsp PROCEDURE FOR 
		usp_ope_periodo_control_pprsp( :ls_flag_ctrl, 
												 :li_ano, 
												 :li_mes) ;
	EXECUTE usp_ope_periodo_control_pprsp ;
	
	IF sqlca.sqlcode = -1 Then
		rollback ;
		MessageBox( 'Error usp_ope_periodo_control_pprsp', sqlca.sqlerrtext, StopSign! )
		return
	End If
	
	FETCH usp_ope_periodo_control_pprsp INTO :ld_fec_ini, :ld_fec_fin;
	CLOSE usp_ope_periodo_control_pprsp;
	
	IF sqlca.sqlcode = -1 Then
		rollback ;
		MessageBox( 'Error fetch usp_ope_periodo_control_pprsp', sqlca.sqlerrtext, StopSign! )
		return
	End If

	lstr_rep.fecha1  = ld_fec_ini
	lstr_rep.fecha2  = ld_fec_fin
	lstr_rep.string1 = string(ls_cencos)
	lstr_rep.string2 = string(ls_cntap)
	lstr_rep.string3 = ls_flag_ctrl
	lstr_rep.long1				= li_ano
	
	opensheetwithparm (lw_1, lstr_rep, w_main, 0, Layered!)

end if
end event

type dw_ppto from u_dw_abc within tabpage_3
integer x = 1623
integer y = 84
integer width = 1614
integer height = 552
integer taborder = 20
string dataobject = "d_proc_ppto_mat_aprob"
end type

event constructor;call super::constructor;ii_ck[1] = 1
end event

type st_ppto from statictext within tabpage_3
integer x = 1623
integer width = 1614
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Partidas x articulo"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3694
integer height = 1012
long backcolor = 79741120
string text = "Errores / Mensajes"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_errores dw_errores
end type

on tabpage_4.create
this.dw_errores=create dw_errores
this.Control[]={this.dw_errores}
end on

on tabpage_4.destroy
destroy(this.dw_errores)
end on

type dw_errores from u_dw_abc within tabpage_4
integer width = 3611
integer height = 864
string dataobject = "d_proc_errores_tbl"
end type

event constructor;call super::constructor;ii_ck[1] = 1
end event

type cb_4 from commandbutton within w_ope904_aprobacion_operac_material
integer x = 439
integer y = 176
integer width = 325
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cns. Pto"
end type

event clicked;String ls_nada = ' ',ls_msj_err,ls_cod_origen,ls_estado
Long   ll_inicio,ll_nro_mov

SetPointer(hourglass!)

//ACTUALIZA INFORMACION tabla temporal
tab_1.tabpage_1.dw_art.Accepttext()

delete from tt_ope_aprob_mat_ot_prev ;


Insert Into tt_ope_aprob_mat_ot_prev
Select * from tt_ope_aprobacion_material_ot ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error', ls_msj_err)
END IF



for ll_inicio = 1 to idw_art.Rowcount()
	 ls_cod_origen = idw_art.object.cod_origen  [ll_inicio]
	 ll_nro_mov    = idw_art.object.nro_mov		 [ll_inicio]
	 ls_estado     = idw_art.object.flag_estado [ll_inicio]
	 
	 update tt_ope_aprob_mat_ot_prev
	    set flag_estado = :ls_estado
	  where (cod_origen = :ls_cod_origen ) and
	  		  (nro_mov	  = :ll_nro_mov    ) ;
	
	 
next

//



DECLARE PB_usp_ope_evaluacion_pto_aprob PROCEDURE FOR usp_ope_evaluacion_pto_aprob
(:ls_nada);
EXECUTE PB_usp_ope_evaluacion_pto_aprob ;



IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error', ls_msj_err)
END IF

//tipo de ot
OpenSheet(w_ope745_presp_art_aprobados,  parent, 2, Layered!)

SetPointer(Arrow!)
end event

type st_5 from statictext within w_ope904_aprobacion_operac_material
integer x = 2638
integer y = 424
integer width = 3278
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Operaciones pendientes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_ope904_aprobacion_operac_material
integer x = 1189
integer y = 60
integer width = 439
integer height = 112
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Numero Aprobacion"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ope904_aprobacion_operac_material
integer x = 2642
integer y = 240
integer width = 183
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Items :"
boolean focusrectangle = false
end type

type em_items from editmask within w_ope904_aprobacion_operac_material
integer x = 2830
integer y = 228
integer width = 119
integer height = 84
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type sle_aprobacion from singlelineedit within w_ope904_aprobacion_operac_material
integer x = 1189
integer y = 196
integer width = 439
integer height = 88
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217857
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type cb_noproc from commandbutton within w_ope904_aprobacion_operac_material
integer x = 439
integer y = 60
integer width = 325
integer height = 108
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Cns. N.A."
end type

event clicked;Decimal 	ld_imp_max_aprob_amp
Long 		ll_nivel_aprob, ll_count
String 	ls_ot_adm, ls_flag_aprobador, ls_codigo
w_ope908_rpt_artic_no_autorizados lw_1

sg_parametros_est lstr_rep


SELECT o.imp_max_aprob_amp, o.nivel_aprob, ou.flag_aprobador
  INTO :ld_imp_max_aprob_amp, :ll_nivel_aprob, :ls_flag_aprobador
  FROM ot_adm_aprob_req o, ot_adm_usuario ou
 WHERE o.ot_adm	= ou.ot_adm 
   and o.cod_usr	= ou.cod_usr 
	and o.ot_adm 	= :ls_ot_adm
	and o.cod_usr 	= :gs_user;

IF ls_flag_aprobador='N' THEN
	Messagebox('Aviso', 'Usted no esta autorizado a esta opción')
	Return
ELSEIF ls_flag_aprobador='C' then
	Messagebox('Aviso', 'Usted no tiene restricciones para aprobar')
	Return
END IF

lstr_rep.string1 = gs_user	
		
OpenSheetWithParm(lw_1, lstr_rep, w_main, 2, layered!)	

end event

type dw_master from u_dw_abc within w_ope904_aprobacion_operac_material
event ue_aprobar ( )
integer x = 2638
integer y = 496
integer width = 3278
integer height = 788
string dataobject = "d_proc_operaciones_aprobadas_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
ii_ck[1] = 2				// columnas de lectrua de este dw
is_dwform = 'tabular'
idw_mst  = dw_master				// dw_master
ii_ss = 0



end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;String ls_nro_orden, ls_oper_sec
Long ll_row
Integer li_busqueda



is_dw = '1'
dw_master.ii_update = 1

IF row = 0 THEN RETURN

ls_nro_orden = this.object.nro_orden[row]
ls_oper_sec = this.object.oper_sec[row]

ll_row = idw_art.find('oper_sec='+"'"+ls_oper_sec+"'",1, idw_art.RowCount() )

IF ll_row > 0 then		// la busqueda resulto exitosa
	idw_art.SelectRow(0, false)
	idw_art.SelectRow(ll_row,true)
	idw_art.ScrollToRow(ll_row)
END IF

end event

event ue_insert_pre;call super::ue_insert_pre;this.SetItem( al_row, 'flag_estado', '1' )
this.SetItem( al_row, 'cod_origen', gs_origen )
this.SetItem( al_row, 'fecha_registro', today() )
this.SetItem( al_row, 'cod_usr', gs_user )
//is_accion = 'new'
//proteger respuesta
dw_master.object.respuesta_rsp.Protect = 1
end event

event ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event rbuttondown;
//Ancestor Script
if row = 0 then return
m_rbutton_aprobar 	lm_1

lm_1 = CREATE m_rbutton_aprobar 
lm_1.PopMenu(w_main.PointerX(), w_main.PointerY())

destroy lm_1


end event

event doubleclicked;call super::doubleclicked;string 			ls_nro_orden
str_parametros 	lstr_param

choose case lower(dwo.name)
case 'nro_orden'
		if row = 0 then return

		ls_nro_orden = this.object.nro_orden[row]
		lstr_param.dw1		 = 'd_abc_datos_ot_frm'
		lstr_param.string1 = '1'
		lstr_param.string2 = ls_nro_orden
		OpenWithParm(w_cns_datos_ot, lstr_param)

case 'oper_sec'
		if row = 0 then return
		ls_nro_orden = this.object.oper_sec[row]
		lstr_param.dw1		 = 'd_cns_detalle_opersec_x_autorizar_tbl'
		lstr_param.string1 = '2'
		lstr_param.string2 = ls_nro_orden
		OpenWithParm(w_cns_datos_ot, lstr_param)

end choose


end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

em_items.TExt = string(this.RowCount())
end event

type gb_1 from groupbox within w_ope904_aprobacion_operac_material
integer width = 2994
integer height = 328
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

