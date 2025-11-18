$PBExportHeader$w_com007_ratio_base_proveedor.srw
forward
global type w_com007_ratio_base_proveedor from w_abc_master_smpl
end type
type em_proveedor from singlelineedit within w_com007_ratio_base_proveedor
end type
type em_nombre from editmask within w_com007_ratio_base_proveedor
end type
type gb_1 from groupbox within w_com007_ratio_base_proveedor
end type
end forward

global type w_com007_ratio_base_proveedor from w_abc_master_smpl
integer width = 2048
integer height = 1680
string title = "Distribucion de Ratios por  proveedor - temporada(COM007)"
string menuname = "m_mantto_smpl"
em_proveedor em_proveedor
em_nombre em_nombre
gb_1 gb_1
end type
global w_com007_ratio_base_proveedor w_com007_ratio_base_proveedor

on w_com007_ratio_base_proveedor.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.em_proveedor=create em_proveedor
this.em_nombre=create em_nombre
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_proveedor
this.Control[iCurrent+2]=this.em_nombre
this.Control[iCurrent+3]=this.gb_1
end on

on w_com007_ratio_base_proveedor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_proveedor)
destroy(this.em_nombre)
destroy(this.gb_1)
end on

event ue_update_pre;call super::ue_update_pre;Long 		ll_x, ll_row[]

of_get_row_update(dw_master, ll_row[])
dw_master.of_set_flag_replicacion()

end event

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
end event

event open;IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
ELSE
	CLOSE(THIS)
END IF
end event

event ue_query_retrieve;//idw_query.AcceptText()
//idw_query.Object.datawindow.querymode = 'no'
//idw_query.Retrieve()
end event

event ue_query_set;//overide
end event

event ue_retrieve_list;// Asigna valores a structura 
Long   ll_row
string ls_proveedor, ls_desc

sg_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_proveedores_tbl'
sl_param.titulo = "Partes Diario de Raciones"
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	
	ls_proveedor = sl_param.field_ret[1]
	
	SELECT nom_proveedor INTO :ls_desc
     FROM proveedor
    WHERE proveedor =:ls_proveedor;

	em_proveedor.text = ls_proveedor
	em_nombre.text = ls_desc
	
	dw_master.retrieve(ls_proveedor)
	
END IF
end event

type dw_master from w_abc_master_smpl`dw_master within w_com007_ratio_base_proveedor
event ue_display ( string as_columna,  long al_row )
integer x = 46
integer y = 256
integer width = 1920
integer height = 1204
string dataobject = "d_abc_master_ratios_proveedor_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

choose case upper(as_columna)

  case "PROVEEDOR"
		
		ls_sql = "SELECT PROVEEDOR AS CODIGO, " &
				  + "NOM_PROVEEDOR AS NOMBRE " &
				  + "FROM PROVEEDOR " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.proveedor			[al_row] = ls_codigo
			this.object.nom_proveedor  	[al_row] = ls_data
			this.ii_update = 1
		end if		
		
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;String ls_proveedor

////is_action = 'new'

ls_proveedor = em_proveedor.text

if ls_proveedor = '' or IsNull(ls_proveedor) then
	MessageBox('Aviso', 'Debe Ingresar un Proveedor')
	dw_master.reset( )
	em_proveedor.setfocus()
	return
end if

//Cargamos Datos iniciales de configuración

dw_master.object.cod_origen [al_row] = gs_origen
dw_master.object.proveedor  [al_row] = ls_proveedor
dw_master.object.ano        [al_row] = YEAR(date(f_fecha_actual()))
dw_master.object.mes        [al_row] = MONTH(date(f_fecha_actual()))
end event

event dw_master::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                     //   'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_ck[4] = 4				// columnas de lectrua de este dw
ii_ck[5] = 5				// columnas de lectrua de este dw
end event

type em_proveedor from singlelineedit within w_com007_ratio_base_proveedor
event dobleclick pbm_lbuttondblclk
integer x = 82
integer y = 88
integer width = 325
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT proveedor as codigo, " & 
		  +"nom_proveedor AS nombre " &
		  + "FROM proveedor " &
		  + "WHERE flag_estado = '1'"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	dw_master.retrieve(ls_codigo)
	em_nombre.text = ls_data
end if


dw_master.enabled = true

end event

event modified;String 	ls_proveedor, ls_desc

ls_proveedor = this.text

if ls_proveedor = '' or IsNull(ls_proveedor) then
	MessageBox('Aviso', 'Debe Ingresar un Proveedor')
	return
end if

SELECT nom_proveedor INTO :ls_desc
FROM proveedor
WHERE proveedor =:ls_proveedor;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Proveedor no existe')
	return
end if

dw_master.retrieve(ls_proveedor)
dw_master.enabled = true
em_nombre.text = ls_desc

end event

type em_nombre from editmask within w_com007_ratio_base_proveedor
integer x = 430
integer y = 88
integer width = 1495
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type gb_1 from groupbox within w_com007_ratio_base_proveedor
integer x = 46
integer y = 12
integer width = 1925
integer height = 188
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Proveedor"
end type

