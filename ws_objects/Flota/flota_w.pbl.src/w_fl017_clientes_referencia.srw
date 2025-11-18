$PBExportHeader$w_fl017_clientes_referencia.srw
forward
global type w_fl017_clientes_referencia from w_abc_master_smpl
end type
type st_1 from statictext within w_fl017_clientes_referencia
end type
end forward

global type w_fl017_clientes_referencia from w_abc_master_smpl
integer width = 2816
integer height = 1036
string title = "Matenimientos de datos de referencia laboral de clientes (FL017)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
st_1 st_1
end type
global w_fl017_clientes_referencia w_fl017_clientes_referencia

type variables

end variables

on w_fl017_clientes_referencia.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_fl017_clientes_referencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;

ii_lec_mst = 0

ii_help = 101            // help topic
ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
ib_log = TRUE
//is_tabla = 'Master'
//idw_query = dw_master

end event

event ue_dw_share;call super::ue_dw_share;string ls_proveedor, ls_nom_proveedor, ls_ruc

select max(cliente) into :ls_proveedor from fl_clientes;

dw_master.retrieve(ls_proveedor) //jalando al último cliente registrado

SELECT nom_proveedor, ruc INTO :ls_nom_proveedor, :ls_ruc FROM proveedor WHERE proveedor = :ls_proveedor;

IF LEN(TRIM(ls_ruc)) > 0 THEN
	ls_nom_proveedor = TRIM(ls_nom_proveedor)+' ('+TRIM(ls_ruc)+')'
ELSE
	ls_nom_proveedor = TRIM(ls_nom_proveedor)
END IF

dw_master.object.proveedor_t.text = ls_nom_proveedor
end event

event ue_insert_pos;call super::ue_insert_pos;
dw_master.event ue_carga_data ('Datos nuevos')
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_fl017_clientes_referencia
event ue_carga_data ( string as_estado )
integer x = 0
integer y = 0
integer width = 2757
integer height = 624
string dataobject = "d_cliente_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::ue_carga_data(string as_estado);string ls_proveedor, ls_nombre, ls_sql, ls_ubigeo_oficina, ls_ubigeo_planta, ls_ubigeo, ls_nom_proveedor, ls_ruc
long ll_row 
integer li_i, li_countcli
str_seleccionar lstr_seleccionar

this.AcceptText()
ll_row = this.getrow()
IF as_estado = 'Datos existentes' THEN
	ls_sql = "SELECT CODIGO AS IDENTIFICADOR, NOMBRE AS DESCRIPCION, RUC AS RUC FROM VW_FL_PROV_CLIENTE"
	messagebox('Datos existentes', ls_sql)
ELSE
	ls_sql = "SELECT CODIGO AS IDENTIFICADOR, NOMBRE AS DESCRIPCION, RUC AS RUC FROM VW_FL_PROV_CLIENTE_NON"
	messagebox('Datosnuevos', ls_sql)
END IF
lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S' //S SIMPLE Y M PARA MULTIPLE
OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	
IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_proveedor = lstr_seleccionar.param1[1]
	ls_nombre   = lstr_seleccionar.param2[1]
	ls_ruc = lstr_seleccionar.param3[1]
ELSE		
	IF Messagebox('Error', "DEBE SELECCIONAR UN PROVEEDOR", StopSign!, OkCancel!, 1) = 1 THEN
		IF as_estado = 'Datos existentes' THEN
			this.event ue_carga_data ('Datos existentes')
		ELSE
			this.event ue_carga_data ('Datos nuevos')
		END IF
	ELSE
		IF as_estado = 'Datos existentes' THEN
			RETURN
		ELSE
			CLOSE (PARENT)
			RETURN
		END IF
	END IF
end if	

SELECT count(cliente) INTO :li_countcli FROM fl_clientes WHERE cliente = :ls_proveedor;
IF as_estado = 'Datos existentes' THEN
	IF li_countcli = 0 THEN
		IF Messagebox('Error', "EL CLIENTE SELECCIONADO NO TIENE DATOS", StopSign!, OkCancel!, 1) = 1 THEN
			this.event ue_carga_data ('Datos existentes')
		ELSE
			RETURN
		END IF
	END IF
ELSE
	IF li_countcli <> 0 THEN
		IF Messagebox('Error', "EL CLIENTE SELECCIONADO YA HA SIDO REGISTRADO", StopSign!, OkCancel!, 1) = 1 THEN
			this.event ue_carga_data ('Datos nuevos')
		ELSE
			RETURN
		END IF
	END IF
END IF

dw_master.Retrieve(ls_proveedor)

this.object.cliente[ll_row] = ls_proveedor
this.object.proveedor[ll_row] = ls_proveedor

ls_ubigeo_planta = this.object.ubigeo_planta[ll_row]
ls_ubigeo_oficina = this.object.ubigeo_oficina[ll_row]
IF LEN(TRIM(ls_ubigeo_oficina)) = 0 OR LEN(TRIM(ls_ubigeo_planta)) = 0 THEN
	SELECT min(ubigeo_codigo) INTO :ls_ubigeo FROM tg_ubigeo;
	IF LEN(TRIM(ls_ubigeo_planta)) = 0 THEN
		this.object.ubigeo_planta[ll_row] = ls_ubigeo
	END IF
	IF LEN(TRIM(ls_ubigeo_oficina)) = 0 THEN
		this.object.ubigeo_oficina[ll_row] = ls_ubigeo
	END IF
END IF

SELECT nom_proveedor, ruc INTO :ls_nom_proveedor, :ls_ruc FROM proveedor WHERE proveedor = :ls_proveedor;

IF LEN(TRIM(ls_ruc)) > 0 THEN
	ls_nom_proveedor = TRIM(ls_nom_proveedor)+' ('+TRIM(ls_ruc)+')'
ELSE
	ls_nom_proveedor = TRIM(ls_nom_proveedor)
END IF

this.object.proveedor_t.text = ls_nom_proveedor
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::doubleclicked;call super::doubleclicked;this.event ue_carga_data ('Datos existentes')
end event

event dw_master::updateend;call super::updateend;this.of_protect()
end event

type st_1 from statictext within w_fl017_clientes_referencia
integer x = 41
integer y = 652
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

