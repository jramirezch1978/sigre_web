$PBExportHeader$w_ma715_inoperat_maquinas.srw
forward
global type w_ma715_inoperat_maquinas from w_rpt_list
end type
type uo_1 from u_ingreso_rango_fechas within w_ma715_inoperat_maquinas
end type
type st_1 from statictext within w_ma715_inoperat_maquinas
end type
type sle_ot_adm from singlelineedit within w_ma715_inoperat_maquinas
end type
type sle_descripcion from singlelineedit within w_ma715_inoperat_maquinas
end type
type pb_3 from picturebutton within w_ma715_inoperat_maquinas
end type
type rb_res from radiobutton within w_ma715_inoperat_maquinas
end type
type rb_det from radiobutton within w_ma715_inoperat_maquinas
end type
type gb_1 from groupbox within w_ma715_inoperat_maquinas
end type
type gb_2 from groupbox within w_ma715_inoperat_maquinas
end type
end forward

global type w_ma715_inoperat_maquinas from w_rpt_list
integer height = 1884
string title = "Inoperatividad de maquinas(MA715)"
string menuname = "m_rpt_smpl"
uo_1 uo_1
st_1 st_1
sle_ot_adm sle_ot_adm
sle_descripcion sle_descripcion
pb_3 pb_3
rb_res rb_res
rb_det rb_det
gb_1 gb_1
gb_2 gb_2
end type
global w_ma715_inoperat_maquinas w_ma715_inoperat_maquinas

type variables

end variables

on w_ma715_inoperat_maquinas.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_1=create uo_1
this.st_1=create st_1
this.sle_ot_adm=create sle_ot_adm
this.sle_descripcion=create sle_descripcion
this.pb_3=create pb_3
this.rb_res=create rb_res
this.rb_det=create rb_det
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_ot_adm
this.Control[iCurrent+4]=this.sle_descripcion
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.rb_res
this.Control[iCurrent+7]=this.rb_det
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_ma715_inoperat_maquinas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.st_1)
destroy(this.sle_ot_adm)
destroy(this.sle_descripcion)
destroy(this.pb_3)
destroy(this.rb_res)
destroy(this.rb_det)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;dw_report.SettransObject(sqlca)

// ii_help = 101           // help topic
idw_1 = dw_report
idw_1.Visible = TRUE
ib_preview = FALSE
//Trigger event ue_preview()

end event

event ue_filter;call super::ue_filter;idw_1.groupcalc()
end event

type dw_report from w_rpt_list`dw_report within w_ma715_inoperat_maquinas
integer x = 14
integer y = 376
integer width = 3401
integer height = 1276
string dataobject = "d_rpt_inoperat_maquina_tbl"
end type

type dw_1 from w_rpt_list`dw_1 within w_ma715_inoperat_maquinas
boolean visible = false
integer x = 91
integer y = 588
integer width = 1353
integer height = 960
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2


end event

type pb_1 from w_rpt_list`pb_1 within w_ma715_inoperat_maquinas
boolean visible = false
integer x = 1559
integer y = 916
end type

type pb_2 from w_rpt_list`pb_2 within w_ma715_inoperat_maquinas
boolean visible = false
integer x = 1559
integer y = 1144
end type

type dw_2 from w_rpt_list`dw_2 within w_ma715_inoperat_maquinas
boolean visible = false
integer x = 1851
integer y = 584
integer width = 1353
integer height = 960
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2

end event

type cb_report from w_rpt_list`cb_report within w_ma715_inoperat_maquinas
integer x = 2793
integer y = 156
integer width = 274
integer textsize = -8
string text = "Reporte"
end type

event cb_report::clicked;call super::clicked;String ls_ot_adm, ls_descripcion
Date ld_fini, ld_ffin

IF ( rb_res.checked=true and rb_det.checked=true) or    &
	( rb_res.checked=false and rb_det.checked=false) then
	messagebox('Aviso', 'Selección incorrecta de opciones')
	return
END IF

ls_ot_adm = sle_ot_adm.text

IF ls_ot_adm='' THEN
	messagebox('Aviso', 'Seleccione administrador de orden de trabajo')
	return
END IF

IF rb_res.checked=true then
    idw_1.DataObject='d_rpt_inoperat_maquina_tbl'
ELSE
    idw_1.DataObject='d_rpt_inoperat_maquina_det_tbl'	
END IF
idw_1.SetTransObject(sqlca)	

// Leyendo fechas de objeto fecha
ld_fini = uo_1.of_get_fecha1()
ld_ffin = uo_1.of_get_fecha2()  

DECLARE PB_usp_mtt_inoperat_maquina PROCEDURE FOR usp_mtt_inoperat_maquina ( :ls_ot_adm, :ld_fini, :ld_ffin ) ;
execute PB_usp_mtt_inoperat_maquina ;
	
IF sqlca.sqlcode = -1 THEN
   MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
	rollback ;
   Return
ELSE
   MessageBox( 'Aviso', "Fin de proceso")
END IF

ls_descripcion = 'Del ' + string(ld_fini, 'dd/mm/yyyy') + ' al ' + string(ld_ffin, 'dd/mm/yyyy')
idw_1.retrieve()
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = ls_descripcion

ib_preview = FALSE
parent.event ue_preview()

end event

type uo_1 from u_ingreso_rango_fechas within w_ma715_inoperat_maquinas
integer x = 649
integer y = 220
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') 
of_set_fecha(today(), today() )
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type st_1 from statictext within w_ma715_inoperat_maquinas
integer x = 658
integer y = 100
integer width = 274
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT_ADM:"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type sle_ot_adm from singlelineedit within w_ma715_inoperat_maquinas
integer x = 965
integer y = 100
integer width = 293
integer height = 84
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

type sle_descripcion from singlelineedit within w_ma715_inoperat_maquinas
integer x = 1463
integer y = 108
integer width = 1120
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type pb_3 from picturebutton within w_ma715_inoperat_maquinas
integer x = 1298
integer y = 100
integer width = 128
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;String ls_ot_adm

str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT OT_ADMINISTRACION.OT_ADM AS CODIGO, '&
						 		 +'OT_ADMINISTRACION.DESCRIPCION AS DESCRIPCION '&
								 +'FROM OT_ADMINISTRACION '

IF lstr_seleccionar.s_seleccion = 'S' THEN
	OpenWithParm(w_seleccionar,lstr_seleccionar)	
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_ot_adm.text = lstr_seleccionar.param1[1]
		sle_descripcion.text = lstr_seleccionar.param2[1]
	END IF
END IF

end event

type rb_res from radiobutton within w_ma715_inoperat_maquinas
integer x = 160
integer y = 104
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
end type

type rb_det from radiobutton within w_ma715_inoperat_maquinas
integer x = 160
integer y = 188
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
end type

type gb_1 from groupbox within w_ma715_inoperat_maquinas
integer x = 608
integer y = 36
integer width = 2021
integer height = 288
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

type gb_2 from groupbox within w_ma715_inoperat_maquinas
integer x = 105
integer y = 36
integer width = 448
integer height = 288
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Opciones"
end type

