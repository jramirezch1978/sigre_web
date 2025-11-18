$PBExportHeader$w_fi915_change_clase_bien_servicio.srw
forward
global type w_fi915_change_clase_bien_servicio from w_abc
end type
type st_ruc from statictext within w_fi915_change_clase_bien_servicio
end type
type st_proveedor from statictext within w_fi915_change_clase_bien_servicio
end type
type sle_proveedor from singlelineedit within w_fi915_change_clase_bien_servicio
end type
type rb_2 from radiobutton within w_fi915_change_clase_bien_servicio
end type
type rb_1 from radiobutton within w_fi915_change_clase_bien_servicio
end type
type cb_retrieve from commandbutton within w_fi915_change_clase_bien_servicio
end type
type sle_mes from singlelineedit within w_fi915_change_clase_bien_servicio
end type
type sle_year from singlelineedit within w_fi915_change_clase_bien_servicio
end type
type tab_1 from tab within w_fi915_change_clase_bien_servicio
end type
type tabpage_1 from userobject within tab_1
end type
type dw_cntas_pagar from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_cntas_pagar dw_cntas_pagar
end type
type tab_1 from tab within w_fi915_change_clase_bien_servicio
tabpage_1 tabpage_1
end type
end forward

global type w_fi915_change_clase_bien_servicio from w_abc
integer width = 3429
integer height = 2596
string title = "[FI915] Cambiar Clase de Bien o Servicio (SUNAT TABLA30)"
string menuname = "m_only_save"
event ue_procesar ( )
st_ruc st_ruc
st_proveedor st_proveedor
sle_proveedor sle_proveedor
rb_2 rb_2
rb_1 rb_1
cb_retrieve cb_retrieve
sle_mes sle_mes
sle_year sle_year
tab_1 tab_1
end type
global w_fi915_change_clase_bien_servicio w_fi915_change_clase_bien_servicio

type variables
u_dw_abc		idw_cntas_pagar
end variables

forward prototypes
public subroutine of_asigna_dws ()
public function boolean of_change (long al_row)
end prototypes

event ue_procesar();Long ll_row

for ll_row = 1 to idw_cntas_pagar.RowCount()
	if idw_cntas_pagar.object.chck [ll_row] = '1' then
		if not this.of_change(ll_row) then return
	end if
next

commit;
MessageBox('Aviso', 'Proceso culminado satisfactoriamente', Information!)
end event

public subroutine of_asigna_dws ();idw_cntas_pagar = tab_1.tabpage_1.dw_cntas_pagar
end subroutine

public function boolean of_change (long al_row);String 	ls_cod_relacion, ls_tipo_doc, ls_nro_doc, ls_mensaje
Long		ll_year, ll_mes, ll_nro_libro
//create or replace procedure usp_fin_chg_periodo_prov(
//       asi_cod_relacion     in proveedor.proveedor%TYPE,
//       asi_tipo_doc         in doc_tipo.tipo_doc%TYPE,
//       asi_nro_doc          in cntas_pagar.nro_doc%TYPE,
//       ani_year             in cntbl_asiento.ano%TYPE,
//       ani_mes              in cntbl_asiento.mes%TYPE,
//       ani_nro_libro        in cntbl_libro.nro_libro%TYPE
//) is

ls_cod_relacion 	= idw_cntas_pagar.object.cod_relacion 	[al_row]
ls_tipo_doc 		= idw_cntas_pagar.object.tipo_doc 		[al_row]
ls_nro_doc 			= idw_cntas_pagar.object.nro_doc 		[al_row]
ll_year 				= Long(idw_cntas_pagar.object.year_dst 		[al_row])
ll_mes 				= Long(idw_cntas_pagar.object.mes_dst			[al_row])
ll_nro_libro		= Long(idw_cntas_pagar.object.nro_libro_dst 	[al_row])

DECLARE usp_fin_chg_periodo_prov PROCEDURE FOR 
	usp_fin_chg_periodo_prov(	:ls_cod_relacion,
										:ls_tipo_doc,
										:ls_nro_doc,
										:ll_year,
										:ll_mes,
										:ll_nro_libro);
	
EXECUTE usp_fin_chg_periodo_prov ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	MessageBox('Error en Procedure usp_fin_chg_periodo_prov', ls_mensaje)
	return false
END IF

CLOSE usp_fin_chg_periodo_prov;

return true
end function

on w_fi915_change_clase_bien_servicio.create
int iCurrent
call super::create
if this.MenuName = "m_only_save" then this.MenuID = create m_only_save
this.st_ruc=create st_ruc
this.st_proveedor=create st_proveedor
this.sle_proveedor=create sle_proveedor
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_retrieve=create cb_retrieve
this.sle_mes=create sle_mes
this.sle_year=create sle_year
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_ruc
this.Control[iCurrent+2]=this.st_proveedor
this.Control[iCurrent+3]=this.sle_proveedor
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.cb_retrieve
this.Control[iCurrent+7]=this.sle_mes
this.Control[iCurrent+8]=this.sle_year
this.Control[iCurrent+9]=this.tab_1
end on

on w_fi915_change_clase_bien_servicio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_ruc)
destroy(this.st_proveedor)
destroy(this.sle_proveedor)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_retrieve)
destroy(this.sle_mes)
destroy(this.sle_year)
destroy(this.tab_1)
end on

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()
Integer li_year, li_mes

idw_cntas_pagar.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = idw_cntas_pagar              				// asignar dw corrien
idw_cntas_pagar.SetFocus()

li_year 	= Long(String(f_fecha_Actual(), 'yyyy'))
li_mes	= Long(String(f_fecha_Actual(), 'mm'))

sle_year.text = String(li_year, '0000')
sle_mes.text = String(li_mes, '00')

this.event ue_refresh()



end event

event resize;call super::resize;of_asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_cntas_pagar.width  = tab_1.tabpage_1.width  - idw_cntas_pagar.x - 10
idw_cntas_pagar.height  = tab_1.tabpage_1.height  - idw_cntas_pagar.x - 10

end event

event ue_refresh;call super::ue_refresh;Integer 	li_year, li_mes
string	ls_proveedor, ls_filtro

if rb_2.checked then
	if trim(sle_proveedor.text) = '' then
		gnvo_app.of_mensaje_error( "Debe Seleccionar un proveedor para la consulta")
		sle_proveedor.setFocus( )
		return
	end if
	
	ls_filtro = '2'
	ls_proveedor = trim(sle_proveedor.text) +'%'
	setNull(li_year)
	setNull(li_mes)
else
	ls_filtro = '1'
	SetNull(ls_proveedor)
	li_year 	= Long(sle_year.text)
	li_mes	= Long(sle_mes.text)
	
end if


idw_cntas_pagar.Retrieve(ls_filtro, li_year, li_mes, ls_proveedor)

idw_cntas_pagar.ii_protect = 0
idw_cntas_pagar.of_protect( )
end event

event ue_modify;call super::ue_modify;idw_cntas_pagar.of_protect()
//dw_detail.of_protect()
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

idw_cntas_pagar.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	idw_cntas_pagar.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_cntas_pagar.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_cntas_pagar.ii_update = 0
	
	idw_cntas_pagar.il_totdel = 0
	
	idw_cntas_pagar.ResetUpdate()
	
	idw_cntas_pagar.ii_protect = 0
	idw_cntas_pagar.of_protect( )
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
END IF

	
end event

event ue_update_pre;call super::ue_update_pre;

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( idw_cntas_pagar )  <> true then return

ib_update_check = true

end event

type st_ruc from statictext within w_fi915_change_clase_bien_servicio
integer x = 2921
integer y = 124
integer width = 521
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_proveedor from statictext within w_fi915_change_clase_bien_servicio
integer x = 1239
integer y = 124
integer width = 1669
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_proveedor from singlelineedit within w_fi915_change_clase_bien_servicio
event ue_dobleclick pbm_lbuttondblclk
integer x = 841
integer y = 124
integer width = 379
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = "SELECT P.PROVEEDOR    AS CODIGO_PROVEEDOR ,"&
							  + "P.NOM_PROVEEDOR AS NOMBRES, "&
							  + "decode(p.ruc, null, p.nro_doc_ident, p.ruc) as ruc " &
							  + "FROM PROVEEDOR P"
										 
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	This.text			= lstr_seleccionar.param1[1]
	st_proveedor.text = lstr_seleccionar.param2[1]
	st_ruc.text 		= lstr_seleccionar.param3[1]
END IF	

end event

type rb_2 from radiobutton within w_fi915_change_clase_bien_servicio
integer x = 59
integer y = 124
integer width = 759
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrar por Proveedor"
borderstyle borderstyle = styleraised!
end type

event clicked;sle_proveedor.enabled = true
sle_year.enabled = false
sle_mes.enabled = false
end event

type rb_1 from radiobutton within w_fi915_change_clase_bien_servicio
integer x = 64
integer y = 32
integer width = 759
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrar por Periodo"
boolean checked = true
borderstyle borderstyle = styleraised!
end type

event clicked;sle_proveedor.enabled = false
sle_year.enabled = true
sle_mes.enabled = true
end event

type cb_retrieve from commandbutton within w_fi915_change_clase_bien_servicio
integer x = 1614
integer y = 4
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;parent.event ue_refresh()
end event

type sle_mes from singlelineedit within w_fi915_change_clase_bien_servicio
integer x = 1166
integer y = 32
integer width = 192
integer height = 84
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_year from singlelineedit within w_fi915_change_clase_bien_servicio
integer x = 841
integer y = 32
integer width = 302
integer height = 84
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type tab_1 from tab within w_fi915_change_clase_bien_servicio
integer y = 236
integer width = 3282
integer height = 1896
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.Control[]={this.tabpage_1}
end on

on tab_1.destroy
destroy(this.tabpage_1)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3246
integer height = 1768
long backcolor = 79741120
string text = "Cntas x Pagar"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_cntas_pagar dw_cntas_pagar
end type

on tabpage_1.create
this.dw_cntas_pagar=create dw_cntas_pagar
this.Control[]={this.dw_cntas_pagar}
end on

on tabpage_1.destroy
destroy(this.dw_cntas_pagar)
end on

type dw_cntas_pagar from u_dw_abc within tabpage_1
integer width = 3374
integer height = 1588
integer taborder = 20
string dataobject = "d_abc_change_clase_bin_serv_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw

//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF

end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "clase_bien_serv"
		ls_sql = "select codigo as codigo, " &
				 + "descripcion as descripcion " &
				 + "from sunat_tabla30 " &
				 + "where flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.clase_bien_serv		[al_row] = ls_codigo
			this.object.desc_clase_bien_serv	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event itemchanged;call super::itemchanged;String ls_desc
Accepttext()

CHOOSE CASE lower(dwo.name)
	CASE 'nro_libro_dst'
		SELECT desc_libro
			INTO	 :ls_desc
		FROM   cntbl_libro
		WHERE  nro_libro = :data ; 
		
			
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Numero de Libro no existe, por favor Verifique! ',StopSign!)
			This.object.nro_libro_dst [row] = gnvo_app.is_null
			Return 1
		END IF
				
END CHOOSE


end event

