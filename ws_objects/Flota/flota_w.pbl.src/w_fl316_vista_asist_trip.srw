$PBExportHeader$w_fl316_vista_asist_trip.srw
forward
global type w_fl316_vista_asist_trip from w_abc
end type
type dw_master from u_dw_abc within w_fl316_vista_asist_trip
end type
end forward

global type w_fl316_vista_asist_trip from w_abc
integer width = 1902
integer height = 1504
string title = "Vista Completa (FL316)"
string menuname = "m_smpl"
event ue_retrieve ( )
dw_master dw_master
end type
global w_fl316_vista_asist_trip w_fl316_vista_asist_trip

type variables
window iw_parent
string is_nave
date id_fecha1, id_fecha2
end variables

event ue_retrieve();dw_master.SetRedraw(false)
dw_master.SetTransObject(SQLCA)
dw_master.Retrieve(is_nave, id_fecha1, id_fecha2)
dw_master.SetRedraw(true)
end event

on w_fl316_vista_asist_trip.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_fl316_vista_asist_trip.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente

dw_master.of_protect()         		// bloquear modificaciones 

end event

type dw_master from u_dw_abc within w_fl316_vista_asist_trip
integer width = 1623
integer height = 1044
string dataobject = "d_vist_completa_asist_trip_cross"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, false)
this.SelectRow(currentrow, true)
this.SetRow(currentrow)
end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_len
String  ls_column , ls_setsort, ls_name, ls_cadena

ls_column = THIS.GetObjectAtPointer()
li_pos = pos(upper(ls_column),'~t')
ls_name = mid(ls_column, 1, li_pos - 1)

li_pos = LastPos(ls_name, '_t')
ls_cadena = mid(ls_name, li_pos)

IF Lower( Right(ls_cadena, 2) ) = '_t' THEN RETURN

IF Lower( Left(ls_cadena, 2) ) <> '_t' THEN RETURN

li_pos = LastPos(ls_cadena, '_')
ls_cadena = mid( ls_cadena, li_pos )
li_pos = pos(ls_name,'_t')
ls_name = mid(ls_name, 1, li_pos - 1) + ls_cadena

IF ii_sort = 0 THEN
	ii_sort = 1
	ls_setsort = ls_name + ' A'
ELSE
	ii_sort = 0
	ls_setsort = ls_name + ' D'
END IF

THIS.setsort(ls_setsort)
THIS.sort()
end event

