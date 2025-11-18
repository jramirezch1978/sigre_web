$PBExportHeader$w_pr504_destajo_consistencia.srw
forward
global type w_pr504_destajo_consistencia from w_abc_master_smpl
end type
type st_1 from statictext within w_pr504_destajo_consistencia
end type
type sle_nro_parte from singlelineedit within w_pr504_destajo_consistencia
end type
end forward

global type w_pr504_destajo_consistencia from w_abc_master_smpl
integer width = 3803
integer height = 2080
string title = "Consistencia de Destajo(PR504) "
string menuname = "m_reporte"
windowstate windowstate = maximized!
st_1 st_1
sle_nro_parte sle_nro_parte
end type
global w_pr504_destajo_consistencia w_pr504_destajo_consistencia

on w_pr504_destajo_consistencia.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.sle_nro_parte=create sle_nro_parte
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_nro_parte
end on

on w_pr504_destajo_consistencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_nro_parte)
end on

event ue_retrieve_list;call super::ue_retrieve_list;string ls_sql,  ls_return1, ls_return2
ls_sql = "select parte as nro_parte, fec as fecha from vw_pr_parte_destajo"
f_lista (ls_sql, ls_return1, ls_return2, '2')
if trim(ls_return1) = '' or isnull(ls_return1) then return
sle_nro_parte.text = ls_return1
this.event ue_query_retrieve( )
end event

event ue_query_retrieve;//override
string ls_nro_parte, ls_fecha

ls_nro_parte = trim(sle_nro_parte.text)

if ls_nro_parte = '' then return

idw_1.Retrieve(ls_nro_parte)

if idw_1.rowcount( ) < 1 then return

select to_char(sysdate, 'dd/mm/yyyy hh24:mi') 
   into :ls_fecha
	from dual;
	
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_user.text = 'Impreso por: ' + trim(gs_user)
idw_1.object.t_date.text = 'Fecha de impresión: ' + trim(ls_fecha)
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr504_destajo_consistencia
integer y = 128
integer width = 3474
integer height = 1608
string dataobject = "d_destajo_consistencia_tbl"
end type

type st_1 from statictext within w_pr504_destajo_consistencia
integer x = 23
integer y = 24
integer width = 1015
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Búsqueda por Número de Parte Diario:"
boolean focusrectangle = false
end type

type sle_nro_parte from singlelineedit within w_pr504_destajo_consistencia
integer x = 1061
integer y = 4
integer width = 393
integer height = 100
integer taborder = 10
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

