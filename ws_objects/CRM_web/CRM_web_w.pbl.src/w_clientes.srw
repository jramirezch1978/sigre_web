$PBExportHeader$w_clientes.srw
forward
global type w_clientes from window
end type
type dw_master from u_dw_abc within w_clientes
end type
type cb_close from commandbutton within w_clientes
end type
type cb_guardar from commandbutton within w_clientes
end type
end forward

global type w_clientes from window
integer width = 3296
integer height = 1540
boolean titlebar = true
string title = "Nuevo Cliente"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
dw_master dw_master
cb_close cb_close
cb_guardar cb_guardar
end type
global w_clientes w_clientes

type variables
String ls_ruc_register
Integer li_return_ruc
end variables
on w_clientes.create
this.dw_master=create dw_master
this.cb_close=create cb_close
this.cb_guardar=create cb_guardar
this.Control[]={this.dw_master,&
this.cb_close,&
this.cb_guardar}
end on

on w_clientes.destroy
destroy(this.dw_master)
destroy(this.cb_close)
destroy(this.cb_guardar)
end on

event open;if is_action='new' then
	dw_master.Reset()
	dw_master.event ue_Insert()
	
	dw_master.ii_protect = 1
	dw_master.of_protect()
	
	dw_master.SetFocus()
	dw_master.setColumn("clientes_nombre")

elseif is_action = 'open' then
	dw_master.Retrieve(gs_cliente)
end if

end event

type dw_master from u_dw_abc within w_clientes
integer x = 27
integer y = 40
integer width = 3168
integer height = 1264
string dataobject = "d_abc_clientes_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;if is_action="new" then
	this.Object.flag_estado					[al_row] = '1'
end if
this.Object.usuario_id					[al_row] = gi_user
end event

event itemchanged;call super::itemchanged;li_return_ruc = 0
string li_ruc
CHOOSE CASE LOWER(dwo.name)
	CASE 'nro_doc_ident'
		ls_ruc_register = String(data)
		IF (len(ls_ruc_register) > 0) THEN
			li_return_ruc = Integer(ls_ruc_register)
		ELSE
			return
		END IF
	END CHOOSE
RETURN(li_return_ruc)
end event

type cb_close from commandbutton within w_clientes
integer x = 1883
integer y = 1328
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "CERRAR"
end type

event clicked;str_parametros lstr_param

lstr_param.titulo = 'n'
CloseWithReturn(parent, lstr_param)
end event

type cb_guardar from commandbutton within w_clientes
integer x = 795
integer y = 1328
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "GRABAR"
end type

event clicked;String ls_mensaje, ls_cliente_id_last, ls_ruc_tomado
str_parametros	lstr_param

ls_ruc_tomado = String(li_return_ruc)
messagebox("ruc",ls_ruc_register)

dw_master.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al insertar Cliente', ls_mensaje)
	return
end if

COMMIT ;

if is_action="open" then return

select cliente_id
into :ls_cliente_id_last
from clientes
where trim(nro_doc_ident) = :ls_ruc_register;

IF ls_cliente_id_last="" THEN RETURN

INSERT INTO CARTERA_CLIENTES(CLIENTE_ID,USUARIO_ID, USU_REG_ID)
VALUES (:ls_cliente_id_last, :gi_user, :gi_user );
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al insertar Cartera - Cliente', ls_mensaje)
	return
end if
COMMIT ;

lstr_param.titulo = 's'
MessageBox('Registro de Clientes', 'Registro Correcto')

CloseWithReturn(parent, lstr_param)
end event

