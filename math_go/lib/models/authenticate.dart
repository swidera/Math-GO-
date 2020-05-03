bool authenticateUser(String user, String password){

  //autheticate user using service back to database

  if(user=="user1" && password=="abc123"){
    return true;
  }
  else{
    return false;
  }

}