$PBExportHeader$w_fl030_clien_general.srw
forward
global type w_fl030_clien_general from w_abc_master_smpl
end type
end forward

global type w_fl030_clien_general from w_abc_master_smpl
integer width = 2839
integer height = 1008
string title = "Clientes (FL030)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
end type
global w_fl030_clien_general w_fl030_clien_general

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

on w_fl030_clien_general.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl030_clien_general.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update;call super::ue_update;idw_1.update()
commit;
messagebox('', 'Registros guardados')
end event

event ue_open_pre;call super::ue_open_pre;long ll_row
string ls_ubigeo, ls_ubigeo_descripcion, ls_cadena

ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

ls_cadena = of_carga_data(1)
if ls_cadena <> '' then
	idw_1.Retrieve(left(ls_cadena,8))

	idw_1.object.t_empresa.text = right(ls_cadena,len(ls_Cadena)-8)
	
	ll_row = idw_1.getrow()
	ls_ubigeo = idw_1.object.ubigeo_oficina[ll_row]

	select tu.ubige_descripcion 
		into :ls_ubigeo_descripcion 
	from tg_ubigeo tu 
	where tu.ubigeo_codigo = :ls_ubigeo;
			
	idw_1.object.t_ubigeo_oficina.text = ls_ubigeo_descripcion 
	ls_ubigeo = idw_1.object.ubigeo_planta[ll_row]

	select tu.ubige_descripcion 
		into :ls_ubigeo_descripcion 
	from tg_ubigeo tu 
	where tu.ubigeo_codigo = :ls_ubigeo;
			
	idw_1.object.t_ubigeo_planta.text = ls_ubigeo_descripcion 
end if
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_fl030_clien_general
integer x = 0
integer y = 0
integer width = 2775
integer height = 700
string dataobject = "d_clientes_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle, 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)
ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = dw_master
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_cadena, ls_codigo, ls_desc
long ll_row
ll_row = this.getrow()
if dwo.name = 'cliente' then
	parent.event ue_dw_share()
end if
if ii_protect = 0 then
	if dwo.name = 'ubigeo_oficina' or dwo.name = 'ubigeo_planta' then
		ls_cadena = of_carga_dis()
		ls_codigo = left(ls_cadena,6)
		ls_desc = right(ls_cadena, len(ls_cadena)-6)
	end if
	if dwo.name = 'ubigeo_oficina' then
		this.object.ubigeo_oficina[ll_row] = ls_codigo
		this.object.t_ubigeo_oficina.text = ls_desc
	end if
	if dwo.name = 'ubigeo_planta' then
		this.object.ubigeo_planta[ll_row]  = ls_codigo
		this.object.t_ubigeo_planta.text = ls_desc
	end if

end if
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_cadena, ls_codigo, ls_empresa

this.object.t_ubigeo_oficina.text  = ''
this.object.t_ubigeo_planta.text = ''
ls_cadena = of_carga_data(0)

if ls_cadena <> '' then
	this.object.cliente[al_row] = left(ls_cadena,8)
	this.object.t_empresa.text = right(ls_cadena,len(ls_Cadena)-8)
else
	this.object.cliente[al_row] = ''
	this.object.t_empresa.text = ''
end if

end event

