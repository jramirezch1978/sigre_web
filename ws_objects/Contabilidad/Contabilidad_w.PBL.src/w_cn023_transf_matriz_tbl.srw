$PBExportHeader$w_cn023_transf_matriz_tbl.srw
forward
global type w_cn023_transf_matriz_tbl from w_abc_mastdet_lstmst
end type
type st_1 from statictext within w_cn023_transf_matriz_tbl
end type
type st_2 from statictext within w_cn023_transf_matriz_tbl
end type
type st_3 from statictext within w_cn023_transf_matriz_tbl
end type
end forward

global type w_cn023_transf_matriz_tbl from w_abc_mastdet_lstmst
integer width = 3374
integer height = 1696
string title = "Matriz de Transferencias de Asientos (CN023)"
string menuname = "m_abc_mastdet_smpl"
st_1 st_1
st_2 st_2
st_3 st_3
end type
global w_cn023_transf_matriz_tbl w_cn023_transf_matriz_tbl

type variables

end variables

on w_cn023_transf_matriz_tbl.create
int iCurrent
call super::create
if this.MenuName = "m_abc_mastdet_smpl" then this.MenuID = create m_abc_mastdet_smpl
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
end on

on w_cn023_transf_matriz_tbl.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
end on

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

//of_position_window(0,0)       			// Posicionar la ventana en forma fija
dw_lista.Retrieve()
//ii_help = 101           					// help topic
//ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
//ii_consulta = 1                      // 1 = la lista de consulta es gobernada por el sistema de acceso

end event

event ue_dw_share();call super::ue_dw_share;dw_lista.of_share_lista(dw_master)
end event

event resize;// Override
end event

type dw_master from w_abc_mastdet_lstmst`dw_master within w_cn023_transf_matriz_tbl
integer x = 1326
integer y = 116
integer width = 2002
integer height = 832
string dataobject = "d_transf_matriz_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
ii_dk[1] = 1 		      // columnas que se pasan al detalle
ii_dk[2] = 2	 	      // columnas que se pasan al detalle

idw_mst = dw_master

end event

event dw_master::doubleclicked;call super::doubleclicked;// Ventanas de ayuda
IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cencos_origen'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS, '&
														 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&
														 +'FROM CENTROS_COSTO ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cencos_origen',lstr_seleccionar.param1[1])
					Setitem(row,'desc_cencos',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
		 CASE 'cnta_prsp_ini'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP AS CNTA_PRSP, '&
														 +'PRESUPUESTO_CUENTA.DESCRIPCION AS DESCRIPCION '&
														 +'FROM PRESUPUESTO_CUENTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_prsp_ini',lstr_seleccionar.param1[1])
					Setitem(row,'ppto_cta_descrip_ini',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
		 CASE 'cnta_prsp_fin'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP AS CNTA_PRSP, '&
														 +'PRESUPUESTO_CUENTA.DESCRIPCION AS DESCRIPCION '&
														 +'FROM PRESUPUESTO_CUENTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_prsp_fin',lstr_seleccionar.param1[1])
					Setitem(row,'ppto_cta_descrip_fin',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
		
		 CASE 'cnta_cntbl_debe'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_cntbl_debe',lstr_seleccionar.param1[1])
					Setitem(row,'abrev_cnta_debe',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
		 CASE 'cnta_cntbl_haber'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_cntbl_haber',lstr_seleccionar.param1[1])
					Setitem(row,'abrev_cnta_haber',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF

END CHOOSE

end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2])
end event

event dw_master::clicked;call super::clicked;idw_mst.il_row = dw_master.GetRow()
end event

type dw_detail from w_abc_mastdet_lstmst`dw_detail within w_cn023_transf_matriz_tbl
integer x = 1326
integer y = 1060
integer width = 2002
integer height = 444
string dataobject = "d_transf_matriz_det_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ss = 1 						// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true	// indica si hace cascada con el detalle, al deletear
ii_ck[1] = 1					// columnas de lectura de este dw
ii_ck[2] = 2					// columnas de lectura de este dw
ii_ck[3] = 3					// columnas de lectura de este dw
ii_rk[1] = 1 	      		// columnas que recibimos del master
ii_rk[3] = 3 	    			// columnas que recibimos del master
idw_mst  = dw_master
idw_det  = dw_detail

end event

event dw_detail::ue_insert_pre(long al_row);call super::ue_insert_pre;Long ll_row, ll_nro_sec, ll_item

ll_row = dw_master.GetRow()
ll_nro_sec = dw_master.GetItemNumber(ll_row, 'nro_sec')
ll_item = dw_master.GetItemNumber(ll_row, 'item')

this.SetItem(al_row, 'nro_sec', ll_nro_sec )
this.SetItem(al_row, 'item', ll_item )
this.SetItem(al_row, 'flag_fin_sec', 'D' )

end event

event dw_detail::doubleclicked;// Ventanas de ayuda
IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cencos_destino'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS, '&
														 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&
														 +'FROM CENTROS_COSTO ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cencos_destino',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
		 CASE 'cnta_prsp'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP AS CNTA_PRSP, '&
														 +'PRESUPUESTO_CUENTA.DESCRIPCION AS DESCRIPCION '&
														 +'FROM PRESUPUESTO_CUENTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_prsp',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
		
		 CASE 'proveedor'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO, '&
														 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE '&
														 +'FROM PROVEEDOR ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'proveedor',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF

END CHOOSE


end event

type dw_lista from w_abc_mastdet_lstmst`dw_lista within w_cn023_transf_matriz_tbl
integer x = 5
integer y = 116
integer width = 1303
integer height = 1392
string dataobject = "d_transf_matriz_lista_tbl"
end type

event dw_lista::constructor;call super::constructor;ii_ck[1] = 1          // columnas de lectura de este dw
ii_ck[2] = 2          // columnas de lectura de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle


end event

event dw_lista::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_lista::ue_output(long al_row);call super::ue_output;dw_master.ScrollToRow(al_row)

end event

event dw_lista::ue_retrieve_det_pos(any aa_id[]);dw_master.retrieve(aa_id[1],aa_id[2])
end event

event dw_lista::clicked;call super::clicked;Long ll_nro_sec, ll_item
IF row > 0 then
	ll_nro_sec = this.GetItemNumber( row, 'nro_sec')
	ll_item = this.GetItemNumber( row, 'item')
	dw_detail.Retrieve( ll_nro_sec, ll_item )
end if

end event

type st_1 from statictext within w_cn023_transf_matriz_tbl
integer x = 1618
integer y = 36
integer width = 1422
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
string text = "DATOS GENERALES DE SECUENCIA DE TRANSFERENCIA"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn023_transf_matriz_tbl
integer x = 1723
integer y = 972
integer width = 1207
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
string text = "DETALLE DE SECUENCIA DE TRANSFERENCIA"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn023_transf_matriz_tbl
integer x = 485
integer y = 44
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
string text = "SECUENCIAS"
alignment alignment = center!
boolean focusrectangle = false
end type

