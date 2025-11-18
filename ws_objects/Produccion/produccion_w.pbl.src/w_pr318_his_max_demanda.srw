$PBExportHeader$w_pr318_his_max_demanda.srw
forward
global type w_pr318_his_max_demanda from w_abc_master_smpl
end type
end forward

global type w_pr318_his_max_demanda from w_abc_master_smpl
integer width = 2318
integer height = 1740
string title = "Historico de Maximas Demandas(PR318)"
string menuname = "m_mantto_consulta"
end type
global w_pr318_his_max_demanda w_pr318_his_max_demanda

on w_pr318_his_max_demanda.create
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
end on

on w_pr318_his_max_demanda.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
//is_tabla = 'HISTORICO_MAX_DEMANDA'
ib_update_check = true
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr318_his_max_demanda
event ue_display ( string as_columna,  long al_row )
integer width = 2240
integer height = 1520
string dataobject = "d_abc_historico_max_demanda_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

//sg_parametros sl_param

choose case upper(as_columna)
		
		case "COD_ORIGEN"

		ls_sql = "SELECT COD_ORIGEN AS CODIGO, " &
				  + "NOMBRE AS DESCRIPCION " &
				  + "FROM ORIGEN " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_origen		[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
		case "COD_PLANTA"

		ls_sql = "SELECT to_char(COD_PLANTA) AS CODIGO_PLANTA, " &
				  + "DESC_PLANTA AS DESCRIPCION " &
				  + "FROM TG_PLANTAS " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_planta		[al_row] = ls_codigo
			this.object.desc_planta		[al_row] = ls_data
			this.ii_update = 1
		end if
					
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;//Cargamos Datos iniciales de configuración

dw_master.Setitem(al_row,"ano",YEAR(date(f_fecha_actual())))
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
//ii_ck[5] = 5
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

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null, ls_nro_parte
Long		ll_count, ll_cuenta, ll_detail
integer	li_item

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	
	case "cod_planta"
		
		ls_codigo = this.object.cod_planta[row]

		SetNull(ls_data)
		select desc_planta
			into :ls_data
		from tg_plantas
		where cod_planta = to_char(:ls_codigo)
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Planta no existe o no esta activa", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_planta	  	[row] = ls_codigo
			this.object.desc_planta		[row] = ls_codigo
			return 1
		end if

		this.object.desc_planta			[row] = ls_data
		
end choose
end event

