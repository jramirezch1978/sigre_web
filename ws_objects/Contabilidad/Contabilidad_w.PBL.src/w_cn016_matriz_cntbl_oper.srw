$PBExportHeader$w_cn016_matriz_cntbl_oper.srw
forward
global type w_cn016_matriz_cntbl_oper from w_abc_mastdet_smpl
end type
type st_1 from statictext within w_cn016_matriz_cntbl_oper
end type
type dw_1 from u_dw_cns within w_cn016_matriz_cntbl_oper
end type
end forward

global type w_cn016_matriz_cntbl_oper from w_abc_mastdet_smpl
integer width = 3173
integer height = 1908
string title = "Matriz contable de operaciones (CN016)"
string menuname = "m_abc_mastdet_smpl"
st_1 st_1
dw_1 dw_1
end type
global w_cn016_matriz_cntbl_oper w_cn016_matriz_cntbl_oper

on w_cn016_matriz_cntbl_oper.create
int iCurrent
call super::create
if this.MenuName = "m_abc_mastdet_smpl" then this.MenuID = create m_abc_mastdet_smpl
this.st_1=create st_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_1
end on

on w_cn016_matriz_cntbl_oper.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_1)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)       			// Posicionar la ventana en forma fija
//Log de Seguridad
ib_log = TRUE
//Leemos lista de matrices
dw_1.Settransobject(sqlca)
dw_1.Retrieve()

end event

event resize;//dw_master.width  = newwidth  - dw_master.x - 10
//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cn016_matriz_cntbl_oper
integer y = 4
integer width = 1947
integer height = 588
string dataobject = "d_matriz_cntbl_oper_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::dragdrop;call super::dragdrop;STRING ls_matriz, ls_matriz_new
ls_matriz = dw_1.object.matriz_ctbl[dw_1.GetRow()]
ls_matriz_new = dw_master.GetItemString(dw_master.Getrow(),"matriz_ctbl")
//Ejecutamos Store Procedure de llenado de tabla
DECLARE sp_plant_matriz PROCEDURE FOR usp_copiar_matriz_contable(:ls_matriz, :ls_matriz_new);
EXECUTE sp_plant_matriz;
IF SQLCA.SQLCODE = -1 THEN
	messagebox("Error","Procedimiento no se ha ejecutado correctamente")
END IF	
//Volvemos a leer el DataWindows de Copiado
dw_1.Retrieve()

end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cn016_matriz_cntbl_oper
integer y = 600
integer width = 3113
integer height = 1120
string dataobject = "d_matriz_cntbl_oper_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle
This.SetRowFocusIndicator(Hand!)
end event

event dw_detail::clicked;call super::clicked;This.SelectRow(0, False)
end event

event dw_detail::ue_insert_pre(long al_row);call super::ue_insert_pre;long ln_reg 
integer li_item
li_item = 0 
For ln_reg = 1 to this.RowCount()
	 if this.GetItemNumber( ln_reg, 'item' ) > li_item then 
		 li_item = this.GetItemNumber( ln_reg, 'item' )
    end if 
Next
//MessageBox('as' li_item )
this.SetItem( al_row, 'item', li_item + 1 ) 


end event

type st_1 from statictext within w_cn016_matriz_cntbl_oper
integer x = 1966
integer width = 1157
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8421376
string text = "Copiar de ?"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_1 from u_dw_cns within w_cn016_matriz_cntbl_oper
integer x = 1966
integer y = 84
integer width = 1157
integer height = 508
integer taborder = 20
string dragicon = "H:\Source\ICO\row.ico"
boolean bringtotop = true
string dataobject = "d_matriz_cntbl_oper_2_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
ii_ck[1] = 1         // columnas de lectrua de este dw

	
end event

event clicked;call super::clicked;This.SelectRow(0, False)
This.SelectRow(row, True)
THIS.SetRow(row)
Drag(Begin!)

end event

