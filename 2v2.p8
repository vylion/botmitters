pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
player = 
{team=0;ammo=0;shieldtime=0;
invtime=0; hp=0; x=0;y=0; psx=0, psy=0}

p1 = player;
p2 = player;
p3 = player;
p4 = player;



function _move(pl)
	
end
function _update()
	if btn(0) then
		move(p1);
	end
end
function _draw()
	cls()
	spr(0,p1.x,p1,y)
end

__gfx__
0000000007ccccc007ccccc007ccccc0666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000007ccacacc7ccacacc7ccacacc6777777d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007007ccacacd7ccacacd7ccacacd6766666d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000cccccccdcccccccdcccccccdd6ddddd50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000dccccd00dccccd00dccccd05dddddd50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000dddd0000dddd0000dddd005dddddd50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d00d0000d00d0000d00d005dddddd50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d00d0000000d0000d00000555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000b3333300b3333300b333330666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b33a3a33b33a3a33b33a3a33665555555555556600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b33a3a31b33a3a31b33a3a316555e6666666555600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333313333333133333331655e76666666655600000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000001333310013333100133331065e766666666665600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001111000011110000111100656666666666665600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001001000010010000100100656666666666665600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001001000000010000100000656666666666665600000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007aaaaa007aaaaa007aaaaa0656666666666665600000000000000000000000000000000000000000000000000000000000000000000000000000000
000000007a8a8aaa7a8a8aaa7a8a8aaa656666666666665600000000000000000000000000000000000000000000000000000000000000000000000000000000
000000007a8a8aa97a8a8aa97a8a8aa9656666666666665600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaa9aaaaaaa9aaaaaaa9656666666666665600000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000009aaaa9009aaaa9009aaaa90655666666666665600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000099990000999900655566666666555600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009009000090090000900900665555555555556600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009009000000090000900000066666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000076666600766666007666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000768686667686866676868666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000007686866d7686866d7686866d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006666666d6666666d6666666d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000d6666d00d6666d00d6666d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000dddd0000dddd0000dddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d00d0000d00d0000d00d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d00d0000000d0000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0004040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004242424240000002424242424000006060604000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004240000000000002424240024000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004242414142400002424000024000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004002424242400002424000024000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000000002424242424000024000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000000000000000000000024000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004040404062424242424242424000004040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000000000004000000000004000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000000000406040000000406040000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000000060000000000000000000600000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000