$PBExportHeader$w_sig712_cntas_cobrar_acum_detalle.srw
forward
global type w_sig712_cntas_cobrar_acum_detalle from w_report_smpl
end type
end forward

global type w_sig712_cntas_cobrar_acum_detalle from w_report_smpl
integer width = 2295
integer height = 1584
string title = "SIG712 - Resumen de cntas x cobrar de pptt x cliente y despacho"
string menuname = "m_rpt_simple"
long backcolor = 134217752
end type
global w_sig712_cntas_cobrar_acum_detalle w_sig712_cntas_cobrar_acum_detalle

type variables
String	is_oper, is_clase
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

on w_sig712_cntas_cobrar_acum_detalle.create
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
end on

on w_sig712_cntas_cobrar_acum_detalle.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;String ls_relacion , ls_tipo, ls_cod_art, ls_mov_tipo
Long ll_factor
Date ld_fec_ini, ld_fec_fin


sg_parametros lstr_rep

lstr_rep = message.powerobjectparm

ls_relacion = lstr_rep.string1
ls_cod_art = lstr_rep.string2
ld_fec_ini = lstr_rep.date1
ld_fec_fin = lstr_rep.date2

idw_1.ii_zoom_actual = 120
ib_preview = false
event ue_preview()

IF lstr_rep.tipo = 'NCC' then

	dw_report.dataobject = 'd_rpt_sig_cntas_cobrar_acum_det_ncc'
	dw_report.SetTransObject(sqlca)
	dw_report.Visible = True
	dw_report.Object.t_empresa.text = gs_empresa
	dw_report.Object.t_user.text = gs_user
	dw_report.Object.p_logo.filename = gs_logo
	dw_report.Object.t_windows.text = this.classname()
	dw_report.Retrieve( ld_fec_ini, ld_fec_fin, ls_relacion, ls_cod_art)
	dw_report.Object.t_texto.text = 'Desde: '+ string(lstr_rep.date1)+ ' Al: '+ string(lstr_rep.date2)


else

	dw_report.dataobject = 'd_rpt_sig_cntas_cobrar_acum_det'
	dw_report.SetTransObject(sqlca)
	dw_report.Visible = True
	dw_report.Object.t_empresa.text = gs_empresa
	dw_report.Object.t_user.text = gs_user
	dw_report.Object.p_logo.filename = gs_logo
	dw_report.Object.t_windows.text = this.classname()
	dw_report.Retrieve( ld_fec_ini, ld_fec_fin, ls_relacion, ls_cod_art, lstr_rep.string3,lstr_rep.string4 )
	dw_report.Object.t_texto.text = 'Desde: '+ string(lstr_rep.date1)+ ' Al: '+ string(lstr_rep.date2)

end if 

end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()
idw_1.object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_sig712_cntas_cobrar_acum_detalle
integer x = 0
integer y = 0
integer width = 2254
integer height = 1356
string dataobject = "d_rpt_sig_cntas_cobrar_acum_det"
boolean hsplitscroll = true
end type

event dw_report::doubleclicked;call super::doubleclicked;//LONG ll_col, ll_static, li_pos
//STRING ls_col, ls_objects, ls_value, ls_col1, &
//		 ls_numero, ls_oper_vnta_terc, ls_data, &
// 		 ls_origen, ls_cod_art, ls_tipo, ls_oper_ing_prod, &
//		 ls_doc_otr, ls_doc_ov
//Date ld_fec_ini, ld_fec_fin
//
//ld_fec_ini = uo_1.of_get_fecha1()
//ld_fec_fin = uo_1.of_get_fecha2()
//
//
//sg_parametros lstr_rep
//
//if row=0 then  return
//
//IF this.Rowcount() = 0 then return
//
////HALLANDO EL VALOR DE ORIGEN
//ll_col = this.GetClickedColumn()
//
//dw_report.modify('datawindow.crosstab.staticmode=yes')
//
//ls_objects=dw_report.object.datawindow.objects
//ls_col = dw_report.Describe("#" + String(ll_col) + ".name")
//li_pos = pos(ls_col,'_x')
//If len(ls_col) > li_pos + 1 then
//	ls_numero = mid(ls_col,li_pos+2)
//else
//	ls_numero = ''
//end if
//ls_col1 = "t_origen"+ls_numero
//ls_origen = dw_report.DESCRIBE(ls_col1+".text")
///////////
//
//ls_cod_art = this.object.tt_sig_producc_pptt_cod_art [row]
//
//lstr_rep.string1 = ls_origen
//lstr_rep.string2 = ls_cod_art
//lstr_rep.date1 = ld_fec_ini
//lstr_rep.date2 = ld_fec_fin
//
//select l.oper_ing_prod , l.oper_vnta_terc, l.doc_otr, l.doc_ov
//  into :ls_oper_ing_prod, :ls_oper_vnta_terc, :ls_doc_otr, :ls_doc_ov
//from logparam l where l.reckey='1' ;
//
//MessageBox("",String(dwo.name))
//if Mid(Lower(dwo.name),1,4) = 'prod' then
//	lstr_rep.string3 = ls_oper_ing_prod
//	ls_tipo = 'PROD'
//
//elseif Mid(Lower(dwo.name),1,4) = 'vent' then
//	ls_tipo = 'VENT'
//
//elseif Mid(Lower(dwo.name),1,4) = 'desp' then
//	lstr_rep.string3 = ls_oper_vnta_terc	
//	ls_tipo = 'DESP'
//
//elseif Mid(Lower(dwo.name),1,4) = 'tras' then	
//	lstr_rep.string3= ls_doc_otr	
//	ls_tipo = 'TRAS'
//
//elseif Mid(Lower(dwo.name),1,7) = 'stock_t' then	
//	ls_tipo = 'STKT'
//
//elseif Mid(Lower(dwo.name),1,7) = 'stock_f' then		
//	ls_tipo = 'STKF'
//
//elseif Mid(Lower(dwo.name),1,4) = 'pend' then
//	lstr_rep.string3 = ls_doc_ov
//	ls_tipo = 'PEND'
//
//end if 
//
//lstr_rep.tipo = ls_tipo
//
//OpenSheetWithParm(w_sig711_stock_pptt_x_origen_detalle, lstr_rep, w_main, 2, layered!)

end event

