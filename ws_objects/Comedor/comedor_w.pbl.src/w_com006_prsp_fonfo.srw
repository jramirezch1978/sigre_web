$PBExportHeader$w_com006_prsp_fonfo.srw
forward
global type w_com006_prsp_fonfo from w_abc_master
end type
end forward

global type w_com006_prsp_fonfo from w_abc_master
integer width = 3648
integer height = 1076
string title = "Fondo de Comedores(COM006)"
string menuname = "m_mantto_consulta"
end type
global w_com006_prsp_fonfo w_com006_prsp_fonfo

on w_com006_prsp_fonfo.create
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
end on

on w_com006_prsp_fonfo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;//Oerride

IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
ELSE
	CLOSE(THIS)
END IF
end event

event ue_open_pre;call super::ue_open_pre;idw_1.Retrieve()
ii_help = 101            // help topic
ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)

ib_log = TRUE
//idw_query = dw_master
//is_tabla = 'COM_PART_PRSP_FONDO'

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
end event

event ue_modify;call super::ue_modify;dw_master.enabled = true
dw_master.of_protect( )
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing(dw_master, 'tabular') = false then
	return
	ib_update_check = false
end if

dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master`dw_master within w_com006_prsp_fonfo
event ue_display ( string as_columna,  long al_row )
integer width = 3557
integer height = 852
boolean enabled = false
string dataobject = "d_abc_com_part_prsp_fondo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, ls_desc_cencos_r
Long		ll_row_find

sg_parametros sl_param

choose case upper(as_columna)
		
		case "CENCOS"

		ls_sql = "SELECT CENCOS AS CODIGO_CENCOS, " &
				  + "DESC_CENCOS AS DESCRIPCION " &
				  + "FROM CENTROS_COSTO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if

case "COD_ORIGEN"

		ls_sql = "SELECT COD_ORIGEN AS CODIGO_ORIGEN, " &
				  + "NOMBRE AS DESCRIPCION " &
				  + "FROM ORIGEN " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_origen		[al_row] = ls_codigo
			this.object.origen	      [al_row] = ls_data
			this.ii_update = 1
		end if
		
		case "CNTA_PRSP"

		ls_sql = "SELECT CNTA_PRSP AS CODIGO, " &
				  + "DESCRIPCION AS DESC_CUENTA " &
				  + "FROM PRESUPUESTO_CUENTA " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_cnta      [al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event dw_master::constructor;call super::constructor;is_mastdet 	= 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                        //'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform 	= 'tabular'	// tabular, form (default)

ii_ck[1] 	= 1				// columnas de lectrua de este dw
idw_mst  	= dw_master

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data
Long		ll_count

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
		
	case "cencos"
		
		ls_codigo = this.object.cencos[row]

		SetNull(ls_data)
		select desc_cencos
			into :ls_data
		from centros_costo
		where cencos = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Centro de costo no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.cencos	  	[row] = ls_codigo
			this.object.desc_cencos	[row] = ls_codigo
			return 1
		end if

		this.object.desc_cencos		[row] = ls_data
		
		case "cod_origen"
		
		ls_codigo = this.object.cod_origen[row]

		SetNull(ls_data)
		select nombre
			into :ls_data
		from origen
		where cod_origen = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Origen no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_origen	  	[row] = ls_codigo
			this.object.origen			[row] = ls_codigo
			return 1
		end if

		this.object.origen				[row] = ls_data
		
		case "cnta_prsp"
		
		ls_codigo = this.object.cnta_prsp[row]

		SetNull(ls_data)
		select descripcion
			into :ls_data
		from presupuesto_cuenta
		where CNTA_PRSP = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Cuenta Presupuestal no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.cnta_prsp	  	   [row] = ls_codigo
			this.object.desc_cnta			[row] = ls_codigo
			return 1
		end if

		this.object.desc_cnta				[row] = ls_data
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;idw_1.enabled = true
end event

