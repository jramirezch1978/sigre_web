$PBExportHeader$sle_text.sru
forward
global type sle_text from singlelineedit
end type
end forward

global type sle_text from singlelineedit
integer width = 402
integer height = 112
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
event ue_keydwn pbm_keydown
event ue_display ( )
event ue_dblclick pbm_lbuttondblclk
end type
global sle_text sle_text

event ue_keydwn;if Key = KeyF2! then
	this.event dynamic ue_display()	
end if
end event

event ue_display();//// Asigna valores a structura 
//sg_parametros sl_param
//
//sl_param.dw1    = 'd_abc_lista_pd_ot_tbl'
//sl_param.titulo = "Partes Diario de Orden de Trabajo"
//sl_param.field_ret_i[1] = 1
//
//sl_param.tipo    = '1SQL'
//sl_param.string1 =  ' WHERE ("VW_OPE_PT_X_ADM"."COD_USR" = '+"'"+gs_user+"'"+')    '&
//						 +'ORDER BY "VW_OPE_PT_X_ADM"."NRO_PARTE" DESC  '
//
//
//OpenWithParm( w_lista, sl_param)
//
//sl_param = Message.PowerObjectParm
//IF sl_param.titulo <> 'n' THEN
//				
//	This.Text = sl_param.field_ret[1]
//	parent.event dynamic ue_retrieve()
//			
//END IF
//

//boolean lb_ret
//string ls_codigo, ls_data, ls_sql
//str_seleccionar lstr_seleccionar
//
//choose case upper(as_columna)
//		
//	case "UND"
//		
//		ls_sql = "SELECT UND AS CODIGO, " &
//				  + "DESC_UNIDAD AS DESCRIPCION " &
//				  + "FROM UNIDAD " 
//				 
//		lb_ret = f_lista(ls_sql, ls_codigo, &
//					ls_data, '1')
//		
//		if ls_codigo <> '' then
//			this.object.und[al_row] = ls_codigo
//			this.object.desc_und[al_row] = ls_data
//			this.ii_update = 1
//		end if
//		
//end choose
end event

event ue_dblclick;this.event dynamic ue_display()
end event

on sle_text.create
end on

on sle_text.destroy
end on

event modified;//string ls_codigo, ls_data
//
//ls_codigo = trim(this.text)
//
//SetNull(ls_data)
//select descr_especie
//	into :ls_data
//from tg_especies
//where especie = :ls_codigo;
//
//if ls_data = "" or IsNull(ls_data) then
//	Messagebox('Error', "CODIGO DE ESPECIE NO EXISTE", StopSign!)
//	this.text = ""
//	st_especie.text = ""
//	this.event dynamic ue_reset( )
//	return
//end if
//		
//st_especie.text = ls_data
//
//parent.event dynamic ue_retrieve()
end event

