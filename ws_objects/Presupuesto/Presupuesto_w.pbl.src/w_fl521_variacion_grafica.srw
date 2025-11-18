$PBExportHeader$w_fl521_variacion_grafica.srw
forward
global type w_fl521_variacion_grafica from w_rpt_general
end type
end forward

global type w_fl521_variacion_grafica from w_rpt_general
integer width = 1792
integer height = 1656
string title = "Variaciones del Presupuesto (FL521)"
end type
global w_fl521_variacion_grafica w_fl521_variacion_grafica

on w_fl521_variacion_grafica.create
call super::create
end on

on w_fl521_variacion_grafica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
idw_1.Retrieve()
end event

event ue_copiar;call super::ue_copiar;dw_report.ClipBoard("gr_1")
end event

type dw_report from w_rpt_general`dw_report within w_fl521_variacion_grafica
integer y = 0
integer width = 1691
integer height = 1148
string dataobject = "d_presup_compara_grf"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_report::doubleclicked;call super::doubleclicked;grObjectType lgr_click_obj

string   ls_graphname="gr_1", &
			ls_nave, ls_mes, ls_parametro, ls_cod_nave
integer 	li_series, li_category, li_count
 

lgr_click_obj = this.ObjectAtPointer (ls_graphname, li_series, li_category)

ls_nave = this.seriesname(ls_graphname,li_series)
ls_mes  = this.Categoryname( ls_graphname , li_category )

if len(trim(ls_mes)) = 1 then ls_mes = '0' + ls_mes

select count(distinct nave)
	into :li_count
from tt_fl_presup_compara;

select nave 
	into :ls_cod_nave 
from tg_naves 
where nomb_nave like :ls_nave;

ls_parametro = ls_mes + ls_cod_nave

if len(trim(ls_nave)) > 0 then
	if li_count > 1 then
		OpenSheetWithParm( w_fl907_grafica_ppto_var, ls_nave, w_main, 0, Layered! )
	else
		OpenSheetWithParm( w_fl908_grafica_ppto_compos, ls_parametro, w_main, 0, Layered! )
	end if
end if
end event

