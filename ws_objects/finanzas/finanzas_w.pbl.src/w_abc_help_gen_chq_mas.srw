$PBExportHeader$w_abc_help_gen_chq_mas.srw
forward
global type w_abc_help_gen_chq_mas from window
end type
type dw_1 from u_dw_list_tbl within w_abc_help_gen_chq_mas
end type
type cb_1 from commandbutton within w_abc_help_gen_chq_mas
end type
end forward

global type w_abc_help_gen_chq_mas from window
integer width = 1568
integer height = 468
boolean titlebar = true
string title = "Seleccione Documento a Visualizar"
windowtype windowtype = response!
long backcolor = 67108864
dw_1 dw_1
cb_1 cb_1
end type
global w_abc_help_gen_chq_mas w_abc_help_gen_chq_mas

on w_abc_help_gen_chq_mas.create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.Control[]={this.dw_1,&
this.cb_1}
end on

on w_abc_help_gen_chq_mas.destroy
destroy(this.dw_1)
destroy(this.cb_1)
end on

event open;str_parametros lstr_param

IF isvalid(message.PowerObjectParm) THEN
   lstr_param = message.PowerObjectParm
	IF lstr_param.opcion = 1 THEN //Doc Pendientes Cta Cte
		dw_1.dataobject = 'd_abc_help_doc_pend_tbl'
	ELSE									  //Cuentas x Pagar	
		dw_1.dataobject = 'd_abc_help_cntas_pagar_tbl'	
	END IF
	
	dw_1.SettransObject(sqlca)
   dw_1.Retrieve(lstr_param.string1)
END IF
//**//



end event

type dw_1 from u_dw_list_tbl within w_abc_help_gen_chq_mas
integer x = 27
integer y = 4
integer width = 965
integer height = 336
integer taborder = 30
boolean hscrollbar = false
end type

event constructor;call super::constructor;ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1          // columnas de lectrua de este dw

end event

type cb_1 from commandbutton within w_abc_help_gen_chq_mas
integer x = 1147
integer y = 16
integer width = 357
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;Long    ll_inicio
String  ls_cadena
str_parametros lstr_param
boolean lb_result



IF dw_1.Rowcount () > 0 THEN
	FOR ll_inicio = 1 TO dw_1.Rowcount()
		 lb_result = dw_1.IsSelected(ll_inicio)		
		 IF lb_result THEN
			 ls_cadena = ls_cadena +", '" +dw_1.Object.tipo_doc [ll_inicio]+"'"
		 END IF
	NEXT

	IF Isnull(ls_cadena) OR Trim(ls_cadena) = '' THEN
		Messagebox('Aviso','Debe Seleccionar Algun Documento , Verifique !')
		Return
	END IF

	lstr_param.String2 = '('+Mid(ls_cadena,2)+')'

ELSE
	lstr_param.String2 = ''
END IF


CloseWithReturn(Parent,lstr_param)


end event

