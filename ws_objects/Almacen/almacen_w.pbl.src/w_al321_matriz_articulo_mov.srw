$PBExportHeader$w_al321_matriz_articulo_mov.srw
forward
global type w_al321_matriz_articulo_mov from w_abc
end type
type dw_master from u_dw_abc within w_al321_matriz_articulo_mov
end type
type cb_1 from commandbutton within w_al321_matriz_articulo_mov
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_al321_matriz_articulo_mov
end type
type gb_fechas from groupbox within w_al321_matriz_articulo_mov
end type
type gb_1 from groupbox within w_al321_matriz_articulo_mov
end type
type sle_descrip from singlelineedit within w_al321_matriz_articulo_mov
end type
type cbx_1 from checkbox within w_al321_matriz_articulo_mov
end type
type sle_almacen from singlelineedit within w_al321_matriz_articulo_mov
end type
type st_2 from statictext within w_al321_matriz_articulo_mov
end type
end forward

global type w_al321_matriz_articulo_mov from w_abc
integer width = 3026
integer height = 1680
string title = "[AL321] Matriz Contable en mov Almacen"
string menuname = "m_save_filtro_param"
event ue_retrieve ( )
event ue_saveas ( )
dw_master dw_master
cb_1 cb_1
uo_fecha uo_fecha
gb_fechas gb_fechas
gb_1 gb_1
sle_descrip sle_descrip
cbx_1 cbx_1
sle_almacen sle_almacen
st_2 st_2
end type
global w_al321_matriz_articulo_mov w_al321_matriz_articulo_mov

type variables
string is_flag_matriz_contab, il_afecta_pto, is_salir
end variables

forward prototypes
public function integer of_get_param ()
end prototypes

event ue_retrieve();string 	ls_almacen, ls_mensaje
Date 		ld_fecha1, ld_fecha2

This.Event dynamic ue_update_Request()

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

//create or replace procedure USP_ALM_ACTUALIZA_MATRIZ_CNT(
//       ad_del in date, 
//       ad_al  in date 
//) is

DECLARE USP_ALM_ACTUALIZA_MATRIZ_CNT PROCEDURE FOR
	USP_ALM_ACTUALIZA_MATRIZ_CNT( :ld_fecha1, :ld_fecha2 );

EXECUTE USP_ALM_ACTUALIZA_MATRIZ_CNT;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_ALM_ACTUALIZA_MATRIZ_CNT:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return
END IF

CLOSE USP_ALM_ACTUALIZA_MATRIZ_CNT;

if cbx_1.Checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' or IsNull(sle_almacen.text) then
		MessageBox('Aviso', 'Debe indicar algun almacen')
		return
	end if
	ls_almacen = trim(sle_almacen.text) + '%'
end if

dw_master.Retrieve(ls_almacen, ld_fecha1, ld_fecha2)
dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()

end event

event ue_saveas();dw_master.Saveas( )
end event

public function integer of_get_param ();// Evalua parametros
Int li_ret = 1

// busca tipos de movimiento definidos
SELECT flag_matriz_contab
  INTO :is_flag_matriz_contab
FROM logparam  
where reckey = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en LogParam')
	return 0
end if

if sqlca.sqlcode < 0 then
	Messagebox( "Error en busqueda parametros", sqlca.sqlerrtext)
	return 0	
end if

if ISNULL( is_flag_matriz_contab ) or TRIM( is_flag_matriz_contab ) = '' then
	Messagebox("Error de parametros", "Defina FLAG_MATRIZ_CONTAB en logparam")
	return 0
end if

return 1

end function

on w_al321_matriz_articulo_mov.create
int iCurrent
call super::create
if this.MenuName = "m_save_filtro_param" then this.MenuID = create m_save_filtro_param
this.dw_master=create dw_master
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.gb_fechas=create gb_fechas
this.gb_1=create gb_1
this.sle_descrip=create sle_descrip
this.cbx_1=create cbx_1
this.sle_almacen=create sle_almacen
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.gb_fechas
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.sle_descrip
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.sle_almacen
this.Control[iCurrent+9]=this.st_2
end on

on w_al321_matriz_articulo_mov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.gb_fechas)
destroy(this.gb_1)
destroy(this.sle_descrip)
destroy(this.cbx_1)
destroy(this.sle_almacen)
destroy(this.st_2)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	
	dw_master.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_master.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
	END IF
END IF

end event

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery() 
end if

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente

end event

event ue_update_pre;call super::ue_update_pre;Long 		ll_x, ll_row[]

of_get_row_update(dw_master, ll_row[])

ib_update_check = true
For ll_x = 1 TO UpperBound(ll_row)
	//Validar registro ll_x
	IF string(dw_master.object.flag_gen_asnt_autom[ll_row[ll_x]]) = '0' THEN
		MessageBox('Error', 'Mes Contable ya esta cerrado para este registro'  )
		dw_master.SelectRow(0,false)
		dw_master.SelectRow(ll_row[ll_x], true)
		dw_master.SetRow(ll_row[ll_x])
		dw_master.SetColumn('matriz')
		
		ib_update_check = False
		return
	END IF
NEXT


dw_master.of_set_flag_replicacion()

end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if


end event

type dw_master from u_dw_abc within w_al321_matriz_articulo_mov
integer y = 308
integer width = 2752
integer height = 1140
integer taborder = 30
string dataobject = "d_abc_matriz_contable_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

end event

event itemchanged;call super::itemchanged;string 	ls_data

this.AcceptText()

choose case lower(dwo.name)
	case "centro_benef"
		
		select desc_centro
			into :ls_data
		from centro_beneficio
		where centro_benef = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Centro de Beneficio no existe o no está activo", StopSign!)
			this.object.centro_benef	[row] = gnvo_app.is_null
			this.object.desc_centro		[row] = gnvo_app.is_null
			return 1
		end if

		this.object.desc_centro	[row] = ls_data
	
	case "cencos"
		
		select desc_cencos
			into :ls_data
		from centros_costo
		where cencos 		= :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Centro de Costo " + data + " no existe o no está activo", StopSign!)
			this.object.cencos		[row] = gnvo_app.is_null
			this.object.desc_Cencos	[row] = gnvo_app.is_null
			return 1
		end if

		this.object.desc_centro	[row] = ls_data
	
	case "matriz"
		
		select m.descripcion
			into :ls_data
		from matriz_cntbl_finan m
		where matriz = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Matriz Contable " + data + " no existe o no está activo", StopSign!)
			this.object.matriz				[row] = gnvo_app.is_null
			this.object.desc_matriz_cntbl	[row] = gnvo_app.is_null
			return 1
		end if

		this.object.desc_matriz_cntbl	[row] = ls_data
end choose
end event

event ue_display;call super::ue_display;// Abre ventana de ayuda 
String 	ls_tipo_mov, ls_cencos, ls_cnta_prsp, &
    		ls_grp_cntbl, ls_matriz, ls_null, ls_sub_cat, ls_cod_art
string 	ls_data, ls_sql, ls_codigo
Long 		ll_count, ll_afecta_pto
Integer	li_year
str_parametros sl_param

choose case lower(as_columna)
	case 'centro_benef'
		ls_sql = "SELECT centro_benef AS CODIGO_CenBef, " &
				  + "desc_centro AS DESCRIPCION_centro_benef " &
				  + "FROM centro_beneficio " &
				  + "where flag_estado = '1' " 
					 
		f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.centro_benef[al_row] = ls_codigo
			this.object.desc_centro	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case 'cencos'
		li_year = year(Date(this.object.fec_registro [al_row]))
		
		ls_sql = "SELECT distinct cc.cencos AS CODIGO_cencos, " &
				  + "cc.desc_cencos AS DESCRIPCION_centro_costo " &
				  + "FROM centros_Costo cc, " &
				  + "presupuesto_partida pp " &
				  + "where pp.cencos = cc.cencos " &
				  + "   and cc.flag_estado = '1' " &
				  + "  and pp.ano = " + string(li_year)
					 
		f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.object.cnta_prsp	[al_row] = ls_null
			this.ii_update = 1
		end if
		
		return

	case 'cnta_prsp'
		li_year = year(Date(this.object.fec_registro [al_row]))
		ls_cencos = this.object.cencos [al_row]
		
		ls_sql = "SELECT distinct pp.cnta_prsp AS CODIGO_cnta_prsp, " &
				  + "pp.descripcion AS DESCRIPCION_cnta_prsp " &
				  + "FROM presupuesto_cuenta pc, " &
				  + "presupuesto_partida pp " &
				  + "where pp.cnta_prsp = pc.cnta_prsp " &
				  + "   and pc.flag_estado = '1' " &
				  + "   and pc.cencos = '" + ls_cencos + "' " &
				  + "  and pp.ano = " + string(li_year)
					 
		f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
		return

	case "matriz"
		// Busco la matriz contable por Codigo de SubCategoria del Articulo
		ls_cod_art = this.object.cod_Art [al_row]
		if IsNull(ls_cod_art) or trim(ls_cod_art) = '' then
			MessageBox('Error', 'Debe indicar un codigo de articulo valido, por favor verifique!', StopSign!)
			this.SetColumn('cod_art')
			return
		end if
		
		select sub_cat_art
			into :ls_sub_cat
		from articulo
		where cod_art = :ls_cod_art
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Codigo de Articulo ' + ls_cod_art + ' no existe o no se encuentra activo.', StopSign!)
			return
		end if
		
		if IsNull(ls_sub_cat) or trim(ls_sub_cat) = '' then
			MessageBox('Error', 'No se ha definido Codigo de Sub Categoria en Articulo ' + ls_cod_art &
				+ ', por favor verifique!', StopSign!)
			return
		end if
		
		ls_tipo_mov = this.object.tipo_mov [al_row]
		
		select nvl(amt.factor_presup, 0)
			into :ll_afecta_pto
		from  articulo_mov_tipo amt
		where amt.tipo_mov = :ls_tipo_mov
		  and amt.flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Tipo de movimiento ' + ls_tipo_mov + ' no existe o no se encuentra activo.', StopSign!)
			return
		end if
		
		if ll_afecta_pto = 0  then
			ls_grp_cntbl = '%%'
		else
			ls_cencos 	 = this.object.cencos	[al_row]
			
			// Busca grp_cntbl segun centro de costo
			Select NVL(trim(cc.grp_cntbl), '%') || '%'
				into :ls_grp_cntbl 
			from centros_costo cc
			where cc.cencos 		= :ls_cencos
			  and cc.flag_estado = '1';

			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Centro de Costos ' + ls_cencos &
					+ ' no existe o no se encuentra activo. Por favor verifique!', StopSign!)
				return
			end if
			
			
		end if
		
		sl_param.dw1 		= "d_sel_tipo_mov_matriz_subcat"
		sl_param.titulo 	= "Matrices de movimiento almacen"
		sl_param.tipo 		= '1S2S3S'
		sl_param.string1 	= ls_tipo_mov
		sl_param.string2 	= ls_grp_cntbl
		sl_param.string3 	= ls_sub_cat
		sl_param.factor_prsp = ll_afecta_pto  	// Factor Presupuesto de Tipo_mov
		sl_param.field_ret_i[1] = 1				// Grupo
		sl_param.field_ret_i[2] = 2				// Subcategoria
		sl_param.field_ret_i[3] = 3				// Matriz
	
		OpenWithParm( w_search, sl_param)		
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then		
			//Asigno la matriz contable
			ls_grp_cntbl 				= sl_param.field_ret[1]
			ls_sub_cat 				   = sl_param.field_ret[2]
			ls_matriz 				   = sl_param.field_ret[3]
			
			if ll_afecta_pto <> 0 then
				ls_cencos 	 = this.object.cencos[al_row]
			
				// Verifica que codigo exista
				Select count(tipo_mov) 
					into :ll_count 
				from tipo_mov_matriz_subcat
				Where tipo_mov 	= :ls_tipo_mov 
				  and grp_cntbl 	= :ls_grp_cntbl 
				  and cod_sub_Cat	= :ls_sub_cat
				  and matriz 		= :ls_matriz;		
				  
				if ll_count = 0 then			
					Messagebox( "Error", "Matriz elegida no corresponde a la información ingresada." &
												+ "~r~nTipo de movimiento SI afecta presupuesto." &					
												+ "~r~nMatriz: " + ls_matriz &
												+ "~r~nTipo Mov: " + ls_tipo_mov &
												+ "~r~nGrupo Contable: " + ls_grp_cntbl &
												+ "~r~nSub Categoría: " + ls_sub_cat, StopSign!)
					this.object.matriz[al_row] = gnvo_app.is_null
					return 
				end if		
				
				
				
			else
				
				// Verifica que codigo exista
				Select count(tipo_mov) 
					into :ll_count 
				from tipo_mov_matriz_subcat
				Where tipo_mov 	= :ls_tipo_mov 
				  and matriz 		= :ls_matriz
				  and cod_sub_cat = :ls_sub_cat;		
				  
				if ll_count = 0 then			
					Messagebox( "Error", "Matriz elegida no corresponde a la información ingresada." &
												+ "~r~nTipo de movimiento NO afecta presupuesto." &					
												+ "~r~nMatriz: " + ls_matriz &
												+ "~r~nTipo Mov: " + ls_tipo_mov &
												+ "~r~nSub Categoría: " + ls_sub_cat, StopSign!)
					this.object.matriz[al_row] = gnvo_app.is_null
					return 
				end if		
				
			end if
			
			select m.descripcion
				into :ls_data
			from matriz_cntbl_finan m
			where matriz = :ls_matriz;

			
			this.object.matriz				[al_row] = ls_matriz
			this.object.desc_matriz_cntbl	[al_row] = ls_data
			this.ii_update = 1
		END IF
		
end choose



end event

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

type cb_1 from commandbutton within w_al321_matriz_articulo_mov
integer x = 2597
integer y = 20
integer width = 325
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Recuperar"
end type

event clicked;Parent.Event dynamic ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas_v within w_al321_matriz_articulo_mov
event destroy ( )
integer x = 78
integer y = 60
integer taborder = 30
long backcolor = 67108864
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type gb_fechas from groupbox within w_al321_matriz_articulo_mov
integer x = 59
integer width = 667
integer height = 300
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_1 from groupbox within w_al321_matriz_articulo_mov
integer x = 731
integer width = 1746
integer height = 300
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

type sle_descrip from singlelineedit within w_al321_matriz_articulo_mov
integer x = 1303
integer y = 72
integer width = 1157
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_al321_matriz_articulo_mov
integer x = 782
integer y = 184
integer width = 951
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los almacenes"
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type sle_almacen from singlelineedit within w_al321_matriz_articulo_mov
event dobleclick pbm_lbuttondblclk
integer x = 1074
integer y = 72
integer width = 224
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc

end event

type st_2 from statictext within w_al321_matriz_articulo_mov
integer x = 768
integer y = 84
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
boolean focusrectangle = false
end type

