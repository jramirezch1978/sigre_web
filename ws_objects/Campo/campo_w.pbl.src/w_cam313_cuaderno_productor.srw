$PBExportHeader$w_cam313_cuaderno_productor.srw
forward
global type w_cam313_cuaderno_productor from w_abc_master
end type
type tab_1 from tab within w_cam313_cuaderno_productor
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detalle from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detalle dw_detalle
end type
type tabpage_2 from userobject within tab_1
end type
type dw_cosecha from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_cosecha dw_cosecha
end type
type tabpage_3 from userobject within tab_1
end type
type dw_deshierbo from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_deshierbo dw_deshierbo
end type
type tabpage_4 from userobject within tab_1
end type
type dw_deshije from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_deshije dw_deshije
end type
type tabpage_5 from userobject within tab_1
end type
type dw_limp_matas from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_limp_matas dw_limp_matas
end type
type tabpage_6 from userobject within tab_1
end type
type dw_enfunde from u_dw_abc within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_enfunde dw_enfunde
end type
type tabpage_7 from userobject within tab_1
end type
type dw_prot_racimo from u_dw_abc within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_prot_racimo dw_prot_racimo
end type
type tabpage_8 from userobject within tab_1
end type
type dw_cos_com from u_dw_abc within tabpage_8
end type
type tabpage_8 from userobject within tab_1
dw_cos_com dw_cos_com
end type
type tabpage_9 from userobject within tab_1
end type
type dw_riego from u_dw_abc within tabpage_9
end type
type tabpage_9 from userobject within tab_1
dw_riego dw_riego
end type
type tabpage_10 from userobject within tab_1
end type
type dw_pre_abono from u_dw_abc within tabpage_10
end type
type tabpage_10 from userobject within tab_1
dw_pre_abono dw_pre_abono
end type
type tabpage_11 from userobject within tab_1
end type
type dw_inv from u_dw_abc within tabpage_11
end type
type tabpage_11 from userobject within tab_1
dw_inv dw_inv
end type
type tabpage_12 from userobject within tab_1
end type
type dw_capacitacion from u_dw_abc within tabpage_12
end type
type tabpage_12 from userobject within tab_1
dw_capacitacion dw_capacitacion
end type
type tabpage_13 from userobject within tab_1
end type
type dw_cost_mant from u_dw_abc within tabpage_13
end type
type tabpage_13 from userobject within tab_1
dw_cost_mant dw_cost_mant
end type
type tabpage_14 from userobject within tab_1
end type
type dw_ventas from u_dw_abc within tabpage_14
end type
type tabpage_14 from userobject within tab_1
dw_ventas dw_ventas
end type
type tabpage_15 from userobject within tab_1
end type
type dw_siembra from u_dw_abc within tabpage_15
end type
type tabpage_15 from userobject within tab_1
dw_siembra dw_siembra
end type
type tabpage_16 from userobject within tab_1
end type
type dw_prep_terr from u_dw_abc within tabpage_16
end type
type tabpage_16 from userobject within tab_1
dw_prep_terr dw_prep_terr
end type
type tabpage_17 from userobject within tab_1
end type
type dw_fert_l from u_dw_abc within tabpage_17
end type
type tabpage_17 from userobject within tab_1
dw_fert_l dw_fert_l
end type
type tabpage_18 from userobject within tab_1
end type
type dw_fert_d from u_dw_abc within tabpage_18
end type
type tabpage_18 from userobject within tab_1
dw_fert_d dw_fert_d
end type
type tabpage_19 from userobject within tab_1
end type
type dw_fito_l from u_dw_abc within tabpage_19
end type
type tabpage_19 from userobject within tab_1
dw_fito_l dw_fito_l
end type
type tabpage_20 from userobject within tab_1
end type
type dw_fito_d from u_dw_abc within tabpage_20
end type
type tabpage_20 from userobject within tab_1
dw_fito_d dw_fito_d
end type
type tab_1 from tab within w_cam313_cuaderno_productor
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
tabpage_9 tabpage_9
tabpage_10 tabpage_10
tabpage_11 tabpage_11
tabpage_12 tabpage_12
tabpage_13 tabpage_13
tabpage_14 tabpage_14
tabpage_15 tabpage_15
tabpage_16 tabpage_16
tabpage_17 tabpage_17
tabpage_18 tabpage_18
tabpage_19 tabpage_19
tabpage_20 tabpage_20
end type
end forward

global type w_cam313_cuaderno_productor from w_abc_master
integer width = 3337
integer height = 3280
string title = "[CM313] Cuaderno del Productor"
string menuname = "m_abc_anular_lista"
tab_1 tab_1
end type
global w_cam313_cuaderno_productor w_cam313_cuaderno_productor

type variables
u_dw_abc idw_detalle, idw_cosecha, idw_deshije, idw_deshierbo, idw_limp_matas, &
			idw_enfunde, idw_prot_racimo, idw_cos_com, idw_riego, idw_pre_abono, &
			idw_inv, idw_capacitacion, idw_cost_mant, idw_ventas, idw_siembra, idw_prep_terr, &
			idw_fert_l, idw_fert_d, idw_fito_l, idw_fito_d
end variables

forward prototypes
public subroutine of_asigna_dws ()
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro)
public subroutine of_retrieve_productor (datawindow ad_dw, string as_nro_certif, long al_row)
end prototypes

public subroutine of_asigna_dws ();idw_detalle 		= tab_1.tabpage_1.dw_detalle
idw_cosecha 		= tab_1.tabpage_2.dw_cosecha
idw_deshierbo 		= tab_1.tabpage_3.dw_deshierbo
idw_deshije 		= tab_1.tabpage_4.dw_deshije
idw_limp_matas		= tab_1.tabpage_5.dw_limp_matas
idw_enfunde			= tab_1.tabpage_6.dw_enfunde
idw_prot_racimo	= tab_1.tabpage_7.dw_prot_racimo
idw_cos_com		= tab_1.tabpage_8.dw_cos_com
idw_riego			= tab_1.tabpage_9.dw_riego
idw_pre_abono		= tab_1.tabpage_10.dw_pre_abono
idw_inv				= tab_1.tabpage_11.dw_inv
idw_capacitacion	= tab_1.tabpage_12.dw_capacitacion
idw_cost_mant		= tab_1.tabpage_13.dw_cost_mant
idw_ventas			= tab_1.tabpage_14.dw_ventas
idw_siembra			= tab_1.tabpage_15.dw_siembra
idw_prep_terr		= tab_1.tabpage_16.dw_prep_terr
idw_fert_l		= tab_1.tabpage_17.dw_fert_l
idw_fert_d			= tab_1.tabpage_18.dw_fert_d
idw_fito_l			= tab_1.tabpage_19.dw_fito_l
idw_fito_d		= tab_1.tabpage_20.dw_fito_d

end subroutine

public function integer of_set_numera ();// Numera documento
Long 	ll_ult_nro, ll_j
string	ls_mensaje, ls_nro, ls_table

if is_action = 'new' then

	ls_table = 'LOCK TABLE NUM_SIC_CUADERNO_PRODUCTOR IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_ult_nro 
	from NUM_SIC_CUADERNO_PRODUCTOR
	where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode = 100 then
		Insert into NUM_SIC_CUADERNO_PRODUCTOR (cod_origen, ult_nro)
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
	Update NUM_SIC_CUADERNO_PRODUCTOR 
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

for ll_j = 1 to idw_cosecha.RowCount()	
	idw_cosecha.object.nro_registro		[ll_j] = ls_nro	
next
for ll_j = 1 to idw_deshije.RowCount()	
	idw_deshije.object.nro_registro		[ll_j] = ls_nro	
next

for ll_j = 1 to idw_deshierbo.RowCount()	
	idw_deshierbo.object.nro_registro	[ll_j] = ls_nro	
next

for ll_j = 1 to idw_limp_matas.RowCount()	
	idw_limp_matas.object.nro_registro	[ll_j] = ls_nro	
next

for ll_j = 1 to idw_enfunde.RowCount()	
	idw_enfunde.object.nro_registro		[ll_j] = ls_nro	
next

for ll_j = 1 to idw_prot_racimo.RowCount()	
	idw_prot_racimo.object.nro_registro	[ll_j] = ls_nro	
next

for ll_j = 1 to idw_riego.RowCount()	
	idw_riego.object.nro_registro			[ll_j] = ls_nro	
next

for ll_j = 1 to idw_pre_abono.RowCount()	
	idw_pre_abono.object.nro_registro	[ll_j] = ls_nro
next

for ll_j = 1 to idw_inv.RowCount()	
	idw_inv.object.nro_registro			[ll_j] = ls_nro	
next

for ll_j = 1 to idw_capacitacion.RowCount()	
	idw_capacitacion.object.nro_registro[ll_j] = ls_nro	
next

for ll_j = 1 to idw_cost_mant.RowCount()	
	idw_cost_mant.object.nro_registro	[ll_j] = ls_nro	
next

for ll_j = 1 to idw_ventas.RowCount()	
	idw_ventas.object.nro_registro		[ll_j] = ls_nro	
next

for ll_j = 1 to idw_siembra.RowCount()	
	idw_siembra.object.nro_registro		[ll_j] = ls_nro	
next

for ll_j = 1 to idw_prep_terr.RowCount()	
	idw_prep_terr.object.nro_registro	[ll_j] = ls_nro	
next

for ll_j = 1 to idw_fert_l.RowCount()	
	idw_fert_l.object.nro_registro	[ll_j] = ls_nro	
next

for ll_j = 1 to idw_fert_d.RowCount()	
	idw_fert_d.object.nro_registro	[ll_j] = ls_nro	
next

for ll_j = 1 to idw_fito_l.RowCount()	
	idw_fito_l.object.nro_registro	[ll_j] = ls_nro	
next

for ll_j = 1 to idw_fito_d.RowCount()	
	idw_fito_d.object.nro_registro	[ll_j] = ls_nro	
next

return 1
end function

public subroutine of_retrieve (string as_nro);Long ll_row, ll_ano, ll_mes

ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

if ll_row > 0 then
	// Fuerza a leer detalle
	idw_detalle.retrieve(as_nro)
	idw_cosecha.retrieve(as_nro)
	idw_deshije.retrieve(as_nro)
	idw_deshierbo.retrieve(as_nro)
	idw_limp_matas.retrieve(as_nro)
	idw_enfunde.retrieve(as_nro)
	idw_prot_racimo.retrieve(as_nro)
	idw_cos_com.retrieve(as_nro)
	idw_riego.retrieve(as_nro)
	idw_pre_abono.retrieve(as_nro)
	idw_inv.retrieve(as_nro)
	idw_capacitacion.retrieve(as_nro)
	idw_cost_mant.retrieve(as_nro)
	idw_ventas.retrieve(as_nro)
	idw_siembra.retrieve(as_nro)
	idw_prep_terr.retrieve(as_nro)
	idw_fert_l.retrieve(as_nro)
	idw_fert_d.retrieve(as_nro)
	idw_fito_l.retrieve(as_nro)	
	idw_fito_d.retrieve(as_nro)
	
	dw_master.ii_protect = 0
	dw_master.ii_update	= 0
	dw_master.of_protect()
	dw_master.ResetUpdate()
	
	idw_detalle.ii_protect = 0
	idw_detalle.ii_update	= 0
	idw_detalle.of_protect()
	idw_detalle.ResetUpdate()
	
	idw_cosecha.ii_protect = 0
	idw_cosecha.ii_update	= 0
	idw_cosecha.of_protect()
	idw_cosecha.ResetUpdate()
	
	idw_deshije.ii_protect = 0
	idw_deshije.ii_update	= 0
	idw_deshije.of_protect()
	idw_deshije.ResetUpdate()
	
	idw_deshierbo.ii_protect = 0
	idw_deshierbo.ii_update	= 0
	idw_deshierbo.of_protect()
	idw_deshierbo.ResetUpdate()
	
	idw_limp_matas.ii_protect = 0
	idw_limp_matas.ii_update	= 0
	idw_limp_matas.of_protect()
	idw_limp_matas.ResetUpdate()
	
	idw_enfunde.ii_protect = 0
	idw_enfunde.ii_update	= 0
	idw_enfunde.of_protect()
	idw_enfunde.ResetUpdate()
	
	idw_prot_racimo.ii_protect = 0
	idw_prot_racimo.ii_update	= 0
	idw_prot_racimo.of_protect()
	idw_prot_racimo.ResetUpdate()
	
	idw_riego.ii_protect = 0
	idw_riego.ii_update	= 0
	idw_riego.of_protect()
	idw_riego.ResetUpdate()
	
	idw_pre_abono.ii_protect = 0
	idw_pre_abono.ii_update	= 0
	idw_pre_abono.of_protect()
	idw_pre_abono.ResetUpdate()
	
	idw_inv.ii_protect = 0
	idw_inv.ii_update	= 0
	idw_inv.of_protect()
	idw_inv.ResetUpdate()

	idw_capacitacion.ii_protect = 0
	idw_capacitacion.ii_update	= 0
	idw_capacitacion.of_protect()
	idw_capacitacion.ResetUpdate()
	
	idw_cost_mant.ii_protect = 0
	idw_cost_mant.ii_update	= 0
	idw_cost_mant.of_protect()
	idw_cost_mant.ResetUpdate()
	
	idw_ventas.ii_protect = 0
	idw_ventas.ii_update	= 0
	idw_ventas.of_protect()
	idw_ventas.ResetUpdate()
	
	idw_siembra.ii_protect = 0
	idw_siembra.ii_update	= 0
	idw_siembra.of_protect()
	idw_siembra.ResetUpdate()
	
	idw_prep_terr.ii_protect = 0
	idw_prep_terr.ii_update	= 0
	idw_prep_terr.of_protect()
	idw_prep_terr.ResetUpdate()

	idw_fert_l.ii_protect = 0
	idw_fert_l.ii_update	= 0
	idw_fert_l.of_protect()
	idw_fert_l.ResetUpdate()
	
	idw_fert_d.ii_protect = 0
	idw_fert_d.ii_update	= 0
	idw_fert_d.of_protect()
	idw_fert_d.ResetUpdate()
	
	idw_fito_l.ii_protect = 0
	idw_fito_l.ii_update	= 0
	idw_fito_l.of_protect()
	idw_fito_l.ResetUpdate()
	
	idw_fito_d.ii_protect = 0
	idw_fito_d.ii_update	= 0
	idw_fito_d.of_protect()
	idw_fito_d.ResetUpdate()
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	is_action = 'open'
end if

return 
end subroutine

public subroutine of_retrieve_productor (datawindow ad_dw, string as_nro_certif, long al_row);String ls_desc_base, ls_nom_productor, ls_nro_doc_ident, ls_grado_inst, ls_estado_civil 
String	ls_caserio, ls_distrito, ls_provincia, ls_departamento, ls_nombre_conyuge, ls_dni_conyuge 
Integer li_nro_hijos
Decimal ld_fec_nac, ld_fec_nac_c

select p.nom_proveedor, p.nro_doc_ident, 
       apm.distrito, apm.provincia, apm.departamento, apm.caserio, apm.grado_instruccion, apm.flag_estado_civil, 
       apm.nombre_conyuge, apm.dni_conyuge, MONTHS_BETWEEN(sysdate,apm.fec_nac_conyuge), apm.nro_hijos, apb.desc_base, MONTHS_BETWEEN(sysdate,apm.fec_nac)
into :ls_nom_productor, :ls_nro_doc_ident, :ls_distrito, :ls_provincia, :ls_departamento, :ls_caserio, :ls_grado_inst,
	  :ls_estado_civil, :ls_nombre_conyuge, :ls_dni_conyuge, :ld_fec_nac_c, :li_nro_hijos, :ls_desc_base, :ld_fec_nac
from ap_proveedor_certif    apc,
     proveedor              p,
     ap_proveedor_mp        apm,
     ap_bases               apb
where apc.nro_certificacion = :as_nro_certif
  and apc.proveedor         = p.proveedor     
  and apc.proveedor         = apm.proveedor
  and apc.cod_base          = apb.cod_base;
  
ad_dw.object.nom_proveedor[al_row] 		= ls_nom_productor
ad_dw.object.nro_doc_ident[al_row] 			= ls_nro_doc_ident
ad_dw.object.distrito[al_row] 					= ls_distrito
ad_dw.object.provincia[al_row] 				= ls_provincia
ad_dw.object.departamento[al_row] 			= ls_departamento
ad_dw.object.caserio[al_row] 					= ls_caserio
ad_dw.object.grado_instruccion[al_row] 	= ls_grado_inst
ad_dw.object.flag_estado_civil[al_row] 		= ls_estado_civil
ad_dw.object.nombre_conyuge[al_row] 		= ls_nombre_conyuge
ad_dw.object.dni_conyuge[al_row] 			= ls_dni_conyuge
ad_dw.object.edad_productor[al_row]		= integer(ld_fec_nac /12)
ad_dw.object.edad_conyuge[al_row]			= integer(ld_fec_nac_c /12)
ad_dw.object.nro_hijos[al_row] 				= li_nro_hijos
ad_dw.object.desc_base[al_row] 				= ls_desc_base
end subroutine

event resize;//Override
of_asigna_dws()

dw_master.width  = newwidth  - dw_master.x - 10

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detalle.width  = tab_1.tabpage_1.width  - tab_1.tabpage_1.x - 10
idw_detalle.height = tab_1.tabpage_1.height  - tab_1.tabpage_1.y - 10

idw_cosecha.width  = tab_1.tabpage_2.width  - tab_1.tabpage_2.x - 10
idw_cosecha.height = tab_1.tabpage_2.height  - tab_1.tabpage_2.y - 10

idw_deshierbo.width  = tab_1.tabpage_3.width  - tab_1.tabpage_3.x - 10
idw_deshierbo.height = tab_1.tabpage_3.height  - tab_1.tabpage_3.y - 10

idw_deshije.width  = tab_1.tabpage_4.width  - tab_1.tabpage_4.x - 10
idw_deshije.height = tab_1.tabpage_4.height  - tab_1.tabpage_4.y - 10

idw_limp_matas.width  = tab_1.tabpage_5.width  - tab_1.tabpage_5.x - 10
idw_limp_matas.height = tab_1.tabpage_5.height  - tab_1.tabpage_5.y - 10

idw_enfunde.width  = tab_1.tabpage_6.width  - tab_1.tabpage_6.x - 10
idw_enfunde.height = tab_1.tabpage_6.height  - tab_1.tabpage_6.y - 10

idw_prot_racimo.width  = tab_1.tabpage_7.width  - tab_1.tabpage_7.x - 10
idw_prot_racimo.height = tab_1.tabpage_7.height  - tab_1.tabpage_7.y - 10

idw_cos_com.width  = tab_1.tabpage_8.width  - tab_1.tabpage_8.x - 10
idw_cos_com.height = tab_1.tabpage_8.height  - tab_1.tabpage_8.y - 10

idw_riego.width  = tab_1.tabpage_9.width  - tab_1.tabpage_9.x - 10
idw_riego.height = tab_1.tabpage_9.height  - tab_1.tabpage_9.y - 10

idw_pre_abono.width  = tab_1.tabpage_10.width  - tab_1.tabpage_10.x - 10
idw_pre_abono.height = tab_1.tabpage_10.height  - tab_1.tabpage_10.y - 10

idw_inv.width  = tab_1.tabpage_11.width  - tab_1.tabpage_11.x - 10
idw_inv.height = tab_1.tabpage_11.height  - tab_1.tabpage_11.y - 10

idw_capacitacion.width  = tab_1.tabpage_12.width  - tab_1.tabpage_12.x - 10
idw_capacitacion.height = tab_1.tabpage_12.height  - tab_1.tabpage_12.y - 10

idw_cost_mant.width  = tab_1.tabpage_13.width  - tab_1.tabpage_13.x - 10
idw_cost_mant.height = tab_1.tabpage_13.height  - tab_1.tabpage_13.y - 10

idw_ventas.width  = tab_1.tabpage_14.width  - tab_1.tabpage_14.x - 10
idw_ventas.height = tab_1.tabpage_14.height  - tab_1.tabpage_14.y - 10

idw_siembra.width  = tab_1.tabpage_15.width  - tab_1.tabpage_15.x - 10
idw_siembra.height = tab_1.tabpage_15.height  - tab_1.tabpage_15.y - 10

idw_prep_terr.width  = tab_1.tabpage_16.width  - tab_1.tabpage_16.x - 10
idw_prep_terr.height = tab_1.tabpage_16.height  - tab_1.tabpage_16.y - 10

idw_fert_l.width  = tab_1.tabpage_17.width  - tab_1.tabpage_17.x - 10
idw_fert_l.height = tab_1.tabpage_17.height  - tab_1.tabpage_17.y - 10

idw_fert_d.width  = tab_1.tabpage_18.width  - tab_1.tabpage_18.x - 10
idw_fert_d.height = tab_1.tabpage_18.height  - tab_1.tabpage_18.y - 10

idw_fito_l.width  = tab_1.tabpage_19.width  - tab_1.tabpage_19.x - 10
idw_fito_l.height = tab_1.tabpage_19.height  - tab_1.tabpage_19.y - 10

idw_fito_d.width  = tab_1.tabpage_20.width  - tab_1.tabpage_20.x - 10
idw_fito_d.height = tab_1.tabpage_20.height  - tab_1.tabpage_20.y - 10
end event

on w_cam313_cuaderno_productor.create
int iCurrent
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_cam313_cuaderno_productor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event ue_update;//Override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
idw_detalle.AcceptText()
idw_cosecha.AcceptText()
idw_deshije.AcceptText()
idw_deshierbo.AcceptText()
idw_limp_matas.AcceptText()
idw_enfunde.AcceptText()
idw_prot_racimo.AcceptText()
idw_cos_com.AcceptText()
idw_riego.AcceptText()
idw_pre_abono.AcceptText()
idw_inv.AcceptText()
idw_capacitacion.AcceptText()
idw_cost_mant.AcceptText()
idw_ventas.AcceptText()
idw_siembra.AcceptText() 
idw_prep_terr.AcceptText()
idw_fert_l.AcceptText()
idw_fert_d.AcceptText()
idw_fito_l.AcceptText() 
idw_fito_d.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	idw_detalle.of_create_log()
	idw_cosecha.of_create_log()
	idw_deshije.of_create_log()
	idw_deshierbo.of_create_log()
	idw_limp_matas.of_create_log()
	idw_enfunde.of_create_log()
	idw_prot_racimo.of_create_log()
	idw_cos_com.of_create_log()
	idw_riego.of_create_log()
	idw_pre_abono.of_create_log()
	idw_inv.of_create_log()
	idw_capacitacion.of_create_log()
	idw_cost_mant.of_create_log()
	idw_ventas.of_create_log()
	idw_siembra.of_create_log() 
	idw_prep_terr.of_create_log()
	idw_fert_l.of_create_log()
	idw_fert_d.of_create_log()
	idw_fito_l.of_create_log() 
	idw_fito_d.of_create_log()

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
IF idw_cosecha.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_cosecha.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion registro de COSECHA", ls_msg, StopSign!)
	END IF
END IF

IF idw_deshije.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_deshije.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion registro de DESHIJE", ls_msg, StopSign!)
	END IF
END IF

IF idw_deshierbo.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_deshierbo.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Registro de Deshierbo", ls_msg, StopSign!)
	END IF
END IF
IF idw_limp_matas.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_limp_matas.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_limp_matas", ls_msg, StopSign!)
	END IF
END IF
IF idw_enfunde.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_enfunde.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_enfunde", ls_msg, StopSign!)
	END IF
END IF
IF idw_prot_racimo.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_prot_racimo.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_prot_racimo", ls_msg, StopSign!)
	END IF
END IF
IF idw_cos_com.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_cos_com.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_cos_com", ls_msg, StopSign!)
	END IF
END IF
IF idw_riego.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_riego.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_riego", ls_msg, StopSign!)
	END IF
END IF
IF idw_pre_abono.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_pre_abono.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_pre_abono", ls_msg, StopSign!)
	END IF
END IF
IF idw_inv.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_inv.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_inv", ls_msg, StopSign!)
	END IF
END IF
IF idw_capacitacion.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_capacitacion.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_capacitacion", ls_msg, StopSign!)
	END IF
END IF
IF idw_cost_mant.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_cost_mant.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_cost_mant", ls_msg, StopSign!)
	END IF
END IF
IF idw_ventas.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_ventas.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_ventas", ls_msg, StopSign!)
	END IF
END IF
IF idw_siembra.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_siembra.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_siembra", ls_msg, StopSign!)
	END IF
END IF
IF idw_prep_terr.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_prep_terr.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_prep_terr", ls_msg, StopSign!)
	END IF
END IF
IF idw_fert_l.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_fert_l.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_fert_l", ls_msg, StopSign!)
	END IF
END IF
IF idw_fert_d.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_fert_d.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_fert_d", ls_msg, StopSign!)
	END IF
END IF
IF idw_fito_l.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_fito_l.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_fito_l", ls_msg, StopSign!)
	END IF
END IF
IF idw_fito_d.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_fito_d.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_fito_d", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_detalle.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_cosecha.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_deshije.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_deshierbo.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_limp_matas.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_enfunde.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_prot_racimo.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_riego.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_pre_abono.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_inv.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_capacitacion.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_cost_mant.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_ventas.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_siembra.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_prep_terr.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_fert_l.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_fert_d.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_fito_l.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_fito_d.of_save_log()
	END IF

END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detalle.ii_update = 0
	idw_cosecha.ii_update = 0
	idw_deshije.ii_update = 0
	idw_deshierbo.ii_update = 0
	idw_limp_matas.ii_update = 0
	idw_enfunde.ii_update = 0
	idw_prot_racimo.ii_update = 0
	idw_cos_com.ii_update = 0
	idw_riego.ii_update = 0
	idw_pre_abono.ii_update = 0
	idw_inv.ii_update = 0
	idw_capacitacion.ii_update = 0
	idw_cost_mant.ii_update = 0
	idw_ventas.ii_update = 0
	idw_siembra.ii_update = 0
	idw_prep_terr.ii_update = 0
	idw_fert_l.ii_update = 0
	idw_fert_d.ii_update = 0
	idw_fito_l.ii_update = 0
	idw_fito_d.ii_update = 0
	
	dw_master.il_totdel = 0
	idw_detalle.il_totdel = 0
	idw_cosecha.il_totdel = 0
	idw_deshije.il_totdel = 0
	idw_deshierbo.il_totdel = 0
	idw_limp_matas.il_totdel = 0
	idw_enfunde.il_totdel = 0
	idw_prot_racimo.il_totdel = 0
	idw_cos_com.il_totdel = 0
	idw_riego.il_totdel = 0
	idw_pre_abono.il_totdel = 0
	idw_inv.il_totdel = 0
	idw_capacitacion.il_totdel = 0
	idw_cost_mant.il_totdel = 0
	idw_ventas.il_totdel = 0
	idw_siembra.il_totdel = 0
	idw_prep_terr.il_totdel = 0
	idw_fert_l.il_totdel = 0
	idw_fert_d.il_totdel = 0
	idw_fito_l.il_totdel = 0
	idw_fito_d.il_totdel = 0
	
	dw_master.ResetUpdate()
	idw_detalle.ResetUpdate()
	idw_cosecha.ResetUpdate()
	idw_deshije.ResetUpdate()
	idw_deshierbo.ResetUpdate()
	idw_limp_matas.ResetUpdate()
	idw_enfunde.ResetUpdate()
	idw_prot_racimo.ResetUpdate()
	idw_cos_com.ResetUpdate()
	idw_riego.ResetUpdate()
	idw_pre_abono.ResetUpdate()
	idw_inv.ResetUpdate()
	idw_capacitacion.ResetUpdate()
	idw_cost_mant.ResetUpdate()
	idw_ventas.ResetUpdate()
	idw_siembra.ResetUpdate()
	idw_prep_terr.ResetUpdate()
	idw_fert_l.ResetUpdate()
	idw_fert_d.ResetUpdate()
	idw_fito_l.ResetUpdate()
	idw_fito_d.ResetUpdate()

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

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_cosecha, idw_cosecha.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_deshije, idw_deshije.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_deshierbo, idw_deshierbo.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_limp_matas, idw_limp_matas.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_enfunde, idw_enfunde.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_prot_racimo, idw_prot_racimo.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_cos_com, idw_cos_com.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_riego, idw_riego.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_pre_abono, idw_pre_abono.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_inv, idw_inv.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_capacitacion, idw_capacitacion.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_cost_mant, idw_cost_mant.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_ventas, idw_ventas.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_siembra, idw_siembra.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_prep_terr, idw_prep_terr.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_fert_l, idw_fert_l.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_fert_d, idw_fert_d.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_fito_l, idw_fito_l.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_fito_d, idw_fito_d.is_dwform) <> true then	return

//AutoNumeración de Registro
if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
idw_detalle.of_set_flag_replicacion()
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_cuad_prod_tbl'
sl_param.titulo = 'Cuaderno del Productor'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_insert;//Override
Long  ll_row

if idw_1 = idw_cos_com then
	MessageBox('Error', 'No esta permitido insertar registros en este panel.')
	return
end if

if idw_1 <> dw_master then
	if dw_master.getRow() = 0 then
		MessageBox('Error', 'No esta permitido insertar un detalle de Cuaderno del productor sin antes haber insertado la cabecera, por favor verifique')
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

event ue_modify;call super::ue_modify;idw_detalle.of_protect()
idw_cosecha.of_protect()
idw_deshije.of_protect()
idw_deshierbo.of_protect()
idw_limp_matas.of_protect()
idw_enfunde.of_protect()
idw_prot_racimo.of_protect()
idw_cos_com.of_protect()
idw_riego.of_protect()
idw_pre_abono.of_protect()
idw_inv.of_protect()
idw_capacitacion.of_protect()
idw_cost_mant.of_protect()
idw_ventas.of_protect()
idw_siembra.of_protect()
idw_prep_terr.of_protect()
idw_fert_l.of_protect()
idw_fert_d.of_protect()
idw_fito_l.of_protect()
idw_fito_d.of_protect()
end event

type dw_master from w_abc_master`dw_master within w_cam313_cuaderno_productor
integer width = 3150
integer height = 1008
string dataobject = "d_abc_sic_cuad_prod_cab"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dateTime ldt_fec_oracle

ldt_fec_oracle = f_fecha_actual()

this.object.fec_registro 		[al_row] = ldt_fec_oracle
this.object.fec_inicio 			[al_row] = Date(ldt_fec_oracle)
this.object.ano 					[al_row] = Year(Date(ldt_fec_oracle))
this.object.area_descanso	[al_row] = 0

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

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
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
			of_retrieve_productor(dw_master, ls_codigo, al_row)
			this.ii_update = 1
		end if

case "nro_certificacion_gg"
		ls_sql = "SELECT a.nro_certificacion AS certificacion_productor, " &
				+ " a.has as area_has, " &
				+ " p.nro_doc_ident AS nro_doc_ident, " &
				+ " p.nom_proveedor AS nombre_productor " &
				+ " FROM AP_PROVEEDOR_CERTIF a, " &
				+ "		ap_proveedor_mp mp, " &
    				+ "      proveedor p " &
				+ " WHERE a.proveedor = p.proveedor " &
				+ " and a.proveedor = mp.proveedor " &
				+ " and p.FLAG_ESTADO = '1' " &
				+ " and a.flag_estado = '1' " &
				+ " and mp.flag_estado = '1' " &
				+ " and mp.proveedor = (select apc.proveedor from ap_proveedor_certif apc where apc.nro_certificacion = '" + this.object.nro_certificacion [al_row] + "')"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.nro_certificacion_gg	[al_row] = ls_codigo
			this.ii_update = 1
		end if
end choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1
decimal	ldc_has
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name

	case "nro_certificacion"


		SELECT a.nro_certificacion 
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
			this.object.productor			[row] = ls_null
			this.object.nom_proveedor		[row] = ls_null
			this.object.area_has				[row] = 0
			return 1
			
		end if
		
		of_retrieve_productor(dw_master, data, row)
		
END CHOOSE
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::clicked;call super::clicked;String	ls_docname, ls_named, ls_codpro
integer	li_Result
str_seleccionar lstr_seleccionar
n_cst_upload_file	lnvo_Master

if lower(dwo.name) = 'b_upload' or lower(dwo.name) = 'b_view'  then
	ls_codpro = this.object.nro_registro[dw_master.getRow()]
end if

choose case lower(dwo.name)
	case 'b_upload'
		li_result = GetFileOpenName("Seleccione Archivo", &
						ls_docname, ls_named, "JPG", &
						"Archivos GIF (*.GIF),*.GIF,Archivos BMP (*.BMP),*.BMP,Archivos JPG (*.JPG),*.JPG")
	
		if li_result = 1 then
				
				if ls_codpro = "" or IsNull(ls_codpro) then
					MessageBox('Error', 'El Nro de Registro está en Blanco, '&
											+ 'asegurese de grabar los datos antes de asignar la foto')
					return
				end if

				lnvo_Master = create n_cst_upload_file
				lnvo_Master.of_grabar_foto( ls_docname, ls_codpro,'',date('01/01/2012') ,'3')
				destroy lnvo_Master
		end if
		this.retrieve(ls_codpro)
	case 'b_view'
			lstr_seleccionar.s_column = ls_codpro
			lstr_seleccionar.s_sql       = ''
			lstr_seleccionar.s_seleccion = '3'
			OpenWithParm(w_documento, lstr_seleccionar)

END CHOOSE

end event

type tab_1 from tab within w_cam313_cuaderno_productor
integer y = 1016
integer width = 3232
integer height = 1968
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean perpendiculartext = true
tabposition tabposition = tabsonright!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
tabpage_9 tabpage_9
tabpage_10 tabpage_10
tabpage_11 tabpage_11
tabpage_12 tabpage_12
tabpage_13 tabpage_13
tabpage_14 tabpage_14
tabpage_15 tabpage_15
tabpage_16 tabpage_16
tabpage_17 tabpage_17
tabpage_18 tabpage_18
tabpage_19 tabpage_19
tabpage_20 tabpage_20
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.tabpage_8=create tabpage_8
this.tabpage_9=create tabpage_9
this.tabpage_10=create tabpage_10
this.tabpage_11=create tabpage_11
this.tabpage_12=create tabpage_12
this.tabpage_13=create tabpage_13
this.tabpage_14=create tabpage_14
this.tabpage_15=create tabpage_15
this.tabpage_16=create tabpage_16
this.tabpage_17=create tabpage_17
this.tabpage_18=create tabpage_18
this.tabpage_19=create tabpage_19
this.tabpage_20=create tabpage_20
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_7,&
this.tabpage_8,&
this.tabpage_9,&
this.tabpage_10,&
this.tabpage_11,&
this.tabpage_12,&
this.tabpage_13,&
this.tabpage_14,&
this.tabpage_15,&
this.tabpage_16,&
this.tabpage_17,&
this.tabpage_18,&
this.tabpage_19,&
this.tabpage_20}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
destroy(this.tabpage_8)
destroy(this.tabpage_9)
destroy(this.tabpage_10)
destroy(this.tabpage_11)
destroy(this.tabpage_12)
destroy(this.tabpage_13)
destroy(this.tabpage_14)
destroy(this.tabpage_15)
destroy(this.tabpage_16)
destroy(this.tabpage_17)
destroy(this.tabpage_18)
destroy(this.tabpage_19)
destroy(this.tabpage_20)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Detalle"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detalle dw_detalle
end type

on tabpage_1.create
this.dw_detalle=create dw_detalle
this.Control[]={this.dw_detalle}
end on

on tabpage_1.destroy
destroy(this.dw_detalle)
end on

type dw_detalle from u_dw_abc within tabpage_1
integer width = 2153
integer height = 1360
integer taborder = 20
string dataobject = "d_abc_sic_cuad_prod_det"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.has 		[al_row] = 0.00
this.object.nro_item [al_row] = of_nro_item(this)
end event

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

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro Cosecha y ~r~nComercialización ~r~nMercado Interno"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_cosecha dw_cosecha
end type

on tabpage_2.create
this.dw_cosecha=create dw_cosecha
this.Control[]={this.dw_cosecha}
end on

on tabpage_2.destroy
destroy(this.dw_cosecha)
end on

type dw_cosecha from u_dw_abc within tabpage_2
integer width = 2162
integer height = 1224
string dataobject = "d_abc_sic_reg_cos_con_interno"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;Date 	ld_FechaActual, ld_FechaInicio 
Long 	ll_Semana 
String ls_desc_empresa, ls_ruc

ld_FechaActual = Date(f_fecha_actual())
ld_FechaInicio = Date('01/01/'+String(Year(ld_FechaActual))) 
ll_Semana = DaysAfter(ld_FechaInicio, ld_FechaActual) / 7 + 1


this.object.fec_registro 	[al_Row] = f_fecha_Actual()
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cod_usr			[al_row] = gs_user

this.object.costo_unit			[al_row] = 0
this.object.racimos_cos			[al_row] = 0
this.object.millares				[al_row] = 0
this.object.nro_jor_familiar	[al_row] = 0
this.object.nro_jor_contrat	[al_row] = 0
this.object.fecha					[al_row] = Date(f_fecha_actual())
this.object.Semana				[al_row] = ll_Semana

end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de DESHIERBO"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_deshierbo dw_deshierbo
end type

on tabpage_3.create
this.dw_deshierbo=create dw_deshierbo
this.Control[]={this.dw_deshierbo}
end on

on tabpage_3.destroy
destroy(this.dw_deshierbo)
end on

type dw_deshierbo from u_dw_abc within tabpage_3
integer width = 1664
integer height = 1108
integer taborder = 30
string dataobject = "d_abc_sic_reg_deshierbo"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;Date 	ld_FechaActual, ld_FechaInicio 
Long 	ll_Semana 
String ls_desc_empresa, ls_ruc

ld_FechaActual = Date(f_fecha_actual())
ld_FechaInicio = Date('01/01/'+String(Year(ld_FechaActual))) 
ll_Semana = DaysAfter(ld_FechaInicio, ld_FechaActual) / 7 + 1

this.object.fec_registro 	[al_Row] = f_fecha_Actual()
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cod_usr			[al_row] = gs_user

this.object.nro_jor_familiar	[al_row] = 0
this.object.nro_jor_contrat	[al_row] = 0
this.object.fecha					[al_row] = Date(f_fecha_actual())
this.object.Semana				[al_row] = ll_Semana

end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de DESHIJE"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_deshije dw_deshije
end type

on tabpage_4.create
this.dw_deshije=create dw_deshije
this.Control[]={this.dw_deshije}
end on

on tabpage_4.destroy
destroy(this.dw_deshije)
end on

type dw_deshije from u_dw_abc within tabpage_4
integer width = 1664
integer height = 1108
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_deshije"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;Date 	ld_FechaActual, ld_FechaInicio 
Long 	ll_Semana 
String ls_desc_empresa, ls_ruc

ld_FechaActual = Date(f_fecha_actual())
ld_FechaInicio = Date('01/01/'+String(Year(ld_FechaActual))) 
ll_Semana = DaysAfter(ld_FechaInicio, ld_FechaActual) / 7 + 1

this.object.fec_registro 	[al_Row] = f_fecha_Actual()
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cod_usr			[al_row] = gs_user

this.object.nro_jor_familiar	[al_row] = 0
this.object.nro_jor_contrat	[al_row] = 0
this.object.fecha					[al_row] = Date(f_fecha_actual())
this.object.Semana				[al_row] = ll_Semana

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de ~r~nLIMPIEZA DE MATAS"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_limp_matas dw_limp_matas
end type

on tabpage_5.create
this.dw_limp_matas=create dw_limp_matas
this.Control[]={this.dw_limp_matas}
end on

on tabpage_5.destroy
destroy(this.dw_limp_matas)
end on

type dw_limp_matas from u_dw_abc within tabpage_5
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_limpieza_matas"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;Date 	ld_FechaActual, ld_FechaInicio 
Long 	ll_Semana 
String ls_desc_empresa, ls_ruc

ld_FechaActual = Date(f_fecha_actual())
ld_FechaInicio = Date('01/01/'+String(Year(ld_FechaActual))) 
ll_Semana = DaysAfter(ld_FechaInicio, ld_FechaActual) / 7 + 1

this.object.fec_registro 	[al_Row] = f_fecha_Actual()
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cod_usr			[al_row] = gs_user

this.object.flag_deschante	[al_row] = '0'
this.object.flag_elim_rebrotes	[al_row] = '0'
this.object.flag_elim_sepas	[al_row] = '0'
this.object.flag_deshoje_fito	[al_row] = '0'
this.object.flag_deshoje_post	[al_row] = '0'

this.object.fecha					[al_row] = Date(f_fecha_actual())
this.object.Semana				[al_row] = ll_Semana

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de~r~nENFUNDE Y ENCINTE"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_enfunde dw_enfunde
end type

on tabpage_6.create
this.dw_enfunde=create dw_enfunde
this.Control[]={this.dw_enfunde}
end on

on tabpage_6.destroy
destroy(this.dw_enfunde)
end on

type dw_enfunde from u_dw_abc within tabpage_6
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_enf_encinte"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;Date 	ld_FechaActual, ld_FechaInicio 
Long 	ll_Semana 
String ls_desc_empresa, ls_ruc

ld_FechaActual = Date(f_fecha_actual())
ld_FechaInicio = Date('01/01/'+String(Year(ld_FechaActual))) 
ll_Semana = DaysAfter(ld_FechaInicio, ld_FechaActual) / 7 + 1

this.object.fec_registro 	[al_Row] = f_fecha_Actual()
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cod_usr			[al_row] = gs_user

this.object.nro_jor_familiar	[al_row] = 0
this.object.nro_jor_contrat	[al_row] = 0

this.object.rac_enf_dom	[al_row] = 0
this.object.rac_enf_lun	[al_row] = 0
this.object.rac_enf_mar	[al_row] = 0
this.object.rac_enf_mie	[al_row] = 0
this.object.rac_enf_jue	[al_row] = 0
this.object.rac_enf_vie	[al_row] = 0
this.object.rac_enf_sab	[al_row] = 0

this.object.Semana		[al_row] = ll_Semana

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de ~r~nPROTECCION DE RACIMO"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_prot_racimo dw_prot_racimo
end type

on tabpage_7.create
this.dw_prot_racimo=create dw_prot_racimo
this.Control[]={this.dw_prot_racimo}
end on

on tabpage_7.destroy
destroy(this.dw_prot_racimo)
end on

type dw_prot_racimo from u_dw_abc within tabpage_7
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_prot_racimo"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;Date 	ld_FechaActual, ld_FechaInicio 
Long 	ll_Semana 
String ls_desc_empresa, ls_ruc

ld_FechaActual = Date(f_fecha_actual())
ld_FechaInicio = Date('01/01/'+String(Year(ld_FechaActual))) 
ll_Semana = DaysAfter(ld_FechaInicio, ld_FechaActual) / 7 + 1

this.object.fec_registro 	[al_Row] = f_fecha_Actual()
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cod_usr			[al_row] = gs_user

this.object.nro_jor_familiar	[al_row] = 0
this.object.nro_jor_contrat	[al_row] = 0

this.object.daypado_dom	[al_row] = 0
this.object.daypado_lun	[al_row] = 0
this.object.daypado_mar	[al_row] = 0
this.object.daypado_mie	[al_row] = 0
this.object.daypado_jue	[al_row] = 0
this.object.daypado_vie	[al_row] = 0
this.object.daypado_sab	[al_row] = 0

this.object.Semana				[al_row] = ll_Semana

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_8 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de~r~nCOSECHA Y ~r~nCOMERCIALIZACION"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_cos_com dw_cos_com
end type

on tabpage_8.create
this.dw_cos_com=create dw_cos_com
this.Control[]={this.dw_cos_com}
end on

on tabpage_8.destroy
destroy(this.dw_cos_com)
end on

type dw_cos_com from u_dw_abc within tabpage_8
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_rpt_reg_cos_com_tbl"
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

ii_rk[1] = 1	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_9 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de ~r~nRIEGOS"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_riego dw_riego
end type

on tabpage_9.create
this.dw_riego=create dw_riego
this.Control[]={this.dw_riego}
end on

on tabpage_9.destroy
destroy(this.dw_riego)
end on

type dw_riego from u_dw_abc within tabpage_9
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_riegos"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;Date 	ld_FechaActual, ld_FechaInicio 
Long 	ll_Semana 
String ls_desc_empresa, ls_ruc

ld_FechaActual = Date(f_fecha_actual())
ld_FechaInicio = Date('01/01/'+String(Year(ld_FechaActual))) 
ll_Semana = DaysAfter(ld_FechaInicio, ld_FechaActual) / 7 + 1

this.object.fec_registro 	[al_Row] = f_fecha_Actual()
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cod_usr			[al_row] = gs_user

this.object.nro_jor_familiar	[al_row] = 0
this.object.nro_jor_contrat	[al_row] = 0
this.object.volumen_aplicado	[al_row] = 0
this.object.horas_riego	[al_row] = 0
this.object.costo_agua	[al_row] = 0
this.object.costo_jornal	[al_row] = 0
this.object.fecha					[al_row] = Date(f_fecha_actual())

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_10 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de ~r~nPREPARACION DE ABONO"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_pre_abono dw_pre_abono
end type

on tabpage_10.create
this.dw_pre_abono=create dw_pre_abono
this.Control[]={this.dw_pre_abono}
end on

on tabpage_10.destroy
destroy(this.dw_pre_abono)
end on

type dw_pre_abono from u_dw_abc within tabpage_10
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_prep_abono"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro 	[al_Row] = f_fecha_Actual()
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cod_usr			[al_row] = gs_user

this.object.jornales				[al_row] = 0
this.object.cantidad				[al_row] = 0
this.object.fecha_elaboracion	[al_row] = Date(f_fecha_actual())
this.object.fecha_volteo_01			[al_row] = Date(f_fecha_actual())
this.object.fecha_volteo_02			[al_row] = Date(f_fecha_actual())
this.object.fecha_volteo_03			[al_row] = Date(f_fecha_actual())
this.object.fecha_volteo_04			[al_row] = Date(f_fecha_actual())
this.object.fecha_volteo_05			[al_row] = Date(f_fecha_actual())
this.object.fecha_volteo_06			[al_row] = Date(f_fecha_actual())
this.object.fecha_volteo_07			[al_row] = Date(f_fecha_actual())
this.object.fecha_volteo_08			[al_row] = Date(f_fecha_actual())
this.object.fecha_volteo_09			[al_row] = Date(f_fecha_actual())
this.object.fecha_volteo_10			[al_row] = Date(f_fecha_actual())

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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
string 	ls_codigo, ls_data, ls_data2, ls_data3, ls_sql, ls_ot_adm, &
			ls_nro_ot, ls_labor, ls_null
SetNull(ls_null)			

choose case lower(as_columna)
	case "und"
		ls_sql = "SELECT a.und AS codigo_unidad, " &
				 + "a.desc_unidad as desc_unidad, " &
				 + "a.tipo_und AS tipo_und, " &
				 + "a.flag_estado AS flag_estado " &
				 + "FROM unidad a " &
				 + "WHERE a.flag_estado = '1'"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.und	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose
end event

type tabpage_11 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de~r~nINVENTARIO DE ADQ~r~nDE INSUMOS"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_inv dw_inv
end type

on tabpage_11.create
this.dw_inv=create dw_inv
this.Control[]={this.dw_inv}
end on

on tabpage_11.destroy
destroy(this.dw_inv)
end on

type dw_inv from u_dw_abc within tabpage_11
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_inventario"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro 	[al_Row] = f_fecha_Actual()
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cod_usr			[al_row] = gs_user

this.object.cantidad_comprada	[al_row] = 0
this.object.cantidad_aplicada	[al_row] = 0
this.object.costo_unit				[al_row] = 0
this.object.fecha_compra		[al_row] = Date(f_fecha_actual())
this.object.fecha_aplicacion		[al_row] = Date(f_fecha_actual())

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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
string 	ls_codigo, ls_data, ls_data2, ls_data3, ls_sql, ls_ot_adm, &
			ls_nro_ot, ls_labor, ls_null
SetNull(ls_null)			

choose case lower(as_columna)
	case "und"
		ls_sql = "SELECT a.und AS codigo_unidad, " &
				 + "a.desc_unidad as desc_unidad, " &
				 + "a.tipo_und AS tipo_und, " &
				 + "a.flag_estado AS flag_estado " &
				 + "FROM unidad a " &
				 + "WHERE a.flag_estado = '1'"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.und	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose
end event

type tabpage_12 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de ~r~nCAPACITACION Y VISITAS"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_capacitacion dw_capacitacion
end type

on tabpage_12.create
this.dw_capacitacion=create dw_capacitacion
this.Control[]={this.dw_capacitacion}
end on

on tabpage_12.destroy
destroy(this.dw_capacitacion)
end on

type dw_capacitacion from u_dw_abc within tabpage_12
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_capacitacion"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro 	[al_Row] = f_fecha_Actual()
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cod_usr			[al_row] = gs_user

this.object.fecha					[al_row] = Date(f_fecha_actual())

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_13 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de ~r~nCOSTOS DE ~r~nMANTENIMIENTO"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_cost_mant dw_cost_mant
end type

on tabpage_13.create
this.dw_cost_mant=create dw_cost_mant
this.Control[]={this.dw_cost_mant}
end on

on tabpage_13.destroy
destroy(this.dw_cost_mant)
end on

type dw_cost_mant from u_dw_abc within tabpage_13
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_costos_mant"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro 		[al_Row] = f_fecha_Actual()
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cod_usr			[al_row] = gs_user
this.object.flag_labor_insumo			[al_Row] = 'L'
this.object.nro_jor_familiar						[al_Row] = 0
this.object.nro_jor_contrat						[al_Row] = 0
this.object.costo_unit						[al_Row] = 0
this.object.costo_par_fam						[al_Row] = 0
this.object.costo_par_con						[al_Row] = 0
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_data2, ls_data3, ls_sql, ls_ot_adm, &
			ls_nro_ot, ls_labor, ls_null
SetNull(ls_null)			

choose case lower(as_columna)
	case "und"
		ls_sql = "SELECT a.und AS codigo_unidad, " &
				 + "a.desc_unidad as desc_unidad, " &
				 + "a.tipo_und AS tipo_und, " &
				 + "a.flag_estado AS flag_estado " &
				 + "FROM unidad a " &
				 + "WHERE a.flag_estado = '1'"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.und	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose
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

type tabpage_14 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de VENTAS"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_ventas dw_ventas
end type

on tabpage_14.create
this.dw_ventas=create dw_ventas
this.Control[]={this.dw_ventas}
end on

on tabpage_14.destroy
destroy(this.dw_ventas)
end on

type dw_ventas from u_dw_abc within tabpage_14
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_ventas"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;Date 	ld_FechaActual, ld_FechaInicio 
Long 	ll_Semana 

ld_FechaActual = Date(f_fecha_actual())
ld_FechaInicio = Date('01/01/'+String(Year(ld_FechaActual))) 
ll_Semana = DaysAfter(ld_FechaInicio, ld_FechaActual) / 7 + 1

this.object.fec_registro 	[al_Row] = f_fecha_Actual()
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cod_usr			[al_row] = gs_user
this.object.fecha					[al_row] = Date(f_fecha_actual())
this.object.Semana				[al_row] = ll_Semana

this.object.nro_cajas			[al_row] = 0
this.object.precio_caja			[al_row] = 0
this.object.venta_export				[al_row] = 0
this.object.nro_millares	[al_row] = 0
this.object.precio_millar	[al_row] = 0
this.object.venta_mcdo	[al_row] = 0

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_15 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de SIEMBRA"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_siembra dw_siembra
end type

on tabpage_15.create
this.dw_siembra=create dw_siembra
this.Control[]={this.dw_siembra}
end on

on tabpage_15.destroy
destroy(this.dw_siembra)
end on

type dw_siembra from u_dw_abc within tabpage_15
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_siembra"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro 	[al_Row] = f_fecha_Actual()
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cod_usr			[al_row] = gs_user
this.object.fecha					[al_row] = Date(f_fecha_actual())

this.object.nro_plantas			[al_row] = 0
this.object.nro_jor_familiar			[al_row] = 0
this.object.nro_jor_contrat				[al_row] = 0
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_16 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de ~r~nPREPARACION DE TERRENO"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_prep_terr dw_prep_terr
end type

on tabpage_16.create
this.dw_prep_terr=create dw_prep_terr
this.Control[]={this.dw_prep_terr}
end on

on tabpage_16.destroy
destroy(this.dw_prep_terr)
end on

type dw_prep_terr from u_dw_abc within tabpage_16
integer width = 1664
integer height = 1108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_prep_terreno"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro 	[al_Row] = f_fecha_Actual()
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.cod_usr			[al_row] = gs_user
this.object.fecha					[al_row] = Date(f_fecha_actual())

this.object.costo_x_labor				[al_row] = 0
this.object.costo_x_jornal			[al_row] = 0
this.object.energia_empleada		[al_row] = 0
this.object.nro_jor_familiar			[al_row] = 0
this.object.nro_jor_contrat			[al_row] = 0
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_17 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de ~r~nFERTILIZACION Y ~r~nABONAMIENTO [Ley]"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_fert_l dw_fert_l
end type

on tabpage_17.create
this.dw_fert_l=create dw_fert_l
this.Control[]={this.dw_fert_l}
end on

on tabpage_17.destroy
destroy(this.dw_fert_l)
end on

type dw_fert_l from u_dw_abc within tabpage_17
integer width = 1664
integer height = 1108
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_fertilizantes_ley"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event clicked;call super::clicked;Integer 		li_i, li_row, li_j
u_ds_base 	ds_imp

if dwo.name = 'b_imp' then
			
		ds_imp = create u_ds_base
		ds_imp.DataObject = 'd_abc_ley_fertilizacion'
		ds_imp.SetTransObject(SQLCA)
		ds_imp.Retrieve()
		
		for li_i=1 to ds_imp.RowCount()
				li_row = this.event ue_insert()
				if li_row > 0 then
					this.object.nro_item					[li_row] = of_nro_item(this)
					this.object.fertilizante					[li_row] = ds_imp.object.fertilizante [li_i]
					this.object.und							[li_row] = ds_imp.object.und [li_i]
					this.object.cantidad					[li_row] = ds_imp.object.cantidad [li_i]
					this.object.nitro		 					[li_row] = ds_imp.object.nitro [li_i]
					this.object.fosfo	 					[li_row] = ds_imp.object.fosfo [li_i]
					this.object.pota							[li_row] = ds_imp.object.pota [li_i]
					this.object.calc		 					[li_row] = ds_imp.object.calc [li_i]
					this.object.magn	 					[li_row] = ds_imp.object.magn [li_i]
					this.object.azuf		 					[li_row] = ds_imp.object.azuf [li_i]
				end if
		next
		destroy ds_imp
end if
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item			[al_Row] = of_nro_item(this)
end event

type tabpage_18 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de ~r~nFERTILIZACION Y ~r~nABONAMIENTO [Detalle]"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_fert_d dw_fert_d
end type

on tabpage_18.create
this.dw_fert_d=create dw_fert_d
this.Control[]={this.dw_fert_d}
end on

on tabpage_18.destroy
destroy(this.dw_fert_d)
end on

type dw_fert_d from u_dw_abc within tabpage_18
integer width = 1664
integer height = 1108
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_fertilizantes_det"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.fec_aplicacion 	[al_Row] = Date(f_fecha_actual())
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.fec_compra		[al_row] = Date(f_fecha_actual())

this.object.area					[al_row] = 0
this.object.gr_plantas			[al_row] = 0
this.object.kg_hra				[al_row] = 0
this.object.nro_jornal			[al_row] = 0
this.object.sulf_potasio		[al_row] = 0
this.object.sulpomas			[al_row] = 0
this.object.guano				[al_row] = 0
this.object.humus				[al_row] = 0
this.object.kimel				[al_row] = 0
this.object.fertibio				[al_row] = 0
this.object.otros				[al_row] = 0
end event

type tabpage_19 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de~r~nFITOSANITARIO [Ley]"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_fito_l dw_fito_l
end type

on tabpage_19.create
this.dw_fito_l=create dw_fito_l
this.Control[]={this.dw_fito_l}
end on

on tabpage_19.destroy
destroy(this.dw_fito_l)
end on

type dw_fito_l from u_dw_abc within tabpage_19
integer width = 1664
integer height = 1108
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_fitosanitario_ley"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item			[al_Row] = of_nro_item(this)
end event

event clicked;call super::clicked;Integer 		li_i, li_row, li_j
u_ds_base 	ds_imp

if dwo.name = 'b_imp' then
			
		ds_imp = create u_ds_base
		ds_imp.DataObject = 'd_Abc_ley_fitosanitario'
		ds_imp.SetTransObject(SQLCA)
		ds_imp.Retrieve()
		
		for li_i=1 to ds_imp.RowCount()
				li_row = this.event ue_insert()
				if li_row > 0 then
					this.object.nro_item					[li_row] = of_nro_item(this)
					this.object.producto					[li_row] = ds_imp.object.producto [li_i]
					this.object.composicion				[li_row] = ds_imp.object.composicion [li_i]
					this.object.concentracion				[li_row] = ds_imp.object.concentracion [li_i]
					this.object.plazo						[li_row] = ds_imp.object.plazo [li_i]
					this.object.mochila						[li_row] = ds_imp.object.mochila [li_i]
					this.object.cilindro  					[li_row] = ds_imp.object.cilindro [li_i]
					this.object.plaga 						[li_row] = ds_imp.object.plaga [li_i]
					this.object.nombre_cientifico		[li_row] = ds_imp.object.nombre_cientifico [li_i]
				end if
		next
		destroy ds_imp
end if
end event

type tabpage_20 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2309
integer height = 1936
long backcolor = 79741120
string text = "Registro de~r~nFITOSANITARIO [Detalle]"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_fito_d dw_fito_d
end type

on tabpage_20.create
this.dw_fito_d=create dw_fito_d
this.Control[]={this.dw_fito_d}
end on

on tabpage_20.destroy
destroy(this.dw_fito_d)
end on

type dw_fito_d from u_dw_abc within tabpage_20
integer width = 1664
integer height = 1108
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_fitosanitario_tbl"
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
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.fec_aplicacion 	[al_Row] = Date(f_fecha_actual())
this.object.nro_item			[al_Row] = of_nro_item(this)
this.object.fec_compra		[al_row] = Date(f_fecha_actual())

this.object.area					[al_row] = 0
this.object.nro_jornal			[al_row] = 0
this.object.gorplus				[al_row] = 0
this.object.caldosulfo			[al_row] = 0
this.object.bc1000				[al_row] = 0
this.object.desfan100			[al_row] = 0
this.object.otros				[al_row] = 0
this.object.caldosobrante		[al_row] = 0
end event

