pragma solidity ^0.5.0;

contract Users {
    
    //data structure that stores the user 
    struct User {
        string name;
        bytes32 status;
        address walletAddress;
        uint createdAt;
        uint updatedAt;
    }    
    mapping(address => uint) public userIds;
    
    User[] public users;    //list of all the users 
    
    //Event to trigger when a new user registers
    event newUserRegistered(uint id);
    
    //Event to trigger when the user updates his status or name 
    event userUpdateEvent(uint id);
    
    //Check if the caller of the smart contract is already registered 
    modifier checkSenderIsRegistered {
        require(isRegistered());
        _;
    }

    
    /**
    Constructor function to make a new user
    ***/
    constructor() public {
        //Genesis user 
        addUser(0x0,"","");
        addUser(0x333333333333,"Prateek Madaan","Available");
        addUser(0x222222222222,"Karunya Mehta","Very Happy");
        addUser(0x111111111111,"Blockchain","Not in the mood to learn");
    }

    /**
     * Utility method to register a new user 
     * @param userName  The displaying name 
     * @param status    The status of the user
     */
    
  function registerUser(string memory userName, bytes32 status) public returns(uint)
    {
    	return addUser(msg.sender, userName, status);
    }
     /**
     * Utility method to add a new user (private) 
     * @param walletAddress Address wallet of the user
     * @param userName  The displaying name 
     * @param status    The status of the user
     */
     
     function addUser(address walletAddress,string memory userName,bytes32 status) private returns(uint) {
        //Check whether the user already exists 
         uint userId = userIds[walletAddress];
         require(userId == 0);
         userIds[walletAddress] = users.length;
         uint newUserId = users.length;
         //Storing the new user details 
         users[newUserId] = User({
             name: userName,
             status : status,
             walletAddress : walletAddress,
             createdAt : now,
             updatedAt : now 
         });
         //Emit the event that the new user is registered 
         emit newUserRegistered(newUserId);
         return newUserId;
     }
     
     /**
     * Utility method to update the user profile of the caller of the method 
     * @param newUserName  The displaying name 
     * @param newStatus    The status of the user
     */
    function updateUser(string memory newUserName,bytes32 userStatus) checkSenderIsRegistered public returns(uint) {
        uint userId = userIds[msg.sender];        
        User storage user = users[userId];
        user.name = newUserName;
        user.status = userStatus;
        //Set the updatedAt 
        user.updatedAt = now;
        //Emit the user update event 
        emit userUpdateEvent(userId);
        return userId;
    }
    
    /**
     * Get the user's profile information.
     *
     * @param id 	The ID of the user stored on the blockchain.
     */
    function getUserById(uint id) public view returns(uint,string memory,bytes32,address,uint,uint){
        //Check whether the id is valid in range or not 
        require(id >=0 || id <= users.length);
        User memory i = users[id];
        return (id, i.name,i.status,i.walletAddress,i.createdAt,i.updatedAt);
    }
    
    /**
     * Return the profile information of the caller.
     */
    
    function getOwnProfile() checkSenderIsRegistered public view returns(uint,string memory,bytes32,address,uint,uint) {
        uint userId = userIds[msg.sender];
        return getUserById(userId);
    }
    
    /**
     * Check whether the caller of the smart contract is registered or not.
     */
     
    function isRegistered() public view returns(bool){
        return (userIds[msg.sender] != 0);
    }
     /**
     * return total number of registered users on the blockchain.
     */
     function totalUsers() public view returns(uint){
         return users.length;
     }
}