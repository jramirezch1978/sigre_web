$PBExportHeader$w_cm326_modify_alm_oc.srw
forward
global type w_cm326_modify_alm_oc from w_abc_master
end type
type st_1 from statictext within w_cm326_modify_alm_oc
end type
type st_2 from statictext within w_cm326_modify_alm_oc
end type
type cb_1 from commandbutton within w_cm326_modify_alm_oc
end type
type sle_nro_doc from singlelineedit within w_cm326_modify_alm_oc
end type
end forward

global type w_cm326_modify_alm_oc from w_abc_master
integer width = 3730
integer height = 1904
string title = "Modificar el Almacen en Orden de Compras (CM326)"
string menuname = "m_anulacion_mod"
windowstate windowstate = maximized!
string icon = "H:\Source\Ico\Travel.ico"
event ue_anular ( )
st_1 st_1
st_2 st_2
cb_1 cb_1
sle_nro_doc sle_nro_doc
end type
global w_cm326_modify_alm_oc w_cm326_modify_alm_oc

type variables

end variables

forward prototypes
public function integer of_actualiza_almacen ()
public function integer of_verifica_alm ()
end prototypes

event ue_anular();Integer j

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF
// Anulando 
dw_master.object.flag_estado[dw_master.getrow()] = '0'
dw_master.ii_update = 1


end event

public function integer of_actualiza_almacen ();Long 		ll_i, ll_nro_amp
String 	ls_almacen_old, ls_almacen_new, ls_org_amp, ls_msg, &
			ls_flag_estado, ls_flag_modificar
Decimal	ldc_cant_procesada		
dwItemStatus ldis_status

for ll_i = 1 to dw_master.RowCount()
	 ldis_status = dw_master.GetItemStatus(ll_i,0,Primary!)

	 IF ldis_status = DataModified! THEN
		 ls_almacen_new 	= dw_master.object.almacen			[ll_i]
		 ls_org_amp 		= dw_master.object.org_amp_ref 	[ll_i]
	    ll_nro_amp			= dw_master.object.nro_amp_ref	[ll_i]
	
		 select 	almacen, NVL(flag_estado, '0'), nvL(cant_procesada, 0),
		 			NVL(flag_modificacion, '0')
			into 	:ls_almacen_old, :ls_flag_estado, :ldc_cant_procesada,
					:ls_flag_modificar
	      from articulo_mov_proy
		  where cod_origen 	= :ls_org_amp 
		    and nro_mov		= :ll_nro_amp;
	
		if SQLCA.SQLCode = 100 then
			MessageBox('Error', 'No existe mov proyectado indicado ' + ls_org_amp + string(ll_nro_amp))
			return 0
		end if
	
		if ls_flag_estado <> '1' then
			MessageBox('Aviso', 'El Requerimiento de la OT no esta activo, por favor verifique')
			return 0
		end if
	
		if ldc_cant_procesada > 0 then
			MessageBox('Aviso', 'El Requerimiento de la OT ya esta atendido, por favor verifique')
			return 0
		end if
	
		if trim(ls_almacen_old) <> trim(ls_almacen_new) then
			update articulo_mov_proy
				set almacen = :ls_almacen_new
			where cod_origen 	= :ls_org_amp  
			  and nro_mov		= :ll_nro_amp;

			if SQLCA.SQLCode <> 0 then
				ls_msg = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error', ls_msg )
				return 0
			end if
		  
		end if   
		
	 END IF
	
next

return 1
end function

public function integer of_verifica_alm ();string ls_mensaje

//create or replace procedure USP_ALM_CORR_AMP_OT_OC(
//       asi_nada IN VARCHAR2
//) IS

DECLARE 	USP_ALM_CORR_AMP_OT_OC PROCEDURE FOR
			USP_ALM_CORR_AMP_OT_OC( :gs_origen);

EXECUTE 	USP_ALM_CORR_AMP_OT_OC;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_ALM_CORR_AMP_OT_OC: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE USP_ALM_CORR_AMP_OT_OC;

return 1

end function

on w_cm326_modify_alm_oc.create
int iCurrent
call super::create
if this.MenuName = "m_anulacion_mod" then this.MenuID = create m_anulacion_mod
this.st_1=create st_1
this.st_2=create st_2
this.cb_1=create cb_1
this.sle_nro_doc=create sle_nro_doc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.sle_nro_doc
end on

on w_cm326_modify_alm_oc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.sle_nro_doc)
end on

event ue_open_pre;call super::ue_open_pre;//ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

//Verifico que los Almacenes de las OT y las OC sean los mismos
// de lo contrario fuerzo a que el almacen de la OT sea el mismo de la OC
this.of_verifica_alm( )


end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
if f_row_Processing( dw_master, "tabular") <> true then return

if this.of_actualiza_almacen( ) = 0 then return
	
ib_update_check = True

dw_master.of_set_flag_replicacion()

end event

event resize;//Ancestor Overscript

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
st_1.X 		= dw_master.X
st_1.width 	= dw_master.width
end event

type dw_master from w_abc_master`dw_master within w_cm326_modify_alm_oc
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 272
integer width = 3442
integer height = 820
string dataobject = "d_abc_modify_alm_oc"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "almacen"
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				  + "DESC_almacen AS DESCRIPCION_almacen " &
				  + "FROM almacen " &
				  + "where flag_estado <> '0'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.almacen [al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose

end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,                    	
is_dwform = 'tabular'	
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this)
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

event dw_master::itemchanged;call super::itemchanged;string ls_codigo, ls_data, ls_null
this.AcceptText()
SetNull(ls_null)
if row <= 0 then return 

choose case lower(dwo.name)
	case "almacen"
		
		SetNull(ls_data)
		select desc_almacen
			into :ls_data
		from almacen
		where almacen = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Codigo de Almacen no existe o no esta activo", StopSign!)
			this.object.almacen	[row] = ls_null
			return 1
		end if

end choose

end event

type st_1 from statictext within w_cm326_modify_alm_oc
integer x = 27
integer y = 32
integer width = 3419
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
string text = "Permite Cambiar el ALMACEN, en Ordenes de Compra Amarradas a una OT/Programa"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm326_modify_alm_oc
integer x = 101
integer y = 172
integer width = 498
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Compra"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cm326_modify_alm_oc
integer x = 1115
integer y = 148
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;dw_master.retrieve( sle_nro_doc.text)
dw_master.ii_protect = 0
dw_master.of_protect()
end event

type sle_nro_doc from singlelineedit within w_cm326_modify_alm_oc
event dobleclick pbm_lbuttondblclk
integer x = 663
integer y = 160
integer width = 439
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_nro_doc, ls_data, ls_sql, ls_doc_oc

select doc_oc
	into :ls_doc_oc
from logparam
where reckey = '1';

ls_sql = "SELECT distinct a.tipo_doc AS tipo_doc, " &
		 + "a.nro_doc AS numero_documento " &
		 + "FROM articulo_mov_proy a " &
		 + "where a.flag_estado = '1' " &
		 + "and a.tipo_doc = '" + ls_doc_oc + "' " &
		 + "and a.cant_procesada = 0 " &
		 + "and a.NRO_AMP_REF is not null " &
		 + "and a.ORG_AMP_REF is not null " &
		 + "order by a.nro_doc " 
			 
lb_ret = f_lista(ls_sql, ls_data, ls_nro_doc, '1')
		
if ls_nro_doc <> '' then
	this.text = ls_nro_doc
end if
end event

