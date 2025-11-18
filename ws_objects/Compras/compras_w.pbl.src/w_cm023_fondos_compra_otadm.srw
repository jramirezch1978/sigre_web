$PBExportHeader$w_cm023_fondos_compra_otadm.srw
forward
global type w_cm023_fondos_compra_otadm from w_abc_master_smpl
end type
type st_1 from statictext within w_cm023_fondos_compra_otadm
end type
end forward

global type w_cm023_fondos_compra_otadm from w_abc_master_smpl
integer width = 2601
integer height = 1468
string title = "Listado de Fondos de Compra [CM022]"
string menuname = "m_mantto_smpl"
st_1 st_1
end type
global w_cm023_fondos_compra_otadm w_cm023_fondos_compra_otadm

on w_cm023_fondos_compra_otadm.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_cm023_fondos_compra_otadm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.tipo_proveedor.Protect)

IF li_protect = 0 THEN
   dw_master.Object.tipo_proveedor.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;f_centrar( this )
ii_pregunta_delete = 1 
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cm023_fondos_compra_otadm
event ue_display ( string as_columna,  long al_row )
integer y = 152
integer width = 2542
integer height = 1116
string dataobject = "d_abc_fondo_compras_ot_adm_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_cencos
Integer	li_year

this.AcceptText()

choose case lower(as_columna)
		
	case "cencos"
		li_year = Integer(this.object.ano[al_row])
		
		ls_sql = "SELECT distinct cc.cencos as codigo_cencos, " &
				  + "cc.desc_Cencos as descripcion_cencos " &
				  + "FROM centros_costo cc, " &
				  + "compra_fondo pp, " &
				  + "presupuesto_cuenta pc " &
				  + "where cc.cencos = pp.cencos " &
				  + "and pc.cnta_prsp = pp.cnta_prsp " &
				  + "and pp.ano = " + string(li_year) + " "&
  				  + "order by cc.cencos " 

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
			return
		end if
		
	case "cnta_prsp"
		li_year = Integer(this.object.ano[al_row])
		ls_Cencos = this.object.cencos [al_row]
		
		ls_sql = "SELECT distinct pc.cnta_prsp as codigo_cnta_prsp, " &
				  + "pc.descripcion as descripcion_cnta_prsp " &
				  + "FROM centros_costo cc, " &
				  + "compra_fondo pp, " &
				  + "presupuesto_cuenta pc " &
				  + "where cc.cencos = pp.cencos " &
				  + "and pc.cnta_prsp = pp.cnta_prsp " &
				  + "and pp.ano = " + string(li_year) + " " &
				  + "and pp.cencos = '" + ls_cencos + "' " & 
  				  + "order by pc.cnta_prsp " 

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_cnta_prsp	[al_row] = ls_data
			this.ii_update = 1
			return
		end if
		
	case "ot_adm"
		li_year = Integer(this.object.ano[al_row])
		ls_Cencos = this.object.cencos [al_row]
		
		ls_sql = "SELECT ot_adm as codigo_ot_adm, " &
				  + "descripcion as descripcion_ot_adm " &
				  + "FROM ot_administracion " &
  				  + "order by ot_adm " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ot_adm		[al_row] = ls_codigo
			this.object.desc_ot_adm	[al_row] = ls_data
			this.ii_update = 1
			return
		end if

end choose		
end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;//dw_master.Modify("forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
//dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
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

event dw_master::itemchanged;call super::itemchanged;string 	ls_data, ls_cencos, ls_cnta_prsp, ls_null, ls_ot_adm
Integer	li_year

SetNull(ls_null)
this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	case "ano"
		this.object.cencos			[row] = ls_null
		this.object.desc_cencos		[row] = ls_null
		this.object.cnta_prsp		[row] = ls_null
		this.object.desc_cnta_prsp	[row] = ls_null
		this.object.ot_adm			[row] = ls_null
		this.object.desc_ot_adm		[row] = ls_null
		
	case "cencos"
		
		ls_cencos = data
		li_year	 = Integer(this.object.ano[row])
		SELECT distinct cc.desc_Cencos 
			into :ls_data
	  	FROM 	centros_costo cc, 
	  			compra_fondo pp, 
	  			presupuesto_cuenta pc 
	  	where cc.cencos = pp.cencos 
	  		and pc.cnta_prsp = pp.cnta_prsp 
	  		and pp.ano = :li_year
			and pp.cencos = :ls_cencos;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Centro de Costo no existe o no tiene partida presupuestal " &
				+ 'de fondo para el año indicado', StopSign!)
			this.object.cencos	 	[row] = ls_null
			this.object.desc_cencos	[row] = ls_null
			return 1
		end if

		this.object.desc_cencos[row] = ls_data

	case "cnta_prsp"
		
		ls_cnta_prsp 	= data
		ls_cencos	 	= this.object.cencos[row]
		li_year	 	 	= Integer(this.object.ano[row])
		
		SELECT distinct pc.descripcion
			into :ls_data
	  	FROM 	centros_costo cc, 
	  			compra_fondo pp, 
	  			presupuesto_cuenta pc 
	  	where cc.cencos = pp.cencos 
	  		and pc.cnta_prsp = pp.cnta_prsp 
	  		and pp.ano = :li_year
			and pp.cencos = :ls_cencos
			and pp.cnta_prsp = :ls_cnta_prsp;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Cuenta Presupuestal no existe o no tiene partida presupuestal " &
				+ 'de fondo para el año indicado', StopSign!)
			this.object.cnta_prsp	 	[row] = ls_null
			this.object.desc_cnta_prsp	[row] = ls_null
			return 1
		end if

		this.object.desc_cnta_prsp[row] = ls_data

	case "ot_adm"
		
		ls_ot_adm = data
		
		SELECT descripcion
			into :ls_data
	  	FROM 	ot_administracion
	  	where ot_adm = :ls_ot_adm;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Ot_ADM no existe, por favor verique", StopSign!)
			this.object.ot_adm	 	[row] = ls_null
			this.object.desc_ot_adm	[row] = ls_null
			return 1
		end if

		this.object.desc_ot_adm[row] = ls_data
		
end choose


end event

type st_1 from statictext within w_cm023_fondos_compra_otadm
integer x = 18
integer y = 32
integer width = 2139
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "LISTADO DE FONDOS DE COMPRA X OT_ADM"
alignment alignment = center!
boolean focusrectangle = false
end type

