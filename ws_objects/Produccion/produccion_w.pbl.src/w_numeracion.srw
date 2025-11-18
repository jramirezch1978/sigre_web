$PBExportHeader$w_numeracion.srw
forward
global type w_numeracion from w_abc_master
end type
end forward

global type w_numeracion from w_abc_master
integer width = 1157
integer height = 568
string title = "Numerador"
end type
global w_numeracion w_numeracion

on w_numeracion.create
call super::create
end on

on w_numeracion.destroy
call super::destroy
end on

event ue_open_pre;//Override
long ll_row

f_centrar(this)

idw_1 = dw_master             // asignar dw corriente

idw_1.dataobject = message.stringparm
idw_1.SetTransObject( sqlca)
ll_row = idw_1.retrieve()
if ll_row = 0 then
	idw_1.event ue_insert()
else
	idw_1.ii_protect = 1
	idw_1.of_protect( )
end if


//is_tabla = dw_master.Object.Datawindow.Table.UpdateTable  //Nombre de tabla a grabar en el Log Diario

end event

type dw_master from w_abc_master`dw_master within w_numeracion
integer x = 18
integer y = 4
integer width = 1051
integer height = 432
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.origen [al_row] = gs_origen
end event

event dw_master::constructor;call super::constructor;is_dwform = 'form'
ii_ck[1] = 1
end event

