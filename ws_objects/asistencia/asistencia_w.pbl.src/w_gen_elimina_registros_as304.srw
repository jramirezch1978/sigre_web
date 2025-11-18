$PBExportHeader$w_gen_elimina_registros_as304.srw
forward
global type w_gen_elimina_registros_as304 from w_prc
end type
type st_1 from statictext within w_gen_elimina_registros_as304
end type
type rb_1 from radiobutton within w_gen_elimina_registros_as304
end type
type rb_2 from radiobutton within w_gen_elimina_registros_as304
end type
type rb_3 from radiobutton within w_gen_elimina_registros_as304
end type
type rb_4 from radiobutton within w_gen_elimina_registros_as304
end type
type uo_1 from u_ingreso_rango_fechas within w_gen_elimina_registros_as304
end type
type st_2 from statictext within w_gen_elimina_registros_as304
end type
type cb_1 from commandbutton within w_gen_elimina_registros_as304
end type
type mle_1 from multilineedit within w_gen_elimina_registros_as304
end type
type gb_1 from groupbox within w_gen_elimina_registros_as304
end type
end forward

global type w_gen_elimina_registros_as304 from w_prc
integer width = 2825
integer height = 1320
string title = "Elimina Información de Tablas (AS304)"
st_1 st_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
uo_1 uo_1
st_2 st_2
cb_1 cb_1
mle_1 mle_1
gb_1 gb_1
end type
global w_gen_elimina_registros_as304 w_gen_elimina_registros_as304

on w_gen_elimina_registros_as304.create
int iCurrent
call super::create
this.st_1=create st_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.uo_1=create uo_1
this.st_2=create st_2
this.cb_1=create cb_1
this.mle_1=create mle_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.uo_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.mle_1
this.Control[iCurrent+10]=this.gb_1
end on

on w_gen_elimina_registros_as304.destroy
call super::destroy
destroy(this.st_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.uo_1)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.mle_1)
destroy(this.gb_1)
end on

event open;call super::open;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - w_gen_elimina_registros_as304.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - w_gen_elimina_registros_as304.WorkSpaceHeight()) / 2) - 150
w_gen_elimina_registros_as304.move(ll_x,ll_y)

end event

type st_1 from statictext within w_gen_elimina_registros_as304
integer x = 91
integer y = 96
integer width = 2606
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
string text = "ELIMINA REGISTROS DE INFORMACION"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_gen_elimina_registros_as304
integer x = 101
integer y = 488
integer width = 1047
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Marcaciones del Reloj"
end type

type rb_2 from radiobutton within w_gen_elimina_registros_as304
integer x = 101
integer y = 564
integer width = 1047
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Consolidado de Marcaciones Diarias"
end type

type rb_3 from radiobutton within w_gen_elimina_registros_as304
integer x = 101
integer y = 640
integer width = 1047
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Programación de Turnos"
end type

type rb_4 from radiobutton within w_gen_elimina_registros_as304
integer x = 101
integer y = 720
integer width = 1047
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Incidencias del Trabajador"
end type

type uo_1 from u_ingreso_rango_fechas within w_gen_elimina_registros_as304
integer x = 1335
integer y = 340
integer height = 96
integer taborder = 10
end type

event constructor;call super::constructor;string ls_inicio, ls_fec 
date ld_fec
uo_1.of_set_label('Desde','Hasta')

// Obtiene primer día del mes
ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

uo_1.of_set_fecha(date(ls_inicio),today())
uo_1.of_set_rango_inicio(date('01/01/1900'))  // rango inicial
uo_1.of_set_rango_fin(date('31/12/9999'))     // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type st_2 from statictext within w_gen_elimina_registros_as304
integer x = 119
integer y = 352
integer width = 1056
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
string text = "  Seleccione Opción  "
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_gen_elimina_registros_as304
integer x = 1829
integer y = 528
integer width = 306
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

event clicked;Date ld_fec_desde
Date ld_fec_hasta
DateTime ld_fec_desde1
DateTime ld_fec_hasta1

ld_fec_desde=uo_1.of_get_fecha1()
ld_fec_hasta=uo_1.of_get_fecha2()

ld_fec_desde1=Datetime(uo_1.of_get_fecha1())
ld_fec_hasta1=Datetime(uo_1.of_get_fecha2(),time('23:59:59'))


// Borra registros de información almacenada
If rb_1.checked = true then
  delete from marcacion_reloj_asistencia
    where fecha_marcacion between :ld_fec_desde1 and :ld_fec_hasta1 ;
End if
If rb_2.checked = true then
  delete from marcacion_consolidada_diaria
    where fecha_marcacion between :ld_fec_desde and :ld_fec_hasta ;
End if
If rb_3.checked = true then
  delete from programacion_turnos
    where fecha_descanso between :ld_fec_desde and :ld_fec_hasta ;
End if
If rb_4.checked = true then
  delete from incidencia_trabajador
    where (fecha_movim between :ld_fec_desde and :ld_fec_hasta) ;
End if

IF SQLCA.SQLCode = -1 THEN 
  rollback ;
  MessageBox("SQL error", SQLCA.SQLErrText)
  MessageBox('Atención','No se pudo eliminar registros procesados', Exclamation! )
ELSE
  commit ;
  MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)
END IF


end event

type mle_1 from multilineedit within w_gen_elimina_registros_as304
integer x = 1449
integer y = 672
integer width = 1047
integer height = 424
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 65535
string text = "                                                                    ESTE PROCESO QUE ELIMINA REGISTROS DE INFORMACION ALMACENADA, SERA UNICA Y EXCLUSIVAMENTE RESPONSABILIDAD DEL PERSONAL DEL AREA DE RECURSOS HUMANOS"
alignment alignment = center!
borderstyle borderstyle = styleraised!
end type

type gb_1 from groupbox within w_gen_elimina_registros_as304
integer x = 1262
integer y = 264
integer width = 1426
integer height = 208
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 79741120
string text = " Rango de Fechas "
borderstyle borderstyle = styleraised!
end type

