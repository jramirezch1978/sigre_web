$PBExportHeader$w_ma716_estruct_maq.srw
forward
global type w_ma716_estruct_maq from w_report_smpl
end type
type cb_3 from commandbutton within w_ma716_estruct_maq
end type
type sle_cod_maq from singlelineedit within w_ma716_estruct_maq
end type
type rb_1 from radiobutton within w_ma716_estruct_maq
end type
type rb_2 from radiobutton within w_ma716_estruct_maq
end type
type cb_seleccionar from commandbutton within w_ma716_estruct_maq
end type
type gb_1 from groupbox within w_ma716_estruct_maq
end type
end forward

global type w_ma716_estruct_maq from w_report_smpl
integer width = 3323
integer height = 1636
string title = "Lista de Estructuras  (MA716)"
string menuname = "m_rpt_smpl"
long backcolor = 67108864
cb_3 cb_3
sle_cod_maq sle_cod_maq
rb_1 rb_1
rb_2 rb_2
cb_seleccionar cb_seleccionar
gb_1 gb_1
end type
global w_ma716_estruct_maq w_ma716_estruct_maq

on w_ma716_estruct_maq.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_3=create cb_3
this.sle_cod_maq=create sle_cod_maq
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cb_seleccionar=create cb_seleccionar
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.sle_cod_maq
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.cb_seleccionar
this.Control[iCurrent+6]=this.gb_1
end on

on w_ma716_estruct_maq.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.sle_cod_maq)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cb_seleccionar)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string	ls_mensaje
//create or replace procedure USP_RPT_MAQ_ESTRUCT(
//       asi_nada in varchar2
//) is

DECLARE USP_RPT_MAQ_ESTRUCT PROCEDURE FOR
	USP_RPT_MAQ_ESTRUCT( :ls_mensaje );

EXECUTE USP_RPT_MAQ_ESTRUCT;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_RPT_MAQ_ESTRUCT: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_RPT_MAQ_ESTRUCT;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user
//dw_report.object.datawindow.Print.Orientation = 1

end event

type dw_report from w_report_smpl`dw_report within w_ma716_estruct_maq
integer x = 0
integer y = 236
integer width = 3273
integer height = 1220
integer taborder = 50
string dataobject = "d_rpt_estructura_equipos"
end type

type cb_3 from commandbutton within w_ma716_estruct_maq
integer x = 2322
integer y = 80
integer width = 297
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type sle_cod_maq from singlelineedit within w_ma716_estruct_maq
event dobleclick pbm_lbuttondblclk
integer x = 466
integer y = 80
integer width = 402
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;string ls_sql, ls_return1, ls_return2

ls_sql = "select cod_maquina as codigo_maquina, " &
		 + "desc_maq as descripcion_maquina, " &
		 + "und as unidad " &
		 + "from vw_mt_maq_estruc " &
		 + "where flag_estado = '1' " &
		 + "ORDER BY desc_maq "
				 
f_lista(ls_sql, ls_return1, ls_return2, '2')
		
if ls_return1 <> '' then
	delete tt_mtt_equipos;
	commit;

	this.text = ls_return1
	
	insert into tt_mtt_equipos(cod_maquina)
	values (:ls_return1);
	
	if SQLCA.SQLCode < 0 then 
		MessageBox('Aviso', SQLCA.SQLErrText)
		ROLLBACK;
		return
	end if
	
	commit;
end if
end event

event modified;string ls_cod_maq

delete tt_mtt_equipos;
commit;

ls_cod_maq = this.text 
	
insert into tt_mtt_equipos(cod_maquina)
values (:ls_cod_maq);
	
commit;
end event

type rb_1 from radiobutton within w_ma716_estruct_maq
integer x = 87
integer y = 84
integer width = 375
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x Maquina"
boolean checked = true
end type

event clicked;sle_cod_maq.enabled = true
cb_seleccionar.enabled = false
end event

type rb_2 from radiobutton within w_ma716_estruct_maq
integer x = 891
integer y = 84
integer width = 521
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccionar Rango"
end type

event clicked;sle_cod_maq.enabled = false
SetNull(sle_cod_maq.text)
cb_seleccionar.enabled = true
end event

type cb_seleccionar from commandbutton within w_ma716_estruct_maq
integer x = 1408
integer y = 80
integer width = 402
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Seleccionar"
end type

event clicked;delete tt_mtt_equipos;

commit;

Open(w_abc_seleccion_estruc)
end event

type gb_1 from groupbox within w_ma716_estruct_maq
integer y = 16
integer width = 2167
integer height = 216
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

