$PBExportHeader$w_pt311_solicitud_variacion.srw
forward
global type w_pt311_solicitud_variacion from w_abc_mastdet_smpl
end type
type st_2 from statictext within w_pt311_solicitud_variacion
end type
type cb_1 from commandbutton within w_pt311_solicitud_variacion
end type
type sle_nro from singlelineedit within w_pt311_solicitud_variacion
end type
end forward

global type w_pt311_solicitud_variacion from w_abc_mastdet_smpl
integer width = 2158
integer height = 2100
string title = "Solicitud de Variaciones (PT311)"
string menuname = "m_mantenimiento_cl"
st_2 st_2
cb_1 cb_1
sle_nro sle_nro
end type
global w_pt311_solicitud_variacion w_pt311_solicitud_variacion

type variables
end variables

forward prototypes
public subroutine of_retrieve (string as_nro)
public function integer of_nro_item (datawindow adw_pr)
public subroutine of_modify1 ()
public function integer of_set_numera ()
public function integer of_evalua_ppto (integer ai_year, integer ai_mes, string as_cencos, string as_cnta_prsp, decimal adc_importe)
end prototypes

public subroutine of_retrieve (string as_nro);string 	ls_flag_tipo_sol

this.event ue_update_request( )

dw_master.retrieve( as_nro )

if dw_master.GetRow() > 0 then
	
	ls_flag_tipo_sol = dw_master.object.flag_tipo_sol[dw_master.GetRow()]
	if ls_flag_tipo_sol = 'P' then
		dw_detail.Dataobject = 'd_abc_solicitud_var_det'
	elseif ls_flag_tipo_sol = 'I' or ls_flag_tipo_sol = 'D' then
		dw_detail.Dataobject = 'd_abc_solicitud_prod_ingr_tbl'
	elseif ls_flag_tipo_sol = 'R' then
		dw_detail.Dataobject = 'd_abc_solicitud_prsp_plant_tbl'
	end if
	dw_detail.Settransobject( SQLCA )
	
	dw_detail.Retrieve( as_nro )
	
end if

dw_master.ii_update  = 0
dw_master.ii_protect = 0
dw_master.of_protect( )

dw_detail.ii_update  = 0
dw_detail.ii_protect = 0
dw_detail.of_protect( )

dw_master.il_row = dw_master.GetRow()

is_action = 'open'


end subroutine

public function integer of_nro_item (datawindow adw_pr);integer li_item, li_x

li_item = 0

For li_x = 1 to adw_pr.RowCount()
	IF li_item < adw_pr.object.nro_item[li_x] THEN
		li_item = adw_pr.object.nro_item[li_x]
	END IF
Next

Return li_item + 1
end function

public subroutine of_modify1 ();string ls_flag_tipo_sol

if dw_master.GetRow() = 0 then return

ls_flag_tipo_sol = dw_master.object.flag_tipo_sol[dw_master.GetRow()]

if ls_flag_tipo_sol = 'P' then

	dw_detail.Modify("ano_dst.Protect='1~tIf(flag_tipo_oper <> ~~'T~~',1,0)'")
	dw_detail.Modify("mes_dst.Protect='1~tIf(flag_tipo_oper <> ~~'T~~',1,0)'")
	dw_detail.Modify("cencos_dst.Protect='1~tIf(flag_tipo_oper <> ~~'T~~',1,0)'")
	dw_detail.Modify("cnta_prsp_dst.Protect='1~tIf(flag_tipo_oper <> ~~'T~~',1,0)'")
	
	dw_detail.Modify("ano_dst.Background.color ='1~tIf(flag_tipo_oper <> ~~'T~~', RGB(192,192,192),RGB(255,255,255))'")
	dw_detail.Modify("mes_dst.Background.color ='1~tIf(flag_tipo_oper <> ~~'T~~', RGB(192,192,192),RGB(255,255,255))'")
	dw_detail.Modify("cencos_dst.Background.color ='1~tIf(flag_tipo_oper <> ~~'T~~', RGB(192,192,192),RGB(255,255,255))'")
	dw_detail.Modify("cnta_prsp_dst.Background.color ='1~tIf(flag_tipo_oper <> ~~'T~~', RGB(192,192,192),RGB(255,255,255))'")
	
	dw_detail.Modify("mes_dst.ddlb.required='~~'Yes~~'~tIf(flag_tipo_oper = ~~'T~~',~~'Yes~~',~~'No~~')'")
	dw_detail.Modify("ano_dst.EditMask.required='~~'Yes~~'~tIf(flag_tipo_oper = ~~'T~~',~~'Yes~~',~~'No~~')'")
	dw_detail.Modify("cencos_dst.Edit.required='~~'Yes~~'~tIf(flag_tipo_oper = ~~'T~~',~~'Yes~~',~~'No~~')'")
	dw_detail.Modify("cnta_prsp_dst.Edit.required='~~'Yes~~'~tIf(flag_tipo_oper = ~~'T~~',~~'Yes~~',~~'No~~')'")

elseif ls_flag_tipo_sol = 'R' then

	dw_detail.Modify("cencos.Protect='1~tIf(flag_tipo_oper <> ~~'A~~',1,0)'")
	dw_detail.Modify("cnta_prsp.Protect='1~tIf(flag_tipo_oper <> ~~'A~~',1,0)'")
	dw_detail.Modify("tipo_prtda_prsp.Protect='1~tIf(flag_tipo_oper <> ~~'A~~',1,0)'")
	dw_detail.Modify("flag_factor.Protect='1~tIf(flag_tipo_oper <> ~~'A~~',1,0)'")
	dw_detail.Modify("item_ref.Protect='1~tIf(flag_tipo_oper = ~~'A~~',1,0)'")
	dw_detail.Modify("cod_art.Protect='1~tIf(flag_tipo_oper <> ~~'A~~',1,0)'")
	dw_detail.Modify("servicio.Protect='1~tIf(flag_tipo_oper <> ~~'A~~',1,0)'")

	dw_detail.Modify("cencos.Background.color ='1~tIf(flag_tipo_oper <> ~~'A~~', RGB(192,192,192),RGB(255,255,255))'")
	dw_detail.Modify("cnta_prsp.Background.color ='1~tIf(flag_tipo_oper <> ~~'A~~', RGB(192,192,192),RGB(255,255,255))'")
	dw_detail.Modify("tipo_prtda_prsp.Background.color ='1~tIf(flag_tipo_oper <> ~~'A~~', RGB(192,192,192),RGB(255,255,255))'")
	dw_detail.Modify("flag_factor.Background.color ='1~tIf(flag_tipo_oper <> ~~'A~~', RGB(192,192,192),RGB(255,255,255))'")
	dw_detail.Modify("item_ref.Background.color ='1~tIf(flag_tipo_oper = ~~'A~~', RGB(192,192,192),RGB(255,255,255))'")
	dw_detail.Modify("cod_art.Background.color ='1~tIf(flag_tipo_oper <> ~~'A~~', RGB(192,192,192),RGB(255,255,255))'")
	dw_detail.Modify("servicio.Background.color ='1~tIf(flag_tipo_oper <> ~~'A~~', RGB(192,192,192),RGB(255,255,255))'")

	dw_detail.Modify("cencos.ddlb.required='~~'Yes~~'~tIf(flag_tipo_oper = ~~'A~~',~~'Yes~~',~~'No~~')'")
	dw_detail.Modify("cnta_prsp.EditMask.required='~~'Yes~~'~tIf(flag_tipo_oper = ~~'A~~',~~'Yes~~',~~'No~~')'")
	dw_detail.Modify("tipo_prtda_prsp.Edit.required='~~'Yes~~'~tIf(flag_tipo_oper = ~~'A~~',~~'Yes~~',~~'No~~')'")
	dw_detail.Modify("flag_factor.Edit.required='~~'Yes~~'~tIf(flag_tipo_oper = ~~'A~~',~~'Yes~~',~~'No~~')'")
	dw_detail.Modify("item_ref.EditMask.required='~~'Yes~~'~tIf(flag_tipo_oper = ~~'M~~',~~'Yes~~',~~'No~~')'")
	dw_detail.Modify("cod_art.Edit.required='~~'Yes~~'~tIf(flag_tipo_oper = ~~'A~~',~~'Yes~~',~~'No~~')'")
	dw_detail.Modify("servicio.EditMask.required='~~'Yes~~'~tIf(flag_tipo_oper = ~~'A~~',~~'Yes~~',~~'No~~')'")

	
end if
end subroutine

public function integer of_set_numera ();// Numera documento
Long 		ll_long, ll_nro, ll_i
string	ls_mensaje, ls_nro, ls_table

if dw_master.GetRow() = 0 then return 0

if is_action = 'new' then
	ls_table = 'LOCK TABLE num_prsp_solicitud_var IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_nro 
	from num_prsp_solicitud_var
	where origen = :gs_origen;
	
	IF SQLCA.SQLCode = 100 then
		Insert into num_prsp_solicitud_var (origen, ult_nro)
			values( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		ll_nro = 1
	end if
	
	// Asigna numero a cabecera
	ls_nro = String(ll_nro)	
	ll_long = 10 - len( TRIM( gs_origen))
   ls_nro = TRIM(gs_origen) + f_llena_caracteres('0',Trim(ls_nro),ll_long) 		
	
	// Incrementa contador
	Update num_prsp_solicitud_var 
		set ult_nro = ult_nro + 1 
	 where origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if

	dw_master.object.nro_solicitud[dw_master.getrow()] = ls_nro
else
	ls_nro = dw_master.object.nro_solicitud[dw_master.getrow()] 
end if

for ll_i = 1 to dw_detail.RowCount()
	dw_detail.object.nro_solicitud[ll_i] = ls_nro
next

return 1
end function

public function integer of_evalua_ppto (integer ai_year, integer ai_mes, string as_cencos, string as_cnta_prsp, decimal adc_importe);string 	ls_mensaje
Decimal	ldc_prsp
		
//create or replace function USF_PTO_SALDO_ACTUAL(
//    an_mes        in cntbl_asiento.mes%type,
//    an_ano        in cntbl_asiento.ano%type,
//    as_cencos     in centros_costo.cencos%type,
//    as_cnta_prsp  in presupuesto_cuenta.cnta_prsp%TYPE
//)return number is

DECLARE 	USF_PTO_SALDO_ACTUAL PROCEDURE FOR
			USF_PTO_SALDO_ACTUAL(:ai_mes,
										:ai_year,
										:as_cencos,
										:as_cnta_prsp);

EXECUTE 	USF_PTO_SALDO_ACTUAL;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USF_PTO_SALDO_ACTUAL: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

FETCH USF_PTO_SALDO_ACTUAL INTO :ldc_prsp;

CLOSE USF_PTO_SALDO_ACTUAL;

if adc_importe > ldc_prsp then
	Messagebox( "Error", "Importe es mayor que el presupuesto, Verifique!" &
		+ "~r~nImporte: " + string(adc_importe) &
		+ "~r~nSaldo Prsp: " + string(ldc_prsp))
		
	dw_master.Accepttext()
	return 0 
end if

return 1
end function

on w_pt311_solicitud_variacion.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
this.st_2=create st_2
this.cb_1=create cb_1
this.sle_nro=create sle_nro
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_nro
end on

on w_pt311_solicitud_variacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.sle_nro)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0
ib_log = TRUE
end event

event ue_insert;//Ancestor Overriding
Long  	ll_row
String	ls_flag_tipo_sol

choose case idw_1
	case dw_master
		event ue_update_request()
		dw_master.reset()
		dw_detail.reset()
		dw_detail.ii_update = 0
		
	case dw_detail
		if dw_master.GetRow() = 0 then
			MessageBox('Aviso', 'No puede insertar un registro sin cabecera')
			return
		end if
		
		if dw_master.object.flag_estado [dw_master.GetRow()] <> '1' then
			MessageBox('AViso', 'No puede insertar un registro nuevo, la solicitud no esta activa')
			return
		end if
		
		ls_flag_tipo_sol = dw_master.object.flag_tipo_sol [dw_master.GetRow()]
		
		if IsNull(ls_flag_tipo_sol) then
			MessageBox('Error', 'Debe elegir un tipo de Solicitud antes de insertar un registro')
			return
		end if
		
end choose


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
Long ll_row
ib_update_check = False

ll_row = dw_master.GetRow()

if ll_row = 0 then return

if f_row_Processing( dw_master, "form") <> true then return
if f_row_Processing( dw_detail, "form") <> true then return

if of_set_numera() = 0 then return

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion( )

ib_update_check = true
end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_lista_prsp_sol_var_tbl"
sl_param.titulo = "Solicitudes de Variacion"
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then	
	// Se ubica la cabecera
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_modify;//Ancestor Overriding
if dw_master.GetRow() = 0 then return

if dw_master.object.flag_estado [dw_master.GetRow()] <> '1' then
	MessageBox('AViso', 'No puede insertar un registro nuevo, la solicitud no esta activa')
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()

	return
end if

dw_master.of_protect()
dw_detail.of_protect()

if dw_detail.RowCount() > 0 then
	dw_master.object.flag_tipo_sol.protect = 1
end if

if dw_detail.ii_protect = 0 then
	of_modify1( )
end if

end event

event ue_print;call super::ue_print;//Ancestor Overriding
string ls_flag_tipo_sol
str_parametros lstr_param
w_rpt_preview lw_1

if dw_master.GetRow() = 0 then return

ls_flag_tipo_sol = dw_master.object.flag_tipo_sol[dw_master.GetRow()]

if ls_flag_tipo_sol = 'P' then
	lstr_param.dw1		 = 'd_rpt_solicitud_var_prtda_prsp'
elseif ls_flag_tipo_sol = 'I' or ls_flag_tipo_sol = 'D' then
	lstr_param.dw1		 = 'd_rpt_solicitud_var_prod_ingr'
elseif ls_flag_tipo_sol = 'R' then
	lstr_param.dw1		 = 'd_rpt_solicitud_var_prsp_plant'
end if
lstr_param.string1 = dw_master.object.nro_solicitud[dw_master.GetRow()]
lstr_param.tipo	 = '1S'
lstr_param.titulo	 = 'Solicitud de Variacion ' + string(dw_master.object.nro_solicitud[dw_master.GetRow()])

OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered!)
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_pt311_solicitud_variacion
integer x = 0
integer y = 128
integer width = 1998
integer height = 808
string dataobject = "d_abc_sol_variacion_ff"
end type

event dw_master::itemchanged;call super::itemchanged;string 	ls_flag_tipo_sol, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "flag_tipo_sol"
		
		if dw_detail.Rowcount( ) > 0 then
			MessageBox('Error', 'No puede modificar este item porque tiene detalle')
			
			return 1
		end if
		
		ls_flag_tipo_sol = dw_master.object.flag_tipo_sol[dw_master.GetRow()]
		if ls_flag_tipo_sol = 'P' then
			dw_detail.Dataobject = 'd_abc_solicitud_var_det'
		elseif ls_flag_tipo_sol = 'I' or ls_flag_tipo_sol = 'D' then
			dw_detail.Dataobject = 'd_abc_solicitud_prod_ingr_tbl'
		elseif ls_flag_tipo_sol = 'R' then
			dw_detail.Dataobject = 'd_abc_solicitud_prsp_plant_tbl'
		end if
		dw_detail.Settransobject( SQLCA )
		
		IF ib_log THEN											
			
		END IF
		
		
end choose
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr 			[al_row] = gs_user
this.object.fec_registro 	[al_row] = f_fecha_actual()
this.object.flag_estado 	[al_row] = '1'
this.setColumn('flag_tipo_sol')
is_action = 'new'
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_pt311_solicitud_variacion
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 940
integer width = 1998
integer height = 816
string dataobject = "d_abc_solicitud_var_det"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_cencos, ls_flag_tipo_sol, &
			ls_und, ls_plantilla, ls_cod_art, ls_servicio, &
			ls_desc_art, ls_desc_servicio, ls_flag_tipo_oper, &
			ls_cnta_prsp, ls_tipo_prtda, ls_desc_tipo_prtda
Integer	li_year, li_nro_item
decimal	ldc_cantidad, ldc_precio, ldc_ult_compra
str_parametros sl_param

this.AcceptText()

if dw_master.GetRow() = 0 then return

ls_flag_tipo_sol = dw_master.object.flag_tipo_sol[dw_master.GetRow()]
ls_flag_tipo_oper = this.object.flag_tipo_oper[al_row]

if IsNull(ls_flag_tipo_oper) or ls_flag_tipo_oper = '' then
	MessageBox('Aviso', 'Debe especificar un tipo de Operación')
	return
end if

if IsNull(ls_flag_tipo_sol) or ls_flag_tipo_sol = '' then
	MessageBox('Aviso', 'Debe especificar un tipo de Solicitud de Variación')
	return
end if

choose case lower(as_columna)
	case "cod_plantilla"
		if ls_flag_tipo_sol = 'R' then
			ls_sql = "SELECT cod_plantilla AS CODIGO_plantilla, " &
					  + "descripcion as descripcion_plantilla, " &
					  + "cod_art as codigo_articulo, " &
					  + "to_char(ano) as año_plantilla " &
					  + "FROM presup_plant " &
					  + "where flag_estado <> '0' " 
	
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.cod_plantilla	[al_row] = ls_codigo
				this.object.desc_plantilla	[al_row] = ls_data
				this.ii_update = 1
			end if
		end if
	
	case "item_ref"
		if ls_flag_tipo_sol = 'R' then
			if ls_flag_tipo_oper = 'M' then
				ls_plantilla = this.object.cod_plantilla [al_row]
				if IsNull(ls_plantilla) or ls_plantilla = '' then
					MessageBox('Aviso', 'Debe indicar primeramente una Plantilla')
					return
				end if
				
				sl_param.dw1 = "d_lista_prsp_plantilla_det"
				sl_param.titulo = "Detalle de Plantilla presupuestal"
				sl_param.string1 = ls_plantilla
				sl_param.tipo	  = '1S'
				sl_param.field_ret_i[1] = 2  //item
				sl_param.field_ret_i[2]	= 3  // cencos
				sl_param.field_ret_i[3]	= 4  // cnta_prsp
				sl_param.field_ret_i[4]	= 5  // cod_art
				sl_param.field_ret_i[5]	= 6  // desc_art
				sl_param.field_ret_i[6]	= 7  // und
				sl_param.field_ret_i[7]	= 8  // ratio
				sl_param.field_ret_i[8]	= 9  // flag_factor
				sl_param.field_ret_i[9]	= 10 // cantidad
				sl_param.field_ret_i[10]= 11 // desc_cencos
				sl_param.field_ret_i[11]= 12 // desc_cnta_prsp
				sl_param.field_ret_i[12]= 14 // servicio
				sl_param.field_ret_i[13]= 15 // desc_servicio
				sl_param.field_ret_i[14]= 16 // importe
				sl_param.field_ret_i[15]= 17 // tipo_prtda_prsp
				sl_param.field_ret_i[16]= 18 // desc_tipo_prsp
				
				
				OpenWithParm( w_lista, sl_param)
				sl_param = MESSAGE.POWEROBJECTPARM
				if sl_param.titulo <> 'n' then	
					// Se ubica la cabecera
					this.object.item_ref			[al_row] = Long(sl_param.field_ret[1])
					this.object.flag_factor		[al_row] = sl_param.field_ret[8]
					this.object.cencos			[al_row] = sl_param.field_ret[2]
					this.object.desc_cencos		[al_row] = sl_param.field_ret[10]
					this.object.cnta_prsp		[al_row] = sl_param.field_ret[3]
					this.object.desc_cnta_prsp	[al_row] = sl_param.field_ret[11]
					this.object.cod_art			[al_row] = sl_param.field_ret[4]
					this.object.desc_art			[al_row] = sl_param.field_ret[5]
					this.object.und				[al_row] = sl_param.field_ret[6]
					this.object.servicio			[al_row] = sl_param.field_ret[12]
					this.object.desc_servicio	[al_row] = sl_param.field_ret[13]
					this.object.cantidad_old	[al_row] = Dec(sl_param.field_ret[9])
					this.object.precio_old		[al_row] = Dec(sl_param.field_ret[14])

					// si el tipo de partida es nula entonces lo saco de la 
					// cuenta presupuestal
					ls_tipo_prtda 			= sl_param.field_ret[15]
					ls_desc_tipo_prtda 	= sl_param.field_ret[16]
					ls_cnta_prsp			= sl_param.field_ret[3]
					
					if ls_tipo_prtda = '' or IsNull(ls_tipo_prtda) then
						select tp.tipo_prtda_prsp, tp.desc_tipo_prsp
						  into :ls_tipo_prtda, :ls_desc_tipo_prtda
						  from presupuesto_cuenta  pc,
								 tipo_prtda_prsp_det tp
						where pc.tipo_cuenta = tp.tipo_prtda_prsp
						  and pc.cnta_prsp	= :ls_cnta_prsp;
					end if
					
					this.object.tipo_prtda_prsp[al_row] = ls_tipo_prtda
					this.object.desc_tipo_prsp	[al_row] = ls_desc_tipo_prtda

					this.ii_update = 1

					is_action = 'open'	
				END IF		
				
				// En caso de las plantillas de ratios jalo las cantidades y los precios
				// antiguos
				ls_cod_art = sl_param.field_ret[4]
				if ls_cod_art <> '' and not isnull(ls_cod_art) then
					select nvl(costo_ult_compra, 0)
						into :ldc_ult_compra
					from articulo
					where cod_art = :ls_cod_art;
				else
					ldc_ult_compra = 0
				end if
				
				li_nro_item = integer(ls_codigo)
				
				select cantidad, importe
					into :ldc_cantidad, :ldc_precio
				from presup_plant_det
				where cod_plantilla = :ls_plantilla
				  and item = :li_nro_item;
				
				this.object.precio_new	[al_row] = ldc_ult_compra
				
			end if
			
		end if
		
	case "cencos" 
		if ls_flag_tipo_sol = 'D' or ls_flag_tipo_sol = 'I' then
			// Esto en el caso de que sea un solicitud de variacion
			// de la proyeccion de produccion o de ventas
			li_year = Integer(this.object.ano[al_row])
			if li_year = 0 or IsNull(li_year) then
				MessageBox('Aviso', 'Debe ingresar primero el año origen, Verifique!')
				return
			end if
	
			if ls_flag_tipo_sol = 'D' then
				ls_sql = "SELECT distinct cc.cencos AS CODIGO_cencos, " &
						  + "cc.desc_Cencos AS DESCRIPCION_cencos " &
						  + "FROM centros_costo cc, " &
						  + "presup_produccion_und pp " &
						  + "where pp.cencos = cc.cencos " &
						  + "and pp.ano = " + string(li_year) + " " &
						  + "and cc.flag_estado <> '0' " &
						  + "and pp.flag_estado = '2' "
			else					  
				ls_sql = "SELECT distinct cc.cencos AS CODIGO_cencos, " &
						  + "cc.desc_Cencos AS DESCRIPCION_cencos " &
						  + "FROM centros_costo cc, " &
						  + "presup_ingresos_und pp " &
						  + "where pp.cencos = cc.cencos " &
						  + "and pp.ano = " + string(li_year) + " " &
						  + "and cc.flag_estado <> '0' " &
						  + "and pp.flag_estado = '2' "

			end if
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
			if ls_codigo <> '' then
				this.object.cencos		[al_row] = ls_codigo
				this.object.desc_cencos	[al_row] = ls_data
				this.ii_update = 1
			end if

		elseif ls_flag_tipo_sol = 'R' and ls_flag_tipo_oper = 'A' then
			
			ls_sql = "SELECT distinct cc.cencos AS CODIGO_cencos, " &
					  + "cc.desc_Cencos AS DESCRIPCION_cencos " &
					  + "FROM centros_costo cc " &
					  + "where cc.flag_estado <> '0' " 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
			if ls_codigo <> '' then
				this.object.cencos		[al_row] = ls_codigo
				this.object.desc_cencos	[al_row] = ls_data
				this.ii_update = 1
			end if

			
		end if
		
	case 'cnta_prsp'
		if ls_flag_tipo_sol = 'R' and ls_flag_tipo_oper = 'A' then
			ls_cencos = this.object.cencos[al_row]
			if ls_cencos = '' or IsNull(ls_cencos) then
				MessageBox('Aviso', 'Debe ingresar primero un centro de costo, Verifique!')
				return
			end if
			
			ls_sql = "SELECT distinct pc.cnta_prsp AS CODIGO_cnta_prsp, " &
					  + "pc.descripcion AS DESCRIPCION_cnta_prsp, " &
					  + "tp.tipo_prtda_prsp as tipo_partida, " &
					  + "tp.desc_tipo_prtda as descripcion_tipo_partida " &
					  + "FROM presupuesto_cuenta pc, " &
					  + "tipo_prtda_prsp_det  tp " &
					  + "where tp.tipo_prtda_prsp = pc.tipo_cuenta " & 
					  + "and pc.flag_estado = '1' " 
						 
			lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_tipo_prtda, ls_desc_tipo_prtda, '1')
			
			if ls_codigo <> '' then
				this.object.cnta_prsp		[al_row] = ls_codigo
				this.object.desc_cnta_prsp	[al_row] = ls_data
				this.object.tipo_prtda_prsp[al_row] = ls_tipo_prtda
				this.object.desc_tipo_prtda[al_row] = ls_desc_tipo_prtda
				this.ii_update = 1
			end if
		end if
	
	case 'tipo_prtda_prsp'
		if ls_flag_tipo_sol = 'R' and ls_flag_tipo_oper = 'A' then
			
			ls_cencos = this.object.cencos[al_row]
			if ls_cencos = '' or IsNull(ls_cencos) then
				MessageBox('Aviso', 'Debe ingresar primero un centro de costo, Verifique!')
				return
			end if
			
			ls_cnta_prsp = this.object.cnta_prsp[al_row]
			if ls_cnta_prsp = '' or IsNull(ls_cnta_prsp) then
				MessageBox('Aviso', 'Debe ingresar primero una cuenta presupuestal, Verifique!')
				return
			end if
			
			ls_sql = "SELECT tipo_prtda_prsp AS tipo_partida_prsp, " &
					  + "DESC_TIPO_PRSP AS DESCRIPCION_tipo_prsp " &
					  + "FROM tipo_prtda_prsp_det " &
					  + "where flag_estado = '1' " 
						 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
			if ls_codigo <> '' then
				this.object.tipo_prtda_prsp	[al_row] = ls_codigo
				this.object.desc_tipo_prsp		[al_row] = ls_data
				this.ii_update = 1
			end if
		end if

	case 'servicio'
		if ls_flag_tipo_sol = 'R' and ls_flag_tipo_oper = 'A' then
			ls_cod_art = this.object.cod_art[al_row]
			
			if ls_cod_art <> '' and not IsNull(ls_cod_art) then
				MessageBox('Aviso', 'No puede colocar un servicio, porque ya ha indicado un articulo')
				return
			end if
				
			ls_plantilla = this.object.cod_plantilla[al_row]
			if ls_plantilla = '' or IsNull(ls_plantilla) then
				MessageBox('Aviso', 'Debe elegir un codigo de plantilla primero')
				return
			end if
			
			ls_sql = "SELECT distinct s.servicio AS CODIGO_servicio, " &
					  + "s.descripcion as descripcion_servicio " &
					  + "FROM servicios s " &
					  + "where s.flag_estado <> '0' "
				
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data,  '1')
			
			if ls_codigo <> '' then
				this.object.servicio			[al_row] = ls_codigo
				this.object.desc_servicio	[al_row] = ls_data
				this.ii_update = 1
			end if
			
		end if
	
	case "cod_art"
		
		if ls_flag_tipo_sol = 'D' or ls_flag_tipo_sol = 'I' then
			// Esto en el caso de que sea un solicitud de variacion
			// de la proyeccion de produccion o de ventas
			li_year = Integer(this.object.ano[al_row])
			if li_year = 0 or IsNull(li_year) then
				MessageBox('Aviso', 'Debe ingresar primero el año origen, Verifique!')
				return
			end if
			
			ls_cencos = this.object.cencos [al_row]
			if IsNull(ls_cencos) or ls_cencos = '' then
				MessageBox('Aviso', 'Debe indicar primeramente el centro de costo')
				return
			end if
	
			if ls_flag_tipo_sol = 'D' then
				ls_sql = "SELECT distinct a.cod_art AS CODIGO_articulo, " &
						  + "a.desc_art AS DESCRIPCION_articulo, " &
						  + "und as unidad_art " &
						  + "FROM articulo a, " &
						  + "presup_produccion_und pp " &
						  + "where pp.cod_art = a.cod_art " &
						  + "and pp.cencos = '" + ls_cencos + "' " &
						  + "and pp.ano = " + string(li_year) + " " &
						  + "and a.flag_estado <> '0' " &
						  + "and pp.flag_estado = '2' "
						  
			elseif ls_flag_tipo_sol = 'I' then
				
				ls_sql = "SELECT distinct a.cod_art AS CODIGO_articulo, " &
						  + "a.desc_art AS DESCRIPCION_articulo, " &
						  + "und as unidad_art " &
						  + "FROM articulo a, " &
						  + "presup_produccion_und pp " &
						  + "where pp.cod_art = a.cod_art " &
						  + "and pp.cencos = '" + ls_cencos + "' " &
						  + "and pp.ano = " + string(li_year) + " " &
						  + "and a.flag_estado <> '0' " &
						  + "and pp.flag_estado = '2' "
			end if
			
			lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_und,  '1')
			
			if ls_codigo <> '' then
				this.object.cod_art		[al_row] = ls_codigo
				this.object.desc_art		[al_row] = ls_data
				this.object.und			[al_row] = ls_und
				this.ii_update = 1
			end if
			
		elseif ls_flag_tipo_sol = 'R' and ls_flag_tipo_oper = 'A' then
			
			ls_servicio = this.object.servicio[al_row]
			
			if ls_servicio <> '' and not IsNull(ls_servicio) then
				MessageBox('Aviso', 'No puede colocar un articulo, porque ya ha indicado un servicio')
				return
			end if
			
			// En esta sección entran cuando sea un cambio en los ratios 
			ls_plantilla = this.object.cod_plantilla[al_row]
			if ls_plantilla = '' or IsNull(ls_plantilla) then
				MessageBox('Aviso', 'Debe elegir un codigo de plantilla primero')
				return
			end if
			
			ls_sql = "SELECT a.cod_art AS CODIGO_articulo, " &
					  + "a.desc_art AS DESCRIPCION_articulo, " &
					  + "und as unidad_art " &
					  + "FROM articulo a " &
					  + "where a.flag_estado <> '0' "

			lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_und,  '1')
			
			if ls_codigo <> '' then
				this.object.cod_art		[al_row] = ls_codigo
				this.object.desc_art		[al_row] = ls_data
				this.object.und			[al_row] = ls_und
				this.ii_update = 1
			end if

			select nvl(costo_ult_compra, 0)
				into :ldc_ult_compra
			from articulo
			where cod_art = :ls_codigo;
			
			this.object.precio_new	[al_row] = ldc_ult_compra
					  
		end if
		
		
	case "cencos_org"
		li_year = Integer(this.object.ano_org[al_row])
		if li_year = 0 or IsNull(li_year) then
			MessageBox('Aviso', 'Debe ingresar primero el año origen, Verifique!')
			return
		end if
		
		ls_sql = "SELECT distinct cc.cencos AS CODIGO_cencos, " &
				  + "cc.desc_Cencos AS DESCRIPCION_cencos " &
				  + "FROM centros_costo cc, " &
				  + "presupuesto_partida pp " &
				  + "where pp.cencos = cc.cencos " &
				  + "and pp.ano = " + string(li_year) + " " &
				  + "and cc.flag_estado = '1' " &
				  + "and pp.flag_estado <> '0' "
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos_org	[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case 'cnta_prsp_org'
		li_year = Integer(this.object.ano_org[al_row])
		if li_year = 0 or IsNull(li_year) then
			MessageBox('Aviso', 'Debe ingresar primero el año, Verifique!')
			return
		end if
		
		ls_cencos = this.object.cencos_org[al_row]
		if ls_cencos = '' or IsNull(ls_cencos) then
			MessageBox('Aviso', 'Debe ingresar primero un centro de costo, Verifique!')
			return
		end if
		
		ls_sql = "SELECT distinct pc.cnta_prsp AS CODIGO_cnta_prsp, " &
				  + "pc.descripcion AS DESCRIPCION_cnta_prsp " &
				  + "FROM presupuesto_cuenta pc, " &
				  + "presupuesto_partida pp " &
				  + "where pc.cnta_prsp = pp.cnta_prsp " &
				  + "and pp.ano = " + string(li_year) + " " &
				  + "and pc.flag_estado = '1' " &
				  + "and pp.flag_estado <> '0' "
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp_org	[al_row] = ls_codigo
			this.object.desc_cnta_prsp	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cencos_dst"
		li_year = Integer(this.object.ano_dst[al_row])
		if li_year = 0 or IsNull(li_year) then
			MessageBox('Aviso', 'Debe ingresar primero el año destino, Verifique!')
			return
		end if
		
		ls_sql = "SELECT distinct cc.cencos AS CODIGO_cencos, " &
				  + "cc.desc_Cencos AS DESCRIPCION_cencos " &
				  + "FROM centros_costo cc, " &
				  + "presupuesto_partida pp " &
				  + "where pp.cencos = cc.cencos " &
				  + "and pp.ano = " + string(li_year) + " " &
				  + "and cc.flag_estado = '1' " &
				  + "and pp.flag_estado <> '0' "
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos_dst	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
		return
		
	case 'cnta_prsp_dst'
		li_year = Integer(this.object.ano_dst[al_row])
		if li_year = 0 or IsNull(li_year) then
			MessageBox('Aviso', 'Debe ingresar primero el año, Verifique!')
			return
		end if
		
		ls_cencos = this.object.cencos_dst[al_row]
		if ls_cencos = '' or IsNull(ls_cencos) then
			MessageBox('Aviso', 'Debe ingresar primero un centro de costo, Verifique!')
			return
		end if
		
		ls_sql = "SELECT distinct pc.cnta_prsp AS CODIGO_cnta_prsp, " &
				  + "pc.descripcion AS DESCRIPCION_cnta_prsp " &
				  + "FROM presupuesto_cuenta pc, " &
				  + "presupuesto_partida pp " &
				  + "where pc.cnta_prsp = pp.cnta_prsp " &
				  + "and pp.ano = " + string(li_year) + " " &
				  + "and pc.flag_estado = '1' " &
				  + "and pp.flag_estado <> '0' "
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp_dst	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "centro_benef"
		ls_sql = "SELECT distinct cb.centro_benef AS centro_beneficio, " &
				  + "cb.desc_centro AS descripcion_centro " &
				  + "FROM centro_beneficio cb," &
				  + "centro_benef_usuario cbu " & 
				  + "WHERE cb.centro_benef = cbu.centro_benef " &
				  + "and cb.flag_estado = '1' " &
				  + "and cbu.cod_usr = '" + gs_user + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.centro_benef	[al_row] = ls_codigo
			this.object.desc_centro		[al_row] = ls_data
			this.ii_update = 1
		end if		


end choose
end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

event dw_detail::getfocus;call super::getfocus;if f_row_processing(dw_master,'form') = false then
	dw_master.setFocus( )
	return
end if

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_detail::clicked;//Ancestor Overriding
IF row = 0 OR is_dwform = 'form' THEN RETURN

il_row = row              // fila corriente

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	idwo_clicked = dwo        // dwo corriente
	This.SelectRow(0, False)
	This.SelectRow(row, True)
	THIS.SetRow(row)
	THIS.Event ue_output(row)
	RETURN
END IF

string	  ls_KeyDownType	 //  solo para seleccion multiple

If Keydown(KeyShift!) then  // seleccionar multiples filas usando la tecla shift
	of_Set_Shift_row(row)	
Else
	If this.IsSelected(row) Then
		il_LastRow = row
		ib_action_on_buttonup = true
	Else
		If Keydown(KeyControl!) then  // mantiene las otras filas seleccionadas y selecciona
			il_LastRow = row				// o deselecciona a clicada
			this.SelectRow(row,TRUE)
		Else
			il_LastRow = row
			this.SelectRow(0,FALSE)
			this.SelectRow(row,TRUE)
		End If
	END IF
END IF

//idw_1.BorderStyle = StyleRaised!
//idw_1 = THIS
//idw_1.BorderStyle = StyleLowered!
//is_tabla = 'CLIENTES'						// nombre de tabla para el Log

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;string ls_flag_tipo_sol

dw_master.object.flag_tipo_sol.protect = 1

if dw_master.GetRow() = 0 then return

ls_flag_tipo_sol = dw_master.object.flag_tipo_sol[dw_master.GetRow()]

if ls_flag_tipo_sol = 'R' then
	this.object.cantidad_old [al_row] = 0
	this.object.precio_old   [al_row] = 0
end if

this.object.nro_item	[al_row] = of_nro_item(this)
this.object.cod_usr	[al_row] = gs_user
parent.of_modify1( )

this.SetColumn('flag_tipo_oper')
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

event dw_detail::itemchanged;call super::itemchanged;string 	ls_data, ls_null, ls_cencos, ls_flag_tipo_sol, &
			ls_cnta_prsp, ls_flag_tipo_oper, ls_und, ls_cod_art, &
			ls_desc_art, ls_servicio, ls_desc_servicio, ls_plantilla, &
			ls_tipo_prtda, ls_desc_tipo_prtda, ls_flag_factor, &
			ls_desc_cencos, ls_desc_cnta_prsp, ls_desc
Integer	li_year, li_mes, li_null, li_nro_item
Decimal	ldc_null, ldc_cantidad, ldc_importe, ldc_ult_compra

SetNull(ls_null)
SetNull(ldc_null)
SetNull(li_null)

this.AcceptText()

if dw_master.GetRow() = 0 then return

ls_flag_tipo_sol = dw_master.object.flag_tipo_sol [dw_master.GetRow()]
if IsNull(ls_flag_tipo_sol) or ls_flag_tipo_sol = '' then
	MessageBox('Aviso', 'Debe indicar primero el tipo de Solicitud')
	return
end if

ls_flag_tipo_oper = this.object.flag_tipo_oper[row]
if IsNull(ls_flag_tipo_oper) or ls_flag_tipo_oper = '' then
	MessageBox('Aviso', 'Debe indicar primero el tipo de Operación')
	return
end if


choose case lower(dwo.name)
	case 'flag_tipo_oper' 
		if ls_flag_tipo_sol = 'P' then
			
			this.object.ano_org			[row] = li_null
			this.object.mes_org			[row] = li_null
			this.object.cencos_org 		[row] = ls_null
			this.object.desc_cencos		[row] = ls_null
			this.object.cnta_prsp_org	[row] = ls_null
			this.object.desc_cnta_prsp	[row] = ls_null
			this.object.ano_dst			[row] = li_null
			this.object.mes_dst			[row] = li_null
			this.object.cencos_dst		[row] = ls_null
			this.object.cnta_prsp_dst	[row] = ls_null
			this.object.variacion		[row] = ldc_null
			
		elseif ls_flag_tipo_sol = 'D' or ls_flag_tipo_sol = 'I' then
			
			this.object.ano				[row] = li_null
			this.object.mes				[row] = li_null
			this.object.cencos			[row] = ls_null
			this.object.desc_cencos		[row] = ls_null
			this.object.cod_art			[row] = ls_null
			this.object.desc_art			[row] = ls_null
			this.object.und				[row] = ls_null
			this.object.variacion		[row] = ldc_null
			
		elseif ls_flag_tipo_sol = 'R' then
			
			this.object.cod_plantilla	[row] = ls_null
			this.object.desc_plantilla	[row] = ls_null
			this.object.item_ref			[row] = li_null
			this.object.servicio			[row] = ls_null
			this.object.desc_servicio	[row] = ls_null
			this.object.cod_art			[row] = ls_null
			this.object.desc_art			[row] = ls_null
			this.object.und				[row] = ls_null
			this.object.cantidad_old	[row] = ldc_null
			this.object.cantidad_new	[row] = ldc_null
			this.object.precio_old		[row] = ldc_null
			this.object.precio_new		[row] = ldc_null
			
		end if
	
	case 'cod_plantilla'
		if ls_flag_tipo_sol = 'R' then
			select descripcion
				into :ls_data
			from presup_plant
			where cod_plantilla = :data
			  and flag_estado <> '0';
			
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso', "Codigo de Plantilla no existe, no está activo o no tiene proyección inicial procesada", StopSign!)
				this.object.cod_plantilla	[row] = ls_null
				this.object.desc_plantilla	[row] = ls_null
				return 1
			end if
	
			this.object.desc_plantilla	[row] = ls_data

		end if

	case "item_ref"
		if ls_flag_tipo_sol = 'R' then
			if ls_flag_tipo_oper = 'M' then
				
				ls_plantilla = this.object.cod_plantilla [row]
				if IsNull(ls_plantilla) or ls_plantilla = '' then
					MessageBox('Aviso', 'Debe indicar primeramente una Plantilla')
					return
				end if
				
				li_nro_item = Integer(data)
				
				SELECT ppd.cod_art, a.desc_art, a.und, s.Servicio,  s.descripcion,
						 ppd.cantidad, ppd.importe, NVL(a.costo_ult_compra, 0),
						 cc.cencos, cc.desc_cencos, pc.cnta_prsp, pc.descripcion,
						 tp.tipo_prtda_prsp, tp.desc_tipo_prsp, ppd.flag_factor
				into  :ls_cod_art, :ls_desc_art, :ls_und, :ls_servicio, 
						:ls_desc_servicio, :ldc_cantidad, :ldc_importe, 
						:ldc_ult_compra,
						:ls_cencos, :ls_desc_cencos, :ls_cnta_prsp, :ls_desc_cnta_prsp,
						:ls_tipo_prtda, :ls_desc_tipo_prtda, :ls_flag_factor
				FROM presup_plant_det 		ppd, 
					  articulo 					a, 
					  servicios 				s ,
					  centros_costo			cc,
					  presupuesto_cuenta		pc,
					  tipo_prtda_prsp_det  	tp
			  	where ppd.cod_art  = a.cod_art (+) 
				  and ppd.servicio = s.servicio (+) 
				  and ppd.cencos	 = cc.cencos  
				  and ppd.cnta_prsp= pc.cnta_prsp
				  and ppd.tipo_prtda_prsp = tp.tipo_prtda_prsp (+)
				  and ppd.cod_plantilla = :ls_plantilla
				  and item = :li_nro_item;
						
				if SQLCA.SQLCode = 100 then
					MessageBox('Aviso', 'Item de Plantilla presupuestal no existe, Verifique!')
					this.object.item_ref			[row] = li_null
					this.object.cod_art			[row] = ls_null
					this.object.desc_art			[row] = ls_null
					this.object.und				[row] = ls_null
					this.object.servicio			[row] = ls_null
					this.object.desc_servicio	[row] = ls_null
					this.object.cencos			[row] = ls_null
					this.object.desc_cencos		[row] = ls_null
					this.object.cnta_prsp		[row] = ls_null
					this.object.desc_cnta_prsp	[row] = ls_null
					this.object.tipo_prtda_prsp[row] = ls_null
					this.object.desc_tipo_prsp	[row] = ls_null
					this.object.flag_Factor		[row] = ls_null
					this.object.cantidad_old	[row] = 0
					this.object.precio_old		[row] = 0
					this.object.cantidad_new	[row] = ldc_null
					this.object.precio_new		[row] = ldc_null
					return 1
				end if
				
				this.object.cod_art			[row] = ls_cod_art
				this.object.desc_art			[row] = ls_desc_art
				this.object.und				[row] = ls_und
				this.object.servicio			[row] = ls_servicio
				this.object.desc_servicio	[row] = ls_desc_servicio
				this.object.cantidad_old	[row] = ldc_cantidad
				this.object.precio_old		[row] = ldc_importe
				this.object.precio_new		[row] = ldc_ult_compra
				this.object.cencos			[row] = ls_cencos
				this.object.desc_cencos		[row] = ls_desc_cencos
				this.object.cnta_prsp		[row] = ls_cnta_prsp
				this.object.desc_cnta_prsp	[row] = ls_desc_cnta_prsp
				this.object.flag_Factor		[row] = ls_flag_factor
				
				// si el tipo de partida es nula entonces lo saco de la 
				// cuenta presupuestal
				if ls_tipo_prtda = '' or IsNull(ls_tipo_prtda) then
					select tp.tipo_prtda_prsp, tp.desc_tipo_prsp
					  into :ls_tipo_prtda, :ls_desc_tipo_prtda
					  from presupuesto_cuenta  pc,
					  		 tipo_prtda_prsp_det tp
					where pc.tipo_cuenta = tp.tipo_prtda_prsp
					  and pc.cnta_prsp	= :ls_cnta_prsp;
				end if
				
				this.object.tipo_prtda_prsp[row] = ls_tipo_prtda
				this.object.desc_tipo_prsp	[row] = ls_desc_tipo_prtda
				
			end if
			
		end if
		
	case "cencos" 
		if ls_flag_tipo_sol = 'D' or ls_flag_tipo_sol = 'I' then
			// Esto en el caso de que sea un solicitud de variacion
			// de la proyeccion de produccion o de ventas
			li_year = Integer(this.object.ano[row])
			if li_year = 0 or IsNull(li_year) then
				MessageBox('Aviso', 'Debe ingresar primero el año origen, Verifique!')
				return
			end if
	
			if ls_flag_tipo_sol = 'D' then
				SELECT distinct cc.desc_Cencos 
					into :ls_data
				FROM centros_costo cc,
					  presup_produccion_und pp 
				where pp.cencos = cc.cencos 
				  and pp.ano = :li_year
				  and cc.flag_estado <> '0' 
				  and pp.flag_estado = '2'
				  and cc.cencos = :data;
			else					  
				SELECT distinct cc.desc_Cencos 
					into :ls_data
				FROM centros_costo cc,
					  presup_ingresos_und pp 
				where pp.cencos = cc.cencos 
				  and pp.ano = :li_year
				  and cc.flag_estado <> '0' 
				  and pp.flag_estado = '2'
				  and cc.cencos = :data;
			end if
		elseif ls_flag_tipo_sol = 'R' then
			SELECT cc.desc_Cencos 
				into :ls_data
			FROM centros_costo cc
			where cc.flag_estado <> '0' 
			  and cc.cencos = :data;
		end if
		
		if SQLCA.SQLCode = 100 then
			if ls_flag_tipo_sol <> 'R' then
				Messagebox('Aviso', "Centro de costo no existe, no está activo o no tiene proyección inicial procesada", StopSign!)
			else
				Messagebox('Aviso', "Centro de costo no existe, no está activo", StopSign!)
			end if
			this.object.cencos		[row] = ls_null
			this.object.desc_cencos	[row] = ls_null
			return 1
		end if

		this.object.desc_cencos	[row] = ls_data
		
	case 'cnta_prsp'
		if ls_flag_tipo_sol = 'R' then
			ls_cencos = this.object.cencos[row]
			if ls_cencos = '' or IsNull(ls_cencos) then
				MessageBox('Aviso', 'Debe ingresar primero un centro de costo, Verifique!')
				return
			end if
			
			SELECT pc.descripcion, tipo_cuenta, desc_tipo_prsp 
			  into :ls_data, :ls_tipo_prtda, :ls_desc_tipo_prtda
			FROM presupuesto_cuenta 	pc,
				  tipo_prtda_prsp_det	tp
			where tp.tipo_prtda_prsp = pc.tipo_cuenta
			  and pc.flag_estado = '1' 
			  and pc.cnta_prsp = :data;
						 
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso', "Centro de costo no existe, no está activo", StopSign!)
				this.object.cnta_prsp		[row] = ls_null
				this.object.desc_cnta_prsp	[row] = ls_null
				this.object.tipo_prtda_prsp[row] = ls_null
				this.object.desc_tipo_prsp [row] = ls_null
				return 1
			end if
			
			this.object.desc_cnta_prsp [row] = ls_data
			this.object.tipo_prtda_prsp[row] = ls_tipo_prtda
			this.object.desc_tipo_prsp [row] = ls_desc_tipo_prtda
				
		end if
	
	case 'tipo_prtda_prsp'
		if ls_flag_tipo_sol = 'R' then
			ls_cencos = this.object.cencos[row]
			if ls_cencos = '' or IsNull(ls_cencos) then
				MessageBox('Aviso', 'Debe ingresar primero un centro de costo, Verifique!')
				return
			end if
			
			ls_cnta_prsp = this.object.cnta_prsp[row]
			if ls_cnta_prsp = '' or IsNull(ls_cnta_prsp) then
				MessageBox('Aviso', 'Debe ingresar primero una cuenta presupuestal, Verifique!')
				return
			end if
			
			SELECT DESC_TIPO_PRSP 
				into :ls_data
			FROM tipo_prtda_prsp_det 
			where flag_estado = '1' 
			  and tipo_prtda_prsp = :data;
						 
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso', "Tipo de Partida Presupuestal no existe o no está activo", StopSign!)
				this.object.tipo_prtda_prsp[row] = ls_null
				this.object.desc_tipo_prsp [row] = ls_null
				return 1
			end if
			
			this.object.desc_tipo_prsp [row] = ls_data
		end if


	case 'servicio'
		if ls_flag_tipo_sol = 'R' then
			ls_cod_art = this.object.cod_art[row]
			if ls_cod_art <> '' and not IsNull(ls_cod_art) then
				MessageBox('Aviso', 'No puede colocar un servicio, porque ya ha indicado un articulo')
				this.object.servicio			[row] = ls_null
				this.object.desc_servicio	[row] = ls_null
				this.object.cantidad_old	[row] = 0
				this.object.precio_old		[row] = 0
				this.object.cantidad_new	[row] = ldc_null
				this.object.precio_new		[row] = ldc_null
				return 1
			end if
				
			ls_plantilla = this.object.cod_plantilla[row]
			if ls_plantilla = '' or IsNull(ls_plantilla) then
				MessageBox('Aviso', 'Debe elegir un codigo de plantilla primero')
				this.object.servicio			[row] = ls_null
				this.object.desc_servicio	[row] = ls_null
				this.object.cantidad_old	[row] = 0
				this.object.precio_old		[row] = 0
				this.object.cantidad_new	[row] = ldc_null
				this.object.precio_new		[row] = ldc_null
				return 1
			end if
			
			if ls_flag_tipo_oper = 'M' then
				li_nro_item = Long(this.object.nro_item[row])
				if li_nro_item = 0 or IsNull(li_nro_item) then
					MessageBox('Aviso', 'Deben especificar un numero de item valido')
					this.object.servicio			[row] = ls_null
					this.object.desc_servicio	[row] = ls_null
					this.object.cantidad_old	[row] = 0
					this.object.precio_old		[row] = 0
					this.object.cantidad_new	[row] = ldc_null
					this.object.precio_new		[row] = ldc_null
					return 1
				end if
				
				
				SELECT distinct s.descripcion, ppd.cantidad, ppd.importe
					into :ls_desc_servicio, :ldc_cantidad, :ldc_importe
				FROM 	servicios s, 
						presup_plant_det ppd 
				where ppd.servicio = s.servicio 
					and ppd.cod_plantilla = :ls_plantilla
					and ppd.item = :li_nro_item
					and ppd.servicio = :data
					and s.flag_estado <> '0';
			else
				ldc_cantidad = 0
				ldc_importe = 0
				
				SELECT s.descripcion 
					into :ls_desc_servicio
				FROM servicios s
				where s.servicio = :data
					and s.flag_estado <> '0';
				
			end if
			
			if SQLCA.SQLCode =100 then
				MessageBox('Aviso', 'Codigo de Servicio no existe, no esta activo o no pertenece a la plantilla')
				this.object.servicio			[row] = ls_null
				this.object.desc_servicio	[row] = ls_null
				this.object.cantidad_old	[row] = 0
				this.object.precio_old		[row] = 0
				this.object.cantidad_new	[row] = ldc_null
				this.object.precio_new		[row] = ldc_null
				return 1
			end if
			
			this.object.desc_servicio	[row] = ls_desc_servicio
			this.object.cantidad_old	[row] = ldc_cantidad
			this.object.precio_old		[row] = ldc_importe
				
		end if
	

	case "cod_art" 
		if ls_flag_tipo_sol = 'D' or ls_flag_tipo_sol = 'I' then
			// Esto en el caso de que sea un solicitud de variacion
			// de la proyeccion de produccion o de ventas
			li_year = Integer(this.object.ano[row])
			if li_year = 0 or IsNull(li_year) then
				MessageBox('Aviso', 'Debe ingresar primero el año origen, Verifique!')
				return
			end if
			
			ls_cencos = this.object.cencos [row]
			if IsNull(ls_cencos) or ls_cencos = '' then
				MessageBox('Aviso', 'Debe indicar primeramente el centro de costo')
				return
			end if
	
			if ls_flag_tipo_sol = 'D' then
				SELECT distinct a.desc_art , und
					into :ls_data, :ls_und
				FROM articulo a, 
					  presup_produccion_und pp 
				where pp.cod_art = a.cod_art 
				  and pp.cencos  = :ls_cencos
				  and pp.ano 	  = :li_year
				  and a.flag_estado <> '0' 
				  and pp.flag_estado = '2' 
				  and a.cod_art		= :data;
			else					  
				SELECT distinct a.desc_art , und
					into :ls_data, :ls_und
				FROM articulo a, 
					  presup_ingresos_und pp 
				where pp.cod_art = a.cod_art 
				  and pp.cencos  = :ls_cencos
				  and pp.ano 	  = :li_year
				  and a.flag_estado <> '0' 
				  and pp.flag_estado = '2' 
				  and a.cod_art		= :data;
			end if
			
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso', "Código de Artículo no existe, no está activo o no tiene proyección inicial procesada", StopSign!)
				this.object.cod_art	[row] = ls_null
				this.object.desc_art	[row] = ls_null
				return 1
			end if
	
			this.object.desc_art	[row] = ls_data
		else
			ls_servicio = this.object.servicio[row]
			
			if ls_servicio <> '' and not IsNull(ls_servicio) then
				MessageBox('Aviso', 'No puede colocar un articulo, porque ya ha indicado un servicio')
				this.object.cod_art 		[row] = ls_null
				this.object.desc_art		[row] = ls_null
				this.object.und			[row]	= ls_null
				this.object.cantidad_old[row] = 0
				this.object.precio_old	[row] = 0
				this.object.cantidad_new[row] = ldc_null
				this.object.precio_new	[row] = ldc_null
				return 1
			end if
			
			// En esta sección entran cuando sea un cambio en los ratios 
			ls_plantilla = this.object.cod_plantilla[row]
			if ls_plantilla = '' or IsNull(ls_plantilla) then
				MessageBox('Aviso', 'Debe elegir un codigo de plantilla primero')
				this.object.cod_art 		[row] = ls_null
				this.object.desc_art		[row] = ls_null
				this.object.und			[row]	= ls_null
				this.object.cantidad_old[row] = 0
				this.object.precio_old	[row] = 0
				this.object.cantidad_new[row] = ldc_null
				this.object.precio_new	[row] = ldc_null
				return 1
			end if
			
			if ls_flag_tipo_oper = 'M' then
				
				li_nro_item = Long(this.object.nro_item[row])
				if li_nro_item = 0 or IsNull(li_nro_item) then
					MessageBox('Aviso', 'Deben especificar un numero de item valido')
					this.object.cod_art 		[row] = ls_null
					this.object.desc_art		[row] = ls_null
					this.object.und			[row]	= ls_null
					this.object.cantidad_old[row] = 0
					this.object.precio_old	[row] = 0
					this.object.cantidad_new[row] = ldc_null
					this.object.precio_new	[row] = ldc_null
					return 1
				end if
				
				
				SELECT distinct a.desc_art, a.und, ppd.cantidad, 
						 ppd.importe, NVL(a.costo_ult_compra, 0)
				into   :ls_desc_art, :ls_und, :ldc_cantidad, 
					    :ldc_importe, :ldc_ult_compra
				FROM 	articulo a,
						presup_plant_det ppd 
				where ppd.cod_art = a.cod_art 
				  and ppd.cod_plantilla = :ls_plantilla
				  and ppd.item = :li_nro_item
				  and ppd.cod_art = :data
				  and a.flag_estado <> '0';
			else
				ldc_cantidad = 0
				ldc_importe	 = 0
				
				SELECT desc_art, und, NVL(costo_ult_compra, 0) 
					into :ls_desc_art, :ls_und, :ldc_ult_compra
				from articulo
				where cod_art = :data
				  and flag_estado <> '0';
			end if
			
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso', "Código de Artículo no existe, no está activo o no esta en el item de la plantilla", StopSign!)
				this.object.cod_art		[row] = ls_null
				this.object.desc_art		[row] = ls_null
				this.object.und			[row] = ls_null
				this.object.cantidad_old[row] = 0
				this.object.precio_old	[row] = 0
				this.object.cantidad_new[row] = ldc_null
				this.object.precio_old	[row] = ldc_null
				return 1
			end if

			this.object.desc_art		[row] = ls_desc_art
			this.object.und			[row] = ls_und
			this.object.cantidad_old[row] = ldc_cantidad
			this.object.precio_old	[row] = ldc_importe
			this.object.precio_new	[row] = ldc_ult_compra

		end if

	case "cencos_org"
		
		li_year = Integer(this.object.ano_org[row])
		if li_year = 0 or IsNull(li_year) then
			MessageBox('Aviso', 'Debe ingresar primero el año origen, Verifique!')
			return
		end if
		
		select distinct cc.desc_cencos
			into :ls_data
		from presupuesto_partida pp,
			  centros_costo		 cc
		where pp.cencos = cc.cencos
		  and pp.flag_estado <> '0'
		  and cc.flag_estado = '1'
		  and cc.cencos = :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Centro de costo no existe, no está activo o no tiene partida presupuestal", StopSign!)
			this.object.cencos_org	[row] = ls_null
			this.object.desc_cencos	[row] = ls_null
			return 1
		end if

		this.object.desc_cencos	[row] = ls_data
		
	case "cnta_prsp_org"
		
		li_year = Integer(this.object.ano_org[row])
		if li_year = 0 or IsNull(li_year) then
			MessageBox('Aviso', 'Debe ingresar primero el año origen, Verifique!')
			return
		end if
		
		ls_cencos = this.object.cencos_org[row]
		if ls_cencos = '' or IsNull(ls_cencos) then
			MessageBox('Aviso', 'Debe ingresar primero un centro de costo, Verifique!')
			return
		end if

		select distinct pc.descripcion
			into :ls_data
		from presupuesto_partida pp,
			  presupuesto_cuenta	 pc
		where pp.cnta_prsp = pc.cnta_prsp
		  and pp.flag_estado <> '0'
		  and pc.flag_estado = '1'
		  and pc.cnta_prsp = :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Centro de costo no existe, no está activo o no tiene partida presupuestal", StopSign!)
			this.object.cnta_prsp_org	[row] = ls_null
			this.object.desc_cnta_prsp	[row] = ls_null
			return 1
		end if

		this.object.desc_cnta_prsp	[row] = ls_data

	case "cencos_dst"
		
		li_year = Integer(this.object.ano_org[row])
		if li_year = 0 or IsNull(li_year) then
			MessageBox('Aviso', 'Debe ingresar primero el año origen, Verifique!')
			return
		end if
		
		select distinct cc.desc_cencos
			into :ls_data
		from presupuesto_partida pp,
			  centros_costo		 cc
		where pp.cencos = cc.cencos
		  and pp.flag_estado <> '0'
		  and cc.flag_estado = '1'
		  and cc.cencos = :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Centro de costo no existe, no está activo o no tiene partida presupuestal", StopSign!)
			this.object.cencos_dst	[row] = ls_null
			return 1
		end if

	case "cnta_prsp_dst"
		
		li_year = Integer(this.object.ano_org[row])
		if li_year = 0 or IsNull(li_year) then
			MessageBox('Aviso', 'Debe ingresar primero el año origen, Verifique!')
			return
		end if
		
		ls_cencos = this.object.cencos_dst[row]
		if ls_cencos = '' or IsNull(ls_cencos) then
			MessageBox('Aviso', 'Debe ingresar primero un centro de costo, Verifique!')
			return
		end if

		select distinct pc.descripcion
			into :ls_data
		from presupuesto_partida pp,
			  presupuesto_cuenta	 pc
		where pp.cnta_prsp = pc.cnta_prsp
		  and pp.flag_estado <> '0'
		  and pc.flag_estado = '1'
		  and pc.cnta_prsp = :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Centro de costo no existe, no está activo o no tiene partida presupuestal", StopSign!)
			this.object.cnta_prsp_dst	[row] = ls_null
			return 1
		end if
	
	case 'variacion'
		
		if ls_flag_tipo_sol = 'P' then
			ls_flag_tipo_oper = this.object.flag_tipo_oper [row]
			
			if IsNull(ls_flag_tipo_oper) or ls_flag_tipo_oper = '' then
				MessageBox('Aviso', 'Debe Definir el tipo de Operacion')
				return
			end if
			
			if ls_flag_tipo_oper = 'R' or ls_flag_tipo_oper = 'T' then
				if Dec(data) <= 0 or IsNull(Dec(data)) then
					messagebox( 'Atencion', 'Importe no permitido')
					this.object.variacion[row] = ldc_null
					this.SetColumn('variacion')
					return 1
				end if
				
				if ls_flag_tipo_oper = 'R' or ls_flag_tipo_oper = 'T' then   // Reduccion o transferencia
					li_year 		 = Long(this.object.ano_org   [row])
					li_mes  		 = Long(this.object.mes_org   [row])
					ls_cencos 	 = this.object.cencos_org 		[row]
					ls_cnta_prsp = this.object.cnta_prsp_org	[row]
					
					if of_evalua_ppto(li_year, li_mes, ls_cencos, ls_cnta_prsp, Dec(data)) = 0 then 
						this.object.variacion [row] = ldc_null
						return 1
					end if
				end if	
			end if
		end if
	
	case "centro_benef"
		Select cb.desc_centro 
			into :ls_desc 
		from centro_beneficio cb,
			  centro_benef_usuario cbu
		where cb.centro_benef = cbu.centro_benef
		  and cb.centro_benef = :data
		  and cbu.cod_usr		 = :gs_user
		  and cb.flag_estado = '1';
		  
		if sqlca.sqlcode = 100 then
			Messagebox( "Error", "Centro de beneficio no existe, no esta activo o no tiene autorizacion para utilizarlo", Exclamation!)		
			this.object.centro_benef	[row] = ls_null
			this.object.desc_centro		[row] = ls_null
			Return 1	
		end if
		this.object.desc_centro	[row] = ls_desc
		
end choose
end event

type st_2 from statictext within w_pt311_solicitud_variacion
integer x = 78
integer y = 24
integer width = 498
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Solicitud:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pt311_solicitud_variacion
integer x = 1097
integer y = 12
integer width = 261
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;if sle_nro.text = '' then
	MessageBox('Aviso', 'Debe ingresar un numero de variación')
	return
end if

parent.of_retrieve(sle_nro.text)
sle_nro.text = ''


end event

type sle_nro from singlelineedit within w_pt311_solicitud_variacion
integer x = 590
integer y = 4
integer width = 462
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

