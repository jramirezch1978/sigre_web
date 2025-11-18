$PBExportHeader$cls_vuo_filter.sru
forward
global type cls_vuo_filter from userobject
end type
type pb_f from picturebutton within cls_vuo_filter
end type
type sle_b from singlelineedit within cls_vuo_filter
end type
type ddplb_col from dropdownpicturelistbox within cls_vuo_filter
end type
end forward

global type cls_vuo_filter from userobject
integer width = 1961
integer height = 104
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_filtrar ( string as_campo,  string as_valor )
event key pbm_keydown
pb_f pb_f
sle_b sle_b
ddplb_col ddplb_col
end type
global cls_vuo_filter cls_vuo_filter

type variables
integer ii_Campo_Default
boolean ib_RetrieveFields=true

Private:
string	is_campo_nombre, is_campo_tipo
Integer	ii_index=0
string 	is_Colname[], is_ColEti[], is_ColType[]
Boolean  ib_filter = TRUE
datawindow idw_1
end variables

forward prototypes
public function integer of_retrieve_fields ()
public subroutine of_set_dw (datawindow adw_1)
end prototypes

event ue_filtrar(string as_campo, string as_valor);integer li_index
//li_index = ddplb_col.SelectedIndex ( )

if (ib_filter) and (not IsNull(idw_1) and IsValid(idw_1)) then
	li_index = ii_index
	
	ddplb_col.setRedraw( false )
	idw_1.dynamic function of_setfilter(as_campo, as_valor)
	idw_1.SetFocus( )
	
	if ddplb_col.TotalItems() >= li_index then
		
		ddplb_col.Selectitem( li_index )
		ddplb_col.event ue_changed_index( li_index )
		
	elseif ddplb_col.TotalItems() > 0 then
		
		ddplb_col.Selectitem( 1 )
		ddplb_col.event ue_changed_index( 1 )
		
	end if
	
	ddplb_col.setRedraw( true )
	sle_b.SetFocus()
	
end if
end event

public function integer of_retrieve_fields ();integer 	li_col, li_numcols, li_kc, li_index_picture
string 	ls_col_visible, ls_nom_col, ls_data_type
integer 	li_Count, li_index
n_Cst_utilities  lnvo_utilities

li_Count = 0
li_kc=0
li_numcols=integer(idw_1.describe("datawindow.column.count"))

li_index = ii_index

// Limpio el DropDownListBox
ddplb_col.reset( )

// Lo lleno con los datos del campo
for li_col =1 to li_numcols
	ls_nom_col = idw_1.describe("#"+string(li_col)+".name")
	ls_col_visible=idw_1.describe(ls_nom_col + ".visible")
	if ls_col_visible='1' and (idw_1.describe(ls_nom_col+"_t.text") <> "!" &
		or idw_1.describe(ls_nom_col+"_t.text")="") then 
		
		li_kc++
		is_colname	[li_kc] = idw_1.describe("#"+string(li_col)+".name")
		is_coleti	[li_kc] = trim(idw_1.describe(is_colname[li_kc]+"_t.text"))		
		
		// Si el Titulo de la columna tiene saltos de linea hay que sacarlos
		if pos(is_coleti[li_kc],"~r~n") > 0 then
			lnvo_utilities = create n_cst_utilities
			is_coleti [li_kc] = lnvo_utilities.replace( is_coleti[li_kc], "~r~n", " ")
			destroy lnvo_utilities
		end if
		
		ls_data_type = idw_1.describe("#"+string(li_col)+".ColType")
		if pos(ls_data_type,"(") >0 then 
			ls_data_type= mid(ls_data_type,1,pos(ls_data_type,"(") - 1)
		end if
		
		is_colType[li_kc]	= ls_data_type
		
		choose case ls_data_type
			case 'char'
				li_index_picture = 1
			case 'decimal'
				li_index_picture = 2
			case 'date'
				li_index_picture = 3
			case else
				li_index_picture = 4
		end choose

		ddplb_col.additem(is_coleti[li_kc], li_index_picture)
	end if
next

//Si ya existe un campo seleccionado entonces lo muestro de lo contrario
//tomo el campo que esta por defecto
if li_index > 0 then
	ddplb_col.selectitem(li_index)
	ddplb_col.event selectionchanged(li_index)
else
	if ddplb_col.totalitems()>0 then
		if ii_Campo_Default > 0 and ii_Campo_Default<=ddplb_col.totalitems() then
			ddplb_col.selectitem(ii_Campo_Default)
			ddplb_col.event selectionchanged(ii_Campo_Default)
		else	
			ddplb_col.selectitem(1)
			ddplb_col.event selectionchanged( 1)
		end if	
	end if
end if

return 0
end function

public subroutine of_set_dw (datawindow adw_1);idw_1 = adw_1
end subroutine

on cls_vuo_filter.create
this.pb_f=create pb_f
this.sle_b=create sle_b
this.ddplb_col=create ddplb_col
this.Control[]={this.pb_f,&
this.sle_b,&
this.ddplb_col}
end on

on cls_vuo_filter.destroy
destroy(this.pb_f)
destroy(this.sle_b)
destroy(this.ddplb_col)
end on

type pb_f from picturebutton within cls_vuo_filter
integer x = 1851
integer y = 4
integer width = 110
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "BrowseClasses!"
alignment htextalign = left!
string powertiptext = "Filtrar"
end type

event getfocus;default=true


end event

event losefocus;default=FALSE



end event

event clicked;string ls_valor
ls_valor=TRIM(sle_b.text)
event ue_filtrar( is_campo_nombre, ls_valor)



end event

type sle_b from singlelineedit within cls_vuo_filter
event keydown pbm_keydown
event keyup pbm_keyup
integer x = 658
integer y = 4
integer width = 1189
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217729
textcase textcase = upper!
end type

event keydown;//Pb_f.event clicked( )
////if key=keyenter! then 
////	Pb_f.event clicked( )
////end if	
//parent.event key( key, keyflags)
end event

event keyup;if key=keyescape! then return 
Pb_f.event clicked( )
//if key=keyenter! then 
//	Pb_f.event clicked( )
//end if	
parent.event key( key, keyflags)
end event

type ddplb_col from dropdownpicturelistbox within cls_vuo_filter
event ue_changed_index ( integer ai_index )
integer x = 9
integer y = 4
integer width = 649
integer height = 628
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 134217732
boolean sorted = false
boolean vscrollbar = true
string picturename[] = {"Compile!","Compute!","Bold!","DataManip!"}
long picturemaskcolor = 536870912
end type

event ue_changed_index(integer ai_index);ii_index = ai_index
is_campo_nombre = is_colname[ii_index]
is_campo_tipo	 = is_coltype[ii_index]
end event

event selectionchanged;this.event ue_changed_index( index )
end event

