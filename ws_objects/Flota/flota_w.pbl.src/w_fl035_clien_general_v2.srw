$PBExportHeader$w_fl035_clien_general_v2.srw
forward
global type w_fl035_clien_general_v2 from w_abc_master_smpl
end type
end forward

global type w_fl035_clien_general_v2 from w_abc_master_smpl
integer width = 2839
integer height = 1008
string title = "Clientes (FL035)"
string menuname = "m_mto_smpl_cslta"
long backcolor = 67108864
end type
global w_fl035_clien_general_v2 w_fl035_clien_general_v2

forward prototypes
public function string of_carga_data (integer ai_tipo)
public function string of_carga_dis ()
end prototypes

public function string of_carga_data (integer ai_tipo);string ls_proveedor, ls_nombre, ls_sql, ls_ubigeo_oficina, ls_ubigeo_planta, ls_ubigeo, ls_nom_proveedor, ls_ruc
long ll_row 
integer li_i, li_countcli
str_seleccionar lstr_seleccionar

choose case ai_tipo
	case 0 //cliente nuevo
		ls_sql = "SELECT CODIGO AS IDENTIFICADOR, NOMBRE AS DESCRIPCION, RUC AS RUC FROM VW_FL_PROV_CLIENTE_NON"
	case 1 //cliente existente
		ls_sql = "SELECT CODIGO AS IDENTIFICADOR, NOMBRE AS DESCRIPCION, RUC AS RUC FROM VW_FL_PROV_CLIENTE"
end choose

lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S' //S SIMPLE Y M PARA MULTIPLE
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	
IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_proveedor = left(trim(lstr_seleccionar.param1[1])+'        ',8)+trim(lstr_seleccionar.param2[1])
ELSE
	ls_proveedor = ''
END IF
return ls_proveedor
end function

public function string of_carga_dis ();string ls_proveedor, ls_nombre, ls_sql, ls_ubigeo_oficina, ls_ubigeo_planta, ls_ubigeo, ls_distrito, ls_ruc
long ll_row 
integer li_i, li_countcli
str_seleccionar lstr_seleccionar

ls_sql = "select vtu.ubigeo_codigo as codigo, vtu.ubige_descripcion as descripcion, vtu.referencia as referencia from vw_tg_ubigeo vtu"

lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S' //S SIMPLE Y M PARA MULTIPLE
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	
IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_distrito = trim(lstr_seleccionar.param1[1]) + trim(trim(lstr_seleccionar.param2[1]))
	return ls_distrito
END IF
end function

on w_fl035_clien_general_v2.create
call super::create
if this.MenuName = "m_mto_smpl_cslta" then this.MenuID = create m_mto_smpl_cslta
end on

on w_fl035_clien_general_v2.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master
end event

event ue_retrieve_list;call super::ue_retrieve_list;//override
// Asigna valores a structura 
str_parametros sl_param

sl_param.dw1    = 'ds_clientes_grid'
sl_param.titulo = 'Clientes de Flota'
sl_param.field_ret_i[1] = 1	//Codigo Cliente
sl_param.field_ret_i[2] = 2	//Nombre Cliente

OpenWithParm( w_lista, sl_param )

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	idw_1.Retrieve(sl_param.field_ret[1])
	idw_1.ii_update 	= 0
	idw_1.ii_protect 	= 0
	idw_1.of_protect()
END IF
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'form') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_fl035_clien_general_v2
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
integer width = 2775
integer height = 760
string dataobject = "d_clientes_v2_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

choose case lower(as_columna)
		
	case "cliente"
		
		ls_sql = "SELECT PROVEEDOR AS CODIGO_CLIENTE, " &
				  + "NOM_PROVEEDOR AS DESCRIPCION " &
				  + "FROM PROVEEDOR " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cliente			[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.object.proveedor		[al_row] = ls_codigo
			this.ii_update = 1
		end if
	
	case "ubigeo_oficina"
		
		ls_sql = "SELECT UBIGEO_CODIGO AS CODIGO_UBI, " &
				  + "UBIGE_DESCRIPCION AS DESCR_UBIGEO " &
				  + "FROM TG_UBIGEO " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ubigeo_oficina	[al_row] = ls_codigo
			this.object.desc_ubigeo_1	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "ubigeo_planta"
		
		ls_sql = "SELECT UBIGEO_CODIGO AS CODIGO_UBI, " &
				  + "UBIGE_DESCRIPCION AS DESCR_UBIGEO " &
				  + "FROM TG_UBIGEO " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ubigeo_planta	[al_row] = ls_codigo
			this.object.desc_ubigeo_2	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose

end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle, 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)
ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = dw_master
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado[al_row] = '1'

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

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_codigo, ls_data
this.AcceptText()

if row <= 0 then
	return
end if

choose case lower(dwo.name)
	case "cliente"
		
		ls_codigo = this.object.cliente[row]

		SetNull(ls_data)
		select nom_proveedor
			into :ls_data
		from proveedor
		where proveedor = :ls_codigo
		  and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Aviso', "CODIGO DE PROVEEDOR NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.cliente			[row] = ls_codigo
			this.object.proveedor		[row] = ls_codigo
			this.object.nom_proveedor	[row] = ls_codigo
			return 1
		end if

		this.object.nom_proveedor		[row] = ls_data
		this.object.proveedor			[row] = ls_codigo

	case "ubigeo_oficina"
		
		ls_codigo = this.object.ubigeo_oficina[row]
		
		SetNull(ls_data)
		select ubige_descripcion
			into :ls_data
		from tg_ubigeo
		where ubigeo_codigo = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Aviso', "CODIGO DE UBIGEO NO EXISTE", StopSign!)
			SetNull(ls_codigo)
			this.object.ubigeo_oficina	[row] = ls_codigo
			this.object.desc_ubigeo_1	[row] = ls_codigo
			return 1
		end if
		
		this.object.desc_ubigeo_1	[row] = ls_data
		
	case "ubigeo_planta"
		
		ls_codigo = this.object.ubigeo_planta[row]
		
		SetNull(ls_data)
		select ubige_descripcion
			into :ls_data
		from tg_ubigeo
		where ubigeo_codigo = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Aviso', "CODIGO DE UBIGEO NO EXISTE", StopSign!)
			SetNull(ls_codigo)
			this.object.ubigeo_planta	[row] = ls_codigo
			this.object.desc_ubigeo_2	[row] = ls_codigo
			return 1
		end if
		
		this.object.desc_ubigeo_2	[row] = ls_data

end choose
end event

