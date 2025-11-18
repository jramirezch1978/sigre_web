$PBExportHeader$w_cd501_consulta_documento.srw
forward
global type w_cd501_consulta_documento from w_cns
end type
type sle_razon_social from singlelineedit within w_cd501_consulta_documento
end type
type dw_cns from u_dw_cns within w_cd501_consulta_documento
end type
type cb_1 from commandbutton within w_cd501_consulta_documento
end type
type dw_1 from datawindow within w_cd501_consulta_documento
end type
end forward

global type w_cd501_consulta_documento from w_cns
integer width = 3040
integer height = 1548
string title = "[CD501] Consulta por Documento "
string menuname = "m_consulta"
long backcolor = 12632256
sle_razon_social sle_razon_social
dw_cns dw_cns
cb_1 cb_1
dw_1 dw_1
end type
global w_cd501_consulta_documento w_cd501_consulta_documento

event ue_open_pre;call super::ue_open_pre;of_position_window(50,50)
dw_cns.settransobject(sqlca)

end event

on w_cd501_consulta_documento.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.sle_razon_social=create sle_razon_social
this.dw_cns=create dw_cns
this.cb_1=create cb_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_razon_social
this.Control[iCurrent+2]=this.dw_cns
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_1
end on

on w_cd501_consulta_documento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_razon_social)
destroy(this.dw_cns)
destroy(this.cb_1)
destroy(this.dw_1)
end on

type sle_razon_social from singlelineedit within w_cd501_consulta_documento
integer x = 928
integer y = 24
integer width = 1234
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type dw_cns from u_dw_cns within w_cd501_consulta_documento
integer x = 37
integer y = 320
integer width = 2898
integer height = 828
integer taborder = 30
string dataobject = "d_cns_doc_movimiento"
boolean hscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

type cb_1 from commandbutton within w_cd501_consulta_documento
integer x = 2642
integer y = 64
integer width = 306
integer height = 104
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consultar"
end type

event clicked;String ls_cod_relacion, ls_tipo_doc, ls_nro_doc, ls_razon

dw_1.Accepttext()

ls_cod_relacion = dw_1.object.cod_relacion [1]
ls_tipo_doc		 =	dw_1.object.tipo_doc	    [1]
ls_nro_doc		 =	dw_1.object.nro_doc      [1]

SELECT nom_proveedor INTO :ls_razon FROM proveedor p WHERE p.proveedor = :ls_cod_relacion ;
sle_razon_social.text = ls_razon 

Parent.TriggerEvent('ue_open_pre')

dw_cns.retrieve(ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
end event

type dw_1 from datawindow within w_cd501_consulta_documento
event dw_enter pbm_dwnprocessenter
integer x = 55
integer y = 20
integer width = 855
integer height = 292
integer taborder = 10
string title = "none"
string dataobject = "d_cns_doc_relacion_tbl"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;Send(Handle(this),256,9,Long(0,0))
return 1
end event

event constructor;Settransobject(sqlca)
InsertRow(0)
end event

event doubleclicked;str_seleccionar lstr_seleccionar

CHOOSE CASE dwo.name
	 	 CASE	'tipo_doc'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT DOC_TIPO.TIPO_DOC AS CODIGO ,'&
								      				 +'DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION '&
								   					 +'FROM DOC_TIPO '

														 
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					this.object.tipo_doc [row] = lstr_seleccionar.param1[1]					
				END IF		
				
		 CASE 'cod_relacion'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO_PROVEEDOR ,'&
								      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES '&
								   					 +'FROM PROVEEDOR '

														 
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					this.object.cod_relacion [row] = lstr_seleccionar.param1[1]					
				END IF	
				
				
END CHOOSE

end event

event itemchanged;Long   ll_count
String ls_nombre

Accepttext()

choose case dwo.name
		 case 'cod_relacion'
				select Count(*) into :ll_count from codigo_relacion where (cod_relacion = :data) ;
				
				if ll_count = 0 then
					SetNull(ls_nombre)
					this.object.cod_relacion [row] = ls_nombre
					this.object.nombre       [row] = ls_nombre
					Messagebox('Aviso','Codigo de Relacion No Existe ')
					Return 1
				else
					select nombre into :ls_nombre from codigo_relacion where (cod_relacion = :data) ;
					
					this.object.nombre [row] = ls_nombre
				end if
		 case 'tipo_doc'
				
				select count(*) into :ll_count from doc_tipo where (tipo_doc = :data) ;
				
				if ll_count = 0 then
					Messagebox('Aviso','Documento No Existe ')
					Setnull(ls_nombre)
					this.object.tipo_doc [row] = ls_nombre					
					Return 1
				end if				
end choose

end event

event itemerror;return 1
end event

