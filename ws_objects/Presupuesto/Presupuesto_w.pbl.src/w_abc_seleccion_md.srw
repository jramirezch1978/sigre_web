$PBExportHeader$w_abc_seleccion_md.srw
$PBExportComments$Seleccion con master detalle
forward
global type w_abc_seleccion_md from w_abc_list
end type
type st_campo from statictext within w_abc_seleccion_md
end type
type dw_text from datawindow within w_abc_seleccion_md
end type
type cb_1 from commandbutton within w_abc_seleccion_md
end type
type dw_master from u_dw_abc within w_abc_seleccion_md
end type
end forward

global type w_abc_seleccion_md from w_abc_list
integer x = 539
integer y = 364
integer width = 4288
integer height = 2432
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_campo st_campo
dw_text dw_text
cb_1 cb_1
dw_master dw_master
end type
global w_abc_seleccion_md w_abc_seleccion_md

type variables
String 	is_col = '', is_tipo, is_type, is_doc_oc, is_doc_ov, &
			is_soles, is_dolares, is_almacen, is_doc_otr, is_doc_alm, &
			is_flag_matriz_contab
integer 	ii_ik[]
Long 		ib_row
str_parametros ist_datos


end variables

forward prototypes
public function boolean of_opcion1 ()
public function boolean of_opcion2 ()
end prototypes

public function boolean of_opcion1 ();// Transfiere campos 
Long		ll_j
string	ls_tipo

if dw_2.rowcount() = 0 then return false

delete tt_pto_tipo_prtda;

// Ingresando ahora el detalle de los articulos seleccionados
For ll_j = 1 to dw_2.RowCount()			
	ls_tipo 	= dw_2.object.tipo_prtda_prsp [ll_j]
	insert into tt_pto_tipo_prtda(TIPO_PRTDA_PRSP)
	values( :ls_tipo );
NEXT

commit;
		
return true		

end function

public function boolean of_opcion2 ();// Transfiere campos 
Long		ll_j, ll_row
string	ls_tipo_doc, ls_proveedor, ls_nro_doc, ls_find, ls_moneda
Decimal	ldc_importe
u_dw_abc	ldw_detail

if dw_2.rowcount() = 0 then return false

ldw_detail = ist_datos.dw_m

// Ingresando ahora el detalle de los articulos seleccionados
For ll_j = 1 to dw_2.RowCount()			
	ls_proveedor 	= dw_2.object.proveedor	[ll_j]
	ls_tipo_doc 	= dw_2.object.tipo_doc	[ll_j]
	ls_nro_doc 		= dw_2.object.nro_doc	[ll_j]
	ls_moneda		= dw_2.object.cod_moneda[ll_j]
	
	ls_find = "proveedor='" + ls_proveedor + "' and tipo_doc='" + ls_tipo_doc + "' and nro_doc='" + ls_nro_doc + "'"
	ll_row = ldw_detail.Find(ls_find, 1, ldw_detail.RowCount())
	
	if ll_row = 0 then
		ll_row = ldw_detail.event ue_insert( )
		
		if ll_row <= 0 then return false
	end if
	
	if ls_moneda = gnvo_app.is_soles then
		ldc_importe = dec(dw_2.object.saldo_sol [ll_j])
	else
		ldc_importe = dec(dw_2.object.saldo_dol [ll_j])
	end if
	
	ldw_detail.object.proveedor 		[ll_row] = dw_2.object.proveedor 		[ll_j]
	ldw_detail.object.nom_proveedor 	[ll_row] = dw_2.object.nom_proveedor 	[ll_j]
	ldw_detail.object.ruc 				[ll_row] = dw_2.object.ruc 				[ll_j]
	ldw_detail.object.tipo_doc 		[ll_row] = dw_2.object.tipo_doc 			[ll_j]
	ldw_detail.object.nro_doc 			[ll_row] = dw_2.object.nro_doc 			[ll_j]
	ldw_detail.object.descripcion 	[ll_row] = dw_2.object.descripcion 		[ll_j]
	ldw_detail.object.fecha_emision 	[ll_row] = dw_2.object.fecha_emision 	[ll_j]
	ldw_detail.object.cod_moneda 		[ll_row] = ls_moneda
	ldw_detail.object.importe 			[ll_row] = ldc_importe
		
	
NEXT

return true		


end function

on w_abc_seleccion_md.create
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

on w_abc_seleccion_md.destroy
call super::destroy
destroy(this.st_campo)
destroy(this.dw_text)
destroy(this.cb_1)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;u_dw_abc	ldw_master

ii_access = 1   // sin menu

// Recoge parametro enviado
is_tipo = ist_datos.tipo
dw_master.DataObject = ist_datos.dw_master
dw_master.SetTransObject( SQLCA)

dw_1.DataObject = ist_datos.dw1
dw_1.SetTransObject( SQLCA)

dw_2.DataObject = ist_datos.dw1
dw_2.SetTransObject( SQLCA)	

if TRIM( is_tipo ) = '' then 	// Si tipo no es indicado, hace un retrieve
	dw_master.retrieve()
else		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			dw_master.Retrieve( ist_datos.string1 )
		CASE '1L'
			dw_master.Retrieve( ist_datos.long1 )
		CASE '1D'
			dw_master.Retrieve( ist_datos.date1 )
	END CHOOSE
end if

This.Title = ist_datos.titulo
is_col = dw_1.Describe("#1" + ".name")
st_campo.text = "Orden: " + is_col


end event

event resize;call super::resize;dw_master.width   = newwidth  - dw_master.x - 10
dw_1.height 		= newheight - dw_1.y - 10
dw_1.width			= newwidth/2 - dw_1.x - pb_1.width/2 - 20

dw_2.x				= newwidth/2 + pb_1.width/2 + 20
dw_2.height 		= newheight - dw_2.y - 10
dw_2.width   		= newwidth  - dw_2.x - 10

pb_1.x				= newwidth/2 - pb_1.width/2
pb_2.x				= newwidth/2 - pb_2.width/2
end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()

end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_md
integer x = 0
integer y = 884
integer width = 1362
integer height = 808
end type

event dw_1::constructor;call super::constructor;// Asigna parametro


if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if

//ii_ss      = 0 		//seleccion multiple
//is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
//is_dwform  = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw



end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_count, ll_rc
Any	la_id
Integer	li_x
string	ls_oper_sec, ls_cod_art

if ist_datos.opcion = 4 then
	if dw_2.RowCount() > 1 then
		MessageBox('Aviso', 'Solo se puede seleccionar un articulo x vez')
		return
	end if
end if

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)
end event

event dw_1::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_md
integer x = 1600
integer y = 884
integer width = 1362
integer height = 808
integer taborder = 60
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
				ii_dk[12] = 12
				ii_dk[13] = 13
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
				ii_rk[12] = 12
				ii_rk[13] = 13
				ii_rk[14] = 14
				ii_rk[15] = 15
				ii_rk[16] = 16
				ii_rk[17] = 17
				ii_rk[18] = 18
				ii_rk[19] = 19
				ii_rk[20] = 20
		Case 2
				ii_dk[1]  =  1
				ii_dk[2]  =  2
				ii_dk[3]  =  3
				ii_dk[4]  =  4	
				ii_dk[5]  =  5	
				ii_dk[6]  =  6	
				ii_rk[1]  =  1
				ii_rk[2]  =  2
				ii_rk[3]  =  3
				ii_rk[4]  =  4
				ii_rk[5]  =  5	
				ii_rk[6]  =  6
	Case 3
				ii_dk[1]  =  1
				ii_dk[2]  =  2
				ii_dk[3]  =  3
				ii_dk[4]  =  4	
				ii_dk[5]  =  5
				ii_dk[6]  =  6
				ii_dk[7]  =  7
				ii_dk[8]  =  8
				ii_dk[9]  =  9
				ii_dk[10]  = 10
				ii_dk[11]  = 11
				ii_dk[12]  = 12
				ii_dk[13]  = 13
				ii_dk[14]  = 14
				ii_rk[1]  =  1
				ii_rk[2]  =  2
				ii_rk[3]  =  3
				ii_rk[4]  =  4
				ii_rk[5]  =  5
				ii_rk[6]  =  6
				ii_rk[7]  =  7
				ii_rk[8]  =  8
				ii_rk[9]  =  9
				ii_rk[10]  = 10
				ii_rk[11]  = 11
				ii_rk[12]  = 12
				ii_rk[13]  = 13
				ii_rk[14]  = 14
end choose

end event

event dw_2::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_count, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)
end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_md
integer x = 1426
integer y = 1116
integer taborder = 40
end type

event pb_1::clicked;call super::clicked;//Long ll_row_mst
//
//
//ll_row_mst = ist_datos.dw_m.getrow()
//
//messagebox( ist_datos.dw_m.object.nro_sol_serv[ll_row_mst], '')
//messagebox( dw_2.object.nro_sol_serv[1], '' )
//  if ist_datos.dw_m.object.sol_cod_origen[ll_row_mst] <> dw_2.object.cod_origen[1] or &
//     ist_datos.dw_m.object.nro_sol_serv[ll_row_mst] <> dw_2.object.nro_sol_serv[1] then
//	  messagebox("Error", "no puede seleccionar otro documento") 
//	  return 
//end if
end event

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_md
integer x = 1417
integer y = 1304
integer taborder = 50
end type

type st_campo from statictext within w_abc_seleccion_md
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

type dw_text from datawindow within w_abc_seleccion_md
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

//Integer li_longitud
//string ls_item, ls_ordenado_por, ls_comando
//Long ll_fila
//
//SetPointer(hourglass!)
//
//if TRIM( is_col) <> '' THEN
//	ls_item = upper( this.GetText())
//
//	li_longitud = len( ls_item)
//	if li_longitud > 0 then		// si ha escrito algo
//		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
//	
//		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
//		if ll_fila <> 0 then		// la busqueda resulto exitosa
//			dw_1.selectrow(0, false)
//			dw_1.selectrow(ll_fila,true)
//			dw_1.scrolltorow(ll_fila)
//		end if
//	End if	
//end if	
//SetPointer(arrow!)

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando  
Long ll_fila, li_x

SetPointer(hourglass!)

String ls_campo

if TRIM( is_col) <> '' THEN

	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo

	   IF UPPER( is_type) = 'N' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_type) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF		

		ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())	
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_master.selectrow(0, false)
			dw_master.selectrow(ll_fila,true)
			dw_master.scrolltorow(ll_fila)
			
			// ubica			
			dw_master.Event ue_output(ll_fila)			
		end if
	End if	
else
	Messagebox( "Aviso", "Seleccione el orden haciendo doble click en el titulo")
	dw_1.reset()
	this.insertrow(0)
end if	
SetPointer(arrow!)
end event

type cb_1 from commandbutton within w_abc_seleccion_md
integer x = 2565
integer y = 28
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
string text = "&Transferir"
end type

event clicked;// Transfiere campos 

if dw_2.rowcount() = 0 then return

Choose case ist_datos.opcion
	CASE 1 // Ingreso x Compras 
		if of_opcion1() then
			ist_datos.Titulo = 's'
		else
			return
		end if
	CASE 2 // Seleccion de Cntas x Pagar
		if of_opcion2() then
			ist_datos.Titulo = 's'
		else
			return
		end if		
		
END CHOOSE
CloseWithReturn( parent, ist_datos)

end event

type dw_master from u_dw_abc within w_abc_seleccion_md
integer y = 140
integer width = 2894
integer height = 724
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'  	// tabular(default), form

end event

event clicked;call super::clicked;// Muestra detalle
Long 			ll_count
String 		ls_nro_ref, ls_nro_oc
u_dw_abc 	ldw_master
if row = 0 then return
dw_2.Accepttext()

ll_count = dw_2.Rowcount()
ib_row = row
if ll_count = 0 then
	
	Choose case ist_datos.opcion 
		Case 1 				// Solicitud de Articulos de Ordenes de compra pendientes
			dw_1.Retrieve( this.object.grp_prtda_prsp[row], ist_datos.long1)
			
		Case 2 				// Jalar documentos para el presupuesto de Caja
			dw_1.Retrieve( this.object.proveedor[row], ist_datos.date1)
	end Choose
	
else
	
	Messagebox( "Error", "no puede seleccionar otro registro", exclamation!)	
	This.setredraw(false)
	This.SelectRow(0,False)
	This.SelectRow(ib_row,True)
	This.setfocus()
	This.setredraw(true)	
	dw_1.reset()
	dw_2.reset()
	
end if
end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column 
Long ll_row

li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = mid(ls_column,1,li_pos - 1)
	st_campo.text = "Buscar por: " + dw_master.describe( is_col + "_t.text")
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()	

	is_type = LEFT( this.Describe(is_col + ".ColType"),1)
END  IF
end event

