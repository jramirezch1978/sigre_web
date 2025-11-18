$PBExportHeader$w_ope725_mat_ot_x_oc.srw
forward
global type w_ope725_mat_ot_x_oc from w_report_smpl
end type
type sle_codigo from singlelineedit within w_ope725_mat_ot_x_oc
end type
type sle_nombre from singlelineedit within w_ope725_mat_ot_x_oc
end type
type uo_1 from u_ingreso_rango_fechas within w_ope725_mat_ot_x_oc
end type
type cb_3 from commandbutton within w_ope725_mat_ot_x_oc
end type
type pb_1 from picturebutton within w_ope725_mat_ot_x_oc
end type
type rb_ota from radiobutton within w_ope725_mat_ot_x_oc
end type
type rb_ord from radiobutton within w_ope725_mat_ot_x_oc
end type
type rb_fec from radiobutton within w_ope725_mat_ot_x_oc
end type
type gb_1 from groupbox within w_ope725_mat_ot_x_oc
end type
end forward

global type w_ope725_mat_ot_x_oc from w_report_smpl
integer width = 3424
integer height = 1656
string title = "Atencion de materiales de orden de trabajo  (ope725)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
sle_codigo sle_codigo
sle_nombre sle_nombre
uo_1 uo_1
cb_3 cb_3
pb_1 pb_1
rb_ota rb_ota
rb_ord rb_ord
rb_fec rb_fec
gb_1 gb_1
end type
global w_ope725_mat_ot_x_oc w_ope725_mat_ot_x_oc

on w_ope725_mat_ot_x_oc.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.sle_codigo=create sle_codigo
this.sle_nombre=create sle_nombre
this.uo_1=create uo_1
this.cb_3=create cb_3
this.pb_1=create pb_1
this.rb_ota=create rb_ota
this.rb_ord=create rb_ord
this.rb_fec=create rb_fec
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_codigo
this.Control[iCurrent+2]=this.sle_nombre
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.rb_ota
this.Control[iCurrent+7]=this.rb_ord
this.Control[iCurrent+8]=this.rb_fec
this.Control[iCurrent+9]=this.gb_1
end on

on w_ope725_mat_ot_x_oc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_codigo)
destroy(this.sle_nombre)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.pb_1)
destroy(this.rb_ota)
destroy(this.rb_ord)
destroy(this.rb_fec)
destroy(this.gb_1)
end on

event ue_filter;call super::ue_filter;idw_1.groupcalc()
end event

event ue_open_pre;call super::ue_open_pre;sle_codigo.text=''
sle_nombre.text=''
end event

type dw_report from w_report_smpl`dw_report within w_ope725_mat_ot_x_oc
integer x = 50
integer y = 432
integer width = 3282
integer height = 980
string dataobject = "d_rpt_material_ot_tbl"
end type

type sle_codigo from singlelineedit within w_ope725_mat_ot_x_oc
integer x = 919
integer y = 132
integer width = 338
integer height = 88
integer taborder = 10
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

event modified;String ls_ot_adm, ls_descripcion
Long ll_count

ls_ot_adm = sle_codigo.text

SELECT count(*) 
  INTO :ll_count 
  FROM OT_ADMINISTRACION O 
 WHERE OT_ADM= :ls_ot_adm ;

IF ll_count>0 THEN
	SELECT descripcion
	  INTO :ls_descripcion
	  FROM OT_ADMINISTRACION O 
	 WHERE OT_ADM= :ls_ot_adm ;
	 
	 sle_nombre.text = ls_descripcion 
	 
END IF ;



end event

type sle_nombre from singlelineedit within w_ope725_mat_ot_x_oc
integer x = 1458
integer y = 132
integer width = 1166
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type uo_1 from u_ingreso_rango_fechas within w_ope725_mat_ot_x_oc
integer x = 914
integer y = 248
integer taborder = 20
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(today(), today()) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cb_3 from commandbutton within w_ope725_mat_ot_x_oc
integer x = 2793
integer y = 128
integer width = 357
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consultar"
end type

event clicked;String ls_codigo, ls_estado, ls_texto, ls_tipo, ls_msj_err
Date ld_fec_ini, ld_fec_fin

ls_codigo = TRIM(sle_codigo.text)

IF rb_fec.checked=false AND ls_codigo='' then
	messagebox('Aviso', 'Seleccione codigo a mostrar')
	return
END IF

SetPointer(hourglass!)
ls_codigo = TRIM(sle_codigo.text)
ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

IF rb_fec.checked=true then
	ls_tipo='0'
	ls_texto = 'Por fecha - '
	//idw_1.DataObject='d_rpt_parte_diario_gen_tbl'
ELSEIF rb_ota.checked=true then	
	ls_tipo='1'
	ls_texto = ls_codigo 
	//idw_1.DataObject='d_rpt_parte_diario_maq_tbl'
ELSEIF rb_ord.checked=true then	
	ls_tipo='2'
	ls_texto = ls_codigo 
	//idw_1.DataObject='d_rpt_parte_diario_ot_adm_tbl'
END IF


DECLARE PB_USP_OPE_ATENCION_OT_OC PROCEDURE FOR 
	USP_OPE_ATENCION_OT_OC(	:ls_tipo, 
									:ls_codigo, 
									:ld_fec_ini, 
									:ld_fec_fin );
EXECUTE PB_USP_OPE_ATENCION_OT_OC ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error',ls_msj_err)
	Return
end if

//Messagebox('Aviso', 'Proceso ha concluído satisfactoriamente')

CLOSE PB_USP_OPE_ATENCION_OT_OC ;

//idw_1.SetTransObject(sqlca)
idw_1.retrieve()

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = ls_texto + ', del ' + string(ld_fec_ini, 'dd/mm/yyyy') + ' al ' + string(ld_fec_fin, 'dd/mm/yyyy')
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
SetPointer(Arrow!)

ib_preview = false
idw_1.visible=true
idw_1.ii_zoom_actual = 100
parent.event ue_preview()

//cb_generar.enabled = true

end event

type pb_1 from picturebutton within w_ope725_mat_ot_x_oc
integer x = 1303
integer y = 128
integer width = 123
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
String ls_inactivo

IF rb_ota.checked = true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT OT_ADMINISTRACION.OT_ADM AS CODIGO,'&
									 +'OT_ADMINISTRACION.DESCRIPCION AS DESCRIPCION '&     	
		   						 +'FROM OT_ADMINISTRACION ' 

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_nombre.text = lstr_seleccionar.param2[1]
	END IF												 
END IF 

IF rb_ord.checked = true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT ORDEN_TRABAJO.NRO_ORDEN AS NRO_ORDEN,'&
									 +'ORDEN_TRABAJO.DESCRIPCION AS DESCRIPCION '&     	
		   						 +'FROM ORDEN_TRABAJO ' 

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_nombre.text = lstr_seleccionar.param2[1]
	END IF												 
END IF 

end event

type rb_ota from radiobutton within w_ope725_mat_ot_x_oc
integer x = 114
integer y = 188
integer width = 727
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por admin. de OT"
end type

event clicked;sle_codigo.text=''
sle_nombre.text=''
sle_codigo.enabled=true
sle_nombre.enabled=true
end event

type rb_ord from radiobutton within w_ope725_mat_ot_x_oc
integer x = 114
integer y = 260
integer width = 699
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por orden de trabajo"
end type

event clicked;sle_codigo.text=''
sle_nombre.text=''
sle_codigo.enabled=true
sle_nombre.enabled=true
end event

type rb_fec from radiobutton within w_ope725_mat_ot_x_oc
integer x = 114
integer y = 116
integer width = 480
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por fecha"
end type

event clicked;sle_codigo.text=''
sle_nombre.text=''
sle_codigo.enabled=false
sle_nombre.enabled=false
end event

type gb_1 from groupbox within w_ope725_mat_ot_x_oc
integer x = 59
integer y = 28
integer width = 2683
integer height = 352
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

