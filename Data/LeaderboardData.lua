local MrMythicalLeaderboardData = {
  lastUpdated = 1789473890,
  dungeons = {
    ["seat-of-the-triumvirate"] = {
      name = "Seat of the Triumvirate",
      runs = {
        {
          rank = 1,
          score = 550.8,
          level = 24,
          time = 1724518,
          keystoneTime = 2040999,
          chests = 1,
          completedAt = "2026-08-06T17:00:36.000Z",
          roster = {
            {
              name = "Uwukittymeow",
              class = "Druid",
              spec = "Guardian",
              realm = "Tarren Mill",
              level = 90,
            },
            {
              name = "Speedk",
              class = "Death Knight",
              spec = "Unholy",
              realm = "Twisting Nether",
              level = 90,
            },
            {
              name = "Roibendeux",
              class = "Monk",
              spec = "Mistweaver",
              realm = "Twisting Nether",
              level = 90,
            },
            {
              name = "Sjelelele",
              class = "Evoker",
              spec = "Augmentation",
              realm = "Twisting Nether",
              level = 90,
            },
            {
              name = "Voluxar",
              class = "Demon Hunter",
              spec = "Devourer",
              realm = "Tarren Mill",
              level = 90,
            },
          },
        },
      },
    },
    ["skyreach"] = {
      name = "Skyreach",
      runs = {
        {
          rank = 1,
          score = 549.6,
          level = 24,
          time = 1472070,
          keystoneTime = 1680999,
          chests = 1,
          completedAt = "2026-08-08T18:57:33.000Z",
          roster = {
            {
              name = "Uwukittymeow",
              class = "Druid",
              spec = "Guardian",
              realm = "Tarren Mill",
              level = 90,
            },
            {
              name = "Speedk",
              class = "Death Knight",
              spec = "Unholy",
              realm = "Twisting Nether",
              level = 90,
            },
            {
              name = "Roibendeux",
              class = "Monk",
              spec = "Mistweaver",
              realm = "Twisting Nether",
              level = 90,
            },
            {
              name = "Sjelelele",
              class = "Evoker",
              spec = "Augmentation",
              realm = "Twisting Nether",
              level = 90,
            },
            {
              name = "Voluxar",
              class = "Demon Hunter",
              spec = "Devourer",
              realm = "Tarren Mill",
              level = 90,
            },
          },
        },
      },
    },
    ["windrunner-spire"] = {
      name = "Windrunner Spire",
      runs = {
        {
          rank = 1,
          score = 560.8,
          level = 25,
          time = 1938502,
          keystoneTime = 1980999,
          chests = 1,
          completedAt = "2026-08-01T12:56:55.000Z",
          roster = {
            {
              name = "Vismarck",
              class = "Druid",
              spec = "Guardian",
              realm = "Azshara",
              level = 90,
            },
            {
              name = "Blahbang",
              class = "Death Knight",
              spec = "Unholy",
              realm = "Azshara",
              level = 90,
            },
            {
              name = "양니리",
              class = "Monk",
              spec = "Mistweaver",
              realm = "Azshara",
              level = 90,
            },
            {
              name = "Gingievoker",
              class = "Evoker",
              spec = "Augmentation",
              realm = "Azshara",
              level = 90,
            },
            {
              name = "중이병딜딸러",
              class = "Demon Hunter",
              spec = "Devourer",
              realm = "Azshara",
              level = 90,
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