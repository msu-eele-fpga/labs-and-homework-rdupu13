/**
 * 
 * 
 * 
 */

#include <stdio.h>
#include <string.h>

#define MAX_NAME_SIZE 10



struct player
{
	char name[MAX_NAME_SIZE];
	int room;
	int hp;
	int xp;
	float stamina;
	float fitness;
	float hunger;
	float illness;
	float immune;
};



/**
 * main() - 
 * 
 * 
 */
int main (int argc, char **argv)
{
	struct player rdupu;
	
	strcpy(argv[1], rdupu.name);
	rdupu.room = 0;
	
	rdupu.hp = 100;
	rdupu.xp = 0;
	rdupu.stamina = 10.0;
	rdupu.fitness = 15.0;
	rdupu.hunger = 0.0;
	rdupu.illness = 0.0;
	rdupu.immune = 10.0;
	
	/**
	 * as player exerts: stamina down -> hunger up
	 * as player eats:   hunger down -> stamina up (delayed)
	 * when stamina = 0: hp down
	 * if illness > 0:   hp decreases because of illness
	 *                   immune fights (decreases) illness
	 * when hp = 0:      death
	 *
	 * fitness, immune, hunger, xp are only increased through gameplay
	 */
	
	printf("Name:    %s\n", rdupu.name);
	printf("HP:      %d\n", rdupu.hp);
	printf("XP:      %d\n", rdupu.xp);
	printf("Stamina: %f\n", rdupu.stamina);
	printf("Fitness: %f\n", rdupu.fitness);
	printf("Hunger:  %f\n", rdupu.hunger);
	printf("Illness: %f\n", rdupu.illness);
	printf("Immune:  %f\n", rdupu.immune);
	
	return 0;
}
