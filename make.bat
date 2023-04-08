mkdir dist
mkdir bin
mkdir src\generated
mkdir src\generated\sprites
mkdir src\generated\backgrounds


rgbgfx -c "#FFFFFF,#cfcfcf,#686868,#000000;" --columns -o src/generated/sprites/player-ship.2bpp src/resources/sprites/player-ship.png
rgbgfx -c "#FFFFFF,#cfcfcf,#686868,#000000;" --columns -o src/generated/sprites/enemy-ship.2bpp src/resources/sprites/enemy-ship.png
rgbgfx -c "#FFFFFF,#cfcfcf,#686868,#000000;" --columns -o src/generated/sprites/bullet.2bpp src/resources/sprites/bullet.png
rgbgfx -c "#FFFFFF,#cbcbcb,#414141,#000000;" -o src/generated/backgrounds/text-font.2bpp src/resources/backgrounds/text-font.png
rgbgfx -c "#FFFFFF,#cbcbcb,#414141,#000000;" --tilemap src/generated/backgrounds/star-field.tilemap --unique-tiles -o src/generated/backgrounds/star-field.2bpp src/resources/backgrounds/star-field.png
rgbgfx -c "#FFFFFF,#cbcbcb,#414141,#000000;" --tilemap src/generated/backgrounds/title-screen.tilemap --unique-tiles  -o src/generated/backgrounds/title-screen.2bpp src/resources/backgrounds/title-screen.png

rgbasm -L -o bin/ShootEmUp.o src/ShootEmUp.asm
rgbasm -L -o bin/title-screen-state.o src/states/title-screen/title-screen-state.asm
rgbasm -L -o bin/gameplay-state.o src/states/gameplay/gameplay-state.asm
rgbasm -L -o bin/text.o src/text.asm
rgbasm -L -o bin/background.o src/background.asm
rgbasm -L -o bin/interrupts.o src/interrupts.asm
rgbasm -L -o bin/vblank.o src/utils/vblank.asm

rgbasm -L -o bin/bullets.o src/objects/bullets.asm
rgbasm -L -o bin/enemies.o src/objects/enemies.asm
rgbasm -L -o bin/player.o src/objects/player.asm
rgbasm -L -o bin/enemy-bullet-collision.o src/objects/collision/enemy-bullet-collision.asm

rgbasm -L -o bin/sporbs_lib.o libs/sporbs_lib.asm
rgbasm -L -o bin/input.o libs/input.asm
rgbasm -L -o bin/math.o src/utils/math.asm
rgbasm -L -o bin/sprites.o src/sprites.asm
rgbasm -L -o bin/metasprites.o src/utils/metasprites.asm

rgblink -o dist/ShootEmUp.gb bin/input.o bin/vblank.o bin/title-screen-state.o bin/gameplay-state.o bin/text.o bin/interrupts.o bin/background.o bin/sprites.o bin/math.o  bin/bullets.o bin/player.o bin/enemies.o  bin/metasprites.o  bin/ShootEmUp.o bin/enemy-bullet-collision.o bin/sporbs_lib.o
rgbfix -v -p 0xFF dist/ShootEmUp.gb