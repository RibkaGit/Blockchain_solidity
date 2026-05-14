// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./Hero.sol";

// Create Mage contract that inherits from Hero with health = 50
contract Mage is Hero {
    constructor() Hero(50) {
    }
    
    // Override the attack function for Mage with public visibility
    function attack(Enemy enemy) public override {
        // Invoke the base Hero contract's attack function first
        super.attack(enemy);
        
        // Invoke takeAttack with Spell attack type
        enemy.takeAttack(AttackTypes.Spell);
    }
}

// Create Warrior contract that inherits from Hero with health = 200
contract Warrior is Hero {
    constructor() Hero(200) {
    }
    
    // Override the attack function for Warrior with public visibility
    function attack(Enemy enemy) public override {
        // Invoke the base Hero contract's attack function first
        super.attack(enemy);
        
        // Invoke takeAttack with Brawl attack type
        enemy.takeAttack(AttackTypes.Brawl);
    }
}