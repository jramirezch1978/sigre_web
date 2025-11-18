$PBExportHeader$w_cn201_cntbl_asiento_mensual.srw
forward
global type w_cn201_cntbl_asiento_mensual from w_abc_master_smpl
end type
type cb_1 from commandbutton within w_cn201_cntbl_asiento_mensual
end type
type sle_mes from singlelineedit within w_cn201_cntbl_asiento_mensual
end type
type st_3 from statictext within w_cn201_cntbl_asiento_mensual
end type
type sle_ano from singlelineedit within w_cn201_cntbl_asiento_mensual
end type
type st_4 from statictext within w_cn201_cntbl_asiento_mensual
end type
type gb_3 from groupbox within w_cn201_cntbl_asiento_mensual
end type
end forward

global type w_cn201_cntbl_asiento_mensual from w_abc_master_smpl
integer width = 2770
integer height = 2548
string title = "[CN201] Modificacion Masiva de Asientos contables"
string menuname = "m_abc_master_smpl"
cb_1 cb_1
sle_mes sle_mes
st_3 st_3
sle_ano sle_ano
st_4 st_4
gb_3 gb_3
end type
global w_cn201_cntbl_asiento_mensual w_cn201_cntbl_asiento_mensual

on w_cn201_cntbl_asiento_mensual.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.cb_1=create cb_1
this.sle_mes=create sle_mes
this.st_3=create st_3
this.sle_ano=create sle_ano
this.st_4=create st_4
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.sle_ano
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.gb_3
end on

on w_cn201_cntbl_asiento_mensual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_mes)
destroy(this.st_3)
destroy(this.sle_ano)
destroy(this.st_4)
destroy(this.gb_3)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0

sle_ano.text = string(gnvo_app.of_fecha_actual(), 'yyyy')
sle_mes.text = string(gnvo_app.of_fecha_actual(), 'mm')
end event

event ue_retrieve;call super::ue_retrieve;Integer 	li_year, li_mes

li_year     = Integer(sle_ano.text)
li_mes 		= Integer(sle_mes.text)


dw_master.Retrieve(li_year, li_mes )

end event

event ue_update_pre;call super::ue_update_pre;

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return

ib_update_check = true

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn201_cntbl_asiento_mensual
integer x = 5
integer y = 212
integer width = 2601
integer height = 2068
string dataobject = "d_abc_asientos_mensuales_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// Origen
ii_ck[2] = 2			// Año
ii_ck[3] = 3			// Mes
ii_ck[4] = 4			// Nro libro
ii_ck[5] = 5			// Nro asiento
ii_ck[6] = 6			// Item
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("tipo_operacion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cod_frmt.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("item.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("valor.Protect='1~tIf(IsRowNew(),0,1)'")

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_flag_codrel, ls_flag_docref, ls_flag_ctabco, &
			ls_flag_centro_benef, ls_flag_cencos, ls_Cod_relacion, ls_tipo_docref1

str_cnta_cntbl 	lstr_cnta			
choose case lower(as_columna)
	case "cod_ctabco"
		
		if this.object.flag_ctabco[al_row] = '0' then
			return
		end if
		
		ls_sql = "select bc.cod_ctabco as cod_ctabco, " &
				 + "b.nom_banco as descripcion_banco " &
				 + "from banco_cnta bc, " &
				 + "     banco      b " &
				 + "where bc.cod_banco =  b.cod_banco " &
			    + "  and bc.flag_estado <> '0'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_ctabco	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "cencos"
		
		if this.object.flag_cencos[al_row] = '0' then
			return
		end if
		
		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
				  + "desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "cnta_ctbl"
		lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then
			this.object.cnta_ctbl [al_row] = lstr_cnta.cnta_cntbl
			this.object.desc_cnta [al_row] = lstr_cnta.desc_cnta
			
			SELECT NVL(flag_cencos,'0'), NVL(flag_codrel, '0'), NVL(flag_ctabco, '0'), 
					 NVL(flag_doc_ref, '0'), NVL(flag_centro_benef, '0')
			  INTO :ls_flag_cencos, :ls_flag_codrel, :ls_flag_ctabco, 
					 :ls_flag_docref, :ls_flag_centro_benef
			  FROM cntbl_cnta
			 WHERE cnta_ctbl = :lstr_cnta.cnta_cntbl;
			
			//Activamos Petición de centro de costos
			this.object.flag_cencos 		[al_row] = ls_flag_cencos
			this.object.flag_codrel 		[al_row] = ls_flag_codrel
			this.object.flag_centro_benef [al_row] = ls_flag_centro_benef
			this.object.flag_doc_ref 		[al_row] = ls_flag_docref
			this.object.flag_ctabco 		[al_row] = ls_flag_ctabco
			
			this.ii_update = 1
		end if

	case "cod_relacion"
		if this.object.flag_codrel[al_row] = '0' then
			return
		end if
		
		ls_sql = "SELECT PROVEEDOR.PROVEEDOR AS CODIGO, "&
				 + "PROVEEDOR.NOM_PROVEEDOR AS NOMBRE "&
				 + "FROM PROVEEDOR " &
				 + "WHERE FLAG_ESTADO <> '0'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_relacion	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "tipo_docref1"
		if this.object.flag_doc_ref[al_row] = '0' then
			return
		end if
		
		ls_sql = "SELECT DOC_TIPO.TIPO_DOC AS TIPO, "&
				 + "DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION "&
				 + "FROM DOC_TIPO "&
				 + "WHERE FLAG_ESTADO <> '0'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.tipo_docref1	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	CASE 'centro_benef'
		if this.object.flag_centro_benef[al_row] = '0' then
			return
		end if
		
		ls_sql = "SELECT CENTRO_BENEFICIO.CENTRO_BENEF AS CTRO_BENEFIC, "&
				 + "CENTRO_BENEFICIO.DESC_CENTRO AS DESCRIPCION , "&
				 + "CENTRO_BENEFICIO.COD_ORIGEN AS ORIGEN "&
				 + "FROM CENTRO_BENEFICIO "&
				 + "WHERE FLAG_ESTADO = '1'" 
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.centro_benef	[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose

//				
//END CHOOSE
//
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_flag_cencos, ls_flag_codrel, ls_filter, &
       	ls_flag_ctabco, ls_flag_docref,&
		 	ls_flag_estado, ls_flag_centro_benef, &
		 	ls_flag_permite_mov, ls_moneda, ls_cuenta, ls_desc_cnta
Decimal 	ldc_tasa_cambio, ldc_imp_soles, ldc_imp_dolar, ldc_t_dolar
Long		ll_count


ls_moneda 			= this.object.cod_moneda 		[row]
ls_flag_estado 	= this.object.flag_estado 		[row]
ldc_tasa_cambio 	= Dec(this.object.tasa_cambio [row])

this.accepttext()

IF ls_flag_estado='0' THEN
	MessageBox('Aviso', 'Asiento se encuentra anulado no puede modificarse')
	return
END IF 

this.ii_update = 1

CHOOSE CASE dwo.name
   CASE 'cnta_ctbl'	
	  SELECT flag_cencos, flag_codrel, flag_ctabco, 
				flag_doc_ref, flag_centro_benef, 
				flag_estado, flag_permite_mov,
				desc_cnta
		 INTO :ls_flag_cencos, :ls_flag_codrel, :ls_flag_ctabco,
				:ls_flag_docref, :ls_flag_centro_benef, 
				:ls_flag_estado, :ls_flag_permite_mov,
				:ls_desc_cnta
		 FROM cntbl_cnta
		WHERE cnta_ctbl = :data;

	  IF SQLCA.SQLCode = 100 then
		  messagebox('Aviso', 'Cuenta contable ' + data + ' no existe, por favor verifique!', StopSign!)
		  This.object.cnta_ctbl[row] = gnvo_app.is_null
		  return 1
	  end if
	  
	  IF ls_flag_estado = '0' then
		  messagebox('Aviso', 'Cuenta contable ' + data + ' se encuentra anulado, por favor verifique', StopSign!)
		  This.object.cnta_ctbl[row] = gnvo_app.is_null
		  return 1
	  end if

	  this.object.desc_cnta 			[row] = ls_desc_cnta
	  this.object.flag_cencos 			[row] = ls_flag_cencos
	  this.object.flag_ctabco 			[row] = ls_flag_ctabco
	  this.object.flag_doc_ref 		[row] = ls_flag_docref
	  this.object.flag_codrel 			[row] = ls_flag_codrel
	  this.object.flag_centro_benef 	[row] = ls_flag_centro_benef

  CASE 'cencos'	

	  select nvl(flag_estado, '0')
	    into :ls_flag_estado
	  from centros_costo 
	  where cencos = :data ;

	  IF SQLCA.SQLCode = 100 then
		  messagebox('Aviso', 'Centro de costo ' + data + ' no existe, por favor verifica')
		  This.object.cencos[row] = gnvo_app.is_null
		  return 1
	  end if
	  IF ls_flag_estado = '0' then
		  messagebox('Aviso', 'Centro de costo ' + data + ' se encuentra inactivo, por favor verifica')
		  This.object.cencos[row] = gnvo_app.is_null
		  return 1
	  end if
	  
  CASE 'centro_benef'	
	  select nvl(flag_estado, '0')
	    into :ls_flag_estado
	  from centro_beneficio 
	  where centro_benef = :data ;
	  
	  IF SQLCA.SQLCode = 100 then
		  messagebox('Aviso', 'Centro de beneficio ' + data + ' no existe, por favor verifica')
		  This.object.centro_benef[row] = gnvo_app.is_null
		  return 1
	  end if
	  IF ls_flag_estado = '0' then
		  messagebox('Aviso', 'Centro de beneficio ' + data + ' se encuentra inactivo, por favor verifica')
		  This.object.centro_benef[row] = gnvo_app.is_null
		  return 1
	  end if
	  
  CASE 'cod_relacion'	

	  select nvl(flag_estado, '0')
	    into :ls_flag_estado
	  from proveedor 
	  where proveedor = :data;
	  
	  IF SQLCA.SQLCode = 100 then
		  messagebox('Aviso', 'Código de Relación ' + data + ' no existe, por favor verifica')
		  This.object.cod_relacion[row] = gnvo_app.is_null
		  return 1
	  end if
	  IF ls_flag_estado = '0' then
		  messagebox('Aviso', 'Código de Relación  ' + data + ' se encuentra inactivo, por favor verifica')
		  This.object.cod_relacion[row] = gnvo_app.is_null
		  return 1
	  end if
	  	  
  CASE 'tipo_docref1'	
	  select count(*) 
	  	into :ll_count 
	  from doc_tipo 
	  where tipo_doc = :data;
	  
	  IF ll_count=0 then
		  messagebox('Aviso', 'Tipo de documento ' + data + ' no existe, por favor verifique')
		  This.object.tipo_docref1[row] = gnvo_app.is_null
		  return 1
	  end if
		 
  CASE 'imp_movsol'
	  ls_cuenta 		= this.object.cnta_ctbl [row]
	  ldc_imp_soles 	= DEC( DATA )
     ldc_imp_dolar 	= ldc_imp_soles / ldc_tasa_cambio
	  
	  IF ls_moneda = gnvo_app.is_soles then
     		this.object.imp_movdol [row] = ldc_imp_dolar
	  END IF
	  
	  //dw_detail.object.imp_movdol.protect = 0  // 1
     //of_calcula_totales( )
	  
  	  //ib_estado[2] = true
	  ii_update=1
			 
  CASE 'imp_movdol'
     //dw_detail.object.imp_movsol.protect = 1	  		
     //dw_detail.object.imp_movdol.protect = 0  // 1	  		
     ldc_imp_dolar = DEC( DATA )
	  
  	  IF ls_moneda <> gnvo_app.is_soles then
     		ldc_imp_soles = ldc_imp_dolar * ldc_tasa_cambio
	  	   this.object.imp_movsol [row] = ldc_imp_soles
	  END IF
	  
	  //of_calcula_totales( )
	  
  	  //ib_estado[2] = true
	  ii_update=1
	  
  	CASE 'flag_debhab'
		
		//of_calcula_totales( )
END CHOOSE	

end event

event dw_master::buttonclicked;call super::buttonclicked;str_parametros lstr_param

if row = 0 then return

if lower(dwo.name) = 'b_glosa' then
		
	If this.is_protect("glosa", row) then RETURN
	
	// Para la descripcion de la Factura
	lstr_param.string1   = 'Glosa de la cabecera del asiento Contable'
	lstr_param.string2	 = this.object.glosa [row]

	OpenWithParm( w_descripcion_fac, lstr_param)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
	IF lstr_param.titulo = 's' THEN
			This.object.glosa [row] = left(lstr_param.string3, 2000)
			this.ii_update = 1
	END IF	
	

end if
end event

type cb_1 from commandbutton within w_cn201_cntbl_asiento_mensual
integer x = 773
integer y = 44
integer width = 302
integer height = 136
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Repote"
end type

event clicked;setPointer(Hourglass!)
Parent.Event ue_retrieve()
setPointer(Arrow!)

end event

type sle_mes from singlelineedit within w_cn201_cntbl_asiento_mensual
integer x = 645
integer y = 76
integer width = 105
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_cn201_cntbl_asiento_mensual
integer x = 416
integer y = 84
integer width = 201
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
string text = "Mes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_cn201_cntbl_asiento_mensual
integer x = 201
integer y = 76
integer width = 192
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_cn201_cntbl_asiento_mensual
integer x = 32
integer y = 84
integer width = 155
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
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_3 from groupbox within w_cn201_cntbl_asiento_mensual
integer width = 1339
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
end type

