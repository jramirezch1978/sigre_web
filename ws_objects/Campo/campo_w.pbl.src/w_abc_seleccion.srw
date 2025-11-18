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
integer width = 2999
integer height = 1436
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
String  	is_col = '', is_tipo, is_type, is_soles, is_tipo_alm, &
			is_oper_cons_int, is_almacen, is_opcion
Date 		id_fecha
Double 	in_tipo_cambio
Long		il_opcion
str_parametros 			ist_datos

end variables

forward prototypes
public function boolean of_opcion1 ()
end prototypes

public function boolean of_opcion1 ();// Insertar datos para Labores de Campo
string ls_labor
Long ll_j

delete tt_labores_selec;

FOR ll_j = 1 TO dw_2.RowCount()								
	
	ls_labor = dw_2.object.cod_labor[ll_j]
	
	insert into tt_labores_selec(cod_labor)
	values(:ls_labor);
	
NEXT				
return true

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

event ue_open_pre;call super::ue_open_pre;Long 		ll_row
string 	ls_articulo, ls_datawindow
date		ld_fecha
u_dw_abc	ldw_master

ii_access = 1   // sin menu

// Recoge parametro enviado
if ISNULL( Message.PowerObjectParm ) or NOT IsValid(Message.PowerObjectParm) THEN
	MessageBox('Aviso', 'Parametros enviados estan en blanco', StopSign!)
	return
end if

If Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	MessageBox('Aviso', 'Parametros enviados no son del Tipo str_parametros', StopSign!)
	return
end if

is_tipo = ist_datos.tipo
il_opcion = ist_datos.opcion
ls_datawindow = ist_datos.dw1

dw_1.DataObject = ls_datawindow
dw_2.DataObject = ls_datawindow
dw_1.SetTransObject( SQLCA)
dw_2.SetTransObject( SQLCA)	

IF TRIM(is_tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
		ll_row = dw_1.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			ll_row = dw_1.Retrieve(ist_datos.string1)

		CASE '2S'				
			ll_row = dw_1.Retrieve(ist_datos.string1, ist_datos.string2)
			
		CASE '1D2D'				
			ll_row = dw_1.Retrieve(ist_datos.fecha1, ist_datos.fecha2)

	END CHOOSE
END IF

This.Title = ist_datos.titulo
is_col = dw_1.Describe("#1" + ".name")
st_campo.text = "Orden: " + is_col

end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()

end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion
event type integer ue_selected_row_now ( long al_row )
integer x = 37
integer y = 140
integer width = 1362
boolean hscrollbar = true
boolean vscrollbar = true
end type

event type integer dw_1::ue_selected_row_now(long al_row);Long 		ll_row, ll_count, ll_rc
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

return ll_row
end event

event dw_1::constructor;call super::constructor;if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if

is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
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
	
	is_type = LEFT( this.Describe(is_col + ".ColType"),1)	
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

event dw_1::ue_selected_row();//
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

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion
integer x = 1600
integer y = 144
integer width = 1362
integer taborder = 50
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1         // columnas de lectrua de este dw

end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc, ll_count
Any	la_id
Integer	li_x

if ist_datos.opcion >= 7 and ist_datos.opcion <= 10 then
	
	ll_row = idw_det.EVENT ue_insert()
	ll_count = Long(this.object.Datawindow.Column.Count)
	FOR li_x = 1 to ll_count
		la_id = THIS.object.data.primary.current[al_row, li_x]	
		ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
	NEXT
	
else
	ll_row = idw_det.EVENT ue_insert()
	
	FOR li_x = 1 to UpperBound(ii_dk)
		la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
		ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
	NEXT
	
end if

idw_det.ScrollToRow(ll_row)


end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion
integer x = 1426
integer y = 440
integer taborder = 30
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion
integer x = 1431
integer y = 588
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
	   
		IF UPPER( is_type) = 'D' then
			ls_comando = "UPPER(LEFT(STRING(" + is_col +")," + String(li_longitud) + "))='" + ls_item + "'"
		ELSEIF UPPER( is_type) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF	

//		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
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
CHOOSE CASE ist_datos.opcion
		
	CASE 1 // consumos internos
		if of_opcion1() then 
			ist_datos.titulo = 's'
		else
			return
		end if

END CHOOSE
CloseWithReturn( parent, ist_datos)
end event

