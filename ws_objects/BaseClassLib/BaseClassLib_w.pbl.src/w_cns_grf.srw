$PBExportHeader$w_cns_grf.srw
$PBExportComments$Ventana para crear dinamicamente consultas en cascada
forward
global type w_cns_grf from w_cns
end type
type st_etiqueta from statictext within w_cns_grf
end type
type dw_master from u_dw_cns within w_cns_grf
end type
end forward

global type w_cns_grf from w_cns
integer width = 599
integer height = 644
string menuname = "m_grf_pop"
st_etiqueta st_etiqueta
dw_master dw_master
end type
global w_cns_grf w_cns_grf

type variables
str_cns_pop istr_1
String  		is_column, is_argname[], is_tipo_graf
Integer		ii_mousemove

end variables

on w_cns_grf.create
int iCurrent
call super::create
if this.MenuName = "m_grf_pop" then this.MenuID = create m_grf_pop
this.st_etiqueta=create st_etiqueta
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_etiqueta
this.Control[iCurrent+2]=this.dw_master
end on

on w_cns_grf.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_etiqueta)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;Long		ll_row
String	ls_rc, ls_modify
Integer	li_rc
Long		ll_total

	


end event

event ue_scrollrow;call super::ue_scrollrow;Long ll_rc

ll_rc = dw_master.of_ScrollRow(as_value)

//RETURN ll_rc
end event

type st_etiqueta from statictext within w_cns_grf
integer x = 955
integer y = 76
integer width = 110
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 65535
boolean focusrectangle = false
end type

type dw_master from u_dw_cns within w_cns_grf
event ue_mousemove pbm_mousemove
integer width = 485
integer height = 328
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_mousemove;IF ii_mousemove > 0 THEN
	Int  li_Rtn, li_Series, li_Category 
	String  ls_serie, ls_categ, ls_cantidad, ls_mensaje 
	Long ll_row 
	grObjectType MouseMoveObject 
	MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)
	IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
 		ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías 
 		ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo 
 		ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
 		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
 		st_etiqueta.BringToTop = TRUE 
 		st_etiqueta.x = xpos 
 		st_etiqueta.y = ypos - 70
 		st_etiqueta.text = ls_mensaje 
 		st_etiqueta.width = len(ls_mensaje) * 30 
 		st_etiqueta.visible = true 
	ELSE 
 		st_etiqueta.visible = false 
	END IF
END IF


end event

