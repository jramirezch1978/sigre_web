$PBExportHeader$w_abc_seleccion_equipos.srw
forward
global type w_abc_seleccion_equipos from w_abc_list
end type
type cb_1 from commandbutton within w_abc_seleccion_equipos
end type
type st_campo from statictext within w_abc_seleccion_equipos
end type
type dw_3 from datawindow within w_abc_seleccion_equipos
end type
end forward

global type w_abc_seleccion_equipos from w_abc_list
integer x = 50
integer width = 2601
integer height = 1644
string title = "Seleccion de Equipos"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
cb_1 cb_1
st_campo st_campo
dw_3 dw_3
end type
global w_abc_seleccion_equipos w_abc_seleccion_equipos

type variables
String is_tipo,is_col
str_parametros is_param
DataStore ids_cntas_pagar_det,ids_imp_x_pagar,ids_cntas_cobrar_det,ids_imp_x_cobrar,&
			 ids_imp_x_cobrar_x_doc,ids_art_a_vender
end variables

forward prototypes
public function long wf_verifica_doc (string as_tipo_doc, string as_nro_doc)
public function long wf_find_guias (string as_cod_origen, string as_nro_guia)
public function long wf_verifica_ed (string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public subroutine wf_insert_articulos_x_vales (string as_cod_origen, string as_nro_guia, string as_cod_moneda, decimal adc_tasa_cambio)
end prototypes

public function long wf_verifica_doc (string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public function long wf_find_guias (string as_cod_origen, string as_nro_guia);String ls_expresion,ls_tipo_doc
Long   ll_found = 0,ll_row

//
////***SELECCION DE TIPO DE DOC GUIA***//
//SELECT doc_gr
//  INTO :ls_tipo_doc
//  FROM logparam
// WHERE reckey = '1' ;
////***********************************//
//
//ls_expresion = 'origen_ref = '+"'"+as_cod_origen+"'"+'  AND  nro_ref = '+"'"+as_nro_guia+"'"
//ll_found = is_param.dw_c.Find(ls_expresion, 1,is_param.dw_c.RowCount())	 
//
//IF ll_found > 0 THEN
//	Return ll_found
//ELSE
//
//	IF is_param.dw_c.triggerevent ('ue_insert') > 0 THEN
//      ll_row = w_fi300_cnts_x_cobrar.tab_1.tabpage_2.dw_detail_referencias.il_row
//		/*Datos del Registro Modificado*/
//		w_fi300_cnts_x_cobrar.ib_estado_prea = TRUE
//	   /**/
//		is_param.dw_c.Object.tipo_mov	    [ll_row] = 'C'
//	   is_param.dw_c.Object.origen_ref 	 [ll_row] = as_cod_origen
//	   is_param.dw_c.Object.tipo_ref		 [ll_row] = ls_tipo_doc
//	   is_param.dw_c.Object.nro_ref		 [ll_row] = as_nro_guia
//		is_param.dw_c.Object.flab_tabor	 [ll_row] = '9' //Guias de Remision
Return ll_found
//	END IF
//END IF
//


end function

public function long wf_verifica_ed (string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'cod_relacion = '+"'"+as_cod_relacion+"'"+' AND tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public subroutine wf_insert_articulos_x_vales (string as_cod_origen, string as_nro_guia, string as_cod_moneda, decimal adc_tasa_cambio);//Long   ll_fdw_d,j,ll_found
//String ls_soles, ls_dolares,ls_cod_art,ls_cod_moneda,ls_expresion,ls_tipo_doc,&
//		 ls_item
//
//Rollback;
//DECLARE PB_USP_FIN_ADD_ART_X_GUIA_X_VALE PROCEDURE FOR USP_FIN_ADD_ART_X_GUIA_X_VALE
//(:as_cod_origen,:as_nro_guia,:as_cod_moneda,:adc_tasa_cambio);
//EXECUTE PB_USP_FIN_ADD_ART_X_GUIA_X_VALE ;
//
//
//IF SQLCA.SQLCode = -1 THEN 
//	MessageBox('Fallo Store Procedure','Store Procedure USP_FIN_ADD_ART_X_GUIA_X_VALE , Comunicar en Area de Sistemas' )
//	RETURN
//END IF
//
//
//ids_art_a_vender.Retrieve()
//
//
//
////* Codigo de Moneda Soles y Dolares *//
//SELECT cod_soles,cod_dolares
//  INTO :ls_soles,:ls_dolares
//  FROM logparam   
// WHERE reckey = '1'   ;
////***********************************// 
//
//
//FOR j=1 TO ids_art_a_vender.Rowcount()
//	 
//	 IF is_param.dw_d.Rowcount () = w_fi300_cnts_x_cobrar.ii_lin_x_doc	THEN
//		 Messagebox('Aviso','No Puede Exceder de '+Trim(String(w_fi300_cnts_x_cobrar.ii_lin_x_doc))+' Items x Documento')	
//		 Return 
//	 END IF
//	 
//	 ls_cod_art    = ids_art_a_vender.object.cod_art    [j] 
//	 ls_cod_moneda = ids_art_a_vender.object.cod_moneda [j] 
//	 
//	 ls_expresion  = 'cod_art ='+"'"+ls_cod_art+"'"
//	 ll_found      = is_param.dw_d.find(ls_expresion,1,is_param.dw_d.rowcount())
//	 
//	 IF ll_found > 0 THEN 
//		 is_param.dw_d.Object.cantidad        [ll_found] = is_param.dw_d.Object.cantidad     [ll_found] + ids_art_a_vender.Object.cant_procesada [j]
//		 is_param.dw_d.Object.cant_proyect    [ll_found] = is_param.dw_d.Object.cant_proyect [ll_found] + ids_art_a_vender.Object.cant_proyect   [j]
//	 ELSE
//	    IF is_param.dw_d.triggerevent ('ue_insert') > 0 THEN
//          ll_fdw_d = w_fi300_cnts_x_cobrar.tab_1.tabpage_1.dw_detail.il_row
//			 /*Datos del Registro Modificado*/
//			 w_fi300_cnts_x_cobrar.ib_estado_prea = TRUE
//		    /**/			 
//			  
//			 IF ls_cod_moneda = ls_soles      THEN
//				  is_param.dw_d.Object.precio_unitario [ll_fdw_d] = ids_art_a_vender.Object.precio_unit_soles   [j]
//			 ELSEIF ls_cod_moneda = ls_dolares    THEN
//				  is_param.dw_d.Object.precio_unitario [ll_fdw_d] = ids_art_a_vender.Object.precio_unit_dolares [j]
//			 END IF
//			 
//			 is_param.dw_d.Object.cod_art         [ll_fdw_d] = ids_art_a_vender.Object.cod_art 			 [j]
//			 is_param.dw_d.Object.descripcion     [ll_fdw_d] = ids_art_a_vender.Object.nom_articulo    [j]
//			 is_param.dw_d.Object.cantidad        [ll_fdw_d] = ids_art_a_vender.Object.cant_procesada  [j]
//			 is_param.dw_d.Object.cant_proyect    [ll_fdw_d] = ids_art_a_vender.Object.cant_proyect    [j]
//			 is_param.dw_m.Object.moneda_det	     [1] 		 = is_param.string3
//			 is_param.dw_m.Object.tasa_cambio_det [1] 		 = is_param.db2
//			 is_param.dw_m.Object.cod_relacion_det[1] 	    = is_param.string2
//			 is_param.dw_d.Object.confin			  [ll_fdw_d] = ids_art_a_vender.Object.confin 			 [j]
//			 is_param.dw_d.Object.matriz_cntbl	  [ll_fdw_d] = ids_art_a_vender.object.matriz_cntbl    [j]
//			 is_param.dw_d.Object.flag				  [ll_fdw_d] = 'G'	
//			 is_param.dw_d.Object.tipo_cred_fiscal[ll_fdw_d] = ids_art_a_vender.object.tipo_cred_fiscal[j]
//			 
//			 //Recalculo de Impuesto				 
//			 ls_item = Trim(String(is_param.dw_d.Object.item  [ll_fdw_d]))
//			 w_fi300_cnts_x_cobrar.wf_generacion_imp (ls_item)
//			 
//			 is_param.dw_d.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")
//			 
//		    //Asigno total
//			 w_fi300_cnts_x_cobrar.dw_master.object.importe_a_cobrar [w_fi300_cnts_x_cobrar.dw_master.getrow()] = w_fi300_cnts_x_cobrar.wf_totales ()
//			 w_fi300_cnts_x_cobrar.dw_master.ii_update = 1
//		 END IF	
//	 END IF	
//NEXT
//




end subroutine

on w_abc_seleccion_equipos.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.st_campo=create st_campo
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_campo
this.Control[iCurrent+3]=this.dw_3
end on

on w_abc_seleccion_equipos.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.st_campo)
destroy(this.dw_3)
end on

event ue_open_pre;// Overr

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

dw_1.Retrieve(gs_origen)
dw_2.Retrieve()






end event

event resize;call super::resize;dw_2.height = newheight - dw_2.y - 10
dw_2.x  		= newwidth/2  + 90
dw_2.width  = newwidth  - dw_2.x - 10

dw_1.height = newheight - dw_1.y - 10
dw_1.width  = newwidth/2  - dw_1.x - 90

pb_1.x 	= newwidth/2  - pb_1.width/2
pb_2.x 	= newwidth/2  - pb_2.width/2

cb_1.x = newwidth - cb_1.width - 20
end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_equipos
integer x = 0
integer y = 136
integer width = 800
string dataobject = "d_list_equipos_grid"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;ii_ss 	  = 0
is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form
idw_det  = dw_2 				// dw_detail 

ii_ck[1] = 1         // columnas de lectrua de este dw

end event

event dw_1::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x, li_totcol


ll_row = dw_2.EVENT ue_insert()

// Esta opcion es mas general
li_totcol = Integer(this.Describe("DataWindow.Column.Count"))
	
FOR li_x = 1 to li_totcol
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)




end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

event dw_1::getfocus;call super::getfocus;dw_1.SetFocus()
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
	st_campo.text = "Orden: " + is_col
	dw_3.reset()
	dw_3.InsertRow(0)
	dw_3.SetFocus()

END IF
end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_equipos
integer x = 1234
integer y = 148
integer width = 800
string dataobject = "d_tt_equipos_grid"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ss 	  = 0
ii_ck[1] = 1

idw_det = dw_1
end event

event dw_2::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x, li_totcol


ll_row = dw_2.EVENT ue_insert()

// Esta opcion es mas general
li_totcol = Integer(this.Describe("DataWindow.Column.Count"))
	
FOR li_x = 1 to li_totcol
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)



end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_equipos
integer x = 983
integer y = 440
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_equipos
integer x = 983
integer y = 688
end type

type cb_1 from commandbutton within w_abc_seleccion_equipos
integer x = 1733
integer y = 16
integer width = 297
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;dw_2.Update()
close(parent)
end event

type st_campo from statictext within w_abc_seleccion_equipos
integer x = 27
integer y = 24
integer width = 599
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda :"
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_abc_seleccion_equipos
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 695
integer y = 24
integer width = 974
integer height = 80
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long dw_enter();//Send(Handle(this),256,9,Long(0,0))
dw_1.triggerevent(doubleclicked!)
return 1
end event

event type long ue_tecla(keycode key, unsignedlong keyflags);Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if

ll_row = dw_3.Getrow()

Return 1
end event

event constructor;Long ll_reg

ll_reg = this.insertrow(0)
end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
	//	ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		IF Upper( is_tipo) = 'N' OR UPPER( is_tipo) = 'D' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_tipo) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF
	
		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
			dw_3.Setfocus()
		end if
	End if	
end if	
SetPointer(arrow!)
end event

