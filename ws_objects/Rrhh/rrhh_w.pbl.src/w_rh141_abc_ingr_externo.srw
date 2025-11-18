$PBExportHeader$w_rh141_abc_ingr_externo.srw
forward
global type w_rh141_abc_ingr_externo from w_abc_master
end type
type uo_cabecera from u_cst_quick_search within w_rh141_abc_ingr_externo
end type
end forward

global type w_rh141_abc_ingr_externo from w_abc_master
integer width = 2350
integer height = 1812
string title = "(RH141) Ganancias Externas"
string menuname = "m_master_simple"
uo_cabecera uo_cabecera
end type
global w_rh141_abc_ingr_externo w_rh141_abc_ingr_externo

type variables
string is_codigo
end variables

on w_rh141_abc_ingr_externo.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.uo_cabecera=create uo_cabecera
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_cabecera
end on

on w_rh141_abc_ingr_externo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_cabecera)
end on

event ue_open_pre;call super::ue_open_pre;uo_cabecera.of_set_dw('d_maestro_lista_tbl')
uo_cabecera.of_set_field('nombres')

uo_cabecera.of_retrieve_lista(gs_origen)
uo_cabecera.of_sort_lista()
uo_cabecera.of_protect()


end event

event resize;call super::resize;uo_cabecera.width  = newwidth  - uo_cabecera.x - 10

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

type dw_master from w_abc_master`dw_master within w_rh141_abc_ingr_externo
integer y = 1028
integer width = 2181
integer height = 576
string dataobject = "d_abc_remun_externa_tbl"
end type

event dw_master::constructor;is_dwform = 'tabular'  // tabular, grid, form (default)
ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_trabajador 	[al_Row] = is_codigo
this.object.flag_automatico 	[al_Row] = '0'
this.object.rem_imprecisa 		[al_Row] = 0.00
this.object.rem_retencion 		[al_Row] = 0.00
this.object.rem_gratif 			[al_Row] = 0.00
this.object.rem_externa 		[al_Row] = 0.00
this.object.nro_dias 			[al_Row] = 0


end event

event dw_master::itemchanged;call super::itemchanged;Decimal ldc_imp_gan

choose case dwo.name 
	case 'sueldo'
		ldc_imp_gan = Dec(data)
		If ldc_imp_gan < 0 then
			Messagebox("RRHH","El IMPORTE debe ser MAYOR que CERO", StopSign!)
			dw_master.SetColumn("sueldo")
			dw_master.SetFocus()
			return 1
		End If
end choose 	
end event

type uo_cabecera from u_cst_quick_search within w_rh141_abc_ingr_externo
integer width = 2245
integer height = 1020
integer taborder = 10
boolean bringtotop = true
end type

on uo_cabecera.destroy
call u_cst_quick_search::destroy
end on

event ue_retorno;call super::ue_retorno;dw_master.Retrieve(aa_id)
is_codigo=aa_id
end event

