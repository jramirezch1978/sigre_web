$PBExportHeader$w_pr011_tg_plantas.srw
forward
global type w_pr011_tg_plantas from w_abc_master_smpl
end type
end forward

global type w_pr011_tg_plantas from w_abc_master_smpl
integer width = 3703
integer height = 992
string title = "[PR011] Plantas de Producción"
string menuname = "m_mantto_smpl"
end type
global w_pr011_tg_plantas w_pr011_tg_plantas

on w_pr011_tg_plantas.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr011_tg_plantas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_update_check = TRUE
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr011_tg_plantas
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
integer width = 3602
string dataobject = "d_abc_tg_plantas_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, ls_desc_cencos_r
Long		ll_row_find

str_parametros sl_param

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
		
end choose
end event

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
return 1
end event

event dw_master::itemerror;call super::itemerror;return 1
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
end choose
end event

