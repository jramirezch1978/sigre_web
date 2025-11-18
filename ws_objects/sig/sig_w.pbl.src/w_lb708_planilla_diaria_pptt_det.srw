$PBExportHeader$w_lb708_planilla_diaria_pptt_det.srw
forward
global type w_lb708_planilla_diaria_pptt_det from w_report_smpl
end type
type cb_1 from commandbutton within w_lb708_planilla_diaria_pptt_det
end type
type uo_1 from u_ingreso_fecha within w_lb708_planilla_diaria_pptt_det
end type
end forward

global type w_lb708_planilla_diaria_pptt_det from w_report_smpl
integer width = 2446
integer height = 1232
string title = "Planilla diaria - Campos [LB708]"
string menuname = "m_rpt_simple"
long backcolor = 12632256
cb_1 cb_1
uo_1 uo_1
end type
global w_lb708_planilla_diaria_pptt_det w_lb708_planilla_diaria_pptt_det

on w_lb708_planilla_diaria_pptt_det.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_1=create cb_1
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_1
end on

on w_lb708_planilla_diaria_pptt_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_1)
end on

event ue_retrieve;call super::ue_retrieve;Date ld_fecha
Datetime ldt_fec_ini, ldt_fec_fin, ldt_sem_ini, ldt_mes_ini, ldt_ano_ini
String ls_msg
Integer li_sem, li_mes, li_ano

//ld_fecha = Date( em_fecha.text)
ld_fecha = uo_1.of_get_fecha()

// Verifica proceso diario
//if f_ver_proceso_diario(ld_Fecha, '1520') = 0 then return

SETPOINTER( HOURGLASS!)
select t.del_dia, t.al_dia into :ldt_fec_ini, :ldt_fec_fin 
  from calendario_produccion t
  where t.fecha_prod = :ld_fecha ;
  
// Busca semana, mes y año al que pertenece
  Select c.semana, c.mes, c.ano into :li_sem, :li_mes, :li_ano
    from calendario_produccion c
   where c.fecha_prod = :ld_fecha ;

// Busca rango fechas de inicio y fin para la semana
  Select MIN(c.del_dia) into :ldt_sem_ini 
    from calendario_produccion c Where c.semana = :li_sem;

// Busca rango fechas de inicio y fin para el mes
  Select MIN(c.del_dia) into :ldt_mes_ini
    from calendario_produccion c Where c.mes = :li_mes;  

// Busca rango fechas de inicio y fin para el ano
  Select MIN(c.del_dia) into :ldt_ano_ini
     from calendario_produccion c Where c.ano = :li_ano;

DECLARE usp_proc PROCEDURE FOR USP_LAB_PLANILLA_PPTT_DET(:ldt_fec_ini, :ldt_fec_fin);
EXECUTE usp_proc;
if sqlca.sqlcode = -1 then
	ls_msg = sqlca.sqlerrtext
	RollBack;
	messagebox( "Error USP_LAB_PLANILLA_PPTT_DET", ls_msg, Exclamation!)
	close usp_proc;
	return
end if
close usp_proc;

idw_1.retrieve(ld_fecha)
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_dia.text = 'Día: ' + string( ldt_fec_ini,'dd/mm/yyyy hh:mm') + ' Al: ' + string( ldt_fec_fin,'dd/mm/yyyy hh:mm')
idw_1.object.t_semana.text = 'Semana: ' + string( ldt_sem_ini,'dd/mm/yyyy hh:mm') + ' Al: ' + string( ldt_fec_fin,'dd/mm/yyyy hh:mm')
idw_1.object.t_mes.text = 'Mes: ' + string( ldt_sem_ini,'dd/mm/yyyy hh:mm') + ' Al: ' + string( ldt_fec_fin,'dd/mm/yyyy hh:mm')
//idw_1.object.t_ano.text = 'Año: ' + string( ldt_ano_ini,'dd/mm/yyyy hh:mm') + ' Al: ' + string( ldt_fec_fin,'dd/mm/yyyy hh:mm')
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_objeto.text = 'LB708'
idw_1.object.t_user.text   = gs_user
end event

event ue_mail_send();//
String		ls_ini_file, ls_file, ls_name, ls_address, ls_subject, ls_note, ls_path
n_cst_email	lnv_mail
n_cst_api	lnv_api

lnv_mail = CREATE n_cst_email
lnv_api  = CREATE n_cst_api

ls_subject = THIS.Title
ls_path = 'c:\report.html'
ls_file = 'report.html'

lnv_mail.of_create_html(idw_1, ls_path)
idw_1.SaveAs(ls_path, HTMLTable!, True)

lnv_mail.of_logon()
lnv_mail.of_send_mail(ls_name, ls_address, ls_subject, ls_note, ls_file, ls_path)
lnv_mail.of_logoff()
lnv_api.of_file_delete(ls_path)

DESTROY lnv_mail
DESTROY lnv_api
end event

type dw_report from w_report_smpl`dw_report within w_lb708_planilla_diaria_pptt_det
integer x = 0
integer y = 188
integer width = 1413
integer height = 724
string dataobject = "d_rpt_produccion_pptt_tbl"
end type

type cb_1 from commandbutton within w_lb708_planilla_diaria_pptt_det
integer x = 1902
integer y = 16
integer width = 480
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
boolean default = true
end type

event clicked;parent.event ue_retrieve()

end event

type uo_1 from u_ingreso_fecha within w_lb708_planilla_diaria_pptt_det
integer x = 41
integer y = 32
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:') 
of_set_fecha(today()) 
of_set_rango_inicio(date('01/01/1900')) 
of_set_rango_fin(date('31/12/9999')) 
// of_get_fecha1()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

