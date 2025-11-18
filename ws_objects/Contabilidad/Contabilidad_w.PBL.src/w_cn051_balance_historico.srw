$PBExportHeader$w_cn051_balance_historico.srw
forward
global type w_cn051_balance_historico from w_abc_master_smpl
end type
type st_1 from statictext within w_cn051_balance_historico
end type
type sle_ano from singlelineedit within w_cn051_balance_historico
end type
type cb_1 from commandbutton within w_cn051_balance_historico
end type
end forward

global type w_cn051_balance_historico from w_abc_master_smpl
integer width = 3365
integer height = 1616
string title = "Mantenimiento de Monedas (CN003)"
string menuname = "m_abc_master_smpl"
st_1 st_1
sle_ano sle_ano
cb_1 cb_1
end type
global w_cn051_balance_historico w_cn051_balance_historico

on w_cn051_balance_historico.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.st_1=create st_1
this.sle_ano=create sle_ano
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_ano
this.Control[iCurrent+3]=this.cb_1
end on

on w_cn051_balance_historico.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_ano)
destroy(this.cb_1)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("ano.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("ano")
END IF
end event

event resize;//  Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

event ue_dw_share;// Override
//IF ii_lec_mst = 1 THEN dw_master.Retrieve()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn051_balance_historico
integer x = 32
integer y = 192
integer width = 3255
integer height = 1212
string dataobject = "d_rpt_balance_historico_tbl"
end type

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;String ls_cuenta, ls_descrip
Long ll_count 

This.AcceptText()
//cntbl_cnta_abrev_cnta

ii_update=1
	
CHOOSE CASE dwo.name
   CASE 'cnta_ctbl'	
	  ls_cuenta = DATA

	  SELECT count(*) 
	    INTO :ll_count 
		 FROM cntbl_cnta 
	   WHERE cnta_ctbl = :ls_cuenta and flag_estado='1' ;

	  IF ll_count=0 then
		  messagebox('Aviso', 'Cuenta contable no existe')
		  Setnull(ls_cuenta)
		  This.object.cnta_ctbl[row] = ls_cuenta
		  return 1
	  end if
	  
    SELECT c.abrev_cnta
	   INTO :ls_descrip 
		FROM cntbl_cnta c 
     WHERE c.cnta_ctbl = :ls_cuenta ; 

	  this.object.cntbl_cnta_abrev_cnta[row] = ls_descrip 
END CHOOSE	

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;Long ll_ano

ll_ano = Long(sle_ano.text)

this.object.ano[al_row] = ll_ano
end event

type st_1 from statictext within w_cn051_balance_historico
integer x = 101
integer y = 68
integer width = 142
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año: "
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_cn051_balance_historico
integer x = 256
integer y = 64
integer width = 192
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cn051_balance_historico
integer x = 475
integer y = 44
integer width = 274
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recupera"
end type

event clicked;Long ll_ano

ll_ano = LONG(sle_ano.text) 

IF ii_lec_mst = 1 THEN dw_master.Retrieve(ll_ano)
end event

