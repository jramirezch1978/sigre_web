$PBExportHeader$w_ve313_cambia_fec.srw
forward
global type w_ve313_cambia_fec from w_abc_master
end type
type em_tipo_doc from editmask within w_ve313_cambia_fec
end type
type em_nro_doc from editmask within w_ve313_cambia_fec
end type
type st_1 from statictext within w_ve313_cambia_fec
end type
type cb_1 from commandbutton within w_ve313_cambia_fec
end type
end forward

global type w_ve313_cambia_fec from w_abc_master
integer width = 2949
integer height = 900
string title = "[VE313] Cambio de fecha de presentación"
string menuname = "m_mantenimiento_lista"
em_tipo_doc em_tipo_doc
em_nro_doc em_nro_doc
st_1 st_1
cb_1 cb_1
end type
global w_ve313_cambia_fec w_ve313_cambia_fec

on w_ve313_cambia_fec.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_lista" then this.MenuID = create m_mantenimiento_lista
this.em_tipo_doc=create em_tipo_doc
this.em_nro_doc=create em_nro_doc
this.st_1=create st_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_tipo_doc
this.Control[iCurrent+2]=this.em_nro_doc
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_1
end on

on w_ve313_cambia_fec.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_tipo_doc)
destroy(this.em_nro_doc)
destroy(this.st_1)
destroy(this.cb_1)
end on

type dw_master from w_abc_master`dw_master within w_ve313_cambia_fec
integer x = 18
integer y = 172
integer width = 2848
integer height = 520
string dataobject = "d_abc_cambio_fecha_vencim_ff"
end type

event dw_master::itemchanged;call super::itemchanged;String ls_forma_pago , ls_tipo_doc, ls_nro_doc
Date   ld_fecha_documento, ld_fecha_vencimiento, ld_fecha_documento_old
Decimal{3} ldc_tasa_cambio
Integer    li_dias_venc, li_opcion, li_num_dir 
Long       ll_nro_libro,ll_count


ld_fecha_documento_old = Date(This.object.fecha_documento [row])

Accepttext()

CHOOSE CASE dwo.name
	CASE 'fecha_presentacion'
		  ls_forma_pago = This.Object.forma_pago [row]			
			
		  IF Not(Isnull(ls_forma_pago) OR Trim(ls_forma_pago) = '') THEN
				li_dias_venc = dw_master.Getitemnumber(dw_master.getrow(),'forma_pago_dias_vencimiento')
			
				IF li_dias_venc > 0 THEN
					li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
					IF li_opcion = 1 THEN
						ld_fecha_vencimiento = Relativedate(DATE(This.object.fecha_presentacion[row]),li_dias_venc)
						This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento
					END IF
				END IF
			END IF
			
END CHOOSE



end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
end event

event dw_master::doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String     ls_name ,ls_prot, ls_forma_pago
Date       ld_fecha_presentacion, ld_fecha_vencimiento
Integer 	  li_dias_venc, li_opcion

//str_seleccionar lstr_seleccionar
Datawindow		 ldw	
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
	CASE  'fecha_presentacion'
			ld_fecha_presentacion = Date(This.Object.fecha_presentacion [row])				
			ldw = This
			f_call_calendar(ldw,dwo.name,dwo.coltype, row)
			
			ls_forma_pago = This.Object.forma_pago [row]
			
			IF Not(Isnull(ls_forma_pago) OR Trim(ls_forma_pago) = '') THEN
				li_dias_venc = dw_master.Getitemnumber(dw_master.getrow(),'forma_pago_dias_vencimiento')
			
				IF li_dias_venc > 0 THEN
					li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
					IF li_opcion = 1 THEN
						ld_fecha_vencimiento = Relativedate(DATE(This.object.fecha_presentacion[row]),li_dias_venc)
						This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento
					END IF
				END IF
			ELSE
				ld_fecha_vencimiento = This.object.fecha_presentacion[row]
			END IF

			This.ii_update = 1
				
END CHOOSE

end event

type em_tipo_doc from editmask within w_ve313_cambia_fec
integer x = 475
integer y = 36
integer width = 160
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "!!!!"
end type

type em_nro_doc from editmask within w_ve313_cambia_fec
integer x = 649
integer y = 36
integer width = 343
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "!!!!!!!!!!"
end type

type st_1 from statictext within w_ve313_cambia_fec
integer x = 41
integer y = 64
integer width = 343
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
string text = "Documento :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ve313_cambia_fec
integer x = 1042
integer y = 32
integer width = 238
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;String ls_tipo_doc, ls_nro_doc
Long ll_count

ls_tipo_doc = TRIM(em_tipo_doc.text)
ls_nro_doc = TRIM(em_nro_doc.text)

SELECT count(*) 
  INTO :ll_count 
  FROM cntas_cobrar cc 
 WHERE cc.tipo_doc=:ls_tipo_doc 
   AND cc.nro_doc=:ls_nro_doc ;

IF ll_count > 0 THEN
	dw_master.retrieve(ls_tipo_doc, ls_nro_doc)
ELSE
	MessageBox('Aviso','Registro no existe')
END IF 
end event

