$PBExportHeader$w_pt004_presupuesto_plantilla.srw
forward
global type w_pt004_presupuesto_plantilla from w_abc_mastdet
end type
type st_1 from statictext within w_pt004_presupuesto_plantilla
end type
type sle_1 from singlelineedit within w_pt004_presupuesto_plantilla
end type
type cb_1 from commandbutton within w_pt004_presupuesto_plantilla
end type
end forward

global type w_pt004_presupuesto_plantilla from w_abc_mastdet
integer width = 3630
integer height = 2392
string title = "Plantillas Presupuestales (PT004)"
string menuname = "m_mantenimiento_cl"
event ue_anular ( )
st_1 st_1
sle_1 sle_1
cb_1 cb_1
end type
global w_pt004_presupuesto_plantilla w_pt004_presupuesto_plantilla

type variables
decimal 	idc_prc_cmp_ref
end variables

forward prototypes
public subroutine of_retrieve (string as_nro)
end prototypes

public subroutine of_retrieve (string as_nro);this.event ue_update_request( )

dw_master.retrieve(as_nro)
dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()

dw_detail.retrieve(as_nro)
dw_detail.ii_update = 0
dw_detail.ii_protect = 0
dw_detail.of_protect()

end subroutine

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
// ii_help = 101

idw_1 = dw_master

select NVL(precio_cmp_ref, -1)
  into :idc_prc_cmp_ref
  from logparam
 where reckey = '1';
 
ib_log = TRUE 
end event

event ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then	
	return
end if	

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then	
	return
end if	
ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

on w_pt004_presupuesto_plantilla.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_1
this.Control[iCurrent+3]=this.cb_1
end on

on w_pt004_presupuesto_plantilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_1)
end on

event ue_list_open;call super::ue_list_open;// Abre ventana pop
this.event ue_update_request( )

str_parametros sl_param

sl_param.dw1 = "d_abc_presupuesto_plantilla"
sl_param.titulo = "Plantillas"
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then	
	// Se ubica la cabecera
	of_retrieve(sl_param.field_ret[1])
	is_action = 'open'	
END IF
end event

event ue_delete;//Ancestor Script
Long  	ll_row
string	ls_plantilla
Integer	li_count

if dw_master.GetRow() = 0 then return

ls_plantilla = dw_master.object.cod_plantilla[dw_master.GetRow()]

//Verifico si el codigo de la plantilla pertenece a una
//proyeccion de produccion o de ventas
select count(*)
	into :li_count
from presup_produccion_und
where cod_plantilla = :ls_plantilla
  and flag_Estado = '2';
  
if li_count > 0 then
	if MessageBox('Aviso', 'La Plantilla esta amarrada a una proyeccion de produccion ' &
			+ 'que ha sido procesada, desea continuar???¡', &
			Information!, YesNo!, 2) = 2 then return
end if

select count(*)
	into :li_count
from presup_ingresos_und
where cod_plantilla = :ls_plantilla
  and flag_Estado = '2';
  
if li_count > 0 then
	if MessageBox('Aviso', 'La Plantilla esta amarrada a una proyeccion de produccion ' &
			+ 'que ha sido procesada, desea continuar???¡', &
			Information!, YesNo!, 2) = 2 then return
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


is_action = 'del'
end event

event ue_modify;int 		li_protect, li_count
string	ls_plantilla

if dw_master.GetRow() = 0 then return

ls_plantilla = dw_master.object.cod_plantilla[dw_master.GetRow()]

//Verifico si el codigo de la plantilla pertenece a una
//proyeccion de produccion o de ventas
select count(*)
	into :li_count
from presup_produccion_und
where cod_plantilla = :ls_plantilla
  and flag_Estado = '2';
  
if li_count > 0 then
	if MessageBox('Aviso', 'La Plantilla esta amarrada a una proyeccion de produccion ' &
			+ 'que ha sido procesada, desea modificarla???¡', &
			Information!, YesNo!, 2) = 2 then return
end if

select count(*)
	into :li_count
from presup_ingresos_und
where cod_plantilla = :ls_plantilla
  and flag_Estado = '2';
  
if li_count > 0 then
	if MessageBox('Aviso', 'La Plantilla esta amarrada a una proyeccion de produccion ' &
			+ 'que ha sido procesada, desea modificarla???¡', &
			Information!, YesNo!, 2) = 2 then return
end if


li_protect = integer(dw_master.Object.cod_plantilla.Protect)

IF li_protect = 0 THEN
   dw_master.Object.cod_plantilla.Protect = 1
END IF

idw_1.of_protect( )

is_Action = 'edit'
end event

event ue_insert;// Ancestor Script has been Override
Long  	ll_row
string	ls_plantilla
Integer	li_count

choose case idw_1
	case dw_master
		this.event dynamic ue_update_request()
	case dw_detail

		if dw_master.GetRow() = 0 then return
		
		ls_plantilla = dw_master.object.cod_plantilla[dw_master.GetRow()]
		
		//Verifico si el codigo de la plantilla pertenece a una
		//proyeccion de produccion o de ventas
		select count(*)
			into :li_count
		from presup_produccion_und
		where cod_plantilla = :ls_plantilla
		  and flag_Estado = '2';
		  
		if li_count > 0 then
			if MessageBox('Aviso', 'La Plantilla esta amarrada a una proyeccion de produccion ' &
					+ 'que ha sido procesada, desea continuar???¡', &
					Information!, YesNo!, 2) = 2 then return
		end if
		
		select count(*)
			into :li_count
		from presup_ingresos_und
		where cod_plantilla = :ls_plantilla
		  and flag_Estado = '2';
		  
		if li_count > 0 then
			if MessageBox('Aviso', 'La Plantilla esta amarrada a una proyeccion de produccion ' &
					+ 'que ha sido procesada, desea continuar???¡', &
					Information!, YesNo!, 2) = 2 then return
		end if
		
		if ls_plantilla = '' or IsNull(ls_plantilla) then
			MessageBox('Aviso', 'no ha definido el código de la plantilla', StopSign!)
			return
		end if
		
end choose

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

event ue_print;call super::ue_print;str_parametros lstr_param

if dw_master.GetRow() = 0 then return

lstr_param.string1 = dw_master.object.cod_plantilla[dw_master.GetRow()]

OpenSheetWithParm(w_pt763_rpt_plant_presup, lstr_param, w_main, 0, Layered!)
end event

type dw_master from w_abc_mastdet`dw_master within w_pt004_presupuesto_plantilla
event ue_refresh_det ( )
integer x = 0
integer y = 132
integer width = 3109
integer height = 516
string dataobject = "d_abc_presupuesto_plantilla_ff_v2"
end type

event dw_master::ue_refresh_det();/*
   Evento creado para reemplazar al evento output sin argumento,
	esto para ser usado en la ventana w_pop             */

Long ll_row
ll_row = dw_master.getrow()
il_row = ll_row

THIS.EVENT ue_retrieve_det(ll_row)
if idw_det.RowCount() > 0 then
	idw_det.SetRow(1)
	f_select_current_row(idw_det)
end if

idw_det.ii_protect = 0
idw_det.of_protect()
idw_det.ii_update = 0



end event

event dw_master::constructor;call super::constructor;is_mastdet = 'md'
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

idw_det = dw_detail
ii_ss = 1
end event

event dw_master::itemerror;call super::itemerror;return (1)   // Fuerza a salir sin mostrar mensaje de error
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;is_action = 'new'  // Nuevo documento

this.object.cod_usr		[al_row] = gs_user
this.object.fec_registro[al_row] = f_fecha_actual()
this.object.flag_estado	[al_row] = '1'
this.object.ano			[al_row] = Year(Date(f_fecha_actual()))
end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2])
end event

event dw_master::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

il_row = row
end event

event dw_master::buttonclicked;call super::buttonclicked;string 			ls_plantilla
Long				ll_rows, ll_i, ll_row
u_ds_base 		lds_data
str_parametros 	sl_param

if dwo.name = 'b_cod_art' and this.Describe( "cod_art.Protect") <> '1' then
	OpenWithParm (w_pop_articulos, parent)
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' then
		this.object.cod_art		[row] = sl_param.field_ret[1]
		this.object.nom_articulo[row] = sl_param.field_ret[2]
		this.object.und			[row] = sl_param.field_ret[3]
	END IF
	
elseif dwo.name = 'b_importar' then
	
	if this.ii_update = 1 then
		MessageBox('Aviso', 'Debe grabar primero la cabecera antes de importar los datos')
		return
	end if
	
	OpenWithParm (w_get_plantilla, parent)
	if Not IsValid(Message.PowerObjectParm) or IsNull(Message.PowerObjectParm) then return
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' then
		ls_plantilla = sl_param.string1
		lds_data = CREATE u_ds_base
		lds_data.dataobject = 'd_abc_presupuesto_plantilla_det'
		lds_data.SetTransObject( SQLCA )
		ll_rows = lds_data.Retrieve(ls_plantilla)
		if ll_rows <= 0 then 
			MessageBox('Aviso', 'La plantilla no tiene detalles')
			return
		end if
		
		for ll_i = 1 to lds_data.RowCount( )
		
			ll_row = dw_detail.event ue_insert( )
			if ll_Row > 0 then
				dw_detail.object.cencos 					[ll_Row] = lds_data.object.cencos					[ll_i]
				dw_detail.object.desc_cencos				[ll_Row] = lds_data.object.desc_cencos				[ll_i]			
				dw_detail.object.cnta_prsp 				[ll_Row] = lds_data.object.cnta_prsp				[ll_i]
				dw_detail.object.desc_cnta_prsp			[ll_Row] = lds_data.object.desc_cnta_prsp			[ll_i]			
				dw_detail.object.cod_art 					[ll_Row] = lds_data.object.cod_art					[ll_i]
				dw_detail.object.desc_art					[ll_Row] = lds_data.object.desc_art					[ll_i]			
				dw_detail.object.servicio					[ll_Row] = lds_data.object.servicio					[ll_i]			
				dw_detail.object.desc_servicio			[ll_Row] = lds_data.object.desc_servicio			[ll_i]			
				dw_detail.object.flag_factor				[ll_Row] = lds_data.object.flag_factor				[ll_i]
				dw_detail.object.descripcion				[ll_Row] = lds_data.object.descripcion				[ll_i]
				dw_detail.object.tipo_trabajador			[ll_Row] = lds_data.object.tipo_trabajador		[ll_i]
				dw_detail.object.desc_tipo_trabajador	[ll_Row] = lds_data.object.desc_tipo_trabajador	[ll_i]
				dw_detail.object.cantidad 					[ll_Row] = Dec(lds_data.object.cantidad			[ll_i])
				dw_detail.object.importe	 				[ll_Row] = Dec(lds_data.object.importe				[ll_i])
				dw_detail.object.ratio						[ll_Row] = Dec(lds_data.object.ratio				[ll_i])
				dw_detail.object.centro_benef				[ll_row] = lds_data.object.centro_benef			[ll_i]
				dw_detail.object.tipo_prtda_prsp			[ll_row] = lds_data.object.tipo_prtda_prsp		[ll_i]
				dw_detail.object.desc_tipo_prsp			[ll_row] = lds_data.object.desc_tipo_prsp 		[ll_i]
				dw_detail.object.flag_tipo_compromiso	[ll_row] = lds_data.object.flag_tipo_compromiso	[ll_i]				
			end if
			
		next
		
		DESTROY lds_data
	END IF
END IF
end event

event dw_master::doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
String ls_name, ls_prot
str_parametros sl_param

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

// Ayuda de busqueda para articulos
if ls_name = 'cod_art' and ls_prot = '0' then
	OpenWithParm (w_pop_articulos, parent)
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' then
		this.object.cod_art[this.getrow()] = sl_param.field_ret[1]
		this.object.desc_art[this.getrow()] = sl_param.field_ret[2]
		this.object.und[this.getrow()] = sl_param.field_ret[3]
	END IF
end if
Send(Handle(this),256,9,Long(0,0))   // fuerza a dar enter
end event

event dw_master::itemchanged;call super::itemchanged;Long ll_count
String ls_desc, ls_und

IF dwo.name = "cod_art" then		
	Select count( cod_art) into :ll_count from articulo where cod_art = :data;	
	if ll_count = 0 then
		Messagebox( "Error", "Articulo no existe", Exclamation!)		
		this.object.cod_Art[row] = ""
		Return 1
	end if
	Select desc_art, und into :ls_desc, :ls_und 
	   from articulo where cod_art = :data;		
	this.object.nom_articulo[row] = ls_desc
	this.object.und[row] = ls_und
end if	

end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

type dw_detail from w_abc_mastdet`dw_detail within w_pt004_presupuesto_plantilla
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 656
integer width = 3429
integer height = 996
string dataobject = "d_abc_presupuesto_plantilla_det"
borderstyle borderstyle = styleraised!
end type

event dw_detail::ue_display(string as_columna, long al_row);// Abre ventana de ayuda 
String 	ls_name, ls_cod_art, ls_cnta_prsp, ls_sql, &
			ls_codigo, ls_data, ls_tipo_prtda, ls_desc
Decimal	ldc_ult_compra
Boolean  lb_ret
str_parametros sl_param 

choose case lower(as_columna)
		
	case "cencos"
		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
				  + "DESC_cencos AS DESCRIPCION_cencos " &
				  + "FROM centros_costo " &
				  + "WHERE flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if		
		
	case "cnta_prsp"
		ls_sql = "SELECT pc.cnta_prsp AS CODIGO_cntaprsp, " &
				  + "pc.DESCripcion AS DESCRIPCION_cntaprsp, " &
				  + "tp.tipo_prtda_prsp as tipo_cuenta, " &
				  + "tp.desc_tipo_prsp as descripcion_tipo_cuenta " &
				  + "FROM presupuesto_cuenta PC, " &
				  + "tipo_prtda_prsp_det tp " &
				  + "WHERE pc.tipo_cuenta = tp.tipo_prtda_prsp " &
				  + "and pc.flag_estado = '1'"
				 
		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_tipo_prtda, ls_desc, '2')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_cnta_prsp	[al_row] = ls_data
			this.object.tipo_prtda_prsp[al_row] = ls_tipo_prtda
			this.object.desc_tipo_prsp	[al_row] = ls_desc
			this.ii_update = 1
		end if
	
	case "tipo_prtda_prsp"
		ls_sql = "SELECT TIPO_PRTDA_PRSP AS tipo_partida, " &
				  + "DESC_TIPO_PRSP AS DESCRIPCION_tipo " &
				  + "FROM tipo_prtda_prsp_det " &
				  + "WHERE flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_prtda_prsp[al_row] = ls_codigo
			this.object.desc_tipo_prsp	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_art"
		OpenWithParm (w_pop_articulos, parent)
		sl_param = MESSAGE.POWEROBJECTPARM
		
		ls_cod_art = sl_param.field_ret[1]
		
		select NVL(Costo_ult_compra, 0)
			into :ldc_ult_compra
		from articulo
		where cod_art = :ls_cod_art;
		
		if ldc_ult_compra = idc_prc_cmp_ref then
			select USF_CMP_ULT_PREC_COTIZ(:ls_cod_art)
			  into :ldc_ult_compra
			  from dual;
			  
			if ldc_ult_compra <= 0 then
				MessageBox('Aviso', 'Articulo ' + ls_cod_art &
					+ ' no tiene precio de ultima compra y no ' &
					+ 'tiene cotizacion alguna, Por favor verifique')
				return
			end if
			
		end if

		IF sl_param.titulo <> 'n' then
			this.object.cod_art	[al_row] = sl_param.field_ret[1]
			this.object.desc_art	[al_row] = sl_param.field_ret[2]
			this.object.und		[al_row] = sl_param.field_ret[3]
			this.object.importe	[al_row] = ldc_ult_compra
			this.ii_update = 1
		END IF

	case "servicio"
		ls_cnta_prsp = this.object.cnta_prsp [al_row]
		
		ls_sql = "SELECT S.SERVICIO AS CODIGO_SERVICIO, " &
				  + "S.DESCripcion AS DESCRIPCION_SERVICIO " &
				  + "FROM SERVICIOS S, " &
				  + "ARTICULO_SUB_CATEG A2 " &
				  + "WHERE A2.COD_SUB_CAT = S.COD_SUB_CAT " &
				  + "AND ( A2.CNTA_PRSP_EGRESO = '" + ls_cnta_prsp + "' " &
				  + "OR A2.CNTA_PRSP_INGRESO = '" + ls_cnta_prsp + "') " &
				  + "AND S.flag_estado = '1' " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.servicio			[al_row] = ls_codigo
			this.object.desc_servicio	[al_row] = ls_data
			this.ii_update = 1
		end if		

	case "centro_benef"
		ls_sql = "SELECT centro_benef AS centro_beneficio, " &
				  + "desc_centro AS descripcion_centro " &
				  + "FROM centro_beneficio " &
				  + "WHERE flag_estado = '1' " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.centro_benef	[al_row] = ls_codigo
			this.object.desc_centro		[al_row] = ls_data
			this.ii_update = 1
		end if		
	
	case 'tipo_trabajador'
		ls_sql = "SELECT tipo_trabajador AS codigo_tipo, " &
				  + "DESC_TIPO_TRA AS descripcion_tipo " &
				  + "FROM tipo_trabajador " &
				  + "WHERE flag_estado = '1' " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_trabajador		[al_row] = ls_codigo
			this.object.desc_tipo_trabajador	[al_row] = ls_data
			this.ii_update = 1
		end if		
		
end choose

Send(Handle(this),256,9,Long(0,0))   // fuerza a dar enter
end event

event dw_detail::constructor;call super::constructor;is_mastdet = 'm'	

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

ii_rk[1] = 1 	      // columnas que se pasan al detalle
ii_rk[2] = 2

is_dwform = 'tabular'	
idw_mst  = 	dw_master
idw_det  =  dw_detail
end event

event dw_detail::itemerror;call super::itemerror;return (1)
end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_desc, ls_und, ls_estado, ls_null, ls_tipo_prtda, ls_desc2
decimal	ldc_ult_compra

SetNull( ls_null)
this.Accepttext( )

// Verifica si existe
if dwo.name = "cencos" then	
	Select desc_cencos, flag_estado 
		into :ls_desc, :ls_estado 
	from centros_costo 
	where cencos = :data
	  and flag_estado = '1';		
	  
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Centro de costo no existe o no se encuentra activo", Exclamation!)		
		this.object.cencos		[row] = ls_null
		this.object.desc_cencos	[row] = ls_null
		Return 1
	end if
	
	this.object.desc_cencos[row] = ls_desc
	
elseIF dwo.name = "tipo_prtda_prsp" then		
	
	Select pc.descripcion, tp.tipo_prtda_prsp, 
			 tp.desc_tipo_prsp
		into :ls_desc, :ls_tipo_prtda, :ls_desc2
	from presupuesto_cuenta 	pc,
		  tipo_prtda_prsp_det	tp
	where pc.tipo_cuenta = tp.tipo_prtda_prsp
	  and pc.cnta_prsp = :data
	  and pc.flag_estado = '1';
	  
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Cuenta Presupuestal no existe o no esta activa", Exclamation!)		
		this.object.cnta_prsp		[row] = ls_null
		this.object.desc_cnta_prsp	[row] = ls_null
		Return 1
	end if
	this.object.desc_cnta_prsp	[row] = ls_desc
	this.object.tipo_prtda_prsp[row] = ls_tipo_prtda
	this.object.desc_tipo_prsp	[row] = ls_desc2


elseIF dwo.name = "cod_art" then		
	
	Select desc_art, und, NVL(COSTO_ULT_COMPRA, 0)
		into :ls_desc, :ls_und, :ldc_ult_compra
	from articulo 
	where cod_art = :data
	  and flag_estado = '1';

	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Articulo no existe o no esta activo", Exclamation!)		
		this.object.cod_Art	[row] = ls_null
		this.object.desc_art	[row] = ls_null
		this.object.und		[row] = ls_null
		this.object.importe	[row] = 0
		Return 1
	end if
	
	if ldc_ult_compra = idc_prc_cmp_ref then
		select USF_CMP_ULT_PREC_COTIZ(:data)
		  into :ldc_ult_compra
		  from dual;
		if ldc_ult_compra <= 0 then
			MessageBox('Aviso', 'Articulo ' + data + ' no tiene precio de ultima compra y no tiene cotizacion alguna, Por favor verifique')
			this.object.cod_Art	[row] = ls_null
			this.object.desc_art	[row] = ls_null
			this.object.und		[row] = ls_null
			this.object.importe	[row] = 0
			return 1
		end if
	end if

	this.object.desc_art	[row] = ls_desc
	this.object.und		[row] = ls_und
	this.object.importe	[row] = ldc_ult_compra

elseif dwo.name = "cnta_prsp" then	
	
	Select descripcion 
		into :ls_desc 
	from presupuesto_cuenta 
	where cnta_prsp = :data
	  and flag_estado = '1';
	  
	if sqlca.sqlcode = 100 then
		Messagebox( "Error", "Cuenta Presupuestal no existe o no esta activo", Exclamation!)		
		this.object.cnta_prsp		[row] = ls_null
		this.object.desc_cnta_prsp	[row] = ls_null
		Return 1	
	end if
	this.object.desc_cnta_prsp[row] = ls_desc
	
elseif dwo.name = "tipo_trabajador" then	
	
	Select desc_tipo_tra 
		into :ls_desc 
	from tipo_trabajador
	where tipo_trabajador = :data
	  and flag_estado = '1';
	  
	if sqlca.sqlcode = 100 then
		Messagebox( "Error", "Tipo de Trabajador no existe o no esta activo", Exclamation!)		
		this.object.tipo_trabajador		[row] = ls_null
		this.object.desc_tipo_trabajador	[row] = ls_null
		Return 1	
	end if
	this.object.desc_tipo_trabajador	[row] = ls_desc

elseif dwo.name = "centro_benef" then	
	
	Select desc_centro 
		into :ls_desc 
	from centro_beneficio
	where centro_benef = :data
	  and flag_estado = '1';
	  
	if sqlca.sqlcode = 100 then
		Messagebox( "Error", "Centro de beneficio no existe o no esta activo", Exclamation!)		
		this.object.centro_benef	[row] = ls_null
		this.object.desc_centro		[row] = ls_null
		Return 1	
	end if
	this.object.desc_centro	[row] = ls_desc

elseif dwo.name = 'cantidad' or dwo.name = 'importe' then
	if Dec(this.object.cantidad[row]) <> 0 and &
		Dec(this.object.importe	[row]) <> 0 then
		
		this.object.ratio [row] = Dec(this.object.cantidad[row]) * Dec(this.object.importe[row])
	else
		this.object.ratio[row] = 0
	end if
end if
end event

event dw_detail::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event dw_detail::ue_insert_pre;// Asigna numero de item
if al_row = 0 then return

if dw_master.GetRow() = 0 then return

Int j, li_mayor

li_mayor = 0
For j = 1 to this.rowcount()
	if this.object.item[j] > li_mayor then
		li_mayor = this.object.item[j]
	end if
Next
li_mayor = li_mayor + 1

this.object.item			[al_row] = li_mayor
this.object.cantidad		[al_row] = 0
this.object.importe		[al_row] = 0
this.object.ratio			[al_row] = 0
this.object.flag_factor [al_Row] = 'E'
this.object.cod_plantilla[al_row] = dw_master.object.cod_plantilla [dw_master.GetRow()]

this.SetColumn( "cencos")
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF

end event

event dw_detail::keydwn;call super::keydwn;string 	ls_columna, ls_cadena
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

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

type st_1 from statictext within w_pt004_presupuesto_plantilla
integer x = 32
integer y = 32
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Plantilla"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_pt004_presupuesto_plantilla
integer x = 471
integer y = 8
integer width = 402
integer height = 96
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_pt004_presupuesto_plantilla
integer x = 914
integer y = 8
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;of_retrieve(sle_1.text)
end event

