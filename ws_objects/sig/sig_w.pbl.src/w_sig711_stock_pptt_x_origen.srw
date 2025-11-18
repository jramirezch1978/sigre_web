$PBExportHeader$w_sig711_stock_pptt_x_origen.srw
forward
global type w_sig711_stock_pptt_x_origen from w_report_smpl
end type
type cb_lectura from commandbutton within w_sig711_stock_pptt_x_origen
end type
type uo_1 from u_ingreso_rango_fechas within w_sig711_stock_pptt_x_origen
end type
type st_1 from statictext within w_sig711_stock_pptt_x_origen
end type
type st_2 from statictext within w_sig711_stock_pptt_x_origen
end type
type sle_cat from singlelineedit within w_sig711_stock_pptt_x_origen
end type
type sle_1 from singlelineedit within w_sig711_stock_pptt_x_origen
end type
type pb_1 from picturebutton within w_sig711_stock_pptt_x_origen
end type
type rb_pptt from radiobutton within w_sig711_stock_pptt_x_origen
end type
type rb_subp from radiobutton within w_sig711_stock_pptt_x_origen
end type
type gb_1 from groupbox within w_sig711_stock_pptt_x_origen
end type
type gb_2 from groupbox within w_sig711_stock_pptt_x_origen
end type
end forward

global type w_sig711_stock_pptt_x_origen from w_report_smpl
integer width = 3177
integer height = 1276
string title = "Stock de productos terminados (SIG711)"
string menuname = "m_rpt_simple_correo"
cb_lectura cb_lectura
uo_1 uo_1
st_1 st_1
st_2 st_2
sle_cat sle_cat
sle_1 sle_1
pb_1 pb_1
rb_pptt rb_pptt
rb_subp rb_subp
gb_1 gb_1
gb_2 gb_2
end type
global w_sig711_stock_pptt_x_origen w_sig711_stock_pptt_x_origen

type variables
String	is_oper, is_clase
decimal{4} idc_cantidad
end variables

forward prototypes
public function integer of_get_parametros (ref string as_clase, ref string as_oper_ing_prod)
end prototypes

public function integer of_get_parametros (ref string as_clase, ref string as_oper_ing_prod);Long		ll_rc = 0
String	ls_clase


SELECT CLASE_PROD_TERM
  INTO :as_clase
  FROM SIGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer SIGPARAM')
	lL_rc = -1
END IF

SELECT OPER_ING_PROD
  INTO :as_oper_ing_prod
  FROM LOGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -2
END IF

RETURN ll_rc

end function

on w_sig711_stock_pptt_x_origen.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple_correo" then this.MenuID = create m_rpt_simple_correo
this.cb_lectura=create cb_lectura
this.uo_1=create uo_1
this.st_1=create st_1
this.st_2=create st_2
this.sle_cat=create sle_cat
this.sle_1=create sle_1
this.pb_1=create pb_1
this.rb_pptt=create rb_pptt
this.rb_subp=create rb_subp
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lectura
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_cat
this.Control[iCurrent+6]=this.sle_1
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.rb_pptt
this.Control[iCurrent+9]=this.rb_subp
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
end on

on w_sig711_stock_pptt_x_origen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_lectura)
destroy(this.uo_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_cat)
destroy(this.sle_1)
destroy(this.pb_1)
destroy(this.rb_pptt)
destroy(this.rb_subp)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_mail_send;//Override
long ll_i
string ls_subject, ls_note
sg_parametros lsg_parametros
n_cst_email	lnv_mail
lnv_mail = CREATE n_cst_email

lsg_parametros.dw1 = 'd_lista_usuarios_con_email'
lsg_parametros.titulo = 'Lista de Usuarios con E-mail'
lsg_parametros.db1 = 1000
lsg_parametros.opcion = 17

openwithparm(w_abc_seleccion_lista,lsg_parametros)

if isvalid(message.powerobjectparm) then
	lsg_parametros = message.powerobjectparm
else
	messagebox('Aviso','Ocurrio un error al momento de pasar los parametros, No ha seleccionado ningun usuario')
	return
end if

ls_subject = 'Capacidad Maxima Excedida'
ls_note	  = 'El Stock fisico existente a superado la capacidad de almacenamiento de los almacenes con '+string(idc_cantidad, '###,###,##0')+'. (Capacidad Maxima 100,000 UND)'

for ll_i = 1 to upperbound(lsg_parametros.field_ret[])
	lnv_mail.of_logon()
	lnv_mail.of_send_mail(lsg_parametros.field_ret_s[ll_i], lsg_parametros.field_ret[ll_i], ls_subject, ls_note) 
	lnv_mail.of_logoff()
next

destroy lnv_mail
end event

type dw_report from w_report_smpl`dw_report within w_sig711_stock_pptt_x_origen
integer x = 37
integer y = 484
integer width = 3003
integer height = 560
string dataobject = "d_rpt_sig_stock_pptt_x_origen_tbl"
boolean hsplitscroll = true
end type

event dw_report::doubleclicked;call super::doubleclicked;LONG ll_col, ll_static, li_pos
STRING ls_col, ls_objects, ls_value, ls_col1, &
		 ls_numero, ls_oper_vnta_terc, ls_data, &
 		 ls_origen, ls_cod_art, ls_tipo, ls_oper_ing_prod, &
		 ls_doc_otr, ls_doc_ov
Date ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

sg_parametros lstr_rep

if row=0 then  return

IF this.Rowcount() = 0 then return

//HALLANDO EL VALOR DE ORIGEN
ll_col = this.GetClickedColumn()

dw_report.modify('datawindow.crosstab.staticmode=yes')

ls_objects=dw_report.object.datawindow.objects
ls_col = dw_report.Describe("#" + String(ll_col) + ".name")
li_pos = pos(ls_col,'_x')
If len(ls_col) > li_pos + 1 then
	ls_numero = mid(ls_col,li_pos+2)
else
	ls_numero = ''
end if
ls_col1 = "t_origen"+ls_numero
ls_origen = dw_report.DESCRIBE(ls_col1+".text")

ls_cod_art = this.object.cod_art [row]

ls_origen = trim(mid(ls_origen,3,len(trim(ls_origen))))

lstr_rep.string1 = ls_origen
lstr_rep.string2 = ls_cod_art
lstr_rep.date1 = ld_fec_ini
lstr_rep.date2 = ld_fec_fin

select l.oper_ing_prod , l.oper_vnta_terc, l.doc_otr, l.doc_ov
  into :ls_oper_ing_prod, :ls_oper_vnta_terc, :ls_doc_otr, :ls_doc_ov
from logparam l where l.reckey='1' ;

if Mid(Lower(dwo.name),1,4) = 'prod' then
	lstr_rep.string3 = ls_oper_ing_prod
	ls_tipo = 'PROD'

elseif Mid(Lower(dwo.name),1,4) = 'vent' then
	ls_tipo = 'VENT'

elseif Mid(Lower(dwo.name),1,4) = 'desp' then
	lstr_rep.string3 = ls_oper_vnta_terc	
	ls_tipo = 'DESP'

elseif Mid(Lower(dwo.name),1,4) = 'tras' then	
	lstr_rep.string3= ls_doc_otr	
	ls_tipo = 'TRAS'

elseif Mid(Lower(dwo.name),1,7) = 'stock_t' then	
	ls_tipo = 'STKT'

elseif Mid(Lower(dwo.name),1,7) = 'stock_f' then		
	ls_tipo = 'STKF'

elseif Mid(Lower(dwo.name),1,4) = 'pend' then
	lstr_rep.string3 = ls_doc_ov
	ls_tipo = 'PEND'
	
elseif Mid(Lower(dwo.name),1,4) = 'disp' then
	if (messagebox('Aviso','Esta Consulta puede tardar varios minutos, Desea Proseguir?',Question!,YesNo!,1)) = 2 then return
	ls_tipo = 'DISP'

end if 

lstr_rep.tipo = ls_tipo

OpenSheetWithParm(w_sig711_stock_pptt_x_origen_detalle, lstr_rep, w_main, 2, layered!)

end event

event dw_report::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type cb_lectura from commandbutton within w_sig711_stock_pptt_x_origen
integer x = 2281
integer y = 252
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;//Parent.Event ue_retrieve()

date ld_fec_ini, ld_fec_fin
datetime ldt_fec_ini, ldt_fec_fin
String ls_msj_err
Long ln_count
decimal{4} ldc_cana, ln_cantidad//, ldc_bagazo, ldc_melaza

ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()  

select count(*)
  into :ln_count
  from calendario_produccion cc 
 where fecha_prod = :ld_fec_ini ;

IF ln_count > 0 THEN
	// Inicio
	select del_dia 
	  into :ldt_fec_ini 
	  from calendario_produccion cc 
	 where fecha_prod = :ld_fec_ini ;
	 
	// Fin
	select al_dia 
	  into :ldt_fec_fin
	  from calendario_produccion cc 
	 where fecha_prod = :ld_fec_fin ;
ELSE
	ldt_fec_ini = datetime( ld_fec_ini, time('00:00:00') )
	ldt_fec_fin = datetime( ld_fec_fin, time('00:00:00') )
END IF

SetPointer(hourglass!)

DECLARE PB_USP_SIG_STOCK_PPTT_X_ORIGEN PROCEDURE FOR USP_SIG_STOCK_PPTT_X_ORIGEN
(:ldt_fec_ini, :ldt_fec_fin );
EXECUTE PB_USP_SIG_STOCK_PPTT_X_ORIGEN ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error',ls_msj_err)
	Return
END IF

select round(avg(dia),3)
  into :ldc_cana
  from lab_calculo_prod
 where trunc(fecha) >= :ld_fec_ini
   and trunc(fecha) <= :ld_fec_fin
	and cod_calculo = 'P001'; // caña Sucia

SELECT nvl(sum( decode(amt.factor_sldo_total, 1, nvl(am.cant_procesada,0), nvl(am.cant_procesada,0)*-1)),0)
  INTO :ln_cantidad
  FROM vale_mov vm, articulo_mov am, articulo_mov_tipo amt, almacen a
 WHERE ( vm.cod_origen = am.cod_origen and
        vm.nro_vale = am.nro_vale ) 
   AND ( vm.tipo_mov = amt.tipo_mov ) 
   AND ( vm.almacen = a.almacen ) 
   AND ( vm.flag_estado <> '0' and
         am.flag_estado <> '0' and
         am.cod_origen = :GS_ORIGEN and
         trim(am.cod_art) in (select trim(descripcion)
			  				      	  from rpt_subgrupo
								  		 where reporte = 'MOVAZUDI'
											and TRIM(grupo) in ('GRP1','GRP2','GRP3','GRP4') ) and
         a.flag_tipo_almacen = 'T' and 
         amt.flag_ajuste_valorizacion='0' And
         a.cod_origen = :gs_origen)
   AND (trunc(vm.fec_registro) <= trunc(:ld_fec_fin));

if isnull(ln_cantidad) then ln_cantidad = 0

idw_1.retrieve(ld_fec_ini,ld_fec_fin,ldc_cana, gs_empresa, gs_user)

if ln_cantidad > 100000 then
	st_1.visible = true
	st_1.text = 'El Stock fisico existente a superado la capacidad de almacenamiento de los almacenes con '+string(ln_cantidad, '###,###,##0')+'. (Capacidad Maxima 100,000 UND)'
	idc_cantidad = ln_cantidad
else
	st_1.visible = false
end if

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error',ls_msj_err)
	Return
END IF

CLOSE PB_USP_SIG_STOCK_PPTT_X_ORIGEN ;

idw_1.ii_zoom_actual = 170

SetPointer(Arrow!)

idw_1.object.p_logo.filename = gs_logo

ib_preview = false

event ue_preview()

idw_1.visible=true

commit;


end event

type uo_1 from u_ingreso_rango_fechas within w_sig711_stock_pptt_x_origen
integer x = 887
integer y = 260
integer taborder = 40
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type st_1 from statictext within w_sig711_stock_pptt_x_origen
boolean visible = false
integer x = 1934
integer y = 1048
integer width = 1321
integer height = 196
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 134217752
string text = "El Stock fisico existente a superado la capacidad de almacenamiento de los almacenes. (Capacidad Maxima 100,000 UND)"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_2 from statictext within w_sig711_stock_pptt_x_origen
integer x = 859
integer y = 88
integer width = 558
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Categoria de articulo :"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_cat from singlelineedit within w_sig711_stock_pptt_x_origen
integer x = 1445
integer y = 76
integer width = 215
integer height = 80
integer taborder = 40
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

event modified;Long ll_count 
String ls_categoria, ls_clase 

ls_categoria = TRIM(sle_cat.text) 

IF rb_pptt.checked = TRUE THEN
	SELECT s.clase_prod_term 
	  INTO :ls_clase
	  FROM SIGPARAM s 
	 WHERE reckey='1';
ELSE
	SELECT s.clase_sub_prod 
	  INTO :ls_clase 
	  FROM SIGPARAM s 
	 WHERE reckey='1';
END IF

SELECT count(*) 
  INTO :ll_count 
  FROM articulo_categ aca, articulo_sub_categ asu, articulo a, SIGPARAM sg 
 WHERE aca.cat_art=asu.cat_art and 
       asu.cod_sub_cat=a.sub_cat_art and 
       a.cod_clase=sg.clase_prod_term and 
		 a.cod_clase = :ls_clase and 
		 aca.cat_art = :ls_categoria ;
		 
IF ll_count=0 THEN
	MessageBox('Aviso','Categoria de artículo errada')
	sle_cat.text=''
	Return
END IF 

end event

type sle_1 from singlelineedit within w_sig711_stock_pptt_x_origen
integer x = 1815
integer y = 76
integer width = 1175
integer height = 80
integer taborder = 50
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

type pb_1 from picturebutton within w_sig711_stock_pptt_x_origen
integer x = 1682
integer y = 76
integer width = 114
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\Source\BMP\file_open.bmp"
end type

type rb_pptt from radiobutton within w_sig711_stock_pptt_x_origen
integer x = 110
integer y = 108
integer width = 640
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Producto terminado"
boolean checked = true
end type

type rb_subp from radiobutton within w_sig711_stock_pptt_x_origen
integer x = 110
integer y = 196
integer width = 434
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Subproducto"
end type

type gb_1 from groupbox within w_sig711_stock_pptt_x_origen
integer x = 850
integer y = 188
integer width = 1358
integer height = 196
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Fechas"
end type

type gb_2 from groupbox within w_sig711_stock_pptt_x_origen
integer x = 64
integer y = 24
integer width = 2962
integer height = 388
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

