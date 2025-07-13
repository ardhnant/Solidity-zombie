pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
    //event which will let other ppl know that transaction happend
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    //creating a diff type of value
    struct Zombie {
        string name;
        uint dna;
    }

    //array to store the zombie data
    Zombie[] public zombies;

    //mapping
    mapping(uint => address) public zombieToOwner;
    mapping(address => uint) ownerZombieCount;

    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;

        //setting the data in the map
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;

        //emiting the data into the event
        emit NewZombie(id, _name, _dna);
    }

    //creating a function which will create a random dna based on previous dna
    function _generateRandomDna(
        string memory _str
    ) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        //using require method it is like if, if condition is true then
        //it will proceed what is written ahead else it will stop and throw error
        require(ownerZombieCount[msg.sender] == 0);

        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
