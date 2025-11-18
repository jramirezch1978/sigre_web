$PBExportHeader$w_pop_articulos_bk.srw
forward
global type w_pop_articulos_bk from w_cns
end type
type dw_detail from u_dw_abc within w_pop_articulos_bk
end type
type st_2 from statictext within w_pop_articulos_bk
end type
type st_1 from statictext within w_pop_articulos_bk
end type
type ddlb_orden from dropdownlistbox within w_pop_articulos_bk
end type
type dw_master from u_dw_cns within w_pop_articulos_bk
end type
type dw_1 from datawindow within w_pop_articulos_bk
end type
type cb_1 from commandbutton within w_pop_articulos_bk
end type
end forward

global type w_pop_articulos_bk from w_cns
integer width = 2437
integer height = 1528
string title = "Articulos"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 1073741824
dw_detail dw_detail
st_2 st_2
st_1 st_1
ddlb_orden ddlb_orden
dw_master dw_master
dw_1 dw_1
cb_1 cb_1
end type
global w_pop_articulos_bk w_pop_articulos_bk

type variables
str_parametros ist_datos
String is_opcion, is_par, is_campo
end variables

forward prototypes
public function string wf_condicion_sql (string as_cadena)
end prototypes

public function string wf_condicion_sql (string as_cadena);//****************************************************************************************//
// Permite Crear el Criterio de Filtro dentro del Where
//****************************************************************************************//
String  ls_descripcion

ls_descripcion = "'"+TRIM(dw_1.object.campo[1])+'%'+"'"
if Pos(UPPER(dw_master.GetSQLSelect()),'WHERE',1) > 0 then
	as_cadena = ' AND ( '+ as_cadena +' LIKE '+ls_descripcion+' )'
ELSE
	as_cadena = ' WHERE ( ' + as_cadena +' LIKE '+ls_descripcion+' )' 
END IF	

Return as_cadena
end function

event ue_open_pre();ist_datos.titulo = 'n'

if not isnull( message.stringparm) then
	is_par = message.stringparm
else
	is_par = ''
end if

ddlb_orden.SelectItem(3)
ddlb_orden.event selectionchanged(3)

dw_1.object.campo.background.color = RGB(192,192,192)			
dw_1.object.campo.protect = 1

//			this.object.cantidad[row] = 0

end event

on w_pop_articulos_bk.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.st_2=create st_2
this.st_1=create st_1
this.ddlb_orden=create ddlb_orden
this.dw_master=create dw_master
this.dw_1=create dw_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.ddlb_orden
this.Control[iCurrent+5]=this.dw_master
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.cb_1
end on

on w_pop_articulos_bk.destroy
call super::destroy
destroy(this.dw_detail)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.ddlb_orden)
destroy(this.dw_master)
destroy(this.dw_1)
destroy(this.cb_1)
end on

type p_pie from w_cns`p_pie within w_pop_articulos_bk
end type

type ole_skin from w_cns`ole_skin within w_pop_articulos_bk
end type

type dw_detail from u_dw_abc within w_pop_articulos_bk
integer x = 18
integer y = 820
integer width = 2203
integer height = 472
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular' 
end event

event doubleclicked;call super::doubleclicked;if this.GetRow() > 0 then		
	ist_datos.titulo = "s"			
		
	ist_datos.field_ret[1] = this.object.cod_art[row]
	ist_datos.field_ret[2] = this.object.desc_Art[row]
	ist_datos.field_ret[3] = this.object.und[row]
	ist_datos.field_ret[4] = String(this.object.costo_ult_compra[row])	
	ist_datos.field_ret[5] = String(this.object.dias_reposicion [row])
	ist_datos.field_ret[6] = String(this.object.dias_rep_import [row])
	CloseWithReturn( parent, ist_datos)
end if
end event

type st_2 from statictext within w_pop_articulos_bk
integer x = 709
integer y = 48
integer width = 695
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "busca por:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pop_articulos_bk
integer x = 46
integer y = 44
integer width = 183
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Orden:"
boolean focusrectangle = false
end type

type ddlb_orden from dropdownlistbox within w_pop_articulos_bk
integer x = 229
integer y = 32
integer width = 462
integer height = 352
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"Categoria","Sub Categoria","Articulo"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;Choose case index
	case 1  // Categoria
		dw_master.DataObject = "d_sel_categoria"		
		dw_detail.DataObject = "d_sel_articulo_cat"
		is_opcion = '1'
	case 2  // Sub categoria
		dw_master.DataObject = "d_sel_sub_categoria"
		dw_detail.DataObject = "d_sel_articulo_sub_cat"
		is_opcion = '2'
	case 3  // articulo
		if is_par = 'all' then   // debe mostrar todos los articulos
			dw_master.DataObject = "d_sel_articulo_all"
		else
			dw_master.DataObject = "d_sel_articulo"
		end if
		dw_detail.DataObject = "d_abc_articulo_equivalencias_tbl"
		is_opcion = '3'
end choose
dw_master.SetTransObject( SQLCA)	
dw_detail.SetTransObject( SQLCA)	

dw_master.triggerevent(doubleclicked!)
//dw_master.retrieve()	
end event

type dw_master from u_dw_cns within w_pop_articulos_bk
integer x = 18
integer y = 148
integer width = 2199
integer height = 644
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw
// ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;dw_1.SetFocus()
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return
f_Select_current_row(this)
Choose case is_opcion
	case '1'
		dw_detail.retrieve( dw_master.object.cat_art[currentrow])
	case '2'
		dw_detail.retrieve( dw_master.object.cod_sub_cat[currentrow])
	case '3'		
		dw_detail.retrieve( dw_master.object.cod_art[currentrow])
End Choose
end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN	
	is_campo = UPPER( mid(ls_column,1,li_pos - 1) )		
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"

	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_2.text = "Busca por: " + This.Describe(ls_column)  //is_col
	dw_1.reset()
	dw_1.InsertRow(0)
	dw_1.SetFocus()
	
	dw_1.object.campo.background.color = RGB(255,255,255)
	dw_1.object.campo.protect = 0
END  IF

if Row > 0 AND is_opcion = '3' then		
	ist_datos.titulo = "s"			
		
	ist_datos.field_ret[1] = this.object.cod_art[row]
	ist_datos.field_ret[2] = this.object.desc_Art[row]
	ist_datos.field_ret[3] = this.object.und[row]
	ist_datos.field_ret[4] = String(this.object.costo_ult_compra[row])
	ist_datos.field_ret[5] = String(this.object.dias_reposicion [row])
	ist_datos.field_ret[6] = String(this.object.dias_rep_import [row])
	
	CloseWithReturn( parent, ist_datos)
end if
end event

type dw_1 from datawindow within w_pop_articulos_bk
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 1426
integer y = 36
integer width = 965
integer height = 80
integer taborder = 20
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_master.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_master.scrollnextrow()	
end if
ll_row = dw_1.Getrow()

//dw_lista.SelectRow(0, false)
//dw_lista.SelectRow(ll_row, true)
//dw_1.object.campo[1] = dw_lista.GetItemString(ll_row, is_col)
end event

event dwnenter;//Send(Handle(this),256,9,Long(0,0))

Integer ll_i
String  ls_sql_old,ls_sql_new, ls_descripcion, ls_campo

THIS.ACCEPTTEXT()

IF TRIM(is_campo) = ''  THEN
	Messagebox( "Error", "de Doble click sobre campo a buscar")
	Return 0
END IF

ls_sql_old   = dw_master.GetSQLSelect()

ls_descripcion = "'"+Upper(TRIM(dw_1.object.campo[1]))+'%'+"'"
if Pos(UPPER(dw_master.GetSQLSelect()),'WHERE',1) > 0 then
	ls_campo = ' AND ( to_upper('+ is_campo +') LIKE '+ls_descripcion+' )'
ELSE
	ls_campo = ' WHERE ( to_upper(' + is_campo +') LIKE '+ls_descripcion+' )' 
END IF	

ls_sql_new   = ls_sql_old + ls_campo

IF dw_master.SetSQLSelect(ls_sql_new) = 1 THEN
	dw_master.Retrieve(gnvo_app.invo_empresa.is_empresa)
ELSE
	Return -1	
END IF
dw_master.SetSQLSelect(ls_sql_old)
dw_master.setfocus()

dw_1.object.campo[1] = ''   // Limpia dato a buscar
THIS.ACCEPTTEXT()
dw_master.triggerevent(doubleclicked!)

return 1
end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

//if TRIM( is_col) <> '' THEN
ls_item = upper( this.GetText())
li_longitud = len( ls_item)
Choose case is_opcion
	case '1'		
		ls_comando = "UPPER(LEFT(DESC_CATEGORIA," + String(li_longitud) + "))='" + ls_item + "'"
	case '2'
		ls_comando = "UPPER(LEFT(DESC_SUB_CAT," + String(li_longitud) + "))='" + ls_item + "'"
	case '3'
		ls_comando = "UPPER(LEFT(DESC_ART," + String(li_longitud) + "))='" + ls_item + "'"
End choose
	
if li_longitud > 0 then		// si ha escrito algo	
//	ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())
//	if ll_fila <> 0 then		// la busqueda resulto exitosa
//		dw_master.selectrow(0, false)
//		dw_master.selectrow(ll_fila,true)
//		dw_master.scrolltorow(ll_fila)
//	end if
End if
SetPointer(arrow!)
end event

event constructor;	// Adiciona registro en dw1
	Long ll_reg

	ll_reg = dw_1.insertrow(0)


end event

type cb_1 from commandbutton within w_pop_articulos_bk
integer x = 1134
integer y = 1320
integer width = 247
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
end type

event clicked;ist_datos.titulo = "n"
CloseWithReturn( parent, ist_datos)

end event

