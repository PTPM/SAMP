#include <a_samp>

#define COLOUR_PERSONAL  0x8080FFAA
#define COLOUR_IMPORTANT 0xFF0000AA
#define COLOUR_GLOBAL    0xD0D0FFAA


#define GAME_TEXT_STYLE_BIG 6
#define GAME_TEXT_STYLE_SMALL 4


#define TOWTRUCK 525
#define CEMENT 524
#define FLATBED 455
#define SWEEPER 574
#define VAN 499
#define SMALLVAN 482

#define BEAGLE 511
#define AT400 577
#define SHAMAL 519
#define RUSTLER 476
#define POLICEMAV 497
#define SEASPARROW 447
#define STAIRS 608
#define BAGGAGE 485

#define FBIRANGER 490
#define COPCAR 596
#define COPRANGER 599
#define COPSWAT 427
#define COPBIKE 523
#define COPTANK 601
#define HYDRA 520

#define CONV1 480
#define CONV2 533
#define CONV3 439
#define CONV4 555

#define POSH1 415
#define POSH2 477
#define POSH3 541
#define POSH4 506

#define HUNTLEY 579
#define RANCHER 489
#define PATRIOT 470
#define MONSTER 556

#define SUV1	561
#define SUV2	458
#define SUV3	479

#define LOW1	536
#define LOW2	567
#define LOW3	412

#define STRETCH 409
#define NEWSVAN 582
#define COACH 437

#define BIKEFAST 522
#define BIKESLOW 468
#define BIKEBIG 586

#define SALOON1 562
#define SALOON2 604
#define SALOON3 551
#define SALOON4 421


#define POCKET_MONEY 500


#define GAME_BOUNDARY_MAX_X 3023
#define GAME_BOUNDARY_MIN_X (-21)
#define GAME_BOUNDARY_MAX_Y (-300)
#define GAME_BOUNDARY_MIN_Y (-3135)

#define HYDRA_BOUNDARY_MAX_X GAME_BOUNDARY_MAX_X
#define HYDRA_BOUNDARY_MIN_X GAME_BOUNDARY_MIN_X
#define HYDRA_BOUNDARY_MAX_Y (-900)
#define HYDRA_BOUNDARY_MIN_Y GAME_BOUNDARY_MIN_Y

new mode_name[] = "Protect the Prime Minister 1.4";

new player_class[MAX_PLAYERS];
new player_class_requested[MAX_PLAYERS];
new player_watching[MAX_PLAYERS];


#define NUM_CLASSES (4+7+4+10) // <--- /don't forget to change this

new class_tramp1;
new class_tramp2;
new class_tramp3;
new class_tramp4;

new class_terrorist1;
new class_terrorist2;
new class_terrorist3;
new class_terrorist4;
new class_terrorist5;
new class_terrorist6;
new class_terrorist7;

new class_primeminister;
new class_bodyguard1;
new class_bodyguard2;
new class_bodyguard3;

new class_cop1;
new class_cop2;
new class_cop3;
new class_cop4;
new class_cop5;
new class_cop6;
new class_cop7;
new class_cop8;
new class_cop9;
new class_cop10;


new class_teams[NUM_CLASSES];

new round_timer;  // 1 second, does president health boost
new round_timer_counter;  // counts up to round_time then the round ends
new round_time = 15*60; // in seconds

new regular_task_timer; // 100ms, checks for things like players in the wrong cars


#define TEAM_TRAMP 0
#define TEAM_TERRORIST 1
#define TEAM_PRIMEMINISTER 2
#define TEAM_BODYGUARD 3
#define TEAM_COP 4

GetTextFromTeam(str[80], team)
{
	switch(team) {
		case TEAM_TRAMP: str = "a psychopath";
		case TEAM_TERRORIST: str = "a terrorist";
		case TEAM_PRIMEMINISTER: str = "the Prime Minister";
		case TEAM_BODYGUARD: str = "a bodyguard";
		case TEAM_COP:str = "a cop";
	}
	return 1;
}

TeamColour(team)
{
	switch(team) {
		case TEAM_TRAMP:		 return 0xFF7F0060;
		case TEAM_TERRORIST:	 return 0xFF00AF60;
		case TEAM_PRIMEMINISTER: return 0xFFFF40AA;
		case TEAM_BODYGUARD:	 return 0x00800050;
		case TEAM_COP:		     return 0x5050CF60;
	}
	return 1;
}

ExplainRole(playerid)
{

	if (player_class[playerid]==-1) return;
	
	new team = class_teams[player_class[playerid]];
	
	switch(team) {
		case TEAM_TRAMP: {
			SendClientMessage(playerid,COLOUR_PERSONAL,"Your role is kill everything that moves.");
			SendClientMessage(playerid,COLOUR_PERSONAL,"Beware of the other psychopaths(orange) on the map.");
		}
		case TEAM_TERRORIST: {
			SendClientMessage(playerid,COLOUR_PERSONAL,"Your role is to try and kill the Prime Minister(yellow).");
			SendClientMessage(playerid,COLOUR_PERSONAL,"You must work with the other terrorists(pink) as a team.");
			SendClientMessage(playerid,COLOUR_PERSONAL,"You must avoid the cops(purple) as they will hunt you.");
			SendClientMessage(playerid,COLOUR_PERSONAL,"Beware of the psychopaths(orange) on the map.");
		}
		case TEAM_PRIMEMINISTER: {
			SendClientMessage(playerid,COLOUR_PERSONAL,"Your role is to avoid being killed for as long as possible.");
			SendClientMessage(playerid,COLOUR_PERSONAL,"You must work with your loyal bodyguards(green), they will protect you.");
			SendClientMessage(playerid,COLOUR_PERSONAL,"You are to co-operate with the local police(purple), who will hunt the terrorists.");
			SendClientMessage(playerid,COLOUR_PERSONAL,"Beware of the psychopaths(orange) on the map.");
		}
		case TEAM_BODYGUARD: {
			SendClientMessage(playerid,COLOUR_PERSONAL,"Your duty is to stay with the Prime Minister(yellow) and protect him from harm.");
			SendClientMessage(playerid,COLOUR_PERSONAL,"The terrorists(pink) will soon try and murder him.");
			SendClientMessage(playerid,COLOUR_PERSONAL,"You are to co-operate with the local police(purple), who will hunt the terrorists.");
			SendClientMessage(playerid,COLOUR_PERSONAL,"Beware of the psychopaths(orange) on the map.");
		}
		case TEAM_COP: {
			SendClientMessage(playerid,COLOUR_PERSONAL,"Your orders are to kill the terrorists(pink) without harming the bodyguards(green)");
			SendClientMessage(playerid,COLOUR_PERSONAL,"or the Prime Minister(yellow).");
			SendClientMessage(playerid,COLOUR_PERSONAL,"Beware of the psychopaths(orange) on the map.");
		}
	}
	SendClientMessage(playerid,COLOUR_PERSONAL,"The Prime Minister's safehouse (red) is a hydra/seasparrow free zone.");
	SendClientMessage(playerid,COLOUR_PERSONAL,"Only terrorists and bodyguards may fly the hydra or seasparrow.");
}

main()
{
	print("\n"); // why is this needed?
	printf("Loaded \"%s\" mode.\n",mode_name);
}


CarCol() {
	return random(126);
}


new vehicle_counter = 1;
new vehicle_modelid[MAX_VEHICLES];
new Float: vehicle_spawn_x[MAX_VEHICLES];
new Float: vehicle_spawn_y[MAX_VEHICLES];
new Float: vehicle_spawn_z[MAX_VEHICLES];
new Float: vehicle_z_angle[MAX_VEHICLES];
new vehicle_colour1[MAX_VEHICLES];
new vehicle_colour2[MAX_VEHICLES];

AddStaticVehicle2(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2)
{
	vehicle_modelid[vehicle_counter] = modelid;
	vehicle_spawn_x[vehicle_counter] = spawn_x;
	vehicle_spawn_y[vehicle_counter] = spawn_y;
	vehicle_spawn_z[vehicle_counter] = spawn_z;
	vehicle_z_angle[vehicle_counter] = z_angle;
	vehicle_colour1[vehicle_counter] = color1;
	vehicle_colour2[vehicle_counter] = color2;
	AddStaticVehicle(modelid, spawn_x, spawn_y, spawn_z, z_angle, color1, color2);
	// return vehicle_counter++ doesn't work -- suspect compiler bug
	new retval = vehicle_counter++;
	return retval;
}


new class_counter = 0;
new class_modelid[MAX_PLAYERS];
new Float:class_spawn_x[MAX_PLAYERS];
new Float:class_spawn_y[MAX_PLAYERS];
new Float:class_spawn_z[MAX_PLAYERS];
new Float:class_z_angle[MAX_PLAYERS];
new class_weapon1[MAX_PLAYERS];
new class_weapon1_ammo[MAX_PLAYERS];
new class_weapon2[MAX_PLAYERS];
new class_weapon2_ammo[MAX_PLAYERS];
new class_weapon3[MAX_PLAYERS];
new class_weapon3_ammo[MAX_PLAYERS];

AddPlayerClass2(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo)
{
    class_modelid[class_counter] = modelid;
    class_spawn_x[class_counter] = spawn_x;
    class_spawn_y[class_counter] = spawn_y;
    class_spawn_z[class_counter] = spawn_z;
    class_z_angle[class_counter] = z_angle;
    class_weapon1[class_counter] = weapon1;
    class_weapon1_ammo[class_counter] = weapon1_ammo;
    class_weapon2[class_counter] = weapon2;
    class_weapon2_ammo[class_counter] = weapon2_ammo;
    class_weapon3[class_counter] = weapon3;
    class_weapon3_ammo[class_counter] = weapon3_ammo;
	AddPlayerClass(modelid, spawn_x, spawn_y, spawn_z, z_angle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo);
	new retval = class_counter++;
	return retval;
}

public OnGameModeInit()
{
	SetGameModeText(mode_name);
	
	ShowPlayerMarkers(1);
	ShowNameTags(1);


	AddStaticVehicle2(HYDRA,1967,-2637.3569,14.1309,359.9997,43,0); // hydra west
	AddStaticVehicle2(HYDRA,1977,-2637.3569,14.1309,359.9997,43,0); // hydra east

	AddStaticVehicle2(STRETCH,1272.0273,-2052.5105,58.9108,268.6577,1,1); // pm limo
	AddStaticVehicle2(COPSWAT,1248.0804,-2041.6018,59.8980,269.1785,0,1); // pm swat van south
	AddStaticVehicle2(COPSWAT,1248.4545,-2029.4104,59.8854,269.3774,0,1); // pm swat van middle
	AddStaticVehicle2(COPSWAT,1247.5862,-2016.4684,59.9106,270.2272,0,1); // pm swat van north
	AddStaticVehicle2(COPCAR,1258.5917,-2052.1367,59.2043,267.4406,0,1); // pm police car behind limo
	AddStaticVehicle2(COPCAR,1283.4066,-2052.5417,58.5057,267.8666,0,1); // pm police car infront of limo
	AddStaticVehicle2(NEWSVAN,1307.8915,-2061.7043,58.2399,269.3047,CarCol(),CarCol()); // pm news van
	AddStaticVehicle2(NEWSVAN,1323.5018,-2061.6367,57.7726,270.4650,CarCol(),CarCol()); // pm news van
	AddStaticVehicle2(NEWSVAN,1275,-2013,59.1134,89.3634,CarCol(),CarCol()); // pm newsvan
	AddStaticVehicle2(FBIRANGER,1275,-2023,59.1450,88.3334,0,0); // pm fbiranch north
	AddStaticVehicle2(FBIRANGER,1275,-2028,59.1616,88.3310,0,0); // pm fbiranch south

	AddStaticVehicle2(STRETCH,1330.2595,-626.7542,108.9349,289.3475,0,0); // safe house limo
	AddStaticVehicle2(FBIRANGER,1339.3717,-623.1824,109.2619,289.7454,0,0); // safe house escort before limo
	AddStaticVehicle2(FBIRANGER,1320.3932,-630.0724,109.2656,286.9799,0,0); // safe house escort behind limo
	AddStaticVehicle2(COPCAR,1356.0096,-610.3824,108.8543,105.9892,0,1); // safe house cop car north
	AddStaticVehicle2(COPCAR,1357.4025,-614.4976,108.9018,106.5213,0,1); // safe house cop car middle
	AddStaticVehicle2(COPCAR,1358.7394,-618.5698,108.9018,105.6476,0,1); // safe house cop car south
	AddStaticVehicle2(COPBIKE,1360.5815,-622.1605,108.7038,106.0725,0,0); // safe house cop bike next to cop cars
	
	AddStaticVehicle2(COPBIKE,1555,-1609,12.9486,180,0,0); // police station bike 1 (north)
	AddStaticVehicle2(COPBIKE,1560,-1609,12.9486,180,0,0); // police station bike 2
	AddStaticVehicle2(COPBIKE,1565,-1609,12.9474,180,0,0); // police station bike 3
	AddStaticVehicle2(COPBIKE,1570,-1609,12.9557,180,0,0); // police station bike 4
	AddStaticVehicle2(COPBIKE,1575,-1609,12.9540,180,0,0); // police station bike 5 (south)
	AddStaticVehicle2(COPSWAT,1601.7515,-1623.7999,13.6164,91.0440,0,1); // police station swat van 2
	AddStaticVehicle2(COPSWAT,1601.8759,-1629.7356,13.6197,88.7999,0,1); // police station swat van 1
	AddStaticVehicle2(COPTANK,1534.5927,-1645.1713,5.6494,179.6766,1,1); // police station swat tank 1 (corner)
	AddStaticVehicle2(COPTANK,1545.3734,-1655.2261,5.6494,270.4727,1,1); // police station swat tank 2
	AddStaticVehicle2(COPCAR,1544.4673,-1667.9943,5.6599,269.0485,0,1); // police station cop car indoors
	AddStaticVehicle2(COPCAR,1529.6506,-1683.7926,5.6578,91.2372,0,1); // police station cop car indoors
	AddStaticVehicle2(COPCAR,1544.2897,-1684.2386,5.6589,90.3812,0,1); // police station cop car indoors
	AddStaticVehicle2(COPCAR,1558.9119,-1709.6991,5.6586,181.0041,0,1); // police station cop car indoors
	AddStaticVehicle2(COPCAR,1591.4161,-1711.0702,5.6598,0.3255,0,1); // police station cop car indoors
	AddStaticVehicle2(COPCAR,1601.5614,-1700.2463,5.6598,89.8913,0,1); // police station cop car indoors
	AddStaticVehicle2(COPRANGER,1585.3955,-1671.6195,6.0846,269.2602,0,1); // police station ranger
	AddStaticVehicle2(COPRANGER,1584.6819,-1667.6851,6.0791,269.2272,0,1); // police station ranger
	AddStaticVehicle2(COPRANGER,1601.9421,-1684.0054,6.0797,89.9971,0,1); // police station ranger
	AddStaticVehicle2(COPRANGER,1602.3267,-1691.9391,6.1032,91.0921,0,1); // police station ranger
	AddStaticVehicle2(COPRANGER,1603.4213,-1614.9706,13.6899,86.7397,0,1); // police station ranger outdoors
	AddStaticVehicle2(COPRANGER,1603.1095,-1604.8138,13.6777,89.8504,0,1); // police station ranger outdoors

	AddStaticVehicle2(BIKESLOW,1767.4407,-1689.3885,12.9402,180.4357,CarCol(),CarCol()); // terrorist bike 1
	AddStaticVehicle2(BIKESLOW,1771.0730,-1688.7708,13.0141,181.8331,CarCol(),CarCol()); // terrorists bike 2
	AddStaticVehicle2(HUNTLEY,1808.7601,-1715.5109,13.4829,180.1130,CarCol(),CarCol()); // terrorists huntley
	AddStaticVehicle2(HUNTLEY,1808.7458,-1707.0656,13.4865,180.0818,CarCol(),CarCol()); // terrorists huntley north
	AddStaticVehicle2(BIKEBIG,1774.7974,-1688.7113,12.9956,176.7240,CarCol(),CarCol()); // terrorists bike 3
	AddStaticVehicle2(BIKEBIG,1778.2140,-1688.9255,12.9975,181.9484,CarCol(),CarCol()); // terrorists bike 4
	AddStaticVehicle2(VAN,1795.7860,-1691.3322,13.4844,181.4520,CarCol(),CarCol()); // terrorists van
	AddStaticVehicle2(VAN,1805.5522,-1690.5121,13.5993,152.4614,CarCol(),CarCol()); // terrorists van corner
	AddStaticVehicle2(RANCHER,1766.9115,-1695.8004,13.5906,91.9755,CarCol(),CarCol()); // terrorists 4x4
	AddStaticVehicle2(SMALLVAN,1767.4751,-1704.2063,13.6066,91.5783,CarCol(),CarCol()); // terrorists small van
	AddStaticVehicle2(SALOON2,1786.7887,-1689.5065,13.1861,89.9475,CarCol(),CarCol()); // terrorists old car

	AddStaticVehicle2(POLICEMAV,1987,-2286.9893,15.1966,85.8866,0,1); //
	AddStaticVehicle2(POLICEMAV,1987,-2314.5679,13.6807,86.7669,0,1); //
	AddStaticVehicle2(POLICEMAV,1992,-2400,13.7241,90.2958,0,1); //
	AddStaticVehicle2(POLICEMAV,1992,-2375,13.7236,77.8665,0,1); // police mav
	AddStaticVehicle2(POLICEMAV,1992,-2350,13.7236,94.8186,0,1); // police mav 2
	AddStaticVehicle2(SEASPARROW,2737.4866,-1760.1506,44.1182,224.5974,75,2); // sparrow1
	AddStaticVehicle2(SEASPARROW,1568.8612,-1238.7914,277.8883,49.2131,75,2); // sparrow2


	AddStaticVehicle2(SHAMAL,1596.1857,-2450,14.4836,0.0000,1,1); // shamal
	AddStaticVehicle2(SHAMAL,1559.7833,-2450,14.4836,0.0000,1,1); // shamal
	AddStaticVehicle2(RUSTLER,1516.4668,-2455,14.2437,359.9142,7,6); // rustler
	AddStaticVehicle2(RUSTLER,1486.6560,-2455,14.2642,359.9445,1,6); // rustler
	AddStaticVehicle2(BEAGLE,1457.6503,-2446.1963,14.9146,0.0000,4,90); // beagle
	AddStaticVehicle2(BEAGLE,1442.9895,-2493.7166,14.9277,270.0598,7,68); // beagle runway
	AddStaticVehicle2(AT400,1470.1775,-2593.4873,13.4630,269.6879,8,7); // massive fucking plane
	AddStaticVehicle2(STAIRS,1489.0352,-2590,13.2065,180.2330,1,76); // stairs for plane
	AddStaticVehicle2(BAGGAGE,1877.1975,-2419.0972,13.2110,117.3680,1,78); // baggage
	AddStaticVehicle2(BAGGAGE,1807.3389,-2449.4619,13.2110,129.6533,1,78); // baggage
	AddStaticVehicle2(BAGGAGE,1697.7036,-2434.6035,13.2111,116.7797,1,78); // baggage

	AddStaticVehicle2(POSH2,1465.7742,-899.0321,54.8603,3.2162,CarCol(),CarCol()); // posh house 1
	AddStaticVehicle2(POSH1,1527.2067,-886.2890,61.1146,254.2985,CarCol(),CarCol()); // roof top
	AddStaticVehicle2(POSH3,1535.1796,-841.1790,64.8940,94.3109,CarCol(),CarCol()); // posh 3
	AddStaticVehicle2(POSH4,1528.4613,-811.7554,71.8663,89.1012,CarCol(),CarCol()); // posh 4
	AddStaticVehicle2(POSH1,1025.5624,-800.0936,101.8734,20.1116,CarCol(),CarCol()); // posh
	AddStaticVehicle2(POSH2,920.5785,-786.9205,114.3464,68.2807,CarCol(),CarCol()); // posh
	AddStaticVehicle2(POSH3,855.9669,-815.3113,87.7593,19.6388,CarCol(),CarCol()); // posh
	AddStaticVehicle2(POSH3,684.5640,-1074.3420,49.5645,60.4335,CarCol(),CarCol()); // posh
	AddStaticVehicle2(POSH1,404.5968,-1155.5228,77.6275,143.8123,CarCol(),CarCol()); // posh
	AddStaticVehicle2(POSH3,289.7317,-1167.9216,80.9028,220.8520,CarCol(),CarCol()); // very posh
	AddStaticVehicle2(POSH3,292.9161,-1162.0803,80.9022,220.1603,CarCol(),CarCol()); // very posh
	AddStaticVehicle2(POSH4,288.0584,-1327.9247,53.5295,218.3855,CarCol(),CarCol()); // posh
	AddStaticVehicle2(POSH3,1241.8268,-749.5003,94.2435,18.4917,CarCol(),CarCol()); //
	AddStaticVehicle2(POSH1,872.4854,-872.3334,77.2855,200.1391,CarCol(),CarCol()); // posh
	AddStaticVehicle2(POSH2,833.5978,-926.3884,54.9567,246.7931,CarCol(),CarCol()); // posh
	AddStaticVehicle2(POSH2,842.0680,-896.1290,68.4778,232.5096,CarCol(),CarCol()); // posh
	AddStaticVehicle2(POSH4,1086.8040,-637.7476,112.9547,5.5657,CarCol(),CarCol()); // posh
	AddStaticVehicle2(HUNTLEY,1528.2061,-800.0825,73.0617,90.4437,CarCol(),CarCol()); // posh 4b (rancher)
	AddStaticVehicle2(BIKEFAST,1018.2570,-777.7994,102.6511,90.7938,CarCol(),CarCol()); // posh bike
	AddStaticVehicle2(HUNTLEY,848.0241,-818.4172,87.0807,22.0264,CarCol(),CarCol()); // posh rancher
	AddStaticVehicle2(BIKEFAST,718.9101,-1001.8113,52.4130,148.8447,CarCol(),CarCol()); // posh bike
	AddStaticVehicle2(BIKEFAST,278.7959,-1257.6844,73.9157,215.0338,CarCol(),CarCol()); // posh bike
	AddStaticVehicle2(BIKESLOW,337.6167,-1308.5352,54.2161,209.8673,CarCol(),CarCol()); // sanchez
	AddStaticVehicle2(BIKESLOW,346.4070,-1300.6411,54.2168,206.8296,CarCol(),CarCol()); // sanchez
	AddStaticVehicle2(PATRIOT,914.0649,-665.7319,116.7606,241.1865,CarCol(),CarCol()); // patriot
	AddStaticVehicle2(MONSTER,946.1701,-705.2098,121.9152,29.1216,CarCol(),CarCol()); // bandito
	AddStaticVehicle2(HUNTLEY,940.8948,-695.8306,121.1879,29.9158,CarCol(),CarCol()); // sand king
	AddStaticVehicle2(HUNTLEY,1097.4353,-642.2601,112.5732,267.1823,CarCol(),CarCol()); // huntley
	AddStaticVehicle2(RANCHER,1413.9097,-481.3066,42.9720,297.0425,CarCol(),CarCol()); // rancher

	AddStaticVehicle2(CONV1,1659.2822,-1426.8878,13.3985,88.7621,CarCol(),CarCol()); // com
	AddStaticVehicle2(CONV2,1590.5114,-1317.7780,17.2589,49.2585,CarCol(),CarCol()); // com
	AddStaticVehicle2(CONV3,1809.2898,-1430.6573,13.1695,184.9688,CarCol(),CarCol()); // com
	AddStaticVehicle2(CONV4,1725.2581,-1217.3599,19.0807,2.3763,CarCol(),CarCol()); // com
	AddStaticVehicle2(CONV1,1531.0547,-1066.9626,24.7978,90.4579,CarCol(),CarCol()); // com
	AddStaticVehicle2(POSH2,1451.6792,-1146.7477,23.7968,133.4617,CarCol(),CarCol()); // com
	AddStaticVehicle2(CONV3,1328.1886,-1188.7338,23.3185,176.1219,CarCol(),CarCol()); // com
	AddStaticVehicle2(CONV4,1252.2759,-1430.6191,13.2775,183.7629,CarCol(),CarCol()); // com
	AddStaticVehicle2(CONV1,1357.4553,-1570.0588,13.2831,163.9771,CarCol(),CarCol()); // com
	AddStaticVehicle2(CONV2,1677.5549,-1680.1785,13.2813,182.6165,CarCol(),CarCol()); // com

	AddStaticVehicle2(CONV3,1462.1278,-1356.1224,13.6903,0.6286,CarCol(),CarCol()); // com
	AddStaticVehicle2(POSH1,1294.6667,-984.6381,32.8379,180.0905,CarCol(),CarCol()); // cheetah
	AddStaticVehicle2(SUV1,1205.1552,-1070.0197,29.3908,178.9626,CarCol(),CarCol()); // res
	AddStaticVehicle2(CEMENT,1256.7892,-1261.7640,13.3957,272.3957,CarCol(),CarCol()); // ind
	AddStaticVehicle2(CONV3,1429.0876,-1408.5740,13.7150,179.6099,CarCol(),CarCol()); // com
	AddStaticVehicle2(CONV3,1479.4669,-1415.0720,12.0265,125.8019,CarCol(),CarCol()); // com
	AddStaticVehicle2(LOW1,1947.7089,-1055.4075,24.3895,261.2244,CarCol(),CarCol()); // low
	AddStaticVehicle2(SALOON4,2149.6853,-1137.7899,25.6585,90.4148,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(SALOON1,2160.4878,-1192.2114,23.9636,272.4233,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(SALOON3,2241.3850,-1317.9384,24.1282,269.8383,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(SALOON4,2347.2151,-1274.0010,22.6479,272.8961,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(LOW2,2427.8301,-1241.7535,24.4136,273.2498,CarCol(),CarCol()); // lowrider
	AddStaticVehicle2(LOW3,2413.4661,-1229.0675,24.5211,182.1959,CarCol(),CarCol()); // lowrider
	AddStaticVehicle2(BIKESLOW,2463.7815,-1424.0723,23.8932,83.3706,CarCol(),CarCol()); // slow bike
	AddStaticVehicle2(SALOON4,2460.6946,-1551.0662,24.1444,273.1476,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(LOW2,2479.3372,-1748.7130,13.6900,180.5300,CarCol(),CarCol()); // lowrider
	AddStaticVehicle2(SALOON2,2393.3811,-1927.7556,13.5243,0.1380,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(LOW1,2390.0774,-1884.8796,13.6899,265.9858,CarCol(),CarCol()); // lowrider
	AddStaticVehicle2(SALOON2,2728.9060,-1970.3724,13.6880,269.7400,CarCol(),CarCol()); // saloon cheap

	AddStaticVehicle2(SUV3,976.4387,-1230.6876,17.0708,88.5852,41,41); // suv
	AddStaticVehicle2(FLATBED,834.1715,-1216.6764,17.0872,84.6204,41,41); // ind
	AddStaticVehicle2(TOWTRUCK,860.5280,-1285.6953,14.0937,182.9245,41,41); // ind
	AddStaticVehicle2(SALOON3,920.2068,-1292.6371,13.8247,270.7137,41,41); // saloon
	AddStaticVehicle2(SUV2,1012.5267,-1346.8806,13.4797,267.5486,41,41); // suv
	AddStaticVehicle2(SUV3,1117.3052,-1378.9901,14.4011,89.1945,41,41); // suv
	AddStaticVehicle2(BIKEFAST,1132.5653,-1614.6372,13.9194,85.6389,41,41); // fast bike in shopping centre
	AddStaticVehicle2(CONV4,1160.2629,-1770.1327,16.7116,359.6430,41,41); // com
	AddStaticVehicle2(CONV2,1284.9130,-1732.6017,13.6673,0.8082,41,41); // com

	AddStaticVehicle2(SUV3,974.6439,-1089.6545,24.2836,177.6930,CarCol(),CarCol()); // suv
	AddStaticVehicle2(SALOON1,785.2358,-1064.5126,24.9404,49.4555,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(CONV1,922.8809,-996.1521,38.3117,97.5416,CarCol(),CarCol()); // com
	AddStaticVehicle2(SUV1,1140.2466,-927.7980,43.3007,271.3280,CarCol(),CarCol()); // suv
	AddStaticVehicle2(SALOON2,1337.9901,-901.7728,36.4426,180.8606,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(SWEEPER,1646.3864,-1062.6378,24.0274,155.3884,CarCol(),CarCol()); // sweeper
	AddStaticVehicle2(VAN,1649.0890,-1111.7745,24.0429,267.8602,CarCol(),CarCol()); // van
	AddStaticVehicle2(SMALLVAN,1657.3999,-1134.4487,24.0332,180.5504,CarCol(),CarCol()); // smallvan
	AddStaticVehicle2(FLATBED,1564.0852,-1019.3521,24.0372,81.4864,CarCol(),CarCol()); // flatbed
	AddStaticVehicle2(BIKEFAST,1518.3389,-1257.1481,14.6713,180.1029,CarCol(),CarCol()); // fastbike
	AddStaticVehicle2(SALOON3,1999.5741,-1445.1320,13.6917,217.9478,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(LOW1,2086.8411,-1327.5076,24.1078,0.7111,CarCol(),CarCol()); // low
	AddStaticVehicle2(SALOON4,1993.6346,-1276.0702,23.9460,357.9409,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(SWEEPER,1816.7452,-1133.7300,24.2091,273.6008,CarCol(),CarCol()); // sweeper
	AddStaticVehicle2(COACH,1775.9677,-1022.6566,24.0901,333.2864,CarCol(),CarCol()); // coach
	AddStaticVehicle2(SALOON1,2051.7642,-1121.0273,24.7394,176.2412,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(LOW2,2080.0862,-1284.8212,24.0993,178.8542,CarCol(),CarCol()); // lowrider
	AddStaticVehicle2(LOW3,2143.8416,-1422.6912,25.2155,89.4439,CarCol(),CarCol()); // low
	AddStaticVehicle2(BIKESLOW,2199.1309,-1497.6111,24.1060,275.7724,CarCol(),CarCol()); // slowbike
	AddStaticVehicle2(SUV2,2200.7722,-1660.7334,15.1396,164.7502,CarCol(),CarCol()); // sub
	AddStaticVehicle2(BIKEBIG,2321.2974,-1756.2679,13.6757,273.8248,CarCol(),CarCol()); // bikebig

	AddStaticVehicle2(STRETCH,1460.0215,-1025.5533,23.5681,90.6347,22,1); // limo bingo
	AddStaticVehicle2(STRETCH,1439.1008,-1025.7854,23.5682,90.6346,22,1); // limo bingo


	AddStaticVehicle2(COACH,1567.8092,-1891.4109,13.7520,356.6625,CarCol(),CarCol()); // coach
	AddStaticVehicle2(SUV1,1370.2388,-1889.9265,13.7022,359.3041,CarCol(),CarCol()); // suv
	AddStaticVehicle2(SALOON2,1206.1053,-1829.6782,13.5963,92.9658,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(CONV2,1022.5290,-1832.1632,13.8703,62.2289,CarCol(),CarCol()); // com
	AddStaticVehicle2(CONV4,860.6016,-1756.1599,13.7098,17.1219,CarCol(),CarCol()); // com
	AddStaticVehicle2(POSH1,721.0599,-1809.3398,12.5489,71.5726,CarCol(),CarCol()); // posh
	AddStaticVehicle2(SUV2,479.5703,-1765.3434,5.7271,87.6614,CarCol(),CarCol()); // suv
	AddStaticVehicle2(SUV3,266.6155,-1746.7922,4.5722,91.5479,CarCol(),CarCol()); // suv
	AddStaticVehicle2(CONV1,276.7425,-1594.9742,33.2880,348.6675,CarCol(),CarCol()); // com
	AddStaticVehicle2(CONV3,425.1006,-1440.8821,31.4193,36.4924,CarCol(),CarCol()); // com
	AddStaticVehicle2(SUV1,551.6909,-1505.2357,14.7316,182.8906,CarCol(),CarCol()); // suv
	AddStaticVehicle2(SALOON3,649.7829,-1620.6465,15.2105,112.6496,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(BIKEFAST,682.0504,-1259.6924,13.7628,106.4779,CarCol(),CarCol()); // bikefast
	AddStaticVehicle2(BIKEBIG,2175.6335,-993.5605,63.1809,169.8002,CarCol(),CarCol()); // bikebig
	AddStaticVehicle2(RANCHER,2453.6128,-1016.0901,59.8982,177.5543,CarCol(),CarCol()); // rancher
	AddStaticVehicle2(SALOON4,2536.1904,-1104.8235,59.8875,180.5492,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(LOW1,2328.6465,-1407.3834,24.1766,178.8325,CarCol(),CarCol()); // low
	AddStaticVehicle2(MONSTER,2492.1194,-1663.3529,13.5302,82.4906,CarCol(),CarCol()); // monster
	AddStaticVehicle2(SALOON2,2066.3311,-1694.5254,13.7310,268.5239,CarCol(),CarCol()); // saloon2
	AddStaticVehicle2(CEMENT,2054.1970,-1767.7522,13.7393,181.0835,CarCol(),CarCol()); // cement
	AddStaticVehicle2(FLATBED,1939.3959,-1815.7340,13.7385,77.9876,CarCol(),CarCol()); // flatbed
	AddStaticVehicle2(TOWTRUCK,1937.9028,-1939.7325,13.7375,89.1628,CarCol(),CarCol()); // towtruck
	AddStaticVehicle2(BIKESLOW,1941.1481,-2140.8420,13.7440,175.4044,CarCol(),CarCol()); // bikeslow
	AddStaticVehicle2(SWEEPER,2125.8816,-2165.4050,13.7341,320.7342,CarCol(),CarCol()); // sweeper
	AddStaticVehicle2(PATRIOT,2076.9661,-1994.8885,13.7389,41.9139,CarCol(),CarCol()); // patriot

	AddStaticVehicle2(SALOON2,1502.1649,-2212.7788,13.3136,359.6183,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(SUV1,1407.0730,-2261.8484,13.3164,180.3750,CarCol(),CarCol()); // suv
	AddStaticVehicle2(CONV2,1365.5696,-2365.7705,13.3159,90.6723,CarCol(),CarCol()); // com
	AddStaticVehicle2(VAN,1789.8521,-2180.6389,13.3187,270.2510,CarCol(),CarCol()); // van
	AddStaticVehicle2(SALOON4,1922.5924,-1605.3048,13.1082,269.9615,118,118); // saloon
	AddStaticVehicle2(BIKEBIG,2070.1260,-1591.6121,13.0664,182.2131,118,118); // bikebig
	AddStaticVehicle2(SALOON3,2705.9854,-1844.6924,9.8701,340.3920,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(SUV2,2813.2185,-1671.5564,10.3166,2.8114,CarCol(),CarCol()); // suv
	AddStaticVehicle2(LOW2,2644.6707,-2023.4589,13.9219,1.6210,CarCol(),CarCol()); // low
	AddStaticVehicle2(CEMENT,2743.6338,-2138.0737,11.5750,94.0439,CarCol(),CarCol()); // cement
	AddStaticVehicle2(FLATBED,2300.8748,-2043.2729,13.9219,93.1316,CarCol(),CarCol()); // flatbed
	AddStaticVehicle2(SALOON1,2241.5413,-2111.0176,13.9195,134.0082,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(BIKEFAST,2228.4226,-1811.8547,13.8943,269.9799,CarCol(),CarCol()); // bikefast
	AddStaticVehicle2(LOW1,2505.4697,-1235.4440,37.6099,356.9889,CarCol(),CarCol()); // lowr
	AddStaticVehicle2(SMALLVAN,2587.6326,-1322.8219,40.4727,91.7934,CarCol(),CarCol()); // smallvan
	AddStaticVehicle2(BIKESLOW,2527.5496,-1465.3361,24.3251,86.3631,CarCol(),CarCol()); // slowbike
	AddStaticVehicle2(SALOON3,2698.6609,-1191.8911,69.7986,270.9197,CarCol(),CarCol()); // saloon
	AddStaticVehicle2(RANCHER,2706.4719,-1274.8931,58.4590,135.3378,CarCol(),CarCol()); // rancher

	AddStaticVehicle2(CONV2,894.8080,-1518.4893,12.8387,9.3645,CarCol(),CarCol()); // com
	AddStaticVehicle2(RANCHER,1725.1200,-405.3828,45.0947,196.5883,CarCol(),CarCol()); // offroad
	AddStaticVehicle2(RANCHER,1970.6564,-813.4561,129.1876,281.6888,CarCol(),CarCol()); // rancher
	AddStaticVehicle2(RANCHER,2431.9832,-773.8238,113.2601,296.2740,CarCol(),CarCol()); // rancher
	AddStaticVehicle2(RANCHER,2662.3218,-438.5351,59.7808,318.4588,CarCol(),CarCol()); // rancher

	printf("\nNumber of cars: %d",vehicle_counter);
	
	class_tramp1 = AddPlayerClass2(230,1472.2418,-1626.8203,14.0469,32.7339,WEAPON_CHAINSAW,-1,WEAPON_AK47,100,WEAPON_DEAGLE,300);
	class_tramp2 = AddPlayerClass2(212,1467.3743,-1632.4604,14.0469,59.0541,WEAPON_CHAINSAW,-1,WEAPON_AK47,100,WEAPON_DEAGLE,300);
	class_tramp3 = AddPlayerClass2(200,1465.1167,-1639.7102,14.0469,93.0629,WEAPON_CHAINSAW,-1,WEAPON_AK47,100,WEAPON_DEAGLE,300);
	class_tramp4 = AddPlayerClass2(137,1466.9926,-1646.9403,14.0469,90.8695,WEAPON_CHAINSAW,-1,WEAPON_AK47,100,WEAPON_DEAGLE,300);

	class_terrorist1 = AddPlayerClass2(181, 1785.0, -1704.0, 13.52, 0, WEAPON_SAWEDOFF,300, WEAPON_MP5,300, WEAPON_AK47,300);
	class_terrorist2 = AddPlayerClass2(183, 1784.0, -1704.0, 13.52, 0, WEAPON_SAWEDOFF,300, WEAPON_MP5,300, WEAPON_M4,300);
	class_terrorist3 = AddPlayerClass2(179, 1783.0, -1704.0, 13.52, 0, WEAPON_SAWEDOFF,300, WEAPON_MP5,300, WEAPON_FLAMETHROWER,300);
	class_terrorist4 = AddPlayerClass2(191, 1782.0, -1704.0, 13.52, 0, WEAPON_SAWEDOFF,300, WEAPON_MP5,300, WEAPON_AK47,300);
	class_terrorist5 = AddPlayerClass2(111, 1781.0, -1704.0, 13.52, 0, WEAPON_SAWEDOFF,300, WEAPON_MP5,300, WEAPON_M4,300);
	class_terrorist6 = AddPlayerClass2(73,  1780.0, -1704.0, 13.52, 0, WEAPON_SAWEDOFF,300, WEAPON_MP5,300, WEAPON_FLAMETHROWER,300);
	class_terrorist7 = AddPlayerClass2(100, 1779.0, -1704.0, 13.52, 0, WEAPON_SAWEDOFF,300, WEAPON_MP5,300, WEAPON_M4,300);

	class_primeminister = AddPlayerClass2(147,1125.7273,-2036.8785,69.8804,270.1728,WEAPON_CANE,-1,WEAPON_SPRAYCAN,1000, WEAPON_PARACHUTE,-1);
	class_bodyguard1 = AddPlayerClass2(163,1126.2628,-2039.2416,69.8825,271.4261,WEAPON_SILENCED,100,WEAPON_UZI,200, WEAPON_PARACHUTE,-1);
	class_bodyguard2 = AddPlayerClass2(164,1126.4246,-2034.1844,69.8850,271.4261,WEAPON_SILENCED,100,WEAPON_UZI,200, WEAPON_PARACHUTE,-1);
	class_bodyguard3 = AddPlayerClass2(141,1127.4246,-2036.1844,69.8850,271.4261,WEAPON_SILENCED,100,WEAPON_UZI,200, WEAPON_PARACHUTE,-1);

	class_cop1  = AddPlayerClass2(280,1585,-1684,6.2252,270, WEAPON_DEAGLE,100,WEAPON_MP5,200,WEAPON_SPRAYCAN,300);
	class_cop2  = AddPlayerClass2(280,1585,-1685,6.2188,270, WEAPON_DEAGLE,100,WEAPON_MP5,200,WEAPON_SPRAYCAN,300);
	class_cop3  = AddPlayerClass2(280,1585,-1686,6.2188,270, WEAPON_DEAGLE,100,WEAPON_MP5,200,WEAPON_SPRAYCAN,300);
	class_cop4  = AddPlayerClass2(281,1585,-1687,6.2188,270, WEAPON_DEAGLE,100,WEAPON_MP5,200,WEAPON_SPRAYCAN,300);
	class_cop5  = AddPlayerClass2(281,1585,-1688,6.2188,270, WEAPON_DEAGLE,100,WEAPON_MP5,200,WEAPON_SPRAYCAN,300);
	class_cop6  = AddPlayerClass2(246,1610,-1690,6.2188, 90, WEAPON_DEAGLE,100,WEAPON_MP5,200,WEAPON_SPRAYCAN,300);
	class_cop7  = AddPlayerClass2(284,1610,-1689,6.2188, 90, WEAPON_DEAGLE,100,WEAPON_MP5,200,WEAPON_SPRAYCAN,300);
	class_cop8  = AddPlayerClass2(284,1610,-1688,6.2188, 90, WEAPON_DEAGLE,100,WEAPON_MP5,200,WEAPON_SPRAYCAN,300);
	class_cop9  = AddPlayerClass2(285,1610,-1687,6.2188, 90, WEAPON_DEAGLE,100,WEAPON_MP5,200,WEAPON_SPRAYCAN,300);
	class_cop10 = AddPlayerClass2(285,1610,-1686,6.2188, 90, WEAPON_DEAGLE,100,WEAPON_MP5,200,WEAPON_SPRAYCAN,300);
	
	class_teams[class_tramp1] = TEAM_TRAMP;
	class_teams[class_tramp2] = TEAM_TRAMP;
	class_teams[class_tramp3] = TEAM_TRAMP;
	class_teams[class_tramp4] = TEAM_TRAMP;

	class_teams[class_terrorist1] = TEAM_TERRORIST;
	class_teams[class_terrorist2] = TEAM_TERRORIST;
	class_teams[class_terrorist3] = TEAM_TERRORIST;
	class_teams[class_terrorist4] = TEAM_TERRORIST;
	class_teams[class_terrorist5] = TEAM_TERRORIST;
	class_teams[class_terrorist6] = TEAM_TERRORIST;
	class_teams[class_terrorist7] = TEAM_TERRORIST;

	class_teams[class_primeminister] = TEAM_PRIMEMINISTER;
	class_teams[class_bodyguard1] = TEAM_BODYGUARD;
	class_teams[class_bodyguard2] = TEAM_BODYGUARD;
	class_teams[class_bodyguard3] = TEAM_BODYGUARD;

	class_teams[class_cop1] = TEAM_COP;
	class_teams[class_cop2] = TEAM_COP;
	class_teams[class_cop3] = TEAM_COP;
	class_teams[class_cop4] = TEAM_COP;
	class_teams[class_cop5] = TEAM_COP;
	class_teams[class_cop6] = TEAM_COP;
	class_teams[class_cop7] = TEAM_COP;
	class_teams[class_cop8] = TEAM_COP;
	class_teams[class_cop9] = TEAM_COP;
	class_teams[class_cop10] = TEAM_COP;

	for (new i=0 ; i<MAX_PLAYERS ; i++) {
		player_class[i] = -1;
 	}

	regular_task_timer = SetTimer("RegularTask", 50, 1);
	
	round_timer_counter = 0;
	round_timer = SetTimer("RoundTick", 1000, 1);

	return 1;
}



public OnPlayerConnect(playerid)
{
	player_watching[playerid] = -1;
	new text[256];
	format (text, sizeof text, "Welcome to \"%s\".", mode_name);
	SendClientMessage(playerid,COLOUR_IMPORTANT,text);
	SendClientMessage(playerid,COLOUR_IMPORTANT,"Select a character class, and have fun!");
	SendClientMessage(playerid,COLOUR_IMPORTANT,"(Fixed PM \"death glimpse\" code.)");
	SendClientMessage(playerid,COLOUR_IMPORTANT,"(New facilities for admin cheater observation.)");
	SendClientMessage(playerid,COLOUR_IMPORTANT,"(Lots of code clean-ups.)");
	SetPlayerColor(playerid,0x808080AA);
	WhatClassesLeft(playerid);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{

 	SetPlayerInterior(playerid,14);
	SetPlayerPos(playerid,258.4893,-41.4008,1002.0234);
	SetPlayerFacingAngle(playerid, 270.0);
	SetPlayerCameraPos(playerid,256.0815,-43.0475,1004.0234);
	SetPlayerCameraLookAt(playerid,258.4893,-41.4008,1002.0234);


	player_class_requested[playerid] = classid;
	
	if (GetPlayerFromClass(classid)==-1) {
	
		new name[80];
		GetTextFromTeam(name, class_teams[classid]);
	
		new text[80];
		format(text,80,"~w~%s",name);
	
		GameTextForPlayer(playerid,text,1000,GAME_TEXT_STYLE_BIG);
		
	} else {
	
		new name[80];
		GetTextFromTeam(name, class_teams[classid]);

		new text[80];
	 	format(text,80,"~w~%s ~n~ ~r~Not available",name);

		GameTextForPlayer(playerid,text,1500,GAME_TEXT_STYLE_BIG);
		
	}
	 
	return 1;
}

public OnPlayerSpawn(playerid)
{
	// check to make sure that class is actually unused
	if (player_class[playerid] == -1) {
		new early_bird = GetPlayerFromClass(player_class_requested[playerid]);
		if (early_bird == -1) {
			SetPlayerClass(playerid,player_class_requested[playerid]);
		} else {
			SendClientMessage(playerid,COLOUR_IMPORTANT,"The class you selected was full, picking something else...");
			SetPlayerClass(playerid,GetConsolationClass());
		}
 	}

	SetPlayerInterior(playerid,0);
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid,POCKET_MONEY);
	
	SetPlayerWorldBounds(playerid,GAME_BOUNDARY_MAX_X,GAME_BOUNDARY_MIN_X,GAME_BOUNDARY_MAX_Y,GAME_BOUNDARY_MIN_Y);
	TogglePlayerControllable(playerid,1);

	SetPlayerCheckpoint(playerid,1330.2595,-626.7542,50,130);

	return 1;
}

SetPlayerClass(playerid, class)
{
	new team_name[80];
	new text[80];
	new player_name[80];
	GetPlayerName(playerid,player_name,80);

	if (player_class[playerid]!=-1) {

		GetTextFromTeam(team_name,class_teams[player_class[playerid]]);

		format (text, sizeof text, "%s is nolonger %s.", player_name, team_name);
		SendClientMessageToAll(TeamColour(class_teams[player_class[playerid]]),text);
	}

	player_class[playerid] = class;

	if (class==-1) return;

	SetPlayerColor(playerid,TeamColour(class_teams[class]));

	SetSpawnInfo(playerid,0,
        class_modelid[class],
        class_spawn_x[class],
        class_spawn_y[class],
        class_spawn_z[class],
        class_z_angle[class],
        class_weapon1[class],
        class_weapon1_ammo[class],
        class_weapon2[class],
        class_weapon2_ammo[class],
        class_weapon3[class],
        class_weapon3_ammo[class]);
        
	GetTextFromTeam(team_name,class_teams[class]);

	format (text, 80, "~y~You are %s~n~~w~/duty to get orders~n~ /reclass to change", team_name);
	GameTextForPlayer(playerid,text,7000,GAME_TEXT_STYLE_SMALL);

	format (text, 80, "%s is now %s.",player_name, team_name);
	SendClientMessageToAll(TeamColour(class_teams[class]),text);

	SpawnPlayer(playerid);

}

WhatClassesLeft(playerid)
{
	new text[100];
	format(text,100,"Already taken:");
	if (GetPlayerFromClass(class_primeminister)!=-1)
		format(text,100,"%s, %s",text,"Prime Minister");
	if (GetFreeBodyGuard()==-1)
		format(text,100,"%s, %s",text,"All Bodyguards");
	if (GetFreeTerrorist()==-1)
		format(text,100,"%s, %s",text,"All Terrorists");
	if (GetFreeCop()==-1)
		format(text,100,"%s, %s",text,"All Cops");
	if (GetFreeTramp()==-1)
		format(text,100,"%s, %s",text,"All Psychopaths");
		
	text[14] = ' ';

	format(text,100,"%s.",text);

	if (!streq(text,"Already taken: .")) // only mention it if something actually has been taken
		SendClientMessage(playerid,0xFFD000AA,text);
}

public OnPlayerDeath(playerid, killerid, reason)
{
	printf("OnPlayerDeath(%d,%d,%d)",playerid,killerid,reason);

	if (player_class[playerid]==-1) {
		printf("error: a player died without a class");
		return 1;
	}
	
	if (killerid!=INVALID_PLAYER_ID) {
		new score = GetPlayerScore(killerid);
		SetPlayerScore(killerid,score+1);
	}

	if (class_teams[player_class[playerid]]==TEAM_PRIMEMINISTER) {
		if (killerid==INVALID_PLAYER_ID)
			killerid = playerid;
		switch (class_teams[player_class[killerid]]) {
			case TEAM_PRIMEMINISTER:
				GameTextForAll("The Prime Minister was killed in an accident!", 3000, GAME_TEXT_STYLE_SMALL);
			case TEAM_BODYGUARD:
				GameTextForAll("The Prime Minister was killed by his treacherous bodyguards", 3000, GAME_TEXT_STYLE_SMALL);
			case TEAM_COP:
				GameTextForAll("The Prime Minister was killed by the cops", 3000, GAME_TEXT_STYLE_SMALL);
			case TEAM_TERRORIST:
				GameTextForAll("The Prime Minister was killed by the terrorists", 3000, GAME_TEXT_STYLE_SMALL);
			case TEAM_TRAMP:
				GameTextForAll("The Prime Minister was killed by a psychopath", 3000, GAME_TEXT_STYLE_SMALL);
			default: printf("error OnPlayerDeath");
		}
		
		EveryoneViewsBody(killerid,playerid);

		SetTimer("GameModeExitFunc", 3000, 0);
	}
	SendDeathMessage(killerid, playerid, reason);
	return 1;
}


EveryoneViewsBody(killerid,bodyplayerid)
{
	new Float:kx;
	new Float:ky;
	new Float:kz;
	GetPlayerPos(killerid, kx, ky, kz);

	new Float:bx;
	new Float:by;
	new Float:bz;
	GetPlayerPos(bodyplayerid, bx, by, bz);

	// from body to killer
	new Float:vx = kx - bx;
	new Float:vy = ky - by;
	new Float:vz = kz - bz;

	// distance
	new Float:d = floatsqroot(floatpower(vx,2) + floatpower(vy,2) + floatpower(vz,2));
	
	if (d>3) {
		// normalise to unit vector, take distance of 3m and add 1.5 to height
		vx = vx / d * 3;
		vy = vy / d * 3;
		vz = vz / d * 3 + 1;
	} else {
	    // if two players are on top of each other then just go 7.5m upwards
		vx = 0;
		vy = 0;
		vz = 7.5;
	}

	for (new i=0 ; i<MAX_PLAYERS ; i++) {
		if (IsPlayerConnected(i)) {
			TogglePlayerControllable(i,0);
		    if (i!=bodyplayerid && i!=killerid) { // we must not move the "body"
		        SetPlayerPos(i,bx+vx+1,by+vy+1,bz+vz+1);
		    }
			SetPlayerCameraPos(i,bx+vx,by+vy,bz+vz);
			SetPlayerCameraLookAt(i,bx,by,bz);
		}
	}
}




new player_pos_faked[MAX_PLAYERS];
new Float:player_old_x[MAX_PLAYERS];
new Float:player_old_y[MAX_PLAYERS];
new Float:player_old_z[MAX_PLAYERS];
new Float:player_pos_faked_distance[MAX_PLAYERS];

SetPlayerPosAtPlayer(playerid,target)
{
	if (!player_pos_faked[playerid]) {
	    new Float:px;
	    new Float:py;
	    new Float:pz;
	    
		GetPlayerPos(playerid, px, py, pz);
		
		player_old_x[playerid] = px;
		player_old_y[playerid] = py;
		player_old_z[playerid] = pz;
		
		player_pos_faked[playerid] = 1;
	}

	new Float:x;
	new Float:y;
	new Float:z;
	GetPlayerPos(target, x, y, z);

	SetPlayerPos(playerid,x,y,z+player_pos_faked_distance[playerid]);
}

SetPlayerPosAtSelf(playerid)
{
	if (!player_pos_faked[playerid]) return;

	SetPlayerPos(playerid, player_old_x[playerid], player_old_y[playerid], player_old_z[playerid]);
	
	player_pos_faked[playerid] = 0;
}




new pm_old_location = -1;
new ticks_since_loc_update = 100;
new terrorists_in_airport = 0;

public RoundTick()
{
 	new pm = GetPlayerFromClass(class_primeminister);
	round_timer_counter++;
	ticks_since_loc_update++;
	//SetWorldTime(round_timer_counter/60);  // doesn't work very well
	if (round_timer_counter%150==0 && round_timer_counter>0 && round_timer_counter<round_time) {
		new msg[256];
		format(msg,sizeof msg,"~b~%d minutes remaining",(round_time-round_timer_counter)/60);
		GameTextForAll(msg,5000,GAME_TEXT_STYLE_SMALL);
	}

 	new t[7];                                     // <- dont forget to change this!
 	t[0] = GetPlayerFromClass(class_terrorist1);
	t[1] = GetPlayerFromClass(class_terrorist2);
	t[2] = GetPlayerFromClass(class_terrorist3);
	t[3] = GetPlayerFromClass(class_terrorist4);
	t[4] = GetPlayerFromClass(class_terrorist5);
	t[5] = GetPlayerFromClass(class_terrorist6);
	t[6] = GetPlayerFromClass(class_terrorist7);
	
	new terrorists_in_airport_now = 0;
	
	for (new i=0 ; i<sizeof(t) ; i++) {
	    if (t[i]!=-1 && CalcLocation(t[i])==-2)
			terrorists_in_airport_now = 1;
	}
	if (terrorists_in_airport_now!=terrorists_in_airport && ticks_since_loc_update>10) {
        terrorists_in_airport = terrorists_in_airport_now;
		if (terrorists_in_airport_now) {
			ticks_since_loc_update = 0;
			for (new i=0 ; i<MAX_PLAYERS ; i++) {
			    if (IsPlayerConnected(i) && player_class[i]!=-1 && (
				    class_teams[player_class[i]]==TEAM_PRIMEMINISTER ||
				    class_teams[player_class[i]]==TEAM_BODYGUARD ||
				    class_teams[player_class[i]]==TEAM_COP))
					GameTextForPlayer(i,"~r~Terrorist activity in the Airport!",3000,GAME_TEXT_STYLE_SMALL);
			}
		}
	}

	if (pm!=-1) {
		new pml = CalcLocation(pm);
		if (pml != pm_old_location && ticks_since_loc_update>5) {
		    pm_old_location = pml;
		    ticks_since_loc_update = 0;
			new text[200];
			LocationToText(pml,text,sizeof text);
			for (new i=0 ; i<MAX_PLAYERS ; i++) {
			    if (IsPlayerConnected(i) && player_class[i]!=-1 && (
				    class_teams[player_class[i]]==TEAM_TERRORIST ||
				    class_teams[player_class[i]]==TEAM_BODYGUARD ||
				    class_teams[player_class[i]]==TEAM_COP))
					GameTextForPlayer(i,text,3000,GAME_TEXT_STYLE_SMALL);
			}
		}
	}
	
	if (round_timer_counter>round_time) {
		if (pm!=-1) EveryoneViewsBody(pm,pm);
		GameTextForAll("The Prime Minister survived!", 3000, GAME_TEXT_STYLE_SMALL);
		SetTimer("GameModeExitFunc", 3000, 0);
	}
	
	if (pm!=-1 && round_timer_counter % 5 == 0) { // 1% health every 5 seconds
		new Float:health;
		GetPlayerHealth(pm,health);
		if (health < 100) {
			SetPlayerHealth(pm,floatadd(health,1));
		}
	}
}



public OnPlayerDisconnect(playerid)
{
	SetPlayerClass(playerid,-1);
	return 1;
}




public GameModeExitFunc()
{
	KillTimer(round_timer);
	ResetVoteOnEndGame();
	KillTimer(regular_task_timer);
	GameModeExit();
}


GetPlayerFromClass(classid) {
	for (new i=0 ; i<MAX_PLAYERS ; i++) {
		if (IsPlayerConnected(i) && player_class[i] == classid)
			return i;
	}
	return -1;
}

GetConsolationClass() {
	if (GetFreeTramp()!=-1) {
		return GetFreeTramp();
	} else if (GetFreeCop()!=-1) {
		return GetFreeCop();
	} else if (GetFreeTerrorist()!=-1) {
		return GetFreeTerrorist();
	} else if (GetFreeBodyGuard()!=-1) {
		return GetFreeBodyGuard();
	} else if (GetPlayerFromClass(class_primeminister)==-1) {
		return class_primeminister;
	}
	printf("error: we ran out of classes, is max players set right?");
	return -1;
}

GetFreeTramp() {
	if (GetPlayerFromClass(class_tramp1)==-1) {
		return class_tramp1;
	} else if (GetPlayerFromClass(class_tramp2)==-1) {
		return class_tramp2;
	} else if (GetPlayerFromClass(class_tramp3)==-1) {
		return class_tramp3;
	} else if (GetPlayerFromClass(class_tramp4)==-1) {
		return class_tramp4;
	}
	return -1;
}

GetFreeTerrorist() {
	if (GetPlayerFromClass(class_terrorist1)==-1) {
		return class_terrorist1;
	} else if (GetPlayerFromClass(class_terrorist2)==-1) {
		return class_terrorist2;
	} else if (GetPlayerFromClass(class_terrorist3)==-1) {
		return class_terrorist3;
	} else if (GetPlayerFromClass(class_terrorist4)==-1) {
		return class_terrorist4;
	} else if (GetPlayerFromClass(class_terrorist5)==-1) {
		return class_terrorist5;
	} else if (GetPlayerFromClass(class_terrorist6)==-1) {
		return class_terrorist6;
	} else if (GetPlayerFromClass(class_terrorist7)==-1) {
		return class_terrorist7;
	}
	return -1;
}

GetFreeCop() {
	if (GetPlayerFromClass(class_cop1)==-1) {
		return class_cop1;
	} else if (GetPlayerFromClass(class_cop2)==-1) {
		return class_cop2;
	} else if (GetPlayerFromClass(class_cop3)==-1) {
		return class_cop3;
	} else if (GetPlayerFromClass(class_cop4)==-1) {
		return class_cop4;
	} else if (GetPlayerFromClass(class_cop5)==-1) {
		return class_cop5;
	} else if (GetPlayerFromClass(class_cop6)==-1) {
		return class_cop6;
	} else if (GetPlayerFromClass(class_cop7)==-1) {
		return class_cop7;
	} else if (GetPlayerFromClass(class_cop8)==-1) {
		return class_cop8;
	} else if (GetPlayerFromClass(class_cop9)==-1) {
		return class_cop9;
	} else if (GetPlayerFromClass(class_cop10)==-1) {
		return class_cop10;
	}
	return -1;
}

GetFreeBodyGuard() {
	if (GetPlayerFromClass(class_bodyguard1)==-1) {
		return class_bodyguard1;
	} else if (GetPlayerFromClass(class_bodyguard2)==-1) {
		return class_bodyguard2;
	} else if (GetPlayerFromClass(class_bodyguard3)==-1) {
		return class_bodyguard3;
	}
	return -1;
}



public OnPlayerText(playerid,text[])
{
	if (text[0]!='!') return 1;
	
	if (player_class[playerid]==-1) return 1;

	new myteam = class_teams[player_class[playerid]];
	
	for (new i=0 ; i<MAX_PLAYERS ; i++) {
		if (IsPlayerConnected(i) && player_class[i]!=-1) {
			new yourteam = class_teams[player_class[i]];
			if (MessagesGoTo(myteam,yourteam) || MessagesGoTo(yourteam,myteam)) {
				new text2[256];
				GetPlayerName(playerid,text2,sizeof text2);
				format(text2,sizeof text2, "%s: %s", text2, text);
				SendClientMessage(i,COLOUR_IMPORTANT,text2);
			}
		}
	}
	
	return 0;
}

MessagesGoTo(team1, team2)
{
	if (team1==team2) return 1;
	if (team1==TEAM_PRIMEMINISTER && team2==TEAM_BODYGUARD) return 1;
	if (team1==TEAM_PRIMEMINISTER && team2==TEAM_COP) return 1;
	if (team1==TEAM_BODYGUARD && team2==TEAM_COP) return 1;
	return 0;
}

CouldntSpawnAs(playerid,team)
{
	new team_name[80];
	GetTextFromTeam(team_name,team);

	new text[80];
	format (text, 80, "Could not spawn as %s, that class is full.", team_name);
	SendClientMessage(playerid,COLOUR_PERSONAL,text);
}

native Float:floatstr(const string[]);

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[256];
	new rest[256];

	new numparams = parse_command(cmdtext,cmd,rest);
 
	if (numparams==0) {}

 	if (streq(cmd,"/reclass")) {

		if (player_class[playerid]==-1) {
			return 1;
		}

		if (class_teams[player_class[playerid]]==TEAM_PRIMEMINISTER) {
			SendClientMessage(playerid,COLOUR_PERSONAL,"The prime minister must use /swapclass.");
			return 1;
		}

		if (IsPlayerInAnyVehicle(playerid)) {
			SendClientMessage(playerid,COLOUR_PERSONAL,"You cannot /reclass when inside a vehicle.");
			return 1;
		}

		if (strlen(rest)==0) {
			SendClientMessage(playerid,COLOUR_PERSONAL,"Usage: /reclass pm|terrorist|cop|bodyguard|psycho");
		} else if (streq(rest,"cop") || streq(rest,"c")) {
			new myclass = GetFreeCop();
			if (myclass!=-1) {
			    SetPlayerClass(playerid,myclass);
			} else {
				CouldntSpawnAs(playerid,TEAM_COP);
			}
		} else if (streq(rest,"terrorist") || streq(rest,"t")) {
			new myclass = GetFreeTerrorist();
			if (myclass!=-1) {
			    SetPlayerClass(playerid,myclass);
			} else {
				CouldntSpawnAs(playerid,TEAM_TERRORIST);
			}
		} else if (streq(rest,"bodyguard") || streq(rest,"b")) {
			new myclass = GetFreeBodyGuard();
			if (myclass!=-1) {
			    SetPlayerClass(playerid,myclass);
			} else {
				CouldntSpawnAs(playerid,TEAM_BODYGUARD);
			}
		} else if (streq(rest,"psycho") || streq(rest,"p")) {
			new myclass = GetFreeTramp();
			if (myclass!=-1) {
			    SetPlayerClass(playerid,myclass);
			} else {
				CouldntSpawnAs(playerid,TEAM_TRAMP);
			}
		} else if (streq(rest,"pm")) {
			if (GetPlayerFromClass(class_primeminister)==-1) {
			    SetPlayerClass(playerid,class_primeminister);
			} else {
				CouldntSpawnAs(playerid,TEAM_PRIMEMINISTER);
			}
		} else {
			SendClientMessage(playerid,COLOUR_PERSONAL,"No such class.  Usage: /reclass pm|terrorist|cop|bodyguard|psycho");
		}

		return 1;
 	} else if (streq(cmd,"/swapclass")) {
		if (player_class[playerid]==-1 || class_teams[player_class[playerid]]!=TEAM_PRIMEMINISTER) {
			SendClientMessage(playerid,COLOUR_PERSONAL,"You must be the Prime Minister to use this.");
			return 1;
		}

		new id=GetId(playerid,rest);
		if (id==INVALID_PLAYER_ID) {
			SendClientMessage(playerid,COLOUR_PERSONAL,"Usage: /swapclass <person>");
			return 1;
		}

		new victim_class = player_class[id];
		if (victim_class==-1) {
			SendClientMessage(playerid,COLOUR_PERSONAL,"That person has not yet selected a class.");
			return 1;
		}
		
	    SetPlayerClass(playerid,-1);
	    SetPlayerClass(id,class_primeminister); // currently 2 pms running around but only the new one is recognised by the game code
	    SetPlayerClass(playerid,victim_class);

		return 1;
	} else if (streq(cmd,"/duty")) {
		ExplainRole(playerid);
		return 1;
	} else if (streq(cmd,"/intel")) {
	 	TellPlayerIntel(playerid);
		return 1;
	} else if (streq(cmd,"/callvote")) {
		new id=GetId(playerid,rest);
		if (id!=INVALID_PLAYER_ID)
			InitiateVote(playerid,id);
		return 1;
	} else if (streq(cmd,"/vote")) {
		AddVote(playerid);
		return 1;
	} else if (streq(cmd,"/endvote")) {
		CancelVote(playerid);
		return 1;
	} else if (streq(cmd,"/cmds") ||
			   streq(cmd,"/help") ||
			   streq(cmd,"/show_commands") ||
			   streq(cmd,"/show_cmds")) {
		if(IsPlayerAdmin(playerid)) {
			SendClientMessage(playerid, COLOUR_PERSONAL, "/kick /ban /gethealth /sethealth");
			SendClientMessage(playerid, COLOUR_PERSONAL, "/watch /unwatch /pinfo /restart");
			SendClientMessage(playerid, COLOUR_PERSONAL, "/force <name> <cmd>  /tell <text>");
			SendClientMessage(playerid, COLOUR_PERSONAL, "/time /players");
		}
		SendClientMessage(playerid, COLOUR_PERSONAL, "/reclass <class>  (change class)");
		SendClientMessage(playerid, COLOUR_PERSONAL, "/swapclass (pm can swap class with another person)");
		SendClientMessage(playerid, COLOUR_PERSONAL, "/duty (get orders)   /intel (get PM position)");
		SendClientMessage(playerid, COLOUR_PERSONAL, "/callvote /vote /endvote (votekick a cheater)");
		SendClientMessage(playerid, COLOUR_PERSONAL, "Messages starting with ! are team-only.");
		return 1;
	}

	if (IsPlayerAdmin(playerid)) {
		if (streq(cmd,"/kick")) {
			new id=GetId(playerid,rest);
			if (id==INVALID_PLAYER_ID) return 1;
			SendClientMessage(playerid, COLOUR_PERSONAL, "Kick okay.");
			Kick(id);
			return 1;
		} else if (streq(cmd,"/ban")) {
			new id=GetId(playerid,rest);
			if (id==INVALID_PLAYER_ID) return 1;
			SendClientMessage(playerid, COLOUR_PERSONAL, "Ban okay.");
			Ban(id);
			return 1;
		} else if (streq(cmd,"/time")) {
			new minutes = (round_time - round_timer_counter) / 60;
			new seconds = (round_time - round_timer_counter) % 60;
			new text[256];
			format(text,sizeof text, "time left: %d:%d", minutes, seconds);
			SendClientMessage(playerid, COLOUR_PERSONAL, text);
			return 1;
		} else if (streq(cmd,"/players")) {
			new text[256];
			format(text,sizeof text, "players connected: %d", NumPlayersConnected());
			SendClientMessage(playerid, COLOUR_PERSONAL, text);
			return 1;
		} else if (streq(cmd,"/pinfo")) {
			new id=GetId(playerid,rest);
			if (id==INVALID_PLAYER_ID) return 1;
			if (player_class[id]==-1) {
				SendClientMessage(playerid, COLOUR_PERSONAL, "Player not yet selected class.");
				return 1;
			}
			new text[MAX_PLAYER_NAME+10];
			GetPlayerName(id,text, sizeof text);
			format(text,sizeof text, "name: %s [%d]", text, id);
			if (IsPlayerInAnyVehicle(id)) {
			    format(text,sizeof text, "%s {%d}", text, vehicle_modelid[GetPlayerVehicleID(id)]);
			}
			SendClientMessage(playerid, COLOUR_PERSONAL, text);
			return 1;
		} else if (streq(cmd,"/watch")) {
			new playertext[256], d[256];
			parse_command(rest,playertext,d);
			new id=GetId(playerid,playertext);
			if (id==INVALID_PLAYER_ID) return 1;
			if (player_class[id]==-1) {
				SendClientMessage(playerid, COLOUR_PERSONAL, "Player not yet selected class.");
				return 1;
			}
			player_pos_faked_distance[playerid] = IsFloat(d) ? floatstr(d) : 3.0;
			player_watching[playerid] = id;
			return 1;
		} else if (streq(cmd,"/unwatch")) {
			player_watching[playerid] = -1;
			SetPlayerPosAtSelf(playerid);
			return 1;
		} else if (streq(cmd,"/restart")) {
			GameModeExitFunc();
			return 1;
		} else if (streq(cmd,"/gethealth")) {
			new id=GetId(playerid,rest);
			if (id==INVALID_PLAYER_ID) return 1;
			if (player_class[id]==-1) {
				SendClientMessage(playerid, COLOUR_PERSONAL, "Player not yet selected class.");
				return 1;
			}
			new Float:health;
			GetPlayerHealth(id,health);
			new text[256];
			format (text,sizeof text,"Health: %f",health);
			SendClientMessage(playerid, COLOUR_PERSONAL, text);
			return 1;
		} else if (streq(cmd,"/sethealth")) {
			new playertext[256], healthtext[256];
			parse_command(rest,playertext,healthtext);
			new id=GetId(playerid,playertext);
			if (id==INVALID_PLAYER_ID) return 1;
			if (player_class[id]==-1) {
				SendClientMessage(playerid, COLOUR_PERSONAL, "Player not yet selected class.");
				return 1;
			}

			new Float:health = floatstr(healthtext);
			if (!IsFloat(healthtext) || health < 0 || health > 100) {
				SendClientMessage(playerid, COLOUR_PERSONAL, "Invalid health.");
				return 1;
			}

			SetPlayerHealth(id,health);
			new text[256];
			format (text,sizeof text,"Health now: %f",health);
			SendClientMessage(playerid, COLOUR_PERSONAL, text);
			return 1;
		} else if (streq(cmd,"/force")) {
			new playertext[256], rest2[256];
			parse_command(rest,playertext,rest2);
			new id=GetId(playerid,playertext);
			if (id==INVALID_PLAYER_ID) return 1;
			OnPlayerCommandText(id,rest2);
			return 1;
		} else if (streq(cmd,"/getclass")) {
			new id=GetId(playerid,rest);
			if (id==INVALID_PLAYER_ID) return 1;
			if (player_class[id]==-1) {
				SendClientMessage(playerid, COLOUR_PERSONAL, "Player not yet selected class.");
				return 1;
			}
			new text[256];
			format (text,sizeof text,"Class: %d   Team: %d",player_class[id],class_teams[player_class[id]]);
			SendClientMessage(playerid, COLOUR_PERSONAL, text);
			return 1;
		} else if (streq(cmd,"/tell")) {
			GameTextForAll(rest,4000,GAME_TEXT_STYLE_SMALL);
			return 1;
		}

	}

	return 0;
}



streq(str1[],str2[])
{
	if (strlen(str1)!=strlen(str2)) return 0;
	
	return strcmp(str1,str2,true)==0;
}

GetId(playerid, rest[])
{
	if (!IsNatural(rest)) {
		return GetIdFromName(playerid, rest);
	}
	new id = strval(rest);
	if (id<0 || id >=MAX_PLAYERS || !IsPlayerConnected(id)) {
		SendClientMessage(playerid, COLOUR_PERSONAL, "Invalid id");
		return INVALID_PLAYER_ID;
	}
	return id;
}


GetIdFromName(playerid,victimname[])
{
	new victimid;
	new num_matches = 0;
	for (new i=0 ; i<MAX_PLAYERS ; i++) {
		if (IsPlayerConnected(i)) {
			new text[MAX_PLAYER_NAME];
			GetPlayerName(i,text,MAX_PLAYER_NAME);
			if (strfind(text,victimname,true)>=0) {
				victimid = i;
				num_matches++;
			}
		}
	}
	new text[100];
	switch (num_matches) {
		case 0: {
			format(text,sizeof text,"No match for \"%s\".",victimname);
			SendClientMessage(playerid,COLOUR_PERSONAL,text);
		}
		case 1: return victimid;
		default: {
			format(text,sizeof text,"Too many (%d) matches for \"%s\".",num_matches,victimname);
			SendClientMessage(playerid,COLOUR_PERSONAL,text);
		}
	}
	return INVALID_PLAYER_ID;
}


new player_ispassenger[MAX_PLAYERS];

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	player_ispassenger[playerid] = 1;
	if (vehicle_modelid[vehicleid] == HYDRA || vehicle_modelid[vehicleid] == SEASPARROW) {
		SetPlayerWorldBounds(playerid,HYDRA_BOUNDARY_MAX_X,HYDRA_BOUNDARY_MIN_X,HYDRA_BOUNDARY_MAX_Y,HYDRA_BOUNDARY_MIN_Y);
	}

	return 1;
}

public RegularTask()
{
	for (new i=0 ; i<MAX_PLAYERS ; i++) {
		if (IsPlayerConnected(i) && player_class[i]!=-1) {
			if (IsPlayerInAnyVehicle(i)) {
				new vehicleid = GetPlayerVehicleID(i);
				if (vehicle_modelid[vehicleid] == HYDRA || vehicle_modelid[vehicleid] == SEASPARROW) {
					if (class_teams[player_class[i]]!=TEAM_BODYGUARD &&
						class_teams[player_class[i]]!=TEAM_TERRORIST) {

						GameTextForPlayer(i,"~y~You are ~r~not qualified~n~ ~y~to use this vehicle!",3000,4);

						RemovePlayerFromVehicle(i);
					}
				}
			}
			if (player_watching[i]!=-1)
				SetPlayerPosAtPlayer(i,player_watching[i]);
		}
 	}
 
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	player_ispassenger[playerid] = 0;
	SetPlayerWorldBounds(playerid,GAME_BOUNDARY_MAX_X,GAME_BOUNDARY_MIN_X,GAME_BOUNDARY_MAX_Y,GAME_BOUNDARY_MIN_Y);
	return 1;
}


TellPlayerIntel(playerid)
{
	new pm = GetPlayerFromClass(class_primeminister);
	if (pm==-1) {
		SendClientMessage(playerid,COLOUR_PERSONAL,"Prime Minister is not connected.");
		return;
	}

	new text[256];
	LocationToText(CalcLocation(pm),text);
	
	SendClientMessage(playerid,COLOUR_PERSONAL,text);
	    
}

LocationToText(location, text[], size=sizeof text)
{
	new src[256];
	switch (location) {
	    case -1:src = "Prime Minister is out of bounds (indoors).";
	    case -2:src = "Prime Minister is in the Airport.";
	    case 0:	src = "Prime Minister is in North West Los Santos.";
	    case 1:	src = "Prime Minister is in North Los Santos.";
	    case 2:	src = "Prime Minister is in North East Los Santos.";
    	case 3:	src = "Prime Minister is in West Los Santos.";
	    case 4:	src = "Prime Minister is in Central Los Santos.";
	    case 5:	src = "Prime Minister is in East Los Santos.";
	    case 6:	src = "Prime Minister is in South West Los Santos.";
	    case 7:	src = "Prime Minister is in South Los Santos.";
	    case 8:	src = "Prime Minister is in South East Los Santos.";
	}
	memcpy(text,src,0,sizeof src,size);
}

CalcLocation(playerid)
{

	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);

	if (x<GAME_BOUNDARY_MIN_X ||
        x>GAME_BOUNDARY_MAX_X ||
        y<GAME_BOUNDARY_MIN_Y ||
        y>GAME_BOUNDARY_MAX_Y) {
        return -1;
	}

	if (x<2058.2620 &&
	    x>1848.9244 &&
	    z<55 &&
	    y<-2176.9812 &&
	    y>=-2388.2996) {

	    return -2;

	} else if (z>=13 &&
	           z<50 &&
	           x<2123.8440 &&
	           x>1379.7856 &&
	           y>-2633.9453 &&
	           y<-2388.2996 &&
	           (x>1464.2719 || y<-2403.9871)) {
		return -2;
	}

	new loc = 0;

	if (y<-1930) {
	    loc += 6;
	} else if (y<-1390) {
		loc += 3;
	} else {
	    loc += 0;
	}

	if (x<1130) {
	    loc += 0;
	} else if (x<1835) {
		loc += 1;
	} else {
		loc += 2;
	}


/*    N
    0 1 2
  W 3 4 5 E
    6 7 8
	  S
*/

	return loc;
}


// thanks to Y_Less for this, via http://forum.sa-mp.com/index.php?topic=638.0
// i shortened it a bit though...

parse_command(cmd_text[], cmd[256], text[256])
{
	new index = strfind(cmd_text," ");

	if (index==-1) {
		memcpy(cmd,cmd_text,0,256);
		text = "";
		return 0;
	}
	
	strmid(cmd,cmd_text,0,index);
 	strmid(text, cmd_text, index + 1, strlen(cmd_text));

	new pars = 0;
	
	for (new i=0 ; cmd_text[i] != EOS ; i++)
		if (cmd_text[i]==' ') pars++;
	
	return pars;
}







new vote_timer;
new vote_victim = -1;
new vote_initiator = -1;
new votes_left = 0;


new player_already_voted[MAX_PLAYERS];


InitiateVote(playerid,victimid)
{

	if (victimid<0 || victimid >= MAX_PLAYER_NAME) {
		SendClientMessage(playerid,COLOUR_PERSONAL,"Invalid player id.");
		return;
	}

	if (!IsPlayerConnected(victimid)) {
		SendClientMessage(playerid,COLOUR_PERSONAL,"Nonexistant player id.");
		return;
	}
	
	if (vote_victim==-1) {
		for (new i=0 ; i<MAX_PLAYERS ; i++) {
			player_already_voted[i] = 0;
		}
		vote_victim = victimid;
		vote_initiator = playerid;
		votes_left = 1+(NumPlayersConnected()*6) / 10;
		if (votes_left==NumPlayersConnected())
			votes_left--;
		if (votes_left==0)
			votes_left++;
		vote_timer = SetTimer("ResetVote",90000,0);
		PrintVoteInfo();
	} else {
		SendClientMessage(playerid,COLOUR_PERSONAL,"A vote is already in progress.");
	}
}

NumPlayersConnected()
{
	new total = 0;
	for (new i=0 ; i<MAX_PLAYERS ; i++) {
		if (IsPlayerConnected(i)) total++;
	}
	return total;
}

AddVote(playerid)
{
	if (vote_victim==-1) {
		SendClientMessage(playerid,COLOUR_PERSONAL,"There is no vote currently.");
		return;
	}

	if (!player_already_voted[playerid]) {
		player_already_voted[playerid] = 1;
		votes_left--;
		SendClientMessage(playerid,COLOUR_PERSONAL,"Vote cast.");
		PrintVoteInfo();
		if (votes_left<=0) {
			Ban(vote_victim);
			vote_victim = -1; // reset for another go
			KillTimer(vote_timer);
		}
	} else {
		SendClientMessage(playerid,COLOUR_PERSONAL,"You have already voted.");
	}
}

PrintVoteInfo()
{
	if (vote_victim==-1) {
		printf("PrintVoteInf(): vote_victim==-1 :(");
		return;  //fail gracefully
	}
	new name[MAX_PLAYER_NAME];
	GetPlayerName(vote_victim,name,MAX_PLAYER_NAME);
	new info[200];
	if (votes_left)
		format(info,sizeof info,"~r~ban %s (id %d)?~n~~y~need %d votes~n~/vote if you agree",name,vote_victim,votes_left);
	else
		format(info,sizeof info,"%s (id %d) voted off the server!",name,vote_victim);
	GameTextForAll(info,4000,4);
}


public ResetVote()
{
	if (vote_victim!=-1) {
		GameTextForAll("Poll closed, not enough votes.",3000,4);
		vote_victim = -1;
	}
}


public ResetVoteOnEndGame()
{
	KillTimer(vote_timer);
}


CancelVote(playerid)
{
	if (vote_victim!=-1 && playerid==vote_initiator) {
		GameTextForAll("Poll closed by initiator.",3000,4);
		vote_victim = -1;
	} else if (vote_victim!=-1 && IsPlayerAdmin(playerid)) {
		GameTextForAll("Poll closed by admin.",3000,4);
		vote_victim = -1;
	} else {
		SendClientMessage(playerid,COLOUR_PERSONAL,"No vote, or you are not the initiator.");
	}
}



/* thanks to "Mike", from http://forum.sa-mp.com/index.php?topic=638.0 */
IsNatural(const string[])
{
	new l=strlen(string);
	
	if (l==0) return 0;
	
	for (new i=0 ; i<l ; i++)
		if (string[i] > '9' || string[i] < '0') return 0;

	return 1;
}

// similar idea
IsFloat(const string[])
{
	new l=strlen(string);

	if (l==0) return 0;
	
	new pointctr = 0;

	for (new i=0 ; i<l ; i++) {
		if (string[i]!='-' && string[i]!='.' && (string[i]>'9' || string[i]<'0')) return 0;
		if (string[i]=='-' && i!=0) return 0;
		if (string[i]=='.' && ++pointctr>1) return 0;
	}

	return 1;
}

