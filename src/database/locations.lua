local data = {
    firstCave1 = { -- locations available at the absolute beginning of the game. can't be returned to, but can't be left without obtaining both items
        connections = {
            mimigaVillage = {{"weaponSN"}}
        },
        locations = {
            firstCapsule = {
                requirements = {},
                map = "Cave",
                event = "#0401"
            },
            gunsmithChest = {
                requirements = {},
                map = "Pole",
                event = "#0402"
            }
        }
    },
    firstCave2 = { -- locations available on the return trip to first cave
        connections = {
            mimigaVillage = {{"weaponSN"}}
        },
        locations = {
            gunsmith = {
                requirements = {"polarStar", "eventCore"},
                map = "Pole",
                event = "#0303"
            }
        }
    }
    mimigaVillage = {
        connections = {
            firstCave2 = {{"weaponSN", "flight"}},
            arthur = {{"arthursKey"}}
        },
        locations = {
            yamashita = {
                requirements = {},
                map = "Plant",
                event = "#0401"
            },
            reservoir = {
                requirements = {},
                map = "Pool",
                event = "#0301"
            },
            mapChest = {
                requirements = {},
                map = "Mimi",
                event = "#0202"
            },
            assemblyHall = {
                requirements = {{"juice"}},
                map = "Comu",
                event = "#0303"
            },
            mrLittle = { -- guaranteed to have the little man item, for simplicity's sake (more of an escort quest than fetch quest imo)
                requirements = {{"locket"}},
                map = "Cemet",
                event = "#0301"
            },
            graveyard = {
                requirements = {{"locket"}},
                map = "Cemet",
                event = "#0301"
            },
            mushroom = { -- placed in a chest, can't open unless curly has been saved
                requirements = {{"locket", "eventCurly", "flight"}},
                map = "Mapi",
                event = "#0202"
            },
            maPignon = { -- no need to check the mushroom badge, just need to have it
                requirements = {{"locket", "mushroomBadge", "weaponBoss", "flight"}},
                map = "Mapi",
                event = "#0501"
            }
        }
    }
    arthur = {
        connections = {
            mimigaVillage = {{"arthursKey"}},
            eggCorridor1 = {},
            eggCorridor2 = {{"eventCore"}, -- also unlocks if you have access to the teleporter between grasstown and plantation, but that's logically redundant
            grasstownWest = {},
            upperSandZone = {{"weaponSN"}},
            labyrinthB = {},
            plantation = {{"teleportKey"}}
        },
        locations = {
            risenBooster = {
                requirements = {{"eventCore"}},
                map = "Pens1",
                event = "#0000"
            }
        }
    },
    eggCorridor1 = {
        connections = {
            arthur = {}
        },
        locations = {
            basil = {
                requirements = {},
                map = "Eggs",
                event = "#0403"
            },
            cthulhu = {
                requirements = {},
                map = "Eggs",
                event = "#0404"
            },
            eggItem = {
                requirements = {},
                map = "Egg6",
                event = "#0201"
            },
            observationChest = {
                requirements = {},
                map = "EggR",
                event = "#0301"
            }
        },
        events = {
            eventSue = {
                requirements = {{"idCard", "weaponBoss"}}
            }
        }
    },
    grasstownWest = {
        connections = {
            arthur = {},
            grasstownEast = {{"juice"}, {"flight"}} -- can also sequence break over with a damage boost!
        },
        locations = {
            keySpot = {
                requirements = {},
                map = "Weed",
                event = "#0000"
            },
            jellyCapsule = {
                requirements = {},
                map = "Weed",
                event = "#0000"
            },
            santa = {
                requirements = {{"santaKey"}},
                map = "Santa",
                event = "#0000"
            },
            charcoal = {
                requirements = {{"santaKey", "juice"}},
                map = "Santa",
                event = "#0000"
            }
            chaco = {
                requirements = {{"santaKey"}, {"fireball"}},
                map = "Chako",
                event = "#6969"
            },
            kulala = {
                requirements = {{"santaKey", "weaponBoss"}, {"fireball"}},
                map = "Weed",
                event = "0000"
            }
        }
    },
    grasstownEast = {
        connections = {
            grasstownWest = {{"eventFans"}, {"flight"}},
            plantation = {{"bomb", "weaponSN"}}
        },
        locations = {
            kazuma1 = {
                requirements = {},
                map = "Weed",
                event = "#0000"
            },
            kazuma2 = {
                requirements = {{"eventFans"}},
                map = "Weed",
                event = "#0000"
            },
            execution = {
                requirements = {{"weaponSN"}},
                map = "WeedD",
                event = "#0000"
            },
            outsideHut = {
                requirements = {{"eventFans"}, {"flight"}},
                map = "Weed",
                event = "#0000"
            },
            hutChest = {
                requirements = {{"eventFans"}, {"flight"}},
                map = "WeedB",
                event = "#0000"
            },
            gumChest = {
                requirements = {{"eventFans", "gumKey", "weaponBoss"}, {"flight", "gumKey", "weaponBoss"}},
                map = "Frog",
                event = "#0000"
            },
            malco = {
                requirements = {{"eventFans", "juice", "charcoal", "gum"}},
                map = "Malco",
                event = "#0000"
            }
        },
        events = {
            eventFans = {
                requirements = {{"rustyKey", "weaponBoss"}}
            }
        }
    },
    upperSandZone = {
        connections = {
            arthur = {},
            lowerSandZone = {{"eventOmega"}}
        },
        locations = {
            curly = {
                requirements = {{"polarStar"}},
                map = "Curly",
                event = "#0518"
            },
            panties = {
                requirements = {},
                map = "CurlyS",
                event = "#0421"
            },
            curlyPup = {
                requirements = {},
                map = "CurlyS",
                event = "#0401"
            },
            sandCapsule = {
                requirements = {},
                map = "Sand",
                event = "#0502"
            }
        },
        events = {
            eventOmega = {
                requirements = {}
            }
        }
    },
    lowerSandZone = {
        connections = {
            upperSandZone = {{"eventOmega"}},
            labyrinthW = {{"puppy1", "puppy2", "puppy3", "puppy4", "puppy5", "weaponBoss"}, {"flight"}}
        },
        locations = {
            chestPup = {
                requirements = {},
                map = "Sand",
                event = "#0000"
            },
            pupCapsule = {
                requirements = {},
                map = "Sand",
                event = "#0503"
            },
            darkPup = {
                requirements = {},
                map = "Dark",
                event = "#0000"
            },
            runPup = {
                requirements = {},
                map = "Sand",
                event = "#0000"
            },
            storehousePup = {
                requirements = {},
                map = "Sand",
                event = "#0000"
            },
            jenka = {
                requirements = {{"puppy1", "puppy2", "puppy3", "puppy4", "puppy5"}},
                map = "Jenka1",
                event = "#0000"
            },
            king = {
                requirements = {{"puppy1", "puppy2", "puppy3", "puppy4", "puppy5", "weaponBoss"}},
                map = "Gard",
                event = "#0000"
            }
        }
    },
    labyrinthB = {
        connections = {
            labyrinthW = {{"flight", "weaponBoss"}},
            boulder = {{"flight"}},
            arthur = {}
        },
        locations = {
            fallenBooster = {
                requirements = {},
                map = "MazeB",
                event = "#0000"
            }
        }
    },
    labyrinthW = {
        connections = {
            lowerSandZone = {},
            labyrinthB = {{"weaponBoss"}},
            boulder = {},
            labyrinthM = {{"flight"}}
        },
        locations = {
            critterCapsule = {
                requirements = {{"weaponBoss"}},
                map = "MazeI",
                event = "#0000"
            },
            turboChaba = {
                requirements = {{"machineGun"}},
                map = "MazeA",
                event = "#0000"
            },
            snakeChaba = {
                requirements = {{"polarStar", "fireball"}},
                map = "MazeA",
                event = "#0000"
            },
            whimChaba = {
                requirements = {{"spur"}},
                map = "MazeA",
                event = "#0000"
            },
            armsBarrier = {
                requirements = {{"flight"}},
                map = "MazeO",
                event = "#0000"
            },
            physician = {
                requirements = {},
                map = "MazeO",
                event = "#0000"
            },
            puuBlack = {
                requirements = {{"clinicKey", "weaponBoss"}},
                map = "MazeD",
                event = "#0000"
            }
        }
    },
    boulder = {
        connections = {
            labyrinthB = {},
            labyrinthW = {},
            labyrinthM = {{"cureAll", "weaponBoss"}}
        },
        locations = {
            boulderChest = {
                requirements = {{"cureAll", "weaponBoss"}},
                map = "MazeS",
                event = "#0000"
            }
        }
    },
    labyrinthM = {
        connections = {
            labyrinthW = {},
            boulder = {{"cureAll", "weaponBoss"}},
            darkPlace = {}
        },
    },
    darkPlace = {
        connections = {
            waterway = {{"airTank"}},
            core = {{"cureAll"}},
            labyrinthM = {}
        }
    },
    core = {
        connections = {
            darkPlace = {}
        },
        locations = {
            ropeSpot = {
                requirements = {},
                map = "Almond",
                event = "#0000"
            },
            curlyCorpse = {
                requirements = {{"eventCore"},
                map = "Almond",
                event = "#0000"
            }
        },
        events = {
            eventCore = {
                requirements = {{"weaponBoss"}}
            }
        }
    },
    waterway = {
        connections = {
            darkPlace = {},
            mimigaVillage = {{"weaponSN"}}
        },
        locations = {
            ironhead = {
                requirements = {{"weaponSN"}},
                map = "Stream",
                event = "#0000"
            }
        },
        events = {
            eventCurly = {
                requirements = {{"eventCore", "towRope"}}
            }
        }
    },
    eggCorridor2 = {
        connections = {
            arthur = {},
            outerWall = {{"bomb"}}
        },
        locations = {
            dragonChest = {
                requirements = {{"weaponBoss"}},
                map = "Eggs2",
                event = "#0000"
            },
            sisters = {
                requirements = {{"weaponBoss"}},
                map = "EggR2",
                event = "#0000"
            }
        }
    },
    outerWall = {
        connections = {
            eggCorridor2 = {{"bomb"}},
            plantation = {{"flight"}}
        },
        locations = {
            clock = {
                requirements = {}, --eventCurly? works like that in vanilla
                map = "Clock",
                event = "#0000"
            },
            littleHouse = {
                requirements = {{"little", "flight"}},
                map = "Little",
                event = "#0000"
            }
        }
    },
    plantation = {
        connections = {
            arthur = {{"teleportKey"}},
            outerWall = {},
            grasstownEast = {{"bomb", "weaponSN"}},
            lastCave = {{"eventRocket", "booster2", "weaponBoss"}}
        },
        locations = {
            kanpachi = {
                requirements = {},
                map = "Cent",
                event = "#0000"
            },
            jail1 = {
                requirements = {{"teleportKey"}},
                map = "Jail1",
                event = "#0000"
            },
            momorin = {
                requirements = {{"letter", "booster1"}},
                map = "Momo",
                event = "#0000"
            },
            sprinkler = {
                requirements = {{"mask"}},
                map = "Cent",
                event = "#0000"
            },
            megane = {
                requirements = {{"brokenSprinkler", "mask"}},
                map = "lounge",
                event = "#0000"
            },
            topCapsule = {
                requirements = {{"flight"}},
                map = "Cent",
                event = "#0000"
            },
            plantPup = {
                requirements = {{"eventRocket"}},
                map = "Cent",
                event = "#0000"
            },
            curlyShroom = {
                requirements = {{"eventCurly", "maPignon"}},
                map = "Cent",
                event = "#0000"
            }
        },
        events = {
            eventRocket = {
                requirements = {{"newSprinkler", "booster1", "controller"}}
            }
        }
    },
    lastCave = {
        connections = {
            plantation = {},
            balcony = {{"eventSue", "ironBond"}} --required to get into the endgame boss rush
        },
        locations = {
            redDemon = {
                requirements = {},
                map = "Priso2",
                event = "#0000",
            }
        }
    },
    balcony = {
        connections = {
            lastCave = {}
        },
        locations = {
            hellCapsule = {
                requirements = {},
                map = "Hell1",
                event = "#0000"
            },
            hellChest = {
                requirements = {},
                map = "Hell3",
                event = "#0000"
            }
        },
        events = {
            eventHellCurly = { --do you get to take curly with you in hell?
                requirements = {{"eventCurly"}}
            }
        }
    }
}