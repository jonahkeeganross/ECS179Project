# The title of your game

## Summary

**A paragraph-length pitch for your game.**

## Project Resources

[Web-playable version of your game.](https://itch.io/)  
[Trailor](https://youtube.com)  
[Press Kit](https://dopresskit.com/)  
[Proposal: make your own copy of the linked doc.](https://docs.google.com/document/d/1qwWCpMwKJGOLQ-rRJt8G8zisCa2XHFhv6zSWars0eWM/edit?usp=sharing)

## Gameplay Explanation

**In this section, explain how the game should be played. Treat this as a manual within a game. Explaining the button mappings and the most optimal gameplay strategy is encouraged.**

Cursed Crown follows the same structure as many other Rougelike style games where you spawn into the floor, explore the structure of the floor and find the boss all while collecting upgrades/currency to spend on upgrades.

The tutorial already goes through the basic button mappings which are:

- WASD for basic character movement up/left/down/right respectively.
- Shift is a dash move that blinks your character forward a certain distance, while giving the player invincibility frames, this costs stamina but it best used when you are about to be hit with an attack allowing you to dodge damage.
- J is your basic attack, a sword slash. This costs the least amount of stamina out of all your attacks and is your bread and butter, does a good amount of damage with little knockback allowing you to defeat enemies
- K is a shockwave attack, doing a smaller amount of damage but costing a lot of stamina, it is best used when swarmed with enemies, allowing you to knock them back and give yourself time to escape or fight back
- L is a ranged attack, shooting an arrow in the direction the player is moving. This move costs a good amount of stamina and is hard to hit, making it best for the boss especially when he is standing still.
- F is your interact button allowing you to interact with the altars and chests
- Spacebar allows you to skip the sign dialogue in the tutorial

The META:
The most effective tactic available to beat the game is as follows:

- The skeletons are the most basic and weak enemy. Use your basic sword attack to take them out in 2 to 3 hits
- The vampires will do a lot of damage to you if you arent careful with your movement, it is best to take them out as fast as possible, ideally before the skeletons in the room, allowing you an easier time clearing the rest of the room
- Explore the entire floor before going to fight the boss, which will allow you to get all the coins possible and get full health and hopefully some stamina and damage upgrades for the boss
- For the boss fight, focus on hitting it with arrows when it is standing still. If you get too close with a melee attack it can catch you off guard with a fast attack. When it starts attack with lasers, just focus on dodging the attacks until it stops, to which you will start attacking wiht arrows again. Follow this pattern until defeated

**Add it here if you did work that should be factored into your grade but does not fit easily into the proscribed roles! Please include links to resources and descriptions of game-related material that does not fit into roles here.**

# External Code, Ideas, and Structure

If your project contains code that: 1) your team did not write, and 2) does not fit cleanly into a role, please document it in this section. Please include the author of the code, where to find the code, and note which scripts, folders, or other files that comprise the external contribution. Additionally, include the license for the external code that permits you to use it. You do not need to include the license for code provided by the instruction team.

If you used tutorials or other intellectual guidance to create aspects of your project, include reference to that information as well.

# Team Member Contributions

This section be repeated once for each team member. Each team member should provide their name and GitHub user information.

The general structures is

```
Team Member 1
  Main Role
    Documentation for main role.
  Sub-Role
    Documentation for Sub-Role
  Other contribtions
    Documentation for contributions to the project outside of the main and sub roles.

Team Member 2
  Main Role
    Documentation for main role.
  Sub-Role
    Documentation for Sub-Role
  Other contribtions
    Documentation for contributions to the project outside of the main and sub roles.
...
```

For each team member, you shoudl work of your role and sub-role in terms of the content of the course. Please look at the role sections below for specific instructions for each role.

Below is a template for you to highlight items of your work. These provide the evidence needed for your work to be evaluated. Try to have at least four such descriptions. They will be assessed on the quality of the underlying system and how they are linked to course content.

_Short Description_ - Long description of your work item that includes how it is relevant to topics discussed in class. [link to evidence in your repository](https://github.com/dr-jam/ECS189L/edit/project-description/ProjectDocumentTemplate.md)

Here is an example:  
_Procedural Terrain_ - The game's background consists of procedurally generated terrain produced with Perlin noise. The game can modify this terrain at run-time via a call to its script methods. The intent is to allow the player to modify the terrain. This system is based on the component design pattern and the procedural content generation portions of the course. [The PCG terrain generation script](https://github.com/dr-jam/CameraControlExercise/blob/513b927e87fc686fe627bf7d4ff6ff841cf34e9f/Obscura/Assets/Scripts/TerrainGenerator.cs#L6).

You should replay any **bold text** with your relevant information. Liberally use the template when necessary and appropriate.

Add addition contributions int he Other Contributions section.

## Main Roles

## Sub-Roles

## Other Contributions

## Jonah Ross

### Main Role: Level and World Designer

Designed both the tutorial and main level, using the assets added by Madelaine.

Made the tutorial with the intention off introducing a mechanic, and then allowing the player to have a chance to test out said mecahnics, before introducing the next one, where they then could test everything out at the end of the level on a simple enemy that proves to be a small test for the player to understand the mechanics of the game. Finally it ensures that the player can't leave the tutorial until they have opened the shop system and understand what they can upgrade, giving them an idea of what they should save up for/if they want to save up for anything.

- [Link to tutorial flow chart](https://github.com/jonahkeeganross/ECS179Project/blob/1059c716e308b9f3947ef38fcf8b0d590bbfffbb/Documentation_Charts/Tutorial_Flow_Diagram.pdf): This flow chart was the basic idea behind the tutorial flow, and guided the level design of having the rivers be the separation between the different segments of the players learning, allowing for a smooth, natural separation between the small lessons
- [Link to tutorial design structure](https://github.com/jonahkeeganross/ECS179Project/blob/1059c716e308b9f3947ef38fcf8b0d590bbfffbb/Documentation_Charts/Tutorial_Design_Structure.png): This shows the structure for the tutorial level tilemap. This one was pretty complex because it was a super complex tile map. Each layer had to be its own because many tiles were only half tiles and had to be layered on top of each other to give it the fluid look that it ended up with. Whereas the main level tile map everything was a 16x16 px tile.

As for the main level. The idea was to give the player three different branchs of the level to explore before finding the boss. Roguelike games in particular aren't really supposed to have an increased difficulty in the floor/level themselves, more it should increase as the floors go on, however we weren't able to make more than one solid floor so this wasn't possible to increase the difficulty. To combat this, my idea was to have at least 1 harder room per branch of the floor to give the player a challenge no matter which way they went. On top of this, the more challenging rooms were made that way by adding more enemies, which in turn give the player more chances to get coins to upgrade themselves meaning the more they challenge themselves, the more it pays off in the long run. Once the branch got cleared the player would then backtrack, and choose another branch to explore. Because the lack of procedural generation (something we plan on implementing if we continue working on the game), the player will more or less understand the floor after one run through, which will give them a better understanding of where they want to go with a certain strategy, whether that be collecting as many coins as possible, or going straight to the boss.

- [Link to main level flow chart](https://github.com/jonahkeeganross/ECS179Project/blob/1059c716e308b9f3947ef38fcf8b0d590bbfffbb/Documentation_Charts/Main%20Level%20Flow%20Chart.pdf): This flow chart gives the basic idea of what the main level does until completion, from the main lobby safe room, to each potential branch, which can either lead to the boss room or back to the lobby if there isnt a boss room, through to the next level if the boss is beaten.
- [Link to main level design structure](https://github.com/jonahkeeganross/ECS179Project/blob/1059c716e308b9f3947ef38fcf8b0d590bbfffbb/Documentation_Charts/Main_Level_Design_Structure.png): This shows the structure for the main level tilemap. This one was pretty simple because it wasn't a super complex tile map, allowing for one map as the base walls and structure, and the second layer for the decorations like torches.

Overall I think that the floor design was pretty simple for this game seeing as there is only 1 floor. If more floors were implemented, it would have been more difficult ensuring that difficulty was increased as time went on, but that would also rely on strengthening enemies. I think the basic idea behind each floor was to make it almost maze like, where if you get lucky and find the boss room fast, you can go straight in and skip a lot of fighting, but you also may get really unlucky and have to keep fighting until you dont have enough health to take on the boss, or you may find the boss room and decide to fight everything else to level up before coming back. The level doesn't really decide the strategy, the player does and I think that is the beauty of this style of game.

My main scripting work was on the level controller which utilized a lot of area2d triggers and collision objects to ensure that players were fighting in rooms undisturbed and were locked in when needing to be. Making sure that enemies triggered and turned on when the player entered and not before. Making sure that enemies spawned. Making sure each room had its own designation. I also scripted the enemies movement (will talk about below) which entailed using the NavigationRegion2D and NavigationAgent2D nodes which also needed to be correctly implemented into the level. Implementing the chest and door scenes into the level while also building out the scenes to make sure they open when needed. The scripts are linked below:

- [Level Controller](https://github.com/jonahkeeganross/ECS179Project/blob/ac16c4c707ecaef25aeb805c9da923355c6306de/cursed-crown/Scripts/RoomController.gd#L1)
- [Level Controller (outdated)](<https://github.com/jonahkeeganross/ECS179Project/blob/ac16c4c707ecaef25aeb805c9da923355c6306de/cursed-crown/Scripts/RoomController(outdated).gd#L1>): This script was the inital model that I used to script a basic testing level which included 2 rooms and 1 enemy, which was perfect for learning how to use the navigationregion2d nodes and to make sure that all the nodes triggered when necessary. I realized that pretty much all exports were useless and I made it way more readable but implementeing enemy factories and using lots of groups to be able to find all objects in certain groups without having to call them at the beginning of the script. This was important because it made this script modular and work for every level, instead of my initial plan which was making a script for each level that exported everything that I needed specific to that level.
- [Room Script](https://github.com/jonahkeeganross/ECS179Project/blob/ac16c4c707ecaef25aeb805c9da923355c6306de/cursed-crown/Scripts/Room.gd#L1)
- [Skeleton Script](https://github.com/jonahkeeganross/ECS179Project/blob/ac16c4c707ecaef25aeb805c9da923355c6306de/cursed-crown/Scripts/skeleton.gd#L124): Implemented some of the navigation stuff here, but most scripting for this were done by Alex
- [Vampire Script](https://github.com/jonahkeeganross/ECS179Project/blob/ac16c4c707ecaef25aeb805c9da923355c6306de/cursed-crown/Scripts/vampire.gd#L86): Same here, implemented the movement stuff, but most scripting was done by Alex for other stuff.
- [Door Script](https://github.com/jonahkeeganross/ECS179Project/blob/ac16c4c707ecaef25aeb805c9da923355c6306de/cursed-crown/Scripts/door.gd#L1)

### Sub-Role: Player Onboarding and Tutorial Design

Initially I took on the gameplay testing sub role, but due to the fact that we didn't have a full game until a few days before the presentation I decided to switch my sub-role to tutorial design because I actually ended up designing pretty much the entire tutorial myself. This tied in well with my main role as I initially started by making the level structure, which revoled completely around making the level easy to navigate and structurally lead the player through the tutorial. This lead directly into the implementation of the tutorial flow design

= [Link to Tutorial Design Flow Chart](https://github.com/jonahkeeganross/ECS179Project/blob/1059c716e308b9f3947ef38fcf8b0d590bbfffbb/Documentation_Charts/Tutorial_Flow_Diagram.pdf): This is the same doc that I used to show the flow of the tutorial, it went hand it hand with the design of the level.

The move description assets were built by our asset manager and implemented when hitting the signs. The sign controllers were scripted by Leo but I implemented them into the level with area2d triggers. Scripted the level to make it impossible to leave until all aspects of the tutorial were completed (defeating the skeleton and checking out the altar)

### Other Contributions

Worked on building a coin and coin factory scene which included animation of the coin, spawning and logic of the coin as well as printing out the current coin count at the top of the screen.

- [Script for coin](https://github.com/jonahkeeganross/ECS179Project/blob/1059c716e308b9f3947ef38fcf8b0d590bbfffbb/cursed-crown/Scripts/coin.gd)
- [Script for coin factory](https://github.com/jonahkeeganross/ECS179Project/blob/ac16c4c707ecaef25aeb805c9da923355c6306de/cursed-crown/Scripts/coin_factory.gd#L1)
- [Coin Spawning logic off enemies](https://github.com/jonahkeeganross/ECS179Project/blob/1059c716e308b9f3947ef38fcf8b0d590bbfffbb/cursed-crown/Scripts/skeleton.gd#L193): This is the same in both the vampire and skeleton scripts
- [Coin Spawning logic from chests](https://github.com/jonahkeeganross/ECS179Project/blob/ac16c4c707ecaef25aeb805c9da923355c6306de/cursed-crown/Scripts/chest.gd#L1)

Alterred the camera to fit the tutorial with a bit more restriction, nothing crazy just removed horizontal player tracking and limited the camera to stop at the top and bottom boundaries of the level to make it flow with the tutorial

- [Tutorial Camera Logic](https://github.com/jonahkeeganross/ECS179Project/blob/ac16c4c707ecaef25aeb805c9da923355c6306de/cursed-crown/Scripts/tutorialCameraController.gd#L24)
