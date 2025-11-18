$PBExportHeader$w_fi352_change_number.srw
forward
global type w_fi352_change_number from w_abc
end type
type cb_3 from commandbutton within w_fi352_change_number
end type
type cb_2 from commandbutton within w_fi352_change_number
end type
type st_4 from statictext within w_fi352_change_number
end type
type st_3 from statictext within w_fi352_change_number
end type
type st_2 from statictext within w_fi352_change_number
end type
type sle_nro_doc from singlelineedit within w_fi352_change_number
end type
type sle_tdoc from singlelineedit within w_fi352_change_number
end type
type sle_crel from singlelineedit within w_fi352_change_number
end type
type rb_rde from radiobutton within w_fi352_change_number
end type
type rb_rtd from radiobutton within w_fi352_change_number
end type
type st_1 from statictext within w_fi352_change_number
end type
type em_1 from editmask within w_fi352_change_number
end type
type cb_1 from commandbutton within w_fi352_change_number
end type
type dw_master from u_dw_abc within w_fi352_change_number
end type
type gb_1 from groupbox within w_fi352_change_number
end type
end forward

global type w_fi352_change_number from w_abc
integer width = 3817
integer height = 1716
string title = "Cambiar Numero (FI352)"
string menuname = "m_proceso"
cb_3 cb_3
cb_2 cb_2
st_4 st_4
st_3 st_3
st_2 st_2
sle_nro_doc sle_nro_doc
sle_tdoc sle_tdoc
sle_crel sle_crel
rb_rde rb_rde
rb_rtd rb_rtd
st_1 st_1
em_1 em_1
cb_1 cb_1
dw_master dw_master
gb_1 gb_1
end type
global w_fi352_change_number w_fi352_change_number

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos


idw_1 = dw_master              				// asignar dw corriente

of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

on w_fi352_change_number.create
int iCurrent
call super::create
if this.MenuName = "m_proceso" then this.MenuID = create m_proceso
this.cb_3=create cb_3
this.cb_2=create cb_2
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.sle_nro_doc=create sle_nro_doc
this.sle_tdoc=create sle_tdoc
this.sle_crel=create sle_crel
this.rb_rde=create rb_rde
this.rb_rtd=create rb_rtd
this.st_1=create st_1
this.em_1=create em_1
this.cb_1=create cb_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_nro_doc
this.Control[iCurrent+7]=this.sle_tdoc
this.Control[iCurrent+8]=this.sle_crel
this.Control[iCurrent+9]=this.rb_rde
this.Control[iCurrent+10]=this.rb_rtd
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.em_1
this.Control[iCurrent+13]=this.cb_1
this.Control[iCurrent+14]=this.dw_master
this.Control[iCurrent+15]=this.gb_1
end on

on w_fi352_change_number.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.sle_nro_doc)
destroy(this.sle_tdoc)
destroy(this.sle_crel)
destroy(this.rb_rde)
destroy(this.rb_rtd)
destroy(this.st_1)
destroy(this.em_1)
destroy(this.cb_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

event ue_update_pre;call super::ue_update_pre;Long    ll_inicio,ll_pos,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento
String  ls_flag_sel     ,ls_new_nro ,ls_tipo_doc ,ls_nro_doc,ls_msj_err,&
		  ls_cod_relacion	,ls_origen  ,ls_new_crel ,ls_new_tdoc
		  
//inicializa		  
ib_update_check = true




For ll_inicio = 1 to dw_master.Rowcount()
	 ls_flag_sel 	  = dw_master.object.flag_sel 	 [ll_inicio]	 	
	 ls_new_crel	  = dw_master.object.new_crel  	 [ll_inicio]
	 ls_new_tdoc	  = dw_master.object.new_tdoc  	 [ll_inicio]
	 ls_new_nro  	  = dw_master.object.new_nro  	 [ll_inicio]
	 ls_tipo_doc 	  = dw_master.object.tipo_doc 	 [ll_inicio]
	 ls_nro_doc	 	  = dw_master.object.nro_doc  	 [ll_inicio]	
	 ls_cod_relacion = dw_master.object.cod_relacion [ll_inicio]	
	 ls_origen		  = dw_master.object.origen  		 [ll_inicio]	
	 ll_ano			  = dw_master.object.ano  			 [ll_inicio]	
	 ll_mes			  = dw_master.object.mes  			 [ll_inicio]	 
	 ll_nro_libro    = dw_master.object.nro_libro    [ll_inicio]	
	 ll_nro_asiento  = dw_master.object.nro_asiento  [ll_inicio]	
	 
	 
	 
	 
	 if ls_flag_sel = '1' then
		 //proceso de cambio de numero
		 ll_pos = Pos(ls_new_nro,'-')
		 
		 if Not(ll_pos = 4 or ll_pos = 5) then
			 Messagebox('Aviso','Nuevo Nro de Documento '+ls_tipo_doc +' - '+ls_nro_doc+' No Contiene la separación de la serie con el guion ') 
			 Rollback ;
			 ib_update_check = false
			 
			 GOTO SALIDA			 
		 else
			
			 //verificar que datos a cambiar esten completos
			 if Isnull(ls_new_crel) or trim(ls_new_crel) = '' then
	 			 Messagebox('Aviso','Debe Colocar Codigo de Relacion ,Verifique!') 
			 	 ib_update_check = false
				 GOTO SALIDA
			 end if	
			 
			 if Isnull(ls_new_tdoc) or trim(ls_new_tdoc) = '' then
				 Messagebox('Aviso','Debe Colocar Tipo Documento ,Verifique!') 	
				 ib_update_check = false
				 GOTO SALIDA
			 end if	
			 
			 if Isnull(ls_new_nro)  or trim(ls_new_nro) = '' then
				 Messagebox('Aviso','Debe Colocar Nuevo Nro ,Verifique!') 
				 ib_update_check = false
				 GOTO SALIDA
			 end if
			 
			
			
			

			 DECLARE PB_USP_FIN_CHANGE_NUMBER PROCEDURE FOR USP_FIN_CHANGE_NUMBER 
			 (:ls_new_crel     ,:ls_new_tdoc    ,:ls_new_nro ,:ls_cod_relacion ,:ls_tipo_doc    ,:ls_nro_doc ,
			  :ls_origen       ,:ll_ano         ,:ll_mes     ,:ll_nro_libro    ,:ll_nro_asiento ,:gs_origen );
			 EXECUTE PB_USP_FIN_CHANGE_NUMBER ;
			 
			 IF SQLCA.SQLCode = -1 THEN 
				 ls_msj_err = SQLCA.SQLErrText
				 Rollback ;
				 MessageBox('SQL error', ls_msj_err)
				 ib_update_check = false
			 	 GOTO SALIDA
			 END IF

			 CLOSE PB_USP_FIN_CHANGE_NUMBER ;
			 
 			
			 
			 
		 end if	
	 end if
	 
	 
	 
	 
Next


SALIDA:
if ib_update_check then
	Commit ;
else
	Rollback ;
end if
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()

IF ib_update_check = FALSE THEN RETURN


//recupera nnueva informacion
cb_1.TriggerEvent(Clicked!)


end event

type cb_3 from commandbutton within w_fi352_change_number
integer x = 727
integer y = 376
integer width = 96
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;Str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT DOC_TIPO.TIPO_DOC      AS CODIGO     , '&
							   		 +'DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION  '&
								       +'FROM DOC_TIPO '

OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
   IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_tdoc.text = lstr_seleccionar.param1[1]
	END IF


end event

type cb_2 from commandbutton within w_fi352_change_number
integer x = 727
integer y = 268
integer width = 96
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;Str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO    ,'&
								       +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE    ,'&
								       +'PROVEEDOR.RUC 			 AS CODIGO_RUC '&
								       +'FROM PROVEEDOR '&
								       +'WHERE (PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"+')'

OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
   IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_crel.text = lstr_seleccionar.param1[1]
	END IF


end event

type st_4 from statictext within w_fi352_change_number
integer x = 50
integer y = 484
integer width = 288
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Doc :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_fi352_change_number
integer x = 50
integer y = 380
integer width = 288
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Doc :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi352_change_number
integer x = 50
integer y = 276
integer width = 288
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "C.Relación :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nro_doc from singlelineedit within w_fi352_change_number
integer x = 366
integer y = 472
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type sle_tdoc from singlelineedit within w_fi352_change_number
integer x = 366
integer y = 368
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type sle_crel from singlelineedit within w_fi352_change_number
integer x = 366
integer y = 264
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

type rb_rde from radiobutton within w_fi352_change_number
integer x = 965
integer y = 272
integer width = 859
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Recuperar Documento Especifico"
end type

type rb_rtd from radiobutton within w_fi352_change_number
integer x = 965
integer y = 192
integer width = 859
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Recuperar Documentos sin Serie"
end type

type st_1 from statictext within w_fi352_change_number
integer x = 59
integer y = 52
integer width = 174
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_1 from editmask within w_fi352_change_number
integer x = 270
integer y = 32
integer width = 297
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_1 from commandbutton within w_fi352_change_number
integer x = 978
integer y = 456
integer width = 626
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recupera Información"
end type

event clicked;Long   ll_ano
String ls_crel,ls_tdoc,ls_ndoc

ll_ano  = Long(em_1.text)
ls_crel = Trim(sle_crel.text)
ls_tdoc = Trim(sle_tdoc.text)
ls_ndoc = Trim(sle_nro_doc.text)

if rb_rde.checked then //recupera documento especifico
	IF Isnull(ls_crel) OR ls_crel = ''  THEN //CODIGO DE RELACION
		Messagebox('Aviso','Debe Ingresar Codigo de Relacion')
		sle_crel.setfocus()
		Return
	END IF
	
	IF Isnull(ls_tdoc) OR ls_tdoc = ''  THEN //TIPO DOC
		Messagebox('Aviso','Debe Ingresar Tipo de Documento')
		sle_tdoc.setfocus()
		Return
	END IF
	
	IF Isnull(ls_ndoc) OR ls_ndoc = ''  THEN //NRO DOC
		Messagebox('Aviso','Debe Ingresar Nro de Documento')
		sle_nro_doc.setfocus()
		Return
	END IF


	dw_master.dataobject = 'd_abc_change_number_x_doc_tbl'
	dw_master.settransobject(sqlca)
	dw_master.Retrieve(ls_crel,ls_tdoc,ls_ndoc)
	
end if

if rb_rtd.checked then //recupera todos los documentos sin serie
	if Isnull(ll_ano) or ll_ano = 0 then
		Messagebox('Aviso','Debe Ingresar Un Año a Recuperar ')
		em_1.setfocus( )
		Return
	end if
	
	dw_master.dataobject = 'd_abc_change_number_tbl'
	dw_master.settransobject(sqlca)
	dw_master.Retrieve(ll_ano)
end if




end event

type dw_master from u_dw_abc within w_fi352_change_number
integer x = 27
integer y = 624
integer width = 3726
integer height = 896
string dataobject = "d_abc_change_number_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)



ii_ck[1] = 1			// columnas de lectrua de este dw

idw_mst  = dw_master

end event

event itemchanged;call super::itemchanged;String ls_codigo
Long   ll_count
Accepttext()


choose case dwo.name
		 case 'new_crel'
				
				select count(*) into :ll_count from proveedor p
				 where (p.proveedor   = :data ) and
				 		 (p.flag_estado = '1'   )  ;
						  
						  
			 	if ll_count = 0 then
					SetNull(ls_codigo)
					Messagebox('Aviso','Proveedor No Existe , Verifique!')	
					This.object.new_crell [row] = ls_codigo
					Return 1
				end if
			
		 case 'new_tdoc'	
				select count(*) into :ll_count from doc_tipo
				 where (tipo_doc = :data) ;

			 	if ll_count = 0 then
					SetNull(ls_codigo)
					Messagebox('Aviso','Documento No Existe , Verifique!')	
					This.object.new_tdoc [row] = ls_codigo
					Return 1
				end if
				 
				
end choose

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;Str_seleccionar lstr_seleccionar

This.accepttext( )


lstr_seleccionar.s_seleccion = 'S'

choose case dwo.name
		 case 'new_crel'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO    ,'&
												       +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE    ,'&
												       +'PROVEEDOR.RUC 			 AS CODIGO_RUC '&
												       +'FROM PROVEEDOR '&
												       +'WHERE (PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"+')'

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
					this.object.new_crel [row] = lstr_seleccionar.param1[1]
				END IF

		 case 'new_tdoc'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT DOC_TIPO.TIPO_DOC      AS CODIGO     , '&
											   		 +'DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION  '&
												       +'FROM DOC_TIPO '

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
					this.object.new_tdoc [row] = lstr_seleccionar.param1[1]
				END IF

end choose

end event

type gb_1 from groupbox within w_fi352_change_number
integer x = 9
integer y = 148
integer width = 1934
integer height = 428
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos"
end type

