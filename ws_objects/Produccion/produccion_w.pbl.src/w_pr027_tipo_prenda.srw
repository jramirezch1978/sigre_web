$PBExportHeader$w_pr027_tipo_prenda.srw
forward
global type w_pr027_tipo_prenda from w_abc_master_smpl
end type
end forward

global type w_pr027_tipo_prenda from w_abc_master_smpl
integer width = 1806
integer height = 1000
string title = "Tipo de Prenda(PR027) "
string menuname = "m_mantto_smpl"
end type
global w_pr027_tipo_prenda w_pr027_tipo_prenda

on w_pr027_tipo_prenda.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr027_tipo_prenda.destroy
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

type dw_master from w_abc_master_smpl`dw_master within w_pr027_tipo_prenda
event ue_display ( string as_columna,  long al_row )
integer width = 1714
string dataobject = "d_tipo_prenda_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);//boolean 	lb_ret
//string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
//			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, ls_desc_cencos_r
//Long		ll_row_find
//
//sg_parametros sl_param
//
//choose case upper(as_columna)
//		
//		case "COD_PROD"
//
//		ls_sql = "SELECT cod_art AS CODIGO_ARTICULO, " &
//				  + "DESC_ART AS DESCRIPCION " &
//				  + "FROM ARTICULO " &
//				  + "WHERE FLAG_ESTADO = '1'"
//				 
//		lb_ret = f_lista(ls_sql, ls_codigo, &
//					ls_data, '2')
//		
//		if ls_codigo <> '' then
//			this.object.cod_prod		[al_row] = ls_codigo
//			this.object.desc_prod	[al_row] = ls_data
//			this.object.cod_art		[al_row] = ls_codigo
//			this.object.desc_art		[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
//case "UNIDAD"
//
//		ls_sql = "SELECT und AS CODIGO_UNIDAD, " &
//				  + "DESC_UNIDAD AS DESCRIPCION " &
//				  + "FROM UNIDAD " &
//				  + "WHERE FLAG_ESTADO = '1'"
//				 
//		lb_ret = f_lista(ls_sql, ls_codigo, &
//					ls_data, '2')
//		
//		if ls_codigo <> '' then
//			this.object.unidad				[al_row] = ls_codigo
//			this.object.desc_unidad	      [al_row] = ls_data
//			this.ii_update = 1
//		end if
//		
//end choose
end event

event dw_master::doubleclicked;call super::doubleclicked;//string 	ls_columna
//long		ll_row
//
//this.Accepttext( )
//IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
//ll_row = row
//
//If ll_row > 0 Then
//	ls_columna = upper(dwo.name)
//	This.event dynamic ue_display(ls_columna, ll_row)
//end if
end event

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
return 1
end event

event dw_master::itemchanged;call super::itemchanged;//string 	ls_codigo, ls_data
//Long		ll_count
//
//this.AcceptText()
//
//if row <= 0 then return
//
//choose case lower(dwo.name)
//		
//	case "cod_art"
//		
//		ls_codigo = this.object.cod_art[row]
//
//		SetNull(ls_data)
//		select desc_art
//			into :ls_data
//		from articulo
//		where cod_art = :ls_codigo
//		  and flag_estado = '1';
//		
//		if SQLCA.SQLCode = 100 then
//			Messagebox('Error', "Articulo no existe o no esta activo", StopSign!)
//			SetNull(ls_codigo)
//			this.object.cod_art	  	[row] = ls_codigo
//			this.object.desc_art		[row] = ls_codigo
//			return 1
//		end if
//
//		this.object.desc_art		[row] = ls_data
//		
//		case "unidad"
//		
//		ls_codigo = this.object.unidad[row]
//
//		SetNull(ls_data)
//		select desc_unidad
//			into :ls_data
//		from unidad
//		where und = :ls_codigo
//		  and flag_estado = '1';
//		
//		if SQLCA.SQLCode = 100 then
//			Messagebox('Error', "Unidad no existe o no esta activo", StopSign!)
//			SetNull(ls_codigo)
//			this.object.unidad		  	[row] = ls_codigo
//			this.object.desc_unidad		[row] = ls_codigo
//			return 1
//		end if
//
//		this.object.desc_unidad			[row] = ls_data
//end choose
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

