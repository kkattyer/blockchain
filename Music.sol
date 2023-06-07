// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";



contract Music is ERC1155 {
    constructor() ERC1155("") {
        musAdmin=msg.sender;
    }

    uint amountSongs = 0;
    address musAdmin;
    uint public priceForRecord = 1000 gwei;
    
    struct Song {
        string name;
        string cover;
        bool availability;
    }


    mapping (uint => string) songNumber;
    mapping (uint => address) rentedTo;

    //-----------Admin
    function changeAdmin(address _newAdmin) public {
        require(musAdmin==msg.sender, "Only admin");
        musAdmin = _newAdmin;
      
    }

    function withdraw() public {
        require(musAdmin==msg.sender, "Only admin");
        payable (musAdmin).transfer(address(this).balance);
    }
    //-----------Song
    function RecordSong(string calldata _url) payable public  {
        require(musAdmin==msg.sender, "Only admin");
        require(priceForRecord == msg.value, "Not enough funds");
        //song creation
        songNumber [amountSongs] = _url;
        _mint(musAdmin, amountSongs, 1, "");
         amountSongs++;

    }
    function url (uint _songID) public view returns (string memory){
        require(_songID<amountSongs, "Not exist");
        return songNumber[_songID];
    }

    function rentSong (uint _songID, uint _month) public payable {
        require(_songID<amountSongs, "Not exist");
        require(balanceOf(musAdmin, _songID)!=0, "Already rented");
        require(priceForRecord*_month==msg.value, "Not enough funds");
        rentedTo[_songID]==msg.sender;
        _setApprovalForAll(musAdmin, msg.sender, true);
        safeTransferFrom(musAdmin, msg.sender, _songID, 1, "");
        _setApprovalForAll(musAdmin, msg.sender, false);
    }

    function whereIsSong(uint _songID) public view returns (address) { 
        require(_songID<amountSongs, "Not exist");
        return rentedTo[_songID];
    }

    function returnSong (uint _songID) public {
        require(msg.sender == rentedTo[_songID], "Only admin");
        safeTransferFrom(msg.sender, musAdmin, _songID, 1, "");
        delete rentedTo[_songID];
    }


}
