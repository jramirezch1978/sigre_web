$PBExportHeader$w_cn712_cntbl_rpt_balance_comprob_det.srw
forward
global type w_cn712_cntbl_rpt_balance_comprob_det from w_report_smpl
end type
end forward

global type w_cn712_cntbl_rpt_balance_comprob_det from w_report_smpl
integer width = 3369
integer height = 1604
string title = "Detalle -  Balance de Comprobación (CN712)"
string menuname = "m_impresion"
end type
global w_cn712_cntbl_rpt_balance_comprob_det w_cn712_cntbl_rpt_balance_comprob_det

on w_cn712_cntbl_rpt_balance_comprob_det.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
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

str_parametros lstr_rep

lstr_rep = message.powerobjectparm

ls_cnta_ctbl = lstr_rep.string1

ll_ano = lstr_rep.long1
ll_mes_ini = lstr_rep.long2 
ll_mes_fin = lstr_rep.long3
ll_nro_dig = lstr_rep.long4

if lstr_rep.titulo = '1' then
	idw_1.dataobject = 'd_rpt_balance_comp_detalle_tbl'
else
	idw_1.dataobject = 'd_rpt_saldo_x_cnta_tbl'
end if
idw_1.setTransObject( SQLCA )

idw_1.ii_zoom_actual = 110
ib_preview = false
event ue_preview()

if lstr_rep.titulo = '1' then
	idw_1.Retrieve( ll_ano, ll_mes_ini, ll_mes_fin, ls_cnta_ctbl, ll_nro_dig)
else
	idw_1.Retrieve( ls_cnta_ctbl, ll_ano, ll_mes_ini, ll_mes_fin)
end if

idw_1.object.p_logo.filename 	= gnvo_app.is_logo
idw_1.Object.t_empresa.text 	= gnvo_app.invo_empresa.is_empresa
idw_1.Object.t_user.text 		= gnvo_app.is_user

idw_1.Object.t_titulo.text = 'Cuenta analizada ' + ls_cnta_ctbl

idw_1.Object.t_texto.text = 'Año ' + string(ll_ano) + ', del mes ' &
				 + string(ll_mes_ini) + ' al mes ' + string(ll_mes_fin)

idw_1.Visible = True
				 

end event

type ole_skin from w_report_smpl`ole_skin within w_cn712_cntbl_rpt_balance_comprob_det
end type

type uo_h from w_report_smpl`uo_h within w_cn712_cntbl_rpt_balance_comprob_det
end type

type st_box from w_report_smpl`st_box within w_cn712_cntbl_rpt_balance_comprob_det
end type

type uo_filter from w_report_smpl`uo_filter within w_cn712_cntbl_rpt_balance_comprob_det
end type

type st_filtro from w_report_smpl`st_filtro within w_cn712_cntbl_rpt_balance_comprob_det
end type

type dw_report from w_report_smpl`dw_report within w_cn712_cntbl_rpt_balance_comprob_det
integer x = 517
integer y = 260
integer width = 3291
integer height = 1348
integer taborder = 70
string dataobject = "d_rpt_balance_comp_detalle_tbl"
end type

