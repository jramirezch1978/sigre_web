$PBExportHeader$w_ope320_cierra_opersec.srw
forward
global type w_ope320_cierra_opersec from w_abc_master
end type
type cb_1 from commandbutton within w_ope320_cierra_opersec
end type
type cb_2 from commandbutton within w_ope320_cierra_opersec
end type
type sle_codigo from u_sle_codigo within w_ope320_cierra_opersec
end type
type gb_1 from groupbox within w_ope320_cierra_opersec
end type
end forward

global type w_ope320_cierra_opersec from w_abc_master
integer width = 1280
integer height = 912
string title = "[OPE320] Cierre de OPERSEC"
string menuname = "m_abc_master"
cb_1 cb_1
cb_2 cb_2
sle_codigo sle_codigo
gb_1 gb_1
end type
global w_ope320_cierra_opersec w_ope320_cierra_opersec

on w_ope320_cierra_opersec.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master" then this.MenuID = create m_abc_master
this.cb_1=create cb_1
this.cb_2=create cb_2
this.sle_codigo=create sle_codigo
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.sle_codigo
this.Control[iCurrent+4]=this.gb_1
end on

on w_ope320_cierra_opersec.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.sle_codigo)
destroy(this.gb_1)
end on

type dw_master from w_abc_master`dw_master within w_ope320_cierra_opersec
integer x = 37
integer y = 256
integer width = 1138
integer height = 388
string dataobject = "d_abc_cerrar_opersec_ff"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
end event

type cb_1 from commandbutton within w_ope320_cierra_opersec
integer x = 549
integer y = 128
integer width = 297
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_opersec

Long ll_count

ls_opersec = TRIM(sle_codigo.text)

SELECT count(*) 
  INTO :ll_count 
  FROM articulo_mov_proy amp 
 WHERE amp.oper_sec = :ls_opersec AND 
		 amp.tipo_doc = (select doc_ot from logparam where reckey='1') and 
 		 amp.tipo_mov = (select oper_cons_interno from logparam where reckey='1') ;

IF ll_count > 0 THEN
	dw_master.retrieve(ls_opersec )
ELSE
	MessageBox('Aviso', 'OPERSEC no existe')
	Return
END IF




end event

type cb_2 from commandbutton within w_ope320_cierra_opersec
integer x = 878
integer y = 128
integer width = 297
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Long ll_i, ll_count

IF dw_master.rowcount( ) = 0 THEN RETURN 

for ll_i = 1 to dw_master.rowcount( )
	
	//solamente debe afectar a los articulos con cantidades procesadas = 0
	if dw_master.object.cant_procesada[ll_i] = 0 then
		
		//si articulo es de reposicion
		if dw_master.object.flag_reposicion[ll_i] = '1' then
			
			if dw_master.object.flag_estado[ll_i] = '1' then
				dw_master.object.flag_estado[ll_i] = '2'
				ll_count++
			else
				dw_master.object.flag_estado[ll_i] = '1'
				ll_count++
			end if
			
		else //si no es reposicion
			
			if isnull(dw_master.object.nro_aprob[ll_i]) then
				dw_master.object.flag_estado[ll_i] = '3'
				ll_count++
			else
				dw_master.object.flag_estado[ll_i] = '1'
				ll_count++
			end if
			
		end if
		
	end if
	
next

dw_master.AcceptText()
dw_master.ii_update = 1

messagebox('Aviso',string(ll_count)+' registros afectados')
end event

type sle_codigo from u_sle_codigo within w_ope320_cierra_opersec
integer x = 73
integer y = 112
integer width = 411
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
textcase textcase = upper!
integer limit = 10
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type gb_1 from groupbox within w_ope320_cierra_opersec
integer x = 37
integer y = 32
integer width = 480
integer height = 196
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opersec"
end type

