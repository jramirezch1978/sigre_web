$PBExportHeader$w_rh032_abc_area_seccion.srw
forward
global type w_rh032_abc_area_seccion from w_abc_mastdet_smpl
end type
end forward

global type w_rh032_abc_area_seccion from w_abc_mastdet_smpl
integer width = 2821
integer height = 2392
string title = "(RH032) Areas y Secciones"
string menuname = "m_master_simple"
end type
global w_rh032_abc_area_seccion w_rh032_abc_area_seccion

type variables
Integer ii_dw_upd
end variables

on w_rh032_abc_area_seccion.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh032_abc_area_seccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)


end event

event ue_print;call super::ue_print;idw_1.print()
end event

event ue_modify();call super::ue_modify;int li_protect 
li_protect = integer(dw_detail.Object.cod_area.Protect)

//Porteccion del cod area 
If li_protect = 0 Then
	dw_detail.Object.cod_area.Protect = 1
End if 


	

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
dw_detail.of_set_flag_replicacion( )
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_rh032_abc_area_seccion
integer x = 0
integer y = 0
integer width = 2469
integer height = 916
string dataobject = "d_area_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1            //colunmna de pase de parametros

ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::clicked;call super::clicked;ii_dw_upd =1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;//Validacion de ingreso de filas 
dw_master.Modify("cod_area.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cod_jefe_area.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("desc_area.Protect='1~tIf(IsRowNew(),0,1)'")



end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'cod_jefe_area'
		ls_sql = "select cod_relacion as codigo, nombre as descripcion from codigo_relacion where flag_tabla = 'M'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.cod_jefe_area[row] = ls_return1
		this.object.nombre[row] = ls_return2
		this.ii_update = 1
end choose


end event

event dw_master::itemchanged;call super::itemchanged;string ls_col, ls_sql, ls_return1, ls_return2

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'cod_jefe_area'
		select cod_relacion, nombre 
			into :ls_return1, :ls_return2
			from codigo_relacion 
			where flag_tabla = 'M'
				and cod_relacion = :data;
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, 'No existe el codigo para el Jefe de Área')
			setnull(ls_return1)			
			setnull(ls_return2)
		end if

		this.object.cod_jefe_area[row] = ls_return1
		this.object.nombre[row] = ls_return2
		return 2
end choose
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_rh032_abc_area_seccion
integer x = 0
integer y = 928
integer width = 2469
integer height = 1176
string dataobject = "d_seccion_tbl"
end type

event dw_detail::constructor;call super::constructor;//Forma parte del pK
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
//Variable de pase de Parametros
ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::clicked;call super::clicked;ii_dw_upd = 2
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;int li_protect 
li_protect = integer(dw_detail.object.cod_area.Protect)

//Proteccion del cod area 
If li_protect = 0 Then
	dw_detail.Object.cod_area.Protect = 1
End if

//Validacion al ingresar un registro
dw_detail.Modify("cod_seccion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("cod_jefe_seccion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("desc_seccion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("porc_sctr_ipss.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("porc_sctr_onp.Protect='1~tIf(IsRowNew(),0,1)'")

end event

event dw_detail::itemchanged;call super::itemchanged;string ls_cod_seccion, ls_cod_area, ls_desc_seccion
string ls_primer
decimal ldc_ipss, ldc_onp


dw_detail.AcceptText ( )
choose case dwo.name 
	case 'cod_seccion'
      //Consigue texto
		dw_detail.GetText()
		
		ls_cod_seccion=Trim(dw_detail.GetItemString(row,"cod_seccion"))
		If Len(ls_cod_seccion) <> 3 Then
			Messagebox("Validacion","El CODIGO SECCION es de 3 DIGITOS")
			dw_detail.SetColumn("cod_seccion")
			dw_detail.SetFocus()
			return 1 
		End if 
	   
//		ls_primer=left(ls_cod_Seccion,1)
//		ls_Cod_area = dw_detail.GetItemString(row,"cod_area")
//		If ls_primer <> ls_cod_area Then
//			Messagebox("Validacion","El Primer DIGITO de la SECCION es igual al CODIGO "+&
//			           "AREA")
//			dw_detail.SetColumn("cod_seccion")
//			dw_detail.SetFocus()
//			return 1
//		End if 
	
	case 'desc_seccion'

		dw_detail.GetText()
		
		ls_desc_seccion=Trim(dw_detail.GetItemString(row,"desc_seccion"))
		If isnull(ls_desc_seccion) Then
			Messagebox("validacion","INGRESE una DESCRIPCION a la SECCION")
			dw_detail.SetColumn("desc_Seccion")
			dw_detail.Setfocus()
			return 1
		End if 	
	
   case 'porc_sctr_ipss'
		dw_detail.GetText()

		ldc_ipss = dw_detail.GetItemDecimal(row,"porc_sctr_ipss")
		If ldc_ipss < 0 or ldc_ipss >= 100 Then
			Messagebox("Validacion","El PORCENTAJE esta entre [0 - 100>")
			dw_detail.SetColumn("porc_sctr_ipss")
			dw_detail.SetFocus()
			return 1
		End if 	
		
	case 'porc_sctr_onp'
		
		dw_detail.GetText()
		
		ldc_onp = dw_detail.GetItemDecimal(row,"porc_sctr_onp")
		If ldc_onp < 0 or ldc_onp >= 100 Then
			Messagebox("Validacion","EL PORCENTAJE esta entre [0 - 100>")  
			dw_detail.setColumn("porc_sctr_onp")
			dw_detail.SetFocus()
			return 1
      End if 	
		
end choose 	
end event

