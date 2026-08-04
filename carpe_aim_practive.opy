settings {
    "main": {
        "description": "영웅 변경 - 앉기 + E , 모드 변경 -- 앉기 + Q  누른 상태에서 마우스 좌클릭 4번 누르고 상호작용 --> 해당 영웅으로 적들 모두 변경 , 신 챔프 추가",
        "modeName": "카르페 프로 에임연습장"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "team1Slots": 0,
        "team2Slots": 6
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
        "team1": {
            "mercy": {
                "ability1Cooldown%": 0,
                "weaponsEnabled": "staff"
            },
            "pharah": {
                "passiveRechargeRate%": 138
            }
        },
        "allTeams": {
            "general": {
                "abilityCooldown%": 0,
                "enableInfiniteAmmo": true,
                "enableSpawningWithUlt": true,
                "ultGen%": 500,
                "combatUltGen%": 500,
                "passiveUltGen%": 500
            }
        }
    }
}

#Global variables

globalvar AA 0
globalvar Iiii 8
globalvar JJ 9
globalvar MM 12
globalvar note 14
globalvar note_one 16
globalvar note_offon 17
globalvar score 26

#Player variables

playervar AC 0
playervar AB 1
playervar sore 8
playervar LLLL 11
playervar note 12

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, A or "", "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "설명":
    note = []
    Iiii = []
    hudText(getAllPlayers(), "◆ 영웅변경 : 앉기 + E\r\n◆ 모드 변경 : Q + 앉기 누른채로 유지", null, "◆번역 및 추가 기능 제작：언급안함", HudPosition.LEFT, -3, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudText(note, "● 에임연습을 위해 만들어진 워크샵 입니다. \r\nQ+앉기 버튼을 누르고 있으면 모드가 활성화 되고, \r\n마우스 좌클릭,우클릭을 통해 모드 변경이 가능합니다. \r\n해당 연습 모드를 실행하기 위해서는 상호작용키를 눌러 선택", null, "● 화이팅", HudPosition.TOP, 6, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudText(note, "★ 팀 동료 추가 - 당신의 영웅과 같은 팀 동료가 만들어진다.\r\n★ 자신과 같은 영웅 생성\r\n★ 무한반복\r\n★ 봇이 죽어도 영웅 변경 금지\r\n★ 10배 데미지\r\n★ 무빙 모드 5가지 설정 가능", null, "★ Q+앉기 유지 ( 설명창 닫기 )", HudPosition.TOP, 10, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "1":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    if not eventPlayer.isDummy():
        goto lbl_0
    eventPlayer.disableRespawn()
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), getClosestPlayer(eventPlayer, getOppositeTeam(eventPlayer.getTeam())).getEyePosition()), 1000)
    lbl_0:
    if eventPlayer.getTeam() != Team.1:
        goto lbl_1
    eventPlayer.teleport(vect(212.938, 28.949, -28.076))
    lbl_1:
    if eventPlayer.getTeam() != Team.2:
        goto lbl_2
    eventPlayer.teleport(vect(214.334, 28.949, -56.506))
    lbl_2:
    eventPlayer.setFacing(eventPlayer.T[997], Relativity.TO_WORLD)
    eventPlayer.T[250] = 0
    destroyInWorldText(eventPlayer.T[520])
    eventPlayer.setUltCharge(eventPlayer.T[100])
    if eventPlayer.isDummy() or eventPlayer in Iiii:
        goto lbl_3
    Iiii.append(eventPlayer)
    lbl_3:


rule "2":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.isInSpawnRoom() == true
    
    eventPlayer.teleport(vect(213.301, 28.999, -58.802))


rule "3":
    @Event playerEarnedElimination
    
    eventPlayer.AB++


rule "4":
    @Event playerDealtFinalBlow
    
    eventPlayer.AC++


rule "5":
    @Event eachPlayer
    @Team 2
    
    hudText(getAllPlayers(), "{0} {1}".format(heroIcon(eventPlayer.getHero()), eventPlayer), null, "처치 도움 {0} 처치한 적 {1}".format(eventPlayer.AB, eventPlayer.AC), HudPosition.LEFT, 0, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "6":
    createDummy(Hero.GENJI, Team.1, 1, vect(0, 0, 0))
    createDummy(Hero.MERCY, Team.1, 2, vect(0, 0, 0))
    createDummy(Hero.PHARAH, Team.1, 3, vect(0, 0, 0))
    createDummy(Hero.ASHE, Team.1, 4, vect(0, 0, 0))
    createDummy(Hero.DVA, Team.1, 5, vect(0, 0, 0))
    createDummy(Hero.TRACER, Team.1, 0, vect(0, 0, 0))


rule "7":
    @Event playerDied
    @Condition eventPlayer.isDummy() == true
    
    wait(0.1)
    eventPlayer.teleport(vect(209.256, 28.949, -31.08) + vect(random.uniform(-7, 7), random.uniform(0.5, 3), random.uniform(-7, 7)))
    if eventPlayer.getTeam() == Team.2:
        goto lbl_0
    if MM == 1:
        goto lbl_1
    eventPlayer.startForcingHero(random.choice(getAllHeroes()))
    lbl_0:
    lbl_1:
    eventPlayer.resurrect()


rule "8":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getHero() == Hero.GENJI
    
    eventPlayer.forceButtonPress(Button.JUMP)
    wait(0.25)
    if ruleCondition:
        loop()


rule "9":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getHero() == Hero.PHARAH
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.startForcingButton(Button.JUMP)
    wait(0.5)
    eventPlayer.stopForcingButton(Button.JUMP)
    wait(0.25)
    if ruleCondition:
        loop()


rule "10":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isDummy() == true
    @Condition isHeroBeingPlayed(Hero.PHARAH, eventPlayer.getTeam()) == true
    @Condition eventPlayer.getHero() == Hero.MERCY
    
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), getPlayersOnHero(Hero.PHARAH, eventPlayer.getTeam()).getEyePosition()), 1000)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.startForcingButton(Button.ABILITY_1)
    eventPlayer.startForcingButton(Button.JUMP)
    wait(6.25)
    if ruleCondition:
        loop()
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), getClosestPlayer(eventPlayer, getOppositeTeam(eventPlayer.getTeam())).getEyePosition()), 1000)
    eventPlayer.stopForcingButton(Button.JUMP)
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "ai 성능":
    @Event eachPlayer
    @Condition getClosestPlayer(eventPlayer, Team.ALL).isCommunicating(Comms.VOICE_LINE_UP) == true
    @Condition eventPlayer.isDummy() == true
    
    eventPlayer.communicate(Comms.HELLO)


rule "무빙":
    @Event eachPlayer
    @Team 2
    @Hero mercy
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.LLLL == 0
    
    if eventPlayer.LLLL != 0:
        goto lbl_0
    eventPlayer.LLLL = random.choice(Iiii)
    lbl_0:
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.LLLL.getEyePosition()), 1000)
    eventPlayer.startForcingButton(Button.ABILITY_1)
    if eventPlayer.LLLL in getPlayersInRadius(eventPlayer, 5, Team.ALL):
        goto lbl_1
    eventPlayer.startThrottleInDirection(Vector.FORWARD, 1, Relativity.TO_PLAYER)
    lbl_1:
    if not eventPlayer.LLLL in getPlayersInRadius(eventPlayer, 5, Team.ALL):
        goto lbl_2
    eventPlayer.stopThrottleInDirection()
    lbl_2:
    if not eventPlayer.isInAir():
        goto lbl_3
    eventPlayer.startForcingButton(Button.JUMP)
    lbl_3:
    if eventPlayer.LLLL.getHealth() >= eventPlayer.LLLL.getMaxHealth():
        goto lbl_4
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    lbl_4:
    if eventPlayer.LLLL.getHealth() < eventPlayer.LLLL.getMaxHealth():
        goto lbl_5
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    lbl_5:
    wait(2)
    if eventPlayer.LLLL.hasSpawned():
        loop()
    wait(0.25)
    eventPlayer.LLLL = 0


rule "무빙2":
    @Event eachPlayer
    @Team 2
    @Hero mercy
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.LLLL.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.isOnGround() == true
    
    eventPlayer.stopForcingButton(Button.JUMP)
    eventPlayer.forceButtonPress(Button.JUMP)


rule "무빙3":
    @Event eachPlayer
    @Team 2
    @Hero mercy
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.LLLL.isHoldingButton(Button.CROUCH) == false
    @Condition eventPlayer.isOnGround() == true
    
    eventPlayer.stopForcingButton(Button.CROUCH)


rule "무빙4":
    @Event eachPlayer
    @Team 2
    @Hero mercy
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.LLLL.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isOnGround() == true
    
    eventPlayer.startForcingButton(Button.CROUCH)


rule "무빙5":
    @Event eachPlayer
    @Team 2
    @Hero ana
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getUltCharge() == 100
    
    eventPlayer.LLLL = random.choice(Iiii)
    if eventPlayer.LLLL in getPlayersInRadius(eventPlayer, 5, Team.ALL):
        goto lbl_0
    eventPlayer.startThrottleInDirection(Vector.FORWARD, 1, Relativity.TO_PLAYER)
    lbl_0:
    if not eventPlayer.LLLL in getPlayersInRadius(eventPlayer, 5, Team.ALL):
        goto lbl_1
    eventPlayer.stopThrottleInDirection()
    lbl_1:
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.LLLL.getEyePosition()), 10000)
    if eventPlayer.isUsingUltimate():
        goto lbl_2
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    lbl_2:
    wait(1)
    if ruleCondition:
        loop()
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), getClosestPlayer(eventPlayer, getOppositeTeam(eventPlayer.getTeam())).getEyePosition()), 1000)
    eventPlayer.LLLL = 0
    eventPlayer.stopThrottleInDirection()


rule "01":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isCommunicating(Comms.NEED_HEALING) == true
    
    eventPlayer.T[100] = eventPlayer.getUltCharge()
    eventPlayer.T[250] = 1
    eventPlayer.T[999] = eventPlayer.getPosition()
    eventPlayer.T[997] = eventPlayer.getFacingDirection()
    eventPlayer.T[996] = eventPlayer.getNormalizedHealth()
    eventPlayer.setAllowedHeroes(getAllHeroes().exclude(eventPlayer.getHero()))
    createInWorldText(getPlayers(eventPlayer.getTeam()), eventPlayer, eventPlayer.T[999], 1.5, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    eventPlayer.T[520] = getLastCreatedText()
    wait(1.5)
    eventPlayer.setAllowedHeroes(getAllHeroes())


rule "02":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition JJ == 1
    
    eventPlayer.setUltCharge(100)


rule "03":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition note_offon[8] == 1
    @Condition eventPlayer.LLLL == 0
    
    eventPlayer.startThrottleInDirection(Vector.LEFT, 1, Relativity.TO_PLAYER)
    wait(random.uniform(0.1, 1.5))
    eventPlayer.startThrottleInDirection(Vector.RIGHT, 1, Relativity.TO_PLAYER)
    wait(random.uniform(0.1, 1.5))
    if random.randint(1, 100) >= 33:
        goto lbl_0
    eventPlayer.forceButtonPress(Button.JUMP)
    lbl_0:
    if random.randint(1, 100) >= 33:
        goto lbl_1
    eventPlayer.forceButtonPress(Button.CROUCH)
    lbl_1:
    if ruleCondition:
        loop()


rule "04":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.LLLL == 0
    @Condition note_offon[8] == 2
    
    if random.randint(1, 100) >= 33:
        goto lbl_0
    eventPlayer.startThrottleInDirection(Vector.LEFT, 1, Relativity.TO_PLAYER)
    wait(random.uniform(0.1, 1))
    lbl_0:
    if random.randint(1, 100) >= 33:
        goto lbl_1
    eventPlayer.startThrottleInDirection(Vector.RIGHT, 1, Relativity.TO_PLAYER)
    wait(random.uniform(0.1, 1))
    lbl_1:
    if random.randint(1, 100) >= 33:
        goto lbl_2
    eventPlayer.forceButtonPress(Button.JUMP)
    lbl_2:
    if random.randint(1, 100) >= 33:
        goto lbl_3
    eventPlayer.forceButtonPress(Button.CROUCH)
    lbl_3:
    wait(0.001)
    if ruleCondition:
        loop()


rule "05":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.LLLL == 0
    @Condition note_offon[8] == 3
    
    eventPlayer.startThrottleInDirection(Vector.LEFT, 1, Relativity.TO_PLAYER)
    wait(0.6)
    eventPlayer.startThrottleInDirection(Vector.RIGHT, 1, Relativity.TO_PLAYER)
    wait(0.6)
    if random.randint(1, 100) >= 33:
        goto lbl_0
    eventPlayer.forceButtonPress(Button.JUMP)
    lbl_0:
    if random.randint(1, 100) >= 33:
        goto lbl_1
    eventPlayer.forceButtonPress(Button.CROUCH)
    lbl_1:
    if ruleCondition:
        loop()


rule "06":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.LLLL == 0
    @Condition note_offon[8] == 4
    
    if random.randint(1, 100) >= 33:
        goto lbl_0
    eventPlayer.startThrottleInDirection(Vector.LEFT, 1, Relativity.TO_PLAYER)
    wait(0.6)
    lbl_0:
    if random.randint(1, 100) >= 33:
        goto lbl_1
    eventPlayer.startThrottleInDirection(Vector.RIGHT, 1, Relativity.TO_PLAYER)
    wait(0.6)
    lbl_1:
    if random.randint(1, 100) >= 33:
        goto lbl_2
    eventPlayer.forceButtonPress(Button.JUMP)
    lbl_2:
    if random.randint(1, 100) >= 33:
        goto lbl_3
    eventPlayer.forceButtonPress(Button.CROUCH)
    lbl_3:
    wait(0.001)
    if ruleCondition:
        loop()


rule "07":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.LLLL == 0
    @Condition note_offon[8] == 5
    
    eventPlayer.stopThrottleInDirection()
    wait(0.25)
    eventPlayer.stopThrottleInDirection()
    wait(0.25)
    eventPlayer.stopThrottleInDirection()


rule "":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Disabled
    
    eventPlayer.teleport(eventPlayer.getPosition() + eventPlayer.getFacingDirection() * 10)
    createEffect(getAllPlayers(), Effect.RING, Color.RED, eventPlayer, 3.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.setUltCharge(100)


rule "":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    if eventPlayer in note:
        goto lbl_0
    note_one[eventPlayer.sore].append(eventPlayer)
    note.append(eventPlayer)
    eventPlayer.note = eventPlayer
    return
    lbl_0:
    note.remove(eventPlayer)
    eventPlayer.note = 0
    note_one[eventPlayer.sore].remove(eventPlayer)


rule "모드설정":
    note = []
    hudHeader(note.exclude(note_one[1]), "팀 추가 {0}".format(getNumberOfPlayers(Team.2)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note_one[1], "팀 추가 {0}".format(getNumberOfPlayers(Team.2)), HudPosition.RIGHT, 1, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note.exclude(note_one[2]), "적을 한명 추가 {0}".format(getNumberOfPlayers(Team.1)), HudPosition.RIGHT, 2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note_one[2], "적을 한명 추가 {0}".format(getNumberOfPlayers(Team.1)), HudPosition.RIGHT, 2, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note.exclude(note_one[3]), "(모든 봇 제거)", HudPosition.RIGHT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note_one[3], "(모든 봇 제거)", HudPosition.RIGHT, 3, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note.exclude(note_one[4]), "(봇 리스폰)", HudPosition.RIGHT, 4, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note_one[4], "(봇 리스폰)", HudPosition.RIGHT, 4, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note.exclude(note_one[5]), "무한 궁 {0}".format(heroIcon(note_offon[5])), HudPosition.RIGHT, 5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note_one[5], "무한 궁 설정 {0}".format(heroIcon(note_offon[5])), HudPosition.RIGHT, 5, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note.exclude(note_one[6]), "10배 데미지 {0}".format(heroIcon(note_offon[6])), HudPosition.RIGHT, 6, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note_one[6], "10배 데미지 {0}".format(heroIcon(note_offon[6])), HudPosition.RIGHT, 6, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note.exclude(note_one[7]), "봇 죽어도 같은 영웅 유지 {0}".format(heroIcon(note_offon[7])), HudPosition.RIGHT, 7, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note_one[7], "봇 죽어도 같은 영웅 유지 {0}".format(heroIcon(note_offon[7])), HudPosition.RIGHT, 7, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note.exclude(note_one[8]), "무빙 변경 {0}".format(note_offon[8]), HudPosition.RIGHT, 8, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note_one[8], "무빙 변경 {0}".format(note_offon[8]), HudPosition.RIGHT, 8, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note.exclude(note_one[9]), "(추가)", HudPosition.RIGHT, 9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note_one[9], "(추가)", HudPosition.RIGHT, 9, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note.exclude(note_one[10]), "(추가)", HudPosition.RIGHT, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note_one[10], "(추가)", HudPosition.RIGHT, 10, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note.exclude(note_one[11]), "(추가)", HudPosition.RIGHT, 11, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudHeader(note_one[11], "(추가)", HudPosition.RIGHT, 11, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)


rule "10":
    @Event eachPlayer
    @Condition (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)) == true
    @Condition eventPlayer in note == true
    @Condition eventPlayer == hostPlayer
    
    if not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.sore >= 11:
        goto lbl_0
    note_one[eventPlayer.sore].remove(eventPlayer)
    eventPlayer.sore++
    note_one[eventPlayer.sore].append(eventPlayer)
    lbl_0:
    if not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.sore <= 1:
        goto lbl_1
    note_one[eventPlayer.sore].remove(eventPlayer)
    eventPlayer.sore--
    note_one[eventPlayer.sore].append(eventPlayer)
    lbl_1:


rule "11":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer in note == true
    @Condition eventPlayer.sore >= 1
    @Condition eventPlayer.sore <= 5
    @Condition eventPlayer == hostPlayer
    
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
    if eventPlayer.sore != 1:
        goto lbl_0
    bigMessage(getAllPlayers(), "{0} 팀 생성 {1}".format(eventPlayer, eventPlayer.getHero()))
    createDummy(eventPlayer.getHero(), eventPlayer.getTeam(), -1, eventPlayer.getPosition())
    return
    lbl_0:
    if eventPlayer.sore != 2:
        goto lbl_1
    bigMessage(getAllPlayers(), "{0} 적 생성 {1}".format(eventPlayer, eventPlayer.getHero()))
    createDummy(eventPlayer.getHero(), getOppositeTeam(eventPlayer.getTeam()), -1, vect(214.922, 28.849, -29.814))
    return
    lbl_1:
    if eventPlayer.sore != 3:
        goto lbl_2
    bigMessage(getAllPlayers(), "{0} 모든 봇 제거".format(eventPlayer))
    destroyAllDummies()
    return
    lbl_2:
    if eventPlayer.sore != 4:
        goto lbl_3
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).startForcingHero(eventPlayer.getHero())
    bigMessage(getAllPlayers(), "{0} 적 강제 변경 {1}".format(eventPlayer, eventPlayer.getHero()))
    return
    lbl_3:
    if eventPlayer.sore != 5:
        goto lbl_4
    if note_offon[5] != 0:
        goto lbl_5
    note_offon[5] = Hero.MERCY
    JJ = 1
    getAllPlayers().setUltCharge(100)
    bigMessage(getAllPlayers(), "{0} 무한 궁 설정".format(eventPlayer))
    return
    lbl_5:
    note_offon[5] = 0
    JJ = 0
    bigMessage(getAllPlayers(), "{0} 무한 궁 종료".format(eventPlayer))
    return
    lbl_4:


rule "12":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer in note == true
    @Condition eventPlayer.sore >= 6
    @Condition eventPlayer.sore <= 11
    @Condition eventPlayer == hostPlayer
    
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
    if eventPlayer.sore != 6:
        goto lbl_0
    if note_offon[6] != 0:
        goto lbl_1
    bigMessage(getAllPlayers(), "{0} 데미지 10배".format(eventPlayer))
    note_offon[6] = Hero.MERCY
    getAllPlayers().setDamageDealt(1000)
    return
    lbl_1:
    bigMessage(getAllPlayers(), "{0} 데미지 10배 취소".format(eventPlayer))
    note_offon[6] = 0
    getAllPlayers().setDamageDealt(100)
    return
    lbl_0:
    if eventPlayer.sore != 7:
        goto lbl_2
    if note_offon[7] != 0:
        goto lbl_3
    note_offon[7] = Hero.MERCY
    MM = 1
    bigMessage(getAllPlayers(), "{0} 적 영웅 변경 금지".format(eventPlayer))
    return
    lbl_3:
    note_offon[7] = 0
    MM = 0
    bigMessage(getAllPlayers(), "{0} 적 영웅 변경 금지 해제".format(eventPlayer))
    return
    lbl_2:
    if eventPlayer.sore != 8:
        goto lbl_4
    smallMessage(getAllPlayers(), "{0} 컴퓨터 무빙 변경".format(eventPlayer))
    if note_offon[8] >= 5:
        goto lbl_5
    note_offon[8]++
    return
    lbl_5:
    note_offon[8] = 1
    return
    lbl_4:


rule "13":
    @Condition score <= 11
    
    note_one[AA] = []
    score++
    wait()
    if ruleCondition:
        loop()
    note_offon[8] = 1


rule "14":
    @Event eachPlayer
    @Team 2
    @Hero mercy
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.LLLL.isCommunicating(Comms.THANKS) == true
    
    eventPlayer.LLLL = eventPlayer.LLLL.getPlayerClosestToReticle(eventPlayer.getTeam())
    wait(3)
    if not eventPlayer.LLLL.isDummy():
        goto lbl_0
    eventPlayer.LLLL = 0
    lbl_0:


rule "영웅변경":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    #@Condition eventPlayer.isCommunicating(Comms.ACKNOWLEDGE) == true
    wait(0.1)
    eventPlayer.Y = eventPlayer.getPosition()
    eventPlayer.Q = eventPlayer.getAllowedHeroes()
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(eventPlayer.getHero()))
    wait(0.25)
    eventPlayer.setAllowedHeroes(eventPlayer.Q)
    eventPlayer.Z = true
    eventPlayer.T = true


rule "위치저장값":
    @Event eachPlayer
    @Condition eventPlayer.Z == true
    @Condition eventPlayer.hasSpawned() == true
    
    wait(0.05)
    eventPlayer.teleport(eventPlayer.Y)
    eventPlayer.Z = false
    wait(0.1)
    eventPlayer.Y = eventPlayer.exclude(eventPlayer.getPosition())


