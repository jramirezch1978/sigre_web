$PBExportHeader$w_pr500_base.srw
forward
global type w_pr500_base from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_pr500_base
end type
type st_confirm from statictext within w_pr500_base
end type
type st_etiqueta from statictext within w_pr500_base
end type
type sle_code from singlelineedit within w_pr500_base
end type
type st_code from statictext within w_pr500_base
end type
type st_procesando from statictext within w_pr500_base
end type
end forward

global type w_pr500_base from w_report_smpl
integer width = 3470
integer height = 1900
string title = "Captura de pesca(PR500)"
string menuname = "m_reporte"
windowstate windowstate = maximized!
long backcolor = 67108864
boolean center = true
event ue_copiar ( )
event ue_query_retrieve ( )
event ue_retrieve_list ( )
uo_fecha uo_fecha
st_confirm st_confirm
st_etiqueta st_etiqueta
sle_code sle_code
st_code st_code
st_procesando st_procesando
end type
global w_pr500_base w_pr500_base

type variables
string is_title_original, is_title1, is_title2, is_title3
end variables

forward prototypes
public subroutine of_title ()
public subroutine of_get_code (integer al_inicio, integer al_longitud, ref string as_codigo)
end prototypes

event ue_copiar;idw_1.Clipboard("gr_1")
end event

event ue_query_retrieve();if trim (sle_code.text) = '' then
	messagebox(this.title,'Debe ingresar o seleccionar '+ lower(trim(st_code.text)) ,stopsign!)
	return
else
	this.event ue_retrieve()
end if
end event

event ue_retrieve_list();//string ls_sql, ls_return1, ls_return2
//ls_sql = 'select'
//f_lista(ls_sql, ls_return1, ls_return2, '2')
//sle_code.text = trim(ls_return1)
//this.event ue_retrieve()
end event

public subroutine of_title ();//string ls_fecha1, ls_fecha2, ls_periodo,ls_title
//ls_fecha1 = trim(string(uo_fecha.of_get_fecha1(), 'dd/mm/yyyy'))
//ls_fecha2 = trim(string(uo_fecha.of_get_fecha2(), 'dd/mm/yyyy'))
//ls_title = trim(is_title_original)
//
//if ls_fecha1 = ls_fecha2 then
//	ls_periodo = 'para el día ' + ls_fecha1
//else
//	ls_periodo = 'para el periodo entre ' + ls_fecha1 + ' y ' + ls_fecha2
//end if
//
//idw_1.object.gr_1.title = trim(upper(ls_title)) +' '+ trim(upper(ls_periodo) + is_title1 + is_title2 + is_title3)
//idw_1.Object.p_logo.filename = gs_logo
//idw_1.Object.t_empresa.text = gs_empresa
end subroutine

public subroutine of_get_code (integer al_inicio, integer al_longitud, ref string as_codigo);string ls_codigo
ls_codigo = trim(sle_code.text)
as_codigo = mid(ls_codigo,al_inicio, al_longitud)
end subroutine

on w_pr500_base.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_fecha=create uo_fecha
this.st_confirm=create st_confirm
this.st_etiqueta=create st_etiqueta
this.sle_code=create sle_code
this.st_code=create st_code
this.st_procesando=create st_procesando
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.st_confirm
this.Control[iCurrent+3]=this.st_etiqueta
this.Control[iCurrent+4]=this.sle_code
this.Control[iCurrent+5]=this.st_code
this.Control[iCurrent+6]=this.st_procesando
end on

on w_pr500_base.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.st_confirm)
destroy(this.st_etiqueta)
destroy(this.sle_code)
destroy(this.st_code)
destroy(this.st_procesando)
end on

event ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
//THIS.Event ue_preview()
idw_1.Visible = False
is_title_original = idw_1.object.gr_1.title
end event

event ue_retrieve;call super::ue_retrieve;//of_title()
end event

type dw_report from w_report_smpl`dw_report within w_pr500_base
event ue_mousemove pbm_mousemove
integer x = 23
integer y = 248
integer width = 3429
integer height = 1520
end type

event dw_report::ue_mousemove;int		li_Rtn, li_Series, li_Category
string 	ls_serie, ls_categ, ls_cantidad, ls_mensaje
long ll_row
grObjectType	MouseMoveObject
	
MouseMoveObject = this.ObjectAtPointer('gr_1', li_Series, li_category)

if MouseMoveObject = TypeData! or MouseMoveObject = TypeCategory! then
	
	if st_etiqueta.x = xpos and &
		st_etiqueta.y = (ypos + this.Y - 60) then
		return
	end if

	This.SetRedraw(false)
	ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías
	ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores

	ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'

	st_etiqueta.BringToTop = TRUE
	st_etiqueta.x = xpos
	st_etiqueta.y = ypos + this.Y - 60
	st_etiqueta.text = ls_mensaje
	st_etiqueta.width = len(ls_mensaje) * 30	
	
	if (st_etiqueta.X + st_etiqueta.width ) > this.width then
		st_etiqueta.x = this.width - st_etiqueta.width - 30
	end if
	
	st_etiqueta.visible = true
	This.SetRedraw(true)
else
	st_etiqueta.visible = false
end if
end event

event dw_report::doubleclicked;call super::doubleclicked;//int		li_Rtn, li_Series, li_Category
//string 	ls_serie, ls_categ, ls_cantidad, ls_mensaje, ls_fecha1, ls_fecha2
//long ll_row
//grObjectType	MouseMoveObject
//	
//MouseMoveObject = this.ObjectAtPointer('gr_1', li_Series, li_category)
//
//if MouseMoveObject = TypeData! or MouseMoveObject = TypeCategory! then
//	ls_fecha1 = trim(string(uo_1.of_get_fecha1(), 'dd/mm/yyyy'))
//	ls_fecha2 = trim(string(uo_1.of_get_fecha2(), 'dd/mm/yyyy'))
//	ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías
//	ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo
//	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
//
//	ls_mensaje = trim(ls_cantidad) + trim(ls_serie) + trim(ls_categ) + ls_fecha1 + ls_fecha2
//
//	openwithparm(w_ap503_tip_matprim_orig_grf, ls_mensaje)
//
//else
//
//	return
//
//end if


end event

type uo_fecha from u_ingreso_rango_fechas within w_pr500_base
integer taborder = 40
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date ld_fecha1, ld_fecha2

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(relativedate(today(),-35), today()) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( month( today() ) + 1 ,'00' ) &
	+ '/' + string( year( today() ), '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

of_set_fecha( ld_fecha1, ld_fecha2 )
end event

type st_confirm from statictext within w_pr500_base
boolean visible = false
integer x = 1559
integer y = 16
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "0"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_etiqueta from statictext within w_pr500_base
boolean visible = false
integer x = 23
integer y = 88
integer width = 709
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 134217752
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_code from singlelineedit within w_pr500_base
integer x = 2843
integer y = 4
integer width = 581
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_code from statictext within w_pr500_base
integer x = 1984
integer y = 12
integer width = 841
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Codigo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_procesando from statictext within w_pr500_base
boolean visible = false
integer x = 1285
integer y = 8
integer width = 718
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 67108864
string text = "Procesando..."
alignment alignment = center!
boolean focusrectangle = false
end type

