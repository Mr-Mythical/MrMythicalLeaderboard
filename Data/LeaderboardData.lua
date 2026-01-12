local MrMythicalLeaderboardData = {
  lastUpdated = 1768219394,
  dungeons = {
    ["arakara-city-of-echoes"] = {
      name = "Ara-Kara, City of Echoes",
      runs = {
        {
          rank = 1,
          score = 518.8,
          level = 22,
          time = 1619606,
          keystoneTime = 1800999,
          chests = 1,
          completedAt = "2026-01-11T13:00:38.000Z",
          roster = {
            {
              name = "뿌지직뿌지직",
              class = "Warrior",
              spec = "Protection",
              realm = "Azshara",
              level = 80,
            },
            {
              name = "Tapethree",
              class = "Druid",
              spec = "Restoration",
              realm = "Azshara",
              level = 80,
            },
            {
              name = "마뎀싸개",
              class = "Demon Hunter",
              spec = "Havoc",
              realm = "Azshara",
              level = 80,
            },
            {
              name = "삽삽님",
              class = "Death Knight",
              spec = "Frost",
              realm = "Azshara",
              level = 80,
            },
            {
              name = "캐주얼중독자",
              class = "Hunter",
              spec = "Beast Mastery",
              realm = "Azshara",
              level = 80,
            },
          },
        },
      },
    },
    ["tazavesh-soleahs-gambit"] = {
      name = "Tazavesh: So'leah's Gambit",
      runs = {
        {
          rank = 1,
          score = 534.2,
          level = 23,
          time = 1601084,
          keystoneTime = 1800999,
          chests = 1,
          completedAt = "2025-12-22T18:57:48.000Z",
          roster = {
            {
              name = "Roiiben",
              class = "Druid",
              spec = "Restoration",
              realm = "Blackhand",
              level = 80,
            },
            {
              name = "Cazualaddict",
              class = "Hunter",
              spec = "Beast Mastery",
              realm = "Kazzak",
              level = 80,
            },
            {
              name = "Lazelini",
              class = "Warrior",
              spec = "Protection",
              realm = "Tarren Mill",
              level = 80,
            },
            {
              name = "Sjeledk",
              class = "Death Knight",
              spec = "Frost",
              realm = "Twisting Nether",
              level = 80,
            },
            {
              name = "Crimsf",
              class = "Shaman",
              spec = "Elemental",
              realm = "Draenor",
              level = 80,
            },
          },
        },
      },
    },
  },
}

MrMythicalLeaderboard = MrMythicalLeaderboard or {}
MrMythicalLeaderboard.Data = MrMythicalLeaderboardData

-- Also create global variables for fallback access
_G.MrMythicalLeaderboardData = MrMythicalLeaderboardData