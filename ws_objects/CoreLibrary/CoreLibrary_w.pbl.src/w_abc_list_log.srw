$PBExportHeader$w_abc_list_log.srw
$PBExportComments$abc con dos listas, que permite pasar de una a otra
forward
global type w_abc_list_log from w_abc_master
end type
type dw_izquierda from u_dw_abc within w_abc_list_log
end type
type pb_1 from picturebutton within w_abc_list_log
end type
type pb_2 from picturebutton within w_abc_list_log
end type
end forward

global type w_abc_list_log from w_abc_master
integer width = 1760
integer height = 1452
dw_izquierda dw_izquierda
pb_1 pb_1
pb_2 pb_2
end type
global w_abc_list_log w_abc_list_log

type variables

end variables

forward prototypes
public subroutine of_sort_dw_1 ()
public subroutine of_sort_dw_2 ()
public subroutine of_sort_dw (u_dw_abc adw_object)
end prototypes

public subroutine of_sort_dw_1 ();//Integer	li_rc, li_x, li_total
//string	ls_sort
//
//li_total = UpperBound(dw_1.ii_ck)
//IF li_total < 1 THEN RETURN
//
//ls_sort = "#" + String(dw_1.ii_ck[1]) + " A"
//
//FOR li_x = 2 TO li_total
//	 ls_sort = ls_sort + ", #" + String(dw_1.ii_ck[li_x]) +" A"
//NEXT
//
//dw_1.SetSort (ls_sort)
//dw_1.Sort()
//
//
end subroutine

public subroutine of_sort_dw_2 ();//Integer	li_rc, li_x, li_total
//string	ls_sort
//
//li_total = UpperBound(dw_1.ii_ck)
//IF li_total < 1 THEN RETURN
//
//ls_sort = "#" + String(dw_2.ii_ck[1]) + " A"
//
//FOR li_x = 2 TO li_total
//	 ls_sort = ls_sort + ", #" + String(dw_2.ii_ck[li_x]) +" A"
//NEXT
//
//dw_2.SetSort (ls_sort)
//dw_2.Sort()
//
//
end subroutine

public subroutine of_sort_dw (u_dw_abc adw_object);Integer	li_rc, li_x, li_total
string	ls_sort

li_total = UpperBound(adw_object.ii_ck)
IF li_total < 1 THEN RETURN

ls_sort = "#" + String(adw_object.ii_ck[1]) + " A"

FOR li_x = 2 TO li_total
	 ls_sort = ls_sort + ", #" + String(adw_object.ii_ck[li_x]) +" A"
NEXT

adw_object.SetSort (ls_sort)
adw_object.Sort()
end subroutine

on w_abc_list_log.create
int iCurrent
call super::create
this.dw_izquierda=create dw_izquierda
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_izquierda
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
end on

on w_abc_list_log.destroy
call super::destroy
destroy(this.dw_izquierda)
destroy(this.pb_1)
destroy(this.pb_2)
end on

type dw_master from w_abc_master`dw_master within w_abc_list_log
integer x = 987
integer y = 528
integer width = 695
integer height = 776
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, grid, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple
idw_det  = dw_izquierda  	

//ii_ck[1] = 1          // columna, que juega como key
//ii_dk[1] = 1				// Deploy key
//ii_rk[1] = 1				// Receive key

end event

event dw_master::ue_selected_row();call super::ue_selected_row;dw_izquierda.ii_update = 1
end event

type dw_izquierda from u_dw_abc within w_abc_list_log
integer x = 37
integer y = 528
integer width = 704
integer height = 776
boolean bringtotop = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, grid, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple

idw_det  = dw_master 				// dw_detail 
 
//ii_ck[1] = 1          // columna, que juega como key
//ii_dk[1] = 1				// Deploy key
//ii_rk[1] = 1				// Receive key


end event

event ue_selected_row();call super::ue_selected_row;dw_master.ii_update = 1
end event

type pb_1 from picturebutton within w_abc_list_log
integer x = 782
integer y = 664
integer width = 146
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = " >"
alignment htextalign = left!
end type

event clicked;
dw_izquierda.EVENT ue_selected_row()
of_sort_dw(dw_master)			// ordenar ventana derecha

end event

type pb_2 from picturebutton within w_abc_list_log
integer x = 791
integer y = 992
integer width = 146
integer height = 120
integer taborder = 20
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
alignment htextalign = left!
end type

event clicked;
dw_master.EVENT ue_selected_row()
of_sort_dw(dw_izquierda)					// ordenar ventana izquierda
end event

