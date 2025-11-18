$PBExportHeader$w_ma001_grupo_maquina.srw
forward
global type w_ma001_grupo_maquina from w_abc_mastdet_smpl
end type
type st_1 from statictext within w_ma001_grupo_maquina
end type
type st_2 from statictext within w_ma001_grupo_maquina
end type
type cb_1 from commandbutton within w_ma001_grupo_maquina
end type
end forward

global type w_ma001_grupo_maquina from w_abc_mastdet_smpl
integer width = 2181
integer height = 1712
string title = "Grupos de máquinas (MA001)"
string menuname = "m_abc_mastdet_smpl"
st_1 st_1
st_2 st_2
cb_1 cb_1
end type
global w_ma001_grupo_maquina w_ma001_grupo_maquina

type variables
string is_aid
end variables

on w_ma001_grupo_maquina.create
int iCurrent
call super::create
if this.MenuName = "m_abc_mastdet_smpl" then this.MenuID = create m_abc_mastdet_smpl
this.st_1=create st_1
this.st_2=create st_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_1
end on

on w_ma001_grupo_maquina.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_1)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("grupo_maq.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('grupo_maq')
END IF
ls_protect=dw_detail.Describe("maquina_grp_cod_maquina.protect")
IF ls_protect='0' THEN
   dw_detail.of_column_protect('maquina_grp_cod_maquina')
END IF

end event

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)

//Help
ii_help = 4
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
dw_detail.of_set_flag_replicacion( )
//--VERIFICACION Y ASIGNACION DE GRUPO DE MAQUINA
IF f_row_Processing( dw_master, "grid") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF



//--VERIFICACION Y ASIGNACION DE GRUPO DE MAQUINA

IF f_row_Processing( dw_detail, "grid") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF


end event

event resize;// Ancestor Script has been Override
dw_master.width  = newwidth  - dw_master.x - 10
st_1.x 		= dw_master.X
st_1.width 	= dw_master.width

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
st_2.x 		= dw_detail.X
st_2.width 	= dw_detail.width

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ma001_grupo_maquina
integer y = 88
integer width = 2117
string dataobject = "d_abc_grupo_maquina_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ma001_grupo_maquina
integer x = 5
integer y = 672
integer width = 2117
integer height = 812
string dataobject = "d_abc_grupo_maquina_relac_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 2				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master


end event

event dw_detail::itemerror;call super::itemerror;RETURN 1
end event

event dw_detail::itemchanged;call super::itemchanged;String ls_des_maquina,ls_codigo
Long   ll_count

CHOOSE CASE dwo.name
		 CASE 'cod_maquina'
				SELECT Count(*)
				  INTO :ll_count
				  FROM maquina
				 WHERE (cod_maquina = :data) ;
				 
				IF ll_count > 0 THEN
					SELECT desc_maq
				     INTO :ls_des_maquina
				     FROM maquina
				    WHERE (cod_maquina = :data) ;
					 
					dw_detail.object.maquina_desc_maq[row] = ls_des_maquina					 
				ELSE
					SetNull(ls_codigo)
					This.Object.cod_maquina [row] =  ls_codigo
					Messagebox('Aviso','Debe Ingresar Un Codigo de Maquina Valido, Verifique!')
					Return 1
				END IF	
				 
				 

END CHOOSE

end event

event dw_detail::doubleclicked;call super::doubleclicked;String ls_cod_maquina
str_seleccionar lstr_seleccionar

CHOOSE CASE dwo.name
		 CASE 'cod_maquina'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS CODIGO, '&
		      						 +'MAQUINA.DESC_MAQ AS DESCRIPCION, '&     	
										 +'MAQUINA.TIPO_MAQUINA AS TIPO '&     	
							 		   +'FROM MAQUINA '
									  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
 
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_maquina',lstr_seleccionar.param1[1])					
					Setitem(row,'maquina_desc_maq',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF

END CHOOSE

end event

event dw_detail::buttonclicked;call super::buttonclicked;//sg_parametros sl_param
//
//This.AcceptText()
//If this.ii_protect = 1 then RETURN
//
//choose case lower(dwo.name)
//	case "b_maquinas"
//		
//		sl_param.w1			 = parent
//		sl_param.dw_or_d	 = dw_detail
//		sl_param.dw_or_m	 = dw_master
//		sl_param.dw1       = 'd_list_equipos_grid'
//		sl_param.titulo    = 'Lista de Equipos'
//		sl_param.opcion    = 1
//		OpenWithParm( w_abc_seleccion, sl_param)
//
//end choose
end event

type st_1 from statictext within w_ma001_grupo_maquina
integer x = 5
integer y = 16
integer width = 2117
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217742
long backcolor = 134217730
boolean enabled = false
string text = "Grupos de Máquinas"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ma001_grupo_maquina
integer x = 5
integer y = 596
integer width = 2117
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217742
long backcolor = 134217730
boolean enabled = false
string text = "Máquinas Asignadas al Grupo"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ma001_grupo_maquina
integer x = 18
integer y = 680
integer width = 731
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Listado de Máquinas"
end type

event clicked;sg_parametros sl_param

//If dw_detail.ii_protect = 1 then RETURN

sl_param.w1			 = parent
sl_param.dw_or_d	 = dw_detail
sl_param.dw_or_m	 = dw_master
sl_param.dw1       = 'd_list_equipos_grid'
sl_param.titulo    = 'Lista de Equipos'
sl_param.opcion    = 1
OpenWithParm( w_abc_seleccion, sl_param)

end event

