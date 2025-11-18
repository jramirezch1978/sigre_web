$PBExportHeader$n_cst_sle.sru
forward
global type n_cst_sle from singlelineedit
end type
end forward

global type n_cst_sle from singlelineedit
integer width = 402
integer height = 112
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
event dobleclick pbm_lbuttondblclk
event keypress pbm_keyup
end type
global n_cst_sle n_cst_sle

event dobleclick;//boolean lb_ret
//string 	ls_codigo, ls_data, ls_sql
//
//ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
//		  + "nom_proveedor AS nombre_proveedor, " &
//		  + "ruc AS ruc_proveedor " &
//		  + "FROM proveedor " &
//		  + "where flag_Estado = '1'"
//		 
//lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
//
//if ls_codigo <> '' then
//	this.text = ls_codigo
//end if

end event

on n_cst_sle.create
end on

on n_cst_sle.destroy
end on

event modified;//String ls_null, ls_desc, ls_data, ls_mensaje
//
//SetNull( ls_null)
//ls_data = this.text
//
//if ls_data = "" then
//	ls_mensaje = "Debe Ingresar un código valido"
//	gnvo_log.of_errorlog( ls_mensaje )
//	gnvo_app.of_showmessagedialog( ls_mensaje)
//	this.setFocus()
//	return
//end if
//
//// Verifica que codigo ingresado exista			
//Select nombre
//	into :ls_desc
//	from usuario
//Where cod_usr = :ls_data
//  and flag_estado = '1';
//
//// Verifica que articulo solo sea de reposicion		
//if SQLCA.SQLCode = 100 then
//	ls_mensaje = "Código de usuario ingresado " + ls_data &
//				+ " no existe o no esta activo, por favor verifique"
//	gnvo_log.of_errorlog( ls_mensaje )
//	gnvo_app.of_showmessagedialog( ls_mensaje)
//
//	this.text =  ls_null
//	return 
//end if
//
//this.text = ls_desc
//		
//
end event

