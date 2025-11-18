$PBExportHeader$w_filtros.srw
forward
global type w_filtros from w_abc
end type
type cb_eli from commandbutton within w_filtros
end type
type ddlb_log3 from dropdownlistbox within w_filtros
end type
type ddlb_log2 from dropdownlistbox within w_filtros
end type
type ddlb_log1 from dropdownlistbox within w_filtros
end type
type ddlb_cond4 from dropdownlistbox within w_filtros
end type
type ddlb_cond3 from dropdownlistbox within w_filtros
end type
type ddlb_cond2 from dropdownlistbox within w_filtros
end type
type ddlb_cond1 from dropdownlistbox within w_filtros
end type
type cb_filtrar from commandbutton within w_filtros
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
integer width = 2633
integer height = 712
string title = "Filtros"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean toolbarvisible = false
cb_eli cb_eli
ddlb_log3 ddlb_log3
ddlb_log2 ddlb_log2
ddlb_log1 ddlb_log1
ddlb_cond4 ddlb_cond4
ddlb_cond3 ddlb_cond3
ddlb_cond2 ddlb_cond2
ddlb_cond1 ddlb_cond1
cb_filtrar cb_filtrar
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
String is_campo[], is_type[], is_tipo1, is_tipo2, is_tipo3, is_tipo4
Long il_nro_sel, il_fila
end variables

forward prototypes
public subroutine of_add_valores (dropdownlistbox a_ddlb1, dropdownlistbox a_ddlb2, datawindow a_dw1)
public subroutine of_add_item (dropdownlistbox a_ddlb1, datawindow a_dw1)
end prototypes

public subroutine of_add_valores (dropdownlistbox a_ddlb1, dropdownlistbox a_ddlb2, datawindow a_dw1);Long i, ll_row, ll_find, ll_ind
String ls_string, ls_campo_sel

ls_campo_sel = a_ddlb1.text

a_ddlb2.reset()

ll_ind = 0
FOR i = 1 TO a_dw1.Rowcount()
	CHOOSE CASE mid( is_type[il_nro_sel],1,4)
		CASE 'char'	
	 		ls_string = a_dw1.getitemstring(i, ls_campo_sel) 			
		CASE 'date'
			ls_string = STRING( a_dw1.GetItemDateTime(i, ls_campo_sel), 'dd/mm/yyyy')			
		CASE 'deci'
			ls_string = STRING( a_dw1.GetItemNumber(i, ls_campo_sel), '###.00')
		CASE else
			messagebox( "Atencion", 'Tipo de dato no controlado')
	END CHOOSE
	// Inserta nombre de campo en lista
	ll_find = a_ddlb2.FindItem(ls_string,1)
			
	if ll_find = -1 then
		ll_ind = ll_ind + 1
	   a_ddlb2.InsertItem (ls_string,ll_ind)		
	end if	
NEXT
end subroutine

public subroutine of_add_item (dropdownlistbox a_ddlb1, datawindow a_dw1);//****************************************************************************************//
// Funcion que inserta los itens al ddlb_seleccion                                        //   
//****************************************************************************************//
Integer i
String  ls_expresion, ls_campo
long ll_row

ll_row = Integer(a_dw1.Object.DataWindow.Column.Count)
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


end subroutine

on w_filtros.create
int iCurrent
call super::create
this.cb_eli=create cb_eli
this.ddlb_log3=create ddlb_log3
this.ddlb_log2=create ddlb_log2
this.ddlb_log1=create ddlb_log1
this.ddlb_cond4=create ddlb_cond4
this.ddlb_cond3=create ddlb_cond3
this.ddlb_cond2=create ddlb_cond2
this.ddlb_cond1=create ddlb_cond1
this.cb_filtrar=create cb_filtrar
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
this.Control[iCurrent+1]=this.cb_eli
this.Control[iCurrent+2]=this.ddlb_log3
this.Control[iCurrent+3]=this.ddlb_log2
this.Control[iCurrent+4]=this.ddlb_log1
this.Control[iCurrent+5]=this.ddlb_cond4
this.Control[iCurrent+6]=this.ddlb_cond3
this.Control[iCurrent+7]=this.ddlb_cond2
this.Control[iCurrent+8]=this.ddlb_cond1
this.Control[iCurrent+9]=this.cb_filtrar
this.Control[iCurrent+10]=this.ddlb_24
this.Control[iCurrent+11]=this.ddlb_23
this.Control[iCurrent+12]=this.ddlb_22
this.Control[iCurrent+13]=this.ddlb_21
this.Control[iCurrent+14]=this.ddlb_14
this.Control[iCurrent+15]=this.ddlb_13
this.Control[iCurrent+16]=this.ddlb_12
this.Control[iCurrent+17]=this.cb_1
this.Control[iCurrent+18]=this.ddlb_11
end on

on w_filtros.destroy
call super::destroy
destroy(this.cb_eli)
destroy(this.ddlb_log3)
destroy(this.ddlb_log2)
destroy(this.ddlb_log1)
destroy(this.ddlb_cond4)
destroy(this.ddlb_cond3)
destroy(this.ddlb_cond2)
destroy(this.ddlb_cond1)
destroy(this.cb_filtrar)
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

cb_1.event clicked()
end event

type cb_eli from commandbutton within w_filtros
integer x = 2327
integer y = 172
integer width = 256
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Eliminar"
end type

event clicked;CHOOSE CASE il_fila
	CASE 1
		ddlb_11.visible = false
		ddlb_cond1.visible = false
		ddlb_21.visible = false
	CASE 2
		ddlb_log1.visible = false
		ddlb_12.visible = false
		ddlb_22.visible = false
		ddlb_cond2.visible = false
	CASE 3
		ddlb_log2.visible = false
		ddlb_13.visible = false
		ddlb_23.visible = false
		ddlb_cond3.visible = false
	CASE 4
		ddlb_log3.visible = false
		ddlb_14.visible = false
		ddlb_24.visible = false
		ddlb_cond4.visible = false
END CHOOSE
il_fila = il_fila - 1
end event

type ddlb_log3 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 2011
integer y = 272
integer width = 242
integer height = 352
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"and","or"}
borderstyle borderstyle = stylelowered!
end type

type ddlb_log2 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 2011
integer y = 156
integer width = 242
integer height = 352
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"and","or"}
borderstyle borderstyle = stylelowered!
end type

type ddlb_log1 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 2011
integer y = 40
integer width = 242
integer height = 352
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"and","or"}
borderstyle borderstyle = stylelowered!
end type

type ddlb_cond4 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 832
integer y = 396
integer width = 174
integer height = 484
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"=",">","<",">=","<="}
borderstyle borderstyle = stylelowered!
end type

type ddlb_cond3 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 832
integer y = 276
integer width = 174
integer height = 484
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"=",">","<",">=","<="}
borderstyle borderstyle = stylelowered!
end type

type ddlb_cond2 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 832
integer y = 156
integer width = 174
integer height = 484
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"=",">","<",">=","<="}
borderstyle borderstyle = stylelowered!
end type

type ddlb_cond1 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 832
integer y = 44
integer width = 174
integer height = 504
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"=",">","<",">=","<="}
borderstyle borderstyle = stylelowered!
end type

type cb_filtrar from commandbutton within w_filtros
integer x = 2327
integer y = 368
integer width = 256
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

event clicked;String ls_Cad1, ls_Cad2, ls_Cad3, ls_Cad4, Dw_filter, ls_tipo
Long ll_index

// tipo Char
if LEFT( is_tipo1,4) = 'char' then
	ls_cad1 = ddlb_11.text + ddlb_cond1.text + "'" + ddlb_21.text + "'"	
end if
if LEFT( is_tipo2,4) = 'char' then
	ls_cad2 = ddlb_12.text + ddlb_cond2.text + "'" + ddlb_22.text + "'"
end if
if LEFT( is_tipo3,4) = 'char' then
	ls_cad3 = ddlb_13.text + ddlb_cond3.text + "'" + ddlb_23.text + "'"
end if
if LEFT( is_tipo4,4) = 'char' then
	ls_cad4 = ddlb_14.text + ddlb_cond4.text + "'" + ddlb_24.text + "'"
end if

// tipo Date
if LEFT( is_tipo1,4) = 'date' then
	ls_cad1 = "string(" + ddlb_11.text + ", 'dd/mm/yyyy')" + ddlb_cond1.text + "'" + ddlb_21.text + "'"	
end if
if LEFT( is_tipo2,4) = 'date' then
	ls_cad2 = "string(" + ddlb_12.text + ", 'dd/mm/yyyy')" + ddlb_cond2.text + "'" + ddlb_22.text + "'"
end if
if LEFT( is_tipo3,4) = 'date' then
	ls_cad3 = "string(" + ddlb_13.text + ", 'dd/mm/yyyy')" + ddlb_cond3.text + "'" + ddlb_23.text + "'"	
end if
if LEFT( is_tipo4,4) = 'date' then
	ls_cad4 = "string(" + ddlb_14.text + ", 'dd/mm/yyyy')" + ddlb_cond4.text + "'" + ddlb_24.text + "'"	
end if

// tipo Number
if LEFT( is_tipo1,4) = 'deci' then
	ls_cad1 = ddlb_11.text + " " + ddlb_cond1.text + " NUMBER('" + ddlb_21.text + "')"
end if
if LEFT( is_tipo2,4) = 'deci' then
	ls_cad2 = ddlb_12.text + " " + ddlb_cond2.text + " NUMBER('" + ddlb_22.text + "')"	
end if
if LEFT( is_tipo3,4) = 'deci' then
	ls_cad3 = ddlb_13.text + " " + ddlb_cond3.text + " NUMBER('" + ddlb_23.text + "')"	
end if
if LEFT( is_tipo4,4) = 'deci' then
	ls_cad4 = ddlb_14.text + " " + ddlb_cond4.text + " NUMBER('" + ddlb_24.text + "')"	
end if
CHOOSE CASE il_fila 
	CASE 1
		dw_filter = ls_Cad1 
	CASE 2
		dw_filter = ls_Cad1 + " " + ddlb_log1.text + " " + ls_cad2
	CASE 3
		dw_filter = ls_Cad1 + " " + ddlb_log1.text + " " + ls_cad2 + &
		            " " + ddlb_log2.text + " " + ls_Cad3
	CASE 4
		dw_filter = ls_Cad1 + " " + ddlb_log1.text + " " + &
						ls_cad2 + " " + ddlb_log2.text + " " + &
						ls_Cad3 + " " + ddlb_log3.text + " " + ls_cad4
//		dw_filter = ls_Cad1 + ' AND ' + ls_cad2 + ' AND ' + ls_Cad3 + ' AND ' + ls_Cad4
end choose

istr_1.dw_m.SetFilter(dw_filter)
istr_1.dw_m.Filter()
close (parent)
return 1
end event

type ddlb_24 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 1029
integer y = 392
integer width = 969
integer height = 1012
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean allowedit = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event modified;cb_filtrar.enabled = true
end event

type ddlb_23 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 1029
integer y = 268
integer width = 969
integer height = 1012
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean allowedit = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event modified;cb_filtrar.enabled = true
end event

type ddlb_22 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 1029
integer y = 152
integer width = 969
integer height = 968
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean allowedit = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event modified;cb_filtrar.enabled = true
end event

type ddlb_21 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 1029
integer y = 40
integer width = 969
integer height = 1012
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean allowedit = true
boolean border = false
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event modified;cb_filtrar.enabled = true
end event

type ddlb_14 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 32
integer y = 392
integer width = 791
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
	is_tipo4 = is_type[index]
	of_add_valores(ddlb_14, ddlb_24, istr_1.dw_m)
end if

end event

type ddlb_13 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 32
integer y = 268
integer width = 791
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
	is_tipo3 = is_type[index]
	of_add_valores(ddlb_13, ddlb_23, istr_1.dw_m)
end if

end event

type ddlb_12 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 32
integer y = 152
integer width = 791
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
	is_tipo2 = is_type[index]
	of_add_valores(ddlb_12, ddlb_22, istr_1.dw_m)
end if

end event

type cb_1 from commandbutton within w_filtros
integer x = 2327
integer y = 56
integer width = 256
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

event clicked;if il_fila = 4 then return 
il_fila = il_fila + 1

cb_filtrar.enabled = false
CHOOSE CASE il_fila
	CASE 1
		ddlb_11.visible = true
		ddlb_cond1.visible = true
		ddlb_21.visible = true
		ddlb_cond1.text = '='	
		of_add_item(ddlb_11, istr_1.dw_m)
	CASE 2
		ddlb_log1.visible = true
		ddlb_log1.text = 'and'
		ddlb_12.visible = true
		ddlb_22.visible = true
		ddlb_cond2.visible = true
		ddlb_cond2.text = '='		
		of_add_item(ddlb_12, istr_1.dw_m)
	CASE 3
		ddlb_log2.visible = true
		ddlb_log2.text = 'and'
		ddlb_13.visible = true
		ddlb_23.visible = true
		ddlb_cond3.visible = true
		ddlb_cond3.text = '='		
		of_add_item(ddlb_13, istr_1.dw_m)
	CASE 4
		ddlb_log3.visible = true
		ddlb_log3.text = 'and'
		ddlb_14.visible = true
		ddlb_24.visible = true
		ddlb_cond4.visible = true
		ddlb_cond4.text = '='		
		of_add_item(ddlb_14, istr_1.dw_m)
END CHOOSE
end event

type ddlb_11 from dropdownlistbox within w_filtros
boolean visible = false
integer x = 32
integer y = 40
integer width = 791
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
	is_tipo1 = is_type[index]
	of_add_valores(ddlb_11, ddlb_21, istr_1.dw_m)
end if

end event

