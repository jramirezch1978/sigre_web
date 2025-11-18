$PBExportHeader$w_cn014_matriz_contable.srw
forward
global type w_cn014_matriz_contable from w_abc_mastdet_smpl
end type
type st_1 from statictext within w_cn014_matriz_contable
end type
type st_2 from statictext within w_cn014_matriz_contable
end type
end forward

global type w_cn014_matriz_contable from w_abc_mastdet_smpl
integer width = 2839
integer height = 1700
string title = "Plantilla de Operaciones Contables (CN014)"
string menuname = "m_abc_master_smpl"
st_1 st_1
st_2 st_2
end type
global w_cn014_matriz_contable w_cn014_matriz_contable

on w_cn014_matriz_contable.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_cn014_matriz_contable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

//of_position_window(0,0)	// Posicionar la ventana en forma fija
//Log de Seguridad
ib_log = TRUE


end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("matriz.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("matriz")
END IF
ls_protect=dw_detail.Describe("matriz.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("matriz")
END IF
ls_protect=dw_detail.Describe("item.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("item")
END IF
end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cn014_matriz_contable
integer x = 59
integer y = 168
integer width = 2670
string dragicon = "H:\Source\ICO\row2.ico"
string dataobject = "d_matriz_cntbl_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::clicked;call super::clicked;Drag(Begin!)
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cn014_matriz_contable
integer x = 59
integer y = 844
integer width = 2670
integer height = 620
string dataobject = "d_matriz_cntbl_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
//ii_rk[1] = 15 	      // columnas que recibimos del master
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle
This.SetRowFocusIndicator(Hand!)

end event

event dw_detail::ue_insert_pre(long al_row);call super::ue_insert_pre;String ls_matriz
long ln_reg 
integer li_item
li_item = 0 
For ln_reg = 1 to this.RowCount()
	 if this.GetItemNumber( ln_reg, 'item' ) > li_item then 
		 li_item = this.GetItemNumber( ln_reg, 'item' )
    end if 
Next
//MessageBox('as' li_item )
this.SetItem( al_row, 'item', li_item + 1 ) 
ln_reg = dw_master.GetRow()
ls_matriz = dw_master.GetItemString( ln_reg, 'matriz' )
this.SetItem( al_row, 'matriz', ls_matriz ) 
	 
end event

event dw_detail::clicked;call super::clicked;This.SelectRow(0, False)
end event

event dw_detail::dragdrop;call super::dragdrop;messagebox("Ingrese aqui","Ingrese aqui")
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
		 CASE 'cnta_ctbl'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_ctbl',lstr_seleccionar.param1[1])
					//Setitem(row,'cntbl_cnta_abrev_cnta',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
		CASE 'cencos'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS, '&
														 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&
														 +'FROM CENTROS_COSTO ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cencos',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
		CASE 'cod_ctabco'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT BANCO_CNTA.COD_CTABCO AS BANCO, '&
														 +'BANCO_CNTA.DESCRIPCION AS DESCRIPCION '&
														 +'FROM BANCO_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_ctabco',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
END CHOOSE

end event

type st_1 from statictext within w_cn014_matriz_contable
integer x = 978
integer y = 36
integer width = 832
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "T I T U L O "
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn014_matriz_contable
integer x = 978
integer y = 712
integer width = 832
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "D E T A L L E"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

