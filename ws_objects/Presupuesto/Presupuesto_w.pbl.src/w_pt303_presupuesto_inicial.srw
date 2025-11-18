$PBExportHeader$w_pt303_presupuesto_inicial.srw
forward
global type w_pt303_presupuesto_inicial from w_abc_master
end type
type st_1 from statictext within w_pt303_presupuesto_inicial
end type
type em_year from editmask within w_pt303_presupuesto_inicial
end type
type st_2 from statictext within w_pt303_presupuesto_inicial
end type
type em_cencos from editmask within w_pt303_presupuesto_inicial
end type
type st_3 from statictext within w_pt303_presupuesto_inicial
end type
type em_cnta from editmask within w_pt303_presupuesto_inicial
end type
type cb_cencos from commandbutton within w_pt303_presupuesto_inicial
end type
type cb_cnta from commandbutton within w_pt303_presupuesto_inicial
end type
type cb_1 from commandbutton within w_pt303_presupuesto_inicial
end type
type cb_2 from commandbutton within w_pt303_presupuesto_inicial
end type
end forward

global type w_pt303_presupuesto_inicial from w_abc_master
integer width = 2610
integer height = 1900
string title = "Partidas presupuestales (PT303)"
string menuname = "m_mantenimiento_cl"
event ue_cancelar ( )
event ue_anular ( )
st_1 st_1
em_year em_year
st_2 st_2
em_cencos em_cencos
st_3 st_3
em_cnta em_cnta
cb_cencos cb_cencos
cb_cnta cb_cnta
cb_1 cb_1
cb_2 cb_2
end type
global w_pt303_presupuesto_inicial w_pt303_presupuesto_inicial

type variables

end variables

forward prototypes
public subroutine of_retrieve ()
public subroutine of_set_status_reg ()
public subroutine of_limpia_datos ()
end prototypes

event ue_cancelar();// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()

dw_master.ii_update = 0
is_action = ''
of_set_status_reg()

// Verifica que no pueda modificar
int li_protect

li_protect = integer(dw_master.Object.ano.Protect)
IF li_protect = 0 THEN
	dw_master.of_protect()
end if
of_limpia_datos()	
end event

event ue_anular();// Ancestor Script has been Override
string ls_estado
int li_protect

if dw_master.GetRow() = 0 then return

ls_estado = dw_master.object.flag_estado[dw_master.GetRow()]

if ls_estado = '0' then
	MessageBox('Aviso', 'No puede Anular un registro anulado')
	return
end if

if ls_estado = '2' then
	MessageBox('Aviso', 'No puede Anular un registro aprobado')
	return
end if

dw_master.object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1
is_action = 'anu'
of_set_status_reg()
end event

public subroutine of_retrieve ();Long ll_row, ln_ano

String ls_nro, ls_cencos, ls_cnta_prsp

Select ano, cencos, cnta_prsp into :ln_ano, :ls_cencos, :ls_cnta_prsp
   From presupuesto_partida where rownum = 1;

ll_row = dw_master.retrieve(ln_ano, ls_cencos, ls_cnta_prsp)
if ll_row = 0 then
	this.event ue_insert()
end if

of_set_status_reg()

return
end subroutine

public subroutine of_set_status_reg ();/*
  Funcion que verifica el status del documento
*/
//this.changemenu( m_mtto_imp_mail)

Int li_estado

// Activa todas las opciones
if is_flag_insertar = '1' then
	m_master.m_file.m_basedatos.m_insertar.enabled = true
else
	m_master.m_file.m_basedatos.m_insertar.enabled = false
end if

if is_flag_eliminar = '1' then
	m_master.m_file.m_basedatos.m_eliminar.enabled = true
else
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
end if

if is_flag_modificar = '1' then
	m_master.m_file.m_basedatos.m_modificar.enabled = true
else
	m_master.m_file.m_basedatos.m_modificar.enabled = false
end if

if is_flag_anular = '1' then
	m_master.m_file.m_basedatos.m_anular.enabled = true
else
	m_master.m_file.m_basedatos.m_anular.enabled = false
end if

if is_flag_cerrar = '1' then
	m_master.m_file.m_basedatos.m_cerrar.enabled = true
else
	m_master.m_file.m_basedatos.m_cerrar.enabled = false
end if

if is_flag_consultar = '1' then
	m_master.m_file.m_basedatos.m_abrirlista.enabled = true
else
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
end if


if dw_master.getrow() = 0 then return 

if is_Action = 'new' then
	// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_eliminar.enabled 		= false
	m_master.m_file.m_basedatos.m_modificar.enabled 	= false	
	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= false	
	m_master.m_file.m_printer.m_print1.enabled 			= false	
	m_master.m_file.m_basedatos.m_insertar.enabled 		= false	
	m_master.m_file.m_basedatos.m_anular.enabled 		= false

elseif is_Action = 'open' then
	
	li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])
	
	Choose case li_estado
		case 0		// Anulado			
		m_master.m_file.m_basedatos.m_eliminar.enabled  = false
		m_master.m_file.m_basedatos.m_modificar.enabled = false				
		m_master.m_file.m_basedatos.m_anular.enabled 	= false
		
	CASE 1   // Activo
		
	CASE 2   // no modificable
		m_master.m_file.m_basedatos.m_eliminar.enabled  = false
		m_master.m_file.m_basedatos.m_modificar.enabled = false		
		m_master.m_file.m_basedatos.m_anular.enabled 	= false
	end CHOOSE
	
elseif is_Action = 'edit' OR is_Action = 'anu' OR is_Action = 'del' then
	
	m_master.m_file.m_basedatos.m_eliminar.enabled   = false
	m_master.m_file.m_basedatos.m_modificar.enabled  = false	
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false	
	m_master.m_file.m_printer.m_print1.enabled 		 = false	
	m_master.m_file.m_basedatos.m_insertar.enabled   = false
	m_master.m_file.m_basedatos.m_anular.enabled 	 = false
	
end if

return 
end subroutine

public subroutine of_limpia_datos ();// Limpia los datos de busqueda
em_year.text = ''
em_cencos.text = ''
em_cnta.text = ''
end subroutine

on w_pt303_presupuesto_inicial.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
this.st_1=create st_1
this.em_year=create em_year
this.st_2=create st_2
this.em_cencos=create em_cencos
this.st_3=create st_3
this.em_cnta=create em_cnta
this.cb_cencos=create cb_cencos
this.cb_cnta=create cb_cnta
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_year
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_cencos
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.em_cnta
this.Control[iCurrent+7]=this.cb_cencos
this.Control[iCurrent+8]=this.cb_cnta
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.cb_2
end on

on w_pt303_presupuesto_inicial.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.st_2)
destroy(this.em_cencos)
destroy(this.st_3)
destroy(this.em_cnta)
destroy(this.cb_cencos)
destroy(this.cb_cnta)
destroy(this.cb_1)
destroy(this.cb_2)
end on

event ue_modify;call super::ue_modify;int 		li_protect
Long 		ll_row
string 	ls_estado

ll_row = dw_master.GetRow()
if ll_row = 0 then return

ls_estado = dw_master.object.flag_estado [ll_row]

if ls_estado = '0' or ls_estado = '2' then
	MessageBox('Aviso', 'No puede modificar partida presupuestal')
	dw_master.ii_protect = 0
	dw_master.of_protect()
	return
end if

li_protect = integer(dw_master.Object.ano.Protect)

IF li_protect = 0 THEN
   dw_master.Object.ano.Protect = 1
	dw_master.Object.cencos.Protect = 1
	dw_master.Object.cnta_prsp.Protect = 1
END IF
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then		
	return
end if
ib_update_check = True

dw_master.of_set_flag_replicacion()

end event

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
// ii_help = 101
f_centrar( this)
//of_retrieve()

idw_1 = dw_master
ib_log = TRUE

end event

event ue_delete;call super::ue_delete;is_action = 'del'
of_set_status_reg()
end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
this.event ue_update_request()
str_parametros sl_param

sl_param.dw1 = "d_lista_presupuesto_partida"
sl_param.titulo = "Partidas"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.field_ret_i[3] = 3

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then	
	// Se ubica la cabecera
	is_action = 'open'
	dw_master.retrieve(Long(sl_param.field_ret[1]), sl_param.field_ret[2], sl_param.field_ret[3])
	of_set_status_reg()
END IF
end event

type dw_master from w_abc_master`dw_master within w_pt303_presupuesto_inicial
event ue_display ( string as_columna,  long al_row )
integer y = 116
integer width = 2510
integer height = 1588
integer taborder = 70
string dataobject = "d_abc_presupuesto_inicial"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_tipo_prtda, ls_desc
Decimal	ldc_fondo

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
		
	case 'tipo_prtda_prsp'
		ls_sql = "SELECT TIPO_PRTDA_PRSP AS tipo_partida, " &
				  + "DESC_TIPO_PRSP AS descripcion_tipo_prtda, " &
				  + "GRP_PRTDA_PRSP as grp_tipo_partida " &
				  + "FROM tipo_prtda_prsp_det " &
				  + "WHERE flag_estado = '1'"
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_desc, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_prtda_prsp	[al_row] = ls_codigo
			this.object.desc_tipo_prsp		[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case 'fondo_var_aut'		
		ls_sql = "SELECT FONDO_VAR_AUT AS CODIGO_FONDO, " &
				 + "ANO_USO as ANO, " &
				 + "FONDO AS MONTO_FONDO, " &
				 + "ASIGNADO as MONTO_EJECUTADO " &
				 + "FROM fondo_var_aut " &
				 + "WHERE flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.fondo_var_aut		[al_row] = ls_codigo
			
			select fondo
				into :ldc_fondo
			from fondo_var_aut
			where fondo_var_aut = :ls_codigo;
			
			this.object.fondo	[al_row] = ldc_fondo
			this.ii_update = 1
		end if		
end choose

end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
ii_ck[1] = 1			// columnas de lectrua de este dw
end event

event dw_master::itemchanged;call super::itemchanged;String 		ls_desc, ls_estado, ls_null, ls_tipo_prtda, ls_desc2, ls_cencos, ls_cnta_prsp
Long 			ll_ano, ll_mes 
Decimal{2} 	ldc_fondo, ldc_monto, ldc_monto_mes 
Decimal{2} 	ldc_ene, ldc_feb, ldc_mar, ldc_abr, ldc_may, ldc_jun
Decimal{2} 	ldc_jul, ldc_ago, ldc_set, ldc_oct, ldc_nov, ldc_dic

// Datos antiguos antes de cambiar
ldc_ene = this.object.proy_ene[row]
ldc_feb = this.object.proy_feb[row]
ldc_mar = this.object.proy_mar[row]
ldc_abr = this.object.proy_abr[row]
ldc_may = this.object.proy_may[row]
ldc_jun = this.object.proy_jun[row]
ldc_jul = this.object.proy_jul[row]
ldc_ago = this.object.proy_ago[row]
ldc_set = this.object.proy_set[row]
ldc_oct = this.object.proy_oct[row]
ldc_nov = this.object.proy_nov[row]
ldc_dic = this.object.proy_dic[row]

This.AcceptText()

SetNull( ls_null)
// Verifica si existe
if dwo.name = "cencos" then	
	Select desc_cencos 
		into :ls_desc 
	from centros_costo 
	where cencos = :data
	  and flag_estado = '1';		
	  
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Centro de costo no existe o no est activo", Exclamation!)		
		this.object.cencos		[row] = ls_null
		this.object.desc_cencos	[row] = ls_null
		Return 1
	end if
	this.object.desc_cencos[row] = ls_desc
	
elseif dwo.name = "cnta_prsp" then	
	
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
	
elseif dwo.name = 'fondo_var_aut' then

	Select fondo 
		into :ldc_fondo
	from fondo_var_aut
	where fondo_var_aut = :data
	  and flag_estado = '1';
	  
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Fondo de Variacion automática no existe o no esta activa", Exclamation!)		
		SetNull(ldc_fondo)
		this.object.fondo_var_aut	[row] = ls_null
		this.object.fondo				[row] = ldc_fondo
		Return 1
	end if
	this.object.fondo [row] = ldc_fondo

elseif dwo.name = 'tipo_prtda_prsp' then

	Select DESC_TIPO_PRSP 
		into :ls_desc
	from tipo_prtda_prsp_det
	where TIPO_PRTDA_PRSP = :data
	  and flag_estado = '1';
	  
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Tipo de Partida Presupuestal no existe", Exclamation!)		
		this.object.tipo_prtda_prsp	[row] = ls_null
		this.object.desc_tipo_prsp		[row] = ls_null
		Return 1
	end if
	this.object.desc_tipo_prsp [row] = ls_desc

elseif dwo.name = 'proy_ene' then
	ldc_monto_mes = this.object.proy_ene[row] 
	ll_ano = this.object.ano[row] 
	ls_cencos = this.object.cencos[row] 
	ls_cnta_prsp = this.object.cnta_prsp[row] 
	ll_mes = 1
	
	SELECT NVL(sum(pd.cantidad*pd.costo_unit),0)
     INTO :ldc_monto 
     FROM presupuesto_det pd 
    WHERE pd.ano = :ll_ano AND 
          pd.cencos = :ls_cencos AND 
          pd.cnta_prsp = :ls_cnta_prsp AND 
          pd.mes_corresp = :ll_mes ;
			 
	IF ldc_monto<>0 THEN
		IF ldc_monto <> ldc_monto_mes THEN
			MessageBox('Aviso','Presupuesto Enero difiere de presupuesto detalle')
			this.object.proy_ene[row] = ldc_monto
			Return 1
		END IF 
	END IF 
	
elseif dwo.name = 'proy_feb' then
	ldc_monto_mes = this.object.proy_feb[row] 
	ll_ano = this.object.ano[row] 
	ls_cencos = this.object.cencos[row] 
	ls_cnta_prsp = this.object.cnta_prsp[row] 
	ll_mes = 2
	
	SELECT NVL(sum(pd.cantidad*pd.costo_unit),0)
     INTO :ldc_monto 
     FROM presupuesto_det pd 
    WHERE pd.ano = :ll_ano AND 
          pd.cencos = :ls_cencos AND 
          pd.cnta_prsp = :ls_cnta_prsp AND 
          pd.mes_corresp = :ll_mes ;
			 
	IF ldc_monto<>0 THEN
		IF ldc_monto <> ldc_monto_mes THEN
			MessageBox('Aviso','Presupuesto Febrero difiere de presupuesto detalle')
			this.object.proy_feb[row] = ldc_monto
			Return 1
		END IF 
	END IF 
elseif dwo.name = 'proy_mar' then
	ldc_monto_mes = this.object.proy_mar[row] 
	ll_ano = this.object.ano[row] 
	ls_cencos = this.object.cencos[row] 
	ls_cnta_prsp = this.object.cnta_prsp[row] 
	ll_mes = 3
	
	SELECT NVL(sum(pd.cantidad*pd.costo_unit),0)
     INTO :ldc_monto 
     FROM presupuesto_det pd 
    WHERE pd.ano = :ll_ano AND 
          pd.cencos = :ls_cencos AND 
          pd.cnta_prsp = :ls_cnta_prsp AND 
          pd.mes_corresp = :ll_mes ;
			 
	IF ldc_monto<>0 THEN
		IF ldc_monto <> ldc_monto_mes THEN
			MessageBox('Aviso','Presupuesto Marzo difiere de presupuesto detalle')
			this.object.proy_mar[row] = ldc_monto
			Return 1
		END IF 
	END IF 

elseif dwo.name = 'proy_abr' then
	ldc_monto_mes = this.object.proy_abr[row] 
	ll_ano = this.object.ano[row] 
	ls_cencos = this.object.cencos[row] 
	ls_cnta_prsp = this.object.cnta_prsp[row] 
	ll_mes = 4
	
	SELECT NVL(sum(pd.cantidad*pd.costo_unit),0)
     INTO :ldc_monto 
     FROM presupuesto_det pd 
    WHERE pd.ano = :ll_ano AND 
          pd.cencos = :ls_cencos AND 
          pd.cnta_prsp = :ls_cnta_prsp AND 
          pd.mes_corresp = :ll_mes ;
			 
	IF ldc_monto<>0 THEN
		IF ldc_monto <> ldc_monto_mes THEN
			MessageBox('Aviso','Presupuesto Abril difiere de presupuesto detalle')
			this.object.proy_abr[row] = ldc_monto
			Return 1
		END IF 
	END IF 
	
elseif dwo.name = 'proy_may' then
	ldc_monto_mes = this.object.proy_may[row] 
	ll_ano = this.object.ano[row] 
	ls_cencos = this.object.cencos[row] 
	ls_cnta_prsp = this.object.cnta_prsp[row] 
	ll_mes = 5
	
	SELECT NVL(sum(pd.cantidad*pd.costo_unit),0)
     INTO :ldc_monto 
     FROM presupuesto_det pd 
    WHERE pd.ano = :ll_ano AND 
          pd.cencos = :ls_cencos AND 
          pd.cnta_prsp = :ls_cnta_prsp AND 
          pd.mes_corresp = :ll_mes ;
			 
	IF ldc_monto<>0 THEN
		IF ldc_monto <> ldc_monto_mes THEN
			MessageBox('Aviso','Presupuesto Mayo difiere de presupuesto detalle')
			this.object.proy_may[row] = ldc_monto
			Return 1
		END IF 
	END IF 
elseif dwo.name = 'proy_jun' then
	ldc_monto_mes = this.object.proy_jun[row] 
	ll_ano = this.object.ano[row] 
	ls_cencos = this.object.cencos[row] 
	ls_cnta_prsp = this.object.cnta_prsp[row] 
	ll_mes = 6
	
	SELECT NVL(sum(pd.cantidad*pd.costo_unit),0)
     INTO :ldc_monto 
     FROM presupuesto_det pd 
    WHERE pd.ano = :ll_ano AND 
          pd.cencos = :ls_cencos AND 
          pd.cnta_prsp = :ls_cnta_prsp AND 
          pd.mes_corresp = :ll_mes ;
			 
	IF ldc_monto<>0 THEN
		IF ldc_monto <> ldc_monto_mes THEN
			MessageBox('Aviso','Presupuesto Junio difiere de presupuesto detalle')
			this.object.proy_jun[row] = ldc_monto
			Return 1
		END IF 
	END IF 
elseif dwo.name = 'proy_jul' then
	ldc_monto_mes = this.object.proy_jul[row] 
	ll_ano = this.object.ano[row] 
	ls_cencos = this.object.cencos[row] 
	ls_cnta_prsp = this.object.cnta_prsp[row] 
	ll_mes = 7
	
	SELECT NVL(sum(pd.cantidad*pd.costo_unit),0)
     INTO :ldc_monto 
     FROM presupuesto_det pd 
    WHERE pd.ano = :ll_ano AND 
          pd.cencos = :ls_cencos AND 
          pd.cnta_prsp = :ls_cnta_prsp AND 
          pd.mes_corresp = :ll_mes ;
			 
	IF ldc_monto<>0 THEN
		IF ldc_monto <> ldc_monto_mes THEN
			MessageBox('Aviso','Presupuesto Julio difiere de presupuesto detalle')
			this.object.proy_jul[row] = ldc_monto
			Return 1
		END IF 
	END IF 
	
elseif dwo.name = 'proy_ago' then
	ldc_monto_mes = this.object.proy_ago[row] 
	ll_ano = this.object.ano[row] 
	ls_cencos = this.object.cencos[row] 
	ls_cnta_prsp = this.object.cnta_prsp[row] 
	ll_mes = 8
	
	SELECT NVL(sum(pd.cantidad*pd.costo_unit),0)
     INTO :ldc_monto 
     FROM presupuesto_det pd 
    WHERE pd.ano = :ll_ano AND 
          pd.cencos = :ls_cencos AND 
          pd.cnta_prsp = :ls_cnta_prsp AND 
          pd.mes_corresp = :ll_mes ;
			 
	IF ldc_monto<>0 THEN
		IF ldc_monto <> ldc_monto_mes THEN
			MessageBox('Aviso','Presupuesto Agosto difiere de presupuesto detalle')
			this.object.proy_ago[row] = ldc_monto
			Return 1
		END IF 
	END IF 
elseif dwo.name = 'proy_set' then
	ldc_monto_mes = this.object.proy_set[row] 
	ll_ano = this.object.ano[row] 
	ls_cencos = this.object.cencos[row] 
	ls_cnta_prsp = this.object.cnta_prsp[row] 
	ll_mes = 9
	
	SELECT NVL(sum(pd.cantidad*pd.costo_unit),0)
     INTO :ldc_monto 
     FROM presupuesto_det pd 
    WHERE pd.ano = :ll_ano AND 
          pd.cencos = :ls_cencos AND 
          pd.cnta_prsp = :ls_cnta_prsp AND 
          pd.mes_corresp = :ll_mes ;
			 
	IF ldc_monto<>0 THEN
		IF ldc_monto <> ldc_monto_mes THEN
			MessageBox('Aviso','Presupuesto Setiembre difiere de presupuesto detalle')
			this.object.proy_set[row] = ldc_monto
			Return 1
		END IF 
	END IF 

elseif dwo.name = 'proy_oct' then
	ldc_monto_mes = this.object.proy_oct[row] 
	ll_ano = this.object.ano[row] 
	ls_cencos = this.object.cencos[row] 
	ls_cnta_prsp = this.object.cnta_prsp[row] 
	ll_mes = 10
	
	SELECT NVL(sum(pd.cantidad*pd.costo_unit),0)
     INTO :ldc_monto 
     FROM presupuesto_det pd 
    WHERE pd.ano = :ll_ano AND 
          pd.cencos = :ls_cencos AND 
          pd.cnta_prsp = :ls_cnta_prsp AND 
          pd.mes_corresp = :ll_mes ;
			 
	IF ldc_monto<>0 THEN
		IF ldc_monto <> ldc_monto_mes THEN
			MessageBox('Aviso','Presupuesto Octubre difiere de presupuesto detalle')
			this.object.proy_oct[row] = ldc_monto
			Return 1
		END IF 
	END IF 
	
elseif dwo.name = 'proy_nov' then
	ldc_monto_mes = this.object.proy_nov[row] 
	ll_ano = this.object.ano[row] 
	ls_cencos = this.object.cencos[row] 
	ls_cnta_prsp = this.object.cnta_prsp[row] 
	ll_mes = 11
	
	SELECT NVL(sum(pd.cantidad*pd.costo_unit),0)
     INTO :ldc_monto 
     FROM presupuesto_det pd 
    WHERE pd.ano = :ll_ano AND 
          pd.cencos = :ls_cencos AND 
          pd.cnta_prsp = :ls_cnta_prsp AND 
          pd.mes_corresp = :ll_mes ;
			 
	IF ldc_monto<>0 THEN
		IF ldc_monto <> ldc_monto_mes THEN
			MessageBox('Aviso','Presupuesto Noviembre difiere de presupuesto detalle')
			this.object.proy_nov[row] = ldc_monto
			Return 1
		END IF 
	END IF 
elseif dwo.name = 'proy_dic' then
	ldc_monto_mes = this.object.proy_dic[row] 
	ll_ano = this.object.ano[row] 
	ls_cencos = this.object.cencos[row] 
	ls_cnta_prsp = this.object.cnta_prsp[row] 
	ll_mes = 12
	
	SELECT NVL(sum(pd.cantidad*pd.costo_unit),0)
     INTO :ldc_monto 
     FROM presupuesto_det pd 
    WHERE pd.ano = :ll_ano AND 
          pd.cencos = :ls_cencos AND 
          pd.cnta_prsp = :ls_cnta_prsp AND 
          pd.mes_corresp = :ll_mes ;
			 
	IF ldc_monto<>0 THEN
		IF ldc_monto <> ldc_monto_mes THEN
			MessageBox('Aviso','Presupuesto Diciembre difiere de presupuesto detalle')
			this.object.proy_dic[row] = ldc_monto
			Return 1
		END IF 
	END IF 
	
END IF



end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;//this.object.flag_ingr_egr[al_row] = 'I'
this.object.proy_ene[al_row] = 0
this.object.proy_feb[al_row] = 0
this.object.proy_mar[al_row] = 0
this.object.proy_abr[al_row] = 0
this.object.proy_may[al_row] = 0
this.object.proy_jun[al_row] = 0
this.object.proy_jul[al_row] = 0
this.object.proy_ago[al_row] = 0
this.object.proy_set[al_row] = 0
this.object.proy_oct[al_row] = 0
this.object.proy_nov[al_row] = 0
this.object.proy_dic[al_row] = 0

this.object.cod_usr					[al_row] = gs_user
this.object.flag_ingr_egr			[al_row] = 'E'
this.object.flag_estado				[al_row] = '1'
this.object.flag_ctrl				[al_row] = '5'  // Por defecto es semestral
this.object.flag_tipo_compromiso	[al_row] = 'C'  // Por defecto comprometido

is_action = 'new'
of_set_status_reg()
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
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

type st_1 from statictext within w_pt303_presupuesto_inicial
integer x = 23
integer y = 20
integer width = 142
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_year from editmask within w_pt303_presupuesto_inicial
integer x = 178
integer y = 8
integer width = 210
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_2 from statictext within w_pt303_presupuesto_inicial
integer x = 416
integer y = 20
integer width = 325
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro Costo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_cencos from editmask within w_pt303_presupuesto_inicial
integer x = 750
integer y = 8
integer width = 302
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_3 from statictext within w_pt303_presupuesto_inicial
integer x = 1138
integer y = 20
integer width = 320
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cuenta Pres.:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_cnta from editmask within w_pt303_presupuesto_inicial
integer x = 1477
integer y = 12
integer width = 343
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_cencos from commandbutton within w_pt303_presupuesto_inicial
integer x = 1065
integer y = 8
integer width = 73
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_year

ls_year = trim(em_year.text)

if ls_year = '' or IsNull(ls_year) then
	MessageBox('Aviso', 'Debe especificar un año')
	return
end if

ls_sql = "select distinct b.cencos as codigo_cencos, " &
		 + "b.desc_cencos as descripcion_cencos " &
		 + "from presupuesto_partida a, " &
		 + "centros_costo b " &
		 + "where a.cencos = b.cencos " &
		 + "and a.ano = " + ls_year
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_cencos.text = ls_codigo
end if

end event

type cb_cnta from commandbutton within w_pt303_presupuesto_inicial
integer x = 1833
integer y = 8
integer width = 73
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_year, ls_cencos

ls_year = trim(em_year.text)

if ls_year = '' or IsNull(ls_year) then
	MessageBox('Aviso', 'Debe especificar un año')
	return
end if

ls_cencos = trim(em_cencos.text)

if ls_cencos = '' or IsNull(ls_cencos) then
	MessageBox('Aviso', 'Debe especificar un centro de costo')
	return
end if

ls_sql = "select distinct b.cnta_prsp as codigo_cnta_prsp, " &
		 + "b.descripcion as descripcion_cnta_prsp " &
		 + "from presupuesto_partida a, " &
		 + "presupuesto_cuenta b " &
		 + "where a.cnta_prsp = b.cnta_prsp " &
		 + "and a.cencos = '" + ls_cencos + "' " &
		 + "and a.ano = " + ls_year
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

if ls_codigo <> '' then
	em_cnta.text = ls_codigo
end if
end event

type cb_1 from commandbutton within w_pt303_presupuesto_inicial
integer x = 1947
integer y = 8
integer width = 261
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;if em_year.text = '' then
	MessageBox('Aviso', 'Debe especificar un año')
	return
end if

if em_cencos.text = '' then
	MessageBox('Aviso', 'Debe especificar un Centro de Costo')
	return
end if

if em_cnta.text = '' then
	MessageBox('Aviso', 'Debe especificar una Cuenta Presupuestal')
	return
end if

dw_master.retrieve(Long(em_year.text), em_cencos.text, em_cnta.text)
cb_2.TriggerEvent(Constructor!)

of_limpia_datos()
of_set_status_reg()
end event

type cb_2 from commandbutton within w_pt303_presupuesto_inicial
boolean visible = false
integer x = 2254
integer y = 8
integer width = 261
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Activa"
end type

event constructor;Long ll_row
String ls_estado

ll_row = dw_master.GetRow()

IF ll_row = 0 THEN
	RETURN 0
ELSE
	ls_estado = dw_master.object.flag_estado[ll_row]
	IF ls_estado = '0' THEN
		cb_2.visible=true
		cb_2.enabled=true
		return 1
	END IF 
END IF 
	

end event

event clicked;Long ll_row, ll_count, ll_ok
String ls_estado, ls_cencos, ls_cnta_presup

ll_row = dw_master.GetRow()

IF ll_row = 0 THEN
	RETURN 0
ELSE
	// Valida si centro de costo y cuenta presupuestal esta activo
	ls_cencos = dw_master.object.cencos[ll_row]
	ls_cnta_presup = dw_master.object.cnta_prsp[ll_row]
	
	SELECT count(*) 
	  INTO :ll_count 
	  FROM centros_costo c 
	 WHERE c.cencos=:ls_cencos and c.flag_estado='1' ;
	
	IF ll_count = 0 THEN
		MessageBox('Aviso', 'Centro de costo no esta activo')
		Return 0
	END IF 

	SELECT count(*) 
	INTO :ll_count 
	  FROM presupuesto_cuenta p 
	 WHERE p.cnta_prsp=:ls_cnta_presup and p.flag_estado='1' ;
	
	IF ll_count = 0 THEN
		MessageBox('Aviso', 'Cuenta presupuestal no esta activa')
		Return 0
	END IF 
	
	ls_estado = dw_master.object.flag_estado[ll_row]
	IF ls_estado = '0' THEN 
		ll_ok = MessageBox('Aviso', 'Desea activar partida presupuestal', Exclamation!, YesNo!, 2)

		IF ll_ok = 1 THEN
			dw_master.object.flag_estado[ll_row] = '1'
			dw_master.ii_update = 1
		ELSE
			Return 0
		END IF
	END IF 
END IF 
end event

