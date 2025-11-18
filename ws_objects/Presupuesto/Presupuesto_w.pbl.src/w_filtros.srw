$PBExportHeader$w_filtros.srw
forward
global type w_filtros from w_abc
end type
type cb_3 from commandbutton within w_filtros
end type
type cb_2 from commandbutton within w_filtros
end type
type ddlb_24 from dropdownlistbox within w_filtros
end type
type ddlb_23 from dropdownlistbox within w_filtros
end type
type ddlb_22 from dropdownlistbox within w_filtros
end type
type ddlb_21 from dropdownlistbox within w_filtros
end type
type ddlb_14 from dropdownlistbox within w_filtros
end type
type ddlb_13 from dropdownlistbox within w_filtros
end type
type ddlb_12 from dropdownlistbox within w_filtros
end type
type cb_1 from commandbutton within w_filtros
end type
type ddlb_11 from dropdownlistbox within w_filtros
end type
end forward

global type w_filtros from w_abc
integer width = 2514
integer height = 732
string title = "Filtros"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean toolbarvisible = false
cb_3 cb_3
cb_2 cb_2
ddlb_24 ddlb_24
ddlb_23 ddlb_23
ddlb_22 ddlb_22
ddlb_21 ddlb_21
ddlb_14 ddlb_14
ddlb_13 ddlb_13
ddlb_12 ddlb_12
cb_1 cb_1
ddlb_11 ddlb_11
end type
global w_filtros w_filtros

type variables
str_parametros istr_1
String is_campo[], is_type[]
Long il_nro_sel, il_fila
end variables

forward prototypes
public subroutine of_add_item (dropdownlistbox a_ddlb1, datawindow a_dw1)
public subroutine of_add_valores (dropdownlistbox a_ddlb1, dropdownlistbox a_ddlb2, datawindow a_dw1)
end prototypes

public subroutine of_add_item (dropdownlistbox a_ddlb1, datawindow a_dw1);//****************************************************************************************//
// Funcion que inserta los itens al ddlb_seleccion                                        //   
//****************************************************************************************//
Integer i
String  ls_expresion, ls_campo

FOR i = 1 TO Integer(a_dw1.Object.DataWindow.Column.Count)
	 a_dw1.SetTabOrder(i,0)
	 ls_expresion = "#" + string(i) + ".Name"
	 ls_campo =  a_dw1.Describe( ls_expresion )
	 
	 // Guarda nombre de campos en array
	 is_campo[i] = ls_campo	 
	 
	 // Inserta nombre de campo en lista
	 a_ddlb1.InsertItem (ls_campo, i )
	 
	 // Tipo
	 ls_expresion = "#" + string(i) + ".coltype"
	 ls_campo =  a_dw1.Describe( ls_expresion )
	 
	 // Guarda nombre de tipos en array
 	 is_type[i] = ls_campo	 
	  
	 il_nro_sel = 1  // fuerza a que seleccionado el item 1 
NEXT

ls_expresion = "#" + string(1) + ".Name" 
ls_campo = a_dw1.Describe( ls_expresion )  

a_ddlb1.Text = ls_campo
end subroutine

public subroutine of_add_valores (dropdownlistbox a_ddlb1, dropdownlistbox a_ddlb2, datawindow a_dw1);Long i, ll_row, ll_find
String ls_string, ls_campo_sel

ls_campo_sel = a_ddlb1.text

FOR i = 1 TO a_dw1.Rowcount()
	CHOOSE CASE mid( is_type[il_nro_sel],1,4)
		CASE 'char'	
	 		ls_string = a_dw1.getitemstring(i, ls_campo_sel)			 
			 
			// Inserta nombre de campo en lista
			ll_find = a_ddlb2.FindItem(ls_string,1)

			if ll_find = -1 then
	 		   a_ddlb2.InsertItem (ls_string,i)		
			end if
		CASE 'date'
		CASE 'deci'
		END CHOOSE
NEXT
//this.enabled = false
end subroutine

on w_filtros.create
int iCurrent
call super::create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.ddlb_24=create ddlb_24
this.ddlb_23=create ddlb_23
this.ddlb_22=create ddlb_22
this.ddlb_21=create ddlb_21
this.ddlb_14=create ddlb_14
this.ddlb_13=create ddlb_13
this.ddlb_12=create ddlb_12
this.cb_1=create cb_1
this.ddlb_11=create ddlb_11
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.ddlb_24
this.Control[iCurrent+4]=this.ddlb_23
this.Control[iCurrent+5]=this.ddlb_22
this.Control[iCurrent+6]=this.ddlb_21
this.Control[iCurrent+7]=this.ddlb_14
this.Control[iCurrent+8]=this.ddlb_13
this.Control[iCurrent+9]=this.ddlb_12
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.ddlb_11
end on

on w_filtros.destroy
call super::destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.ddlb_24)
destroy(this.ddlb_23)
destroy(this.ddlb_22)
destroy(this.ddlb_21)
destroy(this.ddlb_14)
destroy(this.ddlb_13)
destroy(this.ddlb_12)
destroy(this.cb_1)
destroy(this.ddlb_11)
end on

event ue_open_pre();// Override
str_parametros lstr_1

istr_1 = message.powerobjectparm

//il_fila = 1
//dw_1.insertrow(0)

cb_1.event clicked()
end event

type cb_3 from commandbutton within w_filtros
integer x = 2112
integer y = 400
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Salir"
end type

event clicked;close (parent)
end event

type cb_2 from commandbutton within w_filtros
integer x = 2112
integer y = 180
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Filtrar"
end type

event clicked;String ls_Cad1, ls_Cad2, ls_Cad3, ls_Cad4, Dw_filter

ls_cad1 = ddlb_11.text + " = '" + ddlb_21.text + "'"
ls_cad2 = ddlb_12.text + " = '" + ddlb_22.text + "'"
ls_cad3 = ddlb_13.text + " = '" + ddlb_23.text + "'"
ls_cad4 = ddlb_14.text + " = '" + ddlb_24.text + "'"


CHOOSE CASE il_fila 
	CASE 1
		dw_filter = ls_Cad1 
	CASE 2
		dw_filter = ls_Cad1 + ' AND ' + ls_cad2
	CASE 3
		dw_filter = ls_Cad1 + ' AND ' + ls_cad2 + ' AND ' + ls_Cad3
	CASE 4
		dw_filter = ls_Cad1 + ' AND ' + ls_cad2 + ' AND ' + ls_Cad3 + ' AND ' + ls_Cad4
end choose

istr_1.dw_m.SetFilter(dw_filter)
istr_1.dw_m.Filter()
close (parent)
end event

type ddlb_24 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 974
integer y = 392
integer width = 1051
integer height = 1012
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type ddlb_23 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 974
integer y = 268
integer width = 1051
integer height = 1012
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type ddlb_22 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 974
integer y = 152
integer width = 1051
integer height = 968
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type ddlb_21 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 974
integer y = 40
integer width = 1051
integer height = 1012
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean border = false
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type ddlb_14 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 32
integer y = 392
integer width = 933
integer height = 1012
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;if index > 0 then
	il_nro_sel = index
	of_add_valores(ddlb_14, ddlb_24, istr_1.dw_m)
end if

end event

type ddlb_13 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 32
integer y = 268
integer width = 933
integer height = 1012
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;if index > 0 then
	il_nro_sel = index
	of_add_valores(ddlb_13, ddlb_23, istr_1.dw_m)
end if

end event

type ddlb_12 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 32
integer y = 152
integer width = 933
integer height = 1012
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;if index > 0 then
	il_nro_sel = index
	of_add_valores(ddlb_12, ddlb_22, istr_1.dw_m)
end if

end event

type cb_1 from commandbutton within w_filtros
integer x = 2112
integer y = 56
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Adicionar"
end type

event clicked;//dw_1.insertRow(0)
il_fila = il_fila + 1

CHOOSE CASE il_fila
	CASE 1
		ddlb_11.visible = true
		ddlb_21.visible = true
		of_add_item(ddlb_11, istr_1.dw_m)
	CASE 2
		ddlb_12.visible = true
		ddlb_22.visible = true
		of_add_item(ddlb_12, istr_1.dw_m)
	CASE 3
		ddlb_13.visible = true
		ddlb_23.visible = true
		of_add_item(ddlb_13, istr_1.dw_m)
	CASE 4
		ddlb_14.visible = true
		ddlb_24.visible = true
		of_add_item(ddlb_14, istr_1.dw_m)
END CHOOSE
end event

type ddlb_11 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 32
integer y = 40
integer width = 933
integer height = 1012
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;if index > 0 then
	il_nro_sel = index
	of_add_valores(ddlb_11, ddlb_21, istr_1.dw_m)
end if

end event

