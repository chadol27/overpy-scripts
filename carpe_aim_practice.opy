#!define code "HCFYS"
#!define version "v3.260805"


settings {
    "main": {
        "description": f"{code} ({version})\nWIHS27#3669 기능 추가/수정/삭제, 신캐 추가",
        "modeName": "카르페 프로 에임연습장 by CHADOL"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "team1Slots": 6,
        "team2Slots": 0
    },
    "gamemodes": {
        "skirmish": {
            "enabledMaps": [
                "havana"
            ]
        },
        "general": {
            "heroLimit": "off",
        }
    },
    "heroes": {
        "allTeams": {
            "general": {
                "abilityCooldown%": 0,
                "enableInfiniteAmmo": true,
                "enableSpawningWithUlt": true,
                "ultGen%": 500,
                "combatUltGen%": 500,
                "passiveUltGen%": 500
            },
            "pharah": {
                "enablePassiveUnlimitedFuel": true
            }
        }
    }
}


#Global variables
globalvar tenfoldDamageEnabled = false
globalvar botMovementMode = 1


#Player variables
playervar menuSelectionIndex
playervar settingsMenuOpen
playervar allowedHeroesBeforeChange


#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, A or "", "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

#!define botSpawnPosition vect(212, 28, -31)
#!define playerSpawnPosition vect(215, 28, -58)
#!define playerSpawnFacing Vector.FORWARD

#!define HUMANS 1
#!define BOTS 2

enum Team:
    HUMANS = Team.1
    BOTS = Team.2

#!define allHumans getPlayers(Team.HUMANS)
#!define allBots getPlayers(Team.BOTS)

def spawnInitialBots():
    @Name "초기 연습 봇 생성"

    createDummy(Hero.GENJI, Team.BOTS, 1, botSpawnPosition)
    createDummy(Hero.MERCY, Team.BOTS, 2, botSpawnPosition)
    createDummy(Hero.PHARAH, Team.BOTS, 3, botSpawnPosition)
    createDummy(Hero.ASHE, Team.BOTS, 4, botSpawnPosition)
    createDummy(Hero.DVA, Team.BOTS, 5, botSpawnPosition)
    createDummy(Hero.TRACER, Team.BOTS, 0, botSpawnPosition)


rule "초기화 및 안내 HUD 생성":
    hudText(allHumans, "영웅변경 {0}{1}\r\n설정(방장) {0}{2}".format(buttonToString(Button.CROUCH), buttonToString(Button.ABILITY_2), buttonToString(Button.INTERACT)), null, f"번역 및 추가 기능 제작: 언급안함\nWIHS27#3669 수정\n{code} ({version})", HudPosition.LEFT, -3, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudText(hostPlayer if hostPlayer.settingsMenuOpen else null, "{0}/{1} 선택, {2} 변경, {3}{2} 닫기".format(buttonToString(Button.PRIMARY_FIRE), buttonToString(Button.SECONDARY_FIRE), buttonToString(Button.INTERACT), buttonToString(Button.CROUCH)), null, "", HudPosition.TOP, 6, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "매치 시간 고정":
    setMatchTime(27*60+27)
    pauseMatchTime()


rule "플레이어 스폰 초기화":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    
    if eventPlayer.getTeam() == Team.BOTS:
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), getRealClosestPlayer(eventPlayer, getOppositeTeam(eventPlayer.getTeam())).getEyePosition()), 1000)
    else:
        eventPlayer.teleport(playerSpawnPosition)
        eventPlayer.setFacing(playerSpawnFacing, Relativity.TO_WORLD)
        eventPlayer.setDamageReceived(0)
        if tenfoldDamageEnabled:
            eventPlayer.setDamageDealt(1000)
        else:
            eventPlayer.setDamageDealt(100)


rule "봇 생성":
    spawnInitialBots()


rule "스폰방에서 연습장으로 이동":
    @Event eachPlayer
    @Team HUMANS
    @Condition eventPlayer.isInSpawnRoom()

    eventPlayer.teleport(playerSpawnPosition)
    eventPlayer.setFacing(playerSpawnFacing, Relativity.TO_WORLD)


rule "리스폰":
    @Event playerDied
    
    wait(0.1)
    if eventPlayer.getTeam() == Team.BOTS:
        eventPlayer.teleport(botSpawnPosition + vect(random.uniform(-7, 7), 0, random.uniform(-7, 7)))
        eventPlayer.startForcingHero(random.choice(getAllHeroes()))
    else:
        eventPlayer.teleport(playerSpawnPosition)
        eventPlayer.setFacing(playerSpawnFacing, Relativity.TO_WORLD)
    eventPlayer.resurrect()


rule "겐지 봇 반복 점프":
    @Event eachPlayer
    @Team BOTS
    @Condition eventPlayer.getHero() == Hero.GENJI
    
    eventPlayer.forceButtonPress(Button.JUMP)
    wait(0.25)
    if ruleCondition:
        loop()


rule "파라 봇 비행":
    @Event eachPlayer
    @Team BOTS
    @Condition eventPlayer.getHero() == Hero.PHARAH
    
    if eventPlayer.getPosition().y < 30:
        eventPlayer.forceButtonPress(Button.ABILITY_1)
        wait(0.1)
    if eventPlayer.getPosition().y < 40:
        eventPlayer.startForcingButton(Button.JUMP)
        wait(random.uniform(0, 1))
        eventPlayer.stopForcingButton(Button.JUMP)
    wait(0.5)
    if ruleCondition:
        loop()


rule "봇 무빙 1 좌우 랜덤":
    @Event eachPlayer
    @Team BOTS
    @Condition botMovementMode == 1
    
    eventPlayer.startThrottleInDirection(Vector.LEFT, 1, Relativity.TO_PLAYER)
    wait(random.uniform(0.1, 1.5))
    eventPlayer.startThrottleInDirection(Vector.RIGHT, 1, Relativity.TO_PLAYER)
    wait(random.uniform(0.1, 1.5))
    if random.randint(1, 100) < 33:
        eventPlayer.forceButtonPress(Button.JUMP)
    if random.randint(1, 100) < 33:
        eventPlayer.forceButtonPress(Button.CROUCH)
    if ruleCondition:
        loop()


rule "봇 무빙 2 행동별 랜덤":
    @Event eachPlayer
    @Team BOTS
    @Condition botMovementMode == 2
    
    if random.randint(1, 100) < 33:
        eventPlayer.startThrottleInDirection(Vector.LEFT, 1, Relativity.TO_PLAYER)
        wait(random.uniform(0.1, 1))
    if random.randint(1, 100) < 33:
        eventPlayer.startThrottleInDirection(Vector.RIGHT, 1, Relativity.TO_PLAYER)
        wait(random.uniform(0.1, 1))
    if random.randint(1, 100) < 33:
        eventPlayer.forceButtonPress(Button.JUMP)
    if random.randint(1, 100) < 33:
        eventPlayer.forceButtonPress(Button.CROUCH)
    wait()
    if ruleCondition:
        loop()


rule "봇 무빙 3 일정 좌우":
    @Event eachPlayer
    @Team BOTS
    @Condition botMovementMode == 3
    
    eventPlayer.startThrottleInDirection(Vector.LEFT, 1, Relativity.TO_PLAYER)
    wait(0.6)
    eventPlayer.startThrottleInDirection(Vector.RIGHT, 1, Relativity.TO_PLAYER)
    wait(0.6)
    if random.randint(1, 100) < 33:
        eventPlayer.forceButtonPress(Button.JUMP)
    if random.randint(1, 100) < 33:
        eventPlayer.forceButtonPress(Button.CROUCH)
    if ruleCondition:
        loop()


rule "봇 무빙 4 간헐적 좌우":
    @Event eachPlayer
    @Team BOTS
    @Condition botMovementMode == 4
    
    if random.randint(1, 100) < 33:
        eventPlayer.startThrottleInDirection(Vector.LEFT, 1, Relativity.TO_PLAYER)
        wait(0.6)
    if random.randint(1, 100) < 33:
        eventPlayer.startThrottleInDirection(Vector.RIGHT, 1, Relativity.TO_PLAYER)
        wait(0.6)
    if random.randint(1, 100) < 33:
        eventPlayer.forceButtonPress(Button.JUMP)
    if random.randint(1, 100) < 33:
        eventPlayer.forceButtonPress(Button.CROUCH)
    wait()
    if ruleCondition:
        loop()


rule "봇 무빙 5 정지":
    @Event eachPlayer
    @Team BOTS
    @Condition botMovementMode == 5
    
    eventPlayer.stopThrottleInDirection()
    wait(0.25)
    eventPlayer.stopThrottleInDirection()
    wait(0.25)
    eventPlayer.stopThrottleInDirection()


rule "모드 설정 메뉴 열기 및 닫기":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer == hostPlayer
    
    if not eventPlayer.isHoldingButton(Button.CROUCH):
        return

    if eventPlayer.settingsMenuOpen:
        eventPlayer.settingsMenuOpen = false
    else:
        eventPlayer.menuSelectionIndex = 1
        eventPlayer.settingsMenuOpen = true


rule "모드 설정 메뉴 HUD 생성":
    hudHeader(hostPlayer if hostPlayer.settingsMenuOpen else null, "10배 데미지: {0}".format("O" if tenfoldDamageEnabled else "X"), HudPosition.RIGHT, 1, Color.BLUE if hostPlayer.menuSelectionIndex == 1 else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR)
    hudHeader(hostPlayer if hostPlayer.settingsMenuOpen else null, "봇 초기화", HudPosition.RIGHT, 2, Color.BLUE if hostPlayer.menuSelectionIndex == 2 else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR)
    hudHeader(hostPlayer if hostPlayer.settingsMenuOpen else null, "무빙 변경: {0}".format(botMovementMode), HudPosition.RIGHT, 3, Color.BLUE if hostPlayer.menuSelectionIndex == 3 else Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR)


rule "모드 설정 메뉴 항목 이동":
    @Event eachPlayer
    @Condition (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE))
    @Condition eventPlayer.settingsMenuOpen
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.menuSelectionIndex < 3:
        eventPlayer.menuSelectionIndex++
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.menuSelectionIndex > 1:
        eventPlayer.menuSelectionIndex--


rule "모드 설정 실행":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.settingsMenuOpen
    @Condition eventPlayer == hostPlayer

    if eventPlayer.isHoldingButton(Button.CROUCH):
        return
    
    playEffect(allHumans, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
    if eventPlayer.menuSelectionIndex == 1:
        tenfoldDamageEnabled = not tenfoldDamageEnabled
        if tenfoldDamageEnabled:
            allHumans.setDamageDealt(1000)
            bigMessage(allHumans, "데미지 10배 ON")
        else:
            allHumans.setDamageDealt(100)
            bigMessage(allHumans, "데미지 10배 OFF")
    elif eventPlayer.menuSelectionIndex == 2:
        destroyAllDummies()
        wait(0.25)
        spawnInitialBots()
        bigMessage(allHumans, "봇 초기화")
    elif eventPlayer.menuSelectionIndex == 3:
        if botMovementMode < 5:
            botMovementMode++
        else:
            botMovementMode = 1
        wait()
        bigMessage(allHumans, "무빙 변경: {}".format(botMovementMode))


rule "무한궁":
    @Event eachPlayer
    @Team HUMANS
    @Condition eventPlayer.getUltCharge() < 100

    eventPlayer.setUltCharge(100)
    wait()
    if ruleCondition:
        loop()


rule "영웅 변경":
    @Event eachPlayer
    @Team HUMANS
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)

    eventPlayer.allowedHeroesBeforeChange = eventPlayer.getAllowedHeroes()
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(eventPlayer.getHero()))
    wait()
    eventPlayer.setAllowedHeroes(eventPlayer.allowedHeroesBeforeChange)
