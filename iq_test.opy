#!define code "M68WD"
#!define version "v5.260913"

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
            "enablePerks": false,
            "heroesAvailable": "mirroredRandom",
            "heroPoolSize": "teamSize",
            "enableWallhack": true,
            "wallhackEnabledTime": 30,
            "scoreToWin": 9,
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
                "abilityCooldown%": 50,
                "ultGen%": 300,
                "combatUltGen%": 300,
                "passiveUltGen%": 300
            }
        }
    }
}

enum ForbiddenActions:
    JUMP = 1
    LEFT_CLICK = 2
    RIGHT_CLICK = 3
    ULTIMATE = 4
    ABILITY_2 = 5
    ABILITY_1 = 6
    MOVE_FORWARD = 7
    HUD_AND_CHAT = 8
    MOVE_BACKWARD = 9
    RELOAD = 10
    JUMP_SHIFT = 11
    ONLY_FORWARD = 12
    ULTIMATE_RELOAD = 13
    LEFT_RIGHT_CLICK = 14
    MELEE = 15
    ABILITY_1_ABILITY_2 = 16
    ONE_SHOT = 17
    JUMP_ABILITY_2 = 18
    STANDING = 19
    STAY_STILL = 20

#Global variables

globalvar random
globalvar kickcount
globalvar meleerandom
globalvar guideBigMessage = ""
globalvar guideHudHeader = ""
globalvar guideHudSubtext = ""  
globalvar someone_qudtlsed = false
globalvar topMessage = ""
globalvar banHud

#Player variables
playervar qudtls_count 6
playervar detectionMessage


def detectionEffects():
    eventPlayer.cancelPrimaryAction()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer, 50)
    eventPlayer.applyImpulse(Vector.UP, max(0, 9999999), Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)


def detectFail():
    someone_qudtlsed = true
    detectionEffects()
    bigMessage(getAllPlayers(), eventPlayer.detectionMessage)
    wait(1)
    getAllPlayers().teleport(vect(0, -10000, 0))
    eventPlayer.qudtls_count++


def meleeFail():
    someone_qudtlsed = true
    meleerandom = random.randint(1, 3)
    detectionEffects()
    bigMessage(getAllPlayers(), eventPlayer.detectionMessage)
    wait(1)
    if meleerandom == 1:
        getPlayers(Team.1).teleport(vect(0, -10000, 0))
    elif meleerandom == 2:
        getPlayers(Team.2).teleport(vect(0, -10000, 0))
    else:
        getAllPlayers().teleport(vect(0, -10000, 0))
    eventPlayer.qudtls_count++


def standingOrStillFail():
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    detectionEffects()
    wait(1)
    eventPlayer.teleport(vect(0, -10000, 0))
    eventPlayer.qudtls_count++

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, A or "", "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

#!suppressWarnings w_dark_color


rule "라운드 준비시간 초기화":
    @Event global
    @Condition isInSetup() == true

    guideHudHeader = ""
    guideHudSubtext = ""
    topMessage = ""
    
    destroyAllEffects()
    someone_qudtlsed = false
    getAllPlayers().enableTextChat()
    random = random.randint(1, len(ForbiddenActions))
    getAllPlayers().enableEnvironmentCollision()
    getAllPlayers().allowButton(Button.SECONDARY_FIRE)
    getAllPlayers().allowButton(Button.ABILITY_1)
    getAllPlayers().allowButton(Button.ABILITY_2)
    getAllPlayers().allowButton(Button.ULTIMATE)
    getAllPlayers().setGravity(100)
    getAllPlayers().setMoveSpeed(100)
    getAllPlayers().setProjectileSpeed(100)
    getAllPlayers().setHealingReceived(100)
    getAllPlayers().setDamageDealt(100)
    getAllPlayers().setHealingDealt(100)
    getAllPlayers().setMaxHealth(100)
    getAllPlayers().stopForcingCurrentHero()
    getAllPlayers().removeAllHealthPools()


rule "라운드 후 초기화":
    @Condition isMatchBetweenRounds()
    getAllPlayers().enableGamemodeHud()
    getAllPlayers().enableHeroHud()
    getAllPlayers().enableKillFeed()
    enableAnnouncer()
    getAllPlayers().enableNameplatesFor(getAllPlayers())
    getAllPlayers().enableScoreboard()


rule "시작 전 피해 방지":
    @Event eachPlayer
    @Condition isInSetup() == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == false
    
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 10)


rule "HUD - 공통":
    hudText(getAllPlayers(), guideHudHeader, null, guideHudSubtext, HudPosition.RIGHT, 0, Color.RED, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), f"WIHS27#3669 수정 {code}({version})\n원본: 3WQ1K", HudPosition.LEFT)
    hudHeader(getAllPlayers(), f"\n  {topMessage}  \n" if topMessage else "", HudPosition.TOP, reevaluation=HudReeval.VISIBILITY_AND_STRING)



rule "HUD - 각 플레이어":
    @Event eachPlayer

    hudHeader(eventPlayer, "{1}번 실수 (강퇴: {0}번)".format(kickcount, eventPlayer.qudtls_count), HudPosition.RIGHT, -1, Color.AQUA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)


rule "금지행동 - 안내":
    @Event global
    @Condition isGameInProgress() == true

    guideHudSubtext = ""
    switch random:
        case ForbiddenActions.JUMP:
            guideBigMessage = "이번 금지행동은 [점프] 입니다"
            guideHudHeader = "점프 해보세요^-^"
            break
        case ForbiddenActions.LEFT_CLICK:
            guideBigMessage = "이번 금지행동은 [좌클릭] 입니다"
            guideHudHeader = "우클릭 금지였나 그랬을껄^-^"
            break
        case ForbiddenActions.RIGHT_CLICK:
            guideBigMessage = "이번 금지행동은 [우클릭] 입니다"
            guideHudHeader = "이상..허다..내가..뭐라고..그랬더라?"
            break
        case ForbiddenActions.ULTIMATE:
            guideBigMessage = "이번 금지행동은 [궁극기] 입니다"
            guideHudHeader = "방금 말씀드린 그거 쓰고 싶으면 써보세요^-^"
            break
        case ForbiddenActions.ABILITY_2:
            guideBigMessage = "이번 금지행동은 [E스킬] 입니다"
            guideHudHeader = "이번 라운드는 분명 E스킬 금지였지?^-^"
            break
        case ForbiddenActions.ABILITY_1:
            guideBigMessage = "이번 금지행동은 [쉬프트] 입니다"
            guideHudHeader = "이번 금지행동은 E스킬 이었을거야^-^"
            break
        case ForbiddenActions.MOVE_FORWARD:
            guideBigMessage = "이번 금지행동은 [전진] 입니다(스킬 조심)"
            guideHudHeader = "누군가한테 겁나 어려운거 1"
            guideHudSubtext = "스킬 쓸때 조심"
            break
        case ForbiddenActions.HUD_AND_CHAT:
            guideBigMessage = "깔끔하게 한판 뜨는 라운드입니다"
            guideHudHeader = "화면이 깔끔하니 좋네요 ^-^ (hud,채팅 금지)"
            break
        case ForbiddenActions.MOVE_BACKWARD:
            guideBigMessage = "이번 금지행동은 [후진] 입니다"
            guideHudHeader = "누군가한테 겁나 어려운거 2"
            break
        case ForbiddenActions.RELOAD:
            guideBigMessage = "이번 금지행동은 [R] 입니다"
            guideHudHeader = "이번 라운드는 분명 궁극기였지? ^-^"
            break
        case ForbiddenActions.JUMP_SHIFT:
            guideBigMessage = "이번 금지행동은 [점프와 쉬프트] 입니다"
            guideHudHeader = "점프 금지였어요^-^"
            break
        case ForbiddenActions.ONLY_FORWARD:
            guideBigMessage = "이번 금지행동은 [← , ↓ , →] 입니다"
            guideHudHeader = "누군가한테 겁나 어려운거 3"
            break
        case ForbiddenActions.ULTIMATE_RELOAD:
            guideBigMessage = "이번 금지행동은 [궁극기와 재장전] 입니다"
            guideHudHeader = "아마 궁극기랑 재장전 금지였을걸요^-^"
            break
        case ForbiddenActions.LEFT_RIGHT_CLICK:
            guideBigMessage = "이번 금지행동은 [좌클릭과 우클릭] 입니다"
            guideHudHeader = "근접, 궁, 쉬프트, E 쓰세요^-^"
            break
        case ForbiddenActions.MELEE:
            guideBigMessage = "이번 금지행동은 [근접공격] 입니다"
            guideHudHeader = "근접공격시 랜덤으로 [니팀] or [내팀] or [모두] 폭1사"
            break
        case ForbiddenActions.ABILITY_1_ABILITY_2:
            guideBigMessage = "이번 금지행동은 [쉬프트 & E스킬] 입니다"
            guideHudHeader = "벌써 까먹은거 아니지? ㅋ"
            break
        case ForbiddenActions.ONE_SHOT:
            guideBigMessage = "이번 라운드는 [한방전] 입니다"
            guideHudHeader = "벽뚫도 ㄱㄴ"
            break
        case ForbiddenActions.JUMP_ABILITY_2:
            guideBigMessage = "이번 금지행동은 [점프와 E스킬] 입니다"
            guideHudHeader = "금지행동이 궁극기랑 또 뭐였더라?"
            break
        case ForbiddenActions.STANDING:
            guideBigMessage = "이번 금지행동은 [일어서 있기] 입니다"
            guideHudHeader = "[앉기] 누르고 있어야 할걸?"
            guideHudSubtext = "대신 개인전!"
            break
        case ForbiddenActions.STAY_STILL:
            guideBigMessage = "이번 금지행동은 [가만히 서 있기] 입니다"
            guideHudHeader = "멈추면 죽는다!"
            guideHudSubtext = "대신 개인전!"
            break
    
    getAllPlayers().cancelPrimaryAction()
    getAllPlayers().clearStatusEffect(Status.PHASED_OUT)
    getAllPlayers().clearStatusEffect(Status.INVINCIBLE)

    if random == ForbiddenActions.STANDING or random == ForbiddenActions.STAY_STILL:
        getAllPlayers().setStatusEffect(null, Status.FROZEN, 2)
        getAllPlayers().setStatusEffect(null, Status.INVINCIBLE, 2)
    else:
        getAllPlayers().setStatusEffect(null, Status.FROZEN, 1)
        getAllPlayers().setStatusEffect(null, Status.INVINCIBLE, 1)

    if random == ForbiddenActions.ONE_SHOT:
        getAllPlayers().disableEnvironmentCollision(false)
        getAllPlayers().setGravity(50)
        getAllPlayers().setMaxHealth(1)
        getAllPlayers().setHealingReceived(0.1)
        getAllPlayers().setDamageDealt(200)

    bigMessage(getAllPlayers(), guideBigMessage)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, null, 100)

    if random == ForbiddenActions.HUD_AND_CHAT:
        wait(1)
        getAllPlayers().disableTextChat()
        getAllPlayers().disableGamemodeHud()
        getAllPlayers().disableHeroHud()
        getAllPlayers().disableKillFeed()
        getAllPlayers().disableNameplatesFor(getAllPlayers())
        getAllPlayers().disableScoreboard()
        disableAnnouncer()
    else:
        wait(0.25)

    if random == ForbiddenActions.LEFT_CLICK:
        getAllPlayers().setDamageDealt(200)
    elif random == ForbiddenActions.LEFT_RIGHT_CLICK:
        getAllPlayers().setDamageDealt(500)
    elif random == ForbiddenActions.ONE_SHOT:
        getAllPlayers().removeAllHealthPools()
    elif random == ForbiddenActions.STANDING:
        getAllPlayers().setMoveSpeed(200)


rule "1. 점프 - 감지":
    @Event eachPlayer
    @Condition random == ForbiddenActions.JUMP
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition isGameInProgress() == true
    
    eventPlayer.detectionMessage = "{0}님의 멋진 점프!".format(eventPlayer)
    detectFail()


rule "2. 좌클릭 - 감지":
    @Event eachPlayer
    @Condition random == ForbiddenActions.LEFT_CLICK
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 좌클 실화냐? 진짜 가슴이 웅장해진다".format(eventPlayer)
    detectFail()


rule "3. 우클릭 - 감지":
    @Event eachPlayer
    @Condition random == ForbiddenActions.RIGHT_CLICK
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 무대를 장악하는 우클릭!".format(eventPlayer)
    detectFail()


rule "4. 궁극기 - 감지":
    @Event eachPlayer
    @Condition random == ForbiddenActions.ULTIMATE
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 판을 만드는 궁극기!".format(eventPlayer)
    detectFail()


rule "5. E스킬 - 감지":
    @Event eachPlayer
    @Condition random == ForbiddenActions.ABILITY_2
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 화려한 E스킬!".format(eventPlayer)
    detectFail()


rule "6. 쉬프트 - 감지":
    @Event eachPlayer
    @Condition random == ForbiddenActions.ABILITY_1
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 멋진 쉬프트!".format(eventPlayer)
    detectFail()


rule "7. 전진 - 감지":
    @Event eachPlayer
    @Condition random == ForbiddenActions.MOVE_FORWARD
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.getThrottle() == vect(0, 0, 1)
    
    eventPlayer.detectionMessage = "{0}님의 당당한 전진!".format(eventPlayer)
    detectFail()


rule "9. 후진 - 감지":
    @Event eachPlayer
    @Condition random == ForbiddenActions.MOVE_BACKWARD
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.getThrottle() == vect(0, 0, -1)
    
    eventPlayer.detectionMessage = "{0}님의 졸렬한 후진!".format(eventPlayer)
    detectFail()


rule "10. 재장전 - 감지":
    @Event eachPlayer
    @Condition random == ForbiddenActions.RELOAD
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 환경을 생각하지 않은 재장전!".format(eventPlayer)
    detectFail()


rule "11. 점프 & 쉬프트 - 감지(점프)":
    @Event eachPlayer
    @Condition random == ForbiddenActions.JUMP_SHIFT
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 멋진 점프!".format(eventPlayer)
    detectFail()


rule "11. 점프 & 쉬프트 - 감지(쉬프트)":
    @Event eachPlayer
    @Condition random == ForbiddenActions.JUMP_SHIFT
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 화려한 쉬프트 사용!".format(eventPlayer)
    detectFail()


rule "12. 앞으로만 - 감지(후진)":
    @Event eachPlayer
    @Condition random == ForbiddenActions.ONLY_FORWARD
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.getThrottle() == vect(0, 0, -1)
    
    eventPlayer.detectionMessage = "{0}님의 졸렬한 후진!".format(eventPlayer)
    detectFail()


rule "12. 앞으로만 - 감지(왼쪽)":
    @Event eachPlayer
    @Condition random == ForbiddenActions.ONLY_FORWARD
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.getThrottle() == vect(1, 0, 0)
    
    eventPlayer.detectionMessage = "{0}님의 게같은 왼쪽걸음!".format(eventPlayer)
    detectFail()


rule "12. 앞으로만 - 감지(오른쪽)":
    @Event eachPlayer
    @Condition random == ForbiddenActions.ONLY_FORWARD
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.getThrottle() == vect(-1, 0, 0)
    
    eventPlayer.detectionMessage = "{0}님의 게같은 오른쪽걸음!".format(eventPlayer)
    detectFail()


rule "13. 궁극기 & 재장전 - 감지(궁극기)":
    @Event eachPlayer
    @Condition random == ForbiddenActions.ULTIMATE_RELOAD
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 판을 뒤엎는 궁극기!".format(eventPlayer)
    detectFail()


rule "13. 궁극기 & 재장전 - 감지(재장전)":
    @Event eachPlayer
    @Condition random == ForbiddenActions.ULTIMATE_RELOAD
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 환경을 생각하지 않은 재장전!".format(eventPlayer)
    detectFail()


rule "14. 좌클릭 & 우클릭 - 감지(좌클릭)":
    @Event eachPlayer
    @Condition random == ForbiddenActions.LEFT_RIGHT_CLICK
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 좌클 실화냐? 진짜 가슴이 웅장해진다".format(eventPlayer)
    detectFail()


rule "14. 좌클릭 & 우클릭 - 감지(우클릭)":
    @Event eachPlayer
    @Condition random == ForbiddenActions.LEFT_RIGHT_CLICK
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 무대를 장악하는 우클릭!".format(eventPlayer)
    detectFail()


rule "15. 근접공격 - 감지":
    @Event eachPlayer
    @Condition random == ForbiddenActions.MELEE
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false

    eventPlayer.detectionMessage = "{0}님의 타노스 기운을 담은 주먹질!".format(eventPlayer)
    meleeFail()


rule "16. E스킬 & 쉬프트 - 감지(쉬프트)":
    @Event eachPlayer
    @Condition random == ForbiddenActions.ABILITY_1_ABILITY_2
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 멋진 쉬프트!".format(eventPlayer)
    detectFail()


rule "16. E스킬 & 쉬프트 - 감지(E스킬)":
    @Event eachPlayer
    @Condition random == ForbiddenActions.ABILITY_1_ABILITY_2
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 화려한 E스킬!".format(eventPlayer)
    detectFail()


rule "18. 점프 & E스킬 - 감지(점프)":
    @Event eachPlayer
    @Condition random == ForbiddenActions.JUMP_ABILITY_2
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 멋진 점프!".format(eventPlayer)
    detectFail()


rule "18. 점프 & E스킬 - 감지(E스킬)":
    @Event eachPlayer
    @Condition random == ForbiddenActions.JUMP_ABILITY_2
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.isAlive() == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    
    eventPlayer.detectionMessage = "{0}님의 화려한 E스킬 사용!".format(eventPlayer)
    detectFail()


rule "19. 서있기 - 감지":
    @Event eachPlayer
    @Condition random == ForbiddenActions.STANDING
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false
    
    standingOrStillFail()


rule "20. 가만히 있기 - 감지":
    @Event eachPlayer
    @Condition random == ForbiddenActions.STAY_STILL
    @Condition someone_qudtlsed == false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isStanding() == true
    
    standingOrStillFail()


rule "리겜":
    @Condition isMatchComplete() == true
    
    wait(3)
    restartMatch()


rule "워크샵 셋팅":
    @Event eachPlayer
    
    kickcount = createWorkshopSettingInt("설정", "자동강퇴 횟수", 4, 1, 10)


rule "실수한 횟수 표시1":
    @Event eachPlayer
    @Condition eventPlayer.qudtls_count >= 1
    
    createInWorldText(getAllPlayers(), "실수 {}번\n\n".format(eventPlayer.qudtls_count), eventPlayer, 1.3, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED)


rule "강퇴까지 3회 남음 - 전체 알림":
    @Event eachPlayer
    @Condition kickcount - eventPlayer.qudtls_count == 3
    @Condition eventPlayer.qudtls_count >= 1
    
    topMessage = "{0}님의 {1}번째 실수! 와 쉽지않네..".format(eventPlayer, eventPlayer.qudtls_count)


rule "강퇴까지 2회 남음 - 전체 알림":
    @Event eachPlayer
    @Condition kickcount - eventPlayer.qudtls_count == 2
    @Condition eventPlayer.qudtls_count >= 1
    
    topMessage = "{0}님의 {1}번째 실수! 능지 ㄱㅊ??".format(eventPlayer, eventPlayer.qudtls_count)


rule "강퇴까지 1회 남음 - 전체 알림":
    @Event eachPlayer
    @Condition kickcount - eventPlayer.qudtls_count == 1
    @Condition eventPlayer.qudtls_count >= 1
    
    topMessage = "{0}님의 {1}번째(마지막) 실수! 한글어 쓰시나요?".format(eventPlayer, eventPlayer.qudtls_count)


rule "강퇴까지 1회 남음 - 개인 경고":
    @Event eachPlayer
    @Condition kickcount - eventPlayer.qudtls_count == 1
    @Condition eventPlayer.qudtls_count >= 1
    
    smallMessage(eventPlayer, "한번만 더해봐라")


rule "강퇴 기준 도달 - 플레이어 제거":
    @Event eachPlayer
    @Condition kickcount - eventPlayer.qudtls_count <= 0
    @Condition eventPlayer.qudtls_count >= 1
    
    smallMessage(eventPlayer, "나가 이새끼야")
    topMessage = "{0} 나가.".format(eventPlayer)
    wait(3)
    eventPlayer.removeFromGame()


rule "강퇴 시 HUD 표시":
    @Event eachPlayer
    @Condition kickcount - eventPlayer.qudtls_count <= 0
    @Condition eventPlayer.qudtls_count >= 1

    hudHeader(getAllPlayers(), f"{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n{eventPlayer} ㅂ12신\n", HudPosition.TOP, 1, Color.LIGHT_RED)
    banHud = getLastCreatedText()
    wait(5)
    destroyHudText(banHud)


rule "디버그: 더미생성":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition len(getAllPlayers()) == 1
    createDummy(Hero.KIRIKO, Team.2, -1,eventPlayer)


rule "제작자 사기 모드":
    @Event eachPlayer
    @Condition "{}".format(eventPlayer) == "WIHS27"
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.MELEE)

    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 60)
    eventPlayer.setDamageDealt(500)
    smallMessage(text="제작자 사기맵")
