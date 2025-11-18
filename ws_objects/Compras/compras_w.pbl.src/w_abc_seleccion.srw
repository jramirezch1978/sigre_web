$PBExportHeader$w_abc_seleccion.srw
forward
global type w_abc_seleccion from w_abc_list
end type
type st_campo from statictext within w_abc_seleccion
end type
type dw_text from datawindow within w_abc_seleccion
end type
type cb_1 from commandbutton within w_abc_seleccion
end type
end forward

global type w_abc_seleccion from w_abc_list
integer x = 649
integer width = 2990
integer height = 1356
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_campo st_campo
dw_text dw_text
cb_1 cb_1
end type
global w_abc_seleccion w_abc_seleccion

type variables
String is_col = '', is_tipo
integer ii_ik[]
str_parametros ist_datos
end variables

forward prototypes
public function integer of_opcion1 ()
public function integer of_opcion5 ()
public function integer of_opcion2 ()
end prototypes

public function integer of_opcion1 ();String	ls_sub_categ[]
Long		ll_i
u_dw_abc ldw_master

if dw_2.RowCount() = 0 then
	MessageBox('Aviso', 'No ha elegido ninguna subcategoría')
	return 0
end if

ldw_master = ist_datos.dw_m

// Actualiza origen y solicitud en cabecera				
For ll_i = 1 to dw_2.RowCount()
	ls_sub_categ[ll_i] = dw_2.object.cod_sub_cat[ll_i]
next

ldw_master.retrieve(ls_sub_categ)
	
return 1
end function

public function integer of_opcion5 ();Long ll_j, ll_row
u_dw_abc ldw_detail

if dw_2.RowCount() = 0 then
	MessageBox('Aviso', 'No ha elegido ningun registro')
	return 0
end if

ldw_detail = ist_datos.dw_d

For ll_j = 1 to dw_2.RowCount()
	ll_row = ldw_detail.event dynamic ue_insert()
	if ll_row > 0 then
		ldw_detail.object.cod_origen		[ll_row] = gs_origen
  		ldw_detail.object.cod_Art			[ll_row] = dw_2.object.cod_art	[ll_j]
		ldw_detail.object.desc_art			[ll_row] = dw_2.object.desc_art	[ll_j]
		ldw_detail.object.Und				[ll_row] = dw_2.object.und			[ll_j]
		ldw_detail.object.fec_proyect		[ll_row] = ist_datos.fecha1   
		ldw_detail.object.fec_registro	[ll_row] = f_fecha_actual()
		ldw_detail.object.cant_proyect	[ll_row] = dw_2.object.por_comprar[ll_j]
		ldw_detail.object.tipo_mov			[ll_row] = ist_datos.oper_ing_oc
		ldw_detail.object.almacen			[ll_row] = ist_datos.almacen
		ldw_detail.object.tipo_ref			[ll_row] = 'CS'  //Compras sugeridas
		ldw_detail.object.dias_reposicion[ll_row] = ldw_detail.object.dias_reposicion[ll_j]
		ldw_detail.object.dias_rep_import[ll_row] = ldw_detail.object.dias_rep_import[ll_j]
		ldw_detail.object.cod_usr			[ll_row] = gs_user
	end if
Next
		
return 1		
end function

public function integer of_opcion2 ();String	ls_sub_categ[]
Long		ll_i

if dw_2.RowCount() = 0 then
	MessageBox('Aviso', 'Debe de seleccionar al menos un comprador')
	return 0
end if

// Actualiza origen y solicitud en cabecera				
For ll_i = 1 to dw_2.RowCount()
	ist_datos.field_ret_s[ll_i] = dw_2.object.comprador[ll_i]
next
	
return 1
end function

on w_abc_seleccion.create
int iCurrent
call super::create
this.st_campo=create st_campo
this.dw_text=create dw_text
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_text
this.Control[iCurrent+3]=this.cb_1
end on

on w_abc_seleccion.destroy
call super::destroy
destroy(this.st_campo)
destroy(this.dw_text)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;Long ll_row

ii_access = 1   // sin menu

// Recoge parametro enviado
is_tipo = ist_datos.tipo
dw_1.DataObject = ist_datos.dw1
dw_2.DataObject = ist_datos.dw1
dw_1.SetTransObject( SQLCA)
dw_2.SetTransObject( SQLCA)	

if TRIM(is_tipo) = '' then 	// Si tipo no es indicado, hace un retrieve
	ll_row = dw_1.retrieve()
else		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			ll_row = dw_1.Retrieve(ist_datos.string1)
	END CHOOSE
end if
This.Title = ist_datos.titulo
is_col = dw_1.Describe("#1" + ".name")
st_campo.text = "Orden: " + is_col

end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion
integer x = 27
integer y = 140
integer width = 1362
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if
is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  	// tabular(default), form
ii_ss = 0 
ii_ck[1] = 1         // columnas de lectrua de este dw
Choose case ist_datos.opcion	
	Case 5		// Orden de compra/Compras sugeridas
		ii_dk[1] = 1				
		ii_dk[2] = 2
		ii_dk[3] = 3
		ii_dk[4] = 4
		ii_dk[5] = 5
		ii_dk[6] = 6
		ii_rk[1] = 1
		ii_rk[2] = 2
		ii_rk[3] = 3
		ii_rk[4] = 4
		ii_rk[5] = 5
		ii_rk[6] = 6
end CHOOSE
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

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc, ll_count
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

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion
integer x = 1600
integer y = 140
integer width = 1362
integer taborder = 50
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1         // columnas de lectrua de este dw
Choose case ist_datos.opcion	
	Case 5 				// Orden de compras - Compras sugeridas
		ii_dk[1] = 1				
		ii_dk[2] = 2
		ii_dk[3] = 3
		ii_dk[4] = 4 
		ii_dk[5] = 5
		ii_dk[6] = 6

		ii_rk[1] = 1
		ii_rk[2] = 2
		ii_rk[3] = 3
		ii_rk[4] = 4
		ii_rk[5] = 5
		ii_rk[6] = 6	
end Choose
end event

event dw_2::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop
end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc, ll_count
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

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion
integer x = 1426
integer y = 440
integer taborder = 30
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion
integer x = 1417
integer y = 980
integer taborder = 40
end type

type st_campo from statictext within w_abc_seleccion
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

type dw_text from datawindow within w_abc_seleccion
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 745
integer y = 16
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

type cb_1 from commandbutton within w_abc_seleccion
integer x = 2583
integer y = 24
integer width = 338
integer height = 88
integer taborder = 20
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
Choose case ist_datos.opcion		
	CASE 1 	// Subcategorias para un reporte
		if of_opcion1() = 0 then return
	
	case 2 //Compradores
		if of_opcion2() = 0 then return
		
	CASE 5 // Orden de compra - Compras sugeridas
		// Busca tipo mov de ing. por compra
		if of_opcion5() = 0 then return

END CHOOSE

CloseWithReturn( parent, ist_datos)


end event

