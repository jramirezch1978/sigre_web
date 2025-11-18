$PBExportHeader$w_cm711_ot_aprobaciones.srw
forward
global type w_cm711_ot_aprobaciones from w_report_smpl
end type
type rb_fechas from radiobutton within w_cm711_ot_aprobaciones
end type
type rb_aprobacion from radiobutton within w_cm711_ot_aprobaciones
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm711_ot_aprobaciones
end type
type cb_1 from commandbutton within w_cm711_ot_aprobaciones
end type
type ddlb_1 from dropdownlistbox within w_cm711_ot_aprobaciones
end type
type rb_ot from radiobutton within w_cm711_ot_aprobaciones
end type
type rb_usuario from radiobutton within w_cm711_ot_aprobaciones
end type
type sle_usuario from singlelineedit within w_cm711_ot_aprobaciones
end type
type cbx_servicio_terc from checkbox within w_cm711_ot_aprobaciones
end type
type sle_ot from u_sle_codigo within w_cm711_ot_aprobaciones
end type
type sle_nro from u_sle_codigo within w_cm711_ot_aprobaciones
end type
type gb_1 from groupbox within w_cm711_ot_aprobaciones
end type
end forward

global type w_cm711_ot_aprobaciones from w_report_smpl
integer width = 3634
integer height = 1908
string title = "OT APROBACIONES (CM711)"
string menuname = "m_impresion"
long backcolor = 67108864
rb_fechas rb_fechas
rb_aprobacion rb_aprobacion
uo_fecha uo_fecha
cb_1 cb_1
ddlb_1 ddlb_1
rb_ot rb_ot
rb_usuario rb_usuario
sle_usuario sle_usuario
cbx_servicio_terc cbx_servicio_terc
sle_ot sle_ot
sle_nro sle_nro
gb_1 gb_1
end type
global w_cm711_ot_aprobaciones w_cm711_ot_aprobaciones

type variables
String	is_doc_ot
end variables

forward prototypes
public function string of_get_doc_ot ()
end prototypes

public function string of_get_doc_ot ();String	ls_doc_ot

  SELECT "PROD_PARAM"."DOC_OT"  
    INTO :ls_doc_ot  
    FROM "PROD_PARAM"  
   WHERE "PROD_PARAM"."RECKEY" = '1' ;


RETURN ls_doc_ot
end function

on w_cm711_ot_aprobaciones.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_fechas=create rb_fechas
this.rb_aprobacion=create rb_aprobacion
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.ddlb_1=create ddlb_1
this.rb_ot=create rb_ot
this.rb_usuario=create rb_usuario
this.sle_usuario=create sle_usuario
this.cbx_servicio_terc=create cbx_servicio_terc
this.sle_ot=create sle_ot
this.sle_nro=create sle_nro
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_fechas
this.Control[iCurrent+2]=this.rb_aprobacion
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.ddlb_1
this.Control[iCurrent+6]=this.rb_ot
this.Control[iCurrent+7]=this.rb_usuario
this.Control[iCurrent+8]=this.sle_usuario
this.Control[iCurrent+9]=this.cbx_servicio_terc
this.Control[iCurrent+10]=this.sle_ot
this.Control[iCurrent+11]=this.sle_nro
this.Control[iCurrent+12]=this.gb_1
end on

on w_cm711_ot_aprobaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_fechas)
destroy(this.rb_aprobacion)
destroy(this.uo_fecha)
destroy(this.cb_1)
destroy(this.ddlb_1)
destroy(this.rb_ot)
destroy(this.rb_usuario)
destroy(this.sle_usuario)
destroy(this.cbx_servicio_terc)
destroy(this.sle_ot)
destroy(this.sle_nro)
destroy(this.gb_1)
end on

event ue_open_pre;//Ancestor Script Override
idw_1 = dw_report
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
idw_1.Visible = true

rb_fechas.Event dynamic clicked()

is_doc_ot = of_get_doc_ot()

ddlb_1.Text = 'Materiales'
end event

event ue_retrieve;call super::ue_retrieve;Date ld_fecha1, ld_fecha2
Integer	li_papel
String	ls_elemento

if ddlb_1.Text = '' then
	MessageBox('Aviso', 'Debe Seleccionar un tipo de Reporte')
	return 
end if

CHOOSE CASE ddlb_1.Text
	CASE 'Materiales'
		ls_elemento = ddlb_1.Text
		IF rb_fechas.Checked then //Rango de Fechas
			li_papel = 1
			ld_fecha1 = uo_fecha.of_get_fecha1()
			ld_fecha2 = uo_fecha.of_get_fecha2()
			idw_1.DataObject = 'd_rpt_aprobaciones_det_tbl'
			idw_1.SetTransObject(SQLCA)
			idw_1.Retrieve(ld_fecha1, ld_fecha2)
			idw_1.object.detalle_t.text  = 'Desde: ' + string(ld_fecha1, 'dd/mm/yyyy') &
					+ ' Hasta: ' + + string(ld_fecha2, 'dd/mm/yyyy')	
		ELSEIF rb_aprobacion.Checked then // Nro Aprobacion
			li_papel = 1
			idw_1.DataObject = 'd_rpt_ot_materiales_nro_tbl'
			idw_1.SetTransObject(SQLCA)
			idw_1.Retrieve(sle_nro.text)
			idw_1.object.detalle_t.text  = 'NRO APROBACION: ' + sle_nro.text
		ELSEIF rb_ot.Checked then // Nro OT
			li_papel = 1
			idw_1.DataObject = 'd_rpt_aprobaciones_det_ot_tbl'
			idw_1.SetTransObject(SQLCA)
			idw_1.Retrieve(is_doc_ot, sle_ot.text)
			idw_1.object.detalle_t.text  = 'NRO OT: ' + sle_ot.text
		ELSEIF rb_usuario.Checked then // Cod Usuario
			li_papel = 1
			ld_fecha1 = uo_fecha.of_get_fecha1()
			ld_fecha2 = uo_fecha.of_get_fecha2()
			idw_1.DataObject = 'd_rpt_aprobaciones_det_usr_tbl'
			idw_1.SetTransObject(SQLCA)
			idw_1.Retrieve(sle_usuario.text, ld_fecha1, ld_fecha2)
			idw_1.object.detalle_t.text  = 'Desde: ' + string(ld_fecha1, 'dd/mm/yyyy') &
				+ ' Hasta: ' + + string(ld_fecha2, 'dd/mm/yyyy')	
		END IF
	CASE 'Operaciones'
		IF rb_fechas.Checked then  //Rango de Fechas
			IF cbx_servicio_terc.checked THEN
				idw_1.DataObject = 'd_rpt_aprobaciones_oper_3ro_det_tbl'
			ELSE
				idw_1.DataObject = 'd_rpt_aprobaciones_oper_det_tbl'
			END IF
			li_papel = 1
			ld_fecha1 = uo_fecha.of_get_fecha1()
			ld_fecha2 = uo_fecha.of_get_fecha2()
			idw_1.SetTransObject(SQLCA)
			idw_1.Retrieve(ld_fecha1, ld_fecha2)
			idw_1.object.detalle_t.text  = 'Desde: ' + string(ld_fecha1, 'dd/mm/yyyy') &
					+ ' Hasta: ' + + string(ld_fecha2, 'dd/mm/yyyy')	
		ELSEIF rb_aprobacion.Checked then  // Nro Aprobacion
			IF cbx_servicio_terc.checked THEN
				idw_1.DataObject = 'd_rpt_aprobaciones_oper_nro_ap_3ro_tbl'
			ELSE
				idw_1.DataObject = 'd_rpt_aprobaciones_oper_nro_ap_det_tbl'
			END IF
			li_papel = 1
			idw_1.SetTransObject(SQLCA)
			idw_1.Retrieve(sle_nro.text)
			idw_1.object.detalle_t.text  = 'NRO APROBACION: ' + sle_nro.text
		ELSEIF rb_ot.Checked then  // Nro OT
			IF cbx_servicio_terc.checked THEN
				idw_1.DataObject = 'd_rpt_aprobaciones_oper_ot_det_3ro_tbl'
			ELSE
				idw_1.DataObject = 'd_rpt_aprobaciones_oper_ot_det_tbl'
			END IF
			li_papel = 1
			idw_1.SetTransObject(SQLCA)
			idw_1.Retrieve(sle_ot.text)
			idw_1.object.detalle_t.text  = 'NRO OT: ' + sle_ot.text
		ELSEIF rb_usuario.Checked then  // Cod Usuario
			IF cbx_servicio_terc.checked THEN
				idw_1.DataObject = 'd_rpt_aprobaciones_oper_3ro_det_usr_tbl'
			ELSE
				idw_1.DataObject = 'd_rpt_aprobaciones_oper_det_usr_tbl'
			END IF
			li_papel = 1
			ld_fecha1 = uo_fecha.of_get_fecha1()
			ld_fecha2 = uo_fecha.of_get_fecha2()
			idw_1.SetTransObject(SQLCA)
			idw_1.Retrieve(sle_usuario.text, ld_fecha1, ld_fecha2)
			idw_1.object.detalle_t.text  = 'Desde: ' + string(ld_fecha1, 'dd/mm/yyyy') &
				+ ' Hasta: ' + + string(ld_fecha2, 'dd/mm/yyyy')
		END IF
		IF cbx_servicio_terc.checked THEN
				ls_elemento = ddlb_1.Text + ' - Terceros'
			ELSE
				ls_elemento = ddlb_1.Text
			END IF
END CHOOSE

idw_1.Object.Datawindow.Print.Orientation = li_papel    // 0=default,1=Landscape, 2=Portrait
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text     = gs_user
idw_1.object.t_empresa.text  = gs_empresa
idw_1.object.t_codigo.text   = 'CM711'
idw_1.object.elemento_t.text  = ls_elemento

ib_preview=false	
end event

type dw_report from w_report_smpl`dw_report within w_cm711_ot_aprobaciones
integer x = 0
integer y = 300
integer width = 2839
integer height = 1380
end type

type rb_fechas from radiobutton within w_cm711_ot_aprobaciones
integer x = 690
integer y = 72
integer width = 485
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
boolean checked = true
end type

event clicked;if this.checked then
	sle_nro.enabled = false
	sle_ot.enabled = false
	uo_fecha.enabled = true
else
	sle_nro.enabled = true
	sle_ot.enabled = true
	uo_fecha.enabled = false
end if
end event

type rb_aprobacion from radiobutton within w_cm711_ot_aprobaciones
integer x = 690
integer y = 164
integer width = 485
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Aprobacion"
end type

event clicked;if this.checked then
	sle_nro.enabled = true
	sle_ot.enabled = false
	uo_fecha.enabled = false
else
	sle_nro.enabled = false
	sle_ot.enabled = true
	uo_fecha.enabled = true
end if
end event

type uo_fecha from u_ingreso_rango_fechas within w_cm711_ot_aprobaciones
integer x = 1184
integer y = 68
integer taborder = 20
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date 		ld_fecha1, ld_fecha2
Integer 	li_ano, li_mes

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
//of_set_fecha(date('01/01/1900'), date('31/12/9999')) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

li_ano = Year(Today())
li_mes = Month(Today())

if li_mes = 12 then
	li_mes = 1
	li_ano ++
else
	li_mes ++
end if

//ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
//	+ '/' + string( year( today() ), '0000') )
//
//ld_fecha2 = date('01/' + String( li_mes ,'00' ) &
//	+ '/' + string(li_ano, '0000') )

//ld_fecha2 = RelativeDate( ld_fecha2, -1 )

ld_fecha2 = Today()
ld_fecha1 = RelativeDate( ld_fecha2, -30 )

This.of_set_fecha( ld_fecha1, ld_fecha2 )

end event

type cb_1 from commandbutton within w_cm711_ot_aprobaciones
integer x = 3232
integer y = 112
integer width = 283
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;parent.event ue_retrieve()
end event

type ddlb_1 from dropdownlistbox within w_cm711_ot_aprobaciones
integer x = 23
integer y = 100
integer width = 571
integer height = 352
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"Materiales","Operaciones"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;IF ddlb_1.Text = 'Operaciones' then
	cbx_servicio_terc.enabled = True
ELSE
	cbx_servicio_terc.enabled = False
END IF
end event

type rb_ot from radiobutton within w_cm711_ot_aprobaciones
integer x = 1600
integer y = 172
integer width = 256
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro OT"
end type

event clicked;if this.checked then
	sle_ot.enabled = true
else
	sle_ot.enabled = false
end if
end event

type rb_usuario from radiobutton within w_cm711_ot_aprobaciones
integer x = 2350
integer y = 172
integer width = 366
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cod Usuario"
end type

event clicked;if this.checked then
	sle_usuario.enabled = true
else
	sle_usuario.enabled = false
end if
end event

type sle_usuario from singlelineedit within w_cm711_ot_aprobaciones
integer x = 2725
integer y = 164
integer width = 434
integer height = 84
integer taborder = 50
string dragicon = "H:\Source\CUR\taladro.cur"
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type cbx_servicio_terc from checkbox within w_cm711_ot_aprobaciones
integer x = 2725
integer y = 68
integer width = 443
integer height = 60
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
string text = "Solo Serv Terc"
end type

type sle_ot from u_sle_codigo within w_cm711_ot_aprobaciones
integer x = 1879
integer y = 164
integer width = 434
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
boolean enabled = false
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type sle_nro from u_sle_codigo within w_cm711_ot_aprobaciones
integer x = 1138
integer y = 164
integer width = 402
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
boolean enabled = false
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type gb_1 from groupbox within w_cm711_ot_aprobaciones
integer x = 640
integer y = 16
integer width = 2546
integer height = 252
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

