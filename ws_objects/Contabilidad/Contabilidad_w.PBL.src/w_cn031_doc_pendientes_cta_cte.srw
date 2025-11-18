$PBExportHeader$w_cn031_doc_pendientes_cta_cte.srw
forward
global type w_cn031_doc_pendientes_cta_cte from w_abc_master_lstmst
end type
type sle_codrel from singlelineedit within w_cn031_doc_pendientes_cta_cte
end type
type st_1 from statictext within w_cn031_doc_pendientes_cta_cte
end type
type sle_tipo_doc from singlelineedit within w_cn031_doc_pendientes_cta_cte
end type
type st_2 from statictext within w_cn031_doc_pendientes_cta_cte
end type
type st_3 from statictext within w_cn031_doc_pendientes_cta_cte
end type
type sle_nro_doc from singlelineedit within w_cn031_doc_pendientes_cta_cte
end type
type cb_1 from commandbutton within w_cn031_doc_pendientes_cta_cte
end type
type gb_1 from groupbox within w_cn031_doc_pendientes_cta_cte
end type
end forward

global type w_cn031_doc_pendientes_cta_cte from w_abc_master_lstmst
integer width = 3703
integer height = 1624
string title = "Documentos pendientes de cuenta corriente (CN031)"
string menuname = "m_abc_master_smpl"
event ue_cancelar ( )
sle_codrel sle_codrel
st_1 st_1
sle_tipo_doc sle_tipo_doc
st_2 st_2
st_3 st_3
sle_nro_doc sle_nro_doc
cb_1 cb_1
gb_1 gb_1
end type
global w_cn031_doc_pendientes_cta_cte w_cn031_doc_pendientes_cta_cte

event ue_cancelar();rollback ;
dw_master.reset()

end event

on w_cn031_doc_pendientes_cta_cte.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.sle_codrel=create sle_codrel
this.st_1=create st_1
this.sle_tipo_doc=create sle_tipo_doc
this.st_2=create st_2
this.st_3=create st_3
this.sle_nro_doc=create sle_nro_doc
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_codrel
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_tipo_doc
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_nro_doc
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_cn031_doc_pendientes_cta_cte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_codrel)
destroy(this.st_1)
destroy(this.sle_tipo_doc)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_nro_doc)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;dw_lista.of_sort_lista()
dw_master.BorderStyle = StyleRaised!			// indicar dw_detail como no activado
dw_master.of_protect()         		// bloquear modificaciones 
of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
String ls_protect
ls_protect=dw_master.Describe("cod_relacion.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("cod_relacion")
END IF
ls_protect=dw_master.Describe("tipo_doc.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("tipo_doc")
END IF
ls_protect=dw_master.Describe("nro_doc.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("nro_doc")
END IF


end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cod_relacion.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("cod_relacion")
END IF
ls_protect=dw_master.Describe("tipo_doc.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("tipo_doc")
END IF
ls_protect=dw_master.Describe("nro_doc.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("nro_doc")
END IF

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_lstmst`dw_master within w_cn031_doc_pendientes_cta_cte
integer x = 1838
integer y = 540
integer width = 1801
integer height = 876
string dataobject = "d_abc_doc_pendientes_ff"
end type

event dw_master::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
idw_mst  = dw_master

end event

event dw_master::resize;call super::resize;//
end event

event dw_master::doubleclicked;call super::doubleclicked;Datawindow ldw
ldw = This
if dwo.type<>'column' THEN RETURN 1

// Ventanas de ayuda
IF Getrow() = 0 THEN Return
String ls_name, ls_prot
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
														 +'FROM CNTBL_CNTA ' &
														 +'WHERE CNTBL_CNTA.NIV_CNTA = 4'
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_ctbl',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF

		 CASE 'cod_relacion'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO, '&
														 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE '&
														 +'FROM PROVEEDOR ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF

		CASE 'tipo_doc'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT DOC_TIPO.TIPO_DOC AS TIPO, '&
														 +'DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION '&
														 +'FROM DOC_TIPO ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'tipo_doc',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
				
END CHOOSE

end event

event dw_master::itemchanged;call super::itemchanged;String ls_cuenta
Decimal ll_count


this.accepttext()

CHOOSE CASE dwo.name
   CASE 'cnta_ctbl'	
	  ls_cuenta = DATA
	  select count(*) into :ll_count from cntbl_cnta where cnta_ctbl = :ls_cuenta;
	  IF ll_count=0 then
		  messagebox('Aviso', 'Cuenta contable no existe')
		  return 1
	  end if
	  ii_update=1
  CASE 'cod_relacion'	
	  ls_cuenta = DATA
	  select count(*) into :ll_count from proveedor where proveedor = :ls_cuenta;
	  IF ll_count=0 then
		  messagebox('Aviso', 'Codigo de relacion no existe')
		  return 1
	  end if
	  ii_update=1
	  	  
  CASE 'tipo_doc'	
	  ls_cuenta = DATA
	  select count(*) into :ll_count from doc_tipo where tipo_doc = :ls_cuenta;
	  IF ll_count=0 then
		  messagebox('Aviso', 'Tipo de documento no existe')
		  return 1
	  end if
	  ii_update=1
END CHOOSE	

end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;string ls_flag_tabla
ls_flag_tabla = '5' // Caja bancos
this.SetItem(al_row, 'flag_tabla', ls_flag_tabla )

end event

type dw_lista from w_abc_master_lstmst`dw_lista within w_cn031_doc_pendientes_cta_cte
integer width = 1806
integer height = 1408
string dataobject = "d_abc_doc_pendientes_tbl"
end type

event dw_lista::constructor;call super::constructor;ii_ck[1] = 1          // columnas de lectura de este dw

end event

event dw_lista::resize;call super::resize;//
end event

type sle_codrel from singlelineedit within w_cn031_doc_pendientes_cta_cte
integer x = 2610
integer y = 136
integer width = 402
integer height = 64
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cn031_doc_pendientes_cta_cte
integer x = 1947
integer y = 136
integer width = 613
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Código de relación:"
boolean focusrectangle = false
end type

type sle_tipo_doc from singlelineedit within w_cn031_doc_pendientes_cta_cte
integer x = 2610
integer y = 232
integer width = 178
integer height = 64
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cn031_doc_pendientes_cta_cte
integer x = 1947
integer y = 232
integer width = 613
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Tipo de documento:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn031_doc_pendientes_cta_cte
integer x = 1947
integer y = 328
integer width = 613
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro. de documento:"
boolean focusrectangle = false
end type

type sle_nro_doc from singlelineedit within w_cn031_doc_pendientes_cta_cte
integer x = 2610
integer y = 328
integer width = 402
integer height = 64
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cn031_doc_pendientes_cta_cte
integer x = 3232
integer y = 208
integer width = 343
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ubicar"
end type

event clicked;long ll_reg, ll_count
String ls_cuenta, ls_codrel, ls_tipo_doc, ls_nro_doc
ls_codrel = sle_codrel.text 
ls_tipo_doc = sle_tipo_doc.text
ls_nro_doc = sle_nro_doc.text

messagebox('Aviso', 'Verifique si documento buscado lo encontro')

ls_cuenta = " cod_relacion >= '" + ls_codrel + "'" + "AND tipo_doc >= '" + ls_tipo_doc + "'" + "AND nro_doc >= '" + ls_nro_doc + "'"
Parent.SetMicroHelp( ls_cuenta )
ll_reg = dw_lista.Find( ls_cuenta, 1, dw_master.RowCount() )
dw_lista.ScrollToRow(ll_reg)
dw_lista.SelectRow(0, false)
dw_lista.SelectRow(ll_reg, true)
dw_master.ScrollToRow(ll_reg)

end event

type gb_1 from groupbox within w_cn031_doc_pendientes_cta_cte
integer x = 1906
integer y = 64
integer width = 1184
integer height = 364
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros de búsqueda"
end type

