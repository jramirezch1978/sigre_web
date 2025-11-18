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
String  	is_col = '', is_tipo, is_type
sg_parametros 			ist_datos

end variables

forward prototypes
public function boolean of_opcion1 ()
public function boolean of_opcion2 ()
public function boolean of_opcion3 ()
public function boolean of_opcion4 ()
public function boolean of_opcion5 ()
end prototypes

public function boolean of_opcion1 ();// Solo para consumos internos 
Long   	ll_j, ll_row, ll_find
string   ls_grupo_maq, ls_cod_maquina
u_dw_abc ldw_detail, ldw_master

ldw_detail = ist_datos.dw_or_d	// detail
ldw_master = ist_datos.dw_or_m	// master

ll_row = ldw_master.GetRow()
if ll_row = 0 then return false

ls_grupo_maq  = ldw_master.Object.grupo_maq	[ll_row]
	 
FOR ll_j = 1 TO dw_2.RowCount()								
	
	ls_cod_maquina = dw_2.object.cod_maquina[ll_j]
	ll_find = ldw_detail.Find("cod_maquina = '" + ls_cod_maquina + "'", 1, ldw_detail.RowCount())
	if ll_find = 0 then
		ll_row = ldw_detail.event ue_insert()
		IF ll_row > 0 THEN
			ldw_detail.ii_update = 1
					
			ldw_detail.Object.cod_maquina [ll_row] = dw_2.Object.cod_maquina	[ll_j]
			ldw_detail.Object.desc_maq 	[ll_row] = dw_2.Object.desc_maq		[ll_j]
			ldw_detail.object.grupo_maq	[ll_row] = ls_grupo_maq
					
		END IF					
	end if
NEXT				
return true

end function

public function boolean of_opcion2 ();Long ll_row
String ls_maquina, ls_mensaje

delete from tt_mtt_equipos;
FOR ll_row = 1 to dw_2.rowcount()
	ls_maquina = dw_2.object.cod_maquina[ll_row]
		
	// Llena tabla temporal con el centro de costo y todas las cuentas
	// presupuestales que tenga segun indicadores
	insert into tt_mtt_equipos(cod_maquina) values (:ls_maquina);
	if sqlca.sqlcode = -1 then
		ls_mensaje = sqlca.sqlerrtext
		ROLLBACK;
		MessageBox('Error', ls_mensaje)
		return false
	end if
NEXT

return true

end function

public function boolean of_opcion3 ();Long ll_row
String ls_ot_adm, ls_mensaje

delete from tt_mtt_ot_adm;
FOR ll_row = 1 to dw_2.rowcount()
	ls_ot_adm = dw_2.object.ot_adm[ll_row]
		
	// Llena tabla temporal con el centro de costo y todas las cuentas
	// presupuestales que tenga segun indicadores
	insert into tt_mtt_ot_adm(ot_adm) values (:ls_ot_adm);
	if sqlca.sqlcode = -1 then
		ls_mensaje = sqlca.sqlerrtext
		ROLLBACK;
		MessageBox('Error', ls_mensaje)
		return false
	end if
NEXT

return true

end function

public function boolean of_opcion4 ();Long ll_row
String ls_cod_maq, ls_mensaje

delete delete tt_mtt_equipos;

FOR ll_row = 1 to dw_2.rowcount()
	ls_cod_maq = dw_2.object.cod_maquina[ll_row]
		
	// Llena tabla temporal con el centro de costo y todas las cuentas
	// presupuestales que tenga segun indicadores
	insert into tt_mtt_equipos(cod_maquina) 
		values (:ls_cod_maq);
		
	if sqlca.sqlcode = -1 then
		ls_mensaje = sqlca.sqlerrtext
		ROLLBACK;
		MessageBox('Error', ls_mensaje)
		return false
	end if
NEXT

commit;

return true

end function

public function boolean of_opcion5 ();Long ll_row
String ls_codigo, ls_mensaje

delete delete tt_mtt_ejecutor;

FOR ll_row = 1 to dw_2.rowcount()
	ls_codigo = dw_2.object.cod_ejecutor[ll_row]
		
	// Llena tabla temporal con el centro de costo y todas las cuentas
	// presupuestales que tenga segun indicadores
	insert into tt_mtt_ejecutor(cod_ejecutor) 
		values (:ls_codigo);
		
	if sqlca.sqlcode = -1 then
		ls_mensaje = sqlca.sqlerrtext
		ROLLBACK;
		MessageBox('Error', ls_mensaje)
		return false
	end if
NEXT

commit;

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
string 	ls_articulo
date		ld_fecha
u_dw_abc	ldw_master

ii_access = 1   // sin menu


// Recoge parametro enviado
if ISNULL( Message.PowerObjectParm ) or NOT IsValid(Message.PowerObjectParm) THEN
	MessageBox('Aviso', 'Parametros enviados estan en blanco', StopSign!)
	return
end if

If Message.PowerObjectParm.ClassName() <> 'sg_parametros' then
	MessageBox('Aviso', 'Parametros enviados no son del Tipo SG_PARAMETROS', StopSign!)
	return
end if

is_tipo = ist_datos.tipo
dw_1.DataObject = ist_datos.dw1
dw_2.DataObject = ist_datos.dw1
dw_1.SetTransObject( SQLCA)
dw_2.SetTransObject( SQLCA)	

IF TRIM( is_tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
		ll_row = dw_1.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			ll_row = dw_1.Retrieve( ist_datos.string1)
		CASE '2S'				
			ll_row = dw_1.Retrieve( ist_datos.string1, ist_datos.string2)
	END CHOOSE
END IF

This.Title = ist_datos.titulo
is_col = dw_1.Describe("#1" + ".name")
st_campo.text = "Orden: " + is_col


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
Integer 	li_x
Any		la_id

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT
	
idw_det.ScrollToRow(ll_row)

return 1
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

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long 		ll_row, ll_count, ll_rc
Integer 	li_x
Any		la_id

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
	CASE 2 // Lista de Equipos w_ma723
		if of_opcion2() then 
			ist_datos.titulo = 's'
		else
			return
		end if
	CASE 3 // Lista de OT_ADM w_ma723
		if of_opcion3() then 
			ist_datos.titulo = 's'
		else
			return
		end if
		
	CASE 4 // Mantenimiento Proyectado w_ma901
		if of_opcion4() then 
			ist_datos.titulo = 's'
		else
			return
		end if

	CASE 5 // Mantenimiento Seleccion de Ejecutores
		if of_opcion5() then 
			ist_datos.titulo = 's'
		else
			return
		end if


END CHOOSE
CloseWithReturn( parent, ist_datos)
end event

