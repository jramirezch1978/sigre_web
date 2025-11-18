$PBExportHeader$w_al319_no_atender_movproy_gen.srw
forward
global type w_al319_no_atender_movproy_gen from w_abc_master
end type
type st_1 from statictext within w_al319_no_atender_movproy_gen
end type
type st_2 from statictext within w_al319_no_atender_movproy_gen
end type
type sle_1 from singlelineedit within w_al319_no_atender_movproy_gen
end type
type sle_2 from singlelineedit within w_al319_no_atender_movproy_gen
end type
type cb_1 from commandbutton within w_al319_no_atender_movproy_gen
end type
type st_3 from statictext within w_al319_no_atender_movproy_gen
end type
end forward

global type w_al319_no_atender_movproy_gen from w_abc_master
integer width = 3694
integer height = 1724
string title = "Movimientos proyectados a no atenderse (AL319)"
string menuname = "m_only_grabar"
windowstate windowstate = maximized!
string icon = "H:\Source\Ico\Travel.ico"
event ue_anular ( )
st_1 st_1
st_2 st_2
sle_1 sle_1
sle_2 sle_2
cb_1 cb_1
st_3 st_3
end type
global w_al319_no_atender_movproy_gen w_al319_no_atender_movproy_gen

type variables
String is_doc_otr, is_oper_sal_otr, is_oper_ing_otr, is_salir

end variables

forward prototypes
public function integer of_get_param ()
end prototypes

event ue_anular();Integer j

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF
// Anulando 
dw_master.object.flag_estado[dw_master.getrow()] = '0'
dw_master.ii_update = 1


end event

public function integer of_get_param ();select doc_otr, oper_ing_otr, oper_sal_otr
	into :is_doc_otr, :is_oper_ing_otr, :is_oper_sal_otr
from logparam
where reckey = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en logparam')
	return 0
end if

if ISNull(is_doc_otr) or is_doc_otr = '' then
	MessageBox('Aviso', 'No ha definido documento de Orden de Traslado en logparam')
	return 0
end if

if ISNull(is_oper_ing_otr) or is_oper_ing_otr = '' then
	MessageBox('Aviso', 'No ha definido Movimiento de Ingreso por Traslado en logparam')
	return 0
end if

if ISNull(is_oper_sal_otr) or is_oper_sal_otr = '' then
	MessageBox('Aviso', 'No ha definido Movimiento de Salida por Traslado en logparam')
	return 0
end if

return 1
end function

on w_al319_no_atender_movproy_gen.create
int iCurrent
call super::create
if this.MenuName = "m_only_grabar" then this.MenuID = create m_only_grabar
this.st_1=create st_1
this.st_2=create st_2
this.sle_1=create sle_1
this.sle_2=create sle_2
this.cb_1=create cb_1
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_1
this.Control[iCurrent+4]=this.sle_2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.st_3
end on

on w_al319_no_atender_movproy_gen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.sle_2)
destroy(this.cb_1)
destroy(this.st_3)
end on

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

//ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
ib_log = TRUE

//idw_1.Retrieve()


end event

event ue_update_pre;call super::ue_update_pre;if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master`dw_master within w_al319_no_atender_movproy_gen
integer x = 0
integer y = 272
integer width = 3442
integer height = 820
integer taborder = 40
string dataobject = "d_abc_no_atender_movproy_gen"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,                    	
is_dwform = 'tabular'	
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this)
end event

event dw_master::doubleclicked;call super::doubleclicked;Integer 	li_opcion
Long		ll_row
string	ls_nro_otr, ls_cod_art, ls_tipo_mov, ls_cadena, ls_mensaje
Decimal	ldc_cant_proyect, ldc_cant_procesada, ldc_cant_facturada, &
			ldc_cant_proyect1, ldc_cant_procesada1

if row = 0 then return 

if this.object.tipo_doc[row] = is_doc_otr then
	// Si el documento es una Orden de Traslado debo verificar 
	// que si estoy cerrando un ingreso no debe haber ningun 
	// salida pendiente de ingreso
	
	if this.object.tipo_mov[row] = is_oper_ing_otr then
		if this.object.flag_estado[row] = '1' then
			ls_cod_art = this.object.cod_art[row]
			ls_nro_otr = this.object.nro_doc[row]
			ldc_cant_proyect1 	= Dec(this.object.cant_proyect[row])
			ldc_cant_procesada1 	= Dec(this.object.cant_procesada[row])
			
			select NVL(cant_proyect,0), NVL(cant_procesada,0), NVL(cant_facturada,0)
				into :ldc_cant_proyect, :ldc_cant_procesada, :ldc_cant_facturada
			from articulo_mov_proy
			where tipo_doc = :is_doc_otr
			  and nro_doc 	= :ls_nro_otr
			  and cod_art	= :ls_cod_art
			  and tipo_mov	= :is_oper_sal_otr for update;
			
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Error no se ha encontrado item de Salida de la Orden de Traslado')
				return
			end if
			
			if ldc_cant_facturada <> ldc_cant_procesada1 then
				update articulo_mov_proy
					set cant_facturada = :ldc_cant_procesada1
				where tipo_doc = :is_doc_otr
				  and nro_doc 	= :ls_nro_otr
				  and cod_art	= :ls_cod_art
				  and tipo_mov	= :is_oper_sal_otr;
				
				if SQLCA.SQlCode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error al intentar actualizar articulo_mov_proy', ls_mensaje)
					return
				end if
				
				commit;
				  
				ldc_cant_facturada = ldc_cant_procesada1
			end if
				
			if ldc_cant_procesada > ldc_cant_facturada then
				MessageBox('Aviso', 'No puede cerrar un ingreso de una Orden de Traslado porque tiene ingresos pendientes')
				return
			end if
				
		end if
	end if

end if

IF This.Object.flag_estado [row] = '1' THEN //
	li_opcion = MessageBox('Aviso' ,'Desea no atender este item?', Question!, YesNo!, 2)
	if li_opcion = 1 then
		This.Object.flag_estado [row] = '2'
		This.ii_update = 1
	end if
elseif This.Object.flag_estado [row] = '2' THEN //
	li_opcion = MessageBox('Aviso' ,'Desea atender este item?', Question!, YesNo!, 2)
	if li_opcion = 1 then
		This.Object.flag_estado [row] = '1'
		This.ii_update = 1
	end if
end if
end event

type st_1 from statictext within w_al319_no_atender_movproy_gen
integer x = 585
integer y = 44
integer width = 1801
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "MOVIMIENTOS PROYECTADOS A NO ATENDERSE"
boolean focusrectangle = false
end type

type st_2 from statictext within w_al319_no_atender_movproy_gen
integer x = 101
integer y = 172
integer width = 347
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
string text = "Documento:"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_al319_no_atender_movproy_gen
event ue_dobleclick pbm_lbuttondblclk
integer x = 475
integer y = 160
integer width = 169
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT distinct a.tipo_doc AS codigo_tipo_doc, " &
		  + "a.DESC_tipo_doc AS DESCRIPCION_tipo_doc " &
		  + "FROM doc_tipo a, " &
		  + "articulo_mov_proy amp " &
		  + "where amp.tipo_doc = a.tipo_doc " &
		  + "and amp.flag_estado <> '0' "
		  
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

type sle_2 from singlelineedit within w_al319_no_atender_movproy_gen
event ue_dobleclick pbm_lbuttondblclk
integer x = 654
integer y = 160
integer width = 457
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_tipo_doc

ls_tipo_doc = sle_1.text

if ls_tipo_doc = '' or IsNull(ls_tipo_doc) then
	MessageBox('Aviso', 'Ingrese primero un tipo de documento')
	return
end if

ls_sql = "SELECT distinct cod_origen AS origen, " &
		 +	"NRO_DOC AS NUMERO_DOC " &
		 + "FROM ARTICULO_MOV_PROY AMP " &
		 + "WHERE FLAG_ESTADO = '1' " &
		 + "AND TIPO_DOC = '" +ls_tipo_doc + "' " 

				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_data
end if

end event

type cb_1 from commandbutton within w_al319_no_atender_movproy_gen
integer x = 1115
integer y = 148
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;dw_master.retrieve( sle_1.text, sle_2.text)
end event

type st_3 from statictext within w_al319_no_atender_movproy_gen
integer x = 1563
integer y = 156
integer width = 1550
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
string text = "Para Cerrar el Item debe hacerle Doble Click en el registro"
boolean focusrectangle = false
end type

