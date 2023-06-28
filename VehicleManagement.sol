// SPDX-License-Identifier:MIT
pragma solidity ^0.8.1;
contract VehicleManagement{
    //Vehical Details for Home Page;
    struct Vehical{
        string Name;
        uint Id;
        string Model;
        string Type;
        string Price;
        string Location;
        string LandMark;
        address Owner;
        string PhoneNum;
        string status;
        string url;
    }
    Vehical[] Vehicals;
    
    string[] locations;
    //User Details
    struct User{
        string Fname;
        string Lname;
        uint phoneNumber;
        string Gmail;
        string Dno;
        string city;
        string Country;
        string password;
    }
    mapping(address => User) Users;

    //Who ordered vehicals for rent ---for Posters
    struct WhoOrdered{
        address reciepient;
        uint timestamp;
        uint VehicalId;
        string url;
        string Location;
        string Landmark;
        string price;
    }
    mapping(address =>WhoOrdered[]) Data;

    //Ordered vehicals data for Users
    
    struct OrderedVehical{
        address Owner;
        uint vehicalId;
        uint timestamp;
        string url;
        string Location;
        string Landmark;
        string price;
    }
    mapping(address => OrderedVehical[]) Data1;


    //Poster SignUp
    function SignUp(string memory _Fname,string memory _Lname,uint _PhoneNum,string memory _gmail,string memory _Dno,string memory _city,string memory _country,string memory _pw)public{
        require(checkAlreadySignup(msg.sender)==false,"Already Reg");
        Users[msg.sender]=User({Fname:_Fname,Lname:_Lname,phoneNumber:_PhoneNum,Gmail:_gmail,Dno :_Dno,city:_city,Country :_country,password:_pw});
    }
    
    function checkAlreadySignup(address pubkey)public view returns(bool){
        return Users[pubkey].phoneNumber!=0;
    }

    //Posting Vehical Details by 
    function PostVehicle(string memory Name,uint id,string memory Model,string memory Type,string memory Price,string memory Location,string memory LandMark,string memory phoneNumber,string memory url) public{
        require(checkId(id)==false,"Id alreay Exist");
        locations.push(Location);
        Vehicals.push(Vehical(Name,id,Model,Type,Price,Location,LandMark,msg.sender,phoneNumber,"Available",url));
    }
    function checkId(uint id) public view returns(bool){
        for(uint i=0;i<Vehicals.length ;i++){
            if(Vehicals[i].Id == id){
                return true;
            }
        }
        return false;
    }
    //Setting status of the Vehical
    function setStatusOfVehicale(address pubkey,uint id,string memory status) public{
        for(uint i=0;i<Vehicals.length;i++){
            if(pubkey == Vehicals[i].Owner && id==Vehicals[i].Id){
                Vehicals[i].status =status;
                return ;
            }
        }
    }

    //Booking vehical for Rent
    function BookVehical(address payable Veh_Holder,uint Id) public payable{
        Veh_Holder.transfer(msg.value);
        for(uint i=0;i<Vehicals.length;i++){
            if(Id == Vehicals[i].Id){
                Data[Veh_Holder].push(WhoOrdered(msg.sender,block.timestamp,Id,Vehicals[i].url,Vehicals[i].Location,Vehicals[i].LandMark,Vehicals[i].Price));
                Data1[msg.sender].push(OrderedVehical(Veh_Holder,Id,block.timestamp,Vehicals[i].url,Vehicals[i].Location,Vehicals[i].LandMark,Vehicals[i].Price));
            }
        }
    }
    //Getting Data
    //vehicle
    function getVehicleData()public view returns(Vehical[] memory){
        return Vehicals;
    }

    //UserData
    function getUserInfo(address pubkey) public view returns(User memory){
        return Users[pubkey];
    }
    //Poster Vehicle Data
    function getPosterVehicleData(address pubkey) public view returns(WhoOrdered[] memory){
        return Data[pubkey];
    }

    //User Vehicle Data
    function getUserVehicleData(address pubkey) public view returns(OrderedVehical[] memory){
        return Data1[pubkey];
    }

    function getLocation() public view returns(string[] memory){
        return locations;
    }

}