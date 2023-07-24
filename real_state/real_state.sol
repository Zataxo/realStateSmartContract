// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RealState {

    struct Property{
        address owner;
        string ownerName;
        string name;
        uint256 price;
        string location;
        string description;
        bool forSale;
    }
    mapping (uint256=> Property) public properties;
    uint256[] public propertyIds;

    event PropertySold (string message,uint256 propertyId,address _from,address _to);

    function listPropertyForSale(
    uint256 _propertyID,
    string calldata _name,
    uint256 _price,
    string calldata _description,
    string calldata _location,
    string calldata _ownerName ) external {
        Property memory newProperty = Property({
            owner:msg.sender,
            name:_name,
            ownerName:_ownerName,
            price:_price,
            description:_description,
            location:_location,
            forSale:true
        });
        properties[_propertyID] = newProperty;
        propertyIds.push(_propertyID);
    }


    function buyProperty(uint _propertyID,string calldata _newOwner) public payable {
        Property storage selectedProperty = properties[_propertyID];

        address previousOwner = selectedProperty.owner;
        //Testing
        require(selectedProperty.forSale,"Property not for sale");
        require(selectedProperty.price <= msg.value,"Insufficient Balance");
        // 
        // Changing ownership
        selectedProperty.owner = msg.sender;
        selectedProperty.ownerName = _newOwner;
        selectedProperty.forSale = false;
        //
       (bool isSuccess,) =  payable(previousOwner).call{value:selectedProperty.price}("");
       assert(isSuccess);
       emit PropertySold("Sold out",_propertyID,previousOwner,msg.sender);
    }
}