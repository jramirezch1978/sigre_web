$PBExportHeader$w_pr501_base_det.srw
forward
global type w_pr501_base_det from w_rpt
end type
type st_etiqueta from statictext within w_pr501_base_det
end type
type pb_1 from picturebutton within w_pr501_base_det
end type
type dw_master from u_dw_abc within w_pr501_base_det
end type
end forward

global type w_pr501_base_det from w_rpt
integer width = 3470
integer height = 1900
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 67108864
boolean center = true
st_etiqueta st_etiqueta
pb_1 pb_1
dw_master dw_master
end type
global w_pr501_base_det w_pr501_base_det

on w_pr501_base_det.create
int iCurrent
call super::create
this.st_etiqueta=create st_etiqueta
this.pb_1=create pb_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_etiqueta
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.dw_master
end on

on w_pr501_base_det.destroy
call super::destroy
destroy(this.st_etiqueta)
destroy(this.pb_1)
destroy(this.dw_master)
end on

event open;IF this.of_access(gs_user, THIS.ClassName()) THEN 
	THIS.EVENT ue_open_pre()
	this.event ue_retrieve()
ELSE
	CLOSE(THIS)
END IF
end event

event ue_open_pre;call super::ue_open_pre;dw_master.Visible = False
dw_master.SetTransObject(sqlca)
end event

type st_etiqueta from statictext within w_pr501_base_det
boolean visible = false
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

type pb_1 from picturebutton within w_pr501_base_det
integer x = 3378
integer width = 78
integer height = 68
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Close!"
alignment htextalign = left!
end type

event clicked;close (parent)
end event

type dw_master from u_dw_abc within w_pr501_base_det
event ue_mousemove pbm_mousemove
integer y = 64
integer width = 3451
integer height = 1816
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_mousemove;int		li_Rtn, li_Series, li_Category
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
	st_etiqueta.x = xpos
	st_etiqueta.y = ypos
	st_etiqueta.text = ls_mensaje
	st_etiqueta.width = len(ls_mensaje) * 30
	st_etiqueta.visible = true
else
	st_etiqueta.visible = false
end if
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = dw_master

end event

