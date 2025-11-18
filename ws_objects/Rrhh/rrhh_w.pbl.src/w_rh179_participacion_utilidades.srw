$PBExportHeader$w_rh179_participacion_utilidades.srw
forward
global type w_rh179_participacion_utilidades from w_abc_master_smpl
end type
type cb_1 from commandbutton within w_rh179_participacion_utilidades
end type
type st_4 from statictext within w_rh179_participacion_utilidades
end type
type sle_ano from singlelineedit within w_rh179_participacion_utilidades
end type
type st_5 from statictext within w_rh179_participacion_utilidades
end type
type sle_item from singlelineedit within w_rh179_participacion_utilidades
end type
type dw_distribucion from datawindow within w_rh179_participacion_utilidades
end type
type cb_2 from commandbutton within w_rh179_participacion_utilidades
end type
type gb_2 from groupbox within w_rh179_participacion_utilidades
end type
end forward

global type w_rh179_participacion_utilidades from w_abc_master_smpl
integer width = 2761
integer height = 2044
string title = "(RH179) Distribución manual de utilidades "
string menuname = "m_master_simple"
cb_1 cb_1
st_4 st_4
sle_ano sle_ano
st_5 st_5
sle_item sle_item
dw_distribucion dw_distribucion
cb_2 cb_2
gb_2 gb_2
end type
global w_rh179_participacion_utilidades w_rh179_participacion_utilidades

type variables
n_cst_wait	invo_wait
end variables

on w_rh179_participacion_utilidades.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.cb_1=create cb_1
this.st_4=create st_4
this.sle_ano=create sle_ano
this.st_5=create st_5
this.sle_item=create sle_item
this.dw_distribucion=create dw_distribucion
this.cb_2=create cb_2
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.sle_ano
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.sle_item
this.Control[iCurrent+6]=this.dw_distribucion
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.gb_2
end on

on w_rh179_participacion_utilidades.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.sle_ano)
destroy(this.st_5)
destroy(this.sle_item)
destroy(this.dw_distribucion)
destroy(this.cb_2)
destroy(this.gb_2)
end on

event ue_modify;call super::ue_modify;string ls_protect
ls_protect=dw_master.Describe("periodo.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('periodo')
END IF
ls_protect=dw_master.Describe("fecha_adelanto.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('fecha_adelanto')
END IF
end event

event ue_open_pre;call super::ue_open_pre;invo_wait = create n_cst_wait
dw_distribucion.SetTransObject(SQLCA)
end event

event ue_update_pre;call super::ue_update_pre;integer  li_row, li_periodo
datetime ld_fecha_adelanto
string   ls_flag_adelanto, ls_flag_estado
decimal  {2} ld_importe

li_row = dw_distribucion.GetRow()

IF li_row = 0 THEN
	MessageBox('Aviso', 'Defina periodo de utilidades')
	Return
END IF

li_row = dw_master.GetRow()

If li_row > 0 Then 

	ls_flag_estado = dw_distribucion.object.flag_estado[dw_distribucion.GetRow()]
	If ls_flag_estado <>'1' Then
		dw_master.ii_update = 0
		Messagebox("Aviso","Período esta bloqueado de modificar")
//		dw_master.SetColumn("flag_estado")
//		dw_master.SetFocus()
		return
	End if	
	
//	ld_importe = dw_master.GetItemNumber(li_row,"importe")
//	If isnull(ld_importe) or ld_importe = 0.00 Then
//		dw_master.ii_update = 0
//		Messagebox("Aviso","Debe ingresar monto fijo o porcentaje de adelanto")
//		dw_master.SetColumn("importe")
//		dw_master.SetFocus()
//		return
//	End if	

End if	

dw_master.of_set_flag_replicacion( )

end event

event resize;// Override
dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

dw_distribucion.width  = newwidth  - dw_distribucion.x - 10
end event

event ue_dw_share;// Override

end event

event closequery;call super::closequery;destroy invo_wait
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh179_participacion_utilidades
integer y = 688
integer width = 2656
integer height = 1196
string dataobject = "d_movimiento_utilidades_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;String ls_ano, ls_item 


ls_ano = TRIM(sle_ano.text)
ls_item = TRIM(sle_item.text)

IF IsNull(ls_ano) or ls_ano='' THEN
	MessageBox('Aviso','Defina período de utilidades')
	dw_master.DeleteRow (al_row)
END IF

IF IsNull(ls_item) or ls_item='' THEN
	MessageBox('Aviso','Defina item de utilidades')
	dw_master.DeleteRow (al_row)
END IF

this.setitem(al_row,"periodo", Long(ls_ano))
this.setitem(al_row,"item", Long(ls_item)) 
this.setitem(al_row,"retencion_judic", 0) 
this.setitem(al_row,"dias_total", 0) 
this.setitem(al_row,"dias_domingo", 0) 
this.setitem(al_row,"dias_feriado", 0) 
this.setitem(al_row,"dias_inasist", 0) 
this.setitem(al_row,"pagos", 0) 
this.setitem(al_row,"adelantos", 0) 
this.setitem(al_row,"dsctos", 0) 
this.setitem(al_row,"retencion_5categ", 0) 
this.setitem(al_row,"utilidad_asistencia", 0) 
this.setitem(al_row,"utilidad_pago", 0) 

dw_master.Modify("periodo.Protect='1~tIf(IsRowNew(),0,1)'")

end event

event dw_master::itemchanged;call super::itemchanged;Integer li_dias_total, li_dias_domingo, li_dias_feriado, li_dias_inasist, li_dias

accepttext()

choose case dwo.name 
	case 'dias_total', 'dias_domingo', 'dias_feriado', 'dias_inasist'
		li_dias_total 		= INT(dw_master.object.dias_total[row])
		li_dias_domingo 	= INT(dw_master.object.dias_domingo[row])
		li_dias_feriado 	= INT(dw_master.object.dias_feriado[row])
		li_dias_inasist 	= INT(dw_master.object.dias_inasist[row])
		
		li_dias = li_dias_total - li_dias_domingo - li_dias_feriado - li_dias_inasist
		
		dw_master.object.dias[row] = li_dias 		
end choose

end event

event dw_master::doubleclicked;call super::doubleclicked;IF this.GetRow()=0 THEN Return 

String ls_null, ls_codigo, ls_nombre, ls_name, ls_prot, ls_cod_origen  

Str_seleccionar  	lstr_seleccionar
DataWindow			ldw

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then
	return
end if

CHOOSE CASE dwo.name
	CASE 'proveedor' 				
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT VW_RRHH_CODREL_MAESTRO.CODIGO AS COD_TRABAJADOR, '&
												 +'VW_RRHH_CODREL_MAESTRO.NOMBRE AS NOMBRE_TRAB, '&
												 +'VW_RRHH_CODREL_MAESTRO.DNI AS DNI, '&
												 +'VW_RRHH_CODREL_MAESTRO.FLAG_ESTADO AS ESTADO '&
												 +'FROM VW_RRHH_CODREL_MAESTRO '
																 
		OpenWithParm(w_seleccionar,lstr_seleccionar)
					
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			this.object.proveedor[row] = lstr_seleccionar.param1[1]
			ls_codigo = lstr_seleccionar.param1[1]
			
			SELECT cod_origen 
			  INTO :ls_cod_origen 
			  FROM MAESTRO m 
			 WHERE cod_trabajador = :ls_codigo ;
			
			this.object.maestro_cod_origen[row] = ls_cod_origen 
			//this.object.nombre_trab[row] = lstr_seleccionar.param2[1] 	
			this.ii_update = 1
		END IF
END CHOOSE

end event

type cb_1 from commandbutton within w_rh179_participacion_utilidades
integer x = 914
integer y = 76
integer width = 315
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Long ll_ano, ll_item

ll_ano = Long(sle_ano.text)
ll_item = Long(sle_item.text)

IF ll_ano = 0 THEN
	MessageBox('Aviso', 'Defina período')
	Return 1
END IF 

dw_distribucion.Retrieve(ll_ano, ll_item)
dw_master.Retrieve(ll_ano, ll_item)

end event

type st_4 from statictext within w_rh179_participacion_utilidades
integer x = 55
integer y = 104
integer width = 169
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año : "
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_rh179_participacion_utilidades
integer x = 206
integer y = 92
integer width = 169
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_rh179_participacion_utilidades
integer x = 466
integer y = 104
integer width = 169
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Item : "
boolean focusrectangle = false
end type

type sle_item from singlelineedit within w_rh179_participacion_utilidades
integer x = 658
integer y = 88
integer width = 123
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type dw_distribucion from datawindow within w_rh179_participacion_utilidades
integer y = 236
integer width = 2656
integer height = 444
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "dw_utl_distribucion_ff"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_rh179_participacion_utilidades
integer x = 2057
integer y = 84
integer width = 558
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reprocesar datos"
end type

event clicked;Integer li_periodo, li_item, li_count
String ls_mensaje

try 
	
	invo_wait.of_mensaje("Procesando utilidades")
	setPointer(HourGlass!)
	
	this.enabled = false
	
	li_periodo = INTEGER(sle_ano.text)
	li_item = INTEGER(sle_item.text)
	
	SELECT count(*) 
	  INTO :li_count 
	  FROM utl_distribucion 
	 WHERE periodo = :li_periodo 
		AND item 	= :li_item ;
	
	IF li_count = 0 THEN
		MessageBox('Aviso', 'Periodo de utilidades no existe')
		Return 1
	END IF
	
	Parent.SetMicroHelp('Procesando Cálculo de Participación de Utilidades')
	
	// Procedimiento de calculo de utilidades
	DECLARE usp_rh_utl_calculo PROCEDURE FOR 
		PKG_RRHH.usp_calcula_utilidad( :li_periodo, 
												 :li_item) ;
			  
	EXECUTE usp_rh_utl_calculo ;
	
	
	IF SQLCA.SQLCode < 0 THEN 
	  ls_mensaje = SQLCA.SQLErrText
	  rollback ;
	  MessageBox("SQL error", "Error al procesar PKG_RRHH.usp_calcula_utilidad. Mensaje: " + ls_mensaje, StopSign!)
	  return
	end if
	
	commit ;
	close usp_rh_utl_calculo ;
	
	MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)
	
	
	

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, 'Error al procesar utilidades')
	
finally
	
	setPointer(Arrow!)
	
	this.enabled = true
	
	invo_wait.of_close()
	
end try


end event

type gb_2 from groupbox within w_rh179_participacion_utilidades
integer x = 37
integer y = 28
integer width = 795
integer height = 196
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Período de utilidades"
end type

