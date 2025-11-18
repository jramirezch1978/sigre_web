$PBExportHeader$w_main_ancst.srw
$PBExportComments$Ancestro Main
forward
global type w_main_ancst from window
end type
type mdi_1 from mdiclient within w_main_ancst
end type
type mditbb_1 from tabbedbar within w_main_ancst
end type
type mdirbb_1 from ribbonbar within w_main_ancst
end type
end forward

global type w_main_ancst from window
integer x = 46
integer y = 60
integer width = 750
integer height = 532
boolean titlebar = true
string title = "Main"
string menuname = "m_master_ancst"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdihelp!
windowstate windowstate = maximized!
long backcolor = 16777215
event ue_help_topic ( )
event ue_help_index ( )
mdi_1 mdi_1
mditbb_1 mditbb_1
mdirbb_1 mdirbb_1
end type
global w_main_ancst w_main_ancst

type variables
Integer ii_help, ii_replicacion = -1
end variables

forward prototypes
public subroutine of_color (long al_value)
end prototypes

event ue_help_topic;ShowHelp(gs_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gs_help, Index!)
end event

public subroutine of_color (long al_value);THIS.BackColor = al_value
end subroutine

on w_main_ancst.create
if this.MenuName = "m_master_ancst" then this.MenuID = create m_master_ancst
this.mdi_1=create mdi_1
this.mditbb_1=create mditbb_1
this.mdirbb_1=create mdirbb_1
this.Control[]={this.mdi_1,&
this.mditbb_1,&
this.mdirbb_1}
end on

on w_main_ancst.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
destroy(this.mditbb_1)
destroy(this.mdirbb_1)
end on

event open;THIS.toolbarvisible = FALSE
gd_fecha = Today()
THIS.Title = gs_sistema +' | ' + gs_origen + ' | ' + gs_empresa + ' | ' + gs_user + ' | ' + gs_esquema + ' | '+ gs_db + ' | ' + String(gd_fecha)

Timer(600)

// ii_help = 101           // help topic

end event

event timer;string ls_flag_replicacion

If ii_replicacion = -1 then
   ls_flag_replicacion = ProfileString("\sigre_exe\replimail.ini", "DataBase", "Mantenimiento", "0")    
    if ls_flag_replicacion = '1' then
        messageBox('Para replicación', &
           'La Aplicación entrará en mantenimiento en 120 segundos')
        ii_replicacion = 120
        timer(10)
    end if
else
    ii_replicacion = ii_replicacion - 5
    messageBox('Para replicación', &
       'La Aplicación entrará en mantenimiento en ' + string(ii_replicacion) + ' segundos')
    if ii_replicacion = 0 then
        Rollback ;
        DISCONNECT ;
        HALT CLOSE
    end if
end if
end event

type mdi_1 from mdiclient within w_main_ancst
long BackColor=8421504
end type

type mditbb_1 from tabbedbar within w_main_ancst
int X=0
int Y=0
int Width=0
int Height=104
end type

type mdirbb_1 from ribbonbar within w_main_ancst
int X=0
int Y=0
int Width=0
int Height=596
end type

