$PBExportHeader$w_abc_seleccion_md2.srw
forward
global type w_abc_seleccion_md2 from w_abc_list
end type
type st_campo from statictext within w_abc_seleccion_md2
end type
type dw_text from datawindow within w_abc_seleccion_md2
end type
type cb_1 from commandbutton within w_abc_seleccion_md2
end type
type dw_master from u_dw_abc within w_abc_seleccion_md2
end type
end forward

global type w_abc_seleccion_md2 from w_abc_list
integer x = 539
integer y = 364
integer width = 2245
integer height = 1664
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_campo st_campo
dw_text dw_text
cb_1 cb_1
dw_master dw_master
end type
global w_abc_seleccion_md2 w_abc_seleccion_md2

type variables
String is_col = '', is_tipo
integer ii_ik[]
str_parametros ist_datos
Long ib_row


end variables

forward prototypes
public function double wf_verifica_factor (string as_tipo_mov)
public function decimal wf_verifica_saldos (string as_codigo, string as_almacen)
end prototypes

public function double wf_verifica_factor (string as_tipo_mov);Double ld_factor

SELECT factor_sldo_total
  INTO :ld_factor   
  FROM articulo_mov_tipo
 WHERE tipo_mov = :as_tipo_mov ;
 
 Return ld_factor
end function

public function decimal wf_verifica_saldos (string as_codigo, string as_almacen);Double ld_saldo_total = 0

SELECT Nvl(sldo_total,0)
INTO   :ld_saldo_total  
FROM   articulo_almacen
WHERE  almacen = :as_almacen AND cod_art = :as_codigo ; 

Return ld_saldo_total
end function

on w_abc_seleccion_md2.create
int iCurrent
call super::create
this.st_campo=create st_campo
this.dw_text=create dw_text
this.cb_1=create cb_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_text
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_master
end on

on w_abc_seleccion_md2.destroy
call super::destroy
destroy(this.st_campo)
destroy(this.dw_text)
destroy(this.cb_1)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;Long ll_row

ii_access = 1   // sin menu

is_tipo = ist_datos.tipo
dw_master.DataObject = ist_datos.dw_master
dw_1.DataObject = ist_datos.dw1
dw_2.DataObject = ist_datos.dw1
dw_master.SetTransObject( SQLCA)
dw_1.SetTransObject( SQLCA)
dw_2.SetTransObject( SQLCA)	

if TRIM( is_tipo) = '' then 	// Si tipo no es indicado, hace un retrieve
	ll_row = dw_master.retrieve()
else		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			ll_row = dw_master.Retrieve( ist_datos.string1)
	END CHOOSE
end if

This.Title = ist_datos.titulo
is_col = dw_1.Describe("#1" + ".name")
st_campo.text = "Orden: " + is_col

end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()
end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_md2
integer x = 27
integer y = 632
integer width = 2171
integer height = 808
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;// Asigna parametro


if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if

ii_ss      = 0 		//seleccion multiple
is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform  = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

Choose case ist_datos.opcion 
  		 Case 1    // Articulos de Orden de compra  - Pendientes
				ii_dk[1]  =  1
				ii_dk[2]  =  2 
				ii_dk[5]  =  5	
				ii_dk[6]  =  6
				ii_dk[7]  =  7
				ii_dk[8]  =  8
				ii_dk[9]  =  9
				ii_dk[10] = 10
				ii_dk[11] = 11
				ii_dk[14] = 14
				ii_dk[15] = 15
				ii_dk[16] = 16
				ii_dk[17] = 17
				ii_dk[18] = 18
				ii_dk[19] = 19
				ii_dk[20] = 20
				ii_rk[1]  =  1
				ii_rk[2]  =  2 
				ii_rk[5]  =  5	
				ii_rk[6]  =  6
				ii_rk[7]  =  7
				ii_rk[8]  =  8
				ii_rk[9]  =  9
				ii_rk[10] = 10
				ii_rk[11] = 11
				ii_rk[14] = 14
				ii_rk[15] = 15
				ii_rk[16] = 16
				ii_rk[17] = 17				
				ii_rk[18] = 18
				ii_rk[19] = 19
 				ii_rk[20] = 20
end choose
ii_ss = 0
end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_campo.text = "Orden: " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

event dw_1::getfocus;call super::getfocus;dw_text.SetFocus()
end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)

NEXT

idw_det.ScrollToRow(ll_row)




end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this)
end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_md2
boolean visible = false
integer x = 1600
integer y = 632
integer width = 1362
integer height = 808
integer taborder = 60
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ss = 0 
ii_ck[1] = 1
Choose Case ist_datos.opcion 
	 	 Case 1   // 
			ii_dk[1]  =  1
				ii_dk[2]  =  2 
				ii_dk[5]  =  5	
				ii_dk[6]  =  6
				ii_dk[7]  =  7
				ii_dk[8]  =  8
				ii_dk[9]  =  9
				ii_dk[10] = 10
				ii_dk[11] = 11
				ii_dk[14] = 14
				ii_dk[15] = 15
				ii_dk[16] = 16
				ii_dk[17] = 17
				ii_dk[18] = 18
				ii_dk[19] = 19
				ii_dk[20] = 20
				ii_rk[1]  =  1
				ii_rk[2]  =  2 
				ii_rk[5]  =  5	
				ii_rk[6]  =  6
				ii_rk[7]  =  7
				ii_rk[8]  =  8
				ii_rk[9]  =  9
				ii_rk[10] = 10
				ii_rk[11] = 11
				ii_rk[14] = 14
				ii_rk[15] = 15
				ii_rk[16] = 16
				ii_rk[17] = 17
				ii_rk[18] = 18
				ii_rk[19] = 19
				ii_rk[20] = 20				

end choose
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

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_md2
boolean visible = false
integer x = 1426
integer y = 864
integer taborder = 40
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_md2
boolean visible = false
integer x = 1426
integer y = 1052
integer taborder = 50
end type

type st_campo from statictext within w_abc_seleccion_md2
integer x = 23
integer y = 20
integer width = 713
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_text from datawindow within w_abc_seleccion_md2
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 745
integer y = 28
integer width = 1449
integer height = 80
integer taborder = 20
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if
ll_row = dw_text.Getrow()

//dw_lista.SelectRow(0, false)
//dw_lista.SelectRow(ll_row, true)
//dw_1.object.campo[1] = dw_lista.GetItemString(ll_row, is_col)
end event

event dwnenter;//Send(Handle(this),256,9,Long(0,0))
dw_1.triggerevent(doubleclicked!)
return 1
end event

event constructor;// Adiciona registro en dw1
Long ll_reg

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
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type cb_1 from commandbutton within w_abc_seleccion_md2
integer x = 1879
integer y = 1472
integer width = 338
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Transferir"
end type

event clicked;// Transfiere campos 

String      ls_cod_art, ls_almacen, ls_tipo_mov, ls_movst, ls_condicion	
Long        j, ll_count,ll_found, ll_row_master  
Decimal {2} ld_cantidad_proy,ld_cantidad_proc
Double		ld_saldo_act ,ld_factor
Date 	  		ld_Fecha
u_dw_abc		ldw_master

ldw_master = ist_datos.dw_m

Choose case ist_datos.opcion
	CASE 1 // Orden de compra Pendientes
		// Asigna datos a dw master
		ll_row_master = ist_datos.dw_or_m.getrow()
		if NOT ISNULL(ist_datos.dw_or_m.object.tipo_doc_int[ll_row_master]) and &
			ist_datos.dw_or_m.object.nro_doc_int[ll_row_master] <> dw_master.object.nro_doc[dw_master.getrow()] then
			IF MessageBox('Aviso','Desea Cambiar de Documento',Question!, Yesno!, 2) = 1 THEN
				ist_datos.dw_or_d.reset()
			ELSE
				Return						
			END IF
		end if
		ist_datos.dw_or_m.object.tipo_doc_int[ll_row_master] = dw_master.object.tipo_doc[dw_master.getrow()]
		ist_datos.dw_or_m.object.nro_doc_int[ll_row_master]  = dw_master.object.nro_doc[dw_master.getrow()]
		ist_datos.dw_or_m.object.proveedor[ll_row_master]    = dw_master.object.proveedor[dw_master.getrow()]
		ist_datos.dw_or_m.object.proveedor_1[ll_row_master]    = dw_master.object.proveedor[dw_master.getrow()]
		ld_fecha = ist_datos.dw_or_m.object.fec_registro(ll_row_master)
		
		For j = 1 to dw_2.RowCount()
			ll_found = 0
			ls_almacen	 = ist_datos.dw_or_m.Object.Almacen[1]
			ls_tipo_mov	 = ist_datos.dw_or_m.Object.tipo_mov[1]
			ls_cod_art   = dw_2.Object.cod_art[j]
			ls_movst		 = Trim(String(dw_2.Object.nro_mov[j]))
			//---***----//
			ld_factor = wf_verifica_factor(ls_tipo_mov)
				 
			IF dw_2.Object.flag_estado[j] = '2' THEN
				ld_cantidad_proc = (dw_2.Object.cant_proyect[j] - dw_2.Object.cant_procesada[j])
				ld_cantidad_proy = (dw_2.Object.cant_proyect[j] - dw_2.Object.cant_procesada[j]) 
			ELSE
				ld_cantidad_proc = dw_2.Object.cant_proyect[j]
			   ld_cantidad_proy = dw_2.Object.cant_proyect[j]
			END IF				 

			IF ld_factor > 0 THEN
			ELSE
			 	ld_saldo_act = wf_verifica_saldos(ls_cod_art,ls_almacen)
  			   IF ld_saldo_act = 0 THEN
				   Messagebox('Aviso','Codigo de Articulo Nº '+Trim(ls_cod_art)+' No Tiene Saldo Disponible ')					 
			   ELSE
					IF ld_cantidad_proy > ld_saldo_act THEN
						Messagebox('Aviso','No se Puede Atender Toda la Cantidad Proyectada '&
					 				+'Por Exceder el Saldo Actual Se Tomara En Cuenta Solo El Saldo Actual = '+Trim(String(ld_saldo_act)))
					   ld_cantidad_proc = ld_saldo_act
				   END IF						
			   END IF 
	     	END IF
			IF ist_datos.dw_or_d.triggerevent ("ue_insert") > 0 THEN
				ist_datos.dw_or_d.Object.cod_origen     [j] = dw_2.Object.cod_origen	   [j]
				ist_datos.dw_or_d.Object.nro_mov_proy 	 [j] = dw_2.Object.nro_mov 	 	   [j]
				ist_datos.dw_or_d.Object.flag_estado  	 [j] = '1'								
				ist_datos.dw_or_d.Object.cod_art      	 [j] = dw_2.Object.cod_art	 	   [j]
				ist_datos.dw_or_d.Object.cant_procesada [j] = ld_cantidad_proc
				ist_datos.dw_or_d.Object.precio_unit  	 [j] = dw_2.Object.precio_unit	[j]
				ist_datos.dw_or_d.Object.decuento		 [j] = dw_2.Object.decuento 	   [j]
				ist_datos.dw_or_d.Object.impuesto		 [j] = dw_2.Object.impuesto	   [j]
				ist_datos.dw_or_d.Object.cod_moneda		 [j] = dw_2.Object.cod_moneda    [j]
				ist_datos.dw_or_d.Object.cencos			 [j] = dw_2.Object.cencos		   [j]
				ist_datos.dw_or_d.Object.cnta_prsp 		 [j] = dw_2.Object.partida_presup[j]
				ist_datos.dw_or_d.Object.desc_art 		 [j] = dw_2.Object.desc_art    	[j]
				ist_datos.dw_or_d.Object.und				 [j] = dw_2.Object.und				[j]				
				w_al302_mov_almacen.of_set_articulo( dw_2.Object.cod_art[j], ls_almacen) 
			END IF

		NEXT		
	CASE 2    // grupo y concepto financiero
		ldw_master.object.confin		[ldw_master.getrow()] = dw_1.Object.confin		[dw_1.getrow()]
		ldw_master.object.desc_confin [ldw_master.GetRow()] = dw_1.Object.descripcion	[dw_1.getrow()]
		ldw_master.ii_update = 1
		
	CASE 3   // grupo y concepto financiero
		ldw_master.object.confin_export		 [ldw_master.getrow()] = dw_1.Object.confin			[dw_1.getrow()]
		ldw_master.object.desc_confin_export [ldw_master.GetRow()] = dw_1.Object.descripcion	[dw_1.getrow()]
		ldw_master.ii_update = 1
END CHOOSE
CloseWithReturn( parent, ist_datos)

end event

type dw_master from u_dw_abc within w_abc_seleccion_md2
integer x = 27
integer y = 140
integer width = 2181
integer height = 464
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'  	// tabular(default), form

end event

event clicked;call super::clicked;// Muestra detalle
Long ll_count

dw_2.Accepttext()

ll_count = dw_2.Rowcount()

if ll_count = 0 then
	if row > 0 then
		ib_row = row
		Choose case ist_datos.opcion 
			Case 1 				// Solicitud de Articulos de Ordenes de compra pendientes
				dw_1.Retrieve( this.object.nro_doc[row])
			Case 2,3				// Programa de compras
				dw_1.Retrieve(this.object.grupo[row])
	    end Choose
	end if
else
	Messagebox( "Error", "no puede seleccionar otro documento", exclamation!)
	This.setredraw(false)
	This.SelectRow(0,False)
	This.SelectRow(ib_row,True)
	This.setfocus()
	This.setredraw(true)	
end if
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this)
end event

