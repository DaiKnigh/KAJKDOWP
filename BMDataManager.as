package net.battleMechsMulti.managers
{
   import com.milkmangames.nativeextensions.GAnalytics;
   import com.milkmangames.nativeextensions.RateBox;
   import com.milkmangames.nativeextensions.events.RateBoxEvent;
   import flash.desktop.NativeApplication;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.InvokeEvent;
   import flash.events.ProgressEvent;
   import flash.external.ExternalInterface;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.net.LocalConnection;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.system.fscommand;
   import flash.utils.getDefinitionByName;
   import net.battleMechsMulti.events.AndroidStoreEvent;
   import net.battleMechsMulti.mobiles.BMAvatarImage;
   import net.battleMechsMulti.mobiles.BMBaseClass;
   import net.battleMechsMulti.mobiles.BMBoostData;
   import net.battleMechsMulti.mobiles.BMChatMessageData;
   import net.battleMechsMulti.mobiles.BMFriendshipData;
   import net.battleMechsMulti.mobiles.BMItem;
   import net.battleMechsMulti.mobiles.BMItemData;
   import net.battleMechsMulti.mobiles.BMMechStructure;
   import net.battleMechsMulti.mobiles.BMMechView;
   import net.battleMechsMulti.mobiles.BMPlayerData;
   import net.battleMechsMulti.mobiles.BMPlayerItemData;
   import net.battleMechsMulti.mobiles.BMPlayerProfile;
   import net.battleMechsMulti.mobiles.BMReplayAction;
   import net.battleMechsMulti.mobiles.BMReplayData;
   import net.battleMechsMulti.mobiles.BMReplayStatus;
   import net.battleMechsMulti.mobiles.BMTileListItem;
   import net.tacticsoft.global.BMMClientFlashVars;
   import net.tacticsoft.utils.DetectedSettings;
   
   public class BMDataManager extends BMBaseClass
   {
      private static var _instance:BMDataManager;
      
      private static var _allowInstantiation:Boolean;
      
      private static const GOOGLE_ANALYTICS_TRACKING_ID:String = "UA-1665200-10";
      
      public static const ONESIGNAL_APP_ID:String = "50bdd4ea-589b-4ce2-8834-b1b182d8addd";
      
      public static const GCM_PROJECT_NUMBER:String = "542358169198";
      
      public var clientVersion:String;
      
      public var flashVars:BMMClientFlashVars;
      
      public var bmmSessionSO:SharedObject;
      
      public var useNoConnectionMode:Boolean = false;
      
      public var firstSocketConnectionEstablished:Boolean = false;
      
      public var noConnectionModeActive:Boolean = false;
      
      public var guestSharedObject:SharedObject;
      
      public var guestSharedObjectExists:Boolean = false;
      
      public var guestRegistrationActive:Boolean = false;
      
      public var generalSharedObject:SharedObject;
      
      public var generalSharedObjectExists:Boolean = false;
      
      public var sessionID:String = "";
      
      public var uniqueID:String = "";
      
      public var userName:String = "";
      
      public var playerbaseID:uint = 0;
      
      public var userID:Number = 0;
      
      public var userbase:uint = GlobalAccess.userbase;
      
      public var clientRunningLocally:Boolean;
      
      public var localTestForIOS:Boolean = false;
      
      public var lastLoginFromFacebook:Boolean = false;
      
      public var login_userTriedToLogin:Boolean = false;
      
      public var alreadySeenPlayingOnDevAlert:* = false;
      
      public var runAsMobile:Boolean = false;
      
      public var runOnDev:Boolean = false;
      
      public var advertisingCampaignID:Number = 0;
      
      public var weightMax:uint = 2000;
      
      public var ladderProgressBase:uint;
      
      public var ladderRankMax:uint;
      
      public var campaignBattleType:uint = 1;
      
      public var battleMaxMechs:uint = 3;
      
      public var inventoryMaxMechs:uint = 3;
      
      public var missionUpgrade_hpRatio:uint = 100;
      
      public var missionUpgrade_energyRatio:uint = 25;
      
      public var missionUpgrade_heatRatio:uint = 25;
      
      public var missionUpgrade_ammoRatio:uint = 50;
      
      public var missionBuy1HardTokensCost:uint = 50;
      
      public var missionBuy6HardTokensCost:uint = 100;
      
      public var missionBuy1InsaneTokensCost:uint = 100;
      
      public var missionBuy6InsaneTokensCost:uint = 150;
      
      public var mission_playerMechFrame:String = "";
      
      public var mission_battleEnded:Boolean = false;
      
      public var mission_battleEnded_playerWon:Boolean = false;
      
      public var mission_battleEnded_hp:uint;
      
      public var mission_battleEnded_bullets:uint;
      
      public var mission_battleEnded_rockets:uint;
      
      public var mission_battleRow:uint;
      
      public var mission_battleColumn:uint;
      
      public var mission_battleEnemyType:String;
      
      public var mission_destroyingMapObjectActive:Boolean;
      
      public var mission_destroyingMapObjectRow:uint;
      
      public var mission_destroyingMapObjectColumn:uint;
      
      public var mission_destroyingMapObjectFrameCounter:uint;
      
      public var missionWorldMap_missionCompletedSlot:Number = -1;
      
      public var mechEquipment_playerItemIDsUpgraded:Object = new Object();
      
      public var welcomeScreenInitialized:Boolean = false;
      
      public var register_termsOfUseChecked:Boolean = false;
      
      public var tutorialEnabled:Boolean = false;
      
      public var supersonic_hasCompletedListener:Boolean = false;
      
      public var supersonic_mobile_afterWins:uint = 0;
      
      public var supersonic_mobile_SPMP:uint = 0;
      
      public var packages_markSpecificPackageID:uint = 0;
      
      public var packages_markPremiumFromBattle:Boolean = false;
      
      public var packages_markPremiumFromTutorial:Boolean = false;
      
      public var packages_markItemBoxFromTutorial:Boolean = false;
      
      public var packages_markFreeGoldPackageFromHanger:Boolean = false;
      
      public var packages_markGoldPackage:Boolean = false;
      
      public var packages_markItemsBox:Boolean = false;
      
      public var battle_replayData:Object;
      
      public var battle_floorBuffsData:Object;
      
      public var battle_goToChatAfterBattle:Boolean = false;
      
      public var battle_inviteToClanAfterBattle:Boolean = false;
      
      public var battle_backgroundID:Number = 1;
      
      public var onlinePlayersInspect_playerID:Number = 0;
      
      public var chat_initialized:Boolean = false;
      
      public var chat_messages_winningWall:Array = new Array();
      
      public var chat_pendingClanMessages:uint = 0;
      
      public var chat_lastChatChannel:uint = 0;
      
      public var chat_channels:Array = new Array();
      
      public var chat_channelsServer:Array = new Array();
      
      public var chat_channelsAdmins:Array = new Array();
      
      public var chat_channelsClan:Array = new Array();
      
      public var chat_channelsClanMembers:Array = new Array();
      
      public var chat_channelsRegular:Array = new Array();
      
      public var chat_log:Object = new Object();
      
      public var chat_winningWallTexts:Array = new Array();
      
      public var chat_differentUserConnected:Boolean = true;
      
      public var chat_playersData:Object = new Object();
      
      public var chat_totalPlayersInLobby:uint = 0;
      
      public var chat_goToClanChat:Boolean = false;
      
      public var chat_goToSpecificPlayerChatPlayerID:Number = 0;
      
      public var chat_goToInspectPlayerID:Number = 0;
      
      public var chat_goToChatAfterBattleUserID:Number = 0;
      
      public var chat_inviteToClanAfterBattleUserID:Number = 0;
      
      public var chat_addPlayerDataAfterBattleName:String;
      
      public var chat_addPlayerDataAfterBattleClanID:Number;
      
      public var chat_addPlayerDataAfterBattleLevel:uint;
      
      public var chat_addPlayerDataAfterBattleGeo:String;
      
      public var chat_addPlayerDataAfterBattleLadderProgress:uint;
      
      public var chat_sendMessageCooldown:uint = 0;
      
      public var replays_loaded:Boolean = false;
      
      public var topBar_levelUpInProgress:Boolean = false;
      
      public var hanger_newItemsForDisplay:Array = new Array();
      
      public var rankingList_gettingBackToRankingListFromAReplay:Boolean = false;
      
      public var inspectPlayer_playerID:Number = 0;
      
      public var inspectPlayer_activeMechIDs:Array;
      
      public var inspectPlayer_currentMechSlot:Number = 0;
      
      public var inspectPlayer_currentMechID:Number;
      
      public var inspectPlayer_selectedTab:String = "";
      
      public var inspectPlayer_lastTab:String = "";
      
      public var inspectPlayer_outsideRankingList:Boolean;
      
      public var inspectPlayer_name:String;
      
      public var inspectPlayer_level:Number;
      
      public var inspectPlayer_ladderProgress:Number;
      
      public var inspectPlayer_clanID:Number;
      
      public var inspectPlayer_goToTab:String;
      
      public var logOutClicked:Boolean = false;
      
      public var useClientIsAlive:Boolean = false;
      
      public var useChatBlocks:Boolean = false;
      
      public var chatBlocksRemain:Number = 6;
      
      public var chatBlocksPlayerIDs:Object = new Object();
      
      public var iAmBannedFromChat:Boolean = false;
      
      public var clanWinsGiveReward:Boolean = false;
      
      public var clanWinsRewardType:String;
      
      public var clanWinsRewardValue:Number;
      
      public var clanWinsWinsRequired:Number;
      
      public var showMythicalsStats:Boolean = true;
      
      public var runningFromSite_yepi:Boolean = false;
      
      public var weeklyTopClanRewards:Array;
      
      public var newItemsCreated:Array = new Array();
      
      public var inspectPlayersStatistics:Object = new Object();
      
      public var inspectPlayersClan:Object = new Object();
      
      public var useChatRank1Channels:Boolean = false;
      
      public var useMissionWorldMapInterface:Boolean = false;
      
      public var useMissionWorldMapInterface_web:Boolean = false;
      
      public var use2V2And3V3Battles:Boolean = false;
      
      public var levelRequired3V3:uint = 20;
      
      public var useMultipleMechsKitsFix:Boolean = false;
      
      public var destroyMechDamageAddon:Number = 10;
      
      public var multipleMechsPythonSupport:Boolean = false;
      
      public var itemsDB:Object;
      
      public var itemTypesDB:Array;
      
      public var itemTypesReverseDB:Array;
      
      public var shopItemTypesDB:Array;
      
      public var shopItemTypesReverseDB:Array;
      
      public var shopItemTypesSourceDB:Array;
      
      public var animationDB:Object;
      
      public var replayActionsDB:Object;
      
      public var infoTextDB:Object;
      
      public var friendsDB:Object;
      
      public var itemTypeSortDB:Object;
      
      public var powerLevelsDB_regular:Array;
      
      public var powerLevelsDB_special:Array;
      
      public var subTypeDB:Object;
      
      public var subTypeDB_myth:Object;
      
      public var subTypeDB_combined:Object;
      
      public var subTypeOrderDB:Array;
      
      public var subTypeOrderDB_myth:Array;
      
      public var subTypeOrderDB_combined:Array;
      
      public var subTypeOriginDB:Object;
      
      public var subTypeOriginDB_myth:Object;
      
      public var subTypeOriginDB_combined:Object;
      
      public var replaysDB:Object;
      
      public var loginReplaysDB:Object;
      
      public var levelUpDB:Array;
      
      public var itemTypeSourceDB:Array;
      
      public var colorsDB:Array;
      
      public var boostsDB:Array;
      
      public var battleInterfaceToolTipDB:Object;
      
      public var techDB:Object;
      
      public var tipsDB:Array;
      
      public var musicDB:Array;
      
      public var newsDB:Object;
      
      public var achievementsDB:Object;
      
      public var achievementsSortedDB:Object;
      
      public var campaignMissionsDB:Object;
      
      public var campaignMissionsSortedDB:Object;
      
      public var campaignMissions_maxKits:uint = 0;
      
      public var campaignMissions_maxWinsVSComputer:uint = 0;
      
      public var helpDB:Array;
      
      public var itemsMaxLevelsDB:Object;
      
      public var tutorialLevelsDB:Array;
      
      public var wheelsDB:Object;
      
      public var propellersDB:Object;
      
      public var applePackages:Array;
      
      public var androidPackages:Array;
      
      public var fakePackages:Array;
      
      public var subTypeItemsAmount:Object;
      
      public var subTypeItemsAmount_myth:Object;
      
      private var wordFilterDB:Array;
      
      private var ladderRankIconsDB:Array;
      
      public var equipmentUnlockDB:Object;
      
      public var equipmentUnlockByLevelDB:Array;
      
      public var missionUpgradesDB:Object;
      
      public var missionUpgradesReverseDB:Object;
      
      public var missionMapObjectDB:Object;
      
      private var computerNamesDB:Array;
      
      public var missionsDB:Array;
      
      public var missionsItemBoxSlots:Object = new Object();
      
      public var endGame1Slot:uint;
      
      public var endGame2Slot:uint;
      
      public var endGame3Slot:uint;
      
      public var endGame4Slot:uint;
      
      public var endGame5Slot:uint;
      
      private var missionLayouts_tutorial:Array;
      
      private var missionLayouts_regular:Array;
      
      public var rankingList_allTime:Object;
      
      public var rankingList_weekly:Object;
      
      public var rankingList_online:Object;
      
      public var rankingList_clansOnlyMode:Boolean = false;
      
      public var playersGeneralData:Object = new Object();
      
      public var inspectPlayerData:Object;
      
      public var itemsDB_online:Object;
      
      private var itemsDB_local:Object;
      
      public var replaysDB_online:Object = new Object();
      
      public var replaysDB_offline:Object = new Object();
      
      public var replaysDB_inspect:Object = new Object();
      
      public var player1PlayerID:Number;
      
      public var player2PlayerID:Number;
      
      public var playersData:Array = new Array();
      
      public var playingVSComputer:Boolean = false;
      
      public var battleType:String = "none";
      
      public var battleSubType:String = "";
      
      public var battleMechsPerPlayer:uint = 0;
      
      public var campaignBattleDifficulty:Number;
      
      public var campaignBattleID:Number;
      
      public var totalOfflineReplays:Number;
      
      public var maxEquipment:Object;
      
      public var gameType:String = "none";
      
      public var gameSubType:String = "";
      
      public var battle_inBattleInvitation:Boolean = false;
      
      public var battle_clientInverted:Boolean = false;
      
      public var battle_syncData:Object = new Object();
      
      public var starterPack_goBackToScreen:String = "";
      
      public var starterPack_displayAfterOnlineBattleCounter:uint = 3;
      
      public var starterPack_displayAfterSinglePlayerMissionCounter:uint = 3;
      
      public var createComputerMechs:Boolean = true;
      
      public var useExtraMusicTracksForMobile:Boolean = false;
      
      public var usePersonaly:Boolean = false;
      
      public var personalyGeos:Array = new Array();
      
      public var player1Profile:BMPlayerProfile;
      
      public var player2Profile:BMPlayerProfile;
      
      public var player3Profile:BMPlayerProfile;
      
      public var player4Profile:BMPlayerProfile;
      
      public var player5Profile:BMPlayerProfile;
      
      public var player6Profile:BMPlayerProfile;
      
      public var player7Profile:BMPlayerProfile;
      
      public var player8Profile:BMPlayerProfile;
      
      public var player9Profile:BMPlayerProfile;
      
      public var playerData1Inventory:Object;
      
      public var playerData2Inventory:Object;
      
      public var playerData3Inventory:Object;
      
      public var playerData4Inventory:Object;
      
      public var playerData5Inventory:Object;
      
      public var playerData6Inventory:Object;
      
      public var playerData7Inventory:Object;
      
      public var playerData8Inventory:Object;
      
      public var playerData9Inventory:Object;
      
      public var playerData1MechStructure1:BMMechStructure;
      
      public var playerData1MechStructure2:BMMechStructure;
      
      public var playerData1MechStructure3:BMMechStructure;
      
      public var playerData2MechStructure1:BMMechStructure;
      
      public var playerData2MechStructure2:BMMechStructure;
      
      public var playerData2MechStructure3:BMMechStructure;
      
      public var playerData3MechStructure1:BMMechStructure;
      
      public var playerData3MechStructure2:BMMechStructure;
      
      public var playerData3MechStructure3:BMMechStructure;
      
      public var playerData4MechStructure1:BMMechStructure;
      
      public var playerData4MechStructure2:BMMechStructure;
      
      public var playerData4MechStructure3:BMMechStructure;
      
      public var playerData5MechStructure1:BMMechStructure;
      
      public var playerData5MechStructure2:BMMechStructure;
      
      public var playerData5MechStructure3:BMMechStructure;
      
      public var playerData6MechStructure1:BMMechStructure;
      
      public var playerData6MechStructure2:BMMechStructure;
      
      public var playerData6MechStructure3:BMMechStructure;
      
      public var playerData7MechStructure1:BMMechStructure;
      
      public var playerData7MechStructure2:BMMechStructure;
      
      public var playerData7MechStructure3:BMMechStructure;
      
      public var playerData8MechStructure1:BMMechStructure;
      
      public var playerData8MechStructure2:BMMechStructure;
      
      public var playerData8MechStructure3:BMMechStructure;
      
      public var playerData9MechStructure1:BMMechStructure;
      
      public var playerData9MechStructure2:BMMechStructure;
      
      public var playerData9MechStructure3:BMMechStructure;
      
      public var player1playerItemIDCounter:Number;
      
      public var player2playerItemIDCounter:Number;
      
      public var player3playerItemIDCounter:Number;
      
      public var player4playerItemIDCounter:Number;
      
      public var player5playerItemIDCounter:Number;
      
      public var player6playerItemIDCounter:Number;
      
      public var player7playerItemIDCounter:Number;
      
      public var player8playerItemIDCounter:Number;
      
      public var player9playerItemIDCounter:Number;
      
      public var battleData:Object;
      
      public var battleLaunchScreen:String;
      
      public var savingReplay:Boolean;
      
      public var replaySaveData:Object;
      
      public var newXP:Number;
      
      public var newGold:Number;
      
      public var cheatWeaponDamage:Number = 0;
      
      public var cheatWeaponDamageComputer:Number = 0;
      
      public var cheatWeaponResistance:Number = 0;
      
      public var cheatExtraHeat:Number = 0;
      
      public var usersOnline:Object = new Object();
      
      public var usersInBattle_ladder:Number = 0;
      
      public var usersInBattle_invitation:Number = 0;
      
      public var usersInBattle_computer:Number = 0;
      
      public var usersSearching:Number = 0;
      
      public var userDeclinedRatingForThisSession:Boolean = false;
      
      public var searchForBattleLevelChangeSeconds:Number = 0;
      
      public var battleInvitations:Object = new Object();
      
      public var clanInvitations:Object = new Object();
      
      public var battleInvitationsEnabled:Boolean = true;
      
      public var breathingEffect:Boolean = true;
      
      public var particleEffects:Boolean = false;
      
      public var movieClipParticleEffects:Boolean = true;
      
      public var movieClipParticleEffectsLevel:Number = 1;
      
      public var movieClipParticleEffectsRatio:Number = 0.25;
      
      public var computerBattleID:Number = 0;
      
      public var tryToAddFriend_username:String;
      
      public var currentTime:Number = 0;
      
      public var premiumAccountTime:Number = 0;
      
      public var lastBattleCreditAddon:Number = 0;
      
      public var specialOffersResetTime:Number = 0;
      
      public var serverTimeDifferece:Number = 0;
      
      public var turnsForQuitPenalty:Number = 0;
      
      public var advancedMatchmakingBlockLevel:Number = 20;
      
      public var randomItemsAmount:Number = 5;
      
      public var useNoMechBreakApart:Boolean = false;
      
      public var useCraftMythicals:Boolean = true;
      
      public var craftMythicals_level:uint = 20;
      
      public var craftPower_torso:uint = 500;
      
      public var craftPower_leg:uint = 500;
      
      public var craftPower_sideWeapon:uint = 500;
      
      public var craftPower_topWeapon:uint = 500;
      
      public var craftPower_special:uint = 500;
      
      public var craftPower_module:uint = 500;
      
      public var dailyLoginStreakData:Array;
      
      public var dailyLoginStreakBonus:Object = new Object();
      
      public var dailyLoginStreakBonusMythical:Boolean = false;
      
      public var battleCreditsMax:uint = 0;
      
      public var battleCreditsMax_supporters:uint = 0;
      
      public var useBattleCreditsPriceIncrease:Boolean = false;
      
      public var nextBattleCreditsPriceReset:Number = 0;
      
      public var battleCreditsPriceSecondsToReset:Number = 0;
      
      public var battleCreditsPriceIncrease:Number = 0;
      
      public var secondsForNewBattleCredit:Number = 1200;
      
      public var secondsForNewBattleCredit_supporters:Number = 1200;
      
      public var battleCreditX1CostGold:uint = 3000;
      
      public var battleCreditX1CostGold_supporters:uint = 3000;
      
      public var battleCreditX6CostGold:uint = 15000;
      
      public var battleCreditX6CostGold_supporters:uint = 15000;
      
      public var useBattleCreditsCap:Boolean = false;
      
      public var battleCreditsCap:uint = 99;
      
      public var clanMaxMembers:uint = 6;
      
      public var createClanCost:Number = 5000;
      
      public var clansRankingList:Object;
      
      public var clansAroundMyLadderProgress:Object;
      
      public var useNameChange:Boolean = false;
      
      public var nameChangeCostTokensBase:uint = 0;
      
      public var nameChangeCostTokensAddon:uint = 0;
      
      public var bonusTokensPerLevelUp:uint = 10;
      
      public var bonusTokensForLevel3:uint = 100;
      
      public var useLanguages:Boolean = false;
      
      public var languageFontType:Array = new Array(0,1,1,2,1,1,2,2,2,2,2);
      
      public var replayInspectedPlayerIDs:Array = new Array();
      
      public var allowNameChangeAfterRegister:Boolean = false;
      
      public var setLastNewsIDForANewUser:Boolean = false;
      
      public var skipChallenge:Boolean = false;
      
      public var itemsBoxShop:Boolean = true;
      
      public var languageID:Number = 1;
      
      public var clientLastLanguageID:Number = 1;
      
      public var nextWeeklyReset:String = "";
      
      public var specialUser:Boolean = false;
      
      public var kitsMax:uint = 2;
      
      public var modulesMax:uint = 7;
      
      public var useRateBox:Boolean = false;
      
      public var rateBoxRankRequired:Number = 5;
      
      private var _rateBoxInitialized:Boolean = false;
      
      private var _createSpecificMechMaxMythicals:Number;
      
      public var useGiftSystem:Boolean = false;
      
      public var giftKeyGold:Number = 0;
      
      public var giftKeysUseMaxLevel:uint = 0;
      
      public var giftKeysBonus1Level:uint = 0;
      
      public var giftKeysBonus2Level:uint = 0;
      
      public var giftKeysBonus3Level:uint = 0;
      
      public var giftKeysBonus1Gold:uint = 0;
      
      public var giftKeysBonus2Gold:uint = 0;
      
      public var useSilverBoxesForGifts:Boolean = false;
      
      public var avatarLink:String = "";
      
      public var callingRankingListEnabled:Boolean = true;
      
      public var blockedBattleInvitations:Object = new Object();
      
      public var tutorialSkipped:Boolean = false;
      
      public var weeklySoloWinners:Object = new Object();
      
      public var weeklyClanWinners:Object = new Object();
      
      public var weeklyTopClans:Object = new Object();
      
      public var chatDefaultLanguageID:Number = 0;
      
      public var levelForExpandedItemBox:uint = 15;
      
      public var resetRankingListTimer:Boolean = false;
      
      public var dailyBonusOptions:Array = new Array();
      
      public var dungeonMechStructures:* = new Array();
      
      public var dungeonDifficulty:uint = 0;
      
      public var allowSlowCPUMode:Boolean = true;
      
      public var slowCPUModeActivateFPS:Number = 24;
      
      public var slowCPUModeDeactivateFPS:Number = 27;
      
      public var slowCPUMode:Boolean = false;
      
      public var generalSpeedRatio:Number = 1;
      
      public var BASE_REWARD:* = 4000;
      
      public var rewardSPWinXP:uint = 50;
      
      public var rewardMPWinGold:uint = 2000;
      
      public var rewardMPWinXP:uint = 300;
      
      public var rewardSPLoseGold:uint = 50;
      
      public var rewardSPLoseXP:uint = 25;
      
      public var rewardMPLoseGold:uint = 250;
      
      public var rewardMPLoseXP:uint = 25;
      
      public var floorBuff_damageAddon:Number = 100;
      
      public var floorBuff_energyRegenerationAddon:Number = 100;
      
      public var floorBuff_energyDamageAddon:Number = 100;
      
      public var floorBuff_heatCoolingAddon:Number = 100;
      
      public var floorBuff_heatDamageAddon:Number = 100;
      
      public var useItemComparisonOnInventoryItemClick:Boolean = false;
      
      public var useItemComparisonOnMechItemRollOver:Boolean = true;
      
      public var activeBoosts:Array = new Array();
      
      public var activeBoostsMobile:Array = new Array();
      
      public var sendTokens_allow:Boolean = false;
      
      public var sendTokens_tokensSpentRequired:Number = 0;
      
      public var sendTokens_daysFromFirstPaymentRequired:Number = 0;
      
      public var sendTokens_minTokensToSend:uint = 0;
      
      public var useStarterPacks:Boolean = false;
      
      public var getTokens_displayAfterOnlineBattleCounter:uint = 0;
      
      public var getTokens_displayAfterSinglePlayerMissionCounter:uint = 0;
      
      public var battle_gamePaused:Boolean = false;
      
      private var avatarImages:Object = new Object();
      
      private var modules_energy:Array = new Array();
      
      private var modules_heat:Array = new Array();
      
      private var modules_bullets:Array = new Array();
      
      private var modules_rockets:Array = new Array();
      
      private var modules_bulletsAndRockets:Array = new Array();
      
      private var modules_resistance:Array = new Array();
      
      private var modules_armor:Array = new Array();
      
      private var kits_energy:Array = new Array();
      
      private var kits_heat:Array = new Array();
      
      private var kits_bullets:Array = new Array();
      
      private var kits_rockets:Array = new Array();
      
      private var kits_resistance:Array = new Array();
      
      private var kits_repair:Array = new Array();
      
      private var highestRepairKitLevel:Number = 0;
      
      private var highestEnergyKitLevel:Number = 0;
      
      private var highestCoolingKitLevel:Number = 0;
      
      private var highestBulletsKitLevel:Number = 0;
      
      private var highestRocketsKitLevel:Number = 0;
      
      private var ladderRankByProgress:Array;
      
      private var ladderProgressMaxByRank:Array;
      
      private var itemIDsForbiddenForPC:Object;
      
      public var ladderRanksPerStar:uint = 2;
      
      public const MAX_SIDE_WEAPONS:Number = 4;
      
      public const MAX_TOP_WEAPONS:Number = 2;
      
      public const MAX_DRONES:Number = 1;
      
      public const MAX_TELEPORTS:Number = 1;
      
      public const MAX_SHIELDS:Number = 1;
      
      public const MAX_CHARGES:Number = 1;
      
      public const MAX_HARPOONS:Number = 1;
      
      public const MAX_KITS:Number = 2;
      
      public const MAX_MODULES:Number = 7;
      
      public const MAX_TAUNTS:Number = 6;
      
      public const SELL_ORIGINAL_VALUE_RATIO:Number = 0.25;
      
      public const SHOP_TILE_LIST_ITEM_SIZE:Number = 84;
      
      public const SHOP_TILE_LIST_ITEM_SIZE_MOBILE:Number = 92;
      
      public const STARTER_PACK_SIZE:uint = 70;
      
      public const NEWS_TILE_LIST_ITEM_SIZE:uint = 140;
      
      public const REWARD_TILE_LIST_ITEM_SIZE:uint = 56;
      
      public const REWARD_TILE_LIST_ITEM_SIZE_MOBILE:uint = 56;
      
      public const INVENTORY_TILE_LIST_ROWS:Number = 5;
      
      public const INVENTORY_TILE_LIST_COLUMNS:Number = 4;
      
      public const INVENTORY_TILE_LIST_ITEM_SIZE:Number = 69;
      
      public const INVENTORY_TILE_LIST_ROWS_MOBILE:Number = 5;
      
      public const INVENTORY_TILE_LIST_COLUMNS_MOBILE:Number = 3;
      
      public const INVENTORY_TILE_LIST_ITEM_SIZE_MOBILE:Number = 75;
      
      public const DRAG_TILE_LIST_ITEM_SIZE:Number = 80;
      
      public const EQUIPMENT_TILE_LIST_ITEM_SIZE:Number = 50;
      
      public const OFFLINE_PLAYER_ID:Number = 1;
      
      public const OFFLINE_OPPONENT_ID:Number = 2;
      
      public const ONLINE_PLAYER_ID:Number = 3;
      
      public const ONLINE_OPPONENT_ID:Number = 4;
      
      public const REPLAY_PLAYER1_ID:Number = 5;
      
      public const REPLAY_PLAYER2_ID:Number = 6;
      
      public const INSPECT_PLAYER_ID:Number = 7;
      
      public const SHOW_PLAYER1_ID:Number = 8;
      
      public const SHOW_PLAYER2_ID:Number = 9;
      
      public const TUTORIAL_TORSO_ID:Number = 23;
      
      public const TUTORIAL_LEG_ID:Number = 2;
      
      public const TUTORIAL_WEAPON_ID:Number = 3;
      
      public const TUTORIAL_BUY_TORSO1_ID:Number = 153;
      
      public const TUTORIAL_BUY_TORSO2_ID:Number = 155;
      
      public const TUTORIAL_BUY_SIDE_WEAPON1_ID:Number = 197;
      
      public const TUTORIAL_BUY_SIDE_WEAPON2_ID:Number = 161;
      
      public const TUTORIAL_BUY_SIDE_WEAPON3_ID:Number = 176;
      
      public const TUTORIAL_BUY_SIDE_WEAPON4_ID:Number = 162;
      
      public const TUTORIAL_BUY_TOP_WEAPON1_ID:Number = 708;
      
      public const TUTORIAL_BUY_KIT_ID:Number = 17;
      
      public const TUTORIAL_BUY_MODULE_ID:Number = 56;
      
      public const TUTORIAL_BOX_LEG_ID:Number = 35;
      
      public const TUTORIAL_BOX_DRONE_ID:Number = 1;
      
      public const TUTORIAL_BOX_MODULE_ID:Number = 25;
      
      public const TUTORIAL_BATTLES:Number = 3;
      
      public const MENU_TUTORIAL_BATTLES:Number = 4;
      
      public const WINS_VS_COMPUTER_REQUIRED_FOR_LADDER:Number = 2;
      
      public const STAGE_WIDTH:Number = 800;
      
      public const STAGE_HEIGHT:Number = 480;
      
      public const RARITY_COMMON:Number = 0;
      
      public const RARITY_RARE:Number = 1;
      
      public const RARITY_EPIC:Number = 2;
      
      public const RARITY_LEGENDARY:Number = 3;
      
      public const RARITY_MYTHICAL:Number = 4;
      
      public const LEVEL_MAX:Number = 30;
      
      public const CHAT_LANGUAGES:uint = 6;
      
      public const CHAT_CLAN_CHANNEL_PLAYER_ID:uint = 10;
      
      public const CHAT_ONLINE_PLAYER_LADDER_PROGRESS_DIFFERENCE:uint = 10;
      
      public const WINNING_WALL_MAX_MESSAGES:Number = 6;
      
      public var GUEST_MAX_ITEMS:Number = 2147483647;
      
      public var GUEST_MAX_LEVEL:Number = 30;
      
      public var GUEST_MAX_GOLD:Number = 2147483647;
      
      public var BAD_AVERAGE_FPS:Number = 10;
      
      public var MULTIPLAYER_UNLOCK_LEVEL:Number = 3;
      
      public var CREDITS_ITEMS_BOX_BOOST_ID:Number = 9;
      
      public var DISPLAY_GET_TOKENS_COUNTER_MAX:uint = 6;
      
      public const DISPLAY_STARTER_PACK_COUNTER_MAX:uint = 3;
      
      private var FREE_PACKAGES_DEFAULT_STRING:String = "8,9";
      
      public var TUTORIAL_LEVEL_START_IN_HANGER:Number;
      
      public var TUTORIAL_LEVEL_MENU_PACKAGES_SHOP:Number;
      
      public var TUTORIAL_LEVEL_PREMIUM_ACCOUNT:Number;
      
      public var TUTORIAL_LEVEL_ITEMS_BOX:Number;
      
      public var TUTORIAL_LEVEL_FUSION:Number;
      
      public var TUTORIAL_LEVEL_LAST_FOR_WORKSHOP:Number;
      
      public var TUTORIAL_LEVEL_HANGER1:Number;
      
      public var TUTORIAL_LEVEL_HANGER2:Number;
      
      public var TUTORIAL_LEVEL_HANGER3:Number;
      
      public var TUTORIAL_LEVEL_HANGER4:Number;
      
      public var TUTORIAL_LEVEL_HANGER5:Number;
      
      public var TUTORIAL_LEVEL_GO_TO_HANGER_FROM_BATTLE:Number;
      
      public var TUTORIAL_LEVEL_GO_TO_BATTLE_FROM_HANGER:Number;
      
      public var TUTORIAL_LEVEL_GO_TO_WORLD_MAP_FROM_HANGER:Number;
      
      public var TUTORIAL_LEVEL_MENU_UNLOCK_ALL_BUTTONS:Number;
      
      public var SUB_TYPE_SIDE_WEAPON_PHYSICAL:uint;
      
      public var SUB_TYPE_TOP_WEAPON_ELECTRIC:uint;
      
      public var SUB_TYPE_MODULE_BULLETS_ROCKETS:uint;
      
      public var SECOND_MECH_UNLOCK_LEVEL:uint = 99;
      
      public const COLOR_FRIEND:String = "33CC00";
      
      public const COLOR_REGULAR_PLAYER:String = "FF9900";
      
      public const COLOR_SELF:String = "0099FF";
      
      public const COLOR_TIP:String = "FFCC66";
      
      public const COLOR_ADMIN:String = "993399";
      
      public const COLOR_SERVER:String = "FFCC00";
      
      public const COLOR_PRIVATE_MESSAGE:String = "FF6699";
      
      public const COLOR_CLAN_MESSAGE:String = "669966";
      
      public const COLOR_TEXT:String = "DDDDDD";
      
      public const COLOR_BATTLE_INVITATION:String = "FFCC00";
      
      public const COLOR_RARE_ITEM:String = "0099FF";
      
      public const COLOR_EPIC_ITEM:String = "9C3399";
      
      public const COLOR_LEGENDARY_ITEM:String = "FF9900";
      
      public const COLOR_MYTHICAL_ITEM:String = "FF6633";
      
      private const COLOR_MYTHICAL_ITEM_DARK:String = "3A0B00";
      
      public const COLOR_GOLD:String = "FF9900";
      
      public const COLOR_TOKENS:String = "CC0000";
      
      public const COLOR_BAD:String = "CC0000";
      
      public const COLOR_GOOD:String = "33CC00";
      
      public const COLOR_HARD:String = "FF9900";
      
      public const COLOR_INSANE:String = "CC0000";
      
      public const COLOR_GIFT_KEY:String = "FFFF00";
      
      public const CLAN_FLAG_CENTER_FRAMES:uint = 27;
      
      public const CLAN_FLAG_SIDES_FRAMES:uint = 11;
      
      public const CLAN_FLAG_COLORS:uint = 18;
      
      private const COLOR_BLUE:String = "0099FF";
      
      private const COLOR_ORANGE:String = "FF9900";
      
      private const COLOR_DARK_GREEN:String = "005400";
      
      private const COLOR_GREEN:String = "33CC00";
      
      private const COLOR_PURPLE:String = "9C3399";
      
      private const COLOR_DARK_RED:String = "831E09";
      
      private const COLOR_DARK_RED_DARK:String = "311E09";
      
      private const COLOR_DARK_GRAY:String = "282828";
      
      private const COLOR_LIGHT_GRAY:String = "545454";
      
      private const COLOR_BLACK:String = "000000";
      
      private const COLOR_YELLOW:String = "FFCC00";
      
      public var afInterface:AppsFlyerInterface;
      
      public const COLOR_SECRET_ITEM:String = "389C38";
      
      public var _currentDifficulty:int = 2;
      
      public var _currentBoss:int = 0;
      
      public function BMDataManager()
      {
         super();
         if(!_allowInstantiation)
         {
            throw new Error("Error: Instantiation failed: Use BMDataManager.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : BMDataManager
      {
         if(_instance == null)
         {
            _allowInstantiation = true;
            _instance = new BMDataManager();
            _allowInstantiation = false;
         }
         return _instance;
      }
      
      public function get rewardSPWinGold() : uint
      {
         var effectiveDifficulty:int = Math.max(1,_currentDifficulty);
         var multiplier:Number = 1 + (effectiveDifficulty - 1) * 0.5;
         return uint(BASE_REWARD * multiplier);
      }
      
      public function setCurrentDifficulty(newDifficulty:int) : void
      {
         _currentDifficulty = newDifficulty;
         trace("Updated difficulty to " + _currentDifficulty + ", new reward: " + rewardSPWinGold);
      }
      
      public function addMobileScreenTracking(param1:String) : void
      {
         this.mobileScreenTracking(param1);
      }
      
      public function sendAppsFlyerTracking(param1:String, param2:String) : void
      {
         trace("BMDataManager :: sendAppsFlyerTracking()");
         this.afInterface.trackEvent(param1,"{\"value\":\"" + param2 + "\"}");
      }
      
      public function initialize() : void
      {
         var _loc1_:BMItemData = null;
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         trace("BMDataManager initialized");
         generateSingletonClassesPointers("dataManager");
         BMAndroidStoreKitManager.getInstance().addEventListener(AndroidStoreEvent.PURCHASE_SUCCEEDED,this.storeKitPurchaseComplete);
         if(GAnalytics.isSupported())
         {
            GAnalytics.create(GOOGLE_ANALYTICS_TRACKING_ID);
            GAnalytics.analytics.defaultTracker.setAdvertisingIdCollectionEnabled(true);
         }
         this.mobileScreenTracking("Start");
         if(DetectedSettings.isMobile || this.localTestForIOS)
         {
            this.runAsMobile = true;
         }
         this.runAsMobile = true;
         if(this.runAsMobile)
         {
            this.useLanguages = true;
         }
         else
         {
            this.useLanguages = true;
         }
         this.itemsMaxLevelsDB = new Object();
         this.itemsMaxLevelsDB["torso"] = 10;
         this.itemsMaxLevelsDB["leg"] = 10;
         this.itemsMaxLevelsDB["sideWeapon"] = 10;
         this.itemsMaxLevelsDB["topWeapon"] = 10;
         this.itemsMaxLevelsDB["drone"] = 10;
         this.itemsMaxLevelsDB["shield"] = 10;
         this.itemsMaxLevelsDB["teleport"] = 10;
         this.itemsMaxLevelsDB["charge"] = 10;
         this.itemsMaxLevelsDB["harpoon"] = 10;
         this.itemsMaxLevelsDB["kit_repair"] = 10;
         this.itemsMaxLevelsDB["kit_energy"] = 10;
         this.itemsMaxLevelsDB["kit_heat"] = 10;
         this.itemsMaxLevelsDB["kit_bullets"] = 10;
         this.itemsMaxLevelsDB["kit_rockets"] = 10;
         this.itemsMaxLevelsDB["kit_resistance"] = 10;
         this.itemsMaxLevelsDB["kit_power"] = 10;
         this.itemsMaxLevelsDB["module_armor"] = 10;
         this.itemsMaxLevelsDB["module_energy"] = 10;
         this.itemsMaxLevelsDB["module_heat"] = 10;
         this.itemsMaxLevelsDB["module_bullets"] = 10;
         this.itemsMaxLevelsDB["module_rockets"] = 10;
         this.itemsMaxLevelsDB["module_bulletsAndRockets"] = 10;
         this.itemsMaxLevelsDB["module_resistance"] = 10;
         this.createGeneralDataBases();
         this.createItemsDataBaseLocally();
         for each(_loc2_ in this.itemsDB_local)
         {
            _loc1_ = new BMItemData();
            _loc1_.initialize();
            _loc1_.itemID = _loc2_[0];
            _loc1_.fullName = _loc2_[1];
            _loc1_.sortID = _loc2_[2];
            _loc1_.finalSortID = _loc2_[3];
            _loc1_.type = _loc2_[4];
            _loc1_.subType = _loc2_[5];
            _loc1_.level = _loc2_[6];
            _loc1_.HPBase = _loc2_[7];
            _loc1_.HPAddon = _loc2_[8];
            _loc1_.energyBase = _loc2_[9];
            _loc1_.energyAddon = _loc2_[10];
            _loc1_.heatBase = _loc2_[11];
            _loc1_.heatAddon = _loc2_[12];
            _loc1_.bullets = _loc2_[13];
            _loc1_.rockets = _loc2_[14];
            _loc1_.damageBase = _loc2_[15];
            _loc1_.damageAddon = _loc2_[16];
            _loc1_.damageType = _loc2_[17];
            _loc1_.damageHeat = _loc2_[18];
            _loc1_.damageEnergy = _loc2_[19];
            _loc1_.uses = _loc2_[20];
            _loc1_.push = _loc2_[21];
            _loc1_.resist1 = _loc2_[22];
            _loc1_.resist2 = _loc2_[23];
            _loc1_.resist3 = _loc2_[24];
            _loc1_.rangeBase = _loc2_[25];
            _loc1_.rangeAddon = _loc2_[26];
            _loc1_.stepsPerWalk = _loc2_[27];
            _loc1_.stepsPerJump = _loc2_[28];
            _loc1_.energyPerBlock = _loc2_[29];
            _loc1_.heatPerBlock = _loc2_[30];
            _loc1_.HPPerBlock = _loc2_[31];
            _loc1_.absorbRatio = _loc2_[32];
            _loc1_.costHeat = _loc2_[33];
            _loc1_.costEnergy = _loc2_[34];
            _loc1_.costGold = _loc2_[35];
            _loc1_.costTokens = _loc2_[36];
            _loc1_.animation = _loc2_[37];
            _loc1_.grp = _loc2_[38];
            _loc1_.specialStatus = _loc2_[39];
            _loc1_.power = _loc2_[40];
            _loc1_.weight = _loc2_[41];
            _loc1_.damageHeatBase = _loc2_[42];
            _loc1_.damageHeatAddon = _loc2_[43];
            _loc1_.damageEnergyBase = _loc2_[44];
            _loc1_.damageEnergyAddon = _loc2_[45];
            _loc1_.resist1Gain = _loc2_[46];
            _loc1_.resist2Gain = _loc2_[47];
            _loc1_.resist3Gain = _loc2_[48];
            _loc1_.extraPhase = _loc2_[49];
            _loc1_.APRecharge = _loc2_[50];
            _loc1_.pushSelf = _loc2_[51];
            this.itemsDB_local[_loc1_.itemID] = _loc1_;
         }
         this.setItemsCategoriesData(false);
         this.createLocalReplays();
         this.initializeGuestSharedObject();
         this.initializeGeneralSharedObject();
         this.inspectPlayerData = new Object();
         _loc3_ = true;
         if(this.runAsMobile)
         {
            _loc3_ = false;
         }
         if(_loc3_)
         {
            if(ExternalInterface.available)
            {
               _loc4_ = ExternalInterface.call("window.location.href.toString");
               if(_loc4_ != null)
               {
                  if(_loc4_.indexOf("mcamp_id=851") > 0)
                  {
                     this.runningFromSite_yepi = true;
                  }
               }
            }
         }
      }
      
      public function setFlashVarsPointer() : void
      {
         this.flashVars = new BMMClientFlashVars(screensM.clientPointer.stage);
         this.bmmSessionSO = SharedObject.getLocal(this.flashVars.soName,"/");
         this.clientVersion = this.flashVars.version;
         if(this.bmmSessionSO.data.userData != null)
         {
            if(this.bmmSessionSO.data.userData.session.SERVER != null)
            {
               if(this.bmmSessionSO.data.userData.session.SERVER.GEOIP_COUNTRY_CODE != null)
               {
                  switch(this.bmmSessionSO.data.userData.session.SERVER.GEOIP_COUNTRY_CODE)
                  {
                     case "DE":
                        this.chatDefaultLanguageID = 1;
                        break;
                     case "ES":
                        this.chatDefaultLanguageID = 2;
                  }
               }
            }
            this.sessionID = this.bmmSessionSO.data.userData.session.session_id;
            this.uniqueID = this.bmmSessionSO.data.userData.session.unique_id;
            this.userName = this.bmmSessionSO.data.userData.session.username;
            this.avatarLink = this.bmmSessionSO.data.userData.avatar_data.avatar_link;
            this.userID = this.bmmSessionSO.data.userData.user_id;
            this.saveUsernameData();
         }
         this.specialUser = false;
         switch(this.userID)
         {
            case 56:
            case 799:
            case 9195889:
            case 9227227:
            case 421541:
               this.specialUser = true;
         }
         if(this.specialUser)
         {
            this.overwriteColorsDB();
         }
         this.clientRunningLocally = true;
         var _loc1_:LocalConnection = new LocalConnection();
         var _loc2_:* = _loc1_.domain;
         if(_loc2_ != "localhost" && _loc2_ != null)
         {
            this.clientRunningLocally = false;
         }
         this.clientRunningLocally = false;
      }
      
      public function isPlayerIDAdmin(param1:Number) : Boolean
      {
         var _loc2_:Boolean = false;
         switch(param1)
         {
            case 56:
            case 799:
            case 9195889:
            case 9227227:
            case 421541:
               _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function initializeOfflineModeForPlayer() : void
      {
         var _loc1_:BMPlayerProfile = null;
         screensM.startCurrentTimeTimer();
         this.createProfile(this.OFFLINE_PLAYER_ID,this.userName,1);
         if(this.guestSharedObjectExists)
         {
            this.loadSharedObjectGuestData();
         }
         else
         {
            _loc1_ = this["player" + this.player1PlayerID + "Profile"];
            _loc1_.gold = 1000;
            _loc1_.battleCredits = this.battleCreditsMax;
            _loc1_.setFreePackages(this.FREE_PACKAGES_DEFAULT_STRING);
            _loc1_.missionsAvailable = [0,0,Infinity,Infinity];
            this.createInventoryLocally(this.OFFLINE_PLAYER_ID,1);
            _loc1_.resetCampaignMissionsData();
         }
         this.createMechLocally(this.OFFLINE_PLAYER_ID,1);
         this.createPlayerData(this.OFFLINE_PLAYER_ID,"initializeOfflineModeForPlayer");
      }
      
      public function initializeOnlineMode() : void
      {
         this.createPlayerData(this.ONLINE_PLAYER_ID,"initializeOnlineMode");
      }
      
      public function initializeIntroMode() : void
      {
         this.createProfile(this.SHOW_PLAYER1_ID,"Show 1",1);
         this.createInventoryLocally(this.SHOW_PLAYER1_ID,1);
         this.createMechLocally(this.SHOW_PLAYER1_ID,1);
         this.createPlayerData(this.SHOW_PLAYER1_ID,"initializeIntroMode");
         this.createProfile(this.SHOW_PLAYER2_ID,"Show 2",1);
         this.createInventoryLocally(this.SHOW_PLAYER2_ID,1);
         this.createMechLocally(this.SHOW_PLAYER2_ID,1);
         this.createPlayerData(this.SHOW_PLAYER2_ID,"initializeIntroMode");
         this.battleData = new Object();
         this.battleData.map = new Object();
         this.battleData.map.stepsTotal = 8;
         this.battleData["player" + this.getInterfacePlayerID(this.player1PlayerID)] = new Object();
         this.battleData["player" + this.getInterfacePlayerID(this.player2PlayerID)] = new Object();
         this.battleData["player" + this.getInterfacePlayerID(this.player1PlayerID)].currentStep = 3 - 1;
         this.battleData["player" + this.getInterfacePlayerID(this.player2PlayerID)].currentStep = this.battleData.map.stepsTotal - 3;
         this.battleData.startingPlayer = 1;
      }
      
      public function setGameTypeAndPlayers(param1:String, param2:String, param3:String) : void
      {
         this.gameType = param1;
         this.gameSubType = param2;
         loop0:
         switch(param1)
         {
            case "none":
               this.player1PlayerID = 0;
               this.player2PlayerID = 0;
               this.itemsDB = null;
               this.replaysDB = null;
               break;
            case "guest":
               this.player1PlayerID = this.OFFLINE_PLAYER_ID;
               this.player2PlayerID = this.OFFLINE_OPPONENT_ID;
               this.itemsDB = this.itemsDB_local;
               break;
            case "online":
               this.player1PlayerID = this.ONLINE_PLAYER_ID;
               this.player2PlayerID = this.ONLINE_OPPONENT_ID;
               this.itemsDB = this.itemsDB_online;
               break;
            case "replay":
               switch(this.gameSubType)
               {
                  case "offlineLogin":
                  case "offlineGuest":
                     this.player1PlayerID = this.REPLAY_PLAYER1_ID;
                     this.player2PlayerID = this.REPLAY_PLAYER2_ID;
                     this.replaysDB = this.replaysDB_offline;
                     break loop0;
                  case "onlineRegular":
                     this.player1PlayerID = this.REPLAY_PLAYER1_ID;
                     this.player2PlayerID = this.REPLAY_PLAYER2_ID;
                     this.replaysDB = this.replaysDB_online;
                     break loop0;
                  case "onlineRankingListInspect":
                  case "onlineMenuChatInspect":
                  case "onlineClanInspect":
                  case "onlineTopPlayers":
                  case "SMTV":
                     this.player1PlayerID = this.REPLAY_PLAYER1_ID;
                     this.player2PlayerID = this.REPLAY_PLAYER2_ID;
                     this.replaysDB = this.replaysDB_inspect;
               }
               break;
            case "intro":
               switch(this.gameSubType)
               {
                  case "guest":
                  case "online":
                     this.player1PlayerID = this.SHOW_PLAYER1_ID;
                     this.player2PlayerID = this.SHOW_PLAYER2_ID;
                     this.itemsDB = this.itemsDB_local;
                     break;
                  case "guest2":
                  case "online2":
                     this.player1PlayerID = this.SHOW_PLAYER1_ID;
                     this.player2PlayerID = this.SHOW_PLAYER2_ID;
                     this.itemsDB = this.itemsDB_local;
               }
         }
      }
      
      public function getInterfacePlayerID(param1:Number) : Number
      {
         var _loc2_:Number = param1;
         switch(param1)
         {
            case this.OFFLINE_PLAYER_ID:
            case this.ONLINE_PLAYER_ID:
            case this.REPLAY_PLAYER1_ID:
            case this.SHOW_PLAYER1_ID:
               _loc2_ = 1;
               break;
            case this.OFFLINE_OPPONENT_ID:
            case this.ONLINE_OPPONENT_ID:
            case this.REPLAY_PLAYER2_ID:
            case this.SHOW_PLAYER2_ID:
               _loc2_ = 2;
         }
         return _loc2_;
      }
      
      public function createProfile(param1:Number, param2:String, param3:Number) : void
      {
         this["player" + param1 + "Profile"] = new BMPlayerProfile();
         var _loc4_:BMPlayerProfile = this["player" + param1 + "Profile"];
         _loc4_.playerID = param1;
         _loc4_.playerName = param2;
         _loc4_.level = param3;
         _loc4_.lastLevel = param3;
         switch(param1)
         {
            case this.ONLINE_PLAYER_ID:
            case this.OFFLINE_PLAYER_ID:
               this.campaignBattleID = 0;
         }
      }
      
      private function createInventoryLocally(param1:Number, param2:uint = 1) : void
      {
         var _loc3_:BMPlayerProfile = null;
         var _loc4_:BMPlayerProfile = null;
         var _loc7_:Number = Number(NaN);
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:uint = 0;
         var _loc11_:Number = Number(NaN);
         var _loc12_:Number = Number(NaN);
         var _loc13_:Object = null;
         var _loc14_:uint = 0;
         var _loc15_:Boolean = false;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:Boolean = false;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:Array = null;
         var _loc22_:Number = Number(NaN);
         var _loc23_:Number = Number(NaN);
         var _loc24_:Number = Number(NaN);
         var _loc25_:uint = 0;
         var _loc26_:BMItemData = null;
         var _loc27_:uint = 0;
         if(param2 == 1)
         {
            this["playerData" + param1 + "Inventory"] = new Object();
            this["player" + param1 + "playerItemIDCounter"] = 1;
         }
         _loc3_ = this["player" + param1 + "Profile"];
         var _loc5_:Number = _loc3_.level;
         var _loc6_:Number = _loc3_.level;
         switch(param1)
         {
            case this.OFFLINE_OPPONENT_ID:
            case this.ONLINE_OPPONENT_ID:
               if(_loc5_ >= 13)
               {
                  _loc5_ -= 3;
                  break;
               }
               if(_loc5_ >= 7)
               {
                  _loc5_ -= 2;
                  break;
               }
               if(_loc5_ >= 3)
               {
                  _loc5_--;
               }
               break;
         }
         loop24:
         switch(param1)
         {
            case this.SHOW_PLAYER1_ID:
               if(this.gameType == "intro")
               {
                  switch(this.gameSubType)
                  {
                     case "guest":
                     case "online":
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],380,param2,"torso",0,5,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],319,param2,"leg",0,2,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],462,param2,"sideWeapon",1,2,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],483,param2,"sideWeapon",2,2,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],399,param2,"topWeapon",1,2,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],399,param2,"topWeapon",2,2,0);
                        break loop24;
                     case "guest2":
                     case "online2":
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],262,param2,"torso",0,1,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],319,param2,"leg",0,2,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],610,param2,"sideWeapon",1,2,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],541,param2,"sideWeapon",2,2,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],474,param2,"sideWeapon",3,2,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],562,param2,"sideWeapon",4,2,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],643,param2,"topWeapon",2,2,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],399,param2,"topWeapon",1,2,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],100,param2,"charge",0,0,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],410,param2,"harpoon",0,0,0);
                  }
               }
               break;
            case this.SHOW_PLAYER2_ID:
               if(this.gameType == "intro")
               {
                  switch(this.gameSubType)
                  {
                     case "guest":
                     case "online":
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],292,param2,"torso",0,0,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],293,param2,"leg",0,0,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],294,param2,"sideWeapon",1,0,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],294,param2,"sideWeapon",2,0,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],410,param2,"harpoon",0,9,0);
                        break loop24;
                     case "guest2":
                     case "online2":
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],380,param2,"torso",0,1,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],319,param2,"leg",0,1,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],462,param2,"sideWeapon",1,1,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],483,param2,"sideWeapon",2,1,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],399,param2,"topWeapon",1,1,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],399,param2,"topWeapon",2,1,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],100,param2,"charge",0,0,0);
                        this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],410,param2,"harpoon",0,0,0);
                  }
               }
               break;
            default:
               if(param1 == this.OFFLINE_PLAYER_ID && this.gameType == "guest")
               {
                  _loc7_ = 10;
                  if(this.clientRunningLocally)
                  {
                     this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],this.TUTORIAL_TORSO_ID,0,"torso",0,0,_loc7_);
                     this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],this.TUTORIAL_LEG_ID,0,"leg",0,0,0);
                     this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],this.TUTORIAL_WEAPON_ID,0,"sideWeapon",0,0,0);
                  }
                  else
                  {
                     this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],this.TUTORIAL_TORSO_ID,0,"torso",0,0,_loc7_);
                     this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],this.TUTORIAL_LEG_ID,0,"leg",0,0,0);
                     this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],this.TUTORIAL_WEAPON_ID,0,"sideWeapon",0,0,0);
                  }
               }
               else
               {
                  switch(this.battleType)
                  {
                     case "mission":
                        _loc8_ = true;
                        _loc9_ = false;
                        switch(this.battleSubType)
                        {
                           case "tank":
                           case "jeep":
                           case "turret":
                              _loc8_ = false;
                              _loc9_ = false;
                        }
                        _loc4_ = this["player" + this.player1PlayerID + "Profile"];
                        _loc10_ = _loc4_.mission_colorID;
                        _loc11_ = _loc3_.level - 2;
                        _loc12_ = _loc3_.level + 1;
                        _loc13_ = this.missionsDB[_loc4_.currentMissionSlot];
                        _loc14_ = 0;
                        _loc15_ = false;
                        if(_loc13_.subType == "endGame")
                        {
                           _loc15_ = true;
                           _loc14_ = 99;
                        }
                        else if(_loc4_.currentMissionSlot > 70)
                        {
                           _loc24_ = (_loc4_.currentMissionSlot - 70) / 50;
                           _loc14_ = Math.ceil(_loc24_ * 10);
                           _loc15_ = true;
                        }
                        if(_loc15_)
                        {
                           _loc11_ = this.LEVEL_MAX;
                           _loc12_ = this.LEVEL_MAX + 1;
                           _loc5_ = this.LEVEL_MAX;
                           _loc6_ = this.LEVEL_MAX + 1;
                        }
                        _loc16_ = this.getReleventItemIDsFromItemsDB("sideWeapon",_loc11_,_loc12_,_loc8_,_loc9_);
                        _loc17_ = this.getReleventItemIDsFromItemsDB("topWeapon",_loc11_,_loc12_,_loc8_,_loc9_);
                        _loc18_ = false;
                        _loc19_ = Math.ceil(Math.random() * 2);
                        if(_loc19_ == 2)
                        {
                           _loc18_ = true;
                        }
                        _loc21_ = new Array();
                        switch(this.battleSubType)
                        {
                           case "mech":
                              if(this._currentBoss == 0)
                              {
                                 this.createMechStructures_playerItemBased(param1,param2,null,_loc5_,_loc6_,_loc14_);
                                 break;
                              }
                              this._currentBoss = 0;
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],292,param2,"torso",0,201,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],294,param2,"sideWeapon",1,201,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],294,param2,"sideWeapon",2,201,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],293,param2,"leg",0,201,0);
                              break;
                           case "mech_hardmode":
                              if(this._currentBoss == 0)
                              {
                                 this.createMechStructures_playerItemBased(param1,param2,null,this.LEVEL_MAX,this.LEVEL_MAX,99);
                                 break;
                              }
                              this._currentBoss = 0;
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],292,param2,"torso",0,201,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],294,param2,"sideWeapon",1,201,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],294,param2,"sideWeapon",2,201,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],293,param2,"leg",0,201,0);
                              break;
                           case "mech_hardmode_elite":
                              var mechSetChoice:int = Math.floor(Math.random() * 3);
                              var sideWeaponOptionsPhysical:Array = [394,1159,1234,891];
                              var topWeaponOptionsPhysical:Array = [1277,1089];
                              var droneOptionsPhysical:Array = [1200,1077];
                              var sideWeaponOptionsExplosive:Array = [1044,1081,1235,1223];
                              var topWeaponOptionsExplosive:Array = [1278,1073];
                              var droneOptionsExplosive:Array = [1123,1077];
                              var sideWeaponOptionsElectric:Array = [933,1161,1236,1266];
                              var topWeaponOptionsElectric:Array = [1078,1282];
                              var droneOptionsElectric:Array = [1049,1077];
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1156,param2,"charge",0,1,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1155,param2,"teleport",0,1,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1138,param2,"harpoon",0,1,0);
                              if(mechSetChoice == 0)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],892,param2,"torso",0,1,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],896,param2,"leg",0,1,0);
                                 var slot:int = 1;
                                 while(slot <= 4)
                                 {
                                    var randomSideWeapon:int = int(sideWeaponOptionsPhysical[Math.floor(Math.random() * sideWeaponOptionsPhysical.length)]);
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],randomSideWeapon,param2,"sideWeapon",slot,1,0);
                                    slot++;
                                 }
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsPhysical[Math.floor(Math.random() * topWeaponOptionsPhysical.length)],param2,"topWeapon",1,1,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsPhysical[Math.floor(Math.random() * topWeaponOptionsPhysical.length)],param2,"topWeapon",2,1,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsPhysical[Math.floor(Math.random() * droneOptionsPhysical.length)],param2,"drone",0,1,0);
                                 var i:int = 5;
                                 while(i <= 7)
                                 {
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],977,param2,"module",i,0,0);
                                    i++;
                                 }
                              }
                              else if(mechSetChoice == 1)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],893,param2,"torso",0,1,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],895,param2,"leg",0,1,0);
                                 var slot2:int = 1;
                                 while(slot2 <= 4)
                                 {
                                    var randomSideWeapon2:int = int(sideWeaponOptionsExplosive[Math.floor(Math.random() * sideWeaponOptionsExplosive.length)]);
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],randomSideWeapon2,param2,"sideWeapon",slot2,1,0);
                                    slot2++;
                                 }
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsExplosive[Math.floor(Math.random() * topWeaponOptionsExplosive.length)],param2,"topWeapon",1,1,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsExplosive[Math.floor(Math.random() * topWeaponOptionsExplosive.length)],param2,"topWeapon",2,1,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsExplosive[Math.floor(Math.random() * droneOptionsExplosive.length)],param2,"drone",0,1,0);
                                 var j:int = 5;
                                 while(j <= 7)
                                 {
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],978,param2,"module",j,0,0);
                                    j++;
                                 }
                              }
                              else if(mechSetChoice == 2)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],894,param2,"torso",0,1,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],897,param2,"leg",0,1,0);
                                 var slot3:int = 1;
                                 while(slot3 <= 4)
                                 {
                                    var randomSideWeapon3:int = int(sideWeaponOptionsElectric[Math.floor(Math.random() * sideWeaponOptionsElectric.length)]);
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],randomSideWeapon3,param2,"sideWeapon",slot3,1,0);
                                    slot3++;
                                 }
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsElectric[Math.floor(Math.random() * topWeaponOptionsElectric.length)],param2,"topWeapon",1,1,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsElectric[Math.floor(Math.random() * topWeaponOptionsElectric.length)],param2,"topWeapon",2,1,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsElectric[Math.floor(Math.random() * droneOptionsElectric.length)],param2,"drone",0,2,0);
                                 var k:int = 5;
                                 while(k <= 7)
                                 {
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1212,param2,"module",k,0,0);
                                    k++;
                                 }
                              }
                              var moduleSlot:int = 1;
                              while(moduleSlot <= 4)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1211,param2,"module",moduleSlot,0,0);
                                 moduleSlot++;
                              }
                              break;
                           case "tank":
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],915,param2,"torso",0,_loc10_,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],917,param2,"leg",0,_loc10_,0);
                              _loc20_ = uint(_loc16_[Math.ceil(Math.random() * _loc16_.length) - 1]);
                              _loc21_.push(_loc20_);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],_loc20_,param2,"sideWeapon",1,_loc10_,0);
                              if(_loc18_)
                              {
                                 _loc20_ = uint(_loc17_[Math.ceil(Math.random() * _loc17_.length) - 1]);
                                 _loc21_.push(_loc20_);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],_loc20_,param2,"topWeapon",2,_loc10_,0);
                                 break;
                              }
                              _loc20_ = uint(_loc16_[Math.ceil(Math.random() * _loc16_.length) - 1]);
                              _loc21_.push(_loc20_);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],_loc20_,param2,"sideWeapon",2,_loc10_,0);
                              break;
                           case "jeep":
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],914,param2,"torso",0,_loc10_,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],916,param2,"leg",0,_loc10_,0);
                              _loc20_ = uint(_loc16_[Math.ceil(Math.random() * _loc16_.length) - 1]);
                              _loc21_.push(_loc20_);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],_loc20_,param2,"sideWeapon",1,_loc10_,0);
                              if(_loc18_)
                              {
                                 _loc20_ = uint(_loc17_[Math.ceil(Math.random() * _loc17_.length) - 1]);
                                 _loc21_.push(_loc20_);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],_loc20_,param2,"topWeapon",2,_loc10_,0);
                                 break;
                              }
                              _loc20_ = uint(_loc16_[Math.ceil(Math.random() * _loc16_.length) - 1]);
                              _loc21_.push(_loc20_);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],_loc20_,param2,"sideWeapon",2,_loc10_,0);
                              break;
                           case "turret":
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],919,param2,"torso",0,_loc10_,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],918,param2,"leg",0,_loc10_,0);
                              _loc20_ = uint(_loc16_[Math.ceil(Math.random() * _loc16_.length) - 1]);
                              _loc21_.push(_loc20_);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],_loc20_,param2,"sideWeapon",1,_loc10_,0);
                              _loc20_ = uint(_loc16_[Math.ceil(Math.random() * _loc16_.length) - 1]);
                              _loc21_.push(_loc20_);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],_loc20_,param2,"sideWeapon",2,_loc10_,0);
                              _loc20_ = uint(_loc17_[Math.ceil(Math.random() * _loc17_.length) - 1]);
                              _loc21_.push(_loc20_);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],_loc20_,param2,"topWeapon",1,_loc10_,0);
                              _loc20_ = uint(_loc17_[Math.ceil(Math.random() * _loc17_.length) - 1]);
                              _loc21_.push(_loc20_);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],_loc20_,param2,"topWeapon",2,_loc10_,0);
                              break;
                           case "italianBattleShip":
                              var italianShipChoice:int = Math.floor(Math.random() * 3);
                              var sideWeaponOptionsItalianShipPhysical:Array = [1159,1145,562,927];
                              var topWeaponOptionsItalianShipPhysical:Array = [1163,1158];
                              var sideWeaponOptionsItalianShipExplosive:Array = [1143,1044,521,925];
                              var topWeaponOptionsItalianShipExplosive:Array = [1117,995];
                              var sideWeaponOptionsItalianShipElectric:Array = [406,1266,1161,926];
                              var topWeaponOptionsItalianShipElectric:Array = [1078,1135];
                              if(italianShipChoice == 0)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1253,param2,"torso",0,21,0);
                                 slot = 1;
                                 while(slot <= 4)
                                 {
                                    randomSideWeapon = int(sideWeaponOptionsItalianShipPhysical[Math.floor(Math.random() * sideWeaponOptionsItalianShipPhysical.length)]);
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],randomSideWeapon,param2,"sideWeapon",slot,21,0);
                                    slot++;
                                 }
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianShipPhysical[Math.floor(Math.random() * topWeaponOptionsItalianShipPhysical.length)],param2,"topWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianShipPhysical[Math.floor(Math.random() * topWeaponOptionsItalianShipPhysical.length)],param2,"topWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1254,param2,"leg",0,21,0);
                                 moduleSlot = 1;
                                 while(moduleSlot <= 4)
                                 {
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],977,param2,"module",moduleSlot,0,0);
                                    moduleSlot++;
                                 }
                                 break;
                              }
                              if(italianShipChoice == 1)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1253,param2,"torso",0,21,0);
                                 slot = 1;
                                 while(slot <= 4)
                                 {
                                    randomSideWeapon = int(sideWeaponOptionsItalianShipExplosive[Math.floor(Math.random() * sideWeaponOptionsItalianShipExplosive.length)]);
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],randomSideWeapon,param2,"sideWeapon",slot,21,0);
                                    slot++;
                                 }
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianShipExplosive[Math.floor(Math.random() * topWeaponOptionsItalianShipExplosive.length)],param2,"topWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianShipExplosive[Math.floor(Math.random() * topWeaponOptionsItalianShipExplosive.length)],param2,"topWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1254,param2,"leg",0,21,0);
                                 moduleSlot = 1;
                                 while(moduleSlot <= 4)
                                 {
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],978,param2,"module",moduleSlot,0,0);
                                    moduleSlot++;
                                 }
                                 break;
                              }
                              if(italianShipChoice == 2)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1253,param2,"torso",0,21,0);
                                 slot = 1;
                                 while(slot <= 4)
                                 {
                                    randomSideWeapon = int(sideWeaponOptionsItalianShipElectric[Math.floor(Math.random() * sideWeaponOptionsItalianShipElectric.length)]);
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],randomSideWeapon,param2,"sideWeapon",slot,21,0);
                                    slot++;
                                 }
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianShipElectric[Math.floor(Math.random() * topWeaponOptionsItalianShipElectric.length)],param2,"topWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianShipElectric[Math.floor(Math.random() * topWeaponOptionsItalianShipElectric.length)],param2,"topWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1254,param2,"leg",0,21,0);
                                 moduleSlot = 1;
                                 while(moduleSlot <= 4)
                                 {
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1212,param2,"module",moduleSlot,0,0);
                                    moduleSlot++;
                                 }
                              }
                              break;
                           case "italianCarrier":
                              var italianCarrierChoice:int = Math.floor(Math.random() * 3);
                              var sideWeaponOptionsItalianCarrierPhysical:Array = [898];
                              var topWeaponOptionsItalianCarrierPhysical:Array = [903];
                              var droneOptionsItalianCarrierPhysical:Array = [1201,1204,648];
                              var sideWeaponOptionsItalianCarrierExplosive:Array = [899];
                              var topWeaponOptionsItalianCarrierExplosive:Array = [902];
                              var droneOptionsItalianCarrierExplosive:Array = [1188,1203,650];
                              var sideWeaponOptionsItalianCarrierElectric:Array = [900];
                              var topWeaponOptionsItalianCarrierElectric:Array = [901];
                              var droneOptionsItalianCarrierElectric:Array = [1049,1202,649];
                              if(italianCarrierChoice == 0)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1256,param2,"torso",0,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsItalianCarrierPhysical[Math.floor(Math.random() * sideWeaponOptionsItalianCarrierPhysical.length)],param2,"sideWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsItalianCarrierPhysical[Math.floor(Math.random() * sideWeaponOptionsItalianCarrierPhysical.length)],param2,"sideWeapon",3,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianCarrierPhysical[Math.floor(Math.random() * topWeaponOptionsItalianCarrierPhysical.length)],param2,"topWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianCarrierPhysical[Math.floor(Math.random() * topWeaponOptionsItalianCarrierPhysical.length)],param2,"topWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1254,param2,"leg",0,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsItalianCarrierPhysical[Math.floor(Math.random() * droneOptionsItalianCarrierPhysical.length)],param2,"drone",0,21,0);
                                 moduleSlot = 1;
                                 while(moduleSlot <= 4)
                                 {
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],977,param2,"module",moduleSlot,0,0);
                                    moduleSlot++;
                                 }
                                 break;
                              }
                              if(italianCarrierChoice == 1)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1256,param2,"torso",0,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsItalianCarrierExplosive[Math.floor(Math.random() * sideWeaponOptionsItalianCarrierExplosive.length)],param2,"sideWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsItalianCarrierExplosive[Math.floor(Math.random() * sideWeaponOptionsItalianCarrierExplosive.length)],param2,"sideWeapon",3,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianCarrierExplosive[Math.floor(Math.random() * topWeaponOptionsItalianCarrierExplosive.length)],param2,"topWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianCarrierExplosive[Math.floor(Math.random() * topWeaponOptionsItalianCarrierExplosive.length)],param2,"topWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1254,param2,"leg",0,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsItalianCarrierExplosive[Math.floor(Math.random() * droneOptionsItalianCarrierExplosive.length)],param2,"drone",0,21,0);
                                 moduleSlot = 1;
                                 while(moduleSlot <= 4)
                                 {
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],978,param2,"module",moduleSlot,0,0);
                                    moduleSlot++;
                                 }
                                 break;
                              }
                              if(italianCarrierChoice == 2)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1256,param2,"torso",0,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsItalianCarrierElectric[Math.floor(Math.random() * sideWeaponOptionsItalianCarrierElectric.length)],param2,"sideWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsItalianCarrierElectric[Math.floor(Math.random() * sideWeaponOptionsItalianCarrierElectric.length)],param2,"sideWeapon",3,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianCarrierElectric[Math.floor(Math.random() * topWeaponOptionsItalianCarrierElectric.length)],param2,"topWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianCarrierElectric[Math.floor(Math.random() * topWeaponOptionsItalianCarrierElectric.length)],param2,"topWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1254,param2,"leg",0,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsItalianCarrierElectric[Math.floor(Math.random() * droneOptionsItalianCarrierElectric.length)],param2,"drone",0,21,0);
                                 moduleSlot = 1;
                                 while(moduleSlot <= 4)
                                 {
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1212,param2,"module",moduleSlot,0,0);
                                    moduleSlot++;
                                 }
                              }
                              break;
                           case "italianAirship":
                              var italianAirshipChoice:int = Math.floor(Math.random() * 3);
                              var sideWeaponOptionsItalianAirshipPhysical:Array = [927,1159,520,564];
                              var topWeaponOptionsItalianAirshipPhysical:Array = [995,1163,1158];
                              var droneOptionsItalianAirshipPhysical:Array = [1204];
                              var sideWeaponOptionsItalianAirshipExplosive:Array = [925,1160,1063,565];
                              var topWeaponOptionsItalianAirshipExplosive:Array = [1038,1117,1157];
                              var droneOptionsItalianAirshipExplosive:Array = [1203];
                              var sideWeaponOptionsItalianAirshipElectric:Array = [926,1161,1266,563];
                              var topWeaponOptionsItalianAirshipElectric:Array = [1162,1070,989];
                              var droneOptionsItalianAirshipElectric:Array = [1202];
                              if(italianAirshipChoice == 0)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1257,param2,"torso",0,21,0);
                                 slot = 1;
                                 while(slot <= 4)
                                 {
                                    randomSideWeapon = int(sideWeaponOptionsItalianAirshipPhysical[Math.floor(Math.random() * sideWeaponOptionsItalianAirshipPhysical.length)]);
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],randomSideWeapon,param2,"sideWeapon",slot,21,0);
                                    slot++;
                                 }
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianAirshipPhysical[Math.floor(Math.random() * topWeaponOptionsItalianAirshipPhysical.length)],param2,"topWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianAirshipPhysical[Math.floor(Math.random() * topWeaponOptionsItalianAirshipPhysical.length)],param2,"topWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1258,param2,"leg",0,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsItalianAirshipPhysical[Math.floor(Math.random() * droneOptionsItalianAirshipPhysical.length)],param2,"drone",0,21,0);
                                 moduleSlot = 1;
                                 while(moduleSlot <= 4)
                                 {
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],977,param2,"module",moduleSlot,0,0);
                                    moduleSlot++;
                                 }
                                 break;
                              }
                              if(italianAirshipChoice == 1)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1257,param2,"torso",0,21,0);
                                 slot = 1;
                                 while(slot <= 4)
                                 {
                                    randomSideWeapon = int(sideWeaponOptionsItalianAirshipExplosive[Math.floor(Math.random() * sideWeaponOptionsItalianAirshipExplosive.length)]);
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],randomSideWeapon,param2,"sideWeapon",slot,21,0);
                                    slot++;
                                 }
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianAirshipExplosive[Math.floor(Math.random() * topWeaponOptionsItalianAirshipExplosive.length)],param2,"topWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianAirshipExplosive[Math.floor(Math.random() * topWeaponOptionsItalianAirshipExplosive.length)],param2,"topWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1258,param2,"leg",0,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsItalianAirshipExplosive[Math.floor(Math.random() * droneOptionsItalianAirshipExplosive.length)],param2,"drone",0,21,0);
                                 moduleSlot = 1;
                                 while(moduleSlot <= 4)
                                 {
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],978,param2,"module",moduleSlot,0,0);
                                    moduleSlot++;
                                 }
                                 break;
                              }
                              if(italianAirshipChoice == 2)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1257,param2,"torso",0,21,0);
                                 slot = 1;
                                 while(slot <= 4)
                                 {
                                    randomSideWeapon = int(sideWeaponOptionsItalianAirshipElectric[Math.floor(Math.random() * sideWeaponOptionsItalianAirshipElectric.length)]);
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],randomSideWeapon,param2,"sideWeapon",slot,21,0);
                                    slot++;
                                 }
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianAirshipElectric[Math.floor(Math.random() * topWeaponOptionsItalianAirshipElectric.length)],param2,"topWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsItalianAirshipElectric[Math.floor(Math.random() * topWeaponOptionsItalianAirshipElectric.length)],param2,"topWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1258,param2,"leg",0,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsItalianAirshipElectric[Math.floor(Math.random() * droneOptionsItalianAirshipElectric.length)],param2,"drone",0,21,0);
                                 moduleSlot = 1;
                                 while(moduleSlot <= 4)
                                 {
                                    this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1212,param2,"module",moduleSlot,0,0);
                                    moduleSlot++;
                                 }
                              }
                              break;
                           case "boss1":
                              var hadesChoice:int = Math.floor(Math.random() * 3);
                              var sideWeaponOptionsHadesHeat:Array = [1044,920,1223];
                              var topWeaponOptionsHadesHeat:Array = [956,1157];
                              var droneOptionsHadesHeat:Array = [1203];
                              var sideWeaponOptionsHadesElectric:Array = [1266,1222];
                              var topWeaponOptionsHadesElectric:Array = [1135,1078];
                              var droneOptionsHadesElectric:Array = [1202];
                              var sideWeaponOptionsHadesExplosive:Array = [1044,920,1223];
                              var topWeaponOptionsHadesExplosive:Array = [956,1157];
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],934,param2,"torso",0,201,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],492,param2,"leg",0,201,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1155,param2,"teleport",0,0,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1156,param2,"charge",0,0,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1166,param2,"shield",0,0,0);
                              if(hadesChoice == 0)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsHadesHeat[0],param2,"sideWeapon",1,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsHadesHeat[0],param2,"sideWeapon",2,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsHadesHeat[1],param2,"sideWeapon",3,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsHadesHeat[2],param2,"sideWeapon",4,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsHadesHeat[0],param2,"topWeapon",1,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsHadesHeat[1],param2,"topWeapon",2,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1045,param2,"harpoon",0,0,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsHadesHeat[0],param2,"drone",0,201,0);
                              }
                              else if(hadesChoice == 1)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsHadesElectric[0],param2,"sideWeapon",1,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsHadesElectric[0],param2,"sideWeapon",2,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsHadesElectric[1],param2,"sideWeapon",3,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsHadesElectric[2],param2,"sideWeapon",4,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsHadesElectric[0],param2,"topWeapon",1,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsHadesElectric[1],param2,"topWeapon",2,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1045,param2,"harpoon",0,0,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsHadesElectric[0],param2,"drone",0,201,0);
                              }
                              else if(hadesChoice == 2)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsHadesExplosive[0],param2,"sideWeapon",1,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsHadesExplosive[0],param2,"sideWeapon",2,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsHadesExplosive[1],param2,"sideWeapon",3,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsHadesExplosive[2],param2,"sideWeapon",4,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsHadesExplosive[0],param2,"topWeapon",1,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsHadesExplosive[1],param2,"topWeapon",2,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1046,param2,"harpoon",0,0,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsHadesHeat[0],param2,"drone",0,201,0);
                              }
                              break;
                           case "boss2":
                              var gurgenChoice:int = Math.floor(Math.random() * 3);
                              var sideWeaponOptionsGurgenPhysical:Array = [813,927];
                              var topWeaponOptionsGurgenPhysical:Array = [995];
                              var droneOptionsGurgenPhysical:Array = [1204];
                              var sideWeaponOptionsGurgenExplosive:Array = [1310,925];
                              var topWeaponOptionsGurgenExplosive:Array = [1316];
                              var droneOptionsGurgenExplosive:Array = [1203];
                              var sideWeaponOptionsGurgenElectric:Array = [1312,926];
                              var topWeaponOptionsGurgenElectric:Array = [1319];
                              var droneOptionsGurgenElectric:Array = [1202];
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1215,param2,"torso",0,201,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1214,param2,"leg",0,201,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1166,param2,"shield",0,0,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1155,param2,"teleport",0,0,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1156,param2,"charge",0,0,0);
                              if(gurgenChoice == 0)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsGurgenPhysical[0],param2,"sideWeapon",2,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsGurgenPhysical[1],param2,"sideWeapon",4,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsGurgenPhysical[0],param2,"topWeapon",1,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsGurgenPhysical[0],param2,"topWeapon",2,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1047,param2,"harpoon",0,0,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsGurgenPhysical[0],param2,"drone",0,201,0);
                              }
                              else if(gurgenChoice == 1)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsGurgenExplosive[0],param2,"sideWeapon",2,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsGurgenExplosive[1],param2,"sideWeapon",4,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsGurgenExplosive[0],param2,"topWeapon",1,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsGurgenExplosive[0],param2,"topWeapon",2,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1046,param2,"harpoon",0,0,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsGurgenExplosive[0],param2,"drone",0,201,0);
                              }
                              else if(gurgenChoice == 2)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsGurgenElectric[0],param2,"sideWeapon",2,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],sideWeaponOptionsGurgenElectric[1],param2,"sideWeapon",4,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsGurgenElectric[0],param2,"topWeapon",1,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],topWeaponOptionsGurgenElectric[0],param2,"topWeapon",2,201,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1045,param2,"harpoon",0,0,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],droneOptionsGurgenElectric[0],param2,"drone",0,201,0);
                              }
                              break;
                           case "boss3":
                              var adamantitusChoice:int = Math.floor(Math.random() * 3);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1232,param2,"torso",0,21,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1156,param2,"charge",0,0,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1166,param2,"shield",0,0,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1233,param2,"drone",0,21,0);
                              if(adamantitusChoice == 0)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1323,param2,"leg",0,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],616,param2,"sideWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1270,param2,"sideWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1234,param2,"sideWeapon",3,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1234,param2,"sideWeapon",4,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1280,param2,"topWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1295,param2,"topWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1047,param2,"harpoon",0,0,0);
                              }
                              else if(adamantitusChoice == 1)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1324,param2,"leg",0,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1151,param2,"sideWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1268,param2,"sideWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1235,param2,"sideWeapon",3,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1235,param2,"sideWeapon",4,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1281,param2,"topWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1293,param2,"topWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1046,param2,"harpoon",0,0,0);
                              }
                              else if(adamantitusChoice == 2)
                              {
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1325,param2,"leg",0,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],619,param2,"sideWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1272,param2,"sideWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1236,param2,"sideWeapon",3,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1236,param2,"sideWeapon",4,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1282,param2,"topWeapon",1,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1296,param2,"topWeapon",2,21,0);
                                 this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1045,param2,"harpoon",0,0,0);
                              }
                              break;
                           case "italianBoss1":
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1247,param2,"torso",0,21,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1250,param2,"sideWeapon",3,21,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1249,param2,"sideWeapon",4,21,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1251,param2,"topWeapon",1,21,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1251,param2,"topWeapon",2,21,0);
                              this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],1225,param2,"leg",0,21,0);
                        }
                        loop30:
                        switch(this.battleSubType)
                        {
                           case "jeep":
                           case "tank":
                           case "turret":
                              _loc25_ = 0;
                              while(true)
                              {
                                 if(true)
                                 {
                                    if(true)
                                    {
                                       if(true)
                                       {
                                          if(true)
                                          {
                                             if(true)
                                             {
                                                if(true)
                                                {
                                                   if(true)
                                                   {
                                                      if(true)
                                                      {
                                                         if(true)
                                                         {
                                                            if(true)
                                                            {
                                                               if(true)
                                                               {
                                                                  if(true)
                                                                  {
                                                                     if(true)
                                                                     {
                                                                        if(true)
                                                                        {
                                                                           if(true)
                                                                           {
                                                                              if(true)
                                                                              {
                                                                                 if(true)
                                                                                 {
                                                                                    if(true)
                                                                                    {
                                                                                       if(true)
                                                                                       {
                                                                                          if(true)
                                                                                          {
                                                                                             if(true)
                                                                                             {
                                                                                                if(true)
                                                                                                {
                                                                                                   if(true)
                                                                                                   {
                                                                                                      if(true)
                                                                                                      {
                                                                                                         if(true)
                                                                                                         {
                                                                                                            if(true)
                                                                                                            {
                                                                                                               if(true)
                                                                                                               {
                                                                                                                  if(true)
                                                                                                                  {
                                                                                                                     if(true)
                                                                                                                     {
                                                                                                                        if(true)
                                                                                                                        {
                                                                                                                           if(true)
                                                                                                                           {
                                                                                                                              if(true)
                                                                                                                              {
                                                                                                                                 if(true)
                                                                                                                                 {
                                                                                                                                    if(true)
                                                                                                                                    {
                                                                                                                                       if(true)
                                                                                                                                       {
                                                                                                                                          if(true)
                                                                                                                                          {
                                                                                                                                             if(true)
                                                                                                                                             {
                                                                                                                                                if(true)
                                                                                                                                                {
                                                                                                                                                   if(true)
                                                                                                                                                   {
                                                                                                                                                      if(true)
                                                                                                                                                      {
                                                                                                                                                         if(true)
                                                                                                                                                         {
                                                                                                                                                            if(true)
                                                                                                                                                            {
                                                                                                                                                               if(true)
                                                                                                                                                               {
                                                                                                                                                                  if(true)
                                                                                                                                                                  {
                                                                                                                                                                     if(true)
                                                                                                                                                                     {
                                                                                                                                                                        if(true)
                                                                                                                                                                        {
                                                                                                                                                                           if(true)
                                                                                                                                                                           {
                                                                                                                                                                              if(true)
                                                                                                                                                                              {
                                                                                                                                                                                 if(true)
                                                                                                                                                                                 {
                                                                                                                                                                                    if(true)
                                                                                                                                                                                    {
                                                                                                                                                                                       if(true)
                                                                                                                                                                                       {
                                                                                                                                                                                          if(true)
                                                                                                                                                                                          {
                                                                                                                                                                                             if(true)
                                                                                                                                                                                             {
                                                                                                                                                                                                if(true)
                                                                                                                                                                                                {
                                                                                                                                                                                                   if(_loc25_ >= _loc21_.length)
                                                                                                                                                                                                   {
                                                                                                                                                                                                      break loop30;
                                                                                                                                                                                                   }
                                                                                                                                                                                                   _loc26_ = this.itemsDB[_loc21_[_loc25_]];
                                                                                                                                                                                                   _loc27_ = 0;
                                                                                                                                                                                                   if(_loc26_.bullets > 0)
                                                                                                                                                                                                   {
                                                                                                                                                                                                      _loc27_ = this.getKitOrModuleItemIDByTypeAndLevel("module","bullets",_loc6_);
                                                                                                                                                                                                   }
                                                                                                                                                                                                   else if(_loc26_.rockets > 0)
                                                                                                                                                                                                   {
                                                                                                                                                                                                      _loc27_ = this.getKitOrModuleItemIDByTypeAndLevel("module","rockets",_loc6_);
                                                                                                                                                                                                   }
                                                                                                                                                                                                   if(_loc27_ > 0)
                                                                                                                                                                                                   {
                                                                                                                                                                                                      this.addInventoryItem(param1,this["playerData" + param1 + "Inventory"],_loc27_,param2,"module",_loc25_ + 1,0,0);
                                                                                                                                                                                                   }
                                                                                                                                                                                                   _loc25_++;
                                                                                                                                                                                                }
                                                                                                                                                                                             }
                                                                                                                                                                                          }
                                                                                                                                                                                       }
                                                                                                                                                                                    }
                                                                                                                                                                                 }
                                                                                                                                                                              }
                                                                                                                                                                           }
                                                                                                                                                                        }
                                                                                                                                                                     }
                                                                                                                                                                  }
                                                                                                                                                               }
                                                                                                                                                            }
                                                                                                                                                         }
                                                                                                                                                      }
                                                                                                                                                   }
                                                                                                                                                }
                                                                                                                                             }
                                                                                                                                          }
                                                                                                                                       }
                                                                                                                                    }
                                                                                                                                 }
                                                                                                                              }
                                                                                                                           }
                                                                                                                        }
                                                                                                                     }
                                                                                                                  }
                                                                                                               }
                                                                                                            }
                                                                                                         }
                                                                                                      }
                                                                                                   }
                                                                                                }
                                                                                             }
                                                                                          }
                                                                                       }
                                                                                    }
                                                                                 }
                                                                              }
                                                                           }
                                                                        }
                                                                     }
                                                                  }
                                                               }
                                                            }
                                                         }
                                                      }
                                                   }
                                                }
                                             }
                                          }
                                       }
                                    }
                                    continue;
                                 }
                              }
                        }
                        break;
                     default:
                        _loc4_ = this["player" + this.player1PlayerID + "Profile"];
                        _loc22_ = _loc4_.level;
                        _loc23_ = _loc4_.level + 1;
                        if(_loc22_ > this.LEVEL_MAX)
                        {
                           _loc22_ = this.LEVEL_MAX;
                        }
                        if(_loc23_ >= this.LEVEL_MAX + 1)
                        {
                           _loc23_ = this.LEVEL_MAX + 1;
                        }
                        this.createMechStructures_playerItemBased(param1,1,null,_loc22_,_loc23_);
                  }
               }
         }
      }
      
      public function createMechLocally(param1:Number, param2:uint) : void
      {
         var _loc8_:Object = null;
         var _loc9_:String = null;
         this["playerData" + param1 + "MechStructure" + param2] = new BMMechStructure();
         var _loc3_:BMMechStructure = this["playerData" + param1 + "MechStructure" + param2];
         _loc3_.initialize(param1,param2);
         var _loc4_:Object = this["playerData" + param1 + "Inventory"];
         var _loc5_:Number;
         var _loc6_:Number = _loc5_ = Number(this["player" + param1 + "playerItemIDCounter"]);
         var _loc7_:uint = 1;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc4_[_loc7_];
            if(_loc8_.equipped == param2)
            {
               _loc9_ = _loc8_.type;
               switch(_loc8_.type)
               {
                  case "sideWeapon":
                  case "topWeapon":
                  case "module":
                  case "kit":
                     _loc9_ = _loc8_.type + _loc8_.equipmentID;
               }
               _loc3_[_loc9_] = _loc8_.playerItemID;
            }
            _loc7_++;
         }
      }
      
      public function createPlayerData(param1:Number, param2:String) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         var _loc8_:BMMechStructure = null;
         var _loc9_:BMPlayerItemData = null;
         var _loc10_:BMItemData = null;
         var _loc11_:Array = null;
         var _loc12_:uint = 0;
         var _loc13_:BMPlayerItemData = null;
         var _loc3_:Object = this["playerData" + param1 + "Inventory"];
         var _loc4_:BMPlayerData = new BMPlayerData();
         _loc4_.initialize();
         var _loc5_:BMPlayerProfile = this["player" + param1 + "Profile"];
         if(param1 == this.OFFLINE_PLAYER_ID)
         {
            _loc5_.playerName = getGeneralText("guest");
         }
         _loc4_.playerItemIDCounter = 1;
         _loc6_ = 1;
         while(_loc6_ <= this.inventoryMaxMechs)
         {
            _loc8_ = new BMMechStructure();
            _loc8_.initialize(param1,_loc6_);
            _loc4_.mechStructures[_loc6_] = _loc8_;
            _loc6_++;
         }
         for each(_loc7_ in _loc3_)
         {
            _loc9_ = new BMPlayerItemData();
            _loc10_ = this.itemsDB[_loc7_.itemID];
            _loc9_.playerItemID = _loc7_.playerItemID;
            _loc9_.itemID = _loc7_.itemID;
            _loc9_.equipped = _loc7_.equipped;
            _loc9_.equipmentType = _loc7_.type;
            _loc9_.equipmentID = _loc7_.equipmentID;
            _loc9_.power = _loc7_.power;
            _loc9_.weight = _loc7_.weight;
            _loc9_.colorID = _loc7_.colorID;
            if(_loc7_.durability != null)
            {
               _loc9_.durability = _loc7_.durability;
            }
            else
            {
               _loc9_.durability = 0;
            }
            _loc4_.items.push(_loc9_);
            if(_loc4_.playerItemIDCounter <= _loc9_.playerItemID)
            {
               _loc4_.playerItemIDCounter = _loc9_.playerItemID + 1;
            }
         }
         _loc4_.updateExistingPlayerItemIDs();
         _loc4_.updateMechsWeight();
         this.playersData[param1] = _loc4_;
         if(param1 == this.ONLINE_PLAYER_ID)
         {
            if(_loc5_.level == 1 && _loc5_.onlineBattles == 0 && _loc5_.battlesVSComputer == 0)
            {
               if(_loc4_.items.length == 3)
               {
                  _loc11_ = new Array();
                  _loc11_.push(_loc4_.items[0]);
                  _loc11_.push(_loc4_.items[1]);
                  _loc11_.push(_loc4_.items[2]);
                  if(_loc11_[0].equipped == 0 && _loc11_[1].equipped == 0 && _loc11_[2].equipped == 0)
                  {
                     _loc12_ = 0;
                     while(_loc12_ < 3)
                     {
                        _loc13_ = _loc11_[_loc12_];
                        switch(_loc13_.itemID)
                        {
                           case this.TUTORIAL_TORSO_ID:
                              _loc4_.items[0] = _loc11_[_loc12_];
                              break;
                           case this.TUTORIAL_LEG_ID:
                              _loc4_.items[1] = _loc11_[_loc12_];
                              break;
                           case this.TUTORIAL_WEAPON_ID:
                              _loc4_.items[2] = _loc11_[_loc12_];
                              break;
                        }
                        _loc12_++;
                     }
                  }
               }
            }
         }
         _loc6_ = 1;
         while(_loc6_ <= this.inventoryMaxMechs)
         {
            this.updateMechStructure(param1,_loc6_);
            _loc6_++;
         }
         _loc4_.selectedMechID = _loc5_.initialSelectedMechID;
      }
      
      private function updateEquipmentIDInInventory(param1:BMMechStructure, param2:Object, param3:String, param4:Number) : void
      {
         var _loc5_:Number = Number(param1[param3 + param4]);
         if(_loc5_ > 0)
         {
            param2[_loc5_].equipmentID = param4;
         }
      }
      
      public function addPlayerItemDataToInventory(param1:uint, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:uint = 0) : void
      {
         var _loc8_:BMPlayerData = this.playersData[param1];
         var _loc9_:BMItemData = this.itemsDB[param2];
         var _loc10_:BMPlayerItemData = new BMPlayerItemData();
         if(param3 > 0)
         {
            _loc10_.playerItemID = param3;
         }
         else
         {
            _loc10_.playerItemID = _loc8_.playerItemIDCounter;
            ++_loc8_.playerItemIDCounter;
         }
         _loc10_.itemID = param2;
         _loc10_.equipmentType = _loc9_.type;
         _loc10_.equipmentID = param4;
         _loc10_.equipped = param5;
         _loc10_.colorID = param7;
         _loc10_.weight = _loc9_.weight;
         if(param6 > 0)
         {
            _loc10_.power = param6;
         }
         else
         {
            _loc10_.power = _loc9_.power;
         }
         _loc8_.items.push(_loc10_);
         _loc8_.updateExistingPlayerItemIDs();
      }
      
      public function removePlayerItemData(param1:uint, param2:Number) : void
      {
         var _loc4_:Number = Number(NaN);
         var _loc5_:BMPlayerItemData = null;
         var _loc3_:BMPlayerData = this.playersData[param1];
         if(_loc3_.items.length > 0)
         {
            _loc4_ = _loc3_.items.length - 1;
            while(_loc4_ >= 0)
            {
               _loc5_ = _loc3_.items[_loc4_];
               if(_loc5_.playerItemID == param2)
               {
                  _loc3_.items.splice(_loc4_,1);
               }
               _loc4_--;
            }
         }
         _loc3_.updateExistingPlayerItemIDs();
      }
      
      public function getPlayerItemData(param1:uint, param2:Number) : BMPlayerItemData
      {
         var _loc4_:BMPlayerItemData = null;
         var _loc6_:BMPlayerItemData = null;
         var _loc3_:BMPlayerData = this.playersData[param1];
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_.items.length)
         {
            _loc6_ = _loc3_.items[_loc5_];
            if(_loc6_.playerItemID == param2)
            {
               _loc4_ = _loc6_;
               _loc5_ = _loc3_.items.length;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function getBonusItems(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Array
      {
         var _loc10_:BMItemData = null;
         var _loc11_:uint = 0;
         var _loc12_:Boolean = false;
         var _loc13_:Number = Number(NaN);
         var _loc14_:Number = Number(NaN);
         var _loc15_:Number = Number(NaN);
         var _loc9_:Array = new Array();
         var _loc16_:Array = new Array();
         var _loc17_:BMPlayerProfile = null;
         var _loc18_:Array = new Array();
         _loc17_ = this["player" + this.player1PlayerID + "Profile"];
         _loc16_.push(1211);
         _loc16_.push(1212);
         _loc16_.push(1213);
         _loc16_.push(1214);
         _loc16_.push(1215);
         _loc16_.push(986);
         _loc16_.push(987);
         _loc16_.push(1166);
         _loc16_.push(1167);
         _loc16_.push(1168);
         _loc16_.push(1027);
         _loc16_.push(1029);
         _loc16_.push(977);
         _loc16_.push(978);
         _loc16_.push(1126);
         _loc16_.push(1127);
         _loc16_.push(1128);
         _loc16_.push(1129);
         _loc16_.push(1130);
         _loc16_.push(1131);
         _loc16_.push(1228);
         _loc16_.push(292);
         _loc16_.push(293);
         _loc16_.push(294);
         _loc16_.push(1232);
         _loc16_.push(1233);
         _loc16_.push(1247);
         _loc16_.push(1248);
         _loc16_.push(1249);
         _loc16_.push(1251);
         _loc16_.push(1260);
         _loc16_.push(1261);
         _loc16_.push(1262);
         _loc16_.push(1264);
         _loc16_.push(1273);
         _loc16_.push(1274);
         _loc16_.push(1275);
         _loc16_.push(1276);
         _loc16_.push(1282);
         _loc16_.push(1290);
         _loc16_.push(1291);
         _loc16_.push(1292);
         _loc16_.push(1298);
         _loc16_.push(1299);
         if(param1 < 4)
         {
            param1 = 4;
         }
         if(param2 < 4)
         {
            param2 = 4;
         }
         if(param3 < 4)
         {
            param3 = 4;
         }
         _loc9_[this.RARITY_COMMON] = new Array();
         _loc9_[this.RARITY_RARE] = new Array();
         _loc9_[this.RARITY_EPIC] = new Array();
         _loc9_[this.RARITY_LEGENDARY] = new Array();
         _loc9_[this.RARITY_MYTHICAL] = new Array();
         for each(_loc10_ in this.itemsDB)
         {
            if(_loc10_.specialStatus <= this.RARITY_MYTHICAL)
            {
               _loc12_ = false;
               if(_loc17_.level >= 15)
               {
                  if(_loc10_.level >= 15 && _loc10_.level <= 30)
                  {
                     _loc12_ = true;
                  }
               }
               else
               {
                  switch(_loc10_.specialStatus)
                  {
                     case this.RARITY_COMMON:
                        if(_loc10_.level >= param2 && _loc10_.level <= param3)
                        {
                           _loc12_ = true;
                        }
                        break;
                     default:
                        if(_loc10_.level >= param1 && _loc10_.level <= param3)
                        {
                           _loc12_ = true;
                        }
                  }
               }
               if(_loc12_)
               {
                  _loc9_[_loc10_.specialStatus].push(_loc10_.itemID);
               }
            }
         }
         _loc11_ = 1;
         while(_loc11_ <= param4)
         {
            _loc13_ = -1;
            _loc15_ = Math.random() * 100;
            if(_loc9_[this.RARITY_MYTHICAL].length > 0)
            {
               if(_loc15_ <= param8)
               {
                  _loc14_ = Math.ceil(Math.random() * _loc9_[this.RARITY_MYTHICAL].length) - 1;
                  _loc13_ = Number(_loc9_[this.RARITY_MYTHICAL][_loc14_]);
               }
            }
            if(_loc13_ == -1)
            {
               if(_loc9_[this.RARITY_LEGENDARY].length > 0)
               {
                  if(_loc15_ <= param8 + param7)
                  {
                     _loc14_ = Math.ceil(Math.random() * _loc9_[this.RARITY_LEGENDARY].length) - 1;
                     _loc13_ = Number(_loc9_[this.RARITY_LEGENDARY][_loc14_]);
                  }
               }
            }
            if(_loc13_ == -1)
            {
               if(_loc9_[this.RARITY_EPIC].length > 0)
               {
                  if(_loc15_ <= param8 + param7 + param6)
                  {
                     _loc14_ = Math.ceil(Math.random() * _loc9_[this.RARITY_EPIC].length) - 1;
                     _loc13_ = Number(_loc9_[this.RARITY_EPIC][_loc14_]);
                  }
               }
            }
            if(_loc13_ == -1)
            {
               if(_loc9_[this.RARITY_RARE].length > 0)
               {
                  if(_loc15_ <= param8 + param7 + param6 + param5)
                  {
                     _loc14_ = Math.ceil(Math.random() * _loc9_[this.RARITY_RARE].length) - 1;
                     _loc13_ = Number(_loc9_[this.RARITY_RARE][_loc14_]);
                  }
               }
            }
            if(_loc13_ == -1)
            {
               if(_loc9_[this.RARITY_COMMON].length > 0)
               {
                  _loc14_ = Math.ceil(Math.random() * _loc9_[this.RARITY_COMMON].length) - 1;
                  _loc13_ = Number(_loc9_[this.RARITY_COMMON][_loc14_]);
               }
            }
            _loc18_.push(_loc13_);
            _loc11_++;
            if(Math.random() * 100 <= 1)
            {
               if(_loc11_ <= param4)
               {
                  _loc14_ = Math.ceil(Math.random() * _loc16_.length) - 1;
                  _loc18_.push(_loc16_[_loc14_]);
                  _loc11_++;
               }
            }
         }
         return _loc18_;
      }
      
      public function isPowerKit(param1:Number) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:BMItemData = this.itemsDB[param1];
         if(_loc3_.type == "kit" && _loc3_.subType == "power")
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function isColorKit(param1:Number) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:BMItemData = this.itemsDB[param1];
         if(_loc3_.type == "kit" && _loc3_.subType == "color")
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function updateMechStructure(param1:uint, param2:uint) : void
      {
         var _loc6_:BMPlayerItemData = null;
         var _loc7_:BMItemData = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc3_:BMPlayerData = this.playersData[param1];
         var _loc4_:BMMechStructure = _loc3_.mechStructures[param2];
         _loc4_.resetStructure();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_.items.length)
         {
            _loc6_ = _loc3_.items[_loc5_];
            if(this.itemsDB[_loc6_.itemID] != null)
            {
               _loc7_ = this.itemsDB[_loc6_.itemID];
               if(_loc6_.equipped == param2)
               {
                  _loc9_ = false;
                  switch(_loc7_.type)
                  {
                     case "torso":
                     case "leg":
                     case "drone":
                     case "shield":
                     case "teleport":
                     case "charge":
                     case "harpoon":
                        _loc8_ = _loc6_.equipmentType;
                        break;
                     default:
                        _loc8_ = _loc6_.equipmentType + _loc6_.equipmentID;
                        if(_loc6_.equipmentID == 0)
                        {
                           _loc9_ = true;
                        }
                  }
                  if(_loc9_ == false)
                  {
                     _loc4_[_loc8_] = _loc6_.playerItemID;
                  }
                  else
                  {
                     trace("ERROR partName:" + _loc8_);
                  }
               }
            }
            else
            {
               trace(" ! ! ! ERROR - ITEM ID " + _loc6_.itemID + " DOES NOT EXIST");
            }
            _loc5_++;
         }
      }
      
      private function createMechStructures_playerItemBased(param1:Number, param2:uint, param3:BMMechStructure, param4:Number, param5:Number, param6:uint = 0) : void
      {
         var _loc8_:BMMechStructure = null;
         var _loc10_:uint = 0;
         var _loc11_:BMPlayerProfile = null;
         var _loc12_:BMPlayerProfile = null;
         var _loc13_:Number = Number(NaN);
         var _loc14_:Number = Number(NaN);
         var _loc7_:Object = this["playerData" + param1 + "Inventory"];
         if(param3 != null)
         {
            _loc8_ = param3;
         }
         else
         {
            _loc8_ = this.createSpecificMechStructure_ItemBased(param4,param5,param6);
         }
         var _loc9_:uint = 0;
         if(param1 == this.OFFLINE_OPPONENT_ID || this.playingVSComputer && param1 == this.ONLINE_OPPONENT_ID)
         {
            _loc11_ = this["player" + this.player1PlayerID + "Profile"];
            _loc12_ = this["player" + this.player2PlayerID + "Profile"];
            _loc13_ = _loc12_.level - _loc11_.levelByItems;
            if(this.battleType == "mission")
            {
               _loc14_ = _loc11_.mission_colorID;
            }
            else
            {
               _loc14_ = this.getComputerColorID(_loc13_);
            }
            _loc9_ = _loc14_;
            _loc8_.torso_colorID = _loc14_;
            _loc8_.leg_colorID = _loc14_;
            _loc10_ = 1;
            while(_loc10_ <= this.maxEquipment["sideWeapon"])
            {
               _loc8_["sideWeapon" + _loc10_ + "_colorID"] = _loc14_;
               _loc10_++;
            }
            _loc10_ = 1;
            while(_loc10_ <= this.maxEquipment["topWeapon"])
            {
               _loc8_["topWeapon" + _loc10_ + "_colorID"] = _loc14_;
               _loc10_++;
            }
         }
         this.addInventoryItem(param1,_loc7_,_loc8_.torso,param2,"torso",0,_loc8_.torso_colorID,0);
         this.addInventoryItem(param1,_loc7_,_loc8_.leg,param2,"leg",0,_loc8_.leg_colorID,0);
         _loc10_ = 1;
         while(_loc10_ <= this.maxEquipment["sideWeapon"])
         {
            this.addInventoryItem(param1,_loc7_,_loc8_["sideWeapon" + _loc10_],param2,"sideWeapon",_loc10_,_loc8_["sideWeapon" + _loc10_ + "_colorID"],0);
            _loc10_++;
         }
         _loc10_ = 1;
         while(_loc10_ <= this.maxEquipment["topWeapon"])
         {
            this.addInventoryItem(param1,_loc7_,_loc8_["topWeapon" + _loc10_],param2,"topWeapon",_loc10_,_loc8_["topWeapon" + _loc10_ + "_colorID"],0);
            _loc10_++;
         }
         this.addInventoryItem(param1,_loc7_,_loc8_.drone,param2,"drone",0,_loc9_,0);
         this.addInventoryItem(param1,_loc7_,_loc8_.shield,param2,"shield",0,0,0);
         this.addInventoryItem(param1,_loc7_,_loc8_.teleport,param2,"teleport",0,0,0);
         this.addInventoryItem(param1,_loc7_,_loc8_.charge,param2,"charge",0,0,0);
         this.addInventoryItem(param1,_loc7_,_loc8_.harpoon,param2,"harpoon",0,0,0);
         _loc10_ = 1;
         while(_loc10_ <= this.maxEquipment["kit"])
         {
            this.addInventoryItem(param1,_loc7_,_loc8_["kit" + _loc10_],param2,"kit",_loc10_,0,0);
            _loc10_++;
         }
         _loc10_ = 1;
         while(_loc10_ <= this.maxEquipment["module"])
         {
            this.addInventoryItem(param1,_loc7_,_loc8_["module" + _loc10_],param2,"module",_loc10_,0,0);
            _loc10_++;
         }
      }
      
      public function getComputerColorID(param1:Number) : Number
      {
         var _loc2_:Number = 0;
         if(param1 < 0)
         {
            _loc2_ = 3;
         }
         else if(param1 == 0)
         {
            _loc2_ = 4;
         }
         else if(param1 == 1)
         {
            _loc2_ = 1;
         }
         else if(param1 == 2)
         {
            _loc2_ = 8;
         }
         else if(param1 == 3)
         {
            _loc2_ = 5;
         }
         else if(param1 > 3)
         {
            _loc2_ = 9;
         }
         return _loc2_;
      }
      
      public function addInventoryItem(param1:Number, param2:Object, param3:Number, param4:Number, param5:String, param6:Number, param7:Number, param8:Number) : void
      {
         var _loc9_:Number = Number(NaN);
         var _loc10_:BMItemData = null;
         var _loc11_:Object = null;
         if(param3 > 0)
         {
            _loc9_ = Number(this["player" + param1 + "playerItemIDCounter"]);
            if(param8 == 0)
            {
               switch(param1)
               {
                  case this.OFFLINE_PLAYER_ID:
                  case this.ONLINE_PLAYER_ID:
                     param8 = Number(this.itemsDB[param3].power);
               }
            }
            _loc10_ = this.itemsDB[param3];
            _loc11_ = {
               "playerItemID":_loc9_,
               "itemID":param3,
               "equipped":param4,
               "type":param5,
               "equipmentID":param6,
               "colorID":param7,
               "power":param8,
               "weight":_loc10_.weight
            };
            param2[_loc9_] = _loc11_;
            this["player" + param1 + "playerItemIDCounter"] = _loc9_ + 1;
         }
      }
      
      public function createSpecificMechStructure_ItemBased(param1:Number, param2:Number, param3:uint = 0) : BMMechStructure
      {
         var _loc5_:BMItemData = null;
         var _loc6_:BMItemData = null;
         var _loc8_:Number = Number(NaN);
         var _loc11_:uint = 0;
         var _loc12_:Number = Number(NaN);
         if(param1 > this.itemsMaxLevelsDB["torso"])
         {
            param1 = Number(this.itemsMaxLevelsDB["torso"]);
         }
         var _loc4_:BMMechStructure = new BMMechStructure();
         var _loc7_:Array = new Array();
         _loc4_.initialize(-1,0);
         this._createSpecificMechMaxMythicals = param3;
         _loc7_ = this.getReleventItemIDsFromItemsDB("torso",param1,param2);
         _loc8_ = Math.ceil(Math.random() * _loc7_.length) - 1;
         _loc6_ = this.itemsDB[_loc7_[_loc8_]];
         _loc4_.torso = _loc6_.itemID;
         _loc4_.totalBullets = _loc6_.bullets;
         _loc4_.totalRockets = _loc6_.rockets;
         if(_loc6_.specialStatus == 4)
         {
            --this._createSpecificMechMaxMythicals;
            if(this._createSpecificMechMaxMythicals <= 0 && param2 > this.LEVEL_MAX)
            {
               param1--;
               param2--;
            }
         }
         _loc7_ = this.getReleventItemIDsFromItemsDB("leg",param1,param2);
         _loc8_ = Math.ceil(Math.random() * _loc7_.length) - 1;
         _loc5_ = this.itemsDB[_loc7_[_loc8_]];
         _loc4_.leg = _loc5_.itemID;
         if(_loc5_.specialStatus == 4)
         {
            --this._createSpecificMechMaxMythicals;
            if(this._createSpecificMechMaxMythicals <= 0 && param2 > this.LEVEL_MAX)
            {
               param1--;
               param2--;
            }
         }
         _loc4_ = this.createSpecificMechItemIDsPerType(_loc4_,"sideWeapon",param1,param2,true);
         _loc4_ = this.createSpecificMechItemIDsPerType(_loc4_,"topWeapon",param1,param2,true);
         _loc4_ = this.createSpecificMechItemIDsPerType(_loc4_,"drone",param1,param2,false);
         _loc4_ = this.createSpecificMechItemIDsPerType(_loc4_,"shield",param1,param2,false);
         _loc4_ = this.createSpecificMechItemIDsPerType(_loc4_,"teleport",param1,param2,false);
         _loc4_ = this.createSpecificMechItemIDsPerType(_loc4_,"charge",param1,param2,false);
         _loc4_ = this.createSpecificMechItemIDsPerType(_loc4_,"harpoon",param1,param2,false);
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         _loc11_ = 1;
         while(_loc11_ <= this.maxEquipment["sideWeapon"])
         {
            _loc12_ = Number(_loc4_["sideWeapon" + _loc11_]);
            if(_loc12_ > 0)
            {
               _loc5_ = this.itemsDB[_loc12_];
               if(_loc5_.bullets > 0)
               {
                  _loc9_++;
               }
               if(_loc5_.rockets > 0)
               {
                  _loc10_++;
               }
            }
            _loc11_++;
         }
         _loc11_ = 1;
         while(_loc11_ <= this.maxEquipment["topWeapon"])
         {
            _loc12_ = Number(_loc4_["topWeapon" + _loc11_]);
            if(_loc12_ > 0)
            {
               _loc5_ = this.itemsDB[_loc12_];
               if(_loc5_.bullets > 0)
               {
                  _loc9_++;
               }
               if(_loc5_.rockets > 0)
               {
                  _loc10_++;
               }
            }
            _loc11_++;
         }
         if(_loc4_.drone > 0)
         {
            _loc5_ = this.itemsDB[_loc4_.drone];
            if(_loc5_.bullets > 0)
            {
               _loc9_++;
            }
            if(_loc5_.rockets > 0)
            {
               _loc10_++;
            }
         }
         var _loc13_:Array = new Array();
         var _loc14_:Array = new Array();
         if(_loc9_ > 0 && _loc10_ > 0)
         {
            _loc13_.push("bulletsAndRockets");
            if(_loc9_ > 1)
            {
               _loc14_.push("bullets");
            }
            if(_loc10_ > 1)
            {
               _loc14_.push("rockets");
            }
            if(_loc9_ > 2)
            {
               _loc13_.push("bullets");
            }
            else if(_loc10_ > 2)
            {
               _loc13_.push("rockets");
            }
            else
            {
               _loc13_.push("bulletsAndRockets");
            }
         }
         else if(_loc9_ > 0)
         {
            _loc13_.push("bullets");
            _loc14_.push("bullets");
            if(_loc9_ > 2)
            {
               _loc13_.push("bullets");
            }
         }
         else if(_loc10_ > 0)
         {
            _loc13_.push("rockets");
            _loc14_.push("rockets");
            if(_loc10_ > 2)
            {
               if(_loc13_.length <= 1)
               {
                  _loc13_.push("rockets");
               }
            }
         }
         var _loc15_:String = "";
         if(_loc4_.shield > 0)
         {
            _loc5_ = this.itemsDB[_loc4_.shield];
            if(_loc5_.energyPerBlock > 0)
            {
               _loc15_ = "energy";
            }
            else
            {
               _loc15_ = "heat";
            }
         }
         if(_loc15_ == "energy")
         {
            _loc13_.push("energy");
            _loc14_.push("energy");
         }
         else
         {
            _loc13_.push("heat");
            _loc14_.push("heat");
         }
         var _loc16_:Number = Math.ceil(Math.random() * 2);
         if(_loc16_ == 1)
         {
            _loc13_.push("resistance");
         }
         else
         {
            _loc14_.push("resistance");
         }
         _loc14_.push("repair");
         if(_loc15_ == "energy")
         {
            _loc13_.push("energy");
            _loc14_.push("energy");
         }
         else
         {
            _loc13_.push("heat");
            _loc14_.push("heat");
         }
         _loc13_.push("heat");
         if(_loc15_ == "energy")
         {
            _loc13_.push("energy");
         }
         else
         {
            _loc13_.push("heat");
         }
         _loc13_.push("armor");
         _loc13_.push("armor");
         _loc13_.push("armor");
         _loc13_.push("armor");
         _loc14_.push("energy");
         _loc14_.push("heat");
         _loc14_.push("energy");
         _loc14_.push("heat");
         var _loc17_:uint = this.getEquipmentUnlockByLevel(param2,"module");
         if(_loc17_ > 0)
         {
            _loc11_ = 1;
            while(_loc11_ <= _loc17_)
            {
               _loc4_["module" + _loc11_] = this.getKitOrModuleItemIDByTypeAndLevel("module",_loc13_[_loc11_ - 1],param2);
               _loc11_++;
            }
         }
         var _loc18_:uint = this.getEquipmentUnlockByLevel(param2,"kit");
         if(_loc18_ > 0)
         {
            _loc11_ = 1;
            while(_loc11_ <= _loc18_)
            {
               _loc4_["kit" + _loc11_] = this.getKitOrModuleItemIDByTypeAndLevel("kit",_loc14_[_loc11_ - 1],param2);
               _loc11_++;
            }
         }
         return _loc4_;
      }
      
      private function getKitOrModuleItemIDByTypeAndLevel(param1:String, param2:String, param3:Number) : Number
      {
         var _loc11_:Array = null;
         var _loc12_:Number = Number(NaN);
         var _loc13_:uint = 0;
         var _loc14_:Number = Number(NaN);
         var _loc4_:String = param1 + "_" + param2;
         var _loc5_:Number = Number(this.itemsMaxLevelsDB[_loc4_]);
         if(param3 > _loc5_)
         {
            param3 = _loc5_;
         }
         var _loc6_:Number = param3;
         var _loc7_:Number = param3;
         var _loc8_:Array = this[param1 + "s_" + param2];
         var _loc9_:uint = 1;
         var _loc10_:Number = 0;
         while(_loc9_ <= 3 && _loc10_ == 0)
         {
            _loc11_ = new Array();
            _loc12_ = _loc6_;
            while(_loc12_ <= _loc7_)
            {
               if(_loc8_[_loc12_] != null)
               {
                  _loc13_ = 0;
                  while(_loc13_ < _loc8_[_loc12_].length)
                  {
                     _loc11_.push(_loc8_[_loc12_][_loc13_]);
                     _loc13_++;
                  }
               }
               _loc12_++;
            }
            if(_loc11_.length > 0)
            {
               _loc14_ = Math.ceil(Math.random() * _loc11_.length) - 1;
               _loc10_ = Number(_loc11_[_loc14_]);
            }
            _loc7_++;
            if(--_loc6_ < 1)
            {
               _loc6_ = 1;
            }
            if(_loc7_ > this.LEVEL_MAX)
            {
               _loc7_ = this.LEVEL_MAX;
            }
            _loc9_++;
         }
         if(_loc10_ == 0)
         {
            trace("combinedType:" + _loc4_ + " itemLevelMax:" + _loc5_ + " MISSING");
         }
         return _loc10_;
      }
      
      private function createSpecificMechItemIDsPerType(param1:BMMechStructure, param2:String, param3:Number, param4:Number, param5:Boolean) : BMMechStructure
      {
         var _loc7_:Number = Number(NaN);
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:Number = Number(NaN);
         var _loc12_:Boolean = false;
         var _loc13_:Number = Number(NaN);
         var _loc14_:Number = Number(NaN);
         var _loc15_:BMItemData = null;
         var _loc16_:String = null;
         var _loc17_:uint = 0;
         var _loc6_:Boolean = true;
         if(this._createSpecificMechMaxMythicals <= 0 && param4 > this.LEVEL_MAX)
         {
            param3--;
            param4--;
         }
         switch(param2)
         {
            case "sideWeapon":
            case "topWeapon":
               _loc7_ = this.getEquipmentUnlockByLevel(param4,param2);
               if(_loc7_ == 0)
               {
                  _loc6_ = false;
               }
               break;
            case "module":
            case "kit":
               trace("WARNING : dataM.createSpecificMechItemIDsPerType is not built for modules and kits!!!");
               break;
            default:
               _loc7_ = 1;
         }
         if(_loc6_)
         {
            _loc8_ = 1;
            while(_loc8_ <= _loc7_)
            {
               _loc9_ = param2;
               if(param3 > this.itemsMaxLevelsDB[_loc9_])
               {
                  param3 = this.itemsMaxLevelsDB[_loc9_] - 3;
                  param4 = Number(this.itemsMaxLevelsDB[_loc9_]);
                  if(param3 < 1)
                  {
                     param3 = 1;
                  }
               }
               _loc10_ = this.getReleventItemIDsFromItemsDB(param2,param3,param4);
               if(_loc10_.length > 0)
               {
                  if(param3 > 1 && _loc10_.length == 1)
                  {
                     _loc13_ = param3 -= 3;
                     if(_loc13_ < 1)
                     {
                        _loc13_ = 1;
                     }
                     _loc10_ = this.getReleventItemIDsFromItemsDB(param2,_loc13_,param4);
                  }
                  _loc11_ = 0;
                  _loc12_ = false;
                  while(_loc11_ < 10 && _loc12_ == false)
                  {
                     _loc14_ = Math.ceil(Math.random() * _loc10_.length) - 1;
                     _loc15_ = this.itemsDB[_loc10_[_loc14_]];
                     _loc16_ = param2;
                     switch(_loc16_)
                     {
                        case "sideWeapon":
                        case "topWeapon":
                           _loc16_ = param2 + _loc8_;
                     }
                     _loc12_ = true;
                     if(param5)
                     {
                        loop5:
                        switch(param2)
                        {
                           case "sideWeapon":
                           case "topWeapon":
                              _loc17_ = 1;
                              while(true)
                              {
                                 if(true)
                                 {
                                    if(true)
                                    {
                                       if(true)
                                       {
                                          if(true)
                                          {
                                             if(true)
                                             {
                                                if(true)
                                                {
                                                   if(true)
                                                   {
                                                      if(true)
                                                      {
                                                         if(true)
                                                         {
                                                            if(true)
                                                            {
                                                               if(true)
                                                               {
                                                                  if(true)
                                                                  {
                                                                     if(true)
                                                                     {
                                                                        if(true)
                                                                        {
                                                                           if(true)
                                                                           {
                                                                              if(true)
                                                                              {
                                                                                 if(true)
                                                                                 {
                                                                                    if(true)
                                                                                    {
                                                                                       if(true)
                                                                                       {
                                                                                          if(true)
                                                                                          {
                                                                                             if(true)
                                                                                             {
                                                                                                if(true)
                                                                                                {
                                                                                                   if(true)
                                                                                                   {
                                                                                                      if(true)
                                                                                                      {
                                                                                                         if(true)
                                                                                                         {
                                                                                                            if(true)
                                                                                                            {
                                                                                                               if(true)
                                                                                                               {
                                                                                                                  if(true)
                                                                                                                  {
                                                                                                                     if(true)
                                                                                                                     {
                                                                                                                        if(true)
                                                                                                                        {
                                                                                                                           if(true)
                                                                                                                           {
                                                                                                                              if(true)
                                                                                                                              {
                                                                                                                                 if(true)
                                                                                                                                 {
                                                                                                                                    if(true)
                                                                                                                                    {
                                                                                                                                       if(true)
                                                                                                                                       {
                                                                                                                                          if(true)
                                                                                                                                          {
                                                                                                                                             if(true)
                                                                                                                                             {
                                                                                                                                                if(true)
                                                                                                                                                {
                                                                                                                                                   if(true)
                                                                                                                                                   {
                                                                                                                                                      if(true)
                                                                                                                                                      {
                                                                                                                                                         if(true)
                                                                                                                                                         {
                                                                                                                                                            if(true)
                                                                                                                                                            {
                                                                                                                                                               if(true)
                                                                                                                                                               {
                                                                                                                                                                  if(true)
                                                                                                                                                                  {
                                                                                                                                                                     if(true)
                                                                                                                                                                     {
                                                                                                                                                                        if(true)
                                                                                                                                                                        {
                                                                                                                                                                           if(true)
                                                                                                                                                                           {
                                                                                                                                                                              if(true)
                                                                                                                                                                              {
                                                                                                                                                                                 if(true)
                                                                                                                                                                                 {
                                                                                                                                                                                    if(true)
                                                                                                                                                                                    {
                                                                                                                                                                                       if(true)
                                                                                                                                                                                       {
                                                                                                                                                                                          if(true)
                                                                                                                                                                                          {
                                                                                                                                                                                             if(true)
                                                                                                                                                                                             {
                                                                                                                                                                                                if(true)
                                                                                                                                                                                                {
                                                                                                                                                                                                   if(_loc17_ >= this.maxEquipment[param2])
                                                                                                                                                                                                   {
                                                                                                                                                                                                      break loop5;
                                                                                                                                                                                                   }
                                                                                                                                                                                                   if(param1[param2 + _loc17_] == _loc15_.itemID)
                                                                                                                                                                                                   {
                                                                                                                                                                                                      _loc12_ = false;
                                                                                                                                                                                                   }
                                                                                                                                                                                                   _loc17_++;
                                                                                                                                                                                                }
                                                                                                                                                                                             }
                                                                                                                                                                                          }
                                                                                                                                                                                       }
                                                                                                                                                                                    }
                                                                                                                                                                                 }
                                                                                                                                                                              }
                                                                                                                                                                           }
                                                                                                                                                                        }
                                                                                                                                                                     }
                                                                                                                                                                  }
                                                                                                                                                               }
                                                                                                                                                            }
                                                                                                                                                         }
                                                                                                                                                      }
                                                                                                                                                   }
                                                                                                                                                }
                                                                                                                                             }
                                                                                                                                          }
                                                                                                                                       }
                                                                                                                                    }
                                                                                                                                 }
                                                                                                                              }
                                                                                                                           }
                                                                                                                        }
                                                                                                                     }
                                                                                                                  }
                                                                                                               }
                                                                                                            }
                                                                                                         }
                                                                                                      }
                                                                                                   }
                                                                                                }
                                                                                             }
                                                                                          }
                                                                                       }
                                                                                    }
                                                                                 }
                                                                              }
                                                                           }
                                                                        }
                                                                     }
                                                                  }
                                                               }
                                                            }
                                                         }
                                                      }
                                                   }
                                                }
                                             }
                                          }
                                       }
                                    }
                                    continue;
                                 }
                              }
                        }
                     }
                     if(_loc12_)
                     {
                        param1[_loc16_] = _loc15_.itemID;
                        if(_loc15_.specialStatus == 4)
                        {
                           --this._createSpecificMechMaxMythicals;
                           if(this._createSpecificMechMaxMythicals <= 0 && param4 > this.LEVEL_MAX)
                           {
                              param3--;
                              param4--;
                           }
                        }
                     }
                     _loc11_++;
                  }
               }
               _loc8_++;
            }
         }
         return param1;
      }
      
      private function getReleventItemIDsFromItemsDB(param1:String, param2:Number, param3:Number, param4:Boolean = true, param5:Boolean = false) : Array
      {
         var _loc7_:BMItemData = null;
         var _loc8_:Boolean = false;
         var _loc9_:Number = Number(NaN);
         var _loc10_:Number = Number(NaN);
         var _loc11_:Number = Number(NaN);
         if(param3 > this.LEVEL_MAX + 1)
         {
            param3 = this.LEVEL_MAX + 1;
         }
         var _loc6_:Array = new Array();
         for each(_loc7_ in this.itemsDB)
         {
            if(this.itemIDsForbiddenForPC[_loc7_.itemID] == null)
            {
               if(_loc7_.type == param1)
               {
                  if(_loc7_.level >= param2 && _loc7_.level <= param3 && _loc7_.itemID != this.TUTORIAL_TORSO_ID)
                  {
                     _loc8_ = true;
                     if(param4 == false)
                     {
                        if(_loc7_.animation.substr(0,5) == "sword")
                        {
                           _loc8_ = false;
                        }
                     }
                     if(param5 == false)
                     {
                        if(_loc7_.resist1 >= 8 || _loc7_.resist2 >= 8 || _loc7_.resist3 >= 8)
                        {
                           _loc8_ = false;
                        }
                     }
                     if(_loc8_)
                     {
                        _loc6_.push(_loc7_.itemID);
                     }
                  }
               }
            }
         }
         if(_loc6_.length == 0)
         {
            _loc9_ = param2;
            _loc10_ = param3;
            _loc11_ = 0;
            while(_loc6_.length == 0 && _loc11_ <= 50)
            {
               if(--_loc9_ < 1)
               {
                  _loc9_ = 1;
               }
               for each(_loc7_ in this.itemsDB)
               {
                  if(_loc7_.type == param1)
                  {
                     if(_loc7_.level >= _loc9_ && _loc7_.level <= _loc10_ && _loc7_.itemID != this.TUTORIAL_TORSO_ID)
                     {
                        _loc6_.push(_loc7_.itemID);
                     }
                  }
               }
               _loc11_++;
            }
         }
         if(_loc6_.length == 0)
         {
            switch(param1)
            {
               case "torso":
               case "leg":
               case "sideWeapon":
                  this.traceError("dataM >> getReleventItemIDsFromItemsDB >> no " + param1 + "s found");
            }
         }
         return _loc6_;
      }
      
      public function createMissionLocally(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc14_:Object = null;
         var _loc15_:BMPlayerItemData = null;
         var _loc16_:BMItemData = null;
         var _loc17_:* = 0;
         var _loc4_:BMPlayerProfile = this["player" + this.player1PlayerID + "Profile"];
         var _loc5_:BMPlayerData = this.playersData[this.player1PlayerID];
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         for(; _loc13_ < _loc5_.items.length; _loc13_++)
         {
            _loc15_ = _loc5_.items[_loc13_];
            if(_loc15_.equipped != _loc5_.selectedMechID)
            {
               continue;
            }
            _loc16_ = this.itemsDB[_loc15_.itemID];
            switch(_loc16_.type)
            {
               case "torso":
               case "leg":
               case "module":
                  _loc6_ += _loc16_.HPBase;
                  if(_loc16_.type == "torso")
                  {
                     _loc6_ += this.getItemPowerHPBonus(this.player1PlayerID,_loc15_.playerItemID);
                  }
                  _loc7_ += _loc16_.energyBase;
                  _loc8_ += _loc16_.energyAddon;
                  _loc9_ += _loc16_.heatBase;
                  _loc10_ += _loc16_.heatAddon;
                  _loc11_ += _loc16_.bullets;
                  _loc12_ += _loc16_.rockets;
                  break;
            }
         }
         _loc4_.mission_hp = _loc6_;
         _loc4_.mission_energy = _loc7_;
         _loc4_.mission_energyRegeneration = _loc8_;
         _loc4_.mission_heat = _loc9_;
         _loc4_.mission_heatCooling = _loc10_;
         _loc4_.mission_bullets = _loc11_;
         _loc4_.mission_rockets = _loc12_;
         _loc4_.mission_difficulty = param2;
         _loc4_.mission_themeID = param3;
         _loc4_.mission_progress = new Array();
         _loc4_.mission_upgrades = new Array();
         _loc4_.mission_gold = 0;
         _loc4_.currentMissionSlot = param1;
         if(param1 <= 2)
         {
            _loc14_ = this.missionLayouts_tutorial[param1];
         }
         else if(Math.random() * 100 != -1)
         {
            _loc17_ = Math.ceil(Math.random() * this.missionLayouts_regular[param2].length) - 1;
            _loc14_ = this.missionLayouts_regular[param2][_loc17_];
         }
         else
         {
            _loc17_ = 0;
            _loc14_ = this.missionLayouts_regular[4][_loc17_];
            this._currentBoss = 1;
         }
         _loc4_.mission_layout = _loc14_.layout;
         _loc4_.mission_startingPosition = _loc14_.startLocation;
         _loc4_.mission_playerPosition = _loc14_.startLocation;
         _loc4_.mission_rows = _loc14_.rows;
         _loc4_.mission_columns = _loc14_.columns;
         _loc4_.missionID = _loc4_.currentMissionSlot + 1;
         _loc4_.mission_loot = new Array();
         _loc4_.mission_computerItems = new Object();
         this.saveGuestData("createMissionLocally");
      }
      
      public function getTargetBattleType() : Array
      {
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         var _loc1_:BMPlayerProfile = this["player" + this.player1PlayerID + "Profile"];
         var _loc2_:String = "regular";
         var _loc3_:String = "";
         if(_loc1_.missionsCompletedAtLastChallenge < _loc1_.missionsCompleted)
         {
            if(_loc1_.missionsCompleted > 2)
            {
               if(this.skipChallenge == false)
               {
                  _loc4_ = 12;
                  _loc5_ = (_loc1_.missionsCompleted + 1) % _loc4_;
                  if(_loc5_ == 4 && _loc1_.missionsCompleted > _loc4_)
                  {
                     _loc2_ = "challenge";
                     _loc3_ = "damage";
                  }
                  else if(_loc5_ == 8)
                  {
                     _loc2_ = "challenge";
                     _loc3_ = "invisible";
                  }
                  else if(_loc5_ == 0)
                  {
                     _loc2_ = "challenge";
                     _loc3_ = "godMode";
                  }
               }
               if(this.clientRunningLocally)
               {
                  _loc2_ = "challenge";
                  _loc3_ = "godMode";
               }
            }
         }
         return [_loc2_,_loc3_];
      }
      
      public function startBattleVSComputer(param1:String, param2:String, param3:Number = -1, param4:Number = -1, param5:Number = -1) : void
      {
         var _loc6_:BMPlayerProfile = null;
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         var _loc9_:Number = Number(NaN);
         var _loc10_:Number = Number(NaN);
         var _loc14_:Number = Number(NaN);
         var _loc18_:Number = Number(NaN);
         var _loc19_:uint = 0;
         var _loc20_:Boolean = false;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:uint = 0;
         var _loc24_:Boolean = false;
         var _loc25_:Object = null;
         var _loc26_:BMPlayerData = null;
         var _loc27_:BMMechStructure = null;
         var _loc28_:BMPlayerItemData = null;
         this.battleMechsPerPlayer = 1;
         if(param1 == "mission")
         {
            this.battleMechsPerPlayer = this.campaignBattleType;
         }
         this.battleType = param1;
         this.battleSubType = param2;
         this.playingVSComputer = true;
         this.skipChallenge = false;
         _loc6_ = this["player" + this.player1PlayerID + "Profile"];
         _loc6_.updateLevelByItems();
         ++_loc6_.battlesVSComputer;
         remoteM.lobby_startedBattleVSComputer();
         this.battleData = new Object();
         this.battleData.startingPlayer = 1;
         switch(_loc6_.winsVSComputer)
         {
            case 0:
               _loc7_ = 4;
               _loc8_ = 0;
               _loc9_ = 3;
               break;
            case 1:
               _loc7_ = 6;
               _loc8_ = 2;
               _loc9_ = 3;
               break;
            case 2:
               _loc7_ = 6;
               _loc8_ = 1;
               _loc9_ = 4;
               break;
            case 3:
            case 4:
               _loc7_ = 7;
               _loc8_ = 1;
               _loc9_ = 5;
               break;
            default:
               _loc20_ = true;
               switch(this.battleType)
               {
                  case "challenge":
                     switch(this.battleSubType)
                     {
                        case "godMode":
                        case "usa":
                        case "japan":
                           _loc20_ = false;
                           _loc7_ = 10;
                           _loc8_ = 3;
                           _loc9_ = 6;
                     }
               }
               if(_loc20_)
               {
                  if(_loc6_.level < 8)
                  {
                     _loc10_ = Math.ceil(Math.random() * 3);
                     _loc7_ = 8;
                     switch(_loc10_)
                     {
                        case 1:
                           _loc8_ = 3;
                           _loc9_ = 4;
                           break;
                        case 2:
                           _loc8_ = 2;
                           _loc9_ = 5;
                           break;
                        case 3:
                           _loc8_ = 1;
                           _loc9_ = 6;
                     }
                  }
                  else
                  {
                     _loc10_ = Math.ceil(Math.random() * 4);
                     _loc7_ = 10;
                     switch(_loc10_)
                     {
                        case 1:
                           _loc8_ = 4;
                           _loc9_ = 5;
                           break;
                        case 2:
                           _loc8_ = 3;
                           _loc9_ = 6;
                           break;
                        case 3:
                           _loc8_ = 2;
                           _loc9_ = 7;
                           break;
                        case 4:
                           _loc8_ = 1;
                           _loc9_ = 8;
                     }
                  }
               }
         }
         if(param3 > -1)
         {
            _loc8_ = param3;
            _loc9_ = param4;
         }
         this.battleData.map = new Object();
         this.battleData.map.stepsTotal = _loc7_;
         var _loc11_:Object = new Object();
         _loc11_.currentStep = _loc8_;
         var _loc12_:Object = new Object();
         _loc12_.currentStep = _loc9_;
         var _loc13_:Boolean = false;
         loop9:
         switch(this.battleType)
         {
            case "challenge":
               switch(this.battleSubType)
               {
                  case "godMode":
                     _loc12_.playerName = getGeneralText("godMode");
                     break loop9;
                  case "usa":
                     _loc12_.playerName = "USA Destructor";
                     break loop9;
                  case "japan":
                     _loc12_.playerName = "Yoshimo X";
                     break loop9;
                  default:
                     _loc13_ = true;
               }
               break;
            case "mission":
               switch(this.battleSubType)
               {
                  case "turret":
                  case "jeep":
                  case "tank":
                     _loc21_ = getSpecificText("missionBaseMap_" + this.battleSubType);
                     _loc12_.playerName = _loc21_;
                     break loop9;
                  default:
                     _loc13_ = true;
               }
               break;
            default:
               _loc13_ = true;
         }
         if(_loc13_)
         {
            _loc10_ = Math.ceil(Math.random() * this.computerNamesDB.length) - 1;
            _loc22_ = this.computerNamesDB[_loc10_];
            _loc12_.playerName = _loc22_;
            if(this._currentBoss == 1)
            {
               _loc12_.playerName = "DENV";
            }
            if(this.battleSubType == "boss1")
            {
               _loc12_.playerName = "Hades";
            }
         }
         if(this.battleSubType == "boss2")
         {
            _loc12_.playerName = "Gurgen";
         }
         if(this.battleSubType == "boss3")
         {
            _loc12_.playerName = "Adamantitus";
         }
         if(this.battleSubType == "italianBoss1")
         {
            _loc12_.playerName = "The Shore Captain";
         }
         if(this.battleSubType == "mech_hardmode_elite")
         {
            var eliteNames:Array = ["Blunderbass Docker","Durandal","Mechanical Impact","Desolator","Suicide Barrage","Shutdown M","Deus Ex Majima"];
            var randomIndex:int = Math.floor(Math.random() * eliteNames.length);
            _loc12_.playerName = eliteNames[randomIndex];
         }
         if(this.battleSubType == "italianBattleShip")
         {
            _loc12_.playerName = "BattleShip";
         }
         if(this.battleSubType == "italianCarrier")
         {
            _loc12_.playerName = "Aircraft Carrier";
         }
         if(this.battleSubType == "italianAirship")
         {
            _loc12_.playerName = "Armada Airship";
         }
         this.battle_clientInverted = false;
         switch(this.battleType)
         {
            case "mission":
               _loc23_ = 1 + Math.ceil(_loc6_.currentMissionSlot / 70 * (this.LEVEL_MAX - 1));
               if(_loc23_ < 2)
               {
                  _loc23_ = 2;
               }
               else if(_loc23_ > this.LEVEL_MAX)
               {
                  _loc23_ = this.LEVEL_MAX;
               }
               _loc12_.level = _loc23_;
               _loc12_.levelByItems = _loc23_;
               break;
            default:
               _loc12_.level = _loc6_.levelByItems + _loc6_.computerLevelAddon;
               _loc12_.levelByItems = _loc12_.level;
               if(_loc12_.level < 1)
               {
                  _loc12_.level = 1;
                  _loc12_.levelByItems = 1;
               }
               else if(_loc12_.level > this.LEVEL_MAX)
               {
                  _loc12_.level = this.LEVEL_MAX;
                  _loc12_.levelByItems = this.LEVEL_MAX;
               }
         }
         switch(this.player1PlayerID)
         {
            case this.OFFLINE_PLAYER_ID:
               _loc14_ = this.OFFLINE_OPPONENT_ID;
               break;
            case this.ONLINE_PLAYER_ID:
               _loc14_ = this.ONLINE_OPPONENT_ID;
         }
         this.battleData.player1 = new Object();
         this.battleData.player1.currentStep = _loc11_.currentStep;
         this.battleData.player2 = new Object();
         this.battleData.player2.currentStep = _loc12_.currentStep;
         this.createProfile(_loc14_,_loc12_.playerName,_loc12_.level);
         var _loc15_:BMPlayerProfile = this["player" + this.player2PlayerID + "Profile"];
         _loc15_.levelByItems = _loc12_.levelByItems;
         this["playerData" + _loc14_ + "Inventory"] = new Object();
         var _loc16_:Object = this["playerData" + _loc14_ + "Inventory"];
         var _loc17_:Boolean = false;
         loop14:
         switch(this.battleType)
         {
            case "challenge":
               switch(this.battleSubType)
               {
                  case "usa":
                     _loc16_[1] = {
                        "playerItemID":1,
                        "itemID":1058,
                        "equipped":1,
                        "type":"torso",
                        "equipmentID":1,
                        "colorID":9
                     };
                     _loc16_[2] = {
                        "playerItemID":2,
                        "itemID":1059,
                        "equipped":1,
                        "type":"leg",
                        "equipmentID":1,
                        "colorID":9
                     };
                     _loc16_[3] = {
                        "playerItemID":3,
                        "itemID":294,
                        "equipped":1,
                        "type":"sideWeapon",
                        "equipmentID":1,
                        "colorID":9
                     };
                     _loc16_[4] = {
                        "playerItemID":4,
                        "itemID":294,
                        "equipped":1,
                        "type":"sideWeapon",
                        "equipmentID":2,
                        "colorID":9
                     };
                     this["player" + _loc14_ + "playerItemIDCounter"] = 4;
                     break loop14;
                  case "japan":
                     _loc16_[1] = {
                        "playerItemID":1,
                        "itemID":1061,
                        "equipped":1,
                        "type":"torso",
                        "equipmentID":1,
                        "colorID":5
                     };
                     _loc16_[2] = {
                        "playerItemID":2,
                        "itemID":1062,
                        "equipped":1,
                        "type":"leg",
                        "equipmentID":1,
                        "colorID":5
                     };
                     _loc16_[3] = {
                        "playerItemID":3,
                        "itemID":1060,
                        "equipped":1,
                        "type":"sideWeapon",
                        "equipmentID":1,
                        "colorID":5
                     };
                     _loc16_[4] = {
                        "playerItemID":4,
                        "itemID":294,
                        "equipped":1,
                        "type":"sideWeapon",
                        "equipmentID":2,
                        "colorID":5
                     };
                     this["player" + _loc14_ + "playerItemIDCounter"] = 4;
                     break loop14;
                  case "godMode":
                     _loc16_[1] = {
                        "playerItemID":1,
                        "itemID":292,
                        "equipped":1,
                        "type":"torso",
                        "equipmentID":1,
                        "colorID":9
                     };
                     _loc16_[2] = {
                        "playerItemID":2,
                        "itemID":293,
                        "equipped":1,
                        "type":"leg",
                        "equipmentID":1,
                        "colorID":9
                     };
                     _loc16_[3] = {
                        "playerItemID":3,
                        "itemID":294,
                        "equipped":1,
                        "type":"sideWeapon",
                        "equipmentID":1,
                        "colorID":9
                     };
                     _loc16_[4] = {
                        "playerItemID":4,
                        "itemID":294,
                        "equipped":1,
                        "type":"sideWeapon",
                        "equipmentID":2,
                        "colorID":9
                     };
                     this["player" + _loc14_ + "playerItemIDCounter"] = 4;
                     break loop14;
                  case "damage":
                     _loc16_[1] = {
                        "playerItemID":1,
                        "itemID":718,
                        "equipped":1,
                        "type":"torso",
                        "equipmentID":1,
                        "colorID":2
                     };
                     _loc16_[2] = {
                        "playerItemID":2,
                        "itemID":719,
                        "equipped":1,
                        "type":"leg",
                        "equipmentID":1,
                        "colorID":2
                     };
                     _loc16_[3] = {
                        "playerItemID":3,
                        "itemID":720,
                        "equipped":1,
                        "type":"sideWeapon",
                        "equipmentID":1,
                        "colorID":2
                     };
                     _loc16_[4] = {
                        "playerItemID":4,
                        "itemID":720,
                        "equipped":1,
                        "type":"sideWeapon",
                        "equipmentID":2,
                        "colorID":2
                     };
                     this["player" + _loc14_ + "playerItemIDCounter"] = 4;
                     break loop14;
                  default:
                     this.createInventoryLocally(_loc14_,1);
               }
               break;
            case "regular":
               switch(_loc6_.winsVSComputer)
               {
                  case 0:
                     _loc16_[1] = {
                        "playerItemID":1,
                        "itemID":this.TUTORIAL_TORSO_ID,
                        "equipped":1,
                        "type":"torso",
                        "equipmentID":1,
                        "colorID":3
                     };
                     _loc16_[2] = {
                        "playerItemID":2,
                        "itemID":this.TUTORIAL_LEG_ID,
                        "equipped":1,
                        "type":"leg",
                        "equipmentID":1,
                        "colorID":3
                     };
                     _loc16_[3] = {
                        "playerItemID":3,
                        "itemID":this.TUTORIAL_WEAPON_ID,
                        "equipped":1,
                        "type":"sideWeapon",
                        "equipmentID":1,
                        "colorID":3
                     };
                     this["player" + _loc14_ + "playerItemIDCounter"] = 3;
                     break loop14;
                  case 1:
                     _loc16_[1] = {
                        "playerItemID":1,
                        "itemID":this.TUTORIAL_BUY_TORSO1_ID,
                        "equipped":1,
                        "type":"torso",
                        "equipmentID":1,
                        "colorID":3
                     };
                     _loc16_[2] = {
                        "playerItemID":2,
                        "itemID":this.TUTORIAL_LEG_ID,
                        "equipped":1,
                        "type":"leg",
                        "equipmentID":1,
                        "colorID":3
                     };
                     _loc16_[3] = {
                        "playerItemID":3,
                        "itemID":this.TUTORIAL_WEAPON_ID,
                        "equipped":1,
                        "type":"sideWeapon",
                        "equipmentID":1,
                        "colorID":3
                     };
                     _loc16_[4] = {
                        "playerItemID":4,
                        "itemID":this.TUTORIAL_WEAPON_ID,
                        "equipped":1,
                        "type":"sideWeapon",
                        "equipmentID":2,
                        "colorID":3
                     };
                     this["player" + _loc14_ + "playerItemIDCounter"] = 4;
                     break loop14;
                  default:
                     this.createInventoryLocally(_loc14_,1);
               }
               break;
            case "mission":
               _loc24_ = false;
               if(param5 > -1)
               {
                  if(_loc6_.mission_computerItems[param5] != null)
                  {
                     _loc24_ = true;
                  }
               }
               if(_loc24_)
               {
                  this["playerData" + _loc14_ + "Inventory"] = new Object();
                  this["player" + _loc14_ + "playerItemIDCounter"] = 1;
                  _loc18_ = 0;
                  while(_loc18_ < _loc6_.mission_computerItems[param5].length)
                  {
                     _loc25_ = _loc6_.mission_computerItems[param5][_loc18_];
                     this.addInventoryItem(_loc14_,this["playerData" + _loc14_ + "Inventory"],_loc25_.itemID,_loc25_.equipped,_loc25_.equipmentType,_loc25_.equipmentID,_loc25_.colorID,_loc25_.power);
                     _loc18_++;
                  }
               }
               else
               {
                  _loc19_ = 1;
                  while(_loc19_ <= this.battleMechsPerPlayer)
                  {
                     this.createInventoryLocally(_loc14_,_loc19_);
                     _loc19_++;
                  }
                  if(_loc6_.currentMissionSlot <= 1)
                  {
                     _loc17_ = true;
                  }
               }
         }
         _loc19_ = 1;
         while(_loc19_ <= this.battleMechsPerPlayer)
         {
            this.createMechLocally(_loc14_,_loc19_);
            _loc19_++;
         }
         this.createPlayerData(_loc14_,"startBattleVSComputer");
         if(_loc17_)
         {
            _loc26_ = this.playersData[_loc14_];
            _loc27_ = _loc26_.mechStructures[_loc26_.selectedMechID];
            _loc27_.topWeapon1 = 0;
            _loc27_.topWeapon2 = 0;
            _loc18_ = _loc26_.items.length - 1;
            while(_loc18_ >= 0)
            {
               _loc28_ = _loc26_.items[_loc18_];
               if(_loc28_.equipmentType == "topWeapon")
               {
                  _loc26_.items.splice(_loc18_,1);
               }
               _loc18_--;
            }
         }
      }
      
      public function getCampaignComputerHPRatio(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = 100;
         if(param1 <= 5)
         {
            switch(param2)
            {
               case 1:
                  _loc3_ = 75;
                  break;
               case 2:
                  _loc3_ = 100;
                  break;
               case 3:
                  _loc3_ = 120;
            }
         }
         else if(param1 <= 10)
         {
            switch(param2)
            {
               case 1:
                  _loc3_ = 85;
                  break;
               case 2:
                  _loc3_ = 100;
                  break;
               case 3:
                  _loc3_ = 120;
            }
         }
         else if(param1 <= 15)
         {
            switch(param2)
            {
               case 1:
                  _loc3_ = 90;
                  break;
               case 2:
                  _loc3_ = 105;
                  break;
               case 3:
                  _loc3_ = 120;
            }
         }
         else if(param1 <= 20)
         {
            switch(param2)
            {
               case 1:
                  _loc3_ = 95;
                  break;
               case 2:
                  _loc3_ = 110;
                  break;
               case 3:
                  _loc3_ = 120;
            }
         }
         else if(param1 <= 25)
         {
            switch(param2)
            {
               case 1:
                  _loc3_ = 100;
                  break;
               case 2:
                  _loc3_ = 110;
                  break;
               case 3:
                  _loc3_ = 125;
            }
         }
         else
         {
            switch(param2)
            {
               case 1:
                  _loc3_ = 100;
                  break;
               case 2:
                  _loc3_ = 115;
                  break;
               case 3:
                  _loc3_ = 130;
            }
         }
         return _loc3_;
      }
      
      public function battle_afterBattleFunctions(param1:Boolean) : void
      {
         var _loc4_:BMPlayerProfile = null;
         var _loc2_:BMPlayerProfile = this["player" + this.player1PlayerID + "Profile"];
         var _loc3_:String = "worldMap";
         switch(this.battleType)
         {
            case "mission":
               _loc3_ = "missionBaseMap";
               break;
            default:
               if(this.battleType == "challenge")
               {
                  _loc3_ = "worldMap";
               }
               else if(this.isTutorialSkippedRegularBattlesMode() || _loc2_.tutorialLevel <= this.TUTORIAL_LEVEL_GO_TO_HANGER_FROM_BATTLE)
               {
                  _loc3_ = "hanger";
               }
               else if(this.gameType == "online")
               {
                  if(param1 == false)
                  {
                     if(this.battle_goToChatAfterBattle || this.battle_inviteToClanAfterBattle)
                     {
                        _loc3_ = "chat";
                     }
                     else if(this.battle_inBattleInvitation)
                     {
                        _loc3_ = "chat";
                     }
                     else
                     {
                        _loc3_ = "ladder";
                     }
                  }
               }
         }
         if(_loc3_ != "missionBaseMap")
         {
            screensM.addScreen("screenNewMenu");
            screensM.screenNewMenu.refreshScreen();
            screensM.screenNewMenu.refreshTopBarAfterBattle = true;
         }
         switch(_loc3_)
         {
            case "hanger":
               screensM.screenNewMenu.hangerMechClicked(true);
               soundM.resetMusicTrackParameters();
               break;
            case "ladder":
               screensM.screenNewMenu.multiplayerLadderClicked(true,false);
               screensM.screenTopBar.activateManualBattleCreditsDisplay();
               soundM.resetMusicTrackParameters();
               if(this.topBar_levelUpInProgress == false && this.supersonic_mobile_SPMP == 0 || this.supersonic_mobile_SPMP == 2)
               {
                  this.superSonic_showAdvertisement();
               }
               break;
            case "chat":
               _loc4_ = this["player" + this.player2PlayerID + "Profile"];
               if(this.battle_goToChatAfterBattle)
               {
                  this.goToChatAfterBattle(_loc4_.userID,_loc4_.playerName,_loc4_.clanID,_loc4_.ladderProgress,_loc4_.level,_loc4_.geo);
               }
               else if(this.battle_inviteToClanAfterBattle)
               {
                  this.inviteToClanAfterBattle(_loc4_.userID,_loc4_.playerName,_loc4_.clanID,_loc4_.ladderProgress,_loc4_.level,_loc4_.geo);
               }
               screensM.screenNewMenu.multiplayerChatClicked(true,false);
               screensM.screenTopBar.activateManualBattleCreditsDisplay();
               soundM.resetMusicTrackParameters();
               if(this.topBar_levelUpInProgress == false && this.supersonic_mobile_SPMP == 0 || this.supersonic_mobile_SPMP == 2)
               {
                  this.superSonic_showAdvertisement();
               }
               break;
            case "worldMap":
               screensM.screenNewMenu.singlePlayerClicked(true);
               soundM.resetMusicTrackParameters();
               break;
            case "missionBaseMap":
               screensM.addScreen("screenMissionBaseMap");
               screensM.addScreen("screenTopBar");
               screensM.screenMissionBaseMap.refreshScreen(true);
               screensM.screenTopBar.refreshScreen(true);
               if(this.supersonic_mobile_SPMP == 0 || this.supersonic_mobile_SPMP == 1)
               {
                  this.superSonic_showAdvertisement();
               }
         }
      }
      
      public function getItemCurrentPowerLevel(param1:Number, param2:Number) : Number
      {
         var _loc8_:uint = 0;
         var _loc3_:BMPlayerItemData = this.getPlayerItemData(param1,param2);
         var _loc4_:BMItemData = this.itemsDB[_loc3_.itemID];
         var _loc5_:Number = _loc4_.level;
         var _loc6_:Number = _loc3_.power;
         var _loc7_:Number = 1;
         switch(_loc4_.type)
         {
            case "torso":
            case "leg":
            case "sideWeapon":
            case "topWeapon":
               _loc8_ = 1;
               while(_loc8_ < this.powerLevelsDB_regular[_loc5_].power.length)
               {
                  if(_loc6_ >= this.powerLevelsDB_regular[_loc5_].power[_loc8_])
                  {
                     _loc7_ = _loc8_;
                  }
                  _loc8_++;
               }
               break;
            default:
               _loc8_ = 1;
               while(_loc8_ < this.powerLevelsDB_special[_loc5_].power.length)
               {
                  if(_loc6_ >= this.powerLevelsDB_special[_loc5_].power[_loc8_])
                  {
                     _loc7_ = _loc8_;
                  }
                  _loc8_++;
               }
         }
         return _loc7_;
      }
      
      public function getGeneralPowerLevel(param1:Number, param2:Number, param3:String = "regular") : Number
      {
         var _loc5_:uint = 0;
         var _loc4_:Number = 1;
         if(param3 == "regular")
         {
            _loc5_ = 1;
            while(_loc5_ < this.powerLevelsDB_regular[param1].power.length)
            {
               if(param2 >= this.powerLevelsDB_regular[param1].power[_loc5_])
               {
                  _loc4_ = _loc5_;
               }
               _loc5_++;
            }
         }
         else
         {
            _loc5_ = 1;
            while(_loc5_ < this.powerLevelsDB_special[param1].power.length)
            {
               if(param2 >= this.powerLevelsDB_special[param1].power[_loc5_])
               {
                  _loc4_ = _loc5_;
               }
               _loc5_++;
            }
         }
         return _loc4_;
      }
      
      public function getItemNextPowerLevel(param1:Number, param2:Number) : Number
      {
         var _loc3_:BMPlayerItemData = this.getPlayerItemData(param1,param2);
         var _loc4_:BMItemData = this.itemsDB[_loc3_.itemID];
         var _loc5_:Number = _loc4_.level;
         var _loc6_:Number;
         var _loc7_:Number = _loc6_ = this.getItemCurrentPowerLevel(param1,param2);
         switch(_loc4_.type)
         {
            case "torso":
            case "leg":
            case "sideWeapon":
            case "topWeapon":
               if(this.powerLevelsDB_regular[_loc5_].power[_loc6_ + 1] != null)
               {
                  _loc7_++;
               }
               break;
            default:
               if(this.powerLevelsDB_special[_loc5_].power[_loc6_ + 1] != null)
               {
                  _loc7_++;
               }
         }
         return _loc7_;
      }
      
      public function getItemPowerHPBonus(param1:Number, param2:Number) : Number
      {
         var _loc3_:BMPlayerItemData = this.getPlayerItemData(param1,param2);
         var _loc4_:BMItemData = this.itemsDB[_loc3_.itemID];
         var _loc5_:Number = _loc4_.level;
         var _loc7_:Number = this.getItemCurrentPowerLevel(param1,param2);
         return (_loc7_ - 1) * this.powerLevelsDB_regular[_loc5_].bonusHP;
      }
      
      public function getItemPowerDamageBonus(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Number(NaN);
         var _loc5_:BMItemData = null;
         var _loc6_:Number = Number(NaN);
         var _loc7_:Number = Number(NaN);
         _loc3_ = 0;
         var _loc4_:BMPlayerItemData = this.getPlayerItemData(param1,param2);
         _loc5_ = this.itemsDB[_loc4_.itemID];
         _loc6_ = _loc5_.level;
         _loc7_ = this.getItemCurrentPowerLevel(param1,param2);
         switch(_loc5_.type)
         {
            case "torso":
            case "leg":
            case "sideWeapon":
            case "topWeapon":
               _loc3_ = (_loc7_ - 1) * this.powerLevelsDB_regular[_loc6_].bonusDamage;
               break;
            default:
               _loc3_ = (_loc7_ - 1) * this.powerLevelsDB_special[_loc6_].bonusDamage;
         }
         return _loc3_;
      }
      
      public function getItemPowerRepairBonus(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Number(NaN);
         var _loc4_:BMPlayerItemData = null;
         var _loc5_:BMItemData = null;
         var _loc6_:Number = Number(NaN);
         var _loc7_:Number = Number(NaN);
         _loc3_ = 0;
         _loc4_ = this.getPlayerItemData(param1,param2);
         _loc5_ = this.itemsDB[_loc4_.itemID];
         _loc6_ = _loc5_.level;
         _loc7_ = this.getItemCurrentPowerLevel(param1,param2);
         switch(_loc5_.type)
         {
            case "torso":
            case "leg":
            case "sideWeapon":
            case "topWeapon":
               _loc3_ = (_loc7_ - 1) * this.powerLevelsDB_regular[_loc6_].bonusRepair;
               break;
            default:
               _loc3_ = (_loc7_ - 1) * this.powerLevelsDB_special[_loc6_].bonusRepair;
         }
         return _loc3_;
      }
      
      public function getGeneralPowerHPBonus(param1:Number, param2:Number, param3:String = "regular") : Number
      {
         var _loc4_:Number = Number(NaN);
         _loc4_ = 0;
         if(param3 == "regular")
         {
            _loc4_ = (param2 - 1) * this.powerLevelsDB_regular[param1].bonusHP;
         }
         else
         {
            _loc4_ = (param2 - 1) * this.powerLevelsDB_special[param1].bonusHP;
         }
         return _loc4_;
      }
      
      public function getGeneralPowerDamageBonus(param1:Number, param2:Number, param3:String = "regular") : Number
      {
         var _loc4_:Number = Number(NaN);
         _loc4_ = 0;
         if(param3 == "regular")
         {
            _loc4_ = (param2 - 1) * this.powerLevelsDB_regular[param1].bonusDamage;
         }
         else
         {
            _loc4_ = (param2 - 1) * this.powerLevelsDB_special[param1].bonusDamage;
         }
         return _loc4_;
      }
      
      public function getGeneralPowerRepairBonus(param1:Number, param2:Number, param3:String = "regular") : Number
      {
         var _loc4_:Number = Number(NaN);
         _loc4_ = 0;
         if(param3 == "regular")
         {
            _loc4_ = (param2 - 1) * this.powerLevelsDB_regular[param1].bonusRepair;
         }
         else
         {
            _loc4_ = (param2 - 1) * this.powerLevelsDB_special[param1].bonusRepair;
         }
         return _loc4_;
      }
      
      public function getItemPowerColorID(param1:Number, param2:Number) : Number
      {
         var _loc3_:BMPlayerItemData = null;
         var _loc4_:BMItemData = null;
         var _loc5_:Number = Number(NaN);
         var _loc6_:Number = Number(NaN);
         _loc3_ = this.getPlayerItemData(param1,param2);
         _loc4_ = this.itemsDB[_loc3_.itemID];
         _loc5_ = this.getItemCurrentPowerLevel(param1,param2);
         _loc6_ = _loc5_ - 1;
         if(_loc6_ > 0)
         {
            _loc6_ += 10;
         }
         if(_loc6_ > 20)
         {
            _loc6_ = 20;
         }
         switch(_loc4_.type)
         {
            case "drone":
            case "teleport":
            case "charge":
            case "harpoon":
               _loc6_ = (_loc6_ - 10) * 2 + 10;
         }
         return _loc6_;
      }
      
      public function createInventoryTileListItem(param1:Number, param2:Boolean, param3:Function, param4:Function, param5:Function, param6:Function, param7:Function, param8:Boolean) : BMTileListItem
      {
         var _loc9_:BMPlayerProfile = null;
         var _loc10_:BMPlayerItemData = null;
         var _loc11_:BMItemData = null;
         var _loc12_:BMItem = null;
         var _loc13_:Number = Number(NaN);
         var _loc14_:BMTileListItem = null;
         var _loc15_:Function = null;
         var _loc16_:Function = null;
         var _loc17_:Function = null;
         var _loc18_:Function = null;
         var _loc19_:Function = null;
         var _loc20_:String = null;
         var _loc21_:String = null;
         var _loc22_:* = null;
         var _loc23_:Number = Number(NaN);
         var _loc24_:MovieClip = null;
         _loc9_ = this["player" + this.player1PlayerID + "Profile"];
         _loc10_ = this.getPlayerItemData(this.player1PlayerID,param1);
         _loc11_ = this.itemsDB[_loc10_.itemID];
         _loc12_ = this.createItem_basedOnPlayerItemID(this.player1PlayerID,param1,"inventory",param8);
         _loc13_ = this.INVENTORY_TILE_LIST_ITEM_SIZE;
         if(this.runAsMobile)
         {
            _loc13_ = this.INVENTORY_TILE_LIST_ITEM_SIZE_MOBILE;
         }
         _loc14_ = new BMTileListItem();
         _loc15_ = param3;
         _loc16_ = param4;
         _loc17_ = param5;
         _loc18_ = param6;
         _loc19_ = param7;
         if(this.runAsMobile)
         {
            _loc15_ = null;
            _loc16_ = null;
            _loc17_ = null;
            _loc18_ = null;
            _loc19_ = null;
         }
         if(param8 == false)
         {
            _loc14_.contentLoaded = false;
            _loc14_.contentData_playerItemID = param1;
            _loc14_.contentData_justBought = param2;
            _loc14_.contentData_removeHoldersMC = true;
            _loc14_.contentData_clicked = _loc15_;
            _loc14_.contentData_mouseDown = _loc16_;
            _loc14_.contentData_mouseUp = _loc17_;
            _loc14_.contentData_mouseOver = _loc18_;
            _loc14_.contentData_mouseOut = _loc19_;
            _loc14_.contentData_dataType = "playerItemID";
            _loc14_.contentData_name = this.itemsDB[_loc10_.itemID].fullName;
            _loc14_.contentData_createFunction = this.createInventoryTileListItem;
         }
         if(_loc10_.equipped >= 1)
         {
            _loc24_ = externalAssetsM.getAsset("general","icon_itemEquipped",_loc13_,_loc13_,false,false);
            if(_loc9_.level >= this.SECOND_MECH_UNLOCK_LEVEL && this.inventoryMaxMechs > 1)
            {
               _loc24_.gotoAndStop("mech" + _loc10_.equipped);
            }
            _loc12_.addOverItemGrp1(_loc24_);
         }
         if(_loc10_.colorID > 0)
         {
            this.colorItem(_loc12_,_loc10_.colorID);
         }
         else if(_loc10_.colorID == 204)
         {
            this.colorItem(_loc12_,0);
         }
         else
         {
            this.colorItem(_loc12_,this.getItemPowerColorID(this.player1PlayerID,param1));
         }
         _loc20_ = "";
         _loc21_ = "";
         _loc22_ = this.COLOR_LIGHT_GRAY;
         if(param2)
         {
            _loc22_ = this.COLOR_YELLOW;
         }
         else
         {
            switch(_loc11_.specialStatus)
            {
               case 1:
                  _loc22_ = this.COLOR_RARE_ITEM;
                  break;
               case 2:
                  _loc22_ = this.COLOR_EPIC_ITEM;
                  break;
               case 3:
                  _loc22_ = this.COLOR_LEGENDARY_ITEM;
                  break;
               case 4:
                  _loc20_ = this.COLOR_MYTHICAL_ITEM_DARK;
                  _loc22_ = this.COLOR_MYTHICAL_ITEM;
                  break;
               case 6:
                  _loc22_ = this.COLOR_SECRET_ITEM;
            }
         }
         switch(_loc11_.type)
         {
            case "drone":
            case "shield":
            case "teleport":
            case "charge":
            case "harpoon":
               if(_loc9_.level < this.equipmentUnlockDB[_loc11_.type].level)
               {
                  _loc20_ = "";
                  _loc21_ = this.COLOR_DARK_RED_DARK;
                  _loc22_ = this.COLOR_DARK_RED;
                  break;
               }
         }
         _loc23_ = 5;
         _loc14_.initialize(_loc13_,_loc13_,_loc12_,_loc20_,_loc21_,_loc22_,_loc23_,_loc15_,_loc16_,_loc17_,_loc18_,_loc19_,this.runAsMobile);
         return _loc14_;
      }
      
      public function createItem_basedOnPlayerItemID(param1:Number, param2:Number, param3:String, param4:Boolean) : BMItem
      {
         var _loc5_:BMPlayerData = null;
         var _loc6_:uint = 0;
         var _loc7_:BMMechStructure = null;
         var _loc8_:BMPlayerItemData = null;
         var _loc9_:BMItem = null;
         var _loc10_:BMItemData = null;
         var _loc11_:Number = Number(NaN);
         var _loc12_:Number = Number(NaN);
         var _loc13_:Number = Number(NaN);
         var _loc14_:Number = Number(NaN);
         var _loc15_:MovieClip = null;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         var _loc20_:MovieClip = null;
         var _loc21_:BMPlayerProfile = null;
         var _loc22_:String = null;
         var _loc23_:Number = Number(NaN);
         var _loc24_:Number = Number(NaN);
         var _loc25_:Number = Number(NaN);
         var _loc26_:Number = Number(NaN);
         var _loc27_:MovieClip = null;
         var _loc28_:MovieClip = null;
         var _loc29_:MovieClip = null;
         _loc5_ = this.playersData[param1];
         _loc6_ = 1;
         if(screensM.isScreenOpened("screenHangerMech"))
         {
            _loc6_ = screensM.screenHangerMech.getTargetMechID();
         }
         _loc7_ = _loc5_.mechStructures[_loc6_];
         _loc8_ = this.getPlayerItemData(param1,param2);
         _loc9_ = new BMItem();
         if(this.itemsDB[_loc8_.itemID] == null)
         {
            this.traceError("itemID " + _loc8_.itemID + " doesn\'t exist");
         }
         _loc10_ = this.itemsDB[_loc8_.itemID];
         _loc13_ = this.getIconFrameSize(param3,_loc10_.type);
         _loc14_ = 0;
         _loc15_ = null;
         _loc16_ = false;
         _loc17_ = false;
         _loc18_ = false;
         _loc19_ = false;
         switch(_loc10_.type)
         {
            case "module":
            case "kit":
            case "shield":
            case "teleport":
            case "charge":
            case "harpoon":
               _loc18_ = true;
         }
         switch(param3)
         {
            case "inventory":
               _loc11_ = this.INVENTORY_TILE_LIST_ITEM_SIZE;
               _loc12_ = this.INVENTORY_TILE_LIST_ITEM_SIZE;
               if(this.runAsMobile)
               {
                  _loc11_ = this.INVENTORY_TILE_LIST_ITEM_SIZE_MOBILE;
                  _loc12_ = this.INVENTORY_TILE_LIST_ITEM_SIZE_MOBILE;
               }
               _loc14_ = 5;
               switch(_loc10_.type)
               {
                  case "torso":
                  case "leg":
                  case "sideWeapon":
                  case "topWeapon":
                  case "drone":
                  case "teleport":
                  case "charge":
                  case "harpoon":
                     _loc17_ = true;
               }
               if(_loc8_.durability > 0)
               {
                  _loc19_ = true;
               }
               break;
            case "drag":
               _loc11_ = this.DRAG_TILE_LIST_ITEM_SIZE;
               _loc12_ = this.DRAG_TILE_LIST_ITEM_SIZE;
               _loc16_ = true;
               break;
            case "equipment":
               _loc21_ = this["player" + this.player1PlayerID + "Profile"];
               _loc11_ = this.EQUIPMENT_TILE_LIST_ITEM_SIZE;
               _loc12_ = this.EQUIPMENT_TILE_LIST_ITEM_SIZE;
               _loc22_ = "occupiedItem";
               switch(_loc10_.type)
               {
                  case "sideWeapon":
                  case "topWeapon":
                     if(_loc10_.bullets > _loc7_.totalBullets || _loc10_.rockets > _loc7_.totalRockets)
                     {
                        _loc22_ = "occupiedItemRed";
                        break;
                     }
               }
               _loc15_ = externalAssetsM.getAsset("general",_loc22_);
               switch(_loc10_.type)
               {
                  case "module":
                  case "kit":
                  case "shield":
                  case "teleport":
                  case "charge":
                  case "harpoon":
                     _loc14_ = 6;
               }
               switch(_loc10_.type)
               {
                  case "torso":
                  case "leg":
                  case "sideWeapon":
                  case "topWeapon":
                  case "drone":
                  case "teleport":
                  case "charge":
                  case "harpoon":
                     _loc17_ = true;
               }
               if(_loc8_.durability > 0)
               {
                  _loc19_ = true;
               }
         }
         _loc20_ = new MovieClip();
         if(param4)
         {
            _loc20_ = externalAssetsM.getAsset(this.itemTypeSourceDB[_loc10_.type],_loc10_.grp,0,0,true,true);
            if(_loc18_)
            {
               _loc20_.filters = [new GlowFilter(0,1,4,4,7)];
            }
         }
         else
         {
            _loc20_.graphics.beginFill(49778,1);
            _loc20_.graphics.drawRect(0,0,50,50);
         }
         switch(_loc10_.type)
         {
            case "torso":
               if(_loc20_.mcShutdown != null)
               {
                  _loc20_.mcShutdown.visible = false;
                  break;
               }
         }
         _loc9_.initialize(_loc8_.playerItemID,_loc11_,_loc12_,_loc20_,_loc13_,_loc14_,_loc16_,_loc15_,this.runAsMobile);
         if(_loc17_)
         {
            _loc23_ = this.getItemCurrentPowerLevel(param1,param2);
            if(_loc23_ > 1)
            {
               _loc24_ = 100;
               _loc25_ = 25;
               _loc26_ = 5;
               _loc27_ = new MovieClip();
               _loc27_.graphics.beginFill(0,0);
               _loc27_.graphics.drawRect(0,0,_loc24_,_loc24_);
               _loc28_ = externalAssetsM.getAsset("general","Grp_rank" + _loc23_,_loc25_,_loc25_,false,false);
               _loc28_.x = _loc24_ - _loc25_ - _loc26_;
               _loc28_.y = _loc24_ - _loc25_ - _loc26_;
               _loc27_.addChild(_loc28_);
               _loc27_.filters = [new GlowFilter(0,1,4,4,7)];
               _loc9_.addOverItemGrp1(_loc27_);
            }
         }
         if(_loc19_)
         {
            _loc29_ = externalAssetsM.getAsset("general","icon_itemDurability",_loc11_,_loc12_,false,false);
            _loc9_.addOverItemGrp2(_loc29_);
         }
         if(_loc8_.colorID > 0)
         {
            this.colorItem(_loc9_,_loc8_.colorID);
         }
         else if(_loc8_.colorID == 204)
         {
            this.colorItem(_loc9_,0);
         }
         else
         {
            this.colorItem(_loc9_,this.getItemPowerColorID(param1,_loc8_.playerItemID));
         }
         return _loc9_;
      }
      
      public function createShopTileListItem_basedOnItemID(param1:Number, param2:String, param3:Function, param4:Function, param5:Function, param6:Function, param7:Function, param8:Boolean) : BMTileListItem
      {
         var _loc9_:BMItem = null;
         var _loc10_:BMTileListItem = null;
         var _loc11_:BMPlayerData = null;
         var _loc12_:BMPlayerProfile = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:Number = Number(NaN);
         var _loc17_:String = null;
         var _loc18_:Boolean = false;
         var _loc19_:BMItemData = null;
         var _loc20_:Boolean = false;
         var _loc21_:Function = null;
         var _loc22_:Function = null;
         var _loc23_:Function = null;
         var _loc24_:Function = null;
         var _loc25_:Function = null;
         var _loc26_:Number = Number(NaN);
         var _loc27_:Number = Number(NaN);
         var _loc28_:Number = Number(NaN);
         var _loc29_:Boolean = false;
         var _loc30_:Boolean = false;
         var _loc31_:String = null;
         _loc9_ = this.createItem_basedOnItemID(param1,param2,param8);
         _loc10_ = new BMTileListItem();
         _loc11_ = this.playersData[this.player1PlayerID];
         _loc12_ = this["player" + this.player1PlayerID + "Profile"];
         _loc13_ = "";
         _loc14_ = "";
         _loc15_ = "";
         _loc16_ = 0;
         _loc17_ = "";
         _loc18_ = false;
         if(_loc11_.existingItemsIDs[param1] != null)
         {
            _loc18_ = true;
         }
         _loc19_ = this.itemsDB[param1];
         switch(_loc19_.specialStatus)
         {
            case 0:
               _loc15_ = this.COLOR_LIGHT_GRAY;
               break;
            case 1:
               _loc15_ = this.COLOR_RARE_ITEM;
               break;
            case 2:
               _loc15_ = this.COLOR_EPIC_ITEM;
               break;
            case 3:
               _loc15_ = this.COLOR_LEGENDARY_ITEM;
               switch(param2)
               {
                  case "shop":
                  case "news":
                     _loc17_ = "icon_itemBox";
               }
               break;
            case 4:
               switch(param2)
               {
                  case "shop":
                  case "news":
                     if(this.showMythicalsStats)
                     {
                        if(_loc18_)
                        {
                           _loc15_ = this.COLOR_MYTHICAL_ITEM;
                           break;
                        }
                        _loc15_ = this.COLOR_MYTHICAL_ITEM_DARK;
                        break;
                     }
                     if(_loc18_)
                     {
                        _loc15_ = this.COLOR_MYTHICAL_ITEM;
                        break;
                     }
                     _loc13_ = this.COLOR_DARK_GRAY;
                     _loc16_ = 1;
                     break;
                  case "reward":
                     _loc15_ = this.COLOR_MYTHICAL_ITEM;
               }
         }
         loop3:
         switch(param2)
         {
            case "starterPack":
               switch(_loc19_.specialStatus)
               {
                  case 0:
                     _loc13_ = this.COLOR_DARK_GRAY;
                     break loop3;
                  case 1:
                     _loc13_ = "001F42";
                     break loop3;
                  case 2:
                     _loc13_ = "300C30";
                     break loop3;
                  case 3:
                     _loc13_ = "382100";
                     break loop3;
                  case 4:
                     _loc13_ = this.COLOR_MYTHICAL_ITEM_DARK;
                     _loc15_ = this.COLOR_MYTHICAL_ITEM;
               }
         }
         _loc20_ = true;
         switch(param2)
         {
            case "shop":
               if(_loc19_.specialStatus <= 3)
               {
                  if(_loc18_)
                  {
                     _loc15_ = this.COLOR_GREEN;
                  }
                  if(_loc19_.level > _loc12_.level && _loc19_.subType != "power")
                  {
                     _loc16_ = 0.7;
                     _loc15_ = this.COLOR_DARK_GRAY;
                     _loc20_ = false;
                  }
               }
               break;
            case "news":
               if(_loc19_.specialStatus <= 3)
               {
                  if(_loc18_)
                  {
                     _loc15_ = this.COLOR_GREEN;
                  }
               }
               break;
            case "packageItem":
               _loc15_ = "";
         }
         if(param8 && _loc20_)
         {
            switch(param2)
            {
               case "shop":
               case "news":
                  if(_loc19_.specialStatus < 3)
                  {
                     _loc29_ = false;
                     _loc30_ = false;
                     if(_loc19_.costTokens == 0)
                     {
                        if(_loc19_.costGold > _loc12_.gold)
                        {
                           _loc29_ = true;
                        }
                     }
                     if(_loc19_.costTokens > _loc12_.tokens)
                     {
                        _loc30_ = true;
                     }
                     if(_loc29_)
                     {
                        if(!_loc30_)
                        {
                           _loc17_ = "icon_notEnoughGold";
                        }
                        break;
                     }
                     if(_loc19_.costTokens)
                     {
                        _loc17_ = "icon_costTokens";
                     }
                     break;
                  }
            }
         }
         _loc21_ = param3;
         _loc22_ = param4;
         _loc23_ = param5;
         _loc24_ = param6;
         _loc25_ = param7;
         if(this.runAsMobile)
         {
            _loc21_ = null;
            _loc22_ = null;
            _loc23_ = null;
            _loc24_ = null;
            _loc25_ = null;
         }
         if(param8 == false)
         {
            _loc10_.contentLoaded = false;
            _loc10_.contentData_itemID = param1;
            _loc10_.contentData_tileListType = param2;
            _loc10_.contentData_removeHoldersMC = true;
            _loc10_.contentData_removeColorMC = true;
            _loc10_.contentData_clicked = _loc21_;
            _loc10_.contentData_mouseDown = _loc22_;
            _loc10_.contentData_mouseUp = _loc23_;
            _loc10_.contentData_mouseOver = _loc24_;
            _loc10_.contentData_mouseOut = _loc25_;
            _loc10_.contentData_dataType = "itemID";
            _loc10_.contentData_name = this.itemsDB[param1].fullName;
            _loc10_.contentData_createFunction = this.createShopTileListItem_basedOnItemID;
         }
         _loc26_ = this.SHOP_TILE_LIST_ITEM_SIZE;
         _loc27_ = this.SHOP_TILE_LIST_ITEM_SIZE;
         switch(param2)
         {
            case "starterPack":
               _loc26_ = this.STARTER_PACK_SIZE;
               _loc27_ = this.STARTER_PACK_SIZE;
               break;
            case "news":
               _loc26_ = this.NEWS_TILE_LIST_ITEM_SIZE;
               _loc27_ = this.NEWS_TILE_LIST_ITEM_SIZE;
               break;
            case "reward":
               if(this.runAsMobile)
               {
                  _loc26_ = this.REWARD_TILE_LIST_ITEM_SIZE;
                  _loc27_ = this.REWARD_TILE_LIST_ITEM_SIZE;
                  break;
               }
               _loc26_ = this.REWARD_TILE_LIST_ITEM_SIZE_MOBILE;
               _loc27_ = this.REWARD_TILE_LIST_ITEM_SIZE_MOBILE;
               break;
            default:
               if(this.runAsMobile)
               {
                  _loc26_ = this.SHOP_TILE_LIST_ITEM_SIZE_MOBILE;
                  _loc27_ = this.SHOP_TILE_LIST_ITEM_SIZE_MOBILE;
               }
         }
         _loc28_ = 5;
         _loc10_.initialize(_loc26_,_loc27_,_loc9_,_loc13_,_loc14_,_loc15_,_loc28_,_loc21_,_loc22_,_loc23_,_loc24_,_loc25_,this.runAsMobile);
         if(_loc17_ != "")
         {
            _loc9_.addOverItemGrp1(externalAssetsM.getAsset("general",_loc17_,_loc26_,_loc27_,false,false));
         }
         if(param8)
         {
            if(_loc18_)
            {
               _loc31_ = "icon_itemBought";
               if(screensM.isScreenOpened("screenHangerPackages"))
               {
                  switch(_loc19_.type)
                  {
                     case "sideWeapon":
                     case "topWeapon":
                     case "drone":
                        _loc31_ = "icon_itemBought3";
                  }
               }
               else if(_loc17_ != "")
               {
                  _loc31_ = "icon_itemBought2";
               }
               _loc9_.addOverItemGrp2(externalAssetsM.getAsset("general",_loc31_,_loc26_,_loc27_,false,false));
            }
         }
         if(_loc16_ > 0)
         {
            _loc10_.setItemTint(_loc16_);
         }
         return _loc10_;
      }
      
      private function createItem_basedOnItemID(param1:Number, param2:String, param3:Boolean) : BMItem
      {
         var _loc4_:BMItem = null;
         var _loc5_:BMItemData = null;
         var _loc6_:Number = Number(NaN);
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         var _loc9_:Number = Number(NaN);
         var _loc10_:Boolean = false;
         var _loc11_:String = null;
         var _loc12_:MovieClip = null;
         _loc4_ = new BMItem();
         _loc5_ = this.itemsDB[param1];
         _loc8_ = this.getIconFrameSize(param2,_loc5_.type);
         _loc9_ = 0;
         _loc10_ = false;
         switch(param2)
         {
            case "shop":
            case "packageItem":
               _loc6_ = this.SHOP_TILE_LIST_ITEM_SIZE;
               _loc7_ = this.SHOP_TILE_LIST_ITEM_SIZE;
               if(this.runAsMobile)
               {
                  _loc6_ = this.SHOP_TILE_LIST_ITEM_SIZE_MOBILE;
                  _loc7_ = this.SHOP_TILE_LIST_ITEM_SIZE_MOBILE;
               }
               _loc9_ = 5;
               break;
            case "reward":
               if(this.runAsMobile)
               {
                  _loc6_ = this.REWARD_TILE_LIST_ITEM_SIZE;
                  _loc7_ = this.REWARD_TILE_LIST_ITEM_SIZE;
                  break;
               }
               _loc6_ = this.REWARD_TILE_LIST_ITEM_SIZE_MOBILE;
               _loc7_ = this.REWARD_TILE_LIST_ITEM_SIZE_MOBILE;
               break;
            case "starterPack":
               _loc6_ = this.STARTER_PACK_SIZE;
               _loc7_ = this.STARTER_PACK_SIZE;
               if(this.runAsMobile)
               {
                  _loc6_ = this.STARTER_PACK_SIZE;
                  _loc7_ = this.STARTER_PACK_SIZE;
               }
               _loc9_ = 5;
               break;
            case "drag":
               _loc6_ = this.DRAG_TILE_LIST_ITEM_SIZE;
               _loc7_ = this.DRAG_TILE_LIST_ITEM_SIZE;
               _loc10_ = true;
               break;
            case "news":
               _loc6_ = this.NEWS_TILE_LIST_ITEM_SIZE;
               _loc7_ = this.NEWS_TILE_LIST_ITEM_SIZE;
               _loc9_ = 2;
         }
         _loc11_ = _loc5_.grp;
         if(_loc11_ == "")
         {
            _loc11_ = "missingItemPicture";
         }
         _loc12_ = new MovieClip();
         if(param3)
         {
            _loc12_ = externalAssetsM.getAsset(this.itemTypeSourceDB[_loc5_.type],_loc11_,0,0,true,true);
            _loc12_.filters = [new GlowFilter(0,1,4,4,7)];
         }
         else
         {
            _loc12_.graphics.beginFill(49778,1);
            _loc12_.graphics.drawRect(0,0,50,50);
         }
         switch(_loc5_.type)
         {
            case "torso":
               if(_loc12_.mcShutdown != null)
               {
                  _loc12_.mcShutdown.visible = false;
                  break;
               }
         }
         _loc4_.initialize(param1,_loc6_,_loc7_,_loc12_,_loc8_,_loc9_,_loc10_,null,this.runAsMobile);
         return _loc4_;
      }
      
      private function getIconFrameSize(param1:String, param2:String) : Number
      {
         var _loc3_:Number = Number(NaN);
         _loc3_ = 0;
         loop0:
         switch(param1)
         {
            case "inventory":
            case "shop":
               switch(param2)
               {
                  case "kit":
                  case "module":
                  case "shield":
                  case "teleport":
                  case "charge":
                  case "harpoon":
                     _loc3_ = 4;
                     break loop0;
                  default:
                     _loc3_ = 5;
               }
               break;
            case "equipment":
            case "drag":
         }
         return _loc3_;
      }
      
      public function createMechIcon(param1:Number, param2:uint, param3:BMMechStructure, param4:Object, param5:Number, param6:Number, param7:Boolean, param8:Boolean, param9:Boolean, param10:Boolean) : BMItem
      {
         var _loc11_:BMMechStructure = null;
         var _loc12_:BMItem = null;
         var _loc13_:Sprite = null;
         var _loc14_:BMMechView = null;
         var _loc15_:MovieClip = null;
         var _loc16_:String = null;
         var _loc17_:MovieClip = null;
         var _loc18_:BMPlayerData = null;
         if(param1 > 0)
         {
            _loc18_ = this.playersData[param1];
            _loc11_ = _loc18_.mechStructures[param2];
         }
         else
         {
            _loc11_ = param3;
         }
         _loc12_ = new BMItem();
         _loc13_ = externalAssetsM.getAsset("general","icon_mechBackground");
         _loc13_.width *= 2;
         _loc13_.height *= 2;
         _loc14_ = new BMMechView();
         _loc15_ = new MovieClip();
         _loc16_ = "playerItemID";
         if(param1 <= 0)
         {
            _loc16_ = "itemID";
         }
         _loc14_.initialize(param1,"hanger",_loc16_,1,false);
         if(param4 != null)
         {
            _loc14_.setManualColors(param4);
         }
         _loc14_.centerMech = true;
         _loc14_.buildMech(_loc11_,"dataManager createMechIcon");
         this.resizeMechViewBySizer(_loc14_,_loc13_);
         _loc15_.addChild(_loc13_);
         _loc15_.addChild(_loc14_);
         if(param10)
         {
            _loc15_.scaleX = -1;
            _loc15_.x += _loc15_.width;
         }
         if(param7)
         {
            _loc15_.x -= _loc15_.width / 2;
            _loc15_.y -= _loc15_.height / 2;
         }
         if(param8)
         {
            _loc13_.alpha = 0;
         }
         if(param9 == false)
         {
            _loc17_ = externalAssetsM.getAsset("general","icon_mechBackground");
         }
         _loc12_.initialize(0,param5,param5,_loc15_,0,param6,false,_loc17_,this.runAsMobile);
         return _loc12_;
      }
      
      public function resizeMechViewBySizer(param1:BMMechView, param2:Sprite) : void
      {
         var _loc3_:Number = Number(NaN);
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         _loc3_ = param1.width / param2.width;
         _loc4_ = param1.height / param2.height;
         _loc5_ = 1 / _loc3_;
         if(_loc3_ < _loc4_)
         {
            _loc5_ = 1 / _loc4_;
         }
         param1.width *= _loc5_;
         param1.height *= _loc5_;
         param1.x = param1.width / 2;
         param1.y = param1.height / 2;
         if(param1.width < param2.width)
         {
            param1.x += (param2.width - param1.width) / 2;
         }
         if(param1.height < param2.height)
         {
            param1.y += (param2.height - param1.height) / 2;
         }
      }
      
      public function getColoringType(param1:Number) : String
      {
         var _loc2_:String = null;
         _loc2_ = "colorID";
         switch(param1)
         {
            case this.OFFLINE_PLAYER_ID:
            case this.ONLINE_PLAYER_ID:
               _loc2_ = "power";
               break;
            case this.ONLINE_OPPONENT_ID:
            case this.INSPECT_PLAYER_ID:
               if(this.playingVSComputer == false)
               {
                  _loc2_ = "power";
               }
         }
         return _loc2_;
      }
      
      public function colorItem(param1:BMItem, param2:Number) : void
      {
         var _loc3_:String = null;
         var _loc4_:ColorTransform = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Number = Number(NaN);
         var _loc7_:BitmapData = null;
         var _loc8_:Bitmap = null;
         var _loc9_:BitmapData = null;
         if(param2 > 0)
         {
            if(param1.itemGrp.mcColor != null)
            {
               _loc3_ = GlobalAccess.stage.quality;
               GlobalAccess.stage.quality = "low";
               _loc4_ = new ColorTransform();
               _loc4_.color = this.colorsDB[param2];
               _loc5_ = param1.itemGrp.mcColor;
               _loc5_.transform.colorTransform = _loc4_;
               _loc5_.blendMode = BlendMode.OVERLAY;
               if(this.runAsMobile == false && param1.itemGrp.itemBM != null)
               {
                  if(this.runAsMobile == false)
                  {
                     GlobalAccess.stage.quality = "best";
                  }
                  else
                  {
                     GlobalAccess.stage.quality = "low";
                  }
                  _loc6_ = 5;
                  _loc7_ = new BitmapData(param1.itemGrp.itemBM.width + _loc6_ * 2,param1.itemGrp.itemBM.height + _loc6_ * 2,true,0);
                  _loc8_ = new Bitmap(_loc7_);
                  _loc8_.smoothing = true;
                  param1.itemGrp.itemBM.x += _loc6_;
                  param1.itemGrp.itemBM.y += _loc6_;
                  if(param1.itemGrp.mcColor != null)
                  {
                     param1.itemGrp.mcColor.x += _loc6_;
                     param1.itemGrp.mcColor.y += _loc6_;
                  }
                  if(param1.itemGrp.mcBarrel != null)
                  {
                     param1.itemGrp.mcBarrel.x += _loc6_;
                     param1.itemGrp.mcBarrel.y += _loc6_;
                  }
                  if(param1.itemGrp.mcLight != null)
                  {
                     param1.itemGrp.mcLight.x += _loc6_;
                     param1.itemGrp.mcLight.y += _loc6_;
                  }
                  if(param1.itemGrp.mcHandle != null)
                  {
                     param1.itemGrp.mcHandle.x += _loc6_;
                     param1.itemGrp.mcHandle.y += _loc6_;
                  }
                  _loc8_.x -= _loc6_;
                  _loc8_.y -= _loc6_;
                  _loc7_.draw(param1.itemGrp);
                  param1.itemGrp.addChild(_loc8_);
                  if(param1.itemGrp.mcBarrel != null)
                  {
                     param1.itemGrp.mcBarrel.parent.removeChild(param1.itemGrp.mcBarrel);
                     param1.itemGrp.addChild(param1.itemGrp.mcBarrel);
                     param1.itemGrp.mcBarrel.x -= _loc6_;
                     param1.itemGrp.mcBarrel.y -= _loc6_;
                  }
                  if(param1.itemGrp.mcLight != null)
                  {
                     param1.itemGrp.mcLight.parent.removeChild(param1.itemGrp.mcLight);
                     param1.itemGrp.addChild(param1.itemGrp.mcLight);
                     param1.itemGrp.mcLight.x -= _loc6_;
                     param1.itemGrp.mcLight.y -= _loc6_;
                  }
                  if(param1.itemGrp.mcHandle != null)
                  {
                     param1.itemGrp.mcHandle.parent.removeChild(param1.itemGrp.mcHandle);
                     param1.itemGrp.addChild(param1.itemGrp.mcHandle);
                     param1.itemGrp.mcHandle.x -= _loc6_;
                     param1.itemGrp.mcHandle.y -= _loc6_;
                  }
                  if(param1.itemGrp.itemBM.parent != null)
                  {
                     param1.itemGrp.itemBM.parent.removeChild(param1.itemGrp.itemBM);
                     param1.itemGrp.itemBMD.dispose();
                  }
                  param1.itemGrp.itemBM = _loc8_;
                  param1.itemGrp.itemBMD = _loc7_;
                  if(param1.itemGrp.mcColor != null)
                  {
                     if(param1.itemGrp.mcColor.parent != null)
                     {
                        param1.itemGrp.mcColor.parent.removeChild(param1.itemGrp.mcColor);
                     }
                  }
                  if(param1.itemGrp.mcShutdown != null)
                  {
                     if(param1.itemGrp.mcShutdown.parent != null)
                     {
                        param1.itemGrp.mcShutdown.parent.removeChild(param1.itemGrp.mcShutdown);
                     }
                     param1.itemGrp.addChild(param1.itemGrp.mcShutdown);
                  }
               }
               if(this.runAsMobile)
               {
                  _loc9_ = new BitmapData(param1.itemGrp.width,param1.itemGrp.height,true,0);
                  _loc9_.draw(param1.itemGrp);
                  param1.itemGrp.gpuImage = new Bitmap(_loc9_,"auto",true);
                  param1.itemGrp.addChild(param1.itemGrp.gpuImage);
                  param1.itemGrp["cacheAsBitmapMatrix"] = new Matrix();
                  param1.itemGrp.cacheAsBitmap = true;
                  GlobalAccess.stage.quality = _loc3_;
                  if(param1.itemGrp.mcShutdown != null)
                  {
                     if(param1.itemGrp.mcShutdown.parent != null)
                     {
                        param1.itemGrp.mcShutdown.parent.removeChild(param1.itemGrp.mcShutdown);
                     }
                     param1.itemGrp.addChild(param1.itemGrp.mcShutdown);
                  }
                  if(param1.itemGrp.mcBarrel != null)
                  {
                     if(param1.itemGrp.mcBarrel.parent != null)
                     {
                        param1.itemGrp.mcBarrel.parent.removeChild(param1.itemGrp.mcBarrel);
                     }
                     param1.itemGrp.addChild(param1.itemGrp.mcBarrel);
                  }
                  if(param1.itemGrp.mcLight != null)
                  {
                     if(param1.itemGrp.mcLight.parent != null)
                     {
                        param1.itemGrp.mcLight.parent.removeChild(param1.itemGrp.mcLight);
                     }
                     param1.itemGrp.addChild(param1.itemGrp.mcLight);
                  }
                  if(param1.itemGrp.mcHandle != null)
                  {
                     if(param1.itemGrp.mcHandle.parent != null)
                     {
                        param1.itemGrp.mcHandle.parent.removeChild(param1.itemGrp.mcHandle);
                     }
                     param1.itemGrp.addChild(param1.itemGrp.mcHandle);
                  }
               }
            }
         }
      }
      
      public function colorMovieClip(param1:MovieClip, param2:Number) : void
      {
         var _loc3_:String = null;
         var _loc4_:ColorTransform = null;
         if(param2 > 0)
         {
            _loc3_ = GlobalAccess.stage.quality;
            if(this.runAsMobile)
            {
               GlobalAccess.stage.quality = "low";
            }
            _loc4_ = new ColorTransform();
            _loc4_.color = this.colorsDB[param2];
            param1.transform.colorTransform = _loc4_;
            param1.blendMode = BlendMode.OVERLAY;
            GlobalAccess.stage.quality = _loc3_;
         }
      }
      
      public function getClientInvertedDirection(param1:String) : String
      {
         var _loc2_:String = null;
         _loc2_ = param1;
         if(this.battle_clientInverted)
         {
            if(_loc2_ == "left")
            {
               _loc2_ = "right";
            }
            else
            {
               _loc2_ = "left";
            }
         }
         return _loc2_;
      }
      
      public function getClientInvertedStep(param1:Number) : Number
      {
         var _loc2_:Number = Number(NaN);
         _loc2_ = param1;
         if(this.battle_clientInverted)
         {
            _loc2_ = this.battleData.map.stepsTotal - 1 - param1;
         }
         return _loc2_;
      }
      
      public function mechMissingPartsForBattle(param1:BMMechStructure) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         _loc2_ = new Array();
         if(param1.torso == 0)
         {
            _loc2_.push("torso");
         }
         if(param1.leg == 0)
         {
            _loc2_.push("leg");
         }
         _loc3_ = true;
         _loc4_ = 1;
         while(_loc4_ <= this.maxEquipment["sideWeapon"])
         {
            if(_loc3_ == true)
            {
               _loc3_ = this.isMechReadyForBattleSub(param1["sideWeapon" + _loc4_]);
            }
            _loc4_++;
         }
         _loc4_ = 1;
         while(_loc4_ <= this.maxEquipment["topWeapon"])
         {
            if(_loc3_ == true)
            {
               _loc3_ = this.isMechReadyForBattleSub(param1["topWeapon" + _loc4_]);
            }
            _loc4_++;
         }
         if(_loc3_)
         {
            _loc2_.push("weapon");
         }
         return _loc2_;
      }
      
      private function isMechReadyForBattleSub(param1:Number) : Boolean
      {
         var _loc2_:Boolean = false;
         _loc2_ = true;
         if(param1 > 0)
         {
            _loc2_ = false;
         }
         return _loc2_;
      }
      
      public function getResistance(param1:Number, param2:Number, param3:Boolean) : Number
      {
         var _loc4_:Number = Number(NaN);
         var _loc5_:BMPlayerData = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc4_ = 0;
         _loc5_ = this.playersData[param1];
         if(param3)
         {
            _loc6_ = screensM.screenHangerMech.getTargetMechID();
         }
         else
         {
            _loc6_ = _loc5_.selectedMechID;
         }
         _loc4_ += this.getResistanceSub(param1,_loc6_,"torso",param2);
         _loc4_ += this.getResistanceSub(param1,_loc6_,"leg",param2);
         _loc7_ = 1;
         while(_loc7_ <= this.maxEquipment["module"])
         {
            _loc4_ += this.getResistanceSub(param1,_loc6_,"module" + _loc7_,param2);
            _loc7_++;
         }
         return _loc4_;
      }
      
      private function getResistanceSub(param1:Number, param2:uint, param3:String, param4:Number) : Number
      {
         var _loc5_:BMPlayerData = null;
         var _loc6_:BMMechStructure = null;
         var _loc7_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         var _loc9_:BMPlayerItemData = null;
         var _loc10_:BMItemData = null;
         _loc5_ = this.playersData[param1];
         _loc6_ = _loc5_.mechStructures[param2];
         _loc7_ = Number(_loc6_[param3]);
         _loc8_ = 0;
         if(_loc7_ > 0)
         {
            _loc9_ = this.getPlayerItemData(param1,_loc7_);
            _loc10_ = this.itemsDB[_loc9_.itemID];
            _loc8_ = Number(_loc10_["resist" + param4]);
         }
         return _loc8_;
      }
      
      public function isTutorialActive() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:BMPlayerProfile = null;
         _loc1_ = false;
         if(this.gameType == "guest" || this.gameType == "online")
         {
            _loc2_ = this["player" + this.player1PlayerID + "Profile"];
            if(_loc2_.tutorialLevel < this.tutorialLevelsDB.length)
            {
               _loc1_ = true;
            }
         }
         return _loc1_;
      }
      
      public function isTutorialSkippedRegularBattlesMode() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:BMPlayerProfile = null;
         _loc1_ = false;
         if(this.tutorialSkipped)
         {
            _loc2_ = this["player" + this.player1PlayerID + "Profile"];
            if(_loc2_.winsVSComputer < 2)
            {
               _loc1_ = true;
            }
         }
         return _loc1_;
      }
      
      public function setTutorialLevel(param1:Number, param2:String) : void
      {
         var _loc3_:BMPlayerProfile = null;
         _loc3_ = this["player" + this.player1PlayerID + "Profile"];
         if(_loc3_.tutorialLevel < param1)
         {
            if(this.tutorialLevelsDB[param1 + 1] == null)
            {
               param1 += 100;
            }
            _loc3_.tutorialLevel = param1;
            if(this.gameType == "online")
            {
               remoteM.lobby_setTutorialLevel(_loc3_.tutorialLevel);
            }
            this.saveGuestData("setTutorialLevel");
         }
      }
      
      public function openBuyTokensPage() : void
      {
         if(this.runAsMobile)
         {
            screensM.addScreen("screenBuyTokensMobile");
            screensM.screenBuyTokensMobile.refreshScreen();
         }
         else
         {
            screensM.addScreen("screenBuyTokensWeb");
            screensM.screenBuyTokensWeb.refreshScreen();
         }
      }
      
      public function openBuyTokensPage_payPalAndDao() : void
      {
         var _loc1_:LocalConnection = null;
         var _loc2_:* = undefined;
         _loc1_ = new LocalConnection();
         _loc2_ = _loc1_.domain;
         if(_loc2_ == "localhost" || _loc2_ == null)
         {
            _loc2_ = "supermechs.com";
         }
         if(_loc2_.substr(-14) != "supermechs.com")
         {
            _loc2_ = "supermechs.com";
         }
         this.openURL("https://" + _loc2_ + "/packages/","_blank");
         screensM.screenConfirmation.displayQuestionOrNotification("refreshBrowserAfterBuyingTokens");
      }
      
      public function openBuyTokensPage_fortumo() : void
      {
         this.openURL("http://pay.fortumo.com/mobile_payments/34b58cd1d222cad65f605f416ecee2a0?cuid=" + this.userID + "&service_id=34b58cd1d222cad65f605f416ecee2a0","_blank");
         screensM.screenConfirmation.displayQuestionOrNotification("refreshBrowserAfterBuyingTokens");
      }
      
      public function openBuyTokensPage_dao() : void
      {
         var _loc1_:LocalConnection = null;
         var _loc2_:* = undefined;
         var _loc3_:* = null;
         _loc1_ = new LocalConnection();
         _loc2_ = _loc1_.domain;
         if(_loc2_ == "localhost" || _loc2_ == null)
         {
            _loc2_ = "supermechs.com";
         }
         if(_loc2_.substr(-14) != "supermechs.com")
         {
            _loc2_ = "supermechs.com";
         }
         _loc3_ = "https://" + _loc2_ + "/services/tokenSystem/dp.php?package=1";
         this.openURL(_loc3_,"_blank");
         screensM.screenConfirmation.displayQuestionOrNotification("refreshBrowserAfterBuyingTokens");
      }
      
      public function openBuyTokensPage_paypal(param1:uint) : void
      {
         var _loc2_:LocalConnection = null;
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         _loc2_ = new LocalConnection();
         _loc3_ = _loc2_.domain;
         if(_loc3_ == "localhost" || _loc3_ == null)
         {
            _loc3_ = "supermechs.com";
         }
         if(_loc3_.substr(-14) != "supermechs.com")
         {
            _loc3_ = "supermechs.com";
         }
         _loc4_ = "https://" + _loc3_ + "/services/tokenSystem/pp.php?package=" + param1;
         this.openURL(_loc4_,"_blank");
         screensM.screenConfirmation.displayQuestionOrNotification("refreshBrowserAfterBuyingTokens");
      }
      
      public function getCurrentDomain() : String
      {
         var _loc1_:String = null;
         var _loc2_:LocalConnection = null;
         _loc1_ = "";
         _loc2_ = new LocalConnection();
         if(_loc2_ != null)
         {
            _loc1_ = _loc2_.domain;
         }
         return _loc1_;
      }
      
      public function getVectorAngle(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Number(NaN);
         _loc3_ = Math.atan2(param2,param1) * 180 / Math.PI;
         if(_loc3_ < 0)
         {
            _loc3_ += 360;
         }
         return _loc3_;
      }
      
      public function getVectorSize(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Number(NaN);
         return Math.sqrt(param1 * param1 + param2 * param2);
      }
      
      public function getVectorSizeOnXAxis(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Number(NaN);
         _loc3_ = param1 * Math.cos(param2 / 180 * Math.PI);
         if(Math.abs(_loc3_) < 0.0001)
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
      
      public function getVectorSizeOnYAxis(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Number(NaN);
         _loc3_ = param1 * Math.sin(param2 / 180 * Math.PI);
         if(Math.abs(_loc3_) < 0.0001)
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
      
      public function createGeneralDataBases() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:BMBoostData = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         this.animationDB = new Object();
         this.animationDB["stomp1"] = {
            "effectType":"stomp",
            "fireEffect":"stompFire1",
            "effectColor":"orange",
            "sound":"stomp1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["stomp2"] = {
            "effectType":"stomp",
            "fireEffect":"stompFire2",
            "effectColor":"red",
            "sound":"stomp1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["stomp3"] = {
            "effectType":"stomp",
            "fireEffect":"stompFire3",
            "effectColor":"blue",
            "sound":"stomp1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["sword1"] = {
            "effectType":"sword",
            "fireEffect":"",
            "effectColor":"orange",
            "sound":"",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["sword2"] = {
            "effectType":"sword",
            "fireEffect":"",
            "effectColor":"red",
            "sound":"",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["sword3"] = {
            "effectType":"sword",
            "fireEffect":"",
            "effectColor":"blue",
            "sound":"",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["shield1"] = {
            "effectType":"shield",
            "fireEffect":"",
            "effectColor":"orange",
            "sound":"",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["shield2"] = {
            "effectType":"shield",
            "fireEffect":"",
            "effectColor":"red",
            "sound":"",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["shield3"] = {
            "effectType":"shield",
            "fireEffect":"",
            "effectColor":"blue",
            "sound":"",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["shieldActivate"] = {
            "effectType":"shieldActivate",
            "fireEffect":"",
            "effectColor":"blue",
            "sound":"",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["bullet1"] = {
            "effectType":"projectile",
            "projectile":"bullet1",
            "fireEffect":"bulletFire1",
            "effectColor":"orange",
            "sound":"fireBullet1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["bullet2"] = {
            "effectType":"projectile",
            "projectile":"bullet2",
            "fireEffect":"bulletFire2",
            "effectColor":"orange",
            "sound":"fireBullet1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["bullet3"] = {
            "effectType":"projectile",
            "projectile":"bullet3",
            "fireEffect":"bulletFire3",
            "effectColor":"orange",
            "sound":"fireBullet2",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["grenade1"] = {
            "effectType":"grenade",
            "projectile":"grenade1",
            "fireEffect":"bulletFire1",
            "effectColor":"orange",
            "sound":"fireGrenade1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["grenade2"] = {
            "effectType":"grenade",
            "projectile":"grenade2",
            "fireEffect":"bulletFire1",
            "effectColor":"red",
            "sound":"fireGrenade1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["grenade3"] = {
            "effectType":"grenade",
            "projectile":"grenade3",
            "fireEffect":"bulletFire1",
            "effectColor":"blue",
            "sound":"fireGrenade1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["grenadePull1"] = {
            "effectType":"grenadePull",
            "projectile":"grenadePull1",
            "fireEffect":"bulletFire1",
            "effectColor":"orange",
            "sound":"fireGrenade1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["grenadePull2"] = {
            "effectType":"grenadePull",
            "projectile":"grenadePull2",
            "fireEffect":"bulletFire1",
            "effectColor":"red",
            "sound":"fireGrenade1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["grenadePull3"] = {
            "effectType":"grenadePull",
            "projectile":"grenadePull3",
            "fireEffect":"bulletFire1",
            "effectColor":"blue",
            "sound":"fireGrenade1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["bulletCharge1"] = {
            "effectType":"chargeProjectile",
            "projectile":"bulletCharge1",
            "fireEffect":"bulletFire1",
            "effectColor":"orange",
            "sound":"fireCharge1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["laser1"] = {
            "effectType":"projectile",
            "projectile":"laser1",
            "fireEffect":"laserFire1",
            "effectColor":"blue",
            "sound":"fireLaser1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["laser2"] = {
            "effectType":"projectile",
            "projectile":"laser2",
            "fireEffect":"laserFire2",
            "effectColor":"blue",
            "sound":"fireLaser2",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["laser3"] = {
            "effectType":"projectile",
            "projectile":"laser3",
            "fireEffect":"laserFire2",
            "effectColor":"blue",
            "sound":"fireBullet2",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["laserCharge1"] = {
            "effectType":"chargeProjectile",
            "projectile":"laserCharge1",
            "fireEffect":"laserFire1",
            "effectColor":"blue",
            "sound":"fireCharge2",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["heat1"] = {
            "effectType":"projectile",
            "projectile":"heat1",
            "fireEffect":"heatFire1",
            "effectColor":"red",
            "sound":"fireLaser2",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["heat2"] = {
            "effectType":"projectile",
            "projectile":"heat2",
            "fireEffect":"heatFire2",
            "effectColor":"red",
            "sound":"fireLaser2",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["heat3"] = {
            "effectType":"projectile",
            "projectile":"heat2",
            "fireEffect":"heatFire2",
            "effectColor":"red",
            "sound":"fireBullet2",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["heatCharge1"] = {
            "effectType":"chargeProjectile",
            "projectile":"heatCharge1",
            "fireEffect":"heatFire1",
            "effectColor":"red",
            "sound":"fireCharge3",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["machineGun1"] = {
            "effectType":"immediate1",
            "fireEffect":"machineGunFire1",
            "effectColor":"orange",
            "sound":"fireMachineGun1",
            "getHitSoundsLength":40,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":"mcBulletShell1"
         };
         this.animationDB["machineGun2"] = {
            "effectType":"immediate1",
            "fireEffect":"machineGunFire2",
            "effectColor":"orange",
            "sound":"fireMachineGun2",
            "getHitSoundsLength":40,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":"mcBulletShell1"
         };
         this.animationDB["machineGun3"] = {
            "effectType":"immediate1",
            "fireEffect":"machineGunFire3",
            "effectColor":"orange",
            "sound":"fireMachineGun2",
            "getHitSoundsLength":40,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":"mcBulletShell1"
         };
         this.animationDB["shotgun1"] = {
            "effectType":"immediate2",
            "fireEffect":"shotgunFire1",
            "effectColor":"orange",
            "sound":"fireShotgun1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"mcBulletShell2",
            "bulletShellsFrames":""
         };
         this.animationDB["shotgun2"] = {
            "effectType":"immediate2",
            "fireEffect":"shotgunFire2",
            "effectColor":"red",
            "sound":"fireShotgun1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"mcBulletShell2",
            "bulletShellsFrames":""
         };
         this.animationDB["shotgun3"] = {
            "effectType":"immediate2",
            "fireEffect":"shotgunFire3",
            "effectColor":"blue",
            "sound":"fireShotgun1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"mcBulletShell2",
            "bulletShellsFrames":""
         };
         this.animationDB["rocketBarrage1"] = {
            "effectType":"rocket",
            "rocket":"rocket1",
            "fireEffect":"rocketFire1",
            "effectColor":"orange",
            "sound":"fireRocket1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["rocketBarrage2"] = {
            "effectType":"rocketMassive",
            "rocket":"rocket2",
            "fireEffect":"rocketFire2",
            "effectColor":"orange",
            "sound":"fireRocket2",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["rocketBarrage3"] = {
            "effectType":"rocketStraight",
            "rocket":"rocket1",
            "fireEffect":"rocketFire1",
            "effectColor":"orange",
            "sound":"fireRocket1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["artilleryBarrage1"] = {
            "effectType":"artillery",
            "rocket":"rocket1",
            "fireEffect":"rocketFire1",
            "effectColor":"orange",
            "sound":"fireRocket2",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["artilleryDiagonal1"] = {
            "effectType":"artilleryDiagonal",
            "rocket":"rocket1",
            "fireEffect":"rocketFire1",
            "effectColor":"orange",
            "sound":"fireRocket2",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["flame1"] = {
            "effectType":"flame",
            "fireEffect":"flameFire1",
            "effectColor":"orange",
            "sound":"flameThrower",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["flame2"] = {
            "effectType":"flame",
            "fireEffect":"flameFireB1",
            "effectColor":"blue",
            "sound":"flameThrower",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["flame3"] = {
            "effectType":"flame",
            "fireEffect":"flameFireC1",
            "effectColor":"green",
            "sound":"flameThrower",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["flame4"] = {
            "effectType":"flame",
            "fireEffect":"flameFireD1",
            "effectColor":"purple",
            "sound":"flameThrower",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["beamRed1"] = {
            "effectType":"beam",
            "size":1,
            "effectShape":"straight",
            "effectColor":"red",
            "sound":"fireCharge1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["beamRed2"] = {
            "effectType":"beam",
            "size":2,
            "effectShape":"straight",
            "effectColor":"red",
            "sound":"fireCharge1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["beamBlue1"] = {
            "effectType":"beam",
            "size":1,
            "effectShape":"straight",
            "effectColor":"blue",
            "sound":"fireCharge1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["beamBlue2"] = {
            "effectType":"beam",
            "size":2,
            "effectShape":"straight",
            "effectColor":"blue",
            "sound":"fireCharge1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["beamYellow1"] = {
            "effectType":"beam",
            "size":1,
            "effectShape":"straight",
            "effectColor":"orange",
            "sound":"fireCharge1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["beamYellow2"] = {
            "effectType":"beam",
            "size":2,
            "effectShape":"straight",
            "effectColor":"orange",
            "sound":"fireCharge1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["beamRoundRed1"] = {
            "effectType":"beam",
            "size":1,
            "effectShape":"round",
            "effectColor":"red",
            "sound":"fireCharge1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["beamRoundRed2"] = {
            "effectType":"beam",
            "size":2,
            "effectShape":"round",
            "effectColor":"red",
            "sound":"fireCharge1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["beamRoundBlue1"] = {
            "effectType":"beam",
            "size":1,
            "effectShape":"round",
            "effectColor":"blue",
            "sound":"fireCharge1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["beamRoundBlue2"] = {
            "effectType":"beam",
            "size":2,
            "effectShape":"round",
            "effectColor":"blue",
            "sound":"fireCharge1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["beamRoundYellow1"] = {
            "effectType":"beam",
            "size":1,
            "effectShape":"round",
            "effectColor":"orange",
            "sound":"fireCharge1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["beamRoundYellow2"] = {
            "effectType":"beam",
            "size":2,
            "effectShape":"round",
            "effectColor":"orange",
            "sound":"fireCharge1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["orbRed1"] = {
            "effectType":"orb",
            "projectile":"orbRed1",
            "fireEffect":"orbFireRed1",
            "effectColor":"red",
            "sound":"fireGrenade1",
            "tailEffect":"orbTailRed1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["orbBlue1"] = {
            "effectType":"orb",
            "projectile":"orbBlue1",
            "fireEffect":"orbFireBlue1",
            "effectColor":"blue",
            "sound":"fireGrenade1",
            "tailEffect":"orbTailBlue1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["orbOrange1"] = {
            "effectType":"orb",
            "projectile":"orbOrange1",
            "fireEffect":"orbFireOrange1",
            "effectColor":"orange",
            "sound":"fireGrenade1",
            "tailEffect":"orbTailOrange1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["shockWaveBlue1"] = {
            "effectType":"shockWave",
            "projectile":"shockWaveShotBlue1",
            "fireEffect":"laserFire2",
            "effectColor":"blue",
            "sound":"fireLaser3",
            "tailEffect":"shockWaveTailBlue1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["shockWaveRed1"] = {
            "effectType":"shockWave",
            "projectile":"shockWaveShotRed1",
            "fireEffect":"heatFire2",
            "effectColor":"red",
            "sound":"fireLaser3",
            "tailEffect":"shockWaveTailRed1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["shockWaveOrange1"] = {
            "effectType":"shockWave",
            "projectile":"shockWaveShotOrange1",
            "fireEffect":"bulletFire3",
            "effectColor":"orange",
            "sound":"fireLaser3",
            "tailEffect":"shockWaveTailOrange1",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["specialPhysical1"] = {
            "effectType":"megaProjectile",
            "projectile":"bullet4",
            "fireEffect":"bulletFire3",
            "tailEffect":"smallExplosionAnim1",
            "effectColor":"orange",
            "sound":"fireLaser2",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["specialExplosive1"] = {
            "effectType":"megaProjectile",
            "projectile":"heat3",
            "fireEffect":"heatFire2",
            "tailEffect":"electricityRedBig1",
            "effectColor":"red",
            "sound":"fireLaser2",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["specialElectric1"] = {
            "effectType":"megaProjectile",
            "projectile":"laser2",
            "fireEffect":"laserFire1",
            "tailEffect":"electricityBig1",
            "effectColor":"blue",
            "sound":"fireLaser2",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":0,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.animationDB["repair1"] = {
            "effectType":"repair",
            "fireEffect":"repair1",
            "effectColor":"blue",
            "sound":"fireLaser2",
            "getHitSoundsLength":0,
            "droneOnHoldFrames":40,
            "bulletShellsInstant":"",
            "bulletShellsFrames":""
         };
         this.itemTypesDB = new Array();
         this.itemTypesDB[0] = "torso";
         this.itemTypesDB[1] = "leg";
         this.itemTypesDB[2] = "sideWeapon";
         this.itemTypesDB[3] = "topWeapon";
         this.itemTypesDB[4] = "drone";
         this.itemTypesDB[5] = "shield";
         this.itemTypesDB[6] = "teleport";
         this.itemTypesDB[7] = "charge";
         this.itemTypesDB[8] = "harpoon";
         this.itemTypesDB[9] = "module";
         this.itemTypesDB[10] = "kit";
         this.itemTypesReverseDB = new Array();
         this.itemTypesReverseDB["torso"] = 0;
         this.itemTypesReverseDB["leg"] = 1;
         this.itemTypesReverseDB["sideWeapon"] = 2;
         this.itemTypesReverseDB["topWeapon"] = 3;
         this.itemTypesReverseDB["drone"] = 4;
         this.itemTypesReverseDB["shield"] = 5;
         this.itemTypesReverseDB["teleport"] = 6;
         this.itemTypesReverseDB["charge"] = 7;
         this.itemTypesReverseDB["harpoon"] = 8;
         this.itemTypesReverseDB["module"] = 9;
         this.itemTypesReverseDB["kit"] = 10;
         this.shopItemTypesDB = new Array();
         this.shopItemTypesDB[0] = "torsoLeg";
         this.shopItemTypesDB[1] = "sideWeapon";
         this.shopItemTypesDB[2] = "topWeapon";
         this.shopItemTypesDB[3] = "specialModule";
         this.shopItemTypesDB[4] = "kit";
         if(this.runAsMobile)
         {
            this.shopItemTypesDB[0] = "torso";
            this.shopItemTypesDB[1] = "leg";
            this.shopItemTypesDB[2] = "sideWeapon";
            this.shopItemTypesDB[3] = "topWeapon";
            this.shopItemTypesDB[4] = "special";
            this.shopItemTypesDB[5] = "module";
            this.shopItemTypesDB[6] = "kit";
         }
         this.shopItemTypesReverseDB = new Array();
         this.shopItemTypesReverseDB["torsoLeg"] = 0;
         this.shopItemTypesReverseDB["torso"] = 0;
         this.shopItemTypesReverseDB["leg"] = 0;
         this.shopItemTypesReverseDB["sideWeapon"] = 1;
         this.shopItemTypesReverseDB["topWeapon"] = 2;
         this.shopItemTypesReverseDB["specialModule"] = 3;
         this.shopItemTypesReverseDB["drone"] = 3;
         this.shopItemTypesReverseDB["shield"] = 3;
         this.shopItemTypesReverseDB["teleport"] = 3;
         this.shopItemTypesReverseDB["charge"] = 3;
         this.shopItemTypesReverseDB["harpoon"] = 3;
         this.shopItemTypesReverseDB["module"] = 3;
         this.shopItemTypesReverseDB["kit"] = 4;
         if(this.runAsMobile)
         {
            this.shopItemTypesReverseDB["torso"] = 0;
            this.shopItemTypesReverseDB["leg"] = 1;
            this.shopItemTypesReverseDB["sideWeapon"] = 2;
            this.shopItemTypesReverseDB["topWeapon"] = 3;
            this.shopItemTypesReverseDB["drone"] = 4;
            this.shopItemTypesReverseDB["shield"] = 4;
            this.shopItemTypesReverseDB["teleport"] = 4;
            this.shopItemTypesReverseDB["charge"] = 4;
            this.shopItemTypesReverseDB["harpoon"] = 4;
            this.shopItemTypesReverseDB["special"] = 4;
            this.shopItemTypesReverseDB["module"] = 5;
            this.shopItemTypesReverseDB["kit"] = 6;
         }
         this.shopItemTypesSourceDB = new Array();
         this.shopItemTypesSourceDB[0] = {
            "source":"items1",
            "iconName":"torsoLeg"
         };
         this.shopItemTypesSourceDB[1] = {
            "source":"items2",
            "iconName":"sideWeapon"
         };
         this.shopItemTypesSourceDB[2] = {
            "source":"items2",
            "iconName":"topWeapon"
         };
         this.shopItemTypesSourceDB[3] = {
            "source":"items3",
            "iconName":"specialModule"
         };
         this.shopItemTypesSourceDB[4] = {
            "source":"items3",
            "iconName":"kit"
         };
         if(this.runAsMobile)
         {
            this.shopItemTypesSourceDB[0] = {
               "source":"items1",
               "iconName":"torso"
            };
            this.shopItemTypesSourceDB[1] = {
               "source":"items1",
               "iconName":"leg"
            };
            this.shopItemTypesSourceDB[2] = {
               "source":"items2",
               "iconName":"sideWeapon"
            };
            this.shopItemTypesSourceDB[3] = {
               "source":"items2",
               "iconName":"topWeapon"
            };
            this.shopItemTypesSourceDB[4] = {
               "source":"items1",
               "iconName":"special"
            };
            this.shopItemTypesSourceDB[5] = {
               "source":"items3",
               "iconName":"module"
            };
            this.shopItemTypesSourceDB[6] = {
               "source":"items3",
               "iconName":"kit"
            };
         }
         this.maxEquipment = new Object();
         this.maxEquipment["sideWeapon"] = this.MAX_SIDE_WEAPONS;
         this.maxEquipment["topWeapon"] = this.MAX_TOP_WEAPONS;
         this.maxEquipment["drone"] = this.MAX_DRONES;
         this.maxEquipment["shield"] = this.MAX_SHIELDS;
         this.maxEquipment["teleport"] = this.MAX_TELEPORTS;
         this.maxEquipment["charge"] = this.MAX_CHARGES;
         this.maxEquipment["harpoon"] = this.MAX_HARPOONS;
         this.maxEquipment["module"] = this.MAX_MODULES;
         this.maxEquipment["kit"] = this.MAX_KITS;
         this.maxEquipment["taunt"] = this.MAX_TAUNTS;
         this.ladderRankIconsDB = new Array();
         this.ladderRankIconsDB[20] = 1;
         this.ladderRankIconsDB[19] = 2;
         this.ladderRankIconsDB[18] = 3;
         this.ladderRankIconsDB[17] = 4;
         this.ladderRankIconsDB[16] = 5;
         this.ladderRankIconsDB[15] = 24;
         this.ladderRankIconsDB[14] = 25;
         this.ladderRankIconsDB[13] = 26;
         this.ladderRankIconsDB[12] = 33;
         this.ladderRankIconsDB[11] = 34;
         this.ladderRankIconsDB[10] = 35;
         this.ladderRankIconsDB[9] = 40;
         this.ladderRankIconsDB[8] = 41;
         this.ladderRankIconsDB[7] = 42;
         this.ladderRankIconsDB[6] = 56;
         this.ladderRankIconsDB[5] = 57;
         this.ladderRankIconsDB[4] = 59;
         this.ladderRankIconsDB[3] = 60;
         this.ladderRankIconsDB[2] = 61;
         this.ladderRankIconsDB[1] = 62;
         this.replayActionsDB = new Object();
         this.replayActionsDB["FW"] = "fireWeapon";
         this.replayActionsDB["SH"] = "shutDown";
         this.replayActionsDB["CM"] = "changeMech";
         this.replayActionsDB["KI"] = "useKit";
         this.replayActionsDB["WL"] = "walkLeft";
         this.replayActionsDB["WR"] = "walkRight";
         this.replayActionsDB["JL"] = "jumpLeft";
         this.replayActionsDB["JR"] = "jumpRight";
         this.replayActionsDB["TP"] = "teleport";
         this.replayActionsDB["CH"] = "charge";
         this.replayActionsDB["HR"] = "harpoon";
         this.replayActionsDB["DA"] = "activateDrone";
         this.replayActionsDB["DD"] = "deactivateDrone";
         this.replayActionsDB["SA"] = "activateShield";
         this.replayActionsDB["SD"] = "deactivateShield";
         this.createInfoTextDB();
         this.levelUpDB = new Array();
         this.levelUpDB[0] = 0;
         this.levelUpDB[1] = 0;
         this.levelUpDB[2] = 75;
         this.levelUpDB[3] = 200;
         this.levelUpDB[4] = 550;
         this.levelUpDB[5] = 950;
         this.levelUpDB[6] = 1400;
         this.levelUpDB[7] = 1900;
         this.levelUpDB[8] = 2450;
         this.levelUpDB[9] = 3050;
         this.levelUpDB[10] = 3700;
         this.levelUpDB[11] = 4400;
         this.levelUpDB[12] = 5150;
         this.levelUpDB[13] = 5950;
         this.levelUpDB[14] = 6850;
         this.levelUpDB[15] = 7850;
         this.levelUpDB[16] = 8950;
         this.levelUpDB[17] = 10150;
         this.levelUpDB[18] = 11450;
         this.levelUpDB[19] = 12900;
         this.levelUpDB[20] = 14500;
         this.levelUpDB[21] = 16250;
         this.levelUpDB[22] = 18150;
         this.levelUpDB[23] = 20200;
         this.levelUpDB[24] = 22400;
         this.levelUpDB[25] = 24750;
         this.levelUpDB[26] = 27250;
         this.levelUpDB[27] = 29900;
         this.levelUpDB[28] = 32700;
         this.levelUpDB[29] = 35650;
         this.levelUpDB[30] = 38600;
         this.levelUpDB[31] = 98536;
         this.levelUpDB[32] = 116830;
         this.levelUpDB[33] = 139697;
         this.levelUpDB[34] = 167138;
         this.levelUpDB[35] = 199153;
         this.levelUpDB[36] = 99999999;
         this.itemTypeSourceDB = new Array();
         this.itemTypeSourceDB["torso"] = "items1";
         this.itemTypeSourceDB["leg"] = "items1";
         this.itemTypeSourceDB["sideWeapon"] = "items2";
         this.itemTypeSourceDB["topWeapon"] = "items2";
         this.itemTypeSourceDB["drone"] = "items1";
         this.itemTypeSourceDB["shield"] = "items3";
         this.itemTypeSourceDB["teleport"] = "items3";
         this.itemTypeSourceDB["charge"] = "items3";
         this.itemTypeSourceDB["harpoon"] = "items3";
         this.itemTypeSourceDB["module"] = "items3";
         this.itemTypeSourceDB["kit"] = "items3";
         this.techDB = new Object();
         this.techDB["drone"] = {
            "name":"Drone",
            "maxLevel":1
         };
         this.techDB["shield"] = {
            "name":"Shield",
            "maxLevel":1
         };
         this.techDB["teleport"] = {
            "name":"Teleport",
            "maxLevel":1
         };
         this.techDB["charge"] = {
            "name":"Charge",
            "maxLevel":1
         };
         this.techDB["harpoon"] = {
            "name":"Grappling hook",
            "maxLevel":1
         };
         this.techDB["damage1"] = {
            "name":"Physical damage mastery",
            "maxLevel":12,
            "damageType":1,
            "addon":2,
            "addonText1":"+",
            "addonText2":" to physical damage",
            "color":"FFCC00"
         };
         this.techDB["damage2"] = {
            "name":"Explosive damage mastery",
            "maxLevel":12,
            "damageType":1,
            "addon":2,
            "addonText1":"+",
            "addonText2":" to explosive damage",
            "color":"FF6600"
         };
         this.techDB["damage3"] = {
            "name":"Electric damage mastery",
            "maxLevel":12,
            "damageType":1,
            "addon":2,
            "addonText1":"+",
            "addonText2":" to electric damage",
            "color":"00CCFF"
         };
         this.techDB["resist1"] = {
            "name":"Physical resistance mastery",
            "maxLevel":12,
            "damageType":1,
            "addon":2,
            "addonText1":"+",
            "addonText2":" to physical resistance",
            "color":"FFCC00"
         };
         this.techDB["resist1Gain"] = {
            "name":"Physical resistance recovery",
            "maxLevel":12,
            "damageType":1,
            "addon":2,
            "addonText1":"+",
            "addonText2":" to physical resistance restored",
            "color":"FFCC00"
         };
         this.techDB["resist2"] = {
            "name":"Explosive resistance mastery",
            "maxLevel":12,
            "damageType":1,
            "addon":2,
            "addonText1":"+",
            "addonText2":" to explosive resistance restored",
            "color":"FF6600"
         };
         this.techDB["resist2Gain"] = {
            "name":"Explosive resistance recovery",
            "maxLevel":12,
            "damageType":1,
            "addon":2,
            "addonText1":"+",
            "addonText2":" to explosive resistance restored",
            "color":"FF6600"
         };
         this.techDB["resist3"] = {
            "name":"Electric resistance mastery",
            "maxLevel":12,
            "damageType":1,
            "addon":2,
            "addonText1":"+",
            "addonText2":" to electric resistance",
            "color":"00CCFF"
         };
         this.techDB["resist3Gain"] = {
            "name":"Electric resistance recovery",
            "maxLevel":12,
            "damageType":1,
            "addon":2,
            "addonText1":"+",
            "addonText2":" to electric resistance restored",
            "color":"00CCFF"
         };
         this.techDB["extraPhase"] = {
            "name":"Extra Action Point",
            "maxLevel":12,
            "damageType":1,
            "addon":2,
            "addonText1":"+",
            "addonText2":" to Action Point",
            "color":"00CCFF"
         };
         this.techDB["critical"] = {
            "name":"Critical damage mastery",
            "maxLevel":12,
            "damageType":1,
            "addon":2,
            "addonText1":"",
            "addonText2":"% for critical hit",
            "color":"FFCC00"
         };
         this.techDB["stomp"] = {
            "name":"Stomp damage addon",
            "maxLevel":12,
            "damageType":1,
            "addon":2,
            "addonText1":"+",
            "addonText2":"% stomp damage",
            "color":"FFCC00"
         };
         this.techDB["discount"] = {
            "name":"Shop discount",
            "maxLevel":12,
            "damageType":1,
            "addon":2,
            "addonText1":"",
            "addonText2":"% discount",
            "color":"FF9900"
         };
         this.createTipsDB();
         this.createMusicData();
         this.createBattleInterfaceToolTipDB();
         this.colorsDB = new Array();
         this.colorsDB[1] = 4291559424;
         this.colorsDB[2] = 4278216345;
         this.colorsDB[3] = 4284900864;
         this.colorsDB[4] = 4292892928;
         this.colorsDB[5] = 4292269782;
         this.colorsDB[6] = 4288230246;
         this.colorsDB[7] = 4283705856;
         this.colorsDB[8] = 4294950656;
         this.colorsDB[9] = 4280361249;
         this.colorsDB[11] = 4288510017;
         this.colorsDB[12] = 4291856671;
         this.colorsDB[13] = 4294609408;
         this.colorsDB[14] = 4294079232;
         this.colorsDB[15] = 4293150976;
         this.colorsDB[16] = 4292288768;
         this.colorsDB[17] = 4290510848;
         this.colorsDB[18] = 4287954944;
         this.colorsDB[19] = 4284416000;
         this.colorsDB[20] = 4278321152;
         this.colorsDB[21] = 4282339840;
         this.colorsDB[100] = 4288217088;
         this.colorsDB[101] = 4278216396;
         this.colorsDB[102] = 4278216345;
         this.colorsDB[103] = 4292367872;
         this.colorsDB[201] = 4278190080;
         this.colorsDB[202] = 4281545523;
         this.colorsDB[203] = 4284900966;
         this.colorsDB[204] = 4288256409;
         this.colorsDB[205] = 4294967295;
         this.colorsDB[206] = 4288230246;
         this.colorsDB[207] = 4291585587;
         this.colorsDB[208] = 4288217088;
         this.colorsDB[209] = 4294901760;
         this.colorsDB[210] = 4294927872;
         this.colorsDB[211] = 4294940928;
         this.colorsDB[212] = 4281571584;
         this.colorsDB[213] = 4278216192;
         this.colorsDB[214] = 4284900864;
         this.colorsDB[215] = 4278216294;
         this.colorsDB[216] = 4278216345;
         this.colorsDB[217] = 4278203238;
         this.colorsDB[218] = 4281545472;
         this.itemIDsForbiddenForPC = new Object();
         this.itemIDsForbiddenForPC[1058] = true;
         this.itemIDsForbiddenForPC[1059] = true;
         this.itemIDsForbiddenForPC[1060] = true;
         this.itemIDsForbiddenForPC[1061] = true;
         this.itemIDsForbiddenForPC[1062] = true;
         this.boostsDB = new Array();
         _loc2_ = new BMBoostData();
         _loc2_.initialize(2,getSpecificText("packages_itemsBoxGold"),"randomItems",0,0,0,85000,5,0,20,0,0,0,90,1,0,0,0,0,0,0,0);
         this.boostsDB[2] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(3,getSpecificText("packages_silver"),"resources",75,75,0,0,0,100000,0,0,0,0,0,0,0,0,0,0,0,0,0);
         this.boostsDB[3] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(4,getSpecificText("packages_gold"),"resources",250,250,0,0,0,350000,0,0,0,0,0,0,0,0,0,0,0,0,0);
         this.boostsDB[4] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(9,getSpecificText("packages_itemsBox"),"randomItems",0,0,0,2500,5,0,5,5,40,15,8,1,40,15,8,1,0,0,0);
         this.boostsDB[9] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(5,getSpecificText("packages_itemsBoxSilver"),"randomItems",0,0,0,5000,5,0,5,5,45,35,17,1,45,35,17,1,0,0,0);
         this.boostsDB[5] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(6,getSpecificText("packages_itemsBoxGold"),"randomItems",0,0,0,12000,5,0,5,5,20,30,45,1,20,30,45,1,0,0,0);
         this.boostsDB[6] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(11,getSpecificText("packages_itemsBox"),"randomItems",0,0,0,500000,5,0,5,5,55,12,4,3,55,12,4,3,0,0,0);
         this.boostsDB[11] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(12,getSpecificText("packages_itemsBox"),"randomItems",0,0,0,500000,5,0,5,5,60,14,5,5,60,14,5,5,0,0,0);
         this.boostsDB[12] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(19,getSpecificText("packages_itemsBoxMythical"),"randomItems",400,400,5,0,0,0,2,2,0,0,0,100,0,0,0,100,0,0,0);
         this.boostsDB[19] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(20,getSpecificText("packages_itemsBoxMythical"),"randomItems",215,215,5,0,0,0,1,2,0,0,0,100,0,0,0,100,0,0,0);
         this.boostsDB[20] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(8,getSpecificText("packages_premiumAccount"),"premiumAccount",40,40,86400,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
         this.boostsDB[8] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(10,getSpecificText("packages_premiumAccount"),"premiumAccount",100,100,604800,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
         this.boostsDB[10] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(1,getSpecificText("packages_premiumAccount"),"premiumAccount",250,250,2592000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
         this.boostsDB[1] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(14,"","specificItem",150,150,2592000,0,892,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
         this.boostsDB[14] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(15,"","specificItem",150,150,2592000,0,920,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
         this.boostsDB[15] = _loc2_;
         _loc2_ = new BMBoostData();
         _loc2_.initialize(16,"","freeTokens",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
         this.boostsDB[16] = _loc2_;
         this.itemTypeSortDB = new Object();
         this.itemTypeSortDB["torso"] = 10000;
         this.itemTypeSortDB["leg"] = 10050;
         this.itemTypeSortDB["sideWeapon"] = 30000;
         this.itemTypeSortDB["topWeapon"] = 40000;
         this.itemTypeSortDB["drone"] = 50000;
         this.itemTypeSortDB["shield"] = 60000;
         this.itemTypeSortDB["teleport"] = 70000;
         this.itemTypeSortDB["charge"] = 80000;
         this.itemTypeSortDB["harpoon"] = 90000;
         this.itemTypeSortDB["module"] = 110000;
         this.itemTypeSortDB["kit"] = 120000;
         this.createPowerLevelsDB();
         this.subTypeOriginDB = new Object();
         this.subTypeOriginDB["torso"] = ["torso"];
         this.subTypeOriginDB["leg"] = ["leg"];
         this.subTypeOriginDB["sideWeapon_physical"] = ["sideWeapon_physical"];
         this.subTypeOriginDB["sideWeapon_explosive"] = ["sideWeapon_explosive"];
         this.subTypeOriginDB["sideWeapon_electric"] = ["sideWeapon_electric"];
         this.subTypeOriginDB["sideWeapon_melee"] = ["sideWeapon_melee"];
         this.subTypeOriginDB["topWeapon_physical"] = ["topWeapon_physical"];
         this.subTypeOriginDB["topWeapon_explosive"] = ["topWeapon_explosive"];
         this.subTypeOriginDB["topWeapon_electric"] = ["topWeapon_electric"];
         this.subTypeOriginDB["drone"] = ["drone"];
         this.subTypeOriginDB["shield"] = ["shield"];
         this.subTypeOriginDB["teleport"] = ["specials"];
         this.subTypeOriginDB["charge"] = ["specials"];
         this.subTypeOriginDB["harpoon"] = ["specials"];
         this.subTypeOriginDB["module_armor"] = ["module_armorResistance"];
         this.subTypeOriginDB["module_energyHeat"] = ["module_energyHeat"];
         this.subTypeOriginDB["module_ammo"] = ["module_bulletsRockets"];
         this.subTypeOriginDB["module_resistance"] = ["module_armorResistance"];
         this.subTypeOriginDB["module_multi"] = ["module_multi"];
         this.subTypeOriginDB["kit_repair"] = ["kit_repairResistance"];
         this.subTypeOriginDB["kit_energyHeat"] = ["kit_energyHeat"];
         this.subTypeOriginDB["kit_ammo"] = ["kit_bulletsRockets"];
         this.subTypeOriginDB["kit_resistance"] = ["kit_repairResistance"];
         this.subTypeOriginDB["kit_power"] = ["kit_power"];
         this.subTypeOriginDB["kit_color"] = ["kit_color"];
         this.subTypeOriginDB_myth = new Object();
         this.subTypeOriginDB_myth["torso"] = ["torso"];
         this.subTypeOriginDB_myth["leg"] = ["leg"];
         this.subTypeOriginDB_myth["sideWeapon_physical"] = ["sideWeapon_physical"];
         this.subTypeOriginDB_myth["sideWeapon_explosive"] = ["sideWeapon_explosive"];
         this.subTypeOriginDB_myth["sideWeapon_electric"] = ["sideWeapon_electric"];
         this.subTypeOriginDB_myth["sideWeapon_melee"] = ["sideWeapon_melee"];
         this.subTypeOriginDB_myth["topWeapon_physical"] = ["topWeapon_physical"];
         this.subTypeOriginDB_myth["topWeapon_explosive"] = ["topWeapon_explosive"];
         this.subTypeOriginDB_myth["topWeapon_electric"] = ["topWeapon_electric"];
         this.subTypeOriginDB_myth["drone"] = ["drone"];
         this.subTypeOriginDB_myth["shield"] = ["shield"];
         this.subTypeOriginDB_myth["teleport"] = ["specials"];
         this.subTypeOriginDB_myth["charge"] = ["specials"];
         this.subTypeOriginDB_myth["harpoon"] = ["specials"];
         this.subTypeOriginDB_myth["module_armor"] = ["module_armorResistance"];
         this.subTypeOriginDB_myth["module_energyHeat"] = ["module_energyHeat"];
         this.subTypeOriginDB_myth["module_ammo"] = ["module_bulletsRockets"];
         this.subTypeOriginDB_myth["module_resistance"] = ["module_armorResistance"];
         this.subTypeOriginDB_combined = new Object();
         this.subTypeOriginDB_combined["box_regular"] = ["box_regular"];
         this.subTypeOriginDB_combined["box_gold"] = ["box_gold"];
         this.subTypeOriginDB_combined["box_mythical"] = ["box_mythical"];
         this.subTypeOriginDB_combined["premiumAccount"] = ["premiumAccount"];
         this.subTypeOriginDB_combined["gold"] = ["gold"];
         this.subTypeOriginDB_combined["kit_repairResistance"] = ["kit_repairResistance"];
         this.subTypeOriginDB_combined["kit_energyHeat"] = ["kit_energyHeat"];
         this.subTypeOriginDB_combined["kit_bulletsRockets"] = ["kit_bulletsRockets"];
         this.subTypeOriginDB_combined["kit_power"] = ["kit_power"];
         this.subTypeOriginDB_combined["kit_color"] = ["kit_color"];
         this.subTypeDB = new Object();
         this.subTypeDB["torso"] = {
            "ID":1,
            "source":"items1",
            "name":"torso",
            "unlockLevel":1
         };
         this.subTypeDB["leg"] = {
            "ID":2,
            "source":"items1",
            "name":"leg",
            "unlockLevel":1
         };
         this.subTypeDB["sideWeapon_physical"] = {
            "ID":3,
            "source":"items2",
            "name":"sideWeapon_physical",
            "unlockLevel":1
         };
         this.subTypeDB["sideWeapon_explosive"] = {
            "ID":4,
            "source":"items2",
            "name":"sideWeapon_explosive",
            "unlockLevel":3
         };
         this.subTypeDB["sideWeapon_electric"] = {
            "ID":5,
            "source":"items2",
            "name":"sideWeapon_electric",
            "unlockLevel":2
         };
         this.subTypeDB["sideWeapon_melee"] = {
            "ID":6,
            "source":"items2",
            "name":"sideWeapon_melee",
            "unlockLevel":3
         };
         this.subTypeDB["topWeapon_physical"] = {
            "ID":7,
            "source":"items2",
            "name":"topWeapon_physical",
            "unlockLevel":3
         };
         this.subTypeDB["topWeapon_explosive"] = {
            "ID":8,
            "source":"items2",
            "name":"topWeapon_explosive",
            "unlockLevel":3
         };
         this.subTypeDB["topWeapon_electric"] = {
            "ID":9,
            "source":"items2",
            "name":"topWeapon_electric",
            "unlockLevel":2
         };
         this.subTypeDB["drone"] = {
            "ID":10,
            "source":"items1",
            "name":"drone",
            "unlockLevel":3
         };
         this.subTypeDB["shield"] = {
            "ID":11,
            "source":"items3",
            "name":"shield",
            "unlockLevel":5
         };
         this.subTypeDB["specials"] = {
            "ID":12,
            "source":"items3",
            "name":"specials",
            "unlockLevel":4
         };
         this.subTypeDB["module_armorResistance"] = {
            "ID":13,
            "source":"items3",
            "name":"module_armorResistance",
            "unlockLevel":3
         };
         this.subTypeDB["module_energyHeat"] = {
            "ID":14,
            "source":"items3",
            "name":"module_energyHeat",
            "unlockLevel":3
         };
         this.subTypeDB["module_bulletsRockets"] = {
            "ID":15,
            "source":"items3",
            "name":"module_bulletsRockets",
            "unlockLevel":2
         };
         this.subTypeDB["module_multi"] = {
            "ID":21,
            "source":"items3",
            "name":"module_multi",
            "unlockLevel":5
         };
         this.subTypeDB["kit_repairResistance"] = {
            "ID":16,
            "source":"items3",
            "name":"kit_repairResistance",
            "unlockLevel":2
         };
         this.subTypeDB["kit_energyHeat"] = {
            "ID":17,
            "source":"items3",
            "name":"kit_energyHeat",
            "unlockLevel":3
         };
         this.subTypeDB["kit_bulletsRockets"] = {
            "ID":18,
            "source":"items3",
            "name":"kit_bulletsRockets",
            "unlockLevel":3
         };
         this.subTypeDB["kit_power"] = {
            "ID":19,
            "source":"items3",
            "name":"kit_power",
            "unlockLevel":3
         };
         this.subTypeDB["kit_color"] = {
            "ID":20,
            "source":"items3",
            "name":"kit_color",
            "unlockLevel":3
         };
         for each(_loc3_ in this.subTypeDB)
         {
            _loc3_.text = getSpecificText("shop_" + _loc3_.name);
         }
         this.SUB_TYPE_SIDE_WEAPON_PHYSICAL = 3;
         this.SUB_TYPE_TOP_WEAPON_ELECTRIC = 9;
         this.SUB_TYPE_MODULE_BULLETS_ROCKETS = 15;
         this.subTypeDB_myth = new Object();
         this.subTypeDB_myth["torso"] = {
            "ID":1,
            "source":"items1",
            "name":"torso",
            "unlockLevel":1
         };
         this.subTypeDB_myth["leg"] = {
            "ID":2,
            "source":"items1",
            "name":"leg",
            "unlockLevel":1
         };
         this.subTypeDB_myth["sideWeapon_physical"] = {
            "ID":3,
            "source":"items2",
            "name":"sideWeapon_physical",
            "unlockLevel":1
         };
         this.subTypeDB_myth["sideWeapon_explosive"] = {
            "ID":4,
            "source":"items2",
            "name":"sideWeapon_explosive",
            "unlockLevel":3
         };
         this.subTypeDB_myth["sideWeapon_electric"] = {
            "ID":5,
            "source":"items2",
            "name":"sideWeapon_electric",
            "unlockLevel":2
         };
         this.subTypeDB_myth["sideWeapon_melee"] = {
            "ID":6,
            "source":"items2",
            "name":"sideWeapon_melee",
            "unlockLevel":3
         };
         this.subTypeDB_myth["topWeapon_physical"] = {
            "ID":7,
            "source":"items2",
            "name":"topWeapon_physical",
            "unlockLevel":3
         };
         this.subTypeDB_myth["topWeapon_explosive"] = {
            "ID":8,
            "source":"items2",
            "name":"topWeapon_explosive",
            "unlockLevel":3
         };
         this.subTypeDB_myth["topWeapon_electric"] = {
            "ID":9,
            "source":"items2",
            "name":"topWeapon_electric",
            "unlockLevel":2
         };
         this.subTypeDB_myth["drone"] = {
            "ID":10,
            "source":"items1",
            "name":"drone",
            "unlockLevel":3
         };
         this.subTypeDB_myth["shield"] = {
            "ID":11,
            "source":"items3",
            "name":"shield",
            "unlockLevel":5
         };
         this.subTypeDB_myth["specials"] = {
            "ID":12,
            "source":"items3",
            "name":"specials",
            "unlockLevel":4
         };
         this.subTypeDB_myth["module_armorResistance"] = {
            "ID":13,
            "source":"items3",
            "name":"module_armorResistance",
            "unlockLevel":3
         };
         this.subTypeDB_myth["module_energyHeat"] = {
            "ID":14,
            "source":"items3",
            "name":"module_energyHeat",
            "unlockLevel":3
         };
         this.subTypeDB_myth["module_bulletsRockets"] = {
            "ID":15,
            "source":"items3",
            "name":"module_bulletsRockets",
            "unlockLevel":2
         };
         for each(_loc3_ in this.subTypeDB_myth)
         {
            _loc3_.text = getSpecificText("shop_" + _loc3_.name);
         }
         this.subTypeDB_combined = new Object();
         this.subTypeDB_combined["box_regular"] = {
            "ID":1,
            "name":"box_regular",
            "color":"blue",
            "unlockLevel":1
         };
         this.subTypeDB_combined["box_gold"] = {
            "ID":2,
            "name":"box_gold",
            "color":"orange",
            "unlockLevel":1
         };
         this.subTypeDB_combined["box_mythical"] = {
            "ID":3,
            "name":"box_mythical",
            "color":"orange",
            "unlockLevel":1
         };
         this.subTypeDB_combined["premiumAccount"] = {
            "ID":4,
            "name":"premiumAccount",
            "color":"orange",
            "unlockLevel":1
         };
         this.subTypeDB_combined["gold"] = {
            "ID":5,
            "name":"gold",
            "color":"orange",
            "unlockLevel":1
         };
         this.subTypeDB_combined["kit_repairResistance"] = {
            "ID":6,
            "name":"kit_repairResistance",
            "color":"blue",
            "unlockLevel":2
         };
         this.subTypeDB_combined["kit_energyHeat"] = {
            "ID":7,
            "name":"kit_energyHeat",
            "color":"blue",
            "unlockLevel":3
         };
         this.subTypeDB_combined["kit_bulletsRockets"] = {
            "ID":8,
            "name":"kit_bulletsRockets",
            "color":"blue",
            "unlockLevel":3
         };
         this.subTypeDB_combined["kit_power"] = {
            "ID":9,
            "name":"kit_power",
            "color":"blue",
            "unlockLevel":3
         };
         this.subTypeDB_combined["kit_color"] = {
            "ID":10,
            "name":"kit_color",
            "color":"blue",
            "unlockLevel":3
         };
         for each(_loc3_ in this.subTypeDB_combined)
         {
            _loc3_.text = getSpecificText("shop_" + _loc3_.name);
         }
         this.subTypeOrderDB = new Array();
         this.subTypeOrderDB.push({"name":"torso"});
         this.subTypeOrderDB.push({"name":"leg"});
         this.subTypeOrderDB.push({
            "name":"sideWeapon_physical",
            "color":"yellow"
         });
         this.subTypeOrderDB.push({
            "name":"sideWeapon_explosive",
            "color":"red"
         });
         this.subTypeOrderDB.push({
            "name":"sideWeapon_electric",
            "color":"blue"
         });
         this.subTypeOrderDB.push({"name":"sideWeapon_melee"});
         this.subTypeOrderDB.push({
            "name":"topWeapon_physical",
            "color":"yellow"
         });
         this.subTypeOrderDB.push({
            "name":"topWeapon_explosive",
            "color":"red"
         });
         this.subTypeOrderDB.push({
            "name":"topWeapon_electric",
            "color":"blue"
         });
         this.subTypeOrderDB.push({"name":"drone"});
         this.subTypeOrderDB.push({"name":"shield"});
         this.subTypeOrderDB.push({"name":"specials"});
         this.subTypeOrderDB.push({"name":"module_armorResistance"});
         this.subTypeOrderDB.push({"name":"module_energyHeat"});
         this.subTypeOrderDB.push({"name":"module_bulletsRockets"});
         this.subTypeOrderDB.push({"name":"kit_repairResistance"});
         this.subTypeOrderDB.push({"name":"kit_energyHeat"});
         this.subTypeOrderDB.push({"name":"kit_bulletsRockets"});
         this.subTypeOrderDB.push({"name":"kit_power"});
         this.subTypeOrderDB.push({"name":"kit_color"});
         this.subTypeOrderDB.push({"name":"module_multi"});
         this.subTypeOrderDB_myth = new Array();
         this.subTypeOrderDB_myth.push({"name":"torso"});
         this.subTypeOrderDB_myth.push({"name":"leg"});
         this.subTypeOrderDB_myth.push({
            "name":"sideWeapon_physical",
            "color":"yellow"
         });
         this.subTypeOrderDB_myth.push({
            "name":"sideWeapon_explosive",
            "color":"red"
         });
         this.subTypeOrderDB_myth.push({
            "name":"sideWeapon_electric",
            "color":"blue"
         });
         this.subTypeOrderDB_myth.push({"name":"sideWeapon_melee"});
         this.subTypeOrderDB_myth.push({
            "name":"topWeapon_physical",
            "color":"yellow"
         });
         this.subTypeOrderDB_myth.push({
            "name":"topWeapon_explosive",
            "color":"red"
         });
         this.subTypeOrderDB_myth.push({
            "name":"topWeapon_electric",
            "color":"blue"
         });
         this.subTypeOrderDB_myth.push({"name":"drone"});
         this.subTypeOrderDB_myth.push({"name":"shield"});
         this.subTypeOrderDB_myth.push({"name":"specials"});
         this.subTypeOrderDB_myth.push({"name":"module_armorResistance"});
         this.subTypeOrderDB_myth.push({"name":"module_energyHeat"});
         this.subTypeOrderDB_myth.push({"name":"module_bulletsRockets"});
         this.subTypeOrderDB_combined = new Array();
         this.subTypeOrderDB_combined.push({"name":"box_regular"});
         this.subTypeOrderDB_combined.push({"name":"box_gold"});
         this.subTypeOrderDB_combined.push({"name":"box_mythical"});
         this.subTypeOrderDB_combined.push({"name":"premiumAccount"});
         this.subTypeOrderDB_combined.push({"name":"gold"});
         this.subTypeOrderDB_combined.push({"name":"kit_repairResistance"});
         this.subTypeOrderDB_combined.push({"name":"kit_energyHeat"});
         this.subTypeOrderDB_combined.push({"name":"kit_bulletsRockets"});
         this.subTypeOrderDB_combined.push({"name":"kit_power"});
         this.subTypeOrderDB_combined.push({"name":"kit_color"});
         this.tutorialLevelsDB = new Array();
         this.tutorialLevelsDB[0] = {};
         this.tutorialLevelsDB[1] = {
            "name":"hanger1",
            "type":"hanger",
            "jumpToNextLevel":false
         };
         this.tutorialLevelsDB[2] = {
            "name":"battle1",
            "type":"battle",
            "jumpToNextLevel":false
         };
         this.tutorialLevelsDB[3] = {
            "name":"hanger2",
            "type":"hanger",
            "jumpToNextLevel":false
         };
         this.tutorialLevelsDB[4] = {
            "name":"battle2",
            "type":"battle",
            "jumpToNextLevel":false
         };
         this.tutorialLevelsDB[5] = {
            "name":"hanger3",
            "type":"hanger",
            "jumpToNextLevel":false
         };
         this.tutorialLevelsDB[6] = {
            "name":"baseMap1",
            "type":"baseMap",
            "jumpToNextLevel":false
         };
         this.tutorialLevelsDB[7] = {
            "name":"battle3",
            "type":"battle",
            "jumpToNextLevel":false
         };
         this.tutorialLevelsDB[8] = {
            "name":"hanger4",
            "type":"hanger",
            "jumpToNextLevel":false
         };
         this.tutorialLevelsDB[9] = {
            "name":"baseMap2",
            "type":"baseMap",
            "jumpToNextLevel":false
         };
         this.tutorialLevelsDB[10] = {
            "name":"battle4",
            "type":"battle",
            "jumpToNextLevel":true
         };
         this.tutorialLevelsDB[11] = {
            "name":"hanger5",
            "type":"hanger",
            "jumpToNextLevel":false
         };
         this.tutorialLevelsDB[12] = {
            "name":"hanger6",
            "type":"hanger",
            "button":"packages",
            "jumpToNextLevel":false
         };
         this.tutorialLevelsDB[13] = {
            "name":"packages1",
            "type":"packages",
            "jumpToNextLevel":false
         };
         this.tutorialLevelsDB[14] = {
            "name":"packages9",
            "type":"packages",
            "jumpToNextLevel":false
         };
         this.TUTORIAL_LEVEL_START_IN_HANGER = 10;
         this.TUTORIAL_LEVEL_HANGER1 = 1;
         this.TUTORIAL_LEVEL_HANGER2 = 3;
         this.TUTORIAL_LEVEL_HANGER3 = 5;
         this.TUTORIAL_LEVEL_HANGER4 = 8;
         this.TUTORIAL_LEVEL_HANGER5 = 11;
         this.TUTORIAL_LEVEL_GO_TO_HANGER_FROM_BATTLE = 8;
         this.TUTORIAL_LEVEL_GO_TO_BATTLE_FROM_HANGER = 3;
         this.TUTORIAL_LEVEL_GO_TO_WORLD_MAP_FROM_HANGER = 9;
         this.TUTORIAL_LEVEL_FUSION = 11;
         this.TUTORIAL_LEVEL_LAST_FOR_WORKSHOP = 11;
         this.TUTORIAL_LEVEL_MENU_PACKAGES_SHOP = 12;
         this.TUTORIAL_LEVEL_PREMIUM_ACCOUNT = 13;
         this.TUTORIAL_LEVEL_ITEMS_BOX = 14;
         this.TUTORIAL_LEVEL_MENU_UNLOCK_ALL_BUTTONS = 14;
         this.missionsDB = new Array();
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":39,
            "yPos":51,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":140,
            "yPos":80,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":207,
            "yPos":182,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":89,
            "yPos":238,
            "difficulty":2,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":308,
            "yPos":210,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"itemBox",
            "subType":"items",
            "packageID":5,
            "onlineWins":2,
            "xPos":366,
            "yPos":200
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":459,
            "yPos":188,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":518,
            "yPos":71,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":426,
            "yPos":76,
            "difficulty":2,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":600,
            "yPos":28,
            "difficulty":2,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":684,
            "yPos":54,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"itemBox",
            "subType":"items",
            "packageID":5,
            "onlineWins":5,
            "xPos":785,
            "yPos":37
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":906,
            "yPos":19,
            "difficulty":1,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":942,
            "yPos":197,
            "difficulty":2,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1039,
            "yPos":78,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1172,
            "yPos":172,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1338,
            "yPos":70,
            "difficulty":3,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1417,
            "yPos":51,
            "difficulty":3,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1224,
            "yPos":268,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1370,
            "yPos":421,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1452,
            "yPos":435,
            "difficulty":2,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1448,
            "yPos":366,
            "difficulty":3,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1382,
            "yPos":592,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1236,
            "yPos":602,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1201,
            "yPos":557,
            "difficulty":2,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1059,
            "yPos":468,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"itemBox",
            "subType":"items",
            "packageID":5,
            "onlineWins":10,
            "xPos":1007,
            "yPos":412
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1081,
            "yPos":414,
            "difficulty":2,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":931,
            "yPos":677,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1161,
            "yPos":734,
            "difficulty":3,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1470,
            "yPos":693,
            "difficulty":3,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":806,
            "yPos":419,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":804,
            "yPos":385,
            "difficulty":2,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":682,
            "yPos":486,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":599,
            "yPos":622,
            "difficulty":2,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":552,
            "yPos":430,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":579,
            "yPos":294,
            "difficulty":2,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":497,
            "yPos":310,
            "difficulty":3,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":312,
            "yPos":397,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":216,
            "yPos":513,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"itemBox",
            "subType":"items",
            "packageID":5,
            "onlineWins":20,
            "xPos":256,
            "yPos":556
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":33,
            "yPos":321,
            "difficulty":3,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":74,
            "yPos":555,
            "difficulty":2,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":19,
            "yPos":521,
            "difficulty":3,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":265,
            "yPos":646,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":65,
            "yPos":742,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":40,
            "yPos":790,
            "difficulty":2,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":105,
            "yPos":906,
            "difficulty":3,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":135,
            "yPos":833,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":191,
            "yPos":851,
            "difficulty":2,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":284,
            "yPos":767,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":300,
            "yPos":877,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":302,
            "yPos":953,
            "difficulty":3,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":476,
            "yPos":960,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":661,
            "yPos":966,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":640,
            "yPos":764,
            "difficulty":2,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":782,
            "yPos":1063,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"itemBox",
            "subType":"items",
            "packageID":6,
            "onlineWins":40,
            "xPos":810,
            "yPos":1108
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":966,
            "yPos":994,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1025,
            "yPos":874,
            "difficulty":3,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":957,
            "yPos":872,
            "difficulty":3,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1189,
            "yPos":1026,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1362,
            "yPos":1116,
            "difficulty":2,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1438,
            "yPos":940,
            "difficulty":2,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1411,
            "yPos":889,
            "difficulty":3,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1237,
            "yPos":1151,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1325,
            "yPos":1311,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1477,
            "yPos":1485,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1482,
            "yPos":1402,
            "difficulty":2,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1324,
            "yPos":1633,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1332,
            "yPos":1586,
            "difficulty":2,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1341,
            "yPos":1712,
            "difficulty":2,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1429,
            "yPos":1793,
            "difficulty":2,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1309,
            "yPos":1882,
            "difficulty":3,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1196,
            "yPos":1837,
            "difficulty":3,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1239,
            "yPos":1597,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"itemBox",
            "subType":"items",
            "packageID":6,
            "onlineWins":60,
            "xPos":1193,
            "yPos":1554
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1161,
            "yPos":1693,
            "difficulty":3,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1082,
            "yPos":1513,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":967,
            "yPos":1598,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1189,
            "yPos":1936,
            "difficulty":3,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1343,
            "yPos":1965,
            "difficulty":3,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1473,
            "yPos":1923,
            "difficulty":3,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":1026,
            "yPos":1370,
            "difficulty":1,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":824,
            "yPos":1454,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":821,
            "yPos":1283,
            "difficulty":2,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":793,
            "yPos":1238,
            "difficulty":3,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":663,
            "yPos":1352,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":517,
            "yPos":1251,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":400,
            "yPos":1237,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":259,
            "yPos":1145,
            "difficulty":2,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":113,
            "yPos":1162,
            "difficulty":2,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":29,
            "yPos":1129,
            "difficulty":3,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":283,
            "yPos":1294,
            "difficulty":1,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":225,
            "yPos":1293,
            "difficulty":2,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":85,
            "yPos":1376,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":233,
            "yPos":1453,
            "difficulty":2,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":287,
            "yPos":1436,
            "difficulty":3,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":360,
            "yPos":1451,
            "difficulty":1,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":356,
            "yPos":1504,
            "difficulty":2,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":465,
            "yPos":1536,
            "difficulty":1,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":531,
            "yPos":1546,
            "difficulty":2,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"itemBox",
            "subType":"items",
            "packageID":6,
            "onlineWins":80,
            "xPos":607,
            "yPos":1595
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":694,
            "yPos":1620,
            "difficulty":1,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":649,
            "yPos":1733,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":635,
            "yPos":1867,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":511,
            "yPos":1872,
            "difficulty":2,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":390,
            "yPos":1961,
            "difficulty":3,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":513,
            "yPos":1775,
            "difficulty":1,
            "themeID":2
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":234,
            "yPos":1691,
            "difficulty":2,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":70,
            "yPos":1669,
            "difficulty":3,
            "themeID":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":194,
            "yPos":1848,
            "difficulty":1,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":161,
            "yPos":1928,
            "difficulty":2,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":177,
            "yPos":1973,
            "difficulty":3,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":250,
            "yPos":1969,
            "difficulty":3,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":90,
            "yPos":1900,
            "difficulty":1,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":41,
            "yPos":1905,
            "difficulty":1,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"itemBox",
            "subType":"mythical",
            "onlineWins":0,
            "xPos":31,
            "yPos":1941,
            "difficulty":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":43,
            "yPos":1861,
            "difficulty":2,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":61,
            "yPos":1806,
            "difficulty":3,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"itemBox",
            "subType":"mythical",
            "onlineWins":0,
            "xPos":40,
            "yPos":1746,
            "difficulty":3
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":43,
            "yPos":1861,
            "difficulty":2,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":61,
            "yPos":1806,
            "difficulty":3,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":144,
            "yPos":2052,
            "difficulty":4,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":215,
            "yPos":2138,
            "difficulty":4,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"regular",
            "xPos":177,
            "yPos":2248,
            "difficulty":4,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":508,
            "yPos":2230,
            "difficulty":4,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":508,
            "yPos":2277,
            "difficulty":4,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":850,
            "yPos":2230,
            "difficulty":4,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":930,
            "yPos":2235,
            "difficulty":4,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":1370,
            "yPos":2370,
            "difficulty":4,
            "themeID":1
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":1470,
            "yPos":2517,
            "difficulty":4,
            "themeID":5
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":1329,
            "yPos":2610,
            "difficulty":4,
            "themeID":5
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":1046,
            "yPos":2465,
            "difficulty":4,
            "themeID":5
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":903,
            "yPos":2501,
            "difficulty":4,
            "themeID":5
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":741,
            "yPos":2586,
            "difficulty":4,
            "themeID":5
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":311,
            "yPos":2521,
            "difficulty":4,
            "themeID":5
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":50,
            "yPos":2524,
            "difficulty":4,
            "themeID":5
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":1070,
            "yPos":2760,
            "difficulty":4,
            "themeID":5
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":920,
            "yPos":2760,
            "difficulty":4,
            "themeID":5
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":700,
            "yPos":3390,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":130,
            "yPos":3600,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":190,
            "yPos":3740,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":145,
            "yPos":3980,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":1400,
            "yPos":3540,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":1290,
            "yPos":3670,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":1355,
            "yPos":3920,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":955,
            "yPos":4180,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":562,
            "yPos":4209,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":780,
            "yPos":4119,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":1110,
            "yPos":4700,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":990,
            "yPos":4880,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":830,
            "yPos":5410,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":540,
            "yPos":5460,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":210,
            "yPos":5710,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":470,
            "yPos":5796,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":1130,
            "yPos":5470,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":1340,
            "yPos":5750,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subtype":"regular",
            "xPos":1080,
            "yPos":5800,
            "difficulty":5,
            "themeID":6
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"endGame",
            "xPos":356,
            "yPos":1826,
            "difficulty":1,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"endGame",
            "xPos":274,
            "yPos":1852,
            "difficulty":2,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"endGame",
            "xPos":265,
            "yPos":1899,
            "difficulty":3,
            "themeID":4
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"endGame",
            "xPos":111,
            "yPos":2825,
            "difficulty":4,
            "themeID":5
         });
         this.missionsDB.push({
            "type":"mission",
            "subType":"endGame",
            "xPos":765,
            "yPos":5650,
            "difficulty":5,
            "themeID":6
         });
         _loc1_ = 0;
         while(_loc1_ < this.missionsDB.length)
         {
            if(this.missionsDB[_loc1_].type == "itemBox")
            {
               this.missionsItemBoxSlots[_loc1_] = _loc1_;
            }
            else if(this.missionsDB[_loc1_].type == "mission")
            {
               if(this.missionsDB[_loc1_].subType == "endGame")
               {
                  this["endGame" + this.missionsDB[_loc1_].difficulty + "Slot"] = _loc1_;
               }
            }
            _loc1_++;
         }
         this.missionLayouts_tutorial = new Array();
         this.missionLayouts_regular = new Array();
         this.missionLayouts_tutorial[0] = {
            "rows":3,
            "columns":3,
            "startLocation":8,
            "layout":"ME_5|L1_1_3"
         };
         this.missionLayouts_tutorial[1] = {
            "rows":4,
            "columns":3,
            "startLocation":11,
            "layout":"ME_2|X1_7_9|CA1_5|JP_8|L1_1_3"
         };
         this.missionLayouts_tutorial[2] = {
            "rows":5,
            "columns":4,
            "startLocation":18,
            "layout":"CA1_13_16|SI2_5_8|L1_1_4|ME_2|SI1_9_12|JP_14|XX_17_20|TK_3"
         };
         this.missionLayouts_regular[1] = new Array();
         this.missionLayouts_regular[1].push({
            "rows":5,
            "columns":5,
            "startLocation":23,
            "layout":"SD1_11_16|X1_6_7|CA1_15|JP_18|L1_1_2|ME_3|XX_21_22_24_25|CA2_10|TK_5"
         });
         this.missionLayouts_regular[1].push({
            "rows":5,
            "columns":4,
            "startLocation":18,
            "layout":"SH1_10_11|X1_9_12|XX_17_20|SB1_1|L1_3_4|ME_14|JP_6|CA2_13_16|TK_7"
         });
         this.missionLayouts_regular[1].push({
            "rows":3,
            "columns":7,
            "startLocation":18,
            "layout":"CA1_6_7|JP_9|L1_1_8|ME_2|SF1_13_14|XX_15_16_17_19_20_21|TK_11"
         });
         this.missionLayouts_regular[1].push({
            "rows":6,
            "columns":4,
            "startLocation":22,
            "layout":"L2_2|SE1_6_7_14_15|CA1_10_11|ME_3|XX_21_24|TK_18_19"
         });
         this.missionLayouts_regular[1].push({
            "rows":4,
            "columns":5,
            "startLocation":18,
            "layout":"L2_1|CA1_15|JP_11_19|SG1_7_8_9_12_14|ME_2|SA1_13|CA2_20"
         });
         this.missionLayouts_regular[1].push({
            "rows":6,
            "columns":4,
            "startLocation":22,
            "layout":"ME_7|XX_21_24|CA1_17|SB1_4|JP_18_19|L1_3_8|SD1_1_5_9_13|SI1_15_16|SI2_11_12|CA2_20"
         });
         this.missionLayouts_regular[1].push({
            "rows":5,
            "columns":5,
            "startLocation":23,
            "layout":"SH1_7_9|CA1_25|JP_18|L1_2_4|SF1_3_8|CA2_21|TK_12_14|ME_13"
         });
         this.missionLayouts_regular[1].push({
            "rows":5,
            "columns":5,
            "startLocation":23,
            "layout":"CA1_12_13_14|SI2_1_5|L1_7_9|SI1_6_10|JP_17_19|ME_18|TK_8"
         });
         this.missionLayouts_regular[1].push({
            "rows":5,
            "columns":6,
            "startLocation":27,
            "layout":"CA1_5_6|JP_4|TK_22|L1_1_2|ME_8|SI1_16_17_18|SI2_10_11_12|XX_25_26_29_30|SC1_19"
         });
         this.missionLayouts_regular[1].push({
            "rows":4,
            "columns":4,
            "startLocation":14,
            "layout":"ME_10_11|L1_6_7|SG1_1_2|SA1_4|CA1_9_13"
         });
         this.missionLayouts_regular[1].push({
            "rows":5,
            "columns":4,
            "startLocation":18,
            "layout":"TK_2_3_6_7_10_11|SI1_9_12|L1_1_4|XX_17_20|SI2_5_8|CA1_13_16"
         });
         this.missionLayouts_regular[1].push({
            "rows":4,
            "columns":6,
            "startLocation":21,
            "layout":"CA1_24|JP_14_16|SG1_8_9_10|L1_5_6|ME_1|SA1_15|CA2_23"
         });
         this.missionLayouts_regular[1].push({
            "rows":5,
            "columns":5,
            "startLocation":23,
            "layout":"SD1_21_22_24_25|X1_2_3_4_7_9_12_14|CA1_1_5|ME_13|L2_8|TK_6_10"
         });
         this.missionLayouts_regular[1].push({
            "rows":5,
            "columns":5,
            "startLocation":23,
            "layout":"CB1_5|CA1_3|SG1_10_15|L1_11_16|ME_6|X1_7_9_12_14_17_19|SA1_20|XX_21_22_24_25|TK_8_13"
         });
         this.missionLayouts_regular[2] = new Array();
         this.missionLayouts_regular[2].push({
            "rows":5,
            "columns":6,
            "startLocation":27,
            "layout":"SH1_8_13_14|L2_1|SE1_7|CA1_6_23_24|SI2_11_12|L1_2|ME_3_4|SI1_17_18|XX_25_26_29_30|TK_21_22"
         });
         this.missionLayouts_regular[2].push({
            "rows":5,
            "columns":6,
            "startLocation":27,
            "layout":"L2_4|SG1_1_2_5_6_7_12|L1_10|ME_21_22|SA1_8_11|CA2_9|TK_20_23|CA3_3"
         });
         this.missionLayouts_regular[2].push({
            "rows":4,
            "columns":4,
            "startLocation":14,
            "layout":"ME_6_7|L3_2|CA2_10|TK_3|CA3_11"
         });
         this.missionLayouts_regular[2].push({
            "rows":4,
            "columns":5,
            "startLocation":18,
            "layout":"ME_9_10|L2_15|CA1_2|JP_7_8|CA3_12|SD1_1_6_11|SF1_5|XX_16_17_19_20|L1_14"
         });
         this.missionLayouts_regular[2].push({
            "rows":6,
            "columns":6,
            "startLocation":33,
            "layout":"SF1_5|ME_12_14|XX_31_32_35_36|SI2_16|L2_6|TK_11_19|CA2_24_30|SI1_22|SD1_1_2_7_8|L1_13|JP_27_28|CA1_25"
         });
         this.missionLayouts_regular[2].push({
            "rows":5,
            "columns":7,
            "startLocation":31,
            "layout":"SC1_1_8_15_22|CA1_14_21|ME_11_18|L1_5_6_7|TK_17_19_25|JP_28|SE1_13"
         });
         this.missionLayouts_regular[2].push({
            "rows":5,
            "columns":5,
            "startLocation":23,
            "layout":"ME_13_18|TK_12_14|JP_17_19|L3_8|SD1_4_5|SB1_1|CA1_7_9"
         });
         this.missionLayouts_regular[3] = new Array();
         this.missionLayouts_regular[3].push({
            "rows":6,
            "columns":7,
            "startLocation":39,
            "layout":"CB1_29_30|CB2_35|SB1_1_7|SI2_16_17_19_20|L1_2|ME_5_12_13|SI1_23_24_26_27|L3_6|JP_9_10|XX_36_37_38_40_41_42|TK_3_32"
         });
         this.missionLayouts_regular[3].push({
            "rows":5,
            "columns":5,
            "startLocation":23,
            "layout":"L2_13|SB1_8|L1_7_9|ME_12_14_18|CB1_20_25|CB2_21|TK_17_19"
         });
         this.missionLayouts_regular[3].push({
            "rows":5,
            "columns":6,
            "startLocation":27,
            "layout":"L2_6_12|SE1_22_23|SI2_5|SC1_13_19|CA3_1|ME_4_10|CB1_7_24|SI1_11|JP_21|XX_25_26_29_30|TK_2_3_8_9"
         });
         this.missionLayouts_regular[3].push({
            "rows":6,
            "columns":6,
            "startLocation":33,
            "layout":"SD1_6_12_18|JP_27_28|SG1_8_9_10_14_16|L1_2|ME_3_4_7_13|SA1_15|L3_1|XX_31_32_35_36|CA2_25_30"
         });
         this.missionLayouts_regular[3].push({
            "rows":7,
            "columns":5,
            "startLocation":33,
            "layout":"SH1_6_10_11_15|L2_1_5|SE1_7_9_12_14|CA1_22_24|JP_26_30|CA3_23|ME_3_8_13|XX_31_32_34_35|SF1_27_29|CA2_28|TK_16_20"
         });
         this.missionLayouts_regular[3].push({
            "rows":5,
            "columns":7,
            "startLocation":32,
            "layout":"CB1_15_22|SH1_17_19|TK_2_6|ME_18_24_26|CA2_28|SD1_3_5|L1_1_7_8_14|CA3_21|JP_9_13|XX_29_30_31_33_34_35|SE1_4"
         });
         this.missionLayouts_regular[3].push({
            "rows":6,
            "columns":7,
            "startLocation":39,
            "layout":"CB1_28_35|SH1_9_10_16_17|TK_1_7|XX_36_37_38_40_41_42|CB2_22_29|ME_4_31_32_33|L1_2_3_5_6|JP_8_14|SE1_12_13_19_20"
         });
         this.missionLayouts_regular[3].push({
            "rows":6,
            "columns":9,
            "startLocation":51,
            "layout":"L3_1_3_10_12|BOSS1New_2|ME_11_20|TK_22|JP_25|X1_31_40_49_4_13_14_15_16_17_18|SD1_36|SA1_53|SI1_54|SI2_45|CB2_46_47_48"
         });
         this.missionLayouts_regular[3].push({
            "rows":7,
            "columns":9,
            "startLocation":59,
            "layout":"BOSS2_5|L3_3_4_6_7|TK_10_18_57|ME_14_22_24|JP_21_25_56|L2_48|CA3_1_9|CA2_55_62_63|CA1_46_54_61|SI1_44_45|SI2_35_36|X1_2_8_11_12_13_15_16_17_33_38_39_40_42_47_49_51_58_60|SD1_53"
         });
         this.missionLayouts_regular[3].push({
            "rows":7,
            "columns":9,
            "startLocation":59,
            "layout":"BOSS3_5|L3_3_4_6_7|TK_10_18_57|ME_14_22_24|JP_21_25_56|L2_48|CA3_1_9|CA2_55_62_63|CA1_46_54_61|SI1_44_45|SI2_35_36|X1_2_8_11_12_13_15_16_17_33_38_39_40_42_47_49_51_58_60|SD1_53"
         });
         this.missionLayouts_regular[4] = new Array();
         this.missionLayouts_regular[4].push({
            "rows":6,
            "columns":7,
            "startLocation":39,
            "layout":"ME3P_11|ME2_23_27|L3_10_12_16_20|SA1_9_13|SI1_22_24_26_28|SI2_15_17_19_21|X1_1_2_3_4_5_6_7_8_14"
         });
         this.missionLayouts_regular[4].push({
            "rows":6,
            "columns":9,
            "startLocation":47,
            "layout":"ME2_44|ME3P_11_12|L3_2_3|SA1_20_21|SG1_19_22_43|SB1_41_42|CB2_36_45_54|X1_5_6_7_8_9_14_15_16_17_18_23_24_25_26_27_32_33_34_35_50_51_52_53"
         });
         this.missionLayouts_regular[4].push({
            "rows":7,
            "columns":12,
            "startLocation":78,
            "layout":"ME2_1_12_27_73|ME3P_71|L3_60_72_84|CB2_2_24_39_61|SH1_6_7_11_13_28_54_55_58_59_74_82_83|X1_14_15_16_17_18_19_20_21_22_23_26_38_40_41_42_43_44_45_46_47_48_50_62_63_64_65_66_67_79"
         });
         this.missionLayouts_regular[4].push({
            "rows":6,
            "columns":9,
            "startLocation":50,
            "layout":"ME2_11_14_17||ME3P_20_26|L3_29_35|CB2_4_6|SA1_22_23_24_31_32_33|X1_10_12_13_15_16_18_19_21_25_27_28_30_34_36_37_38_39_43_44_45"
         });
         this.missionLayouts_regular[4].push({
            "rows":7,
            "columns":7,
            "startLocation":25,
            "layout":"ME2_10_12_16_20_30_34_38_40|ME3P_11_23_27_39|L3_4_22_46_28|SA1_1_7_43_49|SB1_3_5_15_21_29_35_45_47|CB2_17_18_19_24_26_31_32_33"
         });
         this.missionLayouts_regular[4].push({
            "rows":7,
            "columns":12,
            "startLocation":74,
            "layout":"ITALIANBOSS1_47|L3_23_35_59_71|X1_3_4_5_6_7_8_9_10_11_12_16_17_18_19_20_21_22_28_29_30_31_32_33_34_52_53_54_55_56_57_58_64_65_66_67_68_69_70_75_76_77_78_79_80_81_82_83_84|CB2_2_13_14_15|SA1_25_26_27"
         });
         this.missionLayouts_regular[4].push({
            "rows":7,
            "columns":10,
            "startLocation":70,
            "layout":"ME3P_12|ME2_5_9_63_67|L3_2_11_14_18_52_56|CB2_31_46_51|SA1_4_8_62_66|X1_1_3_7_13_15_17_19_21_23_25_27_29_33_35_37_39_41_43_45_47_49_53_55_57_59_61_65_69"
         });
         this.missionLayouts_regular[5] = new Array();
         this.missionLayouts_regular[5].push({
            "rows":10,
            "columns":10,
            "startLocation":91,
            "layout":"L3_10_33_35_36_37_39_51|CV_43|BB_49|ME2_9_41_46|SA1_26_31_73_79|CB2_53_59|SC1_8_25_27_72_74_78_80|X1_12_13_14_18_19_20_22_24_28_30_32_34_38_40_42_44_48_50_52_54_58_60_61_62_64_68_70"
         });
         this.applePackages = new Array();
         this.androidPackages = new Array();
         this.fakePackages = new Array();
         this.fakePackages[1] = {
            "productId":1,
            "sort":200,
            "title":"200 Tokens",
            "price":17.9,
            "description":"200 Tokens for in-game purchases.",
            "displayPrice":"17.90 USD"
         };
         this.fakePackages[2] = {
            "productId":2,
            "sort":400,
            "title":"400 Tokens",
            "price":27.9,
            "description":"400 Tokens for in-game purchases.",
            "displayPrice":"27.90 USD"
         };
         this.fakePackages[3] = {
            "productId":3,
            "sort":1000,
            "title":"1000 Tokens",
            "price":62.9,
            "description":"1000 Tokens for in-game purchases.",
            "displayPrice":"62.90 USD"
         };
         this.wheelsDB = new Object();
         this.wheelsDB[37] = true;
         this.wheelsDB[194] = true;
         this.wheelsDB[195] = true;
         this.wheelsDB[196] = true;
         this.wheelsDB[260] = true;
         this.wheelsDB[261] = true;
         this.wheelsDB[584] = true;
         this.wheelsDB[338] = true;
         this.wheelsDB[916] = true;
         this.wheelsDB[917] = true;
         this.wheelsDB[981] = true;
         this.wheelsDB[982] = true;
         this.wheelsDB[983] = true;
         this.wheelsDB[1059] = true;
         this.wheelsDB[1181] = true;
         this.wheelsDB[1182] = true;
         this.wheelsDB[1183] = true;
         this.wheelsDB[1191] = true;
         this.wheelsDB[1254] = true;
         this.wheelsDB[1258] = true;
         this.missionUpgradesDB = new Object();
         this.missionUpgradesDB["HP"] = "upgradeHP";
         this.missionUpgradesDB["EN"] = "upgradeEnergy";
         this.missionUpgradesDB["HT"] = "upgradeHeat";
         this.missionUpgradesDB["BL"] = "upgradeBullets";
         this.missionUpgradesDB["RK"] = "upgradeRockets";
         this.missionUpgradesReverseDB = new Object();
         this.missionUpgradesReverseDB["upgradeHP"] = "HP";
         this.missionUpgradesReverseDB["upgradeEnergy"] = "EN";
         this.missionUpgradesReverseDB["upgradeHeat"] = "HT";
         this.missionUpgradesReverseDB["upgradeBullets"] = "BL";
         this.missionUpgradesReverseDB["upgradeRockets"] = "RK";
         this.missionMapObjectDB = new Object();
         this.missionMapObjectDB["TR"] = {
            "code":"TR",
            "type":"enemy",
            "grp":"turret",
            "dirtSize":1
         };
         this.missionMapObjectDB["JP"] = {
            "code":"JP",
            "type":"enemy",
            "grp":"jeep",
            "dirtSize":1
         };
         this.missionMapObjectDB["TK"] = {
            "code":"TK",
            "type":"enemy",
            "grp":"tank",
            "dirtSize":2
         };
         this.missionMapObjectDB["BB"] = {
            "code":"BB",
            "type":"enemy",
            "grp":"italianBattleShip",
            "dirtSize":3
         };
         this.missionMapObjectDB["CV"] = {
            "code":"CV",
            "type":"enemy",
            "grp":"italianCarrier",
            "dirtSize":3
         };
         this.missionMapObjectDB["AAA"] = {
            "code":"AAA",
            "type":"enemy",
            "grp":"italianAirship",
            "dirtSize":7
         };
         this.missionMapObjectDB["ME"] = {
            "code":"ME",
            "type":"enemy",
            "grp":"mech",
            "dirtSize":2
         };
         this.missionMapObjectDB["ME2"] = {
            "code":"ME2",
            "type":"enemy_hardmode",
            "grp":"mech_hardmode",
            "dirtSize":2
         };
         this.missionMapObjectDB["ME3P"] = {
            "code":"ME3P",
            "type":"enemy_hardmode",
            "grp":"mech_hardmode_elite",
            "dirtSize":2
         };
         this.missionMapObjectDB["BOSS1"] = {
            "code":"BOSS1",
            "type":"enemy",
            "grp":"mech",
            "dirtSize":2
         };
         this.missionMapObjectDB["BOSS1New"] = {
            "code":"BOSS1New",
            "type":"enemy",
            "grp":"boss1",
            "dirtSize":2
         };
         this.missionMapObjectDB["BOSS2"] = {
            "code":"BOSS2",
            "type":"enemy",
            "grp":"boss2",
            "dirtSize":2
         };
         this.missionMapObjectDB["BOSS3"] = {
            "code":"BOSS3",
            "type":"enemy",
            "grp":"boss3",
            "dirtSize":2
         };
         this.missionMapObjectDB["ITALIANBOSS1"] = {
            "code":"ITALIANBOSS1",
            "type":"enemy",
            "grp":"italianBoss1",
            "dirtSize":2
         };
         this.missionMapObjectDB["L1"] = {
            "code":"L1",
            "type":"loot",
            "grp":"loot1",
            "pickups":1
         };
         this.missionMapObjectDB["L2"] = {
            "code":"L2",
            "type":"loot",
            "grp":"loot2",
            "pickups":2
         };
         this.missionMapObjectDB["L3"] = {
            "code":"L3",
            "type":"loot",
            "grp":"loot3",
            "pickups":3
         };
         this.missionMapObjectDB["SA1"] = {
            "code":"SA1",
            "type":"structure",
            "grp":"structureA1",
            "dirtSize":3
         };
         this.missionMapObjectDB["SB1"] = {
            "code":"SB1",
            "type":"structure",
            "grp":"structureB1",
            "dirtSize":3
         };
         this.missionMapObjectDB["SC1"] = {
            "code":"SC1",
            "type":"structure",
            "grp":"structureC1",
            "dirtSize":3
         };
         this.missionMapObjectDB["SD1"] = {
            "code":"SD1",
            "type":"structure",
            "grp":"structureD1",
            "dirtSize":3
         };
         this.missionMapObjectDB["SE1"] = {
            "code":"SE1",
            "type":"structure",
            "grp":"structureE1",
            "dirtSize":3
         };
         this.missionMapObjectDB["SF1"] = {
            "code":"SF1",
            "type":"structure",
            "grp":"structureF1",
            "dirtSize":3
         };
         this.missionMapObjectDB["SG1"] = {
            "code":"SG1",
            "type":"structure",
            "grp":"structureG1",
            "dirtSize":3
         };
         this.missionMapObjectDB["SH1"] = {
            "code":"SH1",
            "type":"structure",
            "grp":"structureH1",
            "dirtSize":3
         };
         this.missionMapObjectDB["SI1"] = {
            "code":"SI1",
            "type":"structure",
            "grp":"structureI1",
            "dirtSize":3
         };
         this.missionMapObjectDB["SI2"] = {
            "code":"SI2",
            "type":"structure",
            "grp":"structureI2",
            "dirtSize":3
         };
         this.missionMapObjectDB["CA1"] = {
            "code":"CA1",
            "type":"crate",
            "grp":"crateA1",
            "dirtSize":1
         };
         this.missionMapObjectDB["CA2"] = {
            "code":"CA2",
            "type":"crate",
            "grp":"crateA2",
            "dirtSize":1
         };
         this.missionMapObjectDB["CA3"] = {
            "code":"CA3",
            "type":"crate",
            "grp":"crateA3",
            "dirtSize":1
         };
         this.missionMapObjectDB["CB1"] = {
            "code":"CB1",
            "type":"crate",
            "grp":"crateB1",
            "dirtSize":1
         };
         this.missionMapObjectDB["CB2"] = {
            "code":"CB2",
            "type":"crate",
            "grp":"crateB2",
            "dirtSize":1
         };
         this.missionMapObjectDB["XX"] = {
            "code":"XX",
            "type":"invisibleBlock",
            "grp":""
         };
         this.missionMapObjectDB["X1"] = {
            "code":"X1",
            "type":"regularBlock",
            "grp":"X1",
            "dirtSize":1
         };
         this.campaignMissionsDB = new Object();
         this.campaignMissionsDB[1] = {
            "missionID":1,
            "type":"winsVSComputer",
            "level":1,
            "requirement":7,
            "goldBonus":5000
         };
         this.campaignMissionsDB[2] = {
            "missionID":2,
            "type":"winsVSComputer",
            "level":2,
            "requirement":10,
            "goldBonus":5000
         };
         this.campaignMissionsDB[3] = {
            "missionID":3,
            "type":"winsVSComputer",
            "level":3,
            "requirement":13,
            "goldBonus":5000
         };
         this.campaignMissionsDB[4] = {
            "missionID":4,
            "type":"winsVSComputer",
            "level":4,
            "requirement":16,
            "goldBonus":5000
         };
         this.campaignMissionsDB[5] = {
            "missionID":5,
            "type":"winsVSComputer",
            "level":5,
            "requirement":19,
            "goldBonus":5000
         };
         this.campaignMissionsDB[6] = {
            "missionID":6,
            "type":"winsVSComputer",
            "level":6,
            "requirement":22,
            "goldBonus":7000
         };
         this.campaignMissionsDB[7] = {
            "missionID":7,
            "type":"winsVSComputer",
            "level":7,
            "requirement":25,
            "goldBonus":7000
         };
         this.campaignMissionsDB[8] = {
            "missionID":8,
            "type":"winsVSHardComputer",
            "level":1,
            "requirement":1,
            "goldBonus":7500
         };
         this.campaignMissionsDB[9] = {
            "missionID":9,
            "type":"winsVSInsaneComputer",
            "level":1,
            "requirement":1,
            "goldBonus":10000
         };
         this.campaignMissionsDB[10] = {
            "missionID":10,
            "type":"equipDrone",
            "level":1,
            "requirement":1,
            "goldBonus":5000
         };
         this.campaignMissionsDB[11] = {
            "missionID":11,
            "type":"equipTeleport",
            "level":1,
            "requirement":1,
            "goldBonus":5000
         };
         this.campaignMissionsDB[12] = {
            "missionID":12,
            "type":"equipHarpoon",
            "level":1,
            "requirement":1,
            "goldBonus":5000
         };
         this.campaignMissionsDB[13] = {
            "missionID":13,
            "type":"equipShield",
            "level":1,
            "requirement":1,
            "goldBonus":5000
         };
         this.campaignMissionsDB[14] = {
            "missionID":14,
            "type":"equipCharge",
            "level":1,
            "requirement":1,
            "goldBonus":5000
         };
         this.campaignMissionsDB[15] = {
            "missionID":15,
            "type":"completeLadderBattle",
            "level":1,
            "requirement":1,
            "goldBonus":5000
         };
         this.campaignMissionsDB[16] = {
            "missionID":16,
            "type":"kitsUsed",
            "level":1,
            "requirement":1,
            "goldBonus":5000
         };
         this.campaignMissionsDB[17] = {
            "missionID":17,
            "type":"kitsUsed",
            "level":2,
            "requirement":5,
            "goldBonus":5000
         };
         this.campaignMissionsDB[18] = {
            "missionID":18,
            "type":"winsVSHardmodeComputer",
            "level":1,
            "requirement":1,
            "goldBonus":12000
         };
         this.campaignMissions_maxKits = 5;
         this.campaignMissions_maxWinsVSComputer = 25;
         this.sortCampaignMissions();
         this.createEquipmentUnlockedDB(false);
         _loc4_ = new Array();
         _loc4_.push("a55"," anal","anal "," anus","anus ","ar5e","arrse","arse","ass","fukka","asshole","assholes","asswhole","a_s_s","b!tch","b00bs","b17ch");
         _loc4_.push("b1tch","ball","bastard","beastial","beastiality","bellend","bestial","bestiality","bi+ch","biatch","bitch","bloody","blow job","blowjob","blowjobs");
         _loc4_.push("boiolas","bollock","bollok","boner","boob","boobs","booobs","boooobs","booooobs","booooooobs","breasts","buceta","bugger","bum","butt");
         _loc4_.push("butthole","buttmuch","buttplug","c0ck","carpet muncher","cawk","chink","cipa","cl1t","cnut","cock","cok","cokmuncher","coksucka","coon","cox","crap");
         _loc4_.push("cum","cummer","cumming","cums","cumshot","cunilingus","cunillingus","cunnilingus","cunt","cuntlick","cuntlicker","cuntlicking","cunts","cyalis","cyberfuc");
         _loc4_.push("d1ck","damn","dick","dickhead","dildo","dildos","dink","dinks","dirsa","dlck");
         _loc4_.push("doggin","dogging","donkeyribber","doosh","duche","dyke","ejaculate","ejaculated","ejaculates","ejaculating","ejaculatings","ejaculation","ejakulate","f u c k");
         _loc4_.push("f u c k e r","f4nny","fag","fagging","faggitt","faggot","faggs","fagot","fagots","fags","fanny","fannyflaps","fanyy","fatass","fu ck","fcuk","fcuker");
         _loc4_.push("fcuking","feck","fecker","felching","fellate","fellatio");
         _loc4_.push("flange","fook","fooker","fuck","f uck","fucka","fucked","fucker");
         _loc4_.push("fudge packer","fudgepacker","fuk","fuker","fukker","dogystyle","dogy style","isis","sharia");
         _loc4_.push("fukkin","fuks","fukwhit","fukwit","fux","fux0r","f_u_c_k","gangbang","gangbanged","gangbangs","gaylord","gaysex","goatse","god-dam","god-damned","goddamn");
         _loc4_.push("goddamned","hardcoresex","heshe","hitler","hoar","hoare","hoer","homo","hore","horniest","horny","hotsex","jack-off","jackoff","jerk-off","jism","jiz");
         _loc4_.push("jizm","jizz","kawk","knob","knobead","knobed","knobend","knobhead","knobjocky","knobjokey","kock","kondum","kondums","kum","kummer","kumming","kums","kunilingus");
         _loc4_.push("l3i+ch","l3itch","labia","lmfao","lust","lusting","m0f0","m0fo","m45terbate","ma5terb8","ma5terbate","masochist","master-bate","masterb8","masterbat","masterbat3");
         _loc4_.push("motha","masterbate","masterbation","masterbations","masturbate","mo-fo","mof0","mofo","mother","mothafuck","mothafucka");
         _loc4_.push("muff","mutha","muthafecker","muthafuckker","muther","mutherfucker","n1gga","n1gger","nazi","nigg3r","nigg4h","nigga","niggah","niggas","niggaz","nigger","niggers");
         _loc4_.push("nob","nobhead","nobjocky","nobjokey","numbnuts","nutsack","orgasim","orgasims","orgasm","orgasms","p0rn","pawn","pecker","penis","phonesex","phuck","phuk");
         _loc4_.push("phuked","phuking","phukked","phukking","phuks","phuq","pigfucker","pimpis","piss","pissed","pisser","pissers","pisses","pissflaps","pissin","pissing","pissoff","poop");
         _loc4_.push("porn","porno","pornography","pornos","prick","pron","pube","pusse","pussi","pussies","pussy","rape","rapist","rectum","retard","rimjaw","rimming","s.o.b.","sadist","schlong","screwing");
         _loc4_.push("scroat","scrote","scrotum","semen","sex","sh!+","sh!t","sh1t","shag","shagger","shaggin","shagging","shemale","shit","shitdick","shite");
         _loc4_.push("shitfull","shithead","shiting","shits","shitted","shitter","shitting","shitty","skank","slut","sluts","smegma","smut","snatch","son-of-a-bitch","spac","spunk","s_h_i_t");
         _loc4_.push("t1tt1e5","t1tties","teets","teez","testical","testicle","tit ","tits","tittywank","titwank","tosser","turd");
         _loc4_.push("tw4t","twat","twathead","twatty","twunt","twunter","v14gra","v1gra","vagina","viagra","vulva","w00se","wang","wank","wanker","wanky","whoar","whore","willies","willy","xrated");
         _loc4_.push("arsch","ärsche","blödmann","bummsen","bumsen","fick","fotze","hosenpisser","hosenscheißer","hühnerficker","huhrensohn","hundeficker","idiot");
         _loc4_.push("judensau","kacke","kanacke","kanake","kanaken","kinderficker","kinderporno","lutscher","miststück","möse","muschi","nutte","pimmel","piss","sack");
         _loc4_.push("scheisse","schwanz","sieg heil","spasti","titten","volldepp","vollhorst","vollidiot","vollpfosten","vollspack","vollspacken","vollspasti","vorhaut","wichser");
         _loc4_.push("wixer","wixx");
         this.wordFilterDB = new Array();
         _loc1_ = 0;
         while(_loc1_ < _loc4_.length)
         {
            this.wordFilterDB.push({
               "badWord":_loc4_[_loc1_],
               "fix":"###"
            });
            _loc1_++;
         }
         this.computerNamesDB = new Array();
         this.computerNamesDB.push("Executor","X-Ray","Ilona Mark V","Terminator","Garbage Collector","TK 4022","Behemoth Mark 8","Diesel","Engine","Mass Breaker","Tornado","Deefus","Annihalator Mark 3","Defender Mark II","A-T-O-M","Air Strike","Meteor","Xond","A-Bot","Bullet Proof","Heat Blast","Desolator","Maximum Damage","Tech Pro","Detonator","A-R-D Mark 7","Lucky Shot","Metal Breaker","Pyro Blast","Gun Shot","ShotGun","Metro","TS 2K","Metalcrusher","Exterminator 4K","Disintegrator","RT model IV","Hellhound","Desert hunter","Hammer RX","Pathfinder 27X","Model 570X","Death v.II","Quaker","Scrape Yard 2K","The Machine","Destructor","Holster IV","Zed","BeanBag","Boomer","Glorious","BigBang VI","Gearcrusher 2K","Gizmo GT","OutDated Model","RustBucket","Overlord","F8 Crusher","MT-10K","R-Age Machine","Bio-NV","Magnificus","Spartacus XII","Solomon Miner","Goliath 6-cervo","Model1337","C4K-L1E 4K","F0SS1L M4kR","F41L-S4F3 ","W4R-D0G","Biotic-NV","Mode1337 ","Mikobox","Kane","Sentinel 9K","J.U.L.I.U.S"
         ,"Andrewid","Seth","Joebot","The Unknown","Alexander","Model X","MicroNuke","HellGate","WarrMachine","End of the Line","Explosive Dust","Debree","Naplam Strike","Black Mirror","MacroBlast","ElectroQuake","Defence Magnet","Bunker","Rocket Slayer","Mass Detonator","Sparks","Sniper Mark X","Stomp Master","Laser Blade","Explosive Turret","HardCoded","Mythical Theory","Code-9");
      }
      
      public function createTipsDB() : void
      {
         var _loc1_:uint = 0;
         this.tipsDB = new Array();
         _loc1_ = 1;
         while(_loc1_ <= 25)
         {
            this.tipsDB.push(getSpecificText("tip_" + String(_loc1_)));
            _loc1_++;
         }
      }
      
      public function createBattleInterfaceToolTipDB() : void
      {
         this.battleInterfaceToolTipDB = new Object();
         this.battleInterfaceToolTipDB["HP"] = {
            "title":getSpecificText("tooltip_HP"),
            "text":getSpecificText("battleInterfaceTop_HPInfo")
         };
         this.battleInterfaceToolTipDB["energy"] = {
            "title":getSpecificText("tooltip_energy"),
            "text":getSpecificText("battleInterfaceTop_energyInfo")
         };
         this.battleInterfaceToolTipDB["heat"] = {
            "title":getSpecificText("tooltip_heat"),
            "text":getSpecificText("battleInterfaceTop_heatInfo")
         };
         this.battleInterfaceToolTipDB["bullets"] = {
            "title":getSpecificText("tooltip_bullets"),
            "text":getSpecificText("battleInterfaceTop_bulletsInfo")
         };
         this.battleInterfaceToolTipDB["rockets"] = {
            "title":getSpecificText("tooltip_rockets"),
            "text":getSpecificText("battleInterfaceTop_rocketsInfo")
         };
         this.battleInterfaceToolTipDB["resist1"] = {
            "title":getSpecificText("tooltip_resist1"),
            "text":getSpecificText("battleInterfaceTop_resist1Info")
         };
         this.battleInterfaceToolTipDB["resist2"] = {
            "title":getSpecificText("tooltip_resist2"),
            "text":getSpecificText("battleInterfaceTop_resist2Info")
         };
         this.battleInterfaceToolTipDB["resist3"] = {
            "title":getSpecificText("tooltip_resist3"),
            "text":getSpecificText("battleInterfaceTop_resist3Info")
         };
         this.battleInterfaceToolTipDB["resist1Gain"] = {
            "title":getSpecificText("tooltip_resist1Gain"),
            "text":getSpecificText("battleInterfaceTop_resist1GainInfo")
         };
         this.battleInterfaceToolTipDB["resist2Gain"] = {
            "title":getSpecificText("tooltip_resist2Gain"),
            "text":getSpecificText("battleInterfaceTop_resist2GainInfo")
         };
         this.battleInterfaceToolTipDB["resist3Gain"] = {
            "title":getSpecificText("tooltip_resist3Gain"),
            "text":getSpecificText("battleInterfaceTop_resist3GainInfo")
         };
         this.battleInterfaceToolTipDB["extraPhase"] = {
            "title":getSpecificText("tooltip_extraPhase"),
            "text":getSpecificText("battleInterfaceTop_extraPhase")
         };
         this.battleInterfaceToolTipDB["AP"] = {
            "title":getSpecificText("battleInterfaceTop_actionPoints"),
            "color":"",
            "text":getSpecificText("battleInterfaceTop_actionPointsInfo")
         };
         this.battleInterfaceToolTipDB["level"] = {
            "title":getGeneralText("matchMakingLevel"),
            "color":"",
            "text":getGeneralText("matchMakingLevel")
         };
      }
      
      public function createInfoTextDB() : void
      {
         this.infoTextDB = new Object();
         this.infoTextDB["walkLeft"] = getSpecificText("battleInterfaceBottom_walkLeft");
         this.infoTextDB["walkRight"] = getSpecificText("battleInterfaceBottom_walkRight");
         this.infoTextDB["jumpLeft"] = getSpecificText("battleInterfaceBottom_jumpLeft");
         this.infoTextDB["jumpRight"] = getSpecificText("battleInterfaceBottom_jumpRight");
         this.infoTextDB["shutDown"] = getSpecificText("battleInterfaceBottom_shutDown");
         this.infoTextDB["droneActivate"] = getSpecificText("battleInterfaceBottom_droneActivate");
         this.infoTextDB["droneDeactivate"] = getSpecificText("battleInterfaceBottom_droneDeactivate");
         this.infoTextDB["shieldActivate"] = getSpecificText("battleInterfaceBottom_shieldActivate");
         this.infoTextDB["shieldDeactivate"] = getSpecificText("battleInterfaceBottom_shieldDeactivate");
         this.infoTextDB["charge"] = getSpecificText("battleInterfaceBottom_charge");
         this.infoTextDB["harpoon"] = getSpecificText("battleInterfaceBottom_harpoon");
         this.infoTextDB["teleport"] = getSpecificText("battleInterfaceBottom_teleport");
         this.infoTextDB["weapons"] = getSpecificText("battleInterfaceBottom_weapons");
         this.infoTextDB["movement"] = getSpecificText("battleInterfaceBottom_movement");
         this.infoTextDB["specials"] = getSpecificText("battleInterfaceBottom_specials");
         this.infoTextDB["kits"] = getSpecificText("battleInterfaceBottom_kits");
         this.infoTextDB["back"] = getSpecificText("battleInterfaceBottom_back");
         this.infoTextDB["cancel"] = getSpecificText("battleInterfaceBottom_cancel");
         this.infoTextDB["switchMech"] = getSpecificText("battleInterfaceBottom_switchMech");
         this.infoTextDB["selectMech"] = getSpecificText("battleInterfaceBottom_selectMech");
      }
      
      public function updateSubTypeNames() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.subTypeDB)
         {
            _loc1_.text = getSpecificText("shop_" + _loc1_.name);
         }
         for each(_loc1_ in this.subTypeDB_myth)
         {
            _loc1_.text = getSpecificText("shop_" + _loc1_.name);
         }
         for each(_loc1_ in this.subTypeDB_combined)
         {
            _loc1_.text = getSpecificText("shop_" + _loc1_.name);
         }
      }
      
      public function updateBoostNames() : void
      {
         var _loc1_:BMBoostData = null;
         _loc1_ = new BMBoostData();
         _loc1_ = this.boostsDB[2];
         _loc1_.boostName = getSpecificText("packages_bronze");
         _loc1_ = this.boostsDB[3];
         _loc1_.boostName = getSpecificText("packages_silver");
         _loc1_ = this.boostsDB[4];
         _loc1_.boostName = getSpecificText("packages_gold");
         _loc1_ = this.boostsDB[9];
         _loc1_.boostName = getSpecificText("packages_itemsBox");
         _loc1_ = this.boostsDB[5];
         _loc1_.boostName = getSpecificText("packages_itemsBoxSilver");
         _loc1_ = this.boostsDB[6];
         _loc1_.boostName = getSpecificText("packages_itemsBoxGold");
         _loc1_ = this.boostsDB[11];
         _loc1_.boostName = getSpecificText("packages_itemsBox");
         _loc1_ = this.boostsDB[12];
         _loc1_.boostName = getSpecificText("packages_itemsBox");
         _loc1_ = this.boostsDB[19];
         _loc1_.boostName = getSpecificText("packages_itemsBoxMythical");
         _loc1_ = this.boostsDB[20];
         _loc1_.boostName = getSpecificText("packages_itemsBoxMythical");
         _loc1_ = this.boostsDB[8];
         _loc1_.boostName = getSpecificText("packages_premiumAccount");
         _loc1_ = this.boostsDB[10];
         _loc1_.boostName = getSpecificText("packages_premiumAccount");
         _loc1_ = this.boostsDB[1];
         _loc1_.boostName = getSpecificText("packages_premiumAccount");
      }
      
      public function createHelpData() : void
      {
         this.helpDB = new Array();
         this.helpDB.push({
            "type":"costEnergy",
            "name":getSpecificText("help_energyWeaponsTitle"),
            "tip":getSpecificText("help_energyWeapons")
         });
         this.helpDB.push({
            "type":"costBullets",
            "name":getSpecificText("help_bulletWeaponsTitle"),
            "tip":getSpecificText("help_bulletWeapons")
         });
         this.helpDB.push({
            "type":"costRockets",
            "name":getSpecificText("help_rocketWeaponsTitle"),
            "tip":getSpecificText("help_rocketWeapons")
         });
         this.helpDB.push({
            "type":"costHeat",
            "name":getSpecificText("tooltip_heat"),
            "tip":getSpecificText("help_heatDamage")
         });
         this.helpDB.push({
            "type":"range",
            "name":getSpecificText("tooltip_range"),
            "tip":getSpecificText("help_range")
         });
         this.helpDB.push({
            "type":"shutdown",
            "name":getSpecificText("help_shutdownTitle"),
            "tip":getSpecificText("help_shutdown")
         });
         this.helpDB.push({
            "type":"drone",
            "name":getSpecificText("help_droneTitle"),
            "tip":getSpecificText("help_drone")
         });
         this.helpDB.push({
            "type":"shield",
            "name":getSpecificText("help_shieldTitle"),
            "tip":getSpecificText("help_shield")
         });
         this.helpDB.push({
            "type":"charge",
            "name":getSpecificText("help_chargeTitle"),
            "tip":getSpecificText("help_charge")
         });
         this.helpDB.push({
            "type":"teleport",
            "name":getSpecificText("help_teleportTitle"),
            "tip":getSpecificText("help_teleport")
         });
         this.helpDB.push({
            "type":"harpoon",
            "name":getSpecificText("help_harpoonTitle"),
            "tip":getSpecificText("help_harpoon")
         });
         this.helpDB.push({
            "type":"physicalDamage",
            "name":getSpecificText("tooltip_physicalDamage"),
            "tip":getSpecificText("help_physicalDamage")
         });
         this.helpDB.push({
            "type":"explosiveDamage",
            "name":getSpecificText("tooltip_explosiveDamage"),
            "tip":getSpecificText("help_explosiveDamage")
         });
         this.helpDB.push({
            "type":"electricDamage",
            "name":getSpecificText("tooltip_electricDamage"),
            "tip":getSpecificText("help_electricDamage")
         });
         this.helpDB.push({
            "type":"resistPhysical",
            "name":getSpecificText("tooltip_resist1"),
            "tip":getSpecificText("help_resist1")
         });
         this.helpDB.push({
            "type":"resistExplosive",
            "name":getSpecificText("tooltip_resist2"),
            "tip":getSpecificText("help_resist2")
         });
         this.helpDB.push({
            "type":"resistElectric",
            "name":getSpecificText("tooltip_resist3"),
            "tip":getSpecificText("help_resist3")
         });
      }
      
      public function createMusicData() : void
      {
         var _loc1_:Boolean = false;
         this.musicDB = new Array();
         _loc1_ = false;
         if((this.runAsMobile || _loc1_) && this.useExtraMusicTracksForMobile)
         {
            this.musicDB.push({
               "base":"music3",
               "loop":"music3"
            });
            this.musicDB.push({
               "base":"music10",
               "loop":"music10"
            });
            this.musicDB.push({
               "base":"music4",
               "loop":"music4"
            });
            this.musicDB.push({
               "base":"music11",
               "loop":"music11"
            });
            this.musicDB.push({
               "base":"music5",
               "loop":"music5"
            });
            this.musicDB.push({
               "base":"music12",
               "loop":"music12"
            });
            this.musicDB.push({
               "base":"music6",
               "loop":"music6"
            });
            this.musicDB.push({
               "base":"music13",
               "loop":"music13"
            });
            this.musicDB.push({
               "base":"music7",
               "loop":"music7"
            });
            this.musicDB.push({
               "base":"music14",
               "loop":"music14"
            });
            this.musicDB.push({
               "base":"music2",
               "loop":"music2"
            });
            this.musicDB.push({
               "base":"music8_base",
               "loop":"music8_loop"
            });
            this.musicDB.push({
               "base":"music9_base",
               "loop":"music9_loop"
            });
         }
         else
         {
            this.musicDB.push({
               "base":"music3",
               "loop":"music3"
            });
            this.musicDB.push({
               "base":"music4",
               "loop":"music4"
            });
            this.musicDB.push({
               "base":"music5",
               "loop":"music5"
            });
            this.musicDB.push({
               "base":"music6",
               "loop":"music6"
            });
            this.musicDB.push({
               "base":"music7",
               "loop":"music7"
            });
            this.musicDB.push({
               "base":"music2",
               "loop":"music2"
            });
            this.musicDB.push({
               "base":"music8_base",
               "loop":"music8_loop"
            });
            this.musicDB.push({
               "base":"music9_base",
               "loop":"music9_loop"
            });
            this.musicDB.push({
               "base":"music16_base",
               "loop":"music16_loop"
            });
            this.musicDB.push({
               "base":"music17_base",
               "loop":"music17_loop"
            });
            this.musicDB.push({
               "base":"music18",
               "loop":"music18"
            });
         }
      }
      
      public function createPowerLevelsDB() : void
      {
         this.powerLevelsDB_regular = new Array();
         this.powerLevelsDB_regular[1] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,30,60,120,240,480,960,1920,3840,7680,15360,23040,30720,38400,46080,53760]
         };
         this.powerLevelsDB_regular[2] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,30,60,120,240,480,960,1920,3840,7680,15360,23040,30720,38400,46080,53760]
         };
         this.powerLevelsDB_regular[3] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,30,60,120,240,480,960,1920,3840,7680,15360,23040,30720,38400,46080,53760]
         };
         this.powerLevelsDB_regular[4] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,40,80,160,320,640,1280,2560,5120,10240,20480,30720,40960,51200,61440,71680]
         };
         this.powerLevelsDB_regular[5] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,50,100,200,400,800,1600,3200,6400,12800,25600,38400,51200,64000,76800,89600]
         };
         this.powerLevelsDB_regular[6] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,60,120,240,480,960,1920,3840,7680,15360,30720,46080,61440,76800,92160,107520]
         };
         this.powerLevelsDB_regular[7] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,70,140,280,560,1120,2240,4480,8960,17920,35840,53760,71680,89600,107520,125440]
         };
         this.powerLevelsDB_regular[8] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,80,160,320,640,1280,2560,5120,10240,20480,40960,61440,81920,102400,122880,143360]
         };
         this.powerLevelsDB_regular[9] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,90,180,360,720,1440,2880,5760,11520,23040,46080,69120,92160,115200,138240,161280]
         };
         this.powerLevelsDB_regular[10] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,100,200,400,800,1600,3200,6400,12800,25600,51200,76800,102400,128000,153600,179200]
         };
         this.powerLevelsDB_regular[11] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,110,220,440,880,1760,3520,7040,14080,28160,56320,84480,112640,140800,168960,197120]
         };
         this.powerLevelsDB_regular[12] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,120,240,480,960,1920,3840,7680,15360,30720,61440,92160,122880,153600,184320,215040]
         };
         this.powerLevelsDB_regular[13] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,130,260,520,1040,2080,4160,8320,16640,33280,66560,99840,133120,166400,199680,232960]
         };
         this.powerLevelsDB_regular[14] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,140,280,560,1120,2240,4480,8960,17920,35840,71680,107520,143360,179200,215040,250880]
         };
         this.powerLevelsDB_regular[15] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,150,300,600,1200,2400,4800,9600,19200,38400,76800,115200,153600,192000,230400,268800]
         };
         this.powerLevelsDB_regular[16] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,160,320,640,1280,2560,5120,10240,20480,40960,81920,122880,163840,204800,245760,286720]
         };
         this.powerLevelsDB_regular[17] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,170,340,680,1360,2720,5440,10880,21760,43520,87040,130560,174080,217600,261120,304640]
         };
         this.powerLevelsDB_regular[18] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,180,360,720,1440,2880,5760,11520,23040,46080,92160,138240,184320,230400,276480,322560]
         };
         this.powerLevelsDB_regular[19] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,190,380,760,1520,3040,6080,12160,24320,48640,97280,145920,194560,243200,291840,340480]
         };
         this.powerLevelsDB_regular[20] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,200,400,800,1600,3200,6400,12800,25600,51200,102400,153600,204800,256000,307200,358400]
         };
         this.powerLevelsDB_regular[21] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,210,420,840,1680,3360,6720,13440,26880,53760,107520,161280,215040,268800,322560,376320]
         };
         this.powerLevelsDB_regular[22] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,220,440,880,1760,3520,7040,14080,28160,56320,112640,168960,225280,281600,337920,394240]
         };
         this.powerLevelsDB_regular[23] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,230,460,920,1840,3680,7360,14720,29440,58880,117760,176640,235520,294400,353280,412160]
         };
         this.powerLevelsDB_regular[24] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,240,480,960,1920,3840,7680,15360,30720,61440,122880,184320,245760,307200,368640,430080]
         };
         this.powerLevelsDB_regular[25] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,250,500,1000,2000,4000,8000,16000,32000,64000,128000,192000,256000,320000,384000,448000]
         };
         this.powerLevelsDB_regular[26] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,260,520,1040,2080,4160,8320,16640,33280,66560,133120,199680,266240,332800,399360,465920]
         };
         this.powerLevelsDB_regular[27] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,270,540,1080,2160,4320,8640,17280,34560,69120,138240,207360,276480,345600,414720,483840]
         };
         this.powerLevelsDB_regular[28] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,280,560,1120,2240,4480,8960,17920,35840,71680,143360,215040,286720,358400,430080,501760]
         };
         this.powerLevelsDB_regular[29] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,290,580,1160,2320,4640,9280,18560,37120,74240,148480,222720,296960,371200,445440,519680]
         };
         this.powerLevelsDB_regular[30] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,300,600,1200,2400,4800,9600,19200,38400,76800,153600,230400,307200,384000,460800,537600]
         };
         this.powerLevelsDB_regular[31] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,300,600,1200,2400,4800,9600,19200,38400,76800,153600,230400,307200,384000,460800,537600]
         };
         this.powerLevelsDB_regular[32] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,300,600,1200,2400,4800,9600,19200,38400,76800,153600,230400,307200,384000,460800,537600]
         };
         this.powerLevelsDB_regular[33] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,300,600,1200,2400,4800,9600,19200,38400,76800,153600,230400,307200,384000,460800,537600]
         };
         this.powerLevelsDB_regular[34] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,300,600,1200,2400,4800,9600,19200,38400,76800,153600,230400,307200,384000,460800,537600]
         };
         this.powerLevelsDB_regular[35] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,300,600,1200,2400,4800,9600,19200,38400,76800,153600,230400,307200,384000,460800,537600]
         };
         this.powerLevelsDB_regular[36] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,300,600,1200,2400,4800,9600,19200,38400,76800,153600,230400,307200,384000,460800,537600]
         };
         this.powerLevelsDB_special = new Array();
         this.powerLevelsDB_special[1] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,60,240,960,3840,15360]
         };
         this.powerLevelsDB_special[2] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,60,240,960,3840,15360]
         };
         this.powerLevelsDB_special[3] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,60,240,960,3840,15360]
         };
         this.powerLevelsDB_special[4] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,80,320,1280,5120,20480]
         };
         this.powerLevelsDB_special[5] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,100,400,1600,6400,25600]
         };
         this.powerLevelsDB_special[6] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,120,480,1920,7680,30720]
         };
         this.powerLevelsDB_special[7] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,140,560,2240,8960,35840]
         };
         this.powerLevelsDB_special[8] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,160,640,2560,10240,40960]
         };
         this.powerLevelsDB_special[9] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,180,720,2880,11520,46080]
         };
         this.powerLevelsDB_special[10] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,200,800,3200,12800,51200]
         };
         this.powerLevelsDB_special[11] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,220,880,3520,14080,56320]
         };
         this.powerLevelsDB_special[12] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,240,960,3840,15360,61440]
         };
         this.powerLevelsDB_special[13] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,260,1040,4160,16640,66560]
         };
         this.powerLevelsDB_special[14] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,280,1120,4480,17920,71680]
         };
         this.powerLevelsDB_special[15] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,300,1200,4800,19200,76800]
         };
         this.powerLevelsDB_special[16] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,320,1280,5120,20480,81920]
         };
         this.powerLevelsDB_special[17] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,340,1360,5440,21760,87040]
         };
         this.powerLevelsDB_special[18] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,360,1440,5760,23040,92160]
         };
         this.powerLevelsDB_special[19] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,380,1520,6080,24320,97280]
         };
         this.powerLevelsDB_special[20] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,400,1600,6400,25600,102400]
         };
         this.powerLevelsDB_special[21] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,420,1680,6720,26880,107520]
         };
         this.powerLevelsDB_special[22] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,440,1760,7040,28160,112640]
         };
         this.powerLevelsDB_special[23] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,460,1840,7360,29440,117760]
         };
         this.powerLevelsDB_special[24] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,480,1920,7680,30720,122880]
         };
         this.powerLevelsDB_special[25] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,500,2000,8000,32000,128000]
         };
         this.powerLevelsDB_special[26] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,520,2080,8320,33280,133120]
         };
         this.powerLevelsDB_special[27] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,540,2160,8640,34560,138240]
         };
         this.powerLevelsDB_special[28] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,560,2240,8960,35840,143360]
         };
         this.powerLevelsDB_special[29] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,580,2320,9280,37120,148480]
         };
         this.powerLevelsDB_special[30] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,600,2400,9600,38400,153600]
         };
         this.powerLevelsDB_special[31] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,600,2400,9600,38400,153600]
         };
         this.powerLevelsDB_special[32] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,600,2400,9600,38400,153600]
         };
         this.powerLevelsDB_special[33] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,600,2400,9600,38400,153600]
         };
         this.powerLevelsDB_special[34] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,600,2400,9600,38400,153600]
         };
         this.powerLevelsDB_special[35] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,600,2400,9600,38400,153600]
         };
         this.powerLevelsDB_special[36] = {
            "bonusHP":5,
            "bonusDamage":1,
            "bonusRepair":1,
            "power":[0,0,600,2400,9600,38400,153600]
         };
      }
      
      public function createEquipmentUnlockedDB(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         if(param1 == false)
         {
            this.equipmentUnlockDB = new Object();
            this.equipmentUnlockDB["torso"] = {
               "name":"torso",
               "total":1,
               "level":1
            };
            this.equipmentUnlockDB["leg"] = {
               "name":"leg",
               "total":1,
               "level":1
            };
            this.equipmentUnlockDB["sideWeapon1"] = {
               "name":"sideWeapon",
               "total":1,
               "level":1
            };
            this.equipmentUnlockDB["sideWeapon2"] = {
               "name":"sideWeapon",
               "total":2,
               "level":1
            };
            this.equipmentUnlockDB["sideWeapon3"] = {
               "name":"sideWeapon",
               "total":3,
               "level":6
            };
            this.equipmentUnlockDB["sideWeapon4"] = {
               "name":"sideWeapon",
               "total":4,
               "level":9
            };
            this.equipmentUnlockDB["topWeapon1"] = {
               "name":"topWeapon",
               "total":1,
               "level":2
            };
            this.equipmentUnlockDB["topWeapon2"] = {
               "name":"topWeapon",
               "total":2,
               "level":7
            };
            this.equipmentUnlockDB["drone"] = {
               "name":"drone",
               "total":1,
               "level":3
            };
            this.equipmentUnlockDB["shield"] = {
               "name":"shield",
               "total":1,
               "level":6
            };
            this.equipmentUnlockDB["teleport"] = {
               "name":"teleport",
               "total":1,
               "level":4
            };
            this.equipmentUnlockDB["charge"] = {
               "name":"charge",
               "total":1,
               "level":7
            };
            this.equipmentUnlockDB["harpoon"] = {
               "name":"harpoon",
               "total":1,
               "level":5
            };
            this.equipmentUnlockDB["kit1"] = {
               "name":"kit",
               "total":1,
               "level":2
            };
            this.equipmentUnlockDB["kit2"] = {
               "name":"kit",
               "total":2,
               "level":4
            };
            this.equipmentUnlockDB["mech2"] = {
               "name":"mech1",
               "total":1,
               "level":10
            };
            this.equipmentUnlockDB["mech3"] = {
               "name":"mech2",
               "total":2,
               "level":10
            };
            this.SECOND_MECH_UNLOCK_LEVEL = this.equipmentUnlockDB["mech2"].level;
            this.equipmentUnlockDB["module1"] = {
               "name":"module",
               "total":1,
               "level":2
            };
            this.equipmentUnlockDB["module2"] = {
               "name":"module",
               "total":2,
               "level":3
            };
            this.equipmentUnlockDB["module3"] = {
               "name":"module",
               "total":3,
               "level":5
            };
            this.equipmentUnlockDB["module4"] = {
               "name":"module",
               "total":4,
               "level":8
            };
            this.equipmentUnlockDB["module5"] = {
               "name":"module",
               "total":5,
               "level":11
            };
            this.equipmentUnlockDB["module6"] = {
               "name":"module",
               "total":6,
               "level":12
            };
            this.equipmentUnlockDB["module7"] = {
               "name":"module",
               "total":7,
               "level":13
            };
         }
         if(this.inventoryMaxMechs == 6)
         {
            this.equipmentUnlockDB["mech4"] = {
               "name":"mech1",
               "total":4,
               "level":30
            };
            this.equipmentUnlockDB["mech5"] = {
               "name":"mech2",
               "total":5,
               "level":30
            };
            this.equipmentUnlockDB["mech6"] = {
               "name":"mech3",
               "total":6,
               "level":30
            };
         }
         else
         {
            this.equipmentUnlockDB["mech4"] = {
               "name":"mech1",
               "total":4,
               "level":99999999
            };
            this.equipmentUnlockDB["mech5"] = {
               "name":"mech2",
               "total":5,
               "level":99999999
            };
            this.equipmentUnlockDB["mech6"] = {
               "name":"mech3",
               "total":6,
               "level":99999999
            };
         }
         this.equipmentUnlockByLevelDB = new Array();
         _loc2_ = 0;
         for each(_loc3_ in this.equipmentUnlockDB)
         {
            switch(_loc3_.name)
            {
               case "mech1":
               case "mech2":
               case "mech3":
                  break;
               default:
                  if(_loc3_.level < 99)
                  {
                     if(_loc2_ < _loc3_.level)
                     {
                        _loc2_ = uint(_loc3_.level);
                     }
                  }
                  break;
            }
         }
         _loc4_ = 1;
         while(_loc4_ <= _loc2_)
         {
            this.equipmentUnlockByLevelDB[_loc4_] = new Object();
            this.equipmentUnlockByLevelDB[_loc4_].sideWeapon = 0;
            this.equipmentUnlockByLevelDB[_loc4_].topWeapon = 0;
            this.equipmentUnlockByLevelDB[_loc4_].drone = 0;
            this.equipmentUnlockByLevelDB[_loc4_].shield = 0;
            this.equipmentUnlockByLevelDB[_loc4_].teleport = 0;
            this.equipmentUnlockByLevelDB[_loc4_].charge = 0;
            this.equipmentUnlockByLevelDB[_loc4_].harpoon = 0;
            this.equipmentUnlockByLevelDB[_loc4_].module = 0;
            this.equipmentUnlockByLevelDB[_loc4_].kit = 0;
            for each(_loc3_ in this.equipmentUnlockDB)
            {
               if(_loc4_ >= _loc3_.level)
               {
                  _loc5_ = _loc3_.name;
                  if(this.equipmentUnlockByLevelDB[_loc4_][_loc5_] < _loc3_.total)
                  {
                     this.equipmentUnlockByLevelDB[_loc4_][_loc5_] = _loc3_.total;
                  }
               }
            }
            _loc4_++;
         }
      }
      
      public function getEquipmentUnlockByLevel(param1:uint, param2:String) : uint
      {
         var _loc3_:uint = 0;
         _loc3_ = 0;
         if(this.equipmentUnlockByLevelDB[param1] != null)
         {
            _loc3_ = uint(this.equipmentUnlockByLevelDB[param1][param2]);
         }
         else
         {
            _loc3_ = uint(this.equipmentUnlockByLevelDB[this.equipmentUnlockByLevelDB.length - 1][param2]);
         }
         return _loc3_;
      }
      
      private function overwriteColorsDB() : void
      {
      }
      
      public function getSpecialOffersBoostIDs() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:uint = 0;
         var _loc3_:BMBoostData = null;
         var _loc4_:Boolean = false;
         _loc1_ = new Array();
         if(this.starterPackActive())
         {
            _loc1_.push(100);
         }
         _loc2_ = 0;
         while(_loc2_ < this.boostsDB.length)
         {
            if(this.boostsDB[_loc2_] != null)
            {
               _loc3_ = this.boostsDB[_loc2_];
               _loc4_ = false;
               if(_loc3_.costTokens != _loc3_.costTokensDefault)
               {
                  _loc4_ = true;
               }
               else if(_loc3_.type == "randomItems")
               {
                  if(_loc3_.ratioRare != _loc3_.ratioRareDefault || _loc3_.ratioEpic != _loc3_.ratioEpicDefault || _loc3_.ratioLegendary != _loc3_.ratioLegendaryDefault || _loc3_.ratioMythical != _loc3_.ratioMythicalDefault || _loc3_.ratioNewMythical != _loc3_.ratioNewMythicalDefault)
                  {
                     _loc4_ = true;
                  }
               }
               if(_loc4_)
               {
                  _loc1_.push(_loc3_.boostID);
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getAchievmentDescriptionText(param1:Object) : String
      {
         var _loc2_:String = null;
         var _loc3_:Number = Number(NaN);
         var _loc4_:String = null;
         if(param1.requirement > 1)
         {
            if(param1.type == "highestLadderProgress")
            {
               _loc3_ = this.getLadderRankByProgress(param1.requirement);
            }
            else
            {
               _loc3_ = Number(param1.requirement);
            }
            _loc4_ = getSpecificText("achievements_" + param1.type);
            _loc2_ = this.replaceStringInText(_loc4_,"%AMOUNT%",this.getNumberWithComma(_loc3_));
         }
         else
         {
            switch(param1.type)
            {
               case "chargeKills":
               case "droneKills":
               case "teleportKills":
               case "harpoonKills":
               case "swordCombos":
               case "shotgunCombos":
               case "stompCombos":
               case "machineGunCombos":
               case "flameThrowerCombos":
                  _loc2_ = getSpecificText("achievements_" + param1.type + "_1");
                  break;
               default:
                  _loc2_ = getSpecificText("achievements_" + param1.type);
            }
         }
         return _loc2_;
      }
      
      public function sortAchievements() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         this.achievementsSortedDB = new Object();
         for each(_loc1_ in this.achievementsDB)
         {
            _loc2_ = _loc1_.type;
            _loc3_ = uint(_loc1_.level);
            if(this.achievementsSortedDB[_loc2_] == null)
            {
               this.achievementsSortedDB[_loc2_] = new Array();
            }
            this.achievementsSortedDB[_loc2_][_loc3_] = _loc1_.achievementID;
         }
      }
      
      public function sortCampaignMissions() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         this.campaignMissionsSortedDB = new Object();
         for each(_loc1_ in this.campaignMissionsDB)
         {
            _loc2_ = _loc1_.type;
            _loc3_ = uint(_loc1_.level);
            if(this.campaignMissionsSortedDB[_loc2_] == null)
            {
               this.campaignMissionsSortedDB[_loc2_] = new Array();
            }
            this.campaignMissionsSortedDB[_loc2_][_loc3_] = _loc1_.missionID;
         }
      }
      
      public function starterPackActive() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:BMPlayerProfile = null;
         _loc1_ = false;
         if(this.gameType == "online" && this.useStarterPacks)
         {
            _loc2_ = this["player" + this.player1PlayerID + "Profile"];
            if(_loc2_.starterPackData != null)
            {
               if(_loc2_.starterPackData.starterPackStatus == 0)
               {
                  if(this.isTutorialActive() == false)
                  {
                     if(_loc2_.starterPackData.starterPackStartDate == 0)
                     {
                        remoteM.socketM.lobby_setStarterPackStartDate();
                        _loc2_.starterPackData.starterPackStartDate = this.currentTime;
                     }
                     if(_loc2_.starterPackData.starterPackStartDate + _loc2_.starterPackData.offerDuration > this.currentTime)
                     {
                        _loc1_ = true;
                     }
                     else
                     {
                        remoteM.socketM.lobby_setStarterPackTimeOut();
                        _loc2_.starterPackData.starterPackStatus = 3;
                     }
                  }
               }
            }
         }
         return _loc1_;
      }
      
      public function missionWorldMapInterfaceActive() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:BMPlayerProfile = null;
         _loc1_ = false;
         if(this.starterPackActive())
         {
            _loc1_ = true;
         }
         else
         {
            if(this.clientRunningLocally)
            {
               this.useMissionWorldMapInterface = true;
            }
            if(this.useMissionWorldMapInterface || this.runAsMobile == false && this.useMissionWorldMapInterface_web)
            {
               _loc2_ = this["player" + this.player1PlayerID + "Profile"];
               if(_loc2_.level > 10)
               {
                  if(this.specialOffersResetTime > this.currentTime)
                  {
                     if(this.getSpecialOffersBoostIDs().length > 0)
                     {
                        _loc1_ = true;
                     }
                  }
               }
            }
         }
         return _loc1_;
      }
      
      public function isMechReadyForBattle(param1:Boolean, param2:uint = 1) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:BMPlayerData = null;
         var _loc5_:uint = 0;
         var _loc6_:BMMechStructure = null;
         var _loc7_:uint = 0;
         _loc3_ = true;
         _loc4_ = this.playersData[this.player1PlayerID];
         if(this.use2V2And3V3Battles)
         {
            if(param1)
            {
               _loc5_ = screensM.screenHangerMech.getTargetMechID();
            }
            else
            {
               _loc7_ = 1;
               while(_loc7_ <= param2)
               {
                  _loc6_ = _loc4_.mechStructures[_loc7_];
                  if(this.mechMissingPartsForBattle(_loc6_).length > 0)
                  {
                     _loc3_ = false;
                     _loc7_ = param2;
                  }
                  _loc7_++;
               }
            }
         }
         else
         {
            if(param1)
            {
               _loc5_ = screensM.screenHangerMech.getTargetMechID();
            }
            else
            {
               _loc5_ = _loc4_.selectedMechID;
            }
            _loc6_ = _loc4_.mechStructures[_loc5_];
            if(this.mechMissingPartsForBattle(_loc6_).length > 0)
            {
               _loc3_ = false;
            }
         }
         return _loc3_;
      }
      
      public function startedBattleVSComputer(param1:Number) : void
      {
         this.computerBattleID = param1;
      }
      
      public function removeFriendship(param1:Number) : void
      {
         var _loc2_:Object = null;
         var _loc3_:BMFriendshipData = null;
         _loc2_ = new Object();
         for each(_loc3_ in this.friendsDB)
         {
            if(_loc3_.friendshipID != param1)
            {
               _loc2_[_loc3_.friendshipID] = _loc3_;
            }
         }
         this.friendsDB = _loc2_;
      }
      
      public function addNewFriendship(param1:Number) : void
      {
         var _loc2_:BMFriendshipData = null;
         _loc2_ = new BMFriendshipData();
         _loc2_.playerID = 0;
         _loc2_.playerName = this.tryToAddFriend_username;
         _loc2_.friendshipSentByMe = true;
         _loc2_.friendshipID = param1;
         _loc2_.friendshipStatus = 0;
         _loc2_.overallRank = 1;
         _loc2_.XP = 1;
         _loc2_.level = 1;
         this.friendsDB[_loc2_.friendshipID] = _loc2_;
      }
      
      public function addFriendship(param1:Object) : void
      {
         var _loc2_:BMFriendshipData = null;
         var _loc3_:BMPlayerProfile = null;
         _loc2_ = new BMFriendshipData();
         _loc3_ = this["player" + this.ONLINE_PLAYER_ID + "Profile"];
         if(_loc3_.playerName == param1.playerName1)
         {
            _loc2_.playerName = param1.playerName2;
            _loc2_.friendshipSentByMe = true;
         }
         else
         {
            _loc2_.playerName = param1.playerName1;
            _loc2_.friendshipSentByMe = false;
         }
         _loc2_.friendshipID = param1.friendshipID;
         _loc2_.friendshipStatus = param1.status;
         _loc2_.playerID = param1.friendData.playerID;
         _loc2_.overallRank = param1.friendData.overallRank;
         _loc2_.XP = param1.friendData.XP;
         _loc2_.level = param1.friendData.level;
         if(param1.friendData.facebook == 1)
         {
            _loc2_.facebook = true;
         }
         if(param1.friendData.isOnline == 1)
         {
            _loc2_.isOnline = true;
         }
         this.friendsDB[_loc2_.friendshipID] = _loc2_;
      }
      
      public function isMyClanMember(param1:Number) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:BMPlayerProfile = null;
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         _loc2_ = false;
         _loc3_ = this["player" + this.player1PlayerID + "Profile"];
         if(_loc3_.clanID > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.clan_members.length)
            {
               _loc5_ = _loc3_.clan_members[_loc4_];
               if(_loc5_.playerID == param1)
               {
                  _loc2_ = true;
                  _loc4_ = _loc3_.clan_members.length;
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function isMyFriend(param1:Number) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:BMFriendshipData = null;
         _loc2_ = false;
         for each(_loc3_ in this.friendsDB)
         {
            if(_loc3_.playerID == param1)
            {
               if(_loc3_.friendshipStatus == 1)
               {
                  _loc2_ = true;
               }
            }
         }
         return _loc2_;
      }
      
      public function friendOnline(param1:Number, param2:Boolean) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:BMFriendshipData = null;
         _loc3_ = false;
         if(param1 != this.userID)
         {
            for each(_loc4_ in this.friendsDB)
            {
               if(_loc3_ == false)
               {
                  if(_loc4_.playerID == param1)
                  {
                     _loc4_.isOnline = param2;
                     if(_loc4_.isOnline == false)
                     {
                        _loc4_.battleInvitation = false;
                     }
                     _loc3_ = true;
                  }
               }
            }
         }
      }
      
      public function updateUsersStatistics(param1:Object, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         this.usersOnline = param1;
         this.usersInBattle_ladder = param2;
         this.usersInBattle_invitation = param3;
         this.usersInBattle_computer = param4;
         this.usersSearching = param5;
      }
      
      public function getRankIconNumber(param1:Number) : Number
      {
         var _loc2_:Number = Number(NaN);
         var _loc3_:Number = Number(NaN);
         _loc2_ = 62;
         _loc3_ = param1;
         if(_loc3_ < 1)
         {
            _loc3_ = 1;
         }
         else if(_loc3_ > _loc2_)
         {
            _loc3_ = _loc2_;
         }
         return _loc3_;
      }
      
      public function getLadderRankIconNumber(param1:Number) : Number
      {
         var _loc2_:Number = Number(NaN);
         _loc2_ = 1;
         if(this.ladderRankIconsDB[param1] != null)
         {
            _loc2_ = Number(this.ladderRankIconsDB[param1]);
         }
         return _loc2_;
      }
      
      public function createLadderProgressData() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         this.ladderRankByProgress = new Array();
         this.ladderProgressMaxByRank = new Array();
         _loc1_ = 0;
         _loc2_ = 0;
         while(_loc2_ < this.ladderRankMax)
         {
            _loc3_ = uint(this.ladderRankMax - _loc2_);
            _loc4_ = this.ladderProgressBase + Math.floor((this.ladderRankMax - _loc3_) / this.ladderRanksPerStar) + 1;
            _loc5_ = 1;
            while(_loc5_ <= _loc4_)
            {
               _loc1_ += 1;
               this.ladderRankByProgress[_loc1_] = _loc3_;
               _loc5_++;
            }
            this.ladderProgressMaxByRank[_loc3_] = _loc1_;
            _loc2_++;
         }
      }
      
      public function getLadderRankByProgress(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         if(this.gameType == "online")
         {
            if(this.ladderRankByProgress[param1] != null)
            {
               _loc2_ = uint(this.ladderRankByProgress[param1]);
            }
            else if(param1 > this.ladderProgressMaxByRank[1])
            {
               _loc2_ = 1;
            }
         }
         return _loc2_;
      }
      
      public function getLadderProgressMaxByRank(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         if(this.ladderProgressMaxByRank[param1] != null)
         {
            _loc2_ = uint(this.ladderProgressMaxByRank[param1]);
         }
         return _loc2_;
      }
      
      public function getLadderProgressBaseByRank(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         _loc2_ = 1;
         if(param1 < this.ladderRankMax)
         {
            param1 += 1;
            if(this.ladderProgressMaxByRank[param1] != null)
            {
               _loc2_ = this.ladderProgressMaxByRank[param1] + 1;
            }
         }
         return _loc2_;
      }
      
      public function mechIsOverWeight(param1:Array) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:BMPlayerData = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc2_ = false;
         _loc3_ = this.playersData[this.player1PlayerID];
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = uint(param1[_loc4_]);
            if(_loc3_.mechStructures[_loc5_].mechWeight > this.weightMax)
            {
               _loc2_ = true;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function traceReplayData(param1:Object) : void
      {
         trace("offlineReplayDB[" + param1.replayID + "] = { replayID:" + param1.replayID + ", playerID1:" + param1.playerID1 + ", playerID2:" + param1.playerID2 + ", name1:\'" + param1.name1 + "\', name2:\'" + param1.name2 + "\', level1:" + param1.level1 + ", level2:" + param1.level2 + ", mapStepsTotal:" + param1.mapStepsTotal + ", structure1:\'" + param1.structure1 + "\', structure2:\'" + param1.structure2 + "\', actions:\'" + param1.actions + "\', status1:\'" + param1.status1 + "\', status2:\'" + param1.status2 + "\', numberOfTurns:" + param1.numberOfTurns + "};");
      }
      
      private function createLocalReplays() : void
      {
      }
      
      public function addOnlineReplayData(param1:Object, param2:String) : void
      {
         var _loc3_:BMReplayData = null;
         var _loc4_:Number = Number(NaN);
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Boolean = false;
         var _loc11_:Number = Number(NaN);
         var _loc12_:String = null;
         var _loc13_:Number = Number(NaN);
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:BMMechStructure = null;
         var _loc19_:uint = 0;
         var _loc20_:String = null;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:Boolean = false;
         var _loc24_:BMReplayAction = null;
         var _loc25_:String = null;
         var _loc26_:Number = Number(NaN);
         var _loc27_:Boolean = false;
         var _loc28_:String = null;
         var _loc29_:String = null;
         var _loc30_:String = null;
         var _loc31_:BMReplayStatus = null;
         var _loc32_:Number = Number(NaN);
         var _loc33_:Number = Number(NaN);
         var _loc34_:Number = Number(NaN);
         _loc3_ = new BMReplayData();
         _loc6_ = false;
         if(param1.playerID2 == this.userID)
         {
            _loc11_ = Number(param1.playerID1);
            param1.playerID1 = param1.playerID2;
            param1.playerID2 = _loc11_;
            _loc12_ = param1.name1;
            param1.name1 = param1.name2;
            param1.name2 = _loc12_;
            _loc13_ = Number(param1.level1);
            param1.level1 = param1.level2;
            param1.level2 = _loc13_;
            _loc14_ = param1.flag1;
            param1.flag1 = param1.flag2;
            param1.flag2 = _loc14_;
            _loc15_ = param1.structure1;
            param1.structure1 = param1.structure2;
            param1.structure2 = _loc15_;
            _loc16_ = param1.status1;
            param1.status1 = param1.status2;
            param1.status2 = _loc16_;
            _loc3_.replayInverted = true;
            _loc6_ = true;
         }
         _loc3_.replayID = param1.replayID;
         _loc3_.tsCreated = param1.tsCreated;
         _loc3_.playerID1 = param1.playerID1;
         _loc3_.playerID2 = param1.playerID2;
         _loc3_.playerName1 = param1.name1;
         _loc3_.playerName2 = param1.name2;
         _loc3_.level1 = param1.level1;
         _loc3_.level2 = param1.level2;
         _loc3_.flag1 = param1.flag1;
         _loc3_.flag2 = param1.flag2;
         _loc3_.mapStepsTotal = param1.mapStepsTotal;
         _loc3_.floorBuffs = param1.floorBuffs;
         if(param1.mechsPerPlayer != null)
         {
            _loc3_.battleMechsPerPlayer = param1.mechsPerPlayer;
         }
         _loc4_ = 1;
         while(_loc4_ <= 2)
         {
            _loc17_ = param1["structure" + _loc4_];
            _loc18_ = new BMMechStructure();
            _loc19_ = 1;
            _loc18_.initialize(_loc4_,_loc19_);
            _loc20_ = "";
            _loc32_ = 0;
            while(_loc32_ < _loc17_.length)
            {
               _loc5_ = _loc17_.substr(_loc32_,1);
               if(_loc5_ == "_")
               {
                  _loc21_ = "";
                  _loc22_ = _loc20_.substr(0,2);
                  _loc23_ = false;
                  switch(_loc22_)
                  {
                     case "M2":
                     case "M3":
                        _loc23_ = true;
                        break;
                     case "TO":
                        _loc21_ = "torso";
                        break;
                     case "LE":
                        _loc21_ = "leg";
                        break;
                     case "SW":
                        _loc21_ = "sideWeapon";
                        break;
                     case "TW":
                        _loc21_ = "topWeapon";
                        break;
                     case "SL":
                        _loc21_ = "shield";
                        break;
                     case "DR":
                        _loc21_ = "drone";
                        break;
                     case "TP":
                        _loc21_ = "teleport";
                        break;
                     case "CH":
                        _loc21_ = "charge";
                        break;
                     case "HR":
                        _loc21_ = "harpoon";
                        break;
                     case "KI":
                        _loc21_ = "kit";
                        break;
                     case "MO":
                        _loc21_ = "module";
                  }
                  if(_loc23_)
                  {
                     _loc3_["player" + _loc4_ + "MechStructures"][_loc19_] = _loc18_;
                     _loc19_++;
                     _loc18_ = new BMMechStructure();
                     _loc18_.initialize(_loc4_,_loc19_);
                     _loc20_ = "";
                  }
                  else
                  {
                     _loc20_ = _loc20_.substr(3,_loc20_.length - 3);
                     switch(_loc21_)
                     {
                        case "torso":
                        case "leg":
                           _loc18_[_loc21_] = int(_loc20_.substr(0,_loc20_.length - 2));
                           _loc18_[_loc21_ + "_colorID"] = int(_loc20_.substr(_loc20_.length - 1,1));
                           break;
                        case "sideWeapon":
                        case "topWeapon":
                           _loc18_[_loc21_ + _loc20_.substr(0,1)] = int(_loc20_.substr(2,_loc20_.length - 4));
                           _loc18_[_loc21_ + _loc20_.substr(0,1) + "_colorID"] = int(_loc20_.substr(_loc20_.length - 1,1));
                           break;
                        case "shield":
                        case "drone":
                        case "teleport":
                        case "charge":
                        case "harpoon":
                           _loc18_[_loc21_] = int(_loc20_);
                           break;
                        case "kit":
                        case "module":
                           _loc18_[_loc21_ + _loc20_.substr(0,1)] = int(_loc20_.substr(2,_loc20_.length - 2));
                     }
                     _loc20_ = "";
                     if(_loc32_ == _loc17_.length - 1)
                     {
                        _loc3_["player" + _loc4_ + "MechStructures"][_loc19_] = _loc18_;
                     }
                  }
               }
               else
               {
                  _loc20_ += _loc5_;
               }
               _loc32_++;
            }
            _loc4_++;
         }
         _loc7_ = param1.actions;
         _loc32_ = 0;
         while(_loc32_ < _loc7_.length)
         {
            _loc24_ = new BMReplayAction();
            _loc25_ = _loc7_.substr(_loc32_,1);
            if(_loc25_ == "X")
            {
               _loc24_.actionName = "battleResult";
               _loc32_ += 1;
            }
            else
            {
               _loc26_ = int(_loc25_);
               if(_loc6_)
               {
                  if(_loc26_ == 1)
                  {
                     _loc26_ = 2;
                  }
                  else
                  {
                     _loc26_ = 1;
                  }
               }
               _loc24_.playerNumber = _loc26_;
               _loc32_ += 2;
               _loc25_ = _loc7_.substr(_loc32_,2);
               switch(_loc25_)
               {
                  case "FW":
                     _loc24_.actionName = "fire";
                     _loc32_ += 3;
                     _loc27_ = false;
                     switch(_loc7_.substr(_loc32_,1))
                     {
                        case "S":
                           _loc24_.equipmentType = "sideWeapon";
                           _loc27_ = true;
                           break;
                        case "T":
                           _loc24_.equipmentType = "topWeapon";
                           _loc27_ = true;
                           break;
                        case "D":
                           _loc24_.equipmentType = "drone";
                           break;
                        case "L":
                           _loc24_.equipmentType = "leg";
                     }
                     if(_loc27_)
                     {
                        _loc32_ += 2;
                        _loc24_.equipmentID = int(_loc7_.substr(_loc32_,1));
                     }
                     _loc32_ += 2;
                     break;
                  case "SH":
                     _loc24_.actionName = "shutDown";
                     _loc32_ += 3;
                     break;
                  case "KI":
                     _loc24_.actionName = "useKit";
                     _loc32_ += 3;
                     _loc24_.equipmentID = int(_loc7_.substr(_loc32_,1));
                     _loc32_ += 2;
                     break;
                  case "MV":
                     _loc24_.actionName = "moveMechToStep";
                     _loc32_ += 3;
                     switch(_loc7_.substr(_loc32_,1))
                     {
                        case "W":
                           _loc24_.motionType = "walk";
                           break;
                        case "J":
                           _loc24_.motionType = "jump";
                     }
                     _loc32_ += 2;
                     break;
                  case "TP":
                     _loc24_.actionName = "teleport";
                     _loc32_ += 3;
                     break;
                  case "CH":
                     _loc24_.actionName = "charge";
                     _loc32_ += 3;
                     break;
                  case "HR":
                     _loc24_.actionName = "harpoon";
                     _loc32_ += 3;
                     break;
                  case "DA":
                     _loc24_.actionName = "activateDrone";
                     _loc32_ += 3;
                     break;
                  case "DD":
                     _loc24_.actionName = "deactivateDrone";
                     _loc32_ += 3;
                     break;
                  case "SA":
                     _loc24_.actionName = "activateShield";
                     _loc32_ += 3;
                     break;
                  case "SD":
                     _loc24_.actionName = "deactivateShield";
                     _loc32_ += 3;
                     break;
                  case "SW":
                     _loc24_.actionName = "switchMech";
                     _loc32_ += 3;
                     _loc24_.mechID = int(_loc7_.substr(_loc32_,1));
                     _loc32_ += 2;
                     break;
                  case "QU":
                     _loc3_.quitPlayerID = _loc3_["playerID" + _loc24_.playerNumber];
                     _loc24_.actionName = "quit";
                     _loc32_ += 3;
               }
               _loc3_.actions.push(_loc24_);
            }
         }
         _loc8_ = 0;
         _loc9_ = 0;
         _loc4_ = 1;
         while(_loc4_ <= 2)
         {
            _loc28_ = param1["status" + _loc4_];
            _loc29_ = "AP";
            _loc30_ = "";
            _loc31_ = new BMReplayStatus();
            _loc32_ = 0;
            while(_loc32_ < _loc28_.length)
            {
               _loc5_ = _loc28_.substr(_loc32_,1);
               if(_loc5_ == "_")
               {
                  _loc33_ = int(_loc30_);
                  if(_loc6_ && _loc29_ == "step")
                  {
                     _loc33_ = _loc3_.mapStepsTotal - 1 - _loc33_;
                  }
                  _loc31_[_loc29_] = _loc33_;
                  if(_loc29_ == "HP")
                  {
                     if(_loc33_ <= 0)
                     {
                        _loc34_ = 1;
                        if(_loc4_ == 1)
                        {
                           _loc8_++;
                        }
                        else
                        {
                           _loc9_++;
                        }
                     }
                  }
                  switch(_loc29_)
                  {
                     case "AP":
                        _loc29_ = "HP";
                        break;
                     case "HP":
                        _loc29_ = "heat";
                        break;
                     case "heat":
                        _loc29_ = "energy";
                        break;
                     case "energy":
                        _loc29_ = "bullets";
                        break;
                     case "bullets":
                        _loc29_ = "rockets";
                        break;
                     case "rockets":
                        _loc29_ = "step";
                        break;
                     case "step":
                        _loc29_ = "shield";
                        break;
                     case "shield":
                        _loc29_ = "drone";
                        break;
                     case "drone":
                        _loc29_ = "resist1";
                        break;
                     case "resist1":
                        _loc29_ = "resist2";
                        break;
                     case "resist2":
                        _loc29_ = "resist3";
                        break;
                     case "resist3":
                        _loc29_ = "AP";
                  }
                  _loc30_ = "";
               }
               else if(_loc5_ == "X")
               {
                  _loc3_["status" + _loc4_].push(_loc31_);
                  if(_loc32_ < _loc28_.length - 1)
                  {
                     _loc31_ = new BMReplayStatus();
                     _loc30_ = "";
                  }
               }
               else
               {
                  _loc30_ += _loc5_;
               }
               _loc32_++;
            }
            _loc4_++;
         }
         if(_loc3_.quitPlayerID == 0)
         {
            if(_loc8_ > _loc9_)
            {
               _loc3_.wonPlayerID = _loc3_.playerID2;
            }
            else
            {
               _loc3_.wonPlayerID = _loc3_.playerID1;
            }
         }
         _loc3_.numberOfTurns = param1.numberOfTurns;
         _loc10_ = false;
         switch(param2)
         {
            case "online":
               if(this.replaysDB_online[_loc3_.replayID] != null)
               {
                  _loc10_ = Boolean(this.replaysDB_online[_loc3_.replayID].watched);
               }
               if(this.generalSharedObjectExists)
               {
                  if(this.generalSharedObject.data.users != null)
                  {
                     if(this.generalSharedObject.data.users[this.userID] != null)
                     {
                        if(this.generalSharedObject.data.users[this.userID].replaysWatched != null)
                        {
                           if(this.generalSharedObject.data.users[this.userID].replaysWatched[_loc3_.replayID] != null)
                           {
                              _loc10_ = true;
                           }
                        }
                     }
                  }
               }
               _loc3_.watched = _loc10_;
               this.replaysDB_online[_loc3_.replayID] = _loc3_;
               break;
            case "inspect":
               if(this.replaysDB_inspect[_loc3_.replayID] != null)
               {
                  _loc10_ = Boolean(this.replaysDB_inspect[_loc3_.replayID].watched);
               }
               if(this.generalSharedObjectExists)
               {
                  if(this.generalSharedObject.data.users != null)
                  {
                     if(this.generalSharedObject.data.users[this.userID] != null)
                     {
                        if(this.generalSharedObject.data.users[this.userID].replaysWatched != null)
                        {
                           if(this.generalSharedObject.data.users[this.userID].replaysWatched[_loc3_.replayID] != null)
                           {
                              _loc10_ = true;
                           }
                        }
                     }
                  }
               }
               _loc3_.watched = _loc10_;
               this.replaysDB_inspect[_loc3_.replayID] = _loc3_;
               break;
            case "offline":
               this.replaysDB_offline[_loc3_.replayID] = _loc3_;
         }
      }
      
      public function unpackReplay(param1:Number) : void
      {
         var _loc2_:BMReplayData = null;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:Number = Number(NaN);
         var _loc7_:Number = Number(NaN);
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc10_:Number = Number(NaN);
         var _loc11_:uint = 0;
         var _loc12_:BMPlayerProfile = null;
         var _loc13_:String = null;
         var _loc14_:BMMechStructure = null;
         var _loc15_:String = null;
         var _loc16_:Number = Number(NaN);
         _loc2_ = this.replaysDB[param1];
         this.battleMechsPerPlayer = _loc2_.battleMechsPerPlayer;
         _loc2_.watched = true;
         this.battleData = new Object();
         this.battleData.map = new Object();
         this.battleData.map.stepsTotal = _loc2_.mapStepsTotal;
         this.battleData.startingPlayer = 1;
         this.battleData.player1 = new Object();
         this.battleData.player2 = new Object();
         this.battleData.player1.currentStep = _loc2_.status1[0].step;
         this.battleData.player2.currentStep = _loc2_.status2[0].step;
         _loc3_ = new Object();
         if(_loc2_.floorBuffs != null)
         {
            if(_loc2_.floorBuffs != "")
            {
               _loc5_ = "";
               _loc6_ = 0;
               _loc8_ = 0;
               while(_loc8_ < _loc2_.floorBuffs.length)
               {
                  _loc9_ = _loc2_.floorBuffs.substr(_loc8_,1);
                  if(_loc9_ == "-")
                  {
                     if(_loc2_.replayInverted)
                     {
                        _loc6_ = _loc2_.mapStepsTotal - 1 - int(_loc5_);
                     }
                     else
                     {
                        _loc6_ = int(_loc5_);
                     }
                     _loc5_ = "";
                  }
                  else if(_loc9_ == "_" || _loc8_ == _loc2_.floorBuffs.length - 1)
                  {
                     if(_loc8_ == _loc2_.floorBuffs.length - 1)
                     {
                        _loc5_ += _loc9_;
                     }
                     switch(_loc5_)
                     {
                        case "D1":
                           _loc3_[_loc6_] = {
                              "step":_loc6_,
                              "type":"damage",
                              "subType":1
                           };
                           break;
                        case "D2":
                           _loc3_[_loc6_] = {
                              "step":_loc6_,
                              "type":"damage",
                              "subType":2
                           };
                           break;
                        case "D3":
                           _loc3_[_loc6_] = {
                              "step":_loc6_,
                              "type":"damage",
                              "subType":3
                           };
                           break;
                        case "DH":
                           _loc3_[_loc6_] = {
                              "step":_loc6_,
                              "type":"damageHeat"
                           };
                           break;
                        case "DE":
                           _loc3_[_loc6_] = {
                              "step":_loc6_,
                              "type":"damageEnergy"
                           };
                           break;
                        case "ER":
                           _loc3_[_loc6_] = {
                              "step":_loc6_,
                              "type":"energyRegeneration"
                           };
                           break;
                        case "HC":
                           _loc3_[_loc6_] = {
                              "step":_loc6_,
                              "type":"heatCooling"
                           };
                           break;
                        case "IR":
                           _loc3_[_loc6_] = {
                              "step":_loc6_,
                              "type":"ignoreResistance"
                           };
                     }
                     _loc5_ = "";
                  }
                  else
                  {
                     _loc5_ += _loc9_;
                  }
                  _loc8_++;
               }
               this.battle_floorBuffsData = _loc3_;
            }
         }
         _loc4_ = this.player1PlayerID;
         while(_loc4_ <= this.player2PlayerID)
         {
            _loc10_ = this.getInterfacePlayerID(_loc4_);
            _loc11_ = 1;
            while(_loc11_ <= this.battleMechsPerPlayer)
            {
               _loc14_ = _loc2_["player" + _loc10_ + "MechStructures"][_loc11_];
               if(_loc11_ == 1)
               {
                  this["playerData" + _loc4_ + "Inventory"] = new Object();
                  this["player" + _loc4_ + "playerItemIDCounter"] = 1;
               }
               _loc15_ = this.getCensoredString(_loc2_["playerName" + _loc10_]);
               _loc16_ = Number(_loc2_["level" + _loc10_]);
               this.createProfile(_loc4_,_loc15_,_loc16_);
               this.createMechStructures_playerItemBased(_loc4_,_loc11_,_loc14_,-1,-1);
               this.createMechLocally(_loc4_,_loc11_);
               _loc11_++;
            }
            this.createPlayerData(_loc4_,"screenReplay");
            _loc12_ = this["player" + _loc4_ + "Profile"];
            _loc12_.updateLevelByItems();
            _loc13_ = _loc2_["flag" + _loc10_];
            if(_loc13_ != "")
            {
               _loc12_.clanID = _loc10_;
               _loc12_.clan_flag = _loc2_["flag" + _loc10_];
            }
            _loc4_++;
         }
         this.battle_replayData = this.replaysDB[param1];
         screensM.addBattleScreens();
         if(this.gameType == "replay")
         {
            switch(this.gameSubType)
            {
               case "onlineRegular":
                  screensM.removeScreen("screenTopBar");
                  break;
               case "onlineRankingListInspect":
                  screensM.removeScreen("screenInspectPlayer");
                  break;
               case "onlineTopPlayers":
               case "onlineMenuChatInspect":
               case "SMTV":
                  screensM.removeScreen("screenMenuMultiPlayerInspect");
                  screensM.removeScreen("screenInspectPlayer");
                  break;
               case "onlineClanInspect":
                  screensM.removeScreen("screenInspectPlayer");
            }
         }
         screensM.screenNewMenu.removeCurrentScreen();
         screensM.screenNewMenu.removeMe();
      }
      
      public function getBattleCreditX1Cost() : Number
      {
         var _loc1_:BMPlayerProfile = null;
         var _loc2_:Number = Number(NaN);
         _loc1_ = this["player" + this.player1PlayerID + "Profile"];
         _loc2_ = this.battleCreditX1CostGold;
         if(_loc1_.tokensSpent)
         {
            _loc2_ = this.battleCreditX1CostGold_supporters;
         }
         if(this.useBattleCreditsPriceIncrease)
         {
            _loc2_ += Math.ceil(_loc2_ * this.battleCreditsPriceIncrease * _loc1_.battleCreditsBought / 100);
         }
         return _loc2_;
      }
      
      public function getBattleCreditX6Cost() : Number
      {
         var _loc1_:BMPlayerProfile = null;
         var _loc2_:Number = Number(NaN);
         _loc1_ = this["player" + this.player1PlayerID + "Profile"];
         _loc2_ = this.battleCreditX6CostGold;
         if(_loc1_.tokensSpent)
         {
            _loc2_ = this.battleCreditX6CostGold_supporters;
         }
         if(this.useBattleCreditsPriceIncrease)
         {
            _loc2_ += Math.ceil(_loc2_ * this.battleCreditsPriceIncrease * _loc1_.battleCreditsBought / 100);
         }
         return _loc2_;
      }
      
      public function refreshMovieClipParticlesRatio() : void
      {
         this.movieClipParticleEffects = true;
         switch(this.movieClipParticleEffectsLevel)
         {
            case 0:
               this.movieClipParticleEffectsRatio = 0;
               this.movieClipParticleEffects = false;
               break;
            case 1:
               this.movieClipParticleEffectsRatio = 0.2;
               break;
            case 2:
               this.movieClipParticleEffectsRatio = 0.5;
               break;
            case 3:
               this.movieClipParticleEffectsRatio = 1;
         }
      }
      
      public function getLocalGraphicIcon(param1:String) : MovieClip
      {
         var _loc3_:MovieClip = null;
         var _loc2_:Class = Class(getDefinitionByName(param1));
         _loc3_ = new _loc2_();
         if(this.runAsMobile)
         {
            _loc3_["cacheAsBitmapMatrix"] = new Matrix();
         }
         _loc3_.cacheAsBitmap = true;
         return _loc3_;
      }
      
      public function getAvatarImage(param1:String) : BMAvatarImage
      {
         var _loc2_:BMAvatarImage = null;
         var _loc3_:* = null;
         _loc2_ = new BMAvatarImage();
         _loc3_ = "http://images.battlegate.net/Misc/flags/" + param1.toLowerCase() + ".png";
         _loc2_.initialize(0,_loc3_,17,12);
         return _loc2_;
      }
      
      public function applyForNewAvatarImage(param1:BMAvatarImage, param2:String, param3:Number, param4:Number) : void
      {
         throw new IllegalOperationError("Not decompiled due to timeout");
      }
      
      internal function avatarImageUpdateInfo(param1:ProgressEvent) : void
      {
      }
      
      internal function avatarImageLoadingError(param1:IOErrorEvent) : void
      {
      }
      
      internal function avatarImageDoneLoad(param1:Event) : void
      {
         throw new IllegalOperationError("Not decompiled due to timeout");
      }
      
      private function sendAvatarImageToAllRequests(param1:String) : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:Bitmap = null;
         _loc2_ = this.avatarImages[param1];
         _loc3_ = 0;
         while(_loc3_ < _loc2_.requests.length)
         {
            if(_loc2_.requests[_loc3_] != null)
            {
               _loc4_ = new Bitmap(Bitmap(_loc2_.loader.content).bitmapData);
               _loc2_.requests[_loc3_].setAvatarImage(_loc4_);
            }
            _loc3_++;
         }
         _loc2_.requests = new Array();
      }
      
      public function openURL(param1:String, param2:String) : void
      {
         navigateToURL(new URLRequest(param1),param2);
      }
      
      public function refreshClient() : void
      {
         var _loc1_:String = null;
         _loc1_ = ExternalInterface.call("window.location.href.toString");
         if(_loc1_)
         {
            navigateToURL(new URLRequest(_loc1_),"_self");
         }
         else
         {
            navigateToURL(new URLRequest("/"),"_self");
         }
      }
      
      public function emailSuperMechs() : void
      {
         var _loc1_:URLRequest = null;
         _loc1_ = new URLRequest("mailto:supermechs@tacticsoft.net" + "?subject=Video for YouTube channel" + "&body=Hello SuperMechs team,");
         navigateToURL(_loc1_,"_blank");
         _loc1_.method = URLRequestMethod.POST;
      }
      
      public function convertStringIntoDate(param1:String) : Date
      {
         var _loc2_:Number = Number(NaN);
         var _loc3_:Number = Number(NaN);
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         var _loc6_:Number = Number(NaN);
         var _loc8_:Number = Number(NaN);
         _loc2_ = int(param1.substr(0,4));
         _loc3_ = int(param1.substr(5,2));
         _loc4_ = int(param1.substr(8,2));
         _loc5_ = int(param1.substr(11,2));
         _loc6_ = int(param1.substr(14,2));
         _loc8_ = int(param1.substr(17,2));
         return new Date(_loc2_,_loc3_ - 1,_loc4_,_loc5_,_loc6_,_loc8_);
      }
      
      public function getNumberWithComma(param1:Number) : String
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         _loc2_ = false;
         if(param1 < 0)
         {
            _loc2_ = true;
            param1 *= -1;
         }
         _loc3_ = String(param1);
         if(_loc3_.length == 4)
         {
            _loc3_ = _loc3_.substr(0,1) + "," + _loc3_.substr(1,3);
         }
         else if(_loc3_.length == 5)
         {
            _loc3_ = _loc3_.substr(0,2) + "," + _loc3_.substr(2,3);
         }
         else if(_loc3_.length == 6)
         {
            _loc3_ = _loc3_.substr(0,3) + "," + _loc3_.substr(3,3);
         }
         else if(_loc3_.length == 7)
         {
            _loc3_ = _loc3_.substr(0,1) + "," + _loc3_.substr(1,3) + "," + _loc3_.substr(4,3);
         }
         else if(_loc3_.length == 8)
         {
            _loc3_ = _loc3_.substr(0,2) + "," + _loc3_.substr(2,3) + "," + _loc3_.substr(5,3);
         }
         else if(_loc3_.length == 9)
         {
            _loc3_ = _loc3_.substr(0,3) + "," + _loc3_.substr(3,3) + "," + _loc3_.substr(6,3);
         }
         else if(_loc3_.length == 10)
         {
            _loc3_ = _loc3_.substr(0,1) + "," + _loc3_.substr(1,3) + "," + _loc3_.substr(4,3) + "," + _loc3_.substr(7,3);
         }
         if(_loc2_)
         {
            _loc3_ = "-" + _loc3_;
         }
         return _loc3_;
      }
      
      public function replaceStringInText(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:uint = 0;
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            if(param1.substr(_loc4_,param2.length) == param2)
            {
               param1 = param1.substr(0,_loc4_) + param3 + param1.substr(_loc4_ + param2.length,param1.length - _loc4_ - (param2.length - 1));
               _loc4_ = uint(_loc4_ + param2.length - 1);
            }
            _loc4_++;
         }
         return param1;
      }
      
      public function createWeeklyWinnersData(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         this.weeklySoloWinners = new Object();
         this.weeklyClanWinners = new Object();
         this.weeklyTopClans = new Object();
         if(param1 != null)
         {
            for each(_loc2_ in param1)
            {
               _loc3_ = _loc2_.topList.split(",");
               this.addWeeklySoloWin(_loc3_[0],1);
               this.addWeeklySoloWin(_loc3_[1],2);
               this.addWeeklySoloWin(_loc3_[2],3);
               if(_loc2_.clanRank1PlayerIDs != null)
               {
                  _loc5_ = _loc2_.clanRank1PlayerIDs.split(",");
                  _loc4_ = 0;
                  while(_loc4_ < _loc5_.length)
                  {
                     this.addWeeklyClanWin(_loc5_[_loc4_],1);
                     _loc4_++;
                  }
                  _loc6_ = _loc2_.clanRank2PlayerIDs.split(",");
                  _loc4_ = 0;
                  while(_loc4_ < _loc6_.length)
                  {
                     this.addWeeklyClanWin(_loc6_[_loc4_],2);
                     _loc4_++;
                  }
                  _loc7_ = _loc2_.clanRank3PlayerIDs.split(",");
                  _loc4_ = 0;
                  while(_loc4_ < _loc7_.length)
                  {
                     this.addWeeklyClanWin(_loc7_[_loc4_],3);
                     _loc4_++;
                  }
                  _loc8_ = _loc2_.topClans.split(",");
                  _loc4_ = 0;
                  while(_loc4_ < _loc8_.length)
                  {
                     this.addWeeklyTopClan(_loc8_[_loc4_],_loc4_ + 1);
                     _loc4_++;
                  }
               }
            }
         }
         if(this.clientRunningLocally)
         {
            this.addWeeklySoloWin(11725,1);
            this.addWeeklySoloWin(11725,2);
            this.addWeeklySoloWin(11725,1);
            _loc9_ = 0;
            while(_loc9_ < 34)
            {
               this.addWeeklyClanWin(11725,3);
               this.addWeeklyClanWin(11725,2);
               this.addWeeklyClanWin(11725,3);
               this.addWeeklyTopClan(127752,1);
               _loc9_++;
            }
         }
      }
      
      private function addWeeklySoloWin(param1:Number, param2:Number) : void
      {
         if(param1 > 0)
         {
            if(this.weeklySoloWinners[param1] == null)
            {
               this.weeklySoloWinners[param1] = new Object();
               this.weeklySoloWinners[param1].places = new Array();
               this.weeklySoloWinners[param1].places[1] = 0;
               this.weeklySoloWinners[param1].places[2] = 0;
               this.weeklySoloWinners[param1].places[3] = 0;
            }
            ++this.weeklySoloWinners[param1].places[param2];
         }
      }
      
      private function addWeeklyClanWin(param1:Number, param2:Number) : void
      {
         if(param1 > 0)
         {
            if(this.weeklyClanWinners[param1] == null)
            {
               this.weeklyClanWinners[param1] = new Object();
               this.weeklyClanWinners[param1].places = new Array();
               this.weeklyClanWinners[param1].places[1] = 0;
               this.weeklyClanWinners[param1].places[2] = 0;
               this.weeklyClanWinners[param1].places[3] = 0;
            }
            ++this.weeklyClanWinners[param1].places[param2];
         }
      }
      
      private function addWeeklyTopClan(param1:Number, param2:Number) : void
      {
         if(param1 > 0)
         {
            if(this.weeklyTopClans[param1] == null)
            {
               this.weeklyTopClans[param1] = new Object();
               this.weeklyTopClans[param1].places = new Array();
               this.weeklyTopClans[param1].places[1] = 0;
               this.weeklyTopClans[param1].places[2] = 0;
               this.weeklyTopClans[param1].places[3] = 0;
            }
            ++this.weeklyTopClans[param1].places[param2];
         }
      }
      
      public function showGetTokensScreen() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:BMPlayerProfile = null;
         _loc1_ = false;
         if(this.gameType == "online")
         {
            _loc2_ = this["player" + this.player1PlayerID + "Profile"];
            if(_loc2_.tokens < 250)
            {
               if(this.runAsMobile == false && this.usePersonaly)
               {
                  _loc1_ = true;
               }
            }
         }
         return _loc1_;
      }
      
      private function initializeGuestSharedObject() : void
      {
         trace("!!! GUEST SHARED OBJECT INITIALIZED");
         this.guestSharedObject = SharedObject.getLocal("superMechsGuest");
         if(this.guestSharedObject.data != null)
         {
            if(this.guestSharedObject.data.items != undefined)
            {
               trace(">>> GUEST SHARED OBJECT HAS DATA");
               this.guestSharedObjectExists = true;
            }
         }
      }
      
      public function saveGuestData(param1:String) : void
      {
         var _loc2_:BMPlayerData = null;
         var _loc3_:uint = 0;
         var _loc4_:BMPlayerProfile = null;
         var _loc5_:BMPlayerItemData = null;
         var _loc6_:Date = null;
         if(this.gameType == "guest")
         {
            this.resetGuestSharedObject("saveGuestData");
            _loc2_ = this.playersData[this.OFFLINE_PLAYER_ID];
            this.guestSharedObject.data.items = new Array();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.items.length)
            {
               _loc5_ = _loc2_.items[_loc3_];
               this.guestSharedObject.data.items.push(_loc5_);
               _loc3_++;
            }
            _loc4_ = this["player" + this.OFFLINE_PLAYER_ID + "Profile"];
            this.guestSharedObject.data.profile = new Object();
            this.guestSharedObject.data.profile.gold = _loc4_.gold;
            this.guestSharedObject.data.profile.tokens = _loc4_.tokens;
            this.guestSharedObject.data.profile.totalGoldGained = _loc4_.totalGoldGained;
            this.guestSharedObject.data.profile.XP = _loc4_.XP;
            this.guestSharedObject.data.profile.totalXPGained = _loc4_.totalXPGained;
            this.guestSharedObject.data.profile.level = _loc4_.level;
            this.guestSharedObject.data.profile.battlesVSComputer = _loc4_.battlesVSComputer;
            this.guestSharedObject.data.profile.winsVSComputer = _loc4_.winsVSComputer;
            this.guestSharedObject.data.profile.campaignWins = _loc4_.campaignWins;
            this.guestSharedObject.data.profile.campaignLosesStreak = _loc4_.campaignLosesStreak;
            this.guestSharedObject.data.profile.tutorialLevel = _loc4_.tutorialLevel;
            this.guestSharedObject.data.profile.premiumAccountTime = this.premiumAccountTime;
            this.guestSharedObject.data.profile.freePackages = _loc4_.getFreePackagesString();
            this.guestSharedObject.data.profile.playerName = _loc4_.playerName;
            this.guestSharedObject.data.profile.campaignMissionsData = _loc4_.campaignMissionsData;
            this.guestSharedObject.data.profile.mission_layout = _loc4_.mission_layout;
            this.guestSharedObject.data.profile.mission_hp = _loc4_.mission_hp;
            this.guestSharedObject.data.profile.mission_energy = _loc4_.mission_energy;
            this.guestSharedObject.data.profile.mission_energyRegeneration = _loc4_.mission_energyRegeneration;
            this.guestSharedObject.data.profile.mission_heat = _loc4_.mission_heat;
            this.guestSharedObject.data.profile.mission_heatCooling = _loc4_.mission_heatCooling;
            this.guestSharedObject.data.profile.mission_bullets = _loc4_.mission_bullets;
            this.guestSharedObject.data.profile.mission_rockets = _loc4_.mission_rockets;
            this.guestSharedObject.data.profile.mission_startingPosition = _loc4_.mission_startingPosition;
            this.guestSharedObject.data.profile.mission_playerPosition = _loc4_.mission_playerPosition;
            this.guestSharedObject.data.profile.mission_themeID = _loc4_.mission_themeID;
            this.guestSharedObject.data.profile.mission_flag = _loc4_.mission_flag;
            this.guestSharedObject.data.profile.mission_rows = _loc4_.mission_rows;
            this.guestSharedObject.data.profile.mission_columns = _loc4_.mission_columns;
            this.guestSharedObject.data.profile.mission_gold = _loc4_.mission_gold;
            this.guestSharedObject.data.profile.mission_difficulty = _loc4_.mission_difficulty;
            this.guestSharedObject.data.profile.mission_colorID = _loc4_.mission_colorID;
            this.guestSharedObject.data.profile.mission_progress = new Array();
            _loc3_ = 0;
            while(_loc3_ < _loc4_.mission_progress.length)
            {
               this.guestSharedObject.data.profile.mission_progress.push(_loc4_.mission_progress[_loc3_]);
               _loc3_++;
            }
            this.guestSharedObject.data.profile.mission_upgrades = new Array();
            _loc3_ = 0;
            while(_loc3_ < _loc4_.mission_upgrades.length)
            {
               this.guestSharedObject.data.profile.mission_upgrades.push(_loc4_.mission_upgrades[_loc3_]);
               _loc3_++;
            }
            this.guestSharedObject.data.profile.mission_loot = new Array();
            _loc3_ = 0;
            while(_loc3_ < _loc4_.mission_loot.length)
            {
               this.guestSharedObject.data.profile.mission_loot.push(_loc4_.mission_loot[_loc3_]);
               _loc3_++;
            }
            this.guestSharedObject.data.profile.mapProgress = new Array();
            _loc3_ = 0;
            while(_loc3_ < _loc4_.mapProgress.length)
            {
               this.guestSharedObject.data.profile.mapProgress.push(_loc4_.mapProgress[_loc3_]);
               _loc3_++;
            }
            this.guestSharedObject.data.profile.missionsAvailable = new Array();
            _loc3_ = 0;
            while(_loc3_ < _loc4_.missionsAvailable.length)
            {
               this.guestSharedObject.data.profile.missionsAvailable.push(_loc4_.missionsAvailable[_loc3_]);
               _loc3_++;
            }
            this.guestSharedObject.data.profile.missionID = _loc4_.missionID;
            this.guestSharedObject.data.profile.currentMissionSlot = _loc4_.currentMissionSlot;
            if(this.lastBattleCreditAddon == 0)
            {
               _loc6_ = new Date();
               this.lastBattleCreditAddon = Math.ceil(_loc6_.getTime() / 1000);
            }
            this.guestSharedObject.data.profile.battleCredits = _loc4_.battleCredits;
            this.guestSharedObject.data.profile.lastBattleCreditAddon = this.lastBattleCreditAddon;
            this.guestSharedObject.flush();
            this.guestSharedObjectExists = true;
         }
      }
      
      public function resetGuestSharedObject(param1:String) : void
      {
         this.guestSharedObject.clear();
         this.guestSharedObject.flush();
         this.guestSharedObjectExists = false;
      }
      
      private function loadSharedObjectGuestData() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:BMPlayerProfile = null;
         var _loc3_:Object = null;
         var _loc4_:Date = null;
         var _loc5_:Object = null;
         var _loc6_:Number = Number(NaN);
         if(this.guestSharedObjectExists)
         {
            this["playerData" + this.OFFLINE_PLAYER_ID + "Inventory"] = new Object();
            this["player" + this.OFFLINE_PLAYER_ID + "playerItemIDCounter"] = 1;
            _loc1_ = 0;
            while(_loc1_ < this.guestSharedObject.data.items.length)
            {
               _loc5_ = this.guestSharedObject.data.items[_loc1_];
               _loc6_ = 0;
               if(_loc5_.power != null)
               {
                  _loc6_ = Number(_loc5_.power);
               }
               this.addInventoryItem(this.OFFLINE_PLAYER_ID,this["playerData" + this.OFFLINE_PLAYER_ID + "Inventory"],_loc5_.itemID,_loc5_.equipped,_loc5_.equipmentType,_loc5_.equipmentID,_loc5_.colorID,_loc6_);
               _loc1_++;
            }
            _loc2_ = this["player" + this.OFFLINE_PLAYER_ID + "Profile"];
            _loc3_ = this.guestSharedObject.data.profile;
            _loc2_.gold = _loc3_.gold;
            _loc2_.totalGoldGained = _loc3_.totalGoldGained;
            _loc2_.XP = _loc3_.XP;
            _loc2_.totalXPGained = _loc3_.totalXPGained;
            _loc2_.level = _loc3_.level;
            _loc2_.lastLevel = _loc2_.level;
            _loc2_.battlesVSComputer = _loc3_.battlesVSComputer;
            _loc2_.winsVSComputer = _loc3_.winsVSComputer;
            if(_loc3_.ladderWins != null)
            {
               _loc2_.campaignWins = _loc3_.ladderWins;
            }
            if(_loc3_.campaignWins != null)
            {
               _loc2_.campaignWins = _loc3_.campaignWins;
            }
            if(_loc3_.ladderLosesStreak != null)
            {
               _loc2_.campaignLosesStreak = _loc3_.ladderLosesStreak;
            }
            if(_loc3_.campaignLosesStreak != null)
            {
               _loc2_.campaignLosesStreak = _loc3_.campaignLosesStreak;
            }
            if(_loc3_.tutorialLevel != null)
            {
               _loc2_.tutorialLevel = _loc3_.tutorialLevel;
               if(_loc2_.tutorialLevel >= this.tutorialLevelsDB.length)
               {
                  this.tutorialSkipped = true;
               }
            }
            if(_loc3_.premiumAccountTime != null)
            {
               this.premiumAccountTime = _loc3_.premiumAccountTime;
            }
            if(_loc3_.tokens != null)
            {
               _loc2_.tokens = _loc3_.tokens;
            }
            if(_loc3_.freePackages != null)
            {
               if(_loc3_.freePackages != "")
               {
                  _loc2_.setFreePackages(_loc3_.freePackages);
               }
            }
            else
            {
               _loc2_.setFreePackages(this.FREE_PACKAGES_DEFAULT_STRING);
            }
            if(_loc3_.playerName != null)
            {
               _loc2_.playerName = _loc3_.playerName;
            }
            else
            {
               _loc2_.playerName = getGeneralText("guest");
            }
            if(_loc3_.campaignMissionsData != null)
            {
               _loc2_.campaignMissionsData = _loc3_.campaignMissionsData;
            }
            else
            {
               _loc2_.resetCampaignMissionsData();
            }
            _loc2_.mission_layout = _loc3_.mission_layout;
            _loc2_.mission_hp = _loc3_.mission_hp;
            _loc2_.mission_energy = _loc3_.mission_energy;
            _loc2_.mission_energyRegeneration = _loc3_.mission_energyRegeneration;
            _loc2_.mission_heat = _loc3_.mission_heat;
            _loc2_.mission_heatCooling = _loc3_.mission_heatCooling;
            _loc2_.mission_bullets = _loc3_.mission_bullets;
            _loc2_.mission_rockets = _loc3_.mission_rockets;
            _loc2_.mission_startingPosition = _loc3_.mission_startingPosition;
            _loc2_.mission_playerPosition = _loc3_.mission_startingPosition;
            _loc2_.mission_themeID = _loc3_.mission_themeID;
            _loc2_.mission_flag = _loc3_.mission_flag;
            _loc2_.mission_rows = _loc3_.mission_rows;
            _loc2_.mission_columns = _loc3_.mission_columns;
            _loc2_.mission_gold = _loc3_.mission_gold;
            _loc2_.mission_difficulty = _loc3_.mission_difficulty;
            _loc2_.mission_colorID = _loc3_.mission_colorID;
            if(_loc3_.mission_progress != null)
            {
               _loc1_ = 0;
               while(_loc1_ < _loc3_.mission_progress.length)
               {
                  _loc2_.mission_progress.push(_loc3_.mission_progress[_loc1_]);
                  _loc1_++;
               }
            }
            if(_loc3_.mission_upgrades != null)
            {
               _loc1_ = 0;
               while(_loc1_ < _loc3_.mission_upgrades.length)
               {
                  _loc2_.mission_upgrades.push(_loc3_.mission_upgrades[_loc1_]);
                  _loc1_++;
               }
            }
            if(_loc3_.mission_loot != null)
            {
               _loc1_ = 0;
               while(_loc1_ < _loc3_.mission_loot.length)
               {
                  _loc2_.mission_loot.push(_loc3_.mission_loot[_loc1_]);
                  _loc1_++;
               }
            }
            if(_loc3_.mapProgress != null)
            {
               _loc1_ = 0;
               while(_loc1_ < _loc3_.mapProgress.length)
               {
                  _loc2_.mapProgress.push(_loc3_.mapProgress[_loc1_]);
                  _loc1_++;
               }
            }
            _loc2_.missionsAvailable = new Array();
            if(_loc3_.missionsAvailable != null)
            {
               _loc1_ = 0;
               while(_loc1_ < _loc3_.missionsAvailable.length)
               {
                  _loc2_.missionsAvailable.push(_loc3_.missionsAvailable[_loc1_]);
                  _loc1_++;
               }
            }
            _loc2_.missionID = _loc3_.missionID;
            _loc2_.currentMissionSlot = _loc3_.currentMissionSlot;
            _loc2_.battleCredits = _loc3_.battleCredits;
            this.lastBattleCreditAddon = _loc3_.lastBattleCreditAddon;
            _loc4_ = new Date();
            this.currentTime = Math.ceil(_loc4_.getTime() / 1000);
            _loc2_.updateWinsTotal();
         }
      }
      
      private function initializeGeneralSharedObject() : void
      {
         var _loc1_:String = null;
         trace("!!! GENERAL SHARED OBJECT INITIALIZED");
         this.generalSharedObject = SharedObject.getLocal("superMechsGeneral");
         if(this.generalSharedObject.data != null)
         {
            if(this.generalSharedObject.data.lastUsername != undefined)
            {
               trace(">>> GENERAL SHARED OBJECT HAS DATA");
               this.generalSharedObjectExists = true;
            }
            trace(">>>>>>>>>>>>>>>>>>>>>> generalSharedObject.data.lastLanguageID:" + this.generalSharedObject.data.lastLanguageID);
            if(this.generalSharedObject.data.lastLanguageID != null)
            {
               this.languageID = this.generalSharedObject.data.lastLanguageID;
            }
            else if(this.useLanguages)
            {
               _loc1_ = Capabilities.language;
               _loc1_ = Capabilities.languages[0];
               trace("GGGGGGG----------------GGGGGG:" + _loc1_);
               switch(_loc1_)
               {
                  case "en":
                     this.languageID = 1;
                     break;
                  case "de":
                     this.languageID = 5;
                     break;
                  case "ru":
                     this.languageID = 3;
                     break;
                  case "it":
                     this.languageID = 6;
                     break;
                  case "pt":
                     this.languageID = 7;
                     break;
                  case "es":
                     this.languageID = 8;
                     break;
                  case "pl":
                     this.languageID = 9;
                     break;
                  case "hu":
                     this.languageID = 10;
                     break;
                  case "cs":
                  case "da":
                  case "nl":
                  case "fi":
                  case "ja":
                  case "ko":
                  case "nb":
                  case "xu":
                  case "zh-CN":
                  case "zh-TW":
                  case "sv":
                  case "tr":
               }
            }
            this.createTipsDB();
            this.createInfoTextDB();
            this.createBattleInterfaceToolTipDB();
            this.clientLastLanguageID = this.languageID;
         }
         if(this.generalSharedObjectExists == false)
         {
            this.generalSharedObject.data.lastUsername = "";
            this.generalSharedObject.data.lastPassword = "";
            this.generalSharedObject.data.lastLanguageID = this.languageID;
            this.generalSharedObject.data.users = new Object();
            this.generalSharedObject.flush();
         }
      }
      
      public function saveUsernameData() : void
      {
         this.generalSharedObject.data.lastUsername = this.userName;
         this.generalSharedObject.flush();
      }
      
      public function saveLanguageData() : void
      {
         this.generalSharedObject.data.lastLanguageID = this.languageID;
         this.generalSharedObject.flush();
      }
      
      public function saveGeneralSharedObjectData() : void
      {
         var _loc1_:BMReplayData = null;
         var _loc2_:BMPlayerProfile = null;
         this.generalSharedObject.data.lastLanguageID = this.languageID;
         if(this.gameType == "online")
         {
            if(screensM.isScreenOpened("screenWelcomeLogin"))
            {
               this.generalSharedObject.data.lastPassword = "";
               if(screensM.screenWelcomeLogin.mcRememberPasswordV.visible)
               {
                  this.generalSharedObject.data.lastPassword = screensM.screenWelcomeLogin.txtInputPassword.text;
               }
            }
            else
            {
               if(this.generalSharedObject.data.users == null)
               {
                  this.generalSharedObject.data.users = new Object();
               }
               if(this.generalSharedObject.data.users[this.userID] == null)
               {
                  this.generalSharedObject.data.users[this.userID] = new Object();
               }
               if(this.generalSharedObject.data.users[this.userID].replaysWatched == null)
               {
                  this.generalSharedObject.data.users[this.userID].replaysWatched = new Object();
               }
               for each(_loc1_ in this.replaysDB_inspect)
               {
                  if(_loc1_.watched)
                  {
                     this.generalSharedObject.data.users[this.userID].replaysWatched[_loc1_.replayID] = true;
                  }
               }
               if(this.generalSharedObject.data.users[this.userID].winningLosingStreaks == null)
               {
                  this.generalSharedObject.data.users[this.userID].winningLosingStreaks = new Object();
               }
               _loc2_ = this["player" + this.ONLINE_PLAYER_ID + "Profile"];
               this.generalSharedObject.data.users[this.userID].winningLosingStreaks.winningStreakVSComputer = _loc2_.winningStreakVSComputer;
               this.generalSharedObject.data.users[this.userID].winningLosingStreaks.winningStreakVSComputerThisLevel = _loc2_.winningStreakVSComputerThisLevel;
               this.generalSharedObject.data.users[this.userID].winningLosingStreaks.losingStreakVSComputer = _loc2_.losingStreakVSComputer;
               this.generalSharedObject.data.users[this.userID].winningLosingStreaks.computerLevelAddon = _loc2_.computerLevelAddon;
               this.generalSharedObject.data.users[this.userID].winningLosingStreaks.campaignLosesStreak = _loc2_.campaignLosesStreak;
               if(this.generalSharedObject.data.users[this.userID].general == null)
               {
                  this.generalSharedObject.data.users[this.userID].general = new Object();
               }
               this.generalSharedObject.data.users[this.userID].general.mechBuilds = new Array();
               this.generalSharedObject.data.users[this.userID].general.expandedInventory = _loc2_.expandedInventorySortingMessageDisplayed;
            }
         }
         this.generalSharedObject.flush();
      }
      
      public function resetGeneralSharedObject() : void
      {
         var _loc1_:String = null;
         _loc1_ = "";
         if(this.generalSharedObject.data != null)
         {
            if(this.generalSharedObject.data.lastUsername != null)
            {
               _loc1_ = this.generalSharedObject.data.lastUsername;
            }
         }
         this.generalSharedObject.clear();
         this.generalSharedObject.flush();
         if(_loc1_ != "")
         {
            this.generalSharedObject.data.lastUsername = _loc1_;
            this.generalSharedObject.data.lastLanguageID = this.languageID;
         }
      }
      
      public function loadGeneralSharedObjectData() : void
      {
         var _loc1_:BMPlayerProfile = null;
         if(this.generalSharedObjectExists)
         {
            if(this.gameType == "online")
            {
               if(this.generalSharedObject.data.users != null)
               {
                  if(this.generalSharedObject.data.users[this.userID] != null)
                  {
                     if(this.generalSharedObject.data.users[this.userID].winningLosingStreaks != null)
                     {
                        _loc1_ = this["player" + this.ONLINE_PLAYER_ID + "Profile"];
                        _loc1_.winningStreakVSComputer = this.generalSharedObject.data.users[this.userID].winningLosingStreaks.winningStreakVSComputer;
                        _loc1_.winningStreakVSComputerThisLevel = this.generalSharedObject.data.users[this.userID].winningLosingStreaks.winningStreakVSComputerThisLevel;
                        _loc1_.losingStreakVSComputer = this.generalSharedObject.data.users[this.userID].winningLosingStreaks.losingStreakVSComputer;
                        _loc1_.computerLevelAddon = this.generalSharedObject.data.users[this.userID].winningLosingStreaks.computerLevelAddon;
                        if(this.generalSharedObject.data.users[this.userID].winningLosingStreaks.ladderLosesStreak != null)
                        {
                           _loc1_.campaignLosesStreak = this.generalSharedObject.data.users[this.userID].winningLosingStreaks.ladderLosesStreak;
                        }
                        if(this.generalSharedObject.data.users[this.userID].winningLosingStreaks.campaignLosesStreak != null)
                        {
                           _loc1_.campaignLosesStreak = this.generalSharedObject.data.users[this.userID].winningLosingStreaks.campaignLosesStreak;
                        }
                        if(this.generalSharedObject.data.users[this.userID].general != null)
                        {
                           if(this.generalSharedObject.data.users[this.userID].general.expandedInventory != null)
                           {
                              _loc1_.expandedInventorySortingMessageDisplayed = this.generalSharedObject.data.users[this.userID].general.expandedInventory;
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function getSharedObjectLastUsername() : String
      {
         var _loc1_:String = null;
         _loc1_ = "";
         if(this.generalSharedObject.data != null)
         {
            if(this.generalSharedObject.data.lastUsername != null)
            {
               _loc1_ = this.generalSharedObject.data.lastUsername;
            }
         }
         return _loc1_;
      }
      
      public function getSharedObjectLastPassword() : String
      {
         var _loc1_:String = null;
         _loc1_ = "";
         if(this.generalSharedObject.data != null)
         {
            if(this.generalSharedObject.data.lastPassword != null)
            {
               _loc1_ = this.generalSharedObject.data.lastPassword;
            }
         }
         return _loc1_;
      }
      
      public function setItemsCategoriesData(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         var _loc4_:BMItemData = null;
         var _loc5_:Number = Number(NaN);
         this.modules_energy = new Array();
         this.modules_heat = new Array();
         this.modules_bullets = new Array();
         this.modules_rockets = new Array();
         this.modules_bulletsAndRockets = new Array();
         this.modules_resistance = new Array();
         this.modules_armor = new Array();
         this.kits_energy = new Array();
         this.kits_heat = new Array();
         this.kits_bullets = new Array();
         this.kits_rockets = new Array();
         this.kits_resistance = new Array();
         this.kits_repair = new Array();
         _loc2_ = 1;
         while(_loc2_ <= 36)
         {
            this.modules_energy[_loc2_] = new Array();
            this.modules_heat[_loc2_] = new Array();
            this.modules_bullets[_loc2_] = new Array();
            this.modules_rockets[_loc2_] = new Array();
            this.modules_bulletsAndRockets[_loc2_] = new Array();
            this.modules_resistance[_loc2_] = new Array();
            this.modules_armor[_loc2_] = new Array();
            this.kits_energy[_loc2_] = new Array();
            this.kits_heat[_loc2_] = new Array();
            this.kits_bullets[_loc2_] = new Array();
            this.kits_rockets[_loc2_] = new Array();
            this.kits_resistance[_loc2_] = new Array();
            this.kits_repair[_loc2_] = new Array();
            _loc2_++;
         }
         _loc3_ = this.itemsDB_local;
         if(param1)
         {
            _loc3_ = this.itemsDB_online;
         }
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.specialStatus > 3)
            {
               continue;
            }
            _loc5_ = _loc4_.itemID;
            switch(_loc4_.type)
            {
               case "module":
                  if(_loc4_.energyBase > 0 || _loc4_.energyAddon > 0)
                  {
                     this.modules_energy[_loc4_.level].push(_loc5_);
                  }
                  if(_loc4_.heatBase > 0 || _loc4_.heatAddon > 0)
                  {
                     this.modules_heat[_loc4_.level].push(_loc5_);
                  }
                  if(_loc4_.bullets > 0 && _loc4_.rockets > 0)
                  {
                     this.modules_bulletsAndRockets[_loc4_.level].push(_loc5_);
                  }
                  else
                  {
                     if(_loc4_.bullets > 0)
                     {
                        this.modules_bullets[_loc4_.level].push(_loc5_);
                     }
                     if(_loc4_.rockets > 0)
                     {
                        this.modules_rockets[_loc4_.level].push(_loc5_);
                     }
                  }
                  if(_loc4_.resist1 > 0 || _loc4_.resist2 > 0 || _loc4_.resist3 > 0)
                  {
                     this.modules_resistance[_loc4_.level].push(_loc5_);
                  }
                  if(_loc4_.HPBase > 0)
                  {
                     this.modules_armor[_loc4_.level].push(_loc5_);
                  }
                  break;
               case "kit":
                  if(_loc4_.energyBase > 0)
                  {
                     this.kits_energy[_loc4_.level].push(_loc5_);
                  }
                  if(_loc4_.heatBase > 0)
                  {
                     this.kits_heat[_loc4_.level].push(_loc5_);
                  }
                  if(_loc4_.bullets > 0)
                  {
                     this.kits_bullets[_loc4_.level].push(_loc5_);
                  }
                  if(_loc4_.rockets > 0)
                  {
                     this.kits_rockets[_loc4_.level].push(_loc5_);
                  }
                  if(_loc4_.resist1 > 0 || _loc4_.resist2 > 0 || _loc4_.resist3 > 0)
                  {
                     this.kits_resistance[_loc4_.level].push(_loc5_);
                  }
                  if(_loc4_.HPBase > 0)
                  {
                     this.kits_repair[_loc4_.level].push(_loc5_);
                  }
                  break;
            }
         }
      }
      
      public function getClanFlagData(param1:String) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         _loc2_ = new Array();
         if(param1 != null)
         {
            if(param1 != "")
            {
               _loc3_ = "";
               _loc4_ = true;
               _loc5_ = 0;
               while(_loc5_ < param1.length)
               {
                  _loc6_ = param1.substr(_loc5_,1);
                  if(_loc6_ == "_" || _loc5_ == param1.length - 1)
                  {
                     if(_loc5_ == param1.length - 1)
                     {
                        _loc3_ += _loc6_;
                     }
                     if(int(_loc3_) < 1)
                     {
                        _loc4_ = false;
                        _loc5_ = uint(param1.length);
                     }
                     else
                     {
                        _loc2_.push(int(_loc3_));
                        _loc3_ = "";
                     }
                  }
                  else
                  {
                     _loc3_ += _loc6_;
                  }
                  _loc5_++;
               }
               if(_loc2_.length != 5)
               {
                  _loc4_ = false;
               }
               if(_loc4_ == false)
               {
                  _loc2_ = new Array();
               }
            }
         }
         return _loc2_;
      }
      
      public function superSonic_loadNextAdvertisement() : void
      {
         var _loc1_:BMPlayerProfile = null;
         if(this.runAsMobile && this.gameType == "online")
         {
            _loc1_ = this["player" + this.player1PlayerID + "Profile"];
            if(_loc1_.tokensSpent == 0)
            {
               BMSupersonicManager.gi().loadInterstitial();
            }
         }
      }
      
      public function superSonic_showAdvertisement() : void
      {
         var _loc1_:BMPlayerProfile = null;
         if(this.runAsMobile && this.gameType == "online")
         {
            _loc1_ = this["player" + this.player1PlayerID + "Profile"];
            if(_loc1_.tokensSpent == 0)
            {
               if(_loc1_.level > 3)
               {
                  if(this.supersonic_mobile_afterWins == 0 || this.supersonic_mobile_afterWins == 1 && _loc1_.lastBattleResult == "youWon")
                  {
                     if(this.supersonic_hasCompletedListener == false)
                     {
                        BMSupersonicManager.gi().addEventListener(Event.COMPLETE,this.supersonic_showInterstitialComplete);
                     }
                     BMSupersonicManager.gi().showInterstitial();
                  }
               }
            }
         }
      }
      
      public function supersonic_showInterstitialComplete(param1:Event) : void
      {
      }
      
      public function chat_initialize() : void
      {
         if(this.chat_initialized == false)
         {
            this.chat_playersData = new Object();
            this.chat_channels = new Array();
            this.chat_channelsServer = new Array();
            this.chat_channelsAdmins = new Array();
            this.chat_channelsClan = new Array();
            this.chat_channelsClanMembers = new Array();
            this.chat_channelsRegular = new Array();
            this.chat_pendingClanMessages = 0;
            this.chat_addChannel(0,getSpecificText("multiplayerChat_channel1"));
            this.chat_addChannel(3,getSpecificText("multiplayerChat_channel1TopRanks"));
            this.chat_addChannel(1,getSpecificText("multiplayerChat_channel2"));
            this.chat_addChannel(4,getSpecificText("multiplayerChat_channel2TopRanks"));
            this.chat_addChannel(2,getSpecificText("multiplayerChat_channel3"));
            this.chat_addChannel(5,getSpecificText("multiplayerChat_channel3TopRanks"));
            this.chat_addChannel(this.CHAT_CLAN_CHANNEL_PLAYER_ID,getSpecificText("multiplayerChat_channelClan"));
            this.chat_addMessage_welcome(0,getSpecificText("multiplayerChat_server"),getSpecificText("multiplayerChat_welcome1"));
            this.chat_addMessage_welcome(1,getSpecificText("multiplayerChat_server"),getSpecificText("multiplayerChat_welcome2"));
            this.chat_addMessage_welcome(2,getSpecificText("multiplayerChat_server"),getSpecificText("multiplayerChat_welcome3"));
            this.chat_addMessage_welcome(3,getSpecificText("multiplayerChat_server"),getSpecificText("multiplayerChat_welcome1"));
            this.chat_addMessage_welcome(4,getSpecificText("multiplayerChat_server"),getSpecificText("multiplayerChat_welcome2"));
            this.chat_addMessage_welcome(5,getSpecificText("multiplayerChat_server"),getSpecificText("multiplayerChat_welcome3"));
            this.chat_addMessage_welcome(this.CHAT_CLAN_CHANNEL_PLAYER_ID,getSpecificText("multiplayerChat_server"),getSpecificText("multiplayerChat_welcomeClan"));
            this.chat_totalPlayersInLobby = 0;
            this.chat_winningWallTexts = new Array();
            this.chat_playersData = new Object();
            this.chat_differentUserConnected = true;
            this.chat_goToChatAfterBattleUserID = 0;
            this.chat_inviteToClanAfterBattleUserID = 0;
            this.chat_log = new Object();
            this.chat_initialized = true;
         }
      }
      
      public function chat_channelsLanguageUpdate() : void
      {
         this.chat_channels[this.getChannelSlot(0)].name = getSpecificText("multiplayerChat_channel1");
         this.chat_channels[this.getChannelSlot(3)].name = getSpecificText("multiplayerChat_channel1TopRanks");
         this.chat_channels[this.getChannelSlot(1)].name = getSpecificText("multiplayerChat_channel2");
         this.chat_channels[this.getChannelSlot(4)].name = getSpecificText("multiplayerChat_channel2TopRanks");
         this.chat_channels[this.getChannelSlot(2)].name = getSpecificText("multiplayerChat_channel3");
         this.chat_channels[this.getChannelSlot(5)].name = getSpecificText("multiplayerChat_channel3TopRanks");
         this.chat_channels[this.getChannelSlot(this.CHAT_CLAN_CHANNEL_PLAYER_ID)].name = getSpecificText("multiplayerChat_channel3TopRanks");
         this.chat_playersData[0].playerName = getSpecificText("multiplayerChat_channel1");
         this.chat_playersData[3].playerName = getSpecificText("multiplayerChat_channel1TopRanks");
         this.chat_playersData[1].playerName = getSpecificText("multiplayerChat_channel2");
         this.chat_playersData[4].playerName = getSpecificText("multiplayerChat_channel2TopRanks");
         this.chat_playersData[2].playerName = getSpecificText("multiplayerChat_channel3");
         this.chat_playersData[5].playerName = getSpecificText("multiplayerChat_channel3TopRanks");
         this.chat_playersData[this.CHAT_CLAN_CHANNEL_PLAYER_ID].playerName = getSpecificText("multiplayerChat_channel3TopRanks");
      }
      
      public function chat_addChannel(param1:Number, param2:String) : void
      {
         var _loc3_:uint = 0;
         if(this.getChannelSlot(param1) == -1)
         {
            if(this.getChannelSlot(param1) == -1)
            {
               if(param1 <= this.CHAT_LANGUAGES - 1)
               {
                  this.chat_channelsServer.push({
                     "channelID":param1,
                     "name":param2
                  });
               }
               else if(param1 == this.CHAT_CLAN_CHANNEL_PLAYER_ID)
               {
                  this.chat_channelsClan.push({
                     "channelID":param1,
                     "name":param2
                  });
               }
               else if(this.isPlayerIDAdmin(param1))
               {
                  this.chat_channelsAdmins.push({
                     "channelID":param1,
                     "name":param2
                  });
               }
               else if(this.isMyClanMember(param1))
               {
                  this.chat_channelsClanMembers.push({
                     "channelID":param1,
                     "name":param2
                  });
               }
               else
               {
                  this.chat_channelsRegular.push({
                     "channelID":param1,
                     "name":param2
                  });
               }
            }
            this.chat_channels = new Array();
            _loc3_ = 0;
            while(_loc3_ < this.chat_channelsClan.length)
            {
               this.chat_channels.push({
                  "channelID":this.chat_channelsClan[_loc3_].channelID,
                  "name":this.chat_channelsClan[_loc3_].name,
                  "type":"clan"
               });
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.chat_channelsServer.length)
            {
               this.chat_channels.push({
                  "channelID":this.chat_channelsServer[_loc3_].channelID,
                  "name":this.chat_channelsServer[_loc3_].name,
                  "type":"server"
               });
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.chat_channelsAdmins.length)
            {
               this.chat_channels.push({
                  "channelID":this.chat_channelsAdmins[_loc3_].channelID,
                  "name":this.chat_channelsAdmins[_loc3_].name,
                  "type":"admin"
               });
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.chat_channelsClanMembers.length)
            {
               this.chat_channels.push({
                  "channelID":this.chat_channelsClanMembers[_loc3_].channelID,
                  "name":this.chat_channelsClanMembers[_loc3_].name,
                  "type":"friend"
               });
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.chat_channelsRegular.length)
            {
               this.chat_channels.push({
                  "channelID":this.chat_channelsRegular[_loc3_].channelID,
                  "name":this.chat_channelsRegular[_loc3_].name,
                  "type":"regular"
               });
               _loc3_++;
            }
            if(screensM.isScreenOpened("screenMultiPlayerChat"))
            {
               screensM.screenMultiPlayerChat.addAndRefreshChannelsTileList();
            }
         }
      }
      
      public function getChannelSlot(param1:Number) : Number
      {
         var _loc2_:Number = Number(NaN);
         var _loc3_:uint = 0;
         _loc2_ = -1;
         _loc3_ = 0;
         while(_loc3_ < this.chat_channels.length)
         {
            if(this.chat_channels[_loc3_].channelID == param1)
            {
               _loc2_ = _loc3_;
               _loc3_ = this.chat_channels.length;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function chat_addMessage_welcome(param1:uint, param2:String, param3:String) : void
      {
         this.chat_addMessage("message",param1,param1,param3,param2,0,0,"",0,0,"",null,0,0,true);
      }
      
      private function chat_addMessage_battleInvitation(param1:String, param2:uint, param3:String, param4:Number, param5:uint) : void
      {
         this.chat_addMessage("battleInvitation",0,this.userID,param3,param1,param2,0,"",0,0,"",null,param4,param5,true);
      }
      
      private function chat_addMessage_clanInvitation(param1:Number, param2:String, param3:Number, param4:String, param5:String) : void
      {
         this.chat_addMessage("clanInvitation",0,this.userID,param5,param4,0,0,"",0,param1,param2,null,param3,0,true);
      }
      
      public function chat_addMessage(param1:String, param2:Number, param3:Number, param4:String, param5:String = "", param6:uint = 0, param7:uint = 0, param8:String = "", param9:uint = 0, param10:Number = 0, param11:String = "", param12:Object = null, param13:Number = 0, param14:uint = 0, param15:Boolean = false) : void
      {
         var _loc16_:Number = Number(NaN);
         var _loc17_:BMChatMessageData = null;
         var _loc18_:uint = 0;
         var _loc19_:String = null;
         var _loc20_:BMPlayerProfile = null;
         var _loc21_:Boolean = false;
         var _loc22_:Boolean = false;
         var _loc23_:uint = 0;
         var _loc24_:Boolean = false;
         var _loc25_:uint = 0;
         var _loc26_:BMChatMessageData = null;
         var _loc27_:String = null;
         var _loc28_:String = null;
         var _loc29_:String = null;
         _loc16_ = param2;
         switch(param1)
         {
            case "privateMessageAlert":
            case "clanMessageAlert":
            case "battleInvitation":
            case "clanInvitation":
               _loc16_ = param13;
         }
         if(_loc16_ != this.userID)
         {
            param5 = this.getCensoredString(param5);
            param4 = this.getCensoredString(param4);
         }
         _loc17_ = new BMChatMessageData();
         switch(param1)
         {
            case "winningWall":
               _loc18_ = this.chat_messages_winningWall.length;
               _loc19_ = getSpecificText("multiplayerChat_winningWallMessage");
               param12.winUsername = this.getCensoredString(param12.winUsername);
               param12.loseUsername = this.getCensoredString(param12.loseUsername);
               _loc19_ = this.replaceStringInText(_loc19_,"%PLAYER1%","<FONT COLOR=\'#" + this.COLOR_REGULAR_PLAYER + "\'>" + param12.winUsername + "</FONT>");
               _loc19_ = this.replaceStringInText(_loc19_,"%PLAYER2%","<FONT COLOR=\'#" + this.COLOR_REGULAR_PLAYER + "\'>" + param12.loseUsername + "</FONT>");
               _loc17_.initializeWinningWall(_loc18_,_loc19_);
               this.chat_messages_winningWall.push(_loc17_);
               if(screensM.isScreenOpened("screenMultiPlayerLadder"))
               {
                  screensM.screenMultiPlayerLadder.addWinningWallMessage(_loc19_);
               }
               break;
            case "battleInvitation":
            case "clanInvitation":
            case "privateMessageAlert":
            case "clanMessageAlert":
            case "message":
               _loc20_ = this["player" + this.player1PlayerID + "Profile"];
               _loc21_ = false;
               _loc22_ = false;
               if(this.chat_playersData[_loc16_] == null)
               {
                  this.chat_addPlayerToChatPlayersData(_loc16_,param5,param6,param10,param7,param8,"");
                  _loc21_ = true;
               }
               else if(this.chat_playersData[_loc16_].blocked)
               {
                  _loc22_ = true;
               }
               if(_loc22_ == false)
               {
                  loop3:
                  switch(param1)
                  {
                     case "battleInvitation":
                     case "clanInvitation":
                        _loc23_ = 0;
                        if(screensM.isScreenOpened("screenMultiPlayerChat"))
                        {
                           _loc23_ = screensM.screenMultiPlayerChat.getChannelPlayerID();
                        }
                        this.chat_playersData[_loc16_].removed = false;
                        if(this.chat_log[_loc23_] == null)
                        {
                           this.chat_log[_loc23_] = new Array();
                        }
                        _loc18_ = uint(this.chat_log[_loc23_].length);
                        switch(param1)
                        {
                           case "battleInvitation":
                              _loc17_.initializeBattleInvitation(_loc18_,_loc23_,0,this.userID,param13,param4,param5,param6,param14);
                              break loop3;
                           case "clanInvitation":
                              _loc17_.initializeClanInvitation(_loc18_,_loc23_,0,this.userID,param13,param4,param5,param10,param11);
                        }
                        break;
                     case "privateMessageAlert":
                     case "clanMessageAlert":
                     case "message":
                        if(this.chat_playersData[_loc16_].clanID != param10)
                        {
                           this.chat_playersData[_loc16_].clanID = param10;
                        }
                        this.chat_playersData[_loc16_].removed = false;
                        if(param1 == "message")
                        {
                           _loc23_ = param3;
                           if(param3 == this.userID)
                           {
                              _loc23_ = _loc16_;
                              this.chat_addChannel(_loc23_,param5);
                              if(screensM.isScreenOpened("screenMultiPlayerChat"))
                              {
                                 screensM.screenMultiPlayerChat.addAndRefreshChannelsTileList();
                              }
                           }
                        }
                        else
                        {
                           _loc23_ = 0;
                           if(screensM.isScreenOpened("screenMultiPlayerChat"))
                           {
                              _loc23_ = screensM.screenMultiPlayerChat.getChannelPlayerID();
                           }
                        }
                        if(this.chat_log[_loc23_] == null)
                        {
                           this.chat_log[_loc23_] = new Array();
                        }
                        _loc18_ = uint(this.chat_log[_loc23_].length);
                        switch(param1)
                        {
                           case "privateMessageAlert":
                              _loc17_.initializePrivateMessageAlert(_loc18_,_loc23_,_loc16_,param3,param4,param5,param13);
                              break;
                           case "clanMessageAlert":
                              _loc17_.initializeClanMessageAlert(_loc18_,_loc23_,_loc16_,param3,param4,param5,param13);
                              break;
                           case "message":
                              _loc17_.initializeMessage(_loc18_,_loc23_,_loc16_,param3,param4,param5,param6,param7,param9,param10,param11);
                        }
                  }
                  this.chat_log[_loc23_].push(_loc17_);
                  _loc24_ = false;
                  if(this.chat_log[_loc23_].length > 35)
                  {
                     this.chat_log[_loc23_].splice(0,10);
                     _loc25_ = 0;
                     while(_loc25_ < this.chat_log[_loc23_].length)
                     {
                        _loc26_ = this.chat_log[_loc23_][_loc25_];
                        _loc26_.slot = _loc25_;
                        _loc25_++;
                     }
                     _loc18_ -= 10;
                     _loc24_ = true;
                  }
                  if(screensM.isScreenOpened("screenMultiPlayerChat"))
                  {
                     switch(_loc17_.type)
                     {
                        case "battleInvitation":
                        case "clanInvitation":
                           soundM.createSound("battleInvitationReceived",1);
                     }
                     if(_loc23_ == screensM.screenMultiPlayerChat.getChannelPlayerID())
                     {
                        if(_loc24_)
                        {
                           screensM.screenMultiPlayerChat.refreshChatHistory();
                        }
                        else
                        {
                           screensM.screenMultiPlayerChat.addGlobalChatMessage(_loc23_,_loc18_,true);
                        }
                     }
                     else if(param15)
                     {
                        switch(_loc17_.type)
                        {
                           case "battleInvitation":
                           case "clanInvitation":
                           case "message":
                              screensM.screenMultiPlayerChat.incraseChannelPendingMessages(_loc23_);
                              if(_loc23_ == this.CHAT_CLAN_CHANNEL_PLAYER_ID)
                              {
                                 ++this.chat_pendingClanMessages;
                              }
                              if(param3 == this.userID || param3 == this.CHAT_CLAN_CHANNEL_PLAYER_ID)
                              {
                                 if(param3 == this.CHAT_CLAN_CHANNEL_PLAYER_ID)
                                 {
                                    _loc27_ = getSpecificText("multiplayerChat_clanMessageReceived");
                                    _loc27_ = this.replaceStringInText(_loc27_,"%NAME%",param5);
                                    _loc28_ = "clanMessageAlert";
                                 }
                                 else
                                 {
                                    _loc27_ = getSpecificText("multiplayerChat_privateMessageReceived");
                                    _loc27_ = this.replaceStringInText(_loc27_,"%NAME%",param5);
                                    _loc28_ = "privateMessageAlert";
                                 }
                                 this.chat_addMessage(_loc28_,0,this.userID,_loc27_,getSpecificText("multiplayerChat_server"),0,0,"",0,0,"",null,param2,0,true);
                                 break;
                              }
                        }
                     }
                  }
                  else if(_loc23_ == this.CHAT_CLAN_CHANNEL_PLAYER_ID)
                  {
                     if(screensM.isScreenOpened("screenClan"))
                     {
                        ++this.chat_pendingClanMessages;
                        screensM.screenClan.refreshPendingClanMessagesCounter();
                     }
                  }
               }
         }
         if(screensM.isScreenOpened("screenMultiPlayerLadder") && param15)
         {
            _loc29_ = "";
            switch(param1)
            {
               case "battleInvitation":
                  _loc29_ = "battleInvitation";
                  break;
               case "clanInvitation":
                  _loc29_ = "clanInvitation";
                  break;
               case "message":
                  if(param3 == this.CHAT_CLAN_CHANNEL_PLAYER_ID)
                  {
                     _loc29_ = "message_clan";
                  }
                  else if(param3 == this.userID)
                  {
                     _loc29_ = "message_regular";
                  }
            }
            if(_loc29_ != "")
            {
               screensM.screenMultiPlayerLadder.addChatAlert(_loc29_,_loc16_,param5,param10,param11,param14);
            }
         }
      }
      
      public function chat_addPlayerToChatPlayersData(param1:Number, param2:String, param3:Number, param4:Number, param5:Number, param6:String, param7:String) : void
      {
         var _loc8_:Boolean = false;
         var _loc9_:BMPlayerProfile = null;
         _loc8_ = true;
         if(this.chat_playersData[param1] != null)
         {
            _loc8_ = false;
         }
         if(param1 == this.userID)
         {
            _loc9_ = this["player" + this.player1PlayerID + "Profile"];
            param2 = _loc9_.playerName;
            if(_loc8_ == false)
            {
               this.chat_playersData[param1].playerName = param2;
            }
         }
         if(_loc8_)
         {
            this.chat_playersData[param1] = new Object();
            this.chat_playersData[param1].playerID = param1;
            this.chat_playersData[param1].playerName = param2;
            this.chat_playersData[param1].geo = param6;
            this.chat_playersData[param1].lastDevice = param7;
            this.chat_playersData[param1].blocked = false;
         }
         this.chat_playersData[param1].level = param3;
         this.chat_playersData[param1].clanID = param4;
         this.chat_playersData[param1].ladderProgress = param5;
         this.chat_playersData[param1].removed = false;
      }
      
      public function chat_updatePlayersOnline(param1:Object) : void
      {
         var _loc2_:BMPlayerProfile = null;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Number = Number(NaN);
         _loc2_ = this["player" + this.player1PlayerID + "Profile"];
         var _loc3_:Object = new Object();
         _loc5_ = 0;
         this.chat_totalPlayersInLobby = 0;
         for each(_loc4_ in param1)
         {
            _loc6_ = false;
            if(_loc2_.clanID > 0)
            {
               if(_loc2_.clanID == _loc4_.clanID)
               {
                  _loc6_ = true;
               }
            }
            _loc7_ = false;
            if(_loc6_ == false)
            {
               if(_loc5_ <= 13)
               {
                  if(Math.abs(_loc2_.ladderProgress - _loc4_.ladderProgress) <= this.CHAT_ONLINE_PLAYER_LADDER_PROGRESS_DIFFERENCE)
                  {
                     _loc7_ = true;
                  }
               }
            }
            if(_loc6_ || _loc7_)
            {
               _loc8_ = Number(_loc4_.playerID);
               if(_loc8_ != this.userID)
               {
                  _loc4_.playerName = this.getCensoredString(_loc4_.playerName);
               }
               this.chat_addPlayerToChatPlayersData(_loc8_,_loc4_.playerName,_loc4_.level,_loc4_.clanID,_loc4_.ladderProgress,_loc4_.geo,_loc4_.lastDevice);
            }
            ++this.chat_totalPlayersInLobby;
         }
         if(screensM.isScreenOpened("screenMultiPlayerChat"))
         {
            screensM.screenMultiPlayerChat.addAndRefreshOnlinePlayersTileList(true);
            screensM.screenMultiPlayerChat.refreshPlayersInLobbyText();
         }
         else if(screensM.isScreenOpened("screenMultiPlayerLadder"))
         {
            screensM.screenMultiPlayerLadder.refreshPlayersInLobbyText();
         }
      }
      
      public function chat_updateOnlinePlayerClanID(param1:Number, param2:Number) : void
      {
         if(this.chat_playersData != null)
         {
            if(this.chat_playersData[param1] != null)
            {
               this.chat_playersData[param1].clanID = param2;
            }
         }
      }
      
      public function chat_isPlayerBlocked(param1:*) : Boolean
      {
         var _loc2_:Boolean = false;
         _loc2_ = false;
         if(this.chat_playersData[param1] != null)
         {
            if(this.chat_playersData[param1].blocked)
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      public function goToChatAfterBattle(param1:Number, param2:String, param3:Number, param4:uint, param5:uint, param6:String) : void
      {
         this.chat_goToChatAfterBattleUserID = param1;
         this.chat_addPlayerDataAfterBattleName = param2;
         this.chat_addPlayerDataAfterBattleClanID = param3;
         this.chat_addPlayerDataAfterBattleLadderProgress = param4;
         this.chat_addPlayerDataAfterBattleLevel = param5;
         this.chat_addPlayerDataAfterBattleGeo = param6;
      }
      
      public function inviteToClanAfterBattle(param1:Number, param2:String, param3:Number, param4:uint, param5:uint, param6:String) : void
      {
         this.chat_inviteToClanAfterBattleUserID = param1;
         this.chat_addPlayerDataAfterBattleName = param2;
         this.chat_addPlayerDataAfterBattleClanID = param3;
         this.chat_addPlayerDataAfterBattleLadderProgress = param4;
         this.chat_addPlayerDataAfterBattleLevel = param5;
         this.chat_addPlayerDataAfterBattleGeo = param6;
      }
      
      public function chat_blockPlayer(param1:Number, param2:Boolean) : void
      {
         if(this.chat_playersData[param1] != null)
         {
            this.chat_playersData[param1].blocked = true;
            if(param2)
            {
               if(screensM.isScreenOpened("screenMultiPlayerChat"))
               {
                  screensM.screenMultiPlayerChat.refreshChatHistory();
               }
            }
         }
      }
      
      public function chat_unBlockPlayer(param1:Number, param2:Boolean) : void
      {
         if(this.chat_playersData[param1] != null)
         {
            this.chat_playersData[param1].blocked = false;
            if(param2)
            {
               if(screensM.isScreenOpened("screenMultiPlayerChat"))
               {
                  screensM.screenMultiPlayerChat.refreshChatHistory();
               }
            }
         }
      }
      
      public function battleInvitation_add(param1:Number, param2:String, param3:Number, param4:Number, param5:uint) : void
      {
         var _loc6_:* = null;
         param2 = this.getCensoredString(param2);
         this.battleInvitations[param1] = {
            "playerID":param1,
            "playerName":param2,
            "level":param3,
            "clanID":param4,
            "mechsPerPlayer":param5
         };
         switch(param5)
         {
            case 1:
               if(this.use2V2And3V3Battles)
               {
                  _loc6_ = getSpecificText("multiplayerChat_battleInvitationReceived1V1");
                  break;
               }
               _loc6_ = getSpecificText("multiplayerChat_battleInvitationReceived");
               break;
            case 2:
               _loc6_ = getSpecificText("multiplayerChat_battleInvitationReceived2V2");
               break;
            case 3:
               _loc6_ = getSpecificText("multiplayerChat_battleInvitationReceived3V3");
         }
         _loc6_ = "<FONT COLOR=\'#" + this.COLOR_BATTLE_INVITATION + "\'>" + this.replaceStringInText(_loc6_,"%NAME%",param2) + "</FONT>";
         this.chat_addMessage_battleInvitation(param2,param3,_loc6_,param1,param5);
      }
      
      public function battleInvitation_remove(param1:Number) : void
      {
         this.battleInvitations[param1] = null;
      }
      
      public function clan_addInvitation(param1:Number, param2:String, param3:Number, param4:String) : void
      {
         var _loc5_:* = null;
         param2 = this.getCensoredString(param2);
         param4 = this.getCensoredString(param4);
         this.clanInvitations[param1] = {
            "clanID":param1,
            "clanName":param2,
            "leaderID":param3,
            "leaderName":param4
         };
         _loc5_ = getSpecificText("multiplayerChat_clanInvitationReceived");
         _loc5_ = this.replaceStringInText(_loc5_,"%LEADER%",param4);
         _loc5_ = this.replaceStringInText(_loc5_,"%CLAN%",param2);
         _loc5_ = "<FONT COLOR=\'#" + this.COLOR_BATTLE_INVITATION + "\'>" + _loc5_ + "</FONT>";
         if(screensM.isScreenOpened("screenMenuMultiPlayerInspect") && this.onlinePlayersInspect_playerID == param3)
         {
            screensM.screenMenuMultiPlayerInspect.refreshScreen(param3,false,true,false);
         }
         this.chat_addMessage_clanInvitation(param1,param2,param3,param4,_loc5_);
      }
      
      public function clan_removeInvitation(param1:Number) : void
      {
         this.clanInvitations[param1] = null;
      }
      
      public function callFSCommandPixel(param1:String, param2:String) : void
      {
         fscommand(param1,param2);
      }
      
      public function updateGoogleAnalitics(param1:String, param2:String, param3:String, param4:Number) : void
      {
      }
      
      public function traceError(param1:String) : void
      {
         trace("//////////////////");
         trace("//////////////////");
         trace("");
         trace("ERROR : " + param1);
         trace("");
         trace("//////////////////");
         trace("//////////////////");
      }
      
      public function getCensoredString(param1:String) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:RegExp = null;
         _loc2_ = 0;
         while(_loc2_ < this.wordFilterDB.length)
         {
            _loc3_ = new RegExp(this.wordFilterDB[_loc2_].badWord,"/gi");
            param1 = param1.replace(_loc3_,this.wordFilterDB[_loc2_].fix);
            _loc2_++;
         }
         return param1;
      }
      
      public function traceItemsDB(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         var _loc6_:* = null;
         var _loc7_:String = null;
         var _loc8_:Number = Number(NaN);
         _loc2_ = new Array();
         for each(_loc3_ in this.itemsDB_online)
         {
            _loc2_[_loc3_.itemID] = _loc3_;
         }
         trace("");
         trace("");
         trace("");
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc4_];
            if(_loc3_ != null)
            {
               _loc5_ = false;
               if(_loc3_.level > 24)
               {
                  if(param1 == "" || param1 == _loc3_.type)
                  {
                     _loc5_ = true;
                  }
               }
               if(_loc5_)
               {
                  _loc6_ = "";
                  _loc7_ = "";
                  _loc8_ = Number(_loc3_.itemID);
                  _loc6_ = "itemsDB_local[" + _loc8_ + "] = new Array(" + _loc3_.itemID + ",\'" + _loc3_.fullName + "\'," + _loc3_.sortID + "," + _loc3_.finalSortID + ",\'" + _loc3_.type + "\',\'" + _loc3_.subType + "\'," + _loc3_.level + "," + _loc3_.HPBase + "," + _loc3_.HPAddon + ",";
                  _loc6_ = _loc6_ + _loc3_.energyBase + "," + _loc3_.energyAddon + "," + _loc3_.heatBase + "," + _loc3_.heatAddon + "," + _loc3_.bullets + "," + _loc3_.rockets + "," + _loc3_.damageBase + "," + _loc3_.damageAddon + ",";
                  _loc6_ = _loc6_ + _loc3_.damageType + "," + _loc3_.damageHeat + "," + _loc3_.damageEnergy + "," + _loc3_.uses + "," + _loc3_.push + "," + _loc3_.resist1 + "," + _loc3_.resist2 + "," + _loc3_.resist3 + ",";
                  _loc6_ = _loc6_ + _loc3_.rangeBase + "," + _loc3_.rangeAddon + "," + _loc3_.stepsPerWalk + "," + _loc3_.stepsPerJump + "," + _loc3_.energyPerBlock + "," + _loc3_.heatPerBlock + "," + _loc3_.HPPerBlock + ",";
                  _loc6_ = _loc6_ + _loc3_.absorbRatio + "," + _loc3_.costHeat + "," + _loc3_.costEnergy + "," + _loc3_.costGold + "," + _loc3_.costTokens + ",\'";
                  _loc6_ = _loc6_ + _loc3_.animation + "\',\'" + _loc3_.grp + "\'," + _loc3_.specialStatus + "," + _loc3_.power + "," + _loc3_.weight + "," + _loc3_.damageHeatBase + "," + _loc3_.damageHeatAddon + "," + _loc3_.damageEnergyBase + "," + _loc3_.damageEnergyAddon + ",";
                  _loc6_ = _loc6_ + _loc3_.resist1Gain + "," + _loc3_.resist2Gain + "," + _loc3_.resist3Gain + "," + _loc3_.extraPhase + "," + _loc3_.APRecharge + "," + _loc3_.pushSelf + ");";
                  trace(_loc6_);
               }
            }
            _loc4_++;
         }
         trace("");
         trace("");
      }
      
      private function createItemsDataBaseLocally() : void
      {
         this.itemsDB_local = new Object();
         this.itemsDB_local[1] = new Array(1,"Arial Target",1,50301,"drone","drone",3,0,0,0,0,0,0,0,0,11,4,3,0,2,0,0,0,0,0,0,999,0,0,0,0,0,0,0,4,0,0,"laser1","drone1",0,15,8);
         this.itemsDB_local[2] = new Array(2,"Metal Walkers",1,10151,"leg","leg",1,0,0,0,0,0,0,0,0,20,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,100,0,"stomp1","leg1",0,5,9);
         this.itemsDB_local[3] = new Array(3,"Laser Cannon",1,30101,"sideWeapon","physical",1,0,0,0,0,0,0,0,0,15,0,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,5,0,100,0,"bullet1","laser1A",0,5,8,0,0,0,0);
         this.itemsDB_local[6] = new Array(6,"Zyborg",5,10305,"torso","torso",3,150,0,25,7,35,8,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,6000,6,"","torso3",2,15,127,0,0,0,0,0,0,1,0,3);
         this.itemsDB_local[17] = new Array(17,"Repair Kit 1",1,120201,"kit","repair",2,42,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,200,0,"","kit_HP1",0,1,0);
         this.itemsDB_local[22] = new Array(22,"Teleport Mark 1",1,70401,"teleport","teleport",4,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,10,3500,0,"","teleport1",0,20,1);
         this.itemsDB_local[23] = new Array(23,"Newbie",1,10101,"torso","torso",1,108,0,15,5,15,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,200,0,"","torso1",0,5,80,0,0,0,0,1,0,0,0,3);
         this.itemsDB_local[25] = new Array(25,"Armor Plating 1",1,110301,"module","armor",3,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"","module_HP1",0,6,8);
         this.itemsDB_local[29] = new Array(29,"Juggernaut",4,10604,"torso","torso",6,180,0,35,9,35,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,27700,0,"","torso6",1,30,147,0,0,0,0,1,1,0,0,4);
         this.itemsDB_local[32] = new Array(32,"Robot",2,11002,"torso","torso",10,198,0,40,10,50,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,34600,0,"","torso10",0,50,180,0,0,0,0,0,1,1,0,4);
         this.itemsDB_local[35] = new Array(35,"Sky Walkers",1,10351,"leg","leg",3,0,0,0,0,0,0,0,0,23,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,1000,0,"stomp1","leg3",0,15,10);
         this.itemsDB_local[36] = new Array(36,"Steel Walkers",4,10354,"leg","leg",3,6,0,0,0,0,0,0,0,29,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,1500,6,"stomp1","leg2",2,15,18);
         this.itemsDB_local[37] = new Array(37,"Rolin",2,10352,"leg","leg",3,0,0,0,0,0,0,0,0,26,0,1,0,0,0,1,0,0,0,0,1,2,0,0,0,0,0,0,0,1000,0,"stomp1","wheels1",0,15,14);
         this.itemsDB_local[43] = new Array(43,"One Eyed Doom",1,50401,"drone","drone",4,0,0,0,0,0,0,0,0,12,4,3,0,3,0,0,0,0,0,0,999,0,0,0,0,0,0,0,5,3500,0,"laser1","drone2",0,20,10);
         this.itemsDB_local[44] = new Array(44,"Tesla",1,50501,"drone","drone",5,0,0,0,0,0,0,0,0,13,6,3,0,4,0,0,0,0,0,0,999,0,0,0,0,0,0,0,5,4400,0,"laser1","drone3",0,25,12);
         this.itemsDB_local[48] = new Array(48,"Repair Kit 2",1,120601,"kit","repair",6,54,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,500,0,"","kit_HP2",0,3,0);
         this.itemsDB_local[49] = new Array(49,"Repair Kit 3",1,121001,"kit","repair",10,66,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,700,0,"","kit_HP3",0,5,0);
         this.itemsDB_local[53] = new Array(53,"Energy Module 2",1,110401,"module","energyHeat",4,0,0,7,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1900,0,"","module_energy2",0,6,10);
         this.itemsDB_local[54] = new Array(54,"Energy Module 3",1,110501,"module","energyHeat",5,0,0,10,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2650,0,"","module_energy3",0,10,14);
         this.itemsDB_local[55] = new Array(55,"Energy Module 4",1,110601,"module","energyHeat",6,0,0,12,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3300,0,"","module_energy4",0,12,17);
         this.itemsDB_local[56] = new Array(56,"Bullet Storage 1",2,110202,"module","ammo",2,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,350,0,"","module_bullets1",0,4,12);
         this.itemsDB_local[58] = new Array(58,"Bullet Storage 2",2,110502,"module","ammo",5,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2650,0,"","module_bullets2",0,10,16);
         this.itemsDB_local[59] = new Array(59,"Bullet Storage 3",2,110802,"module","ammo",8,0,0,0,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4400,0,"","module_bullets3",0,16,20);
         this.itemsDB_local[61] = new Array(61,"Rocket Storage 1",3,110303,"module","ammo",3,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"","module_rockets1",0,6,12);
         this.itemsDB_local[62] = new Array(62,"Rocket Storage 3",3,110903,"module","ammo",9,0,0,0,0,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4850,0,"","module_rockets3",0,18,20);
         this.itemsDB_local[64] = new Array(64,"Rocket Storage 2",3,110603,"module","ammo",6,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3300,0,"","module_rockets2",0,12,16);
         this.itemsDB_local[65] = new Array(65,"Heat Module 1",1,110302,"module","energyHeat",3,0,0,0,0,5,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"","module_heat2",0,6,6);
         this.itemsDB_local[66] = new Array(66,"Energy Module 1",1,110304,"module","energyHeat",3,0,0,5,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"","module_energy1",0,8,7);
         this.itemsDB_local[67] = new Array(67,"Armor Plating 2",2,110503,"module","armor",5,24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2650,0,"","module_HP2",0,10,10);
         this.itemsDB_local[69] = new Array(69,"Armor Plating 3",4,110804,"module","armor",8,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4400,0,"","module_HP3",0,16,12);
         this.itemsDB_local[71] = new Array(71,"Physical Resistance Module 1",1,110701,"module","resistance",7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,3900,0,"","module_resistancePhysical1",0,14,2);
         this.itemsDB_local[72] = new Array(72,"Heat module 4",1,110602,"module","energyHeat",6,0,0,0,0,15,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3300,0,"","module_heat4",0,12,17);
         this.itemsDB_local[73] = new Array(73,"Heat Module 3",1,110504,"module","energyHeat",5,0,0,0,0,12,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2650,0,"","module_heat3",0,10,14);
         this.itemsDB_local[74] = new Array(74,"Heat module 5",1,110801,"module","energyHeat",8,0,0,0,0,18,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4400,0,"","module_heat5",0,16,21);
         this.itemsDB_local[75] = new Array(75,"Energy Kit 1",1,120401,"kit","energyHeat",4,0,0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,400,0,"","kit_energy1",0,2,0);
         this.itemsDB_local[77] = new Array(77,"Energy Kit 2",1,120801,"kit","energyHeat",8,0,0,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,600,0,"","kit_energy2",0,4,0);
         this.itemsDB_local[83] = new Array(83,"Bullets Kit 1",1,120301,"kit","ammo",3,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,300,0,"","kit_bullets1",0,2,0);
         this.itemsDB_local[84] = new Array(84,"Bullets Kit 2",1,120802,"kit","ammo",8,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,600,0,"","kit_bullets2",0,4,0);
         this.itemsDB_local[87] = new Array(87,"Rockets Kit 1",1,120402,"kit","ammo",4,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,400,0,"","kit_rockets1",0,2,0);
         this.itemsDB_local[88] = new Array(88,"Rockets Kit 2",1,120501,"kit","ammo",5,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,450,0,"","kit_rockets2",0,3,0);
         this.itemsDB_local[89] = new Array(89,"Rockets Kit 3",1,120701,"kit","ammo",7,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,550,0,"","kit_rockets3",0,4,0);
         this.itemsDB_local[90] = new Array(90,"Rockets Kit 4",1,120803,"kit","ammo",8,0,0,0,0,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,600,0,"","kit_rockets4",0,4,0);
         this.itemsDB_local[93] = new Array(93,"Cooling Kit 2",1,120702,"kit","energyHeat",7,0,0,0,0,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,550,0,"","kit_heat2",0,4,0);
         this.itemsDB_local[97] = new Array(97,"Cooling Kit 1",1,120302,"kit","energyHeat",3,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,300,0,"","kit_heat1",0,2,0);
         this.itemsDB_local[99] = new Array(99,"Energy Shield Mark 1",1,60601,"shield","shield",6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,10,0,0,440,0,"","shield1A",0,30,4);
         this.itemsDB_local[100] = new Array(100,"Charge Mark 1",1,80701,"charge","charge",7,0,0,0,0,0,0,0,0,19,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,14,10,3500,0,"","charge1",0,20,7);
         this.itemsDB_local[101] = new Array(101,"Teleport Mark 2",1,70701,"teleport","teleport",7,0,0,0,0,0,0,0,0,20,6,3,0,7,1,0,0,0,0,0,1,0,0,0,0,0,0,0,18,5800,0,"","teleport2",0,35,10);
         this.itemsDB_local[137] = new Array(137,"Adv. Energy Shield Mark 3",1,61001,"shield","shield",10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,2,20,0,0,10450,27,"","shield2A",1,50,12);
         this.itemsDB_local[143] = new Array(143,"Teleport Mark 3",1,70901,"teleport","teleport",9,0,0,0,0,0,0,0,0,23,6,3,0,11,1,0,0,0,0,0,1,0,0,0,0,0,0,0,26,6950,0,"","teleport3",0,45,12);
         this.itemsDB_local[145] = new Array(145,"Charge Mark 2",1,80901,"charge","charge",9,0,0,0,0,0,0,0,0,22,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,18,10,5800,0,"","charge2",0,35,8);
         this.itemsDB_local[153] = new Array(153,"Vector",2,10102,"torso","torso",1,120,0,20,5,20,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,375,0,"","torso2",0,5,92,0,0,0,0,1,0,1,0,4);
         this.itemsDB_local[154] = new Array(154,"Executioner",3,10603,"torso","torso",6,162,0,35,9,35,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18450,0,"","torso5",0,30,143,0,0,0,0,2,0,0,0,4);
         this.itemsDB_local[155] = new Array(155,"Spector",2,10202,"torso","torso",2,132,0,25,6,25,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1150,0,"","torso4",0,10,108,0,0,0,0,0,2,0,0,3);
         this.itemsDB_local[156] = new Array(156,"Samurai",3,11003,"torso","torso",10,210,0,45,10,45,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,34600,0,"","torso8",0,50,180,0,0,0,0,0,0,2,0,2);
         this.itemsDB_local[157] = new Array(157,"Alien",6,10606,"torso","torso",6,174,0,40,8,40,8,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,27700,12,"","torso9",2,30,152,0,0,0,0,2,1,0,0,4);
         this.itemsDB_local[158] = new Array(158,"Two Head",1,10601,"torso","torso",6,180,0,35,8,30,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18450,0,"","torso7",0,30,144,0,0,0,0,1,2,0,0,4);
         this.itemsDB_local[160] = new Array(160,"Laser Cannon v3.0",1,30301,"sideWeapon","physical",3,0,0,0,0,0,0,0,0,18,0,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,8,0,1500,0,"bullet1","laser1C",0,15,8);
         this.itemsDB_local[161] = new Array(161,"One Barrel BB Gun",2,30202,"sideWeapon","electric",2,0,0,0,0,0,0,0,0,16,4,3,0,2,0,0,0,0,0,1,3,0,0,0,0,0,0,0,8,400,0,"laser1","laser5A",0,10,12);
         this.itemsDB_local[162] = new Array(162,"Mini-Chaingun ",3,30203,"sideWeapon","physical",2,0,0,0,0,0,0,5,0,18,9,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,6,0,400,0,"machineGun1","machineGun2",0,10,11);
         this.itemsDB_local[163] = new Array(163,"Duel Barrel BB Gun",2,30302,"sideWeapon","electric",3,0,0,0,0,0,0,0,0,17,4,3,0,3,0,0,0,0,0,1,3,0,0,0,0,0,0,0,8,1500,0,"laser1","laser5B",0,15,14);
         this.itemsDB_local[164] = new Array(164,"Double Plasma Gun",2,30502,"sideWeapon","explosive",5,0,0,0,0,0,0,0,0,18,4,2,5,0,3,1,0,0,0,1,3,0,0,0,0,0,0,9,0,3950,0,"heatCharge1","laser4B",0,25,15);
         this.itemsDB_local[165] = new Array(165,"Chaingun",3,30303,"sideWeapon","physical",3,0,0,0,0,0,0,5,0,20,10,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,7,0,1500,0,"machineGun1","machineGun1",0,15,12);
         this.itemsDB_local[166] = new Array(166,"Electro II",1,30501,"sideWeapon","electric",5,0,0,0,0,0,0,0,0,17,4,3,0,3,0,0,0,0,0,1,3,0,0,0,0,0,0,0,9,3950,0,"laser1","laser2B",0,25,14);
         this.itemsDB_local[167] = new Array(167,"Railgun",4,30304,"sideWeapon","explosive",3,0,0,0,0,0,0,0,0,20,5,2,3,0,3,1,0,0,0,1,3,0,0,0,0,0,0,8,0,2250,0,"heat1","laser10",1,15,13);
         this.itemsDB_local[168] = new Array(168,"RED Plasma Gun",3,30403,"sideWeapon","explosive",4,0,0,0,0,0,0,0,0,18,4,2,5,0,0,1,0,0,0,1,3,0,0,0,0,0,0,10,0,2800,0,"heatCharge1","laser4A",0,20,17);
         this.itemsDB_local[169] = new Array(169,"Rocket Launcher",1,40401,"topWeapon","explosive",4,0,0,0,0,0,0,0,5,18,2,2,2,0,0,1,0,0,0,3,3,0,0,0,0,0,0,8,0,2800,0,"rocketBarrage1","rocketLauncher22A",0,20,12);
         this.itemsDB_local[170] = new Array(170,"Divider",1,40501,"topWeapon","explosive",5,0,0,0,0,0,0,0,5,24,5,2,6,0,0,1,0,0,0,3,3,0,0,0,0,0,0,9,0,3950,0,"rocketBarrage1","rocketLauncher2A",0,25,19);
         this.itemsDB_local[171] = new Array(171,"Electro Cannon",1,40601,"topWeapon","electric",6,0,0,0,0,0,0,0,0,19,6,3,0,6,0,0,0,0,0,3,3,0,0,0,0,0,0,0,11,4950,0,"laser1","laser9",0,30,15);
         this.itemsDB_local[172] = new Array(172,"Lucky Shot",2,40502,"topWeapon","electric",5,0,0,0,0,0,0,0,0,18,7,3,0,3,0,0,0,0,0,3,3,0,0,0,0,0,0,0,10,3950,0,"laser1","laser8A",0,25,12);
         this.itemsDB_local[173] = new Array(173,"Cheddar",3,40603,"topWeapon","physical",6,0,0,0,0,0,0,0,0,24,0,1,0,0,0,1,0,0,0,4,2,0,0,0,0,0,0,9,0,7450,0,"bullet1","laser12A",1,30,13);
         this.itemsDB_local[174] = new Array(174,"Electro I",2,30402,"sideWeapon","electric",4,0,0,0,0,0,0,0,0,18,4,3,0,3,0,0,0,0,0,1,3,0,0,0,0,0,0,0,9,2800,0,"laser1","laser2A",0,20,14);
         this.itemsDB_local[175] = new Array(175,"Electro III",1,30601,"sideWeapon","electric",6,0,0,0,0,0,0,0,0,19,7,3,0,4,0,0,0,0,0,1,3,0,0,0,0,0,0,0,10,4950,0,"laser1","laser2C",0,30,17);
         this.itemsDB_local[176] = new Array(176,"Twin Laser Cannon",1,30201,"sideWeapon","physical",2,0,0,0,0,0,0,0,0,17,0,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,8,0,400,0,"bullet1","laser1B",0,10,8);
         this.itemsDB_local[177] = new Array(177,"Shotgun",1,30305,"sideWeapon","physical",3,0,0,0,0,0,0,5,0,27,6,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1500,0,"bullet1","laser7A",0,15,16);
         this.itemsDB_local[178] = new Array(178,"Adv. Shotgun",1,30401,"sideWeapon","physical",4,0,0,0,0,0,0,5,0,29,7,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,2800,0,"bullet1","laser7B",0,20,17);
         this.itemsDB_local[179] = new Array(179,"Widow Maker",2,40602,"topWeapon","explosive",6,0,0,0,0,0,0,0,5,25,6,2,6,0,0,1,0,0,0,3,3,0,0,0,0,0,0,9,0,4950,0,"rocketBarrage1","rocketLauncher2B",0,30,21);
         this.itemsDB_local[180] = new Array(180,"Air Strike",1,40701,"topWeapon","explosive",7,0,0,0,0,0,0,0,5,22,4,2,5,0,0,0,0,0,0,4,4,0,0,0,0,0,0,10,0,5800,0,"artilleryBarrage1","rocketLauncher3",0,35,16);
         this.itemsDB_local[181] = new Array(181,"Light Gauss Rifle",7,30507,"sideWeapon","explosive",5,0,0,0,0,0,0,0,5,20,6,2,4,0,0,1,0,0,0,2,3,0,0,0,0,0,0,9,0,5950,45,"rocketBarrage1","laser15",3,25,14);
         this.itemsDB_local[182] = new Array(182,"Lava Blaster",2,30902,"sideWeapon","explosive",9,0,0,0,0,0,0,0,0,22,5,2,8,0,0,1,0,0,0,1,3,0,0,0,0,0,0,11,0,7300,0,"beamRoundRed1","laser13",0,45,26);
         this.itemsDB_local[183] = new Array(183,"Soul Drainer",2,30802,"sideWeapon","electric",8,0,0,0,0,0,0,0,0,22,6,3,0,7,0,0,0,0,0,1,3,0,0,0,0,0,0,0,10,6600,0,"beamRoundBlue1","laser3",0,40,22);
         this.itemsDB_local[184] = new Array(184,"Safe Shot",1,40901,"topWeapon","electric",9,0,0,0,0,0,0,0,0,23,8,3,0,8,0,1,0,0,0,3,3,0,0,0,0,0,0,0,11,7300,0,"laser1","laser8B",0,45,23);
         this.itemsDB_local[185] = new Array(185,"Swiss Cheese",3,40803,"topWeapon","physical",8,0,0,0,0,0,0,0,0,26,0,1,0,0,0,1,0,0,0,4,2,0,0,0,0,0,0,10,0,9900,0,"bullet1","laser12B",1,40,14);
         this.itemsDB_local[186] = new Array(186,"Gorgonzola",2,40902,"topWeapon","physical",9,0,0,0,0,0,0,0,0,29,7,1,0,0,0,1,0,0,0,4,2,0,0,0,0,0,0,11,0,10950,0,"bullet1","laser12C",1,45,17);
         this.itemsDB_local[187] = new Array(187,"Plasma Rifle",4,30404,"sideWeapon","electric",4,0,0,0,0,0,0,0,0,18,3,3,0,1,0,0,0,0,0,1,3,0,0,0,0,0,0,0,10,4200,0,"laser1","laser11A",1,20,11);
         this.itemsDB_local[188] = new Array(188,"Double Plasma Rifle",6,30606,"sideWeapon","electric",6,0,0,0,0,0,0,0,0,28,6,3,0,7,3,0,0,0,0,1,3,0,0,0,0,0,0,0,12,7450,54,"laser1","laser11B",3,30,18);
         this.itemsDB_local[189] = new Array(189,"Electric Rifle",1,40801,"topWeapon","electric",8,0,0,0,0,0,0,0,0,25,7,3,0,3,0,0,0,0,0,3,3,0,0,0,0,0,0,0,10,6600,0,"beamBlue1","laser14",0,40,17);
         this.itemsDB_local[190] = new Array(190,"Roast",5,30505,"sideWeapon","explosive",5,0,0,0,0,0,0,0,0,26,6,2,18,0,2,0,0,0,0,2,2,0,0,0,0,0,0,11,0,5950,0,"heat1","laser6",1,25,19);
         this.itemsDB_local[191] = new Array(191,"Elephant",1,10651,"leg","leg",6,0,0,0,0,0,0,0,0,27,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,5250,0,"stomp1","leg4",0,30,12);
         this.itemsDB_local[192] = new Array(192,"Springs",3,10653,"leg","leg",6,12,0,0,0,0,0,0,0,31,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,7900,0,"stomp1","leg5",1,30,23);
         this.itemsDB_local[194] = new Array(194,"Trio-Wheels",2,10652,"leg","leg",6,0,0,0,0,0,0,0,0,31,0,1,0,0,0,1,0,0,0,0,1,2,0,0,0,0,0,0,0,5250,0,"stomp1","wheels2",0,30,17);
         this.itemsDB_local[195] = new Array(195,"Surf Board",4,10654,"leg","leg",6,12,0,0,0,0,0,0,0,34,0,1,0,0,0,1,0,0,0,0,1,3,0,0,0,0,0,0,0,7900,12,"stomp1","wheels4",2,30,30);
         this.itemsDB_local[196] = new Array(196,"Carriers",2,11052,"leg","leg",10,0,0,0,0,0,0,0,0,37,0,1,0,0,0,1,0,0,0,0,1,2,0,0,0,0,0,0,0,9800,0,"stomp1","wheels3",0,50,21);
         this.itemsDB_local[197] = new Array(197,"Plasma Gun",2,30102,"sideWeapon","physical",1,0,0,0,0,0,0,0,0,20,0,1,0,0,2,0,0,0,0,0,2,0,0,0,0,0,0,5,0,125,0,"bulletCharge1","laser16",0,5,7);
         this.itemsDB_local[198] = new Array(198,"Flame Thrower",5,30306,"sideWeapon","explosive",3,0,0,0,0,0,0,0,0,12,12,2,10,0,2,0,0,0,0,0,1,0,0,0,0,0,0,6,0,2250,6,"flame1","flameThrower1",2,15,10);
         this.itemsDB_local[199] = new Array(199,"Ironclad",5,10605,"torso","torso",6,168,0,35,9,40,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,27700,0,"","torso11",1,30,147,0,0,0,0,0,1,2,0,4);
         this.itemsDB_local[200] = new Array(200,"Predator",6,11006,"torso","torso",10,216,0,45,12,45,12,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,51900,20,"","torso12",2,50,189,0,0,0,0,0,2,1,0,4);
         this.itemsDB_local[202] = new Array(202,"Scope",8,11008,"torso","torso",10,222,0,45,12,55,14,5,5,0,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0,0,0,0,51900,90,"","torso13",3,50,201,0,0,0,0,2,0,2,0,5);
         this.itemsDB_local[203] = new Array(203,"Bully",3,30603,"sideWeapon","physical",6,0,0,0,0,0,0,0,0,14,5,1,0,0,2,3,0,0,0,0,3,0,0,0,0,0,0,4,4,4950,0,"bulletCharge1","laser18",0,30,10);
         this.itemsDB_local[204] = new Array(204,"Back Blow",4,31004,"sideWeapon","physical",10,0,0,0,0,0,0,0,0,10,6,1,0,0,3,3,0,0,0,0,3,0,0,0,0,0,0,5,5,7950,0,"beamRoundYellow1","laser19",0,50,13);
         this.itemsDB_local[205] = new Array(205,"Sting Cannon",1,30701,"sideWeapon","electric",7,0,0,0,0,0,0,0,0,22,5,3,0,7,0,0,0,0,0,1,3,0,0,0,0,0,0,0,11,5800,0,"laser1","laser17A",0,35,21);
         this.itemsDB_local[206] = new Array(206,"Mach 2 Cannon",1,31001,"sideWeapon","electric",10,0,0,0,0,0,0,0,0,23,8,3,0,9,0,1,0,0,0,1,3,0,0,0,0,0,0,0,12,7950,0,"laser1","laser17B",0,50,28);
         this.itemsDB_local[207] = new Array(207,"The Drainer",3,40703,"topWeapon","electric",7,0,0,0,0,0,0,0,0,23,5,3,0,9,3,0,0,0,0,1,4,0,0,0,0,0,0,0,7,8700,63,"beamRoundBlue1","laser20A",3,35,23);
         this.itemsDB_local[208] = new Array(208,"Mega Drain",3,41003,"topWeapon","electric",10,0,0,0,0,0,0,0,0,11,10,3,0,28,2,0,0,0,0,1,4,0,0,0,0,0,0,0,7,11950,81,"beamRoundBlue1","laser20B",3,45,30);
         this.itemsDB_local[209] = new Array(209,"Spammer",5,30405,"sideWeapon","physical",4,0,0,0,0,0,0,5,0,29,7,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,4200,8,"bullet1","machineGun3A",2,20,16);
         this.itemsDB_local[210] = new Array(210,"Double Spammer",4,30604,"sideWeapon","physical",6,0,0,0,0,0,0,5,0,30,5,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,1,0,7450,0,"bullet1","machineGun3B",1,30,17);
         this.itemsDB_local[211] = new Array(211,"Tripple spammer",2,30803,"sideWeapon","physical",8,0,0,0,0,0,0,5,0,50,5,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,4,0,9900,0,"bullet1","machineGun3C",1,40,25);
         this.itemsDB_local[212] = new Array(212,"Gauss Rifle",6,30706,"sideWeapon","explosive",7,0,0,0,0,0,0,0,5,28,6,2,9,0,0,1,0,0,0,2,3,0,0,0,0,0,0,8,0,8700,63,"rocketBarrage2","rocketLauncher5",3,35,23);
         this.itemsDB_local[213] = new Array(213,"Heavy Gauss Rifle",3,30903,"sideWeapon","explosive",9,0,0,0,0,0,0,0,5,32,8,2,8,0,0,0,0,0,0,2,3,0,0,0,0,0,0,16,0,7300,0,"rocketBarrage1","rocketLauncher4",0,45,22);
         this.itemsDB_local[214] = new Array(214,"Ruby",4,11004,"torso","torso",10,210,0,35,10,55,14,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,51900,0,"","torso15",1,50,189,0,0,0,0,1,1,1,0,6);
         this.itemsDB_local[215] = new Array(215,"Emerald",5,11005,"torso","torso",10,210,0,55,14,35,10,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,51900,0,"","torso16",1,50,189,0,0,0,0,0,2,2,0,6);
         this.itemsDB_local[219] = new Array(219,"Fire Starter",2,30602,"sideWeapon","explosive",6,0,0,0,0,0,0,0,0,24,6,2,12,0,2,0,0,0,0,0,1,0,0,0,0,0,0,6,0,4950,0,"flame1","flameThrower1",0,30,14);
         this.itemsDB_local[220] = new Array(220,"Long shot",1,41001,"topWeapon","explosive",10,0,0,0,0,0,0,0,5,33,3,2,4,0,0,0,0,0,0,3,4,0,0,0,0,0,0,13,0,7950,0,"artilleryBarrage1","rocketLauncher8A",0,50,23);
         this.itemsDB_local[223] = new Array(223,"MaC Gun",3,30503,"sideWeapon","physical",5,0,0,0,0,0,0,5,0,23,10,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,5,0,3950,0,"machineGun2","machineGun4A",0,25,15);
         this.itemsDB_local[224] = new Array(224,"Lin Gun",2,30904,"sideWeapon","physical",9,0,0,0,0,0,0,5,0,30,3,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,5,0,7300,0,"machineGun2","machineGun4B",0,45,18);
         this.itemsDB_local[226] = new Array(226,"Flame Thrower v3.0",1,30801,"sideWeapon","explosive",8,0,0,0,0,0,0,0,0,23,5,2,15,0,3,0,0,0,0,0,1,0,0,0,0,0,0,5,0,6600,0,"flame1","flameThrower2",0,40,20);
         this.itemsDB_local[228] = new Array(228,"Big Bertha",5,31005,"sideWeapon","explosive",10,0,0,0,0,0,0,0,0,30,0,2,13,0,0,1,0,0,0,1,3,0,0,0,0,0,0,13,0,11950,20,"heat1","laser22A",2,50,32);
         this.itemsDB_local[239] = new Array(239,"Firebee",1,50601,"drone","drone",6,0,0,0,0,0,0,0,5,16,0,2,5,0,0,0,0,0,0,0,999,0,0,0,0,0,0,6,1,5150,0,"rocketBarrage1","drone5A",0,30,13);
         this.itemsDB_local[240] = new Array(240,"Elector",2,50702,"drone","drone",7,0,0,0,0,0,0,0,0,15,5,3,0,5,0,0,0,0,0,0,999,0,0,0,0,0,0,0,7,8700,0,"laser1","drone4A",1,35,14);
         this.itemsDB_local[241] = new Array(241,"Flying Canon",1,50701,"drone","drone",7,0,0,0,0,0,0,0,5,17,0,2,5,0,0,0,0,0,0,0,999,0,0,0,0,0,0,6,1,5800,0,"rocketBarrage1","drone5B",0,35,14);
         this.itemsDB_local[242] = new Array(242,"Heatseeker",3,50703,"drone","drone",7,0,0,0,0,0,0,0,0,18,0,2,6,0,0,0,0,0,0,0,999,0,0,0,0,0,0,6,1,8700,14,"heat1","drone4B",2,35,15);
         this.itemsDB_local[243] = new Array(243,"Blaster",1,50801,"drone","drone",8,0,0,0,0,0,0,0,0,16,0,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,4,2,6400,0,"bulletCharge1","drone7A",0,40,10);
         this.itemsDB_local[244] = new Array(244,"The Drone of Destruction",1,51001,"drone","drone",10,0,0,0,0,0,0,0,0,17,0,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,9,5,7450,0,"bullet2","drone7B",0,50,11);
         this.itemsDB_local[245] = new Array(245,"Blue Snow",1,50901,"drone","drone",9,0,0,0,0,0,0,0,0,15,6,3,0,6,0,0,0,0,0,0,999,0,0,0,0,0,0,0,10,6950,0,"laser1","drone6A",0,45,16);
         this.itemsDB_local[246] = new Array(246,"Red Snow",2,50902,"drone","drone",9,0,0,0,0,0,0,0,0,18,0,2,6,0,0,0,0,0,0,0,999,0,0,0,0,0,0,7,3,10450,0,"heat1","drone6B",1,45,16);
         this.itemsDB_local[247] = new Array(247,"Bullet & Rocket Storage 1",5,110305,"module","ammo",3,0,0,0,0,0,0,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,0,"","module_bulletsRockets_1_1",1,6,16);
         this.itemsDB_local[248] = new Array(248,"Bullet & Rocket Storage 2",5,110605,"module","ammo",6,0,0,0,0,0,0,20,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4950,0,"","module_bulletsRockets_2_1",1,12,24);
         this.itemsDB_local[249] = new Array(249,"Bullet & Rocket Storage 3",6,110606,"module","ammo",6,0,0,0,0,0,0,10,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4950,0,"","module_bulletsRockets_1_2",1,12,24);
         this.itemsDB_local[250] = new Array(250,"Bullet & Rocket Storage 4",8,110908,"module","ammo",9,0,0,0,0,0,0,20,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7300,0,"","module_bulletsRockets_2_2",1,18,32);
         this.itemsDB_local[251] = new Array(251,"Energy & Heat Module 1",3,110403,"module","energyHeat",4,0,0,6,3,6,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2850,0,"","module_energyHeat1",1,8,17);
         this.itemsDB_local[252] = new Array(252,"Energy & Heat Module 2",7,110907,"module","energyHeat",9,0,0,10,5,10,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7300,0,"","module_energyHeat2",1,18,28);
         this.itemsDB_local[255] = new Array(255,"Regeneration & Cooldown Module 1",2,110604,"module","energyHeat",6,0,0,0,8,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3300,0,"","module_mixed1",0,12,20);
         this.itemsDB_local[259] = new Array(259,"Fort Wall",4,11054,"leg","leg",10,24,0,0,0,0,0,0,0,40,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,14700,90,"stomp1","leg7",3,50,32);
         this.itemsDB_local[269] = new Array(269,"Energy module 5",2,110803,"module","energyHeat",8,0,0,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4400,0,"","module_energy5",0,16,21);
         this.itemsDB_local[271] = new Array(271,"Regeneration & Cooldown Module 2",2,111002,"module","energyHeat",10,0,0,0,13,0,13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7950,20,"","module_mixed1",2,20,30);
         this.itemsDB_local[304] = new Array(304,"Heat Module 6",2,110902,"module","energyHeat",9,0,0,0,0,22,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4850,0,"","module_heat6",0,18,26);
         this.itemsDB_local[315] = new Array(315,"Heavy Legs",1,11051,"leg","leg",10,0,0,0,0,0,0,0,0,33,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,9800,0,"stomp1","leg8",0,50,16);
         this.itemsDB_local[317] = new Array(317,"Ultra Springs",3,11053,"leg","leg",10,12,0,0,0,0,0,0,0,37,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,14700,0,"stomp1","leg12",1,50,27);
         this.itemsDB_local[342] = new Array(342,"Buzzer",4,30504,"sideWeapon","electric",5,0,0,0,0,0,0,0,0,8,8,3,0,20,3,0,0,0,0,2,2,0,0,0,0,0,0,0,10,5950,0,"laserCharge1","laser28A",1,25,19);
         this.itemsDB_local[343] = new Array(343,"Heat Module 2",1,110402,"module","energyHeat",4,0,0,0,0,8,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1900,0,"","module_heat1",0,8,9);
         this.itemsDB_local[344] = new Array(344,"Physical Resistance Module 2",1,110901,"module","resistance",9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,4850,0,"","module_resistancePhysical2",0,18,6);
         this.itemsDB_local[348] = new Array(348,"Electric Resistance Module 1",1,110702,"module","resistance",7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,3900,0,"","module_resistanceElectric1",0,14,2);
         this.itemsDB_local[349] = new Array(349,"Explosive Resistance Module 1",1,110703,"module","resistance",7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,3900,0,"","module_resistanceExplosive1",0,14,2);
         this.itemsDB_local[350] = new Array(350,"Explosive Resistance Module 2",1,110904,"module","resistance",9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,4850,0,"","module_resistanceExplosive2",0,18,6);
         this.itemsDB_local[354] = new Array(354,"Electric Resistance Module 2",1,110905,"module","resistance",9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,4850,0,"","module_resistanceElectric2",0,18,6);
         this.itemsDB_local[410] = new Array(410,"Harpoon Mark 1",1,90501,"harpoon","harpoon",5,0,0,0,0,0,0,0,0,19,0,1,0,0,1,0,0,0,0,1,4,0,0,0,0,0,0,0,12,3500,0,"","harpoon1",0,20,6);
         this.itemsDB_local[411] = new Array(411,"Burning Harpoon Mark 1",1,90901,"harpoon","harpoon",9,0,0,0,0,0,0,0,0,22,0,2,6,0,1,0,0,0,0,1,4,0,0,0,0,0,0,0,16,6950,0,"","harpoon2",0,45,11);
         this.itemsDB_local[414] = new Array(414,"Commander",1,10201,"torso","torso",2,120,0,30,6,25,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1150,0,"","torso1B",0,10,107,0,0,0,0,1,0,2,0,4);
         this.itemsDB_local[415] = new Array(415,"Metal box",1,10301,"torso","torso",3,144,0,25,6,25,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4000,0,"","torso2B",0,15,112,0,0,0,0,1,2,1,0,4);
         this.itemsDB_local[416] = new Array(416,"Skeletor",4,10304,"torso","torso",3,138,0,30,7,30,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6000,0,"","torso3B",1,15,118,0,0,0,0,0,2,1,0,3);
         this.itemsDB_local[417] = new Array(417,"Blood Shot",7,10607,"torso","torso",6,174,0,40,9,45,9,5,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,27700,54,"","torso4B",3,30,157,0,0,0,0,1,1,1,0,3);
         this.itemsDB_local[418] = new Array(418,"Fence",3,10303,"torso","torso",3,144,0,30,7,25,7,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,6000,0,"","torso5B",1,15,124,0,0,0,0,3,0,1,0,4);
         this.itemsDB_local[419] = new Array(419,"Adv. Repair Kit 1",2,120602,"kit","repair",6,60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,750,0,"","kit_HP8",1,3,0);
         this.itemsDB_local[420] = new Array(420,"Adv. Repair Kit 2",3,121003,"kit","repair",10,72,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1050,0,"","kit_HP9",1,5,0);
         this.itemsDB_local[427] = new Array(427,"Rockets Kit 5",1,121002,"kit","ammo",10,0,0,0,0,0,0,0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,700,0,"","kit_rockets5",0,5,0);
         this.itemsDB_local[436] = new Array(436,"Adv. Cooling Kit 1",3,120403,"kit","energyHeat",4,0,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,600,0,"","kit_heat8",1,2,0);
         this.itemsDB_local[437] = new Array(437,"Adv. Cooling Kit 2",6,120706,"kit","energyHeat",7,0,0,0,0,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,850,0,"","kit_heat9",1,4,0);
         this.itemsDB_local[439] = new Array(439,"Adv. Energy Kit 1",2,120502,"kit","energyHeat",5,0,0,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,700,0,"","kit_energy8",1,3,0);
         this.itemsDB_local[440] = new Array(440,"Adv. Energy Kit 2",4,120804,"kit","energyHeat",8,0,0,45,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,900,0,"","kit_energy9",1,4,0);
         this.itemsDB_local[462] = new Array(462,"Mach Cannon",4,30704,"sideWeapon","electric",7,0,0,0,0,0,0,0,0,22,10,3,0,5,0,0,0,0,0,1,3,0,0,0,0,0,0,0,10,8700,0,"beamRoundBlue2","laser44A",1,35,21);
         this.itemsDB_local[524] = new Array(524,"Hot Fire",1,41002,"topWeapon","explosive",10,0,0,0,0,0,0,0,5,30,6,2,5,0,0,1,0,0,0,3,3,0,0,0,0,0,0,10,0,11950,0,"rocketBarrage1","rocketLauncher23A",1,50,23);
         this.itemsDB_local[535] = new Array(535,"Rocket Hand",1,30702,"sideWeapon","explosive",7,0,0,0,0,0,0,0,5,22,5,2,2,0,0,1,0,0,0,2,3,0,0,0,0,0,0,10,0,5800,0,"rocketBarrage2","rocketLauncher15A",0,35,15);
         this.itemsDB_local[537] = new Array(537,"Dino Rifle",5,30905,"sideWeapon","physical",9,0,0,0,0,0,0,0,0,28,10,1,0,0,0,1,0,0,0,1,3,0,0,0,0,0,0,9,0,10950,81,"bullet2","cannon3A",3,45,20);
         this.itemsDB_local[538] = new Array(538,"Red eyes",1,30804,"sideWeapon","explosive",8,0,0,0,0,0,0,0,0,20,5,2,4,0,0,1,0,0,0,1,3,0,0,0,0,0,0,15,0,6600,0,"heatCharge1","laser46B",0,40,17);
         this.itemsDB_local[567] = new Array(567,"LR Heat Blaster",2,40802,"topWeapon","explosive",8,0,0,0,0,0,0,0,0,16,5,2,15,0,0,0,0,0,0,3,3,0,0,0,0,0,0,6,0,6600,0,"heatCharge1","blaster1B",0,40,25);
         this.itemsDB_local[568] = new Array(568,"SR Heat Blaster",2,40702,"topWeapon","explosive",7,0,0,0,0,0,0,0,0,22,0,2,5,0,0,1,0,0,0,3,3,0,0,0,0,0,0,11,0,5800,0,"heat1","blaster1A",0,35,16);
         this.itemsDB_local[573] = new Array(573,"Breach",2,10302,"torso","torso",3,132,0,30,8,25,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4000,0,"","torso35",0,15,114,0,0,0,0,1,2,1,0,3);
         this.itemsDB_local[574] = new Array(574,"Capsule",2,10602,"torso","torso",6,150,0,40,8,35,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18450,0,"","torso40",0,30,142,0,0,0,0,0,2,2,0,5);
         this.itemsDB_local[575] = new Array(575,"Threetop",1,11001,"torso","torso",10,198,0,50,14,40,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,34600,0,"","torso23B",0,50,180,0,0,0,0,1,1,2,0,4);
         this.itemsDB_local[576] = new Array(576,"Soldier",7,11007,"torso","torso",10,216,0,50,13,50,13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,51900,20,"","torso24B",2,50,188,0,0,0,0,2,1,1,0,4);
         this.itemsDB_local[583] = new Array(583,"Flatfoot",3,10353,"leg","leg",3,6,0,0,0,0,0,0,0,26,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,1500,0,"stomp1","leg25",1,15,14);
         this.itemsDB_local[592] = new Array(592,"Heat Shield Mark 1",2,60602,"shield","shield",6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,10,0,0,440,0,"","shield1B",0,30,2);
         this.itemsDB_local[597] = new Array(597,"Skull crusher",5,30705,"sideWeapon","melee",7,0,0,0,0,0,0,0,0,27,30,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,7,10,8700,14,"sword1","sword2A",2,35,13);
         this.itemsDB_local[598] = new Array(598,"Almace",6,30406,"sideWeapon","melee",4,0,0,0,0,0,0,0,0,27,7,2,10,0,0,0,0,0,0,0,1,0,0,0,0,0,0,7,10,4200,36,"sword2","sword4B",3,20,15);
         this.itemsDB_local[599] = new Array(599,"Electric butcher",6,30506,"sideWeapon","melee",5,0,0,0,0,0,0,0,0,35,10,3,0,5,0,0,0,0,0,0,1,0,0,0,0,0,0,0,18,5950,10,"sword3","sword4C",2,25,16);
         this.itemsDB_local[600] = new Array(600,"Golden sword",5,30605,"sideWeapon","melee",6,0,0,0,0,0,0,0,0,33,8,1,0,0,0,2,0,0,0,0,1,0,0,0,0,0,0,4,14,7450,12,"sword1","sword4D",2,30,13);
         this.itemsDB_local[602] = new Array(602,"Durendal",3,30805,"sideWeapon","melee",8,0,0,0,0,0,0,0,0,32,8,2,12,0,0,0,0,0,0,0,1,0,0,0,0,0,0,8,10,9900,16,"sword2","sword2C",2,40,20);
         this.itemsDB_local[603] = new Array(603,"Electric chain saw",3,30906,"sideWeapon","melee",9,0,0,0,0,0,0,0,0,29,10,3,0,16,0,0,0,0,0,0,1,0,0,0,0,0,0,0,18,10950,0,"sword3","sword2B",1,45,23);
         this.itemsDB_local[604] = new Array(604,"Butter knife",4,31006,"sideWeapon","melee",10,0,0,0,0,0,0,0,0,41,0,1,0,0,0,2,0,0,0,0,1,0,0,0,0,0,0,4,14,11950,0,"sword1","sword2D",1,50,17);
         this.itemsDB_local[614] = new Array(614,"Bone crusher",3,30307,"sideWeapon","melee",3,0,0,0,0,0,0,0,0,31,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,5,10,2250,0,"sword1","sword4A",1,15,9);
         this.itemsDB_local[627] = new Array(627,"Master Cooling Kit 2",7,120707,"kit","energyHeat",7,0,0,0,0,45,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,850,1,"","kit_heatS2",2,4,0);
         this.itemsDB_local[628] = new Array(628,"Master Cooling Kit 1",4,120404,"kit","energyHeat",4,0,0,0,0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,600,1,"","kit_heatS1",2,2,0);
         this.itemsDB_local[634] = new Array(634,"Master Repair Kit 2",4,121004,"kit","repair",10,78,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1050,2,"","kit_HPS2",2,5,0);
         this.itemsDB_local[635] = new Array(635,"Master Repair Kit 1",3,120603,"kit","repair",6,66,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,750,1,"","kit_HPS1",2,3,0);
         this.itemsDB_local[641] = new Array(641,"Master Energy Kit 2",5,120805,"kit","energyHeat",8,0,0,55,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,900,1,"","kit_energyS2",2,4,0);
         this.itemsDB_local[642] = new Array(642,"Adv. Energy Kit 1",3,120503,"kit","energyHeat",5,0,0,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,700,1,"","kit_energyS1",2,3,0);
         this.itemsDB_local[646] = new Array(646,"Flipmix",2,50802,"drone","drone",8,0,0,0,0,0,0,0,0,19,0,2,7,0,0,0,0,0,0,0,999,0,0,0,0,0,0,7,3,9600,72,"heatCharge1","drone25",3,40,15);
         this.itemsDB_local[647] = new Array(647,"Jim Beam",3,50903,"drone","drone",9,0,0,0,0,0,0,0,0,17,10,3,0,10,0,0,0,0,0,0,999,0,0,0,0,0,0,0,8,10450,18,"beamRoundBlue1","drone14",2,45,20);
         this.itemsDB_local[673] = new Array(673,"Physical Resistance Kit",3,120703,"kit","resistance",7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,1500,0,"","kit_resistPhysical1",1,4,0);
         this.itemsDB_local[674] = new Array(674,"Electric Resistance Kit",5,120705,"kit","resistance",7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,1500,0,"","kit_resistElectric1",1,4,0);
         this.itemsDB_local[675] = new Array(675,"Explosive Resistance Kit",4,120704,"kit","resistance",7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,1500,0,"","kit_resistExplosive1",1,4,0);
         this.itemsDB_local[679] = new Array(679,"Physical Resistance Kit",1,121005,"kit","resistance",10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,1800,0,"","kit_resistPhysical2",1,5,0);
         this.itemsDB_local[680] = new Array(680,"Explosive Resistance Kit",2,121006,"kit","resistance",10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,1800,0,"","kit_resistExplosive2",1,5,0);
         this.itemsDB_local[693] = new Array(693,"Electric Resistance Kit",3,121007,"kit","resistance",10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,1800,0,"","kit_resistElectric2",1,5,0);
         this.itemsDB_local[699] = new Array(699,"Multi Resistance Module",4,110306,"module","resistance",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1500,6,"","module_resistanceAll1",2,8,6);
         this.itemsDB_local[700] = new Array(700,"Multi Resistance Module",7,110607,"module","resistance",6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,0,0,0,0,0,0,0,0,0,0,4950,12,"","module_resistanceAll2",2,12,11);
         this.itemsDB_local[702] = new Array(702,"Multi Resistance Module",4,110906,"module","resistance",9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0,7300,18,"","module_resistanceAll3",2,20,16);
         this.itemsDB_local[708] = new Array(708,"Energy Blaster V1",1,40201,"topWeapon","electric",2,0,0,0,0,0,0,0,0,16,4,3,0,4,2,0,0,0,0,3,2,0,0,0,0,0,0,0,6,450,0,"laser1","blaster9A",0,10,8);
         this.itemsDB_local[709] = new Array(709,"Energy Blaster V2",1,40301,"topWeapon","electric",3,0,0,0,0,0,0,0,0,17,5,3,0,5,2,0,0,0,0,3,2,0,0,0,0,0,0,0,7,1500,0,"laser1","blaster9B",0,15,9);
         this.itemsDB_local[710] = new Array(710,"Heat Blaster",1,40302,"topWeapon","explosive",3,0,0,0,0,0,0,0,0,18,0,2,5,0,0,0,0,0,0,3,2,0,0,0,0,0,0,10,0,1500,0,"heat1","blaster10",0,15,12);
         this.itemsDB_local[711] = new Array(711,"Straight Shot Mark I",1,40303,"topWeapon","physical",3,0,0,0,0,0,0,5,0,23,0,1,0,0,0,0,0,0,0,4,2,0,0,0,0,0,0,7,0,1500,0,"bullet1","cannon5A",0,15,11);
         this.itemsDB_local[712] = new Array(712,"Straight Shot Mark II",1,40402,"topWeapon","physical",4,0,0,0,0,0,0,5,0,22,8,1,0,0,0,1,0,0,0,4,2,0,0,0,0,0,0,8,0,2800,0,"bullet1","cannon5B",0,20,13);
         this.itemsDB_local[713] = new Array(713,"Rocket Battery Mark I",1,40304,"topWeapon","explosive",3,0,0,0,0,0,0,0,5,23,0,2,2,0,0,1,0,0,0,3,3,0,0,0,0,0,0,7,0,1500,0,"rocketBarrage1","rocketLauncher18A",0,15,14);
         this.itemsDB_local[714] = new Array(714,"Rocket Battery Mark II",1,40403,"topWeapon","explosive",4,0,0,0,0,0,0,0,5,25,2,2,1,0,0,1,0,0,0,3,3,0,0,0,0,0,0,10,0,4200,0,"rocketBarrage1","rocketLauncher18B",1,20,13);
         this.itemsDB_local[715] = new Array(715,"Rocket Battery Mark III",3,40503,"topWeapon","explosive",5,0,0,0,0,0,0,0,5,20,5,2,2,0,0,1,0,0,0,3,3,0,0,0,0,0,0,12,0,5950,10,"rocketBarrage1","rocketLauncher18C",2,25,12);
         this.itemsDB_local[716] = new Array(716,"Flame Thrower v4.0",1,31002,"sideWeapon","explosive",10,0,0,0,0,0,0,0,0,27,0,2,16,0,3,0,0,0,0,0,1,0,0,0,0,0,0,5,0,7950,0,"flame1","flameThrower7A",0,50,21);
         this.itemsDB_local[726] = new Array(726,"Adv. Teleport Mark 1",1,70402,"teleport","teleport",4,0,0,0,0,0,0,0,0,16,10,3,0,4,1,0,0,0,0,0,1,0,0,0,0,0,0,0,10,5250,8,"","teleport1",2,20,7);
         this.itemsDB_local[727] = new Array(727,"Adv. Teleport Mark 2",1,70902,"teleport","teleport",9,0,0,0,0,0,0,0,0,26,12,3,0,11,1,0,0,0,0,0,1,0,0,0,0,0,0,0,20,10450,81,"","teleport3",3,45,12);
         this.itemsDB_local[730] = new Array(730,"Adv. Charge Mark 1",1,80902,"charge","charge",9,0,0,0,0,0,0,0,0,28,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,14,10,8700,14,"","charge2",2,35,9);
         this.itemsDB_local[733] = new Array(733,"Adv. Harpoon Mark 2",1,90701,"harpoon","harpoon",7,0,0,0,0,0,0,0,0,25,0,1,0,0,1,0,0,0,0,1,4,0,0,0,0,0,0,0,14,8700,0,"","harpoon1",1,35,8);
         this.itemsDB_local[734] = new Array(734,"Adv. Harpoon Mark 1",1,90702,"harpoon","harpoon",7,0,0,0,0,0,0,0,0,30,0,1,0,0,1,0,0,0,0,1,4,0,0,0,0,0,0,0,12,8700,14,"","harpoon1",2,35,9);
         this.itemsDB_local[768] = new Array(768,"Adv. Energy Shield Mark 1",3,60703,"shield","shield",7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,4,15,0,0,7750,18,"","shield1A",1,30,8);
         this.itemsDB_local[769] = new Array(769,"Adv. Heat Shield Mark 2",4,60804,"shield","shield",8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,20,0,0,8700,14,"","shield1B",2,30,8);
         this.itemsDB_local[770] = new Array(770,"Adv. Energy Shield Mark 2",5,60805,"shield","shield",8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,2,20,0,0,8700,14,"","shield1A",2,30,12);
         this.itemsDB_local[771] = new Array(771,"Adv. Heat Shield Mark 1",6,60706,"shield","shield",7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,4,15,0,0,7750,18,"","shield1B",1,30,5);
         this.itemsDB_local[776] = new Array(776,"Energy Shield Mark 2",5,60905,"shield","shield",9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,4,15,0,0,6400,0,"","shield2A",0,50,8);
         this.itemsDB_local[777] = new Array(777,"Adv. Heat Shield Mark 3",4,61004,"shield","shield",10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,20,0,0,10450,27,"","shield2B",1,50,8);
         this.itemsDB_local[778] = new Array(778,"Heat Shield Mark 2",6,60906,"shield","shield",9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,4,15,0,0,6400,0,"","shield2B",0,50,5);
         this.itemsDB_local[822] = new Array(822,"Power Kit",4,120334,"kit","power",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,5,"","kit_powerB1",2,60,0);
         this.itemsDB_local[824] = new Array(824,"Power Kit",4,120434,"kit","power",4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,600,6,"","kit_powerB1",2,80,0);
         this.itemsDB_local[825] = new Array(825,"Power Kit",4,120534,"kit","power",5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,700,7,"","kit_powerB1",2,100,0);
         this.itemsDB_local[826] = new Array(826,"Power Kit",4,120634,"kit","power",6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,750,8,"","kit_powerB2",2,120,0);
         this.itemsDB_local[827] = new Array(827,"Power Kit",9,120739,"kit","power",7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,850,9,"","kit_powerB2",2,140,0);
         this.itemsDB_local[828] = new Array(828,"Power Kit",6,120836,"kit","power",8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,900,10,"","kit_powerB2",2,160,0);
         this.itemsDB_local[829] = new Array(829,"Power Kit",6,120936,"kit","power",9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,11,"","kit_powerB3",2,180,0);
         this.itemsDB_local[830] = new Array(830,"Power Kit",4,121034,"kit","power",10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1050,12,"","kit_powerB3",2,200,0);
         this.itemsDB_local[849] = new Array(849,"Power Kit",1,120431,"kit","power",4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,600,0,"","kit_power1",1,40,0);
         this.itemsDB_local[850] = new Array(850,"Power Kit",1,120531,"kit","power",5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,700,0,"","kit_power1",1,50,0);
         this.itemsDB_local[851] = new Array(851,"Power Kit",1,120631,"kit","power",6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,750,0,"","kit_power1",1,60,0);
         this.itemsDB_local[852] = new Array(852,"Power Kit",1,120731,"kit","power",7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,850,0,"","kit_power2",1,70,0);
         this.itemsDB_local[853] = new Array(853,"Power Kit",1,120831,"kit","power",8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,900,0,"","kit_power2",1,80,0);
         this.itemsDB_local[854] = new Array(854,"Power Kit",1,120931,"kit","power",9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"","kit_power2",1,90,0);
         this.itemsDB_local[855] = new Array(855,"Power Kit",1,121031,"kit","power",10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1050,0,"","kit_power3",1,100,0);
         this.itemsDB_local[876] = new Array(876,"Power Kit",2,120332,"kit","power",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,450,0,"","kit_power1",1,30,0);
         this.itemsDB_local[904] = new Array(904,"Color Kit",3,120303,"kit","color",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,500,0,"1","kit_color1",2,0,0);
         this.itemsDB_local[905] = new Array(905,"Color Kit",3,120304,"kit","color",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,300,0,"2","kit_color2",2,0,0);
         this.itemsDB_local[906] = new Array(906,"Color Kit",3,120305,"kit","color",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,300,0,"3","kit_color3",2,0,0);
         this.itemsDB_local[907] = new Array(907,"Color Kit",3,120306,"kit","color",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,500,0,"4","kit_color4",2,0,0);
         this.itemsDB_local[908] = new Array(908,"Color Kit",3,120307,"kit","color",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,700,0,"5","kit_color5",2,0,0);
         this.itemsDB_local[909] = new Array(909,"Color Kit",3,120308,"kit","color",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,500,0,"6","kit_color6",2,0,0);
         this.itemsDB_local[910] = new Array(910,"Color Kit",3,120309,"kit","color",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,300,0,"7","kit_color7",2,0,0);
         this.itemsDB_local[911] = new Array(911,"Color Kit",3,120310,"kit","color",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,500,0,"8","kit_color8",2,0,0);
         this.itemsDB_local[912] = new Array(912,"Color Kit",3,120311,"kit","color",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"9","kit_color9",2,0,0);
         this.itemsDB_local[913] = new Array(913,"Remove Color Kit",0,120300,"kit","color",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,300,0,"0","kit_color0",0,0,0);
         this.itemsDB_local[996] = new Array(996,"Shotgun Mark I",2,30907,"sideWeapon","physical",9,0,0,0,0,0,0,5,0,30,10,1,0,0,0,1,0,0,0,0,2,0,0,0,0,0,0,4,0,3040,18,"shotgun1","shotgun3A",2,40,21);
         this.itemsDB_local[997] = new Array(997,"Shotgun Mark II",2,31003,"sideWeapon","physical",10,0,0,0,0,0,0,5,0,32,10,1,0,0,0,1,0,0,0,0,2,0,0,0,0,0,0,5,0,11950,20,"shotgun1","shotgun3B",2,40,22);
         this.itemsDB_local[50] = new Array(50,"Repair Kit 5",1,121801,"kit","repair",18,84,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,900,0,"","kit_HP5",0,9,0);
         this.itemsDB_local[51] = new Array(51,"Repair Kit 6",1,122201,"kit","repair",22,96,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,950,0,"","kit_HP6",0,11,0);
         this.itemsDB_local[60] = new Array(60,"Bullet Storage 4",2,111102,"module","ammo",11,0,0,0,0,0,0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5700,0,"","module_bullets4",0,22,24);
         this.itemsDB_local[63] = new Array(63,"Rocket Storage 4",3,111203,"module","ammo",12,0,0,0,0,0,0,0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6000,0,"","module_rockets4",0,24,24);
         this.itemsDB_local[68] = new Array(68,"Armor Plating 4",2,111103,"module","armor",11,36,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5700,0,"","module_HP4",0,22,15);
         this.itemsDB_local[70] = new Array(70,"Armor Plating 5",2,111402,"module","armor",14,42,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6650,0,"","module_HP5",0,28,17);
         this.itemsDB_local[76] = new Array(76,"Repair Kit 4",1,121401,"kit","repair",14,72,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,800,0,"","kit_HP4",0,7,0);
         this.itemsDB_local[78] = new Array(78,"Energy Kit 3",1,121201,"kit","energyHeat",12,0,0,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,750,0,"","kit_energy3",0,6,0);
         this.itemsDB_local[79] = new Array(79,"Energy Kit 4",1,121601,"kit","energyHeat",16,0,0,60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,850,0,"","kit_energy4",0,8,0);
         this.itemsDB_local[80] = new Array(80,"Energy Kit 5",1,122001,"kit","energyHeat",20,0,0,75,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,900,0,"","kit_energy5",0,10,0);
         this.itemsDB_local[81] = new Array(81,"Energy Kit 6",1,122401,"kit","energyHeat",24,0,0,85,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,950,0,"","kit_energy6",0,12,0);
         this.itemsDB_local[85] = new Array(85,"Bullets Kit 3",1,121301,"kit","ammo",13,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,750,0,"","kit_bullets3",0,7,0);
         this.itemsDB_local[86] = new Array(86,"Bullets Kit 4",1,121602,"kit","ammo",16,0,0,0,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,850,0,"","kit_bullets4",0,8,0);
         this.itemsDB_local[92] = new Array(92,"Cooling Kit 6",1,122301,"kit","energyHeat",23,0,0,0,0,80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,950,0,"","kit_heat6",0,12,0);
         this.itemsDB_local[94] = new Array(94,"Cooling Kit 3",1,121101,"kit","energyHeat",11,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,700,0,"","kit_heat3",0,6,0);
         this.itemsDB_local[95] = new Array(95,"Cooling Kit 4",1,121501,"kit","energyHeat",15,0,0,0,0,60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,800,0,"","kit_heat4",0,8,0);
         this.itemsDB_local[96] = new Array(96,"Cooling Kit 5",1,121901,"kit","energyHeat",19,0,0,0,0,70,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,900,0,"","kit_heat5",0,10,0);
         this.itemsDB_local[139] = new Array(139,"Adv. Energy Shield Mark 6",1,61401,"shield","shield",14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,1,30,0,0,13500,28,"","shield3A",2,70,23);
         this.itemsDB_local[141] = new Array(141,"Energy Shield Mark 4",1,61601,"shield","shield",16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,4,25,0,0,9600,0,"","shield4A",0,90,18);
         this.itemsDB_local[144] = new Array(144,"Teleport Mark 4",1,71201,"teleport","teleport",12,0,0,0,0,0,0,0,0,26,6,3,0,15,1,0,0,0,0,0,1,0,0,0,0,0,0,0,34,8250,0,"","teleport4",0,60,15);
         this.itemsDB_local[146] = new Array(146,"Charge Mark 4",1,81301,"charge","charge",13,0,0,0,0,0,0,0,0,27,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,26,10,8250,0,"","charge3",0,60,10);
         this.itemsDB_local[147] = new Array(147,"Charge Mark 3",1,81101,"charge","charge",11,0,0,0,0,0,0,0,0,24,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,22,10,6950,0,"","charge4",0,45,9);
         this.itemsDB_local[201] = new Array(201,"Golden Eye",5,11405,"torso","torso",14,258,0,60,15,50,13,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,68250,28,"","torso14",2,70,224,0,0,0,0,3,1,2,0,3);
         this.itemsDB_local[216] = new Array(216,"Cobra",2,11402,"torso","torso",14,228,0,55,14,55,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,45500,0,"","torso17",0,70,213,0,0,0,0,1,2,3,0,2);
         this.itemsDB_local[217] = new Array(217,"Cyclops",3,11403,"torso","torso",14,210,0,70,15,50,12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,68250,0,"","torso18",1,70,209,0,0,0,0,2,3,1,0,2);
         this.itemsDB_local[218] = new Array(218,"RPG",2,41502,"topWeapon","explosive",15,0,0,0,0,0,0,0,15,50,12,2,15,0,2,3,0,0,0,3,3,0,0,0,0,0,0,12,0,15550,0,"rocketBarrage2","rocketLauncher7",1,75,33);
         this.itemsDB_local[221] = new Array(221,"Strong Shot",1,41301,"topWeapon","explosive",13,0,0,0,0,0,0,0,10,33,3,2,10,0,0,0,0,0,0,4,4,0,0,0,0,0,0,14,0,9500,0,"artilleryBarrage1","rocketLauncher8B",0,65,25);
         this.itemsDB_local[222] = new Array(222,"Rocky Balboa",2,41202,"topWeapon","explosive",12,0,0,0,0,0,0,0,10,38,0,2,11,0,0,2,0,0,0,3,3,0,0,0,0,0,0,13,0,13500,0,"rocketBarrage1","rocketLauncher6",1,60,33);
         this.itemsDB_local[225] = new Array(225,"WiN Gun",4,31104,"sideWeapon","physical",11,0,0,0,0,0,0,10,0,45,15,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,5,0,12750,22,"machineGun2","machineGun4C",2,55,27);
         this.itemsDB_local[227] = new Array(227,"Le Double Gun",3,31203,"sideWeapon","electric",12,0,0,0,0,0,0,0,0,26,6,3,0,9,0,1,0,0,0,1,3,0,0,0,0,0,0,0,11,9000,0,"laser1","laser24B",0,60,31);
         this.itemsDB_local[229] = new Array(229,"Le Gun",1,31101,"sideWeapon","electric",11,0,0,0,0,0,0,0,0,25,6,3,0,9,0,1,0,0,0,1,3,0,0,0,0,0,0,0,12,8500,0,"laser1","laser24A",0,55,29);
         this.itemsDB_local[230] = new Array(230,"Yellower",5,31205,"sideWeapon","physical",12,0,0,0,0,0,0,0,0,45,10,1,0,0,2,1,0,0,0,2,2,0,0,0,0,0,0,13,0,13500,24,"beamYellow1","laser21A",2,60,16);
         this.itemsDB_local[231] = new Array(231,"Hot Shot",5,31105,"sideWeapon","explosive",11,0,0,0,0,0,0,0,0,30,0,2,30,0,1,1,0,0,0,1,3,0,0,0,0,0,0,8,0,12750,99,"heatCharge1","laser22B",3,55,27);
         this.itemsDB_local[232] = new Array(232,"Le Tre Gun",1,31401,"sideWeapon","electric",14,0,0,0,0,0,0,0,0,29,5,3,0,9,0,1,0,0,0,1,3,0,0,0,0,0,0,0,11,9950,0,"laser1","laser24C",0,70,34);
         this.itemsDB_local[233] = new Array(233,"Yelloworm",5,31405,"sideWeapon","physical",14,0,0,0,0,0,0,0,0,50,0,1,0,0,2,1,0,0,0,1,3,0,0,0,0,0,0,8,0,14950,28,"beamYellow1","laser21B",2,70,22);
         this.itemsDB_local[234] = new Array(234,"BadBoy Blue",1,41601,"topWeapon","electric",16,0,0,0,0,0,0,0,0,30,6,3,0,12,0,0,0,0,0,3,3,0,0,0,0,0,0,0,11,10700,0,"laser1","laser25B",0,80,29);
         this.itemsDB_local[235] = new Array(235,"Blaster Blue",1,41401,"topWeapon","electric",14,0,0,0,0,0,0,0,0,29,5,3,0,10,0,1,0,0,0,3,3,0,0,0,0,0,0,0,11,9950,0,"laserCharge1","laser25A",0,70,29);
         this.itemsDB_local[236] = new Array(236,"Blaster Red",1,41402,"topWeapon","explosive",14,0,0,0,0,0,0,0,0,27,5,2,10,0,0,1,0,0,0,3,3,0,0,0,0,0,0,11,0,9950,0,"heatCharge1","laser26A",0,70,28);
         this.itemsDB_local[237] = new Array(237,"BadBoy Red",1,41701,"topWeapon","explosive",17,0,0,0,0,0,0,0,0,32,0,2,12,0,0,0,0,0,0,3,3,0,0,0,0,0,0,11,0,11050,0,"heat1","laser26B",0,85,29);
         this.itemsDB_local[238] = new Array(238,"Deep Drain",2,31602,"sideWeapon","electric",16,0,0,0,0,0,0,0,0,29,7,3,0,40,2,0,0,0,0,1,3,0,0,0,0,0,0,0,10,10700,0,"laserCharge1","laser23B",0,80,43);
         this.itemsDB_local[253] = new Array(253,"Energy & Heat Module 3",2,111104,"module","energyHeat",11,0,0,12,6,12,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8550,0,"","module_energyHeat3",1,22,33);
         this.itemsDB_local[254] = new Array(254,"Energy & Heat Module 4",3,111204,"module","energyHeat",12,0,0,12,6,12,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9000,0,"","module_energyHeat4",1,24,33);
         this.itemsDB_local[256] = new Array(256,"Raptor",6,11406,"torso","torso",14,252,0,45,12,65,17,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,68250,28,"","torso20",2,70,223,0,0,0,0,2,2,1,0,4);
         this.itemsDB_local[260] = new Array(260,"Hot Wheels",4,11454,"leg","leg",14,14,0,0,0,0,0,0,0,40,0,2,12,0,0,1,0,0,0,0,1,2,0,0,0,0,0,0,0,19350,28,"stomp2","wheels5A",2,70,33);
         this.itemsDB_local[261] = new Array(261,"Electro Wheels",3,11453,"leg","leg",14,14,0,0,0,0,0,0,0,40,0,3,0,12,0,1,0,0,0,0,1,2,0,0,0,0,0,0,0,19350,28,"stomp3","wheels5B",2,70,34);
         this.itemsDB_local[262] = new Array(262,"Gecko",1,11401,"torso","torso",14,246,0,50,12,55,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,45500,0,"","torso19",0,70,214,0,0,0,0,3,0,3,0,3);
         this.itemsDB_local[263] = new Array(263,"Machine Gun",5,31305,"sideWeapon","physical",13,0,0,0,0,0,0,10,0,40,5,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,14250,117,"bullet3","laser27A",3,65,24);
         this.itemsDB_local[264] = new Array(264,"Double Machine Gun",5,31605,"sideWeapon","physical",16,0,0,0,0,0,0,10,0,43,10,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,1,0,16050,32,"bullet3","laser27B",2,80,28);
         this.itemsDB_local[265] = new Array(265,"Snow white",1,31301,"sideWeapon","electric",13,0,0,0,0,0,0,0,0,27,6,3,0,10,0,0,0,0,0,2,2,0,0,0,0,0,0,0,10,9500,0,"laser1","laser23A",0,65,25);
         this.itemsDB_local[266] = new Array(266,"Red Rain",1,51101,"drone","drone",11,0,0,0,0,0,0,0,0,19,0,2,11,0,0,0,0,0,0,0,999,0,0,0,0,0,0,9,5,11800,0,"heat1","drone8",1,55,21);
         this.itemsDB_local[267] = new Array(267,"Blueberry",1,51201,"drone","drone",12,0,0,0,0,0,0,0,0,19,12,3,0,10,0,0,0,0,0,0,999,0,0,0,0,0,0,0,20,12400,108,"laser1","drone9",3,60,21);
         this.itemsDB_local[268] = new Array(268,"Yellow Snow",1,51301,"drone","drone",13,0,0,0,0,0,0,0,0,19,0,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,11,5,8650,0,"bullet2","drone10",0,65,13);
         this.itemsDB_local[270] = new Array(270,"Regeneration & Cooldown Module 4",4,111804,"module","energyHeat",18,0,0,0,18,0,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11400,36,"","module_mixed3",2,36,42);
         this.itemsDB_local[272] = new Array(272,"Regeneration & Cooldown Module 3",4,111404,"module","energyHeat",14,0,0,0,16,0,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000,28,"","module_mixed2",2,28,37);
         this.itemsDB_local[273] = new Array(273,"Bullet & Rocket Storage 6",6,111706,"module","ammo",17,0,0,0,0,0,0,10,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11100,0,"","module_bulletsRockets_1_4",1,34,40);
         this.itemsDB_local[274] = new Array(274,"Bullet & Rocket Storage 5",5,111305,"module","ammo",13,0,0,0,0,0,0,30,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9550,0,"","module_bulletsRockets_3_1",1,26,32);
         this.itemsDB_local[275] = new Array(275,"Bullet & Rocket Storage 8",8,112108,"module","ammo",21,0,0,0,0,0,0,20,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12250,0,"","module_bulletsRockets_2_3",1,42,40);
         this.itemsDB_local[276] = new Array(276,"Bullet & Rocket Storage 7",7,112107,"module","ammo",21,0,0,0,0,0,0,30,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12250,0,"","module_bulletsRockets_3_2",1,42,40);
         this.itemsDB_local[277] = new Array(277,"Bullet & Rocket Storage 9",9,112409,"module","ammo",24,0,0,0,0,0,0,30,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13000,0,"","module_bulletsRockets_3_3",1,48,48);
         this.itemsDB_local[279] = new Array(279,"Armor Plating 6",2,111702,"module","armor",17,48,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7400,0,"","module_HP6",0,34,20);
         this.itemsDB_local[280] = new Array(280,"Armor Plating 7",2,112002,"module","armor",20,54,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8000,0,"","module_HP7",0,40,22);
         this.itemsDB_local[281] = new Array(281,"Armor Plating 8",2,112302,"module","armor",23,60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8500,0,"","module_HP8",0,46,24);
         this.itemsDB_local[284] = new Array(284,"Energy & Heat Module 5",3,111403,"module","energyHeat",14,0,0,13,6,13,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000,0,"","module_energyHeat5",1,28,35);
         this.itemsDB_local[285] = new Array(285,"Energy & Heat Module 6",2,111602,"module","energyHeat",16,0,0,14,7,14,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10750,0,"","module_energyHeat5",1,32,39);
         this.itemsDB_local[286] = new Array(286,"Energy & Heat Module 7",3,111803,"module","energyHeat",18,0,0,15,7,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11400,0,"","module_energyHeat6",1,36,40);
         this.itemsDB_local[287] = new Array(287,"Energy & Heat Module 8",4,112004,"module","energyHeat",20,0,0,16,8,16,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12000,0,"","module_energyHeat6",1,40,44);
         this.itemsDB_local[288] = new Array(288,"Energy & Heat Module 9",1,112201,"module","energyHeat",22,0,0,17,8,17,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12550,0,"","module_energyHeat7",1,44,46);
         this.itemsDB_local[290] = new Array(290,"Energy Module 6",1,111201,"module","energyHeat",12,0,0,17,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6000,0,"","module_energy6",0,24,24);
         this.itemsDB_local[291] = new Array(291,"Energy Module 7",1,111601,"module","energyHeat",16,0,0,20,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7150,0,"","module_energy7",0,32,28);
         this.itemsDB_local[295] = new Array(295,"Bullet Storage 5",2,111405,"module","ammo",14,0,0,0,0,0,0,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6650,0,"","module_bullets5",0,28,28);
         this.itemsDB_local[296] = new Array(296,"Bullet Storage 6",3,111703,"module","ammo",17,0,0,0,0,0,0,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7400,0,"","module_bullets6",0,34,32);
         this.itemsDB_local[297] = new Array(297,"Bullet Storage 7",3,112003,"module","ammo",20,0,0,0,0,0,0,45,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8000,0,"","module_bullets7",0,40,36);
         this.itemsDB_local[298] = new Array(298,"Bullet Storage 8",1,112301,"module","ammo",23,0,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8500,0,"","module_bullets8",0,46,40);
         this.itemsDB_local[301] = new Array(301,"Energy module 8",2,112005,"module","energyHeat",20,0,0,22,11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8000,0,"","module_energy8",0,40,31);
         this.itemsDB_local[302] = new Array(302,"Energy module 9",2,112402,"module","energyHeat",24,0,0,25,12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8650,0,"","module_energy9",0,48,35);
         this.itemsDB_local[305] = new Array(305,"Heat Module 7",2,111202,"module","energyHeat",12,0,0,0,0,24,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6000,0,"","module_heat7",0,24,30);
         this.itemsDB_local[306] = new Array(306,"Heat Module 8",2,111502,"module","energyHeat",15,0,0,0,0,26,11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6900,0,"","module_heat8",0,30,34);
         this.itemsDB_local[307] = new Array(307,"Heat Module 9",1,111801,"module","energyHeat",18,0,0,0,0,28,13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7600,0,"","module_heat9",0,36,38);
         this.itemsDB_local[308] = new Array(308,"Heat Module 10",2,112102,"module","energyHeat",21,0,0,0,0,30,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8150,0,"","module_heat10",0,42,42);
         this.itemsDB_local[309] = new Array(309,"Rocket Storage 5",3,111503,"module","ammo",15,0,0,0,0,0,0,0,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6900,0,"","module_rockets5",0,30,28);
         this.itemsDB_local[310] = new Array(310,"Rocket Storage 6",2,111802,"module","ammo",18,0,0,0,0,0,0,0,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7600,0,"","module_rockets6",0,36,32);
         this.itemsDB_local[311] = new Array(311,"Rocket Storage 7",2,112103,"module","ammo",21,0,0,0,0,0,0,0,45,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8150,0,"","module_rockets7",0,42,36);
         this.itemsDB_local[312] = new Array(312,"Rocket Storage 8",2,112403,"module","ammo",24,0,0,0,0,0,0,0,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8650,0,"","module_rockets8",0,48,40);
         this.itemsDB_local[316] = new Array(316,"Grasshopper",1,11451,"leg","leg",14,0,0,0,0,0,0,0,0,38,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,12900,0,"stomp1","leg10",0,70,23);
         this.itemsDB_local[318] = new Array(318,"High Deff",1,11851,"leg","leg",18,0,0,0,0,0,0,0,0,44,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,15100,0,"stomp1","leg9",0,90,22);
         this.itemsDB_local[319] = new Array(319,"Walkmans",3,11853,"leg","leg",18,18,0,0,0,0,0,0,0,47,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,22650,0,"stomp1","leg11",1,90,37);
         this.itemsDB_local[320] = new Array(320,"Metal Head",1,11801,"torso","torso",18,300,0,60,15,60,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,53300,0,"","torso25",0,90,252,0,0,0,0,3,3,0,0,3);
         this.itemsDB_local[321] = new Array(321,"Roman",8,11808,"torso","torso",18,294,0,80,18,60,15,10,10,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,79950,162,"","torso24",3,90,273,0,0,0,0,3,2,2,0,4);
         this.itemsDB_local[322] = new Array(322,"Twin Turbine",2,11802,"torso","torso",18,264,0,65,17,65,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,53300,0,"","torso21",0,90,251,0,0,0,0,2,3,1,0,4);
         this.itemsDB_local[323] = new Array(323,"Engine",4,11804,"torso","torso",18,276,0,60,16,75,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,79950,0,"","torso22",1,90,256,0,0,0,0,2,1,2,0,2);
         this.itemsDB_local[324] = new Array(324,"Charge Mark 5",1,81501,"charge","charge",15,0,0,0,0,0,0,0,0,30,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,30,10,9300,0,"","charge3",0,75,11);
         this.itemsDB_local[325] = new Array(325,"Charge Mark 6",1,81801,"charge","charge",18,0,0,0,0,0,0,0,0,33,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,34,10,10100,0,"","charge5",0,90,13);
         this.itemsDB_local[326] = new Array(326,"Charge Mark 7",1,82101,"charge","charge",21,0,0,0,0,0,0,0,0,36,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,38,10,10750,0,"","charge5",0,105,14);
         this.itemsDB_local[327] = new Array(327,"Teleport Mark 5",1,71501,"teleport","teleport",15,0,0,0,0,0,0,0,0,28,8,3,0,17,1,0,0,0,0,0,1,0,0,0,0,0,0,0,38,9300,0,"","teleport4",0,75,17);
         this.itemsDB_local[328] = new Array(328,"Teleport Mark 6",1,71801,"teleport","teleport",18,0,0,0,0,0,0,0,0,31,8,3,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,46,10100,0,"","teleport4",0,90,20);
         this.itemsDB_local[329] = new Array(329,"Teleport Mark 7",1,72101,"teleport","teleport",21,0,0,0,0,0,0,0,0,34,10,3,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0,48,10750,0,"","teleport5",0,105,23);
         this.itemsDB_local[330] = new Array(330,"The Dragon",1,31102,"sideWeapon","explosive",11,0,0,0,0,0,0,0,0,29,0,2,17,0,3,0,0,0,0,0,1,0,0,0,0,0,0,5,0,8500,0,"flame1","flameThrower3",0,55,22);
         this.itemsDB_local[331] = new Array(331,"Zippy",1,31501,"sideWeapon","electric",15,0,0,0,0,0,0,0,0,28,8,3,0,11,0,1,0,0,0,1,3,0,0,0,0,0,0,0,12,10350,0,"laser1","laser28A",0,75,36);
         this.itemsDB_local[332] = new Array(332,"XR12",1,41702,"topWeapon","physical",17,0,0,0,0,0,0,0,0,28,2,1,0,0,0,1,0,0,0,4,2,0,0,0,0,0,0,8,0,11050,0,"bulletCharge1","laser29A",0,85,21);
         this.itemsDB_local[333] = new Array(333,"Rapid Fire Rocket Launcher",1,41901,"topWeapon","explosive",19,0,0,0,0,0,0,0,10,45,0,2,13,0,0,1,0,0,0,3,3,0,0,0,0,0,0,18,0,11700,0,"rocketBarrage1","rocketLauncher9A",0,95,37);
         this.itemsDB_local[335] = new Array(335,"XR14",1,42001,"topWeapon","physical",20,0,0,0,0,0,0,0,0,36,0,1,0,0,0,1,0,0,0,4,2,0,0,0,0,0,0,9,0,12000,0,"bullet2","laser29B",0,100,25);
         this.itemsDB_local[336] = new Array(336,"Zappy",1,31701,"sideWeapon","electric",17,0,0,0,0,0,0,0,0,31,6,3,0,12,0,1,0,0,0,1,3,0,0,0,0,0,0,0,12,11050,0,"laser1","laser28B",0,85,40);
         this.itemsDB_local[337] = new Array(337,"Quadroople Machine Gun",5,31905,"sideWeapon","physical",19,0,0,0,0,0,0,10,0,55,10,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,2,0,17550,171,"bullet3","laser27C",3,95,32);
         this.itemsDB_local[338] = new Array(338,"Fortress Floors",2,12252,"leg","leg",22,0,0,0,0,0,0,0,0,51,0,1,0,0,0,2,0,0,0,0,1,2,0,0,0,0,0,0,0,16800,0,"stomp1","wheels6",0,110,37);
         this.itemsDB_local[339] = new Array(339,"Flaming Snake",1,31402,"sideWeapon","explosive",14,0,0,0,0,0,0,0,0,15,20,2,25,0,3,0,0,0,0,0,1,0,0,0,0,0,0,5,0,9950,0,"flame1","flameThrower4",0,70,27);
         this.itemsDB_local[340] = new Array(340,"Blazer",1,31702,"sideWeapon","explosive",17,0,0,0,0,0,0,0,0,37,0,2,28,0,3,0,0,0,0,0,1,0,0,0,0,0,0,6,0,11050,0,"flame1","flameThrower5A",0,85,33);
         this.itemsDB_local[345] = new Array(345,"Physical Resistance Module 3",1,111101,"module","resistance",11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,5700,0,"","module_resistancePhysical3",0,22,9);
         this.itemsDB_local[346] = new Array(346,"Physical Resistance Module 4",1,111301,"module","resistance",13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,6350,0,"","module_resistancePhysical4",0,26,13);
         this.itemsDB_local[347] = new Array(347,"Physical Resistance Module 5",1,111501,"module","resistance",15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,0,0,0,0,0,0,6900,0,"","module_resistancePhysical5",0,30,17);
         this.itemsDB_local[351] = new Array(351,"Explosive Resistance Module 3",1,111105,"module","resistance",11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,5700,0,"","module_resistanceExplosive3",0,22,9);
         this.itemsDB_local[352] = new Array(352,"Explosive Resistance Module 4",1,111302,"module","resistance",13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,6350,0,"","module_resistanceExplosive4",0,26,13);
         this.itemsDB_local[353] = new Array(353,"Explosive Resistance Module 5",1,111504,"module","resistance",15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,0,0,0,0,0,6900,0,"","module_resistanceExplosive5",0,30,17);
         this.itemsDB_local[355] = new Array(355,"Electric Resistance Module 3",1,111106,"module","resistance",11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,5700,0,"","module_resistanceElectric3",0,22,9);
         this.itemsDB_local[356] = new Array(356,"Electric Resistance Module 4",1,111303,"module","resistance",13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,6350,0,"","module_resistanceElectric4",0,26,13);
         this.itemsDB_local[357] = new Array(357,"Electric Resistance Module 5",1,111505,"module","resistance",15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,0,0,0,0,6900,0,"","module_resistanceElectric5",0,30,17);
         this.itemsDB_local[359] = new Array(359,"Explosive Resistance Module 9",1,112303,"module","resistance",23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14,0,0,0,0,0,0,0,0,0,0,0,8500,0,"","module_resistanceExplosive9",0,46,26);
         this.itemsDB_local[360] = new Array(360,"Explosive Resistance Module 8",1,112101,"module","resistance",21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13,0,0,0,0,0,0,0,0,0,0,0,8150,0,"","module_resistanceExplosive8",0,42,24);
         this.itemsDB_local[361] = new Array(361,"Explosive Resistance Module 7",1,111901,"module","resistance",19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,7800,0,"","module_resistanceExplosive7",0,38,22);
         this.itemsDB_local[362] = new Array(362,"Explosive Resistance Module 6",1,111701,"module","resistance",17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,0,0,0,0,0,0,0,0,0,0,0,7400,0,"","module_resistanceExplosive6",0,34,20);
         this.itemsDB_local[363] = new Array(363,"Physical Resistance Module 6",1,111704,"module","resistance",17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,0,0,0,0,0,0,0,0,0,0,0,0,7400,0,"","module_resistancePhysical6",0,34,20);
         this.itemsDB_local[364] = new Array(364,"Physical Resistance Module 7",1,111902,"module","resistance",19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,0,7800,0,"","module_resistancePhysical7",0,38,22);
         this.itemsDB_local[365] = new Array(365,"Physical Resistance Module 8",1,112104,"module","resistance",21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13,0,0,0,0,0,0,0,0,0,0,0,0,8150,0,"","module_resistancePhysical8",0,42,24);
         this.itemsDB_local[366] = new Array(366,"Physical Resistance Module 9",1,112304,"module","resistance",23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14,0,0,0,0,0,0,0,0,0,0,0,0,8500,0,"","module_resistancePhysical9",0,46,26);
         this.itemsDB_local[368] = new Array(368,"Electric Resistance Module 6",1,111705,"module","resistance",17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,0,0,0,0,0,0,0,0,0,0,7400,0,"","module_resistanceElectric6",0,34,20);
         this.itemsDB_local[369] = new Array(369,"Electric Resistance Module 7",1,111903,"module","resistance",19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,7800,0,"","module_resistanceElectric7",0,38,22);
         this.itemsDB_local[370] = new Array(370,"Electric Resistance Module 8",1,112105,"module","resistance",21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13,0,0,0,0,0,0,0,0,0,0,8150,0,"","module_resistanceElectric8",0,42,24);
         this.itemsDB_local[371] = new Array(371,"Electric Resistance Module 9",1,112305,"module","resistance",23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14,0,0,0,0,0,0,0,0,0,0,8500,0,"","module_resistanceElectric9",0,46,26);
         this.itemsDB_local[373] = new Array(373,"Goliath",5,11805,"torso","torso",18,282,0,85,20,50,12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,79950,0,"","torso28",1,90,255,0,0,0,0,1,3,2,0,3);
         this.itemsDB_local[374] = new Array(374,"The Light",3,11803,"torso","torso",18,240,0,80,20,60,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,53300,0,"","torso27",0,90,249,0,0,0,0,6,0,0,0,4);
         this.itemsDB_local[375] = new Array(375,"Electron Power",3,12203,"torso","torso",22,306,0,100,25,55,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,88800,0,"","torso29A",1,110,290,0,0,0,0,0,0,6,0,4);
         this.itemsDB_local[376] = new Array(376,"Flame Power",4,12204,"torso","torso",22,306,0,55,16,100,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,88800,0,"","torso29B",1,110,290,0,0,0,0,0,6,0,0,3);
         this.itemsDB_local[379] = new Array(379,"Dragon",4,11404,"torso","torso",14,216,0,50,10,70,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,68250,0,"","torso26",1,70,209,0,0,0,0,1,4,1,0,3);
         this.itemsDB_local[381] = new Array(381,"Sextuplet Rockets",4,31804,"sideWeapon","explosive",18,0,0,0,0,0,0,0,10,46,15,2,14,0,0,1,0,0,0,2,3,0,0,0,0,0,0,15,0,17100,0,"rocketBarrage1","rocketLauncher10C",1,90,43);
         this.itemsDB_local[382] = new Array(382,"Blue Rein",1,31901,"sideWeapon","electric",19,0,0,0,0,0,0,0,0,34,6,3,0,13,0,1,0,0,0,1,3,0,0,0,0,0,0,0,12,11700,0,"beamBlue1","laser32A",0,95,44);
         this.itemsDB_local[383] = new Array(383,"Termination Heat",1,32101,"sideWeapon","explosive",21,0,0,0,0,0,0,0,0,32,9,2,14,0,0,1,0,0,0,1,3,0,0,0,0,0,0,12,0,12250,0,"beamRed2","laser30B",0,105,46);
         this.itemsDB_local[384] = new Array(384,"Push",1,32001,"sideWeapon","physical",20,0,0,0,0,0,0,0,0,20,0,1,0,0,2,4,0,0,0,0,3,0,0,0,0,0,0,5,5,12000,0,"beamRoundYellow1","laser34A",0,100,24);
         this.itemsDB_local[385] = new Array(385,"Twin Rockets",3,31403,"sideWeapon","explosive",14,0,0,0,0,0,0,0,10,33,5,2,10,0,0,1,0,0,0,2,3,0,0,0,0,0,0,10,0,9950,0,"rocketBarrage1","rocketLauncher10A",0,70,31);
         this.itemsDB_local[386] = new Array(386,"Quadruplet Rockets",4,31604,"sideWeapon","explosive",16,0,0,0,0,0,0,0,10,45,0,2,13,0,0,1,0,0,0,2,3,0,0,0,0,0,0,14,0,16050,0,"rocketBarrage1","rocketLauncher10B",1,80,37);
         this.itemsDB_local[387] = new Array(387,"Zoppy",1,32002,"sideWeapon","electric",20,0,0,0,0,0,0,0,0,34,8,3,0,13,0,1,0,0,0,1,3,0,0,0,0,0,0,0,11,12000,0,"laser1","laser28C",0,100,45);
         this.itemsDB_local[388] = new Array(388,"Fiery Bites",5,32005,"sideWeapon","explosive",20,0,0,0,0,0,0,0,0,36,13,2,28,0,3,0,0,0,0,0,1,0,0,0,0,0,0,7,0,18000,40,"flame1","flameThrower5B",2,100,33);
         this.itemsDB_local[389] = new Array(389,"Red Rein",1,31902,"sideWeapon","explosive",19,0,0,0,0,0,0,0,0,34,0,2,13,0,0,1,0,0,0,1,3,0,0,0,0,0,0,12,0,11700,0,"beamRed1","laser30A",0,95,42);
         this.itemsDB_local[390] = new Array(390,"Termination Electro",1,32102,"sideWeapon","electric",21,0,0,0,0,0,0,0,0,36,6,3,0,14,0,1,0,0,0,1,3,0,0,0,0,0,0,0,12,12250,0,"beamBlue2","laser32B",0,105,47);
         this.itemsDB_local[391] = new Array(391,"Pitchfork",1,32201,"sideWeapon","electric",22,0,0,0,0,0,0,0,0,38,6,3,0,14,2,0,0,0,0,1,3,0,0,0,0,0,0,0,10,12500,0,"laserCharge1","laser33A",0,110,28);
         this.itemsDB_local[392] = new Array(392,"Triton",1,32301,"sideWeapon","electric",23,0,0,0,0,0,0,0,0,44,10,3,0,15,2,0,0,0,0,1,3,0,0,0,0,0,0,0,11,12700,0,"laserCharge1","laser33B",0,115,32);
         this.itemsDB_local[393] = new Array(393,"Pitchfork of Doom ",1,32401,"sideWeapon","electric",24,0,0,0,0,0,0,0,0,55,10,3,0,15,2,0,0,0,0,1,3,0,0,0,0,0,0,0,12,12950,0,"laserCharge1","laser33C",0,120,36);
         this.itemsDB_local[394] = new Array(394,"Blow Back",3,32303,"sideWeapon","physical",23,0,0,0,0,0,0,0,0,25,0,1,0,0,2,5,0,0,0,0,3,0,0,0,0,0,0,7,7,12700,0,"bulletCharge1","laser34B",0,115,32);
         this.itemsDB_local[395] = new Array(395,"Heat Overflow",3,32203,"sideWeapon","explosive",22,0,0,0,0,0,0,0,0,22,0,2,40,0,3,1,0,0,0,2,4,0,0,0,0,0,0,10,0,18750,0,"beamRoundRed1","laser35",1,110,65);
         this.itemsDB_local[396] = new Array(396,"Twin Termination R",2,32302,"sideWeapon","explosive",23,0,0,0,0,0,0,0,0,38,0,2,15,0,0,1,0,0,0,1,3,0,0,0,0,0,0,12,0,12700,0,"beamRed2","laser30C",0,115,49);
         this.itemsDB_local[397] = new Array(397,"Twin Termination B",3,32403,"sideWeapon","electric",24,0,0,0,0,0,0,0,0,38,12,3,0,20,0,1,0,0,0,1,3,0,0,0,0,0,0,0,14,19450,0,"beamBlue2","laser32C",1,120,56);
         this.itemsDB_local[398] = new Array(398,"Blue Blaster",2,42202,"topWeapon","electric",22,0,0,0,0,0,0,0,0,38,11,3,0,15,0,0,0,0,0,3,3,0,0,0,0,0,0,0,17,18750,0,"laser1","laser36B",1,110,35);
         this.itemsDB_local[399] = new Array(399,"M6000",1,42401,"topWeapon","explosive",24,0,0,0,0,0,0,0,15,52,18,2,15,0,0,1,0,0,0,3,3,0,0,0,0,0,0,10,0,12950,0,"rocketBarrage1","rocketLauncher11A",0,120,53);
         this.itemsDB_local[401] = new Array(401,"XR18",1,42301,"topWeapon","physical",23,0,0,0,0,0,0,0,0,40,0,1,0,0,0,1,0,0,0,4,2,0,0,0,0,0,0,9,0,12700,0,"bullet2","laser29C",0,115,29);
         this.itemsDB_local[406] = new Array(406,"Big Blue Blast",4,32004,"sideWeapon","electric",20,0,0,0,0,0,0,0,0,37,10,3,0,5,0,2,0,0,0,1,3,0,0,0,0,0,0,0,17,18000,0,"beamBlue1","laser36A",1,100,40);
         this.itemsDB_local[407] = new Array(407,"Physical Blast",1,41201,"topWeapon","physical",12,0,0,0,0,0,0,0,0,25,2,1,0,0,0,1,0,0,0,4,2,0,0,0,0,0,0,8,0,9000,0,"beamRoundYellow1","laser31A",0,60,17);
         this.itemsDB_local[408] = new Array(408,"Blaster",2,41602,"topWeapon","physical",16,0,0,0,0,0,0,0,0,40,10,1,0,0,0,1,0,0,0,4,2,0,0,0,0,0,0,12,0,16050,0,"beamRoundYellow1","laser31C",1,80,26);
         this.itemsDB_local[409] = new Array(409,"Hard Hitter",2,41302,"topWeapon","physical",13,0,0,0,0,0,0,0,0,32,5,1,0,0,0,1,0,0,0,4,2,0,0,0,0,0,0,10,0,14250,0,"beamRoundYellow1","laser31B",1,65,20);
         this.itemsDB_local[412] = new Array(412,"Burning Harpoon Mark 2",1,91501,"harpoon","harpoon",15,0,0,0,0,0,0,0,0,30,0,2,15,0,1,0,0,0,0,1,5,0,0,0,0,0,0,17,30,9300,0,"","harpoon2",0,75,20);
         this.itemsDB_local[413] = new Array(413,"Electric Harpoon Mark 1",1,91801,"harpoon","harpoon",18,0,0,0,0,0,0,0,0,33,6,3,0,20,1,0,0,0,0,1,4,0,0,0,0,0,0,0,38,10100,0,"","harpoon4",0,90,23);
         this.itemsDB_local[421] = new Array(421,"Adv. Repair Kit 3",2,121402,"kit","repair",14,78,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1200,0,"","kit_HP10",1,7,0);
         this.itemsDB_local[422] = new Array(422,"Adv. Repair Kit 4",1,121802,"kit","repair",18,90,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1350,0,"","kit_HP11",1,9,0);
         this.itemsDB_local[423] = new Array(423,"Adv. Repair Kit 5",1,122202,"kit","repair",22,102,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,0,"","kit_HP12",1,11,0);
         this.itemsDB_local[426] = new Array(426,"Rockets Kit 7",1,121502,"kit","ammo",15,0,0,0,0,0,0,0,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,800,0,"","kit_rockets7",0,8,0);
         this.itemsDB_local[428] = new Array(428,"Rockets Kit 6",1,121302,"kit","ammo",13,0,0,0,0,0,0,0,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,750,0,"","kit_rockets6",0,7,0);
         this.itemsDB_local[429] = new Array(429,"Bullets Kit 5",1,121902,"kit","ammo",19,0,0,0,0,0,0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,900,0,"","kit_bullets5",0,10,0);
         this.itemsDB_local[430] = new Array(430,"Bullets Kit 6",1,122302,"kit","ammo",23,0,0,0,0,0,0,35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,950,0,"","kit_bullets6",0,12,0);
         this.itemsDB_local[432] = new Array(432,"Adv. Cooling Kit 4",2,121503,"kit","energyHeat",15,0,0,0,0,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1200,0,"","kit_heat11",1,8,0);
         this.itemsDB_local[433] = new Array(433,"Adv. Cooling Kit 5",3,121903,"kit","energyHeat",19,0,0,0,0,75,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1350,0,"","kit_heat12",1,10,0);
         this.itemsDB_local[434] = new Array(434,"Adv. Cooling Kit 6",3,122303,"kit","energyHeat",23,0,0,0,0,90,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,0,"","kit_heat13",1,12,0);
         this.itemsDB_local[438] = new Array(438,"Adv. Cooling Kit 3",3,121103,"kit","energyHeat",11,0,0,0,0,55,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1050,0,"","kit_heat10",1,6,0);
         this.itemsDB_local[441] = new Array(441,"Adv. Energy Kit 3",2,121202,"kit","energyHeat",12,0,0,55,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1150,0,"","kit_energy10",1,6,0);
         this.itemsDB_local[442] = new Array(442,"Adv. Energy Kit 4",3,121603,"kit","energyHeat",16,0,0,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1300,0,"","kit_energy11",1,8,0);
         this.itemsDB_local[443] = new Array(443,"Adv. Energy Kit 5",2,122002,"kit","energyHeat",20,0,0,80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1350,0,"","kit_energy12",1,10,0);
         this.itemsDB_local[444] = new Array(444,"Adv. Energy Kit 6",2,122402,"kit","energyHeat",24,0,0,90,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,0,"","kit_energy13",1,12,0);
         this.itemsDB_local[446] = new Array(446,"Beetle",1,12201,"torso","torso",22,294,0,70,18,90,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,59200,0,"","torso10B",0,110,294,0,0,0,0,3,1,2,0,4);
         this.itemsDB_local[448] = new Array(448,"Blood Diamond",6,11806,"torso","torso",18,252,0,65,17,80,20,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,79950,36,"","torso14B",2,90,259,0,0,0,0,1,4,2,0,4);
         this.itemsDB_local[449] = new Array(449,"Barracu",2,12202,"torso","torso",22,294,0,80,20,80,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,59200,0,"","torso8B",0,110,294,0,0,0,0,3,1,3,0,3);
         this.itemsDB_local[450] = new Array(450,"Ember",7,11807,"torso","torso",18,288,0,65,17,70,18,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,79950,36,"","torso7B",2,90,263,0,0,0,0,1,4,1,0,3);
         this.itemsDB_local[463] = new Array(463,"Sure shot",5,32405,"sideWeapon","physical",24,0,0,0,0,0,0,15,0,65,23,1,0,0,0,0,0,0,0,1,3,0,0,0,0,0,0,0,0,19450,216,"bullet3","laser39B",3,120,49);
         this.itemsDB_local[464] = new Array(464,"Moepifier",2,32402,"sideWeapon","explosive",24,0,0,0,0,0,0,0,0,39,0,2,15,0,0,0,0,0,0,1,3,0,0,0,0,0,0,12,0,12950,0,"beamRed1","laser37A",0,120,43);
         this.itemsDB_local[465] = new Array(465,"Burnout",1,32003,"sideWeapon","explosive",20,0,0,0,0,0,0,0,10,38,19,2,13,0,0,1,0,0,0,2,3,0,0,0,0,0,0,11,0,12000,0,"rocketBarrage1","rocketLauncher12",0,100,42);
         this.itemsDB_local[467] = new Array(467,"Launcher",4,32404,"sideWeapon","explosive",24,0,0,0,0,0,0,0,15,56,0,2,19,0,0,1,0,0,0,2,3,0,0,0,0,0,0,10,0,19450,48,"rocketBarrage1","rocketLauncher13",2,120,52);
         this.itemsDB_local[468] = new Array(468,"Bright Blast",5,32305,"sideWeapon","explosive",23,0,0,0,0,0,0,0,0,32,0,2,35,0,2,1,0,0,0,2,2,0,0,0,0,0,0,16,0,19050,46,"beamRoundRed1","laser41A",2,115,34);
         this.itemsDB_local[470] = new Array(470,"Stompers",4,12254,"leg","leg",22,36,0,0,0,0,0,0,0,53,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,25200,44,"stomp1","leg13",2,110,38);
         this.itemsDB_local[473] = new Array(473,"Safe Shot",5,32105,"sideWeapon","physical",21,0,0,0,0,0,0,15,0,60,25,1,0,0,0,0,0,0,0,1,3,0,0,0,0,0,0,0,0,18400,189,"bullet3","laser39A",3,105,46);
         this.itemsDB_local[486] = new Array(486,"Steel Trunks",1,12251,"leg","leg",22,0,0,0,0,0,0,0,0,49,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,16800,0,"stomp1","leg17",0,110,24);
         this.itemsDB_local[494] = new Array(494,"Spray Can",1,51401,"drone","drone",14,0,0,0,0,0,0,0,0,19,0,2,12,0,0,0,0,0,0,0,999,0,0,0,0,0,0,11,5,9000,0,"heatCharge1","drone17",0,70,23);
         this.itemsDB_local[495] = new Array(495,"Flying launcher",1,51501,"drone","drone",15,0,0,0,0,0,0,0,5,20,0,2,9,0,0,0,0,0,0,0,999,0,0,0,0,0,0,12,5,9300,0,"rocketBarrage2","drone15A",0,75,22);
         this.itemsDB_local[496] = new Array(496,"Blue Drone",1,51601,"drone","drone",16,0,0,0,0,0,0,0,0,23,10,3,0,13,0,0,0,0,0,0,999,0,0,0,0,0,0,0,21,14400,32,"laser1","drone12B",2,80,27);
         this.itemsDB_local[497] = new Array(497,"Red Drone",1,51602,"drone","drone",16,0,0,0,0,0,0,0,0,27,0,2,15,0,0,0,0,0,0,0,999,0,0,0,0,0,0,13,5,14400,144,"heat1","drone12A",3,80,27);
         this.itemsDB_local[498] = new Array(498,"Flying Machine Gun",1,51701,"drone","drone",17,0,0,0,0,0,0,10,0,26,0,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,13,5,9850,0,"machineGun2","drone21A",0,85,18);
         this.itemsDB_local[500] = new Array(500,"Parfume",1,51901,"drone","drone",19,0,0,0,0,0,0,0,0,23,0,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,13,5,10300,0,"bullet3","drone13",0,95,17);
         this.itemsDB_local[501] = new Array(501,"Nar Whale",1,51801,"drone","drone",18,0,0,0,0,0,0,0,0,22,0,2,13,0,0,0,0,0,0,0,999,0,0,0,0,0,0,13,5,10100,0,"heat2","drone11",0,90,27);
         this.itemsDB_local[503] = new Array(503,"Flying Blaster",1,52001,"drone","drone",20,0,0,0,0,0,0,0,10,24,0,2,14,0,0,0,0,0,0,0,999,0,0,0,0,0,0,14,5,10550,0,"rocketBarrage2","drone15B",0,100,29);
         this.itemsDB_local[504] = new Array(504,"Flash",1,52101,"drone","drone",21,0,0,0,0,0,0,0,0,23,6,3,0,14,0,0,0,0,0,0,999,0,0,0,0,0,0,0,24,10750,0,"laserCharge1","drone18",0,105,30);
         this.itemsDB_local[505] = new Array(505,"Flying Machine Cannon",1,52201,"drone","drone",22,0,0,0,0,0,0,10,0,25,0,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,15,5,10950,0,"machineGun2","drone21B",0,110,19);
         this.itemsDB_local[506] = new Array(506,"Blue Eye",1,52301,"drone","drone",23,0,0,0,0,0,0,0,0,26,10,3,0,15,0,0,0,0,0,0,999,0,0,0,0,0,0,0,25,16650,0,"laserCharge1","drone19B",1,115,33);
         this.itemsDB_local[507] = new Array(507,"Red Eye",1,52302,"drone","drone",23,0,0,0,0,0,0,0,0,28,0,2,17,0,0,0,0,0,0,0,999,0,0,0,0,0,0,15,5,16650,0,"heat2","drone19A",1,115,34);
         this.itemsDB_local[510] = new Array(510,"Canary",1,52401,"drone","drone",24,0,0,0,0,0,0,0,0,26,0,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,16,5,11250,0,"bullet2","drone20",0,120,20);
         this.itemsDB_local[522] = new Array(522,"Artillery Mark I",2,41802,"topWeapon","explosive",18,0,0,0,0,0,0,0,10,40,5,2,14,0,0,0,0,0,0,4,4,0,0,0,0,0,0,15,0,17100,0,"artilleryBarrage1","rocketLauncher19",1,90,33);
         this.itemsDB_local[526] = new Array(526,"Artillery Mark II",2,42102,"topWeapon","explosive",21,0,0,0,0,0,0,0,15,40,10,2,12,0,0,0,0,0,0,4,4,0,0,0,0,0,0,10,0,12250,0,"artilleryBarrage1","rocketLauncher20A",0,105,36);
         this.itemsDB_local[532] = new Array(532,"Blazing fire",1,42201,"topWeapon","explosive",22,0,0,0,0,0,0,0,15,50,15,2,14,0,0,2,0,0,0,3,3,0,0,0,0,0,0,12,0,12500,0,"rocketBarrage1","rocketLauncher23B",0,110,54);
         this.itemsDB_local[533] = new Array(533,"Rocket Blaster",1,41101,"topWeapon","explosive",11,0,0,0,0,0,0,0,10,34,0,2,9,0,0,2,0,0,0,3,3,0,0,0,0,0,0,12,0,8500,0,"rocketBarrage1","rocketLauncher22B",0,55,30);
         this.itemsDB_local[539] = new Array(539,"Small Yellow Lazer",1,31201,"sideWeapon","physical",12,0,0,0,0,0,0,0,0,27,0,1,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,8,0,9000,0,"beamRoundYellow1","cannon4A",0,60,15);
         this.itemsDB_local[540] = new Array(540,"Blue Lookout",1,31302,"sideWeapon","electric",13,0,0,0,0,0,0,0,0,22,6,3,0,10,0,1,0,0,0,1,3,0,0,0,0,0,0,0,15,9500,0,"beamBlue1","blaster5A",0,65,28);
         this.itemsDB_local[541] = new Array(541,"Red Lookout",1,31303,"sideWeapon","explosive",13,0,0,0,0,0,0,0,0,20,6,2,10,0,0,1,0,0,0,1,3,0,0,0,0,0,0,15,0,9500,0,"beamRed1","blaster4A",0,65,27);
         this.itemsDB_local[542] = new Array(542,"Red Fiering arms",1,31502,"sideWeapon","explosive",15,0,0,0,0,0,0,0,0,30,0,2,11,0,0,0,0,0,0,1,3,0,0,0,0,0,0,11,0,10350,0,"heatCharge1","laser47A",0,75,31);
         this.itemsDB_local[544] = new Array(544,"Rocket Fist",1,31503,"sideWeapon","explosive",15,0,0,0,0,0,0,0,10,35,10,2,10,0,0,1,0,0,0,2,3,0,0,0,0,0,0,10,0,10350,0,"rocketBarrage2","rocketLauncher15B",0,75,34);
         this.itemsDB_local[545] = new Array(545,"Medium Yellow Laser",5,31505,"sideWeapon","physical",15,0,0,0,0,0,0,0,0,43,0,1,0,0,0,0,0,0,0,1,3,0,0,0,0,0,0,10,0,15550,135,"bulletCharge1","cannon4B",3,75,24);
         this.itemsDB_local[546] = new Array(546,"Single Barreled Rocket Launcher",5,31705,"sideWeapon","explosive",17,0,0,0,0,0,0,0,10,48,0,2,15,0,0,1,0,0,0,2,3,0,0,0,0,0,0,10,0,16600,153,"rocketBarrage2","rocketLauncher16A",3,85,39);
         this.itemsDB_local[548] = new Array(548,"Double Blue Watch Guard",1,31601,"sideWeapon","electric",16,0,0,0,0,0,0,0,0,30,6,3,0,11,0,1,0,0,0,1,3,0,0,0,0,0,0,0,16,10700,0,"beamBlue2","blaster5B",0,80,35);
         this.itemsDB_local[549] = new Array(549,"Double Red Watch Guard",1,31703,"sideWeapon","explosive",17,0,0,0,0,0,0,0,0,32,0,2,12,0,0,1,0,0,0,1,3,0,0,0,0,0,0,17,0,11050,0,"beamRed2","blaster4B",0,85,36);
         this.itemsDB_local[551] = new Array(551,"Red Fiering arms",1,31801,"sideWeapon","explosive",18,0,0,0,0,0,0,0,0,33,0,2,12,0,0,0,0,0,0,1,3,0,0,0,0,0,0,11,0,11400,0,"heatCharge1","laser47A",0,90,35);
         this.itemsDB_local[552] = new Array(552,"Large Yellow Laser",5,31805,"sideWeapon","physical",18,0,0,0,0,0,0,0,0,45,0,1,0,0,0,0,0,0,0,1,3,0,0,0,0,0,0,9,0,17100,36,"bulletCharge1","cannon4C",2,90,28);
         this.itemsDB_local[553] = new Array(553,"Minigun",4,31904,"sideWeapon","physical",19,0,0,0,0,0,0,10,0,40,10,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,5,0,17550,38,"machineGun1","machineGun5A",2,95,25);
         this.itemsDB_local[555] = new Array(555,"GAU-8A",5,32205,"sideWeapon","physical",22,0,0,0,0,0,0,15,0,60,15,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,5,0,18750,198,"machineGun1","machineGun5A",3,110,34);
         this.itemsDB_local[556] = new Array(556,"Double Red Fiering arms",1,32103,"sideWeapon","explosive",21,0,0,0,0,0,0,0,0,30,0,2,22,0,0,0,0,0,0,1,3,0,0,0,0,0,0,11,0,12250,0,"heatCharge1","laser47B",0,105,46);
         this.itemsDB_local[566] = new Array(566,"Single Barreled Rocket Launcher",2,32202,"sideWeapon","explosive",22,0,0,0,0,0,0,0,15,49,13,2,14,0,0,1,0,0,0,2,3,0,0,0,0,0,0,8,0,12500,0,"rocketBarrage1","rocketLauncher16B",0,110,50);
         this.itemsDB_local[570] = new Array(570,"LR Energy Blaster I",3,42203,"topWeapon","electric",22,0,0,0,0,0,0,0,0,42,14,3,0,17,0,1,0,0,0,3,3,0,0,0,0,0,0,0,13,18750,198,"beamRoundBlue1","blaster8A",3,110,42);
         this.itemsDB_local[571] = new Array(571,"SR Energy Blaster",1,42402,"topWeapon","electric",24,0,0,0,0,0,0,0,0,41,0,3,0,15,0,1,0,0,0,3,3,0,0,0,0,0,0,0,11,19450,0,"laser1","laser36C",1,120,42);
         this.itemsDB_local[572] = new Array(572,"Sniper Rifle",2,41902,"topWeapon","physical",19,0,0,0,0,0,0,0,0,57,0,1,0,0,0,0,0,0,0,4,2,0,0,0,0,0,0,11,0,17550,171,"bulletCharge1","cannon4B",3,95,27);
         this.itemsDB_local[577] = new Array(577,"Lucifer",7,11407,"torso","torso",14,258,0,60,15,65,16,0,15,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,68250,126,"","torso26B",3,70,241,0,0,0,0,0,7,0,0,4);
         this.itemsDB_local[578] = new Array(578,"Gladiator",8,11408,"torso","torso",14,270,0,50,18,55,20,15,0,0,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0,0,0,0,68250,126,"","torso32",3,70,238,0,0,0,0,1,1,5,0,4);
         this.itemsDB_local[579] = new Array(579,"Shielded",9,11809,"torso","torso",18,306,0,65,18,70,20,10,0,0,0,0,0,0,0,0,2,2,2,0,0,0,0,0,0,0,0,0,0,79950,162,"","torso33",3,90,276,0,0,0,0,2,2,3,0,4);
         this.itemsDB_local[580] = new Array(580,"Mamut",6,12206,"torso","torso",22,318,0,80,20,80,20,0,20,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0,0,0,88800,198,"","torso34",3,110,307,0,0,0,0,3,3,1,0,3);
         this.itemsDB_local[581] = new Array(581,"Mega Gladiator",5,12205,"torso","torso",22,330,0,85,20,75,18,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,88800,44,"","torso37",2,110,308,0,0,0,0,7,0,0,0,3);
         this.itemsDB_local[582] = new Array(582,"Dragon",7,12207,"torso","torso",22,324,0,75,18,85,22,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,88800,198,"","torso36",3,110,297,0,0,0,0,4,1,3,0,3);
         this.itemsDB_local[584] = new Array(584,"Tank Base",1,11852,"leg","leg",18,0,0,0,0,0,0,0,0,47,0,1,0,0,0,1,0,0,0,0,1,2,0,0,0,0,0,0,0,15100,0,"stomp1","wheels7",0,90,28);
         this.itemsDB_local[585] = new Array(585,"Hoofs",2,11452,"leg","leg",14,12,0,0,0,0,0,0,0,40,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,19350,0,"stomp1","leg22",1,70,29);
         this.itemsDB_local[586] = new Array(586,"Tappings",4,11854,"leg","leg",30,36,0,0,0,0,0,0,0,48,0,1,0,0,0,1,0,0,0,0,1,2,3,0,0,0,0,0,0,22650,162,"stomp1","leg23",3,90,53);
         this.itemsDB_local[587] = new Array(587,"Kickers",3,12253,"leg","leg",22,24,0,0,0,0,0,0,0,52,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,25200,0,"stomp1","leg26",1,110,43);
         this.itemsDB_local[589] = new Array(589,"Polaris",1,42403,"topWeapon","explosive",24,0,0,0,0,0,0,0,20,60,10,2,20,0,2,3,0,0,0,3,3,0,0,0,0,0,0,4,0,19450,216,"rocketBarrage2","rocketLauncher7",3,120,43);
         this.itemsDB_local[590] = new Array(590,"Adv. Energy Shield Mark 9",1,62201,"shield","shield",22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,4,35,0,0,16450,66,"","shield5A",1,110,31);
         this.itemsDB_local[591] = new Array(591,"Shield Breaker",1,31802,"sideWeapon","electric",18,0,0,0,0,0,0,0,0,22,8,3,0,30,3,0,0,0,0,1,3,0,0,0,0,0,0,0,10,11400,0,"laser1","laser28B",0,90,42);
         this.itemsDB_local[593] = new Array(593,"Adv. Heat Shield Mark 4",2,61102,"shield","shield",11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,25,0,0,11200,20,"1","shield2B",2,50,12);
         this.itemsDB_local[594] = new Array(594,"Adv. Heat Shield Mark 6",4,61604,"shield","shield",16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,2,30,0,0,14400,32,"","shield3B",2,70,18);
         this.itemsDB_local[595] = new Array(595,"Heat Shield Mark 4",4,61804,"shield","shield",18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,25,0,0,10100,0,"","shield4B",0,90,13);
         this.itemsDB_local[596] = new Array(596,"Heat Shield Mark 5",1,62202,"shield","shield",22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,2,30,0,0,10950,0,"","shield5B",0,110,18);
         this.itemsDB_local[601] = new Array(601,"Beheader",3,31504,"sideWeapon","melee",15,0,0,0,0,0,0,0,0,36,20,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,9,10,15550,0,"sword1","sword1A",1,75,16);
         this.itemsDB_local[605] = new Array(605,"Vorpal sword",3,31103,"sideWeapon","melee",11,0,0,0,0,0,0,0,0,32,35,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,8,10,12750,0,"sword1","sword3A",1,55,19);
         this.itemsDB_local[606] = new Array(606,"Hauteclere",3,31204,"sideWeapon","melee",12,0,0,0,0,0,0,0,0,27,0,2,30,0,0,0,0,0,0,0,1,0,0,0,0,0,0,8,10,13500,0,"sword2","sword3B",1,60,32);
         this.itemsDB_local[607] = new Array(607,"Blue blood spiller",3,31304,"sideWeapon","melee",13,0,0,0,0,0,0,0,0,39,15,3,0,12,0,0,0,0,0,0,1,0,0,0,0,0,0,0,20,14250,0,"sword3","sword3C",1,65,25);
         this.itemsDB_local[608] = new Array(608,"Paladins sword",3,31404,"sideWeapon","melee",14,0,0,0,0,0,0,0,0,36,10,1,0,0,0,2,0,0,0,0,1,0,0,0,0,0,0,5,15,14950,0,"sword1","sword3D",1,70,19);
         this.itemsDB_local[609] = new Array(609,"Kusanagi",4,31704,"sideWeapon","melee",17,0,0,0,0,0,0,0,0,31,12,3,0,14,0,0,0,0,0,0,1,0,0,0,0,0,0,0,16,16600,0,"sword3","sword1C",1,85,25);
         this.itemsDB_local[610] = new Array(610,"Joyeuse",3,31603,"sideWeapon","melee",16,0,0,0,0,0,0,0,0,36,20,2,20,0,0,0,0,0,0,0,1,0,0,0,0,0,0,9,10,16050,0,"sword2","sword1B",1,80,32);
         this.itemsDB_local[611] = new Array(611,"Inferno sword",3,32104,"sideWeapon","melee",21,0,0,0,0,0,0,0,0,36,0,2,25,0,0,1,0,0,0,0,1,0,0,0,0,0,0,9,10,18400,0,"sword2","sword5B",1,105,37);
         this.itemsDB_local[612] = new Array(612,"Bad yellow sword",3,31803,"sideWeapon","melee",18,0,0,0,0,0,0,0,0,45,10,1,0,0,0,2,0,0,0,0,1,0,0,0,0,0,0,4,14,17100,0,"sword1","sword1D",1,90,26);
         this.itemsDB_local[613] = new Array(613,"Dismantler",3,31903,"sideWeapon","melee",19,0,0,0,0,0,0,0,0,50,15,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,8,10,17550,0,"sword1","sword5A",1,95,22);
         this.itemsDB_local[615] = new Array(615,"Crystal sword",4,32204,"sideWeapon","melee",22,0,0,0,0,0,0,0,0,35,12,3,0,17,0,0,0,0,0,0,1,0,0,0,0,0,0,0,16,18750,44,"sword3","sword5C",2,110,29);
         this.itemsDB_local[616] = new Array(616,"Shockwave",4,32304,"sideWeapon","melee",23,0,0,0,0,0,0,0,0,40,44,1,0,0,0,4,0,0,0,0,1,0,0,0,0,0,0,5,15,19050,0,"sword1","sword5D",1,115,41);
         this.itemsDB_local[623] = new Array(623,"Master Cooling Kit 6",4,122304,"kit","energyHeat",23,0,0,0,0,95,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,3,"","kit_heatS6",2,12,0);
         this.itemsDB_local[624] = new Array(624,"Master Cooling Kit 5",4,121904,"kit","energyHeat",19,0,0,0,0,85,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1350,2,"","kit_heatS5",2,10,0);
         this.itemsDB_local[625] = new Array(625,"Master Cooling Kit 4",6,121506,"kit","energyHeat",15,0,0,0,0,70,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1200,2,"","kit_heatS4",2,8,0);
         this.itemsDB_local[626] = new Array(626,"Master Cooling Kit 3",3,121104,"kit","energyHeat",11,0,0,0,0,60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1050,2,"","kit_heatS3",2,6,0);
         this.itemsDB_local[631] = new Array(631,"Master Repair Kit 5",3,122203,"kit","repair",22,114,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,3,"","kit_HPS5",2,11,0);
         this.itemsDB_local[632] = new Array(632,"Master Repair Kit 4",4,121804,"kit","repair",18,102,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1350,2,"","kit_HPS4",2,9,0);
         this.itemsDB_local[633] = new Array(633,"Master Repair Kit 3",4,121404,"kit","repair",14,90,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1200,2,"","kit_HPS3",2,7,0);
         this.itemsDB_local[637] = new Array(637,"Master Energy Kit 6",2,122403,"kit","energyHeat",24,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,3,"","kit_energyS6",2,12,0);
         this.itemsDB_local[638] = new Array(638,"Master Energy Kit 5",2,122003,"kit","energyHeat",20,0,0,90,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1350,3,"","kit_energyS5",2,10,0);
         this.itemsDB_local[639] = new Array(639,"Master Energy Kit 4",5,121605,"kit","energyHeat",16,0,0,75,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1300,2,"","kit_energyS4",2,8,0);
         this.itemsDB_local[640] = new Array(640,"Master Energy Kit 3",4,121204,"kit","energyHeat",12,0,0,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1150,2,"","kit_energyS3",2,6,0);
         this.itemsDB_local[643] = new Array(643,"Top Machine Gun",1,41801,"topWeapon","physical",18,0,0,0,0,0,0,10,0,50,0,1,0,0,0,0,0,0,0,4,2,0,0,0,0,0,0,3,0,11400,0,"machineGun3","machineGun9A",0,90,32);
         this.itemsDB_local[644] = new Array(644,"Top Machine Gun",1,42002,"topWeapon","physical",20,0,0,0,0,0,0,10,0,50,10,1,0,0,0,0,0,0,0,4,2,0,0,0,0,0,0,1,0,18000,0,"machineGun3","machineGun9B",1,100,31);
         this.itemsDB_local[651] = new Array(651,"Cylon",1,51402,"drone","drone",14,0,0,0,0,0,0,5,0,26,0,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,6,11,13500,0,"machineGun3","drone28",1,70,16);
         this.itemsDB_local[652] = new Array(652,"Kinetic pointer",3,51803,"drone","drone",18,0,0,0,0,0,0,0,0,29,0,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,5,10,15150,36,"bulletCharge1","drone26A",2,90,18);
         this.itemsDB_local[653] = new Array(653,"Electric pointer",2,51802,"drone","drone",18,0,0,0,0,0,0,0,0,24,6,3,0,15,0,0,0,0,0,0,999,0,0,0,0,0,0,0,22,15150,0,"laserCharge1","drone26B",1,90,30);
         this.itemsDB_local[654] = new Array(654,"Laser pointer",4,51804,"drone","drone",18,0,0,0,0,0,0,0,0,25,0,2,16,0,0,0,0,0,0,0,999,0,0,0,0,0,0,12,5,15150,36,"heatCharge1","drone26C",2,90,29);
         this.itemsDB_local[655] = new Array(655,"Parasite",1,52002,"drone","drone",20,0,0,0,0,0,0,0,0,25,10,3,0,16,0,0,0,0,0,0,999,0,0,0,0,0,0,0,22,15850,0,"laser1","drone29",1,100,33);
         this.itemsDB_local[656] = new Array(656,"Evil twin",1,52102,"drone","drone",21,0,0,0,0,0,0,0,0,30,0,2,18,0,0,0,0,0,0,0,999,0,0,0,0,0,0,12,5,16150,189,"heat1","drone30",3,105,32);
         this.itemsDB_local[657] = new Array(657,"One shot one kill",1,52402,"drone","drone",24,0,0,0,0,0,0,10,0,35,0,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,14,5,16900,216,"machineGun2","drone32A",3,120,22);
         this.itemsDB_local[662] = new Array(662,"Neutron gun",3,41803,"topWeapon","electric",18,0,0,0,0,0,0,0,0,33,12,3,0,7,0,0,0,0,0,3,3,0,0,0,0,0,0,0,14,17100,36,"laserCharge1","blaster6A",2,90,25);
         this.itemsDB_local[663] = new Array(663,"Double neutron gun",1,42003,"topWeapon","electric",20,0,0,0,0,0,0,0,0,44,15,3,0,7,0,0,0,0,0,3,3,0,0,0,0,0,0,0,17,18000,40,"laserCharge1","blaster6B",2,100,29);
         this.itemsDB_local[664] = new Array(664,"Flechette",3,41303,"topWeapon","physical",13,0,0,0,0,0,0,10,0,48,0,1,0,0,0,0,0,0,0,4,2,0,0,0,0,0,0,2,0,14250,117,"machineGun3","machineGun7A",3,65,26);
         this.itemsDB_local[665] = new Array(665,"Super Flechette",3,41603,"topWeapon","physical",16,0,0,0,0,0,0,10,0,49,0,1,0,0,0,0,0,0,0,4,2,0,0,0,0,0,0,1,0,16050,144,"machineGun3","machineGun7B",3,80,26);
         this.itemsDB_local[668] = new Array(668,"Fixed point cannon",1,42302,"topWeapon","physical",23,0,0,0,0,0,0,15,0,54,6,1,0,0,0,0,0,0,0,4,2,0,0,0,0,0,0,2,0,19050,0,"machineGun3","machineGun6B",1,115,34);
         this.itemsDB_local[669] = new Array(669,"Fixed point gun",2,41102,"topWeapon","physical",11,0,0,0,0,0,0,10,0,34,7,1,0,0,0,0,0,0,0,4,2,0,0,0,0,0,0,1,0,8500,0,"machineGun1","machineGun6A",0,55,23);
         this.itemsDB_local[670] = new Array(670,"EMP Launcher v1.0",3,41103,"topWeapon","explosive",11,0,0,0,0,0,0,0,10,38,10,2,10,0,0,1,0,0,0,3,3,0,0,0,0,0,0,12,0,12750,22,"rocketBarrage2","rocketLauncher24A",2,55,31);
         this.itemsDB_local[671] = new Array(671,"EMP Launcher v2.0",2,41503,"topWeapon","explosive",15,0,0,0,0,0,0,0,10,47,0,2,14,0,3,1,0,0,0,3,3,0,0,0,0,0,0,5,0,15550,30,"rocketBarrage2","rocketLauncher24B",2,75,33);
         this.itemsDB_local[672] = new Array(672,"EMP Launcher v3.0",2,42103,"topWeapon","explosive",21,0,0,0,0,0,0,0,15,20,10,2,30,0,0,1,0,0,0,3,3,0,0,0,0,0,0,7,0,18400,42,"rocketBarrage2","rocketLauncher24C",2,105,48);
         this.itemsDB_local[685] = new Array(685,"Physical Resistance Kit",3,121303,"kit","resistance",13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,2100,0,"","kit_resistPhysical3",1,7,0);
         this.itemsDB_local[686] = new Array(686,"Physical Resistance Kit",4,121604,"kit","resistance",16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,2400,0,"","kit_resistPhysical3",1,8,0);
         this.itemsDB_local[689] = new Array(689,"Explosive Resistance Kit",3,121304,"kit","resistance",13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,2100,0,"","kit_resistExplosive3",1,7,0);
         this.itemsDB_local[690] = new Array(690,"Explosive Resistance Kit",4,121606,"kit","resistance",16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,2400,0,"","kit_resistExplosive3",1,8,0);
         this.itemsDB_local[694] = new Array(694,"Electric Resistance Kit",2,121607,"kit","resistance",16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,2400,0,"","kit_resistElectric3",1,8,0);
         this.itemsDB_local[697] = new Array(697,"Electric Resistance Kit",4,121305,"kit","resistance",13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,2100,0,"","kit_resistElectric3",1,7,0);
         this.itemsDB_local[698] = new Array(698,"Multi Resistance Module",4,112404,"module","resistance",24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,0,0,0,0,0,0,0,0,0,0,13000,0,"","module_resistanceAll7",1,44,38);
         this.itemsDB_local[701] = new Array(701,"Multi Resistance Module",4,111205,"module","resistance",12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0,9000,0,"","module_resistanceAll3",1,16,16);
         this.itemsDB_local[703] = new Array(703,"Multi Resistance Module",4,111206,"module","resistance",12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,4,4,0,0,0,0,0,0,0,0,0,0,9000,24,"","module_resistanceAll4",2,24,21);
         this.itemsDB_local[704] = new Array(704,"Multi Resistance Module",5,111805,"module","resistance",18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,11400,36,"","module_resistanceAll6",2,28,31);
         this.itemsDB_local[705] = new Array(705,"Multi Resistance Module",3,111506,"module","resistance",15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,5,0,0,0,0,0,0,0,0,0,0,10350,30,"","module_resistanceAll5",2,32,26);
         this.itemsDB_local[706] = new Array(706,"Multi Resistance Module",5,112106,"module","resistance",21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,12250,0,"","module_resistanceAll6",1,36,32);
         this.itemsDB_local[707] = new Array(707,"Multi Resistance Module",5,112109,"module","resistance",21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,0,0,0,0,0,0,0,0,0,0,12250,42,"","module_resistanceAll7",2,40,36);
         this.itemsDB_local[717] = new Array(717,"Flame Thrower v5.0",1,31202,"sideWeapon","explosive",12,0,0,0,0,0,0,0,0,30,0,2,18,0,3,0,0,0,0,0,1,0,0,0,0,0,0,5,0,9000,0,"flame1","flameThrower7B",0,60,24);
         this.itemsDB_local[724] = new Array(724,"Bullet & Rocket Storage 6",6,111707,"module","ammo",17,0,0,0,0,0,0,40,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11100,0,"","module_bulletsRockets_4_1",1,34,40);
         this.itemsDB_local[725] = new Array(725,"Bullet & Rocket Storage 5",5,111306,"module","ammo",13,0,0,0,0,0,0,10,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9550,0,"","module_bulletsRockets_1_3",1,26,32);
         this.itemsDB_local[728] = new Array(728,"Adv. Teleport Mark 3",1,71502,"teleport","teleport",15,0,0,0,0,0,0,0,0,30,12,3,0,19,1,0,0,0,0,0,1,0,0,0,0,0,0,0,40,13950,30,"","teleport4",2,75,18);
         this.itemsDB_local[729] = new Array(729,"Adv. Teleport Mark 4",1,72102,"teleport","teleport",21,0,0,0,0,0,0,0,0,38,22,3,0,32,1,0,0,0,0,0,1,0,0,0,0,0,0,0,48,16150,189,"","teleport5",3,105,25);
         this.itemsDB_local[731] = new Array(731,"Adv. Charge Mark 2",1,81302,"charge","charge",13,0,0,0,0,0,0,0,0,35,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,18,10,12400,108,"","charge3",3,60,11);
         this.itemsDB_local[732] = new Array(732,"Adv. Charge Mark 3",1,81802,"charge","charge",18,0,0,0,0,0,0,0,0,37,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,32,10,15150,36,"","charge5",2,90,13);
         this.itemsDB_local[735] = new Array(735,"Adv. Burning Harpoon Mark 2",1,91201,"harpoon","harpoon",12,0,0,0,0,0,0,0,0,32,0,2,12,0,1,0,0,0,0,1,4,0,0,0,0,0,0,14,20,12400,0,"","harpoon2",1,60,17);
         this.itemsDB_local[736] = new Array(736,"Adv. Electric Harpoon Mark 1",3,91203,"harpoon","harpoon",12,0,0,0,0,0,0,0,0,33,18,3,0,15,1,0,0,0,0,1,5,0,0,0,0,0,0,0,20,12400,108,"","harpoon4",3,60,20);
         this.itemsDB_local[737] = new Array(737,"Adv. Electric Harpoon Mark 2",1,91502,"harpoon","harpoon",15,0,0,0,0,0,0,0,0,31,8,3,0,14,1,0,0,0,0,1,4,0,0,0,0,0,0,0,28,13950,30,"","harpoon4",2,75,19);
         this.itemsDB_local[738] = new Array(738,"Adv. Electric Harpoon Mark 3",1,91802,"harpoon","harpoon",18,0,0,0,0,0,0,0,0,35,15,3,0,24,1,0,0,0,0,1,5,0,0,0,0,0,0,0,32,15150,162,"","harpoon4",3,90,26);
         this.itemsDB_local[747] = new Array(747,"Multi Resistance Module",4,112405,"module","resistance",24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,8,8,0,0,0,0,0,0,0,0,0,0,13000,48,"","module_resistanceAll8",2,48,42);
         this.itemsDB_local[750] = new Array(750,"Physical Resistance Kit",2,122204,"kit","resistance",22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,3000,0,"","kit_resistPhysical5",1,11,0);
         this.itemsDB_local[751] = new Array(751,"Physical Resistance Kit",2,121905,"kit","resistance",19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,0,0,0,0,0,0,2700,0,"","kit_resistPhysical4",1,10,0);
         this.itemsDB_local[757] = new Array(757,"Explosive Resistance Kit",2,121906,"kit","resistance",19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,0,0,0,0,0,2700,0,"","kit_resistExplosive4",1,10,0);
         this.itemsDB_local[758] = new Array(758,"Explosive Resistance Kit",2,122205,"kit","resistance",22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,3000,0,"","kit_resistExplosive5",1,11,0);
         this.itemsDB_local[762] = new Array(762,"Electric Resistance Kit",2,121907,"kit","resistance",19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,0,0,0,0,2700,0,"","kit_resistElectric4",1,10,0);
         this.itemsDB_local[763] = new Array(763,"Electric Resistance Kit",2,122206,"kit","resistance",22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,3000,0,"","kit_resistElectric5",1,11,0);
         this.itemsDB_local[772] = new Array(772,"Adv. Energy Shield Mark 10",5,62305,"shield","shield",23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,2,40,0,0,16650,46,"","shield5A",2,110,38);
         this.itemsDB_local[773] = new Array(773,"Adv. Heat Shield Mark 10",4,62404,"shield","shield",24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1,40,0,0,16900,48,"","shield5B",2,110,31);
         this.itemsDB_local[774] = new Array(774,"Energy Shield Mark 5",3,62103,"shield","shield",21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,1,30,0,0,10750,0,"","shield4A",0,110,24);
         this.itemsDB_local[775] = new Array(775,"Adv. Heat Shield Mark 9",6,62306,"shield","shield",23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,4,35,0,0,16650,69,"","shield5B",1,110,25);
         this.itemsDB_local[779] = new Array(779,"Adv. Energy Shield Mark 4",3,61103,"shield","shield",11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,4,25,0,0,11200,20,"","shield2A",2,50,17);
         this.itemsDB_local[780] = new Array(780,"Energy Shield Mark 6",1,62401,"shield","shield",24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,4,35,0,0,11250,0,"","shield6A",0,130,32);
         this.itemsDB_local[788] = new Array(788,"Adv. Energy Shield Mark 8",5,62005,"shield","shield",20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,4,35,0,0,15850,40,"","shield4A",2,90,30);
         this.itemsDB_local[789] = new Array(789,"Adv. Heat Shield Mark 8",1,62101,"shield","shield",21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,4,35,0,0,16150,42,"","shield4B",2,90,24);
         this.itemsDB_local[790] = new Array(790,"Adv. Energy Shield Mark 7",3,61803,"shield","shield",18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,1,30,0,0,15150,54,"","shield4A",1,90,24);
         this.itemsDB_local[791] = new Array(791,"Adv. Heat Shield Mark 7",6,62006,"shield","shield",20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,2,30,0,0,15850,60,"","shield4B",1,90,18);
         this.itemsDB_local[792] = new Array(792,"Energy Shield Mark 3",5,61205,"shield","shield",12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,2,20,0,0,7850,0,"","shield3A",0,70,12);
         this.itemsDB_local[793] = new Array(793,"Adv. Heat Shield Mark 5",1,61402,"shield","shield",14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,25,0,0,13500,42,"","shield3B",1,70,13);
         this.itemsDB_local[794] = new Array(794,"Adv. Energy Shield Mark 5",3,61303,"shield","shield",13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,4,25,0,0,12400,36,"","shield3A",1,70,18);
         this.itemsDB_local[795] = new Array(795,"Heat Shield Mark 3",6,61306,"shield","shield",13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,20,0,0,8250,0,"","shield3B",0,70,8);
         this.itemsDB_local[802] = new Array(802,"Adv. Charge Mark 4",1,82102,"charge","charge",21,0,0,0,0,0,0,0,0,42,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,28,10,16150,189,"","charge6",3,105,14);
         this.itemsDB_local[806] = new Array(806,"Harpoon Mark 2",1,92101,"harpoon","harpoon",21,0,0,0,0,0,0,0,0,40,0,1,0,0,1,0,0,0,0,1,4,0,0,0,0,0,0,11,40,10750,0,"","harpoon2",0,105,15);
         this.itemsDB_local[808] = new Array(808,"Adv. Burning Harpoon Mark 1",2,91202,"harpoon","harpoon",12,0,0,0,0,0,0,0,0,34,0,2,13,0,1,0,0,0,0,1,4,0,0,0,0,0,0,12,24,12400,24,"","harpoon3",2,60,17);
         this.itemsDB_local[809] = new Array(809,"Adv. Burning Harpoon Mark 3",1,91503,"harpoon","harpoon",15,0,0,0,0,0,0,0,0,34,0,2,18,0,1,0,0,0,0,1,5,0,0,0,0,0,0,11,28,13950,135,"","harpoon3",3,75,20);
         this.itemsDB_local[810] = new Array(810,"Adv. Harpoon Mark 3",1,92102,"harpoon","harpoon",21,0,0,0,0,0,0,0,0,50,0,1,0,0,1,0,0,0,0,1,5,0,0,0,0,0,0,9,42,16150,42,"","harpoon2",2,105,18);
         this.itemsDB_local[836] = new Array(836,"Power Kit",4,122434,"kit","power",24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,20,"","kit_powerB7",2,480,0);
         this.itemsDB_local[837] = new Array(837,"Power Kit",4,122334,"kit","power",23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,19,"","kit_powerB7",2,460,0);
         this.itemsDB_local[838] = new Array(838,"Power Kit",4,122234,"kit","power",22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,18,"","kit_powerB7",2,440,0);
         this.itemsDB_local[839] = new Array(839,"Power Kit",4,122134,"kit","power",21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1350,17,"","kit_powerB6",2,420,0);
         this.itemsDB_local[840] = new Array(840,"Power Kit",4,122034,"kit","power",20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1350,16,"","kit_powerB6",2,400,0);
         this.itemsDB_local[841] = new Array(841,"Power Kit",4,121934,"kit","power",19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1350,15,"","kit_powerB6",2,380,0);
         this.itemsDB_local[842] = new Array(842,"Power Kit",4,121834,"kit","power",18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1350,14,"","kit_powerB5",2,360,0);
         this.itemsDB_local[843] = new Array(843,"Power Kit",4,121734,"kit","power",17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1300,13,"","kit_powerB5",2,340,0);
         this.itemsDB_local[844] = new Array(844,"Power Kit",4,121634,"kit","power",16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1300,12,"","kit_powerB5",2,320,0);
         this.itemsDB_local[845] = new Array(845,"Power Kit",2,121532,"kit","power",15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1200,11,"","kit_powerB4",2,300,0);
         this.itemsDB_local[846] = new Array(846,"Power Kit",4,121434,"kit","power",14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1200,10,"","kit_powerB4",2,280,0);
         this.itemsDB_local[847] = new Array(847,"Power Kit",4,121334,"kit","power",13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1150,10,"","kit_powerB4",2,260,0);
         this.itemsDB_local[848] = new Array(848,"Power Kit",4,121234,"kit","power",12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1150,10,"","kit_powerB3",2,240,0);
         this.itemsDB_local[856] = new Array(856,"Power Kit",1,121131,"kit","power",11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1050,0,"","kit_power3",1,110,0);
         this.itemsDB_local[857] = new Array(857,"Power Kit",1,121231,"kit","power",12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1150,0,"","kit_power3",1,120,0);
         this.itemsDB_local[858] = new Array(858,"Power Kit",1,121331,"kit","power",13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1150,0,"","kit_power4",1,130,0);
         this.itemsDB_local[859] = new Array(859,"Power Kit",1,121431,"kit","power",14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1200,0,"","kit_power4",1,140,0);
         this.itemsDB_local[860] = new Array(860,"Power Kit",1,121531,"kit","power",15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1200,0,"","kit_power4",1,150,0);
         this.itemsDB_local[861] = new Array(861,"Power Kit",1,121631,"kit","power",16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1300,0,"","kit_power5",1,160,0);
         this.itemsDB_local[862] = new Array(862,"Power Kit",1,121731,"kit","power",17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1300,0,"","kit_power5",1,170,0);
         this.itemsDB_local[863] = new Array(863,"Power Kit",1,121831,"kit","power",18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1350,0,"","kit_power5",1,180,0);
         this.itemsDB_local[864] = new Array(864,"Power Kit",1,121931,"kit","power",19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1350,0,"","kit_power6",1,190,0);
         this.itemsDB_local[865] = new Array(865,"Power Kit",1,122031,"kit","power",20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1350,0,"","kit_power6",1,200,0);
         this.itemsDB_local[866] = new Array(866,"Power Kit",1,122131,"kit","power",21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1350,0,"","kit_power6",1,210,0);
         this.itemsDB_local[867] = new Array(867,"Power Kit",1,122231,"kit","power",22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,0,"","kit_power7",1,220,0);
         this.itemsDB_local[868] = new Array(868,"Power Kit",1,122331,"kit","power",23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,0,"","kit_power7",1,230,0);
         this.itemsDB_local[869] = new Array(869,"Power Kit",1,122431,"kit","power",24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,0,"","kit_power7",1,240,0);
         this.itemsDB_local[877] = new Array(877,"Power Kit",4,121134,"kit","power",11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1050,10,"","kit_powerB3",2,220,0);
         this.itemsDB_local[979] = new Array(979,"Regeneration & Cooldown Module 5",4,112306,"module","energyHeat",23,0,0,0,21,0,21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12750,46,"","module_mixed4",2,48,48);
         this.itemsDB_local[998] = new Array(998,"Reinforced Shotgun",2,31406,"sideWeapon","physical",14,0,0,0,0,0,0,10,0,40,10,1,0,0,0,1,0,0,0,0,2,0,0,0,0,0,0,5,5,14950,126,"shotgun1","shotgun1A3",3,40,24);
         this.itemsDB_local[999] = new Array(999,"Electric Shotgun",2,31206,"sideWeapon","electric",12,0,0,0,0,0,0,10,0,30,6,3,0,12,0,1,0,0,0,0,2,0,0,0,0,0,0,5,5,13500,108,"shotgun3","shotgun1A",3,40,28);
         this.itemsDB_local[1000] = new Array(1000,"Heat Shotgun",2,31207,"sideWeapon","explosive",12,0,0,0,0,0,0,10,0,30,6,2,12,0,0,1,0,0,0,0,2,0,0,0,0,0,0,10,0,13500,108,"shotgun2","shotgun1A2",3,40,28);
         this.itemsDB_local[52] = new Array(52,"Repair Kit 7",1,122601,"kit","repair",26,108,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"","kit_HP7",0,13,0);
         this.itemsDB_local[82] = new Array(82,"Energy Kit 7",1,122801,"kit","energyHeat",28,0,0,95,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"","kit_energy7",0,14,0);
         this.itemsDB_local[98] = new Array(98,"Cooling Kit 7",1,122701,"kit","energyHeat",27,0,0,0,0,90,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"","kit_heat7",0,14,0);
         this.itemsDB_local[193] = new Array(193,"Mammoth Paws",1,13051,"leg","leg",30,0,0,0,0,0,0,0,0,60,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,19150,0,"stomp1","leg6",0,150,38);
         this.itemsDB_local[278] = new Array(278,"Bullet & Rocket Storage 10",3,113003,"module","ammo",30,0,0,0,0,0,0,40,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14050,0,"","module_bulletsRockets_4_4",1,60,63);
         this.itemsDB_local[282] = new Array(282,"Armor Plating 9",1,112601,"module","armor",26,66,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8900,0,"","module_HP9",0,52,27);
         this.itemsDB_local[283] = new Array(283,"Armor Plating 10",2,112902,"module","armor",29,72,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9250,0,"","module_HP10",0,58,29);
         this.itemsDB_local[289] = new Array(289,"Energy & Heat Module 10",4,112504,"module","energyHeat",25,0,0,18,9,18,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13150,0,"","module_energyHeat8",1,50,50);
         this.itemsDB_local[292] = new Array(292,"VERUS DEUS",1,13601,"torso","torso",30,1800,0,200,100,200,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9999,9999,"","torso1000",6,155,750,0,0,0,0,5,5,5,0,5);
         this.itemsDB_local[293] = new Array(293,"VERUS DEUS",1,13651,"leg","leg",30,200,0,10,0,0,0,0,0,100,0,2,50,0,0,1,0,0,0,0,1,2,3,0,0,0,0,0,0,9999,9999,"stomp1","leg1000",6,155,250);
         this.itemsDB_local[294] = new Array(294,"VERUS DEUS",1,33601,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,50,50,2,20,0,0,1,2,2,2,0,999,0,0,0,0,0,0,0,25,9999,9999,"heat2","laser1000",6,155,50,0,0,0,0,2,2,2);
         this.itemsDB_local[299] = new Array(299,"Bullet Storage 9",2,112602,"module","ammo",26,0,0,0,0,0,0,55,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8900,0,"","module_bullets9",0,52,44);
         this.itemsDB_local[300] = new Array(300,"Bullet Storage 10",2,112903,"module","ammo",29,0,0,0,0,0,0,60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9250,0,"","module_bullets10",0,58,48);
         this.itemsDB_local[303] = new Array(303,"Energy Module 10",2,112802,"module","energyHeat",28,0,0,30,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9150,0,"","module_energy10",0,56,42);
         this.itemsDB_local[313] = new Array(313,"Rocket Storage 9",2,112702,"module","ammo",27,0,0,0,0,0,0,0,55,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9000,0,"","module_rockets9",0,54,44);
         this.itemsDB_local[314] = new Array(314,"Rocket Storage 10",2,113002,"module","ammo",30,0,0,0,0,0,0,0,60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9350,0,"","module_rockets10",0,60,48);
         this.itemsDB_local[334] = new Array(334,"Rocket Launcher v22.0",1,42701,"topWeapon","explosive",27,0,0,0,0,0,0,0,15,50,10,2,18,0,0,2,0,0,0,3,3,0,0,0,0,0,0,20,0,13500,0,"rocketBarrage1","rocketLauncher9B",0,135,56);
         this.itemsDB_local[358] = new Array(358,"Explosive Resistance Module 10",1,112501,"module","resistance",25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,8750,0,"","module_resistanceExplosive10",0,50,27);
         this.itemsDB_local[367] = new Array(367,"Physical Resistance Module 10",1,112502,"module","resistance",25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,0,8750,0,"","module_resistancePhysical10",0,50,27);
         this.itemsDB_local[372] = new Array(372,"Electric Resistance Module 10",1,112503,"module","resistance",25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,8750,0,"","module_resistanceElectric10",0,50,27);
         this.itemsDB_local[377] = new Array(377,"Hulk",1,12601,"torso","torso",26,348,0,110,26,65,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,62000,0,"","torso11B",0,130,332,0,0,0,0,2,3,3,0,2);
         this.itemsDB_local[378] = new Array(378,"Chief",5,12605,"torso","torso",26,330,0,105,25,90,23,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,95800,52,"","torso17B",2,130,342,0,0,0,0,2,3,2,0,2);
         this.itemsDB_local[380] = new Array(380,"Dactyl",6,12606,"torso","torso",26,360,0,95,23,95,23,30,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,95800,234,"","torso20B",3,130,358,0,0,0,0,3,2,2,0,2);
         this.itemsDB_local[402] = new Array(402,"LR Energy Blaster II",3,42603,"topWeapon","electric",26,0,0,0,0,0,0,0,0,47,15,3,0,22,0,1,0,0,0,3,3,0,0,0,0,0,0,0,15,20050,234,"beamRoundBlue1","blaster8B",3,130,50);
         this.itemsDB_local[404] = new Array(404,"M9000",1,42801,"topWeapon","explosive",28,0,0,0,0,0,0,0,15,58,7,2,20,0,0,1,0,0,0,3,3,0,0,0,0,0,0,10,0,13700,0,"rocketBarrage1","rocketLauncher11C",0,140,60);
         this.itemsDB_local[405] = new Array(405,"M8000",1,42601,"topWeapon","explosive",26,0,0,0,0,0,0,0,15,55,0,2,16,0,0,1,0,0,0,3,3,0,0,0,0,0,0,8,0,13350,0,"rocketBarrage1","rocketLauncher11B",0,130,53);
         this.itemsDB_local[424] = new Array(424,"Adv. Repair Kit 6",1,122602,"kit","repair",26,120,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,0,"","kit_HP13",1,13,0);
         this.itemsDB_local[425] = new Array(425,"Adv. Repair Kit 7",1,122901,"kit","repair",29,132,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,0,"","kit_HP14",1,15,0);
         this.itemsDB_local[431] = new Array(431,"Bullets Kit 7",1,122702,"kit","ammo",27,0,0,0,0,0,0,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"","kit_bullets7",0,14,0);
         this.itemsDB_local[435] = new Array(435,"Adv. Cooling Kit 7",3,122703,"kit","energyHeat",27,0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,0,"","kit_heat14",1,14,0);
         this.itemsDB_local[445] = new Array(445,"Adv. Energy Kit 7",2,122802,"kit","energyHeat",28,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,0,"","kit_energy14",1,14,0);
         this.itemsDB_local[447] = new Array(447,"Apollo",1,13001,"torso","torso",30,360,0,100,25,100,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,67500,0,"","torso9B",0,150,364,0,0,0,0,1,4,5,0,3);
         this.itemsDB_local[451] = new Array(451,"Steel Wolf",2,12602,"torso","torso",26,330,0,90,23,90,23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,63850,0,"","torso13B",0,130,332,0,0,0,0,2,4,2,0,3);
         this.itemsDB_local[452] = new Array(452,"Nelly McRockets",3,12603,"torso","torso",26,336,0,85,22,100,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,95800,0,"","torso12B",1,130,333,0,0,0,0,2,4,2,0,3);
         this.itemsDB_local[453] = new Array(453,"Buster",4,12604,"torso","torso",26,372,0,90,22,85,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,95800,0,"","torso6B",1,130,335,0,0,0,0,1,5,2,0,3);
         this.itemsDB_local[454] = new Array(454,"Fire Guardian",2,13002,"torso","torso",30,372,0,80,20,125,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,101250,0,"","torso15B",1,150,366,0,0,0,0,1,6,1,0,4);
         this.itemsDB_local[455] = new Array(455,"Electric Guardian",3,13003,"torso","torso",30,372,0,125,30,80,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,101250,0,"","torso16B",1,150,366,0,0,0,0,1,1,6,0,4);
         this.itemsDB_local[456] = new Array(456,"Vulcano",4,13004,"torso","torso",30,384,0,90,22,120,30,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,101250,60,"","torso18B",2,150,379,0,0,0,0,0,4,0,0,5);
         this.itemsDB_local[457] = new Array(457,"Saphire",7,12607,"torso","torso",26,354,0,115,26,80,20,15,15,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,95800,234,"","torso19B",3,130,359,0,0,0,0,0,4,0,0,5);
         this.itemsDB_local[458] = new Array(458,"Spider",6,13006,"torso","torso",30,390,0,110,26,130,30,0,0,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0,0,0,101250,270,"","torso23",3,150,394,0,0,0,0,3,3,3,0,5);
         this.itemsDB_local[460] = new Array(460,"HAL",5,13005,"torso","torso",30,372,0,110,28,110,28,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,101250,60,"","torso31",2,150,373,0,0,0,0,3,2,2,0,3);
         this.itemsDB_local[461] = new Array(461,"Ultra Gladiator",7,13007,"torso","torso",30,408,0,100,25,110,26,20,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,101250,270,"","torso30",3,150,382,0,0,0,0,3,3,2,0,2);
         this.itemsDB_local[466] = new Array(466,"Blue Blast",1,32501,"sideWeapon","electric",25,0,0,0,0,0,0,0,0,39,8,3,0,16,0,0,0,0,0,1,3,0,0,0,0,0,0,0,11,13150,0,"beamBlue1","laser38A",0,125,47);
         this.itemsDB_local[469] = new Array(469,"Big Bright Blaster",3,32803,"sideWeapon","explosive",28,0,0,0,0,0,0,0,0,35,5,2,40,0,2,1,0,0,0,2,2,0,0,0,0,0,0,19,0,20550,0,"beamRoundRed1","laser41B",1,140,40);
         this.itemsDB_local[471] = new Array(471,"Umpfifier",5,32505,"sideWeapon","physical",25,0,0,0,0,0,0,15,0,55,28,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,12,0,19750,225,"bullet3","laser42A",3,125,33);
         this.itemsDB_local[474] = new Array(474,"Blue Ravenger",1,32701,"sideWeapon","electric",27,0,0,0,0,0,0,0,0,40,10,3,0,25,0,0,0,0,0,2,2,0,0,0,0,0,0,0,12,13500,0,"beamBlue1","laser38B",0,135,49);
         this.itemsDB_local[475] = new Array(475,"Rocketeer",1,32801,"sideWeapon","explosive",28,0,0,0,0,0,0,0,15,58,5,2,17,0,0,1,0,0,0,2,3,0,0,0,0,0,0,9,0,13700,0,"rocketBarrage1","rocketLauncher14A",0,140,57);
         this.itemsDB_local[476] = new Array(476,"Yellow",5,32705,"sideWeapon","physical",27,0,0,0,0,0,0,0,0,51,16,1,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,10,0,20250,243,"bullet3","laser48A",3,135,30);
         this.itemsDB_local[477] = new Array(477,"Mega blaster",2,32702,"sideWeapon","explosive",27,0,0,0,0,0,0,0,0,42,0,2,17,0,3,0,0,0,0,2,2,0,0,0,0,0,0,16,0,13500,0,"beamRoundRed2","laser43A",0,135,31);
         this.itemsDB_local[478] = new Array(478,"Blue Bombardment",1,32601,"sideWeapon","electric",26,0,0,0,0,0,0,0,0,40,8,3,0,16,0,0,0,0,0,2,2,0,0,0,0,0,0,0,23,13350,0,"beamRoundBlue2","laser44B",0,130,35);
         this.itemsDB_local[479] = new Array(479,"Charged laser",1,32901,"sideWeapon","electric",29,0,0,0,0,0,0,0,0,44,8,3,0,18,0,1,0,0,0,2,2,0,0,0,0,0,0,0,13,13850,0,"beamRoundBlue1","laser45",0,145,51);
         this.itemsDB_local[480] = new Array(480,"Blame Blaster",2,32802,"sideWeapon","explosive",28,0,0,0,0,0,0,0,0,43,0,2,17,0,0,0,0,0,0,3,2,0,0,0,0,0,0,11,0,13700,0,"beamRed1","laser37B",0,140,41);
         this.itemsDB_local[482] = new Array(482,"Rocketful",2,32902,"sideWeapon","explosive",29,0,0,0,0,0,0,0,15,59,10,2,18,0,0,1,0,0,0,2,3,0,0,0,0,0,0,10,0,13850,0,"rocketBarrage1","rocketLauncher14B",0,145,60);
         this.itemsDB_local[483] = new Array(483,"Rail Gun",5,32905,"sideWeapon","physical",29,0,0,0,0,0,0,10,0,72,30,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,15,0,20800,261,"bullet3","laser42B",3,145,40);
         this.itemsDB_local[484] = new Array(484,"Caseus",5,32805,"sideWeapon","physical",28,0,0,0,0,0,0,0,0,62,0,1,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,11,0,20550,252,"bullet3","laser48B",3,140,31);
         this.itemsDB_local[485] = new Array(485,"Lava",1,33001,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,40,16,2,18,0,0,0,0,0,0,2,2,0,0,0,0,0,0,12,0,14000,0,"beamRoundRed2","laser43B",0,150,45);
         this.itemsDB_local[487] = new Array(487,"Giga Feet",1,12651,"leg","leg",26,0,0,0,0,0,0,0,0,55,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,18100,0,"stomp1","leg16",0,130,34);
         this.itemsDB_local[488] = new Array(488,"Ultra Stompers",4,12654,"leg","leg",26,48,0,0,0,0,0,0,0,63,0,1,0,0,0,2,0,0,0,0,1,1,0,0,0,0,0,0,0,27150,234,"stomp1","leg18",3,130,50);
         this.itemsDB_local[489] = new Array(489,"Pipe feet",1,13052,"leg","leg",30,24,0,0,0,0,0,0,0,63,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,28750,0,"stomp1","leg19",1,150,50);
         this.itemsDB_local[490] = new Array(490,"Mountain Feet",1,13053,"leg","leg",30,42,0,0,0,0,0,0,0,65,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,28750,60,"stomp1","leg14",2,150,47);
         this.itemsDB_local[491] = new Array(491,"Golden Springs",3,12653,"leg","leg",26,36,0,0,0,0,0,0,0,60,0,1,0,0,0,2,0,0,0,0,1,2,3,0,0,0,0,0,0,27150,52,"stomp1","leg15",2,130,73);
         this.itemsDB_local[492] = new Array(492,"Quake Feet",1,13054,"leg","leg",30,36,0,0,0,0,0,0,0,80,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,28750,270,"stomp1","leg20",3,150,59);
         this.itemsDB_local[493] = new Array(493,"Cannon feet",1,13055,"leg","leg",30,72,0,0,0,0,0,0,0,65,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,28750,270,"stomp1","leg21",3,150,69);
         this.itemsDB_local[508] = new Array(508,"Bird Blaster",1,52501,"drone","drone",25,0,0,0,0,0,0,0,10,27,0,2,16,0,0,0,0,0,0,0,999,0,0,0,0,0,0,16,5,11450,0,"rocketBarrage2","drone16",0,125,34);
         this.itemsDB_local[511] = new Array(511,"Yello Angel",1,52601,"drone","drone",26,0,0,0,0,0,0,0,0,28,0,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,8,13,11600,0,"bulletCharge1","drone23",0,130,22);
         this.itemsDB_local[512] = new Array(512,"Red Angel",1,52602,"drone","drone",26,0,0,0,0,0,0,0,0,32,0,2,18,0,0,0,0,0,0,0,999,0,0,0,0,0,0,15,5,17400,52,"heatCharge1","drone24",2,130,36);
         this.itemsDB_local[513] = new Array(513,"Blue Angel",1,52603,"drone","drone",26,0,0,0,0,0,0,0,0,29,12,3,0,22,0,0,0,0,0,0,999,0,0,0,0,0,0,0,24,17400,234,"laserCharge1","drone22",3,130,38);
         this.itemsDB_local[515] = new Array(515,"Moon",1,42702,"topWeapon","physical",27,0,0,0,0,0,0,0,0,47,0,1,0,0,0,1,0,0,0,4,2,0,0,0,0,0,0,15,0,20250,0,"beamYellow1","laser40A",1,135,31);
         this.itemsDB_local[516] = new Array(516,"Sun",1,42802,"topWeapon","physical",28,0,0,0,0,0,0,0,0,55,0,1,0,0,0,1,0,0,0,4,2,0,0,0,0,0,0,15,0,20550,0,"beamYellow1","laser40B",1,140,32);
         this.itemsDB_local[517] = new Array(517,"Energy & Heat Module 11",2,112703,"module","energyHeat",27,0,0,19,10,19,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13500,0,"","module_energyHeat9",1,54,54);
         this.itemsDB_local[518] = new Array(518,"Energy & Heat Module 12",2,113004,"module","energyHeat",30,0,0,20,10,20,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14050,0,"","module_energyHeat10",1,60,55);
         this.itemsDB_local[520] = new Array(520,"Yellow Beam",5,33005,"sideWeapon","physical",30,0,0,0,0,0,0,0,0,60,10,1,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,11,0,21000,270,"bullet3","laser48C",3,150,32);
         this.itemsDB_local[521] = new Array(521,"Red Firearms",2,33002,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,50,6,2,7,0,0,1,0,0,0,2,2,0,0,0,0,0,0,12,0,14000,0,"heatCharge1","laser46A",0,150,44);
         this.itemsDB_local[523] = new Array(523,"Rocket Blaster",2,42902,"topWeapon","explosive",29,0,0,0,0,0,0,0,15,60,6,2,24,0,0,2,0,0,0,3,3,0,0,0,0,0,0,12,0,20800,58,"rocketBarrage1","rocketLauncher22D",2,145,68);
         this.itemsDB_local[525] = new Array(525,"Artillery Mark IV",1,42901,"topWeapon","explosive",29,0,0,0,0,0,0,0,15,55,15,2,18,0,0,0,0,0,0,4,4,0,0,0,0,0,0,21,0,13850,0,"artilleryBarrage1","rocketLauncher21A",0,145,47);
         this.itemsDB_local[528] = new Array(528,"Burning fire",2,43002,"topWeapon","explosive",30,0,0,0,0,0,0,0,15,64,20,2,20,0,0,1,0,0,0,3,3,0,0,0,0,0,0,13,0,21000,0,"rocketBarrage1","rocketLauncher23C",1,150,64);
         this.itemsDB_local[529] = new Array(529,"Artillery Mark V",1,43001,"topWeapon","explosive",30,0,0,0,0,0,0,0,15,55,20,2,18,0,0,0,0,0,0,4,4,0,0,0,0,0,0,23,0,14000,0,"artilleryBarrage1","rocketLauncher21B",0,150,48);
         this.itemsDB_local[530] = new Array(530,"Missile Launcher",4,43004,"topWeapon","explosive",30,0,0,0,0,0,0,0,15,72,15,2,27,0,0,2,0,0,0,3,3,0,0,0,0,0,0,18,0,21000,270,"rocketBarrage1","rocketLauncher22C",3,150,72);
         this.itemsDB_local[534] = new Array(534,"Artillery Mark III",1,42501,"topWeapon","explosive",25,0,0,0,0,0,0,0,15,54,6,2,16,0,0,0,0,0,0,4,4,0,0,0,0,0,0,21,0,13150,0,"artilleryBarrage1","rocketLauncher20B",0,125,42);
         this.itemsDB_local[547] = new Array(547,"Basic Double Laser",3,32603,"sideWeapon","explosive",26,0,0,0,0,0,0,0,0,44,0,2,19,0,0,0,0,0,0,2,2,0,0,0,0,0,0,18,0,20050,0,"heat2","cannon2B",1,130,39);
         this.itemsDB_local[557] = new Array(557,"Quad Barreled Rocket Launcher",3,33003,"sideWeapon","explosive",30,0,0,0,0,0,0,0,15,65,15,2,18,0,0,0,0,0,0,2,3,0,0,0,0,0,0,9,0,21000,0,"rocketBarrage1","rocketLauncher16C",1,150,57);
         this.itemsDB_local[558] = new Array(558,"Ultimate Gun",2,32502,"sideWeapon","physical",25,0,0,0,0,0,0,15,0,70,20,1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,9,0,19750,50,"machineGun1","machineGun5B",2,125,41);
         this.itemsDB_local[559] = new Array(559,"Shark",1,32503,"sideWeapon","explosive",25,0,0,0,0,0,0,0,0,40,14,2,30,0,3,0,0,0,0,0,1,0,0,0,0,0,0,6,0,13150,0,"flame1","flameThrower6",0,125,38);
         this.itemsDB_local[560] = new Array(560,"Cooker",2,32602,"sideWeapon","explosive",26,0,0,0,0,0,0,0,0,20,10,2,30,0,0,0,0,0,0,2,2,0,0,0,0,0,0,16,0,13350,0,"beamRoundRed2","blaster2",0,130,42);
         this.itemsDB_local[561] = new Array(561,"Basic Laser",1,32504,"sideWeapon","explosive",25,0,0,0,0,0,0,0,0,46,0,2,18,0,0,0,0,0,0,2,2,0,0,0,0,0,0,20,0,19750,0,"heat2","cannon2A",1,125,38);
         this.itemsDB_local[562] = new Array(562,"Saurus Rifle",5,32605,"sideWeapon","physical",26,0,0,0,0,0,0,0,0,46,16,1,0,0,0,1,0,0,0,1,3,0,0,0,0,0,0,10,0,20050,234,"bullet2","cannon3B",3,130,39);
         this.itemsDB_local[563] = new Array(563,"Blue Shredder beam",4,32704,"sideWeapon","electric",27,0,0,0,0,0,0,0,0,44,12,3,0,23,0,1,0,0,0,2,2,0,0,0,0,0,0,0,20,20250,54,"beamBlue2","blaster3A",2,135,50);
         this.itemsDB_local[564] = new Array(564,"Yellow Shredder beam",4,32804,"sideWeapon","physical",28,0,0,0,0,0,0,0,0,53,0,1,0,0,0,1,0,0,0,2,2,0,0,0,0,0,0,16,0,20550,56,"beamYellow2","blaster3C",2,140,32);
         this.itemsDB_local[565] = new Array(565,"Blue Shredder beam",4,32904,"sideWeapon","explosive",29,0,0,0,0,0,0,0,0,48,32,2,15,0,0,1,0,0,0,2,2,0,0,0,0,0,0,23,0,20800,58,"beamRed2","blaster3B",2,145,48);
         this.itemsDB_local[569] = new Array(569,"Anti Material Rifle",1,42502,"topWeapon","physical",25,0,0,0,0,0,0,0,0,60,0,1,0,0,0,0,0,0,0,4,2,0,0,0,0,0,0,11,0,19750,50,"bulletCharge1","cannon9A",2,125,31);
         this.itemsDB_local[588] = new Array(588,"Two Steps",2,12652,"leg","leg",26,24,0,0,0,0,0,0,0,58,0,1,0,0,0,1,0,0,0,0,1,2,2,0,0,0,0,0,0,27150,0,"stomp1","leg24",1,130,47);
         this.itemsDB_local[617] = new Array(617,"Devastator",4,32604,"sideWeapon","melee",26,0,0,0,0,0,0,0,0,55,18,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,10,10,20050,52,"sword1","sword6A",2,130,24);
         this.itemsDB_local[618] = new Array(618,"Hell Force",3,32703,"sideWeapon","melee",27,0,0,0,0,0,0,0,0,60,13,2,44,0,0,1,0,0,0,0,1,0,0,0,0,0,0,16,10,20250,0,"sword2","sword6B",1,135,63);
         this.itemsDB_local[619] = new Array(619,"Call Of Lightning",3,32903,"sideWeapon","melee",29,0,0,0,0,0,0,0,0,69,30,3,0,50,0,0,0,0,0,0,1,0,0,0,0,0,0,0,22,20800,0,"sword3","sword6C",1,145,72);
         this.itemsDB_local[620] = new Array(620,"Meteor",4,33004,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,71,40,1,0,0,0,2,0,0,0,0,1,0,0,0,0,0,0,7,17,21000,60,"sword1","sword6D",2,150,45);
         this.itemsDB_local[622] = new Array(622,"Master Cooling Kit 7",3,122704,"kit","energyHeat",27,0,0,0,0,110,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,3,"","kit_heatS7",2,14,0);
         this.itemsDB_local[629] = new Array(629,"Master Repair Kit 7",3,122903,"kit","repair",29,144,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,3,"","kit_HPS7",2,15,0);
         this.itemsDB_local[630] = new Array(630,"Master Repair Kit 6",3,122603,"kit","repair",26,132,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,3,"","kit_HPS6",2,13,0);
         this.itemsDB_local[636] = new Array(636,"Master Energy Kit 7",3,122803,"kit","energyHeat",28,0,0,110,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,3,"","kit_energyS7",2,14,0);
         this.itemsDB_local[648] = new Array(648,"Triple kinetic pointer",1,52901,"drone","drone",29,0,0,0,0,0,0,0,0,30,0,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,9,14,12000,0,"bulletCharge1","drone27A",0,145,24);
         this.itemsDB_local[649] = new Array(649,"Triple electric pointer",1,52902,"drone","drone",29,0,0,0,0,0,0,0,0,30,10,3,0,21,0,0,0,0,0,0,999,0,0,0,0,0,0,0,26,18000,0,"laserCharge1","drone27B",1,145,42);
         this.itemsDB_local[650] = new Array(650,"Triple laser pointer",1,52903,"drone","drone",29,0,0,0,0,0,0,0,0,37,0,2,22,0,0,0,0,0,0,0,999,0,0,0,0,0,0,16,5,18000,58,"heatCharge1","drone27C",2,145,42);
         this.itemsDB_local[658] = new Array(658,"Death from Above",1,52701,"drone","drone",27,0,0,0,0,0,0,10,0,40,0,1,0,0,0,0,1,0,0,0,999,0,0,0,0,0,0,14,0,17550,243,"machineGun2","drone32B",3,135,25);
         this.itemsDB_local[659] = new Array(659,"Blue cruiser",1,52801,"drone","drone",28,0,0,0,0,0,0,0,0,28,6,3,0,17,0,0,0,0,0,0,999,0,0,0,0,0,0,0,28,11850,0,"laserCharge1","drone31B",0,140,38);
         this.itemsDB_local[660] = new Array(660,"Red cruiser",1,52802,"drone","drone",28,0,0,0,0,0,0,0,0,29,0,2,17,0,0,0,0,0,0,0,999,0,0,0,0,0,0,18,5,11850,0,"heatCharge1","drone31A",0,140,37);
         this.itemsDB_local[661] = new Array(661,"Antares",1,53001,"drone","drone",30,0,0,0,0,0,0,10,0,53,0,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,9,14,18150,270,"machineGun3","drone33",3,150,29);
         this.itemsDB_local[666] = new Array(666,"Black hole blaster",1,42602,"topWeapon","explosive",26,0,0,0,0,0,0,0,0,40,10,2,18,0,0,2,0,0,0,3,3,0,0,0,0,0,0,21,0,20050,0,"beamRoundRed1","blaster7A",1,130,49);
         this.itemsDB_local[667] = new Array(667,"White hole blaster",1,42803,"topWeapon","explosive",28,0,0,0,0,0,0,0,0,45,5,2,16,0,0,2,0,0,0,3,3,0,0,0,0,0,0,20,0,20550,56,"beamRoundRed1","blaster7B",2,140,49);
         this.itemsDB_local[676] = new Array(676,"Multi Resistance Kit",4,123004,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,4,4,0,0,0,0,0,0,0,0,0,0,1400,1,"","kit_resistAll1",10,3,0);
         this.itemsDB_local[677] = new Array(677,"Multi Resistance Kit",8,123008,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,5,0,0,0,0,0,0,0,0,0,0,1700,1,"","kit_resistAll2",10,4,0);
         this.itemsDB_local[678] = new Array(678,"Multi Resistance Kit",5,123005,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,4,4,0,0,0,0,0,0,0,0,0,0,2400,2,"","kit_resistAll2",10,8,0);
         this.itemsDB_local[681] = new Array(681,"Multi Resistance Kit",5,123006,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,2000,1,"","kit_resistAll2",10,5,0);
         this.itemsDB_local[682] = new Array(682,"Multi Resistance Kit",5,123007,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,0,0,0,0,0,0,0,0,0,0,2300,2,"","kit_resistAll1",10,6,0);
         this.itemsDB_local[683] = new Array(683,"Multi Resistance Kit",6,123009,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,9,0,0,0,0,0,0,0,0,0,0,2300,2,"","kit_resistAll3",10,7,0);
         this.itemsDB_local[684] = new Array(684,"Physical Resistance Kit",2,123002,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,2100,0,"","kit_resistPhysical2",10,6,0);
         this.itemsDB_local[687] = new Array(687,"Physical Resistance Kit",2,123003,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,0,2600,0,"","kit_resistPhysical3",10,9,0);
         this.itemsDB_local[688] = new Array(688,"Explosive Resistance Kit",2,123010,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,2100,0,"","kit_resistExplosive2",10,6,0);
         this.itemsDB_local[691] = new Array(691,"Explosive Resistance Kit",2,123011,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,2600,0,"","kit_resistExplosive3",10,9,0);
         this.itemsDB_local[692] = new Array(692,"Electric Resistance Kit",2,123012,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,2100,0,"","kit_resistElectric2",10,6,0);
         this.itemsDB_local[695] = new Array(695,"Electric Resistance Kit",2,123013,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,2600,0,"","kit_resistElectric3",10,9,0);
         this.itemsDB_local[718] = new Array(718,"ARMOR TANK",0,13600,"torso","torso",36,3600,0,500,50,500,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,101250,9999,"","torso1001",10,155,2360,0,0,0,0,10,10,10,0,3);
         this.itemsDB_local[719] = new Array(719,"ARMOR TANK",0,13650,"leg","leg",36,0,0,0,0,0,0,0,0,60,0,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,28650,9999,"stomp1","leg1001",10,155,24);
         this.itemsDB_local[720] = new Array(720,"ARMOR TANK",0,33600,"sideWeapon","explosive",36,0,0,0,0,0,0,0,0,1,0,2,1,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,21000,9999,"beamRed1","laser1001B",10,155,18);
         this.itemsDB_local[721] = new Array(721,"ARMOR TANK",0,33602,"sideWeapon","electric",36,0,0,0,0,0,0,0,0,1,0,3,1,1,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,21000,9999,"beamBlue1","laser1001A",10,155,20);
         this.itemsDB_local[722] = new Array(722,"Bullet & Rocket Storage 9",9,112709,"module","ammo",27,0,0,0,0,0,0,30,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13500,0,"","module_bulletsRockets_3_4",1,54,55);
         this.itemsDB_local[723] = new Array(723,"Bullet & Rocket Storage 9",3,112704,"module","ammo",27,0,0,0,0,0,0,40,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13500,0,"","module_bulletsRockets_4_3",1,54,55);
         this.itemsDB_local[739] = new Array(739,"Multi Resistance Kit",5,123014,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,2700,2,"","kit_resistAll3",10,9,0);
         this.itemsDB_local[740] = new Array(740,"Multi Resistance Kit",5,123015,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13,13,13,0,0,0,0,0,0,0,0,0,0,2700,2,"","kit_resistAll4",10,10,0);
         this.itemsDB_local[741] = new Array(741,"Multi Resistance Kit",5,123016,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0,0,0,0,0,0,0,0,2700,3,"","kit_resistAll4",10,11,0);
         this.itemsDB_local[742] = new Array(742,"Multi Resistance Kit",5,123017,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,8,8,0,0,0,0,0,0,0,0,0,0,2900,3,"","kit_resistAll5",10,13,0);
         this.itemsDB_local[743] = new Array(743,"Multi Resistance Kit",5,123018,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,0,0,0,0,0,0,0,0,0,0,3000,3,"","kit_resistAll5",10,14,0);
         this.itemsDB_local[744] = new Array(744,"Multi Resistance Kit",5,123019,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,12,12,0,0,0,0,0,0,0,0,0,0,3000,3,"","kit_resistAll6",10,15,0);
         this.itemsDB_local[745] = new Array(745,"Multi Resistance Kit",5,123020,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,0,0,0,0,0,0,0,0,0,0,2900,3,"","kit_resistAll5",10,12,0);
         this.itemsDB_local[746] = new Array(746,"Multi Resistance Module",4,112705,"module","resistance",27,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,9,0,0,0,0,0,0,0,0,0,0,13500,54,"","module_resistanceAll9",2,56,47);
         this.itemsDB_local[748] = new Array(748,"Multi Resistance Module",4,113005,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,0,0,0,0,0,0,0,0,0,0,14050,60,"","module_resistanceAll10",2,60,52);
         this.itemsDB_local[749] = new Array(749,"Multi Resistance Module",4,113006,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,9,0,0,0,0,0,0,0,0,0,0,14050,0,"","module_resistanceAll9",1,52,48);
         this.itemsDB_local[752] = new Array(752,"Physical Resistance Kit",2,123021,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,0,2900,0,"","kit_resistPhysical4",10,12,0);
         this.itemsDB_local[753] = new Array(753,"Physical Resistance Kit",2,123022,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,0,3600,0,"","kit_resistPhysical6",1,15,0);
         this.itemsDB_local[754] = new Array(754,"Physical Resistance Kit",2,122502,"kit","resistance",25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,0,0,0,0,0,0,0,0,0,0,0,0,3300,0,"","kit_resistPhysical6",1,13,0);
         this.itemsDB_local[755] = new Array(755,"Physical Resistance Kit",2,123023,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,0,0,0,0,0,0,0,0,0,0,0,0,3000,0,"","kit_resistPhysical5",10,14,0);
         this.itemsDB_local[756] = new Array(756,"Explosive Resistance Kit",2,123024,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,2900,0,"","kit_resistExplosive4",10,12,0);
         this.itemsDB_local[759] = new Array(759,"Explosive Resistance Kit",2,122503,"kit","resistance",25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,0,0,0,0,0,0,0,0,0,0,0,3300,0,"","kit_resistExplosive6",1,13,0);
         this.itemsDB_local[760] = new Array(760,"Explosive Resistance Kit",2,123025,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,0,0,0,0,0,0,0,0,0,0,0,3000,0,"","kit_resistExplosive5",10,14,0);
         this.itemsDB_local[761] = new Array(761,"Explosive Resistance Kit",2,123026,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,3600,0,"","kit_resistExplosive6",1,15,0);
         this.itemsDB_local[764] = new Array(764,"Electric Resistance Kit",2,123027,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,2900,0,"","kit_resistElectric4",10,12,0);
         this.itemsDB_local[765] = new Array(765,"Electric Resistance Kit",2,122504,"kit","resistance",25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,0,0,0,0,0,0,0,0,0,0,3300,0,"","kit_resistElectric6",1,13,0);
         this.itemsDB_local[766] = new Array(766,"Electric Resistance Kit",2,123028,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,0,0,0,0,0,0,0,0,0,0,3000,0,"","kit_resistElectric5",10,14,0);
         this.itemsDB_local[767] = new Array(767,"Electric Resistance Kit",2,123029,"kit","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,3600,0,"","kit_resistElectric6",1,15,0);
         this.itemsDB_local[781] = new Array(781,"Adv. Heat Shield Mark 13",2,62802,"shield","shield",28,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,2,50,0,0,17800,56,"","shield7B",2,150,48);
         this.itemsDB_local[782] = new Array(782,"Adv. Energy Shield Mark 12",1,62601,"shield","shield",26,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,0,4,45,0,0,17400,52,"","shield7A",2,150,48);
         this.itemsDB_local[783] = new Array(783,"Adv. Heat Shield Mark 11",2,62602,"shield","shield",26,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1,40,0,0,17400,78,"","shield6B",1,130,32);
         this.itemsDB_local[784] = new Array(784,"Adv. Energy Shield Mark 11",3,62503,"shield","shield",25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,2,40,0,0,17200,75,"","shield6A",1,130,40);
         this.itemsDB_local[785] = new Array(785,"Heat Shield Mark 6",4,62504,"shield","shield",25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,4,35,0,0,11450,0,"","shield6B",0,130,25);
         this.itemsDB_local[786] = new Array(786,"Adv. Energy Shield Mark 13",3,62703,"shield","shield",27,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,1,50,0,0,17550,54,"","shield7A",2,150,57);
         this.itemsDB_local[787] = new Array(787,"Adv. Heat Shield Mark 12",4,62704,"shield","shield",27,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,4,45,0,0,17550,54,"","shield7B",2,150,39);
         this.itemsDB_local[796] = new Array(796,"Teleport Mark 8",1,72501,"teleport","teleport",25,0,0,0,0,0,0,0,0,38,10,3,0,28,1,0,0,0,0,0,1,0,0,0,0,0,0,0,54,11450,0,"","teleport6",0,125,26);
         this.itemsDB_local[797] = new Array(797,"Teleport Mark 9",1,73001,"teleport","teleport",30,0,0,0,0,0,0,0,0,44,10,3,0,31,1,0,0,0,0,0,1,0,0,0,0,0,0,0,54,12100,0,"","teleport7",0,150,29);
         this.itemsDB_local[798] = new Array(798,"Adv. Teleport Mark 5",1,72502,"teleport","teleport",25,0,0,0,0,0,0,0,0,40,12,3,0,31,1,0,0,0,0,0,1,0,0,0,0,0,0,0,50,17200,50,"","teleport6",2,125,26);
         this.itemsDB_local[799] = new Array(799,"Adv. Teleport Mark 6",1,73002,"teleport","teleport",30,0,0,0,0,0,0,0,0,49,18,3,0,35,1,0,0,0,0,0,1,0,0,0,0,0,0,0,54,18150,270,"","teleport7",3,150,30);
         this.itemsDB_local[800] = new Array(800,"Charge Mark 8",1,82501,"charge","charge",25,0,0,0,0,0,0,0,0,41,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,38,10,11450,0,"","charge6",0,125,17);
         this.itemsDB_local[801] = new Array(801,"Charge Mark 9",1,83001,"charge","charge",30,0,0,0,0,0,0,0,0,46,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,38,10,12100,0,"","charge7",0,150,19);
         this.itemsDB_local[803] = new Array(803,"Adv. Charge Mark 5",1,82502,"charge","charge",25,0,0,0,0,0,0,0,0,44,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,34,10,17200,50,"","charge6",2,125,16);
         this.itemsDB_local[804] = new Array(804,"Adv. Charge Mark 6",1,83002,"charge","charge",30,0,0,0,0,0,0,0,0,53,0,1,0,0,1,1,0,0,0,1,999,0,0,0,0,0,0,26,10,18150,270,"","charge7",3,150,19);
         this.itemsDB_local[805] = new Array(805,"Burning Harpoon Mark 3",1,92501,"harpoon","harpoon",25,0,0,0,0,0,0,0,0,41,0,2,28,0,1,0,0,0,0,1,4,0,0,0,0,0,0,28,46,11450,0,"","harpoon3",0,125,30);
         this.itemsDB_local[807] = new Array(807,"Electric Harpoon Mark 2",1,93001,"harpoon","harpoon",30,0,0,0,0,0,0,0,0,45,10,3,0,33,1,0,0,0,0,1,4,0,0,0,0,0,0,0,64,12100,0,"","harpoon4",0,150,36);
         this.itemsDB_local[811] = new Array(811,"Adv. Burning Harpoon Mark 4",1,92502,"harpoon","harpoon",25,0,0,0,0,0,0,0,0,43,0,2,38,0,1,0,0,0,0,1,5,0,0,0,0,0,0,24,44,17200,225,"","harpoon3",3,125,34);
         this.itemsDB_local[812] = new Array(812,"Adv. Electric Harpoon Mark 4",1,93002,"harpoon","harpoon",30,0,0,0,0,0,0,0,0,48,18,3,0,38,1,0,0,0,0,1,5,0,0,0,0,0,0,0,48,18150,270,"","harpoon4",3,150,38);
         this.itemsDB_local[813] = new Array(813,"Iron Shredder Mark II",5,33006,"sideWeapon","physical",30,0,0,0,0,0,0,20,0,150,45,1,0,0,0,0,10,0,0,0,2,0,0,0,0,0,0,9,0,21000,270,"machineGun3","machineGun8B",4,150,46);
         this.itemsDB_local[814] = new Array(814,"Iron Shredder Mark I",5,32806,"sideWeapon","physical",15,0,0,0,0,0,0,15,0,75,35,1,0,0,0,0,5,0,0,0,2,0,0,0,0,0,0,0,0,20550,252,"machineGun3","machineGun8A",3,140,46);
         this.itemsDB_local[815] = new Array(815,"Apocalypse Mark II",3,42804,"topWeapon","physical",28,0,0,0,0,0,0,15,0,70,12,1,0,0,0,2,0,0,0,4,2,0,0,0,0,0,0,16,0,20550,252,"bullet3","cannon1B",3,140,47);
         this.itemsDB_local[816] = new Array(816,"Apocalypse Mark III",4,43005,"topWeapon","physical",30,0,0,0,0,0,0,15,0,85,5,1,0,0,0,2,0,0,0,4,2,0,0,0,0,0,0,18,0,21000,270,"bullet3","cannon1C",3,150,50);
         this.itemsDB_local[817] = new Array(817,"Apocalypse Mark I",3,42604,"topWeapon","physical",26,0,0,0,0,0,0,15,0,60,20,1,0,0,0,1,0,0,0,4,2,0,0,0,0,0,0,13,0,20050,234,"bullet3","cannon1A",3,130,39);
         this.itemsDB_local[818] = new Array(818,"Missile Battery Mark III",3,33007,"sideWeapon","explosive",30,0,0,0,0,0,0,0,15,67,8,2,25,0,0,1,0,0,0,2,3,0,0,0,0,0,0,10,0,21000,60,"rocketBarrage1","rocketLauncher17C",2,150,67);
         this.itemsDB_local[819] = new Array(819,"Missile Battery Mark I",3,32606,"sideWeapon","explosive",26,0,0,0,0,0,0,0,15,62,0,2,18,0,0,1,0,0,0,2,3,0,0,0,0,0,0,14,0,20050,52,"rocketBarrage1","rocketLauncher17A",2,130,53);
         this.itemsDB_local[820] = new Array(820,"Missile Battery Mark II",3,32807,"sideWeapon","explosive",28,0,0,0,0,0,0,0,15,33,50,2,30,0,0,0,0,0,0,2,3,0,0,0,0,0,0,9,0,20550,56,"rocketBarrage1","rocketLauncher17B",2,140,59);
         this.itemsDB_local[821] = new Array(821,"Dual Barreled Rocket Launcher",3,32906,"sideWeapon","explosive",29,0,0,0,0,0,0,0,15,62,22,2,19,0,0,1,0,0,0,2,3,0,0,0,0,0,0,10,0,20800,0,"rocketBarrage1","rocketLauncher16C",1,145,64);
         this.itemsDB_local[823] = new Array(823,"Power Kit",4,123034,"kit","power",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,30,"","kit_powerB9",2,600,0);
         this.itemsDB_local[831] = new Array(831,"Power Kit",4,122834,"kit","power",28,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,29,"","kit_powerB9",2,560,0);
         this.itemsDB_local[832] = new Array(832,"Power Kit",4,122934,"kit","power",29,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,28,"","kit_powerB9",2,580,0);
         this.itemsDB_local[833] = new Array(833,"Power Kit",4,122734,"kit","power",27,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,27,"","kit_powerB8",2,540,0);
         this.itemsDB_local[834] = new Array(834,"Power Kit",4,122634,"kit","power",26,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,26,"","kit_powerB8",2,520,0);
         this.itemsDB_local[835] = new Array(835,"Power Kit",4,122534,"kit","power",25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,25,"","kit_powerB8",2,500,0);
         this.itemsDB_local[870] = new Array(870,"Power Kit",1,122531,"kit","power",25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,0,"","kit_power8",1,250,0);
         this.itemsDB_local[871] = new Array(871,"Power Kit",1,122631,"kit","power",26,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,0,"","kit_power8",1,260,0);
         this.itemsDB_local[872] = new Array(872,"Power Kit",1,122731,"kit","power",27,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,0,"","kit_power8",1,270,0);
         this.itemsDB_local[873] = new Array(873,"Power Kit",2,122832,"kit","power",28,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,0,"","kit_power9",1,280,0);
         this.itemsDB_local[874] = new Array(874,"Power Kit",2,122932,"kit","power",29,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,0,"","kit_power9",1,290,0);
         this.itemsDB_local[875] = new Array(875,"Power Kit",1,123031,"kit","power",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1500,0,"","kit_power9",1,300,0);
         this.itemsDB_local[878] = new Array(878,"Resistance drainer",1,33008,"sideWeapon","physical",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,8,0,0,1,3,0,0,0,0,0,0,12,0,14000,0,"specialPhysical1","blaster15A",0,150,32);
         this.itemsDB_local[879] = new Array(879,"Resistance drainer",1,33009,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,8,0,1,3,0,0,0,0,0,0,12,0,14000,0,"specialExplosive1","blaster14A",0,150,32);
         this.itemsDB_local[880] = new Array(880,"Resistance drainer",1,33010,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,8,1,3,0,0,0,0,0,0,12,0,14000,0,"specialElectric1","blaster13A",0,150,32);
         this.itemsDB_local[881] = new Array(881,"Liranium",1,33011,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,40,16,3,0,20,0,0,0,0,0,2,2,0,0,0,0,0,0,0,12,14000,0,"beamBlue1","blaster12B",0,150,47);
         this.itemsDB_local[882] = new Array(882,"Miniliranium",2,32808,"sideWeapon","electric",28,0,0,0,0,0,0,0,0,39,9,3,0,17,0,0,0,0,0,2,2,0,0,0,0,0,0,0,11,13700,0,"beamRed1","blaster12A",0,140,42);
         this.itemsDB_local[883] = new Array(883,"Xray",1,43003,"topWeapon","electric",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,8,4,2,0,0,0,0,0,0,11,0,14000,0,"specialElectric1","blaster13A",0,150,27);
         this.itemsDB_local[884] = new Array(884,"B-ray",1,43006,"topWeapon","explosive",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,8,0,4,2,0,0,0,0,0,0,11,0,14000,0,"specialExplosive1","blaster14A",0,150,27);
         this.itemsDB_local[885] = new Array(885,"A-ray",1,43007,"topWeapon","physical",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,8,0,0,4,2,0,0,0,0,0,0,11,0,14000,0,"specialPhysical1","blaster15A",0,150,27);
         this.itemsDB_local[886] = new Array(886,"Shotgun X Mark I",5,33012,"sideWeapon","physical",30,0,0,0,0,0,0,15,0,20,150,1,0,0,0,2,0,0,0,0,2,0,0,0,0,0,0,10,0,21000,90,"shotgun1","shotgun1C3",2,150,59);
         this.itemsDB_local[887] = new Array(887,"Shotgun X Mark I",5,33013,"sideWeapon","explosive",30,0,0,0,0,0,0,15,0,20,130,2,28,0,0,2,0,0,0,0,2,0,0,0,0,0,0,10,0,21000,90,"shotgun2","shotgun1C2",2,150,79);
         this.itemsDB_local[888] = new Array(888,"Shotgun X Mark I",5,33014,"sideWeapon","electric",30,0,0,0,0,0,0,15,0,20,130,3,0,28,0,2,0,0,0,0,2,0,0,0,0,0,0,10,0,21000,90,"shotgun3","shotgun1C",2,150,79);
         this.itemsDB_local[889] = new Array(889,"Grenade launcher Mark III",3,33015,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,50,12,2,20,0,0,1,0,2,0,2,2,0,0,0,0,0,0,12,6,21000,60,"grenade2","grenadeLauncher2A",2,150,61);
         this.itemsDB_local[890] = new Array(890,"Grenade launcher Mark III",3,33016,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,50,12,3,0,20,0,1,0,0,2,2,2,0,0,0,0,0,0,12,6,21000,60,"grenade3","grenadeLauncher2A2",2,150,61);
         this.itemsDB_local[891] = new Array(891,"Grenade launcher Mark III",3,33017,"sideWeapon","physical",30,0,0,0,0,0,0,0,0,60,12,1,0,0,0,1,2,0,0,2,2,0,0,0,0,0,0,12,6,21000,60,"grenade1","grenadeLauncher2A3",2,150,47);
         this.itemsDB_local[892] = new Array(892,"Galaxus Model A",7,13008,"torso","torso",30,432,0,95,24,110,26,25,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,101250,270,"","torso42B",3,150,395,0,0,0,0,5,0,0,0,4);
         this.itemsDB_local[893] = new Array(893,"Galaxus Model B",7,13009,"torso","torso",30,432,0,95,24,110,26,0,25,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,101250,270,"","torso42A",3,150,395,0,0,0,0,0,5,0,0,4);
         this.itemsDB_local[894] = new Array(894,"Galaxus Model C",7,13010,"torso","torso",30,432,0,135,30,90,24,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,101250,270,"","torso42C",3,150,396,0,0,0,0,0,0,5,0,4);
         this.itemsDB_local[895] = new Array(895,"Fire Stampede",1,13056,"leg","leg",30,24,0,0,0,0,0,0,0,60,0,2,25,0,0,2,0,0,0,0,1,1,2,0,0,0,0,0,0,28750,270,"stomp2","leg27A",3,150,74);
         this.itemsDB_local[896] = new Array(896,"Steel Stampede",1,13057,"leg","leg",30,24,0,0,0,0,0,0,0,80,0,1,0,0,0,2,0,0,0,0,1,1,2,0,0,0,0,0,0,28750,270,"stomp1","leg27B",3,150,61);
         this.itemsDB_local[897] = new Array(897,"Thunder Stampede",1,13058,"leg","leg",30,24,0,0,0,0,0,0,0,60,0,3,0,25,0,2,0,0,0,0,1,1,2,0,0,0,0,0,0,28750,270,"stomp3","leg27C",3,150,74);
         this.itemsDB_local[898] = new Array(898,"Resistance drainer",3,33018,"sideWeapon","physical",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,9,0,0,1,3,0,0,0,0,0,0,12,0,21000,60,"specialPhysical1","blaster15B",2,150,36);
         this.itemsDB_local[899] = new Array(899,"Resistance drainer",3,33019,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,9,0,1,3,0,0,0,0,0,0,12,0,21000,60,"specialExplosive1","blaster14B",2,150,36);
         this.itemsDB_local[900] = new Array(900,"Resistance drainer",3,33020,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,9,1,3,0,0,0,0,0,0,12,0,21000,60,"specialElectric1","blaster13B",2,150,36);
         this.itemsDB_local[1898] = new Array(1898,"Resistance drainer MKII",3,33018,"sideWeapon","physical",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,25,0,0,1,3,0,0,0,0,0,0,12,0,21000,60,"specialPhysical1","blaster15B",4,150,36);
         this.itemsDB_local[1899] = new Array(1899,"Resistance drainer MKII",3,33019,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,25,0,1,3,0,0,0,0,0,0,12,0,21000,60,"specialExplosive1","blaster14B",4,150,36);
         this.itemsDB_local[1900] = new Array(1900,"Resistance drainer MKII",3,33020,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,25,1,3,0,0,0,0,0,0,12,0,21000,60,"specialElectric1","blaster13B",4,150,36);
         this.itemsDB_local[901] = new Array(901,"Xray",3,43008,"topWeapon","electric",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,12,4,2,0,0,0,0,0,0,11,0,21000,60,"specialElectric1","blaster13B",2,150,31);
         this.itemsDB_local[902] = new Array(902,"B-ray",3,43009,"topWeapon","explosive",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,12,0,4,2,0,0,0,0,0,0,11,0,21000,60,"specialExplosive1","blaster14B",2,150,31);
         this.itemsDB_local[903] = new Array(903,"A-ray",3,43010,"topWeapon","physical",30,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,19,0,0,4,2,0,0,0,0,0,0,11,0,21000,60,"specialPhysical1","blaster15B",2,150,31);
         this.itemsDB_local[914] = new Array(914,"Jeep",1,13602,"torso","torso",36,50,0,20,7,20,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,101250,9999,"","torso1002",10,155,960,0,0,0,0,1,1,1,0,5);
         this.itemsDB_local[915] = new Array(915,"Tank",1,13603,"torso","torso",36,70,0,25,10,25,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,101250,9999,"","torso1003",10,155,960,0,0,0,0,2,2,2,0,5);
         this.itemsDB_local[916] = new Array(916,"Jeep wheels",1,13652,"leg","leg",36,0,0,0,0,0,0,0,0,1,0,1,0,0,0,1,0,0,0,0,1,4,0,0,0,0,0,0,0,28650,9999,"stomp1","leg1002",10,155,8);
         this.itemsDB_local[917] = new Array(917,"Tank wheels",1,13653,"leg","leg",36,0,0,0,0,0,0,0,0,1,0,1,0,0,0,1,0,0,0,0,1,3,0,0,0,0,0,0,0,28650,9999,"stomp1","leg1003",10,155,8);
         this.itemsDB_local[918] = new Array(918,"Turret base",1,13654,"leg","leg",36,0,0,0,0,0,0,0,0,1,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,28650,9999,"stomp1","leg1004",10,155,8);
         this.itemsDB_local[919] = new Array(919,"Turret",1,13604,"torso","torso",36,1000,0,120,20,120,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,805,9999,"","torso1004",10,155,960,0,0,0,0,3,3,3,0,3);
         this.itemsDB_local[920] = new Array(920,"Inferno Mark II",5,33021,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,22,15,2,65,0,2,0,0,3,0,0,1,0,0,0,0,0,0,25,0,21000,270,"flame1","flameThrower8B",3,150,43);
         this.itemsDB_local[921] = new Array(921,"Inferno Mark I",5,32706,"sideWeapon","explosive",27,0,0,0,0,0,0,0,0,18,13,2,50,0,2,0,0,2,0,0,1,0,0,0,0,0,0,22,0,20250,243,"flame1","flameThrower8A",3,150,33);
         this.itemsDB_local[922] = new Array(922,"Demolisher Mark III",5,33022,"sideWeapon","physical",30,0,0,0,0,0,0,15,0,75,10,1,0,0,0,0,3,0,0,0,3,0,0,0,0,0,0,0,0,21000,270,"bullet3","cannon6C",3,150,68);
         this.itemsDB_local[923] = new Array(923,"Demolisher Mark II",5,32809,"sideWeapon","physical",28,0,0,0,0,0,0,15,0,70,10,1,0,0,0,0,2,0,0,0,3,0,0,0,0,0,0,0,0,20550,252,"bullet3","cannon6B",3,150,60);
         this.itemsDB_local[924] = new Array(924,"Demolisher Mark I",5,32607,"sideWeapon","physical",26,0,0,0,0,0,0,15,0,65,10,1,0,0,0,0,2,0,0,0,3,0,0,0,0,0,0,0,0,20050,234,"bullet3","cannon6A",3,150,56);
         this.itemsDB_local[925] = new Array(925,"Grenade launcher Mark IV",3,33203,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,56,16,2,20,0,0,1,0,4,0,2,2,0,0,0,0,0,0,13,7,21000,9999,"grenade2","grenadeLauncher2B",3,150,73,0,0,0,0);
         this.itemsDB_local[926] = new Array(926,"Grenade launcher Mark IV",3,33204,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,50,14,3,0,37,0,1,0,0,4,2,2,0,0,0,0,0,0,13,7,21000,9999,"grenade3","grenadeLauncher2B2",3,150,73);
         this.itemsDB_local[927] = new Array(927,"Grenade launcher Mark IV",3,33205,"sideWeapon","physical",30,0,0,0,0,0,0,0,0,70,20,1,0,0,0,1,6,0,0,2,2,0,0,0,0,0,0,13,7,21000,9999,"grenade1","grenadeLauncher2B3",3,150,60,0,0,0,0);
         this.itemsDB_local[928] = new Array(928,"Piercing Shotgun Mark I",121,33221,"sideWeapon","physical",15,0,0,0,0,0,0,15,0,30,75,1,0,0,0,1,2,0,0,0,2,0,0,0,0,0,0,12,0,21000,90,"shotgun1","shotgun2A3",2,150,59);
         this.itemsDB_local[929] = new Array(929,"Piercing Shotgun Mark I",122,33222,"sideWeapon","explosive",15,0,0,0,0,0,0,15,0,35,80,2,43,0,0,1,0,2,0,0,2,0,0,0,0,0,0,25,5,21000,90,"shotgun2","shotgun2A2",2,250,65);
         this.itemsDB_local[930] = new Array(930,"Piercing Shotgun Mark I",123,33223,"sideWeapon","electric",30,0,0,0,0,0,0,15,0,35,80,3,0,43,0,1,0,0,2,0,2,0,0,0,0,0,0,5,25,21000,90,"shotgun3","shotgun2A",2,250,65);
         this.itemsDB_local[931] = new Array(931,"Shotgun X Mark III",5,33405,"sideWeapon","physical",30,0,0,0,0,0,0,15,0,35,150,1,0,0,0,1,3,0,0,0,2,0,0,0,0,0,0,14,0,21000,9999,"shotgun1","shotgun2B3",3,250,65);
         this.itemsDB_local[932] = new Array(932,"Shotgun X Mark III",5,33406,"sideWeapon","explosive",30,0,0,0,0,0,0,15,0,35,125,2,36,0,0,2,0,0,0,0,2,0,0,0,0,0,0,16,0,21000,9999,"shotgun2","shotgun2B2",3,150,96);
         this.itemsDB_local[933] = new Array(933,"Shotgun X Mark III",5,33407,"sideWeapon","electric",30,0,0,0,0,0,0,15,0,35,125,3,0,36,0,2,0,0,0,0,2,0,0,0,0,0,0,16,0,21000,9999,"shotgun3","shotgun2B",3,150,94);
         this.itemsDB_local[934] = new Array(934,"Electron Defence Mark II",103,13203,"torso","torso",30,450,0,150,70,170,80,0,0,0,0,0,0,0,0,0,3,3,10,0,0,0,0,0,0,0,0,0,0,101250,9999,"","torso44",4,250,382,0,0,0,0,3,3,4,0,4);
         this.itemsDB_local[935] = new Array(935,"HellFire Armor Mark II",105,13205,"torso","torso",30,600,0,110,70,150,85,30,0,0,0,0,0,0,0,0,3,8,3,0,0,0,0,0,0,0,0,0,0,101250,9999,"","torso46",4,250,407,0,0,0,0,2,5,3,0,3);
         this.itemsDB_local[936] = new Array(936,"Lava Scope Mark II",102,13202,"torso","torso",30,620,0,110,75,170,80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,101250,9999,"","torso48",4,165,369,0,0,0,0,3,5,3,0,3);
         this.itemsDB_local[937] = new Array(937,"Metrolens Mark II",104,13204,"torso","torso",30,600,0,130,45,130,45,0,0,0,0,0,0,0,0,0,10,3,3,0,0,0,0,0,0,0,0,0,0,101250,9999,"","torso47",4,250,379,0,0,0,0,5,3,3,0,3);
         this.itemsDB_local[938] = new Array(938,"Ultraspade Mark II",101,13201,"torso","torso",30,580,0,150,70,130,60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,225000,9999,"","torso45",4,165,364,0,0,0,0,0,0,0,0,3);
         this.itemsDB_local[939] = new Array(939,"Defense Matrix Mark II",1,13401,"torso","torso",30,500,0,130,60,120,60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,112500,9999,"","torso49",4,165,405,0,0,0,0,1,1,1,0,2);
         this.itemsDB_local[940] = new Array(940,"Meltdown",102,33202,"sideWeapon","melee",31,0,0,0,0,0,0,0,0,48,20,2,52,0,0,1,0,3,0,0,1,0,0,0,0,0,0,18,11,21000,9999,"sword2","sword7B",4,150,58);
         this.itemsDB_local[941] = new Array(941,"Meteor",101,33201,"sideWeapon","melee",31,0,0,0,0,0,0,0,0,76,44,1,0,0,0,0,4,0,0,0,1,0,0,0,0,0,0,9,15,21000,9999,"sword1","sword7A",4,150,50);
         this.itemsDB_local[942] = new Array(942,"Sparks",103,33206,"sideWeapon","melee",31,0,0,0,0,0,0,0,0,48,20,3,0,52,0,1,0,0,3,0,1,0,0,0,0,0,0,0,24,21000,9999,"sword3","sword7C",4,150,59);
         this.itemsDB_local[943] = new Array(943,"Meteor",4,33504,"sideWeapon","melee",35,0,0,0,0,0,0,0,0,80,60,1,0,0,0,2,0,0,0,0,1,0,0,0,0,0,0,14,19,21000,90,"sword1","sword7D",2,150,52);
         this.itemsDB_local[944] = new Array(944,"Power Kit",1,123531,"kit","power",35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,400,0,"","kit_power14",1,400,0);
         this.itemsDB_local[945] = new Array(945,"Ultra Power Kit IV",4,123434,"kit","power",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,12500,1,"","kit_powerB13",2,5000,0);
         this.itemsDB_local[946] = new Array(946,"Power Kit",1,123131,"kit","power",31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,400,0,"","kit_power10",1,320,0);
         this.itemsDB_local[947] = new Array(947,"Power Kit",1,123431,"kit","power",34,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,400,0,"","kit_power13",1,380,0);
         this.itemsDB_local[948] = new Array(948,"Power Kit",1,123331,"kit","power",33,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,400,0,"","kit_power12",1,360,0);
         this.itemsDB_local[949] = new Array(949,"Power Kit",1,123231,"kit","power",32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,400,0,"","kit_power11",1,340,0);
         this.itemsDB_local[950] = new Array(950,"Ultra Power Kit II",4,123234,"kit","power",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,2500,10,"","kit_powerB11",2,1000,0);
         this.itemsDB_local[951] = new Array(951,"Ultra Power Kit V",4,123534,"kit","power",35,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,200,0,"","kit_powerB14",1,800,0);
         this.itemsDB_local[952] = new Array(952,"Ultra Power Kit I",4,123134,"kit","power",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,1250,10,"","kit_powerB10",2,500,0);
         this.itemsDB_local[953] = new Array(953,"Ultra Power Kit III",4,123334,"kit","power",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,6250,15,"","kit_powerB12",2,2500,0);
         this.itemsDB_local[954] = new Array(954,"Mayhem Battery I",141,43241,"topWeapon","explosive",30,0,0,0,0,0,0,0,10,52,19,2,31,0,0,0,0,2,0,3,4,0,0,0,0,0,0,24,0,21000,9999,"rocketBarrage1","rocketLauncher25A",3,150,57);
         this.itemsDB_local[955] = new Array(955,"Mayhem Battery II",142,43242,"topWeapon","explosive",31,0,0,0,0,0,0,0,10,53,20,2,33,0,0,0,0,2,0,3,4,0,0,0,0,0,0,25,0,21000,9999,"rocketBarrage1","rocketLauncher25B",4,150,58);
         this.itemsDB_local[956] = new Array(956,"Mayhem Battery III",143,43243,"topWeapon","explosive",30,0,0,0,0,0,0,0,10,54,21,2,34,0,0,0,0,3,0,3,4,0,0,0,0,0,0,26,0,21000,9999,"rocketBarrage1","rocketLauncher25C",3,150,65);
         this.itemsDB_local[957] = new Array(957,"Physical Orb Cannon",111,43211,"topWeapon","physical",30,0,0,0,0,0,0,0,0,50,10,1,0,0,0,-1,3,0,0,3,3,0,0,0,0,0,0,8,8,21000,9999,"orbOrange1","blaster19A",3,250,54);
         this.itemsDB_local[958] = new Array(958,"Metal Sticks",1,13451,"leg","leg",34,0,0,0,0,0,0,0,0,70,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,32850,9999,"stomp1","leg29",0,150,44);
         this.itemsDB_local[959] = new Array(959,"Flame Boots",102,13252,"leg","leg",31,36,0,0,0,0,0,0,0,40,0,2,54,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,65700,9999,"stomp2","leg30B",4,150,71);
         this.itemsDB_local[960] = new Array(960,"Rino Boots",101,13251,"leg","leg",31,36,0,0,0,0,0,0,0,80,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,65700,9999,"stomp1","leg30A",4,150,56);
         this.itemsDB_local[961] = new Array(961,"Thunder Boots",103,13253,"leg","leg",31,36,0,0,0,0,0,0,0,37,0,3,0,54,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,65700,9999,"stomp3","leg30C",4,150,76);
         this.itemsDB_local[962] = new Array(962,"Volcano Chargers Mark II",1,13452,"leg","leg",30,100,0,0,0,0,0,0,0,150,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,32850,9999,"stomp1","leg28",4,150,91);
         this.itemsDB_local[963] = new Array(963,"Platinum Skeleton II",102,113202,"module","armor",30,84,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,70,9999,"","module_HP12",3,250,29);
         this.itemsDB_local[964] = new Array(964,"Titanium Skeleton I",101,113201,"module","armor",30,78,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13500,9999,"","module_HP11",3,250,27);
         this.itemsDB_local[965] = new Array(965,"Platinum Skeleton III",103,113203,"module","armor",30,90,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13500,9999,"","module_HP13",3,250,31);
         this.itemsDB_local[966] = new Array(966,"Mega Rocket Storage I",171,113271,"module","ammo",30,0,0,0,0,0,0,0,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14000,9999,"","module_rockets11",3,60,45);
         this.itemsDB_local[967] = new Array(967,"Mega Rocket Storage II",172,113272,"module","ammo",30,0,0,0,0,0,0,0,70,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14000,9999,"","module_rockets12",3,250,48);
         this.itemsDB_local[968] = new Array(968,"Mega Bullet Storage I",161,113261,"module","ammo",30,0,0,0,0,0,0,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13500,9999,"","module_bullets11",3,58,45);
         this.itemsDB_local[969] = new Array(969,"Mega Bullet Storage II",162,113262,"module","ammo",30,0,0,0,0,0,0,70,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13500,9999,"","module_bullets12",3,250,48);
         this.itemsDB_local[970] = new Array(970,"Energy Generator I",111,113211,"module","energyHeat",30,0,0,35,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13000,9999,"","module_energy11",3,56,43);
         this.itemsDB_local[971] = new Array(971,"Energy Generator II",112,113212,"module","energyHeat",30,0,0,38,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13000,9999,"","module_energy12",3,250,46);
         this.itemsDB_local[972] = new Array(972,"Energy Generator III",2,113502,"module","energyHeat",30,0,0,45,24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13000,9999,"","module_energy13",3,150,48);
         this.itemsDB_local[973] = new Array(973,"Heat Module 11",0,112700,"module","energyHeat",27,0,0,0,0,35,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9000,0,"","module_heat11",0,42,50);
         this.itemsDB_local[974] = new Array(974,"Engine Booster I",131,113231,"module","energyHeat",30,0,0,0,0,40,21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9500,9999,"","module_heat12",3,42,49);
         this.itemsDB_local[975] = new Array(975,"Engine Booster II",132,113232,"module","energyHeat",30,0,0,0,0,43,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9500,9999,"","module_heat13",3,250,52);
         this.itemsDB_local[976] = new Array(976,"Combiner Storage Mark A-1",181,113281,"module","ammo",30,0,0,0,0,0,0,25,70,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9999999,9999,"","module_bulletsRockets_8_5",3,250,65);
         this.itemsDB_local[977] = new Array(977,"Maximum Bullet Storage",3,113403,"module","ammo",30,0,0,0,0,0,0,300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,28000,9999,"","module_bullets15",6,250,100);
         this.itemsDB_local[978] = new Array(978,"Maximum Rocket Storage",3,113404,"module","ammo",30,0,0,0,0,0,0,0,300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,28000,9999,"","module_rockets15",6,250,100);
         this.itemsDB_local[980] = new Array(980,"Needle Blaster Mark I",111,33211,"sideWeapon","physical",31,0,0,0,0,0,0,15,0,75,10,1,0,0,0,0,3,0,0,1,3,0,0,0,0,0,0,0,0,21000,9999,"machineGun1","machineGun11A",4,200,69);
         this.itemsDB_local[981] = new Array(981,"Steel Tractors",111,13261,"leg","leg",31,35,0,0,0,0,0,0,0,60,0,1,0,0,0,1,0,0,0,0,1,3,0,0,0,0,0,0,0,32850,9999,"stomp1","wheels8A",4,250,59);
         this.itemsDB_local[982] = new Array(982,"Burning Tractors",112,13262,"leg","leg",31,35,0,0,0,0,0,0,0,28,0,2,45,0,0,1,0,0,0,0,1,3,0,0,0,0,0,0,0,32850,9999,"stomp2","wheels8B",4,250,72);
         this.itemsDB_local[983] = new Array(983,"Lightning Tractors",113,13263,"leg","leg",31,35,0,0,0,0,0,0,0,28,0,3,0,45,0,1,0,0,0,0,1,3,0,0,0,0,0,0,0,32850,9999,"stomp3","wheels8C",4,250,72);
         this.itemsDB_local[984] = new Array(984,"Lava",1,33207,"sideWeapon","explosive",32,0,0,0,0,0,0,0,0,41,16,2,21,0,0,0,0,0,0,2,2,0,0,0,0,0,0,13,0,21000,9999,"beamRed1","blaster11A",0,150,48);
         this.itemsDB_local[985] = new Array(985,"Lava",1,33301,"sideWeapon","explosive",33,0,0,0,0,0,0,0,0,43,18,2,22,0,0,0,0,0,0,2,2,0,0,0,0,0,0,13,0,21000,9999,"beamRed1","blaster11B",0,150,51);
         this.itemsDB_local[986] = new Array(986,"Flaminator",1,33208,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,65,15,2,40,0,0,0,0,0,0,1,3,0,0,0,0,0,0,0,27,21000,9999,"heat3","sideEnergyHeatBlaster2D",6,150,57);
         this.itemsDB_local[987] = new Array(987,"Hot Flash",1,33401,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,50,25,3,0,47,0,0,0,0,0,1,3,0,0,0,0,0,0,30,0,21000,9999,"laser3","sideEnergyHeatBlaster3D",6,150,60);
         this.itemsDB_local[988] = new Array(988,"Heat Orb Cannon",121,43221,"topWeapon","explosive",30,0,0,0,0,0,0,0,0,40,10,2,26,0,0,-1,0,2,0,3,3,0,0,0,0,0,0,15,5,21000,9999,"orbRed1","blaster20A",6,150,55);
         this.itemsDB_local[989] = new Array(989,"Adv. Electric Orb Cannon",132,43232,"topWeapon","electric",30,0,0,0,0,0,0,0,0,42,12,3,0,28,0,-1,0,0,2,3,3,0,0,0,0,0,0,6,16,21000,99999,"orbBlue1","blaster18B",3,250,57);
         this.itemsDB_local[990] = new Array(990,"Adv. Physical Orb Cannon",112,43212,"topWeapon","physical",30,0,0,0,0,0,0,0,0,55,15,1,0,0,0,-1,3,0,0,3,3,0,0,0,0,0,0,8,8,21000,9999,"orbOrange1","blaster19B",3,250,56);
         this.itemsDB_local[991] = new Array(991,"Adv. Heat Orb Cannon",122,43222,"topWeapon","explosive",30,0,0,0,0,0,0,0,0,42,12,2,28,0,0,-1,0,2,0,3,3,0,0,0,0,0,0,16,6,21000,9999,"orbRed1","blaster20B",3,250,57);
         this.itemsDB_local[992] = new Array(992,"Xray",1,43201,"topWeapon","electric",32,0,0,0,0,0,0,0,0,12,0,3,0,12,0,0,0,0,10,3,3,0,0,0,0,0,0,11,0,21000,9999,"beamRoundBlue1","blaster18A",0,150,71);
         this.itemsDB_local[993] = new Array(993,"Wipeout Mark II",102,43202,"topWeapon","physical",30,0,0,0,0,0,0,10,0,75,40,1,0,0,0,0,3,0,0,4,2,0,0,0,0,0,0,13,0,21000,9999,"bulletCharge1","cannon7B",3,150,49);
         this.itemsDB_local[994] = new Array(994,"Wipeout Mark I",101,43203,"topWeapon","physical",15,0,0,0,0,0,0,10,0,60,30,1,0,0,0,0,3,0,0,4,2,0,0,0,0,0,0,13,0,21000,90,"bulletCharge1","cannon7A",2,150,49);
         this.itemsDB_local[995] = new Array(995,"Wipeout Mark III",103,43204,"topWeapon","physical",30,0,0,0,0,0,0,10,0,175,75,1,0,0,0,0,4,0,0,4,2,0,0,0,0,0,0,13,0,21000,9999,"bulletCharge1","cannon7C",4,150,55);
         this.itemsDB_local[1001] = new Array(1001,"Needle Blaster Mark II",112,33212,"sideWeapon","physical",31,0,0,0,0,0,0,15,0,80,10,1,0,0,0,0,3,0,0,1,3,0,0,0,0,0,0,0,0,21000,9999,"machineGun1","machineGun11B",4,200,71);
         this.itemsDB_local[1002] = new Array(1002,"Unbreakable Diamond Mark I",5,33209,"sideWeapon","physical",15,0,0,0,0,0,0,0,0,15,0,1,0,0,0,0,5,0,0,0,3,0,0,0,0,0,0,0,0,15000,0,"bullet2","cannon8A2",1,100,50);
         this.itemsDB_local[1003] = new Array(1003,"Tesla Purge Mark I",5,33210,"sideWeapon","electric",15,0,0,0,0,0,0,0,0,10,0,3,0,25,0,0,0,0,5,0,3,0,0,0,0,0,0,0,5,15000,0,"laser3","cannon8A3",1,100,50);
         this.itemsDB_local[1004] = new Array(1004,"Explosion Negator I",1,112701,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,9000,0,"","module_resistanceExplosive11",3,250,24);
         this.itemsDB_local[1005] = new Array(1005,"Explosion Negator II",1,112901,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,0,0,0,0,0,0,0,0,0,0,0,9250,0,"","module_resistanceExplosive12",3,250,27);
         this.itemsDB_local[1006] = new Array(1006,"Explosion Negator IV",1,113301,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,19,0,0,0,0,0,0,0,0,0,0,0,11500,9999,"","module_resistanceExplosive14",3,250,33);
         this.itemsDB_local[1007] = new Array(1007,"Explosion Negator III",1,113204,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,0,0,0,0,0,0,0,0,0,0,0,11500,9999,"","module_resistanceExplosive13",3,250,30);
         this.itemsDB_local[1008] = new Array(1008,"Electron Negator V",1,113501,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,11500,9999,"","module_resistanceElectric15",3,250,36);
         this.itemsDB_local[1009] = new Array(1009,"Physical Negator V",1,113503,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,0,11500,9999,"","module_resistancePhysical15",3,250,36);
         this.itemsDB_local[1010] = new Array(1010,"Explosion Negator V",1,113504,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,11500,9999,"","module_resistanceExplosive15",3,250,36);
         this.itemsDB_local[1011] = new Array(1011,"Electron Negator I",1,112706,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,9000,0,"","module_resistanceElectric11",3,250,24);
         this.itemsDB_local[1012] = new Array(1012,"Electron Negator II",1,112904,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,0,0,0,0,0,0,0,0,0,0,9250,0,"","module_resistanceElectric12",3,250,27);
         this.itemsDB_local[1013] = new Array(1013,"Electron Negator III",1,113205,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,0,0,0,0,0,0,0,0,0,0,11500,9999,"","module_resistanceElectric13",3,250,30);
         this.itemsDB_local[1014] = new Array(1014,"Electron Negator IV",1,113302,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,19,0,0,0,0,0,0,0,0,0,0,11500,9999,"","module_resistanceElectric14",3,250,33);
         this.itemsDB_local[1015] = new Array(1015,"Physical Negator I",1,112707,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,9000,0,"","module_resistancePhysical11",3,250,24);
         this.itemsDB_local[1016] = new Array(1016,"Physical Negator II",1,112905,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,0,0,0,0,0,0,0,0,0,0,0,0,9250,0,"","module_resistancePhysical12",3,250,27);
         this.itemsDB_local[1017] = new Array(1017,"Physical Negator III",1,113206,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,0,0,0,0,0,0,0,0,0,0,0,0,11500,9999,"","module_resistancePhysical13",3,250,30);
         this.itemsDB_local[1018] = new Array(1018,"Physical Negator IV",1,113303,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,19,0,0,0,0,0,0,0,0,0,0,0,0,11500,9999,"","module_resistancePhysical14",3,250,33);
         this.itemsDB_local[1019] = new Array(1019,"Invulnerability Mark I",181,113282,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,11,11,0,0,0,0,0,0,0,0,0,0,12000,9999,"","module_resistanceAll11",3,250,46);
         this.itemsDB_local[1020] = new Array(1020,"Invulnerability Mark IV",4,113405,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14,14,14,0,0,0,0,0,0,0,0,0,0,14000,9999,"","module_resistanceAll14",3,250,61);
         this.itemsDB_local[1021] = new Array(1021,"Invulnerability Mark III",4,113406,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13,13,13,0,0,0,0,0,0,0,0,0,0,12000,9999,"","module_resistanceAll13",3,250,56);
         this.itemsDB_local[1022] = new Array(1022,"Invulnerability Mark II",182,113283,"module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,12,12,0,0,0,0,0,0,0,0,0,0,14000,9999,"","module_resistanceAll12",3,250,51);
         this.itemsDB_local[1023] = new Array(1023,"Master Repair Kit 8",3,123203,"kit","repair",32,156,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,4,"","kit_HP15",2,15,0);
         this.itemsDB_local[1024] = new Array(1024,"Master Repair Kit 9",3,123303,"kit","repair",33,168,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,4,"","kit_HP16",2,15,0);
         this.itemsDB_local[1025] = new Array(1025,"Master Repair Kit 10",3,123503,"kit","repair",35,180,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1450,4,"","kit_HP17",2,15,0);
         this.itemsDB_local[1026] = new Array(1026,"Lightning Gate Mark I",1,73101,"teleport","teleport",30,0,0,0,0,0,0,0,0,35,10,3,0,34,2,0,0,0,0,0,1,0,0,0,0,0,0,0,40,21350,9999,"","teleport8",3,250,25);
         this.itemsDB_local[1027] = new Array(1027,"Field Control Mark I",1,73401,"teleport","teleport",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,20,21350,9999,"","teleport8",6,150,31);
         this.itemsDB_local[1028] = new Array(1028,"Fire Tail Mark I",101,83201,"charge","charge",31,0,0,0,0,0,0,0,0,40,0,1,0,0,2,1,0,0,0,1,999,0,0,0,0,0,0,25,15,21350,9999,"","charge8",4,250,19);
         this.itemsDB_local[1029] = new Array(1029,"Bull Charger",1,83401,"charge","charge",30,0,0,0,0,0,0,0,0,15,0,1,0,0,0,1,0,0,0,1,999,0,0,0,0,0,0,33,11,0,9999,"","charge8",6,150,20);
         this.itemsDB_local[1030] = new Array(1030,"Adv. Energy Shield Mark 14",3,63203,"shield","shield",32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,2,55,0,0,18125,90,"","shield8A",2,150,53);
         this.itemsDB_local[1031] = new Array(1031,"Adv. Heat Shield Mark 14",4,63204,"shield","shield",32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,2,55,0,0,18125,90,"","shield8B",2,150,53);
         this.itemsDB_local[1032] = new Array(1032,"Adv. Energy Shield Mark 15",3,63403,"shield","shield",34,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,2,60,0,0,18125,90,"","shield9A",2,150,57);
         this.itemsDB_local[1033] = new Array(1033,"Adv. Heat Shield Mark 15",4,63404,"shield","shield",34,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,2,60,0,0,1010,90,"","shield9B",2,150,57);
         this.itemsDB_local[1034] = new Array(1034,"Ultra Power Kit V",4,123535,"kit","power",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,85,22500,15,"","kit_powerB14",2,10000,0);
         this.itemsDB_local[1037] = new Array(1037,"Electric Orb Cannon",131,43231,"topWeapon","electric",30,0,0,0,0,0,0,0,0,40,10,3,0,26,0,-1,0,0,2,3,3,0,0,0,0,0,0,5,15,35000,9999,"orbBlue1","blaster18A",3,250,55);
         this.itemsDB_local[1038] = new Array(1038,"Backstabber Mark I",151,43251,"topWeapon","explosive",30,0,0,0,0,0,0,0,15,60,27,2,35,0,0,-1,0,2,0,3,4,0,0,0,0,0,0,20,5,50000,9999,"artilleryDiagonal1","rocketLauncher28A",3,250,71);
         this.itemsDB_local[1041] = new Array(1041,"Rear Hit Heat Mark",0,43000,"topWeapon","explosive",30,0,0,0,0,0,0,0,0,50,10,2,22,0,0,-1,0,2,0,3,3,0,0,0,0,0,0,15,0,999999,0,"grenadePull2","grenadeLauncher1B",3,50,59);
         this.itemsDB_local[1042] = new Array(1042,"Rear Hit Electro Mark",0,43011,"topWeapon","electric",30,0,0,0,0,0,0,0,0,50,10,3,0,22,0,-1,0,0,2,3,3,0,0,0,0,0,0,5,10,9999999,0,"grenadePull3","grenadeLauncher1B2",3,50,59);
         this.itemsDB_local[1043] = new Array(1043,"Death Punch Mark I",131,33231,"sideWeapon","explosive",30,0,0,0,0,0,0,0,30,90,50,2,52,0,1,1,0,5,0,3,3,0,0,0,0,0,0,15,5,50000,9999,"rocketBarrage2","blaster16A",3,250,61);
         this.itemsDB_local[1044] = new Array(1044,"Death Punch Mark II",132,33232,"sideWeapon","explosive",30,0,0,0,0,0,0,0,30,96,50,2,54,0,1,1,0,5,0,3,3,0,0,0,0,0,0,15,5,50000,9999,"rocketBarrage2","blaster16B",3,250,63);
         this.itemsDB_local[1045] = new Array(1045,"Shock Biter",121,93221,"harpoon","harpoon",30,0,0,0,0,0,0,0,0,75,10,3,0,31,2,0,0,0,0,1,5,0,0,0,0,0,0,10,15,999999,99999,"","harpoon6D",4,250,28);
         this.itemsDB_local[1046] = new Array(1046,"Flame Biter",111,93211,"harpoon","harpoon",30,0,0,0,0,0,0,0,0,75,10,2,31,0,2,0,0,0,0,1,5,0,0,0,0,0,0,15,10,50000,9999,"","harpoon6C",4,150,28);
         this.itemsDB_local[1047] = new Array(1047,"Rock Biter",101,93201,"harpoon","harpoon",30,0,0,0,0,0,0,0,0,80,15,1,0,0,2,0,0,0,0,1,6,0,0,0,0,0,0,10,10,555555,9999,"","harpoon6A",4,250,23);
         this.itemsDB_local[1048] = new Array(1048,"Backstabber Mark II",152,43252,"topWeapon","explosive",30,0,0,0,0,0,0,0,15,65,36,2,37,0,0,-1,0,3,0,3,4,0,0,0,0,0,0,24,6,999999,99999,"artilleryDiagonal1","rocketLauncher28B",3,250,80);
         this.itemsDB_local[1049] = new Array(1049,"Evil Spark",121,53221,"drone","drone",31,0,0,0,0,0,0,0,0,30,12,3,0,23,0,0,0,0,0,0,999,0,0,0,0,0,0,0,20,9999999,9999,"laser1","drone34",4,250,36);
         this.itemsDB_local[1050] = new Array(1050,"Sector Eye",111,53211,"drone","drone",31,0,0,0,0,0,0,0,5,40,0,2,25,0,0,0,0,0,0,0,999,0,0,0,0,0,0,14,0,999999,99999,"rocketBarrage3","drone35",4,250,37);
         this.itemsDB_local[1051] = new Array(1051,"Electricon Mark I",135,53235,"drone","drone",31,0,0,0,0,0,0,5,0,30,12,3,0,23,0,0,0,0,0,0,999,0,0,0,0,0,0,5,0,0,9999,"laser1","drone36B",4,250,45);
         this.itemsDB_local[1052] = new Array(1052,"Ultra Power Kit",6,123636,"kit","power",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,350,100000,30,"","kit_powerB15",2,50000,0);
         this.itemsDB_local[1053] = new Array(1053,"Red Rain Mark I",161,43261,"topWeapon","explosive",30,0,0,0,0,0,0,0,15,60,27,2,35,0,0,-1,0,2,0,2,4,0,0,0,0,0,0,20,5,0,9999,"artilleryDiagonal1","rocketLauncher26A",3,250,71);
         this.itemsDB_local[1056] = new Array(1056,"Heat Penetrator Mark I",0,43012,"topWeapon","explosive",30,0,0,0,0,0,0,0,0,40,30,2,30,0,0,1,0,0,0,3,3,0,0,0,0,0,0,20,5,99999999,150,"beamRed1","laser40A2",3,140,58,3,0,0,0);
         this.itemsDB_local[1057] = new Array(1057,"Energy Penetrator Mark I",0,43013,"topWeapon","electric",30,0,0,0,0,0,0,0,0,40,30,3,0,30,0,1,0,0,0,3,3,0,0,0,0,0,0,10,15,99999,9999,"beamBlue1","laser40A3",3,150,58,0,0,3,0);
         this.itemsDB_local[1189] = new Array(1189,"USA Mark II",106,13206,"torso","torso",30,600,0,180,70,190,60,0,0,0,0,0,0,0,0,0,6,4,4,0,0,0,0,0,0,0,0,0,0,99999999,9999,"null","torso50",4,250,380,0,0,0,0,4,3,3,0,2);
         this.itemsDB_local[1059] = new Array(1059,"USA Transporter",121,13271,"leg","leg",30,60,0,0,0,0,0,0,0,40,40,2,25,0,0,1,0,0,0,0,1,3,0,0,0,0,0,0,0,99999999,9999,"stomp2","wheels9",4,250,68);
         this.itemsDB_local[1060] = new Array(1060,"Yoshimo Blade V2",105,33213,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,75,0,3,0,60,0,0,0,0,4,0,4,0,0,0,0,0,0,12,22,9999999,9999,"sword3","sword8",4,250,61,0,0,0,0,0,0,2,0,0,0);
         this.itemsDB_local[1061] = new Array(1061,"Yoshimo X V2",107,13207,"torso","torso",30,600,0,140,30,110,45,0,0,0,0,0,0,0,0,0,4,7,4,0,0,0,0,0,0,0,0,0,0,9999999,9999,"null","torso51",4,250,380,0,0,0,0,2,2,5,0,3);
         this.itemsDB_local[1062] = new Array(1062,"Yoshimo Legs V2",131,13281,"leg","leg",30,50,0,0,0,0,0,0,0,40,0,3,0,25,0,1,0,0,0,0,1,3,0,0,0,0,0,0,0,385,9999,"stomp3","leg31",4,250,68);
         this.itemsDB_local[1063] = new Array(1063,"Heat Desolver Mark II",0,33000,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,65,10,2,22,0,0,0,0,0,0,2,2,0,0,0,0,0,0,22,0,99999,270,"heat3","laser48B3",3,150,62,6,0,0,0);
         this.itemsDB_local[1064] = new Array(1064,"Energy Desolver Mark II",0,33023,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,65,10,3,0,22,0,0,0,0,0,2,2,0,0,0,0,0,0,0,22,99999,270,"laser3","laser48B2",3,150,62,0,0,6,0);
         this.itemsDB_local[1066] = new Array(1066,"Energy & Heat Booster I",151,113251,"module","energyHeat",30,0,0,22,11,22,11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9999999,9999,"null","module_energyHeat11",3,250,53);
         this.itemsDB_local[1067] = new Array(1067,"Energy & Heat Booster II",152,113252,"module","energyHeat",30,0,0,24,12,24,12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,999999,9999,"null","module_energyHeat12",3,250,58);
         this.itemsDB_local[1070] = new Array(1070,"Super Nova Mark I",133,43233,"topWeapon","electric",31,0,0,0,0,0,0,0,0,50,36,3,0,90,1,1,0,0,5,3,3,0,0,0,0,0,0,5,35,3040,9999,"beamRoundBlue2","blaster21A",4,250,60);
         this.itemsDB_local[1071] = new Array(1071,"Electron Field Mark I",121,113221,"module","energyHeat",30,0,0,8,36,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,99999,9999,"null","module_energy101",3,250,43);
         this.itemsDB_local[1072] = new Array(1072,"Heat Control Mark I",141,113241,"module","energyHeat",30,0,0,0,0,8,36,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,99999,9999,"null","module_heat101",3,250,43);
         this.itemsDB_local[1073] = new Array(1073,"Engine Breaker Mark I",174,43274,"topWeapon","explosive",30,0,0,0,0,0,0,0,0,60,35,2,10,0,2,-1,0,0,0,2,2,0,0,0,0,0,0,25,10,999999,9999,"shockWaveRed1","cannon11A1",3,250,57,25,0,0,0,0,0,0,0,0,-1);
         this.itemsDB_local[1077] = new Array(1077,"Repair Drone Mark I",101,53201,"drone","drone",30,0,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,10,0,9999999,9999,"repair1","drone37A",3,250,35);
         this.itemsDB_local[1078] = new Array(1078,"Super Nova Mark II",0,43016,"topWeapon","electric",30,0,0,0,0,0,0,0,0,52,38,3,0,96,1,1,0,0,5,3,3,0,0,0,0,0,0,5,36,9999999,9999,"beamRoundBlue2","blaster21B",3,250,62);
         this.itemsDB_local[1079] = new Array(1079,"Mass Deflector",104,33214,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,66,40,1,0,0,0,5,3,0,0,0,1,0,0,0,0,0,0,10,20,999999,9999,"sword1","sword7D",4,250,56);
         this.itemsDB_local[1080] = new Array(1080,"Energy Generator III",113,113213,"module","energyHeat",30,0,0,41,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9999999,9999,"null","module_energy13",3,250,49);
         this.itemsDB_local[1081] = new Array(1081,"FireWall",141,33241,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,50,10,2,17,0,0,2,0,0,0,1,3,0,0,0,0,0,0,15,0,999999,9999,"heat2","blaster17",3,250,51);
         this.itemsDB_local[1082] = new Array(1082,"Engine Booster III",133,113233,"module","energyHeat",30,0,0,0,0,46,23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9999999,9999,"null","module_heat14",3,250,55);
         this.itemsDB_local[1083] = new Array(1083,"Regeneration Blocker Mark III",157,33257,"sideWeapon","electric",30,0,0,0,0,0,0,20,0,80,60,3,0,25,1,0,0,0,0,3,3,0,0,0,0,0,0,15,15,999999,9999,"laser3","cannon10C3",4,250,71,10,10);
         this.itemsDB_local[1085] = new Array(1085,"Devastation Swarm Mark I",174,33274,"sideWeapon","explosive",15,0,0,0,0,0,0,0,15,55,20,2,22,0,0,0,0,0,0,1,3,0,0,0,0,0,0,10,0,9999999,99,"rocketBarrage1","rocketLauncher29A1",2,250,61);
         this.itemsDB_local[1086] = new Array(1086,"Mega Rocket Storage III",173,113273,"module","ammo",30,0,0,0,0,0,0,0,80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9999999,9999,"null","module_rockets13",3,250,55);
         this.itemsDB_local[1087] = new Array(1087,"Cooldown Blocker Mark III",154,33254,"sideWeapon","explosive",30,0,0,0,0,0,0,20,0,80,60,2,25,0,1,0,0,0,0,3,3,0,0,0,0,0,0,15,15,9999999,9999,"heat3","cannon10C2",4,250,71,0,0,10,10);
         this.itemsDB_local[1088] = new Array(1088,"Armor Breaker Mark III",151,33251,"sideWeapon","physical",30,0,0,0,0,0,0,25,0,100,75,1,0,0,1,1,6,0,0,3,3,0,0,0,0,0,0,15,15,9999999,9999,"bullet3","cannon10C",4,250,49);
         this.itemsDB_local[1089] = new Array(1089,"Electric Discharger Mark I",171,43271,"topWeapon","physical",30,0,0,0,0,0,0,10,0,60,50,1,0,0,2,-1,0,0,0,2,2,0,0,0,0,0,0,15,5,9999999,9999,"shockWaveOrange1","cannon11C1",3,250,56,0,0,0,0,0,0,0,0,0,-1);
         this.itemsDB_local[1090] = new Array(1090,"Brutality",100,13685,"torso","torso",30,750,0,150,50,250,100,0,0,0,0,0,0,0,0,0,15,15,15,0,0,0,0,0,0,0,0,0,0,9999999,9999,"","torso52",4,250,350,0,0,0,0,3,5,3,0,4);
         this.itemsDB_local[1094] = new Array(1094,"Electron Field Mark II",122,113222,"module","energyHeat",30,0,0,7,38,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,99999,9999,"null","module_energy102",3,250,44);
         this.itemsDB_local[1095] = new Array(1095,"Generator Breaker Mark I",177,43277,"topWeapon","electric",30,0,0,0,0,0,0,0,0,60,35,3,0,10,2,-1,0,0,0,2,2,0,0,0,0,0,0,10,25,9999999,9999,"shockWaveBlue1","cannon11B1",3,250,57,0,0,25,0,0,0,0,0,0,-1);
         this.itemsDB_local[1096] = new Array(1096,"Heat Control Mark II",142,113242,"module","energyHeat",30,0,0,0,0,7,38,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,99999999,9999,"null","module_heat102",3,250,44);
         this.itemsDB_local[1097] = new Array(1097,"Electric Storm Mark I",178,33278,"sideWeapon","electric",15,0,0,0,0,0,0,0,15,55,20,3,0,22,0,0,0,0,0,1,3,0,0,0,0,0,0,10,0,9999999,99,"rocketBarrage1","rocketLauncher29A3",2,250,61);
         this.itemsDB_local[1098] = new Array(1098,"Military Grade Combiner Storage",186,113286,"module","ammo",30,0,0,0,0,0,0,100,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9999999,9999,"null","module_bulletsRockets_8_8",4,250,65);
         this.itemsDB_local[1099] = new Array(1099,"Metal Shredder Mark I",161,33261,"sideWeapon","physical",30,0,0,0,0,0,0,0,15,60,45,1,0,0,0,0,3,0,0,1,3,0,0,0,0,0,0,15,0,9999999,99,"rocketBarrage1","rocketLauncher29A2",2,250,60);
         this.itemsDB_local[1100] = new Array(1100,"Heat Eruptor Mark I",131,53231,"drone","drone",31,0,0,0,0,0,0,5,0,30,12,2,23,0,0,0,0,0,0,0,999,0,0,0,0,0,0,10,0,99999999,9999,"heat1","drone36C",4,250,45);
         this.itemsDB_local[1101] = new Array(1101,"Combiner Storage Mark A-II",182,113284,"module","ammo",30,0,0,0,0,0,0,40,70,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,999999,9999,"null","module_bulletsRockets_8_6",3,250,75);
         this.itemsDB_local[1102] = new Array(1102,"Combiner Storage Mark A-III",183,113285,"module","ammo",30,0,0,0,0,0,0,55,70,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9999999,9999,"","module_bulletsRockets_8_7",3,250,85);
         this.itemsDB_local[1104] = new Array(1104,"Combiner Storage Mark B-II",187,113287,"module","ammo",30,0,0,0,0,0,0,70,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,99999999,9999,"null","module_bulletsRockets_6_8",3,250,75);
         this.itemsDB_local[1106] = new Array(1106,"FireWatch Mark I",0,43100,"topWeapon","explosive",15,0,0,0,0,0,0,0,0,5,5,2,15,0,1,0,0,12,0,3,4,0,0,0,0,0,0,35,0,99999999,90,"specialExplosive1","blaster22A",2,250,49);
         this.itemsDB_local[1110] = new Array(1110,"ElectroCop Mark I",161,43262,"topWeapon","electric",30,0,0,0,0,0,0,0,0,5,5,3,0,15,1,0,0,0,12,3,4,0,0,0,0,0,0,10,15,9999999,90,"specialElectric1","blaster24A",2,250,58);
         this.itemsDB_local[1117] = new Array(1117,"Stinger Mark I",181,43281,"topWeapon","explosive",30,0,0,0,0,0,0,0,0,55,10,2,20,0,0,0,0,1,0,5,4,0,0,0,0,0,0,25,0,99999999,9999,"heat1","cannon8A",3,250,41);
         this.itemsDB_local[1122] = new Array(1122,"Sector Eyes",0,53400,"drone","drone",34,0,0,0,0,0,0,0,5,41,0,2,26,0,0,0,0,0,0,0,999,0,0,0,0,0,0,10,15,99999999,9999,"rocketBarrage3","drone35B",10,250,39);
         this.itemsDB_local[1123] = new Array(1123,"Evil Flame",126,53226,"drone","drone",31,0,0,0,0,0,0,0,0,30,12,2,23,0,0,0,0,0,0,0,999,0,0,0,0,0,0,20,0,9999999,9999,"heat1","drone34B",4,250,36);
         this.itemsDB_local[1124] = new Array(1124,"Lightning Shell",7,13013,"torso","torso",30,380,0,180,5,80,30,0,0,0,0,0,0,0,0,0,0,0,24,0,0,0,0,0,0,0,0,0,0,9999999,9999,"","torso57B",3,250,375,0,0,0,0,0,0,10,0,3);
         this.itemsDB_local[1125] = new Array(1125,"Lava Shell",7,13012,"torso","torso",30,380,0,80,30,180,5,0,0,0,0,0,0,0,0,0,0,24,0,0,0,0,0,0,0,0,0,0,0,9999999,9999,"","torso57A",3,250,375,0,0,0,0,0,10,0,0,3);
         this.itemsDB_local[1126] = new Array(1126,"Green Tea",5,33025,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,44,16,3,0,55,0,0,0,0,0,0,2,0,0,0,0,0,0,10,35,21000,270,"flame3","flameThrower9C1",6,150,45);
         this.itemsDB_local[1127] = new Array(1127,"Grape Soda",5,33023,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,44,16,2,55,0,0,0,0,0,0,0,2,0,0,0,0,0,0,35,10,21000,270,"flame4","flameThrower9D1",6,150,45);
         this.itemsDB_local[1128] = new Array(1128,"Smiley",7,13014,"torso","torso",30,600,0,100,50,100,50,0,0,0,0,0,0,0,0,0,8,8,8,0,0,0,0,0,0,0,0,0,0,9999999,9999,"","torso55",6,250,410,0,0,0,0,4,3,3,0,4);
         this.itemsDB_local[1129] = new Array(1129,"Barhatniye Tyagi",1,13059,"leg","leg",30,80,0,0,0,0,0,0,0,50,0,1,0,0,0,1,0,0,0,0,1,2,3,0,0,0,0,0,0,22650,162,"stomp1","leg35",6,250,83);
         this.itemsDB_local[1130] = new Array(1130,"Right Hand",3,33005,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,80,0,2,40,0,0,0,0,4,0,0,1,0,0,0,0,0,0,0,0,20250,0,"sword2","hand1A",6,135,69);
         this.itemsDB_local[1131] = new Array(1131,"Left Hand",3,33006,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,80,0,3,0,40,0,0,0,0,4,0,1,0,0,0,0,0,0,0,0,20250,0,"sword2","hand1B",6,135,69);
         this.itemsDB_local[1132] = new Array(1132,"Repair Drone Mark II",1,53002,"drone","drone",30,0,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,12,0,9999999,9999,"repair1","drone37B",3,250,36);
         this.itemsDB_local[1133] = new Array(1133,"Steel Melter Mark I",0,43013,"topWeapon","explosive",30,0,0,0,0,0,0,0,15,45,27,2,40,0,0,-2,0,3,0,2,5,0,0,0,0,0,0,22,6,50000,9999,"artilleryDiagonal1","rocketLauncher27A",3,250,73);
         this.itemsDB_local[1134] = new Array(1134,"Steel Melter Mark II",0,43014,"topWeapon","explosive",30,0,0,0,0,0,0,0,15,45,27,2,45,0,0,-2,0,5,0,2,5,0,0,0,0,0,0,23,6,50000,9999,"artilleryDiagonal1","rocketLauncher27B",3,250,78);
         this.itemsDB_local[1135] = new Array(1135,"Storm Artillery Mark II",0,43015,"topWeapon","electric",30,0,0,0,0,0,0,0,15,45,27,3,0,45,0,-2,0,0,5,2,5,0,0,0,0,0,0,6,23,50000,9999,"artilleryDiagonal1","rocketLauncher27B",3,250,78);
         this.itemsDB_local[1136] = new Array(1136,"Storm Artillery Mark I",0,43014,"topWeapon","electric",30,0,0,0,0,0,0,0,15,45,27,3,0,40,0,-2,0,0,3,2,5,0,0,0,0,0,0,6,22,50000,9999,"artilleryDiagonal1","rocketLauncher27A",3,250,73);
         this.itemsDB_local[1137] = new Array(1137,"Steel Biter",1,93003,"harpoon","harpoon",30,0,0,0,0,0,0,0,0,50,15,1,0,0,2,0,0,0,0,1,6,0,0,0,0,0,0,15,15,555555,9999,"","harpoon6B",3,250,25);
         this.itemsDB_local[1138] = new Array(1138,"Rock Disintegrator",1,93004,"harpoon","harpoon",30,0,0,0,0,0,0,0,0,50,15,1,0,0,3,0,0,0,0,1,999,0,0,0,0,0,0,20,20,555555,9999,"","harpoon5A",3,250,28);
         this.itemsDB_local[1139] = new Array(1139,"Steel Disintegrator",1,93005,"harpoon","harpoon",30,0,0,0,0,0,0,0,0,60,15,1,0,0,3,0,0,0,0,1,999,0,0,0,0,0,0,20,20,555555,9999,"","harpoon5B",3,250,30);
         this.itemsDB_local[1140] = new Array(1140,"Flame Disintegrator",1,93006,"harpoon","harpoon",30,0,0,0,0,0,0,0,0,25,10,2,31,0,3,0,0,0,0,1,999,0,0,0,0,0,0,20,10,50000,9999,"","harpoon5C",3,150,30);
         this.itemsDB_local[1141] = new Array(1141,"Shock Disintegrator",1,93007,"harpoon","harpoon",30,0,0,0,0,0,0,0,0,25,10,3,0,31,3,0,0,0,0,1,999,0,0,0,0,0,0,10,20,999999,99999,"","harpoon5D",3,250,30);
         this.itemsDB_local[1142] = new Array(1142,"Metal Shredder Mark II",5,33023,"sideWeapon","physical",30,0,0,0,0,0,0,0,15,65,45,1,0,0,0,0,3,0,0,1,3,0,0,0,0,0,0,17,0,9999999,9999,"rocketBarrage1","rocketLauncher29B2",3,250,62);
         this.itemsDB_local[1143] = new Array(1143,"Devastation Swarm Mark II",174,33275,"sideWeapon","explosive",30,0,0,0,0,0,0,0,15,55,23,2,25,0,0,0,0,5,0,1,3,0,0,0,0,0,0,12,0,9999999,9999,"rocketBarrage1","rocketLauncher29B1",3,250,63);
         this.itemsDB_local[1144] = new Array(1144,"Electric Storm Mark II",178,33279,"sideWeapon","electric",30,0,0,0,0,0,0,0,15,55,23,3,0,25,0,0,0,0,5,1,3,0,0,0,0,0,0,12,0,9999999,9999,"rocketBarrage1","rocketLauncher29B3",3,250,63);
         this.itemsDB_local[1145] = new Array(1145,"Metal Shredder Mark III",5,33024,"sideWeapon","physical",30,0,0,0,0,0,0,0,30,170,45,1,0,0,0,0,5,0,0,1,3,0,0,0,0,0,0,18,0,9999999,9999,"rocketBarrage1","rocketLauncher29C2",4,250,63);
         this.itemsDB_local[1146] = new Array(1146,"Devastation Swarm Mark III",5,33024,"sideWeapon","explosive",30,0,0,0,0,0,0,0,30,165,25,2,30,0,0,0,0,5,0,1,3,0,0,0,0,0,0,13,0,9999999,9999,"rocketBarrage1","rocketLauncher29C1",4,250,64);
         this.itemsDB_local[1147] = new Array(1147,"Electric Storm Mark III",5,33026,"sideWeapon","electric",30,0,0,0,0,0,0,0,30,165,25,3,0,30,0,0,0,0,5,1,3,0,0,0,0,0,0,13,0,9999999,9999,"rocketBarrage1","rocketLauncher29C3",4,250,64);
         this.itemsDB_local[1148] = new Array(1148,"Diamond Shell",7,13011,"torso","torso",30,120,0,120,40,120,40,0,0,0,0,0,0,0,0,0,19,19,19,0,0,0,0,0,0,0,0,0,0,9999999,9999,"","torso56A",3,250,369,0,0,0,0,5,5,5,0,4);
         this.itemsDB_local[1149] = new Array(1149,"Platinum Hammer",4,33007,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,90,30,1,0,0,4,0,0,0,0,0,1,0,0,0,0,0,0,10,16,21000,60,"sword2","hammer1C",3,150,64);
         this.itemsDB_local[1150] = new Array(1150,"Lightning Hammer",4,33008,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,55,20,3,0,65,4,0,0,0,0,0,1,0,0,0,0,0,0,0,20,20800,0,"sword2","hammer1B",3,150,76,0,0,0,6);
         this.itemsDB_local[1151] = new Array(1151,"Flame Hammer",4,33009,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,55,20,2,65,0,4,0,0,0,0,0,1,0,0,0,0,0,0,20,0,20800,0,"sword2","hammer1A",3,150,76,0,6,0,0);
         this.itemsDB_local[1152] = new Array(1152,"Steel Axe",4,33010,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,95,35,1,0,0,4,1,0,0,0,0,1,0,0,0,0,0,0,10,16,21000,60,"sword2","axe1C",3,150,64);
         this.itemsDB_local[1153] = new Array(1153,"Electric Axe",4,33011,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,60,20,3,0,65,4,1,0,0,0,0,1,0,0,0,0,0,0,0,20,20800,0,"sword2","axe1B",3,150,76,0,0,12,0);
         this.itemsDB_local[1154] = new Array(1154,"Infernal Axe",4,33012,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,60,20,2,65,0,4,1,0,0,0,0,1,0,0,0,0,0,0,20,0,20800,0,"sword2","axe1A",3,150,76,12,0,0,0);
         this.itemsDB_local[1155] = new Array(1155,"Lightning Gate Mark II",1,73003,"teleport","teleport",30,0,0,0,0,0,0,0,0,35,10,3,0,34,3,0,0,0,0,0,1,0,0,0,0,0,0,0,43,21350,9999,"","teleport9",3,250,30);
         this.itemsDB_local[1156] = new Array(1156,"Fire Tail Mark II",1,83003,"charge","charge",30,0,0,0,0,0,0,0,0,40,0,1,0,0,3,1,0,0,0,1,999,0,0,0,0,0,0,28,16,21350,9999,"","charge8",3,250,23);
         this.itemsDB_local[1157] = new Array(1157,"Infernova Mark II",0,43015,"topWeapon","explosive",30,0,0,0,0,0,0,0,0,52,38,2,96,0,1,1,0,5,0,3,3,0,0,0,0,0,0,36,5,999999,9999,"beamRoundRed2","blaster21B3",3,250,62);
         this.itemsDB_local[1158] = new Array(1158,"Ultra Nova Mark II",1,43010,"topWeapon","physical",30,0,0,0,0,0,0,0,0,135,36,1,0,0,1,1,8,0,0,3,3,0,0,0,0,0,0,18,18,999999,9999,"beamRoundYellow2","blaster21B2",3,250,62);
         this.itemsDB_local[1159] = new Array(1159,"Armor Breaker Mark I",5,33024,"sideWeapon","physical",15,0,0,0,0,0,0,30,0,80,55,1,0,0,1,1,15,0,0,3,3,0,0,0,0,0,0,20,20,9999999,90,"bullet3","cannon10A",2,250,53);
         this.itemsDB_local[1160] = new Array(1160,"Cooldown Blocker Mark I",5,33024,"sideWeapon","explosive",15,0,0,0,0,0,0,30,0,50,50,2,35,0,1,0,0,0,0,3,3,0,0,0,0,0,0,20,20,9999999,90,"heat3","cannon10A2",2,250,75);
         this.itemsDB_local[1161] = new Array(1161,"Regeneration Blocker Mark I",5,33027,"sideWeapon","electric",15,0,0,0,0,0,0,30,0,50,50,3,0,35,1,0,0,0,0,3,3,0,0,0,0,0,0,20,20,9999999,90,"laser3","cannon10A3",2,250,75);
         this.itemsDB_local[1162] = new Array(1162,"ElectroCop Mark II",0,43017,"topWeapon","electric",15,0,0,0,0,0,0,0,0,10,10,3,0,15,1,0,0,0,15,3,4,0,0,0,0,0,0,15,20,9999999,9999,"specialElectric1","blaster24B",3,250,63,0,0,0,6);
         this.itemsDB_local[1163] = new Array(1163,"Metal Bender Mark I",0,43017,"topWeapon","physical",15,0,0,0,0,0,0,0,0,5,5,1,0,15,1,0,12,0,0,3,4,0,0,0,0,0,0,15,20,9999999,90,"specialPhysical1","blaster23A",2,250,63);
         this.itemsDB_local[1164] = new Array(1164,"Super Heat Shield Mark I",2,63001,"shield","shield",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,2,55,0,0,17800,56,"","engineBooster7",3,150,50);
         this.itemsDB_local[1165] = new Array(1165,"Super Heat Shield Mark II",2,63002,"shield","shield",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,2,60,0,0,17800,56,"","engineBooster8",3,150,52);
         this.itemsDB_local[1166] = new Array(1166,"OMNI-Shield H+E",2,63003,"shield","shield",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,2,70,0,0,17800,56,"","engineBooster9",6,150,54);
         this.itemsDB_local[1167] = new Array(1167,"Heat of the MATRIX",5,33025,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,65,20,2,25,0,0,0,0,0,0,1,3,0,0,0,0,0,0,0,0,21000,9999,"specialExplosive1","laser1001B",6,250,78);
         this.itemsDB_local[1168] = new Array(1168,"Cold of the MATRIX",0,33028,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,65,20,3,0,25,0,0,0,0,0,1,3,0,0,0,0,0,0,0,0,21000,9999,"specialElectric1","laser1001A",6,250,67);
         this.itemsDB_local[1169] = new Array(1169,"Needle Blaster Mark I",111,33211,"sideWeapon","physical",30,0,0,0,0,0,0,15,0,75,10,1,0,0,0,0,3,0,0,1,3,0,0,0,0,0,0,0,0,21000,9999,"machineGun1","machineGun11A",3,200,69);
         this.itemsDB_local[1170] = new Array(1170,"Volcano Chargers",1,13452,"leg","leg",30,90,0,0,0,0,0,0,0,95,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,32850,9999,"stomp1","leg28",3,150,91);
         this.itemsDB_local[1171] = new Array(1171,"Needle Blaster Mark II",112,33212,"sideWeapon","physical",30,0,0,0,0,0,0,15,0,80,10,1,0,0,0,0,3,0,0,1,3,0,0,0,0,0,0,0,0,21000,9999,"machineGun1","machineGun11B",3,200,71);
         this.itemsDB_local[1172] = new Array(1172,"Electron Defence",103,13203,"torso","torso",30,400,0,100,30,120,40,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,101250,9999,"","torso44",3,250,382,0,0,0,0,3,3,4,0,4);
         this.itemsDB_local[1173] = new Array(1173,"HellFire Armor",105,13205,"torso","torso",30,425,0,90,30,130,45,30,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,101250,9999,"","torso46",3,250,407,0,0,0,0,2,5,2,0,3);
         this.itemsDB_local[1174] = new Array(1174,"Lava Scope",102,13202,"torso","torso",30,380,0,90,25,150,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,101250,9999,"","torso48",3,165,369,0,0,0,0,2,5,3,0,4);
         this.itemsDB_local[1175] = new Array(1175,"Metrolens",104,13204,"torso","torso",30,400,0,115,30,115,30,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,101250,9999,"","torso47",3,250,379,0,0,0,0,5,3,2,0,3);
         this.itemsDB_local[1176] = new Array(1176,"Ultraspade",101,13201,"torso","torso",30,408,0,150,40,110,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,225000,9999,"","torso45",3,165,364,0,0,0,0,3,3,3,0,3);
         this.itemsDB_local[1177] = new Array(1177,"Defense Matrix",1,13401,"torso","torso",30,396,0,112,28,112,28,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,95000,0,"","torso49",1,165,405,0,0,0,0,1,1,1,0,3);
         this.itemsDB_local[1178] = new Array(1178,"Flame Boots",102,13252,"leg","leg",30,36,0,0,0,0,0,0,0,40,0,2,54,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,65700,9999,"stomp2","leg30B",3,150,71);
         this.itemsDB_local[1179] = new Array(1179,"Rino Boots",101,13251,"leg","leg",30,36,0,0,0,0,0,0,0,80,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,65700,9999,"stomp1","leg30A",3,150,56);
         this.itemsDB_local[1180] = new Array(1180,"Thunder Boots",103,13253,"leg","leg",30,36,0,0,0,0,0,0,0,37,0,3,0,54,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,65700,9999,"stomp3","leg30C",3,150,76);
         this.itemsDB_local[1181] = new Array(1181,"Steel Tractors",111,13261,"leg","leg",30,35,0,0,0,0,0,0,0,60,0,1,0,0,0,1,0,0,0,0,1,3,0,0,0,0,0,0,0,32850,9999,"stomp1","wheels8A",3,250,59);
         this.itemsDB_local[1182] = new Array(1182,"Burning Tractors",112,13262,"leg","leg",30,35,0,0,0,0,0,0,0,28,0,2,45,0,0,1,0,0,0,0,1,3,0,0,0,0,0,0,0,32850,9999,"stomp2","wheels8B",3,250,72);
         this.itemsDB_local[1183] = new Array(1183,"Lightning Tractors",113,13263,"leg","leg",30,35,0,0,0,0,0,0,0,28,0,3,0,45,0,1,0,0,0,0,1,3,0,0,0,0,0,0,0,32850,9999,"stomp3","wheels8C",3,250,72);
         this.itemsDB_local[1184] = new Array(1184,"Evil Spark",121,53221,"drone","drone",30,0,0,0,0,0,0,0,0,30,12,3,0,23,0,0,0,0,0,0,999,0,0,0,0,0,0,0,20,9999999,9999,"laser1","drone34",3,250,36);
         this.itemsDB_local[1185] = new Array(1185,"Sector Eye",111,53211,"drone","drone",30,0,0,0,0,0,0,0,5,42,0,2,30,0,0,0,0,0,0,0,999,0,0,0,0,0,0,14,0,999999,99999,"rocketBarrage3","drone35",3,250,37);
         this.itemsDB_local[1186] = new Array(1186,"Electricon Mark I",135,53235,"drone","drone",30,0,0,0,0,0,0,5,0,30,12,3,0,23,0,0,0,0,0,0,999,0,0,0,0,0,0,5,0,0,9999,"laser1","drone36B",3,250,45,0,0,4,0);
         this.itemsDB_local[1187] = new Array(1187,"Heat Eruptor Mark I",131,53231,"drone","drone",30,0,0,0,0,0,0,5,0,30,12,2,23,0,0,0,0,0,0,0,999,0,0,0,0,0,0,10,0,99999999,9999,"heat1","drone36C",3,250,45,4,0,0,0);
         this.itemsDB_local[1188] = new Array(1188,"Evil Flame",126,53226,"drone","drone",30,0,0,0,0,0,0,0,0,30,12,2,23,0,0,0,0,0,0,0,999,0,0,0,0,0,0,20,0,9999999,9999,"heat1","drone34B",3,250,36);
         this.itemsDB_local[1189] = new Array(1189,"USA Mark I",106,13206,"torso","torso",30,450,0,150,30,170,25,0,0,0,0,0,0,0,0,0,4,2,2,0,0,0,0,0,0,0,0,0,0,99999999,9999,"null","torso50",4,250,380,0,0,0,0,3,3,2,0,2);
         this.itemsDB_local[1190] = new Array(1190,"God Mode",0,13605,"torso","torso",30,800,0,175,75,175,75,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9999999,9999,"","torso52",3,250,350,0,0,0,0,3,3,3,0,5);
         this.itemsDB_local[1191] = new Array(1191,"USA Transporter",121,13271,"leg","leg",30,45,0,0,0,0,0,0,0,40,0,2,25,0,0,1,0,0,0,0,1,3,0,0,0,0,0,0,0,99999999,9999,"stomp2","wheels9",3,250,68);
         this.itemsDB_local[1192] = new Array(1192,"Yoshimo Blade",105,33213,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,45,25,3,0,60,0,0,0,0,4,0,4,0,0,0,0,0,0,12,22,9999999,9999,"sword3","sword8",3,250,61,0,0,0,0,0,0,0,0,0,-3);
         this.itemsDB_local[1193] = new Array(1193,"Yoshimo X",107,13207,"torso","torso",30,450,0,140,15,90,30,0,0,0,0,0,0,0,0,0,2,4,2,0,0,0,0,0,0,0,0,0,0,9999999,9999,"null","torso51",3,250,380,0,0,0,0,0,0,8,0,5);
         this.itemsDB_local[1194] = new Array(1194,"Yoshimo Legs",131,13281,"leg","leg",30,45,0,0,0,0,0,0,0,40,0,3,0,25,0,1,0,0,0,0,1,3,0,0,0,0,0,0,0,385,9999,"stomp3","leg31",3,250,68);
         this.itemsDB_local[1195] = new Array(1195,"Meltdown",102,33202,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,48,20,2,52,0,0,1,0,3,0,0,1,0,0,0,0,0,0,18,11,21000,9999,"sword2","sword7B",3,150,58);
         this.itemsDB_local[1196] = new Array(1196,"Meteor",101,33201,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,76,44,1,0,0,0,0,4,0,0,0,1,0,0,0,0,0,0,9,15,21000,9999,"sword1","sword7A",3,150,50);
         this.itemsDB_local[1197] = new Array(1197,"Sparks",103,33206,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,48,20,3,0,52,0,1,0,0,3,0,1,0,0,0,0,0,0,0,24,21000,9999,"sword3","sword7C",3,150,59);
         this.itemsDB_local[1198] = new Array(1198,"Mass Deflector",4,33504,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,85,60,1,0,0,0,2,0,0,0,0,1,0,0,0,0,0,0,14,19,21000,9999,"sword1","sword7D",3,150,52);
         this.itemsDB_local[1199] = new Array(1199,"God Mode",143,13293,"leg","leg",30,50,0,0,0,0,0,0,0,100,50,1,0,0,0,1,0,0,0,0,1,2,2,0,0,0,0,0,0,999999,9999,"stomp1","leg32",4,250,62);
         this.itemsDB_local[1200] = new Array(1200,"Evil Rock",121,53221,"drone","drone",30,0,0,0,0,0,0,0,0,40,10,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,15,0,0,9999,"bullet2","drone34C",3,250,26);
         this.itemsDB_local[1201] = new Array(1201,"Bullet Shark",140,53240,"drone","drone",30,0,0,0,0,0,0,5,0,40,28,1,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,8,0,999999,9999,"bullet2","drone36A",3,250,38);
         this.itemsDB_local[1202] = new Array(1202,"Shocking Scope Mark I",1,53003,"drone","drone",30,0,0,0,0,0,0,0,0,20,12,3,0,33,0,0,0,0,0,0,999,0,0,0,0,0,0,0,20,999999,9999,"laser2","drone40A",3,250,36,0,0,0,2);
         this.itemsDB_local[1203] = new Array(1203,"Boiling Scope Mark I",1,53004,"drone","drone",30,0,0,0,0,0,0,0,0,20,12,2,33,0,0,0,0,0,0,0,999,0,0,0,0,0,0,20,0,999999,9999,"heat2","drone39A",3,250,36,0,2,0,0);
         this.itemsDB_local[1204] = new Array(1204,"Stone Thrower Mark I",1,53005,"drone","drone",30,0,0,0,0,0,0,0,0,20,12,1,0,0,0,0,2,0,0,0,999,0,0,0,0,0,0,5,5,999999,9999,"bullet2","drone38A",3,250,36,0,0,0,0);
         this.itemsDB_local[1205] = new Array(1205,"Antigravity Module 1 (-50)",26,112601,"module","multi",26,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"","module_multi1",3,52,-50);
         this.itemsDB_local[1206] = new Array(1206,"Antigravity Module 2 (-75)",27,112701,"module","multi",27,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"","module_multi2",3,54,-75);
         this.itemsDB_local[1207] = new Array(1207,"Antigravity Module 3 (-90)",28,112801,"module","multi",28,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"","module_multi3",3,56,-90);
         this.itemsDB_local[1208] = new Array(1208,"Antigravity Module 4 (-100)",29,112901,"module","multi",29,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"","module_multi4",3,58,-100);
         this.itemsDB_local[1209] = new Array(1209,"Antigravity Module 5 (-125)",30,113001,"module","multi",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,"","module_multi5",3,60,-125);
         this.itemsDB_local[1210] = new Array(1210,"Rear Hit Mega Mark",0,43090,"topWeapon","physical",30,0,0,0,0,0,0,0,0,65,20,1,0,0,0,-1,2,0,0,3,3,0,0,0,0,0,0,14,0,9999999,0,"grenadePull1","grenadeLauncher1B3",3,50,61);
         this.itemsDB_local[1211] = new Array(1211,"Mega Energy & Heat Booster",152,113252,"module","energyHeat",30,0,0,50,30,50,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,999999,9999,"null","module_energyHeat15",6,250,70);
         this.itemsDB_local[1212] = new Array(1212,"Mega Combiner Storage",183,113285,"module","ammo",30,0,0,0,0,0,0,120,120,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9999999,9999,"","module_bulletsRockets_8_8",6,250,95);
         this.itemsDB_local[1213] = new Array(1213,"Adamantium Skeleton",103,113203,"module","armor",30,150,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13500,9999,"","module_HP15",6,250,50);
         this.itemsDB_local[1214] = new Array(1214,"Legs of the MATRIX",3,10353,"leg","leg",30,142,0,0,0,0,0,0,0,100,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,1500,0,"stomp1","leg33",6,250,120);
         this.itemsDB_local[1215] = new Array(1215,"Head of the MATRIX",7,13008,"torso","torso",30,650,0,100,40,120,45,90,0,0,0,0,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,0,101250,270,"","torso53",6,250,550,0,0,0,0,3,3,3,0,4);
         this.itemsDB_local[1216] = new Array(1216,"Rear Hit Mega Mark I",0,42404,"topWeapon","physical",24,0,0,0,0,0,0,0,0,55,15,1,0,0,0,-1,0,0,0,3,3,0,0,0,0,0,0,10,0,999999,9999,"grenadePull1","grenadeLauncher1A3",3,100,40);
         this.itemsDB_local[1217] = new Array(1217,"Rear Hit Electro Mark I",0,42405,"topWeapon","electric",24,0,0,0,0,0,0,0,0,45,10,3,0,20,0,-1,0,0,0,3,3,0,0,0,0,0,0,3,12,999999,9999,"grenadePull3","grenadeLauncher1A2",3,100,38);
         this.itemsDB_local[1218] = new Array(1218,"Rear Hit Heat Mark I",0,42406,"topWeapon","explosive",24,0,0,0,0,0,0,0,0,45,15,2,20,0,0,-1,0,0,0,3,3,0,0,0,0,0,0,18,0,999999,9999,"grenadePull2","grenadeLauncher1A",3,100,38);
         this.itemsDB_local[1219] = new Array(1219,"Dual Barreled Shotgun",2,32506,"sideWeapon","physical",25,0,0,0,0,0,0,10,0,50,18,1,0,0,0,1,0,0,0,0,2,0,0,0,0,0,0,7,7,14950,126,"shotgun1","shotgun1B3",3,125,38);
         this.itemsDB_local[1220] = new Array(1220,"Dual Barreled Electric Shotgun",2,32507,"sideWeapon","electric",25,0,0,0,0,0,0,10,0,38,15,3,0,20,0,1,0,0,0,0,2,0,0,0,0,0,0,7,7,13500,108,"shotgun3","shotgun1B",3,125,41);
         this.itemsDB_local[1221] = new Array(1221,"Dual Barreled Heat Shotgun",2,32508,"sideWeapon","explosive",25,0,0,0,0,0,0,10,0,38,15,2,20,0,0,1,0,0,0,0,2,0,0,0,0,0,0,9,3,13500,108,"shotgun2","shotgun1B2",3,125,41);
         this.itemsDB_local[1222] = new Array(1222,"ColdFire Mark I",0,33100,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,44,16,3,0,80,2,0,0,0,3,0,2,0,0,0,0,0,0,20,25,9999999,9999,"flame2","flameThrower9B1",3,250,52,0,0,10,5);
         this.itemsDB_local[1223] = new Array(1223,"Lava Spray Mark I",0,33101,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,44,16,2,80,0,2,0,0,3,0,0,2,0,0,0,0,0,0,35,10,999999,9999,"flame1","flameThrower9A1",3,250,52,10,5,0,0);
         this.itemsDB_local[1224] = new Array(1224,"Energy Breach",2,10306,"torso","torso",3,160,0,35,9,25,7,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,6000,0,"","torso22B",3,15,132,0,0,0,0,3,3,4,0,3);
         this.itemsDB_local[1225] = new Array(1225,"Electric Mass",141,13291,"leg","leg",30,50,0,0,0,0,0,0,0,60,0,3,0,80,0,1,0,0,0,0,1,2,3,0,0,0,0,0,0,100,0,"stomp3","leg32A",3,250,60);
         this.itemsDB_local[1226] = new Array(1226,"Magma Barrier",142,13292,"leg","leg",30,50,0,0,0,0,0,0,0,60,0,2,80,0,0,1,0,0,0,0,1,2,3,0,0,0,0,0,0,999999,9999,"stomp2","leg32B",3,250,60);
         this.itemsDB_local[1227] = new Array(1227,"Steel Barricade",143,13293,"leg","leg",30,50,0,0,0,0,0,0,0,125,20,1,0,0,0,1,0,0,0,0,1,2,3,0,0,0,0,0,0,999999,9999,"stomp1","leg32C",3,250,62);
         this.itemsDB_local[1228] = new Array(1228,"Skeleton Scepter",4,40001,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,70,30,2,60,0,2,0,0,3,0,0,3,0,0,0,0,0,0,10,16,21000,60,"sword2","wand1A",6,150,66,5,5,0,0,0,2,0,0,0,0);
         this.itemsDB_local[1229] = new Array(1229,"Ultra Cooling Module",155,114041,"module","energyHeat",30,0,0,0,0,0,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,99999,9999,"null","module_cooling1",3,250,58);
         this.itemsDB_local[1230] = new Array(1230,"Color Kit",3,120312,"kit","color",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,500,0,"204","kit_color204",2,0,0);
         this.itemsDB_local[1231] = new Array(1231,"Meteor Mark I",5,33210,"sideWeapon","explosive",15,0,0,0,0,0,0,0,0,10,0,2,25,0,0,0,0,5,0,0,3,0,0,0,0,0,0,5,0,15000,0,"heat1","cannon8A",1,100,50);
         this.itemsDB_local[1232] = new Array(1232,"Adamantite Shell",7,13211,"torso","torso",30,50,0,200,100,200,100,0,0,0,0,0,0,0,0,0,25,25,25,0,0,0,0,0,0,0,0,0,0,9999999,9999,"","torso56B",6,250,375,0,0,0,0,7,7,7,0,4);
         this.itemsDB_local[1233] = new Array(1233,"Adamantite Repair Drone",1,53002,"drone","drone",30,0,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,999,0,0,0,0,0,0,-20,10,9999999,9999,"repair1","drone37B",6,250,50,0,0,0,0,1,1,1);
         this.itemsDB_local[1234] = new Array(1234,"Unbreakable Diamond Mark II",5,40044,"sideWeapon","physical",30,0,0,0,0,0,0,0,0,30,0,1,0,0,0,0,3,0,0,0,3,0,0,0,0,0,0,0,0,15000,0,"bullet2","cannon8B2",3,100,50,0,0,0,0,1,0,0);
         this.itemsDB_local[1235] = new Array(1235,"Meteor Mark II",5,40045,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,25,0,2,30,0,0,0,0,3,0,0,3,0,0,0,0,0,0,5,0,15000,0,"heat1","cannon8B",3,100,75,0,0,0,0,0,1,0);
         this.itemsDB_local[1236] = new Array(1236,"Tesla Purge Mark II",5,40046,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,25,0,3,0,30,0,0,0,0,3,0,3,0,0,0,0,0,0,0,5,15000,0,"laser3","cannon8B3",3,100,75,0,0,0,0,0,0,1);
         this.itemsDB_local[1237] = new Array(1237,"Bad Shield",5,10112,"sideWeapon","explosive",5,0,5,0,0,0,0,0,0,0,0,2,0,0,3,0,0,0,0,0,9,0,0,0,0,0,0,20,0,5000,0,"shieldActivate","shieldBeginner2",1,50,100,0,0,0,0,0,1,0);
         this.itemsDB_local[1238] = new Array(1238,"Bad Shield",5,10113,"sideWeapon","physical",5,0,5,0,0,0,0,0,0,0,0,1,0,0,3,0,0,0,0,0,9,0,0,0,0,0,0,10,10,5000,0,"shieldActivate","shieldBeginner1",1,50,100,0,0,0,0,1,0,0);
         this.itemsDB_local[1239] = new Array(1239,"Bad Shield",5,10114,"sideWeapon","electric",5,0,5,0,0,0,0,0,0,0,0,3,0,0,3,0,0,0,0,0,9,0,0,0,0,0,0,0,20,5000,0,"shieldActivate","shieldBeginner3",1,50,100,0,0,0,0,0,0,1);
         this.itemsDB_local[1240] = new Array(1240,"Physical Recovery Shield Mark I",10,20111,"sideWeapon","physical",10,0,15,0,0,0,0,0,0,0,0,1,0,0,2,0,0,0,0,0,9,0,0,0,0,0,0,10,10,10000,0,"shieldActivate","shieldRepair1",1,10,100,0,0,0,0,5,0,0);
         this.itemsDB_local[1241] = new Array(1241,"Explosive Recovery Shield Mark I",10,20112,"sideWeapon","explosive",10,0,15,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,9,0,0,0,0,0,0,20,0,10000,0,"shieldActivate","shieldRepair2",1,10,100,0,0,0,0,0,5,0);
         this.itemsDB_local[1242] = new Array(1242,"Electric Recovery Shield Mark I",10,20113,"sideWeapon","electric",10,0,15,0,0,0,0,0,0,0,0,3,0,0,2,0,0,0,0,0,9,0,0,0,0,0,0,0,20,10000,0,"shieldActivate","shieldRepair3",1,10,100,0,0,0,0,0,0,5);
         this.itemsDB_local[1243] = new Array(1243,"Orb of the MATRIX",30,113001,"module","multi",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1000,1000,"","module_orbMatrix",3,60,0,0,0,0,0,0,0,0,1);
         this.itemsDB_local[1244] = new Array(1244,"Binah",30,11111,"torso","torso",100,5000,0,500,500,500,500,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,999999,0,"","BinahTorso",10,250,1000,0,0,0,0,10,10,10,0,10);
         this.itemsDB_local[1245] = new Array(1245,"The Scourge of Abydos",100,11111,"leg","leg",100,2000,0,0,0,0,0,0,0,200,0,3,0,100,0,3,0,0,0,0,2,0,0,0,0,0,0,0,0,999999,0,"stomp3","BinahSegments",10,250,500);
         this.itemsDB_local[1246] = new Array(1246,"Platinum Vest",110,23456,"torso","torso",30,500,0,200,74,150,50,0,0,0,0,0,0,0,0,0,10,10,15,0,0,0,0,0,0,0,0,0,0,999999,9999,"","torso58C",4,250,390,0,0,0,0,3,3,5,0,4);
         this.itemsDB_local[1247] = new Array(1247,"The Shore Captain",110,34567,"torso","torso",30,700,0,125,150,75,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,300,0,"","torso59C",6,250,420,0,0,0,0,0,0,5,0,4);
         this.itemsDB_local[1248] = new Array(1248,"Oceanic Shotgun",110,34789,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,50,150,3,0,100,1,1,5,5,10,3,3,0,0,0,0,0,0,100,100,250,0,"shotgun3","shotgunRanged3A",6,100,100,0,0,0,0,5,5,5,0,0,1);
         this.itemsDB_local[1249] = new Array(1249,"God Save the Queen",110,35234,"sideWeapon","electric",30,0,50,0,0,0,0,0,0,0,0,3,0,0,4,0,3,3,3,0,9,0,0,0,0,0,0,100,100,150,0,"shieldActivate","shieldCaptain1A",6,100,100,0,0,0,0,10,10,10);
         this.itemsDB_local[1250] = new Array(1250,"Leviathan Axe",110,35234,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,100,75,3,0,125,4,2,2,2,2,0,1,0,0,0,0,0,0,100,100,150,0,"sword3","axeCaptain1A",4,100,100);
         this.itemsDB_local[1251] = new Array(1251,"Leviathan Railgun",110,44236,"topWeapon","electric",30,0,0,0,0,0,0,0,0,150,150,3,0,50,1,2,10,10,10,7,3,0,0,0,0,0,0,100,100,150,0,"laserCharge1","sniperDrainer3A",6,100,100);
         this.itemsDB_local[1252] = new Array(1252,"Napier Green Color Kit",3,120312,"kit","color",3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,500,0,"21","kit_color3",3,0,0);
         this.itemsDB_local[1253] = new Array(1253,"Battleship",110,34567,"torso","torso",36,500,0,1000,100,1000,100,0,0,0,0,0,0,0,0,0,10,10,10,0,0,0,0,0,0,0,0,0,0,300,0,"","torsoShip1",10,1000,1000,0,0,0,0,4,4,4,0,5);
         this.itemsDB_local[1254] = new Array(1254,"Ship Propellers",100,34568,"leg","leg",36,500,0,0,0,0,0,0,0,200,0,1,0,0,0,3,0,0,0,0,2,0,0,0,0,0,0,0,0,100,0,"stomp1","propellers",10,250,500);
         this.itemsDB_local[1255] = new Array(1255,"Amethyst",100,5454,"torso","torso",30,685,0,190,45,190,45,0,0,0,0,0,0,0,0,0,10,10,10,0,0,0,0,0,0,0,0,0,0,300,0,"","torso10C",3,250,490,0,0,0,0,0,0,0,0,5);
         this.itemsDB_local[1256] = new Array(1256,"Aircraft Carrier",110,35555,"torso","torso",36,750,0,750,150,750,150,0,0,0,0,0,0,0,0,0,5,5,5,0,0,0,0,0,0,0,0,0,0,300,0,"","torsoShip2",10,750,750,0,0,0,0,4,4,4,0,4);
         this.itemsDB_local[1257] = new Array(1257,"Airship",110,40000,"torso","torso",36,1500,0,2000,100,2000,100,0,0,0,0,0,0,0,0,0,50,50,50,0,0,0,0,0,0,0,0,0,0,300,0,"","torsoShip3",10,1000,1000,0,0,0,0,4,4,4,0,5);
         this.itemsDB_local[1258] = new Array(1258,"Airship Propellers",200,40001,"leg","leg",36,500,0,0,0,0,0,0,0,200,0,2,0,0,0,3,0,0,0,0,2,2,0,0,0,0,0,0,0,100,0,"stomp2","propellers2",10,250,500);
         this.itemsDB_local[1259] = new Array(1259,"Ira Dei",100,35555,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,20,25,2,40,0,3,1,0,4,0,0,5,0,0,0,0,0,0,30,0,100000,1000,"heat2","laser50",4,135,55,5,5,0,0,0,2,0);
         this.itemsDB_local[1260] = new Array(1260,"Rapture",110,65656,"torso","torso",30,750,0,75,100,125,150,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,300,0,"","torso59B",6,250,500,0,0,0,0,0,10,0,0,4);
         this.itemsDB_local[1261] = new Array(1261,"Volcanic Eruption",110,35890,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,50,150,2,100,0,1,1,5,10,5,3,3,0,0,0,0,0,0,100,100,250,0,"shotgun2","shotgunRanged2A",6,100,100,0,0,0,0,5,5,5,0,0,1);
         this.itemsDB_local[1262] = new Array(1262,"Radiant Crusader",110,35234,"sideWeapon","explosive",30,0,50,0,0,0,0,0,0,0,0,2,0,0,4,0,3,5,3,0,9,0,0,0,0,0,0,100,100,150,0,"shieldActivate","shieldCaptain1C",6,100,100,0,0,0,0,10,10,10);
         this.itemsDB_local[1263] = new Array(1263,"Searing Axe",110,35234,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,100,75,2,125,0,4,2,2,2,2,0,1,0,0,0,0,0,0,100,100,150,0,"sword2","axeCaptain1C",4,100,100);
         this.itemsDB_local[1264] = new Array(1264,"Seraphim Railgun",110,44236,"topWeapon","explosive",30,0,0,0,0,0,0,0,0,150,150,2,50,0,1,2,10,10,10,7,3,0,0,0,0,0,0,100,100,150,0,"heat3","sniperDrainer2A",6,100,100);
         this.itemsDB_local[1265] = new Array(1265,"Dauntless Punch Mark I",155,45680,"sideWeapon","electric",30,0,0,0,0,0,0,0,30,90,50,3,0,50,1,1,0,0,5,3,3,0,0,0,0,0,0,5,15,100000,100,"rocketBarrage2","blaster16A2",3,250,61);
         this.itemsDB_local[1266] = new Array(1266,"Dauntless Punch Mark II",155,45678,"sideWeapon","electric",30,0,0,0,0,0,0,0,30,90,55,3,0,55,1,1,0,0,5,3,3,0,0,0,0,0,0,5,15,100000,100,"rocketBarrage2","blaster16B2",3,250,63);
         this.itemsDB_local[1267] = new Array(1267,"Physical Recovery Shield Mark III",5,49111,"sideWeapon","physical",30,0,20,0,0,0,0,0,0,0,0,1,0,0,2,0,0,0,0,0,9,0,0,0,0,0,0,20,10,10000,500,"shieldActivate","shieldRepairC1",3,150,200,0,0,0,0,8,0,0);
         this.itemsDB_local[1268] = new Array(1268,"Explosive Recovery Shield Mark III",5,49112,"sideWeapon","explosive",30,0,20,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,9,0,0,0,0,0,0,30,0,10000,500,"shieldActivate","shieldRepairC2",3,150,200,0,0,0,0,0,8,0);
         this.itemsDB_local[1269] = new Array(1269,"Electric Recovery Shield Mark III",5,49113,"sideWeapon","electric",30,0,20,0,0,0,0,0,0,0,0,3,0,0,2,0,0,0,0,0,9,0,0,0,0,0,0,0,30,10000,500,"shieldActivate","shieldRepairC3",3,150,200,0,0,0,0,0,0,8);
         this.itemsDB_local[1270] = new Array(1270,"Physical Recovery Shield Mark II",7,36111,"sideWeapon","physical",20,0,17,0,0,0,0,0,0,0,0,1,0,0,2,0,0,0,0,0,9,0,0,0,0,0,0,15,15,0,50,"shieldActivate","shieldRepairB1",2,150,150,0,0,0,0,7,0,0);
         this.itemsDB_local[1271] = new Array(1271,"Explosive Recovery Shield Mark II",7,36112,"sideWeapon","explosive",20,0,17,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,9,0,0,0,0,0,0,25,0,0,50,"shieldActivate","shieldRepairB2",2,150,150,0,0,0,0,0,7,0);
         this.itemsDB_local[1272] = new Array(1272,"Electric Recovery Shield Mark II",7,36113,"sideWeapon","electric",20,0,17,0,0,0,0,0,0,0,0,3,0,0,2,0,0,0,0,0,9,0,0,0,0,0,0,0,25,0,50,"shieldActivate","shieldRepairB3",2,150,150,0,0,0,0,0,0,7);
         this.itemsDB_local[1273] = new Array(1273,"Murasama X",111,15555,"torso","torso",30,775,0,200,50,200,50,0,0,0,0,0,0,0,0,0,2,4,2,0,0,0,0,0,0,0,0,0,0,100000,50,"null","Murasama",6,250,550,0,0,0,0,3,5,3,0,4);
         this.itemsDB_local[1274] = new Array(1274,"Murasama Legs",145,13500,"leg","leg",30,225,0,0,0,0,0,0,0,200,0,2,75,0,0,1,0,5,0,0,1,2,3,0,0,0,0,0,0,100000,50,"stomp3","Murasama_Legs",6,250,150);
         this.itemsDB_local[1275] = new Array(1275,"Murasama Slash",105,33213,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,50,100,2,100,0,0,0,0,5,0,0,1,0,0,0,0,0,0,100,100,100000,50,"sword3","Murasama_Right",6,250,100,0,0,0,0,5,5,5);
         this.itemsDB_local[1276] = new Array(1276,"Murasama Lunge",110,34213,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,25,300,2,100,0,0,0,0,10,0,4,3,0,0,0,0,0,0,100,100,100000,50,"sword3","Murasama_Left",6,250,100,0,0,0,0,2,2,2);
         this.itemsDB_local[1277] = new Array(1277,"Brute Force Mark I",200,40001,"topWeapon","physical",30,0,-50,0,0,0,0,0,0,0,0,1,0,0,1,0,35,0,0,4,3,0,0,0,0,0,0,45,45,100000,50,"orbOrange1","bomber1A",3,100,150,0,0,0,0,1,0,0);
         this.itemsDB_local[1278] = new Array(1278,"Scorched Earth Mark I",200,40002,"topWeapon","explosive",30,0,-50,0,0,0,0,0,0,25,25,2,125,0,1,0,0,5,0,4,3,0,0,0,0,0,0,90,0,100000,50,"orbRed1","bomber2A",3,100,150,0,0,0,0,0,1,0);
         this.itemsDB_local[1279] = new Array(1279,"Circuit Shutdown Mark I",200,40003,"topWeapon","electric",30,0,-50,0,0,0,0,0,0,25,25,3,0,125,1,0,0,0,5,4,3,0,0,0,0,0,0,0,90,100000,50,"orbBlue1","bomber3A",3,100,150,0,0,0,0,0,0,1);
         this.itemsDB_local[1280] = new Array(1280,"Brute Force Mark II",200,40004,"topWeapon","physical",30,0,-75,0,0,0,0,0,0,0,0,1,0,0,1,0,50,0,0,4,3,0,0,0,0,0,0,50,50,100000,50,"orbOrange1","bomber1B",4,100,200,0,0,0,0,2,0,0);
         this.itemsDB_local[1281] = new Array(1281,"Scorched Earth Mark II",200,40005,"topWeapon","explosive",30,0,-75,0,0,0,0,0,0,25,25,2,150,0,1,0,0,5,0,4,3,0,0,0,0,0,0,100,0,100000,50,"orbRed1","bomber2B",4,100,200,0,0,0,0,0,2,0);
         this.itemsDB_local[1282] = new Array(1282,"Circuit Shutdown Mark II",200,40006,"topWeapon","electric",30,0,-75,0,0,0,0,0,0,25,25,3,0,150,1,0,0,0,5,4,3,0,0,0,0,0,0,0,100,100000,50,"orbBlue1","bomber3B",4,100,200,0,0,0,0,0,0,2);
         this.itemsDB_local[1283] = new Array(1283,"Military Grade Energy & Heat Booster",152,113252,"module","energyHeat",30,0,0,40,25,40,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,999999,9999,"null","module_energyHeat15",4,300,100);
         this.itemsDB_local[1284] = new Array(1284,"Mega Cooling Module",155,114041,"module","energyHeat",30,0,0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,99999,9999,"null","module_cooling2",4,250,70);
         this.itemsDB_local[1285] = new Array(1285,"Ultra Energy Regeneration Module",156,114511,"module","energyHeat",30,0,0,0,90,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,99999,9999,"null","module_energyPlus107",3,250,50);
         this.itemsDB_local[1286] = new Array(1286,"Mega Energy Regeneration Module",155,114041,"module","energyHeat",30,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,99999,9999,"null","module_energyPlus108",4,250,70);
         this.itemsDB_local[1287] = new Array(1287,"Benevolence",100,13801,"torso","torso",30,750,0,250,100,150,50,0,0,0,0,0,0,0,0,0,15,15,15,0,0,0,0,0,0,0,0,0,0,9999999,9999,"","torso52C",4,250,350,0,0,0,0,3,3,5,0,4);
         this.itemsDB_local[1288] = new Array(1288,"Greyrat",100,13802,"torso","torso",30,850,0,175,75,175,75,0,0,0,0,0,0,0,0,0,5,5,5,0,0,0,0,0,0,0,0,0,0,9999999,9999,"","torso52A",4,250,350,0,0,0,0,5,3,3,0,4);
         this.itemsDB_local[1289] = new Array(1289,"Terran Axe",110,35237,"sideWeapon","melee",30,0,0,0,0,0,0,0,0,150,150,1,0,0,4,2,2,2,2,0,1,0,0,0,0,0,0,100,100,150,0,"sword3","axeCaptain1B",4,100,100);
         this.itemsDB_local[1290] = new Array(1290,"Lord Camelot",110,35237,"sideWeapon","physical",30,0,50,0,0,0,0,0,0,0,0,1,0,0,4,0,3,3,3,0,9,0,0,0,0,0,0,100,100,150,0,"shieldActivate","shieldCaptain1B",6,100,100,0,0,0,0,10,10,10);
         this.itemsDB_local[1291] = new Array(1291,"Planetary Shotgun",110,34789,"sideWeapon","physical",30,0,0,0,0,0,0,0,0,100,200,1,0,0,1,1,25,0,0,3,3,0,0,0,0,0,0,100,100,250,0,"shotgun3","shotgunRanged1A",6,100,100,0,0,0,0,5,5,5,0,0,1);
         this.itemsDB_local[1292] = new Array(1292,"Terran Railgun",110,34780,"topWeapon","physical",30,0,0,0,0,0,0,0,0,250,250,1,0,0,1,2,10,10,10,7,3,0,0,0,0,0,0,100,100,150,0,"laserCharge1","sniperDrainer1A",6,100,100);
         this.itemsDB_local[1293] = new Array(1293,"FireWatch Mark III",1,43116,"topWeapon","explosive",30,0,0,0,0,0,0,0,0,15,15,2,15,0,1,0,0,18,0,3,4,0,0,0,0,0,0,40,0,99999999,9999,"specialExplosive1","blaster22C",4,250,60,0,6);
         this.itemsDB_local[1294] = new Array(1294,"Metal Bender Mark II",0,43018,"topWeapon","physical",30,0,0,0,0,0,0,0,0,10,10,1,0,15,1,0,15,0,0,3,4,0,0,0,0,0,0,15,20,9999999,9999,"specialPhysical1","blaster23B",3,250,63);
         this.itemsDB_local[1295] = new Array(1295,"Metal Bender Mark III",0,43019,"topWeapon","physical",30,0,0,0,0,0,0,0,0,15,15,1,0,15,1,0,18,0,0,3,4,0,0,0,0,0,0,15,20,9999999,9999,"specialPhysical1","blaster23C",4,250,63);
         this.itemsDB_local[1296] = new Array(1296,"ElectroCop Mark III",0,43020,"topWeapon","electric",30,0,0,0,0,0,0,0,0,15,15,3,0,15,1,0,0,0,18,3,4,0,0,0,0,0,0,15,20,9999999,9999,"specialElectric1","blaster24C",4,250,63,0,0,0,6);
         this.itemsDB_local[1297] = new Array(1297,"ColdFire Mark II",0,33103,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,50,20,3,0,100,2,0,0,0,3,0,2,0,0,0,0,0,0,20,25,9999999,9999,"flame2","flameThrower9B2",4,250,52,0,0,15,7);
         this.itemsDB_local[1298] = new Array(1298,"Lava Spray Mark II",0,33104,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,50,20,2,100,0,2,0,0,3,0,0,2,0,0,0,0,0,0,35,10,999999,9999,"flame1","flameThrower9A2",4,250,52,15,7,0,0);
         this.itemsDB_local[1299] = new Array(1299,"Green Tea Mark II",5,33029,"sideWeapon","electric",30,0,0,0,0,0,0,0,0,60,20,3,0,85,0,0,0,0,0,0,2,0,0,0,0,0,0,10,35,21000,270,"flame3","flameThrower9C2",6,150,45);
         this.itemsDB_local[1300] = new Array(1300,"Grape Soda Mark II",5,33027,"sideWeapon","explosive",30,0,0,0,0,0,0,0,0,60,20,2,85,0,0,0,0,0,0,0,2,0,0,0,0,0,0,35,10,21000,270,"flame4","flameThrower9D2",6,150,45);
         this.itemsDB_local[1301] = new Array(1301,"Armor Breaker Mark II",5,33024,"sideWeapon","physical",30,0,0,0,0,0,0,30,0,90,55,1,0,0,1,1,15,0,0,3,3,0,0,0,0,0,0,20,20,9999999,9999,"bullet3","cannon10B",3,250,53);
         this.itemsDB_local[1302] = new Array(1302,"Cooldown Blocker Mark II",5,33024,"sideWeapon","explosive",30,0,0,0,0,0,0,30,0,60,50,2,35,0,1,0,0,0,0,3,3,0,0,0,0,0,0,20,20,9999999,9999,"heat3","cannon10B2",3,250,75);
         this.itemsDB_local[1303] = new Array(1303,"Regeneration Blocker Mark II",5,33027,"sideWeapon","electric",30,0,0,0,0,0,0,30,0,60,50,3,0,35,1,0,0,0,0,3,3,0,0,0,0,0,0,20,20,9999999,9999,"laser3","cannon10B3",3,250,75);
         this.itemsDB_local[1304] = new Array(1304,"Military Grade Bullet Storage",3,113403,"module","ammo",30,0,0,0,0,0,0,200,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,28000,9999,"","module_bullets15",4,250,90);
         this.itemsDB_local[1305] = new Array(1305,"Military Grade Rocket Storage",3,113404,"module","ammo",30,0,0,0,0,0,0,0,200,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,28000,9999,"","module_rockets15",4,250,90);
         this.itemsDB_local[1306] = new Array(1306,"Military Grade Physical Resistance Module","module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,0,14050,9999,"","module_resistancePhysical18",4,100,150,0,0,0,0,5,0,0);
         this.itemsDB_local[1307] = new Array(1307,"Military Grade Explosive Resistance Module","module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,14050,9999,"","module_resistanceExplosive18",4,100,150,0,0,0,0,0,5,0);
         this.itemsDB_local[1308] = new Array(1308,"Military Grade Electric Resistance Module","module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,14050,9999,"","module_resistanceElectric18",4,100,150,0,0,0,0,0,0,5);
         this.itemsDB_local[1309] = new Array(1309,"Military Grade Multi Resistance Module","module","resistance",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,12,12,0,0,0,0,0,0,0,0,0,0,14050,9999,"","module_resistanceAll18",4,100,150,0,0,0,0,3,3,3);
         this.itemsDB_local[1310] = new Array(1310,"UltraKill Mark II",5,33007,"sideWeapon","explosive",30,0,0,0,0,0,0,20,0,100,45,2,50,0,0,0,0,10,0,0,2,0,0,0,0,0,0,9,0,21000,270,"machineGun3","machineGun8B2",4,150,46);
         this.itemsDB_local[1311] = new Array(1311,"UltraKill Mark I",5,32807,"sideWeapon","explosive",15,0,0,0,0,0,0,15,0,75,35,2,30,0,0,0,0,5,0,0,2,0,0,0,0,0,0,0,0,20550,252,"machineGun3","machineGun8A2",3,140,46);
         this.itemsDB_local[1312] = new Array(1312,"Bullet Hell Mark II",5,33008,"sideWeapon","electric",30,0,0,0,0,0,0,20,0,100,45,3,0,50,0,0,0,0,10,0,2,0,0,0,0,0,0,9,0,21000,270,"machineGun3","machineGun8B3",4,150,46);
         this.itemsDB_local[1313] = new Array(1313,"Bullet Hell Mark I",5,32808,"sideWeapon","electric",15,0,0,0,0,0,0,15,0,75,35,3,0,30,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,20550,252,"machineGun3","machineGun8A3",3,140,46);
         this.itemsDB_local[1314] = new Array(1314,"Hatred Mark II",102,43205,"topWeapon","explosive",30,0,0,0,0,0,0,10,0,70,35,2,50,0,0,0,0,3,0,4,2,0,0,0,0,0,0,13,0,21000,9999,"bulletCharge1","cannon7B2",3,150,49);
         this.itemsDB_local[1315] = new Array(1315,"Hatred Mark I",101,43206,"topWeapon","explosive",15,0,0,0,0,0,0,10,0,60,25,2,45,0,0,0,0,3,0,4,2,0,0,0,0,0,0,13,0,21000,90,"bulletCharge1","cannon7A2",2,150,49);
         this.itemsDB_local[1316] = new Array(1316,"Hatred Mark III",103,43207,"topWeapon","explosive",30,0,0,0,0,0,0,10,0,155,55,2,55,0,0,0,0,4,0,4,2,0,0,0,0,0,0,13,0,21000,9999,"bulletCharge1","cannon7C2",4,150,55);
         this.itemsDB_local[1317] = new Array(1317,"Warpath Mark II",112,43211,"topWeapon","electric",30,0,0,0,0,0,0,10,0,70,35,3,0,50,0,0,0,0,3,4,2,0,0,0,0,0,0,13,0,21000,9999,"bulletCharge1","cannon7B3",3,150,49);
         this.itemsDB_local[1318] = new Array(1318,"Warpath Mark I",111,43212,"topWeapon","electric",15,0,0,0,0,0,0,10,0,60,25,3,0,45,0,0,0,0,3,4,2,0,0,0,0,0,0,13,0,21000,90,"bulletCharge1","cannon7A3",2,150,49);
         this.itemsDB_local[1319] = new Array(1319,"Warpath Mark III",113,43213,"topWeapon","electric",30,0,0,0,0,0,0,10,0,155,55,3,0,55,0,0,0,0,4,4,2,0,0,0,0,0,0,13,0,21000,9999,"bulletCharge1","cannon7C3",4,150,55);
         this.itemsDB_local[1320] = new Array(1320,"Molten Vest",110,23456,"torso","torso",30,400,0,150,50,200,75,0,0,0,0,0,0,0,0,0,10,15,10,0,0,0,0,0,0,0,0,0,0,10000,0,"","torso58B",4,250,390,0,0,0,0,3,5,3,0,4);
         this.itemsDB_local[1321] = new Array(1321,"Golden Wind",110,23456,"torso","torso",30,400,0,175,75,175,75,0,0,0,0,0,0,0,0,0,20,10,10,0,0,0,0,0,0,0,0,0,0,10000,0,"","torso58A",4,250,390,0,0,0,0,5,3,3,0,4);
         this.itemsDB_local[1322] = new Array(1322,"FireWatch Mark II",1,43016,"topWeapon","explosive",30,0,0,0,0,0,0,0,0,10,10,2,15,0,1,0,0,15,0,3,4,0,0,0,0,0,0,40,0,99999999,9999,"specialExplosive1","blaster22B",3,250,52,0,6);
         this.itemsDB_local[1323] = new Array(1323,"Earthquake Thrusters",1,13455,"leg","leg",30,100,0,0,0,0,0,0,0,150,0,1,0,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,32850,9999,"stomp1","leg28A",4,150,91);
         this.itemsDB_local[1324] = new Array(1324,"Volcanic Chargers",1,13456,"leg","leg",30,100,0,0,0,0,0,0,0,130,0,2,50,0,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,32850,9999,"stomp2","leg28B",4,150,91);
         this.itemsDB_local[1325] = new Array(1325,"Magnetic Field",1,13457,"leg","leg",30,100,0,0,0,0,0,0,0,130,0,3,0,50,0,1,0,0,0,0,1,1,2,0,0,0,0,0,0,32850,9999,"stomp3","leg28C",4,150,91);
         this.itemsDB_local[1326] = new Array(1326,"Judgement",110,65656,"torso","torso",30,1000,0,50,50,50,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,300,0,"","torso59A",6,250,500,0,0,0,0,0,10,0,0,4);
         this.itemsDB_local[1327] = new Array(1327,"Military Grade Energy Shield",2,63004,"shield","shield",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,4,80,0,0,17800,56,"","shield9A",4,150,54);
         this.itemsDB_local[1328] = new Array(1328,"Military Grade Heat Shield",2,63005,"shield","shield",30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,4,80,0,0,17800,56,"","engineBooster9",4,150,54);
      }
      
      public function onAFConversionData(param1:AppsFlyerEvent) : void
      {
         trace("!!!!!!!!!AND!!!!!!!!!!!!!    BMDataManager :: onAFConversionData()");
         trace("\n-- Event: " + param1.type + "; \nData: " + param1.data + " \n");
      }
      
      private function storeKitPurchaseComplete(param1:AndroidStoreEvent) : void
      {
         trace("!!!!!!!!AND!!!!!!!!!!!!!!    BMDataManager :: storeKitPurchaseComplete()");
         if(param1.data != null)
         {
            this.afInterface.trackEvent("purchase","{\"value\":" + param1.data.purchaseValue + "}");
            if(GAnalytics.isSupported())
            {
               GAnalytics.analytics.defaultTracker.trackTransaction(param1.data.trackingID,param1.data.trackingName,param1.data.trackingCost);
               GAnalytics.analytics.defaultTracker.trackItem(param1.data.trackingID,param1.data.trackingName,param1.data.trackingSKU,param1.data.trackingCost);
            }
         }
      }
      
      public function mobileScreenTracking(param1:String) : void
      {
         trace("BMDataManager :: mobileScreenTracking() - screen: " + param1);
         if(GAnalytics.isSupported())
         {
            GAnalytics.analytics.defaultTracker.trackScreenView(param1);
         }
         this.afInterface.trackEvent("screen","{\"value\":\"" + param1 + "\"}");
      }
      
      public function mobileEventTracking(param1:String, param2:String, param3:String = null, param4:Number = 0, param5:Object = null) : void
      {
         if(GAnalytics.isSupported())
         {
            if(!isNaN(param4))
            {
               if(param5 != null)
               {
                  GAnalytics.analytics.defaultTracker.trackEvent(param1,param2,param3,param4,param5);
               }
               else
               {
                  GAnalytics.analytics.defaultTracker.trackEvent(param1,param2,param3,param4);
               }
               this.afInterface.trackEvent(param3,"{\"value\":" + param4 + "}");
            }
            else if(param3 != null)
            {
               GAnalytics.analytics.defaultTracker.trackEvent(param1,param2,param3);
               this.afInterface.trackEvent(param2,"{\"label\":\"" + param3 + "\"}");
            }
            else
            {
               GAnalytics.analytics.defaultTracker.trackEvent(param1,param2);
               this.afInterface.trackEvent(param1,"{\"action\":\"" + param2 + "\"}");
            }
         }
      }
      
      public function rateBox_initializeAndDisplay() : void
      {
         if(RateBox.isSupported())
         {
            if(this._rateBoxInitialized == false)
            {
               RateBox.create(null,"Rate My App","If you like this app, please rate it 5 stars!");
               NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,this.rateBox_onInvoke);
               RateBox.rateBox.addEventListener(RateBoxEvent.RATE_SELECTED,this.rateBox_onDidRate);
               RateBox.rateBox.addEventListener(RateBoxEvent.LATER_SELECTED,this.rateBox_onDeclinedToRate);
               RateBox.rateBox.addEventListener(RateBoxEvent.NEVER_SELECTED,this.rateBox_onWillNeverRate);
               RateBox.rateBox.addEventListener(RateBoxEvent.NETWORK_UNAVAILABLE,this.rateBox_onRateNotDisplayed);
               RateBox.rateBox.addEventListener(RateBoxEvent.PROMPT_DISPLAYED,this.rateBox_onRateDisplayed);
               this._rateBoxInitialized = true;
            }
            this.rateBox_showRatingDialog();
         }
      }
      
      public function rateBox_incrementEventCounter() : void
      {
         RateBox.rateBox.incrementEventCount();
      }
      
      public function rateBox_showRatingDialog() : void
      {
         RateBox.rateBox.showRatingPrompt(languageM.getText("rateBox_title"),languageM.getText("rateBox_description"));
      }
      
      public function rateBox_showRatingsPageNow() : void
      {
         RateBox.rateBox.gotoRatingsNow();
      }
      
      public function rateBox_resetRateBox() : void
      {
         RateBox.rateBox.resetConditions();
      }
      
      public function rateBox_showInfo() : void
      {
      }
      
      public function rateBox_enableInlineStoreView() : void
      {
         RateBox.rateBox.setUseInlineStoreView(true);
      }
      
      public function rateBox_disableInlineStoreView() : void
      {
         RateBox.rateBox.setUseInlineStoreView(false);
      }
      
      private function rateBox_onInvoke(param1:InvokeEvent) : void
      {
         RateBox.rateBox.onLaunch();
      }
      
      private function rateBox_onDidRate(param1:RateBoxEvent) : void
      {
         var _loc2_:BMPlayerProfile = null;
         screensM.screenConfirmation.displayUrgentMessage("rateBox_usedRated");
         _loc2_ = this["player" + this.player1PlayerID + "Profile"];
         _loc2_.rateStatus = "V";
         remoteM.socketM.lobby_setRateStatus("V");
      }
      
      private function rateBox_onDeclinedToRate(param1:RateBoxEvent) : void
      {
         var _loc2_:BMPlayerProfile = null;
         this.userDeclinedRatingForThisSession = true;
         _loc2_ = this["player" + this.player1PlayerID + "Profile"];
         _loc2_.rateStatus = "D";
         remoteM.socketM.lobby_setRateStatus("D");
      }
      
      private function rateBox_onWillNeverRate(param1:RateBoxEvent) : void
      {
         var _loc2_:BMPlayerProfile = null;
         _loc2_ = this["player" + this.player1PlayerID + "Profile"];
         _loc2_.rateStatus = "X";
         remoteM.socketM.lobby_setRateStatus("X");
      }
      
      private function rateBox_onRateDisplayed(param1:RateBoxEvent) : void
      {
      }
      
      private function rateBox_onRateNotDisplayed(param1:RateBoxEvent) : void
      {
      }
   }
}

