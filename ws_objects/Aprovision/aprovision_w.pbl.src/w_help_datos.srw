$PBExportHeader$w_help_datos.srw
forward
global type w_help_datos from window
end type
type pb_2 from picturebutton within w_help_datos
end type
type pb_1 from picturebutton within w_help_datos
end type
type dw_master from datawindow within w_help_datos
end type
end forward

global type w_help_datos from window
integer width = 2030
integer height = 296
boolean titlebar = true
string title = "Ventana de Ayuda"
windowtype windowtype = response!
long backcolor = 67108864
pb_2 pb_2
pb_1 pb_1
dw_master dw_master
end type
global w_help_datos w_help_datos

type variables
str_parametros istr_param
end variables

on w_help_datos.create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_master=create dw_master
this.Control[]={this.pb_2,&
this.pb_1,&
this.dw_master}
end on

on w_help_datos.destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_master)
end on

event open;f_centrar(this)

IF Not(Isnull(Message.PowerObjectParm))THEN
	istr_param = Message.PowerObjectParm
	dw_master.DataObject = istr_param.dw1
	dw_master.Settransobject(sqlca)
	dw_master.InsertRow(0)
	dw_master.SetFocus()
	dw_master.SetColumn(1)
END IF
end event

type pb_2 from picturebutton within w_help_datos
integer x = 1673
integer y = 36
integer width = 329
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "H:\Source\Gif\doorin.gif"
alignment htextalign = left!
end type

event clicked;istr_param.titulo = 'n'
CloseWithReturn( parent, istr_param)
end event

type pb_1 from picturebutton within w_help_datos
integer x = 1321
integer y = 36
integer width = 329
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "H:\Source\Gif\boton-interes2.gif"
alignment htextalign = left!
end type

event clicked;String ls_cod_relacion,ls_tipo_doc,ls_nro_doc,ls_origen,ls_cegreso
Long   ll_nro_doc

dw_master.Accepttext()


CHOOSE CASE istr_param.opcion
		 CASE 1 //CNTAS X COBRAR
				ls_tipo_doc = dw_master.object.tipo_doc [1]
				ls_nro_doc  = dw_master.object.nro_doc  [1]
				
				istr_param.dw_m.Retrieve(ls_tipo_doc,ls_nro_doc)
				
				IF istr_param.dw_m.Rowcount() = 0 THEN
					SetNull(ls_tipo_doc)
					SetNull(ls_nro_doc)
					dw_master.object.tipo_doc [1] = ls_tipo_doc
					dw_master.object.nro_doc  [1] = ls_nro_doc
					Messagebox('Aviso','Documento No Existe!')
					dw_master.SetFocus()
					dw_master.SetColumn(1)
					Return
				ELSE
					istr_param.titulo = 's'
					CloseWithReturn( parent, istr_param)
				END IF
				
		 CASE 2 //CNTAS X PAGAR
				ls_cod_relacion = dw_master.object.cod_relacion [1]
				ls_tipo_doc 	 = dw_master.object.tipo_doc 		[1]
				ls_nro_doc  	 = dw_master.object.nro_doc  		[1]
				
				istr_param.dw_m.Retrieve(ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
				
				IF istr_param.dw_m.Rowcount() = 0 THEN
					SetNull(ls_cod_relacion)
					SetNull(ls_tipo_doc)
					SetNull(ls_nro_doc)
					dw_master.object.cod_relacion [1] = ls_cod_relacion
					dw_master.object.tipo_doc 		[1] = ls_tipo_doc
					dw_master.object.nro_doc  		[1] = ls_nro_doc
					Messagebox('Aviso','Documento No Existe!')
					dw_master.SetFocus()
					dw_master.SetColumn(1)
					Return
				ELSE
					istr_param.titulo = 's'
					CloseWithReturn( parent, istr_param)
				END IF
		 CASE 3 //LETRAS X COBRAR	, SOLICITUD GIRO
				ls_origen  = dw_master.object.origen  [1]
				ls_nro_doc = dw_master.object.nro_doc [1]
				
				istr_param.dw_m.Retrieve(ls_origen,ls_nro_doc)
				
				IF istr_param.dw_m.Rowcount() = 0 THEN
					SetNull(ls_origen)
					SetNull(ls_nro_doc)
					dw_master.object.origen  [1] = ls_origen
					dw_master.object.nro_doc [1] = ls_nro_doc
					Messagebox('Aviso','Documento No Existe!')
					dw_master.SetFocus()
					dw_master.SetColumn(1)
					Return
				ELSE
					istr_param.titulo = 's'
					CloseWithReturn( parent, istr_param)
				END IF
				
       CASE 4 //LETRAS X PAGAR
				ls_cod_relacion = dw_master.object.cod_relacion [1]
				ls_nro_doc 		 = dw_master.object.nro_doc 	   [1]
				
				istr_param.dw_m.Retrieve(ls_cod_relacion,ls_nro_doc)
				
				IF istr_param.dw_m.Rowcount() = 0 THEN
					SetNull(ls_cod_relacion)
					SetNull(ls_nro_doc)
					dw_master.object.cod_relacion [1] = ls_cod_relacion
					dw_master.object.nro_doc      [1] = ls_nro_doc
					Messagebox('Aviso','Documento No Existe!')
					dw_master.SetFocus()
					dw_master.SetColumn(1)
					Return
				ELSE
					istr_param.titulo = 's'
					CloseWithReturn( parent, istr_param)
				END IF
		 CASE 5 //CAJA BANCOS
				ls_origen  = dw_master.object.origen  [1]
				ll_nro_doc = dw_master.object.nro_doc [1]
				
				istr_param.dw_m.Retrieve(ls_origen,ll_nro_doc,istr_param.string1)
				
				IF istr_param.dw_m.Rowcount() = 0 THEN
					SetNull(ls_origen)
					SetNull(ll_nro_doc)
					dw_master.object.origen  [1] = ls_origen
					dw_master.object.nro_doc [1] = ll_nro_doc
					Messagebox('Aviso','Documento No Existe!')
					dw_master.SetFocus()
					dw_master.SetColumn(1)
					Return
				ELSE
					istr_param.titulo = 's'
					CloseWithReturn( parent, istr_param)
				END IF
				
		CASE 6 //COMPROBANTE DE EGRESOS
			  SELECT comprobante_egr INTO :ls_cegreso FROM finparam WHERE reckey = '1' ; 			  	
			  
			  ls_cod_relacion = dw_master.object.cod_relacion [1]
			  ls_nro_doc		= dw_master.object.nro_doc		  [1]
			  
			  
			  istr_param.dw_m.Retrieve(ls_cod_relacion,ls_cegreso,ls_nro_doc)
			  
			  IF istr_param.dw_m.Rowcount() = 0 THEN
					SetNull(ls_cod_relacion)
					SetNull(ls_nro_doc)
					dw_master.object.cod_relacion  [1] = ls_cod_relacion
					dw_master.object.nro_doc 		 [1] = ls_nro_doc
					Messagebox('Aviso','Documento No Existe!')
					dw_master.SetFocus()
					dw_master.SetColumn(1)
					Return
				ELSE
					istr_param.titulo = 's'
					CloseWithReturn( parent, istr_param)
				END IF			  
			  
			  
END CHOOSE

end event

type dw_master from datawindow within w_help_datos
integer x = 18
integer y = 8
integer width = 1271
integer height = 180
integer taborder = 10
string title = "none"
boolean border = false
boolean livescroll = true
end type

