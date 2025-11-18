$PBExportHeader$n_cst_textbox.sru
forward
global type n_cst_textbox from singlelineedit
end type
end forward

global type n_cst_textbox from singlelineedit
integer width = 736
integer height = 108
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
event ue_dobleclick pbm_lbuttondblclk
end type
global n_cst_textbox n_cst_textbox

event ue_dobleclick;//boolean lb_ret
//string ls_codigo, ls_data, ls_sql
//
//ls_sql = "SELECT almacen AS CODIGO_almacen, " &
//	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
//	    + "FROM almacen " &
//		 + "where flag_tipo_almacen <> 'O'"
//				 
//lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
//		
//if ls_codigo <> '' then
//	this.text 			= ls_codigo
//	sle_descrip.text 	= ls_data
//end if
//
end event

on n_cst_textbox.create
end on

on n_cst_textbox.destroy
end on

event modified;//String 	ls_desc, ls_codigo
//
//ls_codigo = this.text
//if ls_codigo = '' or IsNull(ls_codigo) then
//	MessageBox('Aviso', 'Debe Ingresar un codigo de Cuadrilla')
//	return
//end if
//
//SELECT desc_cuadrilla 
//	INTO :ls_desc
//FROM TG_CUADRILLAS 
//where cod_cuadrilla = :ls_codigo ;
//
//
//IF SQLCA.SQLCode = 100 THEN
//	Messagebox('Aviso', 'Codigo de Cuadrilla no existe ')
//	return
//end if
//
//sle_desc_cuadrilla.text = ls_desc
end event

