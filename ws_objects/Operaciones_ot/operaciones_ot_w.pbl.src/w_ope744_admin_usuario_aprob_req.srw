$PBExportHeader$w_ope744_admin_usuario_aprob_req.srw
forward
global type w_ope744_admin_usuario_aprob_req from w_report_smpl
end type
end forward

global type w_ope744_admin_usuario_aprob_req from w_report_smpl
end type
global w_ope744_admin_usuario_aprob_req w_ope744_admin_usuario_aprob_req

on w_ope744_admin_usuario_aprob_req.create
call super::create
end on

on w_ope744_admin_usuario_aprob_req.destroy
call super::destroy
end on

type dw_report from w_report_smpl`dw_report within w_ope744_admin_usuario_aprob_req
string title = "w_ope744_admin_usuario_aprob_req"
string dataobject = "d_rpt_ot_admin_usuario_aprob_req_tbl"
end type

