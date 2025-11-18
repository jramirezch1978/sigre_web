$PBExportHeader$w_al002_articulo_mov_tipo.srw
forward
global type w_al002_articulo_mov_tipo from w_abc_master
end type
type dw_lista from u_dw_list_tbl within w_al002_articulo_mov_tipo
end type
end forward

global type w_al002_articulo_mov_tipo from w_abc_master
integer width = 2053
integer height = 2268
string title = "Mantenimiento de Tipo de Movimientos (AL002)"
string menuname = "m_mantenimiento_sl"
boolean maxbox = false
boolean resizable = false
dw_lista dw_lista
end type
global w_al002_articulo_mov_tipo w_al002_articulo_mov_tipo

forward prototypes
public function integer of_set_campos ()
end prototypes

public function integer of_set_campos ();Long ll_row
String ls_null
if dw_master.GetRow() = 0 then return 0

SetNull(ls_null)
ll_row = dw_master.GetRow()

if isnull( dw_master.object.factor_sldo_total[ll_row] ) then
	dw_master.object.factor_sldo_total[ll_row] = 0
end if

if isnull( dw_master.object.factor_sldo_sol[ll_row] ) then
	dw_master.object.factor_sldo_sol[ll_row] = 0
end if

if isnull( dw_master.object.factor_sldo_x_llegar[ll_row] ) then
	dw_master.object.factor_sldo_x_llegar[ll_row] = 0
end if

if isnull( dw_master.object.factor_sldo_dev[ll_row] ) then
	dw_master.object.factor_sldo_dev[ll_row] = 0
end if

if isnull( dw_master.object.factor_sldo_pres[ll_row] ) then
	dw_master.object.factor_sldo_pres[ll_row] = 0
end if

if isnull( dw_master.object.factor_sldo_consig[ll_row] ) then
	dw_master.object.factor_sldo_consig[ll_row] = 0
end if

if isnull( dw_master.object.factor_ctrl_templa[ll_row] ) then
	dw_master.object.factor_ctrl_templa[ll_row] = 0
end if

if isnull( dw_master.object.flag_solicita_ref[ll_row] ) then
	dw_master.object.flag_solicita_ref[ll_row] = '0'
end if

if isnull( dw_master.object.flag_solicita_lote[ll_row] ) then
	dw_master.object.flag_solicita_lote[ll_row] = '0'
end if

if dw_master.object.flag_solicita_ref[ll_row] = '0' then  // no requerido
	dw_master.object.flag_clase_mov.background.color = RGB(192,192,192)	
	dw_master.object.flag_clase_mov.protect = 1
	dw_master.object.flag_clase_mov.ddlb.required = 'no'
	dw_master.object.flag_clase_mov[ll_row] = ls_null
else
	dw_master.object.flag_clase_mov.background.color = RGB(255,255,255)			
	dw_master.object.flag_clase_mov.protect = 0
	dw_master.object.flag_clase_mov.ddlb.required = 'yes'			
end if	

if dw_master.object.flag_solicita_lote[ll_row] = '0' then  // no requerido
	dw_master.object.factor_ctrl_templa.background.color = RGB(192,192,192)	
	dw_master.object.factor_ctrl_templa.protect = 1
	dw_master.object.factor_ctrl_templa[ll_row] = 0
else
	dw_master.object.factor_ctrl_templa.background.color = RGB(255,255,255)			
	dw_master.object.factor_ctrl_templa.protect = 0
end if	

return 1
end function

on w_al002_articulo_mov_tipo.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.dw_lista=create dw_lista
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
end on

on w_al002_articulo_mov_tipo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar( this) 
ii_pregunta_delete = 1
ib_log = TRUE

end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores


ib_update_check = True
dw_master.of_set_flag_replicacion( )
end event

event ue_modify;call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.tipo_mov.Protect)

IF li_protect = 0 THEN
   dw_master.Object.tipo_mov.Protect = 1
END IF

this.of_set_campos()
end event

type dw_master from w_abc_master`dw_master within w_al002_articulo_mov_tipo
event ue_display ( string as_columna,  long al_row )
integer x = 18
integer y = 552
integer width = 1998
integer height = 1544
string dataobject = "d_abc_articulo_mov_tipo_ff"
boolean hscrollbar = false
boolean vscrollbar = false
borderstyle borderstyle = styleraised!
end type

event dw_master::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
Long		il_factor_sldo_total


choose case lower(as_columna)
		
	case "tipo_mov_dev"
		il_factor_sldo_total = Long(this.object.factor_sldo_total[al_row])
		
		if il_factor_sldo_total = 0 then
			MessageBox('Aviso', 'Debe indicar el factor Saldo Total para saber si es un ingreso o salida')
			return
		end if
		
		ls_sql = "SELECT tipo_mov AS CODIGO_tipo_mov, " &
				 + "DESC_tipo_mov AS DESCRIPCION_tipo_mov " &
				 + "FROM ARTICULO_MOV_TIPO " &
				 + "WHERE FLAG_ESTADO = '1' " &
				 + "AND FACTOR_SLDO_TOTAL = " + string(il_factor_sldo_total * -1) 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_mov_dev [al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "cod_sunat"
		
		ls_sql = "SELECT codigo as codigo_sunat,  " &
				 + "descripcion as descripcion_operacion " &
				 + "FROM sunat_tabla12 T " &
				 + "where flag_estado <> '0' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_sunat 				[al_row] = ls_codigo
			this.object.desc_tipo_operacion 	[al_row] = ls_data
			this.ii_update = 1
		end if
end choose

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectura de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_null
SetNull(ls_null)

this.object.flag_solicita_ref			[al_row] = '0'
this.object.flag_solicita_prov		[al_row] = '0'
this.object.flag_solicita_doc_int	[al_row] = '0'
this.object.flag_solicita_doc_ext	[al_row] = '0'
this.object.flag_solicita_precio		[al_row] = '0'
this.object.flag_contabiliza			[al_row] = '0'
this.object.flag_ajuste_valorizacion[al_row] = '0'
this.object.flag_estado					[al_row] = '1'
this.object.flag_solicita_cenbef		[al_row] = '0'
this.object.flag_solicita_lote		[al_row] = '0'
this.object.flag_amp						[al_row] = '1'
this.object.flag_clase_mov				[al_row] = ls_null

this.object.factor_presup			[al_row] = 0
this.object.factor_sldo_total		[al_row] = 0
this.object.factor_sldo_x_llegar	[al_row] = 0
this.object.factor_sldo_sol		[al_row] = 0
this.object.factor_sldo_dev		[al_row] = 0
this.object.factor_sldo_pres		[al_row] = 0
this.object.factor_sldo_consig	[al_row] = 0
this.object.factor_ctrl_templa	[al_row] = 0

this.object.flag_clase_mov.protect = 1
this.object.flag_clase_mov.ddlb.required = 'no'
this.object.flag_clase_mov[al_row] = ls_null
end event

event dw_master::itemchanged;call super::itemchanged;String ls_desc

this.AcceptText()

if dwo.name = 'flag_solicita_ref' then
	if data = '0' or isnull( data) then  // no requerido
		this.object.flag_clase_mov.background.color = RGB(192,192,192)	
		this.object.flag_clase_mov.protect = 1
		this.object.flag_clase_mov.ddlb.required = 'no'
		this.object.flag_clase_mov[row] = gnvo_app.is_null
	else
		this.object.flag_clase_mov.background.color = RGB(255,255,255)			
		this.object.flag_clase_mov.protect = 0
		this.object.flag_clase_mov.ddlb.required = 'yes'			
	end if	
	return
end if

if dwo.name = 'flag_solicita_lote' then
	if data = '0' or isnull( data) then  // no requerido
		this.object.factor_ctrl_templa.background.color = RGB(192,192,192)	
		this.object.factor_ctrl_templa.protect = 1
		this.object.factor_ctrl_templa[row] = 0
	else
		this.object.factor_ctrl_templa.background.color = RGB(255,255,255)			
		this.object.factor_ctrl_templa.protect = 0
	end if	
	return
end if

if dwo.name = 'cod_sunat' then
	SELECT descripcion
		into :ls_Desc
	FROM sunat_tabla12 T
	where flag_estado <> '0'
	  and codigo = :data;
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Error', 'Codigo de Sunat para tipo de operacion no existe o no esta activo, por favor verifique!')
		this.object.cod_sunat 				[row] = gnvo_app.is_null
		this.object.desc_tipo_operacion 	[row] = gnvo_app.is_null
		return
	end if
	
	this.object.desc_tipo_operacion [row] = ls_desc
end if


return

end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

type dw_lista from u_dw_list_tbl within w_al002_articulo_mov_tipo
integer x = 18
integer y = 24
integer width = 1998
integer height = 524
boolean bringtotop = true
string dataobject = "d_abc_articulo_mov_tipo_tbl"
end type

event ue_output;call super::ue_output;if al_row = 0 then return
THIS.EVENT ue_retrieve_det(al_row)

if dw_master.GetRow() = 0 then return

dw_master.ScrollToRow(al_row)
dw_master.il_row = al_row

of_set_campos()

end event

event constructor;call super::constructor;
ii_ck[1] = 1         // columnas de lectura de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

dw_master.SetTransObject(SQLCA)
dw_lista.of_share_lista(dw_master)
dw_master.Retrieve()
dw_lista.of_sort_lista()

ii_ss = 1
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	f_select_current_row(this)
	this.event ue_output(currentrow)
end if
end event

