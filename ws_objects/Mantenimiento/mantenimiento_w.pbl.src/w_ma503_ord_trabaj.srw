$PBExportHeader$w_ma503_ord_trabaj.srw
forward
global type w_ma503_ord_trabaj from w_cns
end type
type st_2 from statictext within w_ma503_ord_trabaj
end type
type st_1 from statictext within w_ma503_ord_trabaj
end type
type dw_1 from datawindow within w_ma503_ord_trabaj
end type
type gb_1 from groupbox within w_ma503_ord_trabaj
end type
type cbx_pendientes from checkbox within w_ma503_ord_trabaj
end type
type cbx_ejecutadas from checkbox within w_ma503_ord_trabaj
end type
type uo_1 from u_ingreso_rango_fechas within w_ma503_ord_trabaj
end type
type cb_1 from commandbutton within w_ma503_ord_trabaj
end type
type rb_1 from radiobutton within w_ma503_ord_trabaj
end type
type rb_2 from radiobutton within w_ma503_ord_trabaj
end type
type ddlb_1 from dropdownlistbox within w_ma503_ord_trabaj
end type
end forward

global type w_ma503_ord_trabaj from w_cns
integer x = 5
integer y = 160
integer width = 3570
integer height = 1512
string title = "Ordenes de Trabajo (MA503)"
string menuname = "m_cns"
st_2 st_2
st_1 st_1
dw_1 dw_1
gb_1 gb_1
cbx_pendientes cbx_pendientes
cbx_ejecutadas cbx_ejecutadas
uo_1 uo_1
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
ddlb_1 ddlb_1
end type
global w_ma503_ord_trabaj w_ma503_ord_trabaj

forward prototypes
public subroutine wf_presentacion ()
end prototypes

public subroutine wf_presentacion ();dw_1.SetRedraw(false)
if cbx_ejecutadas.checked and cbx_pendientes.Checked Then
	dw_1.SetFilter( '' )
elseif cbx_pendientes.checked Then
	dw_1.SetFilter( "orden_trabajo_flag_estado='1'" )
elseif cbx_ejecutadas.checked Then
	dw_1.SetFilter( "orden_trabajo_flag_estado='2'" )
else
	dw_1.SetFilter( '1=2' )
End If
dw_1.Filter()
dw_1.SetRedraw(true)
end subroutine

event open;call super::open;of_position_window(0,0)
dw_1.SetTransObject( SQLCA ) ;
end event

on w_ma503_ord_trabaj.create
int iCurrent
call super::create
if this.MenuName = "m_cns" then this.MenuID = create m_cns
this.st_2=create st_2
this.st_1=create st_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.cbx_pendientes=create cbx_pendientes
this.cbx_ejecutadas=create cbx_ejecutadas
this.uo_1=create uo_1
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.ddlb_1=create ddlb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.cbx_pendientes
this.Control[iCurrent+6]=this.cbx_ejecutadas
this.Control[iCurrent+7]=this.uo_1
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.rb_2
this.Control[iCurrent+11]=this.ddlb_1
end on

on w_ma503_ord_trabaj.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.cbx_pendientes)
destroy(this.cbx_ejecutadas)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.ddlb_1)
end on

event ue_open_pre();call super::ue_open_pre;x = 10
y = 10

//Help
ii_help = 503
end event

event resize;call super::resize;
dw_1.width  = newwidth  - dw_1.x - 10
dw_1.height = newheight - dw_1.y - 10
end event

type st_2 from statictext within w_ma503_ord_trabaj
integer x = 37
integer y = 172
integer width = 393
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
boolean focusrectangle = false
end type

type st_1 from statictext within w_ma503_ord_trabaj
integer x = 37
integer y = 80
integer width = 393
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro de Costo :"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_ma503_ord_trabaj
integer y = 288
integer width = 3502
integer height = 1028
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_cons_ord_tra_sol"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_ma503_ord_trabaj
integer y = 12
integer width = 1710
integer height = 252
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro de Costo:"
borderstyle borderstyle = stylelowered!
end type

type cbx_pendientes from checkbox within w_ma503_ord_trabaj
integer x = 3122
integer y = 36
integer width = 366
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pendientes"
boolean checked = true
boolean lefttext = true
borderstyle borderstyle = stylelowered!
end type

event clicked;wf_presentacion()
end event

type cbx_ejecutadas from checkbox within w_ma503_ord_trabaj
integer x = 3122
integer y = 124
integer width = 366
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ejecutadas"
boolean lefttext = true
borderstyle borderstyle = stylelowered!
end type

event clicked;wf_presentacion()
end event

type uo_1 from u_ingreso_rango_fechas within w_ma503_ord_trabaj
integer x = 1746
integer y = 44
integer taborder = 40
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha( RelativeDate( today(), -30), today() ) // para seatear el titulo del boton
of_set_rango_inicio( date('01/01/1900') ) // rango inicial
of_set_rango_fin( date('31/12/9999') ) // rango final


end event

type cb_1 from commandbutton within w_ma503_ord_trabaj
integer x = 1751
integer y = 176
integer width = 1275
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_CenCos 
Date ld_fec_inicio, ld_fec_fin


if rb_1.Checked = True Then
	dw_1.DataObject = 'd_cons_ord_tra_sol'
else
	dw_1.DataObject = 'd_cons_ord_tra_res'
end if
dw_1.SetTransObject( SQLCA ) ;

ls_CenCos = Mid( ddlb_1.Text, 1, 10)


ld_fec_inicio = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()


dw_1.SetRedraw(false)
dw_1.Retrieve( ld_fec_inicio, ld_fec_fin, ls_cencos )

//wf_presentacion()
// esto lo hace en la wf_presentacion
 dw_1.SetRedraw(true)

end event

type rb_1 from radiobutton within w_ma503_ord_trabaj
integer x = 517
integer y = 172
integer width = 361
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solicitante"
boolean checked = true
boolean lefttext = true
borderstyle borderstyle = stylelowered!
end type

type rb_2 from radiobutton within w_ma503_ord_trabaj
integer x = 1166
integer y = 172
integer width = 425
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Responsable"
boolean lefttext = true
borderstyle borderstyle = stylelowered!
end type

type ddlb_1 from dropdownlistbox within w_ma503_ord_trabaj
integer x = 530
integer y = 68
integer width = 1161
integer height = 604
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier New"
long textcolor = 33554432
boolean autohscroll = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event constructor;Long ll_filas, ll_fila
DataStore ds_cencos
ds_cencos = Create DataStore
ds_cencos.DataObject = 'd_dddw_cencos'
ds_cencos.SetTransObject ( SQLCA ) ;
ll_filas = ds_cencos.Retrieve()
For ll_fila = 1 to ll_filas
	 ddlb_1.AddItem ( ds_cencos.object.cencos [ll_fila] + ' ' + &
	                  ds_cencos.object.desc_cencos [ll_fila] )
Next
end event

