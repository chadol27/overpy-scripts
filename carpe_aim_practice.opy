settings {
    "main": {
        "description": "WIHS27#3669 기능 추가/수정/삭제, 신캐 추가 (Code: HCFYS, Last Update: 260805)",
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
            "respawnTime%": 0
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
globalvar tenfoldDamageEnabled 9
globalvar botMovementMode 17

#Player variables
playervar menuSelectionIndex 8
playervar settingsMenuOpen 12
playervar allowedHeroesBeforeChange 16

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, A or "", "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

def spawnInitialBots():
    @Name "초기 연습 봇 생성"

    createDummy(Hero.GENJI, Team.2, 1, vect(0, 0, 0))
    createDummy(Hero.MERCY, Team.2, 2, vect(0, 0, 0))
    createDummy(Hero.PHARAH, Team.2, 3, vect(0, 0, 0))
    createDummy(Hero.ASHE, Team.2, 4, vect(0, 0, 0))
    createDummy(Hero.DVA, Team.2, 5, vect(0, 0, 0))
    createDummy(Hero.TRACER, Team.2, 0, vect(0, 0, 0))

rule "초기화 및 안내 HUD 생성":
    tenfoldDamageEnabled = false
    botMovementMode = 1
    hudText(getAllPlayers(), "영웅변경: {0}+{1}\r\n설정(방장): {0}+{2}".format(inputBindingString(Button.CROUCH), inputBindingString(Button.ABILITY_2), inputBindingString(Button.INTERACT)), null, "번역 및 추가 기능 제작: 언급안함\nWIHS27#3669 수정\nHCFYS (260805 업뎃)", HudPosition.LEFT, -3, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudText(hostPlayer if hostPlayer.settingsMenuOpen else null, "{0}{1} 선택, {2} 변경, {3}+{2} 닫기".format(inputBindingString(Button.PRIMARY_FIRE), inputBindingString(Button.SECONDARY_FIRE), inputBindingString(Button.INTERACT), inputBindingString(Button.CROUCH)), null, "", HudPosition.TOP, 6, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)

rule "플레이어 스폰 초기화":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    if eventPlayer.isDummy():
        eventPlayer.disableRespawn()
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), getRealClosestPlayer(eventPlayer, getOppositeTeam(eventPlayer.getTeam())).getEyePosition()), 1000)
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.teleport(vect(212.938, 28.949, -28.076))
    elif eventPlayer.getTeam() == Team.1:
        eventPlayer.teleport(vect(214.334, 28.949, -56.506))
        eventPlayer.setFacing(Vector.FORWARD, Relativity.TO_WORLD)
    if tenfoldDamageEnabled:
        eventPlayer.setDamageDealt(1000)
    else:
        eventPlayer.setDamageDealt(100)


rule "봇 생성":
    spawnInitialBots()


rule "사망한 봇 이동 및 부활":
    @Event playerDied
    @Condition eventPlayer.isDummy() == true
    
    wait(0.1)
    eventPlayer.teleport(vect(209.256, 28.949, -31.08) + vect(random.uniform(-7, 7), random.uniform(0.5, 3), random.uniform(-7, 7)))
    if eventPlayer.getTeam() != Team.1:
        eventPlayer.startForcingHero(random.choice(getAllHeroes()))
    eventPlayer.resurrect()


rule "겐지 봇 반복 점프":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getHero() == Hero.GENJI
    
    eventPlayer.forceButtonPress(Button.JUMP)
    wait(0.25)
    if ruleCondition:
        loop()


rule "파라 봇 비행 유지":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
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
    @Condition eventPlayer.isDummy() == true
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
    @Condition eventPlayer.isDummy() == true
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
    wait(0.001)
    if ruleCondition:
        loop()


rule "봇 무빙 3 일정 좌우":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
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
    @Condition eventPlayer.isDummy() == true
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
    wait(0.001)
    if ruleCondition:
        loop()


rule "봇 무빙 5 정지":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition botMovementMode == 5
    
    eventPlayer.stopThrottleInDirection()
    wait(0.25)
    eventPlayer.stopThrottleInDirection()
    wait(0.25)
    eventPlayer.stopThrottleInDirection()


rule "모드 설정 메뉴 열기 및 닫기":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
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
    @Condition (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)) == true
    @Condition eventPlayer.settingsMenuOpen == true
    @Condition eventPlayer == hostPlayer
    
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.menuSelectionIndex < 3:
        eventPlayer.menuSelectionIndex++
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.menuSelectionIndex > 1:
        eventPlayer.menuSelectionIndex--


rule "모드 설정 실행":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.settingsMenuOpen == true
    @Condition eventPlayer.menuSelectionIndex >= 1
    @Condition eventPlayer.menuSelectionIndex <= 3
    @Condition eventPlayer == hostPlayer

    if eventPlayer.isHoldingButton(Button.CROUCH):
        return
    
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
    if eventPlayer.menuSelectionIndex == 1:
        tenfoldDamageEnabled = not tenfoldDamageEnabled
        if tenfoldDamageEnabled:
            getAllPlayers().setDamageDealt(1000)
            smallMessage(getAllPlayers(), "데미지 10배 ON")
        else:
            getAllPlayers().setDamageDealt(100)
            smallMessage(getAllPlayers(), "데미지 10배 OFF")
    elif eventPlayer.menuSelectionIndex == 2:
        destroyAllDummies()
        wait(0.25)
        spawnInitialBots()
        smallMessage(getAllPlayers(), "봇 초기화")
    elif eventPlayer.menuSelectionIndex == 3:
        if botMovementMode < 5:
            botMovementMode++
        else:
            botMovementMode = 1
        wait()
        smallMessage(getAllPlayers(), "무빙 변경: {}".format(botMovementMode))


rule "무한궁":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.getUltCharge() < 100

    eventPlayer.setUltCharge(100)
    wait()
    if ruleCondition:
        loop()


rule "영웅 변경":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true

    eventPlayer.allowedHeroesBeforeChange = eventPlayer.getAllowedHeroes()
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(eventPlayer.getHero()))
    wait(0.1)
    eventPlayer.setAllowedHeroes(eventPlayer.allowedHeroesBeforeChange)
