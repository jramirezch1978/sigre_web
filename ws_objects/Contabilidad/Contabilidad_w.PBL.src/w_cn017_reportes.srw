$PBExportHeader$w_cn017_reportes.srw
forward
global type w_cn017_reportes from w_abc_mid
end type
type st_1 from statictext within w_cn017_reportes
end type
type st_2 from statictext within w_cn017_reportes
end type
type st_3 from statictext within w_cn017_reportes
end type
type st_4 from statictext within w_cn017_reportes
end type
end forward

global type w_cn017_reportes from w_abc_mid
integer width = 3173
integer height = 1648
string title = "Reportes de Contabilidad (CN017)"
string menuname = "m_abc_master_smpl"
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
end type
global w_cn017_reportes w_cn017_reportes

on w_cn017_reportes.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
end on

on w_cn017_reportes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
end on

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

//dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_master.Retrieve()
idw_1 = dw_master              				// asignar dw corriente
dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado
//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
//Log de Seguridad
ib_log = TRUE
is_tabla_m  = 'rpt_grupo'
is_tabla_dm = 'rpt_subgrupo'
is_tabla_d  = 'rpt_subgrupo_det'


end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("reporte.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("reporte")
END IF
ls_protect=dw_master.Describe("grupo.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("grupo")
END IF
end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
dw_detmast.of_set_flag_replicacion()
end event

type dw_master from w_abc_mid`dw_master within w_cn017_reportes
integer x = 864
integer y = 36
integer width = 2240
integer height = 332
string dataobject = "d_reportes_grupo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle

//idw_mst  = 			// dw_master
idw_det  = dw_detmast
end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1], aa_id[2])
end event

event dw_master::clicked;call super::clicked;String ls_prueba
ls_prueba = '1'
end event

type dw_detail from w_abc_mid`dw_detail within w_cn017_reportes
integer x = 864
integer y = 940
integer width = 2240
integer height = 484
string dataobject = "d_reportes_subgrupo_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			
ii_ck[3] = 3			
ii_ck[4] = 4			
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
ii_rk[3] = 3
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_detmast
This.SetRowFocusIndicator(Hand!)
end event

event dw_detail::clicked;call super::clicked;if row=0 then return
this.SelectRow( 0, false )
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;long ll_reg, ln_item
ln_item = 0 
For ll_reg = 1 to dw_detail.RowCount()
	 if ln_item < dw_detail.GetItemNumber( ll_reg, 'item' ) then 
	    ln_item = dw_detail.GetItemNumber( ll_reg, 'item' ) 
    end if 
Next
ln_item = ln_item + 1 
dw_detail.SetItem( al_row, 'item', ln_item )
dw_detail.SetItem( al_row, 'acum_en_mn','0')

end event

type dw_detmast from w_abc_mid`dw_detmast within w_cn017_reportes
integer x = 864
integer y = 424
integer width = 2240
integer height = 472
string dataobject = "d_reportes_subgrupo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detmast::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			
ii_ck[3] = 3			
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
ii_dk[3] = 3
idw_mst  = dw_master
idw_det  = dw_detail
This.SetRowFocusIndicator(Hand!)
end event

event dw_detmast::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

if row=0 then return
this.SelectRow( 0, false )

end event

event dw_detmast::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

end event

event dw_detmast::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve( aa_id[1], aa_id[2], aa_id[3] )
end event

type st_1 from statictext within w_cn017_reportes
integer x = 174
integer y = 148
integer width = 471
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "GRUPOS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn017_reportes
integer x = 59
integer y = 592
integer width = 699
integer height = 80
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SUB - GRUPOS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn017_reportes
integer x = 50
integer y = 1052
integer width = 713
integer height = 80
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "DETALLE  DEL"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn017_reportes
integer x = 78
integer y = 1180
integer width = 658
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SUB - GRUPO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

