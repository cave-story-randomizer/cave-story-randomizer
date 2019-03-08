local data = {
    firstCave1 = {
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
        },
        events = {}
    },
    firstCave2 = {
        connections = {
            mimigaVillage = {{"weaponSN"}}
        },
        locations = {
            gunsmith = {
                requirements = {"polarStar", "eventCore"},
                map = "Pole",
                event = "#0303"
            }
        },
        events = {}
    }
    mimigaVillage = {
        connections = {
            firstCave2 = {{"weaponSN", "machineGun"}, {"weaponSN", "booster1"}},
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
            graveyard = {
                requirements = {{"locket"}},
                map = "Cemet",
                event = "#0301"
            },
            mushroom = {
                requirements = {{"locket", "eventCurly", "machineGun"}, {"locket", "eventCurly", "booster1"}},
                map = "Mapi",
                event = "#0202"
            },
            maPignon = {
                requirements = {{"locket", "mushroomBadge", "weapon", "booster1"}, {"locket", "mushroomBadge", "machineGun"}},
                map = "Mapi",
                event = "#0501"
            }
        },
        events = {}
    }
    arthur = {
        connections = {
            mimigaVillage = {{"arthursKey"}},
            eggCorridor1 = {},
            eggCorridor2 = {{"eventCore"}, --also unlocks if you have access to the teleporter between grasstown and plantation, but that's logically redundant
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
                requirements = {{"idCard", "weapon"}}
            }
        }
    },
    grasstownWest = {
        connections = {
            arthur = {},
            grasstownEast = {{"juice"}, {"booster1"}, {"machineGun"}}
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
                requirements = {{"santaKey", "weapon"}, {"fireball"}},
                map = "Weed",
                event = "0000"
            }
        },
        events = {}
    },
    grasstownEast = {
        connections = {
            grasstownWest = {{"eventFans"}, {"machineGun"}, {"booster1"}},
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
                requirements = {{"eventFans"}, {"machineGun"}, {"booster1"}},
                map = "Weed",
                event = "#0000"
            },
            hutChest = {
                requirements = {{"eventFans"}, {"machineGun"}, {"booster1"}},
                map = "WeedB",
                event = "#0000"
            },
            gumChest = {
                requirements = {{"eventFans", "gumKey", "weapon"}, {"machineGun", "gumKey"}, {"booster1", "gumKey", "weapon"}},
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
                requirements = {{"rustyKey", "weapon"}}
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
            labyrinthW = {{"puppies", "weapon"}, {"booster1"}, {"machineGun"}}
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
                requirements = {{"puppies"}},
                map = "Jenka1",
                event = "#0000"
            },
            king = {
                requirements = {{"puppies", "weapon"}},
                map = "Gard",
                event = "#0000"
            }
        },
        events = {}
    },
    labyrinthB = {
        connections = {
            labyrinthW = {{"machineGun"}, {"booster1", "weapon"}},
            boulder = {{"machineGun"}, {"booster1"}},
            arthur = {}
        },
        locations = {
            fallenBooster = {
                requirements = {},
                map = "MazeB",
                event = "#0000"
            }
        },
        events = {}
    },
    labyrinthW = {
        connections = {
            lowerSandZone = {},
            labyrinthB = {{"weapon"}},
            boulder = {},
            labyrinthM = {{"machineGun"}, {"booster1"}}
        },
        locations = {
            critterCapsule = {
                requirements = {{"weapon"}},
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
                requirements = {{"machineGun"}, {"booster1"}},
                map = "MazeO",
                event = "#0000"
            },
            physician = {
                requirements = {},
                map = "MazeO",
                event = "#0000"
            },
            puuBlack = {
                requirements = {{"clinicKey", "weapon"}},
                map = "MazeD",
                event = "#0000"
            }
        },
        events = {}
    },
    boulder = {
        connections = {
            labyrinthB = {},
            labyrinthW = {},
            labyrinthM = {{"cureAll", "weapon"}}
        },
        locations = {
            boulderChest = {
                requirements = {{"cureAll", "weapon"}},
                map = "MazeS",
                event = "#0000"
            }
        },
        events = {}
    },
    labyrinthM = {
        connections = {
            labyrinthW = {},
            boulder = {{"cureAll", "weapon"}},
            darkPlace = {}
        },
        locations = {},
        events = {}
    },
    darkPlace = {
        connections = {
            waterway = {{"airTank"}},
            core = {{"cureAll"}},
            labyrinthM = {}
        },
        locations = {},
        events = {}
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
                requirements = {{"weapon"}}
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
                requirements = {{"weapon"}},
                map = "Eggs2",
                event = "#0000"
            },
            sisters = {
                requirements = {{"weapon"}},
                map = "EggR2",
                event = "#0000"
            }
        },
        events = {}
    },
    outerWall = {
        connections = {
            eggCorridor2 = {{"bomb"}},
            plantation = {{"machineGun"}, {"booster1"}}
        },
        locations = {
            clock = {
                requirements = {}, --eventCurly? works like that in vanilla
                map = "Clock",
                event = "#0000"
            },
            mrLittle = {
                requirements = {{"locket", "machineGun"}, {"locket", "booster1"}},
                map = "Little",
                event = "#0000"
            }
        },
        events = {}
    },
    plantation = {
        connections = {
            arthur = {{"teleportKey"}},
            outerWall = {},
            grasstownEast = {{"bomb", "weaponSN"}},
            lastCave = {{"eventRocket", "booster2", "weapon"}}
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
                requirements = {{"machineGun", "booster1"}},
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
        },
        events = {}
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