#!define code "7N5FA"
#!define version "v2.8"

settings {
    "main": {
        "description": f"Practice Range 2.2 by PMAJellies | WIHS27#3669 버그수정/업데이트 {version}",
        "modeName": "훈련장+"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "team1Slots": 6
    },
    "gamemodes": {
        "practiceRange": {},
        "general": {
            "heroLimit": "off",
            "respawnTime%": 0
        }
    },
    "heroes": {
        "team2": {
            "genji": {
                "ability2Cooldown%": 0
            },
            "reaper": {
                "ability2Cooldown%": 0,
                "ability1Cooldown%": 0
            },
            "reinhardt": {
                "secondaryFireCooldown%": 0,
                "secondaryFireRechargeRate%": 500,
                "damageDealt%": 10,
                "ability2Cooldown%": 0,
                "enableSpawningWithUlt": true,
                "passiveUltGen%": 500,
                "ultGen%": 500
            },
            "sombra": {
                "passiveUltGen%": 500,
                "ultGen%": 500,
                "ability1Cooldown%": 0
            },
            "symmetra": {
                "ability1Cooldown%": 0
            },
            "tracer": {
                "ability1Cooldown%": 0,
                "damageDealt%": 10,
                "ability2Cooldown%": 0
            },
            "widowmaker": {
                "ability1Cooldown%": 0
            }
        },
        "allTeams": {
            "general": {
                "abilityCooldown%": 0,
                "enableInfiniteAmmo": true,
                "enableSpawningWithUlt": true
            }
        }
    }
}

globalvar mercySphere 26

playervar iscreatedbot 26
playervar isInMenu 27
playervar menuValue 28
playervar infUlt 29
playervar damageBoost 30
playervar boostTime 31
playervar isInBoost 32
playervar isFlying 33
playervar infAmmo 34
playervar infAbill 35

#!suppressWarnings w_dark_color

#!include "original.opy"
#!include "chadol.opy"
