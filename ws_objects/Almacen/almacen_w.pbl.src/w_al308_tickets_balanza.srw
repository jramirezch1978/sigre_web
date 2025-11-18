$PBExportHeader$w_al308_tickets_balanza.srw
forward
global type w_al308_tickets_balanza from w_abc_master
end type
type cb_1 from commandbutton within w_al308_tickets_balanza
end type
type cb_2 from commandbutton within w_al308_tickets_balanza
end type
type cb_3 from commandbutton within w_al308_tickets_balanza
end type
type cb_4 from commandbutton within w_al308_tickets_balanza
end type
end forward

global type w_al308_tickets_balanza from w_abc_master
integer width = 2523
integer height = 884
string title = "Balanza (AL308)"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
end type
global w_al308_tickets_balanza w_al308_tickets_balanza

type variables
str_parametros ist_1

end variables

on w_al308_tickets_balanza.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.cb_4
end on

on w_al308_tickets_balanza.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
end on

event resize;// Over
end event

event ue_open_pre;call super::ue_open_pre;string 	ls_origen, ls_nro_guia
ii_access = 1
idw_1.of_protect()   

if Not IsValid(Message.PowerObjectparm) or IsNull(Message.PowerObjectParm) then
	MessageBox('Aviso', 'Parametros no son del tipo str_parametros')
	Post Event Close()
end if

if Message.PowerObjectparm.ClassName() <> 'str_parametros' then
	MessageBox('Aviso', 'Parametros no son del tipo str_parametros')
	Post Event Close()
end if

ist_1 = message.PowerObjectParm

ls_origen 	= ist_1.string1
ls_nro_guia = ist_1.string2

dw_master.Retrieve(ls_origen, ls_nro_guia)
end event

event ue_update_request();// Override
end event

type dw_master from w_abc_master`dw_master within w_al308_tickets_balanza
integer x = 0
integer y = 0
integer width = 1929
integer height = 796
string dataobject = "d_abc_tickets_guia"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
end event

event dw_master::doubleclicked;call super::doubleclicked;DateTime		ldt_fecha
string		ls_nro
str_parametros sl_param

if lower(dwo.name) = 'nro_pesada' then
	sl_param.dw1 = "d_sel_tickets_balanza"
	sl_param.titulo = "Tickets de balanza"
	sl_param.field_ret_i[1] = 1	// Nro pesada	
	sl_param.field_ret_i[2] = 2	// Cod_art
	sl_param.field_ret_i[3] = 3	// Fecha pesada
	sl_param.field_ret_i[4] = 4	// pesada
	sl_param.field_ret_i[5] = 5	// tara
	
	OpenWithParm( w_lista, sl_param)
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then	
		ls_nro = sl_param.field_ret[1]
		
		select fecha_pesada
			into :ldt_fecha
		from salida_pesada
		where nro_pesada = :ls_nro;
		
		this.object.nro_pesada	[row] = ls_nro
		this.object.cod_art		[row] = sl_param.field_ret[2]
		this.object.fecha_pesada[row] = ldt_fecha
		this.object.pesada		[row] = Dec(sl_param.field_ret[4])
		this.object.tara			[row] = Dec(sl_param.field_ret[5])	
		this.ii_update = 1		// activa flag de modificado
	END IF
end if
end event

event dw_master::itemchanged;// Override

// Valida nro de pesada
Decimal 	ldc_pesada, ldc_tara, ldc_null
Datetime ldt_fecha, ldt_null
String	ls_nro_pesada, ls_null, ls_cod_art


ls_nro_pesada = data
SetNull(ls_null)
SetNull(ldc_null)
SetNull(ldt_null)

this.AcceptText()

Select 	fecha_pesada, 
			pesada, 
			tara,
			cod_art
	into 	:ldt_fecha, 
			:ldc_pesada, 
			:ldc_tara,
			:ls_cod_art
from salida_pesada 
where nro_pesada = :ls_nro_pesada;

if sqlca.sqlcode = 100 then
   if messagebox( 'Error', "Numero de pesada no existe, Desea Continuar?", &
			Information!, YesNo!, 1) = 2 then
		this.object.nro_pesada	[row] = ls_null
		this.object.pesada		[row] = ldc_null
		this.object.tara			[row] = ldc_null
		this.object.fecha_pesada[row] = ldt_null
		this.setfocus()
		this.SetColumn( 'nro_pesada')
		Return 1
	end if
end if

if IsNull(ls_cod_art) or trim(ls_cod_art) = '' then
   if messagebox( 'Error', "Ticket de Balanza no tiene asignado ningun codigo de articulo, ¿Desea continuar?", &
			Information!, YesNo!, 1) = 2 then
		this.object.nro_pesada	[row] = ls_null
		this.object.pesada		[row] = ldc_null
		this.object.tara			[row] = ldc_null
		this.object.fecha_pesada[row] = ldt_null
		this.setfocus()
		this.SetColumn( 'nro_pesada')
		Return 1
	end if
end if

this.object.fecha_pesada[row] = ldt_fecha
this.object.pesada		[row] = ldc_pesada
this.object.tara			[row] = ldc_tara
this.object.cod_art		[row] = ls_cod_art

end event

event dw_master::itemerror;call super::itemerror;return (1)
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type cb_1 from commandbutton within w_al308_tickets_balanza
integer x = 1993
integer y = 56
integer width = 448
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Nuevo Ticket"
end type

event clicked;dw_master.insertrow(0)
end event

type cb_2 from commandbutton within w_al308_tickets_balanza
integer x = 1993
integer y = 184
integer width = 448
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Eliminar Ticket"
end type

event clicked;dw_master.deleterow(0)
end event

type cb_3 from commandbutton within w_al308_tickets_balanza
integer x = 1993
integer y = 312
integer width = 448
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Grabar"
end type

event clicked;// Actualiza los numeros de tickets asignando la guia de remision
Long 		ll_j
String 	ls_origen, ls_nro_guia, ls_nro_pesada, ls_mensaje

ls_origen 	= ist_1.string1
ls_nro_guia = ist_1.string2

// Quitar la referencia 
update salida_pesada 
   set cod_origen = null, 
		 nro_guia 	= null,
		 flag_replicacion = '1'
 where cod_origen = :ls_origen 
 	and nro_guia 	= :ls_nro_guia ;

IF SQLCA.SQLCode <> 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error quitar referencias ticket', ls_mensaje)
	return
end if

// Poner la referencia
For ll_j = 1 to dw_master.rowcount()
	ls_nro_pesada = dw_master.object.nro_pesada[ll_j]
	Update salida_pesada 
	   set cod_origen = :ls_origen, 
			 nro_guia 	= :ls_nro_guia,
			 flag_replicacion = '1'
	 where nro_pesada = :ls_nro_pesada;	
	 
	IF SQLCA.SQLCode <> 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al actualizar datos ticket', ls_mensaje)
		return
	end if
end for
commit;
end event

type cb_4 from commandbutton within w_al308_tickets_balanza
integer x = 1993
integer y = 432
integer width = 448
integer height = 104
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Salir"
end type

event clicked;Close(parent)
end event

