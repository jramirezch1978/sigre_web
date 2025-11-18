$PBExportHeader$w_ope019_labor_herramienta.srw
forward
global type w_ope019_labor_herramienta from w_abc_mastdet_smpl
end type
type st_2 from statictext within w_ope019_labor_herramienta
end type
type st_campo from statictext within w_ope019_labor_herramienta
end type
type dw_1 from datawindow within w_ope019_labor_herramienta
end type
end forward

global type w_ope019_labor_herramienta from w_abc_mastdet_smpl
integer width = 2597
integer height = 2132
string title = "Herramientas por labor (OPE019)"
string menuname = "m_master_sin_lista"
st_2 st_2
st_campo st_campo
dw_1 dw_1
end type
global w_ope019_labor_herramienta w_ope019_labor_herramienta

type variables
Datawindowchild idw_child_und, idw_child_und2
String  is_col = 'cod_labor'
Integer ii_ik[]
str_parametros ist_datos
end variables

on w_ope019_labor_herramienta.create
int iCurrent
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
this.st_2=create st_2
this.st_campo=create st_campo
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_campo
this.Control[iCurrent+3]=this.dw_1
end on

on w_ope019_labor_herramienta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_campo)
destroy(this.dw_1)
end on

event ue_modify;call super::ue_modify;String ls_protect

ls_protect=dw_detail.Describe("cod_art.protect")
IF ls_protect='0' THEN
   dw_detail.of_column_protect("cod_art")
END IF

end event

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)

//Help
ii_help = 1
ii_lec_mst = 0
//dw_master.retrieve(gs_user)
dw_master.retrieve()
end event

event ue_print;call super::ue_print;//String      ls_cadena
//Str_cns_pop lstr_cns_pop
//
//IF idw_1.getrow() = 0 THEN RETURN
//
//ls_cadena = idw_1.Object.cod_fase[idw_1.getrow()]
//
//IF Isnull(ls_cadena) OR Trim(ls_cadena) = '' THEN RETURN
//
//lstr_cns_pop.arg[1] = ls_cadena
//lstr_cns_pop.arg[2] = gs_empresa
//lstr_cns_pop.arg[3] = gs_user
//lstr_cns_pop.arg[4] = ''
//
//
//lstr_cns_pop.dataobject = 'd_rpt_labor_fase_etapa_ff'
//lstr_cns_pop.title = 'Reporte de Etapas Por Fase'
//lstr_cns_pop.width  = 3650
//lstr_cns_pop.height = 1950
//
//OpenSheetWithParm(w_rpt_pop, lstr_cns_pop, This, 2, Layered!)
end event

event ue_update_pre;call super::ue_update_pre;//dw_master.accepttext()
dw_detail.accepttext()


////--VERIFICACION Y ASIGNACION DE FASE Y ETAPA
//IF f_row_Processing( dw_master, "grid") <> true then	
//	ib_update_check = False	
//	return
//ELSE
//	ib_update_check = True
//END IF
//
//--VERIFICACION Y ASIGNACION DE FASE Y ETAPA

IF f_row_Processing( dw_detail, "grid") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

//dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ope019_labor_herramienta
integer x = 0
integer y = 188
integer width = 2085
integer height = 992
string dataobject = "d_lista_labor_tbl"
boolean vscrollbar = true
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;//idw_det.retrieve(aa_id[1],gs_user)
idw_det.retrieve(aa_id[1])
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row


li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col    = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color  = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_campo.text = "Orden: " + is_col
	dw_1.reset()
	dw_1.InsertRow(0)
	dw_1.SetFocus()
//ELSE
//	ll_row = this.GetRow()
//	
//	if ll_row > 0 then		
//		Any     la_id
//		Integer li_x, li_y
//		String  ls_tipo
//
//		FOR li_x = 1 TO UpperBound(ii_ik)			
//			la_id = dw_master.object.data.primary.current[dw_master.getrow(), ii_ik[li_x]]
//			// tipo del dato
//			ls_tipo = This.Describe("#" + String(ii_ik[li_x]) + ".ColType")
//
//			IF LEFT( ls_tipo,1) = 'd' THEN
//				ist_datos.field_ret[li_x] = string ( la_id)
//			ELSEIF LEFT( ls_tipo,1) = 'c'  THEN
//				ist_datos.field_ret[li_x] = la_id
//			END IF
//			
//		NEXT
//		
//		ist_datos.titulo = "s"		
//		
//	//	CloseWithReturn( parent, ist_datos)
//	END IF
END IF

// Si el evento es disparado desde otro objeto que esta activo, este evento no recono
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ope019_labor_herramienta
integer x = 0
integer y = 1304
integer width = 2528
integer height = 576
string dataobject = "d_abc_labor_herramienta_tbl"
boolean vscrollbar = true
boolean livescroll = false
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 2				// columnas de lectura de este dw
ii_rk[1] = 1 
end event

event dw_detail::itemerror;call super::itemerror;Return 1
end event

event dw_detail::itemchanged;call super::itemchanged;//String ls_codigo,ls_descripcion
//Long 	 ll_count
//
//Accepttext()
//
//choose case dwo.name
//	 	 case 'ot_adm'
//				
//				select count(*) 
//				  into :ll_count
//				  from vw_ope_ot_adm_usr
//				 where (ot_adm  = :data    ) and
//				 		 (cod_usr = :gs_user ) ;
//				
//				if ll_count = 0 then
//					SetNull(ls_codigo)
//					Messagebox('Aviso','OT Administracion No Existe Verifique')
//					This.object.ot_adm      [row] = ls_codigo
//					This.object.descripcion [row] = ls_codigo
//					Return 1	
//				else
//					select descripcion into :ls_descripcion from ot_administracion where ot_adm =:data ;
//					
//					This.object.descripcion [row] = ls_descripcion
//					
//				end if		
//				 		 
//
//end choose
//
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
	 CASE 'cod_art'
		
			lstr_seleccionar.s_seleccion = 'S'
			lstr_seleccionar.s_sql = 'SELECT ARTICULO.COD_ART AS CODIGO, '&   
											 +'ARTICULO.DESC_ART AS DESCRIPCION, '&   
											 +'ARTICULO.UND AS UNIDAD '&   
											 +'FROM  ARTICULO '&
											 +'WHERE ARTICULO.FLAG_ESTADO = '+"'"+'1'+"'"

			OpenWithParm(w_seleccionar,lstr_seleccionar)
			
			IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			IF lstr_seleccionar.s_action = "aceptar" THEN
				
				Setitem(row,'cod_art',lstr_seleccionar.param1[1])
				Setitem(row,'articulo_desc_art',lstr_seleccionar.param2[1])
				Setitem(row,'articulo_und',lstr_seleccionar.param3[1])
				ii_update = 1
			END IF
END CHOOSE


end event

type st_2 from statictext within w_ope019_labor_herramienta
integer x = 622
integer y = 1208
integer width = 754
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Herramientas por labor"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = StyleShadowBox!
boolean focusrectangle = false
end type

type st_campo from statictext within w_ope019_labor_herramienta
integer x = 27
integer y = 52
integer width = 379
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ayuda:"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_ope019_labor_herramienta
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 471
integer y = 36
integer width = 1147
integer height = 84
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;dw_master.triggerevent(doubleclicked!)
Return 1
end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_master.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_master.scrollnextrow()	
end if
ll_row = dw_master.Getrow()

Return ll_row
end event

event constructor;Long ll_reg

ll_reg = this.insertrow(0)

end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_master.selectrow(0, false)
			dw_master.selectrow(ll_fila,true)
			dw_master.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)
end event

