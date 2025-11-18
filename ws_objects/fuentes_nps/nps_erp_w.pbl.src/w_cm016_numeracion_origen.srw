$PBExportHeader$w_cm016_numeracion_origen.srw
forward
global type w_cm016_numeracion_origen from w_abc_master
end type
end forward

global type w_cm016_numeracion_origen from w_abc_master
integer width = 1179
integer height = 572
string title = "Numeradores"
string menuname = "m_save_exit"
long backcolor = 67108864
end type
global w_cm016_numeracion_origen w_cm016_numeracion_origen

on w_cm016_numeracion_origen.create
call super::create
if this.MenuName = "m_save_exit" then this.MenuID = create m_save_exit
end on

on w_cm016_numeracion_origen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;//Override
long ll_row

//f_centrar(this)

idw_1 = dw_master             // asignar dw corriente

idw_1.dataobject = message.stringparm
idw_1.SetTransObject(sqlca)
ll_row = idw_1.retrieve(gnvo_app.is_origen)
if ll_row = 0 then
	this.event ue_insert()
else
	idw_1.ii_protect = 1
	idw_1.of_protect( )
end if


is_tabla = dw_master.Object.Datawindow.Table.UpdateTable  //Nombre de tabla a grabar en el Log Diario

end event

event ue_insert;// overwrite
Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_insert_pos;call super::ue_insert_pos;string ls_nombre
idw_1.object.origen[al_row] = gnvo_app.is_origen
idw_1.object.ult_nro[al_row] = 1
select nombre 
	into :ls_nombre 
	from origen 
	where cod_origen = :gnvo_app.is_origen;
idw_1.object.cadena_t.text = gnvo_app.is_origen + '   ' + ls_nombre
end event

type dw_master from w_abc_master`dw_master within w_cm016_numeracion_origen
integer x = 0
integer y = 0
integer width = 1129
integer height = 372
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_master::constructor;call super::constructor;is_dwform = 'form'
ii_ck[1] = 1
end event

