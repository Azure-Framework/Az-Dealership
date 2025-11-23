Config = {}

Config.Debug = true

Config.Colors = {
    red    = { label = 'Red',    rgb = { 200, 40, 40 } },
    blue   = { label = 'Blue',   rgb = { 50, 90, 160 } },
    green  = { label = 'Green',  rgb = { 70, 145, 70 } },
    yellow = { label = 'Yellow', rgb = { 210, 160, 40 } },
    black  = { label = 'Black',  rgb = { 10, 10, 10 } },
    white  = { label = 'White',  rgb = { 230, 230, 230 } },
}

Config.Dealerships = {
    larry_sandy = {
        label = "Larry's RV & Performance",

        npc = {
            model = 's_m_m_highsec_01',
            coords = vector4(1224.785, 2728.655, 38.001, 178.806)
        },

        shopRadius = 2.5,

        purchaseSpawns = {
            vector4(1250.584, 2700.988, 37.973, 181.943),
            vector4(1210.180, 2701.866, 37.973, 179.302)
        },

        stock = {
            {
                id       = 'jester',
                model    = 'jester',
                name     = 'Jester',
                price    = 13500,
                category = '2door',
                imageUrl = 'https://imgimp.xyz/images/Stoic-2025-11-23_03-09-43-69227af7515d4.png',
                stats    = { speed = 7, accel = 7, braking = 6, traction = 6 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "The Jester: for when you want tuner vibes with just enough class to still get valet parking."
            },

            {
                id       = 'italirsx',
                model    = 'italirsx',
                name     = 'Itali RSX',
                price    = 15000,
                category = '2door',
                imageUrl = 'https://imgimp.xyz/images/Stoic-2025-11-23_03-11-29-69227b61e53e7.png',
                stats    = { speed = 8, accel = 8, braking = 7, traction = 6 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Perfect for broke Larry’s customers who still want something with two doors."
            },

            {
                id       = 'banshee',
                model    = 'banshee',
                name     = 'Banshee',
                price    = 11000,
                category = '2door',
                imageUrl = 'https://imgimp.xyz/images/Stoic-2025-11-23_03-11-48-69227b74919c8.png',
                stats    = { speed = 7, accel = 7, braking = 5, traction = 5 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Old-school muscle-meets-sport. Loud, twitchy, and guaranteed to annoy your neighbors."
            },
        },


        lotVehicles = {
            {
                stockId = 'italirsx',
                coords  = vector4(1234.963, 2719.298, 37.973, 183.564),
            },
            {
                stockId = 'pariah',
                coords  = vector4(1219.342, 2708.392, 37.973, 178.821),
            },
        },
    },
}
