$PBExportHeader$w_cam380_packing_list.srw
forward
global type w_cam380_packing_list from w_abc_master
end type
type dw_detalle from u_dw_abc within w_cam380_packing_list
end type
end forward

global type w_cam380_packing_list from w_abc_master
integer width = 3497
integer height = 3280
string title = "[CAM380] Packing List"
string menuname = "m_abc_anular_lista"
dw_detalle dw_detalle
end type
global w_cam380_packing_list w_cam380_packing_list

type variables
u_dw_abc idw_detalle
end variables

forward prototypes
public subroutine of_asigna_dws ()
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro)
public subroutine of_retrieve_datos (datawindow ad_dw, string as_registro, string as_item, long al_row)
end prototypes

public subroutine of_asigna_dws ();idw_detalle 		= dw_detalle

end subroutine

public function integer of_set_numera ();// Numera documento
Long 	ll_ult_nro, ll_j
string	ls_mensaje, ls_nro, ls_table

if is_action = 'new' then

	ls_table = 'LOCK TABLE num_sic_packing_list IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_ult_nro 
	from num_sic_packing_list
	where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode = 100 then
		Insert into num_sic_packing_list (cod_origen, ult_nro)
			values( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		ll_ult_nro = 1
	end if
	
	// Asigna numero a cabecera
	ls_nro = TRIM( gs_origen) + trim(string(ll_ult_nro, '00000000'))

	dw_master.object.nro_registro[dw_master.getrow()] = ls_nro
	// Incrementa contador
	Update num_sic_packing_list 
		set ult_nro = ult_nro + 1
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
dw_master.object.nro_registro[dw_master.getrow()] = ls_nro
for ll_j = 1 to idw_detalle.RowCount()	
	idw_detalle.object.nro_registro		[ll_j] = ls_nro	
next

return 1
end function

public subroutine of_retrieve (string as_nro);Long ll_row, ll_ano, ll_mes

ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

if ll_row > 0 then
	// Fuerza a leer detalle
	idw_detalle.retrieve(as_nro)

	dw_master.ii_protect = 0
	dw_master.ii_update	= 0
	dw_master.of_protect()
	dw_master.ResetUpdate()
	
	idw_detalle.ii_protect = 0
	idw_detalle.ii_update	= 0
	idw_detalle.of_protect()
	idw_detalle.ResetUpdate()
	
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	is_action = 'open'
end if

return 
end subroutine

public subroutine of_retrieve_datos (datawindow ad_dw, string as_registro, string as_item, long al_row);String ls_nave, ls_precinto, ls_contenedor, ls_termo, ls_cert, ls_guia, ls_embarque

select scdd.nave , scdd.nro_precinto,
       scdd.contenedor, scdd.temptale, 
       scdd.tipo_certificacion, scdd.GUIA, scdd.EMBARQUE
into :ls_nave, :ls_precinto, :ls_contenedor, :ls_termo, :ls_cert, :ls_guia, :ls_embarque
  from sic_control_cont_det SCDD
  where scdd.nro_registro = :as_registro
    and scdd.nro_item   = to_number(:as_item);

ad_dw.object.reg_control	[al_row] 		= as_registro
ad_dw.object.vapor	[al_row] 				= ls_nave
ad_dw.object.nro_precinto[al_row] 		= ls_precinto
ad_dw.object.nro_contenedor[al_row] 	= ls_contenedor
ad_dw.object.nro_termoregistro[al_row] = ls_termo
ad_dw.object.NRO_GUIA[al_row] 			= ls_guia
ad_dw.object.NRO_EMBARQUE[al_row] 	= ls_embarque

end subroutine

event resize;//Override
of_asigna_dws()

dw_master.width  = newwidth  - dw_master.x - 10

idw_detalle.width  = newwidth  - idw_detalle.x - 10
idw_detalle.height = newheight  - idw_detalle.y - 10


end event

on w_cam380_packing_list.create
int iCurrent
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
this.dw_detalle=create dw_detalle
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detalle
end on

on w_cam380_packing_list.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detalle)
end on

event ue_update;//Override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
idw_detalle.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	idw_detalle.of_create_log()

END IF


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF idw_detalle.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_detalle.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_detalle.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detalle.ii_update = 0
	
	dw_master.il_totdel = 0
	idw_detalle.il_totdel = 0
	
	dw_master.ResetUpdate()
	idw_detalle.ResetUpdate()

	if dw_master.getRow() > 0 then
		of_retrieve(dw_master.object.nro_registro[dw_master.getRow()])
	end if
	
END IF

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_detalle, idw_detalle.is_dwform) <> true then	return

//AutoNumeración de Registro
if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
idw_detalle.of_set_flag_replicacion()
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_sic_packing_list_tbl'
sl_param.titulo = 'Registro de Packing List'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_insert;//Override
Long  ll_row

if idw_1 <> dw_master then
	if dw_master.getRow() = 0 then
		MessageBox('Error', 'No esta permitido insertar un detalle sin antes haber insertado la cabecera, por favor verifique')
		return
	elseif f_row_Processing( dw_master, dw_master.is_dwform) <> true then	
		return
	end if
end if


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

event ue_print;// vista previa de mov. almacen
sg_parametros lstr_rep

if dw_master.rowcount() = 0 then return

lstr_rep.dw1 		= 'd_rpt_packing_list_tbl'
lstr_rep.titulo 	= 'Previo de Packing List'
lstr_rep.string1 	= dw_master.object.nro_registro[dw_master.getrow()]
lstr_rep.tipo		= '1S'

OpenSheetWithParm(w_cam380_packing_list_frm, lstr_rep, w_main, 0, Layered!)
end event

event ue_modify;call super::ue_modify;dw_detalle.of_protect()
end event

type dw_master from w_abc_master`dw_master within w_cam380_packing_list
integer width = 3282
integer height = 828
string dataobject = "d_abc_sic_packing_list_cab_ff"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dateTime ldt_fec_oracle

ldt_fec_oracle = f_fecha_actual()

Date 	ld_FechaActual, ld_FechaInicio 
Long 	ll_Semana 

ld_FechaActual = Date(f_fecha_actual())
ld_FechaInicio = Date('01/01/'+String(Year(ld_FechaActual))) 
ll_Semana = DaysAfter(ld_FechaInicio, ld_FechaActual) / 7 + 1

this.object.fec_registro 			[al_row] = ldt_fec_oracle
this.object.cod_usr 				[al_row] = gs_user
this.object.fec_salida				[al_row] = Date(ldt_fec_oracle)
this.object.semana				[al_row]	= ll_semana
this.object.ano						[al_row] = integer(string(ldt_fec_oracle,'yyyy'))
this.object.inicio_llenado			[al_row]	= DateTime(Date(ldt_fec_oracle), Time("08:00:00"))
this.object.fin_llenado				[al_row]	= DateTime(Date(ldt_fec_oracle), Time("16:00:00"))
this.object.hora_llegada_cont	[al_row]	= DateTime(Date(ldt_fec_oracle), Time("10:00:00"))
this.object.flag_estado			[al_row] = '1'

is_action = 'new'
end event

event dw_master::constructor;call super::constructor;of_asigna_dws()

is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
idw_det  =  idw_detalle

end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_data2, ls_data3, ls_sql, ls_ot_adm, &
			ls_nro_ot, ls_labor, ls_null
SetNull(ls_null)			

choose case lower(as_columna)
	case "proveedor"
		ls_sql = "SELECT p.proveedor AS codigo, " &
				 + "p.nom_proveedor as nombre, " &
 				 + "p.proveedor AS codigo1, " &
 				 + "p.proveedor AS codigo2 " &
				 + "FROM proveedor p " &
				 + "WHERE  p.FLAG_ESTADO = '1' "

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.proveedor	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "tipo_funda"
		ls_sql = "SELECT p.tipo_funda AS tipo_funda, " &
				 + "p.DESC_TIPO_FUNDA as DESC_TIPO_FUNDA, " &
 				 + "p.COD_ART AS COD_ART, " &
 				 + "p.FLAG_ESTADO AS FLAG_ESTADO " &
				 + "FROM AP_TIPO_FUNDA p " &
				 + "WHERE  p.FLAG_ESTADO = '1' "

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.tipo_funda	[al_row] = ls_codigo
			this.object.desc_tipo_funda	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "nro_guia"
		ls_sql = "SELECT p.cod_origen AS cod_origen, " &
				 + "p.NRO_GUIA as NRO_GUIA, " &
 				 + "p.DESTINATARIO AS DESTINATARIO, " &
 				 + "p.FLAG_ESTADO AS FLAG_ESTADO " &
				 + "FROM GUIA p " &
				 + "WHERE  p.FLAG_ESTADO = '1' "

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.org_guia	[al_row] = ls_codigo
			this.object.nro_guia	[al_row] = ls_data
			this.ii_update = 1
		end if

case "reg_control"

		ls_codigo = this.object.proveedor [al_row]
		
		IF ls_codigo = '' then
			MessageBox("Aviso","Primero Seleccione un Cliente")
			return
		END IF
		
		ls_sql = "select a.nro_registro as registro, a.nro_item as item, " &
		+ " a.nave as nave, a.nro_precinto as precinto,  " &
       	+ " a.contenedor as contenedor " &
		+ " from sic_control_cont_det a " &
		+ " where a.proveedor = '" + ls_codigo +  "' "

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')			
		
		if ls_codigo <> '' then
			of_retrieve_datos(dw_master,ls_codigo, ls_data, al_row)
			this.ii_update = 1
		end if

end choose

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
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

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2
decimal	ldc_has
Long 		ll_count
Date		ld_fecha

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name

	case "proveedor"

		SELECT p.proveedor, p.nom_proveedor
				into :ls_desc1, :ls_desc2
			FROM proveedor p 
				 WHERE p.proveedor = :data
				 and p.FLAG_ESTADO = '1' ;
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Códigoo o no se encuentra activo, por favor verifique")
			this.object.proveedor	[row] = ls_null
			this.object.nom_proveedor		[row] = ls_null
			return 1
		end if
		
			this.object.proveedor				[row] = ls_desc1
			this.object.nom_proveedor		[row] = ls_desc2
	
	case "fec_salida"

		this.object.inicio_llenado			[row]	= DateTime(Date(data), Time("08:00:00"))
		this.object.fin_llenado				[row]	= DateTime(Date(data), Time("16:00:00"))
		this.object.hora_llegada_cont	[row]	= DateTime(Date(data), Time("10:00:00"))
		
END CHOOSE
end event

type dw_detalle from u_dw_abc within w_cam380_packing_list
integer x = 5
integer y = 848
integer width = 3136
integer height = 1540
boolean bringtotop = true
string dataobject = "d_abc_sic_packing_list_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = 	dw_master

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item 	[al_row] = of_nro_item(this)
this.object.pallet_01	[al_row] = 0
this.object.pallet_02	[al_row] = 0
this.object.pallet_03	[al_row] = 0
this.object.pallet_04	[al_row] = 0
this.object.pallet_05	[al_row] = 0
this.object.pallet_06	[al_row] = 0
this.object.pallet_07	[al_row] = 0
this.object.pallet_08	[al_row] = 0
this.object.pallet_09	[al_row] = 0
this.object.pallet_10	[al_row] = 0
this.object.pallet_11	[al_row] = 0
this.object.pallet_12	[al_row] = 0
this.object.pallet_13	[al_row] = 0
this.object.pallet_14	[al_row] = 0
this.object.pallet_15	[al_row] = 0
this.object.pallet_16	[al_row] = 0
this.object.pallet_17	[al_row] = 0
this.object.pallet_18	[al_row] = 0
this.object.pallet_19	[al_row] = 0
this.object.pallet_20	[al_row] = 0
this.SetColumn('cod_art') 
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

event ue_display;call super::ue_display;boolean 	lb_ret
Integer li_caja
string 	ls_codigo, ls_data, ls_data2, ls_data3, ls_sql, ls_ot_adm, &
			ls_nro_ot, ls_labor, ls_null
SetNull(ls_null)			

choose case lower(as_columna)
	case "nro_certificacion"
		ls_sql = "SELECT a.nro_certificacion AS certificacion_productor, " &
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
			this.object.nro_certificacion	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data3
			this.ii_update = 1
		end if		
		
	case "cod_art"
		ls_sql = "select distinct a.cod_art as codigo, a.desc_art as descripcion, " &
			+ " a.nom_articulo as nombre, a.flag_estado  as estado " &
 			+ " from AP_TIPO_CERTIFICACION_det p, " &
      	+ " articulo a " &
		+ "  where a.cod_art = p.cod_art_pptt "

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.cod_art	[al_row] = ls_codigo
			this.object.desc_art	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "nro_parte"
		
		if IsNull(this.object.nro_certificacion[al_row]) then
			MessageBox("Aviso", "Seleccione Primero el Nro de Certificación")
			return
		end if
		
		ls_sql = "select accd.nro_parte as nro_parte, " &
       + " trunc(acc.fec_parte) as fec_parte, " &
       + " ae.desc_empacadora as desc_empacadora, " &
       + " ab.desc_base as desc_base, " &
       + " (Select nvl(sum(cant_cajas) ,0) " &
		 + "      from AP_RECIBO_CAJAS arc " &
		+ " 	  where arc.nro_parte = accd.nro_parte " &
 			+ " 	 and arc.nro_certificacion = accd.nro_certificacion) -  " &
         + " (select nvl(sum(nvl(pallet_01,0)+nvl(pallet_02,0)+nvl(pallet_03,0)+ " &
         + " nvl(pallet_04,0)+nvl(pallet_05,0)+nvl(pallet_06,0)+nvl(pallet_07,0)+ " &
         + " nvl(pallet_08,0)+nvl(pallet_09,0)+nvl(pallet_10,0)+nvl(pallet_11,0)+ " &
         + " nvl(pallet_12,0)+nvl(pallet_13,0)+nvl(pallet_14,0)+nvl(pallet_15,0)+ " &
         + " nvl(pallet_16,0)+nvl(pallet_17,0)+nvl(pallet_18,0)+nvl(pallet_19,0)+ " &
         + " nvl(pallet_20,0)),0)  " &
         + " from sic_packing_list_det sic  " &
         + " where sic.nro_certificacion = accd.nro_certificacion  " &
         + " and sic.nro_parte = accd.nro_parte ) as cajas_producidas " & 
+ "    from AP_CONTROL_COSECHA acc, " &
    + "     AP_CONTROL_COSECHA_DET accd, " &
       + "  AP_EMPACADORA ae, " &
        + " ap_sectores ase, " &
        + " ap_bases ab " &
+ "   where acc.nro_parte = accd.nro_parte " &
    + " and acc.cod_empacadora = ae.cod_empacadora " &
    + "  and acc.ano = " + string(dw_master.object.ano [dw_master.GetRow()]) + " " &
    + " and acc.semana between " + string( dw_master.object.semana [dw_master.GetRow()] -1) + " and " + string( dw_master.object.semana [dw_master.GetRow()]  ) + " " &
    + " and ae.cod_sector = ase.cod_sector " &
    + " and ase.cod_base = ab.cod_base " &
	+ " and accd.nro_certificacion = '" + this.object.nro_certificacion [al_row] +"'"
	
			lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.nro_parte			[al_row] = ls_codigo
			this.object.fec_parte			[al_row] = date(ls_data)
			this.object.desc_empacadora [al_row] = ls_data2
			this.object.desc_base			[al_row] = ls_data3
			ls_data		= this.object.nro_certificacion[al_row]

	select 
      (Select nvl(sum(cant_cajas) ,0)
		      from AP_RECIBO_CAJAS arc
			  where arc.nro_parte = accd.nro_parte
 				 and arc.nro_certificacion = accd.nro_certificacion) - 
         (select NVL(sum(nvl(pallet_01,0)+nvl(pallet_02,0)+nvl(pallet_03,0)+
         nvl(pallet_04,0)+nvl(pallet_05,0)+nvl(pallet_06,0)+nvl(pallet_07,0)+
         nvl(pallet_08,0)+nvl(pallet_09,0)+nvl(pallet_10,0)+nvl(pallet_11,0)+
         nvl(pallet_12,0)+nvl(pallet_13,0)+nvl(pallet_14,0)+nvl(pallet_15,0)+
         nvl(pallet_16,0)+nvl(pallet_17,0)+nvl(pallet_18,0)+nvl(pallet_19,0)+
         nvl(pallet_20,0)) ,0)
         from sic_packing_list_det sic 
         where sic.nro_certificacion = accd.nro_certificacion 
         and sic.nro_parte = accd.nro_parte ) as cajas_producidas
		into :li_caja
   from AP_CONTROL_COSECHA acc,
        AP_CONTROL_COSECHA_DET accd,
        AP_EMPACADORA ae,
        ap_sectores ase,
        ap_bases ab
  where acc.nro_parte = accd.nro_parte
    and acc.cod_empacadora = ae.cod_empacadora
    and ae.cod_sector = ase.cod_sector
    and ase.cod_base = ab.cod_base
	and accd.nro_certificacion = :ls_data
	and accd.nro_parte= : ls_codigo;

			this.object.cajas_max			[al_row] = li_caja
			this.ii_update = 1
		end if		

	case "tipo_certificacion"
		ls_sql = "select distinct p.tipo_certificacion as codigo, p.desc_certificacion as descripcion, " &
			+ " p.flag_estado as estado, p.flag_estado as estado2 " &
 			+ " from AP_TIPO_CERTIFICACION p"
		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.tipo_certificacion	[al_row] = ls_codigo
			this.object.desc_certificacion	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc1
decimal	ldc_has
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE lower(dwo.name)

	case "nro_certificacion"

		SELECT p.nom_proveedor 
				into :ls_desc1
			FROM AP_PROVEEDOR_CERTIF a, 
				 	ap_proveedor_mp mp, 
				     proveedor p 
				 WHERE a.proveedor = p.proveedor 
				 and a.nro_certificacion = :data
				 and a.proveedor = mp.proveedor 
				 and p.FLAG_ESTADO = '1' 
				 and mp.flag_estado = '1';
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Numero de Certificado o el productor no se encuentra activo, por favor verifique")
			this.object.nro_certificacion	[row] = ls_null
			this.object.nom_proveedor		[row] = ls_null
			return 1
		end if
		
	this.object.nro_certificacion	[row] = data
	this.object.nom_proveedor		[row] = ls_desc1
	
	case "pallet_01"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_01 [row] = 0
				return 1
			end if		
	case "pallet_02"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_02 [row] = 0
				return 1
			end if		
	case "pallet_03"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_03 [row] = 0
				return 1
			end if		
	case "pallet_04"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_04 [row] = 0
				return 1
			end if		
	case "pallet_05"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_05 [row] = 0
				return 1
			end if		
	case "pallet_06"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_06 [row] = 0
				return 1
			end if		
	case "pallet_07"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_07 [row] = 0
				return 1
			end if		
	case "pallet_08"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_08 [row] = 0
				return 1
			end if		
	case "pallet_09"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_09 [row] = 0
				return 1
			end if		
	case "pallet_10"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_10 [row] = 0
				return 1
			end if		
	case "pallet_11"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_11 [row] = 0
				return 1
			end if		
	case "pallet_12"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_12 [row] = 0
				return 1
			end if		
	case "pallet_13"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_13 [row] = 0
				return 1
			end if		
	case "pallet_14"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_14 [row] = 0
				return 1
			end if		
	case "pallet_15"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_15 [row] = 0
				return 1
			end if		
	case "pallet_16"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_16 [row] = 0
				return 1
			end if		
	case "pallet_17"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_17 [row] = 0
				return 1
			end if		
	case "pallet_18"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_18 [row] = 0
				return 1
			end if		
	case "pallet_19"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_19 [row] = 0
				return 1
			end if		
	case "pallet_20"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_20 [row] = 0
				return 1
			end if		

END CHOOSE


end event

