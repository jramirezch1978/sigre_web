$PBExportHeader$w_sig751_abc_compras_clase.srw
forward
global type w_sig751_abc_compras_clase from w_report_smpl
end type
type cb_lectura from commandbutton within w_sig751_abc_compras_clase
end type
type em_ano from editmask within w_sig751_abc_compras_clase
end type
type st_1 from statictext within w_sig751_abc_compras_clase
end type
type gb_1 from groupbox within w_sig751_abc_compras_clase
end type
end forward

global type w_sig751_abc_compras_clase from w_report_smpl
integer width = 3072
integer height = 2004
string title = "Indicadores de gestión de Logística (SIG751)"
string menuname = "m_rpt_simple"
long backcolor = 15793151
cb_lectura cb_lectura
em_ano em_ano
st_1 st_1
gb_1 gb_1
end type
global w_sig751_abc_compras_clase w_sig751_abc_compras_clase

type variables
Decimal id_tipo_cambio
Date id_fecha_hoy
end variables

forward prototypes
public function integer of_get_parametros (ref string as_clase, ref string as_oper_ing_prod)
end prototypes

public function integer of_get_parametros (ref string as_clase, ref string as_oper_ing_prod);Long		ll_rc = 0
String	ls_clase


SELECT CLASE_PROD_TERM
  INTO :as_clase
  FROM SIGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer SIGPARAM')
	lL_rc = -1
END IF

SELECT OPER_ING_PROD
  INTO :as_oper_ing_prod
  FROM LOGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -2
END IF

RETURN ll_rc

end function

on w_sig751_abc_compras_clase.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_lectura=create cb_lectura
this.em_ano=create em_ano
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lectura
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_sig751_abc_compras_clase.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_lectura)
destroy(this.em_ano)
destroy(this.st_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;//cb_param.enabled = false

//Ponerlo en parametros
em_ano.text = STRING(today(),'yyyy')
end event

type dw_report from w_report_smpl`dw_report within w_sig751_abc_compras_clase
integer x = 50
integer y = 248
integer width = 2907
integer height = 1108
string dataobject = "d_rpt_abc_compra_clase_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;//String ls_grupo, ls_oper_ing_oc, ls_oper_cons_int, ls_dev_prestamo
//Date ld_fec_ini, ld_fec_fin
//LONG ll_dias
//Decimal ld_monto
//
//sg_paramet lstr_rep
//
//if row=0 then return
//
//ll_dias   = LONG(em_dias.text)
//ls_grupo  = this.object.sig_fce[row]
//
//IF this.Rowcount( ) = 0 then return
//
//ls_grupo = this.object.sig_fce[row]
//
//lstr_rep.long1 = ll_dias
//lstr_rep.date1 = id_fecha_hoy
//
//IF ls_grupo = 'STK_VALD' THEN
//	lstr_rep.long1 = ll_dias
//	lstr_rep.date1 = id_fecha_hoy
//	OpenSheet(w_sig751_fce_stock_valorizado, w_main, 2, layered!)
//ELSEIF ls_grupo = 'VAL_OBSO' THEN
//	lstr_rep.long1 = ll_dias
//	lstr_rep.date1 = id_fecha_hoy
//	OpenSheetWithParm(w_sig751_fce_obsoleto_valor, lstr_rep, w_main, 2, layered!)	
//ELSEIF ls_grupo = 'VNI_VSAL' THEN
//
//	select l.oper_ing_oc, l.oper_cons_interno, dev_prestamo 
//     into :ls_oper_ing_oc, :ls_oper_cons_int, :ls_dev_prestamo
//       from logparam l 
//      where l.reckey='1' ;
//	
//	ld_fec_ini = uo_1.of_get_fecha1()
//	ld_fec_fin = uo_1.of_get_fecha2()
//	
//	lstr_rep.string1 = ls_oper_ing_oc
//	lstr_rep.string2 = ls_oper_cons_int
//	lstr_rep.string3 = ls_dev_prestamo	
//	lstr_rep.date1   = ld_fec_ini
//	lstr_rep.date2   = ld_fec_fin
//		
//	OpenSheetWithParm(w_sig751_fce_ni_vs_dev, lstr_rep, w_main, 2, layered!)	
//ELSEIF ls_grupo = 'CMP_ORDE' THEN
//	ld_monto  = this.object.nivel_actual[row]
//	ld_fec_ini = uo_1.of_get_fecha1()
//	ld_fec_fin = uo_1.of_get_fecha2()
//	
//	lstr_rep.date1   = ld_fec_ini
//	lstr_rep.date2   = ld_fec_fin
//	lstr_rep.decimal1   = ld_monto
//			
//	OpenSheetWithParm(w_sig751_fce_oc_fpago_res, lstr_rep, w_main, 2, layered!)	
//	
//END IF
//
end event

type cb_lectura from commandbutton within w_sig751_abc_compras_clase
integer x = 645
integer y = 88
integer width = 343
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;String ls_texto, ls_msj_err
Long ll_ano

cb_lectura.enabled = false

ll_ano = LONG(em_ano.text)

SetPointer(hourglass!)

DECLARE PB_USP_SIG_COSTO_COMPRA_CLASE PROCEDURE FOR USP_SIG_COSTO_COMPRA_CLASE
( :ll_ano );

EXECUTE PB_USP_SIG_COSTO_COMPRA_CLASE ;

cb_lectura.enabled = true

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error',ls_msj_err)
	Return
END IF

CLOSE PB_USP_SIG_COSTO_COMPRA_CLASE ;

//idw_1.DataObject='d_rpt_parte_diario_gen_tbl'
//idw_1.SetTransObject(sqlca)

idw_1.retrieve()

SetPointer(Arrow!)

//idw_1.Object.p_logo.filename = gs_logo
//idw_1.Object.t_texto.text = 'Indicadores de gestión'
//idw_1.Object.t_empresa.text = gs_empresa
//idw_1.Object.t_user.text = gs_user
SetPointer(Arrow!)

//cb_param.enabled = true

idw_1.visible=false
ib_preview = false
idw_1.ii_zoom_actual = 100
idw_1.visible=true


//ib_preview = false
//idw_1.visible=true
//idw_1.ii_zoom_actual = 100

parent.event ue_preview()
end event

type em_ano from editmask within w_sig751_abc_compras_clase
integer x = 247
integer y = 88
integer width = 201
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type st_1 from statictext within w_sig751_abc_compras_clase
integer x = 96
integer y = 96
integer width = 142
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33554431
string text = "Año:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_sig751_abc_compras_clase
integer x = 55
integer y = 24
integer width = 466
integer height = 188
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 33554431
string text = "Parámetros"
end type

