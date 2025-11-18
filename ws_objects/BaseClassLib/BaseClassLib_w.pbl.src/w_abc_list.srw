$PBExportHeader$w_abc_list.srw
$PBExportComments$abc con dos listas, que permite pasar de una a otra
forward
global type w_abc_list from w_base
end type
type dw_1 from u_dw_abc within w_abc_list
end type
type dw_2 from u_dw_abc within w_abc_list
end type
type pb_1 from picturebutton within w_abc_list
end type
type pb_2 from picturebutton within w_abc_list
end type
end forward

global type w_abc_list from w_base
integer width = 2528
integer height = 1708
event ue_open_pre ( )
dw_1 dw_1
dw_2 dw_2
pb_1 pb_1
pb_2 pb_2
end type
global w_abc_list w_abc_list

type variables
protected:
decimal idc_factor = 0.5
end variables

forward prototypes
public subroutine of_sort_dw_2 ()
public subroutine of_sort_dw_1 ()
end prototypes

public subroutine of_sort_dw_2 ();Integer	li_rc, li_x, li_total
string	ls_sort

li_total = UpperBound(dw_1.ii_ck)
IF li_total < 1 THEN RETURN

ls_sort = "#" + String(dw_2.ii_ck[1]) + " A"

FOR li_x = 2 TO li_total
	 ls_sort = ls_sort + ", #" + String(dw_2.ii_ck[li_x]) +" A"
NEXT

dw_2.SetSort (ls_sort)
dw_2.Sort()


end subroutine

public subroutine of_sort_dw_1 ();Integer	li_rc, li_x, li_total
string	ls_sort

li_total = UpperBound(dw_1.ii_ck)
IF li_total < 1 THEN RETURN

ls_sort = "#" + String(dw_1.ii_ck[1]) + " A"

FOR li_x = 2 TO li_total
	 ls_sort = ls_sort + ", #" + String(dw_1.ii_ck[li_x]) +" A"
NEXT

dw_1.SetSort (ls_sort)
dw_1.Sort()


end subroutine

on w_abc_list.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
end on

on w_abc_list.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event resize;call super::resize;dw_1.height = p_pie.y - dw_1.y - this.cii_Windowborder
dw_2.height = p_pie.y - dw_2.y - this.cii_Windowborder

pb_1.x = newwidth * idc_factor - pb_1.width / 2
pb_2.x = pb_1.x

dw_1.width = pb_1.x - dw_1.x - this.cii_Windowborder
dw_2.x = pb_1.x + pb_1.width + this.cii_Windowborder
dw_2.width = newwidth - dw_2.x - this.cii_Windowborder
end event

type p_pie from w_base`p_pie within w_abc_list
end type

type ole_skin from w_base`ole_skin within w_abc_list
end type

type dw_1 from u_dw_abc within w_abc_list
integer x = 23
integer y = 32
integer width = 777
integer height = 1112
boolean bringtotop = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, grid, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple

idw_det  = dw_2 				// dw_detail 
 
//ii_ck[1] = 1          // columna, que juega como key
//ii_dk[1] = 1				// Deploy key
//ii_rk[1] = 1				// Receive key


end event

event ue_selected_row;call super::ue_selected_row;dw_2.ii_update = 1
end event

type dw_2 from u_dw_abc within w_abc_list
integer x = 997
integer y = 32
integer width = 777
integer height = 1112
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, grid, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple
idw_det  = dw_1  	

//ii_ck[1] = 1          // columna, que juega como key
//ii_dk[1] = 1				// Deploy key
//ii_rk[1] = 1				// Receive key

end event

event ue_selected_row;call super::ue_selected_row;dw_1.ii_update = 1
end event

type pb_1 from picturebutton within w_abc_list
integer x = 823
integer y = 376
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
vtextalign vtextalign = vcenter!
boolean map3dcolors = true
end type

event clicked;
dw_1.EVENT ue_selected_row()

// ordenar ventana derecha
of_sort_dw_2()

end event

type pb_2 from picturebutton within w_abc_list
integer x = 823
integer y = 624
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
vtextalign vtextalign = vcenter!
boolean map3dcolors = true
end type

event clicked;
dw_2.EVENT ue_selected_row()

// ordenar ventana izquierda
of_sort_dw_1()
end event

