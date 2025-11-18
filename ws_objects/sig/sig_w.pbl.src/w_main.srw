$PBExportHeader$w_main.srw
forward
global type w_main from w_main_ancst
end type
end forward

global type w_main from w_main_ancst
string menuname = "m_frame"
event ue_menu_no_opcion ( )
end type
global w_main w_main

event ue_menu_no_opcion();String 		ls_ubicacion
Long			ll_rc, ll_x, ll_row
Integer		li_nivel, li_y, li_pos[]
Datastore	lds_nomenu

lds_nomenu = CREATE Datastore
lds_nomenu.Dataobject = 'd_menu_no_opcion'
ll_rc = lds_nomenu.SetTransObject(SQLCA)
ll_row = lds_nomenu.Retrieve(gs_sistema)

FOR ll_x = 1 TO ll_row
	ls_ubicacion = lds_nomenu.GetItemString( ll_x, 'ubicacion')
	li_nivel = Len(ls_ubicacion)/2
	DebugBreak()
	FOR li_y = 1 TO li_nivel
		li_pos[li_y] = Integer(MID(ls_ubicacion,(li_y - 1) * 2 + 1,2))
	NEXT
	
	CHOOSE CASE li_nivel
		CASE 1
			THIS.MenuID.item[li_pos[1]].visible = FALSE
		CASE 2
			THIS.MenuID.item[li_pos[1]].item[li_pos[2]].visible = FALSE
		CASE 3
			THIS.MenuID.item[li_pos[1]].item[li_pos[2]].item[li_pos[3]].visible = FALSE
		CASE 4
			THIS.MenuID.item[li_pos[1]].item[li_pos[2]].item[li_pos[3]].item[li_pos[4]].visible = FALSE
		CASE 5
			THIS.MenuID.item[li_pos[1]].item[li_pos[2]].item[li_pos[3]].item[li_pos[4]].item[li_pos[5]].visible = FALSE
		CASE 6
			THIS.MenuID.item[li_pos[1]].item[li_pos[2]].item[li_pos[3]].item[li_pos[4]].item[li_pos[5]].item[li_pos[6]].visible = FALSE
		CASE ELSE
			MessageBox('Error', 'Nivel Equivocado')
	END CHOOSE
NEXT

DESTROY lds_nomenu
end event

on w_main.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_frame" then this.MenuID = create m_frame
end on

on w_main.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;THIS.EVENT ue_menu_no_opcion()
end event

