$PBExportHeader$w_pr035_selecc_superv_pesad.srw
forward
global type w_pr035_selecc_superv_pesad from w_abc_master_smpl
end type
end forward

global type w_pr035_selecc_superv_pesad from w_abc_master_smpl
integer width = 2688
integer height = 1660
string title = "(PR035) Seleccionadora, Supervisora y Pesadora"
string menuname = "m_mantto_smpl"
end type
global w_pr035_selecc_superv_pesad w_pr035_selecc_superv_pesad

on w_pr035_selecc_superv_pesad.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr035_selecc_superv_pesad.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()
end event

event ue_open_pre;call super::ue_open_pre;ib_update_check = TRUE
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr035_selecc_superv_pesad
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
integer width = 2368
integer height = 1284
string dataobject = "d_selecc_superv_pesa_pck_grd"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, ls_desc_cencos_r
Long		ll_row_find

str_parametros sl_param

choose case lower(as_columna)
		
	case "seleccionadora"

		ls_sql = "select m.codigo as codigo_trabajador, " &
				 + "trim(nombre) as nom_trabajador " &
				 + "from vw_rrhh_codrel_maestro      m " &
				 + "where m.flag_estado = '1' " &
				 + "order by m.codigo "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.seleccionadora			[al_row] = ls_codigo
			this.object.nom_seleccionadora	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "supervisora"

		ls_sql = "select m.codigo as codigo_trabajador, " &
				 + "trim(nombre) as nom_trabajador " &
				 + "from vw_rrhh_codrel_maestro      m " &
				 + "where m.flag_estado = '1' " &
				 + "order by m.codigo "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.supervisora			[al_row] = ls_codigo
			this.object.nom_supervisora	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "pesadora"

		ls_sql = "select m.codigo as codigo_trabajador, " &
				 + "trim(nombre) as nom_trabajador " &
				 + "from vw_rrhh_codrel_maestro      m " &
				 + "where m.flag_estado = '1' " &
				 + "order by m.codigo "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.pesadora			[al_row] = ls_codigo
			this.object.nom_pesadora	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
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

event dw_master::itemchanged;call super::itemchanged;string 	ls_data, ls_null
Long		ll_count

this.AcceptText()

if row <= 0 then return

SetNull(ls_null)

choose case lower(dwo.name)
		
	case "seleccionadora"
		
		select trim(m.apel_paterno || ' ' || m.apel_materno || ', ' || m.nombre1 || ' ' || m.nombre2) 
			into :ls_data
		from maestro m
		where cod_trabajador = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Codigo de trabajador no existe o no esta activo", StopSign!)
			this.object.seleccionadora	  		[row] = ls_null
			this.object.nom_seleccionadora	[row] = ls_null
			return 1
		end if

		this.object.nom_seleccionadora		[row] = ls_data
		
	case "supervisora"
		
		select trim(m.apel_paterno || ' ' || m.apel_materno || ', ' || m.nombre1 || ' ' || m.nombre2) 
			into :ls_data
		from maestro m
		where cod_trabajador = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Codigo de trabajador no existe o no esta activo", StopSign!)
			this.object.supervisora	  		[row] = ls_null
			this.object.nom_supervisora	[row] = ls_null
			return 1
		end if

		this.object.nom_supervisora		[row] = ls_data

	case "pesadora"
		
		select trim(m.apel_paterno || ' ' || m.apel_materno || ', ' || m.nombre1 || ' ' || m.nombre2) 
			into :ls_data
		from maestro m
		where cod_trabajador = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Codigo de trabajador no existe o no esta activo", StopSign!)
			this.object.pesadora	  		[row] = ls_null
			this.object.nom_pesadora	[row] = ls_null
			return 1
		end if

		this.object.nom_pesadora		[row] = ls_data

end choose
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;idw_1.object.origen[al_row] = gs_origen
end event

