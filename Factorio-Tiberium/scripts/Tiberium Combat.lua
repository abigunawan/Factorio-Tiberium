--The Spanish Inquisition

local hit_effects = require ("__base__/prototypes/entity/demo-hit-effects")
local sounds = require("__base__/prototypes/entity/demo-sounds")

local tiberiumArmor = table.deepcopy(data.raw.armor["heavy-armor"])
tiberiumArmor.name = "tiberium-armor"
table.insert(tiberiumArmor.resistances, {type = "tiberium", decrease = 10, percent = 99})
tiberiumArmor.order = "c[tiberium-armor]"
tiberiumArmor.subgroup = "a-items"
tiberiumArmor.icons = {
   {
      icon = tiberiumArmor.icon,
      tint = {r = 0.3, g = 0.9, b = 0.3, a = 0.9}
   }
}

local recipe = table.deepcopy(data.raw.recipe["heavy-armor"])
recipe.name = "tiberium-armor"
recipe.ingredients = {{"plastic-bar", 50}, {"heavy-armor", 1}, {"pipe", 2}}
recipe.result = "tiberium-armor"

data:extend{tiberiumArmor, recipe}

local tiberiumPowerArmor = table.deepcopy(data.raw.armor["power-armor-mk2"])

tiberiumPowerArmor.name = "tiberium-power-armor"
tiberiumPowerArmor.order = "d[tiberium-power-armor]"
tiberiumPowerArmor.subgroup = "a-items"
tiberiumPowerArmor.icons= {
   {
      icon = tiberiumInternalName.."/graphics/icons/tiberium-field-suit.png",
      tint = {r = 0.3, g = 0.9, b = 0.3, a = 0.9}
   }
}

local updatedResist = false
for _, resist in pairs(tiberiumPowerArmor.resistances) do
	if resist.type == "tiberium" then
		resist.percent = 100
		updatedResist = true
		break
	end
end
if not updatedResist then
	tiberiumPowerArmor.resistances[#tiberiumPowerArmor.resistances + 1] = {
		type = "tiberium",
		decrease = 0,
		percent = 100
	}
end

local recipe = table.deepcopy(data.raw.recipe["power-armor-mk2"])
recipe.name = "tiberium-power-armor"
recipe.ingredients = {{"plastic-bar",50},{"power-armor-mk2",1},{"pipe",2}}
recipe.result = "tiberium-power-armor"

data:extend{tiberiumPowerArmor,recipe}

data:extend{
  {
    type = "ammo",
    name = "tiberium-rounds-magazine",
    icon = "__base__/graphics/icons/uranium-rounds-magazine.png",
    icon_size = 64,
	icon_mipmaps = 4,
    ammo_type = {
      category = "bullet",
      action = {
        type = "direct",
        action_delivery = {
          type = "instant",
          source_effects = {
            type = "create-explosion",
            entity_name = "explosion-gunshot"
          },
          target_effects = {
            {
              type = "create-entity",
              entity_name = "explosion-hit",
              offsets = {{0, 1}},
              offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}}
            },
            {
              type = "damage",
              damage = {amount = 15 , type = "tiberium"}
            }
          }
        }
      }
    },
    magazine_size = 10,
    subgroup = "a-items",
    order = "a[basic-clips]-d[tiberium-rounds-magazine]",
    stack_size = 200
  },
  {
    type = "recipe",
    name = "tiberium-rounds-magazine",
    enabled = false,
    category = "advanced-crafting",
    energy_required = 5,
	-- The Tiberium Ore is added to recipe during recipe-autogeneration since it varies based on the settings
    ingredients = {
      {"piercing-rounds-magazine", 1},
    },
    result = "tiberium-rounds-magazine"
  }
}
data:extend{
  {
    type = "ammo",
    name = "tiberium-rocket",
    icon = tiberiumInternalName.."/graphics/icons/tiberium-rocket.png",
    icon_size = 64,
    ammo_type = {
      category = "rocket",
      action = {
        type = "direct",
        action_delivery = {
          type = "projectile",
          projectile = "tiberium-rocket",
          starting_speed = 0.1,
          source_effects = {
            type = "create-entity",
            entity_name = "explosion-hit",
          }
        }
      }
    },
    subgroup = "a-items",
    order = "b[rocket-launcher]-a[basic]",
    stack_size = 200
  },
  {
    type = "recipe",
    name = "tiberium-rocket",
    enabled = false,
    category = "crafting-with-fluid",
    energy_required = 50,
    ingredients = {
      {"rocket", 10},
      {type = "fluid", name = "liquid-tiberium", amount = 1}
    },
    results = {
      {"tiberium-rocket", 10},
    }
  },
  {
    type = "projectile",
    name = "tiberium-rocket",
    flags = {"not-on-map"},
    acceleration = 0.005,
    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "create-entity",
            entity_name = "big-explosion"
          },
          {
            type = "damage",
            damage = {amount = 50, type = "explosion"}
          },
          {
            type = "damage",
            damage = {amount = 100, type = "tiberium"}
          },
          {
            type = "create-entity",
            entity_name = "small-scorchmark",
            check_buildability = true
          },
          {
            type = "nested-result",
            action = {
              type = "area",
              radius = 6.5,
              action_delivery = {
                type = "instant",
                target_effects = {
                  {
                    type = "damage",
                    damage = {amount = 200, type = "tiberium"}
                  },
                  {
                    type = "damage",
                    damage = {amount = 100, type = "explosion"}
                  },
                  {
                    type = "create-entity",
                    entity_name = "explosion"
                  }
                }
              }
            }
          }
        }
      }
    },
    light = {intensity = 0.5, size = 4},
    animation = {
      filename = "__base__/graphics/entity/rocket/rocket.png",
      frame_count = 8,
      line_length = 8,
      width = 9,
      height = 35,
      shift = {0, 0},
      priority = "high"
    },
    shadow = {
      filename = "__base__/graphics/entity/rocket/rocket-shadow.png",
      frame_count = 1,
      width = 7,
      height = 24,
      priority = "high",
      shift = {0, 0}
    },
    smoke = {
      {
        name = "smoke-fast",
        deviation = {0.15, 0.15},
        frequency = 1,
        position = {0, 1},
        slow_down_factor = 1,
        starting_frame = 3,
        starting_frame_deviation = 5,
        starting_frame_speed = 0,
        starting_frame_speed_deviation = 5
      }
    }
  },
}
data:extend{
  {
    type = "ammo",
    name = "tiberium-nuke",
    icon = tiberiumInternalName.."/graphics/icons/tiberium-nuke.png",
    icon_size = 64,
    ammo_type = {
      range_modifier = 5,
      cooldown_modifier = 3,
      target_type = "position",
      category = "rocket",
      action = {
        type = "direct",
        action_delivery = {
          type = "projectile",
          projectile = "tiberium-nuke",
          starting_speed = 0.05,
          source_effects = {
            type = "create-entity",
            entity_name = "explosion-hit"
          }
        }
      }
    },
    subgroup = "a-items",
    order = "b[rocket-launcher]-b[atomic-bomb]",
    stack_size = 10
  },
  {
    type = "recipe",
    name = "tiberium-nuke",
    enabled = false,
    category = "crafting-with-fluid",
    energy_required = 50,
    ingredients = {
      {"rocket-control-unit", 10},
      {"explosives", 10},
      {type = "fluid", name = "liquid-tiberium", amount = 10}
    },
    result = "tiberium-nuke"
  },
  {
    type = "projectile",
    name = "tiberium-nuke",
    flags = {"not-on-map"},
    acceleration = 0.005,
    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "create-trivial-smoke",
            smoke_name = "nuclear-smoke",
            offset_deviation = {{-1, -1}, {1, 1}},
            starting_frame = 3,
            starting_frame_deviation = 5,
            starting_frame_speed = 0,
            starting_frame_speed_deviation = 5,
            speed_from_center = 0.5,
            repeat_count = 100
          },
          {
            type = "create-entity",
            entity_name = "explosion"
          },
          {
            type = "damage",
            damage = {amount = 400, type = "explosion"},
            damage = {amount = 1000, type = "tiberium"}
          },
          {
            type = "create-entity",
            entity_name = "small-scorchmark",
            check_buildability = true
          },
          {
            type = "nested-result",
            action = {
              type = "area",
              target_entities = false,
              trigger_from_target = true,
              repeat_count = 2000,
              radius = 50,
              action_delivery = {
                type = "projectile",
                projectile = "atomic-bomb-wave",
                starting_speed = 0.5
              }
            }
          }
        }
      }
    },
    light = {intensity = 0.8, size = 15},
    animation = {
      filename = "__base__/graphics/entity/rocket/rocket.png",
      frame_count = 8,
      line_length = 8,
      width = 9,
      height = 35,
      shift = {0, 0},
      priority = "high"
    },
    shadow = {
      filename = "__base__/graphics/entity/rocket/rocket-shadow.png",
      frame_count = 1,
      width = 7,
      height = 24,
      priority = "high",
      shift = {0, 0}
    },
    smoke = {
      {
        name = "smoke-fast",
        deviation = {0.15, 0.15},
        frequency = 1,
        position = {0, 1},
        slow_down_factor = 1,
        starting_frame = 3,
        starting_frame_deviation = 5,
        starting_frame_speed = 0,
        starting_frame_speed_deviation = 5
      }
    }
  },
}
data:extend{
  {
    type = "ammo",
    name = "tiberium-seed",
    icon = tiberiumInternalName.."/graphics/icons/tiberium-seed-rocket.png",
    icon_size = 64,
    ammo_type = {
      range_modifier = 5,
      cooldown_modifier = 3,
      target_type = "position",
      category = "rocket",
      action = {
        type = "direct",
        action_delivery = {
          type = "projectile",
          projectile = "tiberium-seed",
          starting_speed = 0.05,
          source_effects = {
            type = "create-entity",
            entity_name = "explosion-hit"
          }
        }
      }
    },
    subgroup = "a-items",
    order = "b[rocket-launcher]-c[seed-missile]",
    stack_size = 10
  },
  {
    type = "recipe",
    name = "tiberium-seed",
    enabled = false,
    category = "crafting-with-fluid",
    energy_required = 50,
    ingredients = {
      {"rocket-control-unit", 10},
      {type = "fluid", name = "liquid-tiberium", amount = 200}
    },
    result = "tiberium-seed"
  },
  {
    type = "projectile",
    name = "tiberium-seed",
    flags = {"not-on-map"},
    acceleration = 0.005,
    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        target_effects = {    
          {
            type = "script",
            effect_id = "seed-launch"
          },
        }
      }
    },
    light = {intensity = 0.8, size = 15},
    animation = {
      filename = "__base__/graphics/entity/rocket/rocket.png",
      frame_count = 8,
      line_length = 8,
      width = 9,
      height = 35,
      shift = {0, 0},
      priority = "high"
    },
    shadow = {
      filename = "__base__/graphics/entity/rocket/rocket-shadow.png",
      frame_count = 1,
      width = 7,
      height = 24,
      priority = "high",
      shift = {0, 0}
    },
    smoke = {
      {
        name = "smoke-fast",
        deviation = {0.15, 0.15},
        frequency = 1,
        position = {0, 1},
        slow_down_factor = 1,
        starting_frame = 3,
        starting_frame_deviation = 5,
        starting_frame_speed = 0,
        starting_frame_speed_deviation = 5
      }
    }
  },
}
data:extend{
  {
    type = "electric-turret",
    name = "ion-turret",
    icon = "__base__/graphics/icons/laser-turret.png",
    icon_size = 64,
    flags = {"placeable-player", "placeable-enemy", "player-creation"},
    minable = {mining_time = 0.5, result = "ion-turret"},
    max_health = 1000,
    collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
    selection_box = {{-1, -1}, {1, 1}},
    rotation_speed = 0.01,
    preparing_speed = 0.05,
    dying_explosion = "medium-explosion",
    corpse = "laser-turret-remnants",
    folding_speed = 0.05,
    energy_source = {
      type = "electric",
      buffer_capacity = "20000kJ",
      input_flow_limit = "48000kW",
      drain = "24kW",
      usage_priority = "primary-input"
    },
    folded_animation = {
      layers = {
        laser_turret_extension{frame_count=1, line_length = 1},
        laser_turret_extension_shadow{frame_count=1, line_length=1},
        laser_turret_extension_mask{frame_count=1, line_length=1}
      }
    },
    preparing_animation = {
      layers = {
        laser_turret_extension{},
        laser_turret_extension_shadow{},
        laser_turret_extension_mask{}
      }
    },
    prepared_animation = {
      layers = {
        laser_turret_shooting(),
        laser_turret_shooting_shadow(),
        laser_turret_shooting_mask()
      }
    },
    --attacking_speed = 0.1,
    energy_glow_animation = laser_turret_shooting_glow(),
    glow_light_intensity = 0.5, -- defaults to 0
    folding_animation = {
      layers = {
        laser_turret_extension{run_mode = "backward"},
        laser_turret_extension_shadow{run_mode = "backward"},
        laser_turret_extension_mask{run_mode = "backward"}
      }
    },
    base_picture = {
      layers = {
        {
          filename = "__base__/graphics/entity/laser-turret/laser-turret-base.png",
          priority = "high",
          width = 70,
          height = 52,
          direction_count = 1,
          frame_count = 1,
          shift = util.by_pixel(0, 2),
          hr_version = {
            filename = "__base__/graphics/entity/laser-turret/hr-laser-turret-base.png",
            priority = "high",
            width = 138,
            height = 104,
            direction_count = 1,
            frame_count = 1,
            shift = util.by_pixel(-0.5, 2),
            scale = 0.5
          }
        },
        {
          filename = "__base__/graphics/entity/laser-turret/laser-turret-base-shadow.png",
          line_length = 1,
          width = 66,
          height = 42,
          draw_as_shadow = true,
          direction_count = 1,
          frame_count = 1,
          shift = util.by_pixel(6, 3),
          hr_version = {
            filename = "__base__/graphics/entity/laser-turret/hr-laser-turret-base-shadow.png",
            line_length = 1,
            width = 132,
            height = 82,
            draw_as_shadow = true,
            direction_count = 1,
            frame_count = 1,
            shift = util.by_pixel(6, 3),
            scale = 0.5
          }
        }
      }
    },
    vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
    attack_parameters = {
      type = "beam",
      cooldown = 40,
      range = 48,
      source_direction_count = 64,
      source_offset = {0, -3.423489 / 4},
      damage_modifier = 8,
      ammo_type = {
        category = "laser-turret",
        energy_consumption = "2000kJ",
        action = {
          type = "direct",
          action_delivery = {
            type = "beam",
            beam = "laser-beam",
            max_length = 48,
            duration = 40,
            source_offset = {0, -1.31439}
          }
        }
      }
    },
    call_for_help_radius = 40
  },
  {
    type = "item",
    name = "ion-turret",
    icon = "__base__/graphics/icons/laser-turret.png",
    icon_size = 64,
    subgroup = "a-buildings",
    order = "f[ion-turret]",
    place_result = "ion-turret",
    stack_size = 50
  },
  {
    type = "recipe",
    name = "ion-turret",
    normal = {
      energy_required = 20,
      enabled = false,
      subgroup = "a-buildings",
      ingredients = {
        {"advanced-circuit", 40},
        {"steel-plate", 40},
        {"tiberium-ion-core", 1}
      },
      result = "ion-turret"
    },
    expensive = {
      energy_required = 30,
      enabled = false,
      subgroup = "a-buildings",
      ingredients = {
        {"advanced-circuit", 40},
        {"steel-plate", 40},
        {"tiberium-ion-core", 1}
      },
      result = "ion-turret"
    }
  }
}

local marvItem = table.deepcopy(data.raw["item-with-entity-data"]["tank"])
marvItem.name = "tiberium-marv"
marvItem.place_result = "tiberium-marv"
marvItem.order = "e[personal-transport]-a[marv]"
marvItem.subgroup = "a-items"
marvItem.icon = tiberiumInternalName.."/graphics/icons/tiberium-marv.png"
marvItem.icon_size = 128
marvItem.icon_mipmaps = nil

local marvEntity = table.deepcopy(data.raw.car["tank"])
marvEntity.name = "tiberium-marv"
marvEntity.guns = nil
marvEntity.max_health = 5000
table.insert(marvEntity.resistances, {type = "tiberium", decrease = 0, percent = 100})
marvEntity.consumption = "1200kW"
marvEntity.braking_power = "1000kW"
marvEntity.friction = 0.02
marvEntity.rotation_speed = 0.002
marvEntity.minable.result = "tiberium-marv"
marvEntity.turret_animation = nil
marvEntity.turret_return_timeout = nil
marvEntity.turret_rotation_speed = nil
marvEntity.weight = 50000
marvEntity.collision_box = {{-1.4, -1.8}, {1.4, 1.8}}
marvEntity.drawing_box = {{-2.3, -2.3}, {2.3, 2}}
marvEntity.selection_box = {{-1.4, -1.8}, {1.4, 1.8}}
marvEntity.burner.smoke[1].position = {0, 2.2}
for _, layer in pairs(marvEntity.animation.layers) do
	layer.scale = 0.75
	if layer.hr_version then
		layer.hr_version.scale = 0.75
	end
end

data:extend{marvItem, marvEntity,
	{
		type = "recipe",
		name = "tiberium-marv",
		enabled = false,
		energy_required = 40,
		ingredients = {
			{"engine-unit", 100},
			{"steel-plate", 100},
			{"iron-gear-wheel", 50},
			{"node-harvester", 4},
		},
		result = "tiberium-marv",
		subgroup = "a-items",
	}
}

--Moving away from land mines for performance reasons, probably need it uncommented for backwards compatibility
local TiberiumDamage = settings.startup["tiberium-damage"].value
local TiberiumRadius = 20 + settings.startup["tiberium-spread"].value * 0.3
data:extend({
  {
    type = "land-mine",
    name = "ore-land-mine",
    icon = tiberiumInternalName.."/graphics/entity/null-sprite.png",
    collision_mask = {"object-layer"},
    force_die_on_attack = false,
    max_health = 10000,
    destructible = false,
    icon_size = 1,
    flags = {
      "not-on-map"
    },
    minable = nil,
    damaged_trigger_effect = hit_effects.entity(),    
    picture_safe = {
      filename = tiberiumInternalName.."/graphics/entity/null-sprite.png",
      priority = "medium",
      width = 1,
      height = 1
    },
    picture_set = {
      filename = tiberiumInternalName.."/graphics/entity/null-sprite.png",
      priority = "medium",
      width = 1,
      height = 1
    },
    picture_set_enemy = {
      filename = tiberiumInternalName.."/graphics/entity/null-sprite.png",
      priority = "medium",
      width = 1,
      height = 1
    },
    trigger_radius = 1,
    ammo_category = "landmine",
    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        source_effects = {
          {
            type = "nested-result",
            action = {
              type = "area",
              radius = 1,
              force = "enemy",
              action_delivery = {
                type = "instant",
                target_effects = {
                  {
                    type = "damage",
                    damage = {amount = TiberiumDamage * 0.1, type = "tiberium"}
                  },
                }
              }
            }
          }
        }
      }
    }
  },
  {
    type = "land-mine",
    name = "node-land-mine",
    icon = tiberiumInternalName.."/graphics/entity/null-sprite.png",
    dying_explosion = "land-mine-explosion",
    icon_size = 1,
    force_die_on_attack = false,
    max_health = 10000,
    collision_mask = {"layer-15"},
    collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
    destructible = false,
    flags = {
      "not-on-map"
    },
    minable = nil,
    damaged_trigger_effect = hit_effects.entity(),
    picture_safe = {
      filename = tiberiumInternalName.."/graphics/entity/null-sprite.png",
      priority = "medium",
      width = 1,
      height = 1
    },
    picture_set = {
      filename = tiberiumInternalName.."/graphics/entity/null-sprite.png",
      priority = "medium",
      width = 1,
      height = 1
    },
    picture_set_enemy = {
      filename = tiberiumInternalName.."/graphics/entity/null-sprite.png",
      priority = "medium",
      width = 1,
      height = 1
    },
    trigger_radius = TiberiumRadius * 0.6,
    trigger_force = "enemy",
    ammo_category = "landmine",
    resistances = {
       {
          type = "physical",
          decrease = 100,
          percent = 100
       },
       {
          type = "explosion",
          decrease = 100,
          percent = 100
       },
       {
          type = "tiberium",
          decrease = 100,
          percent = 100
       },
       {
          type = "acid",
          decrease = 100,
          percent = 100
       }
    },
    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        source_effects = {
          {
            type = "nested-result",
            action = {
              type = "area",
              radius = TiberiumRadius * 0.6,
              force = "enemy",
              action_delivery = {
                type = "instant",
                target_effects = {
                  {
                    type = "damage",
                    damage = {amount = TiberiumDamage * 0.2, type = "tiberium"}
                  },
                }
              }
            }
          }
        }
      }
    }
  }
}) 