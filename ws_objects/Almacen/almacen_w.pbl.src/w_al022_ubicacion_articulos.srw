$PBExportHeader$w_al022_ubicacion_articulos.srw
forward
global type w_al022_ubicacion_articulos from w_abc
end type
type sle_desc from singlelineedit within w_al022_ubicacion_articulos
end type
type cb_3 from commandbutton within w_al022_ubicacion_articulos
end type
type sle_cart from singlelineedit within w_al022_ubicacion_articulos
end type
type st_2 from statictext within w_al022_ubicacion_articulos
end type
type sle_2 from singlelineedit within w_al022_ubicacion_articulos
end type
type cb_2 from commandbutton within w_al022_ubicacion_articulos
end type
type st_1 from statictext within w_al022_ubicacion_articulos
end type
type sle_1 from singlelineedit within w_al022_ubicacion_articulos
end type
type cb_1 from commandbutton within w_al022_ubicacion_articulos
end type
type dw_master from u_dw_abc within w_al022_ubicacion_articulos
end type
type gb_1 from groupbox within w_al022_ubicacion_articulos
end type
end forward

global type w_al022_ubicacion_articulos from w_abc
integer width = 2834
integer height = 1716
string title = "Ubicación de Articulos (AL022)"
string menuname = "m_mantenimiento"
sle_desc sle_desc
cb_3 cb_3
sle_cart sle_cart
st_2 st_2
sle_2 sle_2
cb_2 cb_2
st_1 st_1
sle_1 sle_1
cb_1 cb_1
dw_master dw_master
gb_1 gb_1
end type
global w_al022_ubicacion_articulos w_al022_ubicacion_articulos

on w_al022_ubicacion_articulos.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento" then this.MenuID = create m_mantenimiento
this.sle_desc=create sle_desc
this.cb_3=create cb_3
this.sle_cart=create sle_cart
this.st_2=create st_2
this.sle_2=create sle_2
this.cb_2=create cb_2
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_1=create cb_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_desc
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.sle_cart
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_2
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.sle_1
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.dw_master
this.Control[iCurrent+11]=this.gb_1
end on

on w_al022_ubicacion_articulos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_desc)
destroy(this.cb_3)
destroy(this.sle_cart)
destroy(this.st_2)
destroy(this.sle_2)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos


idw_1 = dw_master              				// asignar dw corriente




of_position_window(0,0)
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN



IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0

END IF

end event

type sle_desc from singlelineedit within w_al022_ubicacion_articulos
integer x = 1024
integer y = 200
integer width = 1303
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 134217752
textcase textcase = upper!
integer limit = 40
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_al022_ubicacion_articulos
integer x = 905
integer y = 208
integer width = 101
integer height = 72
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo,ls_almacen

ls_almacen = sle_1.text

if Isnull(ls_almacen) or trim(ls_almacen) = '' then
	Messagebox('Aviso','Debe Seleccionar un Almacen')
	Return
end if

ls_sql = "select aa.cod_art as codigo, "&
		  +"art.nom_articulo as nombre, "&
		  +"art.und as unidad "&
		  +"from articulo_almacen aa,articulo art "&
		  +"where aa.cod_art = art.cod_art and "&
		  +"art.flag_estado = '1' and " &
        +"aa.almacen = "+"'"+ls_almacen+"'"            
		  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	sle_cart.text = ls_codigo
	sle_desc.text = ls_data
end if
		
end event

type sle_cart from singlelineedit within w_al022_ubicacion_articulos
integer x = 521
integer y = 200
integer width = 366
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 12
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_al022_ubicacion_articulos
integer x = 105
integer y = 212
integer width = 384
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "C. Articulo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_2 from singlelineedit within w_al022_ubicacion_articulos
integer x = 1024
integer y = 88
integer width = 1303
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 134217752
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_al022_ubicacion_articulos
integer x = 846
integer y = 92
integer width = 101
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo


ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	    + "desc_almacen AS descripcion_almacen " &
		 + "FROM almacen " &
		 + "where cod_origen = '" + gs_origen + "' " &
		 + "and flag_estado = '1' " &
  		 + "order by almacen " 

				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	sle_1.text = ls_codigo
	sle_2.text = ls_data
end if
		
	
	


end event

type st_1 from statictext within w_al022_ubicacion_articulos
integer x = 105
integer y = 108
integer width = 384
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Almacen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_al022_ubicacion_articulos
integer x = 521
integer y = 88
integer width = 302
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_al022_ubicacion_articulos
integer x = 2427
integer y = 32
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_cod_alm,ls_cod_art,ls_desc_art

ls_cod_alm  = sle_1.text
ls_cod_art  = sle_cart.text
ls_desc_art = sle_desc.text


IF Isnull(ls_cod_art) OR Trim(ls_cod_art) = '' THEN
	ls_cod_art = '%'
ELSE
	ls_cod_art = ls_cod_art+'%'
END IF


IF Isnull(ls_desc_art) OR Trim(ls_desc_art) = '' THEN
	ls_desc_art = '%'
ELSE
	ls_desc_art = ls_desc_art +'%'
END IF


if Isnull(ls_cod_alm) or trim(ls_cod_alm) = '' then
	Messagebox('Aviso','Debe Seleccionar un Almacen')
	Return
end if


dw_master.Retrieve(ls_cod_alm,ls_cod_art,ls_desc_art)
end event

type dw_master from u_dw_abc within w_al022_ubicacion_articulos
integer y = 332
integer width = 2743
integer height = 1044
string dataobject = "d_abc_ubicacion_art_x_alm_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'

is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1
ii_ck[2] = 2



idw_mst = dw_master

end event

event itemchanged;call super::itemchanged;Accepttext()
end event

type gb_1 from groupbox within w_al022_ubicacion_articulos
integer x = 41
integer y = 20
integer width = 2363
integer height = 300
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Busqueda"
end type

