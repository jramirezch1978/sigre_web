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
integer width = 3771
integer height = 2196
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
String is_col = '', is_tipo, is_soles, is_dolares

integer ii_ik[]
str_parametros ist_datos
Boolean ib_sel = false
Datastore ids_art_a_vender
end variables

forward prototypes
protected subroutine of_insert_art_guia (string as_cod_relacion, string as_tipo_grmp)
public function integer of_insert_ref_grmp (long al_item)
public function integer of_get_param ()
public function integer of_opcion3 ()
end prototypes

protected subroutine of_insert_art_guia (string as_cod_relacion, string as_tipo_grmp);String  	ls_moneda_guia, ls_moneda_lc, ls_expresion, ls_cnta_prsp, &
		   ls_nro_guia, ls_origen_guia, ls_tipo_ref 
Long		ll_row_master, ll_i, ll_found, ll_row
Decimal  ldc_importe, ldc_tasa_cambio

u_dw_abc ldw_detail, ldw_master

ldw_detail = ist_datos.dw_d	// detail
ldw_master = ist_datos.dw_m	// master

ll_row = ldw_master.GetRow()
if ll_row = 0 then return

ls_moneda_lc = ldw_master.object.cod_moneda		[ll_row]   // Moneda de la LC
ldc_tasa_cambio = Dec(ldw_master.object.tasa_cambio	[ll_row])

IF ls_moneda_lc = '' or IsNull(ls_moneda_lc) then
	MessageBox('Aviso', 'La cabecera de la Liqudación no tiene codigo de moneda, por favor verifique')
	RETURN
END IF

ll_row_master  = dw_master.Getrow()
ls_moneda_guia	= dw_master.object.cod_moneda  [ll_row_master]  // Moneda de la GRMP
ls_nro_guia		= dw_master.object.cod_guia_rec[ll_row_master]	// Nro de la GRMP
ls_origen_guia	= dw_master.object.origen		 [ll_row_master]  // Origen de la GRMP

FOR ll_i = 1 TO dw_2.Rowcount()
	
	ls_expresion = "origen_ref = '" + ls_origen_guia  + "' AND tipo_ref = '" + as_tipo_grmp &
					  + "' AND nro_ref = '" + ls_nro_guia + "' AND item_ref = " &
					  + String(dw_2.Object.item[ll_i])
					  
	ll_found 	 = ldw_detail.Find(ls_expresion, 1, ldw_detail.RowCount())

	IF ll_found = 0 THEN
		ldw_Master.il_row = ldw_master.Getrow( )
		ll_row = ldw_detail.event ue_insert()
	
		IF ll_row > 0 THEN
			ldc_importe	= Dec(dw_2.object.peso_venta[ll_i]) * Dec(dw_2.object.precio[ll_i])
			
			if ls_moneda_lc = ls_moneda_guia then
				ldw_detail.Object.importe			  		[ll_row] = ldc_importe
			elseif ls_moneda_lc = is_soles then
				ldw_detail.Object.importe			  		[ll_row] = ldc_importe * ldc_tasa_cambio
			elseif ls_moneda_lc = is_dolares then
				ldw_detail.Object.importe			  		[ll_row] = ldc_importe / ldc_tasa_cambio
			end if
			
			ldw_detail.ii_update = 1
			ldw_detail.Object.item 		     	  		[ll_row] = ll_row
			ldw_detail.Object.cod_art			  		[ll_row] = dw_2.object.cod_art 		[ll_i]
			ldw_detail.Object.descripcion		 		[ll_row] = dw_2.object.desc_art		[ll_i]
			ldw_detail.Object.cantidad			 		[ll_row] = dw_2.object.peso_venta	[ll_i]
			
			ldw_detail.object.origen_ref				[ll_row] = ls_origen_guia
			ldw_detail.object.tipo_ref					[ll_row] = as_tipo_grmp
			ldw_detail.object.nro_ref					[ll_row] = dw_2.object.cod_guia_rec	[ll_i]
			ldw_detail.object.item_ref					[ll_row] = dw_2.object.item			[ll_i]
			ist_datos.titulo = 's'
		END IF
		
		// Inserto las referencias
		IF of_insert_ref_grmp(ll_i) <> 1 THEN 
			messagebox('Aviso', 'Se produjo un error a la hora de agregar la referencia')
			RETURN
		END IF
		
		
	END IF
NEXT

end subroutine

public function integer of_insert_ref_grmp (long al_item);// Función para ingresar las referencias a las GRMP

Long    	ll_j, ll_found, ll_row, ll_row_master
String  	ls_expresion, ls_origen_mov, ls_nro_vale, ls_tipo_mov_alm, &
			ls_moneda_fap, ls_cod_moneda
Decimal 	ldc_descuento

u_dw_abc ldw_detail, ldw_master, ldw_refer

ldw_detail = ist_datos.dw_d	// detalle de cuentas por pagar
ldw_master = ist_datos.dw_m	// master
ldw_refer  = ist_datos.dw_c   // Referencias

ll_row = ldw_master.GetRow()
IF ll_row = 0 THEN RETURN 0

ll_row_master = dw_master.Getrow()

/**** Ingresar las refencias ****/
ist_datos.dw_c.Accepttext()
ls_moneda_fap 	= ldw_master.object.cod_moneda [1]
ls_cod_moneda 	= dw_master.Object.cod_moneda  [ll_row_master]
ls_origen_mov	= dw_2.object.origen_mov		 [al_item]
ls_nro_vale		= dw_2.object.nro_vale			 [al_item]
ls_tipo_mov_alm= ist_datos.string3

ls_expresion = "origen_ref = '" + ls_origen_mov + "' AND tipo_ref = '" +&
					ls_tipo_mov_alm + "' AND  nro_ref = '" + ls_nro_vale + "'"
ll_found 	 = ldw_refer.Find(ls_expresion, 1, ldw_refer.RowCount())	 

IF ll_found = 0 THEN // inserta los documentos de referencias
	ll_j = ldw_refer.event ue_insert()
	IF ll_j > 0 THEN	
		ll_row  = ldw_refer.il_row
		ist_datos.dw_c.Object.tipo_mov	    [ll_row] = 'P'
		ist_datos.dw_c.Object.origen_ref     [ll_row] = ls_origen_mov
		ist_datos.dw_c.Object.tipo_ref	    [ll_row] = ls_tipo_mov_alm
		ist_datos.dw_c.Object.nro_ref		    [ll_row] = ls_nro_vale 
		ist_datos.dw_c.Object.tasa_cambio    [ll_row] = ist_datos.db1			
		ist_datos.dw_c.Object.cod_moneda	    [ll_row] = ls_moneda_fap
		ist_datos.dw_c.Object.cod_moneda_det [ll_row] = ls_cod_moneda
		ist_datos.dw_c.Object.flab_tabor	    [ll_row] = '3' //Cuentas por Pagar
		ist_datos.dw_c.Object.importe			 [ll_row] = 0.00
		ist_datos.titulo = 's'	
	END IF
END IF

RETURN 1

end function

public function integer of_get_param ();select cod_soles, cod_dolares
	into :is_soles, :is_dolares
from logparam l
where reckey = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Error', 'No hay parametros en Logparam, por favor verifique')
	return 0
end if
end function

public function integer of_opcion3 ();Long 		ll_count, ll_row
u_dw_abc ldw_1

ldw_1 = ist_datos.dw_m

ll_count = dw_2.Rowcount()
IF ll_count > 1 THEN
	Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
	Return 0
ELSE

	IF ll_count = 1 THEN
		ll_row = ldw_1.GetRow()
		IF ll_row = 0 THEN RETURN 0
		ldw_1.object.confin 		  [ll_row] = dw_2.Object.confin		  [1]
		
		if ldw_1.of_Existecampo( "matriz_cntbl") then
			ldw_1.object.matriz_cntbl [ll_row] = dw_2.Object.matriz_cntbl [1]
		end if
		ist_datos.titulo = 's'
	END IF
END IF

return 1
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

event ue_open_pre;Long ll_row

ii_access = 1   // sin menu

// Recoge parametro enviado
is_tipo 					= ist_datos.tipo
dw_master.DataObject = ist_datos.dw_master
dw_1.DataObject 		= ist_datos.dw1
dw_2.DataObject 		= ist_datos.dw1


dw_master.SetTransObject(SQLCA)
dw_1.SetTransObject		(SQLCA)
dw_2.SetTransObject		(SQLCA)	

IF TRIM( is_tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
	ll_row = dw_master.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		 CASE '1'  // Guia de Recepcion de Materia Prima
			  ll_row = dw_master.Retrieve(ist_datos.string1, ist_datos.string4)
		CASE 'ARRAY'
			ll_row = dw_master.Retrieve(ist_datos.str_array)
			  
	END CHOOSE
END IF
	
This.Title = ist_datos.titulo
is_col = dw_1.Describe("#1" + ".name")
st_campo.text = "Orden: " + is_col

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10

pb_1.x = newWidth / 2 - pb_1.width / 2
pb_2.x = pb_1.x

dw_1.height  = newHeight  - dw_1.y - 10
dw_1.width 	 = pb_1.x - dw_1.x - 10

dw_2.x 	 = pb_1.x + pb_1.width + 10
dw_2.height  = newHeight  - dw_2.y - 10
dw_2.width  = newwidth  - dw_2.x - 10

end event

event open;call super::open;of_get_param()
end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_md
event type integer ue_selected_row_now ( long al_row )
integer x = 0
integer y = 892
integer width = 1362
integer height = 808
end type

event type integer dw_1::ue_selected_row_now(long al_row);Long			ll_row, ll_rc, ll_nro_mov, j, ll_count
Any			la_id
Integer		li_x

// Valida codigo

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT
	
return 1
end event

event dw_1::constructor;call super::constructor;// Asigna parametro enviados
IF NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
END IF

is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form

CHOOSE CASE ist_datos.opcion 
	 CASE 1 //Concepto Financiero
		   ii_ck[1] = 1			// columnas de lectrua de este dw
			ii_ss = 1
			
	CASE 2 //Guia de Recepcin de Materia Prima
			ii_ck[1] = 1				
			ii_ck[2] = 2				
			ii_ss = 0
			
END CHOOSE
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

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_1::ue_selected_row;// 
Long	ll_row, ll_y

dw_2.ii_update = 1

THIS.EVENT ue_selected_row_pre()

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	// si retorna 0 (fallo en el row_now), deselecciona
	if THIS.EVENT ue_selected_row_now(ll_row) = 0 then
		this.selectRow(ll_row, false);
	end if
	ll_row = THIS.GetSelectedRow(ll_row)
Loop

THIS.EVENT ue_selected_row_pos()
end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_md
integer x = 1573
integer y = 892
integer width = 1362
integer height = 808
integer taborder = 60
end type

event dw_2::constructor;call super::constructor;CHOOSE CASE ist_datos.opcion 
	 CASE 1 //Concepto Financiero
		   ii_ck[1] = 1			// columnas de lectrua de este dw
			ii_ss = 1
			
	CASE 2 //Guia de Recepcin de Materia Prima
			ii_ck[1] = 1				
			ii_ck[2] = 2				
			ii_ss = 0
			
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
integer x = 1399
integer y = 1124
integer taborder = 40
end type

event pb_1::clicked;// Override
Long 		ll_row, ll_count

CHOOSE CASE ist_datos.opcion 
	CASE 1 //Concepto Financiero
		ll_count = dw_2.rowcount( )

		IF ll_count = 1 THEN
			Messagebox('Aviso', 'No puede seleccionar mas de un Concepto Financiero')
			RETURN
		END IF
	 
END CHOOSE


dw_1.EVENT ue_selected_row()

// ordenar ventana derecha
of_sort_dw_2()
end event

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_md
integer x = 1390
integer y = 1312
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
Long   	ll_row, ll_count_det, ll_row_master, ll_found
String 	ls_cod_relacion, ls_tipo_ref, ls_cod_moneda, ls_moneda_fap, &
			ls_nro_guia, ls_expresion, ls_origen_guia, ls_doc_grmp
Decimal	ln_importe

u_dw_abc ldw_referencia

CHOOSE CASE ist_datos.opcion
	CASE 1			//CONFIN
			ll_count_det = dw_2.Rowcount()
			IF ll_count_det > 1 THEN
				Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
				Return
			ELSE

				IF ll_count_det = 1 THEN
					ll_row = ist_datos.dw_m.GetRow()
					IF ll_row = 0 THEN RETURN
					ist_datos.dw_m.object.confin_lc 		[ll_row] = dw_2.Object.confin [1]
					ist_datos.dw_m.object.desc_confin_lc[ll_row] = dw_2.Object.descripcion[1]
					ist_datos.titulo = 's'
				END IF
			END IF
				
	CASE 2 			//Guia de Recepcion de Materia Prima (Cuentas x Pagar)
		
		ldw_referencia = ist_datos.dw_c
		ls_doc_grmp    = ist_datos.string2
		
		ll_row_master   	= dw_master.Getrow()
		ls_cod_relacion	= dw_master.object.proveedor		[ll_row_master]
		
		IF dw_2.Rowcount() > 0 THEN
			ist_datos.dw_m.Accepttext()
			of_insert_art_guia(ls_cod_relacion, ls_doc_grmp)
		END IF

	CASE 3 			//Concepto Financiero
		
		of_opcion3( )

END CHOOSE

CloseWithReturn( parent, ist_datos)
end event

type dw_master from u_dw_abc within w_abc_seleccion_md
integer y = 144
integer width = 3054
integer height = 728
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'  	// tabular(default), form


end event

event clicked;call super::clicked;// Muestra detalle
IF dw_2.Rowcount() = 0 THEN
	IF row > 0 THEN
		CHOOSE CASE ist_datos.opcion 
			 CASE 1
				 dw_1.Retrieve(this.object.grupo[row])
			 CASE 2
				 dw_1.Retrieve(this.object.cod_guia_rec[row])						
		END CHOOSE
	END IF
ELSE
	Messagebox( "Error", "no puede seleccionar otro documento", Exclamation!)
END IF
end event

