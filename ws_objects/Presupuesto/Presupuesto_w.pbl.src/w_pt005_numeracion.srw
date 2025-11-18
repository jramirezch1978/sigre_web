$PBExportHeader$w_pt005_numeracion.srw
forward
global type w_pt005_numeracion from w_abc_master
end type
end forward

global type w_pt005_numeracion from w_abc_master
integer width = 1006
integer height = 556
string title = "Numeradores"
string menuname = "m_numera"
end type
global w_pt005_numeracion w_pt005_numeracion

on w_pt005_numeracion.create
call super::create
if this.MenuName = "m_numera" then this.MenuID = create m_numera
end on

on w_pt005_numeracion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;// Ancestor Script has been Override
long ll_row

f_centrar(this)

dw_master.dataobject = message.stringparm
dw_master.SetTransObject( sqlca)

ll_row = dw_master.retrieve(gs_origen)
if ll_row = 0 then
	dw_master.event ue_insert()
end if

idw_1 = dw_master             // asignar dw corriente
idw_1.SetTransObject(SQLCA)
idw_1.of_protect()         	// bloquear modificaciones al dw_master
//is_tabla = dw_master.Object.Datawindow.Table.UpdateTable  //Nombre de tabla a grabar en el Log Diario

end event

type dw_master from w_abc_master`dw_master within w_pt005_numeracion
integer width = 937
integer height = 332
end type

event dw_master::constructor;call super::constructor;is_dwform = 'form'
ii_ck[1] = 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.origen[al_row] = gs_origen
end event

