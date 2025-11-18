$PBExportHeader$w_n_dwr_service_progress.srw
forward
global type w_n_dwr_service_progress from Window
end type
type st_title from statictext within w_n_dwr_service_progress
end type
type st_remain from statictext within w_n_dwr_service_progress
end type
type cb_cancel from commandbutton within w_n_dwr_service_progress
end type
type uo_prog from uo_dwr_progressbar within w_n_dwr_service_progress
end type
end forward

global type w_n_dwr_service_progress from Window
int X=1056
int Y=484
int Width=1883
int Height=440
boolean TitleBar=true
string Title="Сохранение в Excel"
long BackColor=79741120
WindowType WindowType=response!
event type integer ue_show_progress ( integer ai_progress )
st_title st_title
st_remain st_remain
cb_cancel cb_cancel
uo_prog uo_prog
end type
global w_n_dwr_service_progress w_n_dwr_service_progress

type variables
nonvisualobject parm
datetime idt_start
datetime idt_last
n_dwr_datetime invo_dt_srv
end variables

event ue_show_progress;long ll_cur_s, ll_total_rem_s
long ll_rem_s
long ll_rem_m
long ll_rem_h
string ls_str
datetime ldt_now


ldt_now = datetime(today(), now())
if invo_dt_srv.of_secondsafter(idt_last, ldt_now) > 5 then

	idt_last = ldt_now
	ll_cur_s = invo_dt_srv.of_secondsafter(idt_start, ldt_now)

	if ll_cur_s > 3 and ai_progress > 0 then
		ll_total_rem_s = truncate(round((ll_cur_s * 100)/ai_progress - ll_cur_s, 0), 0)
		ll_total_rem_s = round(ll_total_rem_s/5, 0) * 5
   	
		
		
		
		ll_rem_s = mod(ll_total_rem_s, 60)
		ll_total_rem_s = truncate(ll_total_rem_s / 60, 0)
		ll_rem_m = mod(ll_total_rem_s, 60)
		ll_rem_h = truncate(ll_total_rem_s / 60, 0)
		ls_str = ''
		if ll_rem_h = 1 then ls_str += string(ll_rem_h) + ' Hour ' 
		if ll_rem_h > 1 then ls_str += string(ll_rem_h) + ' Hours ' 

		if ll_rem_m = 1 then
			ls_str += string(ll_rem_m) + ' Minute ' 
      elseif ll_rem_m > 1 or ll_rem_h > 0 then 
			ls_str += string(ll_rem_m) + ' Minutes ' 
		end if
			
		if ll_rem_s = 1 then 
			ls_str += string(ll_rem_s) + ' Second ' 
		elseif ll_rem_s > 1 or ll_rem_h > 0 or ll_rem_m > 0  then 
			ls_str += string(ll_rem_s) + ' Seconds ' 
		end if
		if ls_str <> '' then  ls_str += 'Remaining' 
		
		
		st_remain.text = ls_str
	end if   
end if
uo_prog.setvalue(ai_progress)
return 1
end event

event open;environment l_env

parm = message.PowerObjectParm


this.title='Save as Excel'


if GetEnvironment(l_env) <> 1 then return
this.x = (PixelsToUnits ( l_env.ScreenWidth, XPixelsToUnits! ) - this.width)/2
this.y = (PixelsToUnits ( l_env.ScreenHeight, YPixelsToUnits! ) - this.height)/2
uo_prog.setrange(1, 100)
idt_start = datetime(today(), now())
idt_last = idt_start
parm.postevent('ue_process_work')
end event

on w_n_dwr_service_progress.create
this.st_title=create st_title
this.st_remain=create st_remain
this.cb_cancel=create cb_cancel
this.uo_prog=create uo_prog
this.Control[]={this.st_title,&
this.st_remain,&
this.cb_cancel,&
this.uo_prog}
end on

on w_n_dwr_service_progress.destroy
destroy(this.st_title)
destroy(this.st_remain)
destroy(this.cb_cancel)
destroy(this.uo_prog)
end on

type st_title from statictext within w_n_dwr_service_progress
int X=82
int Y=4
int Width=1701
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_remain from statictext within w_n_dwr_service_progress
int X=82
int Y=160
int Width=1303
int Height=76
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_cancel from commandbutton within w_n_dwr_service_progress
int X=1399
int Y=184
int Width=393
int Height=108
int TabOrder=20
string Text="Отмена"
boolean Default=true
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;parm.triggerevent('ue_cancel')
post close(parent)
end event

event constructor;
this.text='Cancel'


end event

type uo_prog from uo_dwr_progressbar within w_n_dwr_service_progress
int X=82
int Y=84
int Width=1710
int Height=76
int TabOrder=10
boolean BringToTop=true
end type

on uo_prog.destroy
call uo_dwr_progressbar::destroy
end on

