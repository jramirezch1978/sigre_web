$PBExportHeader$w_cn815_rpt_guia_fact.srw
forward
global type w_cn815_rpt_guia_fact from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_cn815_rpt_guia_fact
end type
type pb_1 from picturebutton within w_cn815_rpt_guia_fact
end type
type st_nro_reg from statictext within w_cn815_rpt_guia_fact
end type
type st_3 from statictext within w_cn815_rpt_guia_fact
end type
type sle_origen from singlelineedit within w_cn815_rpt_guia_fact
end type
type cbx_1 from checkbox within w_cn815_rpt_guia_fact
end type
type st_desc_origen from statictext within w_cn815_rpt_guia_fact
end type
type st_1 from statictext within w_cn815_rpt_guia_fact
end type
type st_desc_almacen from statictext within w_cn815_rpt_guia_fact
end type
type sle_almacen from singlelineedit within w_cn815_rpt_guia_fact
end type
type st_2 from statictext within w_cn815_rpt_guia_fact
end type
type st_desc_tipo_mov from statictext within w_cn815_rpt_guia_fact
end type
type sle_tipo_mov from singlelineedit within w_cn815_rpt_guia_fact
end type
type st_5 from statictext within w_cn815_rpt_guia_fact
end type
type sle_con_desde from singlelineedit within w_cn815_rpt_guia_fact
end type
type st_4 from statictext within w_cn815_rpt_guia_fact
end type
type sle_con_hasta from singlelineedit within w_cn815_rpt_guia_fact
end type
type cbx_2 from checkbox within w_cn815_rpt_guia_fact
end type
type gb_1 from groupbox within w_cn815_rpt_guia_fact
end type
type gb_2 from groupbox within w_cn815_rpt_guia_fact
end type
type gb_3 from groupbox within w_cn815_rpt_guia_fact
end type
end forward

global type w_cn815_rpt_guia_fact from w_report_smpl
integer width = 3570
integer height = 2052
string title = "(CN815) Seguimiento de guias VS facturacion"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
uo_1 uo_1
pb_1 pb_1
st_nro_reg st_nro_reg
st_3 st_3
sle_origen sle_origen
cbx_1 cbx_1
st_desc_origen st_desc_origen
st_1 st_1
st_desc_almacen st_desc_almacen
sle_almacen sle_almacen
st_2 st_2
st_desc_tipo_mov st_desc_tipo_mov
sle_tipo_mov sle_tipo_mov
st_5 st_5
sle_con_desde sle_con_desde
st_4 st_4
sle_con_hasta sle_con_hasta
cbx_2 cbx_2
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_cn815_rpt_guia_fact w_cn815_rpt_guia_fact

type variables

end variables

forward prototypes
public function integer of_llamar_procedimiento ()
end prototypes

public function integer of_llamar_procedimiento ();
Date 		ld_fecini, ld_fecfin
String	ls_confin_ini, ls_confin_fin, ls_flag

ld_fecini = uo_1.of_get_fecha1()
ld_fecfin = uo_1.of_get_fecha2() 

SetPointer (HourGlass!)
 
string ls_mensaje, ls_null
 
SetNull(ls_null)

//Obtener rango de conceptos financieros para el proceso
IF cbx_2.checked THEN
	ls_flag = '1'
ELSE
	ls_flag = '0'
END IF

ls_confin_ini = sle_con_desde.text
ls_confin_fin = sle_con_hasta.text

//
//CREATE OR REPLACE PROCEDURE USP_CON_RPT_GUIA_FACT
//       ( AS_CONFIN_INI       IN CNTAS_COBRAR_DET.CONFIN%TYPE,
//         AS_CONFIN_FIN       IN CNTAS_COBRAR_DET.CONFIN%TYPE,
//         AS_FLAG            IN STRING)
 
DECLARE USP_CON_RPT_GUIA_FACT PROCEDURE FOR
 USP_CON_RPT_GUIA_FACT(  :ls_confin_ini,
 								 :ls_confin_fin,
								 :ls_flag);
 
EXECUTE USP_CON_RPT_GUIA_FACT;
 
IF SQLCA.sqlcode = -1 THEN
  ls_mensaje = "PROCEDURE USP_CON_RPT_GUIA_FACT: " + SQLCA.SQLErrText
  Rollback ;
  MessageBox('SQL error', ls_mensaje, StopSign!) 
  SetPointer (Arrow!)
  RETURN 0
END IF
 
CLOSE USP_CON_RPT_GUIA_FACT;
 
SetPointer (Arrow!)

RETURN 1
end function

on w_cn815_rpt_guia_fact.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.uo_1=create uo_1
this.pb_1=create pb_1
this.st_nro_reg=create st_nro_reg
this.st_3=create st_3
this.sle_origen=create sle_origen
this.cbx_1=create cbx_1
this.st_desc_origen=create st_desc_origen
this.st_1=create st_1
this.st_desc_almacen=create st_desc_almacen
this.sle_almacen=create sle_almacen
this.st_2=create st_2
this.st_desc_tipo_mov=create st_desc_tipo_mov
this.sle_tipo_mov=create sle_tipo_mov
this.st_5=create st_5
this.sle_con_desde=create sle_con_desde
this.st_4=create st_4
this.sle_con_hasta=create sle_con_hasta
this.cbx_2=create cbx_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.st_nro_reg
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.sle_origen
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.st_desc_origen
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.st_desc_almacen
this.Control[iCurrent+10]=this.sle_almacen
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.st_desc_tipo_mov
this.Control[iCurrent+13]=this.sle_tipo_mov
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.sle_con_desde
this.Control[iCurrent+16]=this.st_4
this.Control[iCurrent+17]=this.sle_con_hasta
this.Control[iCurrent+18]=this.cbx_2
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.gb_3
end on

on w_cn815_rpt_guia_fact.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.pb_1)
destroy(this.st_nro_reg)
destroy(this.st_3)
destroy(this.sle_origen)
destroy(this.cbx_1)
destroy(this.st_desc_origen)
destroy(this.st_1)
destroy(this.st_desc_almacen)
destroy(this.sle_almacen)
destroy(this.st_2)
destroy(this.st_desc_tipo_mov)
destroy(this.sle_tipo_mov)
destroy(this.st_5)
destroy(this.sle_con_desde)
destroy(this.st_4)
destroy(this.sle_con_hasta)
destroy(this.cbx_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event resize;call super::resize;// prueba

end event

event ue_retrieve;call super::ue_retrieve;Date		ld_fecini, ld_fecfin
string	ls_origen, ls_almacen, ls_tipo_mov

ld_fecini = uo_1.of_get_fecha1()
ld_fecfin = uo_1.of_get_fecha2()  

// Llamar al procedimiento para llenar el dw
of_llamar_procedimiento( )

// Recuperar y mostrar datos
IF cbx_1.checked THEN
	ls_origen = '%%'
ELSE
	ls_origen = trim(sle_origen.text) + '%'
END IF

ls_almacen  = sle_almacen.text
ls_tipo_mov = sle_tipo_mov.text

idw_1.Retrieve(ls_origen, ls_almacen, ls_tipo_mov, ld_fecini, ld_fecfin )
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_texto.text = 'Del : ' + string(ld_fecini,'dd/mm/yyyy') + ' al: ' + string(ld_fecfin,'dd/mm/yyyy')
idw_1.Visible = True
idw_1.SetRedraw(true)


// Agrega la cantidad de registros

st_nro_reg.text = String( dw_report.Rowcount())




end event

type dw_report from w_report_smpl`dw_report within w_cn815_rpt_guia_fact
integer x = 9
integer y = 484
integer width = 3479
integer height = 1360
integer taborder = 50
string dataobject = "dw_rpt_guia_fact_tbl"
end type

type uo_1 from u_ingreso_rango_fechas within w_cn815_rpt_guia_fact
integer x = 1623
integer y = 92
integer taborder = 40
boolean bringtotop = true
long backcolor = 12632256
end type

event constructor;call super::constructor;String ls_desde
 
of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
of_set_rango_fin(date('31/12/9999'))					// rango final
end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type pb_1 from picturebutton within w_cn815_rpt_guia_fact
integer x = 3141
integer y = 68
integer width = 343
integer height = 144
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\procesar_enb.bmp"
alignment htextalign = left!
end type

event clicked;Parent.event ue_retrieve()
end event

type st_nro_reg from statictext within w_cn815_rpt_guia_fact
integer x = 3301
integer y = 352
integer width = 169
integer height = 92
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn815_rpt_guia_fact
integer x = 3131
integer y = 360
integer width = 155
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Nro:"
boolean focusrectangle = false
end type

type sle_origen from singlelineedit within w_cn815_rpt_guia_fact
event dobleclick pbm_lbuttondblclk
integer x = 78
integer y = 140
integer width = 169
integer height = 88
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
	  	 + "nombre AS DESCRIPCION " &
	    + "FROM origen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
IF ls_codigo <> '' THEN
	This.text 			= ls_codigo
	st_desc_origen.text 	= ls_data
END IF

end event

event modified;String 	ls_desc, ls_origen

ls_origen = sle_origen.text

SELECT nombre 
	INTO :ls_desc
FROM origen
where cod_origen = :ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	return
end if

st_desc_origen.text = ls_desc

end event

type cbx_1 from checkbox within w_cn815_rpt_guia_fact
integer x = 87
integer y = 72
integer width = 603
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Todos los Origenes"
boolean checked = true
end type

event clicked;IF THIS.checked THEN
	sle_origen.enabled = FALSE
ELSE
	sle_origen.enabled = TRUE
END IF
end event

type st_desc_origen from statictext within w_cn815_rpt_guia_fact
integer x = 256
integer y = 140
integer width = 1289
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn815_rpt_guia_fact
integer x = 50
integer y = 280
integer width = 306
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Almacen:"
boolean focusrectangle = false
end type

type st_desc_almacen from statictext within w_cn815_rpt_guia_fact
integer x = 622
integer y = 268
integer width = 942
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_almacen from singlelineedit within w_cn815_rpt_guia_fact
event dobleclick pbm_lbuttondblclk
integer x = 357
integer y = 268
integer width = 256
integer height = 88
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_origen



IF cbx_1.checked THEN
	ls_sql = "SELECT ALMACEN AS CODIGO_ALM, " &
			 + "DESC_ALMACEN AS DESCRIPCION, " &
			 + "COD_ORIGEN AS ORIGEN " &
			 + "FROM ALMACEN "  &
			 + "WHERE FLAG_ESTADO = '1'"
ELSE
	ls_origen = sle_origen.text
	ls_sql = "SELECT ALMACEN AS CODIGO_ALM, " &
			 + "DESC_ALMACEN AS DESCRIPCION, " &
			 + "COD_ORIGEN AS ORIGEN " &			 
			 + "FROM ALMACEN "  &
			 + "WHERE FLAG_ESTADO = '1' " &
			 + "AND COD_ORIGEN = '" + ls_origen + "'"
END IF
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
IF ls_codigo <> '' THEN
	This.text 				= ls_codigo
	st_desc_almacen.text = ls_data
END IF


end event

event modified;String 	ls_desc, ls_origen, ls_almacen

ls_origen  = sle_origen.text
ls_almacen = sle_almacen.text

IF cbx_1.checked THEN
	SELECT DESC_ALMACEN
	  INTO :ls_desc
	FROM  ALMACEN
	WHERE FLAG_ESTADO = '1'
	  AND ALMACEN = :ls_almacen;
	
	IF SQLCA.SQLCode = 100 THEN
		Messagebox('Aviso', 'Codigo de Almacen no existe')
		RETURN
	END IF
ELSE
	SELECT DESC_ALMACEN
	  INTO :ls_desc
	FROM  ALMACEN
	WHERE FLAG_ESTADO = '1'
	 AND  COD_ORIGEN = :ls_origen
    AND  ALMACEN    = :ls_almacen;
	
	IF SQLCA.SQLCode = 100 THEN
		Messagebox('Aviso', 'Codigo de Almacen no existe')
		RETURN
	END IF
END IF

st_desc_almacen.text = ls_desc


end event

type st_2 from statictext within w_cn815_rpt_guia_fact
integer x = 41
integer y = 380
integer width = 334
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Operación:"
boolean focusrectangle = false
end type

type st_desc_tipo_mov from statictext within w_cn815_rpt_guia_fact
integer x = 622
integer y = 368
integer width = 942
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_tipo_mov from singlelineedit within w_cn815_rpt_guia_fact
event dobleclick pbm_lbuttondblclk
integer x = 357
integer y = 368
integer width = 256
integer height = 88
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql


ls_sql = "SELECT TIPO_MOV AS CODIGO_MOV, " &
			 + "DESC_TIPO_MOV AS DESCRIPCION " &
			 + "FROM ARTICULO_MOV_TIPO "  &
			 + "WHERE FLAG_ESTADO = '1' " &
			 + "AND FACTOR_SLDO_TOTAL = '-1'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
IF ls_codigo <> '' THEN
	This.text 				 = ls_codigo
	st_desc_tipo_mov.text = ls_data
END IF


end event

event modified;String 	ls_desc, ls_tipo_mov

ls_tipo_mov = sle_tipo_mov.text

SELECT desc_tipo_mov
	INTO :ls_desc
FROM articulo_mov_tipo
WHERE tipo_mov = :ls_tipo_mov
 AND FACTOR_SLDO_TOTAL = '-1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Operación no existe')
	RETURN
END IF

st_desc_tipo_mov.text = ls_desc



end event

type st_5 from statictext within w_cn815_rpt_guia_fact
integer x = 1669
integer y = 356
integer width = 219
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Desde:"
boolean focusrectangle = false
end type

type sle_con_desde from singlelineedit within w_cn815_rpt_guia_fact
event dobleclick pbm_lbuttondblclk
integer x = 1879
integer y = 344
integer width = 279
integer height = 88
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_origen


ls_sql = "SELECT CONFIN AS CODIGO_CONFIN, " &
			 + "DESCRIPCION AS DESCRIPCION " &
			 + "FROM CONCEPTO_FINANCIERO "  &
			 + "WHERE FLAG_ESTADO = '1' " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
IF ls_codigo <> '' THEN
	This.text 				 = ls_codigo
//	st_desc_tipo_mov.text = ls_data
END IF


end event

event modified;String 	ls_confin
long		ll_count

ls_confin = sle_con_desde.text

SELECT count(*)
  INTO :ll_count
FROM  CONCEPTO_FINANCIERO
WHERE flag_estado = '1'
 AND  confin = :ls_confin;

IF ll_count = 0 THEN 
 	Messagebox('Aviso', 'CONFIN no existe')
	RETURN
END IF



end event

type st_4 from statictext within w_cn815_rpt_guia_fact
integer x = 2240
integer y = 360
integer width = 229
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Hasta:"
boolean focusrectangle = false
end type

type sle_con_hasta from singlelineedit within w_cn815_rpt_guia_fact
event dobleclick pbm_lbuttondblclk
integer x = 2437
integer y = 344
integer width = 279
integer height = 88
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_origen


ls_sql = "SELECT CONFIN AS CODIGO_CONFIN, " &
			 + "DESCRIPCION AS DESCRIPCION " &
			 + "FROM CONCEPTO_FINANCIERO "  &
			 + "WHERE FLAG_ESTADO = '1' " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
IF ls_codigo <> '' THEN
	This.text 				 = ls_codigo
//	st_desc_tipo_mov.text = ls_data
END IF


end event

event modified;String 	ls_confin
long		ll_count

ls_confin = sle_con_hasta.text

SELECT count(*)
  INTO :ll_count
FROM  CONCEPTO_FINANCIERO
WHERE flag_estado = '1'
 AND  confin = :ls_confin;

IF ll_count = 0 THEN 
 	Messagebox('Aviso', 'CONFIN no existe')
	RETURN
END IF



end event

type cbx_2 from checkbox within w_cn815_rpt_guia_fact
integer x = 1641
integer y = 276
integer width = 270
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Todos"
boolean checked = true
end type

event clicked;IF THIS.checked THEN
	sle_con_desde.enabled = FALSE
	sle_con_hasta.enabled = FALSE
ELSE
	sle_con_desde.enabled = TRUE
	sle_con_hasta.enabled = TRUE
END IF
end event

type gb_1 from groupbox within w_cn815_rpt_guia_fact
integer x = 1600
integer y = 32
integer width = 1335
integer height = 168
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Rango de Fechas"
end type

type gb_2 from groupbox within w_cn815_rpt_guia_fact
integer x = 1609
integer y = 220
integer width = 1138
integer height = 240
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Confin:"
end type

type gb_3 from groupbox within w_cn815_rpt_guia_fact
integer x = 50
integer y = 12
integer width = 1518
integer height = 240
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Origen:"
end type

