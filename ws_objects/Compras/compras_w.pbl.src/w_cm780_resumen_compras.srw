$PBExportHeader$w_cm780_resumen_compras.srw
forward
global type w_cm780_resumen_compras from w_report_smpl
end type
type cb_1 from commandbutton within w_cm780_resumen_compras
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm780_resumen_compras
end type
type cbx_origen from checkbox within w_cm780_resumen_compras
end type
type pb_1 from picturebutton within w_cm780_resumen_compras
end type
type sle_origen from singlelineedit within w_cm780_resumen_compras
end type
type sle_desc_origen from singlelineedit within w_cm780_resumen_compras
end type
type rb_oc from radiobutton within w_cm780_resumen_compras
end type
type rb_os from radiobutton within w_cm780_resumen_compras
end type
type cbx_pt_mp from checkbox within w_cm780_resumen_compras
end type
type gb_1 from groupbox within w_cm780_resumen_compras
end type
type gb_destino from groupbox within w_cm780_resumen_compras
end type
type gb_2 from groupbox within w_cm780_resumen_compras
end type
end forward

global type w_cm780_resumen_compras from w_report_smpl
integer width = 3323
integer height = 2104
string title = "[CM780] ABC Resumen de compras"
string menuname = "m_impresion"
long backcolor = 67108864
cb_1 cb_1
uo_fecha uo_fecha
cbx_origen cbx_origen
pb_1 pb_1
sle_origen sle_origen
sle_desc_origen sle_desc_origen
rb_oc rb_oc
rb_os rb_os
cbx_pt_mp cbx_pt_mp
gb_1 gb_1
gb_destino gb_destino
gb_2 gb_2
end type
global w_cm780_resumen_compras w_cm780_resumen_compras

type variables
Decimal{4} id_total, id_descuento
Date id_fecha_ini, id_fecha_fin
String is_origen, is_texto, is_opcion
end variables

forward prototypes
public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_oc, ref string as_oper_cons)
end prototypes

public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_oc, ref string as_oper_cons);Long		ll_rc = 0



  SELECT "LOGPARAM"."DOC_OT", "LOGPARAM"."DOC_OC", "LOGPARAM"."OPER_CONS_INTERNO"  
    INTO :as_doc_ot, :as_doc_oc, :as_oper_cons
    FROM "LOGPARAM"  
   WHERE "LOGPARAM"."RECKEY" = '1' ;

	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_cm780_resumen_compras.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.cbx_origen=create cbx_origen
this.pb_1=create pb_1
this.sle_origen=create sle_origen
this.sle_desc_origen=create sle_desc_origen
this.rb_oc=create rb_oc
this.rb_os=create rb_os
this.cbx_pt_mp=create cbx_pt_mp
this.gb_1=create gb_1
this.gb_destino=create gb_destino
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.cbx_origen
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.sle_origen
this.Control[iCurrent+6]=this.sle_desc_origen
this.Control[iCurrent+7]=this.rb_oc
this.Control[iCurrent+8]=this.rb_os
this.Control[iCurrent+9]=this.cbx_pt_mp
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_destino
this.Control[iCurrent+12]=this.gb_2
end on

on w_cm780_resumen_compras.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.cbx_origen)
destroy(this.pb_1)
destroy(this.sle_origen)
destroy(this.sle_desc_origen)
destroy(this.rb_oc)
destroy(this.rb_os)
destroy(this.cbx_pt_mp)
destroy(this.gb_1)
destroy(this.gb_destino)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String	ls_st_origen, ls_msj

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

IF cbx_origen.checked = False THEN
	is_origen = trim(sle_desc_origen.text)
	
	select nombre 
	  into :ls_st_origen 
	  from origen o 
	 where o.cod_origen=:is_origen ;
	 
 	is_origen = is_origen + '%'
	 
ELSE
	is_origen = '%%' //is_origen
	ls_st_origen = 'Todos los Origenes'
END IF

IF rb_os.checked = TRUE THEN
	// Servicios
	is_opcion = 'S'
ELSEIF rb_oc.checked = TRUE THEN
	IF cbx_pt_mp.checked=TRUE THEN
		// Todas las compras, incluye compras de materia prima y productos terminados
		is_opcion = 'C'
	ELSE
		// No inlcuye compras de materia prima ni productos terminados
		is_opcion = 'A'		
	END IF
ELSE
	MessageBox( 'Aviso', 'Defina tipo de reporte' )
	Return
END IF 

sle_desc_origen.text = ls_st_origen 

id_fecha_ini = uo_fecha.of_get_fecha1()
id_fecha_fin = uo_fecha.of_get_fecha2()  

//create or replace procedure USP_CMP_RESUMEN_COMPRAS(
//       asi_origen  in STRING, 
//       asi_opcion  in char, 
//       adi_fec_ini IN date, 
//       adi_fec_fin IN date)
//IS 

DECLARE USP_CMP_RESUMEN_COMPRAS PROCEDURE FOR 
	USP_CMP_RESUMEN_COMPRAS(:is_origen, 
									:is_opcion,
									:id_fecha_ini, 
									:id_fecha_fin );

EXECUTE USP_CMP_RESUMEN_COMPRAS ;

IF sqlca.sqlcode = -1 THEN
	ls_msj = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error USP_CMP_RESUMEN_COMPRAS', ls_msj, StopSign! )
	return
END IF

CLOSE USP_CMP_RESUMEN_COMPRAS;

idw_1.ii_zoom_actual = 120
ib_preview = false

event ue_preview()

is_texto = 'Del: ' + String(id_fecha_ini, 'dd/mm/yyyy') + ' al ' &
		+ String(id_fecha_fin, 'dd/mm/yyyy') + ' - ' + ls_st_origen

idw_1.Retrieve()
idw_1.object.t_texto.text = is_texto 

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = this.classname( )

SELECT round(sum(tt.cant_proyect*(tt.precio_unit-tt.descuento)),4), 
		 round(sum(tt.cant_proyect*tt.descuento),4)  
  INTO :id_total, :id_descuento 
  FROM TT_CMP_COMPRAS_RESUMEN tt ;


end event

event ue_open_pre;call super::ue_open_pre;sle_origen.enabled = false
sle_origen.text = ''
end event

type dw_report from w_report_smpl`dw_report within w_cm780_resumen_compras
integer x = 0
integer y = 316
integer width = 3022
integer height = 1204
string dataobject = "d_rpt_compras_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

str_parametros lstr_rep
String ls_texto 

lstr_rep.string1 = is_texto
lstr_rep.dec1 = id_total


CHOOSE CASE dwo.Name
	CASE "total_dolar" 
		lstr_rep.dec1 = id_total
		OpenSheetWithParm(w_cm780_compras_total, lstr_rep, w_main, 2, layered!)
	CASE "descuento" 
		lstr_rep.dec1 = id_descuento
		OpenSheetWithParm(w_cm780_descuento, lstr_rep, w_main, 2, layered!)		
	CASE "num_proveed" 
		lstr_rep.dec1 = id_total
		OpenSheetWithParm(w_cm780_proveedor, lstr_rep, w_main, 2, layered!)		
	CASE "num_fpago" 
		OpenSheetWithParm(w_cm780_fpago, lstr_rep, w_main, 2, layered!)		
	CASE "num_artic" 
		OpenSheetWithParm(w_cm780_articulo, lstr_rep, w_main, 2, layered!)		
END CHOOSE

end event

type cb_1 from commandbutton within w_cm780_resumen_compras
integer x = 2967
integer y = 96
integer width = 270
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;
IF (cbx_origen.enabled AND cbx_origen.checked) THEN
	
ELSE
	IF sle_origen.text = "" OR isnull(sle_origen.text) THEN
		MessageBox('Error', 'Tiene que seleccionar Origen')
		RETURN
	END IF
END IF

PARENT.Event ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_cm780_resumen_compras
integer x = 791
integer y = 112
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(RelativeDate(Today(),-90), Today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type cbx_origen from checkbox within w_cm780_resumen_compras
integer x = 2208
integer y = 92
integer width = 576
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
string text = "Todos los origenes"
boolean checked = true
end type

event clicked;IF THIS.checked THEN
	sle_origen.enabled = false
	sle_origen.text = '' 
ELSE
 sle_origen.enabled = true
 sle_origen.text = gs_origen 
END IF
end event

type pb_1 from picturebutton within w_cm780_resumen_compras
integer x = 2331
integer y = 168
integer width = 114
integer height = 96
integer taborder = 30
boolean bringtotop = true
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

event clicked;String ls_inactivo
Long ll_nivel
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS CODIGO, '&
										 +'ORIGEN.NOMBRE AS DESCRIPCION '&
										 +'FROM ORIGEN WHERE ORIGEN.FLAG_ESTADO<>0 ' 
						  
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_origen.text = lstr_seleccionar.param1[1]
	sle_desc_origen.text = lstr_seleccionar.param2[1]
END IF

end event

type sle_origen from singlelineedit within w_cm780_resumen_compras
integer x = 2203
integer y = 168
integer width = 105
integer height = 88
integer taborder = 30
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

type sle_desc_origen from singlelineedit within w_cm780_resumen_compras
integer x = 2455
integer y = 168
integer width = 471
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type rb_oc from radiobutton within w_cm780_resumen_compras
integer x = 55
integer y = 112
integer width = 640
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
string text = "Ordenes de compras "
boolean checked = true
end type

type rb_os from radiobutton within w_cm780_resumen_compras
integer x = 55
integer y = 192
integer width = 640
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
string text = "Ordenes de servicios "
end type

type cbx_pt_mp from checkbox within w_cm780_resumen_compras
integer x = 791
integer y = 200
integer width = 1275
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
string text = "No considera prod. terminados y materia prima"
end type

type gb_1 from groupbox within w_cm780_resumen_compras
integer x = 759
integer y = 56
integer width = 1362
integer height = 236
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parámetros:"
end type

type gb_destino from groupbox within w_cm780_resumen_compras
integer x = 2181
integer y = 40
integer width = 773
integer height = 240
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrar Destino Por:"
end type

type gb_2 from groupbox within w_cm780_resumen_compras
integer x = 27
integer y = 52
integer width = 690
integer height = 236
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Tipo de reporte"
end type

