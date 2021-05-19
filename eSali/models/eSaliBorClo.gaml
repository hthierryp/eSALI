/**
* Name: Starling11
* Author: Ethan
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model Starling10

/* Insert your model definition here */

global torus: true {
	
	///// IMPORT DATA FILES
	file landcoverInput <- csv_file("../includes/Landcovers.csv",","); //landcover species  info spreadsheet
	file mapGrid<- csv_file("../includes/BorderClose.csv",","); //landcover type grid spreadsheet
	bool randomMap<- false;
	
	int rep<-1;
	
	////// SET SOME GLOBALS	
	int nbDoves<-30; //number of starlings when simulation starts
	int nbStarlings<-30;
	matrix gridData<-matrix(mapGrid); //matrix made from grid spreadsheet (mapgrid)

	geometry shape <- square(2000#m); //2000x2000m square map
	
	int numberEatingEvents<-1; //Number of fruits eaten per session

	int year; // Years elapsed
	int day; // Days elapsed
	int hour; // Hour of the day
	int min; //Min of the day
	float step <- 10#m; //defines 1 cycle as 1 hour

	/////// SCHEDULER
	reflex timestep{
		do update_date;
		ask Dove{		
			do dove_moving;
			do dove_pooping;
			if ((hour>=6) and (hour<20)){			
				do eating;
			}	
		}
		ask Starling{
			do starling_moving;
			do starling_pooping;
			if ((hour>=6) and (hour<20)){			
				do eating;
			}	
		}
		if cycle=52560{
			do update_values;
			do save_seeds;
			do save_map;
		}
	}
	
	///// INITIALIZATION
	init {
		year<-0; //start at 0 years passed
		day<-0; //set date to day 0
		hour<-0; //start at midnight
		min <- 0;

		do create_landcovers;
		do create_grid;		
		create Dove number:nbDoves;
		create Starling number: nbStarlings;	
		ask Bird{
			myCell<- any(Landscape overlapping(self));
		}	
	}
	//////////////////////////////
	
	
	///// ACTIONS
	
	/// UPDATE TIME PARAMETERS
	action update_date{
		min<-min+10;
		if min=60{
			min<-0;
			hour<-hour+1;
		}
		if hour=24{
			hour<-0;
			day<-day+1;
		}		
		if day=365{
			day<- 0;
			year<-year+1;
		}	
	}
	
	action create_landcovers{
		matrix landcoverMatrix<-matrix(landcoverInput); //creates matrix from landcover spreadsheet
		loop i from: 0 to:landcoverMatrix.rows-1{
			create Landcover{
				name<-landcoverMatrix[0,i];
				priorityStar<-float(landcoverMatrix[4,i]);
				priorityDove<-float(landcoverMatrix[5,i]);				
				myColor<-rgb(int(landcoverMatrix[1,i]),int(landcoverMatrix[2,i]),int(landcoverMatrix[3,i])); //landcover color
			}
		}
	}
	
	action create_grid{ //turn map spreadsheet into grid map
		if randomMap=false{
			ask Landscape{
				grid_value <- float(gridData[grid_x,grid_y]); //translates cells from map spreadsheet into cells in landcover grid
				cellCover<-Landcover[int(grid_value)];
				color <-cellCover.myColor;	//color of grid cell based on landcover
			}			
		}
		else{
			int nbNative <-144;
			ask Landscape[168]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[169]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[170]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[171]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[188]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[189]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[190]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[191]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[208]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[209]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[210]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[211]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[228]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[229]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[230]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			ask Landscape[231]{
				cellCover<-Landcover[0];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
			loop while: nbNative>0{
				ask any(Landscape where(each.rndAssigned=false)){
					bool test <- flip(1/384);
					if test{
						cellCover<-Landcover[2];
						rndAssigned<-true;
						color<-cellCover.myColor;
						nbNative<-nbNative-1;					
					}
				}				
			}
			ask Landscape where(each.rndAssigned=false){
				cellCover<-Landcover[1];
				rndAssigned<-true;
				color<-cellCover.myColor;
			}
		}
	}	
	

	action save_seeds{
		ask Landscape{
			save [name,cellCover,doveSeedsDeg,doveSeedsNat,starlingSeedsDeg,starlingSeedsNat,SeedsDeg,SeedsNat,totalSeeds] to:"../models/BorCloSim"+string(rep)+".csv" type:csv rewrite:false;
		}
	}
	action save_map{
		ask Landscape{
			save species_of(self) to:"BorCloSim"+string(rep)+".shp" type:shp attributes:["name"::name,'cellCover'::cellCover,'doveSeedsDeg'::doveSeedsDeg,'doveSeedsNat'::doveSeedsNat,'starSeedsDeg'::starlingSeedsDeg,'starSeedsNat'::starlingSeedsNat,'SeedsDeg'::SeedsDeg,'SeedsNat'::SeedsNat,'totalSeeds'::totalSeeds];
		}
	}
	action update_values{
		ask Landscape{
			SeedsNat<-starlingSeedsNat+doveSeedsNat;
			SeedsDeg<-starlingSeedsDeg+doveSeedsDeg;
			totalSeeds<-SeedsNat+SeedsDeg;
		}
	}
}

////////////// SPECIES SECTION

//Landscape grid
grid Landscape width:20 height:20 {
	Landcover cellCover; //type of landcover on a cell
	bool rndAssigned;
	int starlingSeedsNat;
	int starlingSeedsDeg;
	int doveSeedsNat;
	int doveSeedsDeg;
	int SeedsNat;
	int SeedsDeg;
	int totalSeeds;
}

grid DispersalMap width: 20 height:20{
	
}

// Landcover Species
species Landcover{
	string name; //name of landcover type
	float priorityStar; //habitat priority of landcover for starlings
	float priorityDove; //habitat priority of landcover for fruit doves
	rgb myColor; //color of landcover cells
}
	
//Bird  species
species Bird skills:[moving]{
	Landscape myCell;
	matrix stomachSeeds<-0 as_matrix({5,2});
	init {
		myCell<- any(Landscape overlapping self);
	}
	
	action eating {		
		ask Landscape overlapping(self){
			if cellCover=Landcover[2]{
				myself.stomachSeeds[0,0]<-1;
				myself.stomachSeeds[0,1]<-0;			
			}
			if cellCover=Landcover[1]{
				myself.stomachSeeds[0,0]<-0;
				myself.stomachSeeds[0,1]<-1;					
			}
			if cellCover=Landcover[0]{
				myself.stomachSeeds[0,0]<-0;
				myself.stomachSeeds[0,1]<-0;					
			}		
		}	
	}
}	


//fruit dove subspecies
species Dove parent:Bird{
	file dove_pic <- file("../includes/dovepic.png"); //picture of starling for aspect
	//starling visual
	aspect icon {
		draw dove_pic size: 50; //draw starling picture
	}
	//dove movement	
	action dove_moving {
		if ((hour>=6) and (hour<20)){	//between 6am and 9 pm-Day movement
			float distanceTarget <-(float(gamma_rnd(79.6984718,0.9071409)))#m;	
			list<Landscape> targetCells <- Landscape at_distance distanceTarget;
			float totProb <-0.0;
			bool going;
			ask targetCells{
				totProb<- totProb +self.cellCover.priorityDove;
			}
			int k<-0;
			float rndDraw <- rnd (1/1);
			float cumProb<-0.0;
			loop while: k<100{
				ask targetCells[k]{
					if rndDraw<(cumProb+(self.cellCover.priorityDove/totProb)){

						ask myself{
							do goto target: any_location_in(targetCells[k]) speed:distanceTarget#m;								
						}
						k<-100;
					}
					else{
						write rndDraw;
						write cumProb;			
						cumProb<-cumProb+(self.cellCover.priorityDove/totProb);
						k<-k+1;
					}
				}
			}
		}
		else if (hour=20){ //roost at night
			Landscape roostTarget <- any(Landscape where (each.cellCover=Landcover[0]));
			do goto target: any_location_in(roostTarget) speed:1000#m;		
		}
		myCell <- any(Landscape overlapping self);
	}
	
	action dove_pooping {
		//expel seeds and add to cell location
		ask Landscape overlapping(self){
			doveSeedsNat<-doveSeedsNat+int(myself.stomachSeeds[4,0]);
			doveSeedsDeg<-doveSeedsDeg+int(myself.stomachSeeds[4,1]);
		}
		stomachSeeds[4,0]<-stomachSeeds[3,0];
		stomachSeeds[4,1]<-stomachSeeds[3,1];		
		stomachSeeds[3,0]<-stomachSeeds[2,0];
		stomachSeeds[3,1]<-stomachSeeds[2,1];
		stomachSeeds[2,0]<-stomachSeeds[1,0];
		stomachSeeds[2,1]<-stomachSeeds[1,1];
		stomachSeeds[1,0]<-stomachSeeds[0,0];
		stomachSeeds[1,1]<-stomachSeeds[0,1];
		stomachSeeds[0,0]<-0;
		stomachSeeds[0,1]<-0;											
	}
}

//starling subspecies
species Starling parent:Bird{
	file starling_pic <- file("../includes/starlingpic.png"); //picture of starling for aspect
	//starling visual
	aspect icon {
		draw starling_pic size: 50; //draw starling picture
	}

	//starling movement
	action starling_moving{
		if ((hour>=6) and (hour<20)){	//between 6am and 9 pm-Day movement
			float distanceTarget <-(float(gamma_rnd(159.4168016,0.9474663)))#m;	
			list<Landscape> targetCells <- Landscape at_distance distanceTarget;
			float totProb <-0.0;
			bool going;
			ask targetCells{
				totProb<- totProb +self.cellCover.priorityStar;
			}
			int k<-0;
			float rndDraw <- rnd (1/1);
			float cumProb<-0.0;
			loop while: k<100{
				ask targetCells[k]{
					if rndDraw<(cumProb+(self.cellCover.priorityStar/totProb)){

						ask myself{
							do goto target: any_location_in(targetCells[k]) speed:distanceTarget#m;								
						}
						k<-100;
					}
					else{
						write rndDraw;
						write cumProb;			
						cumProb<-cumProb+(self.cellCover.priorityStar/totProb);
						k<-k+1;
					}
				}
			}
		}
		else if (hour=20){ //roost at night
			Landscape roostTarget <- any(Landscape where (each.cellCover=Landcover[0]));
			do goto target: any_location_in(roostTarget) speed:1000#m;		
		}
		myCell <- any(Landscape overlapping self);		
	}
	
	action starling_pooping{
		//expel seeds and add to cell location
		ask Landscape overlapping(self){
			starlingSeedsNat<-starlingSeedsNat+int(myself.stomachSeeds[3,0]);
			starlingSeedsDeg<-starlingSeedsDeg+int(myself.stomachSeeds[3,1]);
		}
		stomachSeeds[3,0]<-stomachSeeds[2,0];
		stomachSeeds[3,1]<-stomachSeeds[2,1];
		stomachSeeds[2,0]<-stomachSeeds[1,0];
		stomachSeeds[2,1]<-stomachSeeds[1,1];
		stomachSeeds[1,0]<-stomachSeeds[0,0];
		stomachSeeds[1,1]<-stomachSeeds[0,1];
		stomachSeeds[0,0]<-0;
		stomachSeeds[0,1]<-0;													
	}
}

//experiment
experiment ValidationCoding type:gui {
	
//	init{
//		create simulation with: [nbDoves::70, nbStarlings::30];
//	}
//	init{
//		create simulation with: [nbDoves::50, nbStarlings::50];
//	}
//	init{
//		create simulation with: [nbDoves::30, nbStarlings::70];
//	}
//	init{
//		create simulation with: [nbDoves::10, nbStarlings::90];
//	}

	output{
		monitor "Day of the Year" value:day refresh:every(cycle);		
		monitor "Hour of the Day" value:hour refresh:every(cycle);
		monitor "Minutes" value:min refresh:every(cycle);
		monitor "Year" value:year refresh:every(cycle);
		monitor "Population of Fruit Doves" value:length(Dove) refresh:every(cycle);	
		monitor "Population of Starlings" value:length(Starling) refresh:every(cycle);		
		monitor "Total Population of Birds" value:length(Dove+Starling) refresh:every(cycle);				
		display main_display refresh:every(cycle) background:#grey{
			grid Landscape lines:#black;			
			species Dove aspect:icon;
			species Starling aspect: icon;
		
		}
	}
}

experiment Batch type:batch repeat: 1 keep_seed:false until:(year=1 and day=1){
	parameter 'Repetition' var:rep among:[1,2,3,4,5,6,7,8,9,10];
}

