$PBExportHeader$w_cm004_compradores.srw
forward
global type w_cm004_compradores from w_abc_mastdet_smpl
end type
end forward

global type w_cm004_compradores from w_abc_mastdet_smpl
integer width = 3022
integer height = 1928
string title = "Agentes de Compra (CM004)"
boolean maxbox = false
end type
global w_cm004_compradores w_cm004_compradores

on w_cm004_compradores.create
int iCurrent
call super::create
end on

on w_cm004_compradores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;//f_centrar( this )
end event

event ue_modify;call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.comprador.Protect)

IF li_protect = 0 THEN
   dw_master.Object.comprador.Protect = 1
END IF
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type ole_skin from w_abc_mastdet_smpl`ole_skin within w_cm004_compradores
end type

type st_horizontal from w_abc_mastdet_smpl`st_horizontal within w_cm004_compradores
integer x = 498
end type

type st_filter from w_abc_mastdet_smpl`st_filter within w_cm004_compradores
end type

type uo_filter from w_abc_mastdet_smpl`uo_filter within w_cm004_compradores
end type

type uo_h from w_abc_mastdet_smpl`uo_h within w_cm004_compradores
end type

type st_box from w_abc_mastdet_smpl`st_box within w_cm004_compradores
end type

type dw_master from w_abc_mastdet_smpl`dw_master within w_cm004_compradores
event ue_display ( string as_columna,  long al_row )
integer x = 498
integer width = 2491
integer height = 628
string dataobject = "d_abc_comprador_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case upper(as_columna)
		
	case "COMPRADOR"
		ls_sql = "SELECT COD_USR AS CODIGO_USUARIO, " &
				  + "NOMBRE AS NOMBRE_USUARIO " &
				  + "FROM USUARIO " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.comprador		[al_row] = ls_codigo
			this.object.nom_comprador	[al_row] = ls_data
			this.ii_update = 1
		end if
	
	case "COD_TRABAJADOR"

		ls_sql = "SELECT cod_trabajador AS CODIGO_trabajador, " &
				  + "APEL_PATERNO || ' ' || APEL_MATERNO || ' ' || NOMBRE1 AS NOMBRE_USUARIO " &
				  + "FROM MAESTRO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_trabajador	[al_row] = ls_codigo
			this.ii_update = 1
		end if		
		
end choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::itemerror;call super::itemerror;Return (1)
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data
Long		ll_count
this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	case "comprador"
		
		ls_codigo = this.object.comprador[row]

		SetNull(ls_data)
		select nombre
			into :ls_data
		from usuario
		where cod_usr = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Código de Usuario no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.comprador	 [row] = ls_codigo
			this.object.nom_comprador[row] = ls_codigo
			return 1
		end if

		this.object.nom_comprador[row] = ls_data

	case "cod_trabajador"
		
		ls_codigo = this.object.cod_trabajador[row]

		SetNull(ls_data)
		select count(*)
			into :ll_count
		from maestro
		where cod_trabajador = :ls_codigo
		  and flag_estado = '1';
		
		if ll_count = 0 then
			Messagebox('Error', "Código de Trabajador no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_trabajador	 [row] = ls_codigo
			return 1
		end if
		
end choose

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cm004_compradores
event ue_display ( string as_columna,  long al_row )
integer x = 498
integer y = 936
integer width = 2491
integer height = 740
string dataobject = "d_abc_comprador_articulo"
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "cod_sub_cat"
		ls_sql = "SELECT COD_SUB_CAT AS CODIGO, " &
				  + "DESC_SUB_CAT AS DESCRIPCION " &
				  + "FROM articulo_sub_Categ " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_sub_cat	[al_row] = ls_codigo
			this.object.desc_sub_cat[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this)
end event

event dw_detail::itemchanged;call super::itemchanged;// Busca descripcion de tipo
String ls_desc

Select desc_sub_Cat
	into :ls_desc 
from articulo_sub_Categ
where cod_sub_cat = :data;
	
this.object.desc_sub_cat[row] = ls_desc
end event

event dw_detail::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event dw_detail::keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

