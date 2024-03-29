
PunschrulleDB = {
	["DBVer"] = 13,
	["Profiles"] = {
		["Custom0"] = {
			["Name"] = "knubbe",
			["MuteWelcomeMessage"] = false,
			["Entities"] = {
				["Mirror"] = {
					["TextRight"] = {
						["a"] = 1,
						["FontSize"] = 10,
						["Point"] = "RIGHT",
						["b"] = 1,
						["g"] = 1,
						["sr"] = 0,
						["r"] = 1,
						["sg"] = 0,
						["Y"] = 0,
						["Font"] = "Vixar",
						["sa"] = 1,
						["sb"] = 0,
						["FontShadowX"] = 0.8,
						["rPoint"] = "RIGHT",
						["X"] = -2,
						["FontShadowY"] = -0.8,
					},
					["ShowTextureOnFullBar"] = false,
					["Border"] = {
						["a"] = 1,
						["OnTop"] = true,
						["b"] = 0,
						["g"] = 0,
						["Show"] = false,
						["Padding"] = 4,
						["r"] = 0,
						["Size"] = 16,
					},
					["Fade"] = {
						["Time"] = 0.9,
						["HoldTime"] = 0,
						["Enable"] = true,
					},
					["ShowIcon"] = true,
					["Anchor"] = {
						["Y"] = 1,
						["X"] = 0,
						["Point"] = "BOTTOMRIGHT",
						["rPoint"] = "TOPRIGHT",
						["rTo"] = "Castbar",
					},
					["Bg"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
					["Texture"] = "Minimalist",
					["TextLeft"] = {
						["a"] = 1,
						["FontSize"] = 11,
						["Point"] = "LEFT",
						["b"] = 1,
						["g"] = 1,
						["sr"] = 0,
						["r"] = 1,
						["sg"] = 0,
						["Y"] = 0,
						["Font"] = "Vixar",
						["sa"] = 1,
						["sb"] = 0,
						["FontShadowX"] = 0.8,
						["rPoint"] = "LEFT",
						["X"] = 2,
						["FontShadowY"] = 0,
					},
					["Spark"] = {
						["a"] = 1,
						["b"] = 0.34,
						["Enable"] = true,
						["g"] = 0.23,
						["Width"] = 15,
						["Height"] = 22,
						["r"] = 0.13,
					},
					["Width"] = 170,
					["IconPadding"] = 1,
					["StretchTexture"] = false,
					["Decimals"] = 1,
					["GrowUp"] = true,
					["Events"] = {
						["BOOT"] = {
							["a"] = 1,
							["b"] = 0,
							["enable"] = true,
							["g"] = 0,
							["r"] = 1,
							["icon"] = "Interface\\Icons\\INV_Misc_Rune_01",
							["label"] = "Instance Boot",
						},
						["BREATH"] = {
							["a"] = 1,
							["b"] = 1,
							["enable"] = true,
							["g"] = 0.5,
							["r"] = 0,
							["icon"] = "Interface\\Icons\\Spell_Shadow_DemonBreath",
							["label"] = "Breath",
						},
						["CAMP"] = {
							["a"] = 1,
							["b"] = 0,
							["enable"] = true,
							["g"] = 0.7,
							["r"] = 1,
							["icon"] = "Interface\\Icons\\Spell_Magic_PolymorphChicken",
							["label"] = "Logout",
						},
						["FEIGNDEATH"] = {
							["a"] = 1,
							["b"] = 0,
							["enable"] = true,
							["g"] = 0.7,
							["r"] = 1,
							["icon"] = "Interface\\Icons\\Ability_Rogue_FeignDeath",
							["label"] = "Feign Death",
						},
						["EXHAUSTION"] = {
							["a"] = 1,
							["b"] = 0,
							["enable"] = true,
							["g"] = 0.9,
							["r"] = 1,
							["icon"] = "Interface\\Icons\\Ability_Suffocate",
							["label"] = "Exhaustion",
						},
						["SUMMON"] = {
							["a"] = 1,
							["b"] = 1,
							["enable"] = true,
							["g"] = 0.3,
							["r"] = 1,
							["icon"] = "Interface\\Icons\\Spell_Shadow_Twilight",
							["label"] = "Summon",
						},
						["GAMESTART"] = {
							["a"] = 1,
							["b"] = 0,
							["enable"] = true,
							["g"] = 1,
							["r"] = 0,
							["icon"] = "Interface\\Icons\\Ability_DualWield",
							["label"] = "Game Start",
						},
						["QUIT"] = {
							["a"] = 1,
							["b"] = 0,
							["enable"] = true,
							["g"] = 0.7,
							["r"] = 1,
							["icon"] = "Interface\\Icons\\Spell_Magic_PolymorphChicken",
							["label"] = "Quit Game",
						},
						["WSG_FLAGRESPAWN"] = {
							["a"] = 1,
							["b"] = 0,
							["enable"] = true,
							["g"] = 1,
							["r"] = 0,
							["icon"] = "Interface\\Icons\\Ability_DualWield",
							["label"] = "Flag respawn",
						},
					},
					["BorderEncompassIcon"] = false,
					["Height"] = 15,
					["Frame"] = {
						["a"] = 1,
						["Borderg"] = 1,
						["Bordera"] = 0,
						["r"] = 0,
						["Enable"] = true,
						["g"] = 0,
						["Thickness"] = 0.8,
						["InnerBorderSize"] = 0,
						["OuterBorderSize"] = 0,
						["Borderb"] = 1,
						["Borderr"] = 1,
						["b"] = 0,
					},
					["Padding"] = 1,
					["HideBlizzardBar"] = true,
				},
				["Castbar"] = {
					["CountUpOnChannel"] = false,
					["RankAsRoman"] = true,
					["Border"] = {
						["a"] = 1,
						["OnTop"] = true,
						["b"] = 0,
						["g"] = 0,
						["Padding"] = 4,
						["r"] = 0,
						["Size"] = 16,
					},
					["Fade"] = {
						["SuccessHoldTime"] = 0,
						["Enable"] = true,
						["Failure"] = {
							["a"] = 1,
							["r"] = 0.6,
							["g"] = 0.2,
							["b"] = 0.2,
						},
						["ShowLagWhileFading"] = true,
						["Time"] = 0.9,
						["Tolerance"] = 0.3,
						["PlayerInterruptAsFailure"] = true,
						["FailureHoldTime"] = 0,
						["Success"] = {
							["a"] = 1,
							["r"] = 0.2,
							["g"] = 0.6,
							["b"] = 0.2,
						},
						["OnChannel"] = false,
					},
					["ShowIcon"] = true,
					["Texture"] = "Armory",
					["TextLeft"] = {
						["a"] = 1,
						["FontSize"] = 12,
						["Point"] = "LEFT",
						["b"] = 1,
						["g"] = 1,
						["sr"] = 0,
						["r"] = 1,
						["sg"] = 0,
						["Y"] = 0,
						["Font"] = "Aldrich",
						["sa"] = 1,
						["sb"] = 0,
						["FontShadowX"] = 0.8,
						["rPoint"] = "LEFT",
						["X"] = 3,
						["FontShadowY"] = -0.8,
					},
					["Spark"] = {
						["a"] = 1,
						["b"] = 0.34,
						["Enable"] = 1,
						["g"] = 0.23,
						["Width"] = 15,
						["Height"] = 60,
						["r"] = 0.13,
					},
					["Width"] = 285,
					["BorderEncompassIcon"] = 1,
					["TextLag"] = {
						["a"] = 1,
						["FontSize"] = 9,
						["r"] = 1,
						["g"] = 1,
						["sa"] = 1,
						["sg"] = 0,
						["sr"] = 0,
						["sb"] = 0,
						["FontShadowX"] = 1,
						["b"] = 1,
						["Font"] = "",
						["FontShadowY"] = -1,
					},
					["Frame"] = {
						["a"] = 0.5,
						["Borderg"] = 1,
						["Bordera"] = 0,
						["r"] = 0,
						["Enable"] = 1,
						["g"] = 0,
						["Thickness"] = 0.8,
						["InnerBorderSize"] = 0,
						["OuterBorderSize"] = 0,
						["Borderb"] = 1,
						["Borderr"] = 1,
						["b"] = 0,
					},
					["ShowTextureOnFullBar"] = 1,
					["ShowAimedShot"] = true,
					["RankAsShort"] = true,
					["CountUpOnCast"] = true,
					["Anchor"] = {
						["Y"] = -228.0000188748782,
						["X"] = 0,
						["Point"] = "CENTER",
						["rPoint"] = "CENTER",
						["rTo"] = "",
					},
					["Bg"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
					["Fill"] = {
						["a"] = 1,
						["r"] = 0.8352941176470589,
						["g"] = 1,
						["b"] = 0.392156862745098,
					},
					["Decimals"] = 1,
					["TextRight"] = {
						["a"] = 1,
						["FontSize"] = 14,
						["Point"] = "RIGHT",
						["b"] = 1,
						["g"] = 1,
						["Spacing"] = 1,
						["sr"] = 0,
						["r"] = 1,
						["sg"] = 0,
						["Y"] = 0,
						["X"] = -3,
						["sa"] = 1,
						["sb"] = 0,
						["FontShadowX"] = 0.8,
						["rPoint"] = "RIGHT",
						["Font"] = "Vixar",
						["FontShadowY"] = -0.8,
					},
					["IconPadding"] = 1,
					["ShowLag"] = true,
					["ShowMultiShot"] = false,
					["FillChannel"] = {
						["a"] = 1,
						["r"] = 0.54,
						["g"] = 0.54,
						["b"] = 0.54,
					},
					["HideBlizzardBar"] = true,
					["Tick"] = {
						["a"] = 1,
						["r"] = 0,
						["Enable"] = 1,
						["g"] = 0,
						["Width"] = 3.2,
						["ShowLag"] = false,
						["BotAnchor"] = 0.15,
						["TopAnchor"] = 0,
						["b"] = 0,
					},
					["Height"] = 30,
					["Lag"] = {
						["a"] = 0.5,
						["r"] = 0.95,
						["g"] = 1,
						["b"] = 1,
					},
					["TextDelay"] = {
						["a"] = 0.6,
						["FontSize"] = 14,
						["Point"] = "RIGHT",
						["b"] = 0,
						["g"] = 0,
						["sr"] = 0,
						["r"] = 0.85,
						["sb"] = 0,
						["sa"] = 0,
						["Y"] = 0,
						["X"] = -20,
						["Font"] = "Vixar",
						["AnchorToDuration"] = true,
						["FontShadowX"] = 0.8,
						["rPoint"] = "LEFT",
						["sg"] = 0,
						["FontShadowY"] = -0.8,
					},
					["ChannelDelayToDuration"] = false,
				},
			},
		},
		["Default"] = {
			["Name"] = "Default",
			["MuteWelcomeMessage"] = false,
			["Entities"] = {
				["Mirror"] = {
					["TextRight"] = {
						["a"] = 1,
						["FontSize"] = 10,
						["Point"] = "RIGHT",
						["b"] = 1,
						["g"] = 1,
						["sr"] = 0,
						["r"] = 1,
						["sg"] = 0,
						["Y"] = 0,
						["Font"] = "Vixar",
						["sa"] = 1,
						["sb"] = 0,
						["FontShadowX"] = 0.8,
						["rPoint"] = "RIGHT",
						["X"] = -2,
						["FontShadowY"] = -0.8,
					},
					["ShowTextureOnFullBar"] = false,
					["Border"] = {
						["a"] = 1,
						["OnTop"] = true,
						["r"] = 0,
						["g"] = 0,
						["Show"] = false,
						["Padding"] = 4,
						["b"] = 0,
						["Size"] = 16,
					},
					["Fade"] = {
						["Time"] = 0.9,
						["Enable"] = true,
						["HoldTime"] = 0,
					},
					["AlwaysShow"] = false,
					["ShowIcon"] = true,
					["Anchor"] = {
						["Y"] = 1,
						["X"] = 0,
						["Point"] = "BOTTOMRIGHT",
						["rPoint"] = "TOPRIGHT",
						["rTo"] = "Castbar",
					},
					["Bg"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
					["Texture"] = "Minimalist",
					["TextLeft"] = {
						["a"] = 1,
						["FontSize"] = 10,
						["Point"] = "LEFT",
						["b"] = 1,
						["g"] = 1,
						["sr"] = 0,
						["r"] = 1,
						["sg"] = 0,
						["Y"] = 0,
						["Font"] = "Vixar",
						["sa"] = 1,
						["sb"] = 0,
						["FontShadowX"] = 0.8,
						["rPoint"] = "LEFT",
						["X"] = 2,
						["FontShadowY"] = -0.8,
					},
					["Spark"] = {
						["a"] = 1,
						["b"] = 0.34,
						["Enable"] = true,
						["g"] = 0.23,
						["Width"] = 15,
						["Height"] = 22,
						["r"] = 0.13,
					},
					["IconPadding"] = 1,
					["HideBlizzardBar"] = true,
					["StretchTexture"] = false,
					["Frame"] = {
						["a"] = 1,
						["Borderg"] = 1,
						["Bordera"] = 0,
						["b"] = 0,
						["Enable"] = true,
						["g"] = 0,
						["Thickness"] = 0.8,
						["r"] = 0,
						["Borderr"] = 1,
						["Borderb"] = 1,
						["OuterBorderSize"] = 0,
						["InnerBorderSize"] = 0,
					},
					["GrowUp"] = true,
					["Events"] = {
						["BOOT"] = {
							["a"] = 1,
							["b"] = 0,
							["enable"] = true,
							["g"] = 0,
							["r"] = 1,
							["icon"] = "Interface\\Icons\\INV_Misc_Rune_01",
							["label"] = "Instance Boot",
						},
						["BREATH"] = {
							["a"] = 1,
							["b"] = 1,
							["enable"] = true,
							["g"] = 0.5,
							["r"] = 0,
							["icon"] = "Interface\\Icons\\Spell_Shadow_DemonBreath",
							["label"] = "Breath",
						},
						["CAMP"] = {
							["a"] = 1,
							["b"] = 0,
							["enable"] = true,
							["g"] = 0.7,
							["r"] = 1,
							["icon"] = "Interface\\Icons\\Spell_Magic_PolymorphChicken",
							["label"] = "Logout",
						},
						["FEIGNDEATH"] = {
							["a"] = 1,
							["b"] = 0,
							["enable"] = true,
							["g"] = 0.7,
							["r"] = 1,
							["icon"] = "Interface\\Icons\\Ability_Rogue_FeignDeath",
							["label"] = "Feign Death",
						},
						["EXHAUSTION"] = {
							["a"] = 1,
							["b"] = 0,
							["enable"] = true,
							["g"] = 0.9,
							["r"] = 1,
							["icon"] = "Interface\\Icons\\Ability_Suffocate",
							["label"] = "Exhaustion",
						},
						["WSG_FLAGRESPAWN"] = {
							["a"] = 1,
							["b"] = 0,
							["enable"] = true,
							["g"] = 1,
							["r"] = 0,
							["icon"] = "Interface\\Icons\\Ability_DualWield",
							["label"] = "Flag respawn",
						},
						["GAMESTART"] = {
							["a"] = 1,
							["b"] = 0,
							["enable"] = true,
							["g"] = 1,
							["r"] = 0,
							["icon"] = "Interface\\Icons\\Ability_DualWield",
							["label"] = "Game Start",
						},
						["QUIT"] = {
							["a"] = 1,
							["b"] = 0,
							["enable"] = true,
							["g"] = 0.7,
							["r"] = 1,
							["icon"] = "Interface\\Icons\\Spell_Magic_PolymorphChicken",
							["label"] = "Quit Game",
						},
						["SUMMON"] = {
							["a"] = 1,
							["b"] = 1,
							["enable"] = true,
							["g"] = 0.3,
							["r"] = 1,
							["icon"] = "Interface\\Icons\\Spell_Shadow_Twilight",
							["label"] = "Summon",
						},
					},
					["BorderEncompassIcon"] = false,
					["Height"] = 11,
					["Padding"] = 1,
					["Decimals"] = 1,
					["Width"] = 170,
				},
				["Castbar"] = {
					["CountUpOnChannel"] = false,
					["TextRight"] = {
						["a"] = 1,
						["FontSize"] = 14,
						["Point"] = "RIGHT",
						["b"] = 1,
						["g"] = 1,
						["Spacing"] = 1,
						["sr"] = 0,
						["r"] = 1,
						["X"] = -3,
						["sa"] = 1,
						["Font"] = "Vixar",
						["Y"] = 0,
						["sb"] = 0,
						["FontShadowX"] = 0.8,
						["rPoint"] = "RIGHT",
						["sg"] = 0,
						["FontShadowY"] = -0.8,
					},
					["RankAsRoman"] = true,
					["Border"] = {
						["a"] = 1,
						["OnTop"] = true,
						["r"] = 0,
						["g"] = 0,
						["Show"] = false,
						["Padding"] = 4,
						["b"] = 0,
						["Size"] = 16,
					},
					["Fade"] = {
						["SuccessHoldTime"] = 0,
						["Enable"] = true,
						["Failure"] = {
							["a"] = 1,
							["r"] = 0.6,
							["g"] = 0.2,
							["b"] = 0.2,
						},
						["ShowLagWhileFading"] = true,
						["Time"] = 0.9,
						["Tolerance"] = 0.3,
						["PlayerInterruptAsFailure"] = true,
						["Success"] = {
							["a"] = 1,
							["r"] = 0.2,
							["g"] = 0.6,
							["b"] = 0.2,
						},
						["FailureHoldTime"] = 0,
						["OnChannel"] = false,
					},
					["AlwaysShow"] = false,
					["ShowIcon"] = true,
					["UpperCaseSpellName"] = false,
					["Texture"] = "Minimalist",
					["TextLeft"] = {
						["a"] = 1,
						["FontSize"] = 14,
						["Point"] = "LEFT",
						["b"] = 1,
						["g"] = 1,
						["sr"] = 0,
						["r"] = 1,
						["sg"] = 0,
						["Y"] = 0,
						["Font"] = "Vixar",
						["sa"] = 1,
						["sb"] = 0,
						["FontShadowX"] = 0.8,
						["rPoint"] = "LEFT",
						["X"] = 3,
						["FontShadowY"] = -0.8,
					},
					["Spark"] = {
						["a"] = 1,
						["b"] = 0.34,
						["Enable"] = true,
						["g"] = 0.23,
						["Width"] = 15,
						["Height"] = 60,
						["r"] = 0.13,
					},
					["StretchTexture"] = false,
					["BorderEncompassIcon"] = false,
					["TextLag"] = {
						["a"] = 1,
						["FontSize"] = 9,
						["r"] = 1,
						["g"] = 1,
						["sa"] = 1,
						["sg"] = 0,
						["FontShadowY"] = -1,
						["sb"] = 0,
						["FontShadowX"] = 1,
						["Font"] = "",
						["b"] = 1,
						["sr"] = 0,
					},
					["Frame"] = {
						["a"] = 1,
						["Borderg"] = 1,
						["Bordera"] = 0,
						["b"] = 0,
						["Enable"] = true,
						["g"] = 0,
						["Thickness"] = 0.8,
						["r"] = 0,
						["Borderr"] = 1,
						["Borderb"] = 1,
						["OuterBorderSize"] = 0,
						["InnerBorderSize"] = 0,
					},
					["ShowTextureOnFullBar"] = true,
					["ShowAimedShot"] = true,
					["RankAsShort"] = true,
					["CountUpOnCast"] = true,
					["Anchor"] = {
						["Y"] = -215.5,
						["X"] = -177,
						["Point"] = "TOPLEFT",
						["rPoint"] = "CENTER",
						["rTo"] = "",
					},
					["Bg"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
					["Fill"] = {
						["a"] = 1,
						["r"] = 0.54,
						["g"] = 0.54,
						["b"] = 0.54,
					},
					["Decimals"] = 1,
					["ChannelDelayToDuration"] = false,
					["TextDelay"] = {
						["a"] = 1,
						["FontSize"] = 14,
						["Point"] = "RIGHT",
						["b"] = 0,
						["g"] = 0,
						["sr"] = 0,
						["r"] = 0.85,
						["AnchorToDuration"] = true,
						["Y"] = 0,
						["sa"] = 0,
						["Font"] = "Vixar",
						["sg"] = 0,
						["sb"] = 0,
						["FontShadowX"] = 0.8,
						["rPoint"] = "LEFT",
						["X"] = -3,
						["FontShadowY"] = -0.8,
					},
					["IconPadding"] = 1,
					["Lag"] = {
						["a"] = 1,
						["r"] = 0.95,
						["g"] = 1,
						["b"] = 1,
					},
					["FillChannel"] = {
						["a"] = 1,
						["r"] = 0.54,
						["g"] = 0.54,
						["b"] = 0.54,
					},
					["HideBlizzardBar"] = true,
					["Tick"] = {
						["a"] = 1,
						["r"] = 0,
						["Enable"] = true,
						["g"] = 0,
						["Width"] = 3.2,
						["ShowLag"] = false,
						["BotAnchor"] = 0.15,
						["AsSolidColor"] = false,
						["TopAnchor"] = 0,
						["b"] = 0,
					},
					["ShowLag"] = true,
					["Height"] = 30,
					["ShowRank"] = false,
					["ShowMultiShot"] = false,
					["Width"] = 355,
				},
			},
		},
	},
}
