$PBExportHeader$w_cn008_nivel_centro_costo.srw
forward
global type w_cn008_nivel_centro_costo from w_abc_mid
end type
type st_1 from statictext within w_cn008_nivel_centro_costo
end type
type st_2 from statictext within w_cn008_nivel_centro_costo
end type
type st_3 from statictext within w_cn008_nivel_centro_costo
end type
end forward

global type w_cn008_nivel_centro_costo from w_abc_mid
integer width = 3758
integer height = 1780
string title = "Centro de Costos (CN008)"
string menuname = "m_abc_master_smpl"
st_1 st_1
st_2 st_2
st_3 st_3
end type
global w_cn008_nivel_centro_costo w_cn008_nivel_centro_costo

on w_cn008_nivel_centro_costo.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
end on

on w_cn008_nivel_centro_costo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_master.Retrieve()

idw_1 = dw_master              				// asignar dw corriente


dw_master.setFocus()


end event

event ue_modify();call super::ue_modify;String ls_protect
IF idw_1 = dw_master then
	ls_protect=dw_master.Describe("cod_n1.protect")
	IF ls_protect='0' THEN
   	dw_master.of_column_protect("cod_n1")
	END IF
END IF
IF idw_1 = dw_detmast then
	ls_protect=dw_detmast.Describe("cod_n2.protect")
	IF ls_protect='0' THEN
   	dw_master.of_column_protect("cod_n2")
	END IF
END IF
IF idw_1 = dw_detail then
	ls_protect=dw_detail.Describe("cod_n3.protect")
	IF ls_protect='0' THEN
   	dw_master.of_column_protect("cod_n3")
	END IF
END IF
end event

event resize;// Override

st_2.y = newheight/2 + 10

//Nivel 1
dw_master.width	= newwidth/2  - dw_master.x - 10
dw_master.height	= st_2.y - dw_detail.y - 10
st_1.width 			= dw_master.width

//Nivel 2
dw_detmast.y 			= st_2.y + st_2.height + 10
dw_detmast.width		= newwidth/2  - dw_detmast.x - 10
dw_detmast.height	= newheight - dw_detmast.y - 10
st_2.width 				= dw_detmast.width

//Nivel 3
dw_detail.x 			= dw_master.x + dw_master.width + 10
dw_detail.y			= dw_master.y
dw_detail.width   	= newwidth  - dw_detail.x - 10
dw_detail.height  	= newheight - dw_detail.y - 10

st_3.x					= dw_detail.x
st_3.width 			= dw_detail.width
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
dw_detmast.of_set_flag_replicacion()
end event

type dw_master from w_abc_mid`dw_master within w_cn008_nivel_centro_costo
integer x = 0
integer y = 92
integer width = 1399
integer height = 444
string dataobject = "d_cencos_niv1_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 			// dw_master
idw_det  = dw_detmast
end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mid`dw_detail within w_cn008_nivel_centro_costo
integer x = 1870
integer y = 96
integer width = 1403
integer height = 444
string dataobject = "d_cencos_niv3_tbl"
borderstyle borderstyle = styleraised!
end type

event dw_detail::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_detmast

end event

type dw_detmast from w_abc_mid`dw_detmast within w_cn008_nivel_centro_costo
integer x = 0
integer y = 672
integer width = 1403
integer height = 444
string dataobject = "d_cencos_niv2_tbl"
borderstyle borderstyle = styleraised!
end type

event dw_detmast::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
idw_mst  = dw_master
idw_det  = dw_detail
end event

event dw_detmast::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event dw_detmast::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

end event

event dw_detmast::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2])
end event

type st_1 from statictext within w_cn008_nivel_centro_costo
integer width = 1349
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "NIVEL 1 - Centros de Costos"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn008_nivel_centro_costo
integer y = 580
integer width = 1349
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "NIVEL 2 - Centros de Costos"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn008_nivel_centro_costo
integer x = 1879
integer width = 1349
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "NIVEL 3 - Centros de Costos"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

