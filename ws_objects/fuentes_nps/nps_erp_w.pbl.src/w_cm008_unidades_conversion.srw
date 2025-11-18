$PBExportHeader$w_cm008_unidades_conversion.srw
forward
global type w_cm008_unidades_conversion from w_abc_mastdet_smpl
end type
end forward

global type w_cm008_unidades_conversion from w_abc_mastdet_smpl
integer width = 2761
integer height = 2284
string title = "Unidades - Conversion [CM008]"
boolean maxbox = false
end type
global w_cm008_unidades_conversion w_cm008_unidades_conversion

on w_cm008_unidades_conversion.create
int iCurrent
call super::create
end on

on w_cm008_unidades_conversion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

event ue_modify;call super::ue_modify;int li_protect_und, li_protect_und_conv


li_protect_und = integer(dw_master.Object.und.Protect)
IF li_protect_und = 0 THEN
	dw_master.Object.und.Protect = 1
END IF
		
li_protect_und_conv = integer(dw_detail.Object.und_conv.Protect)
IF li_protect_und_conv = 0 THEN
	dw_detail.Object.und_conv.Protect = 1
END IF

end event

event ue_open_pre;call super::ue_open_pre;//f_centrar( this )
ii_pregunta_delete = 1
end event

type p_pie from w_abc_mastdet_smpl`p_pie within w_cm008_unidades_conversion
end type

type ole_skin from w_abc_mastdet_smpl`ole_skin within w_cm008_unidades_conversion
end type

type uo_h from w_abc_mastdet_smpl`uo_h within w_cm008_unidades_conversion
end type

type st_box from w_abc_mastdet_smpl`st_box within w_cm008_unidades_conversion
end type

type phl_logonps from w_abc_mastdet_smpl`phl_logonps within w_cm008_unidades_conversion
end type

type p_mundi from w_abc_mastdet_smpl`p_mundi within w_cm008_unidades_conversion
end type

type p_logo from w_abc_mastdet_smpl`p_logo within w_cm008_unidades_conversion
end type

type st_horizontal from w_abc_mastdet_smpl`st_horizontal within w_cm008_unidades_conversion
end type

type st_filter from w_abc_mastdet_smpl`st_filter within w_cm008_unidades_conversion
end type

type uo_filter from w_abc_mastdet_smpl`uo_filter within w_cm008_unidades_conversion
end type

type dw_master from w_abc_mastdet_smpl`dw_master within w_cm008_unidades_conversion
integer x = 494
integer y = 280
integer width = 1541
integer height = 812
string dataobject = "d_abc_unidades_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

ib_delete_cascada = true
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve( aa_id[1])
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc
Long		ll_cod_sunat_id

dw_master.Accepttext()
this.Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_sunat'
		select desc_sunat, cod_sunat_id
		  into :ls_desc, :ll_cod_sunat_id
		from sunat_tablas_det t
		where t.nro_tabla = 6
		  and t.cod_sunat = :data
		  and t.flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Error', 'Codigo de Tabla ' + data + ' no existe en la tabla 6 de sunat o no se encuentra activo, por favor verifique')
			SetNull(ll_cod_sunat_id)
			this.object.cod_sunat 		[row] = ls_null
			this.object.desc_sunat 		[row] = ls_null
			this.object.cod_sunat_id	[row] = ll_cod_sunat_id
			
			return 1
		end if
		
		this.object.desc_sunat 		[row] = ls_Desc
		this.object.cod_sunat_id	[row] = ll_cod_sunat_id
		

END CHOOSE


end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this )
end event

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cod_sunat_id
Long		il_factor_sldo_total


choose case lower(as_columna)
		
	case "cod_sunat"
		
		// Tabla 12: tipo de operacion
		ls_sql = "select t.cod_sunat as cod_sunat, " &
				 + "t.desc_sunat as descripcion_sunat, " &
				 + "t.cod_sunat_id as cod_sunat_id " &
				 + "from SUNAT_TABLAS_DET t " &
				 + "where nro_tabla = 6 " & 
				 + "  and flag_estado = '1' " &
				 + "order by cod_sunat "
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_cod_sunat_id, '2')
		
		if ls_codigo <> '' then
			this.object.cod_sunat 		[al_row] = ls_codigo
			this.object.desc_sunat 		[al_row] = ls_data
			this.object.cod_sunat_id 	[al_row] = Long(ls_cod_sunat_id)
			this.ii_update = 1
		end if
		
end choose

end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cm008_unidades_conversion
integer x = 489
integer y = 1116
integer width = 1541
integer height = 536
string dataobject = "d_abc_unidades_conversion_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 1	      // columnas que recibimos del master

end event

event dw_detail::itemchanged;call super::itemchanged;//String ls_und_conversion
//
//This.GetText()
//This.AcceptText()
//
//If row > 0 then
//	Choose case dwo.name
//		Case 'und_conv'
//			ls_und_conversion = this.object.und_conv[row]
//			if ls_und_conversion ="" or isnull(ls_und_conversion) then
//				ii_update = 0
//				messagebox("Validación", "Ingrese la unidad de conversión")
//				this.setcolumn("und_conv")
//				this.setfocus()
//				return 1
//			End If
//	End choose
//End If
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(This)
end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

