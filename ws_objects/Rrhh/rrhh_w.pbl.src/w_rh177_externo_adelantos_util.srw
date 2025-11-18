$PBExportHeader$w_rh177_externo_adelantos_util.srw
forward
global type w_rh177_externo_adelantos_util from w_abc_master_smpl
end type
type st_1 from statictext within w_rh177_externo_adelantos_util
end type
type sle_ano from singlelineedit within w_rh177_externo_adelantos_util
end type
type cb_1 from commandbutton within w_rh177_externo_adelantos_util
end type
type st_2 from statictext within w_rh177_externo_adelantos_util
end type
type gb_1 from groupbox within w_rh177_externo_adelantos_util
end type
end forward

global type w_rh177_externo_adelantos_util from w_abc_master_smpl
integer width = 3950
integer height = 1872
string title = "(RH177) Movimiento de Adelantos a Cuenta"
string menuname = "m_master_simple"
st_1 st_1
sle_ano sle_ano
cb_1 cb_1
st_2 st_2
gb_1 gb_1
end type
global w_rh177_externo_adelantos_util w_rh177_externo_adelantos_util

type variables

end variables

on w_rh177_externo_adelantos_util.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.st_1=create st_1
this.sle_ano=create sle_ano
this.cb_1=create cb_1
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_ano
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.gb_1
end on

on w_rh177_externo_adelantos_util.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_ano)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.gb_1)
end on

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
end event

event ue_modify;call super::ue_modify;string ls_protect
ls_protect=dw_master.Describe("periodo.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('periodo')
END IF
ls_protect=dw_master.Describe("cod_relacion.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cod_relacion')
END IF
ls_protect=dw_master.Describe("fecha_proceso.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('fecha_proceso')
END IF
end event

event ue_dw_share;// Override
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh177_externo_adelantos_util
integer x = 59
integer y = 308
integer width = 3803
integer height = 1348
string dataobject = "d_adelantos_a_cuenta_utilidades_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'  
ii_ck[1] = 1				
ii_ck[2] = 2    			
ii_ck[3] = 3    			

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;String ls_periodo, ls_conc_adel_util 
Long ll_periodo, ll_count 

ls_periodo = TRIM(sle_ano.text)
ll_periodo = Long(TRIM(sle_ano.text))

SELECT NVL(u.cncp_adelanto_util,'') 
  INTO :ls_conc_adel_util 
  FROM utlparam u 
 WHERE reckey='1' ;

IF isnull(ls_conc_adel_util) OR ls_conc_adel_util='' THEN
	MessageBox('Aviso','Definir concepto de adelanto de utilidades')
	Return
END IF 

SELECT count(*) 
  INTO :ll_count 
  FROM utl_excl_trabajador 
 WHERE periodo = :ll_periodo ;

IF ll_count=0 THEN
	MessageBox('Aviso', 'No existe personal externo para periodo seleccionado')
	this.DeleteRow(al_row)
	Return 
END IF 

dw_master.Modify("periodo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cod_relacion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("fecha_proceso.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("concep.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("imp_adelanto.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("imp_reten_jud.Protect='1~tIf(IsRowNew(),0,1)'")

this.setitem(al_row,"periodo", Long(ls_periodo))
this.setitem(al_row,"concep", Long(ls_conc_adel_util))
this.setitem(al_row,"flag_pers_ext", '1')


end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'concep'
		ls_sql = "select concep as codigo, desc_concep as descripcion from concepto where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.concep[row]      = ls_return1
		this.object.desc_concep[row] = ls_return2
		this.ii_update = 1
end choose


end event

event dw_master::itemchanged;call super::itemchanged;string ls_concepto, ls_descripcion

accepttext()
choose case dwo.name 
	case 'concep'
		ls_concepto = dw_master.object.concep[row]	
		select desc_concep
		  into :ls_descripcion
		  from concepto
		  where concep = :ls_concepto ;
		dw_master.object.desc_concep[row] = ls_descripcion
end choose
end event

event dw_master::clicked;call super::clicked;Long ll_count, ll_periodo

ll_periodo = Long(TRIM(sle_ano.text))

select count(*) into :ll_count from utl_excl_trabajador where periodo = :ll_periodo ;

IF ll_count=0 THEN
	MessageBox('Aviso', 'Primero defina personal externo para periodo seleccionado')
	Return -1
END IF 
end event

type st_1 from statictext within w_rh177_externo_adelantos_util
integer x = 165
integer y = 136
integer width = 169
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año : "
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_rh177_externo_adelantos_util
integer x = 352
integer y = 124
integer width = 169
integer height = 88
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

type cb_1 from commandbutton within w_rh177_externo_adelantos_util
integer x = 718
integer y = 116
integer width = 315
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Long ll_ano

ll_ano = Long(sle_ano.text)

IF ll_ano = 0 THEN
	MessageBox('Aviso', 'Defina período')
	Return 1
END IF 

dw_master.Retrieve(ll_ano)

end event

type st_2 from statictext within w_rh177_externo_adelantos_util
integer x = 1129
integer y = 140
integer width = 2432
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
string text = "Permite registrar los adelantos a cuenta de personal externo por el concepto de utilidades."
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_rh177_externo_adelantos_util
integer x = 73
integer y = 60
integer width = 603
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Período de utilidades"
end type

