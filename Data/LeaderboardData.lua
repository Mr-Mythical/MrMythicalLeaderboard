local MrMythicalLeaderboardData = {
  lastUpdated = 1789452045,
  dungeons = {
    ["algethar-academy"] = {
      name = "Algeth'ar Academy",
      runs = {
        {
          rank = 1,
          score = 547,
          level = 24,
          time = 1761595,
          keystoneTime = 1860999,
          chests = 1,
          completedAt = "2026-08-06T18:26:08.000Z",
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
    ["magisters-terrace"] = {
      name = "Magisters' Terrace",
      runs = {
        {
          rank = 1,
          score = 563.4,
          level = 25,
          time = 1857381,
          keystoneTime = 2040999,
          chests = 1,
          completedAt = "2026-08-06T22:23:37.000Z",
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
    ["maisara-caverns"] = {
      name = "Maisara Caverns",
      runs = {
        {
          rank = 1,
          score = 563.4,
          level = 25,
          time = 1798391,
          keystoneTime = 1980999,
          chests = 1,
          completedAt = "2026-07-25T21:10:55.000Z",
          roster = {
            {
              name = "Zacdruid",
              class = "Druid",
              spec = "Guardian",
              realm = "Hyjal",
              level = 90,
            },
            {
              name = "Myzouth",
              class = "Death Knight",
              spec = "Unholy",
              realm = "Burning Legion",
              level = 90,
            },
            {
              name = "Titiquemonk",
              class = "Monk",
              spec = "Mistweaver",
              realm = "Ysondre",
              level = 90,
            },
            {
              name = "Nikovoker",
              class = "Evoker",
              spec = "Augmentation",
              realm = "Ysondre",
              level = 90,
            },
            {
              name = "Nzangellips",
              class = "Demon Hunter",
              spec = "Devourer",
              realm = "Hyjal",
              level = 90,
            },
          },
        },
      },
    },
    ["pit-of-saron"] = {
      name = "Pit of Saron",
      runs = {
        {
          rank = 1,
          score = 562.9,
          level = 25,
          time = 1662440,
          keystoneTime = 1800999,
          chests = 1,
          completedAt = "2026-08-03T14:25:02.000Z",
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
  },
}

MrMythicalLeaderboard = MrMythicalLeaderboard or {}
MrMythicalLeaderboard.Data = MrMythicalLeaderboardData

-- Also create global variables for fallback access
_G.MrMythicalLeaderboardData = MrMythicalLeaderboardData