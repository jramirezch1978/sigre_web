$PBExportHeader$w_cm766_gestion_compra.srw
forward
global type w_cm766_gestion_compra from w_report_smpl
end type
type cb_1 from commandbutton within w_cm766_gestion_compra
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm766_gestion_compra
end type
type p_5 from picture within w_cm766_gestion_compra
end type
type cbx_ot from checkbox within w_cm766_gestion_compra
end type
type sle_ot from singlelineedit within w_cm766_gestion_compra
end type
type pb_ot from picturebutton within w_cm766_gestion_compra
end type
type p_1 from picture within w_cm766_gestion_compra
end type
type cbx_art from checkbox within w_cm766_gestion_compra
end type
type sle_art from singlelineedit within w_cm766_gestion_compra
end type
type pb_art from picturebutton within w_cm766_gestion_compra
end type
type p_2 from picture within w_cm766_gestion_compra
end type
type cbx_prov from checkbox within w_cm766_gestion_compra
end type
type sle_prov from singlelineedit within w_cm766_gestion_compra
end type
type pb_prov from picturebutton within w_cm766_gestion_compra
end type
type p_3 from picture within w_cm766_gestion_compra
end type
type cbx_usr from checkbox within w_cm766_gestion_compra
end type
type sle_usr from singlelineedit within w_cm766_gestion_compra
end type
type pb_usr from picturebutton within w_cm766_gestion_compra
end type
type rb_ot from radiobutton within w_cm766_gestion_compra
end type
type rb_prov from radiobutton within w_cm766_gestion_compra
end type
type rb_art from radiobutton within w_cm766_gestion_compra
end type
type rb_usr from radiobutton within w_cm766_gestion_compra
end type
type rb_mat from radiobutton within w_cm766_gestion_compra
end type
type rb_serv from radiobutton within w_cm766_gestion_compra
end type
type gb_2 from groupbox within w_cm766_gestion_compra
end type
type gb_1 from groupbox within w_cm766_gestion_compra
end type
type gb_3 from groupbox within w_cm766_gestion_compra
end type
type gb_4 from groupbox within w_cm766_gestion_compra
end type
type gb_5 from groupbox within w_cm766_gestion_compra
end type
type gb_6 from groupbox within w_cm766_gestion_compra
end type
end forward

global type w_cm766_gestion_compra from w_report_smpl
integer width = 3813
integer height = 3012
string title = "Gestión de Compras (CM766)"
string menuname = "m_impresion"
cb_1 cb_1
uo_fecha uo_fecha
p_5 p_5
cbx_ot cbx_ot
sle_ot sle_ot
pb_ot pb_ot
p_1 p_1
cbx_art cbx_art
sle_art sle_art
pb_art pb_art
p_2 p_2
cbx_prov cbx_prov
sle_prov sle_prov
pb_prov pb_prov
p_3 p_3
cbx_usr cbx_usr
sle_usr sle_usr
pb_usr pb_usr
rb_ot rb_ot
rb_prov rb_prov
rb_art rb_art
rb_usr rb_usr
rb_mat rb_mat
rb_serv rb_serv
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
end type
global w_cm766_gestion_compra w_cm766_gestion_compra

type variables

end variables

forward prototypes
public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_oc, ref string as_oper_cons)
end prototypes

public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_oc, ref string as_oper_cons);Long		ll_rc = 0



  SELECT "LOGPARAM"."DOC_OT", "LOGPARAM"."DOC_OC", "LOGPARAM"."OPER_CONS_INTERNO"  
    INTO :as_doc_ot, :as_doc_oc, :as_oper_cons
    FROM "LOGPARAM"  
   WHERE "LOGPARAM"."RECKEY" = '1' ;

	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_cm766_gestion_compra.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.p_5=create p_5
this.cbx_ot=create cbx_ot
this.sle_ot=create sle_ot
this.pb_ot=create pb_ot
this.p_1=create p_1
this.cbx_art=create cbx_art
this.sle_art=create sle_art
this.pb_art=create pb_art
this.p_2=create p_2
this.cbx_prov=create cbx_prov
this.sle_prov=create sle_prov
this.pb_prov=create pb_prov
this.p_3=create p_3
this.cbx_usr=create cbx_usr
this.sle_usr=create sle_usr
this.pb_usr=create pb_usr
this.rb_ot=create rb_ot
this.rb_prov=create rb_prov
this.rb_art=create rb_art
this.rb_usr=create rb_usr
this.rb_mat=create rb_mat
this.rb_serv=create rb_serv
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.p_5
this.Control[iCurrent+4]=this.cbx_ot
this.Control[iCurrent+5]=this.sle_ot
this.Control[iCurrent+6]=this.pb_ot
this.Control[iCurrent+7]=this.p_1
this.Control[iCurrent+8]=this.cbx_art
this.Control[iCurrent+9]=this.sle_art
this.Control[iCurrent+10]=this.pb_art
this.Control[iCurrent+11]=this.p_2
this.Control[iCurrent+12]=this.cbx_prov
this.Control[iCurrent+13]=this.sle_prov
this.Control[iCurrent+14]=this.pb_prov
this.Control[iCurrent+15]=this.p_3
this.Control[iCurrent+16]=this.cbx_usr
this.Control[iCurrent+17]=this.sle_usr
this.Control[iCurrent+18]=this.pb_usr
this.Control[iCurrent+19]=this.rb_ot
this.Control[iCurrent+20]=this.rb_prov
this.Control[iCurrent+21]=this.rb_art
this.Control[iCurrent+22]=this.rb_usr
this.Control[iCurrent+23]=this.rb_mat
this.Control[iCurrent+24]=this.rb_serv
this.Control[iCurrent+25]=this.gb_2
this.Control[iCurrent+26]=this.gb_1
this.Control[iCurrent+27]=this.gb_3
this.Control[iCurrent+28]=this.gb_4
this.Control[iCurrent+29]=this.gb_5
this.Control[iCurrent+30]=this.gb_6
end on

on w_cm766_gestion_compra.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.p_5)
destroy(this.cbx_ot)
destroy(this.sle_ot)
destroy(this.pb_ot)
destroy(this.p_1)
destroy(this.cbx_art)
destroy(this.sle_art)
destroy(this.pb_art)
destroy(this.p_2)
destroy(this.cbx_prov)
destroy(this.sle_prov)
destroy(this.pb_prov)
destroy(this.p_3)
destroy(this.cbx_usr)
destroy(this.sle_usr)
destroy(this.pb_usr)
destroy(this.rb_ot)
destroy(this.rb_prov)
destroy(this.rb_art)
destroy(this.rb_usr)
destroy(this.rb_mat)
destroy(this.rb_serv)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
end on

event ue_retrieve;call super::ue_retrieve;String	ls_msj, ls_ot, ls_art, ls_prov, ls_usr, ls_texto
String ls_desc_art, ls_nom_prov, ls_nom_usr
Long		ll_rc

Date ld_fecha1, ld_fecha2

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()
//IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

ls_texto = ''
IF cbx_ot.checked = False THEN
	ls_ot = Trim(sle_ot.text)+'%'
	ls_texto = ls_texto +'OT N° '+sle_ot.text+'.'
else
	ls_ot = '%'
END IF

If rb_mat.Checked then
	IF cbx_art.checked = False THEN
		ls_art = Trim(sle_art.text)
		select desc_art into :ls_desc_art
		  from articulo where cod_art = :ls_art;
		ls_texto = ls_texto +'   Articulo '+Trim(ls_art)+' '+Trim(ls_desc_art)+'.'
		ls_art = Trim(sle_art.text)+'%'
	else
		ls_art = '%'
	END IF
end if

IF cbx_prov.checked = False THEN
	ls_prov = Trim(sle_prov.text)
	select nom_proveedor into :ls_nom_prov
	  from proveedor where proveedor = :ls_prov;
	ls_texto = ls_texto +'   Proveedor '+Trim(ls_prov)+' '+Trim(ls_nom_prov)+'.'
	ls_prov = Trim(sle_prov.text)+'%'
else
	ls_prov = '%'
END IF

IF cbx_usr.checked = False THEN
	ls_usr = Trim(sle_usr.text)
	select nombre into :ls_nom_usr
	  from usuario where cod_usr = :ls_usr;
	ls_texto = ls_texto +'   Agente Compras '+Trim(ls_usr)+' '+Trim(ls_nom_usr)+'.'
	ls_usr = Trim(sle_usr.text)+'%'	
else
	ls_usr = '%'
END IF

If rb_mat.Checked then
	DECLARE pb_rpt_gestion_compra PROCEDURE FOR usp_cmp_rpt_gestion_compra
			  (:ld_fecha1, :ld_fecha2, :ls_ot, :ls_art, :ls_prov, :ls_usr) ;
	EXECUTE pb_rpt_gestion_compra ;
elseif rb_serv.Checked then
	DECLARE pb_rpt_gest_compra_serv PROCEDURE FOR usp_cmp_rpt_gest_compra_serv
			  (:ld_fecha1, :ld_fecha2, :ls_ot, :ls_prov, :ls_usr) ;
	EXECUTE pb_rpt_gest_compra_serv ;
end if

IF sqlca.sqlcode = -1 Then
	Rollback ;
	MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
	Return
End If

If rb_mat.Checked then
	If rb_ot.Checked then
		idw_1.DataObject = 'd_rpt_gestion_compra_x_ot'
	elseif rb_prov.Checked then
		idw_1.DataObject = 'd_rpt_gestion_compra_x_prov'
	elseif rb_art.Checked then
		idw_1.DataObject = 'd_rpt_gestion_compra_x_art'
	elseif rb_usr.Checked then
		idw_1.DataObject = 'd_rpt_gestion_compra_x_usr'
	end if
elseif rb_serv.Checked then
	If rb_ot.Checked then
		idw_1.DataObject = 'd_rpt_gest_compra_serv_x_ot'
	elseif rb_prov.Checked then
		idw_1.DataObject = 'd_rpt_gest_compra_serv_x_prov'
	elseif rb_usr.Checked then
		idw_1.DataObject = 'd_rpt_gest_compra_serv_x_usr'
	end if
end if	
idw_1.SetTransObject(sqlca)

ib_preview = false
idw_1.Modify("DataWindow.Zoom= 95")
TriggerEvent ("ue_preview")
idw_1.Retrieve()
Commit;


idw_1.object.t_subtitulo.text = 'Fecha De Aprobacion Del :  ' + String(ld_fecha1, 'dd/mm/yy') + '  Al:  ' + String(ld_fecha2, 'dd/mm/yy')
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text   = gs_empresa
idw_1.object.t_user.text     = gs_user
idw_1.object.t_objeto.text   = 'CM766'
idw_1.object.t_text.text   = ls_texto
end event

event ue_open_pre;call super::ue_open_pre;//Long	ll_rc
//
//// Leer tipo doc OT, cod operacion consumo interno
//ll_rc = of_get_parametros(is_doc_ot, is_doc_oc, is_oper_cons)
//

end event

type dw_report from w_report_smpl`dw_report within w_cm766_gestion_compra
integer x = 27
integer y = 500
integer width = 2720
integer height = 1212
string dataobject = "d_rpt_gestion_compra_x_prov"
integer ii_zoom_actual = 120
end type

event dw_report::doubleclicked;call super::doubleclicked;GroupCalc()
//IF row = 0 THEN RETURN
//
//STR_CNS_POP lstr_1
//
//CHOOSE CASE dwo.Name
//	CASE "nro_doc_oc" 
//		lstr_1.DataObject = 'd_oc_x_requerimiento_articulo_tbl'
//		lstr_1.Width = 3800
//		lstr_1.Height= 900
//		lstr_1.Arg[1] = is_doc_oc
//		lstr_1.Arg[2] = GetItemString(row,'cod_origen')
//		lstr_1.Arg[3] = String(GetItemNumber(row,'nro_mov'))
//		lstr_1.Title = 'OC Asociadas a este Requerimiento'
//		lstr_1.Tipo_Cascada = 'R'
//		of_new_sheet(lstr_1)	
//	CASE "articulo_almacen_sldo_total" 
//		lstr_1.DataObject = 'd_art_mov_almacen_tbl'
//		lstr_1.Width = 2850
//		lstr_1.Height= 900
//		lstr_1.Arg[1] = GetItemString(row,'cod_art')
//		lstr_1.Arg[2] = GetItemString(row,'almacen')
//		lstr_1.Title = 'Ultimos Movimientos del Articulo en este Almacen'
//		lstr_1.Tipo_Cascada = 'R'
//		of_new_sheet(lstr_1)
//	CASE "nro_doc" 
//		lstr_1.DataObject = 'd_amp_pendiente_ot_cascada_tbl'
//		lstr_1.Width = 3750
//		lstr_1.Height= 1000
//		lstr_1.Arg[1] = is_doc_ot
//		lstr_1.Arg[2] = is_doc_oc
//		lstr_1.Arg[3] = is_oper_cons
//		lstr_1.Arg[4] = GetItemString(row,'nro_doc')
//		lstr_1.Title = 'Movimientos Pendientes por OT'
//		lstr_1.Tipo_Cascada = 'R'
//		of_new_sheet(lstr_1)
//	CASE "fec_proyect" 
//		lstr_1.DataObject = 'd_articulo_desc_ff'
//		lstr_1.Width = 3200
//		lstr_1.Height= 700		
//		lstr_1.Arg[1] = GetItemString(row,'cod_art')
//		lstr_1.Title = 'Datos del Articulo'
//		lstr_1.Tipo_Cascada = 'C'
//		of_new_sheet(lstr_1)
//END CHOOSE
//
end event

type cb_1 from commandbutton within w_cm766_gestion_compra
integer x = 1733
integer y = 396
integer width = 315
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;If rb_serv.Checked and rb_art.Checked then
	MessageBox('Aviso','Accion Inválida')
	Return
end if
String ls_ot, ls_prov, ls_art, ls_usr
Integer li_count

IF cbx_ot.checked = False THEN
	ls_ot = trim(sle_ot.text)
	IF Len(ls_ot) = 0 or IsNull(ls_ot) THEN
		MessageBox('Error', 'Tiene que seleccionar una OT')
		RETURN
	ELSE
		Select count(*) into :li_count
		from orden_trabajo
		where nro_orden = :ls_ot;
		If li_count = 0 then
			MessageBox('Error','N° de OT No Existe!')
			Return
		end if
	END IF
END IF

IF cbx_art.checked = False THEN
	ls_art = trim(sle_art.text)
	IF Len(ls_art) = 0 or IsNull(ls_art) THEN
		MessageBox('Error', 'Tiene que seleccionar un articulo')
		RETURN
	ELSE
		Select count(*) into :li_count
		from articulo
		where cod_art = :ls_art;
		If li_count = 0 then
			MessageBox('Error','Código de Artículo No Existe!')
			Return
		end if
	END IF
END IF

IF cbx_prov.checked = False THEN
	ls_prov = sle_prov.text
	IF Len(trim(ls_prov)) = 0 or IsNull(ls_prov) THEN
		MessageBox('Error', 'Tiene que seleccionar un proveedor')
		RETURN
	ELSE
		Select count(*) into :li_count
		from proveedor
		where proveedor = :ls_prov;
		If li_count = 0 then
			MessageBox('Error','Código de Proveedor No Existe!')
			Return
		end if
	END IF
END IF

IF cbx_usr.checked = False THEN
	ls_usr = sle_usr.text
	IF Len(ls_usr) = 0 or IsNull(ls_usr) THEN
		MessageBox('Error', 'Tiene que seleccionar un usuario')
		RETURN
	ELSE
		Select count(*) into :li_count
		from usuario
		where cod_usr = :ls_usr;
		If li_count = 0 then
			MessageBox('Error','Código de Usuario No Existe!')
			Return
		end if
	END IF
END IF

PARENT.Event ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_cm766_gestion_compra
integer x = 14
integer y = 44
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(RelativeDate(Today(),-30), Today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type p_5 from picture within w_cm766_gestion_compra
integer x = 64
integer y = 152
integer width = 78
integer height = 60
boolean bringtotop = true
string picturename = "Custom042!"
boolean focusrectangle = false
end type

type cbx_ot from checkbox within w_cm766_gestion_compra
integer x = 466
integer y = 144
integer width = 73
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked = true then
	sle_ot.enabled = false
	pb_ot.enabled = false
else
	sle_ot.enabled = true
	pb_ot.enabled = true
end if
end event

type sle_ot from singlelineedit within w_cm766_gestion_compra
integer x = 64
integer y = 220
integer width = 567
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type pb_ot from picturebutton within w_cm766_gestion_compra
integer x = 640
integer y = 212
integer width = 114
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
boolean originalsize = true
string picturename = "c:\sigre\resources\Bmp\file_open.bmp"
string disabledname = "c:\sigre\resources\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORDEN_TRABAJO.NRO_ORDEN AS NRO_ORDEN,'&
								 +'ORDEN_TRABAJO.DESCRIPCION AS DESCRIPCION '&     	
								 +'FROM ORDEN_TRABAJO ' 

OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_ot.text = lstr_seleccionar.param1[1]
end if
end event

type p_1 from picture within w_cm766_gestion_compra
integer x = 850
integer y = 152
integer width = 78
integer height = 60
boolean bringtotop = true
string picturename = "BringToFront!"
boolean focusrectangle = false
end type

type cbx_art from checkbox within w_cm766_gestion_compra
integer x = 1381
integer y = 144
integer width = 73
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked = true then
	sle_art.enabled = false
	pb_art.enabled = false
else
	sle_art.enabled = true
	pb_art.enabled = true
end if
end event

type sle_art from singlelineedit within w_cm766_gestion_compra
integer x = 850
integer y = 220
integer width = 567
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type pb_art from picturebutton within w_cm766_gestion_compra
integer x = 1422
integer y = 208
integer width = 114
integer height = 96
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "c:\sigre\resources\Bmp\file_open.bmp"
string disabledname = "c:\sigre\resources\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ARTICULO.COD_ART AS COD_ARTICULO,'&
								 +'ARTICULO.DESC_ART AS DESCRIPCION '&     	
								 +'FROM ARTICULO ' 

OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_art.text = lstr_seleccionar.param1[1]
end if
end event

type p_2 from picture within w_cm766_gestion_compra
integer x = 1637
integer y = 152
integer width = 78
integer height = 60
boolean bringtotop = true
string picturename = "SelectObject!"
boolean focusrectangle = false
end type

type cbx_prov from checkbox within w_cm766_gestion_compra
integer x = 2249
integer y = 144
integer width = 73
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked = true then
	sle_prov.enabled = false
	pb_prov.enabled = false
else
	sle_prov.enabled = true
	pb_prov.enabled = true
end if
end event

type sle_prov from singlelineedit within w_cm766_gestion_compra
integer x = 1637
integer y = 220
integer width = 567
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type pb_prov from picturebutton within w_cm766_gestion_compra
integer x = 2213
integer y = 212
integer width = 114
integer height = 96
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "c:\sigre\resources\Bmp\file_open.bmp"
string disabledname = "c:\sigre\resources\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS PROVEEDOR,'&
								 +'PROVEEDOR.NOM_PROVEEDOR AS NOMB_PROVEEDOR '&     	
								 +'FROM PROVEEDOR ' 

OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_prov.text = lstr_seleccionar.param1[1]
end if
end event

type p_3 from picture within w_cm766_gestion_compra
integer x = 2427
integer y = 148
integer width = 78
integer height = 60
boolean bringtotop = true
string picturename = "Custom014!"
boolean focusrectangle = false
end type

type cbx_usr from checkbox within w_cm766_gestion_compra
integer x = 2958
integer y = 140
integer width = 73
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked = true then
	sle_usr.enabled = false
	pb_usr.enabled = false
else
	sle_usr.enabled = true
	pb_usr.enabled = true
end if
end event

type sle_usr from singlelineedit within w_cm766_gestion_compra
integer x = 2427
integer y = 216
integer width = 567
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type pb_usr from picturebutton within w_cm766_gestion_compra
integer x = 3003
integer y = 208
integer width = 114
integer height = 96
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "c:\sigre\resources\Bmp\file_open.bmp"
string disabledname = "c:\sigre\resources\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT USUARIO.COD_USR AS USUARIO,'&
								 +'USUARIO.NOMBRE AS NOMBRE '&     	
								 +'FROM USUARIO ' 

OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_usr.text = lstr_seleccionar.param1[1]
end if
end event

type rb_ot from radiobutton within w_cm766_gestion_compra
integer x = 64
integer y = 396
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT"
boolean checked = true
end type

type rb_prov from radiobutton within w_cm766_gestion_compra
integer x = 402
integer y = 396
integer width = 343
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proveedor"
end type

type rb_art from radiobutton within w_cm766_gestion_compra
integer x = 823
integer y = 396
integer width = 343
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Artículo"
end type

type rb_usr from radiobutton within w_cm766_gestion_compra
integer x = 1211
integer y = 396
integer width = 503
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Agente Compras"
end type

type rb_mat from radiobutton within w_cm766_gestion_compra
integer x = 1381
integer y = 52
integer width = 334
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Materiales"
boolean checked = true
end type

type rb_serv from radiobutton within w_cm766_gestion_compra
integer x = 1783
integer y = 52
integer width = 325
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Servicios"
end type

type gb_2 from groupbox within w_cm766_gestion_compra
integer x = 32
integer y = 148
integer width = 763
integer height = 188
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "      Todas las OT      "
end type

type gb_1 from groupbox within w_cm766_gestion_compra
integer x = 818
integer y = 148
integer width = 763
integer height = 188
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "      Todos los Artículos      "
end type

type gb_3 from groupbox within w_cm766_gestion_compra
integer x = 1605
integer y = 148
integer width = 763
integer height = 188
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "      Todos los Proveedores      "
end type

type gb_4 from groupbox within w_cm766_gestion_compra
integer x = 2395
integer y = 144
integer width = 763
integer height = 188
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "      Todos los Usuarios     "
end type

type gb_5 from groupbox within w_cm766_gestion_compra
integer x = 32
integer y = 340
integer width = 1691
integer height = 148
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Mostrar información agrupada por:"
end type

type gb_6 from groupbox within w_cm766_gestion_compra
integer x = 1349
integer width = 805
integer height = 140
integer taborder = 40
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reporte"
end type

