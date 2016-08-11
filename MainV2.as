package  {
	
	//IMPORTS
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.geom.ColorTransform;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	
	public class MainV2 extends MovieClip {
		//INITIAL INFO
		var Height = 600; 	//screen height
		var Width = 800;	//screen width
		//MAIN MENU INFO
		var mainMenu:MainMenu = new MainMenu();	//main menu graphic
		var MainButtonNum = 0;					//button choice in the menu
		//INSTRUCTIONS PANEL INFO
		var instructions:Instructions = new Instructions();	//Instructions menu graphic
		var InstructButtonNum = 0;							//button selected in the menu
		var InstructPage = 0;								//Page of instructions
		//ABOUT PANEL INFO
		var about:About = new About();		//About Menu graphic
		//LEVEL SELECT
		var LvlButtonY = 0;								//Which Row of buttons you are on
		var LvlButtonX = 0;								//Which Column of buttons you are on
		var DiffButtonX = 0;							//Difficulty
		var lvlSelect:LevelSelect = new LevelSelect();	//Level Select Graphics
		var lvlDifficulty = 0;							//Difficulty used to multiply enemy stats
		//LEVEL GRAPHICS & INFO
		var lvlNum;							//which level you are on
		var levelImg;						//graphic for the level
		var Boss;							//graphic of the level's boss
		var levelInfo:Array = new Array(); 	//[0-lvlNumber, 1-chair, 2-couch, 3-table, 4-bookshelf, 5-Doors, 6-MaleEnemy, 7-Female Enemy (not used in this game), 8-UnlockedMaxHealth, 9-Unlocked Weapon, 10-IsUnlocked?, 11-completion text, 12 vents]
		var ventWeapon = 0;					//which weapon is unlocked upon shooting the vent in the level
		//CHANG SPRITE & Energy Sprite
		var chang:Chang = new Chang();				//Chang's sprite
		var changScale = 0.43;						//scale of the sprite
		var heart:Life = new Life();				//Graphic for energy points (life)
		var lifeText:TextField = new TextField();	//Text showing the number of energy/life points
		//GAMEPLAY INFO
		var isBossSeen = false;						//Used to commence boss' movement
		var isBossKill = false;						//To determine whether a character may use the exit door
		var ground = 567;							//y position of the ground
		var runSpeed = 5;							//Speed at which chang moves left/right
		var jumpPower:Number = 12;					//Initial upwards speed upon jumping
		var gravity:Number = 0.8;					//Downwards acceleration when in air
		var xSpeed = 0;								//used to store the overall change in x position of chang per frame
		var ySpeed = 0;								//used to store the overall change in y position of chang per frame
		var isGround;								//to determine wheter chang is on the ground (for gravity to move him or not)
		var isDoor;									//To determine if chang is by a door (to make the second button open door rather than change weapon)
		var isBbutton;								//To determine whether the second button is pressed
		var duckTime = 0;							//To limit the time for which chang can slide
		var jump:Boolean = false;					//To store whether chang is jumping
		var run:Boolean = false;					//To store whether chang is moving in the x direction
		var duck:Boolean = false;					//To store whether chang is ducking
		var shoot:Boolean = false;
		var changMaxEnergy = 30;					//Chang's maximum energy
		var changCurrEnergy = 30;					//Chang's current energy (changes when hit by bullet or picking up a pack)
		//WEAPON INFO
		var reloadTime = 0;							//To keep track of how much time passes between bullets
		var isShot = false;							//To keep track of if a shot has been fired and the gun is reloading
		var topWeapon:Weapon = new Weapon();		//Graphic for the top right gun which is accompanied by name and ammo amount
		var changWeapon:Weapon = new Weapon();		//Graphic for the weapon Chang wields
		var promptText:TextField = new TextField();	//Text for prompts (such as beat boss before exiting, or you picked up a weapon, etc.)
		var weaponText:TextField = new TextField();	//Text for the name of the weapon
		var ammoText:TextField = new TextField();	//Text showing amount of ammo left
		var bulletCount = 0;						//Number used to name each bullet seperately
		var EbulletCount = 0;						//Number used to name enemy bullets
		var bulletSpeed = 10;						//Speed at which bullets move in the x direction
		var weaponNum = 0;							//Number of the weapon currently wielded
		var weaponInfo:Array = new Array(); 		//0-Name, 1-Shoot Speed, 2-Damage, 3-BulletX, 4-BulletY, 5-currentAmmo, 6-maxAmmo, 7-Unlocked?
		var bulletInfo:Array = new Array(); 		//For Changs Bullets: 0-Name, 1-x, 2-y, 3-direction, 4-damage
		var EbulletInfo:Array = new Array();		//For Enemy Bullets: 0-Name, 1-x, 2-y, 3-direction, 4-damage
		var tempBullet;								//Used when removing bullets from the bullet arrays.
		//BossInfo
		var bossInfo:Array = new Array();	//0-initialx, 1-maxX, 2-minX, 3-initialY, 4-Scale(x&y), 5-Health(max), 6-ShootSpeed, 7-ReloadTime, 8-Damage
		var isBossGround;					//To store whether the boss is in the air or not
		var isBossJump;						//To store whether the boss is commanded to jump or not					
		var BossXSpeed =  5;				//To store the change in boss' x position by frame
		var BossYSpeed = 0;					//To store the change in boss' y position by frame
		var BossGround = 567;				//To store the height of the ground for the boss (changes for tables)
		//ENEMY INFO
		var enemyMInfo:Array = new Array(); //[0-lvl, 1-Number, 2-minX, 3-maxX, 4-scaleX, 5-y, 6-currEnergy, 7-maxEnergy, 8-ShootRate, 9-ReloadValue 10-BASEDamage, 11-Dead?, 12-ActualDamage]
		var enemyMCount = 0;				//Number of enemies in the level
		var lastEnemyM = 0;					//number of the last enemy in the level (based on array)
		//SOUNDS
		var shootSound:Sound = new ShootSound();			//Played upon shooting
		var jumpSound:Sound = new JumpSound();				//Played upon jumping
		var deathMusic:Sound = new DeathMusic();			//Played on death screen
		var gameWinMusic:Sound = new GameWinMusic();		//Played upon beating every level
		var levelWinMusic:Sound = new LevelWinMusic();		//Played upon beating a level (not last level)
		var level1Music:Sound = new Level1Music();			//Played during level 1
		var level2Music:Sound = new Level2Music();			//Played during level 2
		var level3Music:Sound = new Level3Music();			//Played during level 3
		var level4Music:Sound = new Level4Music();			//Played during level 4
		var level5Music:Sound = new Level5Music();			//Played during level 5
		var level6Music:Sound = new Level6Music();			//Played during level 6
		var level7Music:Sound = new Level7Music();			//Played during level 7
		var menuMusic:Sound = new MenuMusic();				//Played in the menu
		var tutorialMusic:Sound = new TutorialMusic();		//Played during Tutorial
		var MusicChannel:SoundChannel = new SoundChannel(); //Used to control background music
		var placeInSong = 0;								//Used to keep music playing when switching between menus (song remains same, but everything else changes)
		
		
		public function MainV2() {
			//INITIALIZE INFO FOR ALL LEVELS:
			//In order of  [0-lvlNumber, 1-chair, 2-couch, 3-table, 4-bookshelf, 5-Doors, 6-MaleEnemy, 7-Female Enemy, 8-UnlockedMaxHealth, 9-Unlocked Weapon, 10-IsUnlocked?, 11-completion text, 12 vents]
			levelInfo[0] = [0, 1, 1, 1, 1, 1, 2, 0, 50, 1, 1, "TUTORIAL\nCOMPLETE!",1];
			levelInfo[1] = [1, 7, 3, 0, 1, 1, 2, 0, 80, 3, 0, "TROY\nDEFEATED!",0];
			levelInfo[2] = [2, 0, 12, 0, 2, 1, 3, 0, 130, 4, 0, "ANNIE\nDEFEATED!",1];
			levelInfo[3] = [3, 21, 4, 2, 4, 1, 4, 0, 200, 6, 0, "PIERCE\nDEFEATED!",1];
			levelInfo[4] = [4, 12, 5, 0, 13, 1, 4, 0, 300, 8, 0, "SHIRLEY\nDEFEATED!",0];
			levelInfo[5] = [5, 12, 0, 0, 0, 1, 4, 0, 450, 9, 0, "ABED\nDEFEATED!",1];
			levelInfo[6] = [6, 12, 3, 1, 1, 1, 5, 0, 1000, 11, 0, "BRITTA\nDEFEATED",1];
			levelInfo[7] = [7, 32, 16, 0, 2, 1, 7, 0, 2000, 12, 0, "JEFF\nDEFEATED!",1];

			
			//INITIALIZE INFO FOR ALL WEAPONS:
			//0-Name, 1-Shoot Speed, 2-Damage, 3-BulletX, 4-BulletY, 5-currAmmo, 6-maxAmmo, 7-Unlocked?
			weaponInfo[0] = ["Luger", 24, 10, 39, 13, -1, -1, true];
			weaponInfo[1] = ["GSH", 20, 15, 28.5, 10.5, -1, -1, false];
			weaponInfo[2] = ["Jericho", 24, 20, 31.5, 10, -1, -1, false];
			weaponInfo[3] = ["Raging Bull", 36, 35, 56.5, 9, 12, 12, false];
			weaponInfo[4] = ["Thompson", 6, 8, 64, 18, -1, -1, false];
			weaponInfo[5] = ["P90", 6, 9, 63.35, 14.85, 20, 20, false];
			weaponInfo[6] = ["Mossberg", 48, 80, 68.5, 16.35,  -1, -1, false];
			weaponInfo[7] = ["MAC10", 6, 12, 35, 29.35, 25, 25, false];
			weaponInfo[8] = ["M4A1", 20, 70, 59.85, 22.85, -1, -1, false];
			weaponInfo[9] = ["AKM", 24, 80, 63.35, 23.85, -1, -1, false];
			weaponInfo[10] = ["M60E4", 4, 15, 60.85, 30.85, 40, 40, false];
			weaponInfo[11] = ["Spas12", 48, 220, 70.5, 14.35, -1, -1, false];
			weaponInfo[12] = ["Magnum", 72, 500, 72, 13.85, -1, -1, false];
			weaponInfo[13] = ["M107", 72, 600, 92.85, 15.35, 3, 3, false];

			
			var start = 1; //used to enter menu upon initializing the above values.
			if (start == 1){
				enterMainMenu();
			}
		}
		public function enterMainMenu(){
			stage.addChild(mainMenu);	//Add graphic for the menu
			mainMenu.x = 0;				//Place graphic to align to the screen
			mainMenu.y = Height;
			if (placeInSong == 0){					//if the menu song is not currently playing...
				MusicChannel.stop();				//stop any other songs
				MusicChannel = menuMusic.play();	//play the menu song
			}

			stage.addEventListener(KeyboardEvent.KEY_DOWN, mMenuCommand);			//To determine what to do when pressing keys
			MusicChannel.addEventListener(Event.SOUND_COMPLETE, menuSongFinished);	//If the song reaches its end (to restart the song)
		}
		public function menuSongFinished(e:Event){	//used to loop songs
			MusicChannel.stop();					//stop the song currently playing
			MusicChannel = menuMusic.play();		//start the song from the beginning.
		}
		
		public function mMenuCommand (ke:KeyboardEvent){	//Keyboard commands in the main menu
			if (ke.keyCode == Keyboard.RIGHT){	//Right key
				MainButtonNum += 1;				//Increases the main menu's button num (to go to next button; commanded in switch below)
			}
			if (ke.keyCode == Keyboard.LEFT){	//Left key
				MainButtonNum -= 1;				//Decreases the main menu's button num to go to previous button
			}
			if (ke.keyCode == 65){ 	//A to select
				menuSelect();		//used to select the button. the function will direct the game to the selected menu
			}
			
			if (MainButtonNum == -1){	//if the main button num is less than the min
				MainButtonNum = 2;		//set it to max (this allows for you to go left from the first button to reach the last button)
			}
			if (MainButtonNum == 3){	//similarly if the number is more than max, set it to min.
				MainButtonNum = 0;
			}
			
			switch (MainButtonNum){		//To move the graphic that hovers over the selected button
				case 0:
				mainMenu.mmSelect.x = mainMenu.instructButton.x;
				mainMenu.mmSelect.y = mainMenu.instructButton.y;
				break;
				case 1:
				mainMenu.mmSelect.x = mainMenu.lvlButton.x;
				mainMenu.mmSelect.y = mainMenu.lvlButton.y;
				break;
				case 2:
				mainMenu.mmSelect.x = mainMenu.aboutButton.x;
				mainMenu.mmSelect.y = mainMenu.aboutButton.y;
				break;
			}
		}
		
		public function menuSelect(){		//Used upon selecting a button in the main menu
			placeInSong = MusicChannel.position;		//set place in song so that the program knows a song is playing
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, mMenuCommand);	//Remove the event listener from the main menu for the end of the song. A new one will be added in the next menu.
			stage.removeChildAt(1);		//Remove the main menu graphic
			switch (MainButtonNum){		//Which button was selected
				case 0:
				MainButtonNum = 0;		//The first one will lead to instructions
				displayInstructions();
				break;
				case 1:					//The second will lead to level select
				levelSelect();
				break;
				case 2:					//The third will give info about myself and why I made the game
				displayAbout();
				break;
			}
		}

		public function displayInstructions(){		//Used to control the instructions screen
			stage.addChild(instructions);						//Add graphic for the menu
			instructions.InstructChang1.gotoAndStop("Stand");	//Make graphics of chang stand
			instructions.InstructChang2.gotoAndStop("Stand");
			instructions.InstructChang2.scaleX = -1.5;			//Make the second chang face left and be large (the other one is already large in the movieclip)
			instructions.instructBoss.gotoAndStop("Stand");		//Make the boss graphic go to stand
			instructions.instructEnemy.gotoAndStop("Stand");	//Make the enemy graphic go to stand
			
			MusicChannel.addEventListener(Event.SOUND_COMPLETE, menuSongFinished); 	// Add an event listener for the song's end to loop it
			stage.addEventListener(KeyboardEvent.KEY_DOWN, iMenuCommand);			// Add an event listener for the a key press that will interact with the menu
		}
		
		public function iMenuCommand (ke:KeyboardEvent){	//When a key is pressed on the instructions menu
			if (ke.keyCode == Keyboard.RIGHT){	//Right Key
				InstructButtonNum += 1;			//Move position of button selctor right (through switch below)
			}
			if (ke.keyCode == Keyboard.LEFT){	//Left Key
				InstructButtonNum -= 1;			//Move position of button selctor left (through switch below)
			}
			if (ke.keyCode == 65){ 				//A to select
				instructSelect();				//Upon selecting a button, a function will make that the button do its job
			}
			
			if (InstructButtonNum == -1){		//To allow users to move left across the leftmost button to go to the rightmost one
				InstructButtonNum = 2;
			}
			if (InstructButtonNum == 3){		//To allow users to move right across the leftmost button to go to the leftmost one
				InstructButtonNum = 0;
			}
			
			switch (InstructButtonNum){			//Move the button selector acording to it's position value
				case 0:
				instructions.instructSelect.x = instructions.instructPrev.x;
				instructions.instructSelect.y = instructions.instructPrev.y;
				break;
				case 1:
				instructions.instructSelect.x = instructions.instructNext.x;
				instructions.instructSelect.y = instructions.instructNext.y;
				break;
				case 2:
				instructions.instructSelect.x = instructions.instructReturn.x;
				instructions.instructSelect.y = instructions.instructReturn.y;
				break;
			}
		}
		
		public function instructSelect(){	//Upon selecting a button in the instructions menu
			if (InstructPage == 6){							//This page shows the weapons, and thus the weapons are moved on screen
					instructions.instructWeapon.x = 905;
			}
			if (InstructPage == 7 ){						//This page shows enemies, thus they are moved on screen
				instructions.instructBoss.x = 900;
				instructions.instructEnemy.x = 900;
			}
			switch(InstructButtonNum){	//Switch for which button the user pressed
				case 0:					//If the "previous" button was pressed, go to the previous instruction
				if(InstructPage > 0){
					InstructPage -=1;
				}
				nextInstruction();		//Function that will change intstruction text by page
				break;
				case 1:					//If the "next" button was pressed, go to the next instruction
				if (InstructPage < 7){	
					InstructPage += 1;
				}
				nextInstruction();		//Function that will change intstruction text by page
				break;
				case 2:					//If the "return" button is pressed, go to the main menu
				InstructButtonNum = 0;
				InstructPage = 0;
				placeInSong = MusicChannel.position; //Ensure that the program is aware that the menu song is playing
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, iMenuCommand);//remove event listener for key presses in the instructions menu
				stage.removeChildAt(1);		//remove the graphic for the instruction menu
				enterMainMenu();			//return to the main menu
				break;
			}
		}
		
		public function nextInstruction(){	//Upon changing the instruction page (next or previous)
			switch(InstructPage){
				case 0:	//First Page introduces you to the storyline
				instructions.InstructChang1.gotoAndStop("Stand");
				instructions.InstructChang2.gotoAndStop("Stand");
				instructions.InstructionText.text = "This is Senor Chang.\n\nHe is participating in a schoolwide paintball event.\n\nYou must control him and win the competition.";
				break;
				case 1:	//Second Page tells you how to run
				instructions.InstructChang1.gotoAndStop("Run");
				instructions.InstructChang2.gotoAndStop("Run");
				instructions.InstructionText.text = "To make Senor Chang run, press the left or right keys.";
				break;
				case 2:	//Third Page tells you how to jump
				instructions.InstructChang1.gotoAndStop("Jump");
				instructions.InstructChang2.gotoAndStop("Jump");
				instructions.InstructionText.text = "To make Senor Chang jump, press the up key.";
				break;
				case 3:	//Fourth Page tells you how to duck
				instructions.InstructChang1.gotoAndStop("Duck");
				instructions.InstructChang2.gotoAndStop("Duck");
				instructions.InstructionText.text = "To make Senor Chang duck, press the down key.";
				break;
				case 4:	//Fifth Page tells you how to shoot.
				instructions.InstructChang1.gotoAndStop("Shoot");
				instructions.InstructChang2.gotoAndStop("Shoot");
				instructions.InstructionText.text = "To make Senor Chang shoot, press the 'A' key.";
				case 5:	//Sixth Page tells you that you can run/jump and shoot at the same time
				instructions.InstructChang1.gotoAndStop("RunShoot");
				instructions.InstructChang2.gotoAndStop("JumpShoot");
				instructions.InstructionText.text = "Senor Chang is able to run and shoot at the same time.\n\n\nHe can also jump and shoot.";
				break;
				case 6:	//Seventh Page tells you about switching weapons
				instructions.InstructChang1.gotoAndStop("Shoot");
				instructions.InstructChang2.gotoAndStop("Shoot");
				instructions.InstructionText.text = "You can pick up better weapons as you progress through the game.\nPress 'S' to change between weapons.";
				instructions.instructWeapon.x = 200;
				break;
				case 7:	//Eigth page tells you about enemies
				instructions.InstructChang1.gotoAndStop("Win");
				instructions.InstructChang2.gotoAndStop("Win");
				instructions.InstructionText.text = "You'll face many enemies, and bosses in your efforts. Good Luck!";
				instructions.instructBoss.x = 350;
				instructions.instructEnemy.x = 150;
				break;
			}
		}
		
		public function displayAbout(){	//Upon selecting the About button from the main menu
			stage.addChild(about);		//Add Graphic
			stage.addEventListener(KeyboardEvent.KEY_DOWN, aboutCommand);	//Add Event listener for the button to return to menu
			MusicChannel.addEventListener(Event.SOUND_COMPLETE, menuSongFinished);	//Add listener for end of song so you can loop it
		}
		
		public function aboutCommand(ke:KeyboardEvent){	//Upon pressing a button in the about menu
			if (ke.keyCode ==65) { //A to select)
				placeInSong = MusicChannel.position;	//tell program where you are in the song
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, aboutCommand);	//Remove the listener for the select button
				stage.removeChildAt(1);	//remove graphic
				enterMainMenu();	//return to main menu
			}
		}
		
		public function levelSelect(){		//Upon pressing level select in the main menu, OR returning to lvl select from a level
			if (placeInSong == 0){							//If a song is not already playing
				MusicChannel = menuMusic.play(placeInSong);	//Play the menu song
			}
			stage.addChild(lvlSelect);	//Add the graphic
			var maxLvl;	//This is used to store the highest unlocked level.
			
			for (var unlockTest:int = 0; unlockTest < 8; unlockTest++){	//See if each level is unlocked
				if (levelInfo[unlockTest][10] == 1){	//if the given level is unlocked
					maxLvl = unlockTest; //set it as the max level.
				}
			}
			
			lvlSelect.lvlLocks.x = 600 + 300*maxLvl + 300*Math.floor(maxLvl/7);	//Move the lock graphics over to cover only the unlocked levels.
			
			MusicChannel.addEventListener(Event.SOUND_COMPLETE, menuSongFinished);	//listen for end of song to allow for looping
			stage.addEventListener(KeyboardEvent.KEY_DOWN, lvlMenuCommand);		//listen for key presses
		}
		
		public function lvlMenuCommand (ke:KeyboardEvent){		//Upon pressing a key in the menu
			if (ke.keyCode == Keyboard.RIGHT){				//Right key
				if(LvlButtonY == 1 && LvlButtonX < 7){		//If you are in the second row (levels) and are not at the last level's button already
					if (levelInfo[LvlButtonX+1][10] == 1){	//If the next level is unlocked, hover over that lvl's button
						lvlSelect.LvlPanel.x -= 300;
						lvlSelect.lvlLocks.x -= 300;
						LvlButtonX += 1;
					}
				}
				if(LvlButtonY == 2 && DiffButtonX < 2){		//If you are in the thurd row (diff.), and are not already on the hard button,
					DiffButtonX += 1;						//Move to the next difficulty (easy --> med, med --> hard)
					lvlDifficulty +=1;
					lvlSelect.difficultyPanel.x -= 300;
				}
			}
			if (ke.keyCode == Keyboard.LEFT){				//Left Key
				if(LvlButtonY == 1 && LvlButtonX > 0){		//If not on the second row (levels) and not on the tutorial button
					lvlSelect.LvlPanel.x += 300;			//Go to the prev lvl's button
					LvlButtonX -= 1;
					lvlSelect.lvlLocks.x += 300;
				}
				if(LvlButtonY == 2 && DiffButtonX >0){		//If you are in the thurd row (diff.), and are not already on the easy button
					DiffButtonX -= 1;						//Move the prev. difficulty (hard --> med, med --> easy)
					lvlDifficulty -=1;						//Set the level Difficulty golbal var accordingly.
					lvlSelect.difficultyPanel.x += 300;
				}
			}
			if (ke.keyCode == Keyboard.DOWN){				//Down Key
				if (LvlButtonY < 2){						//If not already on the lowest row of buttons, move down
					lvlSelect.lvlSelectBox.y += 130;		
					LvlButtonY += 1;
				}
			}
			if (ke.keyCode == Keyboard.UP){					//Up Key
				if (LvlButtonY > 0){						//If not already on highest row of buttons, move up
					lvlSelect.lvlSelectBox.y -= 130;
					LvlButtonY -= 1;
				}
			}
			if (ke.keyCode == 65){ 							//A to select a button
				loadLvl();									//Load the lvl or return to main menu depending on row
			}
		}
		
		public function loadLvl(){		//Upon pressing the Select button in the lvl select menu
			if (LvlButtonY == 0) {						//If on the row for return (to main menu), then do so
				placeInSong = MusicChannel.position;	//tell program that the menu song is playing
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, lvlMenuCommand);	//remove the listener for key input
				stage.removeChildAt(1);		//remove graphic for lvl select
				enterMainMenu();			//return to main menu
			}
			if (LvlButtonY == 1){						//If on the row for levels, then load the leve
				MusicChannel.removeEventListener(Event.SOUND_COMPLETE, menuSongFinished);	//remove listener for the end of the menu song
				MusicChannel.stop();														//stop the menu song
				placeInSong = 0;															//Tell program that the menu song is not playing
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, lvlMenuCommand);			//remove listener for keys in the lvl select menu
				stage.removeChildAt(1);							//remove lvl select menu graphic
				lvlNum = LvlButtonX;							//Set the level number global var to the lvl that was selected
				playLevel();									//Load in the level using the lvlNum function
			}
		}
		
		public function playLevel(){		//Upon selecting a level
			isBossKill = false;				//The boss is not dead yet, so make sure the variable agrees.
			
			//Initialize boss info (health changes in game, so this is declared each time)
			//bossinfo [0-initialx, 1-maxX, 2-minX, 3-initialY, 4-Scale(x&y), 5-Health, 6-ShootSpeed, 7-ReloadTime, 8-Damage]
			bossInfo[1] = [1800, 1820, 1380, ground, 1.25, 100, 30, 0, 5];//Troy
			bossInfo[2] = [1550, 1620, 1540, 430.15, 1.5, 160, 30, 0, 10];//Annie
			bossInfo[3] = [1480, 1730, 1480, 481, 1.0, 220, 30, 0, 20];//Pierce
			bossInfo[4] = [2250, 2300, 2250, ground, 1.5, 350, 24, 0, 40];//Shirley
			bossInfo[5] = [1800, 1800, 1800, ground, 1.25, 500, 24, 0, 60];//Abed
			bossInfo[6] = [1900, 1850, 2000, ground, 1.25, 1000, 30, 0, 50];//Britta
			bossInfo[7] = [1850, 1850, 1800, 100, 1.25, 2000, 24, 0, 90];//Jeff
			var multiplyer = 1 + (lvlDifficulty-1)/3;		//Based on the difficulty selected in the lvl select menu, make a multiplyer (easy is 0.67, med is 1, hard is 1.33)
			
			switch(lvlNum){
				case 0:									//If tutorial was selected
				levelImg = new Tutorial();				//Add Tutorial level graphic
				isBossKill = true;						//There is no boss, so make it so the boss is dead to allow for exit door use
				MusicChannel = tutorialMusic.play();	//Play song
				break;
				case 1:									//If lvl 1 was selected
				levelImg = new Level01();				//Set the image variable to the level's graphic
				Boss = new Troy();						//Add boss variable to the level's boss graphic
				MusicChannel = level1Music.play();		//Set the music channel to the level's music.
				break;
				case 2:									//If any other level was selected, do as lvl 1, but with that level's boss, graphic and song.
				levelImg = new Level02();
				Boss = new Annie();
				MusicChannel = level2Music.play();
				break;
				case 3:
				levelImg = new Level03();
				Boss = new Pierce();
				MusicChannel = level3Music.play();
				break;
				case 4:
				levelImg = new Level04();
				Boss = new Shirley();
				MusicChannel = level4Music.play();
				break;
				case 5:
				levelImg = new Level05();
				Boss = new Abed();
				MusicChannel = level5Music.play();
				break;
				case 6:
				levelImg = new Level06();
				Boss = new Britta();
				MusicChannel = level6Music.play();
				break;
				case 7:
				levelImg = new Level07();
				Boss = new Jeff();
				MusicChannel = level7Music.play();
				break;
			}
			addChild(levelImg);				// Add the level's graphic as set in the above switch
			levelImg.y += Height;			//Align the graphic to the screen
			if (lvlNum !=0){				//If not tutorial (then you have a boss) initialize the boss
				addChild(Boss);						//Add the graphic for the boss
				Boss.x = bossInfo[lvlNum][0];		//Set the boss' initial position and scale using the above array
				Boss.y = bossInfo[lvlNum][3];
				Boss.scaleX = bossInfo[lvlNum][4];
				Boss.scaleY = bossInfo[lvlNum][4];
				isBossGround = true;				//make the boss grounded
				Boss.gotoAndStop("Stand");			//make the boss stop at the stand position
				bossInfo[lvlNum][5] *= multiplyer;	//multiply boss' health by multiplier
				bossInfo[lvlNum][8] *= multiplyer;	//multiply boss' damage by multiplier
			}

			
			//ADD CHANG SPRITE, Initialize position (same for all lvls), and make him stand
			addChild(chang);
			chang.x = 70;
			chang.y = ground;
			chang.scaleX = changScale;
			chang.scaleY = changScale;
			chang.gotoAndStop("Stand");
			
			
			//RESET ENEMY INFO
			enemyMCount = 0;	//counter of number of enemies in lvl
			lastEnemyM = 0;		//number of the laste enemy in the lvl
			isDoor = false;		//to determine if chang is at a door
			isBossSeen = false;	//to determine if the boss has been seen (and thus can move all over the map)
			ventWeapon = 0;		//the number of the weapon unlocked in the level's vent.
			//INITIALIZE INFO FOR ALL ENEMIES:
			//MALE SPRITES: //[0-lvl, 1-Number, 2-minX, 3-maxX, 4-scaleX, 5-y, 6-currEnergy, 7-maxEnergy, 8-ShootRate, 9-ReloadValue 10-BASEDamage, 11-Dead?, 12-ActualDamage]
			//Tutorial
			enemyMInfo[0] = [0, "M1", 320, 440, 1, 516.15, 30, 30, -1, 0, 0, false, 0];
			enemyMInfo[1] = [0, "M2", 620, 950, 1, 563, 40, 40, 48, 0, 10, false, 10];
			//Lvl 1
			enemyMInfo[2] = [1, "M1", 460, 460, -1, 491, 60, 60, 24, 0, 10, false, 10];
			enemyMInfo[3] = [1, "M2", 650, 650, 1, 516.15, 60, 60, 20, 0, 5, false, 10];
			//LVL 2
			enemyMInfo[4] = [2, "M1", 470, 470, -1, 480, 60, 60, 24, 0, 10, false, 10];
			enemyMInfo[5] = [2, "M2", 640, 640, -1, 372, 80, 80, 30, 0, 12, false, 10];
			enemyMInfo[6] = [2, "M3", 720, 840, 1, 437, 50, 50, 24, 0, 15, false, 10];
			//LVL 3
			enemyMInfo[7] = [3, "M1", 370, 370, -1, 372, 100, 100, 40, 0, 20, false, 10];
			enemyMInfo[8] = [3, "M2", 540, 540, -1, 372, 100, 100, 40, 20, 21, false, 10];
			enemyMInfo[9] = [3, "M3", 720, 720, -1, 372, 100, 100, 40, 0, 22, false, 10];
			enemyMInfo[10] = [3, "M4", 900, 900, -1, 372, 100, 100, 40, 20, 23, false, 10];
			//LVL 4
			enemyMInfo[11] = [4, "M1", 440, 440, -1, 487, 120, 120, 20, 0, 25, false, 10];
			enemyMInfo[12] = [4, "M2", 620, 620, -1, 447.5, 130, 130, 20, 0, 29, false, 10];
			enemyMInfo[13] = [4, "M3", 805, 805, -1, 408, 140, 140, 20, 0, 31, false, 10];
			enemyMInfo[14] = [4, "M4", 945, 945, -1, 432, 150, 150, 20, 0, 33, false, 10];
			enemyMInfo[15] = [4, "M5", 1185, 1185, -1, 432, 150, 150, 20, 0, 33, false, 10];
			//LVL 5
			enemyMInfo[16] = [5, "M1", 620, 620, -1, ground, 200, 200, 30, 0, 50, false, 10];
			enemyMInfo[17] = [5, "M2", 920, 920, -1, ground, 200, 200, 29, 0, 50, false, 10];
			enemyMInfo[18] = [5, "M3", 1220, 1220, -1, ground, 200, 200, 28, 0, 55, false, 10];
			enemyMInfo[19] = [5, "M4", 1520, 1520, -1, ground, 200, 200, 27, 0, 55, false, 10];
			//LVL 6
			enemyMInfo[20] = [6, "M1", 405, 405, 1, ground, 320, 320, 48, 24, 60, false, 10];
			enemyMInfo[21] = [6, "M2", 740, 740, -1, ground, 320, 320, 48, 0, 60, false, 10];
			enemyMInfo[22] = [6, "M3", 860, 860, -1, 372, 400, 400, 30, 0, 65, false, 10];
			enemyMInfo[23] = [6, "M4", 1000, 1000, 1, ground, 320, 320, 48, 24, 55, false, 10];
			enemyMInfo[24] = [6, "M5", 1445, 1445, -1, ground, 400, 400, 48, 0, 75, false, 10];
			enemyMInfo[25] = [6, "M6", 1535, 1535, -1, 421.45, 320, 320, 30, 0, 70, false, 10];
			//LVL 7
			enemyMInfo[26] = [7, "M1", 375, 375, 1, ground, 500, 500, 24, 0, 80, false, 10];
			enemyMInfo[27] = [7, "M2", 485, 485, 1, 445, 500, 500, 96, 0, 80, false, 10];
			enemyMInfo[28] = [7, "M3", 545, 545, 1, 320, 500, 500, 96, 0, 80, false, 10];
			enemyMInfo[29] = [7, "M4", 950, 950, -1, 190, 500, 500, 30, 0, 100, false, 10];
			enemyMInfo[30] = [7, "M5", 950, 950, -1, 320, 500, 500, 96, 48, 80, false, 10];
			enemyMInfo[31] = [7, "M6", 950, 950, -1, 445, 500, 500, 96, 48, 80, false, 10];
			enemyMInfo[32] = [7, "M7", 1255, 1255, -1, 485, 320, 320, 30, 0, 100, false, 10];
			
			//ADD ENEMIES TO STAGE;
			for (var addEnemyM:int = 0; addEnemyM < enemyMInfo.length; addEnemyM++){ //go through all enemies in the array
				if(enemyMInfo[addEnemyM][0] == lvlNum){					//if their lvl num matches the current level
					var enemyM:MaleEnemy = new MaleEnemy();				//place them all on stage
					addChild(enemyM);
					enemyM.x = enemyMInfo[addEnemyM][2];
					enemyM.y = enemyMInfo[addEnemyM][5];
					enemyM.scaleX = enemyMInfo[addEnemyM][4];
					enemyM.scaleY = Math.abs(enemyMInfo[addEnemyM][4]);
					
					if (enemyMInfo[addEnemyM][2] == enemyMInfo[addEnemyM][3]){	//If their max and min x are the same, then make them stationary
						enemyM.gotoAndStop("Stand");
					}
					else {									//otherwise, they will walk between max x and min x
						enemyM.gotoAndStop("Walk");
					}
					enemyM.name = (enemyMInfo[addEnemyM][1]);			//Name each enemy with their designated name
					enemyMInfo[addEnemyM][6] = enemyMInfo[addEnemyM][7] * multiplyer;	//multiply health and damage by the multiplier
					enemyMInfo[addEnemyM][12] = enemyMInfo[addEnemyM][10] * multiplyer;					
					enemyMCount ++;			//increase the enemy counter
					lastEnemyM = addEnemyM;	//make the last enemy the array number of the current enemy
				}
				else if (enemyMInfo[addEnemyM][0] > lvlNum){		//If the lvl num is less than the enemy's level
					addEnemyM = enemyMInfo.length;		//set the addEnemyM variable such that it will exit the for loop
				}
			}
			
			//Text formatting
			var weaponFormat:TextFormat = new TextFormat();	//Initialize the text format that will apply to the name of the weapon in use
			weaponFormat.size = 20;
			weaponFormat.font = ("Century Gothic");
			weaponFormat.color = 0xFFFFFF;
			weaponFormat.align = 'right';
			
			var energyFormat:TextFormat = new TextFormat(); //Initialize the text format that will apply to the current health text
			energyFormat.font = ("Century Gothic");
			energyFormat.size = 48;
			energyFormat.color = 0xFFFFFF;
			
			//ADD TOP WEAPON INFO
			addChild(topWeapon);				//add an image of the current weapon in the top left corner
			topWeapon.alpha = 0.5;
			topWeapon.x = 700;
			topWeapon.y = 75;
			topWeapon.gotoAndStop(weaponNum+1);		//make that weapon stop at the current weapon
			
			addChild(weaponText);			//Add the text box that will store the weapon's name
			weaponText.x = 600;
			weaponText.y = 5;
			weaponText.alpha = 0.6;
			weaponText.width = 150;
			weaponText.height = 100;
			weaponText.defaultTextFormat = weaponFormat;
			weaponText.text = weaponInfo[weaponNum][0];	//make that text box show the current weapon's name
			
			addChild(ammoText);			//Add the text box that will store the weapon's ammo
			ammoText.x = 650;
			ammoText.y = 100;
			ammoText.alpha = 0.6;
			ammoText.width = 100;
			ammoText.height = 100;
			ammoText.defaultTextFormat = weaponFormat;
			if (weaponInfo[weaponNum][5] >= 0){				//If the current ammo not negative (signifies limited ammo)
				ammoText.text = weaponInfo[weaponNum][5];	//show the weapon's remaining ammo
			}
			else{											//Otherwise (unlimited ammo for that weapon)
				ammoText.text = "Unlimited";				//Show "Unlimited"
			}
			
			var promptTextFormat:TextFormat = new TextFormat();	//Initialize the format of any prompting text
			promptTextFormat.size = 32;
			promptTextFormat.font = ("Century Gothic");
			promptTextFormat.color = 0xFF0000;
			promptTextFormat.align = 'center';
			addChild(promptText)				//add a text box to store any prompts, align it to be below the health info
			promptText.x = 20;
			promptText.y = 100;
			promptText.width = 500;
			promptText.height = 100;
			promptText.alpha = 0.7;
			promptText.defaultTextFormat = promptTextFormat;
			promptText.text = "";		//make it blank until a prompt is needed
			
			//ADD ENERGY INFO
			addChild(heart);		//add pic of heart, and align to top left
			heart.alpha = 0.5;
			heart.x = 50;
			heart.y = 75;
			addChild(lifeText);		//Add text box for health remaining
			lifeText.x = 100;		//Align to be to the right of the heart
			lifeText.y = 45;
			lifeText.width = 100;
			lifeText.height = 100;
			lifeText.alpha = 0.6
			
			lifeText.defaultTextFormat = energyFormat;
			lifeText.text = changCurrEnergy;	//set the text for health to chang's current health
			
			//ALLOW FOR KEYBOARD CONTROLS AND GAMEPLAY
			stage.addEventListener(KeyboardEvent.KEY_DOWN, commandChang);		//Listen for key presses
			stage.addEventListener(KeyboardEvent.KEY_UP, stopChang);			//listen for released keys
			stage.addEventListener(Event.ENTER_FRAME, gamePlay);				//commands for every frame
			MusicChannel.addEventListener(Event.SOUND_COMPLETE, levelSongFinished);	//lisetn for end of song to allow music to loop
		}
		
		public function levelSongFinished(e:Event){		//If the song ends...
			MusicChannel.stop();						//stop the current song
			switch(lvlNum){								//Depending on the level
				case 0:									
				MusicChannel = tutorialMusic.play();	//Play the song for that level from the start (loop)
				break;
				case 1:
				MusicChannel = level1Music.play();
				break;
				case 2:
				MusicChannel = level2Music.play();
				break;
				case 3:
				MusicChannel = level3Music.play();
				break;
				case 4:
				MusicChannel = level4Music.play();
				break;
				case 5:
				MusicChannel = level5Music.play();
				break;
				case 6:
				MusicChannel = level6Music.play();
				break;
				case 7:
				MusicChannel = level7Music.play();
				break;
			}
		}
		
		public function commandChang (ke:KeyboardEvent){	//Upon pressing a key in game
			if (ke.keyCode == Keyboard.RIGHT)		//Right Key
			{
				run = true;							//Make chang face the right direction and have positive speed
				chang.scaleX= changScale;
				xSpeed = runSpeed;
			}
			else if (ke.keyCode == Keyboard.LEFT)	//Left Key
			{
				run = true;							//Make chang face the left direction and have negative speed
				chang.scaleX = -changScale;
				xSpeed = -runSpeed;
			}
			if (ke.keyCode == Keyboard.DOWN)		//Down Key
			{
				duck = true;						//Make Chang Duck
			}
			if (ke.keyCode == Keyboard.UP)			//Up Key
			{
				if (!jump)							//If Chang is not already in the air
				{
					jumpSound.play();				//Play the jump sound, and make him jump
					ySpeed= -jumpPower;
					jump = true;
					chang.y -= 2;
				}
			}
			if (ke.keyCode == 65) // A for Shoot
			{
				shoot = true;
			}
			if (ke.keyCode == 83) // S for other things (doors, weapon change)
			{
				isBbutton = true;
				//ChangingWeapon;
				if(isDoor == false){	//if not at a door
					for (var changeCount = 1; changeCount < 15; changeCount++){	//for every weapon
						weaponNum += 1;					//go to next weapon
						if (weaponNum == 14){			//if at last weapon, go to first weapon
							weaponNum = 0;
						}
						if (weaponInfo[weaponNum][7] == true && weaponInfo[weaponNum][5] != 0){	//If the weapon is unlocked
							changeCount = 15;		//stop the for loop, and set it to that weapon
						}
					}
					topWeapon.gotoAndStop(weaponNum + 1);			//change the top weapon icon
					if (weaponInfo[weaponNum][5] >= 0){				//Change ammo text (limited/unlimited)
						ammoText.text = weaponInfo[weaponNum][5];
					}
					else{
						ammoText.text = "Unlimited";
					}
					weaponText.text = weaponInfo[weaponNum][0];		//Change weapon name text
				}
			}
		}
		
		public function gamePlay(e:Event) {					//Upon entering a frame
			//Control Boss
			if (lvlNum != 0 && isBossKill == false){		//If the boss is not dead, move it...
				//Ground State
				isBossGround = false;						//intialize the whether he is gorunded/jumping to be false
				isBossJump = false;
				
				if(Boss.x > -50 && Boss.x < 850){			//If the boss is close enough to being on screen, then set isBossSeen to true
					bossInfo[lvlNum][2] = 0;				//Set the boss's bounds to be anywhere in the level.
					bossInfo[lvlNum][1] = levelImg.width;	//This will allow the boss to move on his/her own accord, and react to chang's movement
					isBossSeen = true;
				}
				//move Towards Chang while staying within restricted area. When chang is near, the boss may leave this area
				//bossinfo [0-initialx, 1-maxX, 2-minX, 3-initialY, 4-Scale(x&y), 5-Health, 6-ShootSpeed, 7-ReloadTime, 8-Damage]
				if (Boss.x > (chang.x - stage.x)){				//If the boss is to the right of chang
					if (Boss.x - (chang.x - stage.x) > 150){	//If the boss is very far from chang
						if (Boss.x > bossInfo[lvlNum][2] + levelImg.x){	//if the boss is not past his boundary
							Boss.gotoAndStop("Run");					//make him run closer to chang
							BossXSpeed = -5;
							Boss.scaleX = - bossInfo[lvlNum][4];
						}
						else{											//if the boss is past his boundary
							Boss.gotoAndStop("Stand");					//make him wait
							BossXSpeed = 5;
							Boss.scaleX = - (bossInfo[lvlNum][4]);
						}
					}
					else if (Boss.x - (chang.x - stage.x) < 100){	//If the boss is very close to chang
						bossInfo[lvlNum][7] += 1;					//allow him to reload
						Boss.gotoAndStop("RunShoot");				//make him stay in runshoot position
						BossXSpeed = 5;								//make him move away
						Boss.scaleX = - bossInfo[lvlNum][4];		//make him face chang
						if(chang.y < Boss.y){						//if chang is above the boss, make boss jump
							isBossJump = true;
						}
					}
					else{											//if boss is on screen but far enough from chang
						Boss.gotoAndStop("RunShoot");				//make him run shoot, but not move
						bossInfo[lvlNum][7] += 1;					//increase reload
						if(chang.y < Boss.y){						//if chang is above boss, make him jump.
							isBossJump = true;
						}
					}
				}
				else{											//If the boss is to the left of chang, do the same as above but in the opposite direction.
					if (Boss.x - (chang.x - stage.x) < -150){
						if (Boss.x < bossInfo[lvlNum][1] + levelImg.x){
							Boss.gotoAndStop("Run");
							BossXSpeed = 5;
							Boss.scaleX = - bossInfo[lvlNum][4];
						}
						else{
							Boss.gotoAndStop("Stand");
							BossXSpeed = -5;
							Boss.scaleX = - bossInfo[lvlNum][4];
						}
					}
					else if (Boss.x - (chang.x - stage.x) > -105){
						bossInfo[lvlNum][7] += 1;
						Boss.gotoAndStop("RunShoot");
						BossXSpeed = 5;
						Boss.scaleX = - bossInfo[lvlNum][4];
						if(chang.y < Boss.y){
							isBossJump = true;
						}
					}
					else{
						bossInfo[lvlNum][7] += 1;
						Boss.gotoAndStop("Shoot");
						if(chang.y < Boss.y){
							isBossJump = true;
						}
					}
				}
				
				if (bossInfo[lvlNum][7] >= bossInfo[lvlNum][6]){	//If the boss has spent enough time between shots
					var Bbullet:Bullet = new Bullet();				//prepare a bullet graphic
					if (lvlNum > 4){								//if on lvl 4 or greater
						if (Math.abs(Boss.y - chang.y) < 20){		//only shoot if chang's y value is only +/-20 that of boss
							bossInfo[lvlNum][7] = 0;				//restart the reload timer
							addChild(Bbullet);						//Add the bullet graphic
							Bbullet.name = "Ebullet" + EbulletCount;	//Name the bullet using the enemy bullet counter
							EbulletCount ++;							//increase the enemy bullet counter
							Bbullet.gotoAndStop(5);						//make the colour of the bullet purple (for all bosses)
							Bbullet.x = Boss.x + Boss.scaleX * Boss.width/2;	//place the bullet close to the hands of the boss
							Bbullet.y = Boss.y - Boss.height/2;
							if(lvlNum > 5){							//If on lvl 6 or 7
								Bbullet.scaleX = 3;					//Make the bullet larger as well.
								Bbullet.scaleY = 1.1;
							}
							EbulletInfo.push([Bbullet.name, Bbullet.x, Bbullet.y, Boss.scaleX/Boss.scaleY, bossInfo[lvlNum][8]]);//add the bullet's info to the enemy bullet array
						}
					}
					else{
						bossInfo[lvlNum][7] = 0;			//If the level is less than 4
						addChild(Bbullet);					//immediately add the graphic for a bullet, the rest is the same as above
						Bbullet.name = "Ebullet" + EbulletCount;
						EbulletCount ++;
						Bbullet.gotoAndStop(5);
						Bbullet.x = Boss.x + Boss.scaleX * Boss.width/2;
						Bbullet.y = Boss.y - Boss.height/2;
						EbulletInfo.push([Bbullet.name, Bbullet.x, Bbullet.y, Boss.scaleX/Boss.scaleY, bossInfo[lvlNum][8]]);
					}
				}
				
				//Boss' Collision with Furniture
				//CHAIRS
				for (var bossChair:int = 1; bossChair <= levelInfo[lvlNum][1]; bossChair++) //for every chair in the level
				{
					if (levelImg.getChildByName("Chair" + lvlNum + bossChair).hitTestPoint((Boss.x-Boss.width/2), (Boss.y - Boss.height/3), true) || levelImg.getChildByName("Chair" + lvlNum + bossChair).hitTestPoint((Boss.x-Boss.width/2), (Boss.y - Boss.height * 2 / 3), true))
					{//if the boss' left side hits a chair
						Boss.x += BossXSpeed + 5;	//make the boss move away from the chair
						BossXSpeed = 0;				//stop the boss' movement
						isBossJump = true;			//make the boss jump

					}
					else if (levelImg.getChildByName("Chair" + lvlNum + bossChair).hitTestPoint((Boss.x+Boss.width/2), (Boss.y - Boss.height/3), true) || levelImg.getChildByName("Chair" + lvlNum + bossChair).hitTestPoint((Boss.x+Boss.width/2), (Boss.y - Boss.height * 2 / 3), true))
					{//Same thing as above, but with boss' right side
						Boss.x -= xSpeed +1 ;
						xSpeed = 0;
						isBossJump = true;
					}
					else if (levelImg.getChildByName("Chair" + lvlNum + bossChair).hitTestPoint(Boss.x-Boss.width/2, Boss.y, true) || levelImg.getChildByName("Chair" + lvlNum + bossChair).hitTestPoint(Boss.x+Boss.width/2, Boss.y, true))
					{//If the boss lands on top of a chair
						Boss.y = 600 - (levelImg.getChildByName("Chair" + lvlNum + bossChair).y * -1 + levelImg.getChildByName("Chair" + lvlNum + bossChair).height);//make the boss stay on the chair (and not fall through)
						BossYSpeed = 0;			//stop the downward pull from gravity.
						isBossGround = true;	//make boss grounded (so he/she may jump from the top of the chair).
					}
				}
				//COUCHES- same method as chairs
				for (var bossCouch:int = 1; bossCouch <= levelInfo[lvlNum][2]; bossCouch++)
				{
					if (levelImg.getChildByName("Couch" + lvlNum + bossCouch).hitTestPoint((Boss.x-Boss.width/2), (Boss.y - Boss.height/3), true) || levelImg.getChildByName("Couch" + lvlNum + bossCouch).hitTestPoint((Boss.x-Boss.width/2), (Boss.y - Boss.height * 2 / 3), true))
					{
						Boss.x += BossXSpeed + 5;
						BossXSpeed = 0;
						isBossJump = true;
					}
					else if (levelImg.getChildByName("Couch" + lvlNum + bossCouch).hitTestPoint((Boss.x+Boss.width/2), (Boss.y - Boss.height/3), true) || levelImg.getChildByName("Couch" + lvlNum + bossCouch).hitTestPoint((Boss.x+Boss.width/2), (Boss.y - Boss.height * 2 / 3), true))
					{
						Boss.x -= xSpeed +1 ;
						xSpeed = 0;
						isBossJump = true;
					}
					else if (levelImg.getChildByName("Couch" + lvlNum + bossCouch).hitTestPoint(Boss.x-Boss.width/2, Boss.y, true) || levelImg.getChildByName("Couch" + lvlNum + bossCouch).hitTestPoint(Boss.x+Boss.width/2, Boss.y, true))
					{
						Boss.y = 600 - (levelImg.getChildByName("Couch" + lvlNum + bossCouch).y * -1 + levelImg.getChildByName("Couch" + lvlNum + bossCouch).height) +1;
						BossYSpeed = 0;
						isBossGround = true;
					}
				}
				//TABLES, as tables are on a slanted view, the top of the table is consiered about halfway up the table.
				BossGround = 567;//reset the ground value to the actual ground (in case this was changed in the last frame)
				for (var bossTable:int = 1; bossTable <= levelInfo[lvlNum][3]; bossTable++){ //For every talbe
					if (levelImg.getChildByName("Table" + lvlNum + bossTable).hitTestPoint((Boss.x+Boss.width/2), (Boss.y-Boss.height), (true)))
					{//Right side collision like chairs
						Boss.x -= xSpeed +1 ;
						xSpeed = 0;
						isBossJump = true;
					}
					if (levelImg.getChildByName("Table" + lvlNum + bossTable).hitTestPoint((Boss.x-Boss.width/2+2), (Boss.y-Boss.height), (true)))
					{//left side collison like chairs
						Boss.x += BossXSpeed + 5;
						BossXSpeed = 0;
						isBossJump = true;
					}//Below.. if the boss is on top of the table,
					if (levelImg.getChildByName("Table" + lvlNum + bossTable).hitTestPoint((Boss.x - Boss.width/4), (Boss.y ), true) || levelImg.getChildByName("Table" + lvlNum + bossTable).hitTestPoint((Boss.x + Boss.width/4), (Boss.y), true) && Boss.y > 517){
						BossGround = 600 + (levelImg.getChildByName("Table" + lvlNum + bossTable).y) - 63;//set the ground to be halfway up the table
						BossYSpeed = 0;			//stop the boss' movement due to gravity
						isBossGround = true;	//make the boss grounded (to allow for jumps)
					}
				}
				//BOOKSHELVES same as chairs/couches
				for (var BossShelf:int = 1; BossShelf <= levelInfo[lvlNum][4]; BossShelf++)
				{
					if (levelImg.getChildByName("Shelf" + lvlNum + BossShelf).hitTestPoint((Boss.x - Boss.width/2), (Boss.y - Boss.height/2), true))
					{
						Boss.x += BossXSpeed + 5;
						BossXSpeed = 0;
						isBossJump = true;
					}
					if (levelImg.getChildByName("Shelf" + lvlNum + BossShelf).hitTestPoint((Boss.x-Boss.width/2), (Boss.y - Boss.height/3), true) || levelImg.getChildByName("Shelf" + lvlNum + BossShelf).hitTestPoint((Boss.x-Boss.width/2), (Boss.y - Boss.height * 2 / 3), true))
					{
						Boss.x += BossXSpeed + 5;
						BossXSpeed = 0;
						isBossJump = true;
					}
					else if (levelImg.getChildByName("Shelf" + lvlNum + BossShelf).hitTestPoint((Boss.x+Boss.width/2), (Boss.y - Boss.height/3), true) || levelImg.getChildByName("Shelf" + lvlNum + BossShelf).hitTestPoint((Boss.x+Boss.width/2), (Boss.y - Boss.height * 2 / 3), true))
					{
						Boss.x -= xSpeed +1 ;
						xSpeed = 0;
						isBossJump = true;
					}
					else if (levelImg.getChildByName("Shelf" + lvlNum + BossShelf).hitTestPoint(Boss.x+Boss.width/3, Boss.y, true) || levelImg.getChildByName("Shelf" + lvlNum + BossShelf).hitTestPoint(Boss.x-Boss.width/3, Boss.y, true))
					{
						Boss.y = 600 - 228;
						BossYSpeed = 0;
						isBossGround = true;
					}
				}
			}
			
					
			//CONTROL ENEMIES (NON-BOSS) -- Reference: [0-lvl, 1-Name, 2-minX, 3-maxX, 4-scaleX, 5-y, 6-currEnergy, 7-maxEnergy, 8-ShootRate, 9-ReloadValue 10-BASEDamage, 11-Dead?, 12-ActualDamage]
			for (var enemyMCommand = lastEnemyM; enemyMCommand >= (lastEnemyM - enemyMCount +1); enemyMCommand --){ //for each enemy in the level
				if (enemyMInfo[enemyMCommand][11] == false){	//if the enemy is not dead
					enemyMInfo[enemyMCommand][9] += 1			//increase the enemy's reload timer
					if (enemyMInfo[enemyMCommand][9] == enemyMInfo[enemyMCommand][8]){	//if the reload timer is complete
						enemyMInfo[enemyMCommand][9] = 0;				//fire a bullet (same method as the boss' bullets), using values from the enemyInfo array
						var Ebullet:Bullet = new Bullet();
						addChild(Ebullet);
						Ebullet.name = "Ebullet" + EbulletCount;
						EbulletCount ++
						Ebullet.gotoAndStop(1);				//Red bullets for normal enemies.
						Ebullet.x = getChildByName(enemyMInfo[enemyMCommand][1]).x + (enemyMInfo[enemyMCommand][4] * getChildByName(enemyMInfo[enemyMCommand][1]).width/2);
						Ebullet.y = getChildByName(enemyMInfo[enemyMCommand][1]).y - (getChildByName(enemyMInfo[enemyMCommand][1]).height/2);
						EbulletInfo.push([Ebullet.name, Ebullet.x, Ebullet.y, enemyMInfo[enemyMCommand][4], enemyMInfo[enemyMCommand][12]]);
					}
					if (enemyMInfo[enemyMCommand][2] == enemyMInfo[enemyMCommand][3]){	//if the enemy's min and max x values are the same, then do not move them.
						this.getChildByName(enemyMInfo[enemyMCommand][1]).x += 0;
					}
					else if (enemyMInfo[enemyMCommand][4] > 0){ //If their min/max x are different, if they are moving right,
						if((this.getChildByName(enemyMInfo[enemyMCommand][1]).x - levelImg.x) < enemyMInfo[enemyMCommand][3]){//if they are not past their max x
							this.getChildByName(enemyMInfo[enemyMCommand][1]).x += 5;	//move them right 5 units
						}
						else{		//If they have passed the max x...
							enemyMInfo[enemyMCommand][4] *= -1;		//switch their direction
							this.getChildByName(enemyMInfo[enemyMCommand][1]).scaleX = enemyMInfo[enemyMCommand][4];//flip their graphic
						}
					}
					else{		//If they are moving left, same method as moving right but opposite directions
						if (this.getChildByName(enemyMInfo[enemyMCommand][1]).x - levelImg.x > enemyMInfo[enemyMCommand][2]){
							this.getChildByName(enemyMInfo[enemyMCommand][1]).x -= 5;
						}
						else{
							enemyMInfo[enemyMCommand][4] *= -1;
							this.getChildByName(enemyMInfo[enemyMCommand][1]).scaleX = enemyMInfo[enemyMCommand][4];
						}
					}
				}
			}
			
			//control Ducking/sliding
			if (duck == true && xSpeed != 0 && jump == false)	//If chang is ducking, sliding, and not in the air
			{
				duckTime += 1;		//increase the timer by one
				if (duckTime > 24)	//if chang ducks (and slides) for too long, make him stop ducking
				{
					duck = false;
				}
			}
			
			//ENEMY BULLETS & BOSS BULLETS
			for (var ebullets:int = 0; ebullets < EbulletInfo.length; ebullets++){	//For every stored enemy/boss bullet
				var removeEBullet = false;		//initialize removebullet to false. If this becomes true, the bullet will be removed later
				this.getChildByName(EbulletInfo[ebullets][0]).x += EbulletInfo[ebullets][3] * bulletSpeed;	//move the bullet according to bullet speeds in the game
				
				if (getChildByName(EbulletInfo[ebullets][0]).hitTestObject(chang)){	//if the bullet hits chang
					changCurrEnergy -= Math.round(EbulletInfo[ebullets][4]);		//reduce his energy by bullet's damage
					lifeText.text = changCurrEnergy;								//change the life text at the top left
					removeEBullet = true;											//remove the bullet
					
					if (changCurrEnergy <= 0){		//if chang's energy is used up, go to the game over screen
						gameOver();
					}
				}
								
				if (this.getChildByName(EbulletInfo[ebullets][0]).x < EbulletInfo[ebullets][1] - 1000 || this.getChildByName(EbulletInfo[ebullets][0]).x > EbulletInfo[ebullets][1] + 1000){
					removeEBullet = true;	//If the bullet moves more than 1000 pixels from the shooter, remove it
				}
				//For every piece of furniture, if the bullet hits the furniture, remove the bullet
				for (var ebulletChair:int = 1; ebulletChair <= levelInfo[lvlNum][1]; ebulletChair++){
					if (getChildByName(EbulletInfo[ebullets][0]).hitTestObject(levelImg.getChildByName("Chair" + lvlNum + ebulletChair))){
						removeEBullet = true;
					}
				}
				for (var ebulletCouch:int = 1; ebulletCouch <= levelInfo[lvlNum][2]; ebulletCouch++){
					if (getChildByName(EbulletInfo[ebullets][0]).hitTestObject(levelImg.getChildByName("Couch" + lvlNum + ebulletCouch))){
						removeEBullet = true;
					}
				}
				for (var ebulletShelf:int = 1; ebulletShelf <= levelInfo[lvlNum][4]; ebulletShelf++){
					if (getChildByName(EbulletInfo[ebullets][0]).hitTestObject(levelImg.getChildByName("Shelf" + lvlNum + ebulletShelf))){
						removeEBullet = true;
					}
				}
				for (var ebulletTable:int = 1; ebulletTable <= levelInfo[lvlNum][3]; ebulletTable++){
					if (getChildByName(EbulletInfo[ebullets][0]).hitTestObject(levelImg.getChildByName("Table" + lvlNum + ebulletTable)) && getChildByName(EbulletInfo[ebullets][0]).y  > 517){
						removeEBullet = true;
					}
				}
				if (removeEBullet == true){		//if the bullet is to be removed
					removeChild(getChildByName(EbulletInfo[ebullets][0]));		//remove the bullet
					tempBullet = bulletInfo[ebullets]							//move the bullet info to a temp bullet
					EbulletInfo[ebullets] = EbulletInfo[EbulletInfo.length-1];	//move the last bullet in the array to the curren bullet's position in the array
					EbulletInfo[EbulletInfo.length-1] = tempBullet;				//move the current bullet's info the the last spot in the array.
					EbulletInfo.pop();											//remove the last entry in the array
				}
			}
			
			//CHANG'S BULLETS
			for (var bullets:int = 0; bullets < bulletInfo.length; bullets++){	//Fore each of Chang's bullets do the same as enemy bullets unless otherwise specified
				var removeBullet = false;
				this.getChildByName(bulletInfo[bullets][0]).x += bulletInfo[bullets][3] * bulletSpeed;
				
				for (var enemyHit = lastEnemyM; enemyHit >= (lastEnemyM - enemyMCount +1); enemyHit --){	//Rather seeing if the bullet hits chang, see if it hits enemies
					if (enemyMInfo[enemyHit][11] == false){ // if the enemy hit is not dead
						if (getChildByName(bulletInfo[bullets][0]).x > (getChildByName(enemyMInfo[enemyHit][1]).x - getChildByName(enemyMInfo[enemyHit][1]).width/2) && getChildByName(bulletInfo[bullets][0]).x < (getChildByName(enemyMInfo[enemyHit][1]).x + getChildByName(enemyMInfo[enemyHit][1]).width/2) && getChildByName(bulletInfo[bullets][0]).y < (getChildByName(enemyMInfo[enemyHit][1]).y) && getChildByName(bulletInfo[bullets][0]).y > (getChildByName(enemyMInfo[enemyHit][1]).y - getChildByName(enemyMInfo[enemyHit][1]).height)){
							//if there is a hit...
							enemyMInfo[enemyHit][6] -= bulletInfo[bullets][4]; //lower enemy health by the bullet's damage
							removeBullet = true;	//set the boolean to remove the bullet
							if (enemyMInfo[enemyHit][6] <= 0){	//if the enemy is now dead
								var isHealthBonus = Math.round(Math.random()*100);	//generate a random num to determine enemy drops
								if(isHealthBonus > 75){	//25% chance of a health pack
									promptText.text = "Enemy Drop: Health Pack!";		//set the prompt text to inform user of the drop
									changCurrEnergy += Math.round(0.25 * changMaxEnergy);	//Increase chang's energy by 25% of his max energy
									lifeText.text = changCurrEnergy;	//change the energy value on the top left
								}
								else if (isHealthBonus > 60){	//15% chance of a ammo pack (max out all ammo for unlocked weapons)
									promptText.text = "Enemy Drop: Ammo Stash!"; //change prompt text to inform player
									for (var weaponAmmos:int = 0; weaponAmmos < 14; weaponAmmos ++){	//for each weapon
										if (weaponInfo[weaponAmmos][7] == true){	//if the weapon is unlocked
											weaponInfo[weaponAmmos][5] = weaponInfo[weaponAmmos][6];	//set the weapon's current ammo to its max ammo
											if(weaponInfo[weaponNum][5] >= 0){	//change the current weapons ammo to display the number, or unlimited.
												ammoText.text = weaponInfo[weaponNum][5];
											}
											else{
												ammoText.text = "Unlimited";
											}
											
										}
									}
								}
								enemyMInfo[enemyHit][11] = true;	//make the enemy array store the enemy as dead
								getChildByName(enemyMInfo[enemyHit][1]).alpha = 0;	//make the enmy invisible
							}
						}
					}
				}
				if (lvlNum != 0){ //If there is a boss in the level
					if (isBossKill == false && isBossSeen == true){	//if the boss is seen, but not killed
						if (getChildByName(bulletInfo[bullets][0]).hitTestObject(Boss)){	//if the bullet hits the boss
							bossInfo[lvlNum][5] -= bulletInfo[bullets][4];	//reduce boss' health
							removeBullet = true;	//remove bullet
							if(bossInfo[lvlNum][5] <= 0){	//if the boss' health drops to 0 or less
								isBossKill = true;		//set the boolean isBossKill to true (Allows for door use)
								removeChild(Boss);		//remove graphic of the boss
							}
						}
						if (lvlNum > 2){
							if (Math.abs(Boss.x - this.getChildByName(bulletInfo[bullets][0]).x) < 100){//If a bullet is approaching the boss
								isBossJump = true;//make the boss jump
							}
						}
					}
				}
				//bounds for chang's bullets
				if (this.getChildByName(bulletInfo[bullets][0]).x < -500 || this.getChildByName(bulletInfo[bullets][0]).x > 1300){
					removeBullet = true;
				}
				//collsion with furniture
				for (var bulletChair:int = 1; bulletChair <= levelInfo[lvlNum][1]; bulletChair++){
					if (getChildByName(bulletInfo[bullets][0]).hitTestObject(levelImg.getChildByName("Chair" + lvlNum + bulletChair))){
						removeBullet = true;
					}
				}
				for (var bulletCouch:int = 1; bulletCouch <= levelInfo[lvlNum][2]; bulletCouch++){
					if (getChildByName(bulletInfo[bullets][0]).hitTestObject(levelImg.getChildByName("Couch" + lvlNum + bulletCouch))){
						removeBullet = true;
					}
				}
				for (var bulletShelf:int = 1; bulletShelf <= levelInfo[lvlNum][4]; bulletShelf++){
					if (getChildByName(bulletInfo[bullets][0]).hitTestObject(levelImg.getChildByName("Shelf" + lvlNum + bulletShelf))){
						removeBullet = true;
					}
				}
				for (var bulletTable:int = 1; bulletTable <= levelInfo[lvlNum][3]; bulletTable++){
					if (getChildByName(bulletInfo[bullets][0]).hitTestObject(levelImg.getChildByName("Table" + lvlNum + bulletTable)) && getChildByName(bulletInfo[bullets][0]).y  > 517){
						removeBullet = true;
					}
				}
				for (var bulletVent:int = 1; bulletVent <= levelInfo[lvlNum][12]; bulletVent++){//for the vents in the level
					if (getChildByName(bulletInfo[bullets][0]).hitTestObject(levelImg.getChildByName("Vent" + lvlNum + bulletVent))){//if the bullet hits the vent
						var ventColour:ColorTransform = new ColorTransform();//change the colour of the vent to be black
						ventColour.redOffset = -250;
						ventColour.blueOffset = -250;
						ventColour.greenOffset = -250;
						ventColour.alphaOffset = 250;
						removeBullet = true;
						if (ventWeapon == 0){
							ventWeapon = 1;		//make ventWeapon 1, this is used later to determine which weapon will be found in the vent
						}
						levelImg.getChildByName("Vent" + lvlNum + bulletVent).transform.colorTransform = ventColour;
					}
				}
				if (removeBullet == true){
					removeChild(getChildByName(bulletInfo[bullets][0]));
					tempBullet = bulletInfo[bullets]
					bulletInfo[bullets] = bulletInfo[bulletInfo.length-1];
					bulletInfo[bulletInfo.length-1] = tempBullet;
					bulletInfo.pop();
				}
			}
			
			//FINAL BOSS MOVEMENT
			if (lvlNum != 0){//if it's a level with a boss in it
								
				if(BossXSpeed == 0 && BossYSpeed == 0 && isBossGround == true){//if the boss is not moving, make it stand
					Boss.gotoAndStop("Stand");
				}
				Boss.x += BossXSpeed;//move the boss in the x direction, as determine in earlier code
				
				if (Boss.y >= BossGround){ 	//if the boss is below/on the ground
					Boss.y = BossGround;	//make the boss stay on the ground
					isBossGround = true;	//allow the boss to jump later
					BossYSpeed = 0;			//stop any y directional movement
				}
				
				if (isBossJump == true && isBossGround == true){	//if the boss wants to jump and is on the ground
					BossYSpeed -= jumpPower;	//make the boss' vertical speed the jump power (defined at the beginning)
					Boss.y -= jumpPower;		//make the boss move up by jump power pixels
					isBossGround = false;		//make the boss not grounded and thus unable to jump until grounded
				}
				
				if (isBossGround == false){	//if the boss is in the air
					BossYSpeed += gravity;	//make gravity affect his vertical speed
				}
				
				Boss.y += BossYSpeed;	//move boss based on the above calculated speed
			}
			
			//Reload timer
			if (isShot == true){	//if a bullet has been shot, but the time between shots is not yet met
				reloadTime += 1;	//add to the time between shots
				if (reloadTime >= weaponInfo[weaponNum][1]){	//if the shots have been met
					isShot = false;						//set the variable to show that a shot has not been taken in the last while
					reloadTime = 0;						//make the reload time zero, so the next shot will start with a reload time of zero
				}
			}
			
			//Shooting & Sprite Control for CHANG
			if (shoot == true){						//if the user wishes to shoot (Priority 1)
				var bullet:Bullet = new Bullet();	//prepare a bulllet graphic
				addChild(changWeapon);				//add Chang's weapon to show he is ready align that to chang's body and scale
				changWeapon.gotoAndStop(weaponNum + 1);
				changWeapon.name = "changWeapon";
				this.getChildByName("changWeapon").scaleX = chang.scaleX; 
				this.getChildByName("changWeapon").scaleY = changScale; 
				this.getChildByName("changWeapon").x = chang.x + (40 * chang.scaleX) + xSpeed;	//move the gun with chang
				this.getChildByName("changWeapon").y = chang.y - chang.height/2 + ySpeed;		//move the gun with chang
				
				if(isShot == false)	//if a shot has not been fired in the reload time...
				{
					isShot = true;			//make it so a shot has been fired
					addChild(bullet);		//add the bullet graphic
					shootSound.play();		//play the shoot sound
					bullet.name = "bullet" + bulletCount;		//name the bullet, and add it to an array of friendly bullets (same method as enemy bullets)
					bulletCount ++
					bullet.gotoAndStop(4);
					bullet.x = changWeapon.x + (chang.scaleX)* weaponInfo[weaponNum][3];
					bullet.y = changWeapon.y - weaponInfo[weaponNum][4]*changScale;
					bulletInfo.push([bullet.name, bullet.x, bullet.y, (chang.scaleX / Math.abs(chang.scaleX)), weaponInfo[weaponNum][2]]);
					
					weaponInfo[weaponNum][5] --;		//reduce the weapon's ammo
					if (weaponInfo[weaponNum][5] == 0){		//if the weapon has run out of ammo..
						weaponNum = 0;						//go back to the first weapon
						changWeapon.gotoAndStop(weaponNum + 1);		//change all instances of weapon grapic to show first weapon
						topWeapon.gotoAndStop(weaponNum + 1);
						weaponText.text = weaponInfo[weaponNum][0];	//chang name of weapon in top righ to corner
					}
					
					if (weaponInfo[weaponNum][5] > 0){
						ammoText.text = weaponInfo[weaponNum][5];	//update ammo text (if limited)
					}
					else{
						ammoText.text = "Unlimited";				//update ammo text (if unlimited)
					}
				}
				
				if (jump == true)	//while shooting if chang is jumping 
				{
					chang.gotoAndStop("JumpShoot");		//make him look like he's jumpshooting
					
				}
				else if (run == true)	//if he's running but not jumping while shooting
				{
					chang.gotoAndStop("RunShoot");	//make him look like he's running and shooting
				}
				else				//if he's shooting but not running or jumping
				{
					chang.gotoAndStop("Shoot");		//make him stand and shoot
				}
			}
			else if (duck == true)
			{
				chang.gotoAndStop("Duck");		//if the user wishes to duck, make him duck (Priority 2)
			}
			else if (jump == true)				
			{
				chang.gotoAndStop("Jump");		//if the user wishes to jump, make him jump (Priority 3)
			}
			else if (run == true)
			{
				chang.gotoAndStop("Run");		//If the user wishes to run, make him run (Priority 4)
			}
			else
			{
				chang.gotoAndStop("Stand");		//If there are no other commands, make chan stand (Priority 5)
			}		
			
			isGround = false;	//make chang not grounded, unless otherwise proven to be grounded
			
			//COLLISIONS FOR CHANG
			//CHAIRS (Like with bosses)
			for (var a:int = 1; a <= levelInfo[lvlNum][1]; a++)
			{
				if (levelImg.getChildByName("Chair" + lvlNum + a).hitTestPoint((chang.x-chang.width/2), (chang.y - chang.height/3), true) || levelImg.getChildByName("Chair" + lvlNum + a).hitTestPoint((chang.x-chang.width/2), (chang.y - chang.height * 9 / 10), true))
				{
					chang.x += xSpeed + 5;
					xSpeed = 0;
				}
				else if (levelImg.getChildByName("Chair" + lvlNum + a).hitTestPoint((chang.x+chang.width/2), (chang.y - chang.height/3), true) || levelImg.getChildByName("Chair" + lvlNum + a).hitTestPoint((chang.x+chang.width/2), (chang.y - chang.height * 9 / 10), true))
				{
					chang.x -= xSpeed +1 ;
					xSpeed = 0;
				}
				else if (levelImg.getChildByName("Chair" + lvlNum + a).hitTestPoint(chang.x-chang.width/2, chang.y, true) || levelImg.getChildByName("Chair" + lvlNum + a).hitTestPoint(chang.x+chang.width/2, chang.y, true))
				{
					chang.y = 600 - (levelImg.getChildByName("Chair" + lvlNum + a).y * -1 + levelImg.getChildByName("Chair" + lvlNum + a).height);
					ySpeed = 0;
					isGround = true;
				}
			}
			//COUCHES (like with bosses) except the bottom of a couch will stop chang from going up
			for (var b:int = 1; b <= levelInfo[lvlNum][2]; b++)
			{
				if (levelImg.getChildByName("Couch" + lvlNum + b).hitTestPoint((chang.x), (chang.y - chang.height), true))
				{//if changs head hits the couch, make him stop moving upuwards.
					chang.y += 1;
					ySpeed = 0;
				}
				if (levelImg.getChildByName("Couch" + lvlNum + b).hitTestPoint((chang.x-chang.width/2), (chang.y - chang.height/3), true) || levelImg.getChildByName("Couch" + lvlNum + b).hitTestPoint((chang.x-chang.width/2), (chang.y - chang.height * 2 / 3), true))
				{
					chang.x += xSpeed + 5;
					xSpeed = 0;
				}
				else if (levelImg.getChildByName("Couch" + lvlNum + b).hitTestPoint((chang.x+chang.width/2), (chang.y - chang.height/3), true) || levelImg.getChildByName("Couch" + lvlNum + b).hitTestPoint((chang.x+chang.width/2), (chang.y - chang.height * 2 / 3), true))
				{
					chang.x -= xSpeed +1 ;
					xSpeed = 0;
				}
				else if (levelImg.getChildByName("Couch" + lvlNum + b).hitTestPoint(chang.x-chang.width/2, chang.y, true) || levelImg.getChildByName("Couch" + lvlNum + b).hitTestPoint(chang.x+chang.width/2, chang.y, true))
				{
					chang.y = 600 - (levelImg.getChildByName("Couch" + lvlNum + b).y * -1 + levelImg.getChildByName("Couch" + lvlNum + b).height) +1;
					ySpeed = 0;
					isGround = true;
				}
			}
			//TABLES (like with bosses)
			ground = 567;
			for (var d:int = 1; d <= levelInfo[lvlNum][3]; d++){
				if (levelImg.getChildByName("Table" + lvlNum + d).hitTestPoint((chang.x+chang.width/2), (chang.y-chang.height), (true)))
				{
					chang.x -= xSpeed+1;// + 5;
					xSpeed = 0;
				}
				if (levelImg.getChildByName("Table" + lvlNum + d).hitTestPoint((chang.x-chang.width/2+2), (chang.y-chang.height), (true)))
				{
					chang.x -= xSpeed-1;// + 5;
					xSpeed = 0;
				}
				if (levelImg.getChildByName("Table" + lvlNum + d).hitTestPoint((chang.x - chang.width/4), (chang.y ), true) || levelImg.getChildByName("Table" + lvlNum + d).hitTestPoint((chang.x + chang.width/4), (chang.y), true)){
					ground = 600 + (levelImg.getChildByName("Table" + lvlNum + d).y) - 63;
				}
			}
			//Bookshelves (Like with bosses)
			for (var c:int = 1; c <= levelInfo[lvlNum][4]; c++)
			{
				if (levelImg.getChildByName("Shelf" + lvlNum + c).hitTestPoint((chang.x-chang.width/2), (chang.y - chang.height/3), true) || levelImg.getChildByName("Shelf" + lvlNum + c).hitTestPoint((chang.x-chang.width/2), (chang.y - chang.height * 2 / 3), true))
				{
					chang.x += xSpeed + 5;
					xSpeed = 0;
				}
				else if (levelImg.getChildByName("Shelf" + lvlNum + c).hitTestPoint((chang.x+chang.width/2), (chang.y - chang.height/3), true) || levelImg.getChildByName("Shelf" + lvlNum + c).hitTestPoint((chang.x+chang.width/2), (chang.y - chang.height * 2 / 3), true))
				{
					chang.x -= xSpeed +1 ;
					xSpeed = 0;
				}
				else if (levelImg.getChildByName("Shelf" + lvlNum + c).hitTestPoint(chang.x+chang.width/3, chang.y, true) || levelImg.getChildByName("Shelf" + lvlNum + c).hitTestPoint(chang.x-chang.width/3, chang.y, true))
				{
					chang.y = 600 - 228;
					ySpeed = 0;
					isGround = true;
				}
			}
			
			//DOORS AND VENTS (SPECIAL OBJECTS)
			for (var door:int = 1; door <= levelInfo[lvlNum][5]; door++)
			{
				if (levelImg.getChildByName("Door" + lvlNum + door).hitTestPoint((chang.x-chang.width/3), (chang.y - chang.height - 15), true) || levelImg.getChildByName("Door" + lvlNum + door).hitTestPoint((chang.x+chang.width/3), (chang.y - chang.height - 15), true))
				{//if Chang's x position is within the width of the door
					
					isDoor = true;							//set the boolean of door touching to true
					if (door == levelInfo[lvlNum][5]){		//if this is the last door in the level
						if (isBossKill == true){			//if the boss is killed
							if (isBbutton == true){			//If the 's' button is pressed
								finishLevel();				//Go to the finish level screen
							}
							else{							//Otherwise Enter the secret room (NOTE: this was not implemented)
								enterRoom(door);
							}
						}
						else{
							promptText.text = "Beat Boss First!"; //If the boss has not been killed, tell user to beat boss first
						}
					}
				}				
				else {		//if chang is not at a door
					isDoor = false;						//make the bool false so the program knows
					if (levelInfo[lvlNum][12] == 1){	//if there is a secret weapon vent in the level
						if (chang.hitTestObject(levelImg.getChildByName("Vent" + lvlNum + "1")) == true){	//if chang hits the vent
							if (ventWeapon == 1){		//if the vent has been shot and opened
								switch(lvlNum){			//depending on the level
									case 0:
									ventWeapon = 2;		//change the weapon in the vent
									break;
									case 2:
									ventWeapon = 5;
									break;
									case 3:
									ventWeapon = 7;
									break;
									case 5:
									ventWeapon = 10;
									break;
									case 6:
									ventWeapon = 12;
									break;
									case 7:
									ventWeapon = 13;
									break;
								}
								promptText.text = "You found a " + weaponInfo[ventWeapon][0] + "!";	//tell user what weapon they found
								weaponInfo[ventWeapon][7] = true;							//set that weapon to unlocked
								weaponInfo[ventWeapon][5] = weaponInfo[ventWeapon][6];		//max out the ammo of that weapon
							}
						}
					}
				}
			}
			
			//GRAVITY FOR CHANG
			if (chang.y >= ground)		//if chang is below or onthe ground
			{
				ySpeed = 0;			//prevent him from moving
				chang.y = ground;	//set his y location to the ground
				isGround = true;	//set the boos isGround to true so the program knows
			}
			
			if (isGround == false)	//If chang is not on the ground
			{
				jump = true;		//let the program know that chang is in the air
			}
			else
			{
				jump = false;		//otherwise chang is not jumping
			}
			
			if (jump == false)		//if chang is not jumping, then he will not move up or down
			{
				ySpeed = 0;
				jump = false;
				chang.y = chang.y;
			}
			else					//if chang is jumping, he will be influenced by gravity
			{
				ySpeed += gravity;	
				chang.y += ySpeed;
				
			}
			
			//SIDE SCROLLING
			if (chang.x < 150 && xSpeed < 0){		//if chang is moving to the left edge of the screen
				if (levelImg.x >= 0)				//if the level graphic is past its minimum x value
				{
					levelImg.x = 0					//set the level's x value to zero
					if (chang.x > 25)				//if chang is within the bounds determined for him (x=25)
					{
						chang.x += xSpeed;			//move changleft
					}
				}
				else
				{
					levelImg.x -= xSpeed			//if the level is not at it's minimum x value, then move it right 
					for (var enemyLvlShiftL = lastEnemyM; enemyLvlShiftL >= (lastEnemyM - enemyMCount +1); enemyLvlShiftL --){ //for every enemy
						this.getChildByName(enemyMInfo[enemyLvlShiftL][1]).x -= xSpeed;		//Move the enemy by the same shift as the level
					}
					
					if (lvlNum != 0){			//if there is a boss
						Boss.x -= xSpeed;		//move the boss by the same shift as the level
					}
					for (var shiftEBullets = EbulletInfo.length - 1; shiftEBullets > -1; shiftEBullets --){	//shift all enem bullets too
						getChildByName(EbulletInfo[shiftEBullets][0]).x -= xSpeed;
					}
				}
			}
			else if (chang.x > (Width - 150) && xSpeed > 0)		//if chang is at the right edge of the screen
			{
				if (levelImg.x <= -(levelImg.width - Width)){	//if the level image is at the furthest it can go
					levelImg.x = -(levelImg.width - Width);		//leave keep the image at the furthest it can go
					if (chang.x < (Width - 25)){				//allow chang to move until he is 25 pixels from the end
						chang.x += xSpeed;
					}
				}
				else {											//if the level is not at the furthest it can go
					levelImg.x -= xSpeed						//move the level to the left
					if (enemyMCount > 0){						//for every enemy, move them with the level
						for (var enemyLvlShiftR = lastEnemyM; enemyLvlShiftR >= (lastEnemyM - enemyMCount +1); enemyLvlShiftR --){
						this.getChildByName(enemyMInfo[enemyLvlShiftR][1]).x -= xSpeed;
						}
					}
					if (lvlNum != 0){		//if there is a boss
						Boss.x -= xSpeed;	//shift the boss as well
					}
					for (var shiftEBullets2 = EbulletInfo.length - 1; shiftEBullets2 > -1; shiftEBullets2 --){
						getChildByName(EbulletInfo[shiftEBullets2][0]).x -= xSpeed;	//Shift every bullet as well
					}
				}
			}
			else
			{
				chang.x += xSpeed;//if chang is not near the edge of the screen, move him instead
			}
		}
		
		public function stopChang(ke:KeyboardEvent){	//Upon lifting a key
			if (ke.keyCode == Keyboard.RIGHT)	//Right Key
			{
				run = false;					//Stop Chang From running
				xSpeed=0;
			}
			if (ke.keyCode == Keyboard.LEFT)	//Left Key
			{
				run = false;					//Stop Chang from running
				xSpeed=0;
			}
			if (ke.keyCode == Keyboard.DOWN)	//down key
			{
				duck = false;					//stop chang from ducking
				duckTime = 0;
			}
			if (ke.keyCode == Keyboard.UP)		//up key
			{
				if (ySpeed == 0)				//if chang is grounded, make sure he doesn't jump
				{
					jump = false;
				}
				else							//if chang is in the air do nothing
				{
					jump = true;
				}
			}
			if (ke.keyCode == 65) 				// A for Shoot
			{
				if (shoot == true){				//Make sure that the a key has been pressed once (upon entering level, it may not be)
					removeChild(getChildByName("changWeapon")); //remove chang's weapno
				}
				shoot = false;				//stop chang from shooting
			}
			if (ke.keyCode == 83) // S for other things (doors, change weapon)
			{
				isBbutton = false;		//set the isBbutton bool to false so the program knows
			}
		}
		
		public function enterRoom(doorNum:Number){		//This was never used in the program but allows for code to get chang to enter otherh rooms
			isBbutton = false;
		}
		
		public function finishLevel(){		//Upon finishing a level
			MusicChannel.stop();			//Stop the current song
			MusicChannel.removeEventListener(Event.SOUND_COMPLETE, levelSongFinished);		//remove the even listener for the end of the level's song
			for (var removeEnemy = lastEnemyM; removeEnemy >= (lastEnemyM - enemyMCount ); removeEnemy--){//for every enemy
				removeChild(getChildByName(enemyMInfo[removeEnemy][1]));	//remove the enemy
				enemyMCount --;
			}
			isBbutton = false;			//set the b button to false
			removeChild(chang);			//remove chang
			removeChild(levelImg);		//remove the level graphic
			removeChild(topWeapon);		//remove the weapon at the top
			removeChild(weaponText);	//remove the weapon text
			removeChild(ammoText);		//remove the ammo text
			removeChild(lifeText);		//remove the life text
			removeChild(heart);			//remove the heart icon
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, commandChang);	//remove the key down event listner that controlled chang
			stage.removeEventListener(KeyboardEvent.KEY_UP, stopChang);			//remove the key up even listener
			stage.removeEventListener(Event.ENTER_FRAME, gamePlay)				//remove the gamplay event listener that worked every frame
			for (var remEbullets = EbulletInfo.length - 1; remEbullets > -1; remEbullets --){	//for all enemy bullets
				removeChild(getChildByName(EbulletInfo[remEbullets][0]));		//remove bullet
				EbulletInfo.pop();												//remove bullet info from array
			}
			for (var rembullets = bulletInfo.length - 1; rembullets > -1; rembullets --){	//for all freindly bullets
				removeChild(getChildByName(bulletInfo[rembullets][0]));		//remove bullet
				bulletInfo.pop();											//remove info from array
			}
			while (numChildren > 0) {	//for any remaining objects
				removeChildAt(0);		//remove it
			}
			changMaxEnergy = levelInfo[lvlNum][8];			//increase chang's max energy according to the unlocked value in the levelInfo array
			changCurrEnergy = changMaxEnergy;				//make chang's energy full
			weaponInfo[levelInfo[lvlNum][9]][7] = true;		//unlocke the weapon as specified in the levelInfo array
			
			if (lvlNum == 7){		//if this was the last level
				MusicChannel = gameWinMusic.play();			//play the game won music
				MusicChannel.addEventListener(Event.SOUND_COMPLETE, gameCompleteSongFinished);	//add a lisnter for the end of the song to allow for looping
				var winScreen:GameWin = new GameWin();	//add the game win graphic
				addChild(winScreen);		
			}
			else{	//if this was not the last level
				MusicChannel = levelWinMusic.play();		//play the level won music
				MusicChannel.addEventListener(Event.SOUND_COMPLETE, lvlCompleteSongFinished);	//add a listener for the end of the song for looping
				var finishScreen:LevelComplete = new LevelComplete();	//add the level win graphic
				addChild(finishScreen);
				finishScreen.LevelNameText.text = levelInfo[lvlNum][11];	//Make the title what was specified in the levelInfo Array
				if (levelInfo[lvlNum+1][10] == 0){	//if the next level is locked (this level has not been beat before)
					finishScreen.UnlockInfoText.text = "Level" + (lvlNum+1) + "\n" + levelInfo[lvlNum][8] + "\n" + weaponInfo[levelInfo[lvlNum][9]][0]; //inform user about the level, max health and weapon they unlocked
				}
				else{
					finishScreen.UnlockInfoText.text = "Already Unlocked\nAlready Unlocked\nAlready Unlocked";	//if the next level is unlocked hten all of this is already unlocked
				}
							
				levelInfo[lvlNum+1][10] = 1;	//unlock the next level
			}
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, returnToLvlSelect);	//listen for the key press to return to level select
		}
		
		public function lvlCompleteSongFinished(e:Event){	//if the level complete song finsihes, play  it again
			MusicChannel.stop();
			MusicChannel = levelWinMusic.play();
		}
		
		public function gameCompleteSongFinished(e:Event){	//if the game complete song finishes, play it again
			MusicChannel.stop();
			MusicChannel = gameWinMusic.play();
		}
		
		public function returnToLvlSelect(ke:KeyboardEvent){	//Upon pressing a button in game/level complete screen
			if (ke.keyCode == 65){ // if A is pressed
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, returnToLvlSelect);	//remove the event listner
				removeChildAt(0);		//remove the graphic that was shown
				MusicChannel.stop();	//stop the music
				if (lvlNum == 7){	//depending on the level that was completed (or if you died), remove the music end listener
					MusicChannel.removeEventListener(Event.SOUND_COMPLETE, gameCompleteSongFinished);
				}
				else if (changCurrEnergy != changMaxEnergy){	//if you died
					changCurrEnergy = changMaxEnergy;			//reset health to max
					MusicChannel.removeEventListener(Event.SOUND_COMPLETE, deathSongFinished);
				}
				else{
					MusicChannel.removeEventListener(Event.SOUND_COMPLETE, lvlCompleteSongFinished);
				}
				levelSelect();		//return to level select
			}
		}
		
		public function gameOver(){	//Upon dying in game
			MusicChannel.stop();	//stop the music
			MusicChannel.removeEventListener(Event.SOUND_COMPLETE, levelSongFinished);//remove the song end event listener
			MusicChannel = deathMusic.play();	//play the death music
			MusicChannel.addEventListener(Event.SOUND_COMPLETE, deathSongFinished);	//add a song end event listener to allow for loopign
			for (var removeEnemy = lastEnemyM; removeEnemy >= (lastEnemyM - enemyMCount); removeEnemy--){	//remove all enemies
				removeChild(getChildByName(enemyMInfo[removeEnemy][1]));
				enemyMCount --;
			}
			isBbutton = false;			//set b button press to false
			removeChild(chang);			//remove all graphics and event listeners (as with the finishLevel() function)
			removeChild(levelImg);
			removeChild(topWeapon);
			removeChild(weaponText);
			removeChild(ammoText);
			removeChild(lifeText);
			removeChild(heart);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, commandChang);
			stage.removeEventListener(KeyboardEvent.KEY_UP, stopChang);
			stage.removeEventListener(Event.ENTER_FRAME, gamePlay)
			for (var remEbullets = EbulletInfo.length - 1; remEbullets > -1; remEbullets --){
				removeChild(getChildByName(EbulletInfo[remEbullets][0]));
				EbulletInfo.pop();
			}
			for (var rembullets = bulletInfo.length - 1; rembullets > -1; rembullets --){
				removeChild(getChildByName(bulletInfo[rembullets][0]));
				bulletInfo.pop();
			}
			
			while (numChildren > 0) {
				removeChildAt(0);
			}
			
			var deathScreen:GameOverScreen = new GameOverScreen();	//add in a graphic for the death screen
			addChild(deathScreen);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, returnToLvlSelect);	//add an event listener for returning to main menu
		}
		
		public function deathSongFinished(e:Event){	//when the death song finishes, play it again from the start.
			MusicChannel.stop();
			MusicChannel = deathMusic.play();
		}
	}
}
