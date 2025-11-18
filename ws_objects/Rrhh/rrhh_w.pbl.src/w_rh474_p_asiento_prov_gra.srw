$PBExportHeader$w_rh474_p_asiento_prov_gra.srw
forward
global type w_rh474_p_asiento_prov_gra from w_prc
end type
type rb_veda from radiobutton within w_rh474_p_asiento_prov_gra
end type
type rb_produc from radiobutton within w_rh474_p_asiento_prov_gra
end type
type uo_fechas from u_ingreso_rango_fechas within w_rh474_p_asiento_prov_gra
end type
type uo_fecha from u_ingreso_fecha within w_rh474_p_asiento_prov_gra
end type
type cb_1 from commandbutton within w_rh474_p_asiento_prov_gra
end type
type em_descripcion from editmask within w_rh474_p_asiento_prov_gra
end type
type em_origen from editmask within w_rh474_p_asiento_prov_gra
end type
type cb_2 from commandbutton within w_rh474_p_asiento_prov_gra
end type
type gb_1 from groupbox within w_rh474_p_asiento_prov_gra
end type
type gb_2 from groupbox within w_rh474_p_asiento_prov_gra
end type
type gb_3 from groupbox within w_rh474_p_asiento_prov_gra
end type
type gb_4 from groupbox within w_rh474_p_asiento_prov_gra
end type
end forward

global type w_rh474_p_asiento_prov_gra from w_prc
integer width = 2802
integer height = 752
string title = "(RH474) Asientos de provisión de Gratificaciones"
rb_veda rb_veda
rb_produc rb_produc
uo_fechas uo_fechas
uo_fecha uo_fecha
cb_1 cb_1
em_descripcion em_descripcion
em_origen em_origen
cb_2 cb_2
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_rh474_p_asiento_prov_gra w_rh474_p_asiento_prov_gra

on w_rh474_p_asiento_prov_gra.create
int iCurrent
call super::create
this.rb_veda=create rb_veda
this.rb_produc=create rb_produc
this.uo_fechas=create uo_fechas
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_2=create cb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_veda
this.Control[iCurrent+2]=this.rb_produc
this.Control[iCurrent+3]=this.uo_fechas
this.Control[iCurrent+4]=this.uo_fecha
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.em_descripcion
this.Control[iCurrent+7]=this.em_origen
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
this.Control[iCurrent+11]=this.gb_3
this.Control[iCurrent+12]=this.gb_4
end on

on w_rh474_p_asiento_prov_gra.destroy
call super::destroy
destroy(this.rb_veda)
destroy(this.rb_produc)
destroy(this.uo_fechas)
destroy(this.uo_fecha)
destroy(this.cb_1)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event open;call super::open;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)
end event

type rb_veda from radiobutton within w_rh474_p_asiento_prov_gra
integer x = 1550
integer y = 460
integer width = 407
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Veda"
end type

type rb_produc from radiobutton within w_rh474_p_asiento_prov_gra
integer x = 1550
integer y = 396
integer width = 407
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Producción "
boolean checked = true
end type

type uo_fechas from u_ingreso_rango_fechas within w_rh474_p_asiento_prov_gra
integer x = 123
integer y = 416
integer taborder = 60
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

type uo_fecha from u_ingreso_fecha within w_rh474_p_asiento_prov_gra
integer x = 1993
integer y = 172
integer taborder = 50
end type

event constructor;call super::constructor;of_set_label('Fecha:') // para seatear el titulo del boton
of_set_fecha(today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha()  para leer las fechas

end event

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

type cb_1 from commandbutton within w_rh474_p_asiento_prov_gra
integer x = 2213
integer y = 400
integer width = 293
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;string ls_origen, ls_usuario, ls_mensaje, ls_tipo
date ld_fec_proceso, ld_fec_desde, ld_fec_hasta
Parent.SetMicroHelp('Procesando Asientos Contables de Provisiones de Gratificaciones')

ls_usuario     = gs_user
ls_origen      = string(em_origen.text)
ld_fec_proceso = uo_fecha.of_get_fecha()  

ld_fec_desde   = uo_fechas.of_get_fecha1()  
ld_fec_hasta   = uo_fechas.of_get_fecha2()  

if ld_fec_desde > ld_fec_hasta then
	MessageBox('Error','Verifique Rangos de Fechas')
	return ;
end if

IF rb_produc.checked = TRUE THEN
	ls_tipo = 'P'
ELSE
	ls_tipo = 'V'
END IF ;

DECLARE pb_usp_rh_asiento_prov_gra PROCEDURE FOR USP_RH_ASIENTO_PROV_GRA
        ( :ls_origen, :ls_usuario, :ls_tipo, :ld_fec_proceso, :ld_fec_desde, :ld_fec_hasta ) ;
EXECUTE pb_usp_rh_asiento_prov_gra ;

IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText
  rollback ;
  MessageBox("SQL error", ls_mensaje )
  //MessageBox('Atención','No se generó asientos de provisiones de Gratificaciones', Exclamation! )
ELSE
  commit ;
  MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)
END IF

end event

type em_descripcion from editmask within w_rh474_p_asiento_prov_gra
integer x = 448
integer y = 156
integer width = 1143
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh474_p_asiento_prov_gra
integer x = 137
integer y = 156
integer width = 151
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh474_p_asiento_prov_gra
integer x = 320
integer y = 156
integer width = 87
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type gb_1 from groupbox within w_rh474_p_asiento_prov_gra
integer x = 82
integer y = 332
integer width = 1385
integer height = 216
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Horas de Distribución por Centros de Costos "
end type

type gb_2 from groupbox within w_rh474_p_asiento_prov_gra
integer x = 82
integer y = 84
integer width = 1563
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_rh474_p_asiento_prov_gra
integer x = 1961
integer y = 84
integer width = 713
integer height = 216
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Fecha de proceso"
end type

type gb_4 from groupbox within w_rh474_p_asiento_prov_gra
integer x = 1518
integer y = 332
integer width = 462
integer height = 216
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Tipo de proceso"
end type

