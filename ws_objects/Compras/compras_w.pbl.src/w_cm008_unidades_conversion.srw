$PBExportHeader$w_cm008_unidades_conversion.srw
forward
global type w_cm008_unidades_conversion from w_abc_mastdet_smpl
end type
end forward

global type w_cm008_unidades_conversion from w_abc_mastdet_smpl
integer width = 3689
integer height = 2136
string title = "Unidades - Conversion [CM008]"
string menuname = "m_mantto_smpl"
boolean maxbox = false
end type
global w_cm008_unidades_conversion w_cm008_unidades_conversion

on w_cm008_unidades_conversion.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
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

event ue_open_pre;call super::ue_open_pre;f_centrar( this )
ii_pregunta_delete = 1
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cm008_unidades_conversion
integer x = 0
integer y = 0
integer width = 3552
integer height = 1164
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

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this )
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "cod_sunat"

		ls_sql = "select codigo as codigo_sunat, " &
				 + "descripcion as descripcion_sunat " &
				 + "from sunat_tabla6 " &
				 + "where flag_estado = '1'" 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_sunat	[al_row] = ls_codigo
			this.object.descripcion	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc

dw_master.Accepttext()
Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_art'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc
		  from sunat_tabla6
		 Where codigo = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Existencia de SUNAT no existe o no esta activo, por favor verifique")
			this.object.cod_sunat	[row] = gnvo_app.is_null
			this.object.descripcion	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.descripcion		[row] = ls_desc

END CHOOSE
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cm008_unidades_conversion
integer x = 0
integer y = 1172
integer width = 3552
integer height = 712
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

