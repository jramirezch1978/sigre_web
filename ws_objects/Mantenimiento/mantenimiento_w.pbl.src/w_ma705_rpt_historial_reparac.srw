$PBExportHeader$w_ma705_rpt_historial_reparac.srw
forward
global type w_ma705_rpt_historial_reparac from w_report_smpl
end type
type cb_generar from commandbutton within w_ma705_rpt_historial_reparac
end type
type uo_fecha from u_ingreso_rango_fechas within w_ma705_rpt_historial_reparac
end type
type cbx_ot_adm from checkbox within w_ma705_rpt_historial_reparac
end type
type cbx_maquina from checkbox within w_ma705_rpt_historial_reparac
end type
type sle_codigo from singlelineedit within w_ma705_rpt_historial_reparac
end type
type pb_1 from picturebutton within w_ma705_rpt_historial_reparac
end type
type sle_descrip from singlelineedit within w_ma705_rpt_historial_reparac
end type
type rb_1 from radiobutton within w_ma705_rpt_historial_reparac
end type
type rb_2 from radiobutton within w_ma705_rpt_historial_reparac
end type
type rb_3 from radiobutton within w_ma705_rpt_historial_reparac
end type
type gb_2 from groupbox within w_ma705_rpt_historial_reparac
end type
type st_1 from statictext within w_ma705_rpt_historial_reparac
end type
end forward

global type w_ma705_rpt_historial_reparac from w_report_smpl
integer width = 3447
integer height = 1944
string title = "Historial de reparacion de talleres (MA705)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
cb_generar cb_generar
uo_fecha uo_fecha
cbx_ot_adm cbx_ot_adm
cbx_maquina cbx_maquina
sle_codigo sle_codigo
pb_1 pb_1
sle_descrip sle_descrip
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
gb_2 gb_2
st_1 st_1
end type
global w_ma705_rpt_historial_reparac w_ma705_rpt_historial_reparac

type variables
String is_opcion
end variables

on w_ma705_rpt_historial_reparac.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_generar=create cb_generar
this.uo_fecha=create uo_fecha
this.cbx_ot_adm=create cbx_ot_adm
this.cbx_maquina=create cbx_maquina
this.sle_codigo=create sle_codigo
this.pb_1=create pb_1
this.sle_descrip=create sle_descrip
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.gb_2=create gb_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_generar
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.cbx_ot_adm
this.Control[iCurrent+4]=this.cbx_maquina
this.Control[iCurrent+5]=this.sle_codigo
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.sle_descrip
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.rb_3
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.st_1
end on

on w_ma705_rpt_historial_reparac.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_generar)
destroy(this.uo_fecha)
destroy(this.cbx_ot_adm)
destroy(this.cbx_maquina)
destroy(this.sle_codigo)
destroy(this.pb_1)
destroy(this.sle_descrip)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.gb_2)
destroy(this.st_1)
end on

event ue_open_pre;//override
//idw_1.Visible = True

idw_1 = dw_report
idw_1.Visible = FALSE
ib_preview = false
idw_1.ii_zoom_actual = 100

triggerEvent('ue_preview')

//idw_1.Object.p_logo.filename = gs_logo
is_opcion = 'F'  // Por causa de falla

end event

type dw_report from w_report_smpl`dw_report within w_ma705_rpt_historial_reparac
integer x = 23
integer y = 524
integer width = 3378
integer height = 1156
string dataobject = "d_rpt_historial_reparacion"
end type

type cb_generar from commandbutton within w_ma705_rpt_historial_reparac
integer x = 3022
integer y = 276
integer width = 297
integer height = 96
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
boolean cancel = true
end type

event clicked;String ls_cencos, ls_origen, ls_tipo, ls_codigo
Long   ll_count, ll_row
Date   ld_fini, ld_ffin

IF cbx_ot_adm.checked=TRUE THEN
	ls_tipo='OT'
ELSE
	ls_tipo='MQ'
END IF

ls_codigo = sle_codigo.text

IF ls_codigo = '' THEN
	messagebox('AVISO','FALTA UN PARAMETRO')
	RETURN
END IF
	
//Parent.SetRedraw(FALSE)
SetPointer(hourglass!)

cb_generar.enabled = false

ld_fini   = uo_fecha.of_get_fecha1()
ld_ffin   = uo_fecha.of_get_fecha2()

/*Eliminacion de Infomación Temporal*/
delete from tt_man_hist_reparac ;
/**/


IF is_opcion = 'F' THEN   //Fallas
	DECLARE PB_USP_MTT_REPARACION PROCEDURE FOR USP_MTT_RPT_HIST_REPARACION( :ls_tipo, :ls_codigo, :ld_fini, :ld_ffin ) ;
	execute PB_USP_MTT_REPARACION ;
ELSEIF is_opcion = 'O' THEN   //Mano de obra
	DECLARE PB_USP_MTT_MANO_OBRA PROCEDURE FOR USP_MTT_RPT_HIST_MANO_OBRA( :ls_tipo, :ls_codigo, :ld_fini, :ld_ffin ) ;
	execute PB_USP_MTT_MANO_OBRA ;
ELSEIF is_opcion = 'M' THEN //Materiales
	DECLARE PB_USP_MTT_RPT_HIST_ARTICULO PROCEDURE FOR USP_MTT_RPT_HIST_ARTICULO( :ls_tipo, :ls_codigo, :ld_fini, :ld_ffin ) ;
	execute PB_USP_MTT_RPT_HIST_ARTICULO ;
END IF ;

IF sqlca.sqlcode = -1 THEN
	MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
	cb_generar.enabled = true
	Return
END IF

IF is_opcion='F' then
	idw_1.DataObject='d_rpt_historial_reparacion'
ELSEIF is_opcion='O' then
	idw_1.DataObject='d_rpt_historial_mo_tbl'
ELSEIF is_opcion='M' then
	idw_1.DataObject='d_rpt_historial_material_tbl'
END IF

idw_1.SetTransObject(sqlca)
idw_1.retrieve()

idw_1.Object.t_texto.text = 'Del ' + string(ld_fini, 'dd/mm/yyyy') + ' al ' + string(ld_ffin, 'dd/mm/yyyy')
idw_1.Object.p_logo.filename = gs_logo
SetPointer(Arrow!)
//Parent.SetRedraw(TRUE)

ib_preview = false
idw_1.visible=true
idw_1.ii_zoom_actual = 100
parent.event ue_preview()

cb_generar.enabled = true
end event

type uo_fecha from u_ingreso_rango_fechas within w_ma705_rpt_historial_reparac
integer x = 695
integer y = 336
integer taborder = 20
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label("Desde :","Hasta :")
of_set_fecha(TODAY(),TODAY())
of_set_rango_inicio(DATE('01/01/1900'))
of_set_rango_fin(DATE('31/12/9999'))
end event

type cbx_ot_adm from checkbox within w_ma705_rpt_historial_reparac
integer x = 87
integer y = 216
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
string text = "OT_ADM"
end type

event clicked;sle_codigo.text=''
sle_descrip.text = ''
end event

type cbx_maquina from checkbox within w_ma705_rpt_historial_reparac
integer x = 87
integer y = 332
integer width = 512
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
string text = "Equipo / Maquina"
end type

event clicked;sle_codigo.text=''
sle_descrip.text = ''
end event

type sle_codigo from singlelineedit within w_ma705_rpt_historial_reparac
integer x = 699
integer y = 204
integer width = 265
integer height = 92
integer taborder = 50
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

type pb_1 from picturebutton within w_ma705_rpt_historial_reparac
integer x = 987
integer y = 200
integer width = 128
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\source\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;String ls_codigo
str_seleccionar lstr_seleccionar

IF (cbx_ot_adm.checked=true and cbx_maquina.checked=true) OR &
	(cbx_ot_adm.checked=false and cbx_maquina.checked=false) then
	messagebox('Aviso','Seleccione una opción')
	return
end if	

lstr_seleccionar.s_seleccion = 'S'

IF cbx_ot_adm.checked=true then
	lstr_seleccionar.s_sql = 'SELECT OT_ADMINISTRACION.OT_ADM AS CODIGO, '&
									 +'OT_ADMINISTRACION.DESCRIPCION AS DESCRIPCION '&
									 +'FROM OT_ADMINISTRACION '
	
	IF lstr_seleccionar.s_seleccion = 'S' THEN
		OpenWithParm(w_seleccionar,lstr_seleccionar)	
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			sle_codigo.text = lstr_seleccionar.param1[1]
			sle_descrip.text = lstr_seleccionar.param2[1]
		END IF
	END IF

else
	lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS CODIGO, '&
									 +'MAQUINA.DESC_MAQ AS DESCRIPCION '&
									 +'FROM MAQUINA '
	
	IF lstr_seleccionar.s_seleccion = 'S' THEN
		OpenWithParm(w_seleccionar,lstr_seleccionar)	
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			sle_codigo.text = lstr_seleccionar.param1[1]
			sle_descrip.text = lstr_seleccionar.param2[1]
		END IF
	END IF

END IF
end event

type sle_descrip from singlelineedit within w_ma705_rpt_historial_reparac
integer x = 1134
integer y = 204
integer width = 1042
integer height = 92
integer taborder = 60
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

type rb_1 from radiobutton within w_ma705_rpt_historial_reparac
integer x = 2418
integer y = 176
integer width = 498
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Causa de falla"
end type

event clicked;is_opcion = 'F'
end event

type rb_2 from radiobutton within w_ma705_rpt_historial_reparac
integer x = 2418
integer y = 276
integer width = 544
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por mano de obra"
end type

event clicked;is_opcion = 'O'
end event

type rb_3 from radiobutton within w_ma705_rpt_historial_reparac
integer x = 2418
integer y = 376
integer width = 521
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por materiales"
end type

event clicked;is_opcion = 'M'

end event

type gb_2 from groupbox within w_ma705_rpt_historial_reparac
integer x = 64
integer y = 124
integer width = 2921
integer height = 352
integer taborder = 40
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

type st_1 from statictext within w_ma705_rpt_historial_reparac
integer x = 375
integer y = 20
integer width = 2158
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "HISTORIAL DE REPARACION DE TALLERES"
alignment alignment = center!
boolean focusrectangle = false
end type

