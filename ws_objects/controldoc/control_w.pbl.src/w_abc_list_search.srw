$PBExportHeader$w_abc_list_search.srw
forward
global type w_abc_list_search from w_abc_list
end type
type st_1 from statictext within w_abc_list_search
end type
type dw_3 from datawindow within w_abc_list_search
end type
type cb_1 from commandbutton within w_abc_list_search
end type
end forward

global type w_abc_list_search from w_abc_list
st_1 st_1
dw_3 dw_3
cb_1 cb_1
end type
global w_abc_list_search w_abc_list_search

type variables
String is_tipo,is_col
str_parametros is_param
DataStore ids_cntas_pagar_det,ids_imp_x_pagar,ids_cntas_cobrar_det,ids_imp_x_cobrar,&
			 ids_imp_x_cobrar_x_doc,ids_art_a_vender
end variables

on w_abc_list_search.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_3=create dw_3
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.cb_1
end on

on w_abc_list_search.destroy
call super::destroy
destroy(this.st_1)
destroy(this.dw_3)
destroy(this.cb_1)
end on

event open;call super::open;//override
THIS.EVENT ue_open_pre()
end event

event ue_open_pre;call super::ue_open_pre;// Overr
String ls_null
Long   ll_row

// Recoge parametro enviado

	This.Title = is_param.titulo
	dw_1.DataObject = is_param.dw1
	dw_2.Dataobject = is_param.dw1
	
	dw_1.SetTransObject( SQLCA)
	dw_2.SetTransObject( SQLCA)
	//Posiciones 
	dw_1.width = is_param.db1
	pb_1.x 	  = dw_1.width + 50
	pb_2.x 	  = pb_1.x
	dw_2.x 	  = pb_1.x + pb_1.width + 50
	dw_2.width = is_param.db1
	This.width = dw_1.width + pb_1.width + dw_2.width + 200
	cb_1.x	  = This.width - 400

	//Inicializar Variable de Busqueda //
	
	CHOOSE CASE is_param.String1
			 CASE '1RPP'
					is_col = 'codigo'
	END CHOOSE
	
	IF Trim(is_param.tipo) = '' OR Isnull(is_param.tipo) THEN 	// Si tipo no es indicado, hace un retrieve
		ll_row = dw_1.retrieve()
	END IF



end event

type dw_1 from w_abc_list`dw_1 within w_abc_list_search
integer x = 27
integer y = 212
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	is_param = MESSAGE.POWEROBJECTPARM	
end if

ii_ss 	  = 0
is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form
idw_det  = dw_2 				// dw_detail 

ii_ck[1] = 1         // columnas de lectrua de este dw

CHOOSE CASE is_param.opcion 
		CASE	4 
				ii_dk[1]  = 1	//cod_relacion
				ii_dk[2]  = 2	//tipo_doc
				ii_dk[3]  = 3	//nro_doc
				ii_dk[4]  = 4	//total_pagar
				ii_dk[5]  = 5	//cod_moneda
				ii_dk[6]  = 6	//nombre
				ii_dk[7]  = 7	//origen
					
				ii_rk[1]  = 1  //cod_relacion
				ii_rk[2]  = 2  //tipo doc
				ii_rk[3]  = 3  //nro doc
				ii_rk[4]  = 4  //total_pagar
				ii_rk[5]  = 5  //cod_moneda
				ii_rk[6]  = 6  //nombre
				ii_rk[7]  = 7  //origen
END CHOOSE
ii_ss = 0
end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')

IF li_pos > 0 THEN
//	is_tipo = 
	is_col  = UPPER( mid(ls_column,1,li_pos - 1) )	
	is_tipo = LEFT( this.Describe(is_col + ".ColType"),1)	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
//	st_campo.text = "Orden: " + is_col
	dw_3.reset()
	dw_3.InsertRow(0)
	dw_3.SetFocus()

END IF
end event

event dw_1::getfocus;call super::getfocus;dw_1.SetFocus()
end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	   ll_row, ll_rc
Any	   la_id
Integer	li_x


ll_row = dw_2.EVENT ue_insert()


FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)



end event

type dw_2 from w_abc_list`dw_2 within w_abc_list_search
integer x = 1010
integer y = 228
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ss 	  = 0
ii_ck[1] = 1
CHOOSE CASE is_param.opcion 
      CASE  4 
				ii_rk[1]  = 1	//cod_relacion
				ii_rk[2]  = 2	//tipo_doc
				ii_rk[3]  = 3	//nro_doc
				ii_rk[4]  = 4	//total_pagar
				ii_rk[5]  = 5	//cod_moneda
				ii_rk[6]  = 6	//nombre
				ii_rk[7]  = 7	//origen
					
				ii_dk[1]  = 1  //cod_relacion
				ii_dk[2]  = 2  //tipo doc
				ii_dk[3]  = 3  //nro doc
				ii_dk[4]  = 4  //total_pagar
				ii_dk[5]  = 5  //cod_moneda
				ii_dk[6]  = 6  //nombre
				ii_dk[7]  = 7  //origen
				
END CHOOSE
end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)


end event

type pb_1 from w_abc_list`pb_1 within w_abc_list_search
integer x = 832
integer y = 552
end type

type pb_2 from w_abc_list`pb_2 within w_abc_list_search
integer x = 832
integer y = 820
end type

type st_1 from statictext within w_abc_list_search
integer x = 59
integer y = 32
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda"
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_abc_list_search
integer x = 343
integer y = 16
integer width = 914
integer height = 84
integer taborder = 10
boolean bringtotop = true
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_abc_list_search
integer x = 1335
integer y = 16
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Transferir"
end type

