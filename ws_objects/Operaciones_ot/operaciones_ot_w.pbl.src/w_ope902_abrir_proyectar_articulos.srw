$PBExportHeader$w_ope902_abrir_proyectar_articulos.srw
forward
global type w_ope902_abrir_proyectar_articulos from w_prc
end type
type uo_2 from u_ingreso_fecha within w_ope902_abrir_proyectar_articulos
end type
type rb_cerrar from radiobutton within w_ope902_abrir_proyectar_articulos
end type
type rb_reprogramar from radiobutton within w_ope902_abrir_proyectar_articulos
end type
type rb_proyectar from radiobutton within w_ope902_abrir_proyectar_articulos
end type
type rb_abrir from radiobutton within w_ope902_abrir_proyectar_articulos
end type
type pb_1 from picturebutton within w_ope902_abrir_proyectar_articulos
end type
type st_1 from statictext within w_ope902_abrir_proyectar_articulos
end type
type uo_1 from u_ingreso_rango_fechas within w_ope902_abrir_proyectar_articulos
end type
type sle_ot_adm from singlelineedit within w_ope902_abrir_proyectar_articulos
end type
type cb_2 from commandbutton within w_ope902_abrir_proyectar_articulos
end type
type cb_procesar from commandbutton within w_ope902_abrir_proyectar_articulos
end type
type gb_1 from groupbox within w_ope902_abrir_proyectar_articulos
end type
end forward

global type w_ope902_abrir_proyectar_articulos from w_prc
integer width = 1710
integer height = 1408
string title = "OPE901 - Abrir y cerrar operaciones"
uo_2 uo_2
rb_cerrar rb_cerrar
rb_reprogramar rb_reprogramar
rb_proyectar rb_proyectar
rb_abrir rb_abrir
pb_1 pb_1
st_1 st_1
uo_1 uo_1
sle_ot_adm sle_ot_adm
cb_2 cb_2
cb_procesar cb_procesar
gb_1 gb_1
end type
global w_ope902_abrir_proyectar_articulos w_ope902_abrir_proyectar_articulos

on w_ope902_abrir_proyectar_articulos.create
int iCurrent
call super::create
this.uo_2=create uo_2
this.rb_cerrar=create rb_cerrar
this.rb_reprogramar=create rb_reprogramar
this.rb_proyectar=create rb_proyectar
this.rb_abrir=create rb_abrir
this.pb_1=create pb_1
this.st_1=create st_1
this.uo_1=create uo_1
this.sle_ot_adm=create sle_ot_adm
this.cb_2=create cb_2
this.cb_procesar=create cb_procesar
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_2
this.Control[iCurrent+2]=this.rb_cerrar
this.Control[iCurrent+3]=this.rb_reprogramar
this.Control[iCurrent+4]=this.rb_proyectar
this.Control[iCurrent+5]=this.rb_abrir
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.uo_1
this.Control[iCurrent+9]=this.sle_ot_adm
this.Control[iCurrent+10]=this.cb_2
this.Control[iCurrent+11]=this.cb_procesar
this.Control[iCurrent+12]=this.gb_1
end on

on w_ope902_abrir_proyectar_articulos.destroy
call super::destroy
destroy(this.uo_2)
destroy(this.rb_cerrar)
destroy(this.rb_reprogramar)
destroy(this.rb_proyectar)
destroy(this.rb_abrir)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.uo_1)
destroy(this.sle_ot_adm)
destroy(this.cb_2)
destroy(this.cb_procesar)
destroy(this.gb_1)
end on

type uo_2 from u_ingreso_fecha within w_ope902_abrir_proyectar_articulos
integer x = 187
integer y = 848
integer taborder = 30
end type

event constructor;call super::constructor;of_set_label('Desde:') 
of_set_fecha(today()) 
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha()  para leer las fechas

end event

on uo_2.destroy
call u_ingreso_fecha::destroy
end on

type rb_cerrar from radiobutton within w_ope902_abrir_proyectar_articulos
integer x = 174
integer y = 324
integer width = 1189
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Cerrar articulos de ordenes de trabajo"
end type

type rb_reprogramar from radiobutton within w_ope902_abrir_proyectar_articulos
integer x = 174
integer y = 412
integer width = 1298
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reprogramar articulos de articulos OT"
end type

type rb_proyectar from radiobutton within w_ope902_abrir_proyectar_articulos
integer x = 174
integer y = 236
integer width = 1298
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Proyectar articulos de ordenes de trabajo"
end type

type rb_abrir from radiobutton within w_ope902_abrir_proyectar_articulos
integer x = 174
integer y = 148
integer width = 1298
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Abrir articulos de ordenes de trabajo"
end type

type pb_1 from picturebutton within w_ope902_abrir_proyectar_articulos
integer x = 891
integer y = 560
integer width = 128
integer height = 104
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT VW_CAM_USR_ADM.OT_ADM AS CODIGO, '&   
								 +'VW_CAM_USR_ADM.DESCRIPCION  AS DESCRIPCION  '&   
								 +'FROM  VW_CAM_USR_ADM '&
								 +'WHERE VW_CAM_USR_ADM.COD_USR = '+"'"+gs_user+"'"    	

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_ot_adm.text = lstr_seleccionar.param1[1]
END IF

end event

type st_1 from statictext within w_ope902_abrir_proyectar_articulos
integer x = 155
integer y = 572
integer width = 270
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT_ADM:"
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_ope902_abrir_proyectar_articulos
integer x = 165
integer y = 688
integer taborder = 20
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type sle_ot_adm from singlelineedit within w_ope902_abrir_proyectar_articulos
integer x = 443
integer y = 564
integer width = 366
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_ope902_abrir_proyectar_articulos
integer x = 1001
integer y = 1116
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Salir"
end type

event clicked;Close(Parent)
end event

type cb_procesar from commandbutton within w_ope902_abrir_proyectar_articulos
integer x = 288
integer y = 1120
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesa"
end type

event clicked;Date ld_fec_inicio, ld_fec_final, ld_fec_programa
String ls_ot_adm, ls_proceso, ls_msj
Long ll_count

ls_ot_adm = sle_ot_adm.text 

SELECT count(*) 
  INTO :ll_count
  FROM ot_administracion o 
 WHERE o.ot_adm=:ls_ot_adm ;

IF ll_count=0 THEN
	messagebox('Aviso', 'OT_ADM no existe')
	RETURN
END IF

IF (rb_cerrar.checked=FALSE AND rb_abrir.checked=FALSE) THEN
	messagebox('Aviso','Seleccione una opción')
	return
END IF

IF rb_abrir.checked=TRUE THEN
	ls_proceso = 'A'
ELSEIF rb_cerrar.checked=TRUE THEN
	ls_proceso = 'C'
ELSEIF rb_proyectar.checked=TRUE THEN
	ls_proceso = 'P'
ELSEIF rb_reprogramar.checked=TRUE THEN
	ls_proceso = 'R'
	ld_fec_programa = uo_2.of_get_fecha()  
END IF

ld_fec_inicio = uo_1.of_get_fecha1()
ld_fec_final = uo_1.of_get_fecha2()  

cb_procesar.enabled = false

IF ls_proceso='R' THEN
	DECLARE PB_USP_OPE_CIERRA_OPERACIONES PROCEDURE FOR USP_OPE_CIERRA_OPERACIONES ( 
		:ls_proceso, :ls_ot_adm, :ld_fec_inicio, :ld_fec_final ) ;
	execute PB_USP_OPE_CIERRA_OPERACIONES ;
//ELSE
//	DECLARE PB_USP_OPE_CIERRA_OPERACIONES PROCEDURE FOR USP_OPE_CIERRA_OPERACIONES ( 
//		:ls_proceso, :ls_ot_adm, :ld_fec_inicio, :ld_fec_final ) ;
//	execute PB_USP_OPE_CIERRA_OPERACIONES ;
END IF

IF sqlca.sqlcode = -1 Then
	ls_msj = sqlca.sqlerrtext
	rollback ;
	MessageBox( 'Error', ls_msj, StopSign! )
	MessageBox( 'Error', "Procedimiento <<USP_OPE_CIERRA_OPERACIONES>> no concluyo correctamente", StopSign! )
ELSE
	commit ;
	MessageBox( 'Mensaje', "Proceso terminado" )
End If

cb_procesar.enabled = true

end event

type gb_1 from groupbox within w_ope902_abrir_proyectar_articulos
integer x = 105
integer y = 68
integer width = 1490
integer height = 952
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

