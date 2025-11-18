$PBExportHeader$w_ma711_rpt_mntto_preventivo.srw
forward
global type w_ma711_rpt_mntto_preventivo from w_report_smpl
end type
type cb_generar from commandbutton within w_ma711_rpt_mntto_preventivo
end type
type sle_ot_adm from singlelineedit within w_ma711_rpt_mntto_preventivo
end type
type sle_descripcion from singlelineedit within w_ma711_rpt_mntto_preventivo
end type
type pb_1 from picturebutton within w_ma711_rpt_mntto_preventivo
end type
type sle_ejecutor from singlelineedit within w_ma711_rpt_mntto_preventivo
end type
type pb_2 from picturebutton within w_ma711_rpt_mntto_preventivo
end type
type sle_desc_ejecutor from singlelineedit within w_ma711_rpt_mntto_preventivo
end type
type uo_1 from u_ingreso_rango_fechas within w_ma711_rpt_mntto_preventivo
end type
type st_1 from statictext within w_ma711_rpt_mntto_preventivo
end type
type st_2 from statictext within w_ma711_rpt_mntto_preventivo
end type
type st_3 from statictext within w_ma711_rpt_mntto_preventivo
end type
type rb_res from radiobutton within w_ma711_rpt_mntto_preventivo
end type
type rb_det from radiobutton within w_ma711_rpt_mntto_preventivo
end type
type gb_1 from groupbox within w_ma711_rpt_mntto_preventivo
end type
type gb_2 from groupbox within w_ma711_rpt_mntto_preventivo
end type
end forward

global type w_ma711_rpt_mntto_preventivo from w_report_smpl
integer width = 3131
integer height = 1388
string title = "(MA711) Programa de mantemiento preventivo "
string menuname = "m_rpt_smpl"
long backcolor = 67108864
cb_generar cb_generar
sle_ot_adm sle_ot_adm
sle_descripcion sle_descripcion
pb_1 pb_1
sle_ejecutor sle_ejecutor
pb_2 pb_2
sle_desc_ejecutor sle_desc_ejecutor
uo_1 uo_1
st_1 st_1
st_2 st_2
st_3 st_3
rb_res rb_res
rb_det rb_det
gb_1 gb_1
gb_2 gb_2
end type
global w_ma711_rpt_mntto_preventivo w_ma711_rpt_mntto_preventivo

type variables

end variables

on w_ma711_rpt_mntto_preventivo.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_generar=create cb_generar
this.sle_ot_adm=create sle_ot_adm
this.sle_descripcion=create sle_descripcion
this.pb_1=create pb_1
this.sle_ejecutor=create sle_ejecutor
this.pb_2=create pb_2
this.sle_desc_ejecutor=create sle_desc_ejecutor
this.uo_1=create uo_1
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.rb_res=create rb_res
this.rb_det=create rb_det
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_generar
this.Control[iCurrent+2]=this.sle_ot_adm
this.Control[iCurrent+3]=this.sle_descripcion
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.sle_ejecutor
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.sle_desc_ejecutor
this.Control[iCurrent+8]=this.uo_1
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.rb_res
this.Control[iCurrent+13]=this.rb_det
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.gb_2
end on

on w_ma711_rpt_mntto_preventivo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_generar)
destroy(this.sle_ot_adm)
destroy(this.sle_descripcion)
destroy(this.pb_1)
destroy(this.sle_ejecutor)
destroy(this.pb_2)
destroy(this.sle_desc_ejecutor)
destroy(this.uo_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rb_res)
destroy(this.rb_det)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre();call super::ue_open_pre;idw_1.Visible = True


ib_preview = false
this.event ue_preview()


idw_1.Object.p_logo.filename = gs_logo
end event

event ue_filter();call super::ue_filter;idw_1.groupcalc()
end event

type dw_report from w_report_smpl`dw_report within w_ma711_rpt_mntto_preventivo
integer x = 37
integer y = 424
integer width = 2565
integer height = 764
integer taborder = 0
string dataobject = "d_rpt_mntto_prevent_maq_res"
boolean hsplitscroll = true
integer ii_zoom_actual = 100
end type

type cb_generar from commandbutton within w_ma711_rpt_mntto_preventivo
integer x = 2638
integer y = 308
integer width = 334
integer height = 96
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;String ls_ot_adm, ls_descripcion, ls_ejecutor, ls_desc_ejec
Date ld_fec_ini, ld_fec_fin
Long   ll_count, ll_row

ls_ot_adm = sle_ot_adm.text
ls_ejecutor = sle_ejecutor.text
ls_descripcion = sle_descripcion.text
ls_desc_ejec = sle_desc_ejecutor.text

cb_generar.enabled = false

IF Isnull(ls_ot_adm) OR Trim(ls_ot_adm) = '' THEN
	Messagebox('Aviso','Debe ingresar ot_adm')
	Return
END IF

ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()  


DECLARE PB_USP_MTT_RPT_PREVENTIVO_MAQ &
PROCEDURE FOR USP_MTT_RPT_PREVENTIVO_MAQ ( :ls_ot_adm, :ls_ejecutor, :ld_fec_ini, :ld_fec_fin) ;

execute PB_USP_MTT_RPT_PREVENTIVO_MAQ ;

IF sqlca.sqlcode = -1 THEN
	MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
	ROLLBACK ;
	Return
END IF

If rb_res.Checked = True then
	dw_report.DataObject = 'd_rpt_mntto_prevent_maq_res'
	dw_report.SetTransObject(sqlca)
elseif rb_det.Checked = True then
	dw_report.DataObject = 'd_rpt_mntto_prevent_maq_tbl'
	dw_report.SetTransObject(sqlca)
end if	
dw_report.object.t_subtitulo.Text = 'Del '+String(ld_fec_ini,'dd/mm/yyyy')+' Al '+String(ld_fec_fin,'dd/mm/yyyy')
dw_report.object.t_texto.Text = 'OT Adm: '+ls_ot_adm+' - '+ls_descripcion+'      Ejecutor: '+ls_ejecutor+ ' - '+ls_desc_ejec

dw_report.retrieve(gs_empresa,gs_user)
ib_preview = false
parent.event ue_preview()

cb_generar.enabled = true

end event

type sle_ot_adm from singlelineedit within w_ma711_rpt_mntto_preventivo
integer x = 759
integer y = 104
integer width = 270
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_ot_adm, ls_descripcion
Long ll_count

ls_ot_adm = sle_ot_adm.text

SELECT count(*) INTO :ll_count
FROM ot_administracion
WHERE ot_adm = :ls_ot_adm ;

IF ll_count > 0 THEN
	SELECT descripcion INTO :ls_descripcion
	FROM ot_administracion
	WHERE ot_adm = :ls_ot_adm ;
	
	sle_descripcion.text = ls_descripcion
ELSE
	MessageBox('Aviso','OT_ADM no existe')
END IF

end event

type sle_descripcion from singlelineedit within w_ma711_rpt_mntto_preventivo
integer x = 1147
integer y = 104
integer width = 1435
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
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_ma711_rpt_mntto_preventivo
integer x = 1042
integer y = 104
integer width = 91
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar
String ls_ot_adm, ls_descripcion

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_column = '1'
lstr_seleccionar.s_sql = 'SELECT OT_ADMINISTRACION.OT_ADM  AS  OT_ADM, ' &
   									 +'OT_ADMINISTRACION.DESCRIPCION AS DESCRIPCION '&     	
		 		   					 +'FROM OT_ADMINISTRACION ' &
										 +'ORDER BY OT_ADMINISTRACION.OT_ADM'
										  
OpenWithParm(w_seleccionar,lstr_seleccionar)	
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
	
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_ot_adm.text = lstr_seleccionar.param1[1]
   sle_descripcion.text = lstr_seleccionar.param2[1]
END IF

end event

type sle_ejecutor from singlelineedit within w_ma711_rpt_mntto_preventivo
integer x = 759
integer y = 196
integer width = 270
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_ejecutor, ls_descripcion
Long ll_count

ls_ejecutor = sle_ejecutor.text

SELECT count(*) INTO :ll_count
FROM ejecutor 
WHERE cod_ejecutor = :ls_ejecutor ;

IF ll_count > 0 THEN
	SELECT descripcion INTO :ls_descripcion
	FROM ejecutor 
	WHERE cod_ejecutor = :ls_ejecutor ;

	sle_desc_ejecutor.text = ls_descripcion
	
ELSE
	MessageBox('Aviso','Ejecutor no existe')
END IF

end event

type pb_2 from picturebutton within w_ma711_rpt_mntto_preventivo
integer x = 1042
integer y = 188
integer width = 91
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar
String ls_ejecutor, ls_desc_ejecutor

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_column = '1'
lstr_seleccionar.s_sql = 'SELECT EJECUTOR.COD_EJECUTOR  AS  COD_EJECUTOR, ' &
   									 +'EJECUTOR.DESCRIPCION AS DESCRIPCION '& 
		 		   					 +'FROM EJECUTOR ' &
										 +'ORDER BY EJECUTOR.COD_EJECUTOR'

OpenWithParm(w_seleccionar,lstr_seleccionar)	
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
	
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_ejecutor.text = lstr_seleccionar.param1[1]
   sle_desc_ejecutor.text = lstr_seleccionar.param2[1]
END IF

end event

type sle_desc_ejecutor from singlelineedit within w_ma711_rpt_mntto_preventivo
integer x = 1147
integer y = 200
integer width = 1435
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
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type uo_1 from u_ingreso_rango_fechas within w_ma711_rpt_mntto_preventivo
integer x = 759
integer y = 296
integer taborder = 50
boolean bringtotop = true
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

type st_1 from statictext within w_ma711_rpt_mntto_preventivo
integer x = 480
integer y = 112
integer width = 251
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "OT Adm. :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ma711_rpt_mntto_preventivo
integer x = 480
integer y = 208
integer width = 251
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Ejecutor :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_ma711_rpt_mntto_preventivo
integer x = 480
integer y = 312
integer width = 251
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Fechas :"
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_res from radiobutton within w_ma711_rpt_mntto_preventivo
integer x = 46
integer y = 96
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
boolean checked = true
end type

type rb_det from radiobutton within w_ma711_rpt_mntto_preventivo
integer x = 46
integer y = 160
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
end type

type gb_1 from groupbox within w_ma711_rpt_mntto_preventivo
integer x = 439
integer y = 32
integer width = 2181
integer height = 372
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Parámetros"
borderstyle borderstyle = stylebox!
end type

type gb_2 from groupbox within w_ma711_rpt_mntto_preventivo
integer x = 23
integer y = 36
integer width = 393
integer height = 212
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reporte"
end type

