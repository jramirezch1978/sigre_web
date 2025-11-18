$PBExportHeader$w_abc_master_log.srw
$PBExportComments$abc con botones y grabacion en Log Diario
forward
global type w_abc_master_log from w_abc
end type
type dw_lista from u_dw_list_tbl within w_abc_master_log
end type
type dw_master from u_dw_abc within w_abc_master_log
end type
type cb_buscar from u_cb_open within w_abc_master_log
end type
type p_1 from picture within w_abc_master_log
end type
type cb_insertar from u_cb_insert within w_abc_master_log
end type
type p_2 from picture within w_abc_master_log
end type
type cb_modificar from u_cb_modify within w_abc_master_log
end type
type cb_eliminar from u_cb_delete within w_abc_master_log
end type
type cb_grabar from u_cb_update within w_abc_master_log
end type
type cb_cancelar from u_cb_cancel within w_abc_master_log
end type
type p_3 from picture within w_abc_master_log
end type
type p_4 from picture within w_abc_master_log
end type
type p_5 from picture within w_abc_master_log
end type
type p_6 from picture within w_abc_master_log
end type
type cb_1 from u_cb_close within w_abc_master_log
end type
type p_7 from picture within w_abc_master_log
end type
end forward

global type w_abc_master_log from w_abc
integer width = 1975
integer height = 1148
event ue_get_col_protect ( )
event ue_update_log ( )
dw_lista dw_lista
dw_master dw_master
cb_buscar cb_buscar
p_1 p_1
cb_insertar cb_insertar
p_2 p_2
cb_modificar cb_modificar
cb_eliminar cb_eliminar
cb_grabar cb_grabar
cb_cancelar cb_cancelar
p_3 p_3
p_4 p_4
p_5 p_5
p_6 p_6
cb_1 cb_1
p_7 p_7
end type
global w_abc_master_log w_abc_master_log

type variables
String   is_col_protect[], is_funcion, is_key, is_tipo_oper
String   is_tabla, is_campo, is_val_anterior, is_val_nuevo
Double idb_num_log_rel
Integer ii_log = 0
Boolean  ib_list_perm = False
end variables

forward prototypes
public subroutine of_set_buttons_all ()
public subroutine of_set_buttons_insert ()
public subroutine of_set_buttons_modify ()
public subroutine of_set_buttons_delete ()
public subroutine of_undelete_last_row ()
public function integer of_is_col_protect (string as_column)
end prototypes

event ue_get_col_protect;Integer	li_totcol, li_x, li_pos, li_y = 0
String	ls_colname, ls_campo, ls_flag

li_totcol = Integer(dw_master.Describe("DataWindow.Column.Count"))
FOR li_x = 1 TO li_totcol
	ls_colname = "#" + String(li_x) + ".dbName"
	ls_colname = dw_master.Describe(ls_colname)
	li_pos = Pos(ls_colname,".")
	ls_colname = Mid(ls_colname,li_pos + 1)
	ls_campo = ls_colname
	ls_colname = ls_colname + ".Protect"
	ls_flag = dw_master.Describe(ls_colname)
	IF ls_flag <> '0' THEN
		li_y ++
		is_col_protect[li_y] = ls_campo
	END IF
NEXT


end event

event ue_update_log();DateTime	ldt_now

IF ii_log <> 1 THEN RETURN

ldt_now = Datetime(Today(), Now())

INSERT INTO "log_diario"  
          ( "fecha", "tabla", "operacion", "llave", "campo",
			   "val_anterior", "val_nuevo", "cod_usr")  
  VALUES ( :ldt_now, :is_tabla, :is_tipo_oper, :is_key, :is_campo,   
             :is_val_anterior, :is_val_nuevo, :gs_user)  ;

IF sqlca.sqlcode = 0 THEN
   COMMIT ;
	is_campo = ''
	is_val_anterior = ''
	is_val_nuevo = ''
ELSE
	Rollback ;
	MessageBox ("Error", 'No se pudo grabar el Log')
END IF


end event

public subroutine of_set_buttons_all ();IF cb_buscar.ii_flag_acceso = 1    THEN cb_buscar.enabled = TRUE
IF cb_eliminar.ii_flag_acceso = 1  THEN cb_eliminar.enabled = TRUE
IF cb_insertar.ii_flag_acceso = 1  THEN cb_insertar.enabled = TRUE
IF cb_modificar.ii_flag_acceso = 1 THEN cb_modificar.enabled = TRUE

cb_cancelar.enabled = FALSE
cb_grabar.enabled = FALSE
end subroutine

public subroutine of_set_buttons_insert ();cb_buscar.enabled = FALSE
cb_modificar.enabled = FALSE
cb_eliminar.enabled = FALSE
cb_insertar.enabled = FALSE
cb_cancelar.enabled = TRUE
cb_grabar.enabled = TRUE
end subroutine

public subroutine of_set_buttons_modify ();cb_insertar.enabled = FALSE
cb_eliminar.enabled = FALSE
cb_modificar.enabled = FALSE
cb_cancelar.enabled = TRUE
cb_grabar.enabled = TRUE
end subroutine

public subroutine of_set_buttons_delete ();cb_insertar.enabled = FALSE
cb_modificar.enabled = FALSE
cb_eliminar.enabled = FALSE
cb_cancelar.enabled = TRUE
cb_grabar.enabled = TRUE
end subroutine

public subroutine of_undelete_last_row ();long	ll_row


ll_row = idw_1.DeletedCount()  // NUMERO DE ROWS DELETE => ultimo DELETE

idw_1.SetRedraw(false)

if idw_1.RowsMove(ll_row, ll_row, delete!, idw_1, idw_1.il_row, primary!) = -1 then
	MessageBox("Error", "Undelete failed", exclamation!)
else
	idw_1.SetFocus()
	idw_1.ScrollToRow(idw_1.il_row)
	idw_1.SetColumn(1)
end if
idw_1.SetRedraw(true)



end subroutine

public function integer of_is_col_protect (string as_column);Integer	li_x, li_flag = 0

FOR li_x = 1 TO UpperBound(is_col_protect)
	IF as_column =	is_col_protect[li_x] THEN
		li_flag = 1
		Exit
	END IF
NEXT

RETURN li_flag
end function

on w_abc_master_log.create
int iCurrent
call super::create
this.dw_lista=create dw_lista
this.dw_master=create dw_master
this.cb_buscar=create cb_buscar
this.p_1=create p_1
this.cb_insertar=create cb_insertar
this.p_2=create p_2
this.cb_modificar=create cb_modificar
this.cb_eliminar=create cb_eliminar
this.cb_grabar=create cb_grabar
this.cb_cancelar=create cb_cancelar
this.p_3=create p_3
this.p_4=create p_4
this.p_5=create p_5
this.p_6=create p_6
this.cb_1=create cb_1
this.p_7=create p_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
this.Control[iCurrent+2]=this.dw_master
this.Control[iCurrent+3]=this.cb_buscar
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.cb_insertar
this.Control[iCurrent+6]=this.p_2
this.Control[iCurrent+7]=this.cb_modificar
this.Control[iCurrent+8]=this.cb_eliminar
this.Control[iCurrent+9]=this.cb_grabar
this.Control[iCurrent+10]=this.cb_cancelar
this.Control[iCurrent+11]=this.p_3
this.Control[iCurrent+12]=this.p_4
this.Control[iCurrent+13]=this.p_5
this.Control[iCurrent+14]=this.p_6
this.Control[iCurrent+15]=this.cb_1
this.Control[iCurrent+16]=this.p_7
end on

on w_abc_master_log.destroy
call super::destroy
destroy(this.dw_lista)
destroy(this.dw_master)
destroy(this.cb_buscar)
destroy(this.p_1)
destroy(this.cb_insertar)
destroy(this.p_2)
destroy(this.cb_modificar)
destroy(this.cb_eliminar)
destroy(this.cb_grabar)
destroy(this.cb_cancelar)
destroy(this.p_3)
destroy(this.p_4)
destroy(this.p_5)
destroy(this.p_6)
destroy(this.cb_1)
destroy(this.p_7)
end on

event ue_open_pre;call super::ue_open_pre;THIS.EVENT ue_get_col_protect()
THIS.FUNCTION POST of_set_buttons_all()

dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
idw_1 = dw_master              			// asignar dw corriente
idw_1.enabled = False						// bloquear modificaciones 
dw_lista.of_share_lista(idw_1)			// compartir data con lista
idw_1.Retrieve()								// leer todos los registros
idw_1.il_row = 1								// actualizar il_row con primera fila
ii_pregunta_delete = 1   					// 1 = si pregunta, 0 = no pregunta (default)
ii_access = 1
ib_list_perm = Not(cb_buscar.Visible)			// definir si la lista es permanente o no
dw_lista.visible = ib_list_perm	 		// ocultar lista

//ii_log = 1									// 0 = No graba Log(default), 1 = Si.
//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
//is_tabla = 'CLIENTES'						// nombre de tabla para el Log

end event

event ue_insert;call super::ue_insert;Long	ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_update_request;call super::ue_update_request;//Integer li_msg_result
//
//IF idw_1.ii_update = 1 THEN
//	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
//	IF li_msg_result = 1 THEN
// 		THIS.EVENT ue_update()
//	END IF
//END IF


end event

event ue_update;call super::ue_update;Integer	li_rc

idw_1.AcceptText()
THIS.EVENT ue_update_pre()

IF idw_1.ii_update = 1 THEN
	li_rc = of_update(idw_1)
END IF

IF li_rc = -1 THEN RETURN

IF is_funcion = 'I' THEN cb_grabar.EVENT ue_insert_key()

THIS.EVENT ue_update_log()
of_set_buttons_all()
is_funcion = ''
idw_1.enabled = False

end event

event ue_set_access_cb;call super::ue_set_access_cb;
//Integer	li_x
//String	ls_temp
//
//FOR li_x = 1 to Len(is_niveles)
//	ls_temp = Mid(is_niveles, li_x, 1)
//	CHOOSE CASE ls_temp
//		CASE 'I'
//			cb_insertar.ii_flag_acceso = 1
//		CASE 'E'
//			cb_eliminar.ii_flag_acceso = 1
//		CASE 'M'
//			cb_modificar.ii_flag_acceso = 1
//		CASE 'C'
//			cb_buscar.ii_flag_acceso = 1
//	END CHOOSE
//NEXT

cb_eliminar.ii_flag_log = 1
cb_insertar.ii_flag_log = 1
cb_modificar.ii_flag_log = 1

//cb_buscar.ii_flag_log = 1
end event

type dw_lista from u_dw_list_tbl within w_abc_master_log
integer x = 14
integer y = 4
integer width = 658
integer height = 1008
boolean bringtotop = true
end type

event ue_output;call super::ue_output;dw_master.ScrollToRow(al_row)
dw_master.il_row = al_row

THIS.visible = ib_list_perm
end event

type dw_master from u_dw_abc within w_abc_master_log
integer x = 137
integer y = 44
integer width = 1207
integer height = 920
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;String ls_type

is_campo = dwo.Name
IF is_funcion = 'M' AND is_campo <> 'datawindow' AND ii_update = 0 THEN
	IF of_is_col_protect(is_campo) = 1 THEN
		MessageBox('Error', 'La columna esta protegida')
	ELSE
		ls_type = THIS.Describe(is_campo + ".ColType")
		CHOOSE CASE ls_type
			CASE 'date'
				is_val_anterior = String(THIS.GetItemDate(row,is_campo), 'dd/mm/yyyy')
			CASE 'datetime'
				is_val_anterior = String(THIS.GetItemDateTime(row,is_campo), 'dd/mm/yyyy hh:mm:ss')
			CASE Else
				IF Left(ls_type,4) = 'char' THEN
					is_val_anterior = THIS.GetItemString(row,is_campo)
				ELSE
					is_val_anterior = String(THIS.GetItemNumber(row,is_campo))
				END IF
		END CHOOSE
	of_column_protect(is_campo)
	END IF
END IF
end event

event itemchanged;call super::itemchanged;IF is_funcion = 'M' THEN
	is_val_nuevo = data
END IF


end event

type cb_buscar from u_cb_open within w_abc_master_log
integer x = 1591
integer y = 36
integer taborder = 90
boolean bringtotop = true
boolean enabled = false
end type

event clicked;call super::clicked;IF dw_lista.visible THEN
	dw_lista.visible = FALSE
ELSE
	dw_lista.visible = TRUE
END IF


end event

type p_1 from picture within w_abc_master_log
integer x = 1431
integer y = 20
integer width = 101
integer height = 112
boolean bringtotop = true
string picturename = "\source\bmp\file_open.bmp"
boolean focusrectangle = false
end type

type cb_insertar from u_cb_insert within w_abc_master_log
integer x = 1591
integer y = 172
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
end type

event clicked;call super::clicked;idw_1.enabled = True
ii_log = THIS.ii_flag_log
is_funcion = 'I'
is_tipo_oper = 'Insertar'
of_set_buttons_insert()

end event

type p_2 from picture within w_abc_master_log
integer x = 1431
integer y = 144
integer width = 101
integer height = 112
boolean bringtotop = true
string picturename = "\source\bmp\insert.bmp"
boolean focusrectangle = false
end type

type cb_modificar from u_cb_modify within w_abc_master_log
integer x = 1591
integer y = 308
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
end type

event clicked;call super::clicked;idw_1.enabled = True
idw_1.of_protect()
ii_log = THIS.ii_flag_log
is_funcion = 'M'
is_tipo_oper = 'Modificar'
of_set_buttons_modify()

end event

event ue_clicked_pre;call super::ue_clicked_pre;//is_key = String(dw_master.GetItemNumber(dw_master.il_row,'codigo'))
end event

type cb_eliminar from u_cb_delete within w_abc_master_log
integer x = 1591
integer y = 444
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
end type

event clicked;call super::clicked;ii_log = THIS.ii_flag_log
is_funcion = 'E'
is_tipo_oper = 'Eliminar'
of_set_buttons_delete()

end event

event ue_clicked_pre;call super::ue_clicked_pre;//is_key = String(idw_1.GetItemNumber(idw_1.il_row,'codigo'))
end event

type cb_grabar from u_cb_update within w_abc_master_log
integer x = 1591
integer y = 580
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
end type

event clicked;call super::clicked;PARENT.EVENT ue_update()


end event

event ue_insert_key;call super::ue_insert_key;//is_key = String(idw_1.GetItemNumber(idw_1.il_row,'codigo'))

end event

type cb_cancelar from u_cb_cancel within w_abc_master_log
integer x = 1591
integer y = 716
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
end type

event clicked;call super::clicked;CHOOSE CASE is_funcion
	CASE 'I'
		idw_1.DeleteRow(idw_1.il_row)
	CASE 'M'
		idw_1.Retrieve()
	CASE 'E'
		of_undelete_last_row()
END CHOOSE

of_set_buttons_all()
is_funcion = ''
idw_1.enabled = False
idw_1.ii_update = 0

end event

type p_3 from picture within w_abc_master_log
integer x = 1431
integer y = 276
integer width = 101
integer height = 112
boolean bringtotop = true
string picturename = "\source\bmp\modify.bmp"
boolean focusrectangle = false
end type

type p_4 from picture within w_abc_master_log
integer x = 1431
integer y = 404
integer width = 101
integer height = 112
boolean bringtotop = true
string picturename = "\source\bmp\delete.bmp"
boolean focusrectangle = false
end type

type p_5 from picture within w_abc_master_log
integer x = 1431
integer y = 556
integer width = 101
integer height = 112
boolean bringtotop = true
string picturename = "\source\bmp\update.bmp"
boolean focusrectangle = false
end type

type p_6 from picture within w_abc_master_log
integer x = 1431
integer y = 696
integer width = 101
integer height = 112
boolean bringtotop = true
string picturename = "\source\bmp\cancel.bmp"
boolean focusrectangle = false
end type

type cb_1 from u_cb_close within w_abc_master_log
integer x = 1591
integer y = 852
integer taborder = 30
boolean bringtotop = true
end type

type p_7 from picture within w_abc_master_log
integer x = 1431
integer y = 836
integer width = 101
integer height = 112
boolean bringtotop = true
string picturename = "\source\bmp\window.bmp"
boolean focusrectangle = false
end type

