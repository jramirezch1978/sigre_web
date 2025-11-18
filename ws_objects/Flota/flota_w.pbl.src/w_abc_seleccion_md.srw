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
integer width = 2990
integer height = 1564
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
String is_col = '', is_tipo
integer ii_ik[]
str_parametros ist_datos
Boolean ib_sel = false
Datastore ids_art_a_vender
end variables

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

event ue_open_pre();Long ll_row

ii_access = 1   // sin menu

// Recoge parametro enviado
is_tipo 					= ist_datos.tipo
dw_master.DataObject = ist_datos.dw_master
dw_1.DataObject 		= ist_datos.dw1
dw_2.DataObject 		= ist_datos.dw1

//**DataStore de Artciuclos Por Orden de Venta**//
ids_art_a_vender            = Create DataStore
ids_art_a_vender.DataObject = 'd_tt_fin_art_a_vender_tbl'
ids_art_a_vender.Settransobject(sqlca)
//****//

dw_master.SetTransObject(SQLCA)
dw_1.SetTransObject		(SQLCA)
dw_2.SetTransObject		(SQLCA)	

IF TRIM( is_tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
	ll_row = dw_master.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
			 CASE '1O'
				   ll_row = dw_master.Retrieve(ist_datos.string1)
			 CASE '11' //**Orden de Compra (Cuentas x Pagar)**/
					ll_row = dw_master.Retrieve(ist_datos.string1)
			 CASE '12' //**Orden de Servicio (Cuentas x Pagar)**/
					ll_row = dw_master.Retrieve(ist_datos.string1)		
	END CHOOSE
END IF
	
This.Title = ist_datos.titulo
is_col = dw_1.Describe("#1" + ".name")
st_campo.text = "Orden: " + is_col

end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_md
integer x = 27
integer y = 632
integer width = 1362
integer height = 808
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if


is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

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

event dw_1::rowfocuschanged;call super::rowfocuschanged;f_Select_current_row(this)
end event

event dw_1::ue_selected_row_pro;Long	  ll_row, ll_rc
Any	  la_id
Integer li_x, li_totcol

if dw_2.RowCount() > 0 then
	MessageBox('Aviso', 'no puede seleccionar mas de un concepto financiero', StopSign!)
	return
end if

ll_row = dw_2.EVENT ue_insert()

// Esta opcion es mas general
li_totcol = Integer(this.Describe("DataWindow.Column.Count"))
	
FOR li_x = 1 to li_totcol
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT




end event

event dw_1::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)


Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = 0
Loop

end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_md
integer x = 1600
integer y = 632
integer width = 1362
integer height = 808
integer taborder = 60
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
CHOOSE CASE ist_datos.opcion 
		 CASE 1 //Guias de Remision
				ii_rk[1] = 1				// Deploy key
				ii_rk[2] = 2				
				ii_rk[3] = 3				// Deploy key
				ii_rk[4] = 4
				ii_dk[1] = 1				// Receive key
				ii_dk[2] = 2				// Receive key
				ii_dk[3] = 3				
				ii_dk[4] = 4
		CASE 2,3,4,5,8 //Concepto Financiero
				ii_rk[1] = 1				// Deploy key
				ii_rk[2] = 2				
				ii_rk[3] = 3				// Deploy key
				ii_dk[1] = 1				// Receive key
				ii_dk[2] = 2				// Receive key
				ii_dk[3] = 3				
				
		
		CASE	9							  //Articulo Movimiento Proyectado	
				ii_rk[1]  = 1				// Deploy key
				ii_rk[2]  = 2				
				ii_rk[3]  = 3				
				ii_rk[4]  = 4
				ii_rk[5]  = 5				
				ii_rk[6]  = 6			
				ii_rk[7]  = 7
				ii_rk[8]  = 8				
				ii_rk[9]  = 9				
				ii_rk[10] = 10
				ii_rk[11] = 11
				
				ii_dk[1]  = 1				
				ii_dk[2]  = 2				
				ii_dk[3]  = 3				
				ii_dk[4]  = 4								
				ii_dk[5]  = 5				
				ii_dk[6]  = 6			
				ii_dk[7]  = 7
				ii_dk[8]  = 8				
				ii_dk[9]  = 9				
				ii_dk[10] = 10
				ii_dk[11] = 11
		CASE	10							  //Articulo Movimiento Proyectado
											  //x Orden de Compra
			   ii_rk[1]  = 1 			  //Codigo de Articulo
			  	ii_rk[2]  = 2 			  //Nombre de Articulo
				ii_rk[3]  = 5			  //Codigo de Moneda	  
				ii_rk[4]	 = 6			  //Precio Unitario
				ii_rk[5]  = 7			  //Cantidad Pendiente
				ii_rk[6]  = 8			  //Centro de Costo
				ii_rk[7]	 = 9			  //Cuenta Presupuestal
				
				ii_dk[1]  = 1				
				ii_dk[2]  = 2				
				ii_dk[3]  = 5				
				ii_dk[4]  = 6				
				ii_dk[5]  = 7								
				ii_dk[6]  = 8				
				ii_dk[7]  = 9				
		CASE 	11								//Orden de Servicio Detalle (Cuentas x Pagar)			
			
				ii_rk[1]  = 3 				//Nro Item
				ii_rk[2]  = 7				//Descripción
				ii_rk[3]  = 8				//Importe
				ii_rk[4]  = 11				//Cencos
				ii_rk[5]  = 13				//Cuenta Presupuestal
				
				ii_dk[1]  = 3 				//Nro Item
				ii_dk[2]  = 7				//Descripción
				ii_dk[3]  = 8				//Importe
				ii_dk[4]  = 11				//Cencos
				ii_dk[5]  = 13				//Cuenta Presupuestal
END CHOOSE
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

ll_row = idw_det.EVENT ue_insert()

// Esta opcion es mas general
li_totcol = Integer(this.Describe("DataWindow.Column.Count"))
	
FOR li_x = 1 to li_totcol
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT



end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_md
integer x = 1426
integer y = 864
integer taborder = 40
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_md
integer x = 1417
integer y = 1052
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

type cb_1 from commandbutton within w_abc_seleccion_md
integer x = 2578
integer y = 28
integer width = 338
integer height = 84
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
str_parametros lstr_datos
Long ll_count_det, ll_row

CHOOSE CASE ist_datos.opcion
	CASE 1		//CASO PARTICULAR DE CONFIN
		ll_count_det = dw_2.Rowcount()
		IF ll_count_det > 1 THEN
			Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
			Return
		end if
		
		IF ll_count_det = 1 THEN
			ll_row = ist_datos.dw_m.GetRow()
			IF ll_row = 0 THEN RETURN
			lstr_datos.field_ret[1] = dw_2.Object.confin			[1]
			lstr_datos.field_ret[2] = dw_2.Object.matriz_cntbl	[1]
			lstr_datos.field_ret[3] = dw_2.Object.descripcion	[1]
			lstr_datos.titulo = 's'
		END IF
				
END CHOOSE
CloseWithReturn( parent, lstr_datos)
end event

type dw_master from u_dw_abc within w_abc_seleccion_md
integer x = 27
integer y = 140
integer width = 2894
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
IF dw_2.Rowcount() = 0 THEN
	
	IF row > 0 THEN
		CHOOSE CASE ist_datos.opcion 
				 CASE 1,2
						dw_1.Retrieve(this.object.grupo[row])
		END CHOOSE
	END IF
ELSE
	Messagebox( "Error", "no puede seleccionar otro documento", Exclamation!)
END IF
end event

