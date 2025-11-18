$PBExportHeader$w_cn028_maerel.srw
forward
global type w_cn028_maerel from w_abc_mastdet_smpl
end type
type sle_1 from singlelineedit within w_cn028_maerel
end type
type st_1 from statictext within w_cn028_maerel
end type
end forward

global type w_cn028_maerel from w_abc_mastdet_smpl
integer width = 1755
integer height = 1776
string title = "Maestro de Relaciones (CN028)"
string menuname = "m_abc_master_smpl"
sle_1 sle_1
st_1 st_1
end type
global w_cn028_maerel w_cn028_maerel

on w_cn028_maerel.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.sle_1=create sle_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_1
this.Control[iCurrent+2]=this.st_1
end on

on w_cn028_maerel.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_1)
destroy(this.st_1)
end on

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente
//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
//Log de Seguridad
ib_log = TRUE


end event

event ue_modify();//dw_master.of_protect()
dw_detail.of_protect()

String ls_protect
ls_protect=dw_master.Describe("proveedor.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("proveedor")
END IF
ls_protect=dw_detail.Describe("proveedor.protect")
IF ls_protect='0' THEN
   dw_detail.of_column_protect("proveedor")
END IF
end event

event resize;// Override
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cn028_maerel
integer x = 41
integer y = 172
integer width = 1637
integer height = 444
string dataobject = "d_maerel_lista_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])

end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cn028_maerel
integer x = 41
integer y = 664
integer width = 1637
integer height = 900
string dataobject = "d_maerel_ff"
end type

event dw_detail::constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 2 	      // columnas que recibimos del master
//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_detail::clicked;// Override
end event

type sle_1 from singlelineedit within w_cn028_maerel
integer x = 942
integer y = 48
integer width = 325
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;long ll_reg
String ls_nombres
ls_nombres = sle_1.text
ls_nombres = " proveedor >= '" + ls_nombres + "'"
Parent.SetMicroHelp( ls_nombres )
ll_reg = dw_master.Find( ls_nombres, 1, dw_master.RowCount() )
dw_master.ScrollToRow(ll_reg)
dw_master.SelectRow(0, false)
dw_master.SelectRow(ll_reg, true)

end event

type st_1 from statictext within w_cn028_maerel
integer x = 46
integer y = 60
integer width = 855
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Buscar por Código de Proveedor"
boolean focusrectangle = false
end type

