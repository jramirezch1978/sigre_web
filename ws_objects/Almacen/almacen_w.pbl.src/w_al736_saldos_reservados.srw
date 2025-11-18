$PBExportHeader$w_al736_saldos_reservados.srw
forward
global type w_al736_saldos_reservados from w_report_smpl
end type
type gb_1 from groupbox within w_al736_saldos_reservados
end type
type uo_fechas from u_ingreso_rango_fechas_v within w_al736_saldos_reservados
end type
type cb_3 from commandbutton within w_al736_saldos_reservados
end type
type rb_fec from radiobutton within w_al736_saldos_reservados
end type
type rb_ot from radiobutton within w_al736_saldos_reservados
end type
type rb_art from radiobutton within w_al736_saldos_reservados
end type
type em_1 from editmask within w_al736_saldos_reservados
end type
type pb_1 from picturebutton within w_al736_saldos_reservados
end type
type sle_descrip from singlelineedit within w_al736_saldos_reservados
end type
type rb_cen from radiobutton within w_al736_saldos_reservados
end type
type rb_ot_adm from radiobutton within w_al736_saldos_reservados
end type
type cbx_art from checkbox within w_al736_saldos_reservados
end type
type cbx_ot from checkbox within w_al736_saldos_reservados
end type
type cbx_cen from checkbox within w_al736_saldos_reservados
end type
type st_1 from statictext within w_al736_saldos_reservados
end type
type gb_2 from groupbox within w_al736_saldos_reservados
end type
end forward

global type w_al736_saldos_reservados from w_report_smpl
integer width = 3456
integer height = 1876
string title = "Saldos reservados (AL736)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 12632256
gb_1 gb_1
uo_fechas uo_fechas
cb_3 cb_3
rb_fec rb_fec
rb_ot rb_ot
rb_art rb_art
em_1 em_1
pb_1 pb_1
sle_descrip sle_descrip
rb_cen rb_cen
rb_ot_adm rb_ot_adm
cbx_art cbx_art
cbx_ot cbx_ot
cbx_cen cbx_cen
st_1 st_1
gb_2 gb_2
end type
global w_al736_saldos_reservados w_al736_saldos_reservados

type variables
Integer ii_index
end variables

on w_al736_saldos_reservados.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_1=create gb_1
this.uo_fechas=create uo_fechas
this.cb_3=create cb_3
this.rb_fec=create rb_fec
this.rb_ot=create rb_ot
this.rb_art=create rb_art
this.em_1=create em_1
this.pb_1=create pb_1
this.sle_descrip=create sle_descrip
this.rb_cen=create rb_cen
this.rb_ot_adm=create rb_ot_adm
this.cbx_art=create cbx_art
this.cbx_ot=create cbx_ot
this.cbx_cen=create cbx_cen
this.st_1=create st_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.rb_fec
this.Control[iCurrent+5]=this.rb_ot
this.Control[iCurrent+6]=this.rb_art
this.Control[iCurrent+7]=this.em_1
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.sle_descrip
this.Control[iCurrent+10]=this.rb_cen
this.Control[iCurrent+11]=this.rb_ot_adm
this.Control[iCurrent+12]=this.cbx_art
this.Control[iCurrent+13]=this.cbx_ot
this.Control[iCurrent+14]=this.cbx_cen
this.Control[iCurrent+15]=this.st_1
this.Control[iCurrent+16]=this.gb_2
end on

on w_al736_saldos_reservados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.uo_fechas)
destroy(this.cb_3)
destroy(this.rb_fec)
destroy(this.rb_ot)
destroy(this.rb_art)
destroy(this.em_1)
destroy(this.pb_1)
destroy(this.sle_descrip)
destroy(this.rb_cen)
destroy(this.rb_ot_adm)
destroy(this.cbx_art)
destroy(this.cbx_ot)
destroy(this.cbx_cen)
destroy(this.st_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;Date ld_fec_ini, ld_fec_fin
String ls_codigo, ls_doc_ot, ls_descrip, ls_texto

ld_fec_ini = uo_fechas.of_get_fecha1()
ld_fec_fin = uo_fechas.of_get_fecha2()

SELECT doc_ot into :ls_doc_ot FROM logparam where reckey='1' ;
// Por fecha
IF rb_fec.checked = TRUE THEN 

	IF cbx_art.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_artic_tbl'
	ELSEIF cbx_ot.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_ot_tbl'
	ELSEIF cbx_cen.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_cencos_tbl'		
	END IF 
	dw_report.SetTransObject(SQLCA)	
	dw_report.retrieve(ls_doc_ot, ld_fec_ini, ld_fec_fin)

// Por orden de trabajo
ELSEIF rb_ot.checked = TRUE THEN
	IF cbx_art.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_ot_art_tbl'
	ELSEIF cbx_ot.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_ot_art_tbl'
	ELSEIF cbx_cen.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_ot_cen_tbl'		
	END IF 
	dw_report.SetTransObject(SQLCA)		
	ls_codigo = TRIM(em_1.text)
	IF ISNULL(ls_codigo) OR TRIM(ls_codigo)='' THEN
		MessageBox('Aviso','Registre Orden de trabajo')
		return
	END IF 
	ls_texto = 'OT ' + TRIM(ls_codigo)
	dw_report.retrieve(ls_doc_ot, ls_codigo, ld_fec_ini, ld_fec_fin)

// Por articulo
ELSEIF rb_art.checked = TRUE THEN
	IF cbx_art.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_art_fecha_tbl'
	ELSEIF cbx_ot.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_art_ot_tbl'
	ELSEIF cbx_cen.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_art_cencos_tbl'		
	END IF 
	dw_report.SetTransObject(SQLCA)	
	ls_codigo = TRIM(em_1.text)

	IF ISNULL(ls_codigo) OR TRIM(ls_codigo)='' THEN
		MessageBox('Aviso','Registre código de artículo')
		return
	END IF 
	
	dw_report.retrieve(ls_doc_ot, ls_codigo, ld_fec_ini, ld_fec_fin)

// Por OT_ADM
ELSEIF rb_ot_adm.checked = TRUE THEN
	IF cbx_art.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_ota_art_tbl'
	ELSEIF cbx_ot.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_ota_ot_tbl'
	ELSEIF cbx_cen.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_ota_cencos_tbl'	
	END IF 
	dw_report.SetTransObject(SQLCA)		
	ls_codigo = TRIM(em_1.text)

	IF ISNULL(ls_codigo) OR TRIM(ls_codigo)='' THEN
		MessageBox('Aviso','Registre código de OT_ADM')
		return
	END IF 

	dw_report.retrieve(ls_doc_ot, ls_codigo, ld_fec_ini, ld_fec_fin)

// Por centro de costo solicitante
ELSEIF rb_cen.checked = TRUE THEN
	IF cbx_art.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_cencos_art_tbl'
	ELSEIF cbx_ot.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_cencos_ot_tbl'
	ELSEIF cbx_cen.checked = TRUE THEN
		dw_report.dataobject='d_rpt_saldos_reserv_cencos_cen_tbl'		
	END IF 
	dw_report.SetTransObject(SQLCA)		
	ls_codigo = TRIM(em_1.text)

	IF ISNULL(ls_codigo) OR TRIM(ls_codigo)='' THEN
		MessageBox('Aviso','Registre centro de costo solicitante')
		return
	END IF 
	
	dw_report.retrieve(ls_doc_ot, ls_codigo, ld_fec_ini, ld_fec_fin)
	
END IF 

dw_report.object.t_user.text = gs_user
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_objeto.text = 'AL736'
		
dw_report.object.t_texto.text = ls_texto + " Del: " + &
                               String( ld_fec_ini, 'dd/mm/yyyy') + ' AL ' + &
	                            String( ld_fec_fin, 'dd/mm/yyyy') 

end event

event ue_open_pre;call super::ue_open_pre;em_1.enabled = false
end event

type dw_report from w_report_smpl`dw_report within w_al736_saldos_reservados
integer x = 37
integer y = 416
integer width = 3342
integer height = 1224
integer taborder = 0
string dataobject = "d_rpt_saldos_reservados_tbl"
end type

type gb_1 from groupbox within w_al736_saldos_reservados
integer x = 2263
integer y = 48
integer width = 745
integer height = 284
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "  Fechas  : "
end type

type uo_fechas from u_ingreso_rango_fechas_v within w_al736_saldos_reservados
integer x = 2322
integer y = 104
integer height = 212
integer taborder = 30
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde

ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
uo_fechas.of_set_label("Desde","Hasta")
uo_fechas.of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
uo_fechas.of_set_rango_inicio(DATE('01/01/1000'))
uo_fechas.of_set_rango_fin(DATE('31/12/9999'))

end event

type cb_3 from commandbutton within w_al736_saldos_reservados
integer x = 3045
integer y = 156
integer width = 334
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve()


end event

type rb_fec from radiobutton within w_al736_saldos_reservados
integer x = 91
integer y = 96
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Por fecha"
boolean checked = true
end type

event clicked;em_1.enabled = false
end event

type rb_ot from radiobutton within w_al736_saldos_reservados
integer x = 553
integer y = 100
integer width = 626
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Por orden de trabajo"
end type

event clicked;em_1.enabled = true
end event

type rb_art from radiobutton within w_al736_saldos_reservados
integer x = 1207
integer y = 100
integer width = 398
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Por artículo"
end type

event clicked;em_1.enabled = true
end event

type em_1 from editmask within w_al736_saldos_reservados
integer x = 96
integer y = 256
integer width = 453
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "!!!!!!!!!!!!"
end type

event modified;String ls_codigo, ls_descrip
Long ll_count

IF rb_ot.checked = TRUE THEN
	ls_codigo = TRIM(em_1.text)

  select count(*) 
    into :ll_count 
	 from orden_trabajo ot 
	where ot.flag_estado<>'0' and 
			ot.nro_orden = :ls_codigo ;

  IF ll_count > 0 THEN
	  select titulo t 
	    into :ls_descrip 
	    from orden_trabajo ot 
		where ot.nro_orden = :ls_codigo ;
	END IF

ELSEIF rb_art.checked = TRUE THEN
  ls_codigo = TRIM(em_1.text)

  select count(*) 
    into :ll_count 
	 from articulo_mov_proy amp, articulo a 
	where amp.cod_art=a.cod_art and 
      	amp.cant_reservado > 0 and
			amp.cod_art = :ls_codigo and 
      	a.flag_estado<>'0' ;
  
  if ll_count=0 THEN
	  messagebox('Aviso','Articulo no tiene saldos reservados')
	  return
  end if 
  
  select nom_articulo 
    into :ls_descrip 
	 from articulo_mov_proy amp, articulo a 
	where amp.cod_art=a.cod_art and 
      	amp.cant_reservado > 0 and
			amp.cod_art = :ls_codigo and 			
      	a.flag_estado<>'0' ;

ELSEIF rb_ot_adm.checked = TRUE THEN
  ls_codigo = TRIM(em_1.text)

  select count(*) 
    into :ll_count 
	 from ot_administracion ota
	where ota.ot_adm = :ls_codigo ;
  
  if ll_count=0 THEN
	  messagebox('Aviso','OT_ADM no existe ')
	  return
  end if 
  
  select descripcion
    into :ls_descrip 
	 from ot_administracion ota
	where ota.ot_adm = :ls_codigo ;

ELSEIF rb_cen.checked = TRUE THEN
  ls_codigo = TRIM(em_1.text)

  select count(*) 
    into :ll_count 
	 from centros_costo cc
	where cc.cencos = :ls_codigo and 
      	cc.flag_estado<>'0' ;
  
  if ll_count=0 THEN
	  messagebox('Aviso','Centro de costo no existe')
	  return
  end if 
  
  select desc_cencos
    into :ls_descrip 
	 from centros_costo cc
	where cc.cencos = :ls_codigo ;

end if 

sle_descrip.text = ls_descrip 
end event

type pb_1 from picturebutton within w_al736_saldos_reservados
integer x = 599
integer y = 260
integer width = 114
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\source\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;String ls_estado, ls_inventariable 
str_seleccionar lstr_seleccionar
Datawindow ldw
dwobject   dwo1

IF rb_ot.checked=TRUE THEN
	ls_estado='0'
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT ORDEN_TRABAJO.NRO_ORDEN AS NRO_ORDEN ,'&
											 +'ORDEN_TRABAJO.TITULO    AS TIULO     ,'&
											 +'ORDEN_TRABAJO.OT_ADM    AS OT_ADM     '&											 
											 +'FROM ORDEN_TRABAJO ' //&
	//										 +'WHERE ORDEN_TRABAJO.FLAG_ESTADO <> '+"'"+ls_estado+"'"
							  
	OpenWithParm(w_seleccionar,lstr_seleccionar)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		em_1.text = lstr_seleccionar.param1[1]
	END IF
ELSEIF rb_art.checked=TRUE THEN
	ls_estado='0'
	ls_inventariable = '1'
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT ARTICULO.COD_ART 		  AS CODIGO	,'&
											 +'ARTICULO.NOM_ARTICULO  AS NOMBRE '&
											 +'FROM ARTICULO ' //&
											// +'ARTICULO.UND    		  AS und    		'&											 											 
											 //+'WHERE ARTICULO.FLAG_INVENTARIABLE = '+"'"+ls_inventariable+"'"

							  
	OpenWithParm(w_seleccionar,lstr_seleccionar)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		em_1.text = lstr_seleccionar.param1[1]		
		sle_descrip.text = TRIM(lstr_seleccionar.param2[1])
	END IF

ELSEIF rb_ot_adm.checked=TRUE THEN
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT OT_ADMINISTRACION.OT_ADM 		 AS ot_adm ,'&
											 +'OT_ADMINISTRACION.DESCRIPCION  AS descripcion '&
											 +'FROM OT_ADMINISTRACION ' 
							  
	OpenWithParm(w_seleccionar,lstr_seleccionar)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		em_1.text = lstr_seleccionar.param1[1]		
		sle_descrip.text = TRIM(lstr_seleccionar.param2[1])
	END IF

ELSEIF rb_cen.checked=TRUE THEN
	ls_estado = '0'
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS 		AS CODIGO ,'&
											 +'CENTROS_COSTO.DESC_CENCOS  AS DESCRIPCION '&
											 +'FROM CENTROS_COSTO ' //&
											 //+'WHERE CENTROS_COSTO.FLAG_ESTADO <> '+"'"+ls_estado+"'"
							  
	OpenWithParm(w_seleccionar,lstr_seleccionar)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		em_1.text = lstr_seleccionar.param1[1]		
		sle_descrip.text = TRIM(lstr_seleccionar.param2[1])
	END IF

END IF
end event

type sle_descrip from singlelineedit within w_al736_saldos_reservados
integer x = 736
integer y = 256
integer width = 933
integer height = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type rb_cen from radiobutton within w_al736_saldos_reservados
integer x = 553
integer y = 176
integer width = 613
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Por centro de costo"
end type

event clicked;em_1.enabled = true
end event

type rb_ot_adm from radiobutton within w_al736_saldos_reservados
integer x = 91
integer y = 176
integer width = 384
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Por OT Adm"
end type

event clicked;em_1.enabled = true
end event

type cbx_art from checkbox within w_al736_saldos_reservados
integer x = 1728
integer y = 144
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "X artículo"
boolean checked = true
end type

event clicked;cbx_cen.checked = false
cbx_ot.checked = false
end event

type cbx_ot from checkbox within w_al736_saldos_reservados
integer x = 1728
integer y = 216
integer width = 443
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "x Ord. Trabajo"
end type

event clicked;cbx_art.checked = false
cbx_cen.checked = false
end event

type cbx_cen from checkbox within w_al736_saldos_reservados
integer x = 1728
integer y = 288
integer width = 457
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "x CenCos Solic."
end type

event clicked;cbx_art.checked = false
cbx_ot.checked = false
end event

type st_1 from statictext within w_al736_saldos_reservados
integer x = 1737
integer y = 80
integer width = 384
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = "Ordenado por :"
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_al736_saldos_reservados
integer x = 50
integer y = 20
integer width = 2167
integer height = 364
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = "Parámetros"
end type

