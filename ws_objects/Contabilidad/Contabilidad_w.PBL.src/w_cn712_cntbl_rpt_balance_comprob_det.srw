$PBExportHeader$w_cn712_cntbl_rpt_balance_comprob_det.srw
forward
global type w_cn712_cntbl_rpt_balance_comprob_det from w_report_smpl
end type
end forward

global type w_cn712_cntbl_rpt_balance_comprob_det from w_report_smpl
integer width = 3369
integer height = 1604
string title = "[CN712] Detalle -  Balance de Comprobación"
string menuname = "m_abc_report_smpl"
end type
global w_cn712_cntbl_rpt_balance_comprob_det w_cn712_cntbl_rpt_balance_comprob_det

type variables

end variables

on w_cn712_cntbl_rpt_balance_comprob_det.create
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
end on

on w_cn712_cntbl_rpt_balance_comprob_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;This.Event ue_retrieve()
ib_preview = false
// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;Long ll_ano, ll_mes, ll_mes_ini, ll_mes_fin, ll_nro_dig
String ls_cnta_ctbl


istr_rep = message.powerobjectparm

ls_cnta_ctbl = istr_rep.string1

ll_ano 		= istr_rep.long1
ll_mes_ini 	= istr_rep.long2 
ll_mes_fin 	= istr_rep.long3
ll_nro_dig 	= istr_rep.long4
this.title	= istr_rep.string2

if istr_rep.titulo = '1' then
	
	if istr_rep.moneda = gnvo_app.is_soles then
		idw_1.dataobject = 'd_rpt_balance_comp_detalle_tbl'	
	else
		idw_1.dataobject = 'd_rpt_balance_comp_detalle_tbl'	
	end if
	
elseif istr_rep.titulo = '2' then
	
	idw_1.dataobject = 'd_rpt_saldo_x_cnta_tbl'
	
elseif istr_rep.titulo = '3' then
	
	idw_1.dataobject = 'd_rpt_balance_res_libro_tv'
	
elseif istr_rep.titulo = '4' then
	
	if istr_rep.moneda = gnvo_app.is_soles then
		idw_1.dataobject = 'd_rpt_saldo_proveedor_sol_tbl'	
	else
		idw_1.dataobject = 'd_rpt_saldo_proveedor_dol_tbl'	
	end if
	
elseif istr_rep.titulo = '5' then
	
	if istr_rep.moneda = gnvo_app.is_soles then
		idw_1.dataobject = 'd_rpt_saldo_prov_doc_sol_tbl'	
	else
		idw_1.dataobject = 'd_rpt_saldo_prov_doc_dol_tbl'	
	end if

elseif istr_rep.titulo = '6' then
	
	if istr_rep.moneda = gnvo_app.is_soles then
		idw_1.dataobject = 'd_rpt_saldo_cnta_cntbl_proveedor_sol_tbl'	
	else
		idw_1.dataobject = 'd_rpt_saldo_cnta_cntbl_proveedor_dol_tbl'	
	end if

elseif istr_rep.titulo = '7' then
	
	if istr_rep.moneda = gnvo_app.is_soles then
		idw_1.dataobject = 'd_rpt_saldo_prov_doc_mon_sol_tbl'	
	else
		idw_1.dataobject = 'd_rpt_saldo_prov_doc_mon_dol_tbl'	
	end if	
	
end if

idw_1.setTransObject( SQLCA )

idw_1.ii_zoom_actual = 110
ib_preview = false
event ue_preview()

if istr_rep.titulo = '1' or istr_rep.titulo = '3' then
	
	idw_1.Retrieve( ll_ano, ll_mes_ini, ll_mes_fin, ls_cnta_ctbl, ll_nro_dig)
	
elseif istr_rep.titulo = '2' or istr_rep.titulo = '4' or istr_rep.titulo = '5' or istr_rep.titulo = '6' or istr_rep.titulo = '7' then
	
	idw_1.Retrieve( ls_cnta_ctbl+'%', ll_ano, ll_mes_ini, ll_mes_fin)
	
end if

idw_1.object.p_logo.filename 	= gs_logo
idw_1.Object.t_empresa.text 	= gnvo_app.empresa.is_nom_empresa

if idw_1.of_existecampo( "t_ruc") then
	idw_1.Object.t_ruc.text 		= gnvo_app.empresa.is_ruc
end if

idw_1.Object.t_user.text 		= gs_user

idw_1.Object.t_titulo.text = 'Cuenta analizada ' + ls_cnta_ctbl + ' Moneda ' + istr_rep.moneda

idw_1.Object.t_texto.text = 'Año ' + string(ll_ano) + ', del mes ' &
				 + string(ll_mes_ini) + ' al mes ' + string(ll_mes_fin)
				 
idw_1.Object.Datawindow.Print.DocumentName = this.title + ' [Cuenta analizada ' + ls_cnta_ctbl + ']'

idw_1.Visible = True
				 

end event

type dw_report from w_report_smpl`dw_report within w_cn712_cntbl_rpt_balance_comprob_det
integer x = 0
integer y = 0
integer width = 3291
integer height = 1348
integer taborder = 70
string dataobject = "d_rpt_balance_comp_detalle_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;if row = 0 then return

str_parametros lstr_param
w_rpt_preview	lw_1

if istr_rep.titulo = '1' or istr_rep.titulo = '3' then

	lstr_param.dw1 		= 'd_rpt_voucher_tbl'
	lstr_param.titulo 	= 'Previo de Voucher'
	lstr_param.string1 	= this.object.origen [row]
	lstr_param.integer1 	= Integer(this.object.ano [row])
	lstr_param.integer2 	= Integer(this.object.mes [row])
	lstr_param.integer3 	= Integer(this.object.nro_libro [row])
	lstr_param.integer4 	= Integer(this.object.nro_asiento [row])
	lstr_param.string2	= gs_empresa
	lstr_param.posicion_paper = 1   //Landscape
	lstr_param.tipo		= '1S1I2I3I4I2S'
	OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered!)
	
end if


end event

