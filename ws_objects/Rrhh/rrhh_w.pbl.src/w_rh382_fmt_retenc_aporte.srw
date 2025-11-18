$PBExportHeader$w_rh382_fmt_retenc_aporte.srw
forward
global type w_rh382_fmt_retenc_aporte from w_report_smpl
end type
type cb_3 from commandbutton within w_rh382_fmt_retenc_aporte
end type
type em_descripcion from editmask within w_rh382_fmt_retenc_aporte
end type
type em_origen from editmask within w_rh382_fmt_retenc_aporte
end type
type cb_1 from commandbutton within w_rh382_fmt_retenc_aporte
end type
type sle_representante from singlelineedit within w_rh382_fmt_retenc_aporte
end type
type st_3 from statictext within w_rh382_fmt_retenc_aporte
end type
type sle_codigo from singlelineedit within w_rh382_fmt_retenc_aporte
end type
type sle_nombre from singlelineedit within w_rh382_fmt_retenc_aporte
end type
type cb_4 from commandbutton within w_rh382_fmt_retenc_aporte
end type
type em_ejercicio from editmask within w_rh382_fmt_retenc_aporte
end type
type uo_1 from u_ingreso_fecha within w_rh382_fmt_retenc_aporte
end type
type rb_snp from radiobutton within w_rh382_fmt_retenc_aporte
end type
type rb_afp from radiobutton within w_rh382_fmt_retenc_aporte
end type
type gb_2 from groupbox within w_rh382_fmt_retenc_aporte
end type
type gb_1 from groupbox within w_rh382_fmt_retenc_aporte
end type
type gb_4 from groupbox within w_rh382_fmt_retenc_aporte
end type
type gb_3 from groupbox within w_rh382_fmt_retenc_aporte
end type
type gb_5 from groupbox within w_rh382_fmt_retenc_aporte
end type
end forward

global type w_rh382_fmt_retenc_aporte from w_report_smpl
integer width = 3502
integer height = 1936
string title = "(RH382) Formato de retención SNP o AFP"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
cb_1 cb_1
sle_representante sle_representante
st_3 st_3
sle_codigo sle_codigo
sle_nombre sle_nombre
cb_4 cb_4
em_ejercicio em_ejercicio
uo_1 uo_1
rb_snp rb_snp
rb_afp rb_afp
gb_2 gb_2
gb_1 gb_1
gb_4 gb_4
gb_3 gb_3
gb_5 gb_5
end type
global w_rh382_fmt_retenc_aporte w_rh382_fmt_retenc_aporte

on w_rh382_fmt_retenc_aporte.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_1=create cb_1
this.sle_representante=create sle_representante
this.st_3=create st_3
this.sle_codigo=create sle_codigo
this.sle_nombre=create sle_nombre
this.cb_4=create cb_4
this.em_ejercicio=create em_ejercicio
this.uo_1=create uo_1
this.rb_snp=create rb_snp
this.rb_afp=create rb_afp
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_4=create gb_4
this.gb_3=create gb_3
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.sle_representante
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.sle_codigo
this.Control[iCurrent+8]=this.sle_nombre
this.Control[iCurrent+9]=this.cb_4
this.Control[iCurrent+10]=this.em_ejercicio
this.Control[iCurrent+11]=this.uo_1
this.Control[iCurrent+12]=this.rb_snp
this.Control[iCurrent+13]=this.rb_afp
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_4
this.Control[iCurrent+17]=this.gb_3
this.Control[iCurrent+18]=this.gb_5
end on

on w_rh382_fmt_retenc_aporte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_1)
destroy(this.sle_representante)
destroy(this.st_3)
destroy(this.sle_codigo)
destroy(this.sle_nombre)
destroy(this.cb_4)
destroy(this.em_ejercicio)
destroy(this.uo_1)
destroy(this.rb_snp)
destroy(this.rb_afp)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.gb_5)
end on

event ue_retrieve;call super::ue_retrieve;STRING ls_tipo_fmt, ls_origen, ls_descripcion, ls_empresa, ls_ruc, ls_representante, &
		 ls_direccion1, ls_direccion2, ls_direccion3, ls_direccion4, ls_trabajador
DATE ld_fec_proceso
INTEGER li_periodo

ls_origen 		= string(em_origen.text)
ls_trabajador  = string(sle_codigo.text)
ld_fec_proceso = uo_1.of_get_fecha()
li_periodo 		= INTEGER(em_ejercicio.text)
IF rb_snp.checked THEN
	ls_tipo_fmt = 'S'
	dw_report.DataObject = 'd_rpt_fmt_retenc_snp'
ELSE
	ls_tipo_fmt = 'A'
	dw_report.DataObject = 'd_rpt_fmt_retenc_afp'
END IF
dw_report.SetTransObject(sqlca);

// 
DECLARE PB_USP_RH_FMT_RETENC_SNP_AFP PROCEDURE FOR USP_RH_FMT_RETENC_SNP_AFP(
  :li_periodo, :ls_origen, :ls_trabajador, :ld_fec_proceso , :ls_tipo_fmt ) ;
		 
EXECUTE PB_USP_RH_FMT_RETENC_SNP_AFP ;

ls_descripcion = 'Según D.Ley No 27605 - Ejercicio' + String(li_periodo) 

SELECT e.nombre, e.ruc INTO :ls_empresa, :ls_ruc 
  FROM empresa e where e.cod_empresa = (SELECT cod_empresa FROM genparam WHERE reckey='1') ;

ls_representante = TRIM(sle_representante.text)

SELECT o.dir_calle ||' - '||o.dir_distrito ||', '||o.dir_provincia INTO :ls_direccion1 
  FROM origen o WHERE o.cod_origen='LM' ;
  
SELECT o.dir_calle ||' - '||o.dir_distrito ||', '||o.dir_provincia INTO :ls_direccion2 
  FROM origen o WHERE o.cod_origen='CN' ;

SELECT o.dir_calle ||' - '||o.dir_distrito ||', '||o.dir_provincia INTO :ls_direccion3 
  FROM origen o WHERE o.cod_origen='SP' ;

SELECT o.dir_calle ||' - '||o.dir_distrito ||', '||o.dir_provincia INTO :ls_direccion4 
  FROM origen o WHERE o.cod_origen='PS' ;

dw_report.retrieve(li_periodo, ls_origen, ls_trabajador, ls_tipo_fmt)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_descripcion.text = ls_descripcion
dw_report.object.t_empresa.text = ls_empresa
dw_report.object.t_ruc.text = ls_ruc 
dw_report.object.t_representante.text = ls_representante
dw_report.object.t_direccion_01.text = ls_direccion1
dw_report.object.t_direccion_02.text = ls_direccion2
dw_report.object.t_direccion_03.text = ls_direccion3
dw_report.object.t_direccion_04.text = ls_direccion4

end event

event ue_open_pre;call super::ue_open_pre;sle_codigo.text = '%'
end event

type dw_report from w_report_smpl`dw_report within w_rh382_fmt_retenc_aporte
integer x = 0
integer y = 424
integer width = 3438
integer height = 1188
integer taborder = 60
string dataobject = "d_rpt_fmt_retenc_afp"
end type

type cb_3 from commandbutton within w_rh382_fmt_retenc_aporte
integer x = 1582
integer y = 100
integer width = 87
integer height = 68
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

type em_descripcion from editmask within w_rh382_fmt_retenc_aporte
integer x = 1696
integer y = 100
integer width = 718
integer height = 72
boolean bringtotop = true
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

type em_origen from editmask within w_rh382_fmt_retenc_aporte
integer x = 1458
integer y = 100
integer width = 96
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_1 from commandbutton within w_rh382_fmt_retenc_aporte
integer x = 2976
integer y = 296
integer width = 293
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type sle_representante from singlelineedit within w_rh382_fmt_retenc_aporte
integer x = 2048
integer y = 304
integer width = 763
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_rh382_fmt_retenc_aporte
integer x = 1669
integer y = 304
integer width = 361
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
string text = "Representante :"
boolean focusrectangle = false
end type

type sle_codigo from singlelineedit within w_rh382_fmt_retenc_aporte
integer x = 41
integer y = 304
integer width = 279
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_nombre from singlelineedit within w_rh382_fmt_retenc_aporte
integer x = 448
integer y = 304
integer width = 1157
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217738
borderstyle borderstyle = stylelowered!
end type

type cb_4 from commandbutton within w_rh382_fmt_retenc_aporte
integer x = 343
integer y = 304
integer width = 87
integer height = 68
integer taborder = 30
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

sl_param.dw1 = "d_rpt_select_codigo_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_codigo.text  = sl_param.field_ret[1]
	sle_nombre.text = sl_param.field_ret[2]
END IF
end event

type em_ejercicio from editmask within w_rh382_fmt_retenc_aporte
integer x = 782
integer y = 100
integer width = 343
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type uo_1 from u_ingreso_fecha within w_rh382_fmt_retenc_aporte
event destroy ( )
integer x = 2693
integer y = 100
integer taborder = 20
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:') // para seatear el titulo del boton
 of_set_fecha(today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha()  para leer las fechas

end event

type rb_snp from radiobutton within w_rh382_fmt_retenc_aporte
integer x = 50
integer y = 132
integer width = 443
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Retención SNP"
end type

type rb_afp from radiobutton within w_rh382_fmt_retenc_aporte
integer x = 50
integer y = 64
integer width = 443
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Retención AFP"
boolean checked = true
end type

type gb_2 from groupbox within w_rh382_fmt_retenc_aporte
integer x = 1408
integer y = 36
integer width = 1056
integer height = 172
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_1 from groupbox within w_rh382_fmt_retenc_aporte
integer x = 727
integer y = 28
integer width = 443
integer height = 172
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 79741120
string text = "Ejercicio"
end type

type gb_4 from groupbox within w_rh382_fmt_retenc_aporte
integer y = 236
integer width = 2848
integer height = 180
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 67108864
string text = "Trabajador y representante"
end type

type gb_3 from groupbox within w_rh382_fmt_retenc_aporte
integer x = 2651
integer y = 36
integer width = 727
integer height = 172
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 79741120
string text = "Fecha"
end type

type gb_5 from groupbox within w_rh382_fmt_retenc_aporte
integer width = 571
integer height = 224
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 79741120
string text = "Tipo retención"
end type

