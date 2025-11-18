$PBExportHeader$w_cn792_devengados.srw
forward
global type w_cn792_devengados from w_rpt
end type
type tab_1 from tab within w_cn792_devengados
end type
type tabpage_1 from userobject within tab_1
end type
type dw_resumido from u_dw_rpt within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_resumido dw_resumido
end type
type tabpage_2 from userobject within tab_1
end type
type dw_detallado from u_dw_rpt within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_detallado dw_detallado
end type
type tab_1 from tab within w_cn792_devengados
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type cb_1 from commandbutton within w_cn792_devengados
end type
type sle_mes2 from singlelineedit within w_cn792_devengados
end type
type st_1 from statictext within w_cn792_devengados
end type
type sle_mes1 from singlelineedit within w_cn792_devengados
end type
type st_3 from statictext within w_cn792_devengados
end type
type sle_ano from singlelineedit within w_cn792_devengados
end type
type st_4 from statictext within w_cn792_devengados
end type
type gb_3 from groupbox within w_cn792_devengados
end type
end forward

global type w_cn792_devengados from w_rpt
integer width = 3241
integer height = 2404
string title = "[CN792] Reporte de Devengados RRHH - Planilla"
string menuname = "m_impresion"
tab_1 tab_1
cb_1 cb_1
sle_mes2 sle_mes2
st_1 st_1
sle_mes1 sle_mes1
st_3 st_3
sle_ano sle_ano
st_4 st_4
gb_3 gb_3
end type
global w_cn792_devengados w_cn792_devengados

type variables
u_dw_rpt idw_resumido, idw_detallado
end variables

forward prototypes
public subroutine of_asigna_dws ()
end prototypes

public subroutine of_asigna_dws ();idw_resumido = tab_1.tabpage_1.dw_resumido
idw_detallado = tab_1.tabpage_2.dw_detallado
end subroutine

on w_cn792_devengados.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.tab_1=create tab_1
this.cb_1=create cb_1
this.sle_mes2=create sle_mes2
this.st_1=create st_1
this.sle_mes1=create sle_mes1
this.st_3=create st_3
this.sle_ano=create sle_ano
this.st_4=create st_4
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_mes2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_mes1
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.sle_ano
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.gb_3
end on

on w_cn792_devengados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.cb_1)
destroy(this.sle_mes2)
destroy(this.st_1)
destroy(this.sle_mes1)
destroy(this.st_3)
destroy(this.sle_ano)
destroy(this.st_4)
destroy(this.gb_3)
end on

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()
sle_ano.text = string(gnvo_app.of_fecha_actual(), 'yyyy')
sle_mes1.text = '01'
sle_mes2.text = string(gnvo_app.of_fecha_actual(), 'mm')

idw_resumido.setTransobject( SQLCA )
idw_detallado.setTransobject( SQLCA )

idw_1 = idw_resumido
idw_1.SetFocus()


idw_resumido.object.dataWindow.Print.Orientation = "1"
idw_resumido.ib_preview = false
idw_resumido.event ue_preview( )

idw_detallado.object.dataWindow.Print.Orientation = "2"
idw_detallado.ib_preview = false
idw_detallado.event ue_preview( )

end event

event resize;call super::resize;of_asigna_dws()

tab_1.width = newwidth - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_resumido.width = tab_1.tabpage_1.width - idw_resumido.x - 10
idw_resumido.height = tab_1.tabpage_1.height - idw_resumido.y - 10

idw_detallado.width = tab_1.tabpage_2.width - idw_detallado.x - 10
idw_detallado.height = tab_1.tabpage_2.height - idw_detallado.y - 10

end event

event ue_retrieve;call super::ue_retrieve;Integer 	li_year, li_mes1, li_mes2
string	ls_mes1, ls_mes2

li_year     = Integer(sle_ano.text)
li_mes1 		= Integer(sle_mes1.text)
li_mes2 		= Integer(sle_mes2.text)

CHOOSE CASE string(li_mes1, '00')
			
	CASE '01'
		  ls_mes1 = '01 ENERO'
	CASE '02'
		  ls_mes1 = '02 FEBRERO'
	CASE '03'
		  ls_mes1 = '03 MARZO'
	CASE '04'
		  ls_mes1 = '04 ABRIL'
	CASE '05'
		  ls_mes1 = '05 MAYO'
	CASE '06'
		  ls_mes1 = '06 JUNIO'
	CASE '07'
		  ls_mes1 = '07 JULIO'
	CASE '08'
		  ls_mes1 = '08 AGOSTO'
	CASE '09'
		  ls_mes1 = '09 SEPTIEMBRE'
	CASE '10'
		  ls_mes1 = '10 OCTUBRE'
	CASE '11'
		  ls_mes1 = '11 NOVIEMBRE'
	CASE '12'
		  ls_mes1 = '12 DICIEMBRE'
END CHOOSE
	
CHOOSE CASE string(li_mes2, '00')
			
	CASE '01'
		  ls_mes2 = '01 ENERO'
	CASE '02'
		  ls_mes2 = '02 FEBRERO'
	CASE '03'
		  ls_mes2 = '03 MARZO'
	CASE '04'
		  ls_mes2 = '04 ABRIL'
	CASE '05'
		  ls_mes2 = '05 MAYO'
	CASE '06'
		  ls_mes2 = '06 JUNIO'
	CASE '07'
		  ls_mes2 = '07 JULIO'
	CASE '08'
		  ls_mes2 = '08 AGOSTO'
	CASE '09'
		  ls_mes2 = '09 SEPTIEMBRE'
	CASE '10'
		  ls_mes2 = '10 OCTUBRE'
	CASE '11'
		  ls_mes2 = '11 NOVIEMBRE'
	CASE '12'
		  ls_mes2 = '12 DICIEMBRE'
END CHOOSE

idw_resumido.Retrieve(li_year, li_mes1, li_mes2)
idw_resumido.object.p_logo.filename 	= gs_logo
idw_resumido.object.t_nom_empresa.text = gnvo_app.empresa.is_nom_empresa
idw_resumido.object.t_user.text 			= gs_user
idw_resumido.object.t_desde.text    	= ls_mes1
idw_resumido.object.t_hasta.text    	= ls_mes2
idw_resumido.object.t_fecha.text    	= string(gnvo_app.of_fecha_actual(), 'dd/mm/yyyy hh:mm:ss')


idw_detallado.Retrieve(li_year, li_mes1, li_mes2)
idw_detallado.object.p_logo.filename 	= gs_logo
idw_detallado.object.t_nom_empresa.text = gnvo_app.empresa.is_nom_empresa
idw_detallado.object.t_user.text 			= gs_user
idw_detallado.object.t_desde.text    	= ls_mes1
idw_detallado.object.t_hasta.text    	= ls_mes2
idw_resumido.object.t_fecha.text    	= string(gnvo_app.of_fecha_actual(), 'dd/mm/yyyy hh:mm:ss')

end event

event ue_preview;call super::ue_preview;idw_1.event ue_preview( )
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type tab_1 from tab within w_cn792_devengados
integer y = 208
integer width = 2921
integer height = 1724
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 2885
integer height = 1604
long backcolor = 67108864
string text = "Resumido"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_resumido dw_resumido
end type

on tabpage_1.create
this.dw_resumido=create dw_resumido
this.Control[]={this.dw_resumido}
end on

on tabpage_1.destroy
destroy(this.dw_resumido)
end on

type dw_resumido from u_dw_rpt within tabpage_1
integer width = 2839
integer height = 1584
integer taborder = 50
string dataobject = "d_rpt_devengado_resumido_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 2885
integer height = 1604
long backcolor = 67108864
string text = "Detallado"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_detallado dw_detallado
end type

on tabpage_2.create
this.dw_detallado=create dw_detallado
this.Control[]={this.dw_detallado}
end on

on tabpage_2.destroy
destroy(this.dw_detallado)
end on

type dw_detallado from u_dw_rpt within tabpage_2
integer width = 2839
integer height = 1584
string dataobject = "d_rpt_devengado_detalle_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

type cb_1 from commandbutton within w_cn792_devengados
integer x = 1362
integer y = 32
integer width = 302
integer height = 152
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Repote"
end type

event clicked;setPointer(Hourglass!)
Parent.Event ue_retrieve()
setPointer(Arrow!)

end event

type sle_mes2 from singlelineedit within w_cn792_devengados
integer x = 1175
integer y = 76
integer width = 105
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cn792_devengados
integer x = 882
integer y = 84
integer width = 274
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Hasta"
boolean focusrectangle = false
end type

type sle_mes1 from singlelineedit within w_cn792_devengados
integer x = 736
integer y = 76
integer width = 105
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_cn792_devengados
integer x = 416
integer y = 84
integer width = 293
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Desde"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_cn792_devengados
integer x = 201
integer y = 76
integer width = 192
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_cn792_devengados
integer x = 32
integer y = 84
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_3 from groupbox within w_cn792_devengados
integer width = 1339
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
end type

