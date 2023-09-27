
--[[
    GD50
    Super Mario Bros. Remake
    -- LevelMaker Class --
    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

local keyPicked = false

function LevelMaker.generate(width, height)
    keyPicked = false
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    local keySpawned = false
    local lockedBrickSpawned = false
    local keyColor = math.random(4)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            
            
            -- Spawn key
            
        elseif math.random(10) == 1 and not keySpawned then
                GenerateKey(keyColor, objects, x, blockHeight)
                keySpawned = true

            -- Spawn locked brick
            elseif math.random(10) == 1 and not lockedBrickSpawned then
                GenerateBrick(keyColor, objects, x, blockHeight, width, tiles)
                lockedBrickSpawned = true
            end
        end
    end

    if not keySpawned then
        GenerateKey(keyColor, objects, math.random(width), 3)
    end

    if not lockedBrickSpawned then
        GenerateBrick(keyColor, objects, math.random(width), 3, width, tiles)
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end

--[[
    Helper function to create Key game object
]]
function GenerateKey(color, objects, x, y)
    table.insert(objects, GameObject {
        texture = 'keys-and-locks',
        x = (x - 1) * 16,
        y = (y - 1) * 16,
        width = 16,
        height = 16,
        frame = color,
        collidable = true,
        consumable = true,

        onConsume = function(player, object)
            gSounds['pickup']:play()
            player.keyPicked = true
            keyPicked = true
        end
    })

end

--[[
    Helper function to create locked brick game object
]]
function GenerateBrick(color, objects, x, y, levelWidth, tiles)
    table.insert(objects, GameObject {
        texture = 'keys-and-locks',
        x = (x - 1) * 16,
        y = (y - 1) * 16,
        width = 16,
        height = 16,
        frame = color + 4,
        collidable = true,
        consumable = false,
        solid = true,

        onCollide = function(object)

            if keyPicked then
                local FlagX, FlagY

                for count = levelWidth, 1, -1 do
                    if tiles[5][count].id == TILE_ID_GROUND then
                        FlagX = count
                        FlagY = POLE_HEIGHT/2 - 2
                        break
                    
                    elseif tiles[7][count].id == TILE_ID_GROUND then
                        FlagX = count
                        FlagY = 6 + POLE_HEIGHT
                        break
                    end
                    
                end

                gSounds['kill2']:play()
                
                local pole = GameObject {
                    texture = 'pole',
                    x = (FlagX * TILE_SIZE) - POLE_WIDTH,
                    y = FlagY,
                    width = POLE_WIDTH,
                    height = POLE_HEIGHT,
                    frame = math.random(6),
                    consumable = false,
                    solid = false,

                }


                table.insert(objects, GameObject {
                    texture = 'flag',
                    x = pole.x + FLAG_WIDTH/2,
                    y = pole.y + FLAG_HEIGHT,
                    width = FLAG_WIDTH,
                    height = FLAG_HEIGHT,
                    frame = math.random(4),
                    consumable = true,
                    solid = false,
                    inverted = true,

                    onConsume = function(player, object)
                        gSounds['pickup']:play()
                        Timer.after(0.5, function()
                            gStateMachine:change('play', {
                            width = levelWidth + 20,
                            score = player.score
                        })
                    end
                )
                    end
                })

                table.insert(objects, pole)
            end
        end
    })
end