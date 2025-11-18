$PBExportHeader$w_abc_incidencia_trabajador_as202.srw
forward
global type w_abc_incidencia_trabajador_as202 from w_abc_master
end type
type uo_1 from u_cst_quick_search within w_abc_incidencia_trabajador_as202
end type
type st_1 from statictext within w_abc_incidencia_trabajador_as202
end type
end forward

global type w_abc_incidencia_trabajador_as202 from w_abc_master
integer width = 2903
integer height = 1660
string title = "Incidencias Diarias por Trabajador (AS202)"
string menuname = "m_abc_master_smpl"
uo_1 uo_1
st_1 st_1
end type
global w_abc_incidencia_trabajador_as202 w_abc_incidencia_trabajador_as202

type variables
string is_codigo
end variables

on w_abc_incidencia_trabajador_as202.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.uo_1=create uo_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.st_1
end on

on w_abc_incidencia_trabajador_as202.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.st_1)
end on

event ue_modify;call super::ue_modify;int li_protect
li_protect = integer(dw_master.Object.cod_trabajador.Protect)

IF li_protect = 0 THEN
   dw_master.Object.cod_trabajador.Protect = 1
END IF

end event

event ue_open_pre;call super::ue_open_pre;of_position_window(380,150)
uo_1.of_set_dw('d_maestro_lista_tbl')
uo_1.of_set_field('apel_paterno')

uo_1.of_retrieve_lista()
uo_1.of_sort_lista()
uo_1.of_protect()

end event

type dw_master from w_abc_master`dw_master within w_abc_incidencia_trabajador_as202
integer y = 768
integer width = 2853
integer height = 708
string dataobject = "d_incidencia_trabajador_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'  // Tabular, grid, form (default)
ii_ck[1] = 1           // Forma el PK
ii_ck[2] = 2           // Forma el PK
end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;Int li_count 
String ls_protect

this.setitem(al_row,"cod_trabajador",is_codigo)
ls_protect=dw_master.Describe("cod_trabajador.protect")

IF ls_protect='0' THEN
  	dw_master.of_column_protect('cod_trabajador')
END IF
this.setitem(al_row,"cod_usr",gs_user)

end event

event dw_master::itemchanged;call super::itemchanged;date ld_fec_desde, ld_fec_hasta, ldt_fecha
string ls_fec_hasta

choose case dwo.name
	CASE 'fecha_fin'
        dw_master.GetText() 
	     dw_master.Accepttext()
		  //Fecha Inicial es NULA
		  ld_fec_desde=date(dw_master.GetItemDatetime(row,'fecha_inicio'))
        SetNull(ldt_fecha)
		  If isnull(ld_fec_desde) then
			  messagebox("Atención","Ingrese Fecha Inicial")
			  this.SetColumn("fecha_inicio")
			  this.Setfocus()
           this.SetItem(row,"fec_hasta",ldt_fecha)
			  ii_update = 0
			  return 1
		   End if 	  
		  
        //Verificar que la Fecha FINAL sea mayor que la Fecha INICIAL
		  ld_fec_hasta=date(dw_master.GetItemDatetime(row,'fecha_fin'))

		  IF ld_fec_hasta < ld_fec_desde THEN 
			  messagebox("Atención","La fecha final debe ser "+&
 				          "mayor que la fecha inicial")
			  ii_update =0
			  Return 1
		  END IF 
		    	 
end choose 


end event

type uo_1 from u_cst_quick_search within w_abc_incidencia_trabajador_as202
integer x = 9
integer y = 4
integer width = 2853
integer height = 624
integer taborder = 10
boolean bringtotop = true
end type

on uo_1.destroy
call u_cst_quick_search::destroy
end on

event ue_retorno;call super::ue_retorno;dw_master.Retrieve(aa_id)
is_codigo=aa_id

end event

type st_1 from statictext within w_abc_incidencia_trabajador_as202
integer x = 9
integer y = 660
integer width = 2853
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "DETALLE DE INCIDENCIAS POR TRABAJADOR"
alignment alignment = center!
boolean focusrectangle = false
end type

