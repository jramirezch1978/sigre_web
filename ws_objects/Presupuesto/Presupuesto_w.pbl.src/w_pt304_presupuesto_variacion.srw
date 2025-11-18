$PBExportHeader$w_pt304_presupuesto_variacion.srw
forward
global type w_pt304_presupuesto_variacion from w_abc_master
end type
type st_2 from statictext within w_pt304_presupuesto_variacion
end type
type cb_1 from commandbutton within w_pt304_presupuesto_variacion
end type
type sle_nro from singlelineedit within w_pt304_presupuesto_variacion
end type
end forward

global type w_pt304_presupuesto_variacion from w_abc_master
integer width = 2391
integer height = 1836
string title = "Variaciones Partida Presupuestal (PT304)"
string menuname = "m_mantenimiento_cl"
boolean maxbox = false
event ue_cancelar ( )
st_2 st_2
cb_1 cb_1
sle_nro sle_nro
end type
global w_pt304_presupuesto_variacion w_pt304_presupuesto_variacion

type variables

end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro)
public function integer of_evalua_ppto (integer ai_year, integer ai_mes, string as_cencos, string as_cnta_prsp, decimal adc_importe)
end prototypes

event ue_cancelar();// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()

dw_master.ii_update = 0


end event

public function integer of_set_numera ();// Numera documento
Long 		ll_long, ll_nro
string	ls_mensaje, ls_nro, ls_table

if dw_master.GetRow() = 0 then return 0

if is_action = 'new' then
	ls_table = 'LOCK TABLE NUM_PRESUP_VARIACION IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_nro 
	from NUM_PRESUP_VARIACION
	where origen = :gs_origen;
	
	IF SQLCA.SQLCode = 100 then
		Insert into NUM_PRESUP_VARIACION (origen, ult_nro)
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
	Update NUM_PRESUP_VARIACION 
		set ult_nro = ult_nro + 1 
	 where origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if

	dw_master.object.nro_variacion[dw_master.getrow()] = ls_nro
end if

return 1
end function

public subroutine of_retrieve (string as_nro);dw_master.retrieve(as_nro)
dw_master.ii_protect = 0
dw_master.of_protect()

dw_master.ii_update = 0
end subroutine

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

on w_pt304_presupuesto_variacion.create
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

on w_pt304_presupuesto_variacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.sle_nro)
end on

event ue_modify;// Ancestor Script has been Override
if dw_master.object.flag_automatico[dw_master.GetRow()] <> '0' then
	MessageBox('Aviso', 'No puede Modificar una variacion automatica')
	dw_master.ii_protect = 0
	dw_master.of_protect()
	return
end if

dw_master.of_protect() 

int li_protect

li_protect = integer(dw_master.Object.ano.Protect)

IF li_protect = 0 THEN
   dw_master.Object.ano.Protect = 1
	dw_master.Object.cencos_origen.Protect = 1
	dw_master.Object.cnta_prsp_origen.Protect = 1
	dw_master.Object.tipo_variacion.Protect = 1
END IF
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
Long ll_row
ll_row = dw_master.GetRow()

if ll_row = 0 then return

ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

if of_set_numera() = 0 then return

dw_master.of_set_flag_replicacion()

dw_master.SetRow(ll_row)
dw_master.Scrolltorow( ll_row )

ib_update_check = true
end event

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
// ii_help = 101
f_centrar( this)

idw_1 = dw_master
ib_log = TRUE
end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 		= "d_list_presupuesto_variacion"
sl_param.titulo 	= "Variaciones"
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then	
	// Se ubica la cabecera
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_delete;// Ancestor Script has been Override
if dw_master.GetRow() = 0 then return

if dw_master.object.flag_automatico[dw_master.GetRow()] <> '0' then
	MessageBox('Aviso', 'No puede Eliminar una variacion automatica')
	dw_master.ii_protect = 0
	dw_master.of_protect()
	return
end if

Long  ll_row

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

event ue_insert;// Ancestor Script has been Override
Long  ll_row

idw_1.Reset()

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

event ue_print;//Ancestor Overriding
str_parametros lstr_param
w_rpt_preview lw_1

if dw_master.GetRow() = 0 then return

lstr_param.dw1		 = 'd_rpt_prsp_variaciones_frm'
lstr_param.string1 = dw_master.object.nro_variacion[dw_master.GetRow()]
lstr_param.tipo	 = '1S'
lstr_param.titulo	 = 'Variaciones presupuestales'

OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered!)
end event

type dw_master from w_abc_master`dw_master within w_pt304_presupuesto_variacion
event ue_display ( string as_columna,  long al_row )
integer y = 128
integer width = 2286
integer height = 1332
string dataobject = "d_abc_presupuesto_ampliacion"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_year, ls_Cencos

choose case lower(as_columna)
		
	case "cencos_origen"
		ls_sql = "SELECT distinct cc.cencos AS CODIGO_cencos, " &
				 + "cc.DESC_cencos AS DESCRIPCION_cencos " &
				 + "FROM centros_costo cc " &
				 + "where cc.flag_estado = '1' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos_origen		[al_row] = ls_codigo
			this.object.desc_cencos_origen[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cnta_prsp_origen"
		ls_sql = "SELECT distinct pc.cnta_prsp AS CODIGO_cnta_prsp, " &
				 + "pc.descripcion AS DESC_cnta_prsp " &
				 + "FROM presupuesto_cuenta pc " &
				 + "where pc.flag_estado = '1' " 
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp_origen		[al_row] = ls_codigo
			this.object.desc_cnta_prsp_origen[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cencos_destino"
		ls_sql = "SELECT cc.cencos AS CODIGO_cencos, " &
				 + "cc.DESC_cencos AS DESCRIPCION_cencos " &
				 + "FROM centros_costo cc " &
				 + "where cc.flag_estado = '1' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos_destino		 [al_row] = ls_codigo
			this.object.desc_cencos_destino[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cnta_prsp_destino"
		
		ls_sql = "SELECT pc.cnta_prsp AS CODIGO_cnta_prsp, " &
				 + "pc.descripcion AS DESC_cnta_prsp " &
				 + "FROM presupuesto_cuenta pc " &
				 + "where pc.flag_estado = '1' "
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp_destino		 [al_row] = ls_codigo
			this.object.desc_cnta_prsp_destino[al_row] = ls_data
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
		
end choose

end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
ii_ck[1] = 1			// columnas de lectrua de este dw
is_dwform = 'form'	// tabular, form (default)
end event

event dw_master::itemchanged;call super::itemchanged;Long 			ll_year, ll_mes, ll_count
String 		ls_desc, ls_cencos, ls_cnta_prsp, ls_null, ls_estado, &
				ls_tipo_variacion
Decimal{2} 	ldc_importe, ldc_null

setnull( ls_null)
setnull( ldc_null)

this.AcceptText()

// Verifica si existe
if dwo.name = "cencos_origen" then	
	ll_year = Long(this.object.ano[row])
	
	if ll_year = 0 or IsNull(ll_year) then
		MessageBox('Aviso', 'Tiene que especificar el año')
		return
	end if
	
	Select distinct cc.desc_cencos 
		into :ls_desc
	from centros_costo cc
	where cc.flag_estado = '1'
	  and cc.cencos 	 = :data;	
	
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Centro de costo no existe o no esta activo", Exclamation!)		
		this.object.cencos_origen		[row] = ls_null
		this.object.desc_cencos_origen[row] = ls_null
		Return 1
	end if
	
	this.object.desc_cencos_origen[row] = ls_desc
	
elseif dwo.name = "cnta_prsp_origen" then	

	ll_year = Long(this.object.ano[row])
	
	if ll_year = 0 or IsNull(ll_year) then
		MessageBox('Aviso', 'Tiene que especificar el año')
		return
	end if
	
	ls_cencos = this.object.cencos_origen[row]
	
	if ls_cencos = '' or IsNull(ls_cencos) then
		MessageBox('Aviso', 'Tiene que especificar un centro de costo')
		return
	end if
	
	Select distinct pc.descripcion
		into :ls_desc
	from presupuesto_cuenta  pc
	where pc.flag_estado  = '1'
	  and pc.cnta_prsp	 = :data;

	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Cuenta Presupuestal no existe o no esta activo", Exclamation!)		
		this.object.cnta_prsp_origen		[row] = ls_null
		this.object.desc_cnta_prsp_origen[row] = ls_null
		Return 1
	end if
	
	this.object.desc_cnta_prsp_origen[row] = ls_desc

elseif dwo.name = "cencos_destino" then	
	
	Select desc_cencos 
		into :ls_desc 
	from centros_costo 
	where cencos = :data
	  and flag_estado = '1';
	  
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Centro de costo no existe o no esta activo", Exclamation!)		
		this.object.cencos_destino			[row] = ls_null
		this.object.desc_cencos_destino	[row] = ls_null
		Return 1
	end if
	
	this.object.desc_cencos_destino[row] = ls_desc
	
elseif dwo.name = "cnta_prsp_destino" then	
	
	Select descripcion 
		into :ls_desc 
	from presupuesto_cuenta 
	where cnta_prsp = :data
	  and flag_estado = '1';
	  
	if SQLCA.SQLCode = 100 then
		
		Messagebox( "Error", "Cuenta Presupuestal no existe", Exclamation!)		
		this.object.cnta_prsp_destino			[row] = ls_null
		this.object.desc_cnta_prsp_destino	[row] = ls_null
		Return 1
	end if
	
	this.object.desc_cnta_prsp_destino[row] = ls_desc

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

	
elseif dwo.name = 'tipo_variacion' then

	if this.object.tipo_variacion[row] = 'T' then	
		// Desactiva destino
		this.object.cencos_destino.background.color = RGB(255,255,255)
		this.object.cencos_destino.protect = 0
		this.object.cnta_prsp_destino.background.color = RGB(255,255,255)
		this.object.cnta_prsp_destino.protect = 0
		this.object.mes_destino.background.color = RGB(255,255,255)
		this.object.mes_destino.protect = 0
	else
		// Desactiva destino
		this.object.cencos_destino.background.color = RGB(192,192,192)   
		this.object.cencos_destino.protect = 1
		this.object.cnta_prsp_destino.background.color = RGB(192,192,192)   
		this.object.cnta_prsp_destino.protect = 1
		this.object.mes_destino.background.color = RGB(192,192,192)   
		this.object.mes_destino.protect = 1
	end if
	
elseif dwo.name = 'importe' then
	
	ls_tipo_variacion = this.object.tipo_variacion [row]
	
	if IsNull(ls_tipo_variacion) or ls_tipo_variacion = '' then
		MessageBox('Aviso', 'Debe Definir el tipo de Operacion')
		return
	end if	
	
	if Dec(data) <= 0 or IsNull(Dec(data)) then
		messagebox( 'Atencion', 'Importe no permitido')
		this.object.importe[row] = ldc_null
		return 1
	end if
	
	if ls_tipo_variacion = 'R' or ls_tipo_variacion = 'T' then   // Reduccion
		ll_year 		 = Long(this.object.ano [row])
		ll_mes  		 = Long(this.object.mes_origen [row])
		ls_cencos 	 = this.object.cencos_origen 		[row]
		ls_cnta_prsp = this.object.cnta_prsp_origen	[row]
		
		if of_evalua_ppto(ll_year, ll_mes, ls_cencos, ls_cnta_prsp, Dec(data)) = 0 then 
			this.object.importe [row] = ldc_null
			return 1
		end if
	end if	
	
end if

// Verifica que exista partida
ls_cencos 		= this.object.cencos_origen[row]
ls_cnta_prsp 	= this.object.cnta_prsp_origen[row]
ll_year 			= Long(this.object.ano[row])
ll_mes 			= Long(this.object.mes_origen[row])

IF ll_year = 0 or ISNull(ll_year) then
	this.setcolumn( 'ano')
	return 1
end if

IF ll_mes = 0 or ISNull(ll_mes) then
	this.setcolumn( 'mes_origen')
	return 1
end if

IF ls_cencos = '' or ISNull(ls_cencos) then
	this.setcolumn( 'cencos_origen')
	return 1
end if

IF ls_cnta_prsp = '' or ISNull(ls_cnta_prsp) then
	this.setcolumn( 'cnta_prsp_origen')
	return 1
end if

if this.object.tipo_variacion[row] <> 'A'  then
	
	Select count(*) 
	into :ll_count 
	from presupuesto_partida
	where cencos = :ls_cencos 
	  and cnta_prsp = :ls_cnta_prsp 
	  and ano = :ll_year
	  and flag_estado <> '0';	
	  
	if ll_count = 0 then
		Messagebox( "Atencion", "Partida no presupuestada o esta inactiva")
		this.object.cencos_origen			[row] = ls_null
		this.object.cnta_prsp_origen		[row] = ls_null
		this.object.desc_cencos_origen	[row] = ls_null
		this.object.desc_cnta_prsp_origen[row] = ls_null
		this.Setcolumn( 'cencos_origen')
		return 1
	end if
	
end if
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr			[al_row] = gs_user
this.object.fecha				[al_row] = f_fecha_Actual()
this.object.flag_automatico[al_row] = '0'
this.object.flag_proceso	[al_row] = 'M'


// Desactiva destino
this.object.cencos_destino.background.color = RGB(192,192,192)   
this.object.cencos_destino.protect = 1
this.object.cnta_prsp_destino.background.color = RGB(192,192,192)   
this.object.cnta_prsp_destino.protect = 1
this.object.mes_destino.background.color = RGB(192,192,192)   
this.object.mes_destino.protect = 1

is_Action = 'new'
this.SetColumn("ano")
this.SetFocus()
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, row)
end if

end event

event dw_master::keydwn;call super::keydwn;string 	ls_columna, ls_cadena
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

type st_2 from statictext within w_pt304_presupuesto_variacion
integer x = 55
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
string text = "Nro Variacion:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pt304_presupuesto_variacion
integer x = 1097
integer y = 12
integer width = 261
integer height = 84
integer taborder = 30
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

type sle_nro from singlelineedit within w_pt304_presupuesto_variacion
integer x = 590
integer y = 4
integer width = 462
integer height = 100
integer taborder = 40
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

