$PBExportHeader$w_cm006_criterios_evaluacion.srw
forward
global type w_cm006_criterios_evaluacion from w_abc_master_smpl
end type
type st_1 from statictext within w_cm006_criterios_evaluacion
end type
end forward

global type w_cm006_criterios_evaluacion from w_abc_master_smpl
integer width = 1874
integer height = 1332
string title = "Criterios de evaluacion [CM006]"
string menuname = "m_mantto_smpl"
st_1 st_1
end type
global w_cm006_criterios_evaluacion w_cm006_criterios_evaluacion

on w_cm006_criterios_evaluacion.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_cm006_criterios_evaluacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()

end event

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.cod_criterio.Protect)

IF li_protect = 0 THEN
   dw_master.Object.cod_criterio.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;f_centrar( this)
ii_pregunta_delete = 1 
end event

type dw_master from w_abc_master_smpl`dw_master within w_cm006_criterios_evaluacion
integer x = 14
integer y = 136
integer width = 1810
integer height = 988
string dataobject = "d_abc_criterio_evaluacion_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("cod_comprador.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("nom_comprador.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
str_parametros sl_param
String ls_name, ls_prot

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if
CHOOSE CASE dwo.name 
	CASE 'cod_comprador' 
		// Asigna valores a structura 
		sl_param.dw1 = "d_dddw_trabajador"
		sl_param.titulo = "Trabajadores"
		sl_param.field_ret_i[1] = 1		

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then			
			this.object.cod_comprador[this.getrow()] = sl_param.field_ret[1]			
		END IF
END CHOOSE
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this)
end event

type st_1 from statictext within w_cm006_criterios_evaluacion
integer x = 407
integer y = 36
integer width = 1047
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "CRITERIOS DE EVALUACION"
alignment alignment = center!
boolean focusrectangle = false
end type

