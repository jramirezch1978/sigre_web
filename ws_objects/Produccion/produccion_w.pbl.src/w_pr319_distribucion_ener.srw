$PBExportHeader$w_pr319_distribucion_ener.srw
forward
global type w_pr319_distribucion_ener from w_abc_master_smpl
end type
end forward

global type w_pr319_distribucion_ener from w_abc_master_smpl
integer width = 2107
integer height = 944
string title = "Distribucion de Energía(PR319)"
string menuname = "m_mantto_consulta"
end type
global w_pr319_distribucion_ener w_pr319_distribucion_ener

on w_pr319_distribucion_ener.create
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
end on

on w_pr319_distribucion_ener.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
//is_tabla = 'PROD_ENER_DISTRIBUCION'
ib_update_check = true
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr319_distribucion_ener
event ue_display ( string as_columna,  long al_row )
integer width = 1993
integer height = 712
string dataobject = "d_prod_ener_distribucion"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

//sg_parametros sl_param

choose case upper(as_columna)
		
		case "COD_PLANTA"

		ls_sql = "SELECT COD_PLANTA AS CODIGO_PLANTA, " &
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
					
			case "NRO_CONSUMO"		
	
		ls_sql = "SELECT TO_CHAR(PC.NRO_CONSUMO) AS NRO_CONSUMO, TO_CHAR(PC.MES) AS MES, PC.COD_PLANTA, P.DESC_PLANTA, PC.COD_ORIGEN, PC.COD_USR " &
				  + "FROM PROD_CONSUMO_ENER PC, TG_PLANTAS P " &
				  + "WHERE P.COD_PLANTA = PC.COD_PLANTA " &
				  + "AND PC.COD_USR = '" + gs_user + "'"
				  		 
		lb_ret = f_lista(ls_sql, ls_codigo, &
				ls_data, '1')
		
if ls_codigo <> '' then
			this.object.nro_consumo		[al_row] = ls_codigo
			this.ii_update = 1
		end if
end choose
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                        //'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1
ii_ck[2] = 2 // columnas de lectrua de este dw

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
		
		case "nro_consumo"
		
		ls_codigo = this.object.nro_consumo[row]

		SetNull(ls_data)
		select cod_planta
			into :ls_data
		from prod_consumo_ener
		where nro_consumo = :ls_codigo;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Nro. De consumo no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.nro_consumo	  	[row] = ls_codigo
			return 1
		end if
		
	case "cod_planta"
		
		ls_codigo = this.object.cod_planta[row]

		SetNull(ls_data)
		select desc_planta
			into :ls_data
		from tg_plantas
		where cod_planta = :ls_codigo
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

event dw_master::itemerror;call super::itemerror;return 1
end event

