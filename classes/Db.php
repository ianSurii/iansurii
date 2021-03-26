<?php
session_start();
define('servername','us-cdbr-east-03.cleardb.com');
define('username','bd66e08fe4dc3f');
define('password','b0b1e506');
define('dbname','heroku_fdc1a947f428aba');
//483f9647@us-cdbr-east-03.cleardb.com heroku_fa93cedb859fa1b
class db{
    function __construct(){
		$this->connection = new mysqli(servername, username,password,dbname);
		
		if ($this->connection->connect_error) die('Database error -> ' . $this->connection->connect_error);
		
	}
	
	function ret_obj(){
		return $this->connection;
	}


}
?>
