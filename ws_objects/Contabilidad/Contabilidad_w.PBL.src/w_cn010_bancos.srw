$PBExportHeader$w_cn010_bancos.srw
forward
global type w_cn010_bancos from w_abc_mastdet_smpl
end type
type st_1 from statictext within w_cn010_bancos
end type
type st_2 from statictext within w_cn010_bancos
end type
end forward

global type w_cn010_bancos from w_abc_mastdet_smpl
integer width = 2569
integer height = 1520
string title = "Bancos (CN010)"
string menuname = "m_abc_mastdet_smpl"
st_1 st_1
st_2 st_2
end type
global w_cn010_bancos w_cn010_bancos

on w_cn010_bancos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_mastdet_smpl" then this.MenuID = create m_abc_mastdet_smpl
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_cn010_bancos.destroy
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

//of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cod_banco.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("cod_banco")
END IF
ls_protect=dw_detail.Describe("cod_ctabco.protect")
IF ls_protect='0' THEN
   dw_detail.of_column_protect("cod_ctabco")
END IF

end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;
dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cn010_bancos
integer x = 32
integer y = 52
integer width = 1477
integer height = 516
string dataobject = "d_banco_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		 // 'm' = master sin detalle (default), 'd' =  detalle,
is_dwform = 'tabular' // tabular, form (default)
ii_ck[1] = 1			 // columnas de lectura de este dw
ii_dk[1] = 1 	       // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
idw_det  = dw_detail
end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(string(aa_id[1]))

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cn010_bancos
integer x = 32
integer y = 628
integer width = 2432
integer height = 668
string dataobject = "d_banco_cnta_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectura de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
idw_mst  = dw_master

end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2

ls_col = trim(lower(string(dwo.name)))

choose case ls_col
	case 'cod_moneda'
		ls_sql = "select cod_moneda as codigo, descripcion as desc_moneda from moneda"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.cod_moneda[row] = ls_return1
		this.ii_update = 1
	case 'cnta_ctbl'
		ls_sql = "select cnta_ctbl as numero, desc_cnta as descripcion from cntbl_cnta where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.cnta_ctbl[row] = ls_return1
		this.ii_update = 1
	case 'cod_origen'
		ls_sql = "select cod_origen as codigo, nombre as descripcion from origen"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.cod_origen[row] = ls_return1
		this.ii_update = 1
end choose
end event

event dw_detail::itemchanged;call super::itemchanged;string ls_col, ls_return1, ls_return2
long ll_cuenta

ls_col = trim(lower(string(dwo.name)))

this.accepttext( )

choose case ls_col
	case 'cod_moneda'

		select count(cod_moneda)
			into :ll_cuenta
			from moneda
			where trim(cod_moneda) = trim(:data);
			
		if ll_cuenta <> 1 then
			this.object.cod_moneda[row] = ''
			messagebox(parent.title, 'Código de moneda no existente', stopsign!)
		end if
		
		return 2
		
	case 'cnta_ctbl'
		
		select count(cnta_ctbl)
			into :ll_cuenta
			from cntbl_cnta 
			where flag_estado = '1'
				and trim(cnta_ctbl) = trim(:data);
				
		if ll_cuenta <> 1 then
			this.object.cnta_ctbl[row] = ''
			messagebox(parent.title, 'Número de cuenta no existente', stopsign!)
		end if
		
		return 2
		
	case 'cod_origen'
		
		select count(cod_origen)
			into :ll_cuenta
			from origen
			where trim(cod_origen) = trim(:data);
			
		if ll_cuenta <> 1 then
			this.object.cod_origen[row] = ''
			messagebox(parent.title, 'Código de origen no existente', stopsign!)
		end if
		
		return 2
		
end choose
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen[al_row] = gs_origen
end event

type st_1 from statictext within w_cn010_bancos
integer x = 1554
integer y = 192
integer width = 914
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "DEFINICION DE CUENTAS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn010_bancos
integer x = 1769
integer y = 324
integer width = 494
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "BANCARIAS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

