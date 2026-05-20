# Drone Coordination System (PDDL)

## Overview
This project implements a multi-drone coordination system using PDDL (Planning Domain Definition Language). The domain models autonomous drones that navigate between connected sites, capture images, manage battery energy, and recharge at charging stations using temporal planning.

The project demonstrates how AI planning can be used for autonomous navigation, resource management, and multi-agent coordination.

---

## Features

- Durative actions for real-time drone behavior
- Energy-aware planning with battery constraints
- Autonomous navigation between connected sites
- Image collection at designated picture locations
- Charging and energy recovery system
- Site reservation system to avoid conflicts
- Operational mode transitions between drone states

---

## Actions

- `takeoff` – launches a drone into flight
- `land` – lands a drone at a site
- `move` – moves drones between connected locations
- `take-pic` – captures images at picture sites
- `charge` – recharges drone batteries
- `transition` – changes drone operational modes

---

## Planning Features

This domain uses advanced PDDL features including:

- Temporal planning
- Numeric fluents
- Durative actions
- Resource constraints
- Multi-agent coordination

---

## Technologies

- PDDL 2.1
- Temporal AI Planning
- Numeric Fluents
- Autonomous Agent Modeling

---

## Future Improvements

Potential extensions include:

- Obstacle avoidance
- Collision detection
- Dynamic weather conditions
- Mission prioritization
- Multi-objective optimization
