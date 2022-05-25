pragma solidity ^0.8.0;
contract Dns {
    struct NameEntry {
        address payable owner;
        string value;
        uint sellingPrice;
        bool sell;
    }

    uint32 constant REGISTRATION_COST = 100;
    uint32 constant UPDATE_COST = 10;
    mapping(bytes32 => NameEntry) data;
    bytes32 constant NULL = "";
    function nameLookup(string memory name) public view returns (string memory) {
        return data[keccak256(abi.encodePacked(name))].value;
    }
    function getPrice(string memory name) public view returns (uint) {
        return data[keccak256(abi.encodePacked(name))].sellingPrice;
    }
    function getSell(string memory name) public view returns (bool) {
        return data[keccak256(abi.encodePacked(name))].sell;
    }

    function getName(string memory name) public view returns (string memory IP,uint SellPrice,bool IsSelling) {
        return (data[keccak256(abi.encodePacked(name))].value,data[keccak256(abi.encodePacked(name))].sellingPrice, data[keccak256(abi.encodePacked(name))].sell);
    }

    function nameNew(string memory _name, string memory _IP,uint _price, bool _sell) public payable{
        if (msg.value >= REGISTRATION_COST) {
            bytes32 hash = keccak256(abi.encodePacked(_name));
            if ((keccak256(abi.encodePacked((data[hash].value))) == keccak256(abi.encodePacked((""))))){
                data[hash].owner = payable(msg.sender);
                data[hash].value = _IP;
                data[hash].sellingPrice = _price;
                data[hash].sell = _sell;
            }
        }
    }
    function buy(string memory name, string memory _IP,uint _sellingPrice, bool _sell) public payable{
        bytes32 hash = keccak256(abi.encodePacked(name));
        if (data[hash].sell == true){
            if (msg.value >= UPDATE_COST + data[hash].sellingPrice) {
                data[hash].owner.transfer(msg.value-UPDATE_COST);
                data[hash].owner = payable(msg.sender);
                data[hash].value = _IP;
                data[hash].sellingPrice = _sellingPrice;
                data[hash].sell = _sell;
            }
        }
    }
    function nameUpdate (string memory name, string memory newIP, uint newPrice, bool _sell) public payable {
        bytes32 hash = keccak256(abi.encodePacked(name));

        if (data[hash].owner == payable(msg.sender) && msg.value >= UPDATE_COST) {
            data[hash].value = newIP;
            data[hash].sellingPrice = newPrice;
            data[hash].sell = _sell;
        }
    }
}