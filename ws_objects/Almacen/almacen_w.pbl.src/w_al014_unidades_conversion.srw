$PBExportHeader$w_al014_unidades_conversion.srw
forward
global type w_al014_unidades_conversion from w_abc_master_smpl
end type
type st_1 from statictext within w_al014_unidades_conversion
end type
end forward

global type w_al014_unidades_conversion from w_abc_master_smpl
integer width = 2734
integer height = 1152
string title = "Motivos de traslado"
string menuname = "m_mantenimiento_sl"
st_1 st_1
end type
global w_al014_unidades_conversion w_al014_unidades_conversion

on w_al014_unidades_conversion.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_al014_unidades_conversion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar( this )
ii_pregunta_delete = 1 
ib_log = TRUE
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_al014_unidades_conversion
integer x = 18
integer y = 164
integer width = 2597
string dataobject = "d_abc_und_conversion_tbl"
boolean minbox = true
boolean maxbox = true
boolean livescroll = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::itemchanged;call super::itemchanged;Long 	 ll_count
String ls_desc_unidad

Accepttext()

choose case dwo.name
		 case 'und_ingr'
			
				select count(*) into :ll_count
				  from unidad
				 where (und = :data) ;

			   IF ll_count = 0 THEN
					Messagebox('Aviso','Unidad de Conversión No Existe , Verifique!')
					Return 1
				ELSE
					select desc_unidad into :ls_desc_unidad from unidad 
					 where (und = :data) ;
					 
					
					This.object.desc_unidad_ingr [row] = ls_desc_unidad
					 
				END IF
				 
		 case 'und_conv'		
				select count(*) into :ll_count
				  from unidad
				 where (und = :data) ;
				 
				 
			   IF ll_count = 0 THEN
					Messagebox('Aviso','Unidad de Conversión No Existe , Verifique!')
					Return 1
				ELSE
					select desc_unidad into :ls_desc_unidad from unidad 
					 where (und = :data) ;
					 
					 
					This.object.desc_unidad_conv [row] = ls_desc_unidad
				END IF
			
end choose

end event

event dw_master::doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar




CHOOSE CASE dwo.name
		 CASE 'und_ingr'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT UNIDAD.UND         AS CODIGO, '&
														 +'UNIDAD.DESC_UNIDAD AS DESCRIPCION '&
														 +'FROM UNIDAD '

										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'und_ingr',lstr_seleccionar.param1[1])
					Setitem(row,'desc_unidad_ingr',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
				
		 CASE 'und_conv'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT UNIDAD.UND         AS CODIGO, '&
														 +'UNIDAD.DESC_UNIDAD AS DESCRIPCION '&
														 +'FROM UNIDAD '

										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'und_conv',lstr_seleccionar.param1[1])
					Setitem(row,'desc_unidad_conv',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
END CHOOSE


end event

type st_1 from statictext within w_al014_unidades_conversion
integer x = 809
integer y = 36
integer width = 919
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
string text = "Unidades de Conversión"
alignment alignment = center!
boolean focusrectangle = false
end type

