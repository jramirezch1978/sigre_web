$PBExportHeader$w_cn970_cierre_ejercicio.srw
forward
global type w_cn970_cierre_ejercicio from w_prc
end type
type st_5 from statictext within w_cn970_cierre_ejercicio
end type
type st_4 from statictext within w_cn970_cierre_ejercicio
end type
type st_3 from statictext within w_cn970_cierre_ejercicio
end type
type st_2 from statictext within w_cn970_cierre_ejercicio
end type
type em_cod_relacion from editmask within w_cn970_cierre_ejercicio
end type
type em_nro_doc from editmask within w_cn970_cierre_ejercicio
end type
type em_tipo_doc from editmask within w_cn970_cierre_ejercicio
end type
type em_cencos from editmask within w_cn970_cierre_ejercicio
end type
type uo_fecha from u_ingreso_fecha within w_cn970_cierre_ejercicio
end type
type cb_cancelar from commandbutton within w_cn970_cierre_ejercicio
end type
type cb_generar from commandbutton within w_cn970_cierre_ejercicio
end type
type st_1 from statictext within w_cn970_cierre_ejercicio
end type
type gb_1 from groupbox within w_cn970_cierre_ejercicio
end type
type gb_2 from groupbox within w_cn970_cierre_ejercicio
end type
end forward

global type w_cn970_cierre_ejercicio from w_prc
integer width = 2185
integer height = 1356
string title = "(CN970) Cierre Anual del Ejercicio"
boolean center = true
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
em_cod_relacion em_cod_relacion
em_nro_doc em_nro_doc
em_tipo_doc em_tipo_doc
em_cencos em_cencos
uo_fecha uo_fecha
cb_cancelar cb_cancelar
cb_generar cb_generar
st_1 st_1
gb_1 gb_1
gb_2 gb_2
end type
global w_cn970_cierre_ejercicio w_cn970_cierre_ejercicio

on w_cn970_cierre_ejercicio.create
int iCurrent
call super::create
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.em_cod_relacion=create em_cod_relacion
this.em_nro_doc=create em_nro_doc
this.em_tipo_doc=create em_tipo_doc
this.em_cencos=create em_cencos
this.uo_fecha=create uo_fecha
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.em_cod_relacion
this.Control[iCurrent+6]=this.em_nro_doc
this.Control[iCurrent+7]=this.em_tipo_doc
this.Control[iCurrent+8]=this.em_cencos
this.Control[iCurrent+9]=this.uo_fecha
this.Control[iCurrent+10]=this.cb_cancelar
this.Control[iCurrent+11]=this.cb_generar
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_cn970_cierre_ejercicio.destroy
call super::destroy
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.em_cod_relacion)
destroy(this.em_nro_doc)
destroy(this.em_tipo_doc)
destroy(this.em_cencos)
destroy(this.uo_fecha)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

type st_5 from statictext within w_cn970_cierre_ejercicio
integer x = 1065
integer y = 732
integer width = 590
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Código de Relación :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn970_cierre_ejercicio
integer x = 1065
integer y = 616
integer width = 590
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro Documento :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn970_cierre_ejercicio
integer x = 73
integer y = 732
integer width = 590
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Tipo de Documento :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn970_cierre_ejercicio
integer x = 73
integer y = 616
integer width = 590
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Centro de Costo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_cod_relacion from editmask within w_cn970_cierre_ejercicio
integer x = 1678
integer y = 724
integer width = 343
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_nro_doc from editmask within w_cn970_cierre_ejercicio
integer x = 1678
integer y = 616
integer width = 343
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_tipo_doc from editmask within w_cn970_cierre_ejercicio
integer x = 686
integer y = 724
integer width = 343
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_cencos from editmask within w_cn970_cierre_ejercicio
integer x = 686
integer y = 616
integer width = 343
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type uo_fecha from u_ingreso_fecha within w_cn970_cierre_ejercicio
integer x = 837
integer y = 356
integer taborder = 10
end type

event constructor;call super::constructor;date ld_fec_proceso 
of_set_label('Al')
ld_fec_proceso = Date(gnvo_app.of_fecha_Actual())

of_set_fecha(ld_fec_proceso)
of_set_rango_inicio(date('01/01/1900'))
of_set_rango_fin(date('31/12/9999'))

end event

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

type cb_cancelar from commandbutton within w_cn970_cierre_ejercicio
integer x = 1042
integer y = 936
integer width = 389
integer height = 140
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;CLOSE (PARENT)
end event

type cb_generar from commandbutton within w_cn970_cierre_ejercicio
integer x = 562
integer y = 932
integer width = 389
integer height = 144
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;date ld_fec_proceso
integer li_verifica
string ls_cencos, ls_tipo_doc, ls_nro_doc, ls_cod_relacion, ls_mensaje

try 
	cb_generar.enabled      = false
	cb_cancelar.enabled     = false
	em_cencos.enabled       = false
	em_tipo_doc.enabled     = false
	em_nro_doc.enabled      = false
	em_cod_relacion.enabled = false
	
	Yield ( )
	
	ld_fec_proceso 	= uo_fecha.of_get_fecha()
	ls_cencos 			= string(em_cencos.text)
	ls_tipo_doc 		= string(em_tipo_doc.text)
	ls_nro_doc 			= string(em_nro_doc.text)
	ls_cod_relacion 	= string(em_cod_relacion.text)
	
	li_verifica = 0
	if ls_cencos = '' then
		setnull(ls_cencos)
	else
		select count(*)
		  into :li_verifica
		  from centros_costo
		  where cencos = :ls_cencos 
		    and flag_estado = '1';
			 
		if li_verifica = 0 then
			MessageBox('Verificar','Centro de Costo no Existe o no esta activo, por favor verifique!')
			return
		end if
	end if
	
	li_verifica = 0
	if ls_tipo_doc = '' then
		setnull(ls_tipo_doc)
	else
		select count(*)
		  into :li_verifica
		  from doc_tipo
		  where tipo_doc = :ls_tipo_doc ;
		if li_verifica = 0 then
			MessageBox('Verificar','Tipo de Documento no Existe, por favor verifique!')
			return
		end if
	end if
	
	li_verifica = 0
	if ls_cod_relacion = '' then
		setnull(ls_cod_relacion)
	else
		select count(*)
		  into :li_verifica
		  from proveedor
		  where proveedor = :ls_cod_relacion 
		    and flag_estado <> '0';
		  
		if li_verifica = 0 then
			MessageBox('Verificar','Código de Relación no Existe o no esta activo, por favor verifique!')
			return
		end if
	end if
	
	if ls_nro_doc = '' then
		setnull(ls_nro_doc)
	end if
	
	DECLARE USP_CNTBL_CIERRE_EJERCICIO PROCEDURE FOR 
		USP_CNTBL_CIERRE_EJERCICIO( :ld_fec_proceso, 
											 :ls_cencos, 
											 :ls_tipo_doc, 
											 :ls_nro_doc, 
											 :ls_cod_relacion,
											 :gs_origen, 
											 :gs_user ) ;
	EXECUTE USP_CNTBL_CIERRE_EJERCICIO ;
	
	IF sqlca.sqlcode = -1 THEN
		ls_mensaje = sqlca.sqlerrtext
		ROLLBACK ;
		MessageBox( 'Store Procedure USP_CNTBL_CIERRE_EJERCICIO Falló', ls_mensaje, StopSign! )
		return
	end if
	
	COMMIT ;
	CLOSE USP_CNTBL_CIERRE_EJERCICIO ;
	
	MessageBox ('Atención', "Proceso Ha Concluído Satisfactoriamente")
	

catch ( Exception ex )
	f_mensaje("Ha ocurrido una excepcion: " + ex.getMessage(), "")
	
finally
	cb_generar.enabled      = true
	cb_cancelar.enabled     = true
	em_cencos.enabled       = true
	em_tipo_doc.enabled     = true
	em_nro_doc.enabled      = true
	em_cod_relacion.enabled = true
end try

end event

type st_1 from statictext within w_cn970_cierre_ejercicio
integer x = 489
integer y = 88
integer width = 1303
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 12632256
string text = "CIERRE ANUAL DEL EJERCICIO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn970_cierre_ejercicio
integer x = 46
integer y = 500
integer width = 2057
integer height = 376
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Datos Opcionales "
end type

type gb_2 from groupbox within w_cn970_cierre_ejercicio
integer x = 750
integer y = 276
integer width = 859
integer height = 208
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Fecha de Proceso "
end type

