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


rule "변수1 : 점프":
    @Event eachPlayer
    @Condition random == 1
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [점프] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "점프 금지!")
    wait(0.25)
    hudHeader(eventPlayer, "점프 해보세요^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "점프시 사망":
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


rule "변수 2 : 좌클릭":
    @Event eachPlayer
    @Condition random == 2
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [좌클릭] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "좌클릭 금지! 대신 공격력 2배!")
    wait(0.25)
    eventPlayer.setDamageDealt(200)
    hudHeader(eventPlayer, "우클릭 금지였나 그랬을껄^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "좌클릭시 사망":
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


rule "변수 3 : 우클릭":
    @Event eachPlayer
    @Condition random == 3
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [우클릭] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "우클릭 금지!")
    wait(0.25)
    hudHeader(eventPlayer, "이상..허다..내가..뭐라고..그랬더라?", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "우클릭시 사망":
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


rule "변수 4 : 궁극기":
    @Event eachPlayer
    @Condition random == 4
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [궁극기] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "궁 사용 금지!")
    wait(0.25)
    hudHeader(eventPlayer, "방금 말씀드린 그거 쓰고 싶으면 써보세요^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "궁극기시 사망":
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


rule "변수 5 : E스킬":
    @Event eachPlayer
    @Condition random == 5
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [ {0} ] 입니다".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)))
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "{0} 스킬 금지!".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)))
    wait(0.25)
    hudHeader(eventPlayer, "이번 라운드는 분명 E스킬 금지였지?^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "E스킬 사용시 사망":
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


rule "변수 6 : 쉬프트":
    @Event eachPlayer
    @Condition random == 6
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [ {0} ] 입니다".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)))
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "{0} 스킬 금지!".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)))
    wait(0.25)
    hudHeader(eventPlayer, "이번 금지행동은 E스킬 이었을거야^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "쉬프트 사용시 사망":
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


rule "변수 7 : 전진키":
    @Event eachPlayer
    @Condition random == 7
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    getPlayersOnHero(Hero.DVA, Team.ALL).disallowButton(Button.ABILITY_1)
    getPlayersOnHero(Hero.JUNKRAT, Team.ALL).disallowButton(Button.ULTIMATE)
    bigMessage(eventPlayer, "이번 금지행동은 [전진] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "전진 금지! 전진 금지!")
    wait(0.25)
    hudHeader(eventPlayer, "어차피 누군가는 할거에요 포기해^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "변수 7 : 전진키 알림 디바":
    @Event eachPlayer
    @Hero dva
    @Condition random == 7
    @Condition isGameInProgress() == true
    
    wait(0.25)
    hudSubheader(eventPlayer, "이 라운드에서만 디바 쉬프트 비활성화됨 (전진과 같은판정)", HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "변수 7 : 전진키 알림 정크렛":
    @Event eachPlayer
    @Hero junkrat
    @Condition random == 7
    @Condition isGameInProgress() == true
    
    wait(0.25)
    hudSubheader(eventPlayer, "이 라운드에서만 정크렛 궁 비활성화됨 (전진과 같은판정)", HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "전진키 사용시 사망":
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


rule "변수 8 : hud,채팅":
    @Event eachPlayer
    @Condition random == 8
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "깔끔하게 한판 뜨는 라운드입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "깔끔하게 화면에 있는 모든걸 지워드릴게요")
    wait(1)
    getAllPlayers().disableTextChat()
    eventPlayer.disableGamemodeHud()
    eventPlayer.disableHeroHud()
    eventPlayer.disableKillFeed()
    eventPlayer.disableNameplatesFor(getAllPlayers())
    eventPlayer.disableScoreboard()
    disableAnnouncer()
    hudHeader(eventPlayer, "화면이 깔끔하니 좋네요 ^-^ (hud,채팅 금지)", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "변수 9 : 후진키":
    @Event eachPlayer
    @Condition random == 9
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [후진] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "뒤로가기 금지!")
    hudHeader(eventPlayer, "쫄?쫄?쫄?^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "후진키 사용시 사망":
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


rule "변수 10 : 재장전":
    @Event eachPlayer
    @Condition random == 10
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [R] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "수동 재장전 금지!")
    wait(0.25)
    hudHeader(eventPlayer, "이번 라운드는 분명 궁금지였지? ^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "재장전 사용시 사망":
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


rule "변수 11 : 점프 & 쉬프트":
    @Event eachPlayer
    @Condition random == 11
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [ 점프와 {0} ] 입니다".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)))
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "점프랑 {0} 둘 다 금지!".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)))
    wait(0.25)
    hudHeader(eventPlayer, "점프 금지였어요^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "점프&쉬프트 사용시 사망":
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


rule "점프&쉬프트 사용시 사망":
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


rule "변수 12 : 앞으로만":
    @Event eachPlayer
    @Condition random == 12
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [← , ↓ , →] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "[← , ↓ , →]  금지!")
    wait(0.25)
    hudHeader(eventPlayer, "후진 금지였나?^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "앞으로 제외 다른거 사용시 사망 - 후진":
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


rule "앞으로 제외 다른거 사용시 사망 - 왼쪽":
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
    bigMessage(getAllPlayers(), "{0}님의 꽃 '게같은' 왼쪽걸음!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 꽃게 알러지가 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "앞으로 제외 다른거 사용시 사망 - 오른쪽":
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
    bigMessage(getAllPlayers(), "{0}님의 꽃 '게같은' 오른쪽걸음!".format(eventPlayer))
    smallMessage(getAllPlayers(), "{0}님의 꽃게 알러지가 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "변수 13 : 궁극기 & 재장전":
    @Event eachPlayer
    @Condition random == 13
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [궁극기와 재장전] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "궁극기랑 재장전 둘 다 금지!")
    wait(0.25)
    hudHeader(eventPlayer, "아마 궁극기랑 재장전 금지였을걸요^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "궁극기&재장전 사용시 사망":
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


rule "궁극기&재장전 사용시 사망":
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


rule "변수 14 : 좌클릭 & 우클릭":
    @Event eachPlayer
    @Condition random == 14
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [좌클릭과 우클릭] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "좌우클릭 금지! 대신 공격력을 5배 올려드릴게요!")
    wait(0.25)
    hudHeader(eventPlayer, "근접, 궁, 쉬프트, E 쓰세요^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.setDamageDealt(500)


rule "좌클릭&우클릭 사용시 사망":
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


rule "좌클릭&우클릭 사용시 사망":
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


rule "변수 15 : 근접공격 안내":
    @Event eachPlayer
    @Condition random == 15
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [근접공격] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "근접공격이 금지래요~")
    wait(0.25)
    hudHeader(eventPlayer, "근접공격시 [니팀] or [내팀] or [모두] 중 하나가 날아갑니다 ^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "근접공격 사용시 1팀 사망":
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


rule "근접공격 사용시 2팀 사망":
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


rule "근접공격 사용시 모두 사망":
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


rule "변수 16 : E스킬 & 쉬프트":
    @Event eachPlayer
    @Condition random == 16
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [ {0} & {1} ] 입니다".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)))
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "E랑 쉬프트 둘 다 금지!")
    wait(0.25)
    hudHeader(eventPlayer, "방금 말씀드렸는데 벌써 까먹은거 아니죠?^-^", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "E스킬 & 쉬프트 사용시 사망":
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


rule "E스킬 & 쉬프트 사용시 사망":
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


rule "변수 17 : 한방전!":
    @Event eachPlayer
    @Condition random == 17
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 라운드는 [ 한방전 ] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "한방에 다 죽어요!")
    eventPlayer.disableEnvironmentCollision(false)
    eventPlayer.setGravity(50)
    eventPlayer.setMaxHealth(1)
    eventPlayer.setHealingReceived(0.1)
    eventPlayer.setDamageDealt(200)
    wait(0.25)
    hudHeader(eventPlayer, "벽을 뚫고 지나갈 수도 있어요!", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.removeAllHealthPools()


rule "변수 18 : 점프 & E":
    @Event eachPlayer
    @Condition random == 18
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 1)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    bigMessage(eventPlayer, "이번 금지행동은 [ 점프와 {0} ] 입니다".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)))
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "점프랑 {0} 둘 다 금지!".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)))
    wait(0.25)
    hudHeader(eventPlayer, "금지행동이 궁극기랑 또 뭐였더라?", HudPosition.LEFT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING)


rule "점프&쉬프트 사용시 사망":
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
    smallMessage(getAllPlayers(), "{0}님의 멋진 점프가 지구를 멸망시켰다...".format(eventPlayer))
    eventPlayer.qudtls_count++


rule "점프&쉬프트 사용시 사망":
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


rule "변수 19 : 서있기":
    @Event eachPlayer
    @Condition random == 19
    @Condition isGameInProgress() == true
    
    eventPlayer.setStatusEffect(null, Status.FROZEN, 2)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 2)
    bigMessage(eventPlayer, "이번 금지행동은 [ 일어서 있기 ] 입니다")
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    smallMessage(eventPlayer, "[ 일어서 있기 ] 금지!")
    wait(0.25)
    hudText(eventPlayer, "[앉기] 누르고 있어야 할걸요?", null, "대신 개인전!", HudPosition.LEFT, 0, Color.RED, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.setMoveSpeed(200)


rule "서 있을 시 사망":
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


rule "변수 20 : 가만히 있기":
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


rule "가만히 있을 시 사망":
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


rule "실수한 횟수 경고1":
    @Event eachPlayer
    @Condition kickcount >= 2
    @Condition kickcount - eventPlayer.qudtls_count == 3
    @Condition eventPlayer.qudtls_count >= 1
    
    smallMessage(getAllPlayers(), "{0}님의 {1}번째 실수! 한글어 사용자신가요?".format(eventPlayer, eventPlayer.qudtls_count))


rule "실수한 횟수 경고2":
    @Event eachPlayer
    @Condition kickcount >= 2
    @Condition kickcount - eventPlayer.qudtls_count == 2
    @Condition eventPlayer.qudtls_count >= 1
    
    smallMessage(getAllPlayers(), "{0}님의 {1}번째 실수! 능지 괜찮으신가요?".format(eventPlayer, eventPlayer.qudtls_count))


rule "실수한 횟수 경고3":
    @Event eachPlayer
    @Condition kickcount - eventPlayer.qudtls_count == 1
    @Condition kickcount >= 2
    @Condition eventPlayer.qudtls_count >= 1
    
    smallMessage(eventPlayer, "마지막 경고입니다. 주의하세요.")


rule "실수한 횟수 경고4":
    @Event eachPlayer
    @Condition kickcount >= 2
    @Condition kickcount - eventPlayer.qudtls_count <= 0
    @Condition eventPlayer.qudtls_count >= 1
    
    smallMessage(eventPlayer, "나가 이새끼야")
    bigMessage(getAllPlayers(), "{0} 나가.".format(eventPlayer))
    wait(1.5)
    eventPlayer.removeFromGame()


rule "실수한 횟수 경고5":
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