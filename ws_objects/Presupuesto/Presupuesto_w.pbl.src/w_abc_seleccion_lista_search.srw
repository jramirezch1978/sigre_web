$PBExportHeader$w_abc_seleccion_lista_search.srw
forward
global type w_abc_seleccion_lista_search from w_abc_list
end type
type cb_transferir from commandbutton within w_abc_seleccion_lista_search
end type
type uo_search from n_cst_search within w_abc_seleccion_lista_search
end type
end forward

global type w_abc_seleccion_lista_search from w_abc_list
integer x = 50
integer width = 3707
integer height = 2040
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_transferir cb_transferir
uo_search uo_search
end type
global w_abc_seleccion_lista_search w_abc_seleccion_lista_search

type variables
String is_tipo,is_col
str_parametros istr_datos
DataStore ids_cntas_pagar_det,ids_imp_x_pagar,ids_cntas_cobrar_det,ids_imp_x_cobrar,&
			 ids_imp_x_cobrar_x_doc,ids_art_a_vender
end variables

forward prototypes
public function long wf_verifica_doc (string as_tipo_doc, string as_nro_doc)
public function long wf_find_guias (string as_cod_origen, string as_nro_guia)
public function long wf_verifica_ed (string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public subroutine wf_insert_articulos_x_vales (string as_cod_origen, string as_nro_guia, string as_cod_moneda, decimal adc_tasa_cambio)
public function boolean of_opcion2 ()
public function boolean of_opcion1 ()
end prototypes

public function long wf_verifica_doc (string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = "tipo_doc='" + as_tipo_doc + "' AND nro_doc='" + as_nro_doc + "'"

ll_found 	 = istr_datos.dw_m.Find(ls_expresion,1,istr_datos.dw_m.Rowcount())


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

ls_expresion = "cod_relacion='" + as_cod_relacion+"' AND tipo_doc='" + as_tipo_doc &
				 + "' AND nro_doc='" + as_nro_doc + "'"

ll_found 	 = istr_datos.dw_m.Find(ls_expresion,1,istr_datos.dw_m.Rowcount())


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

public function boolean of_opcion2 ();// Transfiere campos 
Long		ll_j
string	ls_Cencos, ls_mensaje

if dw_2.rowcount() = 0 then return false

delete TT_PTO_SELECCION;

// Ingresando ahora el detalle de los articulos seleccionados
For ll_j = 1 to dw_2.RowCount()			
	ls_cencos 	= dw_2.object.cencos [ll_j]
	
	insert into TT_PTO_SELECCION(cencos)
	values( :ls_cencos );
	
	if sqlca.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha sucedido un error al insertar un registro en TT_PTO_SELECCION. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
NEXT

commit;
		
return true		

end function

public function boolean of_opcion1 ();// Transfiere campos 
Long		ll_j
string	ls_codigo, ls_mensaje

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete tt_ope_cencos;

FOR ll_j = 1 TO dw_2.Rowcount ()
	
	ls_codigo = dw_2.object.cencos [ll_j]				 				
	
	INSERT INTO tt_ope_cencos (cencos)
	VALUES (:ls_codigo) ;
			 
	if sqlca.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha sucedido un error al insertar un registro en tt_ope_cencos. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
NEXT

commit;
		
return true		

end function

on w_abc_seleccion_lista_search.create
int iCurrent
call super::create
this.cb_transferir=create cb_transferir
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_transferir
this.Control[iCurrent+2]=this.uo_search
end on

on w_abc_seleccion_lista_search.destroy
call super::destroy
destroy(this.cb_transferir)
destroy(this.uo_search)
end on

event ue_open_pre;// Overr
String ls_null
Long   ll_row

// Recoge parametro enviado

This.Title = istr_datos.titulo
dw_1.DataObject = istr_datos.dw1
dw_2.Dataobject = istr_datos.dw1

dw_1.SetTransObject( SQLCA)
dw_2.SetTransObject( SQLCA)

uo_search.of_set_dw(dw_1)

//Posiciones 

//Inicializar Variable de Busqueda //
	
IF Trim(istr_datos.tipo) = '' OR Isnull(istr_datos.tipo) THEN 	// Si tipo no es indicado, hace un retrieve
	ll_row = dw_1.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	
	CHOOSE CASE istr_datos.tipo
		CASE '1S'  
			dw_1.Retrieve(istr_datos.string1)
			
		CASE '1L1S'  
			dw_1.Retrieve(istr_datos.long1, istr_datos.string1)
	END CHOOSE
	
END IF







end event

event resize;call super::resize;//Posiciones 
dw_1.width = newwidth /2 - pb_1.width /2 - 10
dw_1.height = newheight - dw_1.y - 10

pb_1.x 	  = dw_1.width + 10
pb_2.x 	  = pb_1.x

dw_2.x 	  = pb_1.x + pb_1.width + 10

dw_2.width = dw_1.width
dw_2.height = dw_1.height

cb_transferir.x	= newwidth - cb_transferir.width - 10

uo_Search.width 	= cb_transferir.x - uo_Search.x - 10
uo_Search.event ue_resize(sizetype, cb_transferir.x - 10 - uo_Search.x, newheight)
end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_lista_search
integer x = 0
integer y = 96
integer width = 517
end type

event dw_1::constructor;// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	istr_datos = MESSAGE.POWEROBJECTPARM	
end if

ii_ss 	  = 0
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

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long 		ll_row, ll_count, ll_rc
integer 	li_x
Any 		la_id

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

// Asigna datos
idw_det.ScrollToRow(ll_row)

//return ll_row

end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

event dw_1::getfocus;call super::getfocus;dw_1.SetFocus()
end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_lista_search
integer x = 690
integer y = 96
integer width = 517
end type

event dw_2::constructor;call super::constructor;ii_ss 	  = 0
ii_ck[1] = 1

end event

event dw_2::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro(long al_row);call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)



end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_lista_search
integer x = 530
integer y = 416
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_lista_search
integer x = 530
integer y = 664
end type

type cb_transferir from commandbutton within w_abc_seleccion_lista_search
integer x = 1472
integer width = 297
integer height = 84
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

event clicked;string ls_codigo
Long ll_row

dw_2.Accepttext()



CHOOSE CASE istr_datos.opcion
	CASE 1 //Programa de Pagos
		if of_opcion1() then
			istr_datos.Titulo = 's'
		else
			return
		end if	
				
	CASE 2 // Seleccion de Cntas x Pagar
		if of_opcion2() then
			istr_datos.Titulo = 's'
		else
			return
		end if	
END CHOOSE

Closewithreturn(parent, istr_datos)
end event

type uo_search from n_cst_search within w_abc_seleccion_lista_search
event destroy ( )
integer width = 1458
integer taborder = 10
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

