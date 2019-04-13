Config = {}

Config.SyncAnimations = {
	{
		name = 'synced',
		label = 'Synkade animationer',
		items = {
			{label = 'Gangsterhälsa på närmsta spelare', data = {lib = 'mp_ped_interaction', anim1 = 'hugs_guy_b', anim2 = 'hugs_guy_a', distans = 1.15, distans2 = 0.0, height = 0.0, spin = 180.0}},
			{label = 'Krama närmsta spelare', data = {lib = 'mp_ped_interaction', anim1 = 'kisses_guy_b', anim2 = 'kisses_guy_b', distans = 1.10, distans2 = -0.1, height = 0.0, spin = 180.0}},
			{label = 'Kyss närmsta spelare', data = {lib = 'mp_ped_interaction', anim1 = 'kisses_guy_a', anim2 = 'kisses_guy_a', distans = 1.15, distans2 = 0.0, height = 0.0, spin = 180.0}},
			{label = 'Skaka hand med närmsta spelare', data = {lib = 'mp_common', anim1 = 'givetake1_a', anim2 = 'givetake1_a', distans = 0.8, distans2 = 0.05, height = 0.0, spin = 180.0}},
			{label = 'Gör highfive med närmsta spelare', data = {lib = 'mp_ped_interaction', anim1 = 'highfive_guy_a', anim2 = 'highfive_guy_b', distans = 1.2, distans2 = -0.3, height = 0.0, spin = 180.0}},
		}
	}
}

Config.Animations = {

	{
		name  = 'festives',
		label = 'Festliga',
		items = {
			{label = "Rök en cigarett", type = "scenario", data = {anim = "WORLD_HUMAN_SMOKING"}},
			{label = "Spela musik", type = "scenario", data = {anim = "WORLD_HUMAN_MUSICIAN"}},
			{label = "DJ", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@dj", anim = "dj"}},
			{label = "Drick en öl", type = "scenario", data = {anim = "WORLD_HUMAN_DRINKING"}},
			{label = "Party", type = "scenario", data = {anim = "WORLD_HUMAN_PARTYING"}},
			{label = "Luftgitarr", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@air_guitar", anim = "air_guitar"}},
			{label = "Jucka", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging"}},
			{label = "Rock'n'roll", type = "anim", data = {lib = "mp_player_int_upperrock", anim = "mp_player_int_rock"}},
			{label = "Fylld på platsen", type = "anim", data = {lib = "amb@world_human_bum_standing@drunk@idle_a", anim = "idle_a"}},
			{label = "Spy", type = "anim", data = {lib = "oddjobs@taxi@tie", anim = "vomit_outside"}},
		}
	},
	
	{
		name = 'dance',
		label = 'Danser',
		items = {
		{label = "Dansa 1", type = "anim", data = {lib = "misschinese2_crystalmazemcs1_cs", anim = "dance_loop_tao"}},
		{label = "Dansa 2", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_3@monologue_3a", anim = "mnt_dnc_buttwag"}},
		{label = "Dansa 3", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_4@monologue_4a", anim = "mnt_dnc_verse"}},
		{label = "Dansa 4", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_2@monologue_2a", anim = "mnt_dnc_angel"}},
		{label = "Dansa 5", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_1@monologue_1a", anim = "mtn_dnc_if_you_want_to_get_to_heaven"}},
		{label = "Dansa 6", type = "anim", data = {lib = "special_ped@mountain_dancer@base", anim = "base"}},
		{label = "Kort dans 1", type = "anim", data = {lib = "move_clown@p_m_two_idles@", anim = "fidget_short_dance"}},
		{label = "Kort dans 2", type = "anim", data = {lib = "move_clown@p_m_zero_idles@", anim = "fidget_short_dance"}},
		{label = "Dansa i bilen", type = "anim", data = {lib = "misschinese1crazydance", anim = "crazy_dance_base"}},
		{label = "Freakout", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@freakout", anim = "freakout"}},
		{label = "Jazz hands", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@jazz_hands", anim = "jazz_hands"}},

		}
	},
	
	{
		name  = 'greetings',
		label = 'Hälsningar',
		items = {
			{label = "Hälsa", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_hello"}},
			{label = "Skaka hand", type = "anim", data = {lib = "mp_common", anim = "givetake1_a"}},
			{label = "Skaka hand 2", type = "anim", data = {lib = "mp_ped_interaction", anim = "handshake_guy_a"}},
			{label = "Gangsterhälsning", type = "anim", data = {lib = "mp_ped_interaction", anim = "hugs_guy_a"}},
			{label = "Militärhälsning", type = "anim", data = {lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute"}},
		}
	},
	
		{
		name  = 'humors',
		label = 'Humör',
		items = {
			{label = "Applådera", type = "scenario", data = {anim = "WORLD_HUMAN_CHEERING"}},
			{label = "Tumme upp", type = "anim", data = {lib = "mp_action", anim = "thanks_male_06"}},
			{label = "Krama", type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_a"}},
			{label = "Ge fingret", type = "anim", data = {lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter"}},
			{label = "Runka", type = "anim", data = {lib = "mp_player_int_upperwank", anim = "mp_player_int_wank_01"}},
		}
	},
	
	
	{
		name  = 'sports',
		label = 'Sportliga',
		items = {
			{label = "Flexa muskler", type = "anim", data = {lib = "amb@world_human_muscle_flex@arms_at_side@base", anim = "base"}},
			{label = "Viktstång", type = "anim", data = {lib = "amb@world_human_muscle_free_weights@male@barbell@base", anim = "base"}},
			{label = "Armhävningar", type = "anim", data = {lib = "amb@world_human_push_ups@male@base", anim = "base"}},
			{label = "Gör situps", type = "anim", data = {lib = "amb@world_human_sit_ups@male@base", anim = "base"}},
			{label = "Yoga", type = "anim", data = {lib = "amb@world_human_yoga@male@base", anim = "base_a"}},
		}
	},
	
	{
		name  = 'work',
		label = 'Jobb',
		items = {
			{label = "Kriminell: händerna bakom huvudet", type = "anim", data = {lib = "random@arrests@busted", anim = "idle_c"}},
			{label = "Polis utreda", type = "anim", data = {lib = "amb@code_human_police_investigate@idle_b", anim = "idle_f"}},
			{label = "Polis: prata på radion", type = "anim", data = {lib = "random@arrests", anim = "generic_radio_chatter"}},
			{label = "Polis: trafik", type = "scenario", data = {anim = "WORLD_HUMAN_CAR_PARK_ATTENDANT"}},
			{label = "Polis: kikare", type = "scenario", data = {anim = "WORLD_HUMAN_BINOCULARS"}},
			{label = "Jordbruk: skörd", type = "scenario", data = {anim = "world_human_gardener_plant"}},
			{label = "Mekaniker: reparera motorn", type = "anim", data = {lib = "mini@repair", anim = "fixing_a_ped"}},
			{label = "Läkare: observera", type = "scenario", data = {anim = "CODE_HUMAN_MEDIC_KNEEL"}},
			{label = "Taxi: prata med kunden", type = "anim", data = {lib = "oddjobs@taxi@driver", anim = "leanover_idle"}},
			{label = "Taxi: ge räkning", type = "anim", data = {lib = "oddjobs@taxi@cyi", anim = "std_hand_off_ps_passenger"}},
			{label = "Livsmedel: ge handla", type = "anim", data = {lib = "mp_am_hold_up", anim = "purchase_beerbox_shopkeeper"}},
			{label = "Bartender: tjäna en shot", type = "anim", data = {lib = "mini@drinking", anim = "shots_barman_b"}},
			{label = "Reporter: Ta en bild", type = "scenario", data = {anim = "WORLD_HUMAN_PAPARAZZI"}},
			{label = "Ta noteringar", type = "scenario", data = {anim = "WORLD_HUMAN_CLIPBOARD"}},
			{label = "Snickare: hamra", type = "scenario", data = {anim = "WORLD_HUMAN_HAMMERING"}},
			{label = "Luffare: tigg pengagr", type = "scenario", data = {anim = "WORLD_HUMAN_BUM_FREEWAY"}},
			{label = "Statyn", type = "scenario", data = {anim = "WORLD_HUMAN_HUMAN_STATUE"}},
			{label = "Vakt: bouncer", type = "anim", data = {lib = "mini@strip_club@idles@bouncer@base", anim = "base"}},
		}
	},

	{
		name  = 'misc',
		label = 'Olika',
		items = {
			{label = "Drick en kaffe", type = "anim", data = {lib = "amb@world_human_aa_coffee@idle_a", anim = "idle_a"}},
			{label = "Sitta", type = "anim", data = {lib = "anim@heists@prison_heistunfinished_biztarget_idle", anim = "target_idle"}},
			{label = "Luta dig", type = "scenario", data = {anim = "world_human_leaning"}},
			{label = "Ligg på ryggen", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE_BACK"}},
			{label = "Ligg på magen", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE"}},
			{label = "Tvätta fönster", type = "scenario", data = {anim = "world_human_maid_clean"}},
			{label = "Grilla", type = "scenario", data = {anim = "PROP_HUMAN_BBQ"}},
			{label = "Ta en selfie", type = "scenario", data = {anim = "world_human_tourist_mobile"}},
			{label = "Lyssna på en dörr", type = "anim", data = {lib = "mini@safe_cracking", anim = "idle_base"}}, 
		}
	},
	
	{
		name = 'gestikulera',
		label = 'Gestikulera',
		items = {
			{label = "Peka", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_point"}},
			{label = "Kom hit", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_come_here_soft"}}, 
			{label = "Kom an", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_bring_it_on"}},
			{label = "Till mig", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_me"}},
			{label = "Jag visste det, skit", type = "anim", data = {lib = "anim@am_hold_up@male", anim = "shoplift_high"}},
			{label = "Facepalm", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm"}},
			{label = "Lugna ner ", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_easy_now"}},
			{label = "Vad gjorde jag?", type = "anim", data = {lib = "oddjobs@assassinate@multi@", anim = "react_big_variations_a"}},
			{label = "Att vara rädd", type = "anim", data = {lib = "amb@code_human_cower_stand@male@react_cowering", anim = "base_right"}},
			{label = "Slåss?", type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e"}},
			{label = "Det är inte möjligt!", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_damn"}},

		}
	},
	
	{
		name = 'casual',
		label = 'Vanliga',
		items = {
		{label = "Bouncer", type = "anim", data = {lib = "mini@strip_club@idles@bouncer@base", anim = "base"}},
		{label = "Armarna i kors", type = "anim", data = {lib = "amb@world_human_hang_out_street@female_arms_crossed@base", anim = "base"}},
		{label = "Händerna på bältet", type = "anim", data = {lib = "amb@world_human_cop_idles@male@base", anim = "base"}},
		{label = "Luta dig mot en vägg", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@legs_crossed@idle_a", anim = "idle_a"}},
		{label = "Luta dig mot ett räcke", type = "scenario", data = {anim = "prop_human_bum_shopping_cart"}},

		}
	},
	
	{
		name  = 'attitudem',
		label = 'Gångstil',
		items = {
			{label = "Självsäker M", type = "attitude", data = {lib = "move_m@confident", anim = "move_m@confident"}},
			{label = "Självsäker K", type = "attitude", data = {lib = "move_f@heels@c", anim = "move_f@heels@c"}},
			{label = "Deprimerad M", type = "attitude", data = {lib = "move_m@depressed@a", anim = "move_m@depressed@a"}},
			{label = "Deprimerad K", type = "attitude", data = {lib = "move_f@depressed@a", anim = "move_f@depressed@a"}},
			{label = "Business", type = "attitude", data = {lib = "move_m@business@a", anim = "move_m@business@a"}},
			{label = "Modig", type = "attitude", data = {lib = "move_m@brave@a", anim = "move_m@brave@a"}},
			{label = "Nonchalant", type = "attitude", data = {lib = "move_m@casual@a", anim = "move_m@casual@a"}},
			{label = "Fet", type = "attitude", data = {lib = "move_m@fat@a", anim = "move_m@fat@a"}},
			{label = "Hipster", type = "attitude", data = {lib = "move_m@hipster@a", anim = "move_m@hipster@a"}},
			{label = "Skadad", type = "attitude", data = {lib = "move_m@injured", anim = "move_m@injured"}},
			{label = "Bråttom", type = "attitude", data = {lib = "move_m@hurry@a", anim = "move_m@hurry@a"}},
			{label = "Hemlös", type = "attitude", data = {lib = "move_m@hobo@a", anim = "move_m@hobo@a"}},
			{label = "Ledsen", type = "attitude", data = {lib = "move_m@sad@a", anim = "move_m@sad@a"}},
			{label = "Muskler", type = "attitude", data = {lib = "move_m@muscle@a", anim = "move_m@muscle@a"}},
			{label = "Chockad", type = "attitude", data = {lib = "move_m@shocked@a", anim = "move_m@shocked@a"}},
			{label = "Shadyped", type = "attitude", data = {lib = "move_m@shadyped@a", anim = "move_m@shadyped@a"}},
			{label = "Surrande", type = "attitude", data = {lib = "move_m@buzzed", anim = "move_m@buzzed"}},
			{label = "Pressad", type = "attitude", data = {lib = "move_m@hurry_butch@a", anim = "move_m@hurry_butch@a"}},
			{label = "Pengar", type = "attitude", data = {lib = "move_m@money", anim = "move_m@money"}},
			{label = "Snabb", type = "attitude", data = {lib = "move_m@quick", anim = "move_m@quick"}},
			{label = "Manätare", type = "attitude", data = {lib = "move_f@maneater", anim = "move_f@maneater"}},
			{label = "Oförskämd", type = "attitude", data = {lib = "move_f@sassy", anim = "move_f@sassy"}},	
			{label = "Arrogant", type = "attitude", data = {lib = "move_f@arrogant@a", anim = "move_f@arrogant@a"}},
		}
	},
	
	{
		name  = 'porn',
		label = '18+',
		items = {
			{label = "Ta emot blowjob", type = "anim", data = {lib = "oddjobs@towing", anim = "m_blow_job_loop"}},
			{label = "Ge blowjob", type = "anim", data = {lib = "oddjobs@towing", anim = "f_blow_job_loop"}},
			{label = "Chaufför: Sex i bilen", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_player"}},
			{label = "Passagerare: Sex i bilen", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_female"}},
			{label = "Klia dig på pungen", type = "anim", data = {lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch"}},
			{label = "Stå sexigt 1", type = "anim", data = {lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02"}},
			{label = "Stå sexigt 2", type = "scenario", data = {anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"}},
			{label = "Visa brösten", type = "anim", data = {lib = "mini@strip_club@backroom@", anim = "stripper_b_backroom_idle_b"}},
			{label = "Dansa sexigt 1", type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f"}},
			{label = "Dansa sexigt 2", type = "anim", data = {lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2"}},
			{label = "Dansa sexigt 3", type = "anim", data = {lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3"}},
		}
	}
}
