$PBExportHeader$w_ope001_fase_etapa.srw
forward
global type w_ope001_fase_etapa from w_abc_mastdet_smpl
end type
type st_1 from statictext within w_ope001_fase_etapa
end type
type st_2 from statictext within w_ope001_fase_etapa
end type
end forward

global type w_ope001_fase_etapa from w_abc_mastdet_smpl
integer width = 2171
integer height = 2108
string title = "Mantenimiento Procesos - Actividades (OPE001)"
string menuname = "m_master_sin_lista"
st_1 st_1
st_2 st_2
end type
global w_ope001_fase_etapa w_ope001_fase_etapa

on w_ope001_fase_etapa.create
int iCurrent
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_ope001_fase_etapa.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cod_fase.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("cod_fase")
END IF
ls_protect=dw_detail.Describe("cod_etapa.protect")
IF ls_protect='0' THEN
   dw_detail.of_column_protect("cod_etapa")
END IF

end event

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)

//Help
ii_help = 1
ii_lec_mst = 0
//dw_master.retrieve(gs_user)
dw_master.retrieve()
end event

event ue_print();call super::ue_print;String      ls_cadena
Str_cns_pop lstr_cns_pop

IF idw_1.getrow() = 0 THEN RETURN

ls_cadena = idw_1.Object.cod_fase[idw_1.getrow()]

IF Isnull(ls_cadena) OR Trim(ls_cadena) = '' THEN RETURN

lstr_cns_pop.arg[1] = ls_cadena
lstr_cns_pop.arg[2] = gs_empresa
lstr_cns_pop.arg[3] = gs_user
lstr_cns_pop.arg[4] = ''


lstr_cns_pop.dataobject = 'd_rpt_labor_fase_etapa_ff'
lstr_cns_pop.title = 'Reporte de Etapas Por Fase'
lstr_cns_pop.width  = 3650
lstr_cns_pop.height = 1950

OpenSheetWithParm(w_rpt_pop, lstr_cns_pop, This, 2, Layered!)
end event

event ue_update_pre;call super::ue_update_pre;dw_master.accepttext()
dw_detail.accepttext()


//--VERIFICACION Y ASIGNACION DE FASE Y ETAPA
IF f_row_Processing( dw_master, "grid") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

//--VERIFICACION Y ASIGNACION DE FASE Y ETAPA

IF f_row_Processing( dw_detail, "grid") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ope001_fase_etapa
integer x = 0
integer y = 76
integer width = 2121
integer height = 724
string dataobject = "d_fase_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;//idw_det.retrieve(aa_id[1],gs_user)
idw_det.retrieve(aa_id[1])
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::itemchanged;call super::itemchanged;String ls_codigo,ls_descripcion
Long 	 ll_count

Accepttext()

choose case dwo.name
	 	 case 'ot_adm'
				
				select count(*) 
				  into :ll_count
				  from vw_ope_ot_adm_usr
				 where (ot_adm  = :data    ) and
				 		 (cod_usr = :gs_user ) ;
				
				if ll_count = 0 then
					SetNull(ls_codigo)
					Messagebox('Aviso','OT Administracion No Existe Verifique')
					This.object.ot_adm      [row] = ls_codigo
					This.object.descripcion [row] = ls_codigo
					Return 1	
				else
					select descripcion into :ls_descripcion from ot_administracion where ot_adm =:data ;
					
					This.object.descripcion [row] = ls_descripcion
					
				end if		
				 		 

end choose

end event

event dw_master::doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'ot_adm'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_OPE_OT_ADM_USR.OT_ADM AS OT_ADM, '&
														 +'VW_OPE_OT_ADM_USR.DESCRIPCION AS DESCRIPCION '&
														 +'FROM VW_OPE_OT_ADM_USR '&
														 +'WHERE COD_USR = '+"'"+gs_user+"'"
														 

										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'ot_adm',lstr_seleccionar.param1[1])
					Setitem(row,'descripcion',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
END CHOOSE




end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ope001_fase_etapa
integer x = 18
integer y = 916
integer width = 2103
integer height = 872
string dataobject = "d_etapa_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 2				// columnas de lectura de este dw
ii_rk[1] = 1 
end event

event dw_detail::itemerror;call super::itemerror;Return 1
end event

event dw_detail::itemchanged;call super::itemchanged;String ls_codigo,ls_descripcion
Long 	 ll_count

Accepttext()

choose case dwo.name
	 	 case 'ot_adm'
				
				select count(*) 
				  into :ll_count
				  from vw_ope_ot_adm_usr
				 where (ot_adm  = :data    ) and
				 		 (cod_usr = :gs_user ) ;
				
				if ll_count = 0 then
					SetNull(ls_codigo)
					Messagebox('Aviso','OT Administracion No Existe Verifique')
					This.object.ot_adm      [row] = ls_codigo
					This.object.descripcion [row] = ls_codigo
					Return 1	
				else
					select descripcion into :ls_descripcion from ot_administracion where ot_adm =:data ;
					
					This.object.descripcion [row] = ls_descripcion
					
				end if		
				 		 

end choose

end event

event dw_detail::doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'ot_adm'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_OPE_OT_ADM_USR.OT_ADM AS CODIGO_ADM, '&
														 +'VW_OPE_OT_ADM_USR.DESCRIPCION AS DESCRIPCION '&
														 +'FROM VW_OPE_OT_ADM_USR '&
														 +'WHERE COD_USR = '+"'"+gs_user+"'"
														 

										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'ot_adm',lstr_seleccionar.param1[1])
					Setitem(row,'descripcion',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
END CHOOSE




end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;String ls_ot_adm
ls_ot_adm = dw_master.GetItemString(dw_master.GetRow(), 'ot_adm')
this.object.ot_adm[al_row]=ls_ot_adm

end event

type st_1 from statictext within w_ope001_fase_etapa
integer x = 512
integer y = 4
integer width = 1074
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Procesos "
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ope001_fase_etapa
integer x = 576
integer y = 828
integer width = 942
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Actividades"
alignment alignment = center!
boolean focusrectangle = false
end type

