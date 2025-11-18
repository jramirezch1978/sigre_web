$PBExportHeader$w_gen_transferencia_as303.srw
forward
global type w_gen_transferencia_as303 from w_prc
end type
type st_2 from statictext within w_gen_transferencia_as303
end type
type cb_1 from commandbutton within w_gen_transferencia_as303
end type
type st_1 from statictext within w_gen_transferencia_as303
end type
type dw_1 from datawindow within w_gen_transferencia_as303
end type
type uo_1 from u_ingreso_rango_fechas within w_gen_transferencia_as303
end type
type gb_1 from groupbox within w_gen_transferencia_as303
end type
type r_1 from rectangle within w_gen_transferencia_as303
end type
type r_2 from rectangle within w_gen_transferencia_as303
end type
end forward

global type w_gen_transferencia_as303 from w_prc
integer width = 2962
integer height = 1536
string title = "Transfiere Inasistencias y Pagos por Sobretiempos (AS303)"
st_2 st_2
cb_1 cb_1
st_1 st_1
dw_1 dw_1
uo_1 uo_1
gb_1 gb_1
r_1 r_1
r_2 r_2
end type
global w_gen_transferencia_as303 w_gen_transferencia_as303

on w_gen_transferencia_as303.create
int iCurrent
call super::create
this.st_2=create st_2
this.cb_1=create cb_1
this.st_1=create st_1
this.dw_1=create dw_1
this.uo_1=create uo_1
this.gb_1=create gb_1
this.r_1=create r_1
this.r_2=create r_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.r_1
this.Control[iCurrent+8]=this.r_2
end on

on w_gen_transferencia_as303.destroy
call super::destroy
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.uo_1)
destroy(this.gb_1)
destroy(this.r_1)
destroy(this.r_2)
end on

event open;call super::open;dw_1.settransobject(SQLCA)

long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - w_gen_transferencia_as303.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - w_gen_transferencia_as303.WorkSpaceHeight()) / 2) - 150
w_gen_transferencia_as303.move(ll_x,ll_y)

end event

type st_2 from statictext within w_gen_transferencia_as303
integer x = 87
integer y = 48
integer width = 2729
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "TRANSFERENCIA  DE INFORMACION A LA PLANILLA"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_gen_transferencia_as303
integer x = 2080
integer y = 228
integer width = 247
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Long ln_reg_act, ln_reg_tot
r_2.width  = 0
st_1.x     = r_2.x + 50
st_1.width = 2000
st_1.Text  = 'Seleccionando Trabajadores para la Generación'
ln_reg_tot = dw_1.Retrieve()
st_1.width = 220

string ls_codtra
date ld_fec_desde
date ld_fec_hasta
ld_fec_desde=uo_1.of_get_fecha1()
ld_fec_hasta=uo_1.of_get_fecha2()

// Borra información de inasistencias y sobretiempos
DELETE FROM inasistencia
  WHERE nro_doc = 'RELOJ     ' and 
        fec_movim between ld_fec_desde and ld_fec_hasta ;

DELETE FROM sobretiempo_turno
  WHERE nro_doc = 'RELOJ     ' and 
        fec_movim between ld_fec_desde and ld_fec_hasta ;

// Declara ejecuación para transferencia de información a la planilla
DECLARE pb_usp_asi_transfiere_plla PROCEDURE FOR USP_ASI_TRANSFIERE_PLLA
        ( :ls_codtra, :ld_fec_desde, :ld_fec_hasta ) ;

// Busca trabajador para realizar transferencia
For ln_reg_act = 1 to ln_reg_tot
	 dw_1.ScrollToRow( ln_reg_act )
	 dw_1.SelectRow( 0, false )
	 dw_1.SelectRow( ln_reg_act, true )
	 
    ls_codtra = dw_1.GetItemString( ln_reg_act, "cod_trabajador" )
	 execute pb_usp_asi_transfiere_plla;
   
	 r_2.width = ln_reg_act / ln_reg_tot * r_1.width
	 st_1.Text = String(ln_reg_act / ln_reg_tot * 100, '##0.00') + '%'
    st_1.x = r_2.x + r_2.width
Next

IF SQLCA.SQLCode = -1 THEN 
  rollback ;
  MessageBox("SQL error", SQLCA.SQLErrText)
  MessageBox('Atención','No se pudo realizar la transferencia', Exclamation! )
ELSE
  commit ;
  MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)
END IF

end event

type st_1 from statictext within w_gen_transferencia_as303
integer x = 1362
integer y = 1216
integer width = 247
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "Avance"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_gen_transferencia_as303
integer x = 91
integer y = 400
integer width = 2729
integer height = 736
string dataobject = "d_transf_asistencia_tbl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type uo_1 from u_ingreso_rango_fechas within w_gen_transferencia_as303
event destroy ( )
integer x = 645
integer y = 228
integer taborder = 10
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;string ls_inicio, ls_fec 
date ld_fec
uo_1.of_set_label('Desde','Hasta')

// Obtiene primer día del mes
ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

uo_1.of_set_fecha(date(ls_inicio),today())
uo_1.of_set_rango_inicio(date('01/01/1900'))  // rango inicial
uo_1.of_set_rango_fin(date('31/12/9999'))     // rango final

end event

type gb_1 from groupbox within w_gen_transferencia_as303
integer x = 558
integer y = 160
integer width = 1454
integer height = 188
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 79741120
string text = " Digite Rango de Fechas "
borderstyle borderstyle = styleraised!
end type

type r_1 from rectangle within w_gen_transferencia_as303
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 12632256
integer x = 91
integer y = 1216
integer width = 2482
integer height = 76
end type

type r_2 from rectangle within w_gen_transferencia_as303
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 10789024
integer x = 91
integer y = 1216
integer width = 2231
integer height = 76
end type

