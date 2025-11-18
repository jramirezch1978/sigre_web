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

type ole_skin from w_abc_mastdet_smpl`ole_skin within w_cm008_unidades_conversion
end type

type st_horizontal from w_abc_mastdet_smpl`st_horizontal within w_cm008_unidades_conversion
end type

type st_filter from w_abc_mastdet_smpl`st_filter within w_cm008_unidades_conversion
end type

type uo_filter from w_abc_mastdet_smpl`uo_filter within w_cm008_unidades_conversion
end type

type uo_h from w_abc_mastdet_smpl`uo_h within w_cm008_unidades_conversion
end type

type st_box from w_abc_mastdet_smpl`st_box within w_cm008_unidades_conversion
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

event dw_master::itemchanged;call super::itemchanged;//String ls_und
//
//this.GetText()
//This.AcceptText()
//
//If row > 0 then
//	Choose case dwo.name
//		Case 'und'
//			ls_und = this.object.und[row]
//			if ls_und ="" or isnull(ls_und) then
//				ii_update = 0
//				messagebox("Validación", "Ingrese la unidad")
//				this.setcolumn("und")
//				this.setfocus()
//				return 1
//			End If
//	End choose
//End If
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this )
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

