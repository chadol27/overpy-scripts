#!define code "00000"
#!define version "v1.260911"

settings {
    "main": {
        "description": f"{code} ({version})\nWIHS27#3669 기능 추가/수정/삭제\n원본: [ 최신코드 : 3WQ1K ] / [ 개인전ver : EFZSB ] / 하지 말라는 것만 하지 않으면 이길 수 있는 게임 / 260813ver",
        "modeName": "[점프하면 모두 X 된다] by CHADOL"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "spectatorSlots": 5,
        "team1Slots": 6,
        "team2Slots": 6,
        "returnToLobby": "never",
        "teamBalancing": "afterGame"
    },
    "gamemodes": {
        "assault": {
            "enabled": false,
            "captureSpeed%": 10
        },
        "elimination": {
            "enabledMaps": [
                "workshopChamber",
                "workshopIsland",
                "workshopIslandNight"
            ],
            "enableTiebreaker": false,
            "drawTime": 60,
            "enablePerks": true,
            "heroesAvailable": "mirroredRandom",
            "heroPoolSize": "teamSize",
            "perkEliminationCatchupLevelAmount%": 100,
            "perkGeneration%": 500,
            "enableWallhack": true,
            "wallhackEnabledTime": 30,
            "scoreToWin": 5,
            "tiebreakerTime": 60
        },
        "general": {
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "immediately",
            "enableRandomHeroes": true,
            "respawnTime%": 0
        }
    },
    "heroes": {
        "allTeams": {
            "disabledHeroes": [
                "lifeweaver"
            ],
            "general": {
                "abilityCooldown%": 33,
                "ultGen%": 500,
                "combatUltGen%": 500,
                "passiveUltGen%": 500
            }
        }
    }
}

#Global variables

globalvar random 0
globalvar kickcount 9
globalvar meleerandom 12

#Player variables
playervar qudtls_count 6

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, A or "", "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

#!suppressWarnings w_dark_color

rule "인스펙터 레코딩 비활성화":
    @Event eachPlayer
    
    disableInspector()


rule "랜덤 / 초기화":
    @Event eachPlayer
    @Condition (isInSetup() or isMatchBetweenRounds()) == true
    
    destroyAllHudTexts()
    destroyAllEffects()
    getAllPlayers().enableTextChat()
    random = random.randint(1, 20)
    eventPlayer.enableEnvironmentCollision()
    getAllPlayers().allowButton(Button.SECONDARY_FIRE)
    getAllPlayers().allowButton(Button.ABILITY_1)
    getAllPlayers().allowButton(Button.ABILITY_2)
    getAllPlayers().allowButton(Button.ULTIMATE)
    getAllPlayers().enableGamemodeHud()
    getAllPlayers().enableHeroHud()
    getAllPlayers().enableKillFeed()
    enableAnnouncer()
    getAllPlayers().enableNameplatesFor(getAllPlayers())
    getAllPlayers().enableScoreboard()
    eventPlayer.setGravity(100)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setHealingReceived(100)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setHealingDealt(100)
    eventPlayer.setMaxHealth(100)
    eventPlayer.stopForcingCurrentHero()
    eventPlayer.removeAllHealthPools()


rule "1. 점프 - 안내":
    @Event eachPlayer
    @Condition random == 1
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [점프] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudHeader(eventPlayer, "점프 해보세요^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "1. 점프 - 감지":
    @Event eachPlayer
    @Condition random == 1
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition isGameInProgress() == true
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 멋진 점프!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 멋진 점프가 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "2. 좌클릭 - 안내":
    @Event eachPlayer
    @Condition random == 2
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [좌클릭] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    eventPlayer.setDamageDealt(200)
    hudHeader(eventPlayer, "우클릭 금지였나 그랬을껄^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "2. 좌클릭 - 감지":
    @Event eachPlayer
    @Condition random == 2
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 좌클 실화냐? 진짜 가슴이 웅장해진다".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 웅장한 좌클이 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "3. 우클릭 - 안내":
    @Event eachPlayer
    @Condition random == 3
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [우클릭] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudHeader(eventPlayer, "이상..허다..내가..뭐라고..그랬더라?", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "3. 우클릭 - 감지":
    @Event eachPlayer
    @Condition random == 3
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 무대를 장악하는 우클릭!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님..와..역시..무대를 뒤집어버리셨다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "4. 궁극기 - 안내":
    @Event eachPlayer
    @Condition random == 4
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [궁극기] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudHeader(eventPlayer, "방금 말씀드린 그거 쓰고 싶으면 써보세요^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "4. 궁극기 - 감지":
    @Event eachPlayer
    @Condition random == 4
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 판을 만드는 궁극기!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 궁극기가 판을 뒤집어 버렸다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "5. E스킬 - 안내":
    @Event eachPlayer
    @Condition random == 5
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [ E스킬 ] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudHeader(eventPlayer, "이번 라운드는 분명 E스킬 금지였지?^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "5. E스킬 - 감지":
    @Event eachPlayer
    @Condition random == 5
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 화려한 E스킬!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 화려한 E스킬이 지구를 날려버렸다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "6. 쉬프트 - 안내":
    @Event eachPlayer
    @Condition random == 6
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [ 쉬프트 ] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudHeader(eventPlayer, "이번 금지행동은 E스킬 이었을거야^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "6. 쉬프트 - 감지":
    @Event eachPlayer
    @Condition random == 6
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 멋진 쉬프트!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 강렬한 쉬프트 스킬이 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "7. 전진 - 안내":
    @Event eachPlayer
    @Condition random == 7
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    getPlayersOnHero(Hero.DVA, Team.ALL).disallowButton(Button.ABILITY_1)
    getPlayersOnHero(Hero.JUNKRAT, Team.ALL).disallowButton(Button.ULTIMATE)
    bigMessage(eventPlayer, "이번 금지행동은 [전진] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudHeader(eventPlayer, "누군가한테 겁나 어려운거 1", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "7. 전진 - 안내(디바)":
    @Event eachPlayer
    @Hero dva
    @Condition random == 7
    @Condition isGameInProgress() == true
    
    wait(0.25)
    hudSubheader(eventPlayer, "이 라운드에서만 디바 쉬프트 비활성화됨 (전진과 같은판정)", HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "7. 전진 - 안내(정크렛)":
    @Event eachPlayer
    @Hero junkrat
    @Condition random == 7
    @Condition isGameInProgress() == true
    
    wait(0.25)
    hudSubheader(eventPlayer, "이 라운드에서만 정크렛 궁 비활성화됨 (전진과 같은판정)", HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "7. 전진 - 감지":
    @Event eachPlayer
    @Condition random == 7
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.getThrottle() == vect(0, 0, 1)
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 당당한 전진!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님이 너무 당당하게 걸어서 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "8. HUD, 채팅 - 안내":
    @Event eachPlayer
    @Condition random == 8
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "깔끔하게 한판 뜨는 라운드입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(1)
    getAllPlayers().disableTextChat()
    eventPlayer.disableGamemodeHud()
    eventPlayer.disableHeroHud()
    eventPlayer.disableKillFeed()
    eventPlayer.disableNameplatesFor(getAllPlayers())
    eventPlayer.disableScoreboard()
    disableAnnouncer()
    hudHeader(eventPlayer, "화면이 깔끔하니 좋네요 ^-^ (hud,채팅 금지)", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "9. 후진 - 안내":
    @Event eachPlayer
    @Condition random == 9
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [후진] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    hudHeader(eventPlayer, "누군가한테 겁나 어려운거 2", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "9. 후진 - 감지":
    @Event eachPlayer
    @Condition random == 9
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.getThrottle() == vect(0, 0, -1)
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 졸렬한 후진!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 졸렬한 뒷걸음질이 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "10. 재장전 - 안내":
    @Event eachPlayer
    @Condition random == 10
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [R] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudHeader(eventPlayer, "이번 라운드는 분명 궁극기였지? ^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "10. 재장전 - 감지":
    @Event eachPlayer
    @Condition random == 10
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 환경을 생각하지 않은 재장전!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님이 버린 탄들이 환경오염으로 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "11. 점프 & 쉬프트 - 안내":
    @Event eachPlayer
    @Condition random == 11
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [ 점프와 쉬프트 ] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudHeader(eventPlayer, "점프 금지였어요^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "11. 점프 & 쉬프트 - 감지(점프)":
    @Event eachPlayer
    @Condition random == 11
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 멋진 점프!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 멋진 점프가 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "11. 점프 & 쉬프트 - 감지(쉬프트)":
    @Event eachPlayer
    @Condition random == 11
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 화려한 쉬프트 사용!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 화려한 쉬프트에 지구가 날아가버렸다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "12. 앞으로만 - 안내":
    @Event eachPlayer
    @Condition random == 12
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [← , ↓ , →] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudHeader(eventPlayer, "누군가한테 겁나 어려운거 3", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "12. 앞으로만 - 감지(후진)":
    @Event eachPlayer
    @Condition random == 12
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.getThrottle() == vect(0, 0, -1)
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 졸렬한 후진!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 졸렬한 뒷걸음질이 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "12. 앞으로만 - 감지(왼쪽)":
    @Event eachPlayer
    @Condition random == 12
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.getThrottle() == vect(1, 0, 0)
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 게같은 왼쪽걸음!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 게 알러지가 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "12. 앞으로만 - 감지(오른쪽)":
    @Event eachPlayer
    @Condition random == 12
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.getThrottle() == vect(-1, 0, 0)
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 게같은 오른쪽걸음!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 게 알러지가 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "13. 궁극기 & 재장전 - 안내":
    @Event eachPlayer
    @Condition random == 13
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [궁극기와 재장전] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudHeader(eventPlayer, "아마 궁극기랑 재장전 금지였을걸요^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "13. 궁극기 & 재장전 - 감지(궁극기)":
    @Event eachPlayer
    @Condition random == 13
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 판을 뒤엎는 궁극기!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 궁극기가 지구를 뒤집어버렸다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "13. 궁극기 & 재장전 - 감지(재장전)":
    @Event eachPlayer
    @Condition random == 13
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 환경을 생각하지 않은 재장전!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님이 버린 탄들이 환경오염으로 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "14. 좌클릭 & 우클릭 - 안내":
    @Event eachPlayer
    @Condition random == 14
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [좌클릭과 우클릭] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudHeader(eventPlayer, "근접, 궁, 쉬프트, E 쓰세요^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.setDamageDealt(500)


rule "14. 좌클릭 & 우클릭 - 감지(좌클릭)":
    @Event eachPlayer
    @Condition random == 14
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 좌클 실화냐? 진짜 가슴이 웅장해진다".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 웅장한 좌클이 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "14. 좌클릭 & 우클릭 - 감지(우클릭)":
    @Event eachPlayer
    @Condition random == 14
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 무대를 장악하는 우클릭!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님..와..역시..무대를 뒤집어버리셨다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "변수 15 : 근접공격":
    @Event eachPlayer
    @Condition random == 15
    @Condition isGameInProgress() == true
    
    meleerandom = random.randint(1, 3)


rule "15. 근접공격 - 안내":
    @Event eachPlayer
    @Condition random == 15
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [근접공격] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudHeader(eventPlayer, "근접공격시 랜덤으로 [니팀] or [내팀] or [모두] 폭1사", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "15. 근접공격 - 사망(1팀)":
    @Event eachPlayer
    @Condition meleerandom == 1
    @Condition random == 15
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getPlayers(Team.1).teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 타노스 기운을 담은 주먹질!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 주먹질이 1팀을 날려버렸다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "15. 근접공격 - 사망(2팀)":
    @Event eachPlayer
    @Condition meleerandom == 2
    @Condition random == 15
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getPlayers(Team.2).teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 타노스 기운을 담은 주먹질!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 주먹질이 2팀을 날려버렸다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "15. 근접공격 - 사망(모두)":
    @Event eachPlayer
    @Condition meleerandom == 3
    @Condition random == 15
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 타노스 기운을 담은 주먹질!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 실수로 모두를 날려버렸다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "16. E스킬 & 쉬프트 - 안내":
    @Event eachPlayer
    @Condition random == 16
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [ 쉬프트 & E스킬 ] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudHeader(eventPlayer, "벌써 까먹은거 아니지? ㅋ", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "16. E스킬 & 쉬프트 - 감지(쉬프트)":
    @Event eachPlayer
    @Condition random == 16
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 멋진 쉬프트!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 강렬한 쉬프트 스킬이 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "16. E스킬 & 쉬프트 - 감지(E스킬)":
    @Event eachPlayer
    @Condition random == 16
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 화려한 E스킬!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 화려한 E스킬이 지구를 날려버렸다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "17. 한방전 - 안내":
    @Event eachPlayer
    @Condition random == 17
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 라운드는 [ 한방전 ] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    eventPlayer.disableEnvironmentCollision(false)
    eventPlayer.setGravity(50)
    eventPlayer.setMaxHealth(1)
    eventPlayer.setHealingReceived(0.1)
    eventPlayer.setDamageDealt(200)
    wait(0.25)
    hudHeader(eventPlayer, "벽뚫도 ㄱㄴ", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.removeAllHealthPools()


rule "18. 점프 & E스킬 - 안내":
    @Event eachPlayer
    @Condition random == 18
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [ 점프와 E스킬 ] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudHeader(eventPlayer, "금지행동이 궁극기랑 또 뭐였더라?", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "18. 점프 & E스킬 - 감지(점프)":
    @Event eachPlayer
    @Condition random == 18
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 멋진 점프!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 점프가 지구를 붕괴시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "18. 점프 & E스킬 - 감지(E스킬)":
    @Event eachPlayer
    @Condition random == 18
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    getAllPlayers().cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    getAllPlayers().teleport(vect(0, -10000, 0))
    bigMessage(getAllPlayers(), "{0}님의 화려한 E스킬 사용!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 화려한 E스킬에 지구가 날아가버렸다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "19. 서있기 - 안내":
    @Event eachPlayer
    @Condition random == 19
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 2)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 2)
    bigMessage(eventPlayer, "이번 금지행동은 [ 일어서 있기 ] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    wait(0.25)
    hudText(eventPlayer, "[앉기] 누르고 있어야 할걸?", null, "대신 개인전!", HudPosition.LEFT, 0, Color.RED, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.setMoveSpeed(200)


rule "19. 서있기 - 감지":
    @Event eachPlayer
    @Condition random == 19
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    eventPlayer.teleport(vect(0, -10000, 0))


rule "20. 가만히 있기 - 안내":
    @Event eachPlayer
    @Condition random == 20
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 2)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 2)
    bigMessage(eventPlayer, "이번 금지행동은 [ 가만히 서 있기 ] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "[ 가만히 서 있기 ] 금지!")
    wait(0.25)
    hudText(eventPlayer, "멈추면 죽는다!", null, "대신 개인전!", HudPosition.LEFT, 0, Color.RED, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "20. 가만히 있기 - 감지":
    @Event eachPlayer
    @Condition random == 20
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isStanding() == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    eventPlayer.teleport(vect(0, -10000, 0))


rule "리겜":
    @Condition isMatchComplete() == true
    
    wait(1)
    restartMatch()


rule "현재 모드 알림":
    @Event eachPlayer
    @Condition (isInSetup() or isGameInProgress()) == true
    
    wait(1)
    hudHeader(eventPlayer, "{0}번 실수시 강퇴".format(kickcount), HudPosition.RIGHT, 0, Color.AQUA, HudReeval.VISIBILITY_AND_STRING)


rule "워크샵 셋팅":
    @Event eachPlayer
    
    kickcount = createWorkshopSettingInt("설정", "자동강퇴 횟수", 3, 1, 10)


rule "실수한 횟수 표시1":
    @Event eachPlayer
    @Condition kickcount >= 3
    @Condition eventPlayer.qudtls_count >= 1
    
    createInWorldText(getAllPlayers(), "{0}번 실수함!\r\n \r\n ".format(eventPlayer.qudtls_count), eventPlayer, 1.3, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED)


rule "실수한 횟수 표시2":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition kickcount <= 2
    @Condition eventPlayer.qudtls_count >= 1
    
    hudSubtext(eventPlayer, "현재 {0}번 실수함!".format(eventPlayer.qudtls_count), HudPosition.RIGHT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "강퇴까지 3회 남음 - 전체 알림":
    @Event eachPlayer
    @Condition kickcount >= 2
    @Condition kickcount - eventPlayer.qudtls_count == 3
    @Condition eventPlayer.qudtls_count >= 1
    
    smallMessage(getAllPlayers(), "{0}님의 {1}번째 실수! 한글어 사용자신가요?".format(eventPlayer, eventPlayer.qudtls_count))


rule "강퇴까지 2회 남음 - 전체 알림":
    @Event eachPlayer
    @Condition kickcount >= 2
    @Condition kickcount - eventPlayer.qudtls_count == 2
    @Condition eventPlayer.qudtls_count >= 1
    
    smallMessage(getAllPlayers(), "{0}님의 {1}번째 실수! 능지 ㄱㅊ??".format(eventPlayer, eventPlayer.qudtls_count))


rule "강퇴까지 1회 남음 - 전체 알림":
    @Event eachPlayer
    @Condition kickcount >= 2
    @Condition kickcount - eventPlayer.qudtls_count == 1
    @Condition eventPlayer.qudtls_count >= 1
    
    smallMessage(getAllPlayers(), "{0}님의 {1}번째 실수! 마지막임 이제".format(eventPlayer, eventPlayer.qudtls_count))


rule "강퇴까지 1회 남음 - 개인 경고":
    @Event eachPlayer
    @Condition kickcount - eventPlayer.qudtls_count == 1
    @Condition kickcount >= 2
    @Condition eventPlayer.qudtls_count >= 1
    
    smallMessage(eventPlayer, "한번만 더해봐라")


rule "강퇴 기준 도달 - 플레이어 제거":
    @Event eachPlayer
    @Condition kickcount >= 2
    @Condition kickcount - eventPlayer.qudtls_count <= 0
    @Condition eventPlayer.qudtls_count >= 1
    
    smallMessage(eventPlayer, "나가 이새끼야")
    bigMessage(getAllPlayers(), "{0} 나가.".format(eventPlayer))
    wait(1.5)
    eventPlayer.removeFromGame()


rule "강퇴 횟수 1회 설정 - 첫 실수 제거":
    @Event eachPlayer
    @Condition kickcount == 1
    @Condition kickcount - eventPlayer.qudtls_count <= 0
    @Condition eventPlayer.qudtls_count >= 1
    
    smallMessage(eventPlayer, "잠시 후 자동강퇴 됩니다")
    wait(1.5)
    eventPlayer.removeFromGame()


# # 이거 무슨 역할인지 모르겠음
# rule "작은맵 피해 방지":
#     @Event eachPlayer
#     @Condition isInSetup() == true
#     @Condition eventPlayer.isAlive() == true
#     @Condition isGameInProgress() == false
    
#     eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 4.9)
#     if not ruleCondition:
#         return


rule "디버그: 더미생성":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.MELEE)
    @Condition len(getPlayers(Team.1)) == 1
    createDummy(Hero.ANA, Team.2, -1,eventPlayer)
