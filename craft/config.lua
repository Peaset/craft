Config = {}

Config.Range = 2
Config.Repair = true
Config.NPCEnable = true 
Config.NPC = {
	{1175.467,-1493.33,46.434,false,125.0,0xB3F3EE34,"s_m_y_blackops_01","mini@strip_club@idles@bouncer@base","base","all"},  --Parçaçı Peacer
	{-168.880,6144.642,41.637,false,125.0,0xB3F3EE34,"s_m_y_blackops_01","mini@strip_club@idles@bouncer@base","base","all"},  --Tamirci
}

Config.RepairZones = {
	[1] = {
		coord = {x = -168.880,y = 6144.64,z = 41.637},
		job = 'all',
	},
}

Config.Places = {
	[1] = {
		coord = {x = 1175.467,y = -1493.33,z = 46.434},
		title = 'Parcaci',
		job = 'all',
		Items = {
			[1] = {
				label = 'Ap Pistol',
				name = 'WEAPON_APPISTOL',
				count = 1,
				requ = {
					[1] = {name = 'guntrigger',count = 1},
					[2] = {name = 'gunbow',count = 1},
					[3] = {name = 'gunbody',count = 1},
					[4] = {name = 'gunbarrel',count = 1},
				},

			},
		}
	},
}