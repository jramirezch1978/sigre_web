$PBExportHeader$w_ap310_det_grf_calidad.srw
forward
global type w_ap310_det_grf_calidad from window
end type
type st_etiqueta from statictext within w_ap310_det_grf_calidad
end type
type p_arrow from picture within w_ap310_det_grf_calidad
end type
type dw_actual from datawindow within w_ap310_det_grf_calidad
end type
type dw_max from datawindow within w_ap310_det_grf_calidad
end type
type dw_min from datawindow within w_ap310_det_grf_calidad
end type
type dw_lista from datawindow within w_ap310_det_grf_calidad
end type
end forward

global type w_ap310_det_grf_calidad from window
integer width = 3470
integer height = 1788
boolean titlebar = true
string title = "Detalle de Calidaddes por Especie"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_etiqueta st_etiqueta
p_arrow p_arrow
dw_actual dw_actual
dw_max dw_max
dw_min dw_min
dw_lista dw_lista
end type
global w_ap310_det_grf_calidad w_ap310_det_grf_calidad

type variables
string is_especie
end variables

event open;
long ll_calidades
string ls_cadena, ls_calidad, ls_nro_parte, ls_nom_prov, ls_nom_esp, ls_fec_ini
integer li_item

dw_min.Modify("gr_1.Pointer = 'h:\source\cur\taladro.cur'")
dw_max.Modify("gr_1.Pointer = 'h:\source\cur\taladro.cur'")
dw_actual.Modify("gr_1.Pointer = 'h:\source\cur\taladro.cur'")

ls_cadena = Message.StringParm

is_especie = trim(mid(ls_cadena, 1, 12))
ls_nro_parte = trim(mid(ls_cadena, 13, 10))
li_item = integer(trim(mid(ls_cadena, 23, 3)))

select count(*) 
	into :ll_calidades
	from tg_articulo_calidad 
	where trim(cod_art) = :is_especie;
/*select count(*) 
	into :ll_calidades 
	from tg_especie_calidad 
	where especie = :is_especie;*/
	
if ll_calidades <= 0 then
	messagebox('Aprovisionamiento', 'No se han registrado estándares de ~r calidad para la especie seleccionada' ,StopSign!)
	return
end if
dw_lista.settransobject(sqlca);
dw_min.settransobject(sqlca);
dw_max.settransobject(sqlca);
dw_actual.settransobject(sqlca);

dw_lista.retrieve(is_especie)
dw_lista.setrow(1)
dw_lista.scrolltorow(1)
dw_lista.setRowFocusIndicator(p_arrow)

ls_calidad = dw_lista.object.cod_calidad[1]

dw_min.retrieve(ls_calidad, is_especie)
dw_max.retrieve(ls_calidad, is_especie)

dw_actual.retrieve(ls_nro_parte, li_item)

declare usp_ap_guia_cal_grf procedure for 
	usp_ap_guia_cal_grf(:ls_nro_parte, :li_item);
execute usp_ap_guia_cal_grf;
fetch usp_ap_guia_cal_grf into :ls_nom_prov, :ls_nom_esp, :ls_fec_ini;
close usp_ap_guia_cal_grf;

dw_lista.object.calidad_desc_t.text = WordCap('calidad de ' + Trim(ls_nom_esp))
this.title = 'Proveedor: ' + WordCAp(trim(ls_nom_prov)) + ' | '+ 'Descarga: ' + Trim(ls_fec_ini)
end event

on w_ap310_det_grf_calidad.create
this.st_etiqueta=create st_etiqueta
this.p_arrow=create p_arrow
this.dw_actual=create dw_actual
this.dw_max=create dw_max
this.dw_min=create dw_min
this.dw_lista=create dw_lista
this.Control[]={this.st_etiqueta,&
this.p_arrow,&
this.dw_actual,&
this.dw_max,&
this.dw_min,&
this.dw_lista}
end on

on w_ap310_det_grf_calidad.destroy
destroy(this.st_etiqueta)
destroy(this.p_arrow)
destroy(this.dw_actual)
destroy(this.dw_max)
destroy(this.dw_min)
destroy(this.dw_lista)
end on

event resize;dw_actual.height = newheight - dw_actual.y - 10
end event

type st_etiqueta from statictext within w_ap310_det_grf_calidad
boolean visible = false
integer x = 517
integer y = 1520
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217752
alignment alignment = center!
boolean focusrectangle = false
end type

type p_arrow from picture within w_ap310_det_grf_calidad
boolean visible = false
integer x = 14
integer y = 76
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "Custom035!"
boolean focusrectangle = false
end type

type dw_actual from datawindow within w_ap310_det_grf_calidad
event mouse_move_act ( )
event mouse_move pbm_mousemove
integer y = 732
integer width = 3415
integer height = 728
integer taborder = 30
string title = "none"
string dataobject = "d_ap_pd_desc_atrib_grf"
boolean border = false
boolean livescroll = true
end type

event mouse_move;int		li_Rtn, li_Series, li_Category
string 	ls_serie, ls_categ, ls_cantidad, ls_mensaje
long ll_row
grObjectType	MouseMoveObject

MouseMoveObject = this.ObjectAtPointer('gr_1', li_Series, li_category)
	if MouseMoveObject = TypeData! or MouseMoveObject = TypeCategory! then

	ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías
	ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
		st_etiqueta.BringToTop = TRUE
	st_etiqueta.x = xpos + this.x + 40
	st_etiqueta.y = ypos + this.y - 10
	st_etiqueta.text = ls_mensaje
	st_etiqueta.width = len(ls_mensaje) * 30
	st_etiqueta.visible = true
else
	st_etiqueta.visible = false
end if
end event

event doubleclicked;this.BringToTop = true
if this.y = 0 then
	this.x = 0
	this.y = 732
	this.width = 3415
	this.height = 728
else
	this.x = 0
	this.y = 0
	this.width = parent.width
	this.height = parent.height
end if
end event

type dw_max from datawindow within w_ap310_det_grf_calidad
event mouse_move_max pbm_mousemove
integer x = 2080
integer width = 1335
integer height = 728
integer taborder = 30
string title = "none"
string dataobject = "d_tg_calidad_rmax_grf"
boolean border = false
boolean livescroll = true
end type

event mouse_move_max;int		li_Rtn, li_Series, li_Category
string 	ls_serie, ls_categ, ls_cantidad, ls_mensaje
long ll_row
grObjectType	MouseMoveObject

MouseMoveObject = this.ObjectAtPointer('gr_1', li_Series, li_category)
	if MouseMoveObject = TypeData! or MouseMoveObject = TypeCategory! then

	ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías
	ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
		st_etiqueta.BringToTop = TRUE
	st_etiqueta.x = xpos + this.x + 40
	st_etiqueta.y = ypos + this.y - 10
	st_etiqueta.text = ls_mensaje
	st_etiqueta.width = len(ls_mensaje) * 30
	st_etiqueta.visible = true
else
	st_etiqueta.visible = false
end if
end event

event doubleclicked;this.BringToTop = true
if this.x = 0 then
	this.x = 2080
	this.y = 0
	this.width = 1335
	this.height = 728
else
	this.x = 0
	this.y = 0
	this.width = parent.width
	this.height = parent.height
end if
end event

type dw_min from datawindow within w_ap310_det_grf_calidad
event mouse_move pbm_mousemove
integer x = 727
integer width = 1335
integer height = 728
integer taborder = 20
string title = "none"
string dataobject = "d_tg_calidad_rmin_grf"
boolean border = false
boolean livescroll = true
end type

event mouse_move;int		li_Rtn, li_Series, li_Category
string 	ls_serie, ls_categ, ls_cantidad, ls_mensaje
long ll_row
grObjectType	MouseMoveObject

MouseMoveObject = this.ObjectAtPointer('gr_1', li_Series, li_category)
	if MouseMoveObject = TypeData! or MouseMoveObject = TypeCategory! then

	ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías
	ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
		st_etiqueta.BringToTop = TRUE
	st_etiqueta.x = xpos + this.x + 40
	st_etiqueta.y = ypos + this.y - 10
	st_etiqueta.text = ls_mensaje
	st_etiqueta.width = len(ls_mensaje) * 30
	st_etiqueta.visible = true
else
	st_etiqueta.visible = false
end if
end event

event doubleclicked;this.BringToTop = true
if this.x = 0 then
	this.x = 727
	this.y = 0
	this.width = 1335
	this.height = 728
else
	this.x = 0
	this.y = 0
	this.width = parent.width
	this.height = parent.height
end if
end event

type dw_lista from datawindow within w_ap310_det_grf_calidad
integer width = 713
integer height = 728
integer taborder = 10
string title = "none"
string dataobject = "d_tg_calidades_especies_tbl"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event rowfocuschanged;string ls_calidad

ls_calidad = dw_lista.object.cod_calidad[this.getrow()]

dw_min.retrieve(ls_calidad, is_especie)
dw_max.retrieve(ls_calidad, is_especie)
end event

