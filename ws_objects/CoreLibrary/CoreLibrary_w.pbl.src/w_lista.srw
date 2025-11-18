$PBExportHeader$w_lista.srw
forward
global type w_lista from w_abc_master_smpl
end type
type st_campo from statictext within w_lista
end type
type dw_1 from datawindow within w_lista
end type
type cb_3 from commandbutton within w_lista
end type
type pb_1 from picturebutton within w_lista
end type
type pb_2 from picturebutton within w_lista
end type
type pb_3 from picturebutton within w_lista
end type
end forward

global type w_lista from w_abc_master_smpl
integer width = 3237
integer height = 2488
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_buscar ( )
st_campo st_campo
dw_1 dw_1
cb_3 cb_3
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
end type
global w_lista w_lista

type variables
String  				is_field_return, is_tipo, is_col = '', is_type, is_dbname, is_col0
integer 				ii_ik[]
str_parametros 	ist_ret, ist_inp
n_cst_utilitario 	invo_util
end variables

forward prototypes
public function string of_sql_where (string as_sql_old, string as_where)
end prototypes

event ue_buscar();Integer 	ll_i, ll_pos, ll_pos2
Integer 	li_return
String  	ls_sql_old, ls_sql_new, ls_descripcion, ls_campo, &
    		ls_cad_a, ls_where, ls_select, ls_alias, ls_sql_tt

dw_1.ACCEPTTEXT()
IF TRIM(is_col) = ''  THEN
	Messagebox( "Error", "de Doble click sobre campo a buscar", StopSign!)
	Return 
END IF

ls_campo = TRIM(dw_1.object.campo[1])
if ls_campo = '' or IsNull(ls_campo) then return

//Sentencia SQL Antigua, no debe tocarse
ls_sql_old   = dw_master.GetSQLSelect()

//SQL para trabajarla, le quito las comillas primero
ls_sql_new = invo_util.of_replace(ls_sql_old, '"', '')

//hay que quitar si es que hay comentarios
if Pos( UPPER( ls_sql_new ), '--', 1) > 0 then	
	
	ll_pos = Pos( UPPER( ls_sql_new ), '--', 1)
	ll_pos2 = 0
	
	if Pos( UPPER( ls_sql_new ), char(13), ll_pos) > 0 then
		
		ll_pos2 = Pos( UPPER( ls_sql_new ), char(13), ll_pos)
		
	elseif Pos( UPPER( ls_sql_new ), char(10), ll_pos) > 0 then
		
		ll_pos2 = Pos( UPPER( ls_sql_new ), char(10), ll_pos)
		
	end if
		
	if ll_pos2 > 0 then
		ls_sql_new = trim(upper(mid(ls_sql_new, 1, ll_pos - 1))) &
					  + trim(upper(mid(ls_sql_new, ll_pos2 + 1)))
	end if
end if


ls_sql_new = invo_util.of_replace(ls_sql_new, char(9), ' ')
ls_sql_new = invo_util.of_replace(ls_sql_new, char(13), ' ')
ls_sql_new = invo_util.of_replace(ls_sql_new, char(10), ' ')

//Agrego la sentencia SQL en caso que sea asi
if is_tipo = '1SQL' then
	ls_sql_new	= of_sql_where( ls_sql_new, ist_inp.string1 )
end if

//Busco la sentencia WHERE para agregarla
if Pos( UPPER( ls_sql_new ), 'WHERE', 1) > 0 then	
	ls_where = " AND ( "
else
	ls_where = " WHERE ("
end if

//Obtengo el select 
ls_select = trim(upper(mid(ls_sql_new, 1, Pos(upper(ls_sql_new), 'FROM') - 1)))

//quito la sentencia SELECT
ls_select = trim(mid(ls_select, len("SELECT") + 1))

//Quito el distinct en caso que exista
if Pos(ls_select, "DISTINCT") > 0 then
	ls_select = trim(mid(ls_select, len("DISTINCT") + 1))
end if

//Obtengo el campo con el nombre de la columna
if Pos(ls_select, upper(is_col)) > 0 then
	//Si existe, entonces lo primero es sacar el nombre de la tabla o el alias, poniendo el punto
	if Pos(ls_select, "." + upper(is_col)) > 0 then
		//Si existe entonces sado el alias, a partir de la ultima coma
		ls_alias = MID(ls_select, 1, Pos(ls_select, "." + upper(is_col)) - 1)
		
		if LastPos(ls_alias, ",") > 0 then
			ls_alias = trim(mid(ls_alias, LastPos(ls_alias, ",")  + 1)) + "." + is_col
		else
			//Entonces en ls_alias tengo el nombre de la tabla por lo que creo el alias con la columna
			ls_alias = trim(ls_alias) + "." + is_col
		end if
	else
		//Si existe entonces sado el alias, a partir del nombre
		ls_alias = trim(MID(ls_select, 1, Pos(ls_select, upper(is_col)) - 1))
		
		if right(ls_alias,2) = "AS" then
			ls_alias = trim(left(ls_alias, len(ls_alias) - 2))
		end if
		
		if is_col0 <> "" then
			if Pos(ls_alias, "AS " + is_col0) > 0 then
				
				ls_alias = trim(mid(ls_alias, Pos(ls_alias, "AS " +is_col0) + len("AS " +is_col0) + 1))
				
			elseif Pos(ls_alias, is_col0) > 0 then
				
				ls_alias = trim(mid(ls_alias, Pos(ls_alias, is_col0) + len(is_col0) + 1))
				
			end if
	
			if mid(ls_alias,1,1) = "," then
				ls_alias = trim(mid(ls_alias, 2))
			end if
		end if
		
		if len(trim(ls_alias)) <= 1 then
			ls_alias = is_col
		end if

	end if
else
	//No existe alias ni nada parecido
	ls_alias = is_col
end if

if upper( left( is_type, 4 ) ) = 'NUMB' OR  upper( left( is_type, 4 ) ) = 'DECI' then
	ls_where = ls_where + ls_alias + " LIKE " + ls_campo
elseif upper( left( is_type, 4 ) ) = 'DATE' then
	ls_where = ls_where + "to_char(" + ls_alias + ", 'dd/mm/yyyy') LIKE '" + ls_campo + "%'"
else
	ls_where = ls_where + "UPPER( " + ls_alias + ") LIKE UPPER('" + ls_campo + "%')"
end if

ls_where = ls_where + ")"
// Anexo el WHERE a la sentencia LS_SQL_OLD, teniendo en cuenta el ORDER en la sintaxis
ls_sql_new = of_sql_where( ls_sql_new, ls_where )

//Reemplazo el usuario en caso hubiera
//ls_sql_new = invo_util.of_replaceall(ls_sql_new, ":as_usuario", "'" + gs_user + "'")

if pos(ls_sql_new, ':') = 0 then
	IF dw_master.SetSQLSelect(ls_sql_new) = 1 THEN
		//this.event ue_retrieve()
		event ue_retrieve()
	
	ELSE
		dw_master.SetSQLSelect(ls_sql_old)
		MessageBox('Error', "No se ha podido asignar la sentencia SQL al datawindows de busqueda: " + ls_sql_new)
		return 
	end if
else
	
	//Hago el cambio mediante el modify
	ls_sql_new = invo_util.of_replaceall(ls_sql_new, "'", "~~'")
	dw_master.Modify("DataWindow.Table.Select='" + ls_sql_new + "'")
	
	event ue_retrieve()
	
END IF

dw_master.SetSQLSelect(ls_sql_old)

if dw_master.RowCount() > 0 then
	dw_master.setfocus()

	dw_1.object.campo[1] = ''   // Limpia dato a buscar
	
	pb_3.enabled = true
else
	pb_3.enabled = false
	dw_1.SetFocus()
end if


return
end event

public function string of_sql_where (string as_sql_old, string as_where);Integer ll_i, ll_pos, li_return
String  ls_descripcion, ls_cad_a, ls_sql_new


ll_pos = POS( upper(as_sql_old), 'ORDER' )
if ll_pos > 0 THEN	
	ls_cad_a = Left( as_sql_old, ll_pos - 1 ) + as_where + ' ' &
	   			+ Mid( as_sql_old, ll_pos)
	ls_sql_new = ls_cad_a
else
	ls_sql_new   = as_sql_old + as_where
end if

return ls_sql_new
end function

on w_lista.create
int iCurrent
call super::create
this.st_campo=create st_campo
this.dw_1=create dw_1
this.cb_3=create cb_3
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.pb_3
end on

on w_lista.destroy
call super::destroy
destroy(this.st_campo)
destroy(this.dw_1)
destroy(this.cb_3)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
end on

event ue_open_pre;// Overr

String ls_null
Long ll_row
ii_lec_mst = 0

idw_1 = dw_master
// Recoge parametro enviado
if NOT ISNULL( Message.PowerObjectParm ) then
	IF Message.PowerObjectParm.Classname () = 'str_parametros' THEN
	
		ist_inp = MESSAGE.POWEROBJECTPARM
	
		
		ii_ik = ist_inp.field_ret_i	// Numero de campo a devolver
		is_tipo = ist_inp.tipo
		
		dw_master.DataObject = ist_inp.dw1	
		dw_master.SetTransObject( SQLCA )	
	
		This.Title = ist_inp.titulo		// Titulo de ventana
	
		dw_1.object.campo.background.mode = 0
		dw_1.object.campo.background.color = RGB(192,192,192)			
		dw_1.object.campo.protect = 1	
		
		st_campo.text = "Buscar por: "  //+ is_col
		dw_1.Setfocus()
		
	else
		MessageBox('Error ' + This.Classname(), "LA ESTRUCTURA NO ES DEL TIPO: 'str_parametros' ", &
			StopSign!)
		event post Close(this)
	END IF
else
	event post Close(this)
end if
end event

event ue_set_access;// OVER
end event

event resize;//Overr
//Long ll_x, ll_y

dw_master.width  = newwidth  - dw_master.x - 10
//dw_master.height = newheight - dw_master.y - 300

//ll_x = (w_main.WorkSpaceWidth() - This.WorkSpacewidth() ) - 50
//ll_y = (w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) - 50

//this.move(ll_x, ll_y)
end event

event open;call super::open;
end event

event ue_retrieve;call super::ue_retrieve;Long 		ll_row
String 	ls_null, ls_cen, ls_sql_old, ls_sql
Integer 	li_ano, li_mes, li_return

if TRIM( is_tipo ) = '' then 	// Si tipo no es indicado, hace un retrieve 
	dw_master.retrieve()	
else		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			dw_master.Retrieve( ist_inp.string1 )
			
		CASE '1SQL'
			ls_sql_old 	= dw_master.GetSQLSelect()
			ls_sql	 	= of_sql_where( ls_sql_old, ist_inp.string1 )
			
			IF dw_master.SetSQLSelect(ls_sql) = 1 THEN
				li_return = dw_master.Retrieve()
				if li_return = -1 then
					MessageBox(this.ClassName(), 'NO SE PUDO EJECUTAR CORRECTAMENTE ' &
						+ 'LA SENTENCIA SQL: ~r~n' + ls_sql, StopSign!)
					return 
				end if
			END IF
			
			//old sql select
			dw_master.SetSQLSelect(ls_sql_old)
			dw_master.setfocus()

	END CHOOSE
end if

pb_3.enabled = true
end event

type dw_master from w_abc_master_smpl`dw_master within w_lista
integer y = 112
integer width = 3200
integer height = 2060
boolean hsplitscroll = true
end type

event dw_master::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then	
	f_select_current_row( this )
end if	
end event

event dw_master::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column, ls_name
Long 		ll_row, ll_count


IF row = 0 THEN
	
	ls_column = upper(dwo.name)
	
	if right( ls_column, 2 ) = "_T" then
	
		is_col = left(ls_column, len(ls_column) - 2 )
				
		st_campo.text = "Buscar por: " + dw_master.describe( ls_column + ".text")
		dw_1.reset()
		dw_1.InsertRow(0)
		dw_1.SetFocus()	
	
		is_type = this.Describe(is_col + ".ColType")
		dw_1.object.campo.background.color = RGB(255,255,255)
		dw_1.object.campo.protect = 0
		
		//Obtengo el campo anterior
		ll_count = Long(this.object.Datawindow.Column.Count)

		FOR li_col = 1 to ll_count
			if upper(dw_master.describe( "#" + string(li_col) + ".name")) = upper(is_col) then 
				exit
			end if
		next
				
		if li_col > 1 then
			li_col -= 1
			is_col0 = upper(dw_master.describe( "#" + string(li_col) + ".dbname"))
			
			if Pos(is_col0, ".") > 0 then
				is_col0 = Mid(is_col0, Pos(is_col0, ".") + 1)
			end if
		else
			is_col0 = ""
		end if
	end if
	
ELSE
	
	ll_row = this.GetRow()
	
	if ll_row > 0 then		
		Any  la_id
		Integer li_x, li_y
		String ls_tipo

		FOR li_x = 1 TO UpperBound(ii_ik)			
			la_id = this.object.data.primary.current[this.getrow(), ii_ik[li_x]]
			// tipo del dato
			ls_tipo = This.Describe("#" + String(ii_ik[li_x]) + ".ColType")
			
			if LEFT( ls_tipo,4 ) = 'date' then
				ist_ret.field_ret[li_x] = string ( la_id )
			end if
			
			if LEFT( ls_tipo,1) = 'd' then
				ist_ret.field_ret[li_x] = string ( la_id)
			end if

			if LEFT( ls_tipo,1 ) = 'c' then
				ist_ret.field_ret[li_x] = la_id
			end if
		NEXT
		ist_ret.titulo = "s"		
		CloseWithReturn( parent, ist_ret)
	end if
END  IF
// Si el evento es disparado desde otro objeto que esta activo, este evento no reconoce el valor row como tal.

end event

event dw_master::getfocus;call super::getfocus;dw_1.SetFocus()
end event

event dw_master::ue_column_sort;// Ancestor Script has been Override

Integer li_pos, li_len
String  ls_column , ls_setsort, ls_name

ls_column = THIS.GetObjectAtPointer()
li_pos = pos(upper(ls_column),'~t')
ls_name = mid(ls_column, 1, li_pos - 1)

IF Lower(Right(ls_name, 2)) <> '_t' THEN RETURN

li_len = len(ls_name) - 2
ls_setsort = mid(ls_column, 1, li_len )

IF ii_sort = 0 THEN
	ii_sort = 1
	ls_setsort = trim(ls_setsort) + ' A'
ELSE
	ii_sort = 0
	ls_setsort = trim(ls_setsort) + ' D'
END IF

THIS.setsort(ls_setsort)
THIS.sort()

If this.RowCount() > 0 then
	this.SetRow(0)
	f_select_current_Row(this)
end if
	
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type st_campo from statictext within w_lista
integer x = 14
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

type dw_1 from datawindow within w_lista
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 736
integer y = 20
integer width = 2222
integer height = 80
integer taborder = 20
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long 	ll_row

if key = KeyUpArrow! then		// Anterior
	if dw_master.RowCount() > 0 then
		dw_master.scrollpriorRow()
	end if
elseif key = KeyDownArrow! then	// Siguiente
	if dw_master.RowCount() > 0 then
		dw_master.scrollnextrow()	
	end if
end if
ll_row = dw_master.Getrow()

dw_master.SetRow(ll_row)
f_select_current_row(dw_master)

if key = KeyUpArrow! or key = KeyDownArrow! then

	IF UPPER( LEFT(is_type,4) ) = 'NUMB' OR UPPER( LEFT(is_type,4) ) = "DECI" then
		dw_1.object.campo[1] = String( dw_master.GetItemNumber(ll_row, is_col) )
	ELSEIF UPPER( LEFT(is_type,4) ) = 'CHAR' then
		dw_1.object.campo[1] = dw_master.GetItemString(ll_row, is_col)
	ELSEIF UPPER( is_type ) = 'DATE' then
		dw_1.object.campo[1] = String( dw_master.GetItemDate(ll_row, is_col), 'dd/mm/yyyy' )
	ELSEIF UPPER( is_type ) = 'DATETIME' then
		dw_1.object.campo[1] = String( dw_master.GetItemDateTime(ll_row, is_col), 'dd/mm/yyyy' )
	END IF		
end if
end event

event type long dwnenter();//Send(Handle(this),256,9,Long(0,0))
//dw_master.triggerevent(doubleclicked!)
cb_3.event clicked()
return 1
end event

event constructor;Long ll_reg

ll_reg = this.insertrow(0)


end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer 	li_longitud
string 	ls_item, ls_ordenado_por, ls_comando, ls_campo
Long 		ll_fila, li_x

SetPointer(hourglass!)


if TRIM( is_col ) <> '' THEN

	ls_item = upper( this.GetText() )

	li_longitud = len( ls_item )

	if li_longitud > 0 then		// si ha escrito algo

	   IF UPPER( LEFT(is_type,4) ) = 'NUMB' OR UPPER( LEFT(is_type,4) ) = "DECI" then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( LEFT(is_type,4) ) = 'CHAR' then
		   ls_comando = "UPPER( LEFT(" + is_col +", " + String(li_longitud) + "))='" + ls_item + "'"
		ELSEIF UPPER( LEFT(is_type,4) ) = 'DATE' then
		   ls_comando = "LEFT( STRING(" + is_col +",'dd/mm/yyyy'), " + string(li_longitud) + ") = '" + ls_item + "'"
		END IF		
		
		ll_fila = dw_master.find(ls_comando, 1, dw_master.RowCount())	
		
		if ll_fila > 0 then		// la busqueda resulto exitosa
			dw_master.selectrow(0, false)
			dw_master.selectrow(ll_fila,true)
			dw_master.scrolltorow(ll_fila)
			// ubica			
			dw_master.Event ue_output(ll_fila)			
		elseif ll_fila = -1 then
			MessageBox(This.ClassName(), "Error General, Comando: " &
					+ ls_comando, Exclamation!)
		elseif ll_fila = -5 then
			MessageBox(This.ClassName(), "Error en argumentos, Comando: " &
					+ ls_comando, Exclamation!)
		elseif ll_fila = 0 then
			dw_master.SelectRow(0, false)
		end if
	End if	
else
	Messagebox( "Aviso", "Seleccione el orden haciendo doble click en el titulo")
	dw_1.reset()
	this.insertrow(0)
end if	

SetPointer(arrow!)
end event

type cb_3 from commandbutton within w_lista
integer x = 2971
integer y = 20
integer width = 229
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;Parent.event ue_buscar()

end event

type pb_1 from picturebutton within w_lista
integer x = 1755
integer y = 2188
integer width = 315
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "c:\sigre\resources\Bmp\Salir.bmp"
alignment htextalign = right!
end type

event clicked;ist_ret.titulo = 'n'
CloseWithReturn( parent, ist_ret)
end event

type pb_2 from picturebutton within w_lista
integer x = 969
integer y = 2188
integer width = 325
integer height = 188
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "c:\sigre\resources\Bmp\Todos.bmp"
alignment htextalign = right!
end type

event clicked;Parent.event ue_retrieve()
end event

type pb_3 from picturebutton within w_lista
integer x = 1362
integer y = 2188
integer width = 315
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\filtrar.bmp"
string disabledname = "C:\SIGRE\resources\BMP\filtrar.bmp"
alignment htextalign = right!
end type

event clicked;if dw_master.rowCount() > 0 then
   Parent.PostEvent("ue_filter")
end if
end event

