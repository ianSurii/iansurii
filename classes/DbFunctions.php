<?php

include('classes/Db.php');

class dbFunction extends db{
protected $db;
public function __construct(){
		$this->db = new db();
		$this->db =$this->db->ret_obj();
	
        }
        
function insert($table,$column,$value){
    $query="INSERT INTO ".$table." (".$column.") VALUES(".$value.");";
    $result=$this->db->query($query) or die($this->db->error);
    if($result){
        return true;
    }
    else{
        return false;
        
    }
}
function update($table,$setColumnValue,$condition){
    $query="UPDATE ".$table." ".$setColumnValue."WHERE".$condition.";";
    $result=$this->db->query($query) or die($this->db->error);
  //updateformat SET ContactName = 'Alfred Schmidt', City= 'Frankfurt'
    //WHERE CustomerID = 1;
    if($result){
        return true;
    }
    else{
        return false;

    }
}

function select($table,$conditon){
    $data=array();
    $query="SELECT * FROM ".$table." ".$conditon.";";
    $result=$this->db->query($query)  or die($this->db->error);
    while ($row =mysqli_fetch_assoc($result)) {
        $data[] = $row;
    
    }
    return $data;
    
    }
    function selectAll($table){
        $data=array();
        $query="SELECT * FROM ".$table.";";
        $result=$this->db->query($query)  or die($this->db->error);
        while ($row =mysqli_fetch_assoc($result)) {
            $data[] = $row;
        
        }
        return $data;
        
        }
function conditionSelect($condition ,$table){
$data=array();
//otherformart: SELECT Count(*) AS DistinctCountries FROM (SELECT DISTINCT Country FROM Customers);
$query="SELECT ".$condition." FROM ".$table.";";
$result=$this->db->query($query)  or die($this->db->error);
while ($row =mysqli_fetch_assoc($result)) {
	$data[] = $row;

}
return $data;

}
function delete($table ,$condition){
    $data=array();
    //otherformart: SELECT Count(*) AS DistinctCountries FROM (SELECT DISTINCT Country FROM Customers);
    $query="DELETE FROM ".$table."".$condition.";";
    $result=$this->db->query($query)  or die($this->db->error);
   if($result){
       return true;
   }
   
    
    }


		
 }
?>