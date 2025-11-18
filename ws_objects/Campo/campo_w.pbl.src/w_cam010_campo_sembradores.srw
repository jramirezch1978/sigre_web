$PBExportHeader$w_cam010_campo_sembradores.srw
forward
global type w_cam010_campo_sembradores from w_abc_mastdet_smpl
end type
end forward

global type w_cam010_campo_sembradores from w_abc_mastdet_smpl
integer width = 2688
integer height = 2004
string title = "[CAM010] Campos y sembradores"
string menuname = "m_abc_master_smpl"
end type
global w_cam010_campo_sembradores w_cam010_campo_sembradores

on w_cam010_campo_sembradores.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam010_campo_sembradores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_mastdet_smpl`dw_master within w_cam010_campo_sembradores
integer x = 0
integer y = 0
integer width = 2304
integer height = 968
string dataobject = "d_abc_campos_tbl"
end type

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "cencos"
		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
				  + "desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "centro_benef"
		ls_sql = "SELECT centro_benef AS centro_beneficio, " &
				  + "desc_Centro AS descripcion_centro_beneficio " &
				  + "FROM centro_beneficio " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.centro_benef	[al_row] = ls_codigo
			this.object.desc_centro		[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "representante"
		ls_sql = "SELECT proveedor AS codigo_representante, " &
				  + "nom_proveedor AS nombre_representante " &
				  + "FROM proveedor " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.representante		[al_row] = ls_codigo
			this.object.nom_representante	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "ubicacion"
		ls_sql = "SELECT ubicacion AS codigo_ubicacion, " &
				  + "desc_ubicacion AS descripcion_ubicacion " &
				  + "FROM ubicacion_campos "

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.ubicacion		[al_row] = ls_codigo
			this.object.desc_ubicacion	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "tipo_variedad"
		ls_sql = "SELECT tipo_variedad AS tipo_variedad, " &
				  + "desc_tipo_variedad AS descripcion_tipo_variedad " &
				  + "FROM cam_variedad_cultivo " &
				  + "where flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.tipo_variedad		[al_row] = ls_codigo
			this.object.desc_tipo_variedad[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'

this.object.has_totales [al_row] = 0
this.object.has_netas 	[al_row] = 0
this.object.has_cana 	[al_row] = 0
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
THIS.SetRow(currentrow)
THIS.Event ue_output(currentrow)

end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

//idw_det.ScrollToRow(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cam010_campo_sembradores
integer x = 0
integer y = 976
integer width = 2299
integer height = 728
string dataobject = "d_abc_campo_sembradores_tbl"
end type

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_detail::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "proveedor"
		ls_sql = "SELECT proveedor AS codigo_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor " &
				  + "FROM proveedor " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

