$PBExportHeader$w_gen_actualiza_marcaciones_as302.srw
forward
global type w_gen_actualiza_marcaciones_as302 from w_prc
end type
type cb_1 from commandbutton within w_gen_actualiza_marcaciones_as302
end type
type st_2 from statictext within w_gen_actualiza_marcaciones_as302
end type
type uo_1 from u_ingreso_fecha within w_gen_actualiza_marcaciones_as302
end type
type gb_1 from groupbox within w_gen_actualiza_marcaciones_as302
end type
end forward

global type w_gen_actualiza_marcaciones_as302 from w_prc
integer width = 1874
integer height = 956
string title = "Actualiza Consolidado de Marcaciones Diarias  (AS302)"
cb_1 cb_1
st_2 st_2
uo_1 uo_1
gb_1 gb_1
end type
global w_gen_actualiza_marcaciones_as302 w_gen_actualiza_marcaciones_as302

on w_gen_actualiza_marcaciones_as302.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.st_2=create st_2
this.uo_1=create uo_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_gen_actualiza_marcaciones_as302.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.uo_1)
destroy(this.gb_1)
end on

event open;call super::open;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - w_gen_actualiza_marcaciones_as302.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - w_gen_actualiza_marcaciones_as302.WorkSpaceHeight()) / 2) - 150
w_gen_actualiza_marcaciones_as302.move(ll_x,ll_y)

end event

type cb_1 from commandbutton within w_gen_actualiza_marcaciones_as302
integer x = 800
integer y = 624
integer width = 302
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Date   ld_fec_proceso
ld_fec_proceso = uo_1.of_get_fecha() 

// Declara ejecuación de marcaciones consolidadas diarias
DECLARE pb_usp_asi_marcacion_consolidada PROCEDURE FOR USP_ASI_MARCACION_CONSOLIDADA
        ( :ld_fec_proceso ) ;

EXECUTE pb_usp_asi_marcacion_consolidada;

IF SQLCA.SQLCode = -1 THEN 
  rollback ;
  MessageBox("SQL error", SQLCA.SQLErrText)
  MessageBox('Atención','Proceso de marcaciones, falló', Exclamation! )
ELSE
  commit ;
  MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)
END IF


end event

type st_2 from statictext within w_gen_actualiza_marcaciones_as302
integer x = 247
integer y = 180
integer width = 1376
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
string text = "ACTUALIZACION DE MARCACIONES DIARIAS"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_fecha within w_gen_actualiza_marcaciones_as302
event destroy ( )
integer x = 626
integer y = 420
integer taborder = 10
end type

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;Date ld_fec_proceso 
of_set_label('Día')

ld_fec_proceso = today()

of_set_fecha (ld_fec_proceso)
of_set_rango_inicio (date('01/01/1900'))
of_set_rango_fin (date('31/12/9999'))

end event

type gb_1 from groupbox within w_gen_actualiza_marcaciones_as302
integer x = 553
integer y = 348
integer width = 750
integer height = 200
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 79741120
string text = " Digite Fecha "
borderstyle borderstyle = styleraised!
end type

