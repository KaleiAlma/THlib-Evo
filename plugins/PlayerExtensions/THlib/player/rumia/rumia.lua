---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Ryann1908.
--- DateTime: 09/21/2020 14:16
--- Sprite by DD at https://www.pixiv.net/en/artworks/64093974
---

--- Player Class
rumia_player=Class(player_class) --- Defines that this file belongs to a player, aka a player class

--- Initialize
function rumia_player:init() --- Initializing the player
    LoadTexture('rumia_player','THlib/player/rumia/rumia.png') --- Loads the whole spritesheet
    LoadImageFromFile('fog','THlib/player/rumia/fog.png',true,0,0,false,0) --- Loads the fog graphic for Rumia's clouds
    LoadImageGroup('rumia_player','rumia_player',0,0,32,48,8,3,0.5,0.5) --- Loads the Rumia player sprite
    LoadImage('rumia_support','rumia_player',80,144,16,16) --- Loads Rumia's options/support graphic
    LoadImage('rumia_darkshot_left','rumia_player',214,144,42,16) --- Loads Rumia's dark shot
    LoadAnimation('rumia_darkshot_ef_right','rumia_player',0,160,16,16,4,1,4) --- Loads Rumia's dark shot effect
    LoadImage('rumia_bluepellet','rumia_player',145,144,31,15) --- Loads Rumia's blue subshot
    LoadImage('rumia_purplepellet_end','rumia_player',177,177,31,15) --- Loads Rumia's blue subshot effect
    LoadImage('rumia_purplepellet','rumia_player',145,177,31,15) --- Loads Rumia's purple subshot
    LoadImage('rumia_bluepellet_end','rumia_player',177,144,31,15) --- Loads Rumia's purple subshot effect
    LoadImage('rumia_circle','rumia_player',0,176,48,48) --- Loads Rumia's dark circle
    LoadImage('rumia_lblaser','rumia_player',0,224,256,16) --- Loads Rumia's light laser
    LoadImage('rumia_dblaser','rumia_player',0,240,256,16) --- Loads Rumia's dark laser
    LoadPS('rumia_dark_ps','THlib/player/rumia/dkshot.psi','parimg11',0,0) --- Loads Rumia's option effect/particle
    SetImageCenter('rumia_lblaser',0,8) --- Sets the light laser's image center
    SetImageCenter('rumia_dblaser',0,8) --- Sets the light laser's image center
    LoadPS('rumia_cloud_ps','THlib/player/rumia/cloud.psi','fog',0,0) --- Loads Rumia's dark cloud effect/particle

    player_class.init(self)
    self.name='Rumia' --- Gives the player name
    self.hspeed=4.5 --- The player's speed
    self.imgs={} --- Table for the player sprites
    self.A=0.5 self.B=0.5 --- The player's hitbox
    for i=1,24 do self.imgs[i]='rumia_player'..i end --- The player's sprite animation
    self.slist=
    {
        {nil,nil,nil,nil},
        {{0,-40,0,-20}     ,           nil,         nil,           nil},
        {{-30,-40,-10,-24}    ,{30,-40,10,-24}    ,         nil,           nil},
        {{-38,-20,-16,-8}   ,{0,-32,0,-28}  ,{38,-20,16,-8} ,           nil},
        {{-54,-50,-22,-20},{-21,-32,-12,-28},{21,-32,12,-28},{54,-50,22,-20}},
        {{-44,-48,-16,20},{-24,-32,-6,28},{24,-32,6,28},{44,-48,16,20}},
    } --- The options positioning
    self.anglelist=
    {
        {90,90,90,90},
        {90,90,90,90},
        {100,80,90,90},
        {100,90,80,90},
        {110,100,80,70},
    } --- Angle list for the shots
end

--- Shoot
function rumia_player:shoot()
    PlaySound('plst00',0.3,self.x/1024) --- Plays the shot sound
    self.nextshoot=4 --- Defines the interval for the player to shoot again
    New(rumia_dark_shot,'rumia_darkshot_left',self.x-10,self.y+5,1.7) --- Creates Rumia's main shot in the left side
    New(rumia_dark_shot,'rumia_darkshot_left',self.x+10,self.y+5,1.7) --- Creates Rumia's main shot in the right side
    local num=int(lstg.var.power/100)+1
    for i=1,4 do --- Does an operation 4 times
        if self.sp[i] and self.sp[i][3]>0.5 then --- Self support shenanigans; this is to calculate the shots that will be fired in the options
            New(rumia_dark_sp,self.supportx+self.sp[i][1],self.supporty+self.sp[i][2],'rumia_dark_ps',2,false) --- Creates the fire effect
            New(rumia_subshot_blue,'rumia_bluepellet',self.supportx+self.sp[i][1],self.supporty+self.sp[i][2],0.55) --- Creates the blue shot
            New(rumia_subshot_purple,'rumia_purplepellet',self.supportx+self.sp[i][1],self.supporty+self.sp[i][2],0.55,self.anglelist[num][i]) --- Creates the purple shot
            New(rumia_cloud,self.supportx+self.sp[i][1]+ran:Int(10,-10),self.supporty+self.sp[i][2]+ran:Int(10,-10),'fog',0.4) --- Creates the clouds
        end
    end
end

--- Spell/Bomb
function rumia_player:spell()
    self.nextspell=190 --- Time until you can bomb again
    self.protect=200 --- Invulnerability time
    self.collect_line=self.collect_line-300 --- Lowers the PoC line
    New(player_spell_mask,50,50,175,40,25,30)
    misc.ShakeScreen(60,3)
    PlaySound('power1',0.8)
    PlaySound('slash',0.8)
    New(tasker,function() --- Makes an async task that waits 90 seconds to raise the PoC back up
        task.Wait(90)
        self.collect_line=self.collect_line+300
    end)
    New(bullet_cleaner,self.x,self.y,256,10,65,true,false,0) --- Clears bullet in a circle
    New(rumia_circle_bomb,'rumia_circle',self.x,self.y,5,5) --- Creates the bomb
end
--[[
--- Special (for example, releases (key C)); this is commented out, but you can try uncommenting it and press C to drop some items
function rumia_player:special()
    _drop_item(item_power_large,1,player.x,player.y)
    _drop_item(item_bomb,1,player.x,player.y)
end
--]]
--- Rendering of the player code and options
function rumia_player:render()
    for i=1,4 do
        if self.sp[i] and self.sp[i][3]>0.5 then
            Render('rumia_support',self.supportx+self.sp[i][1],self.supporty+self.sp[i][2],self.timer*3) --- Rendering of the options
        end
    end
    player_class.render(self) --- Renders the player
end

------------------------------------------ Objects/Shots/Bombs/Effects
--- Main Shot

rumia_dark_shot=Class(object) --- The main shot, it is an object (object class)
function rumia_dark_shot:init(img,x,y,dmg) --- Initialization of the bullet (arguments: img (sprite), x (position), y (position), dmg (damage)
    self.x=x --- X position
    self.y=y --- Y position
    self.group=GROUP_PLAYER_BULLET --- Makes it part of the player bullet group
    self.layer=LAYER_PLAYER_BULLET --- Makes it part of the player bullet layer
    self.img=img --- It's image/sprite
    self.hscale=1.1 --- It's horizontal scale (1 is default)
    self.vscale=1.1 --- It's vertical scale (1 is default)
    self.a=50 --- It's X/horizontal hitbox
    self.b=20 --- It's Y/vertical hitbox
    self.rot=90 --- The orientation of the bullet/sprite (90 angle, aka Upwards (not related to speed))
    self.dmg=dmg --- The bullet's damage
    self.bound=false --- Makes it not despawn if off-screen
    self.killflag=false --- Makes it die once it collides with an enemy (setting off the "on kill()" function)
    self.vy=20 --- Makes the object go upwards
end

function rumia_dark_shot:frame() --- Action to make every frame
    if self.timer>5 then --- Turns self.bound to true (enables off screen deletion) after 5 frames of the object spawned
        self.bound=true --- Enables off screen deletion
    end
end

function rumia_dark_shot:kill() --- Action to make when it gets killed
    New(rumia_dark_shot_ef,'rumia_darkshot_ef_right',self.x,self.y) --- Creates this bullet's kill effect
    Kill(self) --- Kills itself
end

--- Main Shot Effect (when killed)

rumia_dark_shot_ef=Class(object) --- The main shot's effect, it is an object (object class) --- f
function rumia_dark_shot_ef:init(img,x,y)
    self.x=x
    self.y=y
    self.img=img
    self.hscale=1.4
    self.vscale=1.4
    self.rot=ran:Int(85,95)
    self.vy=1
    SetImgState(self,'mul+add',255,255,100,100) --- Sets a blend mode to the object's image, and also colors it a bit redder
end

function rumia_dark_shot_ef:frame()
    if self.timer>19 then
    Kill(self)
    end
end

--- SubShot Blue

rumia_subshot_blue=Class(object) --- The blue subshot, it is an object (object class)
function rumia_subshot_blue:init(img,x,y,dmg) --- Initialization of the bullet (arguments: img (sprite), x (position), y (position), dmg (damage)
    self.x=x
    self.y=y
    self.group=GROUP_PLAYER_BULLET
    self.layer=LAYER_PLAYER_BULLET
    self.img=img
    self.hscale=1.2
    self.vscale=1.2
    self.a=40
    self.b=10
    self.rot=90
    self.dmg=dmg
    self.bound=false
    self.killflag=false
    self.vy=32
    SetImgState(self,'',125,255,255,255)
end

function rumia_subshot_blue:frame()
    if self.timer>5 then
    self.bound=true
    end
end

function rumia_subshot_blue:kill()
    New(rumia_subshot_blue_ef,'rumia_bluepellet_end',self.x,self.y)
    Kill(self)
end

--- SubShot Blue Effect (when killed)

rumia_subshot_blue_ef=Class(object) --- The blue subshot's effect, it is an object (object class)
function rumia_subshot_blue_ef:init(img,x,y)
    self.x=x
    self.y=y
    self.img=img
    self.hscale=1.4
    self.vscale=1.4
    self.rot=ran:Int(85,95)
    self.vy=2
    SetImgState(self,'mul+add',135,100,100,255)
end

function rumia_subshot_blue_ef:frame()
    if self.timer>19 then
        Kill(self)
    end
end

--- SubShot Purple

rumia_subshot_purple=Class(player_bullet_trail) --- The purple subshot, it is a player bullet trail class (for homing)
function rumia_subshot_purple:init(img,x,y,dmg,target)
    self.x=x
    self.y=y
    self.group=GROUP_PLAYER_BULLET
    self.layer=LAYER_PLAYER_BULLET
    self.img=img
    self.hscale=1.2
    self.vscale=1.2
    self.a=40
    self.b=10
    self.rot=90
    self.dmg=dmg
    self.bound=false
    self.killflag=false
    self.v=8
    self.target=target
    self.trail=1
    SetImgState(self,'',125,255,255,255)
end

function rumia_subshot_purple:frame() --- Homing code from Reimu with tweaks
    player_class.findtarget(self)
    if IsValid(self.target) and self.target.colli then
        local a=math.mod(Angle(self,self.target)-self.rot+720,360)
        if a>180 then a=a-360 end
        local da=self.trail/(Dist(self,self.target)+1)
        if da+15>=abs(a) then self.rot=Angle(self,self.target)
        else self.rot=self.rot+sign(a)*da end
    end
    self.vx=self.v*cos(self.rot)
    self.vy=self.v*sin(self.rot)
    if self.timer>5 then
        self.bound=true
    end
end

function rumia_subshot_purple:kill()
    New(rumia_subshot_purple_ef,'rumia_purplepellet_end',self.x,self.y,self.rot)
    Kill(self)
end

--- SubShot Purple Effect (when killed)

rumia_subshot_purple_ef=Class(object) --- The purple subshot's effect, it is an object (object class)
function rumia_subshot_purple_ef:init(img,x,y,rot)
    self.x=x
    self.y=y
    self.img=img
    self.hscale=1.4
    self.vscale=1.4
    self.rot=rot+ran:Int(-5,5)
    SetImgState(self,'mul+add',155,100,100,255)
end

function rumia_subshot_purple_ef:frame()
    SetV2(self,3,self.rot,true,false)
    if self.timer>19 then
    Kill(self)
    end
end

--- Cloud Shadow Shot

rumia_cloud=Class(object) --- The shadow cloud shot. It is an object but essentially a particle as well
function rumia_cloud:init(x,y,img,dmg)
    self.x=x
    self.y=y
    self.group=GROUP_PLAYER_BULLET
    self.layer=LAYER_PLAYER_BULLET-4
    self.hscale=1
    self.vscale=1
    self.A=30
    self.B=30
    self.rect=false
    self.rot=ran:Int(0,360)
    self.dmg=dmg
    self.img=img
    self.bound=false
    self.killflag=false
    SetImgState(self,'',125,255,255,255)
end
function rumia_cloud:frame()
    self.a=30
    self.b=30
    if self.timer >= 40 then Del(self) end
end

function rumia_cloud:kill()
    New(rumia_dark_sp,self.x,self.y,'rumia_dark_ps',25,true)
end

function rumia_cloud:render()
    SetImgState(self,'',155-self.timer*(155/40),255,255,255)
    Render(self.img,self.x,self.y,self.rot,self.hscale,self.vscale,0.5)
end

--function rumia_cloud:render()
   -- SetImgState(self,'',255,255,255,255)
    --Render(self.img,self.x,self.y,self.rot,self.hscale,self.vscale,0.5)
--end

--- --- Rumia Bomb

--- Rumia Circle

rumia_circle_bomb=Class(object)
function rumia_circle_bomb:init(img,x,y,hscale,vscale)
    self.img=img
    self.x=x
    self.y=y
    self.hscale=hscale
    self.vscale=vscale
    self.group=GROUP_PLAYER_BULLET
    self.layer=LAYER_PLAYER_BULLET
    self.mute=true
    self.dmg=0.2
    self.killflag=true
    self.omiga = ran:Int(0.1,1)*ran:Sign() --- Makes the object spin it's graphic
    self.alp = 200 --- A theoretical alpha value for the object
    SetImgState(self,"",0,255,255,255)
    task.New(self,function() --- Creates a task in the object
        for i=1,5 do
            New(rumia_laser,'rumia_lblaser',self.x,self.y,360/5*i+90,false)
            New(rumia_laser,'rumia_dblaser',self.x,self.y,360/5*i+90,true)
        end
        New(tasker,function() --- Creates a tasker inside the object; putting tasks inside a tasker makes them run simultaneously, async
            task.New(self,function()
                do local a,_d_a=(0),(200/30) for i=1,30 do
                    SetImgState(self,"",a,255,255,255)
                    task.Wait(1)
                    a=a+_d_a end
                end
                self.alp = 200
            end)
            task.New(self,function()
                for i=1,40 do
                    self.hscale=self.hscale-0.1
                    self.vscale=self.vscale-0.1
                    if self.timer > 31 then
                        self.alp = self.alp - 10
                        SetImgState(self,"",self.alp,255,255,255)
                    end
                    misc.ShakeScreen(10,1)
                    do local a,_d_a=(0),(360/50) for j=1,50 do
                        New(rumia_cloud,self.x+(i*2)*cos(a)+ran:Int(-10,10),self.y+(i*2)*sin(a)+ran:Int(-10,10),'fog',0.4)
                        a=a+_d_a
                    end end
                    task.Wait(self.timer-30)
                end
                New(rumia_cloud,self.x,self.y,'fog',0.4)
                Del(self)
            end)
        end)
    end)
end

function rumia_circle_bomb:frame()
    task.Do(self)
end

rumia_laser=Class(object)
function rumia_laser:init(img,x,y,ang,rot)
    self.img = img
    self.x = x
    self.y = y
    self.rot = ang
    self.A = 256
    self.B = 16
    self.group=GROUP_PLAYER_BULLET
    self.layer=LAYER_PLAYER_BULLET
    self.killflag=true
    self.dmg = 3
    self.rect=false
    self.hscale, self.vscale = 6,6
    SetImgState(self,"mul+add",0,222,255,255)
    task.New(self,function()
        New(tasker,function()
            task.New(self,function()
                do local a,_d_a=(0),(222/25) for i=1,25 do
                    self.hscale, self.vscale = self.hscale-5/25, self.vscale-5/25
                    SetImgState(self,"mul+add",a,255,255,255)
                    task.Wait(1)
                    a=a+_d_a
                end end
            end)
            task.New(self,function()
                for i=1,_infinite do
                    if rot == true then
                        self.rot = self.rot+4 - self.timer*0.04
                    else
                        self.rot = self.rot-4 + self.timer*0.04
                    end
                    task.Wait(1)
                end
            end)
            task.New(self,function()
                task.Wait(65)
                do local a,_d_a=(222),(-222/15) for i=1,15 do
                    SetImgState(self,"mul+add",a,255,255,255)
                    task.Wait(1)
                    a=a+_d_a
                end end
                Del(self)
            end)
        end)
    end)
end

function rumia_laser:frame()
    self.a=256
    self.b=16
    task.Do(self)
end
--- --- Options/Support Firing Effect

rumia_dark_sp=Class(object) --- The option's "turned on/firing" effect. It is an object but essentially a particle as well
function rumia_dark_sp:init(x,y,img,time,cloudk)
    self.x=x
    self.y=y
    self.img=img
    self.time=time
    if cloudk == true then
        self.group=GROUP_PLAYER_BULLET
        self.layer=LAYER_PLAYER_BULLET-5
    end
end
function rumia_dark_sp:frame()
    if self.timer > self.time then Kill(self) end
end

