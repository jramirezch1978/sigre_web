$PBExportHeader$w_main.srw
forward
global type w_main from w_main_ancst
end type
end forward

global type w_main from w_main_ancst
string title = "Sistema de Compras"
string menuname = "m_master"
event ue_repos_stock ( )
end type
global w_main w_main

event ue_repos_stock();String 	ls_estado
Long		ll_count
//Primero verifico si es un comprador y si est activo

select flag_estado
  into :ls_estado
  from comprador
 where comprador = :gs_user;

if SQLCA.SQlCode = 100 then return

if ls_estado <> '1' then return

// Ahora verifico cuantos artículos tienen como saldo
// menor al saldo minimo
SELECT count(*)
  into :ll_count
FROM articulo_almacen aa,
     almacen          al
WHERE aa.almacen = al.almacen
  AND aa.sldo_total <= NVL(aa.sldo_minimo,0)
  AND aa.flag_reposicion = '1';

if ll_count = 0 then return

if MessageBox('Aviso', 'Existen ' + string(ll_count) &
	+ ' Artículos de reposicion de Stock que estan por ' &
	+ 'debajo del Stock Mínimo. ¿Desea Visualizarlos?', &
	Information!, YesNo!, 1) = 2 then return
	
OpenSheet(w_cm781_rep_stock_default, w_main, 0, Original!)
end event

on w_main.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_master" then this.MenuID = create m_master
end on

on w_main.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;//w_main.backcolor=8421504
mdi_1.BackColor = RGB(128,128,128)

//Este evento lanza un reporte de Reposicion de Stock 
// de acuerdo al almacen respectivo de su origen
this.event ue_repos_stock( )
end event

