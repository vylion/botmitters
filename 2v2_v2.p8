pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function new_player(num, x, y)
	local player = {}
	player.num = num
	player.x = x
	player.y = y
	player.dx = 0
	player.dy = 0
	player.accel = 0.05
	player.frame = 0
	player.f0 = 0
	player.standing = false
	player.d = 1
	player.ammo_cd = 0

	return player
end

k_left=0
k_right=1
k_up=2
k_down=3
k_a=4
k_b=5

val = 0
flag = 0
grav = 0.28
t_step = 0.15
vxmax = 3
maxfall = 4
jumpforce = 4

shots = {}
n_shots = 0

function quickdel(t,i)
    local n=#t
    if (i>0 and i<=n) then
            t[i]=t[n]
            t[n]=nil
    end
end

function new_shot(pl)
	shot = {}
	shot.dx = pl.d*3/8
	shot.x = pl.x
	shot.y = pl.y-0.5
	shot.sprite = 32
	shot.flip_x = pl.d < 0
	shot.flip_y = false

	n_shots += 1

	return add(shots,shot)
end

clouds = {}
for i=0,16 do
	add(clouds,{
		x=rnd(128),
		y=rnd(128),
		spd=1+rnd(4),
		w=32+rnd(32)
	})
end

particles = {}
for i=0,24 do
	add(particles,{
		x=rnd(128),
		y=rnd(128),
		s=0+flr(rnd(5)/4),
		spd=0.25+rnd(5),
		off=rnd(1),
		c=6+flr(0.5+rnd(1))
	})
end

dead_particles = {}

function solid_player(num, x, y)
	val=mget(x, y)
	flag = fget(val, 1)--0 = terrain flag
	coli = false
	foreach(players, function (p)
		if (p.num != num) then
			if not coli then
				coli = (y > p.y-1 and y < p.y) and (x < p.x+0.5 and x > p.x-0.5)
			end
		end
	end)
	return (flag or coli)
end

function solid(x, y)
	val=mget(x, y)
	flag = fget(val, 1)--0 = terrain flag
	return flag
end

function move_player(pl)
	accel = pl.accel
	if (not pl.standing) then
		accel = accel/2
	end

	--player control
	if (btn(k_left, pl.num)) then
		pl.dx = pl.dx - accel
		pl.d = -1
	end
	if (btn(k_right, pl.num)) then
		pl.dx = pl.dx + accel
		pl.d = 1
	end
	if (btn(k_up, pl.num) and pl.standing) then
		pl.dy = -0.5
	end

	--frame
	if (pl.standing) then
		pl.f0 = (pl.f0+abs(pl.dx)*2+4) % 4
	else
		pl.f0 = (pl.f0+abs(pl.dx)/2+4) % 4
	end

	if (abs(pl.dx) < 0.1) then
		pl.frame = 0
		pl.f0 = 0
	else
		pl.frame = 0 + flr(pl.f0)
	end

	pl.standing = false
	-- x movement
	xaux = pl.x + pl.dx + sgn(pl.dx)*0.3
	if (not solid_player(pl.num, xaux, pl.y - 0.5)) then
		pl.x = pl.x + pl.dx
	else
		while (not solid_player(pl.num, pl.x + sgn(pl.dx)*0.3, pl.y-0.5)) do
			pl.x = pl.x + sgn(pl.dx)*0.1
		end
	end

	-- y movement
	if (pl.dy < 0) then
		if (solid_player(pl.num, pl.x-0.2, pl.y+pl.dy-1) or
			solid_player(pl.num, pl.x+0.2, pl.y+pl.dy-1)) then
			pl.dy = 0
			while ( not (
				solid_player(pl.num, pl.x-0.2, pl.y-1) or
				solid_player(pl.num, pl.x+0.2, pl.y-1)))
				do
				pl.y = pl.y - 0.01
			end
		else
			pl.y = pl.y + pl.dy
		end
	else
		if (solid_player(pl.num, pl.x-0.2, pl.y+pl.dy) or
			solid_player(pl.num, pl.x+0.2, pl.y+pl.dy)) then
			pl.standing=true
			pl.dy = 0

			while (not (
				solid_player(pl.num, pl.x-0.2,pl.y) or
				solid_player(pl.num, pl.x+0.2,pl.y)
				)) do
				pl.y = pl.y + 0.05
			end
		else
			pl.y = pl.y + pl.dy
		end
	end

	-- gravity
	pl.dy = pl.dy + 0.04

	-- x friction
	if (pl.standing) then
		pl.dx = pl.dx*0.8
	else
		pl.dx = pl.dx*0.9
	end
end

function player_shoot(pl)
	if(btnp(k_a, pl.num)) then
		new_shot(pl)
	end
end

function update_shots()
	local i = 1
	while shots[i] ~= nil do
		shots[i].x += shots[i].dx
		shots[i].flip_y = not shots[i].flip_y
		local sx = shots[i].x
		local sy = shots[i].y
		if solid(sx, sy+0.2) or
			solid(sx, sy-0.2) then
			quickdel(shots, i)
		else
			i += 1
		end
	end
end

function _init()
	p1 = new_player(0, 4, 4)
	p2 = new_player(1, 5, 4)

	players = {p1, p2}
end

function _update()
	move_player(p1)
	player_shoot(p1)
	move_player(p2)
	player_shoot(p2)

	update_shots()
end

function draw_player(pl)
	spr(16*pl.num+1 + pl.frame,pl.x*8-4,pl.y*8-8, 1, 1, pl.d < 0)
end

n_shots = 0

function draw_shots()
	n_shots = 0
	foreach(shots, function(s)
		spr(s.sprite, s.x*8-4, s.y*8-4, 1, 1, s.flip_x, s.flip_y)
		n_shots += 1
	end)
end

function robado()
	foreach(clouds, function(c)
		c.x += c.spd
		rectfill(c.x,c.y,c.x+c.w,c.y+4+(1-c.w/64)*12,new_bg~=nil and 14 or 1)
		if c.x > 128 then
			c.x = -c.w
			c.y=rnd(128-8)
		end
	end)


	foreach(particles, function(p)
		p.x += p.spd
		p.y += sin(p.off)
		p.off+= min(0.05,p.spd/8)
		rectfill(p.x,p.y,p.x+p.s,p.y+p.s,p.c)
		if p.x>128+4 then
			p.x=-4
			p.y=rnd(128)
		end
	end)

	-- dead particles
	foreach(dead_particles, function(p)
		p.x += p.spd.x
		p.y += p.spd.y
		p.t -=1
		if p.t <= 0 then del(dead_particles,p) end
		rectfill(p.x-p.t/5,p.y-p.t/5,p.x+p.t/5,p.y+p.t/5,14+p.t%2)
	end)

end

function _draw()
	cls()
	robado()
	mapdraw(0, 0, 0, 0, 200, 200)
	print(p1.x)
	print(p1.y)
	print(p1.frame)
	print(p1.standing)
	print("shots: "..(n_shots))

	draw_player(p1)
	draw_player(p2)
	draw_shots()
end

__gfx__
0000000007ccccc007ccccc007ccccc007ccccc007ccccc007ccccc0000000000000000000000000000000000000000000000000000000000000000000000000
000000007ccacacc7ccacacc7ccacacc7ccacacc7cacaccc7cacaccc000000000000000000000000000000000000000000000000000000000000000000000000
007007007ccacacd7ccacacd7ccacacd7ccacacd7cacaccd7cacaccd000000000000000000000000000000000000000000000000000000000000000000000000
00077000cccccccdcccccccdcccccccdcccccccdcccccccdcccccccd000000000000000000000000000000000000000000000000000000000000000000000000
000770000dccccd00dccccd00dccccd00dccccd00dccccd00dccccd0000000000000000000000000000000000000000000000000000000000000000000000000
0070070000dddd0000dddd0000dddd0000dddd0000dddd0000dddd00000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d00d0000d00d0000d00d0000d00d0000d00d0000d00d00000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d00d0000d000000000000000000d0000000d0000d00000000000000000000000000000000000000000000000000000000000000000000000000000
666666660b3333300b3333300b3333300b3333300b3333300b333330000000000000000000000000000000000000000000000000000000000000000000000000
6777777db33a3a33b33a3a33b33a3a33b3a3a333b3a3a333b3a3a333000000000000000000000000000000000000000000000000000000000000000000000000
6766666db33a3a31b33a3a31b33a3a31b3a3a331b3a3a331b3a3a331000000000000000000000000000000000000000000000000000000000000000000000000
d6ddddd5333333313333333133333331333333313333333133333331000000000000000000000000000000000000000000000000000000000000000000000000
5dddddd5013333100133331001333310013333100133331001333310000000000000000000000000000000000000000000000000000000000000000000000000
5dddddd5001111000011110000111100001111000011110000111100000000000000000000000000000000000000000000000000000000000000000000000000
5dddddd5001001000010010000100100001001000010010000100100000000000000000000000000000000000000000000000000000000000000000000000000
55555555001001000000010000100000001001000000010000100000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007aaaaa007aaaaa007aaaaa007aaaaa007aaaaa007aaaaa0000000000000000000000000000000000000000000000000000000000000000000000000
000000007aa8a8aa7aa8a8aa7aa8a8aa7a8a8aaa7a8a8aaa7a8a8aaa000000000000000000000000000000000000000000000000000000000000000000000000
000aaaa07aa8a8a97aa8a8a97aa8a8a97a8a8aa97a8a8aa97a8a8aa9000000000000000000000000000000000000000000000000000000000000000000000000
809a777aaaaaaaa9aaaaaaa9aaaaaaa9aaaaaaa9aaaaaaa9aaaaaaa9000000000000000000000000000000000000000000000000000000000000000000000000
09aa777a09aaaa9009aaaa9009aaaa9009aaaa9009aaaa9009aaaa90000000000000000000000000000000000000000000000000000000000000000000000000
000aaaa0009999000099990000999900009999000099990000999900000000000000000000000000000000000000000000000000000000000000000000000000
00000000009009000090090000900900009009000090090000900900000000000000000000000000000000000000000000000000000000000000000000000000
00000000009009000000090000900000009009000000090000900000000000000000000000000000000000000000000000000000000000000000000000000000
00000000076666600766666007666660076666600766666007666660000000000000000000000000000000000000000000000000000000000000000000000000
00000000766868667668686676686866768686667686866676868666000000000000000000000000000000000000000000000000000000000000000000000000
000000007668686d7668686d7668686d7686866d7686866d7686866d000000000000000000000000000000000000000000000000000000000000000000000000
000000006666666d6666666d6666666d6666666d6666666d6666666d000000000000000000000000000000000000000000000000000000000000000000000000
000000000d6666d00d6666d00d6666d00d6666d00d6666d00d6666d0000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd0000dddd0000dddd0000dddd0000dddd0000dddd00000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d00d0000d00d0000d00d0000d00d0000d00d0000d00d00000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d00d0000000d0000d0000000d00d0000000d0000d00000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000002000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010171717171717171717171710000010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010171717171717171717171710000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010171717171717171717171010000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010001717171717170000100010000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000017171717171010101010000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000000001717170000001710000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010101010101010101010101010000010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000017171717171700000017170000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010001717171717171717171717171700000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000000171717000000000000171700000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000000171700000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001035014350193501b3501d3501f3502335023350253502535025350253502435022350213501d350183501635014350133501135011350103500f3501535016350163502935000000000000000000000
0012000000000000001535017350183501b3501a35023350263501b3501c3501c3501d3501f3503335023350223501e3501c350393501435012350123503a3503935035350123502e3502c35027350233501e350
00100000353203a3103b3203b32035330323402f3402e3502e3402e3402f3503236035340363203632036340373403535033360313602f3602f36030350323403333035330373303734035360303703136036350
