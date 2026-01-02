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
            -- =========================================================
            -- 2 DOOR (Sports / Muscle / Coupes)
            -- =========================================================
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

            -- no more custom images beyond the 3 above
            {
                id       = 'pariah',
                model    = 'pariah',
                name     = 'Pariah',
                price    = 15500,
                category = '2door',
                imageUrl = '',
                stats    = { speed = 8, accel = 8, braking = 6, traction = 7 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "A budget rocket with a reputation for embarrassing pricier toys."
            },
            {
                id       = 'elegy2',
                model    = 'elegy2',
                name     = 'Elegy RH8',
                price    = 12000,
                category = '2door',
                imageUrl = '',
                stats    = { speed = 7, accel = 7, braking = 6, traction = 6 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Tuner royalty. Cheap enough to buy, expensive enough to ruin your paycheck in upgrades."
            },
            {
                id       = 'sultan',
                model    = 'sultan',
                name     = 'Sultan',
                price    = 10500,
                category = '2door',
                imageUrl = '',
                stats    = { speed = 6, accel = 6, braking = 5, traction = 6 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "All-wheel fun with just enough chaos to keep it interesting."
            },
            {
                id       = 'futo',
                model    = 'futo',
                name     = 'Futo',
                price    = 6500,
                category = '2door',
                imageUrl = '',
                stats    = { speed = 5, accel = 5, braking = 4, traction = 4 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Light, cheap, and born to slide sideways the moment you look at the throttle."
            },
            {
                id       = 'dominator',
                model    = 'dominator',
                name     = 'Dominator',
                price    = 9500,
                category = '2door',
                imageUrl = '',
                stats    = { speed = 6, accel = 6, braking = 4, traction = 4 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "A muscle car with an ego problem and a gas bill to match."
            },
            {
                id       = 'gauntlet',
                model    = 'gauntlet',
                name     = 'Gauntlet',
                price    = 9000,
                category = '2door',
                imageUrl = '',
                stats    = { speed = 6, accel = 6, braking = 5, traction = 5 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Classic American attitude in two-door form."
            },
            {
                id       = 'schafter3',
                model    = 'schafter3',
                name     = 'Schafter V12',
                price    = 14000,
                category = '2door',
                imageUrl = '',
                stats    = { speed = 7, accel = 7, braking = 6, traction = 6 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Luxury coupe power without the supercar tax."
            },

            -- =========================================================
            -- 4 DOOR (Sedans / Sports Sedans)
            -- =========================================================
            {
                id       = 'premier',
                model    = 'premier',
                name     = 'Premier',
                price    = 3500,
                category = '4door',
                imageUrl = '',
                stats    = { speed = 4, accel = 4, braking = 4, traction = 4 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Reliable, basic, and perfect for people who hate excitement."
            },
            {
                id       = 'tailgater',
                model    = 'tailgater',
                name     = 'Tailgater',
                price    = 7500,
                category = '4door',
                imageUrl = '',
                stats    = { speed = 5, accel = 5, braking = 5, traction = 5 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "A clean exec sedan that still knows how to move."
            },
            {
                id       = 'schafter2',
                model    = 'schafter2',
                name     = 'Schafter',
                price    = 9000,
                category = '4door',
                imageUrl = '',
                stats    = { speed = 6, accel = 6, braking = 6, traction = 6 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Comfort, speed, and just enough menace."
            },
            {
                id       = 'fugitive',
                model    = 'fugitive',
                name     = 'Fugitive',
                price    = 5200,
                category = '4door',
                imageUrl = '',
                stats    = { speed = 5, accel = 5, braking = 5, traction = 5 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "The sensible pick that still looks sharp."
            },
            {
                id       = 'washington',
                model    = 'washington',
                name     = 'Washington',
                price    = 4800,
                category = '4door',
                imageUrl = '',
                stats    = { speed = 4, accel = 4, braking = 5, traction = 5 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Big body comfort for cruising Sandy without spilling your coffee."
            },
            {
                id       = 'intruder',
                model    = 'intruder',
                name     = 'Intruder',
                price    = 3200,
                category = '4door',
                imageUrl = '',
                stats    = { speed = 4, accel = 4, braking = 4, traction = 4 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Cheap daily driver vibes. It will get you there."
            },

            -- =========================================================
            -- MOTORCYCLES
            -- =========================================================
            {
                id       = 'bati',
                model    = 'bati',
                name     = 'Bati 801',
                price    = 9000,
                category = 'motorcycles',
                imageUrl = '',
                stats    = { speed = 7, accel = 8, braking = 5, traction = 5 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Fast, lightweight, and a proven way to regret your life choices."
            },
            {
                id       = 'akuma',
                model    = 'akuma',
                name     = 'Akuma',
                price    = 8500,
                category = 'motorcycles',
                imageUrl = '',
                stats    = { speed = 7, accel = 7, braking = 5, traction = 5 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "A street bike that bites back when you get cocky."
            },
            {
                id       = 'carbonrs',
                model    = 'carbonrs',
                name     = 'Carbon RS',
                price    = 11000,
                category = 'motorcycles',
                imageUrl = '',
                stats    = { speed = 8, accel = 8, braking = 5, traction = 5 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Sleek and stupid fast. Exactly what Larry would upsell."
            },
            {
                id       = 'innovation',
                model    = 'innovation',
                name     = 'Innovation',
                price    = 7000,
                category = 'motorcycles',
                imageUrl = '',
                stats    = { speed = 5, accel = 5, braking = 4, traction = 5 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Cruiser comfort with a bit of show-off chrome energy."
            },
            {
                id       = 'sanchez',
                model    = 'sanchez',
                name     = 'Sanchez',
                price    = 4500,
                category = 'motorcycles',
                imageUrl = '',
                stats    = { speed = 5, accel = 6, braking = 4, traction = 6 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Dirt-ready and perfect for Sand Shores chaos."
            },

            -- =========================================================
            -- OFFROAD
            -- =========================================================
            {
                id       = 'bifta',
                model    = 'bifta',
                name     = 'Bifta',
                price    = 8000,
                category = 'offroad',
                imageUrl = '',
                stats    = { speed = 6, accel = 6, braking = 4, traction = 7 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Beach buggy energy with desert attitude."
            },
            {
                id       = 'brawler',
                model    = 'brawler',
                name     = 'Brawler',
                price    = 18000,
                category = 'offroad',
                imageUrl = '',
                stats    = { speed = 6, accel = 6, braking = 5, traction = 7 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Overbuilt, loud, and allergic to paved roads."
            },
            {
                id       = 'dubsta3',
                model    = 'dubsta3',
                name     = 'Dubsta 6x6',
                price    = 22000,
                category = 'offroad',
                imageUrl = '',
                stats    = { speed = 5, accel = 5, braking = 5, traction = 7 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Because four wheels simply aren't enough for your ego."
            },
            {
                id       = 'rebel2',
                model    = 'rebel2',
                name     = 'Rebel (Clean)',
                price    = 6500,
                category = 'offroad',
                imageUrl = '',
                stats    = { speed = 4, accel = 4, braking = 4, traction = 6 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "A humble pickup that thrives in the dirt."
            },
            {
                id       = 'mesa',
                model    = 'mesa',
                name     = 'Mesa',
                price    = 7000,
                category = 'offroad',
                imageUrl = '',
                stats    = { speed = 5, accel = 5, braking = 4, traction = 6 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Simple off-road utility with classic SUV lines."
            },

            -- =========================================================
            -- SPECIAL (RVs / Vans / Utility "Larry's" vibe)
            -- =========================================================
            {
                id       = 'camper',
                model    = 'camper',
                name     = 'Camper',
                price    = 12000,
                category = 'special',
                imageUrl = '',
                stats    = { speed = 3, accel = 3, braking = 3, traction = 4 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Your mobile apartment with the handling of a sleepy whale."
            },
            {
                id       = 'journey',
                model    = 'journey',
                name     = 'Journey',
                price    = 9000,
                category = 'special',
                imageUrl = '',
                stats    = { speed = 3, accel = 3, braking = 3, traction = 4 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "The RV for anyone brave enough to live in the slow lane."
            },
            {
                id       = 'surfer',
                model    = 'surfer',
                name     = 'Surfer',
                price    = 5500,
                category = 'special',
                imageUrl = '',
                stats    = { speed = 3, accel = 3, braking = 3, traction = 4 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Vintage van charm with questionable reliability."
            },
            {
                id       = 'youga',
                model    = 'youga',
                name     = 'Youga',
                price    = 6000,
                category = 'special',
                imageUrl = '',
                stats    = { speed = 4, accel = 4, braking = 4, traction = 4 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "A work van that can double as a questionable life decision."
            },
            {
                id       = 'rumpo',
                model    = 'rumpo',
                name     = 'Rumpo',
                price    = 6200,
                category = 'special',
                imageUrl = '',
                stats    = { speed = 4, accel = 4, braking = 4, traction = 4 },
                colors   = { 'red', 'blue', 'yellow', 'green', 'black', 'white' },
                blurb    = "Cargo space for days, style for… maybe later."
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
