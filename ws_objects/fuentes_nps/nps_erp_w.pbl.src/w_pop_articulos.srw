$PBExportHeader$w_pop_articulos.srw
forward
global type w_pop_articulos from w_cns
end type
type st_2 from statictext within w_pop_articulos
end type
type dw_master from u_dw_cns within w_pop_articulos
end type
type dw_1 from datawindow within w_pop_articulos
end type
type cb_1 from commandbutton within w_pop_articulos
end type
end forward

global type w_pop_articulos from w_cns
integer width = 2816
integer height = 1860
string title = "Articulos"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_2 st_2
dw_master dw_master
dw_1 dw_1
cb_1 cb_1
end type
global w_pop_articulos w_pop_articulos

type variables
str_parametros 	ist_datos
String 				is_opcion, is_par, is_campo, is_almacen
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

event ue_open_pre;ist_datos.titulo = 'n'

if not isnull( message.PowerObjectParm) then
	ist_datos = message.PowerObjectParm
	is_almacen = ist_datos.almacen + '%'
else
	is_almacen = '%%'
end if

dw_1.SetFocus( )
end event

on w_pop_articulos.create
int iCurrent
call super::create
this.st_2=create st_2
this.dw_master=create dw_master
this.dw_1=create dw_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.dw_master
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.cb_1
end on

on w_pop_articulos.destroy
call super::destroy
destroy(this.st_2)
destroy(this.dw_master)
destroy(this.dw_1)
destroy(this.cb_1)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - this.cii_windowborder
dw_master.height = p_pie.y - dw_master.y 
end event

type p_pie from w_cns`p_pie within w_pop_articulos
integer x = 0
integer y = 1496
end type

type ole_skin from w_cns`ole_skin within w_pop_articulos
integer x = 2277
end type

type st_2 from statictext within w_pop_articulos
integer x = 55
integer y = 36
integer width = 366
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Busca:"
boolean focusrectangle = false
end type

type dw_master from u_dw_cns within w_pop_articulos
event ue_return ( long al_row )
integer y = 140
integer width = 2761
integer height = 1324
boolean bringtotop = true
string dataobject = "d_sel_articulo_busca_all"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_return(long al_row);Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

if al_Row > 0 then		
	ist_datos.titulo = "s"			
		
	ist_datos.field_ret[1] = this.object.cod_art			[al_row]
	ist_datos.field_ret[2] = this.object.desc_Art		[al_row]
	ist_datos.field_ret[3] = this.object.und				[al_row]
	ist_datos.field_ret[4] = String(this.object.costo_ult_compra[al_row])
	ist_datos.field_ret[5] = String(this.object.dias_reposicion [al_row])
	ist_datos.field_ret[6] = String(this.object.dias_rep_import [al_row])
	ist_datos.field_ret[7] = this.object.numero_serie	[al_row]
	ist_datos.field_ret[8] = this.object.flag_numero_serie	[al_row]
	
	CloseWithReturn( parent, ist_datos)
end if
end event

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
end event

event doubleclicked;call super::doubleclicked;this.event ue_return( row )
end event

event clicked;call super::clicked;if row = 0 then return
this.setRow(row)
f_Select_current_row(this)
end event

type dw_1 from datawindow within w_pop_articulos
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 485
integer y = 24
integer width = 1957
integer height = 88
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
String  ls_sql_old,ls_sql_new, ls_texto

THIS.ACCEPTTEXT()

if IsNull(dw_1.object.campo[1]) then
	dw_1.object.campo[1] = ""
end if

if dw_master.RowCount() > 0 and dw_master.getSelectedrow( 0 ) > 0 then
	if Upper(TRIM(dw_1.object.campo[1])) = "" then
		dw_master.event ue_return( dw_master.getSelectedrow( 0 ))
		return
	end if
end if

ls_texto = "%"+Upper(TRIM(dw_1.object.campo[1]))+ "%"

dw_master.SetTransobject( SQLCA )
dw_master.Retrieve(gnvo_app.invo_empresa.is_empresa, ls_texto, is_almacen)

dw_master.setfocus()
dw_1.object.campo[1] = ""
dw_1.setFocus( )

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

type cb_1 from commandbutton within w_pop_articulos
integer x = 1138
integer y = 1604
integer width = 480
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
boolean cancel = true
end type

event clicked;ist_datos.titulo = "n"
CloseWithReturn( parent, ist_datos)

end event

