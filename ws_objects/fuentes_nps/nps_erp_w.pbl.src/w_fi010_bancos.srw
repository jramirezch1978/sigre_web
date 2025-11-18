$PBExportHeader$w_fi010_bancos.srw
forward
global type w_fi010_bancos from w_abc_master_smpl
end type
end forward

global type w_fi010_bancos from w_abc_master_smpl
integer width = 3163
integer height = 2032
string title = "[FI010] BANCOS"
string menuname = "m_mtto_smpl"
end type
global w_fi010_bancos w_fi010_bancos

on w_fi010_bancos.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_fi010_bancos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)
ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

dw_master.Retrieve( gnvo_app.invo_empresa.is_empresa)
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion ()
end event

type p_pie from w_abc_master_smpl`p_pie within w_fi010_bancos
end type

type ole_skin from w_abc_master_smpl`ole_skin within w_fi010_bancos
end type

type uo_h from w_abc_master_smpl`uo_h within w_fi010_bancos
end type

type st_box from w_abc_master_smpl`st_box within w_fi010_bancos
end type

type phl_logonps from w_abc_master_smpl`phl_logonps within w_fi010_bancos
end type

type p_mundi from w_abc_master_smpl`p_mundi within w_fi010_bancos
end type

type p_logo from w_abc_master_smpl`p_logo within w_fi010_bancos
end type

type st_filter from w_abc_master_smpl`st_filter within w_fi010_bancos
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_fi010_bancos
end type

type dw_master from w_abc_master_smpl`dw_master within w_fi010_bancos
integer y = 264
integer width = 2519
integer height = 1336
string dataobject = "d_abc_banco_tbl"
boolean hscrollbar = false
end type

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;Long   ll_count
String ls_null
Accepttext()


choose case dwo.name
	case 'proveedor'
		SELECT Count(*)
		  INTO :ll_count
		  FROM proveedor pr
		 WHERE (pr.proveedor   = :data ) and
				 (pr.flag_estado = '1'   ) ; 
				 
		
		IF ll_count = 0 THEN
			Messagebox('Aviso','Proveedor No Existe o no esta activo, Verifique!')
			setnull(ls_null)
			This.Object.proveedor [row] = ls_null
			Return 1
		END IF
end choose

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row (this)
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("cod_banco.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("nom_banco.Protect='1~tIf(IsRowNew(),0,1)'")

this.object.cod_empresa [al_row] = gnvo_app.invo_empresa.is_empresa
this.object.cod_origen 	[al_row] = gnvo_app.is_origen
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cat_art, &
			ls_cod_art, ls_proveedor, ls_moneda, ls_banco


choose case lower(as_columna)
		
	case "proveedor"
		ls_sql = "SELECT P.PROVEEDOR AS CODIGO , " &
				 + "P.NOM_PROVEEDOR AS DESCRIPCION, " &
				 + "RUC AS NRO_RUC "  &
				 + "FROM PROVEEDOR P " &
				 + "WHERE PROVEEDOR.FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	CASE 'cod_origen'
		ls_sql = "select distinct t.cod_origen as codigo_origen, " &
				 + "t.nombre as nombre_origen " &
				 + "from origen t, " &
				 + "user_empresa ue " &
				 + "where t.cod_origen = ue.cod_origen " &
				 + "and ue.cod_empresa = '" + gnvo_app.invo_empresa.is_empresa +"' " &
				 + "and t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_origen		[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose


end event

