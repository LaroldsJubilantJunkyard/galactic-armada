mkdir dist
mkdir bin


rgbgfx -c "#FFFFFF,#cfcfcf,#686868,#000000;" --columns -o src/resources/sprites/player-ship.2bpp src/resources/sprites/player-ship.png
rgbgfx -c "#FFFFFF,#cfcfcf,#686868,#000000;" --columns -o src/resources/sprites/enemy-ship.2bpp src/resources/sprites/enemy-ship.png
rgbgfx -c "#FFFFFF,#cfcfcf,#686868,#000000;" --columns -o src/resources/sprites/bullet.2bpp src/resources/sprites/bullet.png
rgbgfx -c "#FFFFFF,#cbcbcb,#414141,#000000;" -o src/resources/sprites/text-font.2bpp src/resources/sprites/text-font.png
rgbgfx -c "#FFFFFF,#cbcbcb,#414141,#000000;" -P --tilemap src/resources/sprites/star-field.tilemap --unique-tiles -o src/resources/sprites/star-field.2bpp src/resources/sprites/star-field.png
rgbgfx -c "#FFFFFF,#cbcbcb,#414141,#000000;" -P --tilemap src/resources/sprites/title-screen.tilemap --unique-tiles  -o src/resources/sprites/title-screen.2bpp src/resources/sprites/title-screen.png

rgbasm -L -o bin/ShootEmUp.o src/ShootEmUp.asm
rgbasm -L -o bin/text.o src/text.asm
rgbasm -L -o bin/background.o src/background.asm
rgbasm -L -o bin/interrupts.o src/interrupts.asm

rgbasm -L -o bin/bullets.o src/objects/bullets.asm
rgbasm -L -o bin/enemies.o src/objects/enemies.asm
rgbasm -L -o bin/player.o src/objects/player.asm
rgbasm -L -o bin/enemy-bullet-collision.o src/objects/collision/enemy-bullet-collision.asm

rgbasm -L -o bin/sporbs_lib.o libs/sporbs_lib.asm
rgbasm -L -o bin/input.o libs/input.asm
rgbasm -L -o bin/math.o src/utils/math.asm
rgbasm -L -o bin/sprites.o src/sprites.asm
rgbasm -L -o bin/metasprites.o src/utils/metasprites.asm

rgblink -o dist/ShootEmUp.gb bin/input.o bin/text.o bin/interrupts.o bin/background.o bin/sprites.o bin/math.o  bin/bullets.o bin/player.o bin/enemies.o  bin/metasprites.o  bin/ShootEmUp.o bin/enemy-bullet-collision.o bin/sporbs_lib.o
rgbfix -v -p 0xFF dist/ShootEmUp.gb